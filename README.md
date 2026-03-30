# HBN — Human Brain Net

Created by Luis Mauricio Junqueira Zanin

HBN is an open protocol for safe, structured, and evolvable AI-assisted software engineering.

HBN starts from a simple discipline: AI-assisted work should remain legible, reviewable, and governable by humans. Intent should be explicit. Validation expectations should be visible. Safety-related uncertainty should not disappear behind convenience.

This repository is not a hosted orchestration platform. It is the local, inspectable runtime and documentation base for an operable HBN scaffold that can now also generate repository-local runtime adapters.

## What HBN Is

HBN is a protocol and working language for AI-assisted software engineering. In this repository it currently provides:

- semantic activation through `usehbn` and `use hbn`
- structured intent capture
- local consent capture
- truth barrier warnings
- guardian warnings
- semantic readback and hearback gating
- ERP result recording
- JSON-backed execution traceability
- repository-local protocol initialization via `.hbn/`

## Why HBN Exists

AI-assisted engineering often fails in the same way: a request sounds clear, but objectives, constraints, risks, review conditions, and implementation boundaries remain implicit. That ambiguity becomes drift, overconfidence, and hidden responsibility transfer.

HBN exists to counter that drift with protocol structure instead of autonomy claims.

## What Problem HBN Solves

HBN makes AI-assisted engineering work more explicit by recording:

- what was requested
- what the executor understood
- what must remain invariant
- what validation is missing
- what was actually done
- what requires human confirmation before execution

## What HBN Is Not

HBN is not:

- a product
- a framework
- a hosted platform
- a background agent system
- a distributed execution engine
- a token economy
- an AGI claim
- a replacement for human review

## Command

Use HBN

HBN has three related command layers:

- semantic trigger: `usehbn` or `use hbn` inside a sentence
- operational CLI: `hbn`
- local bootstrap script: `get-hbn`

Canonical semantic references:

- `usehbn`
- `use hbn`
- `usehbn.com`
- `usehbn.org`

The semantic trigger is case-insensitive and can appear inside longer text. The operational CLI is installed locally and currently exposes `hbn` as the primary entry point and `usehbn` as a compatibility alias.
The domains are treated as canonical semantic references for the protocol identity. In the current system, adapters and documentation should normalize them to HBN semantics without assuming that browsing is required.

## Installation

Bootstrap install:

```bash
./get-hbn
```

This script creates or reuses a local `.venv/` and writes deterministic local `hbn` and `usehbn` wrappers against the checked-out source tree.

Development install:

```bash
python3 -m pip install -e .
```

Build-system metadata is now declared through `pyproject.toml` with setuptools.

Verify the CLI:

```bash
hbn version
```

If `hbn` or `usehbn` is not on your shell `PATH`, use one of:

```bash
.venv/bin/hbn version
python3 -m usehbn version
```

On older `pip`/setuptools combinations, editable install may still depend on legacy behavior. In those cases, prefer `./get-hbn` for local bootstrapping because it does not depend on a package index or wheel tooling.

## How To Use

Initialize HBN protocol state in a target repository:

```bash
hbn init
```

Inspect the current protocol state:

```bash
hbn inspect --target .
```

Run the protocol on a sentence:

```bash
hbn run "use hbn analyze this system"
```

Generate a runtime adapter:

```bash
hbn install --runtime claude-code
```

Backward-compatible alias:

```bash
usehbn "use hbn analyze this system"
```

Each execution writes:

- a structured execution log to `logs/`
- persistent state to `state/hbn-state.json`
- protocol-local coordination artifacts to `.hbn/` after `hbn init`

## Protocol Flow

The current local flow is:

1. Activation
2. Intent capture
3. Truth barrier
4. Guardian
5. Track classification
6. Readback
7. Hearback
8. Execution
9. ERP result

`safe_track` work requires readback plus hearback confirmation before ERP creation. `fast_track` work can remain lighter, but classification is still explicit.

## CLI Surface

```bash
hbn version
hbn init [--target <path>]
hbn inspect [--target <path>]
hbn install --runtime <claude-code|codex|copilot|cursor> [--target <path>]
hbn run "<sentence>"
hbn readback <exec_id> --agent-id <id> --intent-json <json> --understanding <text> --invariant <text> --plan-step <text>
hbn hearback <exec_id> --status confirmed
hbn result <exec_id> --agent-id <id> --action <text> --outcome <value> --human-status <value>
```

## Example Usage

Base execution:

```bash
hbn run "use hbn review the authentication flow and verify rollback coverage"
```

Readback for `safe_track` work:

```bash
hbn readback exec-001 \
  --agent-id codex \
  --intent-json '{"objective":"review auth","constraints":["no breaking changes"],"risks":["authentication regressions"],"validation_requirements":["run auth tests"]}' \
  --guardian-json '{"status":"warn","warnings":[{"code":"guardian-1","message":"Validation evidence is incomplete."}]}' \
  --understanding "The request is limited to review and incremental hardening." \
  --invariant "Public login API unchanged" \
  --plan-step "Inspect the current authentication flow" \
  --plan-step "List compatible incremental improvements" \
  --out-of-scope "Database schema migration" \
  --residual-risk "Some auth paths may lack automated coverage"
```

ERP after hearback confirmation:

```bash
hbn result exec-001 \
  --agent-id codex \
  --action "Recorded validated review outcome." \
  --outcome executed_with_risk \
  --human-status conditional \
  --readback-id readback-exec-001
```

## Project Structure

```text
usehbn/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── GOVERNANCE.md
├── ROADMAP.md
├── agents/
├── core/
├── docs/
├── examples/
├── reports/
├── schemas/
├── site/
├── src/usehbn/
├── tests/
└── .hbn/
```

Main areas:

- `src/usehbn/`: local runtime implementation
- `schemas/`: protocol contracts
- `core/`: protocol specifications
- `agents/`: repository agent rules
- `reports/`: historical implementation and audit artifacts
- `.hbn/`: active inter-IA coordination and knowledge for this repository
- `get-hbn`: local bootstrap helper for deterministic local installation
- `core/semantic-layer.md`: semantic normalization rules across natural language, commands, and adapters

## Governance

HBN is founder-led and review-based. Luis Mauricio Junqueira Zanin is the founder and initial protocol steward. Human review is the root of trust. Safety and protocol integrity take priority over acceleration.

See `GOVERNANCE.md` and `MAINTAINERS.md`.

## Contribution

Contributions are welcome when they improve protocol clarity, implementation discipline, documentation quality, traceability, or test coverage without weakening safety or governance rules.

Start with `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, and `SECURITY.md`.

## License

HBN is released under the GNU Affero General Public License v3.0.

AGPLv3 is used because HBN is intended to remain open and inspectable even when adapted into network-facing systems. Modified network-facing deployments must still make corresponding source available. That protects the protocol from disappearing behind closed operational layers.

See `LICENSE` and `docs/LICENSING.md`.

## What Works Today

The repository currently provides a real local runtime for:

- semantic trigger detection
- structured intent extraction
- local consent storage
- truth barrier and guardian warnings
- execution logging and JSON state persistence
- semantic readback with hearback gating
- ERP result recording linked to readbacks
- `hbn init` for repository-local protocol state
- `hbn inspect` for repository-local protocol inspection
- `hbn install` for runtime adapter file generation
- compatibility alias `usehbn`
- `.hbn/relay/` and `.hbn/knowledge/` as the basis for inter-IA continuity
- local bootstrap via `get-hbn`
- packaging metadata prepared through `pyproject.toml`

## What Does Not Work Yet

This repository does not yet provide:

- native execution inside Codex, Claude Code, Copilot, or Cursor without local adapter installation
- packaged distribution on PyPI
- multi-agent orchestration runtime
- SaaS or hosted coordination
- remote or one-command cross-platform installers

## Current Status

HBN is now beyond a documentation-only scaffold, but it is still early-stage. The present target is an honest L3-to-L4 transition: installable, inspectable, protocolized, traceable, and able to generate local adapter files for multiple AI runtimes. Public distribution, true runtime-native orchestration, and broader platform behavior remain future work.
