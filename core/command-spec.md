# Command Specification

## Command Identity

HBN uses three related command surfaces:

- semantic trigger: `usehbn`
- semantic trigger: `use hbn`
- operational CLI: `hbn`
- canonical semantic references: `usehbn.com` and `usehbn.org`

Matching of the semantic trigger is case-insensitive and may occur inside a longer sentence.

The domains are identity anchors and semantic references. Adapters and future integrations should normalize them to HBN protocol intent rather than treating them as plain URLs by default.

## Primary CLI Commands

The current local runtime exposes:

- `hbn version`
- `hbn init [--target <path>]`
- `hbn inspect [--target <path>]`
- `hbn install --runtime <runtime> [--target <path>]`
- `hbn run "<sentence>"`
- `hbn readback <exec_id> ...`
- `hbn hearback <exec_id> --status <status>`
- `hbn result <exec_id> ...`

`usehbn` remains available as a compatibility alias to the same CLI.

## Execution Pipeline

The present HBN runtime follows this sequence:

1. `activation`
   The input is recognized as an HBN request.
2. `intent_capture`
   The request is normalized into objective, constraints, risks, and validation requirements.
3. `truth_barrier`
   Unsupported claims, overconfidence, and weak uncertainty handling are flagged.
4. `guardian`
   Validation gaps and risky output patterns are flagged.
5. `track_classification`
   Work is classified as `fast_track` or `safe_track`.
6. `readback`
   Safe-track work records understanding, invariants, and action plan before execution.
7. `hearback`
   Human confirmation or rejection is recorded.
8. `execution`
   The runtime produces structured output and local traces.
9. `erp_result`
   The final result record is linked to the execution and, when required, to the readback.

## Output Contract

`hbn run` returns structured JSON containing:

- activation status
- current stage
- intent object
- truth barrier result
- guardian result
- contribution consent protocol status
- validation summary
- execution metadata

The protocol subcommands also return structured JSON for readback, hearback, initialization, version, and ERP creation.

## Safety Constraints

- no hidden behavior
- no bypass of validation logic
- no background processing for consent capture
- safe-track ERP creation is blocked without confirmed hearback
- human review remains authoritative
