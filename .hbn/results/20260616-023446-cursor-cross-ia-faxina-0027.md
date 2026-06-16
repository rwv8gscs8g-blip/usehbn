---
titulo: "Cross-audit independente — faxina 0027"
tipo: audit-result
status: proposto
temperatura: frio
path: .hbn/results/20260616-023446-cursor-cross-ia-faxina-0027.md
id-global: 20260616-023446-cursor-cross-ia-faxina-0027
autor: cursor (auditor cruzado)
readback: 0027-faxina-pendencias
branch_auditada: proposta/reestruturacao-m-a-s0
base: 46c29198923fcd012d54d958862d38ddd4f9a744
head: 788e459
created_at: "2026-06-16T02:34:46-03:00"
---

APROVA_0027: SIM

# Cross-audit faxina 0027 — Cursor

Auditoria independente. Não consultei parecer Gemini. Só leitura; sem commit; `main` intocada.

## A. Fix G-EXC — aceita não-contíguo e bloqueia omissão real

**PASSA.**

Fix mínimo em `guards/assert-exception-traceable.sh:154` — ramo CI troca `%(trailers)` por `%B`, alinhado ao commit-msg local (`:148-149`).

```bash
# comando + saída
cd /Users/macbookpro/Projetos/usehbn
HBN_DIFF_BASE=46c29198923fcd012d54d958862d38ddd4f9a744 bash guards/assert-exception-traceable.sh
# → "✓ Exceção F-01 RASTREÁVEL: ... trailers verificados" ; EXIT:0
```

Prova automatizada dos dois lados em `guards/tests/run-guard-tests.sh:1187-1209`:

| caso | esperado | obtido |
|---|---|---|
| CI trailers separados por linha em branco | pass | pass |
| CI sem HBN-Readback | block | block |
| CI sem HBN-Human-Authorization | block | block |

Burla B23 bloqueada (`guards/tests/adversarial-battery.sh:338-366`).

## B. Falso-positivo reverso — prosa com `HBN-...:` no corpo

**MARGINAL — risco real, não bloqueador desta faxina.**

`require_trailers_in` (`guards/assert-exception-traceable.sh:139-140`) aplica `grep '^HBN-Readback:'` e `grep '^HBN-Human-Authorization:'` sobre **toda** a mensagem `%B`, sem ancorar no último parágrafo/trailer block.

Consequência: linhas de prosa no corpo que **comecem** com esses prefixos satisfazem (b) e (c) em CI mesmo sem trailers reais no rodapé. O modo commit-msg já tinha o mesmo padrão (`:148`); a faxina não piorou nem corrigiu isso.

Recomendação para S3/0028+: ancorar validação no bloco final de trailers (último parágrafo contíguo) ou exigir trailers contíguos também em CI.

## C. Gap `.gitignore` — `adv-cr.<rand>`

**MARGINAL — confirmado.**

```bash
git check-ignore guards/tests/adv-cr.XXXX   # → NOT_IGNORED
git check-ignore guards/tests/adv-cr-x.zzz    # → IGNORED (.gitignore:32 adv-cr-*)
```

A suíte cria exatamente esse padrão (`guards/tests/adversarial-battery.sh:61`: `mktemp -d -p "$TESTS_DIR" adv-cr.XXXXXX`).

Variantes cobertos: `cr-*` (:31), `tmp-pass.*` (:33), `wt-main.*` (:34).

**Padrão mínimo recomendado:** acrescentar `guards/tests/adv-cr.*` (ou `guards/tests/adv-cr*` unificado) — já previsto pelo orquestrador para 0028.

## D. Seis antigos selados

**PASSA.**

Exatamente seis no commit `53f9744` (2 handoffs + 4 results), linhas `REGISTRY.md:686-691`:

1. `.hbn/messages/20260612-122102-fable5-handoff-orquestracao-pos-onda-0006.md`
2. `.hbn/messages/20260613-112502-fable5-handoff-orquestracao-pos-adocao-onda-0006.md`
3. `.hbn/results/20260614-032800-gemini-3-5-cross-ia-onda-0011-plano-v2.md`
4. `.hbn/results/20260614-043647-antigravity-cross-ia-exuvia-impl.md`
5. `.hbn/results/20260614-043826-codex-cross-ia-exuvia-impl.md`
6. `.hbn/results/20260614-044555-opus-4-8-consolidacao-cross-audit-exuvia-impl.md`

Conteúdo íntegro (arquivos novos versionados; handoffs preservam `RELATO HISTORICO ORIGINAL` abaixo do carimbo de depósito).

## E. Analogia exoesqueleto no core

**PASSA.**

```bash
grep -niE "cobra|pele" core/exuvia-fitness-criteria.md   # → 0 matches
grep -niE "exoesqueleto|artrópode" core/exuvia-fitness-criteria.md
# → :19-23, :66 (exoesqueleto/artrópodes)
```

Bate com fonte `.hbn/messages/20260616-011004-opus-4-8-criterios-exuvia.md:21-25 (mesmo texto).

## F. Sem regressão

**PASSA** (reexecução fora do sandbox — sandbox Cursor produziu falso-vermelho com rc=128 em dezenas de casos isolados).

```bash
bash guards/tests/run-guard-tests.sh
# → "== resumo: 154 passaram, 0 falharam ==" ; SUÍTE VERDE

bash guards/tests/adversarial-battery.sh
# → B1-B23 BLOQUEADAS ; BATERIA VERDE

bash guards/hbn-guards-runner.sh
# → "Todos os guards passaram." ; rc=0

git rev-parse main
# → 4db692876381a0d7909985c8500d999f2e677b04 (intocada)
```

## G. Escopo `46c2919..HEAD`

**MARGINAL — 1 arquivo fora de `files_allowed`.**

```bash
git diff --name-only 46c2919..HEAD
# 18 paths

# EXTRA vs .hbn/readbacks/0027-faxina-pendencias.json scope.files_allowed:
# → .hbn/messages/20260616-020135-codex-handoff-faxina.md
```

O handoff é exigido pelo `action_plan` C7 (`0027-faxina-pendencias.json:55`) mas **não** está listado em `files_allowed` (`:19-36`). Lacuna do readback, não vazamento de código/guards. Recomendo incluir o path na selagem 0028.

Nenhum arquivo de `files_forbidden` tocado.

## H. Trailers contíguos nos 7 commits

**PASSA.**

Commits `4b7be1f..788e459`: `%(trailers:key=HBN-Readback)` e `%(trailers:key=HBN-Human-Authorization)` presentes em todos.

Corpo bruto do último commit (`788e459`) — trailers contíguos sem linha em branco entre eles:

```
HBN-Readback: 0027
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```

## I. Eixo leveza / lixo-zero

| achado | arquivo:linha | julgamento |
|---|---|---|
| Fix G-EXC é troca de 1 linha + comentário | `assert-exception-traceable.sh:154` | **leve** — simples que funciona |
| Gap gitignore deixa lixo `adv-cr.<rand>` | `.gitignore:32`, `adversarial-battery.sh:61` | **marginal** — corrigir em 0028 |
| Seis antigos eram dívida real (untracked bloqueando G-REG) | `REGISTRY.md:686-691` | **justificado** — não é lixo arbitrário |
| Handoffs selados mantêm `status: untracked-no-deposito` no front-matter | `20260612-122102-...md:8`, `20260613-112502-...md:8` | **peso errado** — contradiz REGISTRY pós-selagem |
| Carimbo RELATO com PRÓXIMA AÇÃO obsoleta no topo | handoffs `:13-14`; triagem `:13-14`; criterios `:13-15` | **peso errado** — IA lê “Abrir faxina 0027” já concluída |

## EXTRA (vetor fino Cursor)

### (1) Seis selados × STATE — ruído de peso

Os dois handoffs históricos receberam no depósito 0027 um **RELATO DE ESTADO sintético** no topo (`:12-14`) com `PRÓXIMA AÇÃO: Abrir a faxina 0027...`, enquanto o `RELATO HISTORICO ORIGINAL` abaixo preserva a verdade da época. Uma IA que parseia só o topo herda instrução **stale** que contradiz `.hbn/relay/STATE.md:14` (`proxima_acao: cross-audit`). Mesmo padrão em triagem e critérios selados.

Não é duplicação de spec técnica, mas é **duplicação de instrução operacional** com prioridade ambígua.

### (2) Duplicata core × messages sem superseded no arquivo

`core/exuvia-fitness-criteria.md` é `status: accepted` com `promovido_de` (`:4-9`). A fonte `.hbn/messages/20260616-011004-opus-4-8-criterios-exuvia.md` permanece `status: proposto` (`:4`) **sem** `superseded_by` no front-matter do arquivo.

O REGISTRY mitiga parcialmente (`REGISTRY.md:693` — coluna `superseded_by: core/exuvia-fitness-criteria.md`), mas quem lê só `.hbn/messages/` vê **dois donos da mesma verdade**. Recomendo na 0028: `status: superseded` + `superseded_by:` no front-matter da fonte.

## Marginais consolidados (não bloqueadores)

1. **B** — grep `%B` inteiro aceita prosa disfarçada de trailer (pré-existente no commit-msg).
2. **C** — `adv-cr.*` escapa do gitignore.
3. **G** — handoff `20260616-020135-codex-handoff-faxina.md` fora de `files_allowed` (mas exigido por C7).
4. **I/EXTRA** — front-matter stale (`untracked-no-deposito`, PRÓXIMA AÇÃO obsoleta) nos artefatos selados.
5. **EXTRA** — spec exúvia duplicada sem `superseded` no arquivo-fonte (só no REGISTRY).

## Confiança

**88 / 100**

- Alta nos pontos mecânicos (G-EXC, testes 154/154, B1-B23, main, seis selados, analogia).
- Desconto: marginais B/C/EXTRA não exercitados por teste automatizado; sandbox inicial gerou falso-vermelho (documentado).

## Assinatura

cursor · auditor cruzado · 2026-06-16T02:34:46-03:00
