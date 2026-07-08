---
titulo: "Cross-audit ADVERSARIAL — Onda B17 (meta-path tipo+nome / readback 0019)"
tipo: audit-result
agente: cursor
familia: Cursor
implementador_auditado: codex
readback: 0019
tip_auditado: cb4c1d4
base_b17: 9556618
main_ref: 4db6928
data: 2026-06-15T21:38:50-03:00
created_at: "2026-06-15T21:38:50-03:00"
path: .hbn/results/20260615-213850-cursor-cross-ia-b17-meta-path.md
id-global: 20260615-213850-cursor-cross-ia-b17-meta-path
status: congelado
temperatura: glacier
---

# Cross-audit adversarial B17 — cursor (2ª opinião)

PAPEL auditor · TOKEN cursor · FAMÍLIA Cursor · CONTEXTO ~62% · auditando do disco

## Regra zero

```
$ pwd
/Users/macbookpro/Projetos

$ cd /Users/macbookpro/Projetos/usehbn && GIT_OPTIONAL_LOCKS=0 git status
On branch proposta/reestruturacao-m-a-s0
Untracked files present (handoffs antigos, results cross-ia anteriores, dirs adv-cr.* em guards/tests/)
nothing added to commit
```

Branch: `proposta/reestruturacao-m-a-s0` · tip: `cb4c1d4` · `main` = `4db6928` (intocada).

## 1. Commits B17 (9556618..cb4c1d4)

```
cb4c1d4 b17: atualiza state e handoff
6e0b195 b17: cobre smuggling por meta-path
537045b b17: restringe meta-path por tipo e nome
45579c8 b17: abre readback 0019
```

### Separação lógica + trailers (3 por commit)

| commit | arquivos | trailers |
|---|---|---|
| 45579c8 | `.hbn/readbacks/0019-b17-anti-smuggling-meta-path.json`, `REGISTRY.md` | 3 (`HBN-Readback: 0019`, `HBN-Human-Authorization`, `HBN-Token-FP: 34a7f2f9`) |
| 537045b | `guards/assert-scope-lock.sh`, `guards/README.md` | 3 |
| 6e0b195 | `guards/tests/adversarial-battery.sh`, `guards/tests/run-guard-tests.sh` | 3 |
| cb4c1d4 | `.hbn/messages/20260615-120038-codex-handoff-b17.md`, `.hbn/relay/STATE.md`, `REGISTRY.md` | 3 |

Padrão WAVE-OPEN → IMPLEMENTAÇÃO → TESTES → STATE+HANDOFF conforme readback 0019 `invariants_to_preserve`.

### main intocada

```
$ git rev-parse main
4db692876381a0d7909985c8500d999f2e677b04

$ git merge-base --is-ancestor main HEAD && echo ok
ok
```

### ADR-025

Regex em `guards/assert-scope-lock.sh:246` exige basename `^[0-9]{8}-[0-9]{6}-[a-z0-9][a-z0-9-]*-[a-z0-9][a-z0-9-]*\.(json|md)$` — alinhado a ADR-025 Decisão 1 (`methodology/adr/ADR-025-nome-universal-artefato-ia.md:39-44`): carimbo real, agente minúsculo, slug, extensão `.json` ou `.md` apenas.

### REGISTRY (linhas B17 no tip)

```555:566:REGISTRY.md
## Onda B17 (2026-06-15) — anti-smuggling meta-path tipo+nome — status: in_progress, readback 0019
...
| 20260615-115415-codex-readback-b17-anti-smuggling-meta-path | .hbn/readbacks/0019-b17-anti-smuggling-meta-path.json | readback | quente | — | 2026-06-15T11:54:15-03:00 |
| 20260615-120038-codex-state-b17 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T12:00:38-03:00 |
| 20260615-120038-codex-handoff-b17 | .hbn/messages/20260615-120038-codex-handoff-b17.md | handoff | quente | — | 2026-06-15T12:00:38-03:00 |
```

## 2. Readback 0019 coerente

| campo readback | evidência no tip |
|---|---|
| `understanding` (smuggling meta-path tipo+nome) | `assert-scope-lock.sh:202-250` remove glob `**` e adiciona `is_meta_auto_allowed` |
| `scope.files_allowed` | todos os paths tocados nos 4 commits ⊆ lista (`.hbn/readbacks/0019-…`, `REGISTRY.md`, `guards/*`, `STATE.md`, handoff) |
| `scope.files_forbidden` | seis untracked antigos não tocados (confirmado por `git status`) |
| `action_plan` (5 itens) | mapeia 1:1 aos 4 commits + cobertura de testes em 6e0b195 |
| `invariants_to_preserve` | main intocada, trailers 3×4, commits separados — verificado |
| `status: in_progress` | coerente: cross-audit pendente (este parecer) |

### Diff 537045b vs guards/README.md §Meta-paths

Commit 537045b adiciona §Meta-paths em `guards/README.md:39-47` e implementação correspondente em `assert-scope-lock.sh:202-250`. Texto README e código concordam: dispensa só para `.json/.md` ADR-025, hearback `NNNN-*.{json,md}` do readback ativo, e `.hbn/relay/INDEX.md`. Removidos `META_ALWAYS_ALLOWED` com `.hbn/bypasses/**` e `.hbn/messages/**`.

## 3. Suítes mecânicas

### Sandbox (falso-negativo documentado)

```
$ bash guards/tests/run-guard-tests.sh 2>&1 | tail -3
SUÍTE VERMELHA — nenhum guard pode ser ativado no runner (ADR-020 Decisão 2).

$ bash guards/tests/adversarial-battery.sh 2>&1 | grep -E 'B4|B15|B17'
B4 bypass env sem nota ... PASSOU ✗
B15 active-version com conflito ... PASSOU ✗
B17 smuggling meta-path ... BLOQUEADA ✓

$ bash guards/hbn-guards-runner.sh; echo rc=$?
xargs: sysconf(_SC_ARG_MAX) failed  (×9)
[hbn-guards] Todos os guards passaram.
rc=0
```

Causa: sandbox nega `rm`/limita `xargs` — casos herméticos falham em massa; B17 positivos (handoff/hearback/bypass) aparecem como ✗ no sandbox.

### Terminal do operador (fora do sandbox — conclusivo)

```
$ bash guards/tests/run-guard-tests.sh 2>&1 | tail -3
== resumo: 140 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.

$ bash guards/tests/adversarial-battery.sh 2>&1 | tail -3
B17 smuggling meta-path tipo/nome arbitrario | G-SCO | BLOQUEADA ✓
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.

$ bash guards/hbn-guards-runner.sh 2>&1 | tail -2
[hbn-guards] Todos os guards passaram.
rc=0
```

## 4. Tarefa adversarial (repo isolado, `make_sco_repo` + `assert-scope-lock.sh`)

Setup: repo git descartável com `.hbn/active-version`, readback `0001-t.json` (`safe_track`/`confirmed`), `files_allowed=["docs/**"]`.

| cenário | comando / path | rc | veredito |
|---|---|---|---|
| **a)** payload.sh + exploit.py | stage `.hbn/bypasses/payload.sh`, `.hbn/messages/exploit.py` | 1 | **BLOCK** ✓ |
| **b)** nome ADR-025 com `.sh` | `.hbn/messages/20260615-120000-codex-handoff-x.sh` | 1 | **BLOCK** ✓ |
| **c)** dupla extensão `.md.sh` | `.hbn/messages/20260615-120000-codex-handoff-x.md.sh` | 1 | **BLOCK** ✓ |
| **d)** symlink em meta-path | `ln -s ../../docs/secret.txt .hbn/messages/20260615-120000-codex-handoff-x.md` | 0 | **PASS** — guard valida só path string (`is_meta_auto_allowed` `assert-scope-lock.sh:236-249`), não tipo real nem alvo do symlink |
| **e)** quasi-ADR-025 | `CODEX` maiúsculo / slug ausente / `.json.sh` / ZWSP U+200B no basename | 1 | **BLOCK** ✓ (todos) |
| **f)** legítimos | handoff `.md` ADR-025 + hearback `0001-ok.json` + bypass `.md` ADR-025 + `INDEX.md` | 0 | **PASS** ✓ (todos) |

### Repro B18 candidato (symlink smuggling)

```
$ # repo isolado; scope docs/** only
$ ln -s ../../src/payload.sh .hbn/messages/20260615-120000-codex-handoff-x.md
$ git add .hbn/messages/20260615-120000-codex-handoff-x.md
$ bash guards/assert-scope-lock.sh
[hbn-guards/assert-scope-lock] ✓ Todos arquivos staged dentro do scope declarado em 0001-t.json.
rc=0
$ ls -la .hbn/messages/
lrwxr-xr-x ... 20260615-120000-codex-handoff-x.md -> ../../src/payload.sh
```

Conteúdo real é `.sh` fora do escopo; basename `.md` ADR-025 satisfaz regex. **Fora do recorte B17** (tipo+nome por extensão literal), mas vetor residual documentável para B18.

## 5. Veredito

**APROVA_B17: SIM**

**Furos:** 1 candidato B18 — symlink com basename ADR-025 válido passa scope-lock apesar de apontar para payload `.sh` fora do escopo (`assert-scope-lock.sh:236-249` não inspeciona `-L`/mime).

Demais vetores do despacho (payload arbitrário, extensão errada, quasi-nomes) **bloqueados**. Implementação, README, readback 0019, REGISTRY e suítes (140/140 + B17 BLOQUEADA + runner rc=0 fora do sandbox) **coerentes**.

---

## TRUTH BARRIER

| afirmação | confiança | não-verificado |
|---|---|---|
| 4 commits separados + 3 trailers | alta | — |
| main = 4db6928 intocada | alta | — |
| readback 0019 coerente com obra | alta | — |
| 537045b ↔ README §Meta-paths | alta | — |
| run-guard-tests 140/140 | alta | sandbox deu falso-negativo; reexecutado fora |
| adversarial B17 BLOQUEADA | alta | idem |
| hbn-guards-runner rc=0 | alta | sandbox rc=0 com avisos xargs; fora limpo |
| symlink PASS (B18) | alta | repro isolado acima |
| CI remoto | — | não executado nesta auditoria |

## Linha REGISTRY (texto — NÃO depositada)

```
| 20260615-213850-cursor-cross-ia-b17-meta-path | .hbn/results/20260615-213850-cursor-cross-ia-b17-meta-path.md | audit-result | frio | — | 2026-06-15T21:38:50-03:00 |
```
