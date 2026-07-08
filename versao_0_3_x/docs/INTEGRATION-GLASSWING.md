# Integration: Glasswing-style preventive security

> Category A integration (per `docs/EVOLUTION-POLICY.md`). HBN composes
> with a Glasswing-inspired preventive security layer without absorbing
> it as core protocol.

## Context

In April 2026 Anthropic published [Project Glasswing](https://www.anthropic.com/glasswing)
and made [Claude Mythos Preview](https://red.anthropic.com/2026/mythos-preview/)
available to a small set of partners. Mythos discovered thousands of
zero-day vulnerabilities across major operating systems and browsers in
weeks. The risk profile changed: AI models can now find exploitable
flaws faster than humans can remediate.

For a public, source-available, AI-assisted project, this changes how
"safe execution" should be defined. HBN's existing layers (Truth
Barrier, Guardian) flag bad claims and risky intents. They do not yet
flag patterns that are exploitable by hostile users of public code.

This document defines a Glasswing-style preventive layer that HBN
projects can adopt to close that gap, **without** changing HBN core.

## What this layer is

A locally enforceable checklist of N domain-specific preventive checks
(N typically 3-7), expressed as:

- a list of vectors (G1, G2, ..., Gn)
- a verification command per vector
- a violation policy (block onda close on `VIOLATED`)

The list is project-specific. The structure is portable.

## Reference instantiation: Credenciamento V12.0.0203

The Credenciamento project (a Brazilian municipal VBA system) defines
6 vectors:

| Vector | Description |
|---|---|
| G1 | No untrusted disposable macros in the import package root |
| G2 | All `CONFIG` reads pass type+range validation before producing behavior |
| G3 | Privileged formulas isolated to specific tab prefixes with expiration |
| G4 | `AUDIT_LOG` is append-only — no `Range.Delete`/`Range.Clear` outside authenticated path |
| G5 | Claims without evidence (`100%`, `zero risk`, `totally secure`) are blocked |
| G6 | Product code in AI chat response is blocked — file delivery only (added 2026-04-28 after real violation) |

Each vector has a verification command in
`local-ai/scripts/glasswing-checks.sh` (project-local). Output `OK G1..Gn`
gates onda close.

## How to define your own vectors

For your project, pick 3-7 vectors that are specific to your domain.
Examples for other project types:

| Project type | Likely vectors |
|---|---|
| Web app with auth | session fixation, CSRF coverage, input sanitization, rate limiting, audit log integrity |
| Data pipeline | PII handling, schema drift, secret leakage, idempotency, audit log integrity |
| Mobile app | secure storage, network pinning, deep link validation, third-party SDK audit, build signing |
| Internal tooling | privilege escalation paths, log tampering, config validation, secrets in code, dependency freshness |

Document them in `<project>/docs/GLASSWING-VECTORS.md` (or equivalent),
with one paragraph per vector and a verification command.

## How HBN composes

HBN readbacks for safe_track work include a `glasswing_checks` block:

```json
{
  "glasswing_checks": {
    "G1_<name>": "ok | violated | not_applicable",
    "G2_<name>": "ok | violated | not_applicable",
    ...
  }
}
```

Hearback `confirmed` is conditional on all checks being `ok` or
`not_applicable`. A `violated` flag forces a fix-then-readback cycle.

## Out of scope

- HBN does not provide automatic vulnerability scanning.
- HBN does not run Mythos-class models.
- HBN does not commit projects to specific verification tooling.

## Reference

- Project Glasswing: https://www.anthropic.com/glasswing
- Claude Mythos Preview: https://red.anthropic.com/2026/mythos-preview/
- Credenciamento case study: `docs/CASE-STUDY-CREDENCIAMENTO.md`
