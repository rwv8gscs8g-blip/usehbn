---
titulo: "06 — Freeze, Fitness Gate e exúvia (evolução por muda)"
status: proposto
temperatura: quente
path: versao_2_0_0/core/06-freeze-fitness-exuvia.md
created_at: "2026-07-01T19:42:00-03:00"
autor: fable-5
familia: Anthropic
---

# 06 — Freeze, fitness e exúvia

Consolida: hbn-exuvia-scaffold (mecânica M-A), esteira-pre-transicao e a
governança de muda. Mantidos verbatim (contratos medíveis):
`core/exuvia-fitness-criteria.md` (8 critérios) · `core/freeze-gate-spec.md` ·
`core/dual-run-spec.md`.

## Modelo: versão = pasta contém o sistema inteiro

Decisão travada (hearback 2026-06-15 §4.1). `usehbn/versao_X_Y_Z/` carrega
BOOT, core, guards, .hbn, REGISTRY — tudo. A IA lê SÓ a versão ativa
(`.hbn/active-version` na raiz do repo; fail-closed em ponteiro ausente,
duplicado, inseguro ou com conflito de merge). O exoesqueleto anterior nunca é
apagado: vira história (git + REGISTRY antigo).

## Ciclo de muda (exúvia)

1. Congela-se o incumbente (freeze-gate exit 0 + tag).
2. Desafiante nasce em `versao_X_Y_Z/` com TRANSICAO.md (1 doc) +
   MANIFESTO-MIGRACAO.md (todo elemento → migra/apêndice/morre) +
   FITNESS-CHECKLIST.md (8 critérios com comandos objetivos).
3. Cross-audit do desafiante por ≥ 2 famílias ≠ implementador da muda.
4. **Fitness Gate**: confronto incumbente × desafiante medido (C-TEST, C-ADV,
   C-XAUDIT, C-DOG, C-FCLOSE, C-NOREG, C-TRACE, C-DEBT). O incumbente
   sobrevive até o desafiante PROVAR.
5. Rollback ensaiado (`scripts/hbn-exuvia-rollback.sh` — dry-run primeiro;
   `--apply` só com autorização humana; reconciliação token×STATE conforme
   scaffold M-A).
6. Hearback humano → flip do ponteiro `.hbn/active-version` em commit próprio
   → tag anti-GC `hbn-exuvia/<versao-anterior>`.

## Freeze de PROTOCOLO ≠ freeze de PROJETO

São gates distintos (lição 2026-06-21): o freeze do protocolo congela guards/
specs/ritos; o freeze de um projeto (ex.: V206 do Credenciamento) usa os
critérios do perfil do projeto (`freeze-gate-spec §3`: validação tela-a-tela,
evidências por tela, pareceres). Critérios de projeto entram como `na` com
hearback no freeze de protocolo, e vice-versa.
