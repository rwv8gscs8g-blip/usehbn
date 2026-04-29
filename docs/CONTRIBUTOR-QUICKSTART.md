# Contributor Quickstart

## Goal

This is the shortest contributor path that still keeps HBN legible and safe.

## Local Setup

From the repository root:

```bash
python3 -m venv .venv
. .venv/bin/activate
python3 -m pip install -e .
hbn version
```

If editable install is inconvenient in your environment, use:

```bash
./get-hbn
```

## First Safe Validation

Create a disposable sandbox instead of starting in a real project:

```bash
hbn quickstart --target /tmp/hbn-sandbox --runtime auto
hbn doctor --target /tmp/hbn-sandbox
hbn inspect --target /tmp/hbn-sandbox
```

## Runtime Adapters

If `doctor` detects a runtime but no adapter is installed, follow the suggested
command, for example:

```bash
hbn install --runtime codex --target /tmp/hbn-sandbox
```

## Local Development Checks

Run the test suite:

```bash
python -m pytest tests -q
```

Build local distributions when touching packaging or onboarding:

```bash
python -m build --no-isolation
```

## High-Value Contribution Areas

- onboarding and installation ergonomics
- runtime adapter generation and refresh
- relay continuity and handoff safety
- documentation clarity
- packaging and distribution hardening
- tests that reduce ambiguity or regressions

## Current Boundaries

Contributors should assume:

- HBN is a hardened `0.2.x` runtime
- `v0.3` remains a research and architecture track
- human review remains the root of trust
- no hidden deployment or autonomous execution is expected

## Before Opening Public-Facing Claims

Do not present HBN as broadly distributed until the PyPI and remote-installer
work is complete. For now, the correct framing is:

- local runtime
- controlled disclosure
- contributor-ready hardening phase
