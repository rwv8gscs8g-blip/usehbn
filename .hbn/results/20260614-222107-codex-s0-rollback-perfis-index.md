---
titulo: "Resultado S0 — rollback, perfis e INDEX"
tipo: implementation-result
status: final
temperatura: frio
path: .hbn/results/20260614-222107-codex-s0-rollback-perfis-index.md
id-global: 20260614-222107-codex-s0-rollback-perfis-index
autoria: codex
created_at: "2026-06-14T22:21:07-03:00"
---

# Resultado S0 — rollback, perfis e INDEX

## O que foi feito

- Corrigido `scripts/hbn-exuvia-rollback.sh` para resolver `state_path` a partir
  do `TARGET`, não do active-version da working tree anterior ao reset.
- Adicionado `scripts/tests/test-hbn-exuvia-rollback.sh`, cobrindo `HEAD` e
  `TARGET` com `.hbn/active-version` divergentes; `--dry-run` não altera o
  worktree e `--apply` reconcilia o STATE certo.
- Criados `.hbn/models/grok.json` e `.hbn/models/cursor.json` com o conteúdo
  autorizado e validados contra `schemas/model-profile.schema.json`.
- Reconciliado `.hbn/relay/INDEX.md` como superseded, apontando `STATE.md` como
  fonte canônica.
- Removidas as quatro fixtures untracked indicadas em `guards/tests/`.
- Atualizados `STATE.md`, readback 0013, REGISTRY, handoff e result da onda.

## Evidência executada

```text
bash guards/tests/run-guard-tests.sh
== resumo: 132 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

```text
bash guards/tests/adversarial-battery.sh
B1 nome serial novo em .hbn/results/                 | G-NUM    | BLOQUEADA ✓
B2 created_at UTC (Z) no REGISTRY                    | G-NUM    | BLOQUEADA ✓
B3 CI=true local (sem CI real)                       | G-CR     | BLOQUEADA ✓
B4 bypass env sem nota em .hbn/bypasses/             | comuns   | BLOQUEADA ✓
B5 .hbn órfão a 5 níveis de profundidade             | G-STRAY  | BLOQUEADA ✓
B6 symlink .hbn órfão                                | G-STRAY  | BLOQUEADA ✓
B7 .hbn escondido sob backups2/                      | G-STRAY  | BLOQUEADA ✓
B8 HBN_SCAN_ROOT apontando para o nada               | G-STRAY  | BLOQUEADA ✓
B9 scope vazio em safe_track                         | G-SCO    | BLOQUEADA ✓
B10 implementador == auditor (groupthink)            | G-FAM    | BLOQUEADA ✓
B11 hearback sem assinatura (chave registrada)       | G-HRB    | BLOQUEADA ✓
B12 hearback no mesmo commit da obra                 | G-HRB    | BLOQUEADA ✓
B13 exceção impl==agente sem os 4 sinais             | G-EXC    | BLOQUEADA ✓
B14 arquivo de token local ERRADO + FP do log        | G-TOK    | BLOQUEADA ✓
B15 active-version com conflito de merge             | G-CR     | BLOQUEADA ✓
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

```text
bash guards/hbn-guards-runner.sh
[hbn-guards] Todos os guards passaram.
```

```text
bash scripts/tests/test-hbn-exuvia-rollback.sh
PASS: rollback --apply reconcilia STATE usando active-version do TARGET; --dry-run nao altera o worktree
```

## Pontos Para Auditoria Cruzada

- Confirmar que o rollback usa o `.hbn/active-version` do `TARGET` em todos os
  caminhos críticos, inclusive `git show "${TARGET}:${state_path}"` e
  reconciliação pós-`git reset --hard`.
- Confirmar que o teste novo prova a regressão D3 sem depender da árvore real do
  repo canônico.
- Revisar se os perfis `grok` e `cursor` permanecem corretamente em `proposed`,
  sem declarar papéis ou contexto não verificados.
- Confirmar que o `INDEX.md` agora não pode mais induzir handoff por estado
  antigo de abril e que `STATE.md` é a única fonte canônica.
- Confirmar que S0 não alterou lógica de guard, `core/`, `src/`, `examples/`,
  `inbox/`, `site/` ou `.hbn/hearbacks/`.
- Conferir que o próximo despacho exclui OpenAI dos auditores: Gemini (Google)
  + Grok (xAI) ou Cursor, com autodeclaração do modelo real.
