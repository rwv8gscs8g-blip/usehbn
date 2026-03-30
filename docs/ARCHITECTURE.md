# Architecture

## Position

HBN is a protocol-first repository. The runtime included here is a minimal implementation scaffold for the protocol, not a full execution engine.

## Protocol Layers

The current architecture is organized into five protocol layers:

1. activation
2. intent structuring
3. contribution consent
4. truth barrier
5. guardian monitoring

These layers are intentionally small so that protocol meaning remains visible in code and documentation.

## Runtime Flow

1. A sentence is received by the trigger detector.
2. If `usehbn` or `use hbn` appears, HBN activates.
3. The runtime captures a structured intent with objective, constraints, risks, and validation requirements.
4. The truth barrier checks for overconfidence, unsupported claims, and missing uncertainty in risky contexts.
5. The guardian layer aggregates warnings and records them locally when appropriate.
6. The Contribution Consent Protocol can ask an explicit question and store a local JSON record if consent is granted.

## Components

- `trigger.py`
  Detects case-insensitive semantic activation.
- `protocol/intent.py`
  Produces the initial structured intent object.
- `protocol/consent.py`
  Creates local consent records with no background processing.
- `protocol/truth_barrier.py`
  Flags claim-quality issues that deserve human attention.
- `protocol/guardian.py`
  Detects validation gaps and risk-sensitive outputs, then logs warnings locally.
- `bridge/vba.py`
  Describes how HBN concepts can be applied to Excel/VBA systems without automating them.

## Storage Model

This release stores only local artifacts:

- consent records in `.usehbn/consents/`
- guardian warnings in `.usehbn/logs/guardian.jsonl`

There is no hidden processing, remote worker, distributed runtime, or background execution loop in this codebase.

## Current Non-Goals

This release does not provide:

- distributed compute execution
- hidden background agents
- autonomous deployment behavior
- formal verification
- claims of comprehensive safety
