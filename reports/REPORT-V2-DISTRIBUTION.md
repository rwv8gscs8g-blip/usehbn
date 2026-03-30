# REPORT — V2 Distribution

**Date:** 2026-03-30  
**Scope:** phase 2 distribution, adapters, inspect, packaging, and release-document review

## What Was Implemented

- `hbn inspect` for local protocol-state and packaging inspection
- `hbn install --runtime <runtime>` for Claude Code, Codex, Copilot, and Cursor adapters
- `pyproject.toml` for modern build metadata bootstrap
- `get-hbn` as a deterministic local bootstrap script
- release documentation for publishing and runtime adapters
- version bump to `0.2.0`

## Packaging Decision

Current packaging posture:

- distribution name: `usehbn`
- primary CLI: `hbn`
- bootstrap script: `get-hbn`

This is intentional. Public publication should only proceed after validating package-name availability.

## Validation

### Tests

- `35 passed in 0.08s`

### Manual CLI Checks

- `./get-hbn`: passed
- `.venv/bin/hbn version`: passed
- `.venv/bin/hbn inspect --target .`: passed
- `.venv/bin/hbn install --runtime codex --target /tmp/usehbn-release-adapter`: passed
- `.venv/bin/usehbn "use hbn analyze this system"`: passed

## Release Notes

The repository is now prepared for local bootstrap, local inspection, and adapter generation. It is not yet claiming public package publication or native runtime integration.

## Remaining Gate Before Public Publishing

- validate public package name strategy
- decide release channel and publication target
- run final release checklist using `docs/PUBLISHING.md`
