# Report

## Diagnostic Report

### Current structure

Before this pass, the repository already contained:

- a working Python protocol scaffold under `src/usehbn/`
- governance and community documents at the repository root
- a detailed but mostly uppercase documentation set under `docs/`
- tests and schemas

### Problems identified

- the repository did not yet expose the requested `/core`, `/site`, `/examples`, and expanded `/agents` structure
- the documentation set was credible but not yet organized into a simple front-door information architecture
- there was no GitHub Pages-compatible landing page
- agent operating rules were not yet formalized inside the repository

### Missing components

- repository-wide agent operating system
- formal protocol entry points under `/core`
- examples for usage and prompts
- a minimal public landing page
- a final report connecting diagnosis, decisions, and next steps

### Opportunities for improvement

- create a clearer documentation path for new readers
- separate protocol definition from supporting explanation
- add a static landing page that works without tooling
- make agent behavior a first-class repository concern

## What Was Done

- created `agents/agents.md` as the permanent operating contract for AI agents
- added curated docs entry points in `docs/vision.md`, `docs/principles.md`, `docs/how-it-works.md`, and `docs/roadmap.md`
- added formal protocol files in `core/protocol.md`, `core/command-spec.md`, and `core/validation-rules.md`
- added examples in `examples/usage-examples.md` and `examples/prompt-samples.md`
- added agent guidance in `agents/codex.md`, `agents/claude.md`, and `agents/safety.md`
- created a GitHub Pages-compatible landing page in `site/index.html` and `site/styles.css`
- updated `README.md` to reflect the broader structure and purpose of the repository
- updated `CHANGELOG.md` to track this structural refinement
- implemented a minimal execution engine that extends the CLI
- added execution logs in `logs/`
- added a JSON persistence layer in `state/hbn-state.json`

## Why Decisions Were Made

- additive changes were preferred over renames so existing content and references would not break
- the new lowercase docs provide a simpler entry point while preserving the earlier detailed documents
- the landing page uses plain HTML and CSS to stay portable and GitHub Pages compatible
- agent rules were written into the repository first so every further change could follow a documented contract
- JSON persistence was chosen over SQLite to keep the state layer explicit, minimal, and easy to inspect
- the execution engine was separated from the CLI so protocol execution can evolve without coupling all logic to argument parsing

## What Should Be Done Next

1. decide whether GitHub Pages should publish from `/site` directly or through a Pages-specific branch or setting
2. add more formal protocol versioning rules under `/core`
3. expand examples to cover repository review, modernization, and release workflows
4. decide how future SaaS-specific materials should be separated from the protocol specification
5. evaluate whether the JSON state layer should later migrate to SQLite once query and concurrency needs become real
