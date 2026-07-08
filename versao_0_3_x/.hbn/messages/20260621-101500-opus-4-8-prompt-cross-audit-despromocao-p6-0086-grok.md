---
titulo: "Prompt cross-audit Despromocao-P6 / G-ARVORE-LABEL (0086) — grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-101500-opus-4-8-prompt-cross-audit-despromocao-p6-0086-grok.md
created_at: "2026-06-21T10:15:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "grok (xAI) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit Despromocao-P6 (0086) — grok

⟦HBN-COPY dest=grok⟧ BEGIN
PAPEL: auditor cruzado (familia xAI, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: grok · familia xAI · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

ALVO: ratificar (ou reprovar) a Despromocao-P6 — readback .hbn/readbacks/0086-despromocao-p6.json, guard guards/assert-arvore-label.sh (ESTENDIDO), despacho .hbn/messages/20260621-100000-opus-4-8-despacho-despromocao-p6.md (commit 4cd6bf8). Mudanca: o guard agora gateia DESPROMOCAO — linha nova do REGISTRY com arvore menor que a anterior do mesmo path (fronteira<intermediaria<estavel) exige tipo=arvore-despromocao + readback versionado; senao bloqueia. ATENCAO: modificacao de guard selado — cace REGRESSAO na promocao.

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia guards/assert-arvore-label.sh e cite linhas: ordem fronteira<intermediaria<estavel; lookup da arvore anterior do path no REGISTRY base ignorando added e legadas 5/6-col; exigencia de tipo=arvore-despromocao + readback quando A_nova < A_anterior; preservacao de promocao e estavel=>quente.
3. ATAQUE num fixture descartavel: BLOQUEIAM (i) estavel->fronteira via linha comum sem evento; (ii) intermediaria->fronteira sem evento; (iii) arvore-despromocao SEM readback. PASSAM: despromocao COM arvore-despromocao+readback; nascer fronteira; promocao com arvore-promocao+readback.
4. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram"; bash guards/tests/run-guard-tests.sh -> 0 falharam; bash guards/tests/adversarial-battery.sh -> BATERIA VERDE (B88+).
5. readback 0086: status implemented_pending_cross_audit; PROPOSED_UNTIL_CROSS_AUDIT; escopo respeitado; read-list, guards/data, orchestrator-profile-spec, runner NAO tocados.
6. Burla a procurar: rebaixamento que ainda passe sem evento (linhas legadas, multiplas linhas no commit, normalizacao de colunas); regressao que quebre promocao; falso-verde. Se achar, vote NAO.

ENTREGUE: crie .hbn/results/20260621-104000-grok-cross-ia-despromocao-p6-0086.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260621-104000-grok-cross-ia-despromocao-p6-0086.md
id-global: 20260621-104000-grok-cross-ia-despromocao-p6-0086
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0086: SIM"
arvore: fronteira
created_at: "2026-06-21T10:40:00-03:00"
---

SOU: grok · familia xAI · papel auditor

<suas verificacoes com comando+saida e arquivo:linha>

APROVA_0086: SIM
(ultima linha = veredito exato: "APROVA_0086: SIM" OU "APROVA_0086: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
