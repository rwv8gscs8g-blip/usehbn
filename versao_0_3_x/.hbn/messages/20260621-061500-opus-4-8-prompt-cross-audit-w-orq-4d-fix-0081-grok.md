---
titulo: "Prompt re-cross-audit W-ORQ-4d-fix / G-CI-BATTERY endurecido (0081) — grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-061500-opus-4-8-prompt-cross-audit-w-orq-4d-fix-0081-grok.md
created_at: "2026-06-21T06:15:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "grok (xAI) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt re-cross-audit W-ORQ-4d-fix (0081) — grok

⟦HBN-COPY dest=grok⟧ BEGIN
PAPEL: auditor cruzado (familia xAI, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: grok · familia xAI · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

CONTEXTO: o W-ORQ-4d (0080) foi REPROVADO por antigravity, que achou 2 bypasses no G-CI-BATTERY (comentario inline e echo do path). Este e o FIX (readback 0081, commit be18335). Confirme que as 2 burlas agora sao BLOQUEADAS.

ALVO: ratificar (ou reprovar) o W-ORQ-4d-fix — readback .hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json, guard guards/assert-ci-battery.sh (ENDURECIDO). Agora o guard exige invocacao REAL de bash guards/tests/run-guard-tests.sh e bash guards/tests/adversarial-battery.sh num step run (remove comentario inline; rejeita echo/aspas).

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia guards/assert-ci-battery.sh: confirme o novo algoritmo (strip de comentario inline " #..."; tokenizacao do comando; segmento deve COMECAR com `bash <script>`; echo/aspas nao contam). Cite linhas.
3. REPRODUZA num fixture descartavel as 2 burlas e confirme que o guard agora BLOQUEIA (exit != 0):
   (a) `- run: echo "skip" # bash guards/tests/run-guard-tests.sh`  -> BLOQUEIA.
   (b) `- run: echo "bash guards/tests/adversarial-battery.sh"`     -> BLOQUEIA.
   E o caso BOM (workflow real) PASSA.
4. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram".
5. bash guards/tests/run-guard-tests.sh -> 0 falharam.
6. bash guards/tests/adversarial-battery.sh -> BATERIA VERDE. Confirme B85 (comentario) e B86 (echo) BLOQUEADOS.
7. readback 0081: status implemented_pending_cross_audit; PROPOSED_UNTIL_CROSS_AUDIT; escopo files_allowed respeitado; .github/workflows/**, read-list, guards/data, orchestrator-profile-spec NAO tocados.
8. Procure NOVAS burlas equivalentes (ex.: `:` no-op, `true && echo`, heredoc, `bash -c "echo ..."`, indentacao enganosa em run: |). Se achar uma que ainda passe, descreva reproduzivel e vote NAO.

ENTREGUE: crie .hbn/results/20260621-064000-grok-cross-ia-w-orq-4d-fix-0081.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260621-064000-grok-cross-ia-w-orq-4d-fix-0081.md
id-global: 20260621-064000-grok-cross-ia-w-orq-4d-fix-0081
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0081: SIM"
arvore: fronteira
created_at: "2026-06-21T06:40:00-03:00"
---

SOU: grok · familia xAI · papel auditor

<suas verificacoes com comando+saida e arquivo:linha, incluindo a reproducao das 2 burlas agora BLOQUEADAS>

APROVA_0081: SIM
(ultima linha = veredito exato: "APROVA_0081: SIM" OU "APROVA_0081: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
