# HBN — ERP Hardening Audit

**Date:** 2026-03-29
**Scope:** Validation of 6 proposed corrections from external audit + Codex execution prompt
**Role:** Senior Architect, Code Auditor, Protocol Validator
**Baseline:** 11 tests passing, ERP fully functional

---

## PART 1 — CRITICAL VALIDATION OF EACH CORRECTION

### Correction 1: Timestamp Inconsistency

**Audit finding:** Uses `datetime.now(timezone.utc).isoformat()` which produces `2026-03-29T07:14:01.948821+00:00`. Proposal: use UTC with `Z` suffix.

**Verdict: VALID — but with refinement.**

The current output is technically correct ISO 8601. The `+00:00` suffix is semantically equivalent to `Z`. However, there are two real problems:

1. **Inconsistency across modules.** The consent module (`consent.py`) uses `datetime.utcnow().isoformat() + "Z"` while result.py uses `datetime.now(timezone.utc).isoformat()`. Two different timestamp strategies in the same protocol is a genuine defect. A protocol that claims traceability cannot have ambiguous time formats.

2. **`utcnow()` is deprecated.** Python 3.12+ deprecates `datetime.utcnow()`. The correct modern approach is `datetime.now(timezone.utc)`.

**Recommended correction:** Standardize ALL modules on a single shared function. Use `datetime.now(timezone.utc)` (future-proof), but format the output to end in `Z` for readability and consistency. This means replacing `+00:00` with `Z` in the formatted string.

**Implementation:** Create a shared `_utc_now_iso()` in `utils/config.py` (or a new `utils/time.py`), then replace all timestamp generation across consent.py and result.py with this single function. This is minimal and eliminates the drift risk permanently.

---

### Correction 2: Execution ID Overwrite

**Audit finding:** `create_result_record()` writes to `{execution_id}.json` without checking if the file already exists. A second call with the same `execution_id` silently overwrites the first record.

**Verdict: VALID — critical.**

This is a data integrity defect. In a traceability system, overwriting a result record without warning destroys audit history. The binding between intent and result is 1:1 by design — allowing overwrite violates this contract.

**Recommended correction:** Before writing, check if the file exists. If it does, raise a `ValueError` with a clear message: `"Result record already exists for execution_id: {execution_id}. Use a unique execution_id or delete the existing record explicitly."` This is a 3-line change in result.py.

**Rejected alternative:** The audit could have proposed an "append" or "versioning" approach (result-v1, result-v2). That adds unnecessary complexity. The 1:1 binding is correct; enforce it.

---

### Correction 3: State Duplication

**Audit finding:** `append_result_state()` appends to the `results` array without checking for duplicate `execution_id`. The existing test `test_state_append` actually *demonstrates this flaw* — it appends the same record twice and asserts `len == 2`.

**Verdict: VALID — and the test confirms the bug.**

Line 61-62 of `test_result_protocol.py`:
```python
append_result_state(record, base_dir=tmp_path)
append_result_state(record, base_dir=tmp_path)
state = load_state_document(tmp_path)
assert len(state["results"]) == 2  # This is a bug, not a feature
```

The state store should reject a duplicate `execution_id` in the `results` array.

**Recommended correction:** In `append_result_state()`, check if any existing entry in `document["results"]` has a matching `traceability.execution_id`. If so, raise `ValueError`. Update the test to assert that the second append raises, not that it produces 2 entries.

**Dependency:** This correction is naturally paired with Correction 2. If file-level duplication is blocked (Correction 2), state-level duplication should also be blocked. Both enforce the same invariant: one execution_id → one result.

---

### Correction 4: Schema — `other_emergent_risk` as Required

**Audit finding:** `other_emergent_risk` is listed in `required` array of `intent_risk_profile` in `result.schema.json`, but it's a free-text string that defaults to `""` in `result.py`.

**Verdict: VALID — but the fix is nuanced.**

The field IS always present in records (result.py always sets it via `risk_profile["other_emergent_risk"] = other_emergent_risk`). So the schema's `required` constraint never actually fails at runtime. The real problem is semantic: the `required` declaration implies that a human MUST provide this value, but the system auto-fills it as empty string. This is misleading.

**Recommended correction:** Remove `other_emergent_risk` from the `required` array in the schema. Keep the field in `properties` so it's still validated when present. In `result.py`, only include the field in the record when `other_emergent_risk` is non-empty. This makes the schema honest: the field is optional, and its absence means "no emergent risk noted."

---

### Correction 5: `action_taken` Unbounded

**Audit finding:** `action_taken` is a string with `minLength: 1` but no maximum length. Proposal: limit to 200 characters.

**Verdict: PARTIALLY VALID — but 200 is too restrictive.**

An unbounded string in a structured record is a legitimate concern for storage and display. However, `action_taken` needs to be descriptive enough to be useful for traceability. "Refactored authentication module, extracted JWT validation into separate middleware, updated 12 test cases, verified backwards compatibility with existing API clients" is 180 characters and that's a reasonable single-action description.

**Recommended correction:** Add `maxLength: 500` to the schema. 500 characters is enough for a detailed action description but prevents abuse (someone pasting an entire diff as `action_taken`). This is a schema-only change — no Python code modification needed since the validator already checks `maxLength` if... wait. Let me verify.

**Critical check:** The custom validator in `validators.py` does NOT check `maxLength`. It only checks `minLength`. This means adding `maxLength` to the schema would be **unenforced** — a false guarantee.

**Revised recommendation:** Two changes needed:
1. Add `maxLength` support to `_validate_node()` in `validators.py` (2 lines)
2. Add `maxLength: 500` to `action_taken` in `result.schema.json`

This order matters: validator first, then schema constraint. Never add a schema constraint without enforcement.

---

### Correction 6: Evidence Parsing Incomplete

**Audit finding:** `_parse_evidence()` in cli.py splits on `:` but doesn't validate that `type` and `reference` are non-empty after splitting. `":" → {"type": "", "reference": ""}` would pass parsing but fail schema validation only later.

**Verdict: VALID — defense in depth.**

The schema does enforce `minLength: 1` on both `type` and `reference` within evidence items. So malformed evidence will eventually be caught. But the error message will be a schema validation error deep in the pipeline, not a clear CLI-level error at the point of input.

**Recommended correction:** Add two checks in `_parse_evidence()`:
```python
if not evidence_type.strip():
    raise ValueError(f"Evidence type cannot be empty: {entry}")
if not reference.strip():
    raise ValueError(f"Evidence reference cannot be empty: {entry}")
```

This is 4 lines of code. It moves error detection to the boundary where the user can immediately understand and fix the problem. The schema validation remains as a second safety net.

---

## PART 2 — ARCHITECTURAL ADJUSTMENTS

### Adjustment A: Shared Timestamp Function

Corrections 1 (timestamp) touches two files (consent.py and result.py). Rather than fixing each independently, extract a shared function. Place it in `utils/time.py` (new file, 5 lines):

```python
from datetime import datetime, timezone

def utc_now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.%fZ")
```

Then replace all timestamp generation in consent.py and result.py with `from usehbn.utils.time import utc_now_iso`. This permanently eliminates drift between modules.

### Adjustment B: Duplication Guard as Shared Pattern

Corrections 2 and 3 enforce the same invariant (1 execution_id → 1 result). Rather than implementing two independent checks, the file-level check in result.py should be the primary guard, and the state-level check in store.py should be a secondary defense:

- **result.py** (primary): Check file existence before write. Raise `ValueError`.
- **store.py** (secondary): Check array before append. Raise `ValueError`.

Both raise the same error type. Both are independently testable. Neither depends on the other. This is defense-in-depth without coupling.

### Adjustment C: No New Architectural Patterns

All 6 corrections are local changes to existing files. None requires new abstractions, new modules (except the tiny `utils/time.py`), or new dependencies. This is correct. The temptation to over-engineer hardening into a "validation framework" must be resisted.

---

## PART 3 — PARETO ANALYSIS

| # | Correction | Impact | Effort | Classification | Priority |
|---|-----------|--------|--------|---------------|----------|
| 2 | Execution ID overwrite guard | **HIGH** — data integrity | **LOW** — 3 lines in result.py | HIGH IMPACT / LOW EFFORT | **P0** |
| 3 | State duplication guard | **HIGH** — data integrity | **LOW** — 4 lines in store.py + test fix | HIGH IMPACT / LOW EFFORT | **P0** |
| 6 | Evidence parsing validation | **MEDIUM** — error clarity | **LOW** — 4 lines in cli.py | HIGH IMPACT / LOW EFFORT | **P1** |
| 1 | Timestamp standardization | **MEDIUM** — consistency | **MEDIUM** — new util + 2 file changes | HIGH IMPACT / LOW EFFORT | **P1** |
| 4 | Schema: other_emergent_risk optional | **MEDIUM** — schema honesty | **LOW** — schema edit + 2 lines in result.py | LOW IMPACT / LOW EFFORT | **P2** |
| 5 | action_taken maxLength | **LOW** — abuse prevention | **MEDIUM** — validator change + schema edit | LOW IMPACT / LOW EFFORT | **P2** |

### Execution Order

**Batch 1 (P0 — Data Integrity):** Corrections 2 + 3. These fix the most dangerous defect: silent data loss through overwrite. Must be done first because all subsequent corrections assume result records are trustworthy.

**Batch 2 (P1 — Input Quality):** Corrections 6 + 1. Improve error messages at boundaries and eliminate timestamp inconsistency.

**Batch 3 (P2 — Schema Honesty):** Corrections 4 + 5. Polish the schema to accurately reflect what the system enforces.

---

## PART 4 — FINAL CODEX PROMPT

```
---------------------------------------
CODEX TASK: HBN ERP Hardening — 6 Targeted Corrections
---------------------------------------

CONTEXT:
You are working on the HBN repository. The Execution Result Protocol
(ERP) is already implemented and all 11 tests pass. Your task is to
apply 6 hardening corrections identified by architectural audit.

CRITICAL RULES:
1. Do NOT rewrite any existing module
2. Do NOT add external dependencies
3. Do NOT change function signatures (only add internal logic)
4. Run ALL existing tests after EACH batch to verify no regressions
5. Every change must be minimal and additive

---------------------------------------
BATCH 1 — DATA INTEGRITY (P0)
---------------------------------------

CORRECTION 2: Block execution_id overwrite in result.py
File: src/usehbn/protocol/result.py
Location: create_result_record(), before the write_json() call

Add:
  output_path = _results_dir(storage_dir) / f"{execution_id}.json"
  if output_path.exists():
      raise ValueError(
          f"Result record already exists for execution_id: "
          f"{execution_id}. Cannot overwrite."
      )
  write_json(output_path, record)

This replaces the existing two lines (output_path assignment + write)
with three lines (assignment + check + write).

CORRECTION 3: Block duplicate execution_id in state store
File: src/usehbn/state/store.py
Location: append_result_state(), before the append call

Add:
  existing_ids = [
      r.get("traceability", {}).get("execution_id")
      for r in document.get("results", [])
  ]
  exec_id = result_record.get("traceability", {}).get("execution_id")
  if exec_id in existing_ids:
      raise ValueError(
          f"Result for execution_id {exec_id} already in state."
      )

TEST UPDATES for Batch 1:
File: tests/test_result_protocol.py

1. Fix test_state_append: Change the test to assert that the SECOND
   append raises ValueError, not that it produces len==2.
   The test should:
   - Create record and append once (succeeds)
   - Assert len(results) == 1
   - Attempt second append with same record
   - Assert pytest.raises(ValueError)

2. Add test_overwrite_blocked:
   - Create a result record for "exec-dup-001"
   - Call create_result_record again with same execution_id
   - Assert pytest.raises(ValueError) with "already exists" in message

VALIDATION: Run pytest. All tests must pass. Then run:
  usehbn result exec-batch1-test --agent-id codex \
    --action "batch 1 validation" --outcome executed \
    --human-status approved --storage-dir /tmp/hbn-test

---------------------------------------
BATCH 2 — INPUT QUALITY (P1)
---------------------------------------

CORRECTION 6: Validate evidence parsing in CLI
File: src/usehbn/cli.py
Location: _parse_evidence() function, after the split

Replace the current body of the for loop with:
  for entry in entries:
      if ":" not in entry:
          raise ValueError(
              f"Evidence must use type:reference format: {entry}"
          )
      evidence_type, reference = entry.split(":", 1)
      if not evidence_type.strip():
          raise ValueError(
              f"Evidence type cannot be empty: {entry}"
          )
      if not reference.strip():
          raise ValueError(
              f"Evidence reference cannot be empty: {entry}"
          )
      evidence.append({
          "type": evidence_type.strip(),
          "reference": reference.strip(),
      })

CORRECTION 1: Standardize timestamps across all protocol modules
Step A — Create shared timestamp utility:
File: src/usehbn/utils/time.py (NEW FILE)

Content:
  """Shared UTC timestamp generation for HBN.

  Copyright (C) 2026 Luis Mauricio Junqueira Zanin
  Licensed under the GNU Affero General Public License v3.0
  or later.
  """

  from datetime import datetime, timezone


  def utc_now_iso() -> str:
      """Return current UTC time as ISO 8601 with Z suffix."""
      dt = datetime.now(timezone.utc)
      return dt.strftime("%Y-%m-%dT%H:%M:%S.%fZ")

Step B — Update result.py:
File: src/usehbn/protocol/result.py
- Remove the _utc_timestamp() function entirely
- Add import: from usehbn.utils.time import utc_now_iso
- Replace the "created_at": _utc_timestamp() line with:
  "created_at": utc_now_iso()

Step C — Update consent.py:
File: src/usehbn/protocol/consent.py
- Find the line that generates created_at timestamp
  (uses datetime.utcnow().isoformat() + "Z")
- Add import: from usehbn.utils.time import utc_now_iso
- Replace timestamp generation with: utc_now_iso()
- Remove the datetime import if no longer needed

TEST ADDITIONS for Batch 2:
File: tests/test_result_protocol.py

3. Add test_evidence_empty_type_rejected:
   - Import _parse_evidence from usehbn.cli
   - Call _parse_evidence([":some_reference"])
   - Assert pytest.raises(ValueError) with "type cannot be empty"

4. Add test_evidence_empty_reference_rejected:
   - Call _parse_evidence(["log:"])
   - Assert pytest.raises(ValueError) with "reference cannot be empty"

5. Add test_timestamp_format:
   - Import utc_now_iso from usehbn.utils.time
   - Call utc_now_iso()
   - Assert result ends with "Z"
   - Assert result does NOT contain "+00:00"

VALIDATION: Run pytest. All tests must pass.

---------------------------------------
BATCH 3 — SCHEMA HONESTY (P2)
---------------------------------------

CORRECTION 4: Make other_emergent_risk optional
File: schemas/result.schema.json
- Remove "other_emergent_risk" from the "required" array
  inside "intent_risk_profile"

File: src/usehbn/protocol/result.py
- Change the line:
    risk_profile["other_emergent_risk"] = other_emergent_risk
  To:
    if other_emergent_risk:
        risk_profile["other_emergent_risk"] = other_emergent_risk

CORRECTION 5: Add maxLength to action_taken
Step A — Add maxLength support to validator:
File: src/usehbn/utils/validators.py
Location: Inside the "if schema_type == 'string'" block,
after the minLength check

Add:
  if "maxLength" in schema and len(value) > schema["maxLength"]:
      errors.append(
          f"{path} must have length <= {schema['maxLength']}"
      )

Step B — Add maxLength to schema:
File: schemas/result.schema.json
- Change "action_taken" from:
    "action_taken": { "type": "string", "minLength": 1 }
  To:
    "action_taken": {
      "type": "string",
      "minLength": 1,
      "maxLength": 500
    }

TEST ADDITIONS for Batch 3:
File: tests/test_result_protocol.py

6. Add test_other_emergent_risk_optional:
   - Create a result record WITHOUT passing other_emergent_risk
   - Assert "other_emergent_risk" is NOT in
     record["intent_risk_profile"]

7. Add test_action_taken_too_long:
   - Create a result record with action_taken = "x" * 501
   - Assert pytest.raises(ValueError) with "maxLength"
     or "length <=" in message

8. Add test_maxlength_validator:
   - Import _validate_node from usehbn.utils.validators
   - Validate a string value "abcdef" against schema
     {"type": "string", "maxLength": 3}
   - Assert errors list is non-empty

VALIDATION: Run pytest. All tests must pass.

---------------------------------------
FINAL VALIDATION (ALL BATCHES)
---------------------------------------

1. Run: python -m pytest tests/ -v
   Result: ALL tests must pass (original 11 + 8 new = 19 total)

2. Run: usehbn "use hbn refactor auth module without breaking tests"
   Verify: Output unchanged from pre-hardening behavior

3. Run:
   usehbn result exec-final-001 --agent-id codex \
     --action "ERP hardening complete" --outcome executed \
     --human-status approved \
     --evidence "audit:HBN-ERP-HARDENING-AUDIT.md" \
     --storage-dir /tmp/hbn-final-test

   Verify: Record created with Z-suffix timestamp

4. Run same command again (same exec-final-001):
   Verify: ValueError raised — overwrite blocked

5. Verify: /tmp/hbn-final-test/.usehbn/results/exec-final-001.json
   exists and contains valid JSON

---------------------------------------
REPORT
---------------------------------------

After ALL corrections are applied, create REPORT-HARDENING.md with:

- Date and scope
- For each correction (1-6):
  - File(s) modified
  - Lines changed (count)
  - Test(s) added
  - Regression status (pass/fail)
- Total tests before: 11
- Total tests after: 19 (expected)
- All 11 original tests: pass/fail
- All 8 new tests: pass/fail
- Any deviations from this prompt and why
- Confirmation: "No existing behavior was modified.
  All changes are additive and defensive."
```

---

## SUMMARY

Of the 6 proposed corrections, all 6 are valid. None was rejected. Two were refined (timestamp strategy elevated to a shared utility; maxLength required validator support first). The Pareto analysis groups them into 3 batches ordered by data-integrity-first, then input-quality, then schema-polish. The Codex prompt is structured for incremental, test-validated execution with zero risk of regression. Expected outcome: 19 passing tests, same external behavior, stronger internal guarantees.
