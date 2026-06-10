---
titulo: REGISTRY — livro-razão de artefatos do protocolo (ADR-011 Decisão 4)
status: proposed
temperatura: quente
data-abertura: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente C3/C4)
regras: append-only; uma linha por evento (nascimento ou mudança de temperatura); nunca rename, nunca delete
evidencia: ADR-011 (methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md), Decisões 4 e 5
---

# REGISTRY do canônico useHBN

Livro-razão append-only. Dado qualquer par de artefatos, a ordem das linhas
(e o id `AAAAMMDD-NN`) diz o que veio antes; `temperatura` + `superseded_by`
dizem se algum foi ultrapassado — sem abrir arquivo nenhum.

Quem deposita artefato novo appenda a linha **no mesmo commit** do depósito.
Mudança de temperatura = nova linha (a antiga nunca é editada além da coluna
`superseded_by` permanecer vazia — a linha mais recente do path vence).

## Legado (mapeamento, sem rename)

Órfãos anteriores ao ADR-011, com data efetiva reconstruída do git/mtime.
Nenhum arquivo é renomeado — esta seção só costura o passado ao livro-razão.

| data efetiva | artefato (path) | tipo | temperatura | superseded_by | evidência da data |
|---|---|---|---|---|---|
| ~2026-04-03 | HBN-ARCHITECTURAL-REVIEW-2026-04.md | analise | frio | — | mtime 2026-04-03; 1º commit efd226b (2026-04-29, "baseline before onda 1") |
| 2026-04-29 | AUDITORIA_SUPERPOWERS.md | audit | frio | — | commit efd226b 2026-04-29 |
| 2026-06-10 04:58 | PROMPT_ANALISE_PROFUNDA_PROTOCOLO_FABLE5.md | prompt | frio | — | mtime (untracked; ciclo encerrado) |
| 2026-06-10 04:59 | PROMPT_EVOLUCAO_PROTOCOLO_FABLE5.md | prompt | frio | — | mtime (untracked; ciclo encerrado) |
| 2026-06-10 05:14 | docs/ANALISE-PROFUNDA-EVOLUCAO-PROTOCOLO-2026-06-10.md | analise | frio | — | mtime; frio ao entregar (ADR-011 Decisão 2) |
| 2026-06-10 05:37 | PROMPT_C1_BASTAO_FABLE5.md | prompt | frio | — | mtime; corrente C1 encerrada |
| 2026-06-10 05:49 | reports/BASELINE-RETOMADA-2026-06-10.md | baseline | frio | — | mtime; evidência histórica (medição 238–393 KB) |
| 2026-06-10 06:02 | PROMPT_C2_CHAIN_FABLE5.md | prompt | frio | — | mtime; corrente C2 encerrada |
| 2026-06-10 06:19 | PROMPT_C3_CHAIN_FABLE5.md | prompt | quente | — | mtime; ciclo C3/C4 em curso nesta janela |

## Linhas (going-forward, ADR-011)

| id | artefato (path) | tipo | temperatura | superseded_by |
|---|---|---|---|---|
| 20260610-01 | schemas/state.schema.json | schema | quente | — |
| 20260610-02 | schemas/handoff.schema.json | schema | quente | — |
| 20260610-03 | core/relay-spec.md | spec-core | quente | — |
| 20260610-04 | agents/role-templates.md | spec-core | quente | — |
| 20260610-05 | methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md | adr | quente | — |
| 20260610-06 | methodology/adr/ADR-012-naming-versoes-ondas.md | adr | quente | — |
| 20260610-07 | methodology/adr/ADR-008-migracao-snapshot-credenciamento-v2.md | adr | quente | — |
| 20260610-08 | methodology/adr/ADR-008-migracao-snapshot-credenciamento.md | adr | ultrapassado | ADR-008 v2 (20260610-07) |
| 20260610-09 | inbox/README.md | spec-core | quente | — |
| 20260610-10 | schemas/hearback.schema.json | schema | quente | — |
| 20260610-11 | schemas/audit-pre.schema.json | schema | quente | — |
| 20260610-12 | schemas/audit-post.schema.json | schema | quente | — |
| 20260610-13 | guards/ (runner + 5 guards + lib/common.sh + README) | guard | quente | — |
| 20260610-14 | .github/workflows/hbn-shield.yml | ci | quente | — |
| 20260610-15 | reports/20260610-15-proposal-bump-versao-canonico.md | proposal | quente | — |
| 20260610-16 | agents/architect-autonomous.md | spec-core | quente | — |
| 20260610-17 | methodology/adr/ADR-013-arquiteto-autonomo-classes-a-b.md | adr | quente | — |
| 20260610-18 | .hbn/queue/ (README + itens 001–019) | queue | quente | — |
| 20260610-19 | core/cadence-d.md | spec-core | quente | — |
| 20260610-20 | .hbn/knowledge/0001-comandos-atomicos-copiaveis.md | knowledge | quente | — |
| 20260610-21 | .hbn/knowledge/0002-entrega-operacional-minimalista.md | knowledge | quente | — |
| 20260610-22 | .hbn/autoevolve/cycle-2026-06-10.jsonl | exec | frio | — |

Nota de legado adicional: `/Users/macbookpro/Projetos/PROMPT_ARQUITETO_USEHBN_AUTONOMO.md`
(v1.6, FORA deste repo, sem git) — quente; vira `ultrapassado` com
`superseded_by: agents/architect-autonomous.md (20260610-16)` na ratificação
do lote C4.
