---
titulo: "Prompt cross-audit W-ORQ-4a / G-READLIST-RITE (0074) — antigravity/Google"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-004500-opus-4-8-prompt-cross-audit-w-orq-4a-0074-antigravity.md
created_at: "2026-06-21T00:45:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "antigravity (Google) — auditor cruzado"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# Prompt cross-audit W-ORQ-4a (0074) — antigravity

⟦HBN-COPY dest=antigravity⟧ BEGIN
PAPEL: auditor cruzado (familia Google, != OpenAI). Chat NOVO, sem memoria; tudo autossuficiente. READ-ONLY: NAO comite, NAO use --no-verify, NAO altere arquivos versionados (k-0025).
PRIMEIRA LINHA da sua resposta E do parecer, EXATA: SOU: antigravity · familia Google · papel auditor
REPO: ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0. VERDADE = disco: confirme por arquivo:linha ou comando+saida (Truth Barrier).

ALVO: ratificar (ou reprovar) o W-ORQ-4a / G-READLIST-RITE — readback .hbn/readbacks/0074-w-orq-4a-readlist-rite.json, guard guards/assert-readlist-rite.sh, despacho .hbn/messages/20260621-003000-opus-4-8-despacho-w-orq-4a-readlist-rite.md (commit 985302a). G-READLIST-RITE = todo commit que ADICIONA/MODIFICA core/read-list-canonica.txt so passa se um readback staged declarar read_list_rite (nao-vazio) + human_status == confirmed; senao bloqueia (fail-closed, forward-only, blob staged).

VERIFICACOES OBRIGATORIAS (rode e cite a saida):
1. git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA).
2. Leia guards/assert-readlist-rite.sh e cite linhas: gatilho (core/read-list-canonica.txt em diff-filter=AM); exigencia de readback staged com read_list_rite nao-vazio E human_status confirmed; fail-closed; guard_check_bypass.
3. grep -n assert-readlist-rite guards/hbn-guards-runner.sh (esta no runner).
4. bash guards/hbn-guards-runner.sh -> "Todos os guards passaram".
5. bash guards/tests/run-guard-tests.sh -> 0 falharam.
6. bash guards/tests/adversarial-battery.sh -> BATERIA VERDE. Confirme os casos (B76+) que cobrem: read-list modificada SEM readback; readback SEM read_list_rite; read_list_rite com human_status != confirmed. E o caso NEUTRO (commit sem tocar a read-list passa).
7. readback 0074: status == implemented_pending_cross_audit; activation_status == PROPOSED_UNTIL_CROSS_AUDIT; escopo files_allowed respeitado; este commit NAO tocou core/read-list-canonica.txt nem guards/data/**.
8. Burla a procurar: alguma edicao de core/read-list-canonica.txt que passe SEM rito declarado; falso-verde; o guard reavaliando commits passados; drift de escopo. Se achar, descreva reproduzivel e vote NAO.

ENTREGUE: crie .hbn/results/20260621-010000-antigravity-cross-ia-w-orq-4a-0074.md (UNTRACKED — NAO comite) com EXATAMENTE:
---
path: .hbn/results/20260621-010000-antigravity-cross-ia-w-orq-4a-0074.md
id-global: 20260621-010000-antigravity-cross-ia-w-orq-4a-0074
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0074: SIM"
arvore: fronteira
created_at: "2026-06-21T01:00:00-03:00"
---

SOU: antigravity · familia Google · papel auditor

<suas verificacoes com comando+saida e arquivo:linha>

APROVA_0074: SIM
(ultima linha = veredito exato: "APROVA_0074: SIM" OU "APROVA_0074: NAO" + achados.)
⟦HBN-COPY END⟧

— FIM DO PROMPT —
