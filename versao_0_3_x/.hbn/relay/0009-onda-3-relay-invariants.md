# 0009 — Nova Onda 3: Relay Invariants em Runtime
**Bastão:** codex
**Estado:** ativo
**Criado:** 2026-04-29T10:07:24Z
**readback_id:** readback-0009-onda-3-relay-invariants
**track:** safe_track
**hearback_status:** pending

## Contexto Recebido

Humano autorizou: "Codex, executar Nova Onda 3 conforme `.hbn/relay/0008-architect-correcao-onda3.md` e `docs/WAVE-PLAN-V0.3.0.md` secao 'Onda 3 (NOVA) — Relay Invariants em Runtime'. Crie Readback 0009. Pare apos Passo 2 e aguarde Hearback antes de implementar."

Leitura obrigatória realizada:

- `agents/wave-protocol.md`: "Readback antes de qualquer alteracao"; "Hearback humano antes de cada onda"; "Codex e cirurgiao, nao arquiteto."; "Se em qualquer momento ha tentacao de refatorar codigo \"para consistencia\", pausar e pedir Hearback humano."
- `docs/MATURITY-MATRIX.md`: Relay está `Parcial`, com risco "Convencoes nao validadas em runtime"; Baton está `Parcial`, com risco "Sem timeout, sem audit trail completo."
- `docs/WAVE-PLAN-V0.3.0.md`: "Promover Relay/Baton de Parcial para \"Implementado parcial honesto\", endurecendo tres invariantes em runtime"; "(a) Path mismatch fix"; "(b) Audit trail das transicoes"; "(c) Baton staleness check (advisory, default off)".
- `.hbn/relay/0008-architect-correcao-onda3.md`: "Sem correcao, Codex pararia corretamente no Passo 1 do superprompt ao tentar abrir `src/usehbn/relay/*.py`."; "Toda a logica vive em `src/usehbn/cli.py`"; "`run_handoff` **nunca** vai detectar readback pendente criado pelo fluxo padrao do CLI HBN."
- `.hbn/relay/INDEX.md`: está em estado de transição do architect para esta onda; antes deste Readback ainda mostra `0008 | architect-correcao-onda3 | aguardando-hearback-humano | claude-opus-4.7`. A mensagem humana atual funciona como autorização para criar o Readback 0009, mas não vou atualizar `INDEX.md` antes do Hearback de implementação.
- `tests/test_relay.py:341-425`: `test_two_agent_handoff_cycle` copia manualmente `.usehbn/readbacks/exec-cycle-001.json` para `.hbn/readbacks/exec-cycle-001.json` para o handoff falhar. Esse hack confirma o path mismatch.

## Verificação pre-deposit (G2)

Comandos executados:

```bash
grep -nE "audit_trail|baton_staleness_seconds|baton_stale" src/usehbn/cli.py || true
grep -n "default_state_dir" src/usehbn/protocol/readback.py
```

Resultado:

- `audit_trail`, `baton_staleness_seconds` e `baton_stale`: zero matches em `src/usehbn/cli.py`.
- `src/usehbn/protocol/readback.py:14`: `from usehbn.utils.config import default_state_dir`.
- `src/usehbn/protocol/readback.py:25`: `readbacks_dir = default_state_dir(storage_dir) / READBACKS_DIRNAME`.

Os achados do deposit 0008 se sustentam no código atual. Não há sobreposição significativa detectada; a onda pode seguir após Hearback humano.

## Understanding

Esta onda corrige o path mismatch que faz o Handoff ignorar Readback pendente criado no fluxo padrão `.usehbn/readbacks/`, adiciona `audit_trail` de últimas transições no state do Relay e adiciona `baton_stale` advisory quando `baton_staleness_seconds` estiver configurado. Tudo fica restrito a `src/usehbn/cli.py` e `tests/test_relay.py`, sem criar módulo novo, sem tocar `protocol/`, sem tocar schemas, sem alterar superfície pública da CLI.

## Invariants Preserved

- doutrina HBN
- CLI publica
- schemas
- engine.py
- protocol/
- default_state_dir
- termos doutrinários imutáveis
- ausência de novos subcomandos CLI

## Action Plan

1. Adicionar `test_handoff_blocks_on_pending_usehbn_readback`: Readback pending em `.usehbn/readbacks/` deve bloquear `run_handoff` diretamente.
2. Adicionar `test_find_pending_readbacks_dedups_when_present_in_both_dirs`: mesmo `execution_id` em `.hbn/readbacks/` e `.usehbn/readbacks/` deve aparecer uma vez.
3. Adicionar `test_handoff_audit_trail_preserves_last_ten`: 12 handoffs deixam `audit_trail` com exatamente 10 entradas, preservando a mais recente no fim.
4. Adicionar `test_handoff_audit_trail_backward_compatible`: state sem `audit_trail` deve aceitar handoff e escrever uma entrada.
5. Adicionar `test_relay_status_baton_stale_flag_when_configured`: `baton_staleness_seconds=0` deve produzir `baton_stale: true`.
6. Adicionar `test_relay_status_no_baton_stale_field_by_default`: sem configuração, `baton_stale` não aparece.
7. Ajustar `test_two_agent_handoff_cycle` removendo o copy manual `.usehbn -> .hbn`, com comentário explicando que o dual-read tornou o hack desnecessário.

## O Que Será Feito

Após Hearback humano explícito, o diff planejado é:

- `src/usehbn/cli.py`
  - Alterar somente `_load_relay_state`, `_save_relay_state`, `_find_pending_readbacks`, `run_relay_status` e `run_handoff`.
  - `_find_pending_readbacks(target)` lerá ambos `.hbn/readbacks/` e `default_state_dir(target) / "readbacks"`, deduplicando por `execution_id` e preferindo entrada com `hearback_status == "pending"`.
  - `_load_relay_state(target)` tolerará ausência de `audit_trail` e levantará `ValueError` se `audit_trail` existir com tipo inválido.
  - `_save_relay_state(target, state)` garantirá `audit_trail` como lista compatível e manterá no máximo 10 entradas.
  - `run_handoff(args)` adicionará entrada `{from, to, at, summary}` ao `audit_trail` antes de salvar o state.
  - `run_relay_status(args)` adicionará `baton_stale` somente quando `baton_staleness_seconds` for `int > 0` ou conforme plano/teste para `0` como always-stale; caso não configurado, não adicionará o campo.

- `tests/test_relay.py`
  - Adicionar os 6 testes novos listados no Action Plan.
  - Ajustar `test_two_agent_handoff_cycle` para remover o hack de cópia manual entre `.usehbn/readbacks/` e `.hbn/readbacks/`.

Arquivos de coordenação:

- `.hbn/relay/0009-onda-3-relay-invariants.md` permanece ativo até Hearback final.
- `.hbn/relay/INDEX.md` só será atualizado no fechamento da onda, se a implementação for aprovada por testes e ERP.

## O Que NÃO Será Feito

- Não criar `src/usehbn/relay/` ou qualquer novo módulo.
- Não tocar `src/usehbn/protocol/`.
- Não tocar `src/usehbn/execution/engine.py`.
- Não tocar `schemas/`.
- Não adicionar novos subcomandos CLI.
- Não renomear funções, parâmetros, classes ou termos doutrinários.
- Não mover código de Relay para fora de `src/usehbn/cli.py`.
- Não tocar `pyproject.toml`, `setup.cfg`, `get-hbn`, `core/`, `docs/`, `.github/` ou `reports/`.
- Não fazer commit, push, PR ou release.

## Residual Risks

- **R1:** dual-read pode introduzir duplicidade real se o mesmo Readback existir nos dois diretórios. Mitigação: dedup por `execution_id`, preferindo `pending`, com teste dedicado.
- **R2:** leitura tolerante de `audit_trail` ausente pode mascarar state corrompido. Mitigação: ausência é compatível, tipo inválido levanta erro.
- **R3:** mudança em `_find_pending_readbacks` pode alterar comportamento do `test_two_agent_handoff_cycle`. Mitigação: ajustar explicitamente o teste integrado; se aparecer quebra não prevista, parar e pedir Hearback.
- **R4:** campos novos em `state.json` podem impactar runtimes externos que consomem JSON por exact-match. Mitigação: adicionar campos sem remover/renomear existentes; `baton_stale` só aparece quando configurado.

## Próximo Passo

PARAR aqui. Aguardar Hearback humano explícito antes de implementar Passo 3. Após Hearback, executar baseline, alterar apenas `src/usehbn/cli.py` e `tests/test_relay.py`, rodar testes, gravar ERP, atualizar relay, devolver bastão para humano e aguardar Hearback final.
