---
titulo: "Parecer Cursor - Cross-IA S2 (despacho auto-declarante)"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260616-010221-cursor-cross-ia-s2-dispatch.md
id-global: 20260616-010221-cursor-cross-ia-s2-dispatch
autoria: cursor
created_at: "2026-06-16T01:02:21-03:00"
---

APROVA_S2: SIM

**Auditor:** cursor (família distinta de codex e gemini)  
**Data:** 2026-06-16T01:02:21-03:00  
**Branch:** `proposta/reestruturacao-m-a-s0` @ `121fae1`  
**Base S2:** `5d7c72f` · **main:** `4db6928` (intocada)

---

## Escopo verificado (Seção 1)

| Alegação | Evidência |
|----------|-----------|
| `schemas/dispatch.schema.json` + `core/dispatch-spec.md` | Arquivos presentes no diff `5d7c72f..HEAD`; schema com `required` em `dispatch_id`, `readback_id`, `token_fp`, `human_authorization`, `scope`, `action_plan` (`schemas/dispatch.schema.json:6-12`) |
| G-DSP-FMT `guards/validate-dispatch.sh` | Existe; valida schema, basename `dispatch_id`, corpo zsh-safe (`guards/validate-dispatch.sh:46-57`, `246-248`) |
| G-DSP-INT `guards/assert-dispatch-integrity.sh` | Existe; cruza readback ativo, `token_fp`, `human_authorization` (`guards/assert-dispatch-integrity.sh:76-87`, `188-204`) |
| Wiring bloqueante após `assert-scope-lock` | `guards/hbn-guards-runner.sh:54-56` |
| Testes B20–B22 | `bash guards/tests/run-guard-tests.sh` → `151 passaram, 0 falharam`; `bash guards/tests/adversarial-battery.sh` → B20/B21/B22 `BLOQUEADA ✓` |
| Dogfood `0025` | `.hbn/dispatch/0025-s2-dispatch-auto-declarante.md` no índice; re-staged passa ambos guards (exit 0) |
| 6 commits S2 com 3 trailers | `git log --oneline 5d7c72f..HEAD` → 6 commits (`0781df9`…`121fae1`); cada um com `HBN-Readback`, `HBN-Human-Authorization`, `HBN-Token-FP: 34a7f2f9` via `grep '^HBN-'` |

---

## Pontos de ataque (Seção 2)

### A — Coerência G-DSP-INT ✓

- **Readback inexistente:** coberto por B21 e `run-guard-tests` (`dsp-int: readback inexistente/não-ativo → BLOCK`).
- **Readback existe mas não é ativo (0024):** fixture manual → `assert-dispatch-integrity.sh` exit=1, mensagem `readback_id '0024-selagem-b19-cross-audit' não é o readback_ativo` (`guards/assert-dispatch-integrity.sh:193-195`).
- **token_fp divergente:** B20 bloqueada; fixture manual exit=1.
- **human_authorization vazio:** fixture manual → `validate-dispatch` exit=1, `assert-dispatch-integrity` exit=1.

### B — Forma G-DSP-FMT ✓

- Campo ausente, `#` no corpo, `token_fp` mal-formado: casos `dsp-fmt:*` em `run-guard-tests.sh` (151/151); B22 bloqueada.

### C — Fail-closed schema ✓

- Schema removido do índice → `validate-dispatch.sh` mensagem `Schema obrigatório ausente` (`guards/validate-dispatch.sh:47-49`), **exit=1** (fixture manual).

### D — Regressão symlink/meta-path sob `.hbn/dispatch/` ✓

- Symlink mode `120000` em `.hbn/dispatch/evil.md` → `validate-dispatch` exit=1, `assert-scope-lock` exit=1 (fixture manual). Cadeia B17–B19 intacta na bateria.

### E — Wiring ✓

- Ambos guards no array `GUARDS` (`hbn-guards-runner.sh:55-56`).
- Hook `pre-commit` executa runner (` .git/hooks/pre-commit:33-35`).
- `bash guards/hbn-guards-runner.sh` → `Todos os guards passaram`, exit 0.
- Despacho só entra no escopo dos guards via `grep -E '^\.hbn/dispatch/'` (`validate-dispatch.sh:43`, `assert-dispatch-integrity.sh:43`); bypass por `--no-verify` é invariante proibida no readback, não falha de S2.

### F — Dogfood real ✓

- `git add .hbn/dispatch/0025-s2-dispatch-auto-declarante.md` + ambos guards → exit 0 (não grandfathered).

### G — Schema×guard ✓

- Campos `required` do schema são validados por G-DSP-FMT via Python (`validate-dispatch.sh:180-208`).
- G-DSP-INT revalida subconjunto semântico (`readback_id`, `token_fp`, `human_authorization`) além do schema.
- `scope`/`action_plan` no dispatch não são cruzados com readback pelos guards de dispatch (responsabilidade de `assert-scope-lock` no diff staged) — coerente com `core/dispatch-spec.md:40-44`.

### H — Marginal trailers (não bloqueador)

- `grep '^HBN-…:'` encontra os 3 trailers em todos os 6 commits S2.
- `git log -1 --format='%(trailers:key=HBN-Readback)'` → vazio; só `HBN-Token-FP` aparece via `%(trailers)` — trailers separados por linha em branco.
- Guards ativos usam **grep**, não `%(trailers)`: `assert-baton-token.sh:147`, `assert-exception-traceable.sh:136-137` (pre-commit sem `MSG_FILE` deixa trailers para commit-msg/CI — `assert-exception-traceable.sh:156`).
- **Recomendação:** **won't-fix** para o fluxo pre-commit atual; **dívida latente** se CI passar a exigir bloco contíguo via `%(trailers)` em range (`assert-exception-traceable.sh:151`).

### I — Invariantes ✓

- `git rev-parse main` → `4db6928`; merge-base com HEAD = `4db6928`.
- Diff S2: 13 paths; 12 em `files_allowed` do readback 0025; handoff `.hbn/messages/20260616-004342-codex-handoff-s2.md` coberto por meta-path auto-allow (`assert-scope-lock.sh:247-248`, basename bate regex).
- Seis untracked antigos permanecem `??` intactos (comando `git status --porcelain` em cada path listado no readback `files_forbidden`).

---

## EXTRA (Cursor) — vetores finos

### 1. Despacho fora de `.hbn/dispatch/` (marginal, não bloqueador S2)

Front matter com semântica de dispatch em `.hbn/messages/fake-dispatch.md` staged → ambos guards retornam **0** com `Nenhum dispatch staged em .hbn/dispatch/.` (`validate-dispatch.sh:60-62`, `assert-dispatch-integrity.sh:47-49`). O escopo normativo de S2 é exclusivamente `.hbn/dispatch/` (`core/dispatch-spec.md:12-13`). Risco residual: YAML “dispatch-like” em meta-paths não passa por G-DSP; mitigado por `assert-scope-lock` e pela spec. **Sugestão futura (pós-S2):** guard de detecção de front matter `dispatch_id` fora de `.hbn/dispatch/`, análogo a B17 para meta-path.

### 2. `dispatch_id` ≠ `readback_id` sem checagem (marginal, won't-fix)

Fixture: `.hbn/dispatch/0026-outro-dispatch.md` com `readback_id: 0025-s2-dispatch-auto-declarante` (ativo) → ambos guards exit 0. Schema e spec não exigem igualdade; `dispatch_id` amarra ao basename (`validate-dispatch.sh:240-242`), `readback_id` ao STATE (`assert-dispatch-integrity.sh:193-195`). Cenário legítimo para múltiplos despachos de um readback.

---

## Comandos executados (amostra Truth Barrier)

```
git branch --show-current          → proposta/reestruturacao-m-a-s0
git rev-parse HEAD                 → 121fae1c71659d164653569ef4ff9eaaeecef479
git rev-parse main                 → 4db692876381a0d7909985c8500d999f2e677b04
bash guards/tests/run-guard-tests.sh     → 151 passaram, 0 falharam
bash guards/tests/adversarial-battery.sh → BATERIA VERDE (B1–B22)
bash guards/hbn-guards-runner.sh         → Todos os guards passaram
```

**Nota de ambiente:** primeira execução da suíte no sandbox falhou (xargs/`sysconf`); reexecução fora do sandbox confirmou resultados acima. Veredito baseado na segunda execução.

---

## Marginais não-bloqueadoras (resumo)

1. **H — trailers não-contíguos:** grep OK, `%(trailers)` parcial → won't-fix curto prazo; dívida CI futura.
2. **EXTRA — dispatch-like fora de `.hbn/dispatch/`:** guards ignoram por design de escopo; endurecimento futuro opcional.
3. **EXTRA — `dispatch_id` ≠ `readback_id`:** permitido; sem checagem cruzada necessária nesta onda.

---

## Confiança

**90 / 100** — evidência direta em disco, suítes verdes, ataques manuais reproduzidos; pequena reserva pelo comportamento sandbox na primeira passagem e pelos marginais EXTRA/H documentados.

---

*Assinado: cursor · cross-audit independente S2 · 2026-06-16T01:02:21-03:00*
