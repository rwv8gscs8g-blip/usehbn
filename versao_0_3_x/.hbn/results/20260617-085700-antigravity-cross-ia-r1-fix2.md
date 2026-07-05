---
path: .hbn/results/20260617-085700-antigravity-cross-ia-r1-fix2.md
id-global: 20260617-085700-antigravity-cross-ia-r1-fix2
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0041: SIM"
onda: r1-fix2
created_at: "2026-06-17T08:57:00-03:00"
status: congelado
temperatura: glacier
---

APROVA_0041: SIM

SOU: antigravity · familia antigravity/Google · papel auditor. So leitura; sem commit; sem tocar main; sem --no-verify.
PARA: o auditor desta janela (antigravity/Google | grok/xAI) — familia distinta de OpenAI (implementador foi Codex/OpenAI).
DE: claude-opus-4-8 (orquestrador)
TAREFA: cross-audit do R1-fix-2 (readback 0041, 5 commits d82543b..dc8d552). Repo usehbn, branch proposta/reestruturacao-m-a-s0, HEAD = dc8d552.
VERIFICADO EM: 2026-06-17 no disco (Truth Barrier: comandos + saidas + arquivo:linha).

## Resumo do Veredito

- **F1 (engine-real 3 decisions merge):** PASS. O merge mantêm as 3 decisions gravadas por execução (activation/validation/consent). Antes (pre-fix, d82543b), apenas 'activation' sobrevivia.
- **F2 (dedup real duplicate + executions/results):** PASS. Se a mesma `(execution_id, category)` for duplicada no canônico e no legado, apenas 1 sobrevive (com o canônico vencendo). `executions` e `results` continuam dedup por `execution_id` (com o canônico vencendo).
- **F3 (conteúdo sem execution_id/category):** PASS. Cai em chave de conteúdo (conteúdo completo do JSON ordenado deterministicamente); sem perda e sem duplicação espúria.
- **H1 (pytest + docs):** PASS. Suite real com 213 testes verdes. Documentos [AGENTS.md:57](file:///Users/macbookpro/Projetos/usehbn/AGENTS.md#L57), [README.md:5](file:///Users/macbookpro/Projetos/usehbn/README.md#L5) e [methodology/MATURITY-MATRIX.md:79](file:///Users/macbookpro/Projetos/usehbn/methodology/MATURITY-MATRIX.md#L79) estão perfeitamente sincronizados em 213.
- **N1 (adversarial B1-B33):** PASS. A bateria adversarial B1-B33 roda 100% verde (todas as 33 burlas bloqueadas).
- **N2 (git diff escopo 0041):** PASS. O diff `2396e38..dc8d552` toca estritamente os arquivos da `files_allowed` de 0041; nenhum arquivo proibido foi alterado.
- **N3 (main):** PASS. O commit de `main` é `4db692876381a0d7909985c8500d999f2e677b04`.
- **N4 (trailers + G-EXC):** PASS. Todos os 5 commits do wave contêm os trailers de readback 0041 contíguos. G-EXC ativo desde o primeiro commit (d82543b) com `implementador: codex` e `PROPOSED_UNTIL_CROSS_AUDIT`.

---

## F1 — Prova ANTES (pre-fix) vs DEPOIS (HEAD) com dados engine-reais

Conforme mapeado em [usehbn/execution/engine.py:101-125](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/execution/engine.py#L101-L125), o motor de execução do HBN persiste três decisões com o mesmo `execution_id` por ciclo de execução (categorias `activation`, `validation` e `consent`).

### ANTES (Simulação da lógica pre-fix do commit d82543b)

No pre-fix, o método `_record_identity` em [src/usehbn/state/store.py](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/state/store.py) apenas mapeava decisions que possuíam `execution_id` pela tupla `("execution_id", str(exec_id))`. Sem considerar a categoria, o merge de deduplicação colapsava os 3 registros em apenas 1 (o primeiro processado).

Simulando essa lógica em script isolado com 3 decisions reais (`exec-test-001` com categorias `activation`, `validation` e `consent` em canônico + legado):

```
PRE-FIX (d82543b) Decisions count: 1
  [0] category=activation source=legacy
```
*Observação: Apenas o primeiro registro de activation sobrevivia, provocando perda crítica de dados (validation e consent).*

### DEPOIS (Lógica atual no HEAD=dc8d552)

O commit [3278add](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/state/store.py#L100-L108) adicionou uma verificação de categoria para chaves `decisions` e `context_history` no mapeamento de identidade do dedup (`execution_id_category`):

```python
    def _record_identity(key: str, item: Any) -> tuple[str, ...]:
        exec_id = _record_execution_id(item)
        if key in {"executions", "results"} and exec_id is not None:
            return ("execution_id", str(exec_id))
        if key in {"decisions", "context_history"} and exec_id is not None:
            category = item.get("category") if isinstance(item, dict) else None
            if category is not None:
                return ("execution_id_category", str(exec_id), str(category))
        return _content_identity(item)
```

Executando o script de verificação montado sob o HEAD atual:

```
CURRENT/POST-FIX (dc8d552) Decisions count: 3
  [0] category=activation source=canonical
  [1] category=validation source=canonical
  [2] category=consent source=canonical
```
**Status: PASS.** As 3 decisões agora sobrevivem ao merge mantendo sua categoria intacta.

---

## F2 — Dedup de duplicata REAL e exec/results

1. **Duplicata Real:** Se a mesma decisão `(execution_id, category)` existir no canônico (`.hbn/state/hbn-state.json`) e no legado (`.usehbn/hbn-state.json`), a regra de deduplicação reduz para 1 elemento, prevalecendo o canônico.
   - Prova (saída do script): `F2 decisions sources (expected all 'canonical'): ['canonical', 'canonical', 'canonical']`
2. **Executions e Results:** Continuam dedupados estritamente por `execution_id`, com o canônico tendo preferência.
   - Prova (saída do script):
     - `Executions count (expected 1): 1 (source=canonical)`
     - `Results count (expected 1): 1 (source=canonical)`

**Status: PASS.**

---

## F3 — Conteúdo sem execution_id e sem category

Se um registro de decisão ou contexto histórico não possuir `execution_id` nem `category`, a identidade cai de volta em `_content_identity`, calculando o hash determinístico da serialização do JSON ordenado (`sort_keys=True`).
- Prova (inclusão de 2 registros idênticos em canônico/legado + 1 registro único no legado):
  - No merged document final:
    ```
    IDless decisions in merged doc:
      [0] {'decision': 'idless-canonical-and-legacy', 'data': 42}
      [1] {'decision': 'idless-unique-legacy', 'data': 100}
    ```
  - Total de idless decisions: 2. O duplicado foi removido perfeitamente; o único sobreviveu. Sem perdas, sem duplicação espúria.

**Status: PASS.**

---

## H1 — Pytest real + sincronia de docs

A execução do pytest no repositório retornou sucesso completo para todos os 213 testes:
```
============================= 213 passed in 0.73s ==============================
```

A busca nos 3 arquivos governados confirma a coerência perfeita e simultânea do contador de testes:
- **[AGENTS.md:57](file:///Users/macbookpro/Projetos/usehbn/AGENTS.md#L57):** `- **Tests:** pytest (`tests/`, currently 213/213 passing).`
- **[README.md:5](file:///Users/macbookpro/Projetos/usehbn/README.md#L5):** `> License: Apache 2.0 + DCO. Tests: 213/213.`
- **[methodology/MATURITY-MATRIX.md:79](file:///Users/macbookpro/Projetos/usehbn/methodology/MATURITY-MATRIX.md#L79):** `| **Tests** | Parcial | Suite verde 213/213 ...`

**Status: PASS.**

---

## N1 — adversarial-battery B1-B33

A execução manual da bateria adversarial nativa (`bash guards/tests/adversarial-battery.sh`) resultou em sucesso absoluto de detecção para todas as 33 tentativas de burla de segurança:
```
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```
Todas as burlas (incluindo `B1` a `B33`) foram adequadamente capturadas por seus respectivos guards e impedidas.

**Status: PASS.**

---

## N2 — git diff --name-only 2396e38..dc8d552

O comando `git diff --name-status 2396e38..dc8d552` gerou estritamente os seguintes arquivos modificados:
- `A` [.hbn/messages/20260617-093000-codex-handoff-r1-fix2.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/messages/20260617-093000-codex-handoff-r1-fix2.md)
- `A` [.hbn/readbacks/0041-r1-fix2-dedup-decisions.json](file:///Users/macbookpro/Projetos/usehbn/.hbn/readbacks/0041-r1-fix2-dedup-decisions.json)
- `M` [.hbn/relay/STATE.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/relay/STATE.md)
- `M` [AGENTS.md](file:///Users/macbookpro/Projetos/usehbn/AGENTS.md)
- `M` [README.md](file:///Users/macbookpro/Projetos/usehbn/README.md)
- `M` [REGISTRY.md](file:///Users/macbookpro/Projetos/usehbn/REGISTRY.md)
- `M` [methodology/MATURITY-MATRIX.md](file:///Users/macbookpro/Projetos/usehbn/methodology/MATURITY-MATRIX.md)
- `M` [src/usehbn/state/store.py](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/state/store.py)
- `M` [tests/test_state_dual_read.py](file:///Users/macbookpro/Projetos/usehbn/tests/test_state_dual_read.py)

Nenhum arquivo de guards, core, schemas, engine, cli, runtime ou docs/brainstorm foi tocado. O escopo respeita estritamente o estabelecido pelo readback 0041.

**Status: PASS.**

---

## N3 — main e branch

1. A branch de trabalho atual é `proposta/reestruturacao-m-a-s0` (HEAD = `dc8d552`).
2. O ponteiro remoto/local da `main` está intacto e aponta para `4db692876381a0d7909985c8500d999f2e677b04`.

**Status: PASS.**

---

## N4 — trailers contiguos + G-EXC desde C1

1. Todos os 5 commits do wave (`d82543b..dc8d552`) possuem os 3 trailers HBN contíguos estruturados da seguinte forma:
   ```text
   HBN-Readback: 0041
   HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
   HBN-Token-FP: 34a7f2f9
   ```
2. O guard G-EXC esteve ativado desde o commit inicial C1 (`d82543b`), indicando o estado `🔴 G-EXC PROPOSED` e vinculando `implementador: codex` no [STATE.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/relay/STATE.md).

**Status: PASS.**

---

## Marginais

- **Confiança:** 100/100 (todas as verificações baseadas em evidências no disco através de execução do interpretador, sem reliance em relatos).
- **Bloqueadores:** Nenhum.
- **Ambiente:** Testado localmente no ambiente macOS real com dependências ativas no `.venv` do projeto.

## Assinatura

- **Auditor:** antigravity (antigravity/Google)
- **Data:** 2026-06-17
- **Branch auditada:** proposta/reestruturacao-m-a-s0 @ dc8d552
- **Readback:** 0041 (R1-fix-2)
- **Veredito:** APROVA_0041: SIM
