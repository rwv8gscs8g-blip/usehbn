# Changelog

All notable changes to HBN will be documented in this file.

## Unreleased

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
