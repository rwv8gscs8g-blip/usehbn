# HBN — Architectural Evolution Analysis

**Date:** 2026-03-29
**Scope:** Deep architectural review + next evolution proposal
**Analyst:** Claude Opus 4.6 (under protocol mindset)

---

## STEP 1 — ARCHITECTURAL ANALYSIS

### 1.1 Structural Architecture

HBN is organized as a **protocol-first monorepo** with seven top-level concerns:

| Directory | Role | Content Type |
|-----------|------|--------------|
| `core/` | Protocol definition | Markdown specs (3 files) |
| `agents/` | Agent operating contracts | Markdown behavioral rules (4 files) |
| `docs/` | Extended documentation | Markdown (12 files) |
| `schemas/` | Data contracts | JSON Schema Draft 2020-12 (3 files) |
| `src/usehbn/` | Reference implementation | Python (12 modules) |
| `tests/` | Behavioral verification | pytest (4 files) |
| `site/` | Public landing page | Static HTML/CSS |

The Python implementation is organized into four internal packages:

- `protocol/` — The four protocol primitives (intent, consent, truth_barrier, guardian)
- `execution/` — Pipeline orchestrator (engine.py)
- `state/` — JSON-backed persistence (store.py)
- `utils/` — Config, logging, custom schema validator

**Observation:** The structure is clean and well-separated. Protocol definition (core/) is independent from implementation (src/). This is a genuine strength — the protocol can survive a complete rewrite of the runtime. However, the `protocol/` package mirrors `core/` without a formal binding mechanism. There is no programmatic contract that ensures the Python code implements the spec as written. This is a latent drift risk.

### 1.2 Separation of Concerns

The system achieves good separation across five layers:

1. **Activation** (trigger.py) — Pure regex detection, no side effects
2. **Structuring** (intent.py) — Pattern-based NLP extraction, produces validated JSON
3. **Analysis** (truth_barrier.py) — Heuristic quality checks on claims, advisory only
4. **Monitoring** (guardian.py) — Warning aggregation + local logging, no enforcement
5. **Consent** (consent.py) — Explicit question + local record, never transmitted

**Critical observation:** Layers 3 and 4 (truth barrier and guardian) are structurally coupled. Guardian imports and wraps truth barrier results. Yet they serve different purposes — truth_barrier assesses *claim quality*, while guardian assesses *validation completeness*. The current coupling means guardian cannot be extended independently without entangling truth barrier logic. This is the primary architectural debt in the current design.

### 1.3 Execution Flow (usehbn command)

The CLI pipeline in `engine.py` follows a strict linear flow:

```
Input sentence
  → detect_activation(sentence)          # trigger.py
  → structure_intent(sentence)           # intent.py
  → evaluate_truth_barrier(intent)       # truth_barrier.py
  → assess_guardian(intent, tb_result)   # guardian.py
  → create_consent_record(...)           # consent.py (if --request-consent)
  → write logs + state                   # store.py, logger.py
  → return structured JSON
```

**Strengths:**
- Fully synchronous, deterministic pipeline
- Each step produces inspectable intermediate output
- No hidden state mutations — all writes are explicit
- Execution IDs enable full traceability

**Weaknesses:**
- The pipeline is hardcoded in engine.py — there is no way to add, remove, or reorder steps without modifying the orchestrator directly
- No concept of pipeline failure modes — if truth_barrier raises an exception, the entire execution aborts with no partial state
- No execution timeout or resource bounds
- The engine returns a monolithic dictionary; consumers cannot request partial results

### 1.4 Safety Model

The safety model operates at three levels:

**Level 1 — Claim-quality heuristics (truth_barrier.py):**
Flags overconfidence patterns ("always", "guaranteed", "100%"), unsupported claims ("zero risk", "fully secure"), and missing uncertainty markers in risky contexts. This is pure string matching — effective for obvious cases but trivially circumventable by rewording.

**Level 2 — Validation-completeness monitoring (guardian.py):**
Detects intents with risks but no validation_requirements. Forwards truth barrier warnings. Logs everything to local JSONL. Explicitly not enforcement — warnings can be ignored.

**Level 3 — Agent behavioral contracts (agents/*.md):**
Natural-language rules for Claude and Codex that prescribe: interpret → structure → validate → execute → document. Safety checks framed as required questions, not code-level enforcement.

**Critical assessment:** The safety model is **advisory-only by design**. There is no enforcement point — no step in the pipeline can block execution. This is philosophically consistent with "human is root of trust" but means the system cannot prevent a compliant-looking but dangerous intent from passing through. The guardian emits warnings but the CLI still returns a successful result with all data intact. There is no concept of a "blocked" or "escalated" execution state.

### 1.5 Extensibility

**Current extensibility points:**
- New risk keywords can be added to `RISK_INDICATORS` in intent.py
- New overconfidence patterns can be added to truth_barrier.py lists
- New agent contracts can be added as markdown files in agents/
- Schemas can be extended (JSON Schema is forward-compatible)

**Missing extensibility:**
- No plugin or middleware architecture — every extension requires modifying core files
- No hook system for pre/post pipeline stages
- No way to register custom validators without editing validators.py
- No protocol versioning in the runtime — the schema files have no version field, and the Python code doesn't check protocol version
- The VBA bridge (bridge/vba.py) is a dead-end concept — returns a static dictionary describing what *should* be done, with no actual bridge logic

### 1.6 Weaknesses and Risks

**W1 — Intent extraction is brittle.** The regex-based constraint/risk extraction in intent.py works only for English sentences that use specific keywords ("without", "must", "only"). Even slight rephrasing defeats it. "Make sure it doesn't break tests" does not trigger the "without" constraint pattern. "Ensure backwards compatibility" extracts nothing. This is the single most fragile component.

**W2 — No execution result feedback.** The pipeline ends at structured intent + advisory warnings. There is no mechanism to capture what actually happened after the human acts on the intent. The protocol describes a full cycle (intent → execution → documentation) but the implementation only covers intent → advisory.

**W3 — State accumulates without bounds.** `hbn-state.json` appends every execution's full output to arrays that grow without limits. After thousands of executions, loading state becomes a blocking I/O operation. There is no rotation, archival, or cleanup strategy.

**W4 — Tests are minimal.** Four test files with 9 total test cases. No edge case coverage for intent extraction. No tests for the execution engine's error paths. No tests for state overflow. No tests for malformed input. No integration tests that exercise the CLI end-to-end.

**W5 — Custom validator is incomplete.** The hand-rolled JSON Schema validator in validators.py supports only 6 types and 5 constraints. It silently ignores any schema feature it doesn't recognize (additionalProperties, patternProperties, oneOf, anyOf, etc.). This means schemas could specify constraints that are never enforced.

**W6 — No protocol version negotiation.** The HBN-LANGUAGE-v0.1.md defines a versioned language surface, but the runtime never checks which version it's operating under. A future v0.2 schema change could silently break validation without any error.

### 1.7 Missing Components for a Real System

1. **Execution feedback loop** — Capture what happened after intent was structured (did the human approve? what was the outcome? was the risk realized?)
2. **Pipeline configurability** — Register/deregister stages without editing engine.py
3. **Error handling strategy** — Partial failure modes, retry semantics, fallback behavior
4. **Protocol version binding** — Runtime checks that schemas, code, and specs are aligned
5. **Observability** — Metrics, structured logging with correlation IDs, execution duration tracking
6. **Multi-agent coordination** — Currently, agent contracts are independent markdown files with no shared state or communication protocol
7. **External integration interface** — No API, no event system, no webhook mechanism for CI/CD or editor integration

---

## STEP 2 — SYSTEM MATURITY ASSESSMENT

### Classification: **Structured Prototype**

HBN sits precisely between "Prototype" and "Structured System." Here is the evidence:

**Beyond prototype because:**
- Formal separation between protocol definition and implementation
- JSON Schema-based data contracts
- Explicit governance and contribution model
- Installable CLI with entry point
- Automated tests (minimal but present)
- Local state persistence with traceability

**Not yet a structured system because:**
- No pipeline configurability (hardcoded execution flow)
- No error handling beyond Python exceptions
- No protocol version enforcement at runtime
- Tests cover happy paths only (9 test cases)
- No execution feedback loop (pipeline terminates at advisory output)
- State management has no bounds or rotation
- Custom validator is incomplete relative to the schemas it validates

**Assessment:** HBN has the *shape* of a structured system but the *depth* of a prototype. The architecture is well-designed at the directory and conceptual level, but the runtime implementation is thin. The ratio of documentation to executable logic is approximately 4:1, which is appropriate for a protocol-first project at this stage, but means the system's behavior is mostly *described* rather than *enforced*.

---

## STEP 3 — GAP IDENTIFICATION

### What prevents HBN from becoming a real runtime system

**Gap 1: No execution result capture.** The protocol describes a full lifecycle (intent → execution → documentation), but the implementation ends at "structured intent + warnings." Without a mechanism to record what *actually happened* — whether the human approved, what the agent did, what the outcome was — HBN cannot close the feedback loop. This is the primary gap between a structuring tool and a runtime system.

**Gap 2: No pipeline stage registry.** The engine hardcodes five stages in a fixed order. A real runtime needs configurable pipelines where stages can be registered, ordered, and conditionally skipped. Without this, every new protocol feature requires editing the orchestrator.

**Gap 3: No error boundary model.** If truth_barrier.py throws an exception, the entire execution crashes with a traceback. A runtime system needs defined failure modes: what happens when a stage fails? Is the result partial? Is it retried? Is the execution marked as failed-but-logged?

### What prevents HBN from scaling

**Gap 4: Unbounded state accumulation.** `hbn-state.json` is a single JSON file that grows monotonically. At scale, this becomes a bottleneck for both I/O and memory.

**Gap 5: No concurrent execution model.** The CLI is single-threaded and synchronous. Two simultaneous `usehbn` invocations will race on state file writes, potentially corrupting `hbn-state.json`.

**Gap 6: No external integration surface.** There is no API, no event bus, no webhook. Integration with CI/CD, editors, or other tools requires wrapping the CLI in shell scripts.

### What prevents multi-agent orchestration

**Gap 7: No shared execution context.** Agent contracts (agents/*.md) are independent documents with no shared state model. Two agents working on the same codebase have no way to coordinate: no shared intent registry, no execution lock, no result handoff.

**Gap 8: No agent identity in the runtime.** The execution engine doesn't know *which agent* is executing. There is no agent_id field in the execution record, no per-agent configuration, no agent-specific validation rules.

**Gap 9: No delegation protocol.** There is no mechanism for one agent to delegate a sub-intent to another agent, or for a human to split intent across multiple agents with coordinated validation.

---

## STEP 4 — PROPOSED NEXT EVOLUTION

### The single next step: **Execution Result Protocol (ERP)**

**What:** Add a formal mechanism to capture execution outcomes after the intent structuring phase, closing the feedback loop between intent → action → result.

**Why this step and not others:**
- Pipeline configurability is a refactoring task that doesn't increase protocol maturity
- Multi-agent orchestration requires ERP as a prerequisite (agents need to see each other's results)
- Error handling is a subset of ERP (a failed execution is a specific result type)
- State rotation is an operational concern, not a protocol evolution

ERP is the highest-leverage single step because it converts HBN from a **structuring tool** (takes intent, produces advisory output) into a **traceability system** (tracks intent through execution to outcome).

**What it includes:**

1. **A new schema: `schemas/result.schema.json`** — Defines the structure of an execution result: execution_id (binding to the intent), agent_id, action_taken, outcome (success/failure/partial/blocked), evidence (array of artifacts), human_reviewed (boolean), timestamp.

2. **A new protocol module: `src/usehbn/protocol/result.py`** — Functions to create, validate, and store execution result records. Stores results in `.usehbn/results/{execution_id}.json`, maintaining 1:1 binding with intent executions.

3. **State store extension** — Add a `results` array to `hbn-state.json` alongside existing `executions`, `decisions`, `context_history`.

4. **CLI extension** — A new subcommand `usehbn result <execution_id>` that captures and records an outcome for a previously structured intent. This preserves the existing CLI interface (no breaking changes).

5. **Guardian integration** — Guardian can now compare intent risks against actual outcomes. A risky intent with no result record becomes a new warning type: "unresolved_risk".

**What it does NOT include:**
- No multi-agent orchestration (that's step N+1)
- No pipeline refactoring (orthogonal concern)
- No API surface (premature)
- No changes to existing modules (purely additive)

---

## STEP 5 — CODEX PROMPT

```
---------------------------------------
CODEX TASK: Implement Execution Result Protocol (ERP) for HBN
---------------------------------------

CONTEXT:
You are working on the HBN repository — an open protocol for safe,
structured AI-assisted software engineering. The system currently
implements: semantic activation, intent structuring, truth barrier,
guardian monitoring, and contribution consent. All existing code is
in src/usehbn/ with tests in tests/.

The system has a critical gap: it structures intent but never captures
what actually happened after the intent was acted upon. Your task is to
implement the Execution Result Protocol (ERP), which closes the
feedback loop by recording execution outcomes.

---------------------------------------
RULES (MANDATORY):
---------------------------------------
1. Do NOT modify any existing file in src/usehbn/protocol/,
   src/usehbn/execution/engine.py, or src/usehbn/cli.py
   beyond minimal, additive changes (imports and new subcommand).
2. Do NOT introduce external dependencies.
3. All new code must follow existing patterns (see intent.py and
   consent.py as reference).
4. All new data must be validated against a JSON schema.
5. All file writes must go through utils/logger.py functions.
6. Run ALL existing tests after changes to verify no regressions.

---------------------------------------
STEP 1: Create the Result Schema
---------------------------------------
Create file: schemas/result.schema.json

The schema must define:
- execution_id (string, minLength 1) — binds to an existing execution
- agent_id (string, minLength 1) — who executed (e.g., "codex", "claude", "human")
- action_taken (string, minLength 1) — what was done
- outcome (string, enum: "success", "failure", "partial", "blocked")
- evidence (array of objects with type and reference fields, minItems 0)
- human_reviewed (boolean)
- review_notes (string, may be empty)
- created_at (string, minLength 1) — ISO 8601 timestamp
- storage_path (string, minLength 1) — where the record is stored

All fields required. Use JSON Schema Draft 2020-12 to match existing
schemas.

---------------------------------------
STEP 2: Create the Result Protocol Module
---------------------------------------
Create file: src/usehbn/protocol/result.py

Implement two functions:

1. create_result_record(
       execution_id: str,
       agent_id: str,
       action_taken: str,
       outcome: str,
       evidence: list,
       human_reviewed: bool,
       review_notes: str = "",
       storage_dir: str | None = None
   ) -> dict

   - Validates outcome is in ["success", "failure", "partial", "blocked"]
   - Creates record with all schema fields
   - Writes to .usehbn/results/{execution_id}.json
   - Validates record against schemas/result.schema.json using
     utils/validators.py validate_against_schema()
   - Returns the validated record

2. load_result_record(execution_id: str, storage_dir: str | None = None) -> dict | None
   - Loads a result record by execution_id
   - Returns None if not found
   - Returns parsed dict if found

Follow the exact patterns in consent.py for:
- Path resolution via utils/config.py
- Schema loading via pathlib
- Timestamp generation via datetime.utcnow().isoformat()
- JSON writing via utils/logger.py write_json()

---------------------------------------
STEP 3: Extend the State Store
---------------------------------------
Modify file: src/usehbn/state/store.py

Add to the _empty_state() template:
- A "results" key with empty array value

Add function:
- append_result_state(result_record: dict, storage_dir: str | None = None)
  Follows the exact pattern of append_execution_state().

---------------------------------------
STEP 4: Extend the Protocol Package Exports
---------------------------------------
Modify file: src/usehbn/protocol/__init__.py

Add: from .result import create_result_record, load_result_record

Modify file: src/usehbn/__init__.py

Add: create_result_record, load_result_record to imports and exports.

---------------------------------------
STEP 5: Add CLI Subcommand
---------------------------------------
Modify file: src/usehbn/cli.py

Add a subcommand "result" that accepts:
  - execution_id (positional, required)
  - --agent-id (required)
  - --action (required)
  - --outcome (required, choices: success, failure, partial, blocked)
  - --evidence (optional, repeatable, format: "type:reference")
  - --human-reviewed (flag, default False)
  - --review-notes (optional string)
  - --storage-dir (optional, same as existing)
  - --indent (optional int, same as existing)

The subcommand must:
  1. Parse evidence strings into [{type: x, reference: y}, ...]
  2. Call create_result_record()
  3. Call append_result_state()
  4. Print the result record as JSON to stdout

IMPORTANT: The existing "run" behavior (default when no subcommand)
must remain unchanged. Use argparse subparsers. The bare
`usehbn "sentence"` must continue to work exactly as before.

---------------------------------------
STEP 6: Extend Guardian (Optional Warning)
---------------------------------------
Modify file: src/usehbn/protocol/guardian.py

Add a new function:
- check_unresolved_risks(execution_id: str, storage_dir: str | None = None) -> dict
  1. Loads the execution log from logs/{execution_id}.json
  2. If the intent had risks but no result record exists, emit warning:
     code: "unresolved_risk"
     severity: "advisory"
     message: "Execution {execution_id} has identified risks but no
               result record. Consider recording the outcome."
  3. Returns guardian-schema-compliant dict

This function is NOT called automatically in the pipeline.
It is available for external tooling to invoke.

---------------------------------------
STEP 7: Write Tests
---------------------------------------
Create file: tests/test_result.py

Test cases (minimum):
1. test_create_result_record_success
   - Creates a result record with outcome="success"
   - Asserts file exists at expected path
   - Asserts all fields present and correctly typed
   - Asserts execution_id matches

2. test_create_result_record_with_evidence
   - Creates a record with two evidence items
   - Asserts evidence array length and structure

3. test_create_result_record_invalid_outcome
   - Attempts outcome="invalid"
   - Asserts ValueError is raised

4. test_load_result_record_found
   - Creates then loads a record
   - Asserts loaded record matches created record

5. test_load_result_record_not_found
   - Loads a non-existent execution_id
   - Asserts returns None

6. test_state_store_results_appended
   - Creates a result, appends to state
   - Loads state, asserts "results" array has one entry

7. test_guardian_unresolved_risk
   - Creates an execution with risks but no result
   - Calls check_unresolved_risks
   - Asserts warning with code "unresolved_risk"

All tests must use tmp_path fixture for isolation.

---------------------------------------
STEP 8: Update Core Documentation
---------------------------------------
Create file: core/result-spec.md

Content must define:
- Purpose of the Execution Result Protocol
- Record structure (matching schema)
- Storage location and naming convention
- Relationship to execution records (1:1 binding via execution_id)
- Non-goals: not enforcement, not automatic, not remote

Modify file: docs/ARCHITECTURE.md

Add a section "Execution Result Layer" describing:
- Where ERP fits in the protocol stack (after guardian, before next cycle)
- How it closes the feedback loop
- Storage artifacts it creates

---------------------------------------
STEP 9: Validation
---------------------------------------
After ALL changes:

1. Run: python -m pytest tests/ -v
   All existing tests MUST pass. All new tests MUST pass.

2. Run: usehbn "use hbn refactor auth module without breaking tests"
   Verify output is unchanged from current behavior.

3. Run: usehbn result exec-test-001 --agent-id codex \
        --action "refactored auth module" --outcome success \
        --evidence "test_report:tests/passed" --human-reviewed
   Verify structured JSON output with all fields.

4. Verify file exists: .usehbn/results/exec-test-001.json

5. Verify hbn-state.json contains a "results" array.

---------------------------------------
REPORT
---------------------------------------
After completion, create REPORT-ERP.md with:
- Files created (list with paths)
- Files modified (list with paths and description of changes)
- Tests added (list with names and status)
- Regression check result (pass/fail)
- Any decisions made during implementation and rationale
- Any deviations from this prompt and why
```

---

## Summary

HBN is a well-conceived protocol-first project at the **structured prototype** stage. Its architecture is philosophically sound — protocol over implementation, human authority as root, advisory over enforcement, local-only processing. The primary gap preventing evolution from structuring tool to runtime system is the absence of an execution feedback loop. The Execution Result Protocol closes that gap with a purely additive change that requires no modifications to the existing pipeline behavior, prepares the system for multi-agent coordination (agents can now see each other's results), and establishes the groundwork for a true traceability chain: intent → action → outcome → review.
