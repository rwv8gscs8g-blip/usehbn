# HBN Evolution Policy

> How HBN incorporates new protocols and standards openly, deliberately,
> and reversibly.

## Why this policy exists

HBN is a protocol layer. Protocol layers are useful exactly to the extent
that they remain stable and predictable. But the AI-assisted engineering
ecosystem is moving fast, and good ideas (Diataxis, llms.txt, AGENTS.md,
Glasswing-style preventive security, future RAG conventions) deserve a
clear path into HBN — without diluting protocol identity.

This document is the contract for that path.

## Three categories of incorporation

HBN absorbs external protocols in one of three modes:

### A. Adopted as integration (recommended default)

The external protocol stays an external protocol. HBN provides a
documented integration path showing how to use both together. No HBN
spec is rewritten. Examples added in 2026-04: Diataxis, llms.txt,
AGENTS.md, Glasswing-style preventive security.

Triggers:

- Protocol has independent maintainer and authority
- HBN benefits from interoperability without claiming ownership
- Adoption is mostly reversible by removing one integration document

Process:

1. Author proposes integration in `docs/INTEGRATION-<NAME>.md`.
2. Document covers: what the external protocol is, how HBN composes
   with it, what does NOT need to change in HBN to support it, and a
   minimal example.
3. Add an entry to `README.md` under "Adopted External Protocols".
4. Add a `relay/` entry referencing the integration when used in a
   cycle.

No HBN core change. No new HBN concept. Just a documented bridge.

### B. Absorbed as protocol concept (deliberate, slow)

A concept from outside is absorbed as part of HBN's own surface — for
example, if a future RAG standard becomes universally adopted and
HBN should expose a `hbn rag` subcommand.

Triggers:

- Concept is durable across model generations
- Existing HBN users would benefit from native exposure
- Absorption can be done without contradicting existing protocol

Process:

1. Reflective pass: write `reports/REPORT-ABSORB-<NAME>.md` listing
   pros, cons, alternatives, and exit criteria.
2. Open issue with at least 30-day comment window.
3. Maintainer review per `MAINTAINERS.md`.
4. New core spec under `core/<concept>.md`.
5. Schema and CLI surface updated together.
6. Release notes call out the absorption explicitly.

### C. Rejected with rationale

Some protocols are not absorbable into HBN without weakening HBN. Those
get a `docs/REJECTED-<NAME>.md` document explaining why, so contributors
know the decision was deliberate, not an oversight.

## Hard limits (non-negotiable)

Regardless of category, HBN does NOT:

- Remove human authority as the root of trust.
- Add hidden behavior.
- Lower the threshold for safe-track work.
- Replace explicit readback with implicit inference.
- Couple HBN to any single AI model, runtime, or vendor.

If an external protocol requires any of the above, it goes to category C
(rejected).

## Versioning

Integration documents (category A) do not bump HBN's version. They are
additive context.

Absorbed concepts (category B) bump the minor version. The CHANGELOG
records the absorption with link to the corresponding `report-absorb`.

## Case study: Credenciamento (V12.0.0203)

The Credenciamento project (`https://github.com/...`) is the first
production-scale demonstration of category A integration. It composes:

- HBN (core: relay + readback + truth barrier + guardian)
- Diataxis (docs/ structure for humans)
- llms.txt + AGENTS.md (machine-readable navigation)
- Glasswing-style preventive security (5 vectors, locally enforced)

See `docs/CASE-STUDY-CREDENCIAMENTO.md` for the full integration map.

## How to propose a new incorporation

1. Open an issue titled `[evolution] propose <category-A|B|C> for <protocol>`.
2. Reference this document.
3. Wait for maintainer triage before drafting the integration document.

This keeps HBN evolvable without being faddish.
