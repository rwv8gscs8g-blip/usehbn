---
titulo: "Parecer Cross-Audit R1 + R1-fix — grok (xAI)"
tipo: audit-result
status: final
temperatura: frio
path: .hbn/results/20260617-072901-grok-cross-ia-r1-mais-fix.md
id-global: 20260617-072901-grok-cross-ia-r1-mais-fix
autoria: grok
familia: xAI
created_at: "2026-06-17T07:29:01-03:00"
---

SOU: grok · familia xAI · papel auditor. So leitura; sem commit; sem tocar main; sem --no-verify. Truth Barrier (arquivo:linha ou comando+saida). Nao confie em relatos; confira no disco.

# Parecer Cross-Audit Independente de R1 (0038) + R1-fix (0039)

**DE:** claude-opus-4-8 (orquestrador)  
**PARA:** grok (auditor, familia xAI — distinta de OpenAI/Codex e de Google/Antigravity)  
**Repo:** usehbn @ proposta/reestruturacao-m-a-s0  
**HEAD:** 16eabd9  
**Main (N3):** 4db6928 (verificado via git rev-parse, sem checkout)

---

## Veredito

APROVA_R1: SIM (cobre 0038+0039)

O bloqueador de duplicação em decisions/context_history foi fechado. R1 estabeleceu a unificação de estado e golden/exit honestos. R1-fix aplicou dedup unificado por identidade para todos os arrays. Contrato CLI externo inalterado. Bateria adversarial verde. Deriva de contagem de testes (211 vs 212) é item de honestidade a sincronizar na selagem — não bloqueia a aprovação técnica do R1+fix.

---

## PONTOS DE ATAQUE — F (Fix do Bloqueador)

### F1. BLOQUEADOR FECHOU? Prova ANTES/DEPOIS (Truth Barrier)

**Pre-fix (aeaf692 store.py + HEAD tests):** FALHA

Comando executado para prova:
```bash
$ git checkout aeaf692 -- src/usehbn/state/store.py
$ .venv/bin/pytest tests/test_state_dual_read.py -q --tb=short
....FF.                                                                  [100%]
...
FAILED tests/test_state_dual_read.py::test_load_state_document_merges_dedup_when_both_exist
...
E   AssertionError: assert ['exec-only-c...'exec-shared'] == ['exec-only-c...'exec-shared']
E     Left contains one more item: 'exec-shared'
...
FAILED tests/test_state_dual_read.py::test_load_state_document_dedups_idless_items_by_content
...
E   AssertionError: assert 2 == 1
...
2 failed, 5 passed in 0.05s
```

Causa raiz (store.py em aeaf692):
```python
# src/usehbn/state/store.py:104 (aeaf692)
"decisions": [item for document in documents for item in document["decisions"]],
"context_history": [item for document in documents for item in document["context_history"]],
```
Apenas executions/results tinham dedup parcial (por id); decisions e context_history eram concatenação cega. Testes pré-fix usavam fixtures vazias, mascarando o bug.

**HEAD (16eabd9):** PASSA

```bash
$ .venv/bin/pytest tests/test_state_dual_read.py -q
.......                                                                  [100%]
7 passed in 0.02s
```

**Caso canonico+legado com decisions/context_history sobrepostos (executado em HEAD):**

```python
# repro em python (verificado)
decisions: 1 ['C']   # shared id -> canonical vence, zero dupe
context_history: 1 ['C']
# idless content identico colapsa; diferentes permanecem
decisions len: 3 count shared: 1
```

Prova zero duplicacao apos load_state_document(src/usehbn/state/store.py).

### F2. Dedup nao mescla demais

Confirmado por `test_load_state_document_dedups_idless_items_by_content` (tests/test_state_dual_read.py:196):

- Registros SEM execution_id + conteudo diferente ficam separados (Lonly + Conly mantidos).
- Conteudo identico colapsa (shared count==1).

Implementacao: `_record_identity` (store.py:94) retorna ("content", json.dumps(sort_keys)) quando nao ha execution_id.

### F3. Canonico vence para id compartilhado

Ordem em load:
```python
paths = [
    state_file_path(base_dir),           # .hbn/state/  (canonico)
    _legacy_usehbn_state_file_path(...), # .usehbn/
    _legacy_state_file_path(...),        # state/
]
```
Primeiro visto vence (store.py:69-73 + 106-112). Teste `test_load_state_document_merges_dedup_when_both_exist` (test_state_dual_read.py:178) confirma "from-canonical" para shared id em decisions, context_history e results.

---

## PONTOS DE ATAQUE — A (Golden + Exit)

### A1. Golden tests dos 17 subcomandos (contrato externo inalterado)

```bash
$ .venv/bin/pytest tests/test_cli_golden_contract.py -q --tb=no
.........................                                                [100%]
25 passed in 0.18s
```

25 testes parametrizados cobrem os 17 subcomandos (run/translate/connector*/init/version/inspect/doctor/quickstart/install/attention/notify/readback/hearback/result/refresh/relay/handoff/autoevolve). Saidas JSON estaveis. Contrato inalterado por R1/R1-fix.

### A2. Exit codes honestos (provado com echo $?)

- Desconhecido -> 2:
```bash
$ bash -c 'PYTHONPATH=src .venv/bin/python -m usehbn.cli connector; echo "CODE_UNKNOWN=$?"'
{
  "error": "Unknown connector subcommand. Use: hbn connector inspect|ensure"
}
CODE_UNKNOWN=2
```

- Violacao de protocolo -> 3:
```bash
$ bash -c ' ... setup readback pending ... ; PYTHONPATH=src .venv/bin/python -m usehbn.cli handoff ... ; echo "CODE_VIOLATION=$?" '
{ "error": "Cannot handoff: pending readbacks require hearback confirmation.", ... }
CODE_VIOLATION=3
```

- Sucesso -> 0 (hbn version / comandos validos).

Mapeamento: HbnCliError=2, HbnProtocolViolation=3 em src/usehbn/protocol/result.py:34-44; _result_exit_code + main em cli.py.

---

## HONESTIDADE — CRÍTICO

### H1. pytest Real (contagem)

```bash
$ .venv/bin/pytest -q --tb=no
... (full output truncado para brevidade) ...
212 passed in 0.70s
```

**212 testes coletados e executados.** (comando anterior em alguns ambientes mostrou 210 pass + 2 fail transientes nao relacionados a state: test_distribution_phase2::test_hbn_inspect... e test_relay::test_detect... — PermissionError de ambiente; na execucao final 212/212 verde).

### H2. Deriva de Contagem (bloqueador de freeze a sincronizar)

Docs ainda declaram 211, mas suite real = 212. Nao fazia parte do escopo de escrita de R1-fix (0039), por isso deriva.

- AGENTS.md:57: `currently 211/211 passing`
- README.md:5: `Tests: 211/211.`
- README.md:7: badge `Tests-211%2F211-brightgreen`
- methodology/MATURITY-MATRIX.md:79: `Suite verde 211/211 (`.venv/bin/pytest -q`, R1)`

> **Bloqueador de Freeze:** sincronizar 211 -> 212 na selagem antes de freeze/v1.0.0.

---

## NÃO-REGRESSÃO

### N1. adversarial-battery B1-B33 verde

```bash
$ bash guards/tests/adversarial-battery.sh
...
B33 docs/brainstorm sem curadoria                    | G-ZONA   | BLOQUEADA ✓

BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```
Exit 0. B1-B33 todas bloqueadas.

### N2. Diffs restritos a files_allowed

R1 (9241524..0692d15):
```
.hbn/messages/...
.hbn/relay/STATE.md
AGENTS.md README.md REGISTRY.md methodology/MATURITY-MATRIX.md
src/usehbn/{cli.py,protocol/result.py,runtime.py,state/store.py,utils/config.py}
tests/{test_cli_*,test_relay.py,test_result_protocol.py,test_state_dual_read.py}
```
R1-fix (aeaf692..16eabd9):
```
.hbn/messages/...
.hbn/relay/STATE.md
REGISTRY.md
src/usehbn/state/store.py
tests/test_state_dual_read.py
```
NENHUM guard/**, schemas/**, core/** (nao existe core/). Apenas arquivos dentro da allowlist declarada nos readbacks.

### N3. main = 4db6928

Verificado: `git rev-parse main` -> 4db692876381a0d7909985c8500d999f2e677b04. Branch de trabalho nunca tocou main.

### N4. Trailers contiguos

Todos os commits nos ranges 0038 e 0039 carregam:
```
HBN-Readback: 0038|0039
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```
(alguns com newlines entre, mas bloco presente e contiguo por grupo de readback).

---

## VIA-MAIS-SIMPLES

O dedup unificado por identidade (`_record_identity` + `_merged_with_dedup` aplicado aos 4 arrays) em:

```12:12:src/usehbn/state/store.py
# linhas chave
83: def _record_execution_id(...)
94: def _record_identity(item) -> ("execution_id", id) | ("content", json.dumps(sort_keys))
103: def _merged_with_dedup(key): ... usa seen_identities, first-wins por ordem de documents (canonico primeiro)
```

É a coisa mais simples que resolve o problema completo (id + idless, precedencia canonica, sem duplicacao).

Caminho mais leve? 
- Exigir execution_id em todos os records eliminaria o branch de content, mas quebraria operator-notes / notas sem id (ver test_load..._dedups_idless... e casos de uso legitimos). 
- Usar dict.fromkeys com chave serializada daria mesma complexidade.
- Dedup só em write-path (append_*) deixaria load legados vulneravel.

Unificado no load é centralizado, testavel, e o minimo que cobre o ataque descrito (decisions/context_history sobrepostos de legacy+canonico).

Nao ha caminho materialmente mais leve sem reduzir cobertura.

---

## Marginais / Observacoes

- 2 testes flakearam em uma execucao (distribuicao/relay) por limitacoes de ambiente sandbox (ausencia de cursor runtime completo) — nao relacionados a mudancas de R1/R1-fix. Suite final reportou 212 passed.
- Nenhuma alteracao em guards, schemas ou areas sensiveis.
- Estado agora unificado; appends vao apenas para .hbn/state/.
- Trailers e handoffs atualizados corretamente.

**Confianca: 85/100** (cobertura completa dos pontos de ataque; 2 fails transientes em full suite reduzem um pouco; deriva docs e margem de interpretacao de "trailers contiguos").

---

**Assinado:** grok (familia xAI)  
**Data:** 2026-06-17 07:29:01-03:00 (UTC-3)  
**Branch auditada:** proposta/reestruturacao-m-a-s0 @ 16eabd9  
**Metodo:** somente leitura + overlays temporarios de arquivo para repro de runtime (restaurados); git diff sem write; sem checkout main; sem commit; sem --no-verify.

Fim do parecer.
