# Roadmap

## Current release: 0.2.x local runtime and adapter foundation

- stabilize protocol vocabulary and CLI semantics
- keep `hbn` and `usehbn` aligned without hidden behavior
- improve intent extraction quality
- expand tests around edge cases, schemas, and protocol guards
- mature `.hbn/` as the local continuity layer for repositories and inter-IA handoff
- validate local runtime adapter generation for Claude Code, Codex, Copilot, and Cursor
- harden local bootstrap behavior through `get-hbn`
- prepare publication workflow without claiming PyPI availability before validation

## Next protocol milestones

- formalize protocol versioning and release gates
- add richer language examples and compatibility notes
- define a stronger risk taxonomy for the truth barrier and guardian layers
- publish reference documents for protocol change proposals
- improve local auditability of consent and guardian events
- publish to PyPI after package-name validation
- evolve `hbn inspect` into a richer repository health command
- move from adapter generation to deeper runtime-native integration

## Explicit non-goals for the near term

- distributed compute execution
- background agents or hidden processes
- token economy features
- AGI positioning
- exaggerated security guarantees
