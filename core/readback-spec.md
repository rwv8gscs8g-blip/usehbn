# Semantic Readback Specification

## Purpose

Semantic Readback is the HBN contract that captures what the executor believes it is about to do before a risky or constrained execution moves forward.

It exists to reduce silent drift between:

- the original human intent
- the executor's interpretation
- the actual implementation path

## Required Fields

Every readback record must contain:

- `readback_id`
- `execution_id`
- `agent_id`
- `track`
- `hearback_status`
- `understanding`
- `invariants_preserved`
- `action_plan`
- `classification_basis`
- `created_at`

## Semantic Meaning

`understanding`
: Plain-language statement of what the executor believes the work means.

`invariants_preserved`
: Things that must not change during the execution. This is the primary guard against accidental regression or scope drift.

`action_plan`
: The concrete planned steps the executor intends to take.

`out_of_scope`
: Optional boundaries that explicitly exclude work from the current cycle.

`residual_risks`
: Optional risks that remain acknowledged even after readback is complete.

## Track Classification

HBN currently classifies work as:

- `fast_track`
- `safe_track`

`safe_track` is required when any of the following are present:

- guardian warnings
- explicit intent risks
- explicit intent constraints

## Hearback

The readback remains incomplete until hearback is recorded:

- `pending`
- `confirmed`
- `rejected`

If a readback exists and hearback is not `confirmed`, ERP creation must fail with an explicit protocol violation.

## ERP Link

If the execution is `safe_track`, ERP creation must include the matching `readback_id`.

## Non-Goals

Semantic Readback is not:

- a hidden reasoning engine
- an autonomous planner
- a substitute for human approval
- a guarantee that implementation is correct
