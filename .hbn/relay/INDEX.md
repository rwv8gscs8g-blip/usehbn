# HBN Relay — Estado Atual

**Bastao atual:** claude-opus-4.7 (architect)
**Bastao desde:** 2026-04-29T07:00:00Z
**Ultima atualizacao:** 2026-04-29T07:00:00Z

## Iteracoes Ativas

| # | Assunto | Estado | Bastao |
|---|---------|--------|--------|
| 0004 | onda-bastao-claude-wave-plan-v0.3.0 | ativo-aguardando-hearback-humano | claude-opus-4.7 |

## Ultimo Handoff

| Campo | Valor |
|-------|-------|
| De | humano |
| Para | claude-opus-4.7 |
| Em | 2026-04-29T07:00:00Z |
| Aprovador | humano:luis-mauricio |
| Hearback | "Quer seguir com as proximas ondas e ao final do ciclo atualizar o github" |

## Iteracoes Arquivadas Recentemente

- `20260429T065632Z-0003-onda-1-honestidade-narrativa.md` (Onda 1 concluida; honestidade narrativa alinhada a `docs/MATURITY-MATRIX.md`; commit `43c4c5d`).
- `20260429T0530-0002-onda-bastao-claude-v0.3.0-foundation.md` (architect deposit inicial concluido; 6 artefatos doutrinarios depositados).

## Pendencias Globais

- **Iteracao 0004 — Humano**: dar Hearback sobre `docs/WAVE-PLAN-V0.3.0.md` (plano canonico das 9 ondas do ciclo v0.3.0).
- **Onda 2 — Humano**: apos Hearback sobre o plano, autorizar passagem do bastao ao Codex para executar ERP Hardening Batch 1 (P0 Data Integrity).
- **RFC-0001** (`--enforce`): aberta em `docs/rfc/RFC-0001-enforce-mode.md`. Sem implementacao em v0.3.0.
- **Decisao Q13** (TestPyPI primeiro): documentada em `docs/PUBLISHING-DECISION.md`. Hearback explicito necessario antes da Onda 9 (gate G6).
- **Observacao menor — CHANGELOG dual-header**: absorvida na Onda 8.
- **Observacao menor — README Current Status**: absorvida na Onda 8.

## Proxima Acao

`humano` deve revisar a iteracao 0004:
1. Conferir `docs/WAVE-PLAN-V0.3.0.md` — ordem das 9 ondas, escopo de cada onda, gates aplicaveis.
2. Conferir `.hbn/relay/0004-onda-bastao-claude-wave-plan-v0.3.0.md` — Readback do architect deposit.
3. Decidir Hearback:
   - **Aprovacao integral** -> autorizar passagem do bastao ao Codex para Onda 2.
   - **Aprovacao parcial** -> indicar quais ondas reordenar/ajustar.
   - **Rejeicao** -> reverter o deposito.
4. Apos Hearback explicito sobre Onda 2, este arquivo sera atualizado para registrar bastao com `codex` e iteracao ativa `0005`.

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
