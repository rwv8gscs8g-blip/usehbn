---
titulo: "Prompt cross-audit W-ORQ-4b / G-ORQ-REF endurecido (0076) — antigravity/Google"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-023000-opus-4-8-prompt-cross-audit-w-orq-4b-0076-antigravity.md
created_at: "2026-06-21T02:30:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "antigravity (Google) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit W-ORQ-4b (0076) — antigravity

⟦HBN-COPY dest=antigravity⟧ BEGIN
PAPEL: auditor cruzado (familia Google, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: antigravity · familia Google · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

ALVO: ratificar (ou reprovar) o W-ORQ-4b — readback .hbn/readbacks/0076-w-orq-4b-orqref.json, guard guards/assert-orq-entrada-ref.sh (ENDURECIDO), despacho .hbn/messages/20260621-020000-opus-4-8-despacho-w-orq-4b-orqref.md (commit 98adf4d). Mudanca: G-ORQ-REF passa a gatear tambem despachos em .hbn/messages/*.md com tipo: despacho (exige orq_entrada_ref + readback_alvo), alem de .hbn/dispatch/*.md, freeze e readbacks vigentes. ATENCAO ESPECIAL: e modificacao de guard SELADO — cace REGRESSAO.

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia guards/assert-orq-entrada-ref.sh e cite linhas: o novo ramo que trata .hbn/messages/*.md com tipo: despacho como ato de autoridade; confirme que .hbn/messages com tipo handoff/prompt/entrada NAO sao gateados; confirme que .hbn/dispatch/*.md, freeze e readbacks vigentes mantiveram a logica anterior (sem regressao).
3. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram" (note: o proprio despacho 0076 em .hbn/messages com tipo despacho + orq_entrada_ref passou = dogfood).
4. bash guards/tests/run-guard-tests.sh -> 0 falharam.
5. bash guards/tests/adversarial-battery.sh -> BATERIA VERDE. Confirme os casos novos (B79+): despacho em .hbn/messages tipo despacho SEM orq_entrada_ref bloqueia; orq_entrada_ref divergente bloqueia; tipo handoff/prompt/entrada neutro passa. Confirme tambem que os casos antigos de G-ORQ-REF continuam (regressao zero).
6. readback 0076: status == implemented_pending_cross_audit; activation_status == PROPOSED_UNTIL_CROSS_AUDIT; escopo files_allowed respeitado; guards/data/** e read-list NAO tocados; guards/hbn-guards-runner.sh NAO tocado.
7. Burla a procurar: um despacho-ato-de-autoridade em .hbn/messages que ainda escape do gate; regressao que afrouxe o gate de .hbn/dispatch/freeze/readbacks; falso-verde. Se achar, descreva reproduzivel e vote NAO.

ENTREGUE: crie .hbn/results/20260621-024500-antigravity-cross-ia-w-orq-4b-0076.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260621-024500-antigravity-cross-ia-w-orq-4b-0076.md
id-global: 20260621-024500-antigravity-cross-ia-w-orq-4b-0076
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0076: SIM"
arvore: fronteira
created_at: "2026-06-21T02:45:00-03:00"
---

SOU: antigravity · familia Google · papel auditor

<suas verificacoes com comando+saida e arquivo:linha>

APROVA_0076: SIM
(ultima linha = veredito exato: "APROVA_0076: SIM" OU "APROVA_0076: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
