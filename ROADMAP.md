# Roadmap

## Current release: 0.2.x hardened runtime

- ✅ stabilized protocol vocabulary and CLI semantics
- ✅ `hbn` and `usehbn` aligned without hidden behavior
- ✅ validated local runtime adapter generation for Claude Code, Codex, Copilot, and Cursor
- ✅ hardened local bootstrap behavior through `get-hbn`
- ✅ matured `.hbn/` as the local continuity layer with relay, knowledge, reports, readbacks, and results
- ✅ added `hbn relay status` and `hbn handoff` for structured baton tracking and validated handoff
- ✅ added `hbn refresh` for batch adapter refresh
- ✅ added `hbn init --runtime auto` for environment-based runtime detection
- ✅ added `hbn hearback --last` for ergonomic readback confirmation
- ✅ added `environment` field to ERP for machine-readable diagnostic context
- ✅ added self-describing fallback to adapter body for degraded CLI-less operation
- clean sdist and wheel build verified — ready for publication review

## Delivery Track

The active execution track is deliberately narrow. HBN is currently being
treated as a hardened `0.2.x` runtime, not as a full `v0.3` implementation.

See `docs/EXECUTION-DECISION.md` for the governing distinction between
immediate delivery and research.

### Block 1: Immediate Delivery

- publish to TestPyPI and then PyPI after package-name validation
- keep `pip install usehbn` as the main low-friction install path
- create a minimal remote bootstrap script for `curl | sh` installation after
  package publication

### Block 2: Operational Ergonomics

- add `hbn relay query <keyword>` for knowledge and reports search
- evolve `hbn inspect` into a richer repository health command
- expand tests around edge cases, schemas, and protocol guards
- formalize protocol versioning and release gates

### Block 3: Research Track (`v0.3`)

- improve intent extraction quality
- define a stronger risk taxonomy for the truth barrier and guardian layers
- move from adapter generation to deeper runtime-native integration
- internationalization of section labels beyond Portuguese

## Explicit non-goals for the near term

- distributed compute execution
- background agents or hidden processes
- token economy features
- AGI positioning
- exaggerated security guarantees
