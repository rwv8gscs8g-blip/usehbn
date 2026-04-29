# Changelog

All notable changes to HBN will be documented in this file.

## Unreleased

- Add `docs/EVOLUTION-POLICY.md` — formal contract for incorporating
  external protocols (categories A/B/C, hard limits, versioning rules)
- Add `docs/INTEGRATION-DIATAXIS.md` — category A integration with the
  Diataxis documentation framework
- Add `docs/INTEGRATION-LLMS-TXT.md` — category A integration with the
  llms.txt standard for LLM-readable navigation
- Add `docs/INTEGRATION-AGENTS-MD.md` — category A integration with the
  agents.md format for unified agent contracts
- Add `docs/INTEGRATION-GLASSWING.md` — category A integration of a
  Glasswing-style preventive security layer (5 domain-specific vectors,
  composing with Truth Barrier and Guardian)
- Add `docs/CASE-STUDY-CREDENCIAMENTO.md` — first production-scale
  composition of HBN with Diataxis, llms.txt, AGENTS.md, and Glasswing,
  documented from the Brazilian municipal Credenciamento project
- Add explicit execution governance separating the hardened `0.2.x` delivery track from the `v0.3` research track
- Add `docs/EXECUTION-DECISION.md` to define source-of-truth order, scope boundaries, and the approved three-block execution plan

- Add `hbn relay status` for structured baton ownership and active iteration visibility
- Add `hbn handoff --to <agent> --summary <text>` for validated relay baton transfer with pending-readback gate and automatic archive of resolved relay files
- Add `hbn refresh` for batch refresh of all installed runtime adapters in a target
- Add `hbn init --runtime auto|<runtime>` for auto-detection of AI runtime from environment signals during initialization
- Add `hbn hearback --last --status <status>` convenience for confirming the most recent pending readback without needing to copy exec_id
- Add `hbn result --env-key key=value` for capturing environment conditions in ERP records
- Add optional `environment` field to `result.schema.json` for machine-readable diagnostic context
- Add self-describing fallback section to adapter body so adapters work in degraded mode without CLI
- Add `.gitignore` suggestions during `hbn init` for ephemeral protocol artifacts
- Add `.hbn/relay/state.json` as structured relay state file for baton tracking
- Prepare public packaging via `pyproject.toml`
- Add `hbn inspect` for local protocol-state inspection
- Add `hbn install --runtime <runtime>` for runtime adapter generation
- Add local bootstrap script `get-hbn`
- Add runtime adapter support for Claude Code, Codex, Copilot, and Cursor

## v0.2.0

- Added the primary `hbn` CLI entry point while keeping `usehbn` as a compatibility alias
- Added `hbn init`, `hbn run`, and `hbn version`
- Added semantic readback fields for understanding, invariants, action plan, out-of-scope items, and residual risks
- Added repository-local `.hbn/` initialization for relay and knowledge artifacts
- Reorganized implementation and audit documents under `reports/`
- Updated the README and protocol specs to reflect the real local runtime
- Added `agents/agents.md` as the repository-wide operating contract for AI agents
- Added curated documentation entry points under `docs/`
- Added formal protocol documents under `core/`
- Added GitHub Pages-compatible landing page files under `site/`
- Added examples and prompt samples under `examples/`
- Added `REPORT.md` with diagnostic summary, decisions, and next steps
- Added a minimal execution engine that extends the CLI with explicit execution, validation, and structured output
- Added JSON execution logs under `logs/`
- Added a JSON state layer for executions, decisions, and context history under `state/`

## v0.1.0

- Initial public release
- Protocol scaffold
- CLI
- Intent structure
- Consent system
- Documentation
