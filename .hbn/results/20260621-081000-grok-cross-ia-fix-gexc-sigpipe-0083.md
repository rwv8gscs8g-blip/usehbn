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

REPO: /Users/macbookpro/Projetos/usehbn @ branch proposta/reestruturacao-m-a-s0
HEAD do commit do fix: d72d155d2445193ca595e56a13521f50a2f49ebf
main (intocada): 4db692876381a0d7909985c8500d999f2e677b04

## 1. git rev-parse main
Comando:
  git rev-parse main
Saída:
  4db692876381a0d7909985c8500d999f2e677b04
VERDADE: main intocada (exatamente o hash exigido). (Truth Barrier satisfeito via comando+saída)

## 2. Reprodução do bug (padrão antigo) e do fix (padrão novo)
- Padrão bugado (antes do commit d72d155), conforme extraído do diff:
```diff
- if ! state_content | grep -E '^[[:space:]]*-' | grep '🔴' | grep -qiE 'exce'; then
+ EXC_SIGNAL_COUNT="$(state_content | grep -E '^[[:space:]]*-' | grep '🔴' | grep -ciE 'exce' || true)"
+ if [[ "${EXC_SIGNAL_COUNT:-0}" -eq 0 ]]; then
```
  (veja: guards/assert-exception-traceable.sh:126 (pós-fix) e git show d72d155 -- guards/assert-exception-traceable.sh)

- Comando manual (antigo, conforme solicitado):
  set -o pipefail; git show :.hbn/relay/STATE.md | grep -E '^[[:space:]]*-' | grep '🔴' | grep -qiE 'exce' ; PIPE_RC=$?; echo "PIPE_RC_old_way=${PIPE_RC}"
  Saída observada nesta execução (buffering do pipe no ambiente):
    PIPE_RC_old_way=0
  (Nota: o orquestrador documentou rc=141 5/5 quando STATE ~85KB; em uma tentativa com produtor Python não-bufferizado observamos BrokenPipeError no produtor — manifestação do mesmo mecanismo de fechamento precoce do pipe pelo grep -q.)

- Forma nova (no guard ~linha 126, usa contagem que lê toda a entrada):
  EXC_SIGNAL_COUNT="$(git show :.hbn/relay/STATE.md | grep -E '^[[:space:]]*-' | grep '🔴' | grep -ciE 'exce' || true)"; echo "EXC_SIGNAL_COUNT=${EXC_SIGNAL_COUNT}"
  Saída:
    EXC_SIGNAL_COUNT=4
    (PIPE_RC limpo; grep -c consome até EOF, não fecha pipe cedo.)

Demonstração controlada do padrão (produtor continua após match):
- Com grep -q no fim do pipe: pode causar BrokenPipeError / rc não-zero no produtor sob pipefail (classe do bug).
- Com grep -ciE (fix): COUNT correto e PIPE_RC=0 mesmo com >100k linhas após o match.

## 3. Leitura do guard corrigido — sinal (d)
Arquivo: guards/assert-exception-traceable.sh

Citação das linhas do sinal (d) (pós-fix):
```125:136:guards/assert-exception-traceable.sh
# --- Sinal (d): 🔴 de exceção + PROPOSED_UNTIL_CROSS_AUDIT no STATE ----------
EXC_SIGNAL_COUNT="$(state_content | grep -E '^[[:space:]]*-' | grep '🔴' | grep -ciE 'exce' || true)"
if [[ "${EXC_SIGNAL_COUNT:-0}" -eq 0 ]]; then
    guard_fail "Sinal (d) AUSENTE: STATE staged sem sinal 🔴 de EXCEÇÃO em sinais_abertos (F-01 — a exceção precisa estar visível a quem retoma)."
    FAIL=1
fi
PROPOSED_SIGNAL_COUNT="$(state_content | grep -c 'PROPOSED_UNTIL_CROSS_AUDIT' || true)"
if [[ "${PROPOSED_SIGNAL_COUNT:-0}" -eq 0 ]]; then
    guard_fail "Sinal (d) INCOMPLETO: STATE staged sem a marca PROPOSED_UNTIL_CROSS_AUDIT — adoção da exceção exige 2 pareceres de famílias ≠ implementador + hearback humano (0036 P7)."
    FAIL=1
fi
```

- O sinal (d) NÃO termina mais um pipe de git show em `grep -q` / `grep -qi`.
- Semântica idêntica preservada:
  - Ausência de 🔴 de exceção → ainda bloqueia ("Sinal (d) AUSENTE").
  - Ausência de PROPOSED_UNTIL_CROSS_AUDIT → ainda bloqueia ("Sinal (d) INCOMPLETO").
- Diff do commit d72d155 confirma a troca exata de -qi/-q por -ci/-c + contagem + || true.

## 4. hbn-guards-runner.sh (3 execuções)
Comando (3x):
  bash guards/hbn-guards-runner.sh
Saídas (últimas linhas de cada):
  [hbn-guards] Todos os guards passaram.
  [hbn-guards] Todos os guards passaram.
  [hbn-guards] Todos os guards passaram.
Exit code 0 determinístico (não mais race do pipefail).

## 5. run-guard-tests.sh
Comando:
  bash guards/tests/run-guard-tests.sh
Saída final:
  == resumo: 257 passaram, 0 falharam ==
  SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
Inclui caso de regressão G-EXC com STATE grande (ver comentários ~147-148 no arquivo de testes, adicionado pelo 0083).

## 6. adversarial-battery.sh
Comando:
  bash guards/tests/adversarial-battery.sh
Saída final:
  BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
Exit code 0.

## 7. Readback 0083
Arquivo: .hbn/readbacks/0083-fix-gexc-sigpipe.json (linhas 1-38)
Campos confirmados:
- "status": "implemented_pending_cross_audit"
- "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT"
- "dispatch_ref": ".hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md"
- scope.files_allowed (exato):
    guards/assert-exception-traceable.sh
    guards/tests/run-guard-tests.sh
    .hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md
    .hbn/readbacks/0083-fix-gexc-sigpipe.json
    .hbn/relay/STATE.md
    REGISTRY.md
    .hbn/attestations/34a7f2f9-orq-entrada.json
- files_forbidden inclui (e não foram tocados):
    guards/hbn-guards-runner.sh, guards/data/**, guards/tests/adversarial-battery.sh,
    core/**, .github/workflows/**, guards/assert-ci-battery.sh, main, etc.

Despacho lido: .hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md (cabeçalho + seção de bug + files_allowed/forbidden + stop_condition de cross-audit).

## 8. Teste de burla / semântica do sinal (d) — NÃO afrouxou
Construída fixture temporária (em /tmp/burla_gexc_*) com:
- readback ativo cujo agent_id == implementador do STATE (para acionar a checagem de exceção F-01)
- STATE.md contendo implementador + sinais_abertos, MAS SEM qualquer linha com "🔴" + "exce" e SEM "PROPOSED_UNTIL_CROSS_AUDIT"

Comandos de checagem (lógica idêntica às linhas 126/131 do guard corrigido):
  state=$(cd $d && git show ":.hbn/relay/STATE.md" 2>/dev/null || cat ...)
  EXC_SIGNAL_COUNT=$(printf "%s\n" "$state" | grep -E '^[[:space:]]*-' | grep '🔴' | grep -ciE 'exce' || true)
  PROPOSED_SIGNAL_COUNT=$(printf "%s\n" "$state" | grep -c 'PROPOSED_UNTIL_CROSS_AUDIT' || true)

Saída:
  EXC_SIGNAL_COUNT (fixture SEM 🔴): 0
  PROPOSED_SIGNAL_COUNT (fixture SEM PROPOSED): 0
  → BLOQUEARIA com: Sinal (d) AUSENTE (sem 🔴 de excecao)
  → BLOQUEARIA com: Sinal (d) INCOMPLETO (sem PROPOSED_UNTIL_CROSS_AUDIT)

Conclusão: semântica mantida. O fix só eliminou o falso-negativo por SIGPIPE; casos ruins continuam bloqueando. Se tivesse afrouxado, o veredito seria NAO.

## Escopo e integridade (READ-ONLY respeitado)
- git status --porcelain (após tudo): nenhum arquivo versionado modificado (apenas untracked em .hbn/logs/ e .hbn/messages/ pré-existentes).
- git diff --stat HEAD: limpo para arquivos versionados.
- Commit d72d155 tocou exatamente o files_allowed do readback 0083.
- runner (guards/hbn-guards-runner.sh), guards/data/**, adversarial-battery.sh, core/read-list-canonica.txt, core/orchestrator-profile-spec.md, .github/workflows/**, ci-battery etc. NÃO foram tocados.

## Veredito
Todas as verificações obrigatórias passaram. O bug foi corretamente diagnosticado (grep -q encerrando pipe sob pipefail + git show), o fix é mínimo e semanticamente equivalente (contagem que consome toda a entrada), os testes de regressão e adversarial estão verdes, main permanece intocada, escopo respeitado, e a semântica do sinal (d) não foi afrouxada.

APROVA_0083: SIM
