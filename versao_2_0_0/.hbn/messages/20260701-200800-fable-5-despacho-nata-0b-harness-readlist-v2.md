---
titulo: "Despacho nata-0b — bloco read-list do harness version-aware (sob rito, pós-incidente)"
tipo: despacho
status: congelado
temperatura: glacier
path: versao_2_0_0/.hbn/messages/20260701-200800-fable-5-despacho-nata-0b-harness-readlist-v2.md
created_at: "2026-07-01T20:08:00-03:00"
autor: fable-5
familia: Anthropic
arvore: fronteira
---

⟦HBN-COPY dest=codex⟧ BEGIN
SOU: fable-5 · família Anthropic · papel arquiteto-consolidador da exúvia (gate humano de Maurício) · CHAT NOVO
SEU PAPEL: implementador · tier ALTO (guards/tests) · onda nata-0b · UMA onda, UM commit · SÓ INICIAR APÓS nata-0 selada

CONTEXTO DE INCIDENTE (obrigatório): uma versão desta adaptação foi introduzida SEM rito por agente não identificado em 2026-07-01 19:34:45 e REVERTIDA para restaurar C-NOREG. O diff está preservado em `versao_2_0_0/docs/incidente-20260701-harness-rodada1.patch` — use como REFERÊNCIA DE CONTEÚDO, não aplique às cegas: aquela versão editava só a cópia v2 e quebrava a paridade. Registro: versao_2_0_0/FITNESS-CHECKLIST.md §Registro de incidente; MANIFESTO-MIGRACAO.md §PENDENTE item 0b.

MISSÃO: tornar version-aware o bloco "Read-list viva" de `guards/tests/run-guard-tests.sh` (~linhas 3656–3685), num ÚNICO script idêntico nas duas cópias:
1. Detectar a raiz sob teste: se contém `BOOT.md` + `core/02-papeis.md` (layout v2), alvos = `BOOT.md`, `core/02-papeis.md`, `core/03-rito-da-onda.md`, `core/04-artefatos.md`, `core/05-guards.md`, `core/read-list-canonica.txt`; senão, alvos atuais do incumbente INALTERADOS.
2. Skip do ponteiro `.hbn/active-version` quando ele vive no repo pai (caso bootstrap).
3. O teste negativo "referência quebrada é detectada (F-08)" permanece BLOCK.

files_allowed (as duas cópias IDÊNTICAS byte a byte):
- guards/tests/run-guard-tests.sh
- versao_2_0_0/guards/tests/run-guard-tests.sh

CRITÉRIOS DE ACEITE (cole saídas reais de terminal):
- `diff -rq guards versao_2_0_0/guards` → VAZIO após o patch.
- `cd <raiz> && bash guards/tests/run-guard-tests.sh` → 272/272.
- `cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh` → 272/272 (agora honesto: mesmo harness nas duas cópias, sob rito, com quórum).
- Caso F-08 (referência quebrada) → BLOCK nos dois contextos.

ROLLBACK: `git tag hbn-rollback/nata-0b` antes do patch (ato do operador).

PROIBIÇÕES: escopo é SÓ o bloco read-list do harness — nenhuma outra linha do arquivo; sem `--no-verify`; sem `git add -A`; staging seletivo e PARAR. Sob ambiguidade, PARE e pergunte.
⟦HBN-COPY END⟧
