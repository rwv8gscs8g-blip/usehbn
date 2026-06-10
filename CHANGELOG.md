# Changelog

All notable changes to HBN will be documented in this file.

## Unreleased

- **proposed (C2 corrente, 2026-06-10, hearback C1 aplicado — conservador)**: read-list canônica de retomada passa de 4 para 5 itens (~21,6 KB): knowledge 0022 (firewall) vira 5º item fixo; regra geral registrada em `core/relay-spec.md` — invariante sempre-quente só se crítico de segurança/negócio E não-coberto-por-guard-executável; `agents/role-templates.md` §T1–T3 atualizados.
- **proposed (C2 corrente, 2026-06-10, aguarda hearback Maurício)**: `ADR-011-enderecamento-numeracao-temperatura.md` — id global `AAAAMMDD-NN`, tabela tipo→pasta→numeração→temperatura, front-matter quente/frio/ultrapassado, REGISTRY append-only por plano; migração going-forward sem rename de história.
- **proposed (C2 corrente, 2026-06-10, aguarda hearback Maurício)**: `ADR-012-naming-versoes-ondas.md` — versão canônica `V<MAJOR>.<MINOR>.<PATCH>`, onda = `NNNN` monotônico (árvore 38.2.x rebaixada a descrição), artefato `NNNN-<tipo>-<slug>` com vocabulário fixo, build label `<versão>+<commit>`; tabela legado→canônico, história fechada intocada.
- **proposed (C2 corrente, 2026-06-10, aguarda hearback Maurício)**: `ADR-008-...-v2.md` — gatilho vira DATA FIXA 2026-06-30 + dono Maurício (meta-regra: decisão não bloqueia em evento sem dono), desacoplado do freeze V206, reabertura obrigatória; `inbox/README.md` + `inbox/<projeto>/` como porta única de feedback dos projetos (id ADR-011, sem colisão); plano de migração reusa matriz MD-K, radar/ migra como está.
- **proposed (C1 Bastão 2.0, 2026-06-10, aguarda hearback Maurício)**: `core/relay-spec.md` v2 (STATE ≤80 linhas × LOG archive), `schemas/state.schema.json`, `schemas/handoff.schema.json` (16 seções da knowledge 0014/onda 0177), `agents/role-templates.md` (§T1–T3 leem o STATE), guard-state-fresh especificado, baseline em `reports/BASELINE-RETOMADA-2026-06-10.md` (retomada 0177: 238–393 KB → dry-run 18,5 KB / 4 arquivos).

## Unreleased — Quarta 2026-05-13 (Autoevolve cycle, awaits human afternoon validation + v0.4.0 vote)

Autonomous Autoevolve cycle inside the Quarta de Sanitização window
(06:00–12:00 BRT, 2026-05-13). 16 microdeltas applied across 14 arms of
the system, each as a separate commit with mandatory pytest. Total tests
grew from 114 → **182 passing**.

### Added

- `src/usehbn/autoevolve/` — local-first microdelta orchestrator with
  JSON-serializable `MicrodeltaTask`/`MicrodeltaResult` contracts (v1.0.0),
  `FileQueue`, `LocalWorker`, `Orchestrator`, `AuditWriter`, and an
  approval gate (`HUMAN_GATE` file override). Interfaces shaped so a
  future distributed pool plugs in without API changes (5cd54d7).
- `hbn autoevolve {status, audit, approve, rollback}` CLI surface, with
  markdown and HTML report renderers (c260a67).
- `src/usehbn/signals.py` — canonical HBN signal registry (16 user-facing
  + 1 operational `AUTOEVOLVE_TICK`) — `54f6c7a`.
- `methodology/adr/ADR-010-autoevolve-cycle.md` — PROPOSED. Doctrine of
  the autoevolve cycle, dependencies on ADR-001/007, 14-arm map,
  approval criteria (ecc3d54).
- `schemas/autoevolve-cycle.schema.json` — Draft 2020-12, validates each
  JSONL record (5fc15b5).
- Pure helpers reusable downstream: `compute_baton_staleness`,
  `summarize_registry`, `summarize_state_document`,
  `resolve_language_fallback`, `get_protocol_invariant`,
  `aggregate_audit`, `render_html_fragment`, `_classify_trigger_origin`.
- `docs/feynman/USEHBN-EXPLICADO.md` + `.docx` — Feynman-style honest
  explainer of what is functional/tested vs what is future promise
  (83cb165).
- `docs/HUMAN-INTERFACE-AUTOEVOLVE.md` — human guide for status, audit,
  rollback, gate.
- `docs/PROPOSAL-V0.4.0.md` — formal proposal to promote PROTOCOL_VERSION
  0.3.0 → 0.4.0 conditional on afternoon human validation + Hearback.
- `site/autoevolve.html` — public showcase page rendering the cycle
  table from the real JSONL (b97ad0f).
- `.hbn/autoevolve/cycle-2026-05-13.jsonl` — sealed audit trail of all
  16 microdeltas with HBN signals.

### Changed (additive — no breaking change)

- `describe_vba_bridge` now reports `maturity: stub` + canonical
  disclaimers list (e008f4d).
- `decision_records` carry a human-readable `reason` field
  (ecccf5d).
- `translate_natural_entry` exposes a `language_fallback` block when
  locale is unknown (68f6c83).
- `detect_activation` classifies `trigger_origin` as
  `shorthand_token` vs `natural_phrase` (fc026af).
- `hbn --help` lists the `autoevolve` subcommand (c198cab).
- `cli.run_relay_status` delegates baton-staleness to the new pure
  helper `runtime.compute_baton_staleness` (8c32ec3).

### Not done (deferred to operator gates)

- No tag, no PyPI/TestPyPI upload, no push to `origin/main`.
- ADR-010 stays PROPOSED until cross-IA review + Hearback.
- Credenciamento untouched (V204 freeze respected).
- v0.3.0 release block below remains the canonical release target until
  operator promotes v0.4.0 per `docs/PROPOSAL-V0.4.0.md`.

## v0.3.0 — Honest Foundation (2026-05-10, prepared; awaits human-gated tag + publish)

This is the v0.3.0 release block, prepared by iteration 12 of the
autonomous roadmap (proposal 09). The actual `git tag v0.3.0`, the
`twine upload --repository testpypi`, and the `git push` to
`origin/main` are deferred to operator-gated iterations 13 (validation)
and post-13 (publish), per §B.2 of the proposal.

### Changed (BREAKING — license migration)

- **License: AGPLv3 → Apache License 2.0** (2026-05-10).
  Per `methodology/adr/ADR-005-licenciamento-apache-cla.md`, the
  project migrates to Apache 2.0 to align with the open-protocol
  stratum (MCP, LSP, OpenTelemetry, Diataxis) and remove
  corporate-adoption friction. The patent grant of Apache 2.0
  preserves the protection against patent trolling that was a
  motivation for the earlier AGPLv3 choice. All `LICENSE`, `setup.cfg`,
  `pyproject.toml`, source headers in `src/usehbn/**` and `tests/`,
  README, CONTRIBUTING, and `docs/LICENSING.md` updated in a single
  atomic transition (no AGPL/Apache mixture). Historical references
  to AGPLv3 in `auditoria/`, `reports/`, and prior CHANGELOG entries
  are preserved as historical record.
- **Contributor agreement: Developer Certificate of Origin (DCO)**.
  Contributions must include `Signed-off-by:` in commit messages
  (`git commit -s`). DCO enforcement in CI is phase 2; phase 1 is
  documental only.

### Changed (version constants — MD-H)

- **`PACKAGE_VERSION` and `PROTOCOL_VERSION` are now distinct constants.**
  Previously, `cli.py` published `protocol_version` in records using
  `__version__` (the package version), producing inconsistent records
  whenever the two values diverged. Both constants are exposed in
  `src/usehbn/__init__.py` and currently aligned at `0.3.0`. Future
  releases may diverge them legitimately (e.g., a `0.3.1` patch fixing
  only the CLI keeps `PROTOCOL_VERSION` at `0.3.0`). `hbn version`
  now publishes both `package_version` and `protocol_version`.
  See ADR-004 v2 and `auditoria/00_status/06_MD_H_RESOLUCAO_VERSAO.md`.
- Bump `__version__` and `setup.cfg version`: `0.2.0 → 0.3.0`.

### Added (governance + methodology)

- `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` — single canonical source
  for the 13 constitutional principles (P1-P10 founders + P11-P13
  operational, with identical constitutional weight).
- `methodology/ADR-AND-MD-PRIMER.md` — didactic explanation of the
  Architecture Decision Record (ADR) and Microdelta (MD) units of
  evolution, with reusable templates in `methodology/templates/`.
- `methodology/adr/` — first 9 ADRs depositing post-2026-05-09
  architectural decisions: Quarta de Sanitização, Founding/Consuming
  typology, monolithic mono-repo modular topology with separate
  `radar/`, SemVer, Apache 2.0 migration, multi-repo signals, health
  metrics, snapshot migration plan, P1-P13 constitution.
- `auditoria/` partition for protocol meta-history (bootstrap, cross-IA
  prompts and consolidation, microdelta specs).
- 6 new HBN signals: 🌐 (cross-repo lock), ⛓️ (protocol dep change),
  🧊 (app frozen), 🪞 (mirror drift), ⏳ (billing window drift —
  resolved 🟠 collision with SOURCE DRIFT), 🔍 (groupthink alarm).

### Marked SUPERSEDED

- `docs/PRINCIPLES.md` (8 generic items inherited from v0.2.x) is now
  superseded by `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (13
  principles). The legacy file is preserved with a banner pointing to
  the canonical source (P7 — preserve history).

### Earlier in this cycle — Onda 1: Honestidade Narrativa (2026-04-29)

The Onda 1 entries below were captured under a separate `[Unreleased]`
header in earlier drafts; they are part of the same v0.3.0 cycle and
have been folded into this section to remove the dual-Unreleased
artifact that existed in the file pre-Onda-5 cleanup (per autonomous
roadmap iteration 8).

### Changed (Onda 1)

- README, ARCHITECTURE, UNIVERSAL-TRANSLATOR, CONNECTORS,
  RUNTIME-ADAPTERS alinhados a docs/MATURITY-MATRIX.md.
- Universal Translator descrito honestamente como Environment
  Router + Connector Resolver em estágio Routed da Phagocytosis.
- Truth Barrier e Guardian descritos como advisory (RFC-0001
  aberta, alvo v0.4.0).

- Add `docs/EVOLUTION-POLICY.md` — formal contract for incorporating
  external protocols (categories A/B/C, hard limits, versioning rules)
- Add `docs/INTEGRATION-DIATAXIS.md` — category A integration with the
  Diataxis documentation framework
- Add `docs/INTEGRATION-LLMS-TXT.md` — category A integration with the
  llms.txt standard for LLM-readable navigation
- Add `docs/INTEGRATION-AGENTS-MD.md` — category A integration with the
  agents.md format for unified agent contracts
- Add `docs/INTEGRATION-GLASSWING.md` — category A integration of a
  Glasswing-style preventive security layer (5 domain-specific vectors,
  composing with Truth Barrier and Guardian)
- Add `docs/CASE-STUDY-CREDENCIAMENTO.md` — first production-scale
  composition of HBN with Diataxis, llms.txt, AGENTS.md, and Glasswing,
  documented from the Brazilian municipal Credenciamento project
- Add explicit execution governance separating the hardened `0.2.x` delivery track from the `v0.3` research track
- Add `docs/EXECUTION-DECISION.md` to define source-of-truth order, scope boundaries, and the approved three-block execution plan

- Add `hbn relay status` for structured baton ownership and active iteration visibility
- Add `hbn handoff --to <agent> --summary <text>` for validated relay baton transfer with pending-readback gate and automatic archive of resolved relay files
- Add `hbn refresh` for batch refresh of all installed runtime adapters in a target
- Add `hbn init --runtime auto|<runtime>` for auto-detection of AI runtime from environment signals during initialization
- Add `hbn hearback --last --status <status>` convenience for confirming the most recent pending readback without needing to copy exec_id
- Add `hbn result --env-key key=value` for capturing environment conditions in ERP records
- Add optional `environment` field to `result.schema.json` for machine-readable diagnostic context
- Add self-describing fallback section to adapter body so adapters work in degraded mode without CLI
- Add `.gitignore` suggestions during `hbn init` for ephemeral protocol artifacts
- Add `.hbn/relay/state.json` as structured relay state file for baton tracking
- Prepare public packaging via `pyproject.toml`
- Add `hbn inspect` for local protocol-state inspection
- Add `hbn install --runtime <runtime>` for runtime adapter generation
- Add local bootstrap script `get-hbn`
- Add runtime adapter support for Claude Code, Codex, Copilot, and Cursor

## v0.2.0

- Added the primary `hbn` CLI entry point while keeping `usehbn` as a compatibility alias
- Added `hbn init`, `hbn run`, and `hbn version`
- Added semantic readback fields for understanding, invariants, action plan, out-of-scope items, and residual risks
- Added repository-local `.hbn/` initialization for relay and knowledge artifacts
- Reorganized implementation and audit documents under `reports/`
- Updated the README and protocol specs to reflect the real local runtime
- Added `agents/agents.md` as the repository-wide operating contract for AI agents
- Added curated documentation entry points under `docs/`
- Added formal protocol documents under `core/`
- Added GitHub Pages-compatible landing page files under `site/`
- Added examples and prompt samples under `examples/`
- Added `REPORT.md` with diagnostic summary, decisions, and next steps
- Added a minimal execution engine that extends the CLI with explicit execution, validation, and structured output
- Added JSON execution logs under `logs/`
- Added a JSON state layer for executions, decisions, and context history under `state/`

## v0.1.0

- Initial public release
- Protocol scaffold
- CLI
- Intent structure
- Consent system
- Documentation
