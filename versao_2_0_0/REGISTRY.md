---
titulo: REGISTRY — livro-razão de artefatos do useHBN v2
status: congelado
temperatura: glacier
data-abertura: 2026-07-01
autoria: fable-5 (implementador da exúvia, gate humano de Maurício)
regras: append-only; uma linha por evento (nascimento ou mudança de temperatura); nunca rename, nunca delete
evidencia: core/04-artefatos.md §REGISTRY (sucede ADR-011 Decisões 4 e 5 do v0.3.x)
---

# REGISTRY do useHBN v2

Livro-razão append-only desta versão. Formato da linha:
`| id | path | tipo | autor | temperatura | superseded_by |`
onde `id = AAAAMMDD-NN` (dia + sequência do dia). Quem deposita artefato
numerado appenda a linha no MESMO commit do depósito (G-REG).

O livro-razão do exoesqueleto v0.3.x permanece em `../REGISTRY.md` (história
imutável; não migra — ver MANIFESTO-MIGRACAO.md).

## Linhas

| id | path | tipo | autor | temperatura | superseded_by |
|---|---|---|---|---|---|
| 20260701-01 | BOOT.md | spec | fable-5 | quente | |
| 20260701-02 | core/01-principios.md | spec | fable-5 | quente | |
| 20260701-03 | core/02-papeis.md | spec | fable-5 | quente | |
| 20260701-04 | core/03-rito-da-onda.md | spec | fable-5 | quente | |
| 20260701-05 | core/04-artefatos.md | spec | fable-5 | quente | |
| 20260701-06 | core/05-guards.md | spec | fable-5 | quente | |
| 20260701-07 | core/06-freeze-fitness-exuvia.md | spec | fable-5 | quente | |
| 20260701-08 | core/07-projetos-membrana.md | spec | fable-5 | quente | |
| 20260701-09 | core/08-evolucao.md | spec | fable-5 | quente | |
| 20260701-10 | core/actor-write-matrix.txt | dado | fable-5 | quente | |
| 20260701-11 | .hbn/relay/STATE.md | estado | fable-5 | quente | |
| 20260701-12 | .hbn/readbacks/0001-bootstrap-exuvia-versao-2-0-0.json | readback | fable-5 | quente | |
| 20260701-13 | .hbn/messages/20260701-193000-fable-5-bootstrap-exuvia-versao-2-0-0.md | message | fable-5 | quente | |
| 20260701-14 | TRANSICAO.md | doc-transicao | fable-5 | quente | |
| 20260701-15 | MANIFESTO-MIGRACAO.md | manifesto | fable-5 | quente | |
| 20260701-16 | FITNESS-CHECKLIST.md | checklist | fable-5 | quente | |
| 20260701-17 | core/exuvia-fitness-criteria.md | spec-verbatim-v03x | fable-5 | quente | |
| 20260701-18 | core/freeze-gate-spec.md | spec-verbatim-v03x | fable-5 | quente | |
| 20260701-19 | core/dual-run-spec.md | spec-verbatim-v03x | fable-5 | quente | |
| 20260701-20 | core/read-list-canonica.txt | dado | fable-5 | quente | |
| 20260701-21 | core/role-cards.md | spec | fable-5 | quente | |
| 20260701-22 | .hbn/messages/20260701-200700-fable-5-despacho-nata-0-role-family-active-root.md | message | fable-5 | quente | |
| 20260701-23 | .hbn/messages/20260701-200800-fable-5-despacho-nata-0b-harness-readlist-v2.md | message | fable-5 | quente | |

## Glaciação (terceira exúvia — 2026-07-05)

> Evento de encerramento: a primeira exúvia (v2.0.0) NUNCA foi ativada
> (relatório crítico 20260705-001142) e foi congelada pela terceira exúvia
> (`status: congelado`, `temperatura: glaciar`). A especificação consolidada
> daqui foi IMPORTADA para `versao_3_0_0/`. Livro-razão ENCERRADO.

| 20260705-g1 | versao_2_0_0/ | versao-inteira | fable-5 | glaciar | versao_3_0_0/ |
