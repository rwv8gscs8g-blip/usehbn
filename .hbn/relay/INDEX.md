# HBN Relay — Estado Atual

**Bastao atual:** codex
**Bastao desde:** 2026-04-29T07:11:00Z
**Ultima atualizacao:** 2026-04-29T07:11:00Z

## Iteracoes Ativas

| # | Assunto | Estado | Bastao |
|---|---------|--------|--------|
| 0005 | onda-2-erp-hardening-batch-1 | aguardando-codex-criar-readback | codex |

## Ultimo Handoff

| Campo | Valor |
|-------|-------|
| De | claude-opus-4.7 (architect) |
| Para | codex |
| Em | 2026-04-29T07:11:00Z |
| Aprovador | humano:luis-mauricio |
| Hearback | "1 plano aprovado; 2 ordem das ondas mantida; 3 autorizado para codex executar" |

## Iteracoes Arquivadas Recentemente

- `20260429T071100Z-0004-onda-bastao-claude-wave-plan-v0.3.0.md` (architect deposit do plano canonico de 9 ondas; commit `bf8523f`).
- `20260429T065632Z-0003-onda-1-honestidade-narrativa.md` (Onda 1 concluida; commit `43c4c5d`).
- `20260429T0530-0002-onda-bastao-claude-v0.3.0-foundation.md` (architect deposit inicial; 6 artefatos doutrinarios).

## Pendencias Globais

- **Onda 2 — Codex**: criar Readback inicial em `.hbn/relay/0005-onda-2-erp-hardening-batch-1.md` declarando o diff planejado e PARAR. Nao executar codigo antes de Hearback humano explicito.
- **Onda 2 — Humano**: apos Codex publicar Readback, dar Hearback explicito ou pedir ajuste.
- **Auditoria pos-Onda 2**: humano pode invocar `"Claude, auditar Onda 2 contra docs/WAVE-PLAN-V0.3.0.md e agents/wave-protocol.md."` apos execucao.
- **RFC-0001** (`--enforce`): aberta em `docs/rfc/RFC-0001-enforce-mode.md`. Sem implementacao em v0.3.0.
- **Decisao Q13** (TestPyPI primeiro): documentada em `docs/PUBLISHING-DECISION.md`. Hearback explicito necessario antes da Onda 9 (gate G6).
- **Observacao menor — CHANGELOG dual-header**: absorvida na Onda 8.
- **Observacao menor — README Current Status**: absorvida na Onda 8.

## Proxima Acao

`codex` deve:

1. Ler na ordem (obrigatorio):
   - `agents/wave-protocol.md` (contrato de execucao em ondas).
   - `docs/MATURITY-MATRIX.md`.
   - `docs/WAVE-PLAN-V0.3.0.md` (secao **Onda 2** especificamente).
   - `reports/HBN-ERP-HARDENING-AUDIT.md` (correcoes 2 e 3).
   - `src/usehbn/protocol/result.py` (estado atual).
   - `src/usehbn/state/store.py` (estado atual).
   - `tests/test_result_protocol.py` (estado atual; identificar `test_state_append`).
   - este `INDEX.md`.
2. Criar `.hbn/relay/0005-onda-2-erp-hardening-batch-1.md` (Readback inicial) com:
   - Bastao: codex; Estado: ativo; created_at em UTC ISO 8601 com sufixo `Z`.
   - Contexto Recebido (citacoes literais de trechos normativos).
   - O Que Sera Feito (diff planejado por arquivo, com snippets exatos das linhas a inserir em `result.py` e `store.py`).
   - O Que NAO Sera Feito (lista explicita de arquivos proibidos).
   - Riscos minimos R1 (bloqueio quebra fluxo legitimo), R2 (test legacy depende do bug), R3 (state historico com duplicidade).
   - Proximo Passo apos onda.
3. **PARAR**. Nao prosseguir sem Hearback humano explicito.
4. Apos Hearback humano `confirmed`, executar passos 2-6 do superprompt e gravar ERP.
5. Devolver bastao para humano com:
   - Lista de arquivos modificados.
   - Resultado de `pytest -q` antes e depois.
   - Resultado de `git diff --stat`.
   - Resultado do grep doutrinario.
   - `execution_id` e `readback_id` do ERP.

## Leitura Obrigatoria Para Novas IAs

- `agents/wave-protocol.md` (CONTRATO de execucao em ondas).
- `docs/MATURITY-MATRIX.md` (estado canonico por componente).
- `docs/PHAGOCYTOSIS.md` (doutrina do Universal Translator honesto).
- `docs/WAVE-PLAN-V0.3.0.md` (plano canonico das 9 ondas do ciclo).
- Lista doutrinaria imutavel em v0.3.0: `Readback`, `Hearback`, `Guardian`, `Truth Barrier`, `ERP`, `Relay`, `Baton`, `Consent`, `Handoff`, `Track`, `Universal Translator`, `Phagocytosis`, `usehbn`, `hbn`, `use hbn`. NAO renomear, NAO traduzir, NAO substituir.
- `usehbn` e `hbn` sao igualmente canonicos (decisao humana Q14). `usehbn` tem prioridade semantica humana.
- Use uma marcacao visivel de status no inicio do ciclo: `✅ HBN ACTIVE`, `❌ HBN SECURITY BLOCKED SUGGESTION` ou `🟡 HBN NEEDS HUMAN DECISION`.
- Em bloqueios ou decisoes humanas, use `hbn notify` quando houver execucao local disponivel.
- Arquivos ativos de coordenacao usam o padrao `0001-Assunto.md`.
- Arquivos resolvidos saem de `.hbn/relay/` e vao para `.hbn/relay-archive/` com prefixo de timestamp.
- Mantenha em `.hbn/relay/` apenas o contexto operacional realmente ativo.
- Codex e cirurgiao, nao arquiteto. Em duvida, PARAR e pedir Hearback.
