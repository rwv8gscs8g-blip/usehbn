---
titulo: "Resultado M-A — scaffold inativo da hbn-exuvia"
tipo: implementation-result
status: final
temperatura: frio
path: .hbn/results/20260614-183746-codex-m-a-scaffold-inativo.md
id-global: 20260614-183746-codex-m-a-scaffold-inativo
autoria: codex
created_at: "2026-06-14T18:37:46-03:00"
---

# Resultado M-A — scaffold inativo

## O que foi feito

- Criado `.hbn/active-version` apontando para `.`. O incumbente 0.3.x continua
  na raiz atual; nenhuma exuvia foi ativada.
- `guards/lib/common.sh` agora resolve `get_canonical_root()` pela versao ativa
  e normaliza paths Git `versao_*/*` para paths locais da versao.
- Hooks locais `.git/hooks/pre-commit` e `.git/hooks/commit-msg` foram trocados
  por shims fail-closed com marcador `HBN_HOOK_SHIM_VERSION=M-A-20260614`.
  Templates auditáveis foram versionados em `guards/hook-shims/`.
- Guards atualizados para operar com a versao ativa: G-CR, G-REG, G-STRAY,
  G-SLF, G-PTR, G-RLT, G-NUM, G-TOK, G-FAM, G-EXC, G-SCO, G-HRB, G-LEG e
  G-STR.
- Criado `core/hbn-exuvia-scaffold.md` com a politica de ponteiro, hooks,
  token x STATE, tag anti-GC, rollback e glacier.
- Criado `scripts/hbn-exuvia-rollback.sh`; o padrao e dry-run. `--apply`
  fica para M-C e exige operador.
- `.gitignore` ampliado para caches/artefatos (`node_modules/`, `.next/`,
  `.turbo/`, `coverage/`, `htmlcov/`, `tmp/`, `temp/`, `*.log`).
- `STATE.md` sincronizado para M-A, mantendo sinais abertos validos e sem dar
  baixa em F-01.

## Fora de escopo preservado

- Nao houve `git mv` da raiz para `versao_0_3_x/`.
- Nao foi criada `versao_1_0_0/`.
- Nao houve repontamento para outra versao.
- Nao houve escrita em `src/`, dominio, `examples/` ou `inbox/`.
- Nao houve baixa de F-01 nem criacao de hearback formal.
- A tag `hbn-exuvia/protocol-0.3.x` nao foi criada nesta onda; ela fica para o
  commit de congelamento real em M-C.

## Evidencia executada

```text
bash guards/tests/run-guard-tests.sh
== resumo: 132 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

```text
bash guards/tests/adversarial-battery.sh
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
15/15 burlas bloqueadas.
```

```text
bash guards/hbn-guards-runner.sh
[hbn-guards] Todos os guards passaram.
```

## Prova fail-closed

Ponteiro removido temporariamente:

```text
[hbn-hook/pre-commit] BLOQUEADO: ponteiro /Users/macbookpro/Projetos/usehbn/.hbn/active-version ausente ou ilegível
```

Ponteiro corrompido para versao inexistente:

```text
[hbn-hook/pre-commit] BLOQUEADO: versão ativa inexistente: versao_9_9_9
```

## Prova de regressao zero

Com `.hbn/active-version` restaurado para `.`:

```text
source guards/lib/common.sh; get_canonical_root
/Users/macbookpro/Projetos/usehbn
```

O runner real tambem permaneceu verde com essa resolucao.

## Rollback dry-run

Como a tag anti-GC ainda nao deve existir antes de M-C, o dry-run foi executado
contra `HEAD` para exercitar a reconciliacao token x STATE:

```text
scripts/hbn-exuvia-rollback.sh --dry-run --target HEAD
token_local: presente (34a7f2f9)
state_target_hash: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
DRY-RUN: nenhuma alteração aplicada.
Plano:
  1. preservar /Users/macbookpro/Projetos/usehbn/.git/hbn-baton-token
  2. git reset --hard HEAD
  3. reconciliar .hbn/relay/STATE.md: bastao_token_sha256=34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
  4. usar trailer HBN-Token-FP: 34a7f2f9
```

## Pontos para Gemini + Grok

- Confirmar se a politica de `G-STRAY` deve permitir toda `versao_*` sob um
  repo com `.hbn/active-version` ou apenas a versao ativa.
- Auditar se o pre-flight de hooks no runner e suficiente como mitigacao de
  clones sem onboarding, considerando que hook ausente nao executa a si mesmo.
- Confirmar a semantica de G-REG: paths no `REGISTRY.md` da versao continuam
  sem o prefixo `versao_*`.
- Revisar o script de rollback antes de M-C, especialmente o `--apply` com
  `git reset --hard`, que nao foi executado nesta onda.
- Validar o plano de glacier calendarizado antes de qualquer descida real.
