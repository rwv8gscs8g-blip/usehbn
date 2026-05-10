# AGENTS.md — useHBN

> Single agent contract file at the repository root, per the
> [agents.md](https://agents.md) Category A integration adopted by
> useHBN ([`docs/INTEGRATION-AGENTS-MD.md`](docs/INTEGRATION-AGENTS-MD.md)).
> This file is the entry point for any AI operating in this repository.
> Granular per-IA contracts live in [`agents/`](agents/) and are
> referenced from here.

## Project identity

- **Name:** useHBN — Human Brain Net.
- **Status:** open protocol for safe, structured, evolvable AI-assisted software engineering. Pre-v1 (current working release: v0.3.0, "Honest Foundation").
- **Repository:** `~/Projetos/usehbn/` (local canonical) → public mirror to be published per `methodology/adr/ADR-005-licenciamento-apache-cla.md`.
- **License:** Apache License, Version 2.0 (see `LICENSE`). Migrated from AGPLv3 on 2026-05-10 — see `CHANGELOG.md` and `methodology/adr/ADR-005-licenciamento-apache-cla.md`.
- **Contributor agreement:** Developer Certificate of Origin (DCO). Use `git commit -s`. See `CONTRIBUTING.md`.
- **Maturity reference:** [`docs/MATURITY-MATRIX.md`](docs/MATURITY-MATRIX.md) — single source of truth for what works, what is partial, what is vision. No public claim may exceed it.

## Typology (per ADR-002)

| Term | Meaning | Where in this ecosystem |
|---|---|---|
| **Founding Application** | Application where the protocol patterns were discovered empirically. Historical status, not technical. Single per protocol. | Credenciamento (`~/Projetos/Credenciamento/`) — fundição onde o HBN foi forjado; hoje é apenas seu primeiro consumidor |
| **Consuming Application** | Application that consumes the protocol as a dependency via `.usehbn-snapshot/` read-only mirror. Technical status, current and future. | Credenciamento (post-v204 final, per ADR-008) plus future apps |
| **Reference Implementation** | Canonical code base materializing the protocol. | To be built in `examples/` (future) |
| **Protocol Specification** | Normative spec. | `modules/` (per ADR-003 — populated progressively via Onda Documental Sanitization) |
| **NOT a module** | Forbidden status. | Credenciamento NEVER receives this label |

## Constitutional principles (P1-P13)

The 13 constitutional principles of useHBN have **identical normative
weight**. Source of truth:
[`methodology/PRINCIPIOS-CONSTITUCIONAIS.md`](methodology/PRINCIPIOS-CONSTITUCIONAIS.md).
Per ADR-009, mudança em qualquer P1-P13 exige cross-IA com ≥2 IAs +
decisão humana + cápsula de auditoria + append-only + bump SemVer
MAJOR. Cadência de revisão: anual.

Quick reference:

- **P1** Preservar antes de transformar
- **P2** Documentar antes de executar
- **P3** Testar antes de refatorar
- **P4** Explicar antes de automatizar
- **P5** Humano no controle por padrão
- **P6** Toda evolução deve ser reversível
- **P7** Nenhuma tecnologia fagocitada perde sua identidade
- **P8** O protocolo importa mais que a ferramenta
- **P9** Frameworks são descartáveis; princípios são permanentes
- **P10** Segurança e não-regressão > velocidade
- **P11** Minimalismo de Cadeia (🟦 HBN MINIMALIST GATE)
- **P12** Substrato Sólido (🟪 HBN SUBSTRATO GATE) — orienta o substrato futuro (Rust); **não invalida** o runtime Python v0.3.0
- **P13** AI-Language-Abstraction (🟧 HBN AI-ABSTRACTION GATE)

## Stack and topology (per ADR-003)

- **Runtime:** Python 3.9+ (`src/usehbn/`).
- **Tests:** pytest (`tests/`, currently 93/93 passing).
- **Schemas:** custom JSON-Schema validator (`schemas/`, 7 contracts).
- **Adapters:** 7 supported runtimes — Claude Code, Codex, ChatGPT, Gemini, Antigravity, Copilot, Cursor (`src/usehbn/runtime.py`).

Top-level structure (canonical partitions):

```
modules/         normative protocol specification (RFC-style; populated progressively)
methodology/     architecture, principles, ADRs, RFCs, primer, templates, study-plans
auditoria/       protocol meta-history (bootstrap, addenda, cross-IA outputs, MD specs)
radar/           technology phagocytosis tracking (standalone partition)
examples/        future Reference Implementation
core/            legacy partition; superseded by modules/ progressively (per ADR-003 §B)
docs/            legacy partition; pieces being migrated to modules/ + methodology/
schemas/, src/, tests/, agents/, .hbn/    runtime + coordination
```

## HBN signals (vocabulary every IA must use)

Core single-repo:
- ✅ **HBN ACTIVE** — operating normally.
- 🟡 **HBN NEEDS HUMAN DECISION** — blocked on a human decision.
- ❌ **HBN SECURITY BLOCKED SUGGESTION** — refuse for safety.
- 🔵 **HBN HANDOFF READY** — package ready for next actor.
- 🟣 **HBN PEER REVIEW** — requires cross-IA before merge.
- ⚪ **HBN AUDIT-ONLY** — read-only over a scope.
- 🟠 **HBN SOURCE DRIFT** — divergence between source and mirror.
- 🔴 **HBN RELEASE BLOCKER** — release-blocking issue.
- 🟢 **HBN CHECKPOINT CLEAN** — gate green.

Multi-repo (per ADR-006):
- 🌐 **HBN CROSS-REPO LOCK** — touching mirrored files; wait.
- ⛓️ **HBN PROTOCOL DEP CHANGE** — protocol bumped MAJOR/MINOR; consuming apps revise.
- 🧊 **HBN APP FROZEN** — consuming app in release window; do not touch.
- 🪞 **HBN MIRROR DRIFT** — `.usehbn-snapshot/` in an app diverged from canonical.
- ⏳ **HBN BILLING WINDOW DRIFT** — Quarta de Sanitização parameters need adjustment.
- 🔍 **HBN GROUPTHINK ALARM** — cross-IA convergence too high (`<10%` divergence) → bias risk.
- 🟤 **HBN LICENSE SPLIT REQUIRED** — license unification needed (resolved 2026-05-10 by ADR-005).

Every significant turn must open with at least one signal.

## Communication conventions

- Numbered lists with semicolons: `1) ... ; 2) ... ;` instead of Q1/Q2/Q3.
- Truth Barrier strict: claims like "100%", "guaranteed", "totally safe" are forbidden.
- Glasswing G6: product code does not go in chat; it goes into files in the repository (see [`docs/INTEGRATION-GLASSWING.md`](docs/INTEGRATION-GLASSWING.md)).
- Read-first: before writing, read the current state.
- All evolution operates via ADR (decisions) + MD (executions). See
  [`methodology/ADR-AND-MD-PRIMER.md`](methodology/ADR-AND-MD-PRIMER.md).

## Granular IA contracts

This file delegates to per-IA contracts under [`agents/`](agents/):

- [`agents/agents.md`](agents/agents.md) — repository-wide operating contract for AI agents.
- [`agents/claude.md`](agents/claude.md) — Claude variants (Code, API, Cowork, browser, Desktop).
- [`agents/codex.md`](agents/codex.md) — Codex CLI surgical-execution mode.
- [`agents/safety.md`](agents/safety.md) — safety expectations across all agents.
- [`agents/wave-protocol.md`](agents/wave-protocol.md) — wave/onda execution contract.

When in doubt about scope or behavior, the per-IA file in `agents/`
takes precedence for that IA, and `agents/agents.md` takes precedence
for cross-cutting matters.

## useHBN-version (declarative — for consuming applications)

Consuming applications (per ADR-002 + ADR-004) declare in their own
`AGENTS.md` root:

```yaml
useHBN-version: ^X.Y.Z
useHBN-snapshot-path: .usehbn-snapshot/
useHBN-snapshot-checksum: <SHA256 from PROTOCOL_SHA256.txt>
```

This is **declarative documentation in v0.3.0** (per ADR-002 §B).
Automatic validation via `hbn doctor --target <app>` enters once
[MD-I](auditoria/00_status/07_MD_I_SNAPSHOT_TOOLING.md) snapshot
tooling is implemented (post-v204 final). Until then, the field
guides IA readers but is not enforced by tooling.

This repository (the protocol itself) does **not** carry a
`useHBN-version` field — it **is** the protocol. The current canonical
versions:

```yaml
package_version: 0.3.0      # the Python CLI / PyPI artifact
protocol_version: 0.3.0     # the protocol contracts
```

Per ADR-004 v2 (MD-H), `package_version` and `protocol_version` are
**independent** constants and may diverge in future releases.

## Status of evolution (live)

- **Wave plan:** `docs/WAVE-PLAN-V0.3.0.md` (Onda 1 done; Onda 2 done; Onda 3 pending in iteration 5 of the autonomous roadmap).
- **Active relay:** `.hbn/relay/INDEX.md`.
- **ADRs:** 9 deposited; 8 ACCEPTED, 1 NÃO_RATIFICAR (ADR-008 — bloqueado por v204 final + MD-I implementação). Index: [`methodology/adr/INDEX.md`](methodology/adr/INDEX.md).
- **Autonomous roadmap toward v0.3.0 publishable:** [`auditoria/00_status/09_PROPOSTA_CRONOGRAMA_AUTONOMO_2026_05_10.md`](auditoria/00_status/09_PROPOSTA_CRONOGRAMA_AUTONOMO_2026_05_10.md).

## Version

- v1.0 — 2026-05-10 — Iteration 4 of the autonomous roadmap (MD-C). First root AGENTS.md for useHBN, declaring identity, typology (ADR-002), constitution (ADR-009), topology (ADR-003), license (ADR-005), and signals (ADR-006).
