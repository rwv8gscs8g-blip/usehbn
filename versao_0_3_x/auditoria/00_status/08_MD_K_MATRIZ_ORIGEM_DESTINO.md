---
titulo: 08 - MD-K — Matriz origem→destino do Credenciamento/usehbn/ → ~/Projetos/usehbn/
diataxis: how-to
hbn-track: safe_track
hbn-status: active
audiencia: ambos
versao-protocolo: useHBN pre-v1
data: 2026-05-10
autor: Claude Opus 4.7 (chat arquiteto-mestre useHBN) — MD-K do plano de consolidação cross-IA
escopo: pré-requisito para executar ADR-008 (antes de remover Credenciamento/usehbn/)
relacionado:
  - 05_CONSOLIDACAO_CROSS_IA_ADRS_2026_05_10.md §B.8, §D
  - methodology/adr/ADR-008-migracao-snapshot-credenciamento.md
  - methodology/adr/ADR-003-topologia-repos-relay.md (define as partições destino)
status: congelado
temperatura: glacier
---

# 08. MD-K — Matriz origem→destino do `Credenciamento/usehbn/`

> Mapeamento completo do conteúdo de `~/Projetos/Credenciamento/usehbn/`
> para a topologia alvo (ADR-003) em `~/Projetos/usehbn/`. **Nenhum
> arquivo é removido do Credenciamento neste MD** — ele apenas planeja.
> A migração efetiva (e a substituição da pasta legada por README
> depreciado) acontece após v204 final + ADR-008 ACCEPTED.

## A. Inventário da origem (2026-05-10)

`~/Projetos/Credenciamento/usehbn/` contém:

| Subpasta | Conteúdo | Total |
|---|---|---|
| `methodology/` | 12 arquivos `.md` (~2.470 linhas) — princípios, arquitetura, protocolos | 12 |
| `modules/` | 8 arquivos `.md` (~1.540 linhas) — módulos normativos (Fagocitose, Cápsulas, Auditoria Cruzada, etc.) + INDEX | 8 |
| `radar/` | 4 arquivos `.md` + `_per-technology/` com 60 fichas de tecnologia | 64+ |
| `audits/` | 9 arquivos `.md` — auditorias arquiteturais e prompts de cross-audit | 9 |
| `site/` | 1 arquivo `.md` — proposta de melhoria do usehbn.org | 1 |
| `study-plans/` | 7 `.md` + `gemini/` + `notebooklm/` (1 docx) — planos de estudo de tecnologias | 7+ |
| `docs/` | 2 arquivos `.md` — INTEGRATION-VBA-IMPORTER, PHAGOCYTOSIS-VBA-PATTERNS | 2 |

## B. Matriz de migração

> Convenção: `[migrado]` = já feito; `[planejar]` = aguarda Onda
> Documental Sanitization; `[fundir]` = funde em cerne existente;
> `[manter]` = mantém arquivo standalone; `[descartar]` = não migra
> (efêmero/obsoleto — registrar a decisão).

### B.1 `methodology/` → `~/Projetos/usehbn/methodology/`

| Origem | Destino | Ação | Notas |
|---|---|---|---|
| `PRINCIPIOS-CONSTITUCIONAIS.md` | `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` | **[migrado]** | MD-F (2026-05-09) + MD-J (2026-05-10, isonomia P1-P13). v1.1 vigente |
| `MINIMALISM-PRINCIPLE.md` | `methodology/MINIMALISM-PRINCIPLE.md` | [planejar] | ficha canônica de P11 |
| `SUBSTRATO-SOLIDO-PRINCIPLE.md` | `methodology/SUBSTRATO-SOLIDO-PRINCIPLE.md` | [planejar] | ficha canônica de P12 |
| `AI-LANGUAGE-ABSTRACTION-PRINCIPLE.md` | `methodology/AI-LANGUAGE-ABSTRACTION-PRINCIPLE.md` | [planejar] | ficha canônica de P13 |
| `USEHBN-MODULES-ARCHITECTURE.md` | `methodology/USEHBN-MODULES-ARCHITECTURE.md` | [planejar] | arquitetura multi-braço |
| `THREE-TREES-ARCHITECTURE.md` | `methodology/THREE-TREES-ARCHITECTURE.md` | [planejar] | modelo das 3 árvores |
| `CROSS-IA-AUDIT-PROTOCOL.md` | `methodology/CROSS-IA-AUDIT-PROTOCOL.md` | [planejar] | **relevante agora** — usado no cross-IA dos ADRs; candidato a migração prioritária |
| `RADAR-PHAGOCYTOSIS-PIPELINE.md` | `methodology/PHAGOCYTOSIS.md` | [fundir] | funde em `docs/PHAGOCYTOSIS.md` existente (cerne C2) ou vira `methodology/PHAGOCYTOSIS-PIPELINE.md` standalone — decisão na Onda Documental |
| `RADAR-WEEKLY-REVIEW-PROTOCOL.md` | `methodology/RADAR-WEEKLY-REVIEW-PROTOCOL.md` | [planejar] | relacionado à Quarta (ADR-001) — verificar sobreposição |
| `INCORPORATION-PROGRESSIVE-PLAN.md` | `methodology/PHAGOCYTOSIS.md` | [fundir] | funde com doutrina de fagocitose |
| `INTER-CHAT-COORDINATION.md` | `methodology/INTER-CHAT-COORDINATION.md` | [planejar] | relacionado a `agents/wave-protocol.md` — verificar sobreposição |
| `LANGUAGE-PLATFORM-COMPARISON.md` | `auditoria/decisions/LANGUAGE-PLATFORM-COMPARISON.md` | [planejar] | é registro de decisão (Rust vs alternativas) — vai para auditoria, não methodology |

### B.2 `modules/` → `~/Projetos/usehbn/modules/`

| Origem | Destino | Ação | Notas |
|---|---|---|---|
| `INDEX.md` | `modules/INDEX.md` | [planejar] | índice dos módulos normativos |
| `FAGOCITOSE.md` | `modules/FAGOCITOSE.md` | [planejar] | módulo normativo da fagocitose |
| `CAPSULAS-DE-CONSENTIMENTO.md` | `modules/CAPSULAS-DE-CONSENTIMENTO.md` | [planejar] | módulo das cápsulas |
| `AUDITORIA-CRUZADA.md` | `modules/AUDITORIA-CRUZADA.md` | [planejar] | **relevante agora** — formaliza o cross-IA; migração prioritária |
| `COORDENACAO-INTER-IA.md` | `modules/COORDENACAO-INTER-IA.md` | [planejar] | relay/baton normativo |
| `MARCADORES.md` | `modules/MARCADORES.md` ou `modules/PROTOCOL-CONTRACT.md` | [fundir] | catálogo de sinais — funde com ADR-006 e com a seção de marcadores do `core/protocol.md` |
| `RADAR.md` | `modules/RADAR.md` | [planejar] | módulo do radar de tecnologias |
| `SEGURANCA.md` | `modules/SEGURANCA.md` ou `modules/INTEGRATIONS.md` | [fundir] | 8 vetores Glasswing G1-G8 — funde com `docs/INTEGRATION-GLASSWING.md` |

### B.3 `radar/` → `~/Projetos/usehbn/radar/`

| Origem | Destino | Ação | Notas |
|---|---|---|---|
| `REGISTRY.md` | `radar/REGISTRY.md` | [planejar] | registro consolidado de tecnologias |
| `CONVERGENCE-MATRIX.md` | `radar/CONVERGENCE-MATRIX.md` | [planejar] | matriz princípio × tecnologia — referenciada em PRINCIPIOS-CONSTITUCIONAIS |
| `WEEKLY-UPDATES.md` | `radar/WEEKLY-UPDATES.md` | [planejar] | histórico de atualizações do radar |
| `README.md` | `radar/README.md` | [planejar] | — |
| `_per-technology/*.md` (60 fichas) | `radar/_per-technology/*.md` | [planejar] | cópia em bloco; sem fusão (cada ficha é unidade atômica) |

> **Decisão de topologia (ADR-003 ajuste):** `radar/` é uma 5ª partição
> (além de modules/methodology/auditoria/examples) ou subpasta de
> `methodology/`? Recomendação Opus: **partição standalone `radar/`** —
> tem volume (64+ arquivos) e ciclo de revisão próprio (semanal vs
> anual dos princípios). Atualizar ADR-003 §Decisão na próxima revisão.

### B.4 `audits/` → `~/Projetos/usehbn/auditoria/`

| Origem | Destino | Ação | Notas |
|---|---|---|---|
| `AUDITORIA-ARQUITETURAL-2026-05-09.md` | `auditoria/00_status/` (com prefixo numérico) | [planejar] | auditoria que originou as decisões deste bootstrap |
| `RELATORIO-ANTIGRAVITY-ARQUITETURA-2026-05-09.md` | `auditoria/00_status/` | [planejar] | parecer Antigravity da arquitetura |
| `RELATORIO-ANTIGRAVITY-MODULOS-2026-05-09.md` | `auditoria/00_status/` | [planejar] | parecer Antigravity dos módulos |
| `PROMPT-*.md` (6 prompts de cross-audit) | `auditoria/prompts/` | [planejar] ou [descartar] | prompts já consumidos — verificar se algum tem valor de template reutilizável; senão descartar com registro |

### B.5 `site/` → `~/Projetos/usehbn/site/` (ou auditoria)

| Origem | Destino | Ação | Notas |
|---|---|---|---|
| `PROPOSTA-MELHORIA-USEHBN-ORG.md` | `auditoria/decisions/SITE-PROPOSTA-2026.md` | [planejar] | é proposta, não decisão final — vai para auditoria; quando implementada, o `site/index.html` já existente reflete |

### B.6 `study-plans/` → `~/Projetos/usehbn/methodology/study-plans/` (ou radar)

| Origem | Destino | Ação | Notas |
|---|---|---|---|
| `00-INTEGRATION-ROADMAP.md` | `methodology/study-plans/00-INTEGRATION-ROADMAP.md` | [planejar] | roadmap de incorporação de tecnologias |
| `01-tree-sitter-study-plan.md` ... `05-consent-capsules-study-plan.md` | `methodology/study-plans/` | [planejar] | planos de estudo individuais |
| `README.md` | `methodology/study-plans/README.md` | [planejar] | — |
| `gemini/ARCHITECTURE-BRIEF.md` | `methodology/study-plans/gemini/` | [planejar] | brief para Gemini |
| `notebooklm/*.md` (5 superprompts + template) | `methodology/study-plans/notebooklm/` | [planejar] | superprompts NotebookLM |
| `notebooklm/USEHBN-5-TECHNOLOGIES-MASTER-STUDY.docx` | `methodology/study-plans/notebooklm/` | [planejar] (binário) | docx — único binário; copiar sem normalização de line ending |

### B.7 `docs/` (do Credenciamento/usehbn/) → `~/Projetos/usehbn/`

| Origem | Destino | Ação | Notas |
|---|---|---|---|
| `INTEGRATION-VBA-IMPORTER.md` | `modules/INTEGRATIONS.md` ou `docs/VBA.md` | [fundir] | funde com `docs/VBA.md` existente no useHBN (cerne C5) |
| `PHAGOCYTOSIS-VBA-PATTERNS.md` | `auditoria/case-studies/CREDENCIAMENTO-VBA-PATTERNS.md` | [planejar] | lições destiladas da fagocitose VBA no Credenciamento — vai para case-studies |

## C. O que NÃO vai para o snapshot da app consumidora

Lembrete (de MD-I §B.3): o `.usehbn-snapshot/` no Credenciamento contém
apenas `methodology/` + `modules/` do repo canônico. NÃO leva `radar/`,
`auditoria/`, `study-plans/`, `examples/`, `.hbn/`, `src/`, `tests/`.
A app consome o **protocolo normativo + arquitetura**, não o histórico
nem a implementação Python.

## D. Sequência de execução (após v204 final + ADR-008 ACCEPTED)

| # | Ação | Quem | Risco |
|---|---|---|---|
| 1 | Migração prioritária: `CROSS-IA-AUDIT-PROTOCOL.md` + `AUDITORIA-CRUZADA.md` + `CONVERGENCE-MATRIX.md` (são usados agora) | Opus arquiteto | baixo |
| 2 | Onda Documental Sanitization: migrar o resto de `methodology/` + `modules/` + `radar/` com fusões (cernes C1-C8) | Opus + cross-IA | médio (perda informacional possível — revisão linha-a-linha) |
| 3 | Migrar `audits/` + `study-plans/` + `site/` + `docs/` para `auditoria/` e subpastas | Opus arquiteto | baixo |
| 4 | Auditoria final: diff origem→destino = conteúdo coberto (cross-IA Codex confirma zero perda não-intencional) | Opus + Codex | baixo |
| 5 | `bin/usehbn-fetch.sh` popula `.usehbn-snapshot/` no Credenciamento (MD-I) | Codex CLI | baixo |
| 6 | Substituir `Credenciamento/usehbn/` por README depreciado (ADR-008 §2) — commit dedicado, com tag de backup antes | Codex CLI | médio (remoção — backup obrigatório) |
| 7 | Adicionar seção `useHBN-version` ao `Credenciamento/AGENTS.md` | Codex CLI | baixo |
| 8 | `hbn doctor --target ~/Projetos/Credenciamento` confirma snapshot íntegro | qualquer | baixo |

## E. Decisões de topologia (ratificadas pelo operador 2026-05-10)

Todas as 3 recomendações Opus foram aceitas pelo operador:

1) ✅ **`radar/` é partição standalone** do mono-repo (não subpasta de `methodology/`). Justificativa: volume (64+ arquivos) + ciclo de revisão próprio (semanal vs anual dos princípios). ADR-003 §Decisão atualizado para v1.2 com `radar/` no tree.
2) ✅ **`study-plans/` vive em `methodology/study-plans/`** — são metodologia de incorporação de tecnologias, não fichas atômicas. ADR-003 v1.2 atualizado.
3) ✅ **Prompts consumidos descartados, 1 template mantido** em `methodology/templates/CROSS-AUDIT-TEMPLATE.md` (template genérico de cross-audit reutilizável; os outros 5 prompts já consumidos são removidos com registro em commit dedicado durante a Onda Documental Sanitization). ADR-003 v1.2 inclui `methodology/templates/`.

## F. Rollback

Este MD não toca nada — só planeja. Quando a migração efetiva acontecer
(passo 6 da §D), a reversão é `git checkout <tag-de-backup>` no
Credenciamento. Por isso o passo 6 exige tag antes da remoção.

## G. Versão

- v1.0 — 2026-05-10 — Opus 4.7 chat arquiteto-mestre — MD-K. Matriz completa origem→destino: 12 docs de methodology/, 8 de modules/, 64+ de radar/, 9 de audits/, 1 de site/, 7+ de study-plans/, 2 de docs/. 1 já migrado (PRINCIPIOS-CONSTITUCIONAIS); resto planejado para Onda Documental Sanitization pós-v204. 3 decisões de topologia pendentes.
