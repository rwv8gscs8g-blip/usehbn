# AGENTS.md — useHBN

> Single agent contract file at the repository root, per the
> [agents.md](https://agents.md) Category A integration adopted by
> useHBN ([`docs/INTEGRATION-AGENTS-MD.md`](docs/INTEGRATION-AGENTS-MD.md)).
> This file is the entry point for any AI operating in this repository.
> Granular per-IA contracts live in [`agents/`](agents/) and are
> referenced from here.

## Cartão de entrada (leia ANTES de agir)

Toda IA que assume trabalho neste repo deve, antes de qualquer ação:
autoidentificar-se (família + papel) e ler a read-list mínima. O cartão de
entrada universal e os três cartões de papel são a porta de entrada operacional:

- Cartão de entrada universal: [`.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md`](.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md) (proposta aguardando promoção a `core/cartao-entrada.md`).
- Cartões de papel (Orquestrador / Implementador / Auditor): [`core/role-cards.md`](core/role-cards.md).
- Read-list mínima ao assumir o bastão: `.hbn/relay/STATE.md` → readback ativo apontado no STATE → [`core/role-cards.md`](core/role-cards.md) → `.hbn/knowledge/0001, 0002, 0023, 0024, 0025`.

Regra de ouro: **escreva só no seu slot**. Implementador escreve apenas nos
`scope.files_allowed` do readback ativo; Auditor deposita parecer em
`.hbn/results/`; Orquestrador deposita artefatos untracked e **nunca** sela a
zona livre (`docs/brainstorm/**`) sem aprovação humana explícita (knowledge 0024).

## Project identity

- **Name:** useHBN — Human Brain Net.
- **Status:** open protocol for safe, structured, evolvable AI-assisted software engineering. Pre-v1 (current working release: v0.3.0, "Honest Foundation").
- **Repository:** `~/Projetos/usehbn/` (local canonical) → public mirror to be published per `methodology/adr/ADR-005-licenciamento-apache-cla.md`.
- **License:** Apache License, Version 2.0 (see `LICENSE`). Migrated from AGPLv3 on 2026-05-10 — see `CHANGELOG.md` and `methodology/adr/ADR-005-licenciamento-apache-cla.md`.
- **Contributor agreement:** Developer Certificate of Origin (DCO). Use `git commit -s`. See `CONTRIBUTING.md`.
- **Maturity reference:** [`methodology/MATURITY-MATRIX.md`](methodology/MATURITY-MATRIX.md) — single source of truth for what works, what is partial, what is scaffold, what is vision. No public claim may exceed it. (The copy under `docs/MATURITY-MATRIX.md` is SUPERSEDED — do not read it for state.)
- **Glossary:** [`docs/GLOSSARY.md`](docs/GLOSSARY.md) — canonical definitions of the core terms (exúvia, árvores, fronteira, REGISTRY, readback/hearback, guard, Truth Barrier, fagocitose, esteira de pré-transição, scope-lock, etc.).

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

## Stack and topology

- **Runtime:** Python 3.9+ (`src/usehbn/`).
- **Tests:** pytest (`tests/`).
- **Schemas:** custom JSON-Schema validator (`schemas/`).
- **Guards:** fail-closed bash guards in `guards/` enforcing scope-lock, dispatch
  integrity, registry lines, etc.; adversarial battery in
  `guards/tests/adversarial-battery.sh` (the CRISPR locus / immune memory).
- **Adapters:** supported runtimes via `src/usehbn/runtime.py` (Claude Code, Codex, ChatGPT, Gemini, Antigravity, Copilot, Cursor).

> Maturity caveat: parts of `src/usehbn/` are **Scaffold/Stub** (notably the
> `autoevolve` orchestrator/worker/queue) — see `methodology/MATURITY-MATRIX.md`.
> Do not infer autonomous evolution from the CLI surface.

Top-level structure (real partitions on disk):

```
core/            living, sealed normative specs (status: accepted): protocol.md,
                 role-cards.md, esteira-pre-transicao.md, exuvia-fitness-criteria.md,
                 readback-spec.md, dispatch-spec.md, freeze-gate-spec.md, etc.
methodology/     principles (PRINCIPIOS-CONSTITUCIONAIS.md), MATURITY-MATRIX.md
                 (canonical), ADRs (adr/), RFCs, primer, templates.
docs/            explanation/architecture docs (ARCHITECTURE.md, PHAGOCYTOSIS.md,
                 WAVE-PLAN-V0.3.0.md, GLOSSARY.md) + free zone docs/brainstorm/**.
agents/          per-IA operating contracts (delegated from this file).
auditoria/       protocol meta-history (bootstrap, status, cross-IA outputs).
schemas/         JSON-Schema contracts. src/  Python runtime. tests/  pytest.
guards/          fail-closed guards + adversarial battery (immune memory).
reports/         generated audit/status reports. examples/  future Reference Impl (scaffold).
.hbn/            coordination substrate: relay/STATE.md, readbacks/, results/,
                 messages/, knowledge/, connectors/ — the live wiring of the protocol.
REGISTRY.md      livro-razão append-only de artefatos (ADR-011): nascimento e
                 mudança de temperatura de cada artefato, sem rename, sem delete.
```

Note: `modules/` and `radar/` do **not** exist on disk. Normative specs live in
`core/`; phagocytosis tracking lives in `docs/PHAGOCYTOSIS.md`.

## Pre-transition esteira (gate before freeze and exúvia)

Before a FREEZE (stable tag) or an EXÚVIA (molt to a new exoskeleton), the
orchestrator runs themed, read-only, Truth-Barrier subagent waves that document
findings in `docs/brainstorm/rodada-AAAA-MM-DD/analise-pre-transicao/`. The rule
is sealed in [`core/esteira-pre-transicao.md`](core/esteira-pre-transicao.md):
no freeze and no exúvia without the esteira fulfilled and human-curated.

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
- Truth Barrier strict: claims like "100%", "guaranteed", "totally safe" are forbidden; every judgment cites `arquivo:linha` OR `comando+saída`.
- Glasswing G6: product code does not go in chat; it goes into files in the repository (see [`docs/INTEGRATION-GLASSWING.md`](docs/INTEGRATION-GLASSWING.md)).
- Read-first: before writing, read the current state.
- Gate over instruction: written instruction never unlocks anything — only the enforced guard (fail-closed) does. Honor the guards; if a guard blocks, STOP and report.
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

- **Wave plan:** `docs/WAVE-PLAN-V0.3.0.md`.
- **Active relay/state:** `.hbn/relay/STATE.md` and `.hbn/relay/INDEX.md`.
- **ADRs:** index at [`methodology/adr/INDEX.md`](methodology/adr/INDEX.md).
- **REGISTRY:** [`REGISTRY.md`](REGISTRY.md) — append-only ledger of artifacts.

## Version

- v1.1 (proposta) — curadoria P0 2026-06-17: corrige ponteiros mortos (remove `modules/` e `radar/` inexistentes), declara `core/` como casa das specs vivas (não legado), aponta maturidade para `methodology/MATURITY-MATRIX.md`, adiciona cartão de entrada, esteira de pré-transição, REGISTRY e glossário. Preserva identidade, constituição (ADR-009), sinais (ADR-006) e contratos por IA do v1.0.
- v1.0 — 2026-05-10 — Iteration 4 of the autonomous roadmap (MD-C). First root AGENTS.md for useHBN.

