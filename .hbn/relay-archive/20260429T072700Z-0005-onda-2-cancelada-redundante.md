# 0005 — Onda 2: ERP Hardening Batch 1 — CANCELADA REDUNDANTE
**Cancelada em:** 2026-04-29T07:27:00Z
**Cancelada por:** claude-opus-4.7 (architect)
**Aprovador da cancelacao:** humano:luis-mauricio
**Razao:** Auditoria pre-execucao do architect descobriu que TODAS as 6
correcoes do `reports/HBN-ERP-HARDENING-AUDIT.md` ja estao implementadas no
codigo atual (provavelmente no commit `b2b5f09 feat: harden HBN runtime and
governance flow`). Executar a Onda 2 como planejada produziria: (1) melhoria
cosmetica de mensagem de erro, (2) regressao de performance trocando
`set` comprehension por `list` comprehension em `store.py`, (3) duplicacao
do teste `test_duplicate_state_append_rejected` que ja existe.

**Evidencia (auditoria do architect em 2026-04-29):**

- `result.py:93-95` ja contem `if output_path.exists(): raise ValueError(...)`.
- `store.py:60-69` ja contem dedup com `set` comprehension.
- `tests/test_result_protocol.py:71-89` ja tem `test_result_overwrite_rejected`.
- `tests/test_result_protocol.py:92-104` ja tem `test_duplicate_state_append_rejected`.
- `tests/test_result_protocol.py:107-117` ja tem `test_optional_other_emergent_risk_may_be_omitted`.
- `tests/test_result_protocol.py:120-129` ja tem `test_action_taken_max_length_enforced`.
- `tests/test_result_protocol.py:132-142` ja tem testes de evidence parsing.
- `src/usehbn/utils/time.py` existe; `consent.py` e `result.py` ja usam `utc_now_iso()`.
- `validators.py:63-64` ja enforca `maxLength`.
- `result.schema.json:107-111` ja tem `"maxLength": 500` em `action_taken`.
- `pytest -q`: 88 passed.

**Lico aprendida:** architect deve verificar estado atual do codigo antes
de planejar ondas baseadas em relatorios de auditoria. Relatorio de auditoria
descreve estado em data X; codigo pode ter sido remediado depois sem que
o relatorio fosse atualizado.

**Decisao:** ondas 2, 3 e 4 do plano original sao todas marcadas como
`JA IMPLEMENTADA` em `docs/WAVE-PLAN-V0.3.0.md` revisao 2026-04-29. O ciclo
v0.3.0 reduz de 9 para 6 ondas. Detalhes em
`.hbn/relay-archive/20260429T072700Z-0006-onda-bastao-claude-revisao-plano-v0.3.0.md`
(quando arquivado) e em `docs/WAVE-PLAN-V0.3.0.md`.

**Acao para Codex:** nao executar Passos 2-6. Aguardar nova superprompt do
architect para a nova Onda 2 (Schema Versioning, antiga Onda 5).

---

# Conteudo original (preservado para auditoria)

## Bastao: codex
## Estado: ativo (cancelado antes de execucao)
## Criado: 2026-04-29T07:17:19Z

## Contexto Recebido

Bastão recebido por `codex` para atuar como cirurgião do código. O escopo é P0 Data Integrity para ERP: bloquear sobrescrita de result records por `execution_id` duplicado e bloquear duplicidade no state store. Não há autorização para tocar `engine.py`, `schemas/`, `docs/`, dependências, release, push ou PR.

Trechos normativos lidos:

- `agents/wave-protocol.md`: "Readback antes de qualquer alteracao"; "Hearback humano antes de cada onda"; "A IA executora PARA aqui. Nao prossegue sem Hearback humano explicito."; "Codex e cirurgiao, nao arquiteto."
- `docs/WAVE-PLAN-V0.3.0.md`: "Bloquear sobrescrita silenciosa de records ERP por `execution_id` duplicado."; "O contrato 1 `execution_id` -> 1 `result` precisa ser imposto em duas camadas: arquivo (file system) e estado agregado (state store)."; "G1 (Hearback humano antes de tocar codigo)."; "G2 (mudanca toca state store): plano de migracao + rollback documentados no Readback."
- `reports/HBN-ERP-HARDENING-AUDIT.md` Correction 2: "`create_result_record()` writes to `{execution_id}.json` without checking if the file already exists. A second call with the same `execution_id` silently overwrites the first record."; "Before writing, check if the file exists. If it does, raise a `ValueError` with a clear message".
- `reports/HBN-ERP-HARDENING-AUDIT.md` Correction 3: "`append_result_state()` appends to the `results` array without checking for duplicate `execution_id`."; "The state store should reject a duplicate `execution_id` in the `results` array."; "Both enforce the same invariant: one execution_id → one result."
- `.hbn/relay/INDEX.md`: "0005 | onda-2-erp-hardening-batch-1 | aguardando-codex-criar-readback | codex"; "Codex e cirurgiao, nao arquiteto. Em duvida, PARAR e pedir Hearback."
- `docs/MATURITY-MATRIX.md`: ERP (Result) está como Implementado e State (json append-only) como Parcial. A mudança deve endurecer integridade sem promover estado de maturidade nesta onda.

Estado atual observado em `src/usehbn/protocol/result.py`:

```python
    output_path = _results_dir(storage_dir) / f"{execution_id}.json"
    if output_path.exists():
        raise ValueError(f"Result record already exists for execution_id: {execution_id}")
    write_json(output_path, record)
    return record
```

Estado atual observado em `src/usehbn/state/store.py`:

```python
def append_result_state(result_record: Dict[str, Any], base_dir: Optional[Path] = None) -> Path:
    document = load_state_document(base_dir)
    execution_id = result_record["traceability"]["execution_id"]
    existing_ids = {
        item.get("traceability", {}).get("execution_id")
        for item in document["results"]
    }
    if execution_id in existing_ids:
        raise ValueError(f"Result state already contains execution_id: {execution_id}")
    document["results"].append(result_record)
```

Estado atual observado em `tests/test_result_protocol.py`:

```python
def test_state_append(tmp_path):
    record = create_result_record(
        execution_id="exec-125",
        agent_id="agent-codex",
        hbn_outcome="failed",
        human_status="conditional",
        action_taken="Recorded ERP failure.",
        storage_dir=tmp_path,
    )

    append_result_state(record, base_dir=tmp_path)
    state = load_state_document(tmp_path)

    assert "results" in state
    assert len(state["results"]) == 1
```

Observação cirúrgica: o código atual já contém guards parciais para Correction 2 e Correction 3, mas não está exatamente alinhado aos snippets exigidos pelo superprompt. A onda deve ajustar somente os três arquivos alvo para o contrato literal solicitado e complementar `test_state_append`.

[NOTA do architect 2026-04-29: a observacao acima foi correta em apontar a sobreposicao, mas a conclusao foi
errada em propor "alinhar ao contrato literal". O correto era cancelar a onda. Este e um alerta valido para
futuro: quando Codex detecta sobreposicao significativa, deve PARAR e pedir Hearback adicional, nao tentar
alinhar cosmeticamente. Atualizado em agents/wave-protocol.md futuramente, possivelmente em onda dedicada.]

## O Que Será Feito (CANCELADO — preservado para auditoria)

### `src/usehbn/protocol/result.py`

Em `create_result_record()`, antes de `write_json`, substituir o bloco atual por este snippet exato:

```python
    output_path = _results_dir(storage_dir) / f"{execution_id}.json"
    if output_path.exists():
        raise ValueError(
            f"Result record already exists for execution_id: "
            f"{execution_id}. Cannot overwrite."
        )
    write_json(output_path, record)
```

Razão: alinhar a guarda de overwrite à Onda 2 e tornar a mensagem de erro explícita contra sobrescrita silenciosa.

### `src/usehbn/state/store.py`

Em `append_result_state()`, antes do append, substituir a checagem atual pelo snippet exato:

```python
    existing_ids = [
        r.get("traceability", {}).get("execution_id")
        for r in document.get("results", [])
    ]
    exec_id = result_record.get("traceability", {}).get("execution_id")
    if exec_id in existing_ids:
        raise ValueError(
            f"Result for execution_id {exec_id} already in state."
        )
```

Razão: manter defesa secundária no state store com o contrato literal da onda e sem depender de `result.py`.

### `tests/test_result_protocol.py`

- Corrigir `test_state_append`: após o primeiro append e `len(state["results"]) == 1`, o segundo append com o mesmo record deve levantar `ValueError`.
- Adicionar `test_overwrite_blocked`: segunda chamada de `create_result_record` com o mesmo `execution_id` deve levantar `ValueError` com `"already exists"` na mensagem.
- Manter o escopo restrito a testes de ERP/state; nenhum teste de CLI, schema ou engine será alterado.

## Plano de Migração e Rollback (G2) — CANCELADO

Migração: a mudança não reescreve estado histórico. Ela só bloqueia novos appends/overwrites duplicados a partir da execução do código atualizado.

Rollback: a onda ficará em um diff local isolado nos três arquivos alvo. Se necessário, reverter o commit/local diff da Onda 2 restaura o comportamento anterior de mensagens/guards. Se o humano pedir reversão antes de commit, aplicar reversão somente nesses três arquivos.

## O Que NÃO Será Feito

- Não tocar `src/usehbn/execution/engine.py`.
- Não tocar `schemas/`.
- Não tocar `docs/`.
- Não tocar `core/`, `agents/`, `.github/`, `reports/`, `pyproject.toml`, `setup.cfg`, `get-hbn` ou qualquer outro arquivo fora do escopo alvo.
- Não adicionar dependência externa.
- Não renomear funções, classes, subcomandos ou termos doutrinários.
- Não implementar Corrections 1, 4, 5 ou 6 do audit nesta onda.
- Não fazer git push, PR, release ou commit.

Arquivos alvo permitidos após Hearback:

- `src/usehbn/protocol/result.py`
- `src/usehbn/state/store.py`
- `tests/test_result_protocol.py`

Arquivos de coordenação permitidos pelo protocolo:

- `.hbn/relay/0005-onda-2-erp-hardening-batch-1.md`
- `.hbn/relay/INDEX.md` apenas no fechamento da onda

## Riscos

- **R1:** bloqueio quebra fluxo legítimo onde `execution_id` é reutilizado por engano. **Mitigação:** mensagem de erro orienta correção ao indicar que o record já existe e não pode ser sobrescrito.
- **R2:** testes legados dependem do bug. **Mitigação:** `test_state_append` será corrigido na própria onda para esperar `ValueError` no segundo append.
- **R3:** state store em prod com duplicidade pré-existente. **Mitigação:** enforcement só afeta novos appends; o estado histórico não será migrado nem reescrito.

## Próximo Passo após onda

PARAR aqui e aguardar Hearback humano explícito. Após Hearback `confirmed`, executar baseline `pytest -q`, aplicar as mudanças nos três arquivos alvo, rodar verificações obrigatórias, gravar ERP, atualizar `.hbn/relay/INDEX.md`, devolver bastão para humano e aguardar Hearback final.
