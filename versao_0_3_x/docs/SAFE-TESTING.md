# Safe Testing

## Purpose

This document describes the safest way for a new person to try HBN locally
without touching production systems, deploying code, or depending on hidden
automation.

## What Is Safe

The following workflow is local-only:

```bash
hbn quickstart --target /tmp/hbn-sandbox --runtime auto
hbn doctor --target /tmp/hbn-sandbox
hbn inspect --target /tmp/hbn-sandbox
```

This flow:

- creates a disposable local target
- initializes `.hbn/`
- installs a runtime adapter when a runtime can be detected
- writes only local protocol artifacts
- does not deploy
- does not publish
- does not contact production infrastructure

## Recommended First Run

1. Verify the CLI:

```bash
hbn version
```

2. Create a disposable sandbox:

```bash
hbn quickstart --target /tmp/hbn-sandbox --runtime auto
```

3. Diagnose the sandbox state:

```bash
hbn doctor --target /tmp/hbn-sandbox
```

4. Inspect the created protocol tree:

```bash
hbn inspect --target /tmp/hbn-sandbox
```

5. Run a harmless protocol sentence:

```bash
hbn run "use hbn analyze this system"
```

## Files Written During Safe Testing

Inside the target, HBN may create:

- `.hbn/manifest.json`
- `.hbn/state.json`
- `.hbn/attention.json`
- `.hbn/relay/`
- `.hbn/relay-archive/`
- `.hbn/knowledge/`
- `.hbn/reports/`
- runtime adapter files such as `.claude/commands/hbn.md` or `skills/hbn/SKILL.md`

Outside the target, `hbn run`, `hbn readback`, and `hbn result` may also use
the local storage directory you point them to explicitly.

## What Safe Testing Does Not Prove Yet

This workflow validates:

- local CLI installation
- local protocol state creation
- adapter generation
- basic onboarding ergonomics

It does not by itself prove:

- PyPI publication
- remote installer reliability
- runtime-native integrations
- production deployment workflows

## If `doctor` Returns Warnings

- `needs_setup`: initialize or rerun `quickstart`
- `attention_needed`: follow the returned `next_steps`
- pending readbacks: confirm with `hbn hearback --last --status confirmed`
- no adapter installed: run the recommended `hbn install --runtime ...`

## Public Evaluation Guidance

For external testers, prefer a disposable directory such as `/tmp/hbn-sandbox`
or a throwaway git repository. Do not point first-time evaluation at a
production repository.
