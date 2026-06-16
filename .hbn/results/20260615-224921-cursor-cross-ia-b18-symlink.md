---
titulo: "Cross-audit ADVERSARIAL — Onda B18 (symlink meta-path / readback 0021)"
tipo: audit-result
agente: cursor
familia: Cursor
implementador_auditado: codex
readback: 0021
tip_auditado: 41ea34f
base_b18: 4ed86cd
main_ref: 4db6928
data: 2026-06-15T22:49:21-03:00
created_at: "2026-06-15T22:49:21-03:00"
path: .hbn/results/20260615-224921-cursor-cross-ia-b18-symlink.md
id-global: 20260615-224921-cursor-cross-ia-b18-symlink
---

# Cross-audit adversarial B18 — cursor (2ª opinião)

PAPEL auditor · TOKEN cursor · FAMÍLIA Cursor · CONTEXTO ~68% · auditando do disco

## Regra zero

```
$ pwd
/Users/macbookpro/Projetos

$ cd /Users/macbookpro/Projetos/usehbn && GIT_OPTIONAL_LOCKS=0 git status
On branch proposta/reestruturacao-m-a-s0
Untracked files present (handoffs antigos, results cross-ia anteriores, dirs adv-cr.* em guards/tests/)
nothing added to commit

$ git rev-parse HEAD
41ea34f8b22ff06cc9c2d52ed792fe2f06516acd

$ git log --oneline 4ed86cd..HEAD
41ea34f b18: atualiza estado e handoff
3160a53 b18: cobre symlink em meta-path nos testes
703051c b18: bloqueia symlink em meta-path governado
889fbbb b18: abre readback de bloqueio de symlink
```

## 1. Separação, trailers, main, ADR-025, REGISTRY

| Commit | Arquivos | Trailers (3) |
|---|---|---|
| 889fbbb | readback 0021 + REGISTRY | HBN-Readback: 0021 · HBN-Human-Authorization · HBN-Token-FP: 34a7f2f9 |
| 703051c | `guards/assert-scope-lock.sh`, `guards/README.md` | idem |
| 3160a53 | `adversarial-battery.sh`, `run-guard-tests.sh` | idem |
| 41ea34f | STATE, handoff, REGISTRY (+2 linhas) | idem |

- **main intocada:** `git rev-parse main` → `4db692876381a0d7909985c8500d999f2e677b04`; `git merge-base main HEAD` = mesmo SHA.
- **ADR-025:** meta-path dispensa basename `AAAAMMDD-HHMMSS-<agente>-<slug>.{json,md}`; B18 acrescenta proibição de modo `120000` sob `.hbn/**` antes da dispensa (`guards/README.md:49-52`, `assert-scope-lock.sh:254-263`).
- **REGISTRY B18** (`REGISTRY.md:583-594`): seção onda B18 + 3 linhas (readback, state, handoff). Pareceres cross-ia **não** depositados (correto para este auditor).

## 2. Readback 0021 — coerência

| Campo | Verificação |
|---|---|
| `scope.files_allowed` | ⊆ paths tocados nos 4 commits |
| `scope.files_forbidden` | inclui main, src, seis untracked antigos |
| `action_plan` / `invariants` | 4 commits separados; trailers 0021 |
| `status` | `in_progress` — coerente (cross-audit pendente) |

## 3. Suítes (host, fora do sandbox)

```
$ bash guards/tests/run-guard-tests.sh 2>&1 | tail -3
== resumo: 141 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.

$ bash guards/tests/adversarial-battery.sh 2>&1 | grep B18
B18 symlink ADR-025 em meta-path governado           | G-SCO    | BLOQUEADA ✓

$ bash guards/hbn-guards-runner.sh 2>&1 | tail -2
[hbn-guards] Todos os guards passaram.
RC=0
```

## 4. Diff 703051c vs README §Meta-paths

Implementação (`703051c`) e README (`guards/README.md:39-52`) **alinhados**: dispensa ADR-025/hearback/INDEX; symlinks `120000` sob `.hbn/**` bloqueados antes de meta-path; comentário inline em `assert-scope-lock.sh:206-207`.

## 5. Adversarial (repo isolado)

| Vetor | Modo git | RC guard | Resultado |
|---|---|---|---|
| **a)** symlink ADR-025 `.hbn/messages/` | 120000 | 1 | **BLOCK** ✓ |
| **a2)** symlink ADR-025 `.hbn/bypasses/` | 120000 | 1 | **BLOCK** ✓ |
| **b)** symlink para arquivo fora do repo | 120000 | 1 | **BLOCK** ✓ |
| **c)** symlink `guards/core/src/` (não `.hbn`) | 120000 | 0 | **PASS** — fora do recorte B18 (só `.hbn/*`); `guards/**` no escopo do fixture |
| **d)** hardlink `.hbn/messages/` ADR-025 ← `payload-fora.txt` fora de `files_allowed` | 100644 | 0 | **PASS** — **furo B19** (ver abaixo) |
| **e1)** detecção no índice (pre-commit) | 120000 staged | 1 | **BLOCK** ✓ |
| **e2)** detecção no range HEAD (`HBN_DIFF_BASE`) | 120000 em HEAD | 1 | **BLOCK** ✓ |
| **f)** handoff/hearback/bypass regulares | 100644 | 0 | **PASS** ✓ |

### Furo B19 — hardlink smuggling (candidato)

**Repro:** repo isolado; `files_allowed: ["docs/**"]`; `payload-fora.txt` na raiz **não** staged; `ln payload-fora.txt .hbn/messages/20260615-230200-cursor-handoff-z.md`; `git add` só o path `.hbn/`.

```
mode: 100644
payload-fora staged: 0
[hbn-guards/assert-scope-lock] ✓ Todos arquivos staged dentro do scope declarado em 0001-t.json.
RC=0
```

**Causa:** `is_governed_hbn_symlink` (`assert-scope-lock.sh:254-262`) só testa modo `120000`; hardlink no índice vira blob `100644` e cai na dispensa `is_meta_auto_allowed` (`:244-248`).

**Escopo:** vetor **adjacente** a B18, não coberto pelo readback 0021 (que cita symlink explicitamente). Não invalida o fix `120000` sob `.hbn/**`.

## 6. Implementação central

```254:262:guards/assert-scope-lock.sh
is_governed_hbn_symlink() {
    local file="$1"
    [[ "$file" == .hbn/* ]] || return 1

    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git ls-tree -r HEAD -- "$file" 2>/dev/null | grep -q '^120000[[:space:]]'
    else
        git ls-files --stage -- "$file" 2>/dev/null | grep -q '^120000[[:space:]]'
    fi
}
```

```337:340:guards/assert-scope-lock.sh
    if is_governed_hbn_symlink "$f"; then
        GOVERNED_HBN_SYMLINKS+=("$f")
        FAIL=1
        continue
```

## TRUTH BARRIER

| Item | Confiança | Não verificado |
|---|---|---|
| 4 commits, trailers, separação | alta | — |
| main = 4db6928 | alta | — |
| REGISTRY linhas 583-594 | alta | — |
| Suítes 141/141, B18 BLOQUEADA, runner rc=0 | alta (host) | CI remoto |
| Vetores a,b,e,f | alta | — |
| Vetor c (fora `.hbn`) | alta — by design | — |
| Vetor d hardlink | alta | mitigação cross-platform de inode |

## Veredito

**APROVA_B18: SIM**

**Furos:** 1 candidato B19 — hardlink em meta-path ADR-025 smuggling conteúdo de arquivo fora de `files_allowed` (modo `100644`, não `120000`). Demais vetores do despacho adversarial: bloqueados ou fora do recorte declarado de B18.

## Linha REGISTRY (texto — NÃO depositada)

```
| 20260615-224921-cursor-cross-ia-b18-symlink | .hbn/results/20260615-224921-cursor-cross-ia-b18-symlink.md | audit-result | frio | — | 2026-06-15T22:49:21-03:00 |
```
