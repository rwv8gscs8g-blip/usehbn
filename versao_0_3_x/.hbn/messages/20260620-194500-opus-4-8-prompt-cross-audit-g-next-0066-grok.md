---
titulo: "Prompt cross-audit G-NEXT (0066) — grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260620-194500-opus-4-8-prompt-cross-audit-g-next-0066-grok.md
created_at: "2026-06-20T19:45:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "grok (xAI) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit G-NEXT (0066) — grok

⟦HBN-COPY dest=grok⟧ BEGIN
PAPEL: auditor cruzado (familia xAI, != OpenAI). Chat NOVO, sem memoria; tudo aqui e autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do seu parecer, EXATA: SOU: grok · familia xAI · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier); nao confie em relato.

ALVO: ratificar (ou reprovar) o G-NEXT — readback .hbn/readbacks/0066-w-next-g-next.json, entregue pelo despacho .hbn/messages/20260619-140000-opus-4-8-despacho-w-next-g-next.md. G-NEXT = guard (guards/assert-next-checkpoint.sh) que exige que todo commit que adiciona/modifica .hbn/relay/STATE.md declare EXATAMENTE UM proximo_ponto top-level bem-formado (campos passo/ato/destino/gate/bloco_ref/status), validado no blob staged localmente e em HEAD no CI.

VERIFICACOES OBRIGATORIAS (rode e cite a saida real):
1. git rev-parse main  ->  deve ser 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia guards/assert-next-checkpoint.sh e cite linhas: enums ACTOS/GATES/STATUS, REQUIRED fields, regra de bloco_ref (deve existir como blob no indice/HEAD), exatamente UM proximo_ponto top-level.
3. Confirme que G-NEXT esta no runner: grep -n assert-next-checkpoint guards/hbn-guards-runner.sh.
4. bash guards/hbn-guards-runner.sh        -> "Todos os guards passaram".
5. bash guards/tests/run-guard-tests.sh    -> 0 falharam.
6. bash guards/tests/adversarial-battery.sh -> BATERIA VERDE. Confirme os casos B que cobrem G-NEXT (ausencia de proximo_ponto; ato fora do enum; destino nao-canonico; bloco_ref inexistente; proximo_ponto duplicado).
7. readback 0066: status == implemented_pending_cross_audit; activation_status == PROPOSED_UNTIL_CROSS_AUDIT; track safe_track; implementador codex; escopo files_allowed respeitado.
8. Procure ativamente: regressao, falso-verde, drift de escopo, falta de teste, burla (algum caminho em que o STATE muda sem proximo_ponto valido e o commit ainda passa). Se achar, descreva reproduzivel e vote NAO.

ENTREGUE: crie .hbn/results/20260620-203000-grok-cross-ia-g-next-0066.md (UNTRACKED — NAO comite) com EXATAMENTE este front-matter + corpo:
---
path: .hbn/results/20260620-203000-grok-cross-ia-g-next-0066.md
id-global: 20260620-203000-grok-cross-ia-g-next-0066
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0066: SIM"
arvore: fronteira
created_at: "2026-06-20T20:30:00-03:00"
---

SOU: grok · familia xAI · papel auditor

<suas verificacoes com comando+saida e arquivo:linha>

APROVA_0066: SIM
(a ultima linha e o veredito exato: "APROVA_0066: SIM" OU "APROVA_0066: NAO" + achados reproduziveis.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
