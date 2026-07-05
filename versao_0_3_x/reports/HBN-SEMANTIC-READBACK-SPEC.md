# HBN — Semantic Readback: Architectural Specification

**Date:** 2026-03-29
**Author:** Claude Opus 4.6 (Principal Architect role)
**Target executor:** Codex 5.4
**Baseline:** 17 tests passing, ERP hardened, protocol v0.1.0

---

## PART 1 — DEEP ARCHITECTURAL ANALYSIS

### 1.1 Why Semantic Readback Is Necessary

HBN currently implements a five-stage pipeline: activation → intent structuring → truth barrier → guardian → consent. The ERP added a sixth stage: result recording. But there is a gap between stages 5 and 6 that the protocol does not govern — the gap where *actual execution happens*.

Today, the chain is:

```
Intent (what the human wants)
  → [UNCONTROLLED SPACE: executor interprets, decides, acts]
  → ERP Result (what the executor claims happened)
```

The uncontrolled space is where the most dangerous failures occur. An executor — human or AI — can receive a perfectly structured intent, produce a semantically correct-looking result, and yet have implemented something that *diverges from what was meant*. This is not a bug. This is the dominant failure mode in AI-assisted engineering: technically correct implementation of a semantically incorrect interpretation.

Semantic Readback fills this gap by inserting a mandatory pre-execution contract:

```
Intent (what the human wants)
  → Readback (what the executor declares it understood)
  → Hearback (human confirms or rejects the declaration)
  → Execution (only after confirmation)
  → ERP Result (with semantic reconciliation against readback)
```

This converts the uncontrolled space into a governed protocol stage.

### 1.2 Specific Failure Modes Eliminated

**FM-1: Silent interpretation drift.** An executor reads "refactor the authentication module" and restructures the session management layer because it considers them coupled. Without readback, the human discovers this only after code is changed. With readback, the executor must declare: "I will modify session management" — which the human can reject before any mutation.

**FM-2: Assumed invariants.** An executor preserves function signatures but changes return types. Nothing in the current pipeline detects this. Readback forces the executor to declare `invariants_preserved: ["return types of public methods remain unchanged"]` — making the assumption explicit and challengeable.

**FM-3: Scope creep.** An executor improves code it was not asked to touch. The current pipeline has no mechanism to detect this because intent only specifies what *should* happen, not what *should not*. Readback's `out_of_scope` field makes excluded areas explicit.

**FM-4: Legacy system destruction.** VBA and undocumented systems contain hidden business logic embedded in control flow, cell references, and event handlers. An executor can "clean up" code that appears dead but actually serves a critical function. Readback forces the executor to expose its understanding of the system *before* touching it, giving domain experts a chance to catch misunderstandings.

**FM-5: Beautiful-but-wrong confidence.** AI systems produce polished, confident explanations that mask fundamental misunderstandings. The current truth barrier catches *linguistic* overconfidence ("guaranteed", "always"). Readback catches *semantic* overconfidence by forcing the executor to be specific: what exactly will change, what exactly is preserved.

### 1.3 How Readback Differs from Existing Mechanisms

**Readback vs. tests:** Tests verify behavior *after* implementation. Readback verifies understanding *before* implementation. Tests say "the code does X." Readback says "the executor intends to make the code do X." Tests cannot catch scope creep or unintended side effects in untested areas. Readback can.

**Readback vs. git diff:** A diff shows *what changed*. Readback shows *what was understood, intended, and guaranteed*. A diff of 200 lines cannot be reviewed for semantic correctness without context. A readback provides that context in structured, human-readable form.

**Readback vs. logs:** Logs record *what happened*. Readback records *what was promised*. Logs are retrospective. Readback is prospective. The value of readback is precisely that it exists *before* execution — it creates a baseline for accountability.

**Readback vs. documentation:** Documentation describes the system. Readback describes a *specific transformation of the system*. Documentation is static and often stale. Readback is generated fresh for each execution and validated against the specific intent.

### 1.4 Why Protocol-Level, Not Optional

If readback is optional, it will be skipped for exactly the cases where it is most needed: urgent changes, "simple" fixes, and legacy modifications under time pressure. These are the cases with the highest semantic risk. A protocol-level component means the system enforces its presence when risk conditions are met (via Guardian integration), not when the executor feels like providing it.

The opt-out mechanism is explicit: Fast-Track classification (defined in Part 7) provides a principled escape for genuinely trivial changes. This is not "readback is optional" — it is "certain classes of change are exempt, and the classification criteria are documented and auditable."

### 1.5 Long-Term System Integrity

Over time, systems accumulate changes from many executors. Without readback records, the *reasoning* behind each change is lost. Code comments explain *what*; commit messages explain *why* at a high level; but neither captures what the executor *understood about the system* at the moment of change. Readback creates a structured semantic audit trail: for each significant change, there exists a record of understanding, guarantees, and acknowledged risks. This is invaluable for:

- Understanding why a past decision was made
- Identifying when a false understanding led to a defect
- Training new team members on system semantics
- Enabling AI-to-AI semantic handoffs in multi-agent orchestration

### 1.6 Legacy System Protection (VBA and Beyond)

Legacy systems are uniquely vulnerable because their logic is often implicit: a VBA macro that runs on worksheet change, a hidden named range used in 40 formulas, an event handler that enforces business rules through side effects. No test suite covers these. No documentation describes them.

Readback forces the executor to perform *code/behavior exposure* before modifying the system. The `understanding` field becomes a structured declaration of the executor's mental model. For VBA systems, this means:

- "I understand that Module1.RecalcTotals is triggered by Worksheet_Change on Sheet3"
- "I understand that named range 'TaxRate' is referenced in cells B12:B200"
- "I understand that UserForm1.btnSubmit writes to column G and triggers a macro chain"

A domain expert can read these declarations and immediately identify misunderstandings — before any code is modified. This is the most powerful application of readback: it converts implicit knowledge into explicit, challengeable statements.

---

## PART 2 — CONCEPTUAL MODEL

### 2.1 Role in the System

Semantic Readback is a **pre-execution behavioral contract**. It sits between intent structuring and actual execution, serving as the executor's formal declaration of understanding and intent.

### 2.2 When It Is Triggered

Readback is triggered when the execution is classified as **Safe-Track** (see Part 7). The classification is determined by:

- Guardian warnings present (any risk detected)
- Multi-file changes planned
- Legacy system involvement
- Business logic modification
- Explicit human request

Fast-Track changes (single-file, no business logic, no Guardian warnings) may skip readback.

### 2.3 Who Produces It

The **executor** produces the readback. This can be:

- An AI agent (Codex, Claude) before modifying code
- A human developer before a critical change
- An automated pipeline before a deployment

The readback is always produced by the entity that will perform the execution — never by a third party.

### 2.4 Who Validates It

**MVP: Human only.** The human reviews the readback and either confirms (hearback) or rejects it. The hearback status is recorded in the readback record itself.

**Future: Semantic Validator Agent** (see Part 8). An independent AI that compares readback against intent without seeing code.

### 2.5 Connections to Existing Components

**Intent → Readback:** The readback references the intent's `execution_id`. The `understanding` field must address the intent's `objective`. The `residual_risks` should reference the intent's `risks`.

**Guardian → Readback:** Guardian warnings determine whether readback is required (Safe-Track classification). Guardian's risk assessment informs the readback's `residual_risks`.

**Truth Barrier → Readback:** Truth barrier checks can be applied to the readback text itself — an executor's readback claiming "this change is guaranteed safe" should be flagged.

**Readback → ERP:** The ERP result record references the readback's `readback_id`. The ERP's `action_taken` can be compared against the readback's `action_plan` for semantic reconciliation.

### 2.6 Full Lifecycle

```
SR-001: Intent captured (structure_intent)
SR-002: Risk assessed (Guardian + Truth Barrier)
SR-003: Track classification (Fast-Track or Safe-Track)
SR-004: Readback generated (executor declares understanding)
SR-005: Hearback received (human validates or rejects)
SR-006: Execution allowed (only after SR-005 = confirmed)
SR-007: ERP result recorded (with readback_id reference)
SR-008: Semantic reconciliation (compare ERP vs readback)
```

Steps SR-004 through SR-005 are the new protocol stages. SR-003 determines whether they are required. SR-008 is a future enhancement where ERP results are automatically compared to readback promises.

---

## PART 3 — SCHEMA DESIGN

### readback.schema.json

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HBN Semantic Readback Record",
  "type": "object",
  "required": [
    "readback_id",
    "execution_id",
    "agent_id",
    "track",
    "understanding",
    "invariants_preserved",
    "action_plan",
    "residual_risks",
    "hearback_status",
    "created_at"
  ],
  "properties": {
    "readback_id": {
      "type": "string",
      "minLength": 1
    },
    "execution_id": {
      "type": "string",
      "minLength": 1
    },
    "agent_id": {
      "type": "string",
      "minLength": 1
    },
    "track": {
      "type": "string",
      "enum": ["safe_track", "fast_track"]
    },
    "understanding": {
      "type": "string",
      "minLength": 1,
      "maxLength": 2000
    },
    "invariants_preserved": {
      "type": "array",
      "items": {
        "type": "string",
        "minLength": 1
      },
      "minItems": 1
    },
    "action_plan": {
      "type": "array",
      "items": {
        "type": "string",
        "minLength": 1
      },
      "minItems": 1
    },
    "out_of_scope": {
      "type": "array",
      "items": {
        "type": "string",
        "minLength": 1
      }
    },
    "residual_risks": {
      "type": "array",
      "items": {
        "type": "string",
        "minLength": 1
      }
    },
    "hearback_status": {
      "type": "string",
      "enum": ["pending", "confirmed", "rejected", "revised"]
    },
    "hearback_notes": {
      "type": "string"
    },
    "created_at": {
      "type": "string",
      "minLength": 1
    }
  }
}
```

### Field Semantics

**readback_id** — Unique identifier (`rb-{timestamp}-{uuid_hex[:8]}`). Enables 1:1 binding.

**execution_id** — Links to the intent execution that triggered this readback. This is the foreign key that connects readback to the full traceability chain.

**agent_id** — Who produced the readback. Must match the agent that will execute.

**track** — `safe_track` (full readback required) or `fast_track` (abbreviated readback, permitted for low-risk changes).

**understanding** — The executor's structured declaration of what it understood from the intent. This is the core of code/behavior exposure. Max 2000 chars to force concision.

**invariants_preserved** — Explicit list of things the executor guarantees will NOT change. This is the most important field for legacy systems. At least one invariant is always required — even for new code, the executor must state what existing behavior is preserved.

**action_plan** — Ordered list of steps the executor will take. Each step must be specific and verifiable. At least one step required.

**out_of_scope** — What the executor explicitly will NOT touch. Optional but strongly recommended for multi-file changes.

**residual_risks** — Risks the executor acknowledges but cannot eliminate. Empty array is valid (meaning "no residual risks identified").

**hearback_status** — `pending` (awaiting human review), `confirmed` (human approved), `rejected` (human denied execution), `revised` (readback was modified and resubmitted).

**hearback_notes** — Human reviewer's comments. Optional.

**created_at** — ISO 8601 timestamp with Z suffix (via `utc_now_iso()`).

---

## PART 4 — PIPELINE INTEGRATION

### 4.1 Position in Execution Flow

```
detect_activation → structure_intent → truth_barrier → guardian
                                                           ↓
                                              classify_track()
                                              (fast or safe)
                                                           ↓
                                              [if safe_track]
                                              create_readback()
                                                           ↓
                                              [human reviews]
                                              update_hearback()
                                                           ↓
                                              [if confirmed]
                                              → EXECUTION ALLOWED →
                                                           ↓
                                              create_result_record()
                                              (ERP with readback_id)
```

### 4.2 How It Blocks Execution

In the MVP, blocking is **contractual, not mechanical**. The readback record has `hearback_status: "pending"` at creation. The protocol contract states: execution must not proceed until hearback_status is "confirmed". The CLI supports this by requiring `--hearback confirmed` to finalize a readback.

The system does NOT modify `engine.py` or inject itself into the automatic pipeline. Instead, it operates as a standalone protocol step invoked between intent structuring and ERP recording. This preserves the principle: the pipeline produces advisory output; humans decide when to proceed.

### 4.3 Storage

Readback records are stored in `.usehbn/readbacks/{readback_id}.json`. The state store (`hbn-state.json`) gains a `readbacks` array alongside existing `executions`, `decisions`, `context_history`, and `results`.

### 4.4 Link to execution_id

Each readback references an `execution_id` from a prior `usehbn` invocation. This creates the traceability chain:

```
execution_id → intent log (logs/{execution_id}.json)
execution_id → readback record (.usehbn/readbacks/{readback_id}.json)
execution_id → ERP result (.usehbn/results/{execution_id}.json)
```

### 4.5 ERP Semantic Reconciliation

When an ERP result is created for an execution_id that has an associated readback, the ERP record should reference the `readback_id`. This enables future semantic reconciliation: comparing `action_plan` (what was promised) against `action_taken` (what was done). The MVP does not automate this comparison — it stores the data needed for a human or future validator to perform it.

---

## PART 5 — LEGACY SYSTEM IMPACT

### 5.1 VBA Systems

VBA codebases are the hardest systems to refactor safely because:

- Business logic is embedded in event handlers, not explicit functions
- Cell references create invisible dependency graphs
- Named ranges act as global state
- UserForms combine UI and logic inseparably
- Error handling is often absent, making control flow unpredictable

Readback transforms VBA refactoring from "modify and pray" to "declare and verify":

**Before readback:**
```
Human: "Refactor the invoice calculation"
AI: [modifies 3 modules, changes a named range]
Human: [discovers broken formulas 2 weeks later]
```

**After readback:**
```
Human: "Refactor the invoice calculation"
AI readback:
  understanding: "Invoice total is computed in Module2.CalcInvoice,
    triggered by Worksheet_Change on Sheet1. It reads named range
    'TaxRate' and writes to cells F10:F500."
  invariants_preserved:
    - "Named range 'TaxRate' remains defined and unchanged"
    - "Output cells F10:F500 receive the same values for identical input"
    - "Worksheet_Change trigger on Sheet1 continues to fire CalcInvoice"
  action_plan:
    - "Extract tax calculation into a pure function Module2.ComputeTax"
    - "Replace inline calculation in CalcInvoice with call to ComputeTax"
    - "Add error handling for missing TaxRate"
  out_of_scope:
    - "UserForm1 and its event handlers"
    - "Sheet2 pivot table macros"
Human: [reviews, notices AI missed that F10:F500 also triggers
        a Worksheet_Calculate event → corrects readback before execution]
```

### 5.2 Invariants for Legacy Structures

The `invariants_preserved` field must reference concrete, verifiable properties of the legacy system:

- "Named range X remains defined with current scope and value"
- "Public Sub Y maintains its current signature and calling convention"
- "Cells in range A:Z on SheetN continue to receive the same computed values for the same input"
- "Event handler Worksheet_Change on SheetN remains connected and functional"
- "Error handling behavior in Module.Proc remains: On Error Resume Next"

These are not abstractions. They are testable, falsifiable claims about the system.

### 5.3 Code/Behavior Exposure

Readback inherently implements code/behavior exposure because the `understanding` field requires the executor to describe the system's behavior in structured semantic form. This creates a machine-readable explanation layer:

- Legacy systems can be *read through explanations* rather than through code alone
- Test design can be *derived from invariants_preserved* (each invariant suggests a test)
- Correlation between request, understanding, and result becomes *auditable*

---

## PART 6 — RISK ANALYSIS AND MITIGATION

### Risk 1: False Sense of Security

**Definition:** Teams rely on readback as proof of correctness, reducing code review rigor.

**Mitigation:** Readback documentation (core/readback-spec.md) must state explicitly: "Readback is a declaration of understanding, not proof of correctness. It reduces interpretation errors but does not replace testing, review, or validation." The `hearback_status` field records human review but does not claim human review was thorough.

### Risk 2: Beautiful-but-Wrong Readbacks

**Definition:** AI produces articulate, confident readbacks that are factually incorrect. The readback *looks* right but describes a different system than the one being modified.

**Mitigation:** This is the hardest risk. Three defenses:

1. **Structural constraints.** The schema requires `invariants_preserved` as an array of specific claims, not prose. Each claim is individually challengeable.
2. **Truth barrier integration.** Apply truth barrier checks to the readback text. Overconfident language in a readback ("this change is guaranteed safe") is flagged.
3. **Out-of-scope field.** Forces the executor to declare what it will NOT touch, creating a second axis for human review. If `out_of_scope` is suspiciously narrow, the human should investigate.

### Risk 3: Divergence Between Readback and Actual Code

**Definition:** Executor declares one plan in readback, then implements something different.

**Mitigation:** The ERP result record references the `readback_id`. Future semantic reconciliation can compare `action_plan` to `action_taken`. In the MVP, this is a manual comparison. The data structure exists; automation can follow.

### Risk 4: Bureaucratic Overload

**Definition:** Readback becomes a checkbox exercise. Developers write minimal, meaningless readbacks to satisfy the protocol.

**Mitigation:** Two mechanisms:

1. **Fast-Track exemption.** Trivial changes skip readback entirely. This removes the temptation to produce garbage readbacks for simple fixes.
2. **Schema enforcement.** `invariants_preserved` requires `minItems: 1`. `action_plan` requires `minItems: 1`. `understanding` requires `minLength: 1, maxLength: 2000`. Empty or single-character readbacks fail validation.

### Risk 5: Unnecessary Use in Trivial Changes

**Definition:** A one-line typo fix requires a full readback with invariants and action plan.

**Mitigation:** Fast-Track classification (Part 7). The protocol explicitly defines when readback is NOT required, preventing the "everything needs a readback" failure mode.

---

## PART 7 — FAST-TRACK vs SAFE-TRACK

### Classification Criteria

**FAST-TRACK (readback not required):**

All of the following must be true:

- No Guardian warnings on the intent
- Single-file change
- No business logic modification
- No structural change (no new modules, no interface changes)
- No legacy system involvement
- Intent does not contain high-risk keywords (delete, drop, production, migrate, security, billing, authentication)

**SAFE-TRACK (readback required):**

Any of the following makes the change Safe-Track:

- Guardian emitted any warning
- Multi-file change planned
- Business logic modification
- Legacy system (VBA, undocumented code)
- Risk keywords detected in intent
- Unclear or ambiguous intent
- Executor uncertainty ("I think...", "probably...", "should be safe...")
- Human explicitly requests readback

### Classification Function

The MVP implements a pure function `classify_track(intent, guardian_result)` that returns `"fast_track"` or `"safe_track"` based on the criteria above. This function does NOT block anything — it classifies. The protocol contract determines what happens based on the classification.

---

## PART 8 — SEMANTIC VALIDATOR AGENT (FUTURE)

### Concept

An independent AI agent that receives:

- The original intent (objective, constraints, risks, validation requirements)
- The readback (understanding, invariants, action plan, out_of_scope, residual risks)

And produces a semantic alignment score with specific misalignment flags.

### Critical Design Rules

1. **Must NOT see code.** The validator operates at semantic level only. If it sees code, it becomes a code reviewer — which already exists. Its value is in detecting *semantic drift* between intent and readback.

2. **Must NOT see executor identity.** Prevents bias based on agent reputation.

3. **Must produce structured output.** Not prose. Specific flags: `understanding_covers_objective`, `invariants_address_risks`, `action_plan_is_scoped`, `out_of_scope_is_reasonable`.

4. **Is advisory.** The validator does not block. It provides a second opinion for the human.

### MVP Boundary

**The MVP does NOT implement this agent.** The MVP relies exclusively on human validation. The schema and data structures are designed to support future automated validation, but no automated validator is built. This prevents premature complexity.

---

## PART 9 — MVP (PARETO 80/20)

### What Delivers Maximum Value

The core value of Semantic Readback is the `invariants_preserved` field and the `hearback_status` gate. Everything else is supporting structure. The MVP must make it trivially easy to:

1. Create a readback record with understanding + invariants + action plan
2. Record human hearback (confirmed/rejected)
3. Link readback to execution_id for traceability
4. Persist everything locally with no external dependencies

### MUST Include

- `schemas/readback.schema.json` — Data contract
- `src/usehbn/protocol/readback.py` — `create_readback()`, `update_hearback()`, `load_readback()`, `classify_track()`
- `src/usehbn/state/store.py` — `append_readback_state()` (additive, follows existing pattern)
- `tests/test_readback_protocol.py` — Comprehensive test suite
- `core/readback-spec.md` — Protocol specification
- `agents/codex.md` — Updated agent contract (additive)
- CLI integration — `usehbn readback` subcommand (non-breaking)

### MUST Avoid

- No modification to `engine.py`
- No distributed systems
- No API calls
- No complex orchestration
- No async pipelines
- No automated semantic validation
- No modification to existing test files

---

## PART 10 — STRUCTURED ORCHESTRATION MODEL

The following stage identifiers enable multi-agent orchestration by providing a numbered reference for each protocol step:

```
SR-001  Intent captured
        → structure_intent() produces intent object
        → execution_id generated

SR-002  Risk assessed
        → truth_barrier + guardian produce warnings
        → warnings stored in execution log

SR-003  Track classified
        → classify_track(intent, guardian_result)
        → returns "fast_track" or "safe_track"

SR-004  Readback generated (Safe-Track only)
        → create_readback() produces readback record
        → hearback_status = "pending"
        → record stored in .usehbn/readbacks/

SR-005  Hearback received
        → update_hearback() sets status to confirmed/rejected/revised
        → human review notes captured

SR-006  Execution gate
        → if hearback_status == "confirmed": proceed
        → if hearback_status == "rejected": stop, revise intent
        → if hearback_status == "revised": return to SR-004

SR-007  Execution performed
        → Agent performs the work (outside protocol scope)

SR-008  ERP result recorded
        → create_result_record() with readback_id reference
        → action_taken can be compared to action_plan

SR-009  Semantic reconciliation (FUTURE)
        → Automated comparison of SR-004 action_plan vs SR-008 action_taken
        → Misalignment flagged for human review
```

Each stage produces a traceable artifact. Each artifact references the `execution_id`. The chain is fully auditable from SR-001 to SR-008.

---

## PART 11 — FINAL CODEX PROMPT

```
========================================================================
CODEX TASK: Implement HBN Semantic Readback Protocol (MVP)
========================================================================

CONTEXT:
You are working on the HBN repository — an open protocol for safe,
structured AI-assisted software engineering.

Current state:
- 17 tests passing
- Protocol v0.1.0
- ERP (Execution Result Protocol) fully implemented and hardened
- Pipeline: activation → intent → truth_barrier → guardian → consent
- ERP adds post-execution result recording

Your task: implement Semantic Readback — a pre-execution behavioral
contract where the executor declares what it understood, what it will
preserve, and what it will change, BEFORE any state mutation occurs.

========================================================================
STRICT RULES (MANDATORY):
========================================================================
1. Do NOT modify src/usehbn/execution/engine.py
2. Do NOT modify any existing test file
3. Do NOT introduce external dependencies
4. All new code must use ONLY Python standard library
5. Follow existing patterns in result.py and consent.py
6. Use utc_now_iso() from usehbn.utils.time for all timestamps
7. Use assert_valid_payload() from usehbn.utils.validators for schema
8. Use write_json() from usehbn.utils.logger for file writes
9. Run ALL existing tests after EACH step to verify no regressions
10. All changes are ADDITIVE ONLY

========================================================================
STEP 1: Create the Readback Schema
========================================================================
Create file: schemas/readback.schema.json

Content (copy exactly):

{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HBN Semantic Readback Record",
  "type": "object",
  "required": [
    "readback_id",
    "execution_id",
    "agent_id",
    "track",
    "understanding",
    "invariants_preserved",
    "action_plan",
    "residual_risks",
    "hearback_status",
    "created_at"
  ],
  "properties": {
    "readback_id": {
      "type": "string",
      "minLength": 1
    },
    "execution_id": {
      "type": "string",
      "minLength": 1
    },
    "agent_id": {
      "type": "string",
      "minLength": 1
    },
    "track": {
      "type": "string",
      "enum": ["safe_track", "fast_track"]
    },
    "understanding": {
      "type": "string",
      "minLength": 1,
      "maxLength": 2000
    },
    "invariants_preserved": {
      "type": "array",
      "items": {
        "type": "string",
        "minLength": 1
      },
      "minItems": 1
    },
    "action_plan": {
      "type": "array",
      "items": {
        "type": "string",
        "minLength": 1
      },
      "minItems": 1
    },
    "out_of_scope": {
      "type": "array",
      "items": {
        "type": "string",
        "minLength": 1
      }
    },
    "residual_risks": {
      "type": "array",
      "items": {
        "type": "string",
        "minLength": 1
      }
    },
    "hearback_status": {
      "type": "string",
      "enum": ["pending", "confirmed", "rejected", "revised"]
    },
    "hearback_notes": {
      "type": "string"
    },
    "created_at": {
      "type": "string",
      "minLength": 1
    }
  }
}

VALIDATION: Run python -m pytest tests/ -v. All 17 tests must pass.

========================================================================
STEP 2: Create the Readback Protocol Module
========================================================================
Create file: src/usehbn/protocol/readback.py

Header:
  """Semantic Readback Protocol for HBN.

  Copyright (C) 2026 Luis Mauricio Junqueira Zanin
  Licensed under the GNU Affero General Public License v3.0 or later.
  """

Imports (use exactly these):
  from __future__ import annotations
  import json
  from datetime import datetime, timezone
  from pathlib import Path
  from typing import Any, Dict, List, Optional
  from uuid import uuid4
  from usehbn.utils.config import default_state_dir
  from usehbn.utils.logger import write_json
  from usehbn.utils.time import utc_now_iso
  from usehbn.utils.validators import assert_valid_payload

Constants:
  READBACKS_DIRNAME = "readbacks"

Internal helpers:
  def _readbacks_dir(storage_dir: Optional[Path] = None) -> Path:
      d = default_state_dir(storage_dir) / READBACKS_DIRNAME
      d.mkdir(parents=True, exist_ok=True)
      return d

  def _readback_id() -> str:
      return f"rb-{datetime.now(timezone.utc):%Y%m%dT%H%M%SZ}-{uuid4().hex[:8]}"

Function 1 — classify_track:
  def classify_track(
      intent: Dict[str, Any],
      guardian_result: Dict[str, Any],
  ) -> str:
      """Return 'safe_track' or 'fast_track' based on risk signals."""
      if guardian_result.get("status") == "warn":
          return "safe_track"
      if guardian_result.get("warnings"):
          return "safe_track"
      if intent.get("risks"):
          return "safe_track"
      return "fast_track"

  Notes:
  - This is intentionally conservative: any risk signal → safe_track
  - Multi-file detection and legacy detection are future enhancements
  - The function is pure: no side effects, no I/O

Function 2 — create_readback:
  def create_readback(
      *,
      execution_id: str,
      agent_id: str,
      track: str,
      understanding: str,
      invariants_preserved: List[str],
      action_plan: List[str],
      out_of_scope: Optional[List[str]] = None,
      residual_risks: Optional[List[str]] = None,
      storage_dir: Optional[Path] = None,
  ) -> Dict[str, Any]:
      readback_id = _readback_id()
      record = {
          "readback_id": readback_id,
          "execution_id": execution_id,
          "agent_id": agent_id,
          "track": track,
          "understanding": understanding,
          "invariants_preserved": invariants_preserved,
          "action_plan": action_plan,
          "residual_risks": residual_risks or [],
          "hearback_status": "pending",
          "created_at": utc_now_iso(),
      }
      if out_of_scope is not None:
          record["out_of_scope"] = out_of_scope

      assert_valid_payload(record, "readback.schema.json")

      output_path = _readbacks_dir(storage_dir) / f"{readback_id}.json"
      write_json(output_path, record)
      return record

  Notes:
  - hearback_status always starts as "pending"
  - out_of_scope is only included when provided (truly optional)
  - Schema validation happens before any write

Function 3 — update_hearback:
  def update_hearback(
      readback_id: str,
      status: str,
      notes: str = "",
      storage_dir: Optional[Path] = None,
  ) -> Dict[str, Any]:
      valid_statuses = ("confirmed", "rejected", "revised")
      if status not in valid_statuses:
          raise ValueError(
              f"hearback_status must be one of {valid_statuses}, got: {status}"
          )

      readback_dir = _readbacks_dir(storage_dir)
      readback_path = readback_dir / f"{readback_id}.json"
      if not readback_path.exists():
          raise ValueError(f"Readback not found: {readback_id}")

      record = json.loads(readback_path.read_text(encoding="utf-8"))
      record["hearback_status"] = status
      if notes:
          record["hearback_notes"] = notes

      assert_valid_payload(record, "readback.schema.json")
      write_json(readback_path, record)
      return record

  Notes:
  - Validates that readback exists before updating
  - Re-validates full record after update
  - Cannot set hearback_status back to "pending" (not in valid_statuses)

Function 4 — load_readback:
  def load_readback(
      readback_id: str,
      storage_dir: Optional[Path] = None,
  ) -> Optional[Dict[str, Any]]:
      path = _readbacks_dir(storage_dir) / f"{readback_id}.json"
      if not path.exists():
          return None
      return json.loads(path.read_text(encoding="utf-8"))

Function 5 — find_readback_by_execution:
  def find_readback_by_execution(
      execution_id: str,
      storage_dir: Optional[Path] = None,
  ) -> Optional[Dict[str, Any]]:
      readback_dir = _readbacks_dir(storage_dir)
      for path in readback_dir.glob("rb-*.json"):
          record = json.loads(path.read_text(encoding="utf-8"))
          if record.get("execution_id") == execution_id:
              return record
      return None

  Notes:
  - Linear scan is acceptable for MVP (local filesystem, small N)
  - Returns first match (1:1 relationship assumed)

VALIDATION: Run python -m pytest tests/ -v. All 17 tests must pass.

========================================================================
STEP 3: Extend the State Store
========================================================================
Modify file: src/usehbn/state/store.py

In _empty_state(), the "results" key already exists. Add NO new keys
to _empty_state(). Instead, add a "readbacks" key:

Change _empty_state() from:
  return {
      "executions": [],
      "decisions": [],
      "context_history": [],
      "results": [],
  }
To:
  return {
      "executions": [],
      "decisions": [],
      "context_history": [],
      "results": [],
      "readbacks": [],
  }

Add function (after append_result_state):
  def append_readback_state(
      readback_record: Dict[str, Any],
      base_dir: Optional[Path] = None,
  ) -> Path:
      document = load_state_document(base_dir)
      readback_id = readback_record.get("readback_id", "")
      existing_ids = {
          item.get("readback_id") for item in document["readbacks"]
      }
      if readback_id in existing_ids:
          raise ValueError(
              f"Readback state already contains readback_id: {readback_id}"
          )
      document["readbacks"].append(readback_record)
      path = state_file_path(base_dir)
      write_json(path, document)
      return path

  Notes:
  - Follows EXACT same pattern as append_result_state
  - Includes duplicate guard (learned from ERP hardening)
  - Uses readback_id (not execution_id) as unique key

VALIDATION: Run python -m pytest tests/ -v. All 17 tests must pass.

========================================================================
STEP 4: Update Agent Contract
========================================================================
Modify file: agents/codex.md

Add the following section at the end of the file (after existing
content, do NOT modify existing text):

  ## Semantic Readback Expectation

  Before executing any change classified as Safe-Track, Codex must
  produce a Semantic Readback that declares:

  1. what it understood from the intent
  2. what invariants it will preserve
  3. what specific actions it will take
  4. what is explicitly out of scope
  5. what residual risks remain

  Execution must not proceed until the readback receives human
  confirmation (hearback). If the readback is rejected, Codex must
  revise its understanding before attempting again.

  Fast-Track changes (no Guardian warnings, no risks, single-file)
  may proceed without readback, but the track classification must
  be documented.

VALIDATION: Run python -m pytest tests/ -v. All 17 tests must pass.

========================================================================
STEP 5: Add CLI Subcommand
========================================================================
Modify file: src/usehbn/cli.py

Add imports at the top (alongside existing imports from
usehbn.protocol.result):
  from usehbn.protocol.readback import (
      classify_track,
      create_readback,
      update_hearback,
      load_readback,
  )
  from usehbn.state.store import append_readback_state

In build_root_parser(), add TWO new subparsers after the existing
"result" subparser:

Subparser 1 — "readback":
  readback_parser = subparsers.add_parser(
      "readback",
      help="Create a Semantic Readback record.",
  )
  readback_parser.add_argument(
      "exec_id",
      help="Execution identifier this readback is linked to.",
  )
  readback_parser.add_argument(
      "--agent-id", required=True,
      help="Agent producing this readback.",
  )
  readback_parser.add_argument(
      "--track", required=True,
      choices=["safe_track", "fast_track"],
      help="Track classification.",
  )
  readback_parser.add_argument(
      "--understanding", required=True,
      help="What the executor understood from the intent.",
  )
  readback_parser.add_argument(
      "--invariant", action="append", default=[], required=True,
      help="Invariant preserved. Repeatable. At least one required.",
  )
  readback_parser.add_argument(
      "--action", action="append", default=[], required=True,
      help="Planned action step. Repeatable. At least one required.",
  )
  readback_parser.add_argument(
      "--out-of-scope", action="append", default=[],
      help="Out of scope declaration. Repeatable. Optional.",
  )
  readback_parser.add_argument(
      "--risk", action="append", default=[],
      help="Residual risk. Repeatable. Optional.",
  )
  readback_parser.add_argument("--storage-dir", help="Base directory.")
  readback_parser.add_argument(
      "--indent", type=int, default=2, help="JSON indent.",
  )

Subparser 2 — "hearback":
  hearback_parser = subparsers.add_parser(
      "hearback",
      help="Update hearback status on a Semantic Readback record.",
  )
  hearback_parser.add_argument(
      "readback_id",
      help="Readback identifier to update.",
  )
  hearback_parser.add_argument(
      "--status", required=True,
      choices=["confirmed", "rejected", "revised"],
      help="Hearback decision.",
  )
  hearback_parser.add_argument(
      "--notes", default="",
      help="Human reviewer notes.",
  )
  hearback_parser.add_argument("--storage-dir", help="Base directory.")
  hearback_parser.add_argument(
      "--indent", type=int, default=2, help="JSON indent.",
  )

Add handler functions:

  def run_readback_protocol(args: argparse.Namespace) -> Dict[str, Any]:
      storage_dir = (
          Path(args.storage_dir).expanduser() if args.storage_dir else None
      )
      record = create_readback(
          execution_id=args.exec_id,
          agent_id=args.agent_id,
          track=args.track,
          understanding=args.understanding,
          invariants_preserved=args.invariant,
          action_plan=args.action,
          out_of_scope=args.out_of_scope or None,
          residual_risks=args.risk or None,
          storage_dir=storage_dir,
      )
      state_path = append_readback_state(record, base_dir=storage_dir)
      return {
          "project": "HBN \u2014 Human Brain Net",
          "protocol_version": __version__,
          "readback_record": record,
          "state_path": str(state_path),
      }


  def run_hearback_protocol(args: argparse.Namespace) -> Dict[str, Any]:
      storage_dir = (
          Path(args.storage_dir).expanduser() if args.storage_dir else None
      )
      record = update_hearback(
          readback_id=args.readback_id,
          status=args.status,
          notes=args.notes,
          storage_dir=storage_dir,
      )
      return {
          "project": "HBN \u2014 Human Brain Net",
          "protocol_version": __version__,
          "updated_readback": record,
      }

Update the main() function to handle the new subcommands. The current
main() checks sys.argv[1] == "result". Extend this:

  def main() -> int:
      if len(sys.argv) > 1 and sys.argv[1] == "result":
          parser = build_root_parser()
          args = parser.parse_args()
          result = run_result_protocol(args)
          indent = args.indent
      elif len(sys.argv) > 1 and sys.argv[1] == "readback":
          parser = build_root_parser()
          args = parser.parse_args()
          result = run_readback_protocol(args)
          indent = args.indent
      elif len(sys.argv) > 1 and sys.argv[1] == "hearback":
          parser = build_root_parser()
          args = parser.parse_args()
          result = run_hearback_protocol(args)
          indent = args.indent
      else:
          parser = build_parser()
          args = parser.parse_args()
          result = run_protocol(args)
          indent = args.indent

      print(json.dumps(result, indent=indent, ensure_ascii=True))
      return 0

IMPORTANT: The bare `usehbn "sentence"` must continue to work
exactly as before. Test this explicitly.

VALIDATION: Run python -m pytest tests/ -v. All 17 tests must pass.

========================================================================
STEP 6: Write Tests
========================================================================
Create file: tests/test_readback_protocol.py

Content:

  import json
  import sys
  from pathlib import Path

  import pytest

  sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

  from usehbn.protocol.readback import (
      classify_track,
      create_readback,
      find_readback_by_execution,
      load_readback,
      update_hearback,
  )
  from usehbn.state.store import (
      append_readback_state,
      load_state_document,
  )


  def test_classify_track_safe_when_guardian_warns():
      intent = {"objective": "x", "risks": [], "constraints": [],
                "validation_requirements": []}
      guardian = {"status": "warn", "warnings": [{"code": "x"}],
                  "log_path": ""}
      assert classify_track(intent, guardian) == "safe_track"


  def test_classify_track_safe_when_risks_present():
      intent = {"objective": "x", "risks": ["data loss"],
                "constraints": [], "validation_requirements": []}
      guardian = {"status": "clear", "warnings": [], "log_path": ""}
      assert classify_track(intent, guardian) == "safe_track"


  def test_classify_track_fast_when_no_risk():
      intent = {"objective": "x", "risks": [], "constraints": [],
                "validation_requirements": []}
      guardian = {"status": "clear", "warnings": [], "log_path": ""}
      assert classify_track(intent, guardian) == "fast_track"


  def test_create_readback_produces_valid_record(tmp_path):
      record = create_readback(
          execution_id="exec-rb-001",
          agent_id="codex",
          track="safe_track",
          understanding="Module handles invoice tax calc.",
          invariants_preserved=["Tax rate named range unchanged"],
          action_plan=["Extract pure function for tax"],
          out_of_scope=["UserForm1"],
          residual_risks=["Untested edge case for zero tax"],
          storage_dir=tmp_path,
      )
      assert record["execution_id"] == "exec-rb-001"
      assert record["hearback_status"] == "pending"
      assert record["track"] == "safe_track"
      assert len(record["invariants_preserved"]) == 1
      assert len(record["action_plan"]) == 1
      assert record["out_of_scope"] == ["UserForm1"]
      assert record["created_at"].endswith("Z")

      rb_id = record["readback_id"]
      path = tmp_path / ".usehbn" / "readbacks" / f"{rb_id}.json"
      assert path.exists()


  def test_create_readback_without_optional_fields(tmp_path):
      record = create_readback(
          execution_id="exec-rb-002",
          agent_id="claude",
          track="fast_track",
          understanding="Simple rename.",
          invariants_preserved=["Public API unchanged"],
          action_plan=["Rename function foo to bar"],
          storage_dir=tmp_path,
      )
      assert "out_of_scope" not in record
      assert record["residual_risks"] == []
      assert record["hearback_status"] == "pending"


  def test_update_hearback_confirmed(tmp_path):
      record = create_readback(
          execution_id="exec-rb-003",
          agent_id="codex",
          track="safe_track",
          understanding="Auth refactor.",
          invariants_preserved=["Session tokens unchanged"],
          action_plan=["Extract JWT validation"],
          storage_dir=tmp_path,
      )
      rb_id = record["readback_id"]

      updated = update_hearback(
          rb_id, "confirmed", notes="Looks good.", storage_dir=tmp_path,
      )
      assert updated["hearback_status"] == "confirmed"
      assert updated["hearback_notes"] == "Looks good."

      reloaded = load_readback(rb_id, storage_dir=tmp_path)
      assert reloaded["hearback_status"] == "confirmed"


  def test_update_hearback_rejected(tmp_path):
      record = create_readback(
          execution_id="exec-rb-004",
          agent_id="codex",
          track="safe_track",
          understanding="Misunderstood scope.",
          invariants_preserved=["DB schema"],
          action_plan=["Modify schema"],
          storage_dir=tmp_path,
      )
      updated = update_hearback(
          record["readback_id"], "rejected",
          notes="You said modify schema but invariant says preserve it.",
          storage_dir=tmp_path,
      )
      assert updated["hearback_status"] == "rejected"


  def test_update_hearback_invalid_status(tmp_path):
      record = create_readback(
          execution_id="exec-rb-005",
          agent_id="codex",
          track="safe_track",
          understanding="Test.",
          invariants_preserved=["API"],
          action_plan=["Fix bug"],
          storage_dir=tmp_path,
      )
      with pytest.raises(ValueError):
          update_hearback(
              record["readback_id"], "pending",
              storage_dir=tmp_path,
          )


  def test_update_hearback_not_found(tmp_path):
      with pytest.raises(ValueError):
          update_hearback(
              "rb-nonexistent", "confirmed", storage_dir=tmp_path,
          )


  def test_load_readback_not_found(tmp_path):
      assert load_readback("rb-missing", storage_dir=tmp_path) is None


  def test_find_readback_by_execution(tmp_path):
      record = create_readback(
          execution_id="exec-rb-006",
          agent_id="codex",
          track="safe_track",
          understanding="Find test.",
          invariants_preserved=["All"],
          action_plan=["Do thing"],
          storage_dir=tmp_path,
      )
      found = find_readback_by_execution(
          "exec-rb-006", storage_dir=tmp_path,
      )
      assert found is not None
      assert found["readback_id"] == record["readback_id"]


  def test_find_readback_by_execution_not_found(tmp_path):
      assert find_readback_by_execution(
          "exec-missing", storage_dir=tmp_path,
      ) is None


  def test_state_append(tmp_path):
      record = create_readback(
          execution_id="exec-rb-007",
          agent_id="codex",
          track="safe_track",
          understanding="State test.",
          invariants_preserved=["State shape"],
          action_plan=["Append readback"],
          storage_dir=tmp_path,
      )
      append_readback_state(record, base_dir=tmp_path)
      state = load_state_document(tmp_path)
      assert "readbacks" in state
      assert len(state["readbacks"]) == 1
      assert (
          state["readbacks"][0]["readback_id"] == record["readback_id"]
      )


  def test_state_duplicate_rejected(tmp_path):
      record = create_readback(
          execution_id="exec-rb-008",
          agent_id="codex",
          track="safe_track",
          understanding="Dup test.",
          invariants_preserved=["No dup"],
          action_plan=["Write once"],
          storage_dir=tmp_path,
      )
      append_readback_state(record, base_dir=tmp_path)
      with pytest.raises(ValueError):
          append_readback_state(record, base_dir=tmp_path)


  def test_understanding_max_length_enforced(tmp_path):
      with pytest.raises(ValueError):
          create_readback(
              execution_id="exec-rb-009",
              agent_id="codex",
              track="safe_track",
              understanding="x" * 2001,
              invariants_preserved=["Limit test"],
              action_plan=["Fail validation"],
              storage_dir=tmp_path,
          )


  def test_empty_invariants_rejected(tmp_path):
      with pytest.raises(ValueError):
          create_readback(
              execution_id="exec-rb-010",
              agent_id="codex",
              track="safe_track",
              understanding="No invariants.",
              invariants_preserved=[],
              action_plan=["Do something"],
              storage_dir=tmp_path,
          )


  def test_empty_action_plan_rejected(tmp_path):
      with pytest.raises(ValueError):
          create_readback(
              execution_id="exec-rb-011",
              agent_id="codex",
              track="safe_track",
              understanding="No plan.",
              invariants_preserved=["Something"],
              action_plan=[],
              storage_dir=tmp_path,
          )

VALIDATION: Run python -m pytest tests/ -v
Expected: All 17 existing tests pass + 17 new tests pass = 34 total.

========================================================================
STEP 7: Create Core Protocol Specification
========================================================================
Create file: core/readback-spec.md

Content:

  # Semantic Readback

  ## Definition

  Semantic Readback is a mandatory pre-execution behavioral contract
  within the HBN protocol. The executor must declare what it
  understood, what it will preserve, what it will change, and what
  risks remain — before any state mutation occurs.

  ## Purpose

  Readback eliminates silent divergence between intent and
  implementation. It makes the executor's interpretation explicit,
  challengeable, and traceable.

  ## Readback is NOT:

  - documentation (it is a per-execution contract)
  - a summary (it is structured and schema-validated)
  - optional explanation (it is required for Safe-Track changes)
  - proof of correctness (it is a declaration of understanding)

  ## Record Structure

  A readback record contains:

  - readback_id: unique identifier
  - execution_id: links to the intent that triggered this readback
  - agent_id: who produced the readback
  - track: safe_track or fast_track
  - understanding: what the executor understood
  - invariants_preserved: what will NOT change (required, >= 1)
  - action_plan: what will be done (required, >= 1)
  - out_of_scope: what is explicitly excluded (optional)
  - residual_risks: acknowledged remaining risks
  - hearback_status: pending, confirmed, rejected, or revised

  ## Track Classification

  Fast-Track: no Guardian warnings, no risks, no legacy involvement.
  Readback permitted but not required.

  Safe-Track: any risk signal present. Readback required before
  execution.

  ## Hearback Protocol

  The human reviews the readback and sets hearback_status:
  - confirmed: execution may proceed
  - rejected: execution must not proceed; intent may need revision
  - revised: readback must be regenerated with updated understanding

  ## Storage

  Readback records are stored in .usehbn/readbacks/{readback_id}.json
  and appended to the readbacks array in hbn-state.json.

  ## Non-Goals

  This component does not provide:
  - automated semantic validation
  - execution blocking at runtime
  - distributed coordination
  - formal verification of readback accuracy

========================================================================
STEP 8: Final Validation
========================================================================

1. Run: python -m pytest tests/ -v
   Expected: 34 tests pass (17 existing + 17 new), 0 failures.

2. Run: usehbn "use hbn refactor auth module without breaking tests"
   Verify: Output is IDENTICAL to pre-change behavior.

3. Run: usehbn readback exec-test-001 \
     --agent-id codex \
     --track safe_track \
     --understanding "Auth module handles JWT validation and session mgmt" \
     --invariant "Public API signatures unchanged" \
     --invariant "Existing tests continue to pass" \
     --action "Extract JWT validation into auth/jwt.py" \
     --action "Update imports in auth/__init__.py" \
     --out-of-scope "Session storage backend" \
     --risk "New module may need additional test coverage" \
     --storage-dir /tmp/hbn-readback-test

   Verify: JSON output with readback_id, hearback_status=pending.

4. Extract readback_id from step 3 output. Then run:
   usehbn hearback <readback_id> \
     --status confirmed \
     --notes "Reviewed. Proceed." \
     --storage-dir /tmp/hbn-readback-test

   Verify: Updated record with hearback_status=confirmed.

5. Verify files exist:
   - /tmp/hbn-readback-test/.usehbn/readbacks/<readback_id>.json
   - /tmp/hbn-readback-test/state/hbn-state.json contains readbacks array

========================================================================
REPORT
========================================================================
After ALL steps complete, create REPORT-READBACK.md with:

- Date and scope
- Files created (paths)
- Files modified (paths + description of change)
- Tests: total before (17), total after (34 expected)
- All existing tests: pass/fail
- All new tests: pass/fail
- CLI backward compatibility: verified/not verified
- Deviations from prompt (if any) and rationale
- Confirmation: "No existing behavior was modified.
  All changes are additive. engine.py was not touched."
========================================================================
```

---

## SYNTHESIS

This specification defines Semantic Readback as the sixth protocol layer of HBN, positioned between Guardian assessment and execution. Its core contribution is converting the uncontrolled space between intent and result into a governed, auditable protocol stage. The MVP is deliberately minimal: one schema, one module, two CLI subcommands, 17 tests. It introduces no external dependencies, modifies no existing pipeline logic, and preserves full backward compatibility. The data structures are designed to support future automated semantic validation without requiring architectural changes. The Codex prompt is structured for incremental, test-validated execution with zero regression risk.
