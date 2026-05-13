# ADRs do useHBN — índice

> Architecture Decision Records do protocolo useHBN. Cada ADR é uma
> decisão arquitetural com status documentado. Decisões que afetam
> contratos públicos (schemas, principios, licença) sempre têm ADR.

## Convenções

- **ID**: `ADR-NNN-<kebab-slug>.md` (NNN ≥ 001).
- **Status**: PROPOSED → ACCEPTED → SUPERSEDED → DEPRECATED.
- **Cross-IA**: ADRs estruturais exigem ≥2 IAs revisoras (P10). ADRs
  constitucionais (mudança em P1-P13) exigem 3 IAs (Opus + Antigravity + Codex).
- **Append-only**: ADR antigo não é deletado. Quando substituído, ganha
  status SUPERSEDED + link para o sucessor.
- **Hearback humano** é obrigatório para mudança de status PROPOSED → ACCEPTED.

## Status atual (2026-05-10 — pós cross-IA + MD-J + Hearback humano)

| ADR | Título | Prioridade | Status | Cross-IA | Dependências |
|---|---|---|---|---|---|
| [ADR-001](ADR-001-quarta-de-sanitizacao.md) | Quarta de Sanitização — janela 12h BRT + manual | P0 | **ACCEPTED v1.1** (ratificado 2026-05-10) | ✅ concluído | depende de 002, 003, 004, 005, 006, 009 |
| [ADR-002](ADR-002-tipologia-founding-consuming.md) | Tipologia Founding/Consuming Application vs Module | P0 | **ACCEPTED v1.1** (ratificado 2026-05-10) | ✅ concluído | — |
| [ADR-003](ADR-003-topologia-repos-relay.md) | Topologia mono-repo modular + relay multi-camada | P0 | **ACCEPTED v1.2** (ratificado 2026-05-10; v1.2 absorve decisões topologia) | ✅ concluído | depende de 002 |
| [ADR-004](ADR-004-semver-protocolo.md) | SemVer do protocolo + sinalização para apps consumidoras | P0 | **ACCEPTED v2** (re-deposit 2026-05-10 absorvendo MD-H; PACKAGE_VERSION vs PROTOCOL_VERSION distinção) | ✅ concluído | depende de 002, 003 |
| [ADR-005](ADR-005-licenciamento-apache-cla.md) | Licenciamento — AGPLv3 → Apache 2.0 + DCO | P1 | **ACCEPTED v1.1** (ratificado 2026-05-10) | ✅ concluído | direção decidida 2026-05-09 |
| [ADR-006](ADR-006-sinais-multi-repo.md) | Sinais HBN multi-repo (🌐, ⛓️, 🧊, 🪞, ⏳, 🔍) | P1 | **ACCEPTED v1.1** (ratificado 2026-05-10) | ✅ concluído | — |
| [ADR-007](ADR-007-metricas-saude.md) | Métricas de saúde do protocolo + alarmes | P2 | **ACCEPTED v1.1** (ratificado 2026-05-10) | ✅ concluído | implementação `hbn doctor --health` pós-v0.3.0 |
| [ADR-008](ADR-008-migracao-snapshot-credenciamento.md) | Migração `Credenciamento/usehbn/` → `.usehbn-snapshot/` | P0 | **NÃO_RATIFICAR** — bloqueado por MD-I + MD-K execução + v204 final | ✅ concluído — Codex REPROVOU | **MD-I implementação + Onda Documental + v204 final** |
| [ADR-009](ADR-009-constituicao-p1-p13.md) | Constituição P1-P13 — migração + processo de mudança | P0 | **ACCEPTED v1.1** (ratificado 2026-05-10) | ✅ concluído (3 IAs) | — |
| [ADR-010](ADR-010-autoevolve-cycle.md) | Autoevolve — microdeltas locais com scaffold distribuído | P1 | **PROPOSED** (depositado 2026-05-13 durante o próprio ciclo) | ⏳ pendente | depende conceitualmente de 001 e 007 |

### Microdeltas geradas pela cross-IA (2026-05-10)

| MD | Tema | Status | Bloqueia |
|---|---|---|---|
| MD-H | Resolução divergência de versão (`PACKAGE_VERSION` vs `PROTOCOL_VERSION`) | spec entregue em `auditoria/00_status/06_MD_H_*.md`; patch em código pendente (Codex) | re-deposit ADR-004 |
| MD-I | Snapshot tooling (`bin/usehbn-fetch.sh`, `usehbn-verify.sh`, manifest determinístico, `hbn doctor` extension) | spec entregue em `auditoria/00_status/07_MD_I_*.md`; implementação pendente (Codex, pós-v204) | re-deposit ADR-008 |
| MD-J | Ajustes nos 7 ADRs ratificáveis + reescrita PRINCIPIOS-CONSTITUCIONAIS | ✅ CONCLUÍDO 2026-05-10 (este INDEX reflete) | promoção PROPOSED → ACCEPTED |
| MD-K | Matriz origem→destino do `Credenciamento/usehbn/` | ✅ entregue em `auditoria/00_status/08_MD_K_*.md` | execução de ADR-008 |

## Ordem de cross-IA serial (decisão operador 2026-05-09)

Para os 5 ADRs P0:

```
ADR-002  →  ADR-003  →  ADR-004  →  ADR-009  →  ADR-001
(tipologia)  (topologia)  (SemVer)   (constituição)  (Quarta — fecha)
```

Razão: ADR-001 depende dos outros 4 conceitualmente (tipologia + topologia
+ SemVer + constituição). Quarta é o ritual operacional que materializa
o resto.

ADRs P1 (005, 006) e P2 (007) ratificam após os P0. ADR-008 espera v204
final do Credenciamento independente da ordem dos demais.

## Histórico de revisões

- 2026-05-09 — Opus 4.7 chat arquiteto-mestre deposita os 9 ADRs como
  esqueletos PROPOSED em MD-B. Nenhum cross-IA review concluído ainda.
- 2026-05-10 — Cross-IA concluída: Codex CLI (10 JSONs `0001-0010-cross-ia-codex-*`)
  + Antigravity (10 MDs `0011-0020-cross-ia-antigravity-*`). Consolidação em
  `auditoria/00_status/05_CONSOLIDACAO_CROSS_IA_ADRS_2026_05_10.md`. Resultado:
  7 ADRs RATIFICAR_APÓS_AJUSTES (MD-J aplicado), 2 ADRs NÃO_RATIFICAR
  (ADR-004 bloqueado por MD-H; ADR-008 bloqueado por MD-I + MD-K + v204).
  Decisões do operador: emoji ⏳ para BILLING WINDOW DRIFT; MDs em paralelo.
- 2026-05-10 — **Hearback humano em bloco**: Mauricio ratificou os 7 ADRs
  PROPOSED v1.1 → **ACCEPTED**. ADR-003 promovido a v1.2 absorvendo as 3
  decisões de topologia (radar/ standalone, study-plans/ em methodology/,
  templates/ em methodology/). ADR-004 e ADR-008 mantêm-se NÃO_RATIFICAR
  até specs (MD-H/MD-I) virarem código + v204 final.
- 2026-05-10 — **Iteração 2 do cronograma autônomo (MD-H aplicado)**:
  patch em `__init__.py` + `cli.py` + `setup.cfg` separa `PACKAGE_VERSION`
  de `PROTOCOL_VERSION`; bug em `cli.py:1079` corrigido (records publicam
  PROTOCOL_VERSION agora); ambas constantes alinhadas em `0.3.0` mas
  semanticamente independentes. ADR-004 re-depositado como v2 e
  ratificado. 93 testes passing (+3 novos em `test_version_constants.py`).
  ADR-008 segue NÃO_RATIFICAR (aguarda MD-I + v204 final).

## Como adicionar novo ADR

1. Próximo número disponível: ADR-011 (ADR-010 depositado 2026-05-13).
2. Criar `methodology/adr/ADR-NNN-<kebab-slug>.md` seguindo o template
   dos existentes (frontmatter, contexto, decisão, consequências,
   riscos, próximo passo, versão).
3. Atualizar este INDEX.md adicionando linha na tabela.
4. Status inicial: PROPOSED.
5. Cross-IA review por ≥1 IA distinta do autor (preferencialmente 2).
6. Hearback humano para promover a ACCEPTED.
