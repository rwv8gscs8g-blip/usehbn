# Execution Decision

## Status

Approved by human review on 2026-04-01.

This document separates:

- the current executable delivery track for HBN
- the longer-horizon research and architecture track

The goal is to prevent the repository from mixing near-term delivery work with
speculative protocol expansion.

## Source Hierarchy

When these sources disagree, use this order of authority:

1. the real repository state and passing tests
2. the current runtime and CLI behavior
3. the operational roadmap in `ROADMAP.md`
4. architectural vision documents

This means HBN does not implement a capability just because a vision document
describes it. It becomes real only after it exists in code, docs, tests, and
validated workflow.

## Approved Interpretation Of Recent External Analyses

### Deep Vision Spec (`v0.3`)

The external `HBN v0.3 — Deep Vision Specification` is approved as:

- a research and architecture document
- a direction-setting artifact
- a source of candidate concepts for future protocol evolution

It is **not** approved as an immediate implementation backlog.

Nothing from that document should be treated as shipped protocol behavior unless
it is explicitly implemented, documented, and tested in this repository.

### Friction Reduction / Maturity Analysis

The external maturity and friction analysis is approved as:

- a valid description of the current operating stage
- a useful prioritization aid
- an implementation-oriented guide for near-term delivery

Its actionable recommendations should only be adopted incrementally and remain
subject to normal HBN review discipline.

## Current Delivery Track

HBN is currently treated as a hardened `0.2.x` runtime.

The short-term execution track is limited to:

- distribution hardening
- onboarding friction reduction
- adapter refresh ergonomics
- relay continuity ergonomics
- better repository-state and environment diagnostics

## Three-Block Execution Plan

### Block 1: Immediate Delivery

Focus on public usability and distribution:

- validate package publication path
- publish to TestPyPI / PyPI when approved
- keep `pip install usehbn` as the primary low-friction install path
- prepare the minimal remote bootstrap path after package publication

### Block 2: Operational Ergonomics

Focus on lowering adoption friction without expanding protocol scope:

- improve target-repository onboarding
- improve adapter refresh workflow
- add relay query/search
- strengthen `hbn inspect` and related repository health diagnostics

### Block 3: Research Track (`v0.3`)

Keep these items in research until explicitly selected:

- richer intent decomposition beyond the current runtime
- expanded truth-barrier taxonomy
- stronger guardian / risk taxonomy evolution
- legacy translation/stabilization framework
- deeper multi-agent execution tiers

## Non-Goals For The Current Delivery Track

The following are explicitly out of scope for immediate implementation:

- full `v0.3` architecture rollout
- autonomous orchestration claims
- hidden background processes
- hosted coordination platform features
- protocol expansion that outruns current tests and runtime maturity

## Release Discipline

Before any new capability is treated as part of the real protocol:

1. it must exist in code
2. it must be documented
3. it must have tests or equivalent validation
4. it must fit the current delivery track or be explicitly promoted from the research track

## Practical Reading

If a contributor needs to decide what to work on next:

- use `ROADMAP.md` for delivery sequencing
- use this document for scope boundaries
- use `docs/VISION.md` for long-term intent

