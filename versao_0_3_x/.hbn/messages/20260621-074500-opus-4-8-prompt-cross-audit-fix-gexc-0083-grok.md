---
titulo: "Prompt cross-audit fix-gexc-sigpipe (0083) — grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-074500-opus-4-8-prompt-cross-audit-fix-gexc-0083-grok.md
created_at: "2026-06-21T07:45:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "grok (xAI) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit fix-gexc-sigpipe (0083) — grok

⟦HBN-COPY dest=grok⟧ BEGIN
PAPEL: auditor cruzado (familia xAI, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: grok · familia xAI · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

ALVO: ratificar (ou reprovar) o fix-gexc-sigpipe — readback .hbn/readbacks/0083-fix-gexc-sigpipe.json, guard guards/assert-exception-traceable.sh (CORRIGIDO), despacho .hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md (commit d72d155). Bug corrigido: o sinal (d) do G-EXC usava pipelines terminadas em `grep -q` cuja cabeca e `git show` (state_content); sob `set -euo pipefail`, o grep -q fechava o pipe cedo, git show levava SIGPIPE(141) e o pipefail reportava falha (falso 'Sinal (d) AUSENTE') quando o STATE ficou grande. Fix: trocar por contagem que le toda a entrada (grep -c) / here-string.

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. REPRODUZA o bug e o fix:
   - Forma antiga (manual): `set -o pipefail; git show :.hbn/relay/STATE.md | grep -E '^[[:space:]]*-' | grep '🔴' | grep -qiE 'exce'; echo $?` => 141 (falso-negativo).
   - Forma nova (no guard, ~linha 126): `grep -ciE 'exce'` (le toda a entrada) => sem SIGPIPE.
3. Leia guards/assert-exception-traceable.sh: confirme que o sinal (d) (🔴 de excecao + PROPOSED_UNTIL_CROSS_AUDIT) NAO termina mais um pipe de git show em `grep -q`; confirme SEMANTICA IGUAL (sem 🔴 de excecao ainda bloqueia; sem PROPOSED_UNTIL_CROSS_AUDIT ainda bloqueia). Cite linhas.
4. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram". Rode 3x (exit 0 determinístico — era race).
5. bash guards/tests/run-guard-tests.sh -> 0 falharam (caso de regressao G-EXC com STATE grande).
6. bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
7. readback 0083: status implemented_pending_cross_audit; PROPOSED_UNTIL_CROSS_AUDIT; escopo files_allowed respeitado; runner, guards/data, read-list, orchestrator-profile-spec, workflow, ci-battery NAO tocados.
8. Burla a procurar: o fix AFROUXOU o sinal (d)? Construa fixture SEM 🔴 de excecao e confirme que AINDA BLOQUEIA. Se mudou a semantica / deixou passar caso ruim, vote NAO.

ENTREGUE: crie .hbn/results/20260621-081000-grok-cross-ia-fix-gexc-sigpipe-0083.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260621-081000-grok-cross-ia-fix-gexc-sigpipe-0083.md
id-global: 20260621-081000-grok-cross-ia-fix-gexc-sigpipe-0083
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0083: SIM"
arvore: fronteira
created_at: "2026-06-21T08:10:00-03:00"
---

SOU: grok · familia xAI · papel auditor

<suas verificacoes com comando+saida e arquivo:linha>

APROVA_0083: SIM
(ultima linha = veredito exato: "APROVA_0083: SIM" OU "APROVA_0083: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
