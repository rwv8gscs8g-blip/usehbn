---
titulo: "Cross-audit ADVERSARIAL — Onda S1 (scope lock / readback 0017)"
tipo: audit-result
agente: cursor
familia: Cursor
implementador_auditado: codex
readback: 0017
tip_auditado: 53b966f
base_s1: aa9bd3e
main_ref: 4db6928
data: 2026-06-15T11:31:15-03:00
created_at: "2026-06-15T11:31:15-03:00"
path: .hbn/results/20260615-113115-cursor-cross-ia-s1-scope-lock.md
id-global: 20260615-113115-cursor-cross-ia-s1-scope-lock
---

# Cross-audit adversarial S1 — cursor (2ª opinião)

PAPEL auditor · TOKEN cursor · FAMÍLIA Cursor · CONTEXTO ~55% · auditando do disco

## Regra zero

```
$ pwd
/Users/macbookpro/Projetos

$ cd /Users/macbookpro/Projetos/usehbn && GIT_OPTIONAL_LOCKS=0 git status
On branch proposta/reestruturacao-m-a-s0
Untracked files present (handoffs antigos, results cross-ia anteriores, dirs adv-cr.* em guards/tests/)
nothing added to commit
```

Branch: `proposta/reestruturacao-m-a-s0` · tip: `53b966f` · `main` = `4db6928` (intocada).

## 1. Commits S1 (aa9bd3e..53b966f)

```
53b966f onda-s1: atualiza state e handoff
7d50454 onda-s1: cobre auto-emenda de scope lock
e72c56b onda-s1: endurece scope lock contra auto-emenda
8b810f1 onda-s1: registra parecer gemini de selagem
d19f563 onda-s1: abre readback 0017
```

### Separação lógica + trailers (3 por commit)

| commit | arquivos | trailers |
|---|---|---|
| d19f563 | readback 0017 + REGISTRY | 3 (`HBN-Readback: 0017`, `HBN-Human-Authorization`, `HBN-Token-FP: 34a7f2f9`) |
| 8b810f1 | parecer gemini 103431 + REGISTRY | 3 |
| e72c56b | `core/readback-spec.md`, `guards/assert-scope-lock.sh` | 3 |
| 7d50454 | `guards/tests/run-guard-tests.sh`, `adversarial-battery.sh` | 3 |
| 53b966f | STATE + handoff s1 + REGISTRY | 3 |

Verificação trailers: `git log -1 --format="%B" <c> | grep -cE '^(HBN-Readback|HBN-Human-Authorization|HBN-Token-FP):'` → 3 em cada um dos 5 commits.

### main intocada

```
$ git rev-parse main
4db692876381a0d7909985c8500d999f2e677b04

$ git merge-base --is-ancestor main HEAD && echo ok
ok

$ git diff main 4db6928 --stat | wc -l
0
```

### ADR-025 — linhas REGISTRY dos artefatos numerados S1

Commit d19f563:
```
+| 20260615-104309-codex-readback-s1-scope-extension | .hbn/readbacks/0017-endurecer-assert-scope-lock-scope-extension.json | readback | quente | — | 2026-06-15T10:43:09-03:00 |
```

Commit 8b810f1 (nome ADR-025 `AAAAMMDD-HHMMSS-<agente>-<slug>`):
```
+| 20260615-103431-gemini-3-5-cross-ia-selagem-reestruturacao-m-a-s0 | .hbn/results/20260615-103431-gemini-3-5-cross-ia-selagem-reestruturacao-m-a-s0.md | audit-result | frio | — | 2026-06-15T10:34:31-03:00 |
```

Commit 53b966f:
```
+| 20260615-110757-codex-state-s1 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T11:07:57-03:00 |
+| 20260615-110757-codex-handoff-s1 | .hbn/messages/20260615-110757-codex-handoff-s1.md | handoff | quente | — | 2026-06-15T11:07:57-03:00 |
```

`created_at` com offset `-03:00` (sem sufixo Z) — conforme ADR-025 Decisão 2.2.

## 2. Readback 0017 — `files_allowed`

Arquivo: `.hbn/readbacks/0017-endurecer-assert-scope-lock-scope-extension.json:18-28`

| artefato S1 | coberto |
|---|---|
| readback 0017 (ele mesmo) | sim (linha 20) |
| REGISTRY.md | sim (linha 21) |
| STATE.md | sim (linha 22) |
| parecer 103431 | sim (linha 23) |
| core/readback-spec.md | sim (linha 24) |
| guards/assert-scope-lock.sh | sim (linha 25) |
| guards/tests/run-guard-tests.sh | sim (linha 26) |
| guards/tests/adversarial-battery.sh | sim (linha 27) |
| handoff 110757 (commit 53b966f) | não explícito — coberto por meta-path `.hbn/messages/**` em `guards/assert-scope-lock.sh:211` |

`readback_ativo` no STATE: `.hbn/relay/STATE.md:27` aponta para 0017.

## 3. Suítes

### run-guard-tests — 135 checks

**Sandbox (falso-negativo documentado):**
```
$ bash guards/tests/run-guard-tests.sh   # sandbox Cursor
== resumo: (todos ✗)
SUÍTE VERMELHA — nenhum guard pode ser ativado no runner (ADR-020 Decisão 2).
exit 1
```

**Host real (reexecução fora do sandbox):**
```
$ bash guards/tests/run-guard-tests.sh
== resumo: 135 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
exit 0
```

Checks S1 específicos:
```
✓ sco: emenda files_allowed + uso no mesmo commit (ca69ef9) → BLOCK
✓ sco: scope_extension isolada altera só readback → passa
✓ sco: depósito em escopo já vigente → passa
```

### adversarial-battery — B16 BLOQUEADA

```
$ bash guards/tests/adversarial-battery.sh
B16 auto-emenda files_allowed + uso                  | G-SCO    | BLOQUEADA ✓
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
exit 0
```

### hbn-guards-runner — rc=0

```
$ bash guards/hbn-guards-runner.sh; echo rc=$?
[hbn-guards/assert-scope-lock] Readback ativo: 0017-endurecer-assert-scope-lock-scope-extension.json | track=safe_track | human_status=confirmed
[hbn-guards] Todos os guards passaram.
rc=0
```

## 4. Não-regressão: readback novo sem base

`guards/assert-scope-lock.sh:134`:
```python
added = [p for p in allowed if p not in old_allowed] if base_available == "1" else []
```

Quando não há base em HEAD (`base_available != "1"`), `added` fica vazio — primeiro commit com readback + artefatos **não** dispara regra de extensão. Coerente com `core/readback-spec.md:68-85` (extensão só em readback **existente**).

Teste isolado: readback novo + `docs/novo/**` no mesmo commit → `rc=0` (passa).

## 5. Tarefa adversarial (repo-teste isolado)

Setup: `mktemp -d` + `git init` + `.hbn/active-version` (padrão `adversarial-battery.sh:40-44`).

| caso | expectativa | rc medido | veredito |
|---|---|---|---|
| a) `allowed_delta` incompleto (falta `docs/novo/**`) | BLOCK | 1 | OK |
| b) `scope_extension` sem human/evidence/created_at | BLOCK | 1 | OK |
| c) extensão isolada commit1 + uso commit2 | PASS | 0 | OK |
| d) smuggling `.hbn/messages/evil.md` fora do allowed | PASS (meta-path) | 0 | **comportamento pré-existente intencional** (`assert-scope-lock.sh:202-214`; `adversarial-extra-gemini.sh:218-249`) — não é regressão S1 |
| e) readback novo sem base HEAD | PASS | 0 | OK (não é extensão) |
| f) swap allowed + artefato mesmo commit | BLOCK | 1 | OK |
| h) extensão + REGISTRY staged | BLOCK | 1 | OK |

Mensagem típica de bloqueio (caso b):
```
scope.files_allowed do readback ativo foi estendido sem scope_extension valido
(human, evidence, created_at, allowed_delta cobrindo o delta).
exit 1
```

## 6. Coerência spec ↔ guard

| regra | spec | guard |
|---|---|---|
| extensão isolada | `core/readback-spec.md:70-73` | `assert-scope-lock.sh:275-294` |
| campos obrigatórios | `readback-spec.md:78-81` | `assert-scope-lock.sh:143-152` |
| emenda+uso mesmo commit | `readback-spec.md:84-85` | `assert-scope-lock.sh:252-294` |
| `scope_extension_*` | `readback-spec.md:76` | `assert-scope-lock.sh:139` |

## 7. Furos / B17

**Nenhum furo novo atribuível à onda S1.**

Meta-path `.hbn/messages/**` permite depósito fora de `files_allowed` declarado — é brecha **conhecida e documentada** do protocolo, anterior a S1; o handoff 110757 depende dela. Não candidato B17 para esta onda (escopo S1 = auto-emenda ca69ef9; B16 cobre o drible alvo).

## Veredito

**APROVA_S1: SIM**

Furos: nenhum (meta-path = design legado consciente, fora do escopo do fix ca69ef9).

---
Confiança: alta nos itens mecânicos (commits, trailers, REGISTRY, suítes no host, repros adversariais a/b/c/f/h).
Não verificado: percentual exato de contexto da sessão; comportamento dos hooks commit-msg/pre-commit em commit real (runner sem staged).
