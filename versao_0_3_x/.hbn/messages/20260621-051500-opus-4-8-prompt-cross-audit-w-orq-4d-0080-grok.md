---
titulo: "Prompt cross-audit W-ORQ-4d / bateria no CI + G-CI-BATTERY (0080) — grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-051500-opus-4-8-prompt-cross-audit-w-orq-4d-0080-grok.md
created_at: "2026-06-21T05:15:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "grok (xAI) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit W-ORQ-4d (0080) — grok

⟦HBN-COPY dest=grok⟧ BEGIN
PAPEL: auditor cruzado (familia xAI, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: grok · familia xAI · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

ALVO: ratificar (ou reprovar) o W-ORQ-4d — readback .hbn/readbacks/0080-w-orq-4d-ci-battery.json, guard NOVO guards/assert-ci-battery.sh (G-CI-BATTERY), workflow .github/workflows/hbn-shield.yml, despacho .hbn/messages/20260621-050000-opus-4-8-despacho-w-orq-4d-ci-battery.md (commit 40f03d3). Mudanca: o CI agora roda runner + run-guard-tests + adversarial-battery; e G-CI-BATTERY (invariante no runner) garante que o workflow mantenha as duas invocacoes de teste.

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia .github/workflows/hbn-shield.yml: confirme que ALEM de `bash guards/hbn-guards-runner.sh` ele agora roda `bash guards/tests/run-guard-tests.sh` e `bash guards/tests/adversarial-battery.sh` (cite linhas); confirme YAML valido e env HBN_DIFF_BASE preservado.
3. Leia guards/assert-ci-battery.sh: confirme que e invariante (le o blob do workflow no indice/HEAD) e bloqueia se faltar invocacao de run-guard-tests.sh ou adversarial-battery.sh; grep -n assert-ci-battery guards/hbn-guards-runner.sh (esta no runner).
4. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram" (incl. G-CI-BATTERY).
5. bash guards/tests/run-guard-tests.sh -> 0 falharam.
6. bash guards/tests/adversarial-battery.sh -> BATERIA VERDE. Confirme os casos novos (B83+): workflow sem run-guard-tests => bloqueia; workflow sem adversarial-battery => bloqueia.
7. readback 0080: status == implemented_pending_cross_audit; activation_status == PROPOSED_UNTIL_CROSS_AUDIT; escopo files_allowed respeitado; read-list, guards/data, orchestrator-profile-spec NAO tocados.
8. Burla a procurar: o guard passar com o workflow SEM uma das invocacoes; o workflow rodar mas nao falhar em regressao; falso-verde; teste dependente do estado real do projeto. Se achar, descreva reproduzivel e vote NAO.

ENTREGUE: crie .hbn/results/20260621-054000-grok-cross-ia-w-orq-4d-0080.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260621-054000-grok-cross-ia-w-orq-4d-0080.md
id-global: 20260621-054000-grok-cross-ia-w-orq-4d-0080
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0080: SIM"
arvore: fronteira
created_at: "2026-06-21T05:40:00-03:00"
---

SOU: grok · familia xAI · papel auditor

<suas verificacoes com comando+saida e arquivo:linha>

APROVA_0080: SIM
(ultima linha = veredito exato: "APROVA_0080: SIM" OU "APROVA_0080: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
