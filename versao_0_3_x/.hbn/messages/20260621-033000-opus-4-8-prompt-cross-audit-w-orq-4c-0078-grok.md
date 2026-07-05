---
titulo: "Prompt cross-audit W-ORQ-4c / freeze-gate meta-deref (0078) — grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-033000-opus-4-8-prompt-cross-audit-w-orq-4c-0078-grok.md
created_at: "2026-06-21T03:30:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "grok (xAI) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit W-ORQ-4c (0078) — grok

⟦HBN-COPY dest=grok⟧ BEGIN
PAPEL: auditor cruzado (familia xAI, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: grok · familia xAI · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

ALVO: ratificar (ou reprovar) o W-ORQ-4c — readback .hbn/readbacks/0078-w-orq-4c-freeze-deref.json, guard guards/freeze-gate.sh (ENDURECIDO), spec core/freeze-gate-spec.md, despacho .hbn/messages/20260621-033000-opus-4-8-despacho-w-orq-4c-freeze-deref.md (commit 95e7dfa). Mudanca: o freeze-gate agora DEREFERENCIA a meta-superficie no disco e VETA o freeze se (a) qualquer readback estiver PROPOSED_UNTIL_CROSS_AUDIT/implemented_pending_cross_audit, ou (b) assert-orq-entrada.sh nao for verde. ATENCAO: e modificacao de gate selado — cace REGRESSAO.

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia guards/freeze-gate.sh e cite linhas: os dois novos vetos (varredura de .hbn/readbacks por PROPOSED_UNTIL_CROSS_AUDIT; execucao de assert-orq-entrada). Confirme que sao BLOQUEADORES independentes do checklist e que o comportamento antigo (criterios obrigatorios, na+hearback dereferenciavel, bloqueadores_abertos>0=veto) foi PRESERVADO.
3. Leia core/freeze-gate-spec.md: confirme que documenta os dois criterios meta novos.
4. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram".
5. bash guards/tests/run-guard-tests.sh -> 0 falharam (note a secao G-FRZ com casos novos).
6. bash guards/tests/adversarial-battery.sh -> BATERIA VERDE. Confirme os casos novos: readback pendente => veto; atestacao nao-verde => veto; e que o caso BOM (sem pendencias + orq-entrada verde) congela.
7. readback 0078: status == implemented_pending_cross_audit; activation_status == PROPOSED_UNTIL_CROSS_AUDIT; escopo files_allowed respeitado; read-list, guards/data, orchestrator-profile-spec e runner NAO tocados.
8. Burla a procurar: um freeze que passe mesmo com proposta pendente ou atestacao quebrada; regressao que afrouxe os criterios antigos; teste que dependa do estado real do projeto em vez de fixture descartavel. Se achar, descreva reproduzivel e vote NAO.

ENTREGUE: crie .hbn/results/20260621-041000-grok-cross-ia-w-orq-4c-0078.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260621-041000-grok-cross-ia-w-orq-4c-0078.md
id-global: 20260621-041000-grok-cross-ia-w-orq-4c-0078
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0078: SIM"
arvore: fronteira
created_at: "2026-06-21T04:10:00-03:00"
---

SOU: grok · familia xAI · papel auditor

<suas verificacoes com comando+saida e arquivo:linha>

APROVA_0078: SIM
(ultima linha = veredito exato: "APROVA_0078: SIM" OU "APROVA_0078: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
