# HBN Relay — Estado Atual

**Bastao atual:** humano
**Bastao desde:** 2026-04-29T07:50:13Z
**Ultima atualizacao:** 2026-04-29T08:05:02Z

## Iteracoes Ativas

| # | Assunto | Estado | Bastao |
|---|---------|--------|--------|
| — | nenhuma | aguardando-decisao-humana | humano |

## Iteracoes Canceladas

| # | Assunto | Razao | Arquivo |
|---|---------|-------|---------|
| 0005 | onda-2-erp-hardening-batch-1 | cancelada-redundante (codigo ja implementado) | `.hbn/relay-archive/20260429T072700Z-0005-onda-2-cancelada-redundante.md` |

## Ultimo Handoff

| Campo | Valor |
|-------|-------|
| De | codex |
| Para | humano |
| Em | 2026-04-29T08:05:02Z |
| Aprovador | humano:luis-mauricio |
| Hearback | final confirmado para Nova Onda 2 (`exec-20260429T075001Z-onda2-schema`) |

## Iteracoes Arquivadas Recentemente

- `20260429T080502Z-0007-onda-2-schema-versioning.md` (Nova Onda 2 concluida; `protocol_version` opcional em Readback e Result; ERP `exec-20260429T075001Z-onda2-schema`).
- `20260429T073500Z-0006-onda-bastao-claude-revisao-plano-v0.3.0.md` (architect deposit revisado; Ondas 2-4 antigas marcadas JA IMPLEMENTADA; renumeracao 9->6 ondas).
- `20260429T072700Z-0005-onda-2-cancelada-redundante.md` (Onda 2 antiga; cancelada antes de execucao).
- `20260429T071100Z-0004-onda-bastao-claude-wave-plan-v0.3.0.md` (architect deposit do plano canonico; commit `bf8523f`).
- `20260429T065632Z-0003-onda-1-honestidade-narrativa.md` (Onda 1 concluida; commit `43c4c5d`).
- `20260429T0530-0002-onda-bastao-claude-v0.3.0-foundation.md` (architect deposit inicial).

## Pendencias Globais

- **Nova Onda 3 — Humano**: decidir quando iniciar Relay Invariants em Runtime.
- **Auditoria pos-execucao**: humano pode invocar `"Claude, auditar nova Onda 2 (Schema Versioning) contra docs/WAVE-PLAN-V0.3.0.md e agents/wave-protocol.md."` apos execucao.
- **RFC-0001** (`--enforce`): aberta em `docs/rfc/RFC-0001-enforce-mode.md`. Sem implementacao em v0.3.0.
- **Decisao Q13** (TestPyPI primeiro): documentada em `docs/PUBLISHING-DECISION.md`. Hearback explicito necessario antes da nova Onda 6 (gate G6).
- **Lico aprendida (architect deve auditar codigo antes de planejar)**: documentada em `docs/WAVE-PLAN-V0.3.0.md` secao "Revisao 2026-04-29". Incorporacao formal em `agents/wave-protocol.md` planejada para nova Onda 5.
- **Observacao menor — CHANGELOG dual-header**: absorvida na nova Onda 5.
- **Observacao menor — README Current Status**: absorvida na nova Onda 5.

## Proxima Acao

`humano` deve decidir a proxima acao:

1. Abrir nova Onda 3 — Relay Invariants em Runtime.
2. Pausar o ciclo.
3. Solicitar auditoria adicional da Nova Onda 2.

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
