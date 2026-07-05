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

Around those layers, the current runtime now also includes a connector contract
layer for the universal translator. That layer decides:

- whether an existing bridge can be assumed immediately
- whether HBN must ask for approval before discovery/build
- whether manual environment input should be offered
- which privacy and remote-resolution constraints apply

These layers are intentionally small so that protocol meaning remains visible in code and documentation.

## Runtime Flow

1. A sentence is received by the trigger detector.
2. If `usehbn` or `use hbn` appears, HBN activates.
3. The runtime captures a structured intent with objective, constraints, risks, and validation requirements.
4. The truth barrier checks for overconfidence, unsupported claims, and missing uncertainty in risky contexts.
5. The guardian layer aggregates warnings and records them locally when appropriate.
6. The Contribution Consent Protocol can ask an explicit question and store a local JSON record if consent is granted.

## Components

Component state is governed by `docs/MATURITY-MATRIX.md`. If this architecture
document and the matrix ever diverge, the matrix is the canonical source for
what is Implementado, Parcial, Scaffold, Stub, or Visao in v0.3.0.

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
- `connectors/contracts.py`
  Produces the explicit operating contract for bridge activation, discovery, manual entry, and privacy.

## Current Non-Goals

This release does not provide:

- distributed compute execution
- hidden background agents
- autonomous deployment behavior
- formal verification
- claims of comprehensive safety
- semantic translation between human languages or between technologies
- executable legacy bridge generation
- connector lifecycle enforcement or automatic connector verification

These limits follow `docs/MATURITY-MATRIX.md`: Universal Translator is
Scaffold, legacy bridge generation and connector verify are Stub, and
Phagocytosis plus connector lifecycle are still Visao in v0.3.0.

## Truth Barrier e Guardian: estado atual e direção

Truth Barrier and Guardian are Parcial and advisory in v0.3.0. They emit and
record warnings that deserve human attention, but the current engine does not
block execution because of those warnings.

`docs/rfc/RFC-0001-enforce-mode.md` is open for human comment and targets
v0.4.0. It documents a possible opt-in `--enforce` path, but it does not
authorize implementation or default blocking in v0.3.0.

## Storage Model

This release stores only local artifacts:

- consent records in `.usehbn/consents/`
- guardian warnings in `.usehbn/logs/guardian.jsonl`

There is no hidden processing, remote worker, distributed runtime, or background execution loop in this codebase.
