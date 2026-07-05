---
titulo: "Prompt re-cross-audit W-ORQ-4d-fix / G-CI-BATTERY endurecido (0081) — antigravity/Google"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-061500-opus-4-8-prompt-cross-audit-w-orq-4d-fix-0081-antigravity.md
created_at: "2026-06-21T06:15:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "antigravity (Google) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt re-cross-audit W-ORQ-4d-fix (0081) — antigravity

⟦HBN-COPY dest=antigravity⟧ BEGIN
PAPEL: auditor cruzado (familia Google, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: antigravity · familia Google · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

CONTEXTO: voce REPROVOU o W-ORQ-4d (0080) achando 2 bypasses no G-CI-BATTERY (comentario inline e echo do path). Este e o FIX (readback 0081, commit be18335). RE-AUDITE: confirme que as DUAS burlas que voce reportou agora sao BLOQUEADAS.

ALVO: ratificar (ou reprovar) o W-ORQ-4d-fix — readback .hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json, guard guards/assert-ci-battery.sh (ENDURECIDO). Agora o guard exige invocacao REAL de bash guards/tests/run-guard-tests.sh e bash guards/tests/adversarial-battery.sh num step run (remove comentario inline; rejeita echo/aspas).

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia guards/assert-ci-battery.sh: confirme o novo algoritmo (strip de comentario inline " #..."; tokenizacao do comando; segmento deve COMECAR com `bash <script>`; echo/aspas nao contam). Cite linhas.
3. REPRODUZA suas 2 burlas num fixture descartavel e confirme que agora o guard BLOQUEIA (exit != 0):
   (a) workflow com `- run: echo "skip" # bash guards/tests/run-guard-tests.sh`  -> deve BLOQUEAR.
   (b) workflow com `- run: echo "bash guards/tests/adversarial-battery.sh"`     -> deve BLOQUEAR.
   E o caso BOM (workflow real, com `bash <script>` de verdade) PASSA.
4. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram".
5. bash guards/tests/run-guard-tests.sh -> 0 falharam.
6. bash guards/tests/adversarial-battery.sh -> BATERIA VERDE. Confirme B85 (comentario inline) e B86 (echo) BLOQUEADOS.
7. readback 0081: status implemented_pending_cross_audit; PROPOSED_UNTIL_CROSS_AUDIT; escopo files_allowed respeitado; .github/workflows/**, read-list, guards/data, orchestrator-profile-spec NAO tocados (o fix e so no guard/testes).
8. Procure NOVAS burlas equivalentes (ex.: `: ` no-op, `true && echo`, heredoc, `bash -c "echo ..."`, indentacao enganosa em bloco run: |). Se achar uma que ainda passe, descreva reproduzivel e vote NAO.

ENTREGUE: crie .hbn/results/20260621-063000-antigravity-cross-ia-w-orq-4d-fix-0081.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260621-063000-antigravity-cross-ia-w-orq-4d-fix-0081.md
id-global: 20260621-063000-antigravity-cross-ia-w-orq-4d-fix-0081
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0081: SIM"
arvore: fronteira
created_at: "2026-06-21T06:30:00-03:00"
---

SOU: antigravity · familia Google · papel auditor

<suas verificacoes com comando+saida e arquivo:linha, incluindo a reproducao das 2 burlas agora BLOQUEADAS>

APROVA_0081: SIM
(ultima linha = veredito exato: "APROVA_0081: SIM" OU "APROVA_0081: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
