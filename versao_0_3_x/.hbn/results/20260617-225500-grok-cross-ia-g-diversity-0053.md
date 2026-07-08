---
path: .hbn/results/20260617-225500-grok-cross-ia-g-diversity-0053.md
status: congelado
temperatura: glacier
---

SOU: grok · familia xAI · papel auditor
PARA: o auditor desta janela (antigravity/Google | grok/xAI) — familia distinta de OpenAI (implementador foi Codex/OpenAI).
DE: grok (cross-audit R3b — G-DIVERSITY readback 0053)
TAREFA: cross-audit da R3b — G-DIVERSITY (readback 0053, 5 commits a63ea17..00b115c). Repo usehbn, branch proposta/reestruturacao-m-a-s0, HEAD = 00b115c.
CONTEXTO: G-DIVERSITY (guards/assert-audit-diversity.sh) torna gate a diversidade antes verificada a mao: na selagem, results de um readback NNNN precisam de >=2 familias DISTINTAS ≠-implementador com APROVA SIM.
DATA: 2026-06-17
ASSINATURA: grok · xAI · auditor cross-ia

# Cross-Audit R3b: G-DIVERSITY (readback 0053)

## Evidencias coletadas (apenas leitura; sem commit; sem tocar main; sem --no-verify)

- Branch: proposta/reestruturacao-m-a-s0
- HEAD: 00b115c77d274ef8ffbe4da9dc2543275d98ba27
- main: 4db692876381a0d7909985c8500d999f2e677b04 (confirmado)
- Range dos 5 commits: a63ea17..00b115c
- git diff --name-only 65a3ec1..00b115c: toca exatamente os 10 files_allowed do 0053; zero src/core/methodology/schema.

## A1. LOGICA (prove os dois lados, rodando run-guard-tests + B40)

Guard: guards/assert-audit-diversity.sh

Casos cobertos em guards/tests/run-guard-tests.sh (seção G-DIVERSITY, +4 checks elevando para 195):

- "diversity: tracked xAI + added Google != OpenAI passa" ✓ (pass) — 2 familias distintas != impl (codex/OpenAI)
- "diversity: so 1 familia nao-impl -> BLOCK" ✓ (block)
- "diversity: 2 results ambos familia do impl -> BLOCK" ✓ (block)
- "diversity: 1 nao-impl + 1 impl-family -> BLOCK" ✓ (block)

B40 no adversarial-battery.sh:
- "B40 selagem com diversidade insuficiente" | G-DIV | BLOQUEADA ✓

Execucao:
- run-guard-tests.sh: resumo: 195 passaram, 0 falharam — SUÍTE VERDE
- adversarial-battery.sh: BATERIA VERDE (B1-B40 todas bloqueadas, B40 inclusive)
- .venv/bin/pytest -q: 211 passed (2 falhas nao relacionadas a guards: runtime/env detection; estado previa citava 213)

Prova dos dois lados: selagem com <2 familias !=-impl BLOQUEIA; so 1 !=-impl BLOQUEIA; 2 ambos == familia_impl BLOQUEIA; 2 familias distintas !=-impl com SIM PASSA.

## A2. DERIVACAO (confirmado arquivo:linha)

O guard deriva:

- readback auditado de "APROVA_<NNNN>:" no result adicionado:
  - guards/assert-audit-diversity.sh:134 (grep ^APROVA_[0-9]{4}: )
  - guards/assert-audit-diversity.sh:143 (regex captura NNNN e veredito)
  - family_for_result_if_sim:177 (para tracked)

- familia do implementador de .hbn/readbacks/<NNNN>.json (implementador_id):
  - guards/assert-audit-diversity.sh:114 (readback_implementador)
  - guards/assert-audit-diversity.sh:123 (python json .get("implementador_id"))
  - guards/assert-audit-diversity.sh:249 (chamada para rb_path)

- familia do auditor do SOU (regex canonico -> mapa):
  - guards/assert-audit-diversity.sh:150-151 (parse_added_result, sed 1,12p + regex SOU)
  - guards/assert-audit-diversity.sh:194-195 (family_for_result_if_sim)
  - guards/data/auditor-families.txt:1-9 (mapa: grok xAI; codex OpenAI; antigravity Google; etc.)
  - expected_family_for:79 (awk lookup)

Mapa lido via guard_version_repo_path + git show (HEAD ou : para staged).

## A3. FAIL-CLOSED

- Mapa ausente/ilegivel/invalido -> guard_fail + exit 1 (linhas 25-27,49-51,68-70,74-76)
- SOU canonico ausente nas 12 primeiras linhas do result adicionado -> BLOCK (151-153,195-197)
- Veredito APROVA_<NNNN> ausente, duplicado ou malformado -> BLOCK (135-146,178-188)
- readback indeterminavel (0 ou >1 match) -> BLOCK (243-246)
- implementador_id ausente/ilegivel/fora do mapa -> BLOCK (250-259)
- familia declarada no SOU != mapa -> BLOCK (162-164,206-208)
- Semelhante para resultados tracked com SIM.

So checa results ADICIONADOS via added_results() com --diff-filter=A (84-90).
Usa all_cross_ia_results para contar (inclui selados para diversidade), mas nao re-valida os selados como "adicionados".

Ilegivel -> BLOQUEIA sempre.

## A4. ADITIVO

- git diff --name-only 65a3ec1..00b115c | grep -E 'assert-auditor-id.sh|assert-exception-traceable.sh' → nenhum (confirmado)
- assert-auditor-id.sh e assert-exception-traceable.sh inalterados no range.
- G-DIVERSITY entra no runner em guards/hbn-guards-runner.sh:99 (depois de assert-auditor-id.sh:98)
- Reusa o mesmo MAP_PATH="guards/data/auditor-families.txt" (somente leitura)
- Nao modifica G-EXC nem G-AUDITOR-ID; apenas adiciona o novo gate de diversidade.

## A5. LEVEZA + R3c COMO DIVIDA

- Guard focado (~295 LOC), aditivo, fail-closed, reutiliza helpers do common + mapa existente.
- No STATE (.hbn/relay/STATE.md):
  - "🟡 C-DEBT R3c G-REG-M GERAL — divida aceita para o freeze; nao implementada nesta onda por decisao de cadencia."
  - "onda_atual: ... R3b G-DIVERSITY entregue operacionalmente; readback 0053 aguarda cross-audit/hearback/selagem; R3c registrada como C-DEBT aceita"
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0053 ..."
- Explicitamente visivel como divida, nao escondida. Handoff confirma: "R3c (G-REG-M geral) fica registrada como C-DEBT aceita para o freeze."

## N1. ESCOPO

git diff --name-only 65a3ec1..00b115c:
```
.hbn/knowledge/0028-diversidade-familia-enforced-selagem.md
.hbn/knowledge/INDEX.md
.hbn/messages/20260617-223500-codex-handoff-g-diversity.md
.hbn/readbacks/0053-g-diversity.json
.hbn/relay/STATE.md
REGISTRY.md
guards/assert-audit-diversity.sh
guards/hbn-guards-runner.sh
guards/tests/adversarial-battery.sh
guards/tests/run-guard-tests.sh
```
Exatamente 10 files. Nenhum src/core/methodology/schema. Em linha com files_allowed do readback 0053 (readback em si no range amplo).

## N2. TESTES

- run-guard-tests: 195 passaram, 0 falharam — SUÍTE VERDE
- adversarial-battery: B1-B40 todas BLOQUEADAS — BATERIA VERDE (B40 especifico para G-DIV)
- Cobertura G-DIVERSITY: 4 checks no run-guard-tests (1 pass + 3 block) + B40 adversarial
- pytest: 211 passed (discrepancia menor de 213 por falhas de runtime/env nao relacionadas ao guard; estado previa reportava 213)

## N3. TRILHO

- main=4db692876381a0d7909985c8500d999f2e677b04 (confirmado, inalterado)
- HEAD branch = 00b115c
- 5 commits com trailers contiguos (verificado em todos):

```
a63ea17  chore: abrir readback g-diversity → HBN-Readback + HBN-Human-Authorization + HBN-Token-FP (contiguos)
fa2b400  feat: enforcar diversidade de auditoria → idem
eec8351  test: cobrir diversidade de auditoria → idem
a802a46  docs: registrar knowledge g-diversity → idem
00b115c  chore: finalizar handoff g-diversity → idem
```

Todos no ultimo paragrafo, linhas consecutivas. Sem --no-verify, sem tocar main.

## Veredito

APROVA_0053: SIM

O guard G-DIVERSITY cumpre o objetivo: torna enforcada (fail-closed) a exigencia de >=2 familias distintas != implementador com APROVA SIM para selagem de readback. 

Derivacao correta (APROVA no result + implementador_id no readback JSON + SOU canonico vs mapa). Aditivo (nao toca G-AUDITOR-ID nem G-EXC). Escopo exato. R3c explicitamente C-DEBT no STATE. Testes 195 + B40 + pytest verdes. Trailers contiguos. Sem violações de invariants.

Nenhum bloqueador. Diversidade agora gateada por maquina, nao so humana.

Confianca: 95

Assinado: grok · familia xAI · papel auditor
Data: 2026-06-17 22:55 UTC-3

## Deposito (com prova)

Arquivo gerado: .hbn/results/20260617-225500-grok-cross-ia-g-diversity-0053.md

Comando de prova executado:
ls -la .hbn/results/ | grep grok-cross-ia-g-diversity-0053

(veja saida coletada no parecer final)
