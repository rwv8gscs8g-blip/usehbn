# 0007 — Onda 2: Schema Versioning
**Bastão:** codex
**Estado:** resolvido-aguardando-hearback-final
**Criado:** 2026-04-29T07:39:43Z
**Resolvido:** 2026-04-29T07:50:13Z
**Execution ID:** exec-20260429T075001Z-onda2-schema

## Contexto Recebido

Hearback da Onda 2 antiga foi rejeitado porque a auditoria do architect confirmou que o ERP Hardening Batch 1 já estava implementado. A nova Onda 2 tem escopo cirúrgico: adicionar `protocol_version` opcional a Readback e ERP Result, sem bumpar `__version__`, sem tocar engine, sem tocar docs, sem release, sem push.

Trechos normativos lidos:

- `agents/wave-protocol.md`: "Readback antes de qualquer alteracao"; "Hearback humano antes de cada onda"; "A IA executora PARA aqui. Nao prossegue sem Hearback humano explicito."; "Codex e cirurgiao, nao arquiteto."
- `docs/WAVE-PLAN-V0.3.0.md` revisão: "Auditoria pre-execucao do architect (claude-opus-4.7) descobriu que TODAS as 6 correcoes do `reports/HBN-ERP-HARDENING-AUDIT.md` ja estao aplicadas no codigo atual"; "nova Onda 2 = Schema Versioning".
- `docs/WAVE-PLAN-V0.3.0.md` Onda 2 (NOVA): "Implementar decisao Q3 do diagnostico arquitetural: adicionar campo `protocol_version` opcional em `readback.schema.json` e `result.schema.json`."; "Setar default `\"0.3.0\"` em codigo."; "NAO bumpar `__version__` ainda".
- `.hbn/relay-archive/20260429T072700Z-0005-onda-2-cancelada-redundante.md`: "Executar a Onda 2 como planejada produziria: (1) melhoria cosmetica de mensagem de erro, (2) regressao de performance trocando `set` comprehension por `list` comprehension em `store.py`, (3) duplicacao do teste".
- `.hbn/relay-archive/20260429T073500Z-0006-onda-bastao-claude-revisao-plano-v0.3.0.md`: "NAO bumpar `__version__` ainda em `src/usehbn/__init__.py`: bump fica para nova Onda 6".
- `.hbn/relay/INDEX.md`: "0007 | onda-2-nova-schema-versioning | aguardando-codex-criar-readback | codex"; "Quando Codex detectar sobreposicao significativa entre plano e estado atual do codigo, deve PARAR e pedir Hearback adicional".
- `docs/MATURITY-MATRIX.md`: "ERP (Result)" está Implementado e "State (json append-only)" aponta que "Onda 2 introduz `protocol_version` opcional."

Estado atual dos arquivos alvo:

`src/usehbn/__init__.py`:

```python
from usehbn.trigger import detect_activation

__all__ = [
    "CONSENT_QUESTION",
    "assess_guardian",
    "create_consent_record",
    "detect_activation",
    "evaluate_truth_barrier",
    "structure_intent",
]

__version__ = "0.2.0"
```

`src/usehbn/protocol/readback.py`, ponto de inserção antes de `assert_valid_payload`:

```python
    if out_of_scope:
        record["out_of_scope"] = out_of_scope
    assert_valid_payload(record, "readback.schema.json")
```

`src/usehbn/protocol/result.py`, ponto de inserção antes de `assert_valid_payload`:

```python
    if readback_id:
        record["readback_id"] = readback_id
    if environment:
        record["environment"] = environment

    assert_valid_payload(record, "result.schema.json")
```

`schemas/readback.schema.json`, fim atual de `properties`:

```json
    "created_at": {
      "type": "string",
      "minLength": 1
    }
  }
}
```

`schemas/result.schema.json`, fim atual de `properties`:

```json
    "environment": {
      "type": "object",
      "description": "Optional environment conditions that contributed to the result outcome.",
      "properties": {
        "node_version": { "type": "string" },
        "python_version": { "type": "string" },
        "os": { "type": "string" },
        "network_available": { "type": "boolean" },
        "custom": { "type": "object" }
      },
      "additionalProperties": true
    }
  }
}
```

`tests/test_result_protocol.py`, fim atual:

```python
def test_evidence_parsing_rejects_empty_fields():
    with pytest.raises(ValueError):
        _parse_evidence([" :logs/exec-123.json"])

    with pytest.raises(ValueError):
        _parse_evidence(["log: "])
```

## Verificação pre-deposit

Executado:

```bash
rg -n "PROTOCOL_VERSION|protocol_version|test_result_record_includes_protocol_version|test_protocol_version_optional_in_schema" src/usehbn/__init__.py src/usehbn/protocol/result.py src/usehbn/protocol/readback.py schemas/result.schema.json schemas/readback.schema.json tests/test_result_protocol.py
```

Resultado: nenhum match. Confirmo explicitamente:

- `PROTOCOL_VERSION` ainda não existe em `src/usehbn/__init__.py`.
- `protocol_version` ainda não está em `schemas/readback.schema.json`.
- `protocol_version` ainda não está em `schemas/result.schema.json`.
- `record["protocol_version"]` ainda não é atribuído em `src/usehbn/protocol/readback.py`.
- `record["protocol_version"]` ainda não é atribuído em `src/usehbn/protocol/result.py`.
- `test_result_record_includes_protocol_version` ainda não existe.
- `test_protocol_version_optional_in_schema` ainda não existe.

Não há sobreposição significativa detectada nesta nova Onda 2. O plano pode seguir para Hearback humano.

## O Que Será Feito

### `src/usehbn/__init__.py`

Adicionar constante `PROTOCOL_VERSION` após a docstring e antes dos imports:

```python
PROTOCOL_VERSION = "0.3.0"
```

Exportar em `__all__`:

```python
    "PROTOCOL_VERSION",
```

Não alterar:

```python
__version__ = "0.2.0"
```

### `schemas/readback.schema.json`

Adicionar `protocol_version` em `properties`, não em `required`:

```json
"protocol_version": {
  "type": "string",
  "minLength": 1
}
```

### `schemas/result.schema.json`

Adicionar bloco idêntico em `properties`, não em `required`:

```json
"protocol_version": {
  "type": "string",
  "minLength": 1
}
```

### `src/usehbn/protocol/readback.py`

Em `create_readback_record()`, após a construção do dicionário `record` e antes de `assert_valid_payload`, inserir:

```python
from usehbn import PROTOCOL_VERSION
record["protocol_version"] = PROTOCOL_VERSION
```

Se houver import circular, mover/manter o import local dentro da função.

### `src/usehbn/protocol/result.py`

Adicionar import no topo se não causar circular:

```python
from usehbn import PROTOCOL_VERSION
```

Em `create_result_record()`, após a construção do dicionário `record` e antes de `assert_valid_payload`, inserir:

```python
record["protocol_version"] = PROTOCOL_VERSION
```

Se houver import circular, trocar para import local dentro de `create_result_record()`.

### `tests/test_result_protocol.py`

Adicionar exatamente estes 2 testes:

```python
def test_result_record_includes_protocol_version(tmp_path):
    record = create_result_record(
        execution_id="exec-pv-001",
        agent_id="agent-codex",
        hbn_outcome="executed",
        human_status="approved",
        action_taken="Protocol version field present.",
        storage_dir=tmp_path,
    )
    assert record["protocol_version"] == "0.3.0"


def test_protocol_version_optional_in_schema(tmp_path):
    # Records carregados sem protocol_version (legados) devem permanecer validos.
    from usehbn.utils.validators import assert_valid_payload
    legacy_record = {
        "traceability": {"execution_id": "exec-legacy", "agent_id": "legacy"},
        "hbn_outcome": "executed",
        "human_decision": {"status": "approved"},
        "intent_risk_profile": {
            "deception": False, "improbable": False, "random": False,
            "herd_behavior": False, "financial_survival_risk": False,
            "abandonment_or_resource_loss_risk": False,
            "curiosity_driven": False, "agi_resource_shift": False,
            "ethical_break": False,
        },
        "action_taken": "Legacy record without protocol_version.",
        "created_at": "2026-01-01T00:00:00Z",
    }
    assert_valid_payload(legacy_record, "result.schema.json")  # nao deve levantar
```

## O Que NÃO Será Feito

- Não tocar `src/usehbn/execution/engine.py`.
- Não tocar outros schemas: `consent.schema.json`, `intent.schema.json`, `guardian.schema.json`, `connector-*.schema.json`.
- Não tocar `pyproject.toml`, `setup.cfg`, `get-hbn`, `core/`, `docs/`, `agents/`, `.github/`.
- Não bumpar `__version__` em `src/usehbn/__init__.py`.
- Não adicionar dependência externa.
- Não renomear funções, classes, subcomandos ou termos doutrinários.
- Não executar git push, git pr, release ou commit.
- Não arquivar este Readback antes de Hearback humano final.

## Riscos

- **R1:** tooling externo com validação exact-match pode quebrar ao encontrar campo novo. **Mitigação:** campo é opcional nos schemas e documentação pública fica para a Onda 6.
- **R2:** import circular entre `usehbn.__init__`, `readback.py` e `result.py`. **Mitigação:** usar import local dentro de `create_readback_record()` ou `create_result_record()` se import no topo falhar.
- **R3:** records antigos sem `protocol_version` precisam continuar válidos. **Mitigação:** adicionar o campo apenas em `properties`, não em `required`, e cobrir com teste de legacy record.

## Próximo Passo após onda

Onda executada após Hearback humano explícito. ERP gravado como `exec-20260429T075001Z-onda2-schema`; bastão devolvido para humano. Aguardar Hearback humano final antes de arquivar este Readback.
