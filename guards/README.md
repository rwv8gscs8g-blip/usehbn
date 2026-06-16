---
titulo: Guards canônicos do protocolo — conjunto executável de governança
status: accepted
temperatura: quente
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente C3)
origem: promovido de Credenciamento/scripts/hbn-guards/ (doutrina viva, batida em campo nos incidentes de 2026-05-02 e 2026-05-24)
hearback-status: confirmado 2026-06-10 (readback 0001 / hearback 0001)
---

# guards/ — o conjunto canônico

Promoção 1:1 dos guards maduros do Credenciamento, com TRÊS diffs e só três:

1. Headers de path (`scripts/hbn-guards/` → `guards/`).
2. `lib/common.sh` ganha `guard_diff_files()`: staged no pre-commit local,
   range `HBN_DIFF_BASE...HEAD` em CI (o Shield exporta a base). Os guards
   `forbid-env-files`, `forbid-legacy-paths` e `assert-scope-lock` usam o helper.
3. `assert-canonical-root` pula em `CI=true` — raiz canônica é invariante da
   máquina do operador, não do runner.

Conjunto (ordem do runner): `assert-canonical-root` → `forbid-tmp-worktree` →
`forbid-env-files` → `forbid-legacy-paths` → `assert-scope-lock`.
Runner: `bash guards/hbn-guards-runner.sh` (pre-commit local e CI).

Config: `.hbn/canonical-root` (1 linha, raiz física esperada do repo),
`.hbn/active-version` (1 linha: `.` ou `versao_X_Y_Z`) e
`.hbn/forbidden-paths.txt` (opcional; sem ele o guard de legacy libera).
`guards/lib/common.sh::get_canonical_root()` resolve a raiz operacional da
versão ativa; com `.` o comportamento permanece igual ao da raiz atual.

Hooks locais em `.git/hooks/pre-commit` e `.git/hooks/commit-msg` são shims
finos com marcador `HBN_HOOK_SHIM_VERSION=M-A-20260614`. Eles leem
`.hbn/active-version` e delegam ao runner/guards da versão ativa. O runner faz
pre-flight e bloqueia se os hooks estiverem ausentes ou desatualizados.
Bypass de emergência: `HBN_GUARDS_BYPASS=1` + `[bypass-hbn-guards]` na
mensagem + nota em `.hbn/bypasses/` — nunca para raiz canônica.

## Meta-paths

`assert-scope-lock` dispensa `scope.files_allowed` apenas para meta-paths de
coordenacao com tipo e nome controlados: arquivos `.json` ou `.md` cujo
basename siga ADR-025 (`AAAAMMDD-HHMMSS-<agente>-<slug>.{json,md}`),
hearbacks do readback ativo (`.hbn/hearbacks/NNNN-*.{json,md}`), e
nomes-endereco conhecidos como `.hbn/relay/INDEX.md`. Qualquer outro arquivo em
`.hbn/messages/`, `.hbn/bypasses/` ou `.hbn/hearbacks/` cai no scope-lock
normal e precisa estar declarado em `scope.files_allowed`.

Symlinks sao proibidos em paths de coordenacao governados: qualquer entrada
staged sob `.hbn/**` com modo git `120000` e bloqueada antes da dispensa de
meta-path, mesmo que o basename siga ADR-025. Nao ha uso legitimo de symlink
nesses caminhos.

Conforme knowledge 0021 (Credenciamento): em sandbox o guard é informativo;
conclusivo no Terminal do operador. O CI (Shield, `.github/workflows/hbn-shield.yml`)
é o terceiro ponto de verificação: guards + pytest verdes como portão de merge.

O CLI Python (`src/usehbn/`) permanece implementação de REFERÊNCIA — os guards
não dependem dele (decisão Q3; só `assert-scope-lock` usa python3 para parsear
JSON, qualquer python3 serve).
