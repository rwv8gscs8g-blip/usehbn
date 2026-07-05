---
titulo: "Prompt cross-audit W-LEX (0072) — antigravity/Google"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260620-233000-opus-4-8-prompt-cross-audit-w-lex-0072-antigravity.md
created_at: "2026-06-20T23:30:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "antigravity (Google) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit W-LEX (0072) — antigravity

⟦HBN-COPY dest=antigravity⟧ BEGIN
PAPEL: auditor cruzado (familia Google, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: antigravity · familia Google · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

ALVO: ratificar (ou reprovar) o W-LEX — readback .hbn/readbacks/0072-w-lex.json, entregue pelo despacho .hbn/messages/20260620-231500-opus-4-8-despacho-w-lex.md (commit d3db751). W-LEX grava a Lei da Submissao pelo Exemplo: knowledge .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md + clausula vinculante §7 em core/orchestrator-profile-spec.md (item da read-list), SEM mexer na contagem 13 da read-list.

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md: confirme front-matter (knowledge-id 0029, path real) e as 7 clausulas (obedecer proximo_ponto; um passo/bloco por vez; parar em guard; mecanica ao codex; ratificacao >=2 familias != implementador + gate; main intocada/DESENHA-IMPLEMENTA; chat novo idempotente).
3. .hbn/knowledge/INDEX.md cita 0029 (G-KNOW-INDEX) — confirme a linha.
4. core/orchestrator-profile-spec.md contem a secao "## §7 Lei da Submissao pelo Exemplo" com as clausulas (a)-(f) e referencia a knowledge 0029.
5. core/read-list-canonica.txt continua resolvendo 13 itens (0029 NAO foi adicionado); bash guards/assert-orq-entrada.sh -> verde.
6. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram"; bash guards/tests/run-guard-tests.sh -> 0 falharam; bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
7. readback 0072: status == implemented_pending_cross_audit; activation_status == PROPOSED_UNTIL_CROSS_AUDIT; escopo files_allowed respeitado; guards/** e read-list NAO tocados.
8. Procure: drift de escopo, falso-verde, knowledge sem citacao no INDEX, clausula ausente do profile-spec, read-list quebrada (!=13). Se achar, descreva reproduzivel e vote NAO.

ENTREGUE: crie .hbn/results/20260620-234500-antigravity-cross-ia-w-lex-0072.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260620-234500-antigravity-cross-ia-w-lex-0072.md
id-global: 20260620-234500-antigravity-cross-ia-w-lex-0072
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0072: SIM"
arvore: fronteira
created_at: "2026-06-20T23:45:00-03:00"
---

SOU: antigravity · familia Google · papel auditor

<suas verificacoes com comando+saida e arquivo:linha>

APROVA_0072: SIM
(ultima linha = veredito exato: "APROVA_0072: SIM" OU "APROVA_0072: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
