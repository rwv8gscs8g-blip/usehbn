# 0006 — Onda do Bastao: Revisao do Plano v0.3.0 (architect deposit)

**Bastao:** claude-opus-4.7 (architect)
**Estado:** ativo
**Criado:** 2026-04-29T07:27:00Z
**Atualizado:** 2026-04-29T07:27:00Z

## Contexto Recebido

- Onda 2 (Readback 0005, antiga ERP Hardening Batch 1) recebeu Hearback REJEITADO do humano em 2026-04-29 apos auditoria pre-execucao do architect.
- Auditoria descobriu que TODAS as 6 correcoes do `reports/HBN-ERP-HARDENING-AUDIT.md` ja estao implementadas no codigo atual:
  - `src/usehbn/utils/time.py` existe; `consent.py:16,59` e `result.py:16,79` ja usam `utc_now_iso()`.
  - `result.py:93-95` ja bloqueia overwrite com `if output_path.exists(): raise ValueError(...)`.
  - `store.py:60-69` ja deduplica com `set` comprehension (melhor que `list` proposto).
  - `result.py:65-66` ja torna `other_emergent_risk` condicional.
  - `result.schema.json:107-111` ja tem `maxLength: 500` em `action_taken`.
  - `validators.py:63-64` ja enforca `maxLength`.
  - `tests/test_result_protocol.py` tem `test_result_overwrite_rejected`, `test_duplicate_state_append_rejected`, `test_optional_other_emergent_risk_may_be_omitted`, `test_action_taken_max_length_enforced`, `test_evidence_parsing_*`.
  - `pytest -q`: 88 passed (verificado pelo architect).
- Provavel commit que aplicou as correcoes: `b2b5f09 feat: harden HBN runtime and governance flow`.
- Humano (luis-mauricio) aprovou em 2026-04-29: (1) Hearback REJEITADO para Onda 2 atual; (2) plano revisado de 6 ondas; (3) deposito da iteracao 0006 com lico aprendida.

## Objetivo desta Iteracao

Re-depositar plano canonico do ciclo v0.3.0 com:

1. Onda 2 (antiga, ERP Hardening Batch 1) marcada como `JA IMPLEMENTADA`.
2. Onda 3 (antiga) marcada como `JA IMPLEMENTADA`.
3. Onda 4 (antiga) marcada como `JA IMPLEMENTADA`.
4. Renumeracao das ondas restantes para 6 ondas no total:
   - Nova Onda 2 = Schema Versioning (antiga Onda 5).
   - Nova Onda 3 = Relay Invariants (antiga Onda 6).
   - Nova Onda 4 = Connector Lifecycle Registry (antiga Onda 7).
   - Nova Onda 5 = Cleanup + state/ Legacy Migration (antiga Onda 8).
   - Nova Onda 6 = Vitrine + Release (antiga Onda 9).
5. Lico aprendida explicita: architect deve verificar estado atual do codigo antes de planejar ondas baseadas em relatorios de auditoria.
6. Superprompt para Codex executar a NOVA Onda 2 (Schema Versioning) sera passado pelo humano apos Hearback final desta iteracao.

## O Que Foi Feito (architect, sem tocar em codigo de runtime)

- Arquivado `0005-onda-2-erp-hardening-batch-1.md` em `.hbn/relay-archive/20260429T072700Z-0005-onda-2-cancelada-redundante.md` com nota de cancelamento explicita no topo (motivo, evidencia, lico aprendida, acao para Codex).
- Atualizado `docs/WAVE-PLAN-V0.3.0.md`:
  - Nova secao `## Revisao 2026-04-29 — Ondas 2-4 ja implementadas` no topo.
  - Renumeracao da `## Ordem das Ondas`.
  - Nova Onda 2 (Schema Versioning) com diff planejado em snippets exatos: `src/usehbn/__init__.py` (constante `PROTOCOL_VERSION`), `schemas/readback.schema.json` e `schemas/result.schema.json` (campo opcional), `src/usehbn/protocol/readback.py` e `src/usehbn/protocol/result.py` (atribuicao do campo), `tests/test_result_protocol.py` (2 novos testes).
  - Marcacao `JA IMPLEMENTADA` em cada secao das antigas Ondas 2, 3, 4.
  - Renomeacao dos cabecalhos das antigas Ondas 6, 7, 8, 9 para novas 3, 4, 5, 6.
  - Justificativa atualizada em "A ordem revisada foi escolhida por".
- Atualizado `.hbn/relay/INDEX.md` (em alteracao paralela): bastao com claude (architect), iteracao 0006 ativa, iteracao 0005 marcada como cancelada.

## Lista de Arquivos Tocados

- `docs/WAVE-PLAN-V0.3.0.md` (modificado).
- `.hbn/relay-archive/20260429T072700Z-0005-onda-2-cancelada-redundante.md` (novo, arquivamento de 0005).
- `.hbn/relay/0006-onda-bastao-claude-revisao-plano-v0.3.0.md` (este arquivo).
- `.hbn/relay/INDEX.md` (em alteracao paralela).

Nenhum arquivo em `src/`, `schemas/`, `tests/`, `core/`, `agents/`, `pyproject.toml`, `get-hbn`, `.github/`, `reports/`, `docs/CASE-STUDY-CREDENCIAMENTO.md` foi tocado. Esta iteracao e exclusivamente revisao doutrinaria + arquivamento.

## Decisoes Tomadas (architect)

- **Cancelar Onda 2 (Readback 0005) sem rollback de codigo**: nao houve mudanca de codigo a reverter. Apenas arquivamento do Readback nao executado e nota de cancelamento.
- **Preservar secoes historicas** das antigas Ondas 2, 3, 4 em `docs/WAVE-PLAN-V0.3.0.md`: nao deletar; marcar como `JA IMPLEMENTADA`. Auditoria futura pode precisar entender por que essas ondas foram pensadas e descartadas.
- **Promover Schema Versioning para nova Onda 2**: e a primeira onda do ciclo que ainda envolve codigo. Risco baixo (campo opcional), valor alto (preserva audit trail).
- **Lico aprendida sera incorporada formalmente em `agents/wave-protocol.md`** na nova Onda 5 (Cleanup), nao em onda dedicada. Mantem ciclo enxuto.
- **NAO bumpar `__version__` ainda em `src/usehbn/__init__.py`**: bump fica para nova Onda 6 (Vitrine + Release), conforme principio de fechamento. Por hora apenas adicionar `PROTOCOL_VERSION = "0.3.0"` como constante separada.

## Riscos e Mitigacoes (deste deposito)

- **R1**: Codex pode tentar executar a NOVA Onda 2 sem Hearback humano explicito. **Mitigacao**: superprompt da NOVA Onda 2 reafirma "PARAR apos criar Readback inicial".
- **R2**: humano pode preferir adicionar a NOVA Onda 5 antes de avancar (ex.: lico aprendida em `wave-protocol.md` antes de qualquer onda de codigo). **Mitigacao**: este Readback e o trigger humano resolvem isso explicitamente; lico aprendida ja esta em `docs/WAVE-PLAN-V0.3.0.md` e em `.hbn/relay-archive/20260429T072700Z-0005-onda-2-cancelada-redundante.md`. Atualizacao formal de `wave-protocol.md` fica para Onda 5.
- **R3**: import circular `usehbn.__init__` <-> `usehbn.protocol.result/readback`. **Mitigacao**: superprompt da NOVA Onda 2 instrui Codex a usar import local dentro da funcao se import topo causar circular; pytest valida.

## Proximo Passo

1. **Hearback humano** sobre este deposito (iteracao 0006). Esperado: confirmacao + autorizacao para passar bastao ao Codex executar nova Onda 2.
2. Apos Hearback, humano cola para Codex o superprompt da nova Onda 2 (Schema Versioning) — conteudo embedado em `docs/WAVE-PLAN-V0.3.0.md` secao "Onda 2 (NOVA) — Schema Versioning".
3. Codex cria Readback inicial (provavelmente numerado `0007`) e PARA aguardando Hearback humano sobre o plano detalhado dele.
4. Apos execucao, humano invoca `"Claude, auditar Onda 2 (Schema Versioning) contra docs/WAVE-PLAN-V0.3.0.md e agents/wave-protocol.md."`.

## Pendencias

- Aguardando Hearback humano sobre revisao do plano (iteracao 0006).
- RFC-0001 (`--enforce`) permanece aberto, sem janela definida em v0.3.0.
- Lico aprendida formalizada apenas em docs por hora; entrada em `agents/wave-protocol.md` planejada para nova Onda 5.
- Decisao Q13 (TestPyPI primeiro) precisa Hearback explicito antes de nova Onda 6.
