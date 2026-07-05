# 05 — Protocolos de Teste e Novos Testes (useHBN)

**NÃO-NORMATIVO (fronteira) — insumo de pré-transição**
Autor: Engenheiro de qualidade/testes (read-only), via avaliação no disco
Data: 2026-06-17

**Resumo (3 linhas):** A suíte tem três camadas reais e verdes (pytest 213/213; bateria adversarial B1–B33 verde; guards). O risco residual não está na cobertura, mas em *fixtures sintéticas* que não têm a forma que o engine produz (3 decisions/execução), na ausência de testes de atomicidade/concorrência/propriedade, e na *deriva de contagem* de testes nos docs (114→124→181→182→211→213). Este documento descreve a estratégia atual, prioriza os pontos cegos por arquivo:linha e propõe quatro testes novos, simples e efetivos, mais a recomendação leve-vs-exúvia.

---

## 0. Como reproduzir (Truth Barrier)

```
cd <repo> && PYTHONPATH=src python3 -m pytest -q
# saída observada 2026-06-17: "213 passed in 0.73s"

bash guards/tests/adversarial-battery.sh
# saída observada: "BATERIA VERDE — toda burla documentada foi BLOQUEADA"
#   (linhas B1..B33; contagem de try_burla "B..": 34 invocações para 33 famílias)
```

Inventário de arquivos de teste: **31 arquivos** `tests/test_*.py`; **195 funções `def test_`** declaradas (contagem estática `grep -c`). O total executado é **213** porque o golden contract é parametrizado: `tests/test_cli_golden_contract.py:783` aplica `@pytest.mark.parametrize` sobre `CLI_JSON_CASES` (18 casos), e há funções parametrizadas semelhantes em `test_relay.py`/`test_result_protocol.py`. A diferença 195→213 é, portanto, esperada e *honesta* — mas nenhum gate a verifica (ver §C-iv).

---

## A. ESTRATÉGIA DE TESTE ATUAL — as três camadas

A proteção do protocolo é organizada em três camadas independentes que se complementam. Cada uma responde a uma pergunta diferente.

### Camada 1 — pytest (runtime / comportamento Python)
**Onde:** `tests/` (31 arquivos). **Como rodar:** `PYTHONPATH=src python3 -m pytest -q`.
**O que garante:** que o *código Python* faz o que diz — engine, protocolo (intent, truth_barrier, guardian, consent, result), state store (dual-read/merge/migração R1), conectores, tradução, autoevolve e o **contrato JSON do CLO**.

Subcamadas relevantes:
- **Contrato do CLI (golden / characterization):** `tests/test_cli_golden_contract.py`. Roda cada subcomando de verdade, normaliza ruído não-determinístico (paths tmp, `exec-…`, ISO-8601, ids de connector/remote-lookup — `:36-56`) e compara um *recorte semântico* do JSON (`_summary_*`), não o texto bruto. Cobre 18 subcomandos via `CLI_JSON_CASES` (run, translate, connector inspect, connector ensure, init, version, inspect, doctor, quickstart, install, attention, notify, readback, hearback, result, refresh, relay status, handoff) + `autoevolve` em função própria (`test_cli_autoevolve_golden_contract`). Também fixa **exit codes** de erro e de violação de protocolo (`:…error_exit_code…`, `:…protocol_violation…`).
- **State dual-read / migração R1:** `tests/test_state_dual_read.py` — o coração do risco de perda/duplicação. Exercita `load_state_document` (merge de `.hbn/state/` + legados `.usehbn/` e `state/`) com dedup por identidade.
- **Protocolo de result:** `tests/test_result_protocol.py` — criação, enum, max-length, rejeição de overwrite/append duplicado, leitura de readback legado.
- **Demais invariantes:** `test_protocol_invariant.py`, `test_version_constants.py`, `test_adr_010_present.py`, `test_execution_decision_reason.py`, etc.

### Camada 2 — guards (`guards/tests/run-guard-tests.sh`)
**O que garante:** que os *guards de governança* (G-NUM, G-CR, G-SCO, G-FAM, G-HRB, G-TOK, G-STRAY, etc.) bloqueiam e liberam nos casos certos — o nível de "regras do jogo" (numeração serial, raiz canônica, scope-lock, papel-família, integridade de hearback/baton). É o teste *dos próprios mecanismos de controle*, não do código de produto.

### Camada 3 — bateria adversarial (`guards/tests/adversarial-battery.sh`, B1–B33)
**O que garante:** que cada **burla já documentada** nos cross-audits permanece bloqueada. Cabeçalho do arquivo (`adversarial-battery.sh:4-15`): "tenta CADA burla documentada … e EXIGE que o guard correspondente BLOQUEIE. Qualquer burla passando = bateria vermelha = onda reprovada." É a *memória imune* do protocolo: toda burla nova achada vira uma linha permanente B-n. Saída observada: 33 famílias, todas BLOQUEADAS.

**Como se relacionam:** Camada 1 prova *correção funcional*; Camada 2 prova *que as regras funcionam*; Camada 3 prova *que regressões de segurança conhecidas não voltam*. As três são pré-condição de selagem de onda. Documentação parcial existe (`docs/SAFE-TESTING.md` cobre o fluxo manual seguro; `AGENTS.md:57` cita "pytest currently 213/213"), mas **não há um `tests/README` canônico** que descreva as três camadas juntas — este documento serve de semente para ele.

---

## B. PONTOS CEGOS PRIORIZADOS (arquivo:linha)

> O fio condutor: os dois bugs de perda/duplicação passaram porque a fixture não tinha **a forma que o engine produz** — `src/usehbn/execution/engine.py:99-125` grava **3 decisions por execução** (categorias `activation`, `validation`, `consent`, todas com o **mesmo `execution_id`**) via `append_execution_state` (`engine.py:207-227`).

### P1 (ALTO) — Atomicidade ausente na escrita de estado
`src/usehbn/utils/logger.py:20-22`: `write_json` faz `path.write_text(...)` direto, **sem tmp+`os.replace`, sem fsync**. Todo `hbn-state.json` é reescrito inteiro por `append_execution_state`/`append_result_state` (`state/store.py:157,173`). Um crash/disco-cheio no meio do `write_text` **trunca e corrompe todo o estado acumulado** — exatamente a classe "perda de estado". **Nenhum teste cobre isso.**

### P2 (ALTO) — Fixtures de merge ainda parcialmente sintéticas
`tests/test_state_dual_read.py:42-48` (`_decision_record`) e `:80-85` (`_context_record`) produzem **1 decision por execution_id**, sem as 3 categorias do engine. O teste bom já existe (`:238 _engine_decision_records`, 3 categorias), mas **convive** com os helpers sintéticos que ainda alimentam `test_load_state_document_merges_dedup_when_both_exist` (`:155-235`). Enquanto o helper sintético existir, futuros testes de merge tenderão a reusá-lo e mascarar o mesmo bug de novo. A identidade real de decision é `("execution_id_category", exec_id, category)` (`store.py:104-107`) — uma fixture de 1-decision *nunca exercita* a colisão por categoria.

### P3 (MÉDIO) — Sem teste de propriedade "merge não perde nem duplica"
A lógica de dedup (`store.py:110-127`) é validada só por exemplos pontuais. Não há propriedade verificando que, para *quaisquer* dois documentos, o merge contém **exatamente** o conjunto de identidades distintas (nem a menos = perda, nem a mais = duplicação). É o tipo de garantia que pega os casos que os exemplos esquecem.

### P4 (MÉDIO) — Sem teste de malformados na leitura de estado
`store.py:52-59` (`_read_json_or_empty`) faz `json.loads` direto: JSON truncado/corrompido **levanta exceção não tratada**. Não há teste para `.hbn/state/hbn-state.json` corrompido, chave faltando com tipo errado (ex.: `decisions: 42`), ou encoding inválido. Combina com P1: a corrupção que P1 cria, P4 não detecta graciosamente.

### P5 (MÉDIO) — Sem teste de concorrência
Dois `execute_request` simultâneos no mesmo `storage_dir` fazem read-modify-write não atômico (`store.py:151-157`): o segundo sobrescreve o primeiro (lost update). Sem cobertura.

### P6 (BAIXO) — Golden tests: robustez vs fragilidade
`test_cli_golden_contract.py` é **robusto onde importa** (normaliza não-determinismo, compara recorte semântico — `:36-56,81-90`), então mudança cosmética de mensagem *não* quebra. Risco inverso: por comparar só o recorte (`_summary_*`), **campos novos no JSON podem passar despercebidos** (cobertura não falha ao *adicionar*). Aceitável, mas convém um caso que afirme o conjunto de chaves de topo de pelo menos um comando.

### P7 (BAIXO) — Deriva de contagem nos docs
Contagem real hoje: **213**. Docs citam números conflitantes e desatualizados: `docs/HUMAN-VALIDATION-v0.3.0.md:121,263,299,614` ("114 passed"), `docs/feynman/USEHBN-EXPLICADO.md:137` ("124"), `docs/PROPOSAL-V0.4.0.md:13,122` ("182"), `docs/ANALISE-PROFUNDA…-2026-06-10.md:31` ("182"), brainstorms citando ~181/211. Apenas `AGENTS.md:57` está correto (213/213). A própria síntese reconhece (`docs/brainstorm/rodada-2026-06-17/SINTESE-PROFUNDA-pre-freeze.md:31`): "A honestidade da contagem de testes depende de humanos rodarem pytest … não há gate que case `pytest -q` com o número nos docs."

---

## C. PROPOSTAS DE NOVOS TESTES (concretas e SIMPLES)

### (i) Helper de estado *engine-real* — fixture com a forma que o engine produz
**Ideia:** um único helper compartilhado que gera estado **rodando o engine de verdade**, em vez de montar dicts à mão.

```python
# tests/_engine_state.py  (novo helper, importado pelos testes de merge)
from pathlib import Path
from usehbn.execution.engine import execute_request
from usehbn.state.store import load_state_document

def real_engine_state(tmp: Path, sentences: list[str]) -> dict:
    """Estado com a forma REAL: 3 decisions/execução, mesmo execution_id."""
    for s in sentences:
        execute_request(s, storage_dir=tmp)        # grava 3 decisions + 1 exec + 1 ctx
    return load_state_document(tmp)                 # documento canônico real
```

**Por que é melhor/mais simples:** elimina o `_decision_record` sintético de 1-categoria (P2). Os testes de merge passam a copiar `.hbn/state/` real para uma posição legada e mesclar — exercitando de fato a identidade `(exec_id, category)`. Substitui ~40 linhas de dicts manuais por 3 linhas, e **não pode** divergir da forma do engine porque *é* o engine. Ação concreta: refatorar `test_load_state_document_merges_dedup_when_both_exist` para consumir este helper e **remover** `_decision_record`/`_engine_decision_records` duplicados.

### (ii) Teste de propriedade — "merge nunca perde nem duplica registro distinto"
**Ideia:** propriedade sobre `load_state_document`/merge, sem depender de `hypothesis` se preferir manter zero-dependências (gerador aleatório simples com `random.seed` fixo).

```python
def test_merge_preserves_exactly_distinct_identities(tmp_path):
    canon, legacy = _random_two_docs(seed=1234)     # gera execs com 3 decisions cada
    _write(state_file_path(tmp_path), canon)
    _write(_legacy_usehbn_state_file_path(tmp_path), legacy)
    merged = load_state_document(tmp_path)
    for key in ("decisions", "context_history", "results", "executions"):
        expected = _distinct_identities(canon[key] + legacy[key])   # mesma fn de store
        got      = {_record_identity(key, it) for it in merged[key]}
        assert got == expected            # ⇐ nem a menos (perda) nem a mais (dup)
```

**Por que é melhor:** uma asserção (`got == expected`) cobre *toda a família* dos dois bugs. Se a regra de identidade mudar e passar a fundir o que era distinto (perda) ou duplicar o compartilhado, falha imediatamente — algo que os exemplos atuais (`:155-235`) só pegam por coincidência. Mais simples que escrever N casos manuais.

### (iii) Teste de atomicidade do result/estado
**Ideia (duas variantes, ambas simples):**

*Variante mínima de regressão (sem mudar produção):* afirma o invariante observável — após qualquer sequência de `append_*`, o arquivo sempre desserializa para um documento com as 4 chaves-lista:

```python
def test_state_file_always_parseable_after_appends(tmp_path):
    for s in ["use hbn a", "use hbn b", "noise"]:
        execute_request(s, storage_dir=tmp_path)
    raw = state_file_path(tmp_path).read_text(encoding="utf-8")
    doc = json.loads(raw)                              # não pode levantar
    assert {"executions","decisions","context_history","results"} <= doc.keys()
```

*Variante forte (recomenda mudança em produção):* injetar falha entre escrita e troca para provar que o arquivo antigo permanece íntegro — o que **exige** primeiro tornar `write_json` atômico (tmp + `os.replace`). Ver Recomendação D.

**Por que é melhor:** hoje não há *nenhuma* asserção de que o estado sobrevive a múltiplas escritas; a variante mínima é 5 linhas e fecha P1/P4 no nível observável sem tocar produção.

### (iv) Gate de honestidade de contagem (script)
**Ideia:** um script curto que roda a coleta real e compara com o número declarado no doc canônico (`AGENTS.md`), falhando na deriva.

```bash
# guards/tests/assert-test-count.sh
real=$(cd "$REPO" && PYTHONPATH=src python3 -m pytest -q --collect-only 2>/dev/null \
        | grep -cE '::test_')              # contagem real coletada
declared=$(grep -oE '[0-9]+/[0-9]+ passing' AGENTS.md | grep -oE '^[0-9]+')
[ "$real" = "$declared" ] || { echo "DERIVA: real=$real declared=$declared"; exit 1; }
```

**Por que é melhor:** transforma "depende de um humano rodar pytest" (SINTESE-PROFUNDA:31) em **gate mecânico**. Uma fonte única de verdade (`AGENTS.md`); os demais docs deixam de citar números (ou apontam para AGENTS). Resolve P7 de forma durável e barata.

---

## D. RECOMENDAÇÃO — antes do freeze (leve) vs exúvia

**Entram ANTES do freeze (leve, sem mudar produção, alto valor/baixo risco):**
- **C-i** (helper engine-real) + refatorar o teste de merge sintético — fecha a *causa-raiz* dos dois bugs; só mexe em `tests/`.
- **C-iii variante mínima** (estado sempre parseável após appends) — 5 linhas, fecha o observável de P1/P4.
- **C-iv** (gate de honestidade de contagem) + alinhar os docs desatualizados a 213 — fecha P7, que é uma *mentira documental ativa* hoje.
- **P4 mínimo:** um teste afirmando que JSON corrompido em `.hbn/state/` produz erro *claro* (ou é ignorado graciosamente) em vez de stacktrace cru.

**Ficam para a EXÚVIA (exigem mudança de produção ou infra de teste mais pesada):**
- **C-ii property-based** completo (idealmente com `hypothesis`, que adiciona dependência) — alto valor, mas é endurecimento, não pré-condição de freeze.
- **C-iii variante forte** + tornar `write_json` atômico (`logger.py:20-22` → tmp+`os.replace`+`fsync`) — é a correção *real* de P1; melhor fazer com calma pós-freeze para não introduzir risco às vésperas da transição.
- **P5 concorrência** (lock/lost-update) — requer decisão de design (file lock vs append-log); legítimo adiar.

**Racional do corte:** antes do freeze, só o que (a) não toca código de produção e (b) mata a causa-raiz já demonstrada. Atomicidade e concorrência mudam produção e merecem sua própria onda; a property-based traz dependência. O gate de contagem entra porque corrigir docs que *afirmam* números falsos é higiene de transição, não escopo novo.

---

## Resumo executivo (8–12 linhas)

A suíte do useHBN está verde nas três camadas: pytest **213/213** (observado 2026-06-17, 0.73s), bateria adversarial **B1–B33 toda BLOQUEADA**, e os guards. O contrato do CLI é coberto por golden tests *robustos* — normalizam não-determinismo e comparam recorte semântico, cobrindo 18 subcomandos parametrizados + `autoevolve`; não quebram com mudança cosmética. O risco residual não é cobertura, é **realismo de fixture**: o engine grava 3 decisions por execução (mesmo `execution_id`, categorias activation/validation/consent — `engine.py:99-125`), e `tests/test_state_dual_read.py` ainda mantém helpers sintéticos de 1-decision (`:42-48`) ao lado do helper real (`:238`), o que pode mascarar de novo a classe de bugs de perda/duplicação. Faltam três proteções: **atomicidade** (`logger.py:20-22` escreve sem tmp+replace/fsync — corrupção possível), **malformados** (`store.py:52-59` faz `json.loads` cru) e **concorrência** (read-modify-write não atômico em `store.py:151-157`). Há ainda **deriva de contagem** nos docs (114/124/182/211 vs 213 real); só `AGENTS.md:57` está correto. Proponho quatro testes simples: (i) helper que gera estado *engine-real* via `execute_request`, (ii) propriedade "merge nunca perde nem duplica", (iii) teste de atomicidade/parseabilidade do estado, (iv) gate mecânico que casa `pytest --collect-only` com o número declarado. Antes do freeze entram i, iii-mínima, iv e um teste de malformado (tudo só em `tests/`); ficam para a exúvia a property-based completa, a atomicidade real em `write_json` e o tratamento de concorrência, por exigirem mudança de produção/infra.
