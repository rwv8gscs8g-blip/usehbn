---
titulo: "Cross-audit W3 — G-ZONA-LIVRE / deny-by-default zona livre"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260616-203624-grok-cross-ia-w3-deny-zona-livre.md
id-global: 20260616-203624-grok-cross-ia-w3-deny-zona-livre
autoria: grok
created_at: "2026-06-16T20:36:24-03:00"
---

APROVA_0036: SIM

# Cross-audit W3 — G-ZONA-LIVRE / deny-by-default zona livre

**Auditor:** grok (família distinta do implementador codex)  
**Orquestrador:** claude-opus-4-8  
**Branch:** `proposta/reestruturacao-m-a-s0` @ `55291e1`  
**Base W3:** `50263e1` · **main:** `4db692876381a0d7909985c8500d999f2e677b04`  
**Data:** 2026-06-16T20:36:24-03:00  
**Modo:** somente leitura; sem commit; main intocada

---

## Escopo verificado (A5)

**4 commits contíguos** sobre `50263e1`:

```
c683b0b w3: abre readback 0036
ba40c30 w3: guard G-ZONA-LIVRE (bloqueante)
c4fd64b w3: cobre deny-zona-livre e burla B33
55291e1 w3: atualiza state e handoff
```

**Trailers contíguos** (exemplo `c683b0b`, linhas 3–5 da mensagem):

```
HBN-Readback: 0036
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```

**Diff `50263e1..55291e1` — exatamente 9 paths**, todos dentro de `files_allowed` do readback 0036 (`.hbn/readbacks/0036-deny-zona-livre.json:19-28`):

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

Nenhum arquivo fora do escopo. Handoff real casa com o placeholder `20260616-HHMMSS-...` do readback.

---

## Mecanismo (Truth Barrier)

**Runner:** `guards/hbn-guards-runner.sh:58` inclui `assert-zona-livre.sh` bloqueante (após G-SCOPE).

**Guard:** `guards/assert-zona-livre.sh`

| Linha | Comportamento |
|------:|---------------|
| 30 | Seleciona staged: `grep -E '^docs/brainstorm/.+'` |
| 32-34 | Sem match → pass (ok) |
| 56-58 | STATE ausente/ilegível no índice/HEAD → fail-closed |
| 65-67 | STATE sem `readback_ativo` → fail-closed |
| 91-98 | Readback ativo ausente/ilegível → fail-closed |
| 118-125 | Exige `zona_livre_curada is True` (estrito) e `zona_livre_nota` string não-vazia |

**Readback ativo:** `.hbn/relay/STATE.md:66` → `.hbn/readbacks/0036-deny-zona-livre.json`  
**0036 não declara** `zona_livre_curada` / `zona_livre_nota` no JSON (só no campo `understanding:11`) — coerente: a onda W3 não stagedou `docs/brainstorm/**`.

---

## A1 — stage + reset (dois lados)

### Negativo — sem marcador → BLOQUEIA (rc=1)

**Repo real** (`stage+reset`, knowledge 0023):

```bash
cd /Users/macbookpro/Projetos/usehbn
echo "probe" > docs/brainstorm/_audit-probe-x.md
git add docs/brainstorm/_audit-probe-x.md
bash guards/assert-zona-livre.sh
# → COMMIT BLOQUEADO: falta "zona_livre_curada": true
# Readback ativo: .hbn/readbacks/0036-deny-zona-livre.json
git reset HEAD docs/brainstorm/_audit-probe-x.md && rm -f docs/brainstorm/_audit-probe-x.md
```

**Fixture isolada:** `A1-NEG rc=1` (readback `{"readback_id":"rb"}` + `docs/brainstorm/x.md` staged).

### Positivo — curada + nota → PASSA (rc=0)

**Fixture isolada:** readback ativo com  
`{"zona_livre_curada":true,"zona_livre_nota":"Mauricio aprovou."}` + `docs/brainstorm/x.md` staged → **`A1-POS rc=0`**.

---

## A2 — fail-closed (não passa por omissão)

| Caso | rc | Evidência guard |
|------|----|-----------------|
| STATE ausente no índice | 1 | `assert-zona-livre.sh:56-58` |
| JSON readback truncado | 1 | `assert-zona-livre.sh:114-116,134-135` |
| STATE sem `readback_ativo` | 1 | `assert-zona-livre.sh:65-67` |

Todos reproduzidos em fixtures temporárias (`A2a/A2b/A2c rc=1`).

---

## A3 — vetores finos

| Vetor | rc | Resultado |
|-------|----|-----------|
| (a) `zona_livre_curada: false` | 1 | Bloqueia (`:118` — `is not True`) |
| (b) nota `"   "` (só espaços) | 1 | Bloqueia (`:123-124`) |
| (c) marcador só em readback **inativo** | 1 | Bloqueia — lê só `readback_ativo` do STATE (`:61-63,91-98`) |
| (d) `docs/brainstorm-evil/x`, `docs/brainstormX` staged | 0 | **Não** casam o grep `^docs/brainstorm/.+` (`:30`); guard ok sem exigir curadoria — escape falso **não** ocorre; overmatch **não** ocorre |

---

## A4 — regressão

Com permissões completas (sandbox quebra fixtures git):

```bash
bash guards/tests/run-guard-tests.sh
# → == resumo: 178 passaram, 0 falharam ==

bash guards/tests/adversarial-battery.sh
# → BATERIA VERDE — B1-B33, incluindo B33 docs/brainstorm sem curadoria → G-ZONA BLOQUEADA ✓

bash guards/hbn-guards-runner.sh
# → [hbn-guards] Todos os guards passaram.
```

**main:** `git rev-parse main` → `4db692876381a0d7909985c8500d999f2e677b04` ✓

Cobertura dedicada W3: `run-guard-tests.sh:1779-1827` (positivo, sem marcador, ilegível); `adversarial-battery.sh:561-578` (B33).

---

## A6 — LEVEZA / P-CAND-01 (avaliação honesta)

**O guard agrega segurança real além da branch protection?**

- **Sim, parcialmente e no vetor certo.** Branch protection (ainda 🟡 pendente no GitHub — `STATE.md:64`) age no **merge para main**. O incidente 0024 ocorreu em **commit local na branch de trabalho** com `files_allowed` inflada — G-SCOPE sozinho permitia `docs/brainstorm/**` se listado no readback.
- **G-ZONA-LIVRE** impõe segundo sinal mecânico no **pre-commit** (`hbn-guards-runner.sh`), independente do merge — fecha a brecha “brainstorm no files_allowed sem curadoria explícita”.
- **Limite (não é teatro, mas é marginal):** `zona_livre_curada` é **auto-declarado** no mesmo JSON que a IA edita (`0036-deny-zona-livre.json`). IA maliciosa ou descuidada pode setar `true` + nota genérica no readback da onda de curadoria. O gate **não** prova que Maurício leu cada arquivo — prova que a onda **declarou** curadoria no artefato auditável, somando cross-audit + `HBN-Human-Authorization` + knowledge 0024. Contra **negligência** (caso PF-ARVORES), é robusto; contra **malícia** com `--no-verify`, não (já rastreado em 0025).
- **Via mais simples/robusta (P-CAND-01):** proibir **totalmente** `docs/brainstorm/**` em `files_allowed` de qualquer readback que não seja onda de curadoria dedicada — deny só via G-SCOPE, sem segundo marcador. Trade-off: ondas de selagem de brainstorm precisariam de readback tipo “curadoria-only” e scope_extension explícito. O desenho atual (G-SCOPE + G-ZONA) é **um pouco mais pesado**, porém **permite** ondas mistas desde que o marcador esteja presente — aceitável para MVP se cross-audit ler o marcador.

**Veredito A6:** não é teatro; é **defesa em profundidade modesta** com custo baixo (1 guard, 3 testes, 1 burla). A fraqueza estrutural (auto-declaração) é **marginal**, não bloqueador, desde que humano + cross-audit permaneçam no loop.

---

## Marginais (não bloqueadores)

1. **`mechanical_evidence` stale** em 0036 (`"readback ativo atual = 0035"`, linha 59) — metadado de abertura, não afeta guard.
2. **Auto-declaração** de `zona_livre_curada` — ver A6; mitigado por processo, não por criptografia.
3. **`--no-verify`** continua bypass local (knowledge 0025); fora do escopo W3.
4. **Branch protection GitHub** ainda pendente (`STATE.md:64`) — G-ZONA protege localmente mesmo assim.
5. **Regex** exige `docs/brainstorm/<algo>` (`.+`); paths irmãos escapam corretamente — confirmado A3d.

---

## Confianca

**88 / 100**

Motivos: evidência mecânica reproduzida (A1–A4), escopo limpo (A5), fail-closed confirmado; −12 pela auto-declaração do marcador e branch protection ainda não armada no origin.

---

**Assinatura:** grok · cross-audit read-only W3 · 2026-06-16T20:36:24-03:00
