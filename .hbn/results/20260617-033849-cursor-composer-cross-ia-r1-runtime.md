---
titulo: "Parecer R1 — Cross-IA da Onda R1 (Cursor Composer)"
tipo: audit-result
status: final
temperatura: frio
path: .hbn/results/20260617-033849-cursor-composer-cross-ia-r1-runtime.md
id-global: 20260617-033849-cursor-composer-cross-ia-r1-runtime
autoria: cursor-composer
familia: Cursor/Antigravity
created_at: "2026-06-17T03:38:49-03:00"
---

SOU: cursor-composer · familia Cursor/Antigravity · papel auditor

APROVA_0038: SIM

## Escopo auditado

- Repo: `/Users/macbookpro/Projetos/usehbn`
- Branch: `proposta/reestruturacao-m-a-s0` @ `0692d15`
- Range alegado: `da75a2b..0692d15` (6 commits)
- `git rev-parse main` → `4db692876381a0d7909985c8500d999f2e677b04` ✓

## A1 — Golden tests dos 17 subcomandos

**Veredito: PASSA.**

- Arquivo: `tests/test_cli_golden_contract.py`
- `CLI_JSON_CASES`: 18 casos parametrizados (inclui `connector inspect|ensure` e `relay status` como superfícies aninhadas) + `test_cli_autoevolve_golden_contract` separado.
- `src/usehbn/cli.py:1736-1754`: 18 subcomandos de topo (`autoevolve` incluso); sem `autoevolve` = 17.
- Execução independente:

```
.venv/bin/pytest tests/test_cli_golden_contract.py -q -v
25 passed in 0.19s
EXIT_CODE=0
```

Os testes normalizam timestamps/IDs e comparam envelopes JSON — prova de contrato externo estável, não apenas smoke.

## A2 — Exit codes honestos (CLI real)

**Veredito: PASSA** (com nota sobre top-level).

Comandos reais (` .venv/bin/hbn `):

| Cenário | Saída (trecho) | `$?` |
|---|---|---|
| `hbn connector` (subcomando ausente) | `"error": "Unknown connector subcommand..."` | **2** |
| `hbn relay` (subcomando ausente) | `"error": "Unknown relay subcommand..."` | **2** |
| `hbn version` (sucesso) | `"package_version": "0.3.0"` | **0** |
| `hbn handoff` com readback `hearback_status: pending` | `"error": "Cannot handoff..."`, `"pending_readbacks": ["exec-pending"]` | **3** |

Implementação: `src/usehbn/protocol/result.py:34-45` (`HbnCliError.exit_code=2`, `HbnProtocolViolation.exit_code=3`); `src/usehbn/cli.py:1713-1718` (`_result_exit_code`).

**Nota marginal:** token de topo que não é subcomando (ex. `hbn foobar`) cai em `run_protocol` (`cli.py:1805-1808`) e retorna **0** — comportamento pré-existente, não regressão de R1; golden tests cobrem erros aninhados e violações de protocolo.

## A3 — Estado unificado `.hbn` canônico

**Veredito: PASSA.** Sem duplo-write na origem.

| Evidência | Arquivo:linha |
|---|---|
| Constantes canônicas | `utils/config.py:12-13` (`STATE_DIRNAME=".hbn"`, `LEGACY_STATE_DIRNAME=".usehbn"`) |
| Escrita única de state | `state/store.py:136-137`, `152-153` → só `state_file_path()` (`.hbn/state/hbn-state.json`) |
| Leitura legada + dedup | `state/store.py:62-107` (precedência `.hbn` → `.usehbn` → `state/`, dedup por `execution_id`) |
| Inspect read-only legado | `runtime.py:377-385` |
| Readbacks escritos só em `.hbn/` | `protocol/readback.py:24-27`, `86-87` |
| Results escritos só em `.hbn/` | `protocol/result.py:127-131` (legado só lido em `139-141`) |
| Migração tolerante readback | `cli.py:1409-1417` (cópia one-way legado→canônico, não dual-write) |

`grep` em `src/` não encontrou `write_json`/`write_text` apontando para `.usehbn/`.

Testes dedicados: `tests/test_state_dual_read.py` (5 casos na suíte).

## A4 — Honestidade (pytest + docs)

**Veredito: PASSA.**

**Saída REAL do pytest (evidência independente):**

```
.venv/bin/pytest -q
........................................................................ [ 34%]
........................................................................ [ 68%]
...................................................................      [100%]
211 passed in 0.71s
EXIT_CODE=0
```

| Documento | Contagem / ponteiro | Verificado |
|---|---|---|
| `AGENTS.md:57` | `211/211 passing` | ✓ |
| `README.md:5` | `Tests: 211/211` | ✓ |
| `methodology/MATURITY-MATRIX.md:79` | `Suite verde 211/211` | ✓ |
| `AGENTS.md:17` | `methodology/MATURITY-MATRIX.md` (não `docs/`) | ✓ |
| Autoevolve Scaffold/Parcial | `methodology/MATURITY-MATRIX.md:73-75` | ✓ |
| L4 removido | `da75a2b:README.md:559` tinha `"solid L4 level"`; HEAD substituiu por linguagem ancorada na matriz (`README.md:561`) | ✓ |

## A5 — Sem regressão

**Veredito: PASSA** (1 marginal de escopo).

- `git diff da75a2b..0692d15 -- guards/ core/ schemas/` → vazio.
- `bash guards/tests/adversarial-battery.sh` → **BATERIA VERDE** (B1–B33 bloqueadas), `ADV_EXIT=0`.
- 16 arquivos do diff casam `files_allowed` do readback 0038; 1 marginal:
  - `.hbn/messages/20260616-235900-codex-handoff-r1.md` vs placeholder `20260616-HHMMSS-...` em `0038-r1-runtime-honestidade.json:32` — padrão B17 (meta-path auto-allow), não bypass de escopo de código.

## A6 — Trailers contíguos (6 commits)

**Veredito: MARGINAL — não bloqueador.**

Commits `9241524`–`0cc616f`: trailers presentes mas **com linha em branco entre cada trailer** (ex. `git log -1 --format='%B' 6505b6b`).

Commit `0692d15`: trailers contíguos no último parágrafo ✓

```
HBN-Readback: 0038
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```

Readback exige contiguidade (`0038-r1-runtime-honestidade.json:50`); 5/6 commits divergem cosmeticamente.

## A7 — P-CAND-01 (leveza + risco silencioso)

**Veredito: adequado, risco baixo.**

A unificação é a via mais simples que resolve: um único root de escrita (`.hbn/`) + leitura merge/dedup na carga (`store.py:62-107`). Alternativas (symlinks, dual-write, migração batch) seriam mais pesadas.

Riscos marginais de contrato silencioso:

1. `decisions`/`context_history` concatenam sem dedup (`store.py:104-105`) — duplicatas possíveis se legado e canônico coexistirem.
2. `_migrate_legacy_readback_if_needed` (`cli.py:1409-1417`) copia readback legado→canônico sob demanda — side-effect de escrita em leitura, mas unidirecional e documentado.

Nenhum indício de quebra do contrato JSON do CLI.

## Marginais (não bloqueadores)

1. Trailers com linhas em branco em 5/6 commits (A6).
2. Handoff com timestamp concreto vs placeholder HHMMSS no `files_allowed` (A5).
3. Top-level não-subcomando roteado para `run` com exit 0 (A2 nota).
4. `decisions`/`context_history` sem dedup no merge legado (A7).

## Confiança

**93/100** — evidências reproduzidas no disco; pytest e adversarial rodados fora do sandbox; única ressalva é cosmetic/format nos trailers.

---

Assinatura: **cursor-composer** (família Cursor/Antigravity)  
Data: **2026-06-17T03:38:49Z**  
Orquestrador: claude-opus-4-8  
Readback: 0038-r1-runtime-honestidade
