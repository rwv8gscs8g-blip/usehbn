---
titulo: "Cross-audit ADVERSARIAL — Onda B19 (symlink governado geral / readback 0023)"
tipo: audit-result
agente: cursor
familia: Cursor
implementador_auditado: codex
readback: 0023
tip_auditado: 3f62bbd
base_b19: a434095
main_ref: 4db6928
data: 2026-06-15T23:46:41-03:00
created_at: "2026-06-15T23:46:41-03:00"
path: .hbn/results/20260615-234641-cursor-cross-ia-b19-symlink-geral.md
id-global: 20260615-234641-cursor-cross-ia-b19-symlink-geral
status: congelado
temperatura: glacier
---

# Cross-audit adversarial B19 — cursor (2ª opinião)

PAPEL auditor · TOKEN cursor · FAMÍLIA Cursor · CONTEXTO ~72% · auditando do disco

## Regra zero

```
$ pwd
/Users/macbookpro/Projetos

$ cd /Users/macbookpro/Projetos/usehbn && GIT_OPTIONAL_LOCKS=0 git status
On branch proposta/reestruturacao-m-a-s0
Untracked files present (handoffs antigos, results cross-ia anteriores, dirs adv-cr.* em guards/tests/)
nothing added to commit

$ git rev-parse HEAD
3f62bbde0fd9554c284157afb350c9c4962e850e

$ git log --oneline a434095..HEAD
3f62bbd chore(hbn): hand off B19 for cross-audit
84abc42 test(guards): cover B19 governed symlink block
8b35c40 fix(guards): block symlinks in all governed paths
ca5204d chore(hbn): open B19 symlink-governed wave
```

## 1. Separação, trailers, main, ADR-025, REGISTRY

| Commit | Arquivos | Trailers (3) |
|---|---|---|
| ca5204d | readback 0023 + REGISTRY | HBN-Readback: 0023 · HBN-Human-Authorization · HBN-Token-FP: 34a7f2f9 |
| 8b35c40 | `guards/assert-scope-lock.sh`, `guards/README.md` | idem |
| 84abc42 | `adversarial-battery.sh`, `run-guard-tests.sh` | idem |
| 3f62bbd | STATE, handoff, REGISTRY (+2 linhas) | idem |

- **main intocada:** `git rev-parse main` → `4db692876381a0d7909985c8500d999f2e677b04`; `git merge-base main HEAD` = mesmo SHA.
- **ADR-025:** meta-path dispensa basename `AAAAMMDD-HHMMSS-<agente>-<slug>.{json,md}`; B19 generaliza proibição de modo `120000` para **qualquer** arquivo staged avaliado pelo guard, antes de scope ou dispensa (`guards/README.md:49-55`, `assert-scope-lock.sh:254-263`, `337-341`).
- **REGISTRY B19** (`REGISTRY.md:612-624`): seção onda B19 + 3 linhas (readback, state, handoff). Pareceres cross-ia **não** depositados (correto para este auditor).

## 2. Readback 0023 — coerência

| Campo | Verificação |
|---|---|
| `scope.files_allowed` | ⊆ paths tocados nos 4 commits (handoff C4 via meta-path ADR-025 auto-permitido) |
| `scope.files_forbidden` | inclui main, src, seis untracked antigos |
| `action_plan` / `invariants` | 4 commits separados; trailers 0023 |
| `out_of_scope` | hardlink explicitamente non-issue |
| `status` | `in_progress` — coerente (cross-audit pendente → este parecer) |

## 3. Suítes (host, fora do sandbox)

```
$ bash guards/tests/run-guard-tests.sh 2>&1 | tail -3
== resumo: 145 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.

$ bash guards/tests/adversarial-battery.sh 2>&1 | grep B19
B19 symlink em guards/ permitido por escopo          | G-SCO    | BLOQUEADA ✓

$ bash guards/hbn-guards-runner.sh 2>&1 | tail -2
[hbn-guards] Todos os guards passaram.
RC=0
```

## 4. Diff 8b35c40 vs README §Meta-paths

Implementação (`8b35c40`) e README (`guards/README.md:49-55`) **alinhados**: renomeação `is_governed_hbn_symlink` → `is_governed_symlink` sem filtro `.hbn/*`; `guard_version_repo_path` preserva detecção em `versao_*`; mensagem de erro generalizada (`assert-scope-lock.sh:360-363`); hardlink documentado como `100644` fora do escopo.

## 5. ADVERSARIAL — repo isolado

| Vetor | Modo git | rc | Resultado |
|---|---|---|---|
| **a1)** symlink ADR-025 `.hbn/messages/` | 120000 | 1 | **BLOCK** ✓ |
| **a2)** symlink `guards/` (files_allowed) | 120000 | 1 | **BLOCK** ✓ |
| **a3)** symlink `core/` (files_allowed) | 120000 | 1 | **BLOCK** ✓ |
| **b)** symlink `versao_1_0_0/guards/` | 120000 | 1 | **BLOCK** ✓ |
| **c1)** symlink `methodology/` | 120000 | 1 | **BLOCK** ✓ |
| **c2)** symlink `REGISTRY.md` | 120000 | 1 | **BLOCK** ✓ |
| **d)** hardlink `guards/` | 100644 | 0 | **PASS** ✓ (non-issue declarado) |
| **e)** regulares `guards/core/src` | 100644 | 0 | **PASS** ✓ |

### c) Path governado esquecido pelo predicado?

**Não verificado como furo.** `is_governed_symlink` (`assert-scope-lock.sh:254-263`) não filtra por prefixo de path: qualquer entrada em `$STAGED` com modo `120000` no índice (ou `HEAD` em CI via `HBN_DIFF_BASE`) bloqueia **antes** de `scope_allows` ou `is_meta_auto_allowed`. O predicado anterior B18 limitava a `.hbn/*`; B19 remove essa restrição.

### f) Classe symlink/meta-path (B17+B18+B19)

| Onda | Vetor fechado |
|---|---|
| B17 | smuggling meta-path tipo/nome arbitrário |
| B18 | symlink ADR-025 em `.hbn/**` passando pela dispensa |
| B19 | symlink em path governado não-`.hbn` com nome em `files_allowed` |

**Residual documentado (won't-fix):** hardlink smuggling — Git materializa como `100644`; readback 0023 `out_of_scope` e REGISTRY B18 selagem (`REGISTRY.md:600-602`) registram non-issue.

## TRUTH BARRIER

| Afirmação | Evidência |
|---|---|
| Predicado generalizado | `assert-scope-lock.sh:254-263`, `337-341` |
| Sem filtro `.hbn/*` | diff `8b35c40` remove `[[ "$file" == .hbn/* ]]` |
| 145 testes verdes | `run-guard-tests.sh` exit 0, resumo 145/145 |
| B19 adversarial bloqueada | `adversarial-battery.sh:269` → BLOQUEADA ✓ |
| main intocada | `git merge-base main HEAD` = `4db6928` |

**Confiança:** alta nos itens mecânicos (separação, trailers, suítes, adversarial isolado). **Não verificado:** comportamento em runtime de operador com `HBN_GUARDS_BYPASS=1` (fora do recorte B19).

## Veredito

**APROVA_B19: SIM**

**Furos:** nenhum no recorte B19 (symlink modo `120000` em paths governados avaliados pelo scope-lock). Hardlink permanece non-issue documentado — não é furo B20.

**classe FECHADA: SIM** — para symlink/meta-path no `assert-scope-lock` após B17+B18+B19, com exceção explícita e aceita de hardlink (`100644`).

## Linha REGISTRY (não depositada — entrega em texto)

```
| 20260615-234641-cursor-cross-ia-b19-symlink-geral | .hbn/results/20260615-234641-cursor-cross-ia-b19-symlink-geral.md | audit-result | frio | — | 2026-06-15T23:46:41-03:00 |
```
