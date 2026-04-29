# HBN Relay — Estado Atual

**Bastao atual:** codex
**Bastao desde:** 2026-04-29T07:35:00Z
**Ultima atualizacao:** 2026-04-29T07:35:00Z

## Iteracoes Ativas

| # | Assunto | Estado | Bastao |
|---|---------|--------|--------|
| 0007 | onda-2-nova-schema-versioning | aguardando-codex-criar-readback | codex |

## Iteracoes Canceladas

| # | Assunto | Razao | Arquivo |
|---|---------|-------|---------|
| 0005 | onda-2-erp-hardening-batch-1 | cancelada-redundante (codigo ja implementado) | `.hbn/relay-archive/20260429T072700Z-0005-onda-2-cancelada-redundante.md` |

## Ultimo Handoff

| Campo | Valor |
|-------|-------|
| De | claude-opus-4.7 (architect) |
| Para | codex |
| Em | 2026-04-29T07:35:00Z |
| Aprovador | humano:luis-mauricio |
| Hearback | "sim aprovado, pode fazer. passe me o que respondo para o codex" (Hearback combinado: aceita revisao do plano + autoriza Codex executar nova Onda 2) |

## Iteracoes Arquivadas Recentemente

- `20260429T073500Z-0006-onda-bastao-claude-revisao-plano-v0.3.0.md` (architect deposit revisado; Ondas 2-4 antigas marcadas JA IMPLEMENTADA; renumeracao 9->6 ondas).
- `20260429T072700Z-0005-onda-2-cancelada-redundante.md` (Onda 2 antiga; cancelada antes de execucao).
- `20260429T071100Z-0004-onda-bastao-claude-wave-plan-v0.3.0.md` (architect deposit do plano canonico; commit `bf8523f`).
- `20260429T065632Z-0003-onda-1-honestidade-narrativa.md` (Onda 1 concluida; commit `43c4c5d`).
- `20260429T0530-0002-onda-bastao-claude-v0.3.0-foundation.md` (architect deposit inicial).

## Pendencias Globais

- **Nova Onda 2 (Schema Versioning) — Codex**: criar Readback inicial em `.hbn/relay/0007-onda-2-schema-versioning.md` declarando o diff planejado. PARAR. Nao executar codigo antes de Hearback humano explicito.
- **Nova Onda 2 — Humano**: apos Codex publicar Readback, dar Hearback explicito ou pedir ajuste.
- **Auditoria pos-execucao**: humano pode invocar `"Claude, auditar nova Onda 2 (Schema Versioning) contra docs/WAVE-PLAN-V0.3.0.md e agents/wave-protocol.md."` apos execucao.
- **RFC-0001** (`--enforce`): aberta em `docs/rfc/RFC-0001-enforce-mode.md`. Sem implementacao em v0.3.0.
- **Decisao Q13** (TestPyPI primeiro): documentada em `docs/PUBLISHING-DECISION.md`. Hearback explicito necessario antes da nova Onda 6 (gate G6).
- **Lico aprendida (architect deve auditar codigo antes de planejar)**: documentada em `docs/WAVE-PLAN-V0.3.0.md` secao "Revisao 2026-04-29". Incorporacao formal em `agents/wave-protocol.md` planejada para nova Onda 5.
- **Observacao menor — CHANGELOG dual-header**: absorvida na nova Onda 5.
- **Observacao menor — README Current Status**: absorvida na nova Onda 5.

## Proxima Acao

`codex` deve:

1. Ler na ordem (obrigatorio):
   - `agents/wave-protocol.md` (contrato de execucao em ondas; secao "Como Codex deve operar especificamente"; especialmente: "Quando Codex detectar sobreposicao significativa entre plano e estado atual do codigo, deve PARAR e pedir Hearback adicional, nao tentar alinhar cosmeticamente.").
   - `docs/WAVE-PLAN-V0.3.0.md` secao "Revisao 2026-04-29" e secao "Onda 2 (NOVA) — Schema Versioning (protocol_version opcional)".
   - `docs/MATURITY-MATRIX.md`.
   - `.hbn/relay-archive/20260429T072700Z-0005-onda-2-cancelada-redundante.md` (entender por que onda anterior foi cancelada).
   - `.hbn/relay-archive/20260429T073500Z-0006-onda-bastao-claude-revisao-plano-v0.3.0.md` (entender contexto da revisao).
   - `src/usehbn/__init__.py` (estado atual).
   - `src/usehbn/protocol/result.py` (estado atual; ver onde inserir `record["protocol_version"]`).
   - `src/usehbn/protocol/readback.py` (estado atual; ver onde inserir `record["protocol_version"]`).
   - `schemas/result.schema.json` e `schemas/readback.schema.json` (estado atual; campo a adicionar em `properties`, NAO em `required`).
   - `tests/test_result_protocol.py` (estado atual; onde adicionar 2 testes).
   - este `INDEX.md`.
2. Criar `.hbn/relay/0007-onda-2-schema-versioning.md` (Readback inicial) com:
   - Bastao: codex; Estado: ativo; created_at em UTC ISO 8601 com sufixo `Z`.
   - Contexto Recebido (citacoes literais de trechos normativos, INCLUINDO o estado atual dos arquivos alvo lidos diretamente).
   - **Verificacao pre-deposit**: confirmar que `protocol_version` AINDA NAO existe em `result.py`, `readback.py`, e nos dois schemas. Se ja existir, PARAR e reportar (mesmo padrao de auditoria que cancelou Onda 2 antiga).
   - O Que Sera Feito (diff planejado por arquivo, com snippets exatos da secao "Onda 2 (NOVA)" do plano).
   - O Que NAO Sera Feito (lista explicita de arquivos proibidos).
   - Riscos R1 (tooling externo), R2 (import circular), R3 (records antigos sem campo).
   - Proximo Passo apos onda.
3. **PARAR**. Nao prosseguir sem Hearback humano explicito.
4. Apos Hearback humano `confirmed`, executar conforme superprompt da nova Onda 2.
5. Devolver bastao para humano com relatorio padrao.

## Leitura Obrigatoria Para Novas IAs

- `agents/wave-protocol.md` (CONTRATO de execucao em ondas).
- `docs/MATURITY-MATRIX.md` (estado canonico por componente).
- `docs/PHAGOCYTOSIS.md` (doutrina do Universal Translator honesto).
- `docs/WAVE-PLAN-V0.3.0.md` (plano canonico revisado de 6 ondas; ler secao "Revisao 2026-04-29" primeiro).
- Lista doutrinaria imutavel em v0.3.0: `Readback`, `Hearback`, `Guardian`, `Truth Barrier`, `ERP`, `Relay`, `Baton`, `Consent`, `Handoff`, `Track`, `Universal Translator`, `Phagocytosis`, `usehbn`, `hbn`, `use hbn`. NAO renomear, NAO traduzir, NAO substituir.
- `usehbn` e `hbn` sao igualmente canonicos (decisao humana Q14). `usehbn` tem prioridade semantica humana.
- Use uma marcacao visivel de status no inicio do ciclo: `✅ HBN ACTIVE`, `❌ HBN SECURITY BLOCKED SUGGESTION` ou `🟡 HBN NEEDS HUMAN DECISION`.
- Em bloqueios ou decisoes humanas, use `hbn notify` quando houver execucao local disponivel.
- Arquivos ativos de coordenacao usam o padrao `0001-Assunto.md`.
- Arquivos resolvidos saem de `.hbn/relay/` e vao para `.hbn/relay-archive/` com prefixo de timestamp.
- Mantenha em `.hbn/relay/` apenas o contexto operacional realmente ativo.
- Codex e cirurgiao, nao arquiteto. Em duvida, PARAR e pedir Hearback. **Quando Codex detectar sobreposicao significativa entre plano e estado atual do codigo, deve PARAR e pedir Hearback adicional, nao tentar alinhar cosmeticamente.**
