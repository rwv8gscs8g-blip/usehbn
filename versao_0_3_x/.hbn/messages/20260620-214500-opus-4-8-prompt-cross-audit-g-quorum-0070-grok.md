---
titulo: "Prompt cross-audit G-QUORUM (0070) — grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260620-214500-opus-4-8-prompt-cross-audit-g-quorum-0070-grok.md
created_at: "2026-06-20T21:45:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "grok (xAI) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit G-QUORUM (0070) — grok

⟦HBN-COPY dest=grok⟧ BEGIN
PAPEL: auditor cruzado (familia xAI, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: grok · familia xAI · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

ALVO: ratificar (ou reprovar) o G-QUORUM — readback .hbn/readbacks/0070-w-quorum-g-quorum.json, guard guards/assert-quorum-selagem.sh, entregue pelo despacho .hbn/messages/20260620-213000-opus-4-8-despacho-w-quorum-g-quorum.md (commit 18d46e5). G-QUORUM = todo commit que ADICIONA um readback status "vigente" (selagem) so passa se o readback declarar seals_proposal NNNN E existirem >=2 pareceres canonicos de familias DISTINTAS != OpenAI com APROVA_NNNN: SIM no disco; fail-closed, forward-only, blob staged.

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia guards/assert-quorum-selagem.sh e cite linhas: gatilho (readback vigente ADICIONADO, diff-filter=A); exigencia de seals_proposal ^[0-9]{4}$; coleta de pareceres *-NNNN.md no indice; familia no mapa guards/data/auditor-families.txt e != OpenAI; contagem de familias DISTINTAS; bloqueio se < 2; fail-closed.
3. grep -n assert-quorum-selagem guards/hbn-guards-runner.sh (esta no runner).
4. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram".
5. bash guards/tests/run-guard-tests.sh -> 0 falharam.
6. bash guards/tests/adversarial-battery.sh -> BATERIA VERDE. Confirme os casos (B71+) que cobrem: sem seals_proposal; so 1 parecer != OpenAI; 2 pareceres MESMA familia; parecer de familia OpenAI nao conta; parecer sem APROVA_NNNN: SIM.
7. readback 0070: status == implemented_pending_cross_audit; activation_status == PROPOSED_UNTIL_CROSS_AUDIT; track safe_track; escopo files_allowed respeitado; guards/data/** NAO tocado.
8. Procure burla: alguma SELAGEM (readback vigente adicionado) que passe SEM quorum >=2 != OpenAI; falso-verde; reavaliacao indevida de selagens passadas; drift de escopo. Se achar, descreva reproduzivel e vote NAO.

ENTREGUE: crie .hbn/results/20260620-223000-grok-cross-ia-g-quorum-0070.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260620-223000-grok-cross-ia-g-quorum-0070.md
id-global: 20260620-223000-grok-cross-ia-g-quorum-0070
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0070: SIM"
arvore: fronteira
created_at: "2026-06-20T22:30:00-03:00"
---

SOU: grok · familia xAI · papel auditor

<suas verificacoes com comando+saida e arquivo:linha>

APROVA_0070: SIM
(ultima linha = veredito exato: "APROVA_0070: SIM" OU "APROVA_0070: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
