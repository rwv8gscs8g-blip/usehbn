---
titulo: "Prompt cross-audit W-ORQ-4d-fix-2 / CI entrypoint igualdade-exata (0082) — grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-090000-opus-4-8-prompt-cross-audit-w-orq-4d-fix2-0082-grok.md
created_at: "2026-06-21T09:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "grok (xAI) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit W-ORQ-4d-fix-2 (0082) — grok

⟦HBN-COPY dest=grok⟧ BEGIN
PAPEL: auditor cruzado (familia xAI, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: grok · familia xAI · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

CONTEXTO: as 2 versoes anteriores do G-CI-BATTERY foram reprovadas (burlas comentario/echo/heredoc — parser estatico nao distingue invocacao de string literal). Este e o REDESENHO por IGUALDADE EXATA (readback 0082). O runner agora esta verde (bug G-EXC/SIGPIPE corrigido e selado em 0084).

ALVO: ratificar (ou reprovar) o W-ORQ-4d-fix-2 — readback .hbn/readbacks/0082-w-orq-4d-fix2-ci-entry.json, guards/assert-ci-battery.sh, guards/ci-entry.sh, .github/workflows/hbn-shield.yml. Design: o workflow tem UM step `run:` cujo comando e EXATAMENTE `bash guards/ci-entry.sh` (igualdade exata, nao substring); guards/ci-entry.sh roda runner+suite+bateria; G-CI-BATTERY valida (A) igualdade exata no workflow e (B) invocacoes reais (heredoc-aware) no ci-entry.sh.

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia guards/ci-entry.sh: confirme set -e e as 3 invocacoes reais (runner, suite, bateria).
3. Leia .github/workflows/hbn-shield.yml: confirme um step `run: bash guards/ci-entry.sh` (exato) e YAML valido.
4. Leia guards/assert-ci-battery.sh: confirme (A) igualdade exata e (B) ci-entry.sh invoca os 3 de verdade (heredoc-aware). Cite linhas.
5. ATAQUE num fixture descartavel e confirme que TODAS BLOQUEIAM: (a) `run: echo "bash guards/ci-entry.sh"`; (b) heredoc com `bash guards/ci-entry.sh` como dado; (c) comentario inline; (d) sem o step exato. O caso BOM PASSA. ci-entry.sh com invocacao em heredoc/echo => BLOQUEIA.
6. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram"; bash guards/tests/run-guard-tests.sh -> 0 falharam; bash guards/tests/adversarial-battery.sh -> BATERIA VERDE (B85/B86/B87).
7. readback 0082: status implemented_pending_cross_audit; PROPOSED_UNTIL_CROSS_AUDIT; escopo respeitado; read-list, guards/data, orchestrator-profile-spec, runner NAO tocados.
8. Procure nova burla a igualdade exata (anchors yaml, multiplos run, normalizacao de espacos, aspas). Se achar, vote NAO.

ENTREGUE: crie .hbn/results/20260621-091000-grok-cross-ia-w-orq-4d-fix2-0082.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260621-091000-grok-cross-ia-w-orq-4d-fix2-0082.md
id-global: 20260621-091000-grok-cross-ia-w-orq-4d-fix2-0082
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0082: SIM"
arvore: fronteira
created_at: "2026-06-21T09:10:00-03:00"
---

SOU: grok · familia xAI · papel auditor

<suas verificacoes com comando+saida e arquivo:linha, incluindo as burlas agora BLOQUEADAS>

APROVA_0082: SIM
(ultima linha = veredito exato: "APROVA_0082: SIM" OU "APROVA_0082: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
