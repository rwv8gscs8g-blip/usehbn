---
titulo: "Cross-audit independente — W3 (G-ZONA-LIVRE deny-by-default)"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260616-225600-cursor-cross-ia-w3-deny-zona-livre.md
id-global: 20260616-225600-cursor-cross-ia-w3-deny-zona-livre
autor: cursor (auditor cruzado, família distinta de Codex)
readback: 0036-deny-zona-livre
branch_auditada: proposta/reestruturacao-m-a-s0
base: 50263e1
head: 55291e1
created_at: "2026-06-16T22:56:00-03:00"
---

APROVA_0036: SIM

# Cross-audit W3 — Cursor

Auditoria independente. Não consultei pareceres Grok/Antigravity antes de concluir. Somente leitura; sem commit; sem staging persistente; `main` intocada.

## A1. Guard G-ZONA-LIVRE (mecanismo)

**PASSA.**

O guard `guards/assert-zona-livre.sh` aplica deny-by-default sobre paths staged que casam `^docs/brainstorm/.+` (`:30`). Lê STATE e readback ativo do índice/HEAD via `git show` (`:56-99`), não da working tree solta. Validação JSON exige `zona_livre_curada is True` e `zona_livre_nota` string não-vazia após strip (`:118-125`). Fail-closed em STATE/readback ausente, path `readback_ativo` inválido ou inseguro (`:65-83`), JSON ilegível (`:91-99`) ou python3 ausente (`:101-104`).

Integração bloqueante confirmada em `guards/hbn-guards-runner.sh:58`.

## A2. Prova manual (stage + reset, sem commit)

**PASSA** no vetor negativo.

Comando reproduzido no branch real:

```
git add docs/brainstorm/_cursor-audit-w3-probe.md
bash guards/assert-zona-livre.sh
```

Saída observada (rc=1):

```
zona livre so entra com curadoria humana explicita no readback — knowledge 0024. falta "zona_livre_curada": true
Readback ativo: .hbn/readbacks/0036-deny-zona-livre.json
Paths staged sob docs/brainstorm/**:
  - docs/brainstorm/_cursor-audit-w3-probe.md
```

Restaurado com `git reset HEAD` + `rm` do probe. Sem commit; sem `--no-verify` (knowledge 0025).

## A3. Suítes automatizadas

**PASSA.**

| suíte | comando | resultado |
|---|---|---|
| run-guard-tests | `bash guards/tests/run-guard-tests.sh` | 178/178 verde |
| adversarial-battery | `bash guards/tests/adversarial-battery.sh` | B1–B33 bloqueadas; B33 → G-ZONA |

Checks G-ZONA-LIVRE dedicados (`run-guard-tests.sh:1779-1827`):

- ✓ brainstorm com curadoria no readback passa
- ✓ brainstorm sem marcador → BLOCK
- ✓ readback ativo ilegível → BLOCK

Nota ambiental: na sandbox restrita do Cursor a mesma suíte reportou 118/60 vermelha (repos efêmeros de `make_repo` falham). Com permissões completas, 178/178 — alinhado ao handoff do implementador.

## A4. Escopo e separação (`50263e1..55291e1`)

**PASSA.**

```
git diff --name-only 50263e1..55291e1
```

Retornou exatamente 9 paths, todos cobertos por `scope.files_allowed` do readback 0036:

```
.hbn/messages/20260616-213600-codex-handoff-w3-deny-zona-livre.md
.hbn/readbacks/0036-deny-zona-livre.json
.hbn/relay/STATE.md
REGISTRY.md
guards/README.md
guards/assert-zona-livre.sh
guards/hbn-guards-runner.sh
guards/tests/adversarial-battery.sh
guards/tests/run-guard-tests.sh
```

Marginal não-bloqueador: o readback lista placeholder `20260616-HHMMSS-...` em `files_allowed:28`, mas o handoff real é `...213600-...`. O commit passou via auto-allow B17 de meta-path em `.hbn/messages/` (`assert-scope-lock.sh`); incongruência de template, não bypass de escopo.

`core/**`, `schemas/**` e `guards/assert-scope-lock.sh` não foram tocados (conforme `files_forbidden`).

## A5. Trailers e main

**PASSA.**

Quatro commits W3 (`c683b0b`, `ba40c30`, `c4fd64b`, `55291e1`); cada um com trailers contíguos no último parágrafo:

```
HBN-Readback: 0036
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```

`git rev-parse main` → `4db692876381a0d7909985c8500d999f2e677b04`; `git merge-base main HEAD` → mesmo hash. Main não avançou.

## A6. Alinhamento knowledge 0024

**PASSA** na intenção estrutural.

O guard materializa a lição 0024 (“só gate enforçado vincula”) para `docs/brainstorm/**`. Marginal de design (não bloqueador): a curadoria é auto-declarada no readback que a própria onda pode editar (`zona_livre_curada` + `zona_livre_nota`). Eleva o padrão e força visibilidade pré-commit, mas não substitui revisão humana do diff nem assinatura independente por arquivo. Defense-in-depth adequado para W3; endurecimento futuro (onda de curadoria dedicada, bypass/hearback por entrada) permanece no backlog declarado.

## A7. Estado do readback

**MARGINAL** (não bloqueador).

`.hbn/readbacks/0036-deny-zona-livre.json:7` ainda tem `"status": "in_progress"`. Esperado antes da selagem pós cross-audit; o orquestrador deve fechar na micro-onda de selagem W3.

---

**CONFIANÇA:** 92/100

Lógica do guard verificada no disco, suítes verdes em ambiente não-sandbox, escopo e trailers corretos, main intocada. Marginais: placeholder HHMMSS no readback, status in_progress, natureza self-decl da curadoria.
