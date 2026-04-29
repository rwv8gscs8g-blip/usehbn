# HBN Relay — Estado Atual

**Bastao atual:** humano
**Bastao desde:** 2026-04-29T06:47:39Z
**Ultima atualizacao:** 2026-04-29T06:56:32Z

## Iteracoes Ativas

| # | Assunto | Estado | Bastao |
|---|---------|--------|--------|
| — | nenhuma | aguardando-decisao-humana | humano |

## Ultimo Handoff

| Campo | Valor |
|-------|-------|
| De | codex |
| Para | humano |
| Em | 2026-04-29T06:56:32Z |
| Aprovador | humano:luis-mauricio |
| Hearback | final confirmado para Onda 1 (`exec-20260429T064721Z-onda1`) |

## Iteracoes Arquivadas Recentemente

- `20260429T065632Z-0003-onda-1-honestidade-narrativa.md` (Onda 1 concluida; honestidade narrativa alinhada a `docs/MATURITY-MATRIX.md`; ERP `exec-20260429T064721Z-onda1`).
- `20260429T0530-0002-onda-bastao-claude-v0.3.0-foundation.md` (architect deposit concluido; 6 artefatos doutrinarios depositados sem tocar em codigo).

## Pendencias Globais

- **Onda 2 — Humano**: decidir se a proxima onda inicia agora ou fica pausada.
- **Observacao menor — CHANGELOG dual-header**: decidir se a estrutura `## Unreleased` + `## [Unreleased] — Onda 1` deve ser ajustada em onda futura.
- **Observacao menor — README Current Status**: decidir se o texto de status atual deve ser atualizado em onda futura para eliminar referencias residuais ao track `0.2.x`/`v0.3`.
- **RFC-0001** (`--enforce`): aberta em `docs/rfc/RFC-0001-enforce-mode.md` para janela de comentarios humanos. Implementacao apenas em v0.4.0.
- **Decisao Q13** (TestPyPI primeiro): documentada em `docs/PUBLISHING-DECISION.md`. Hearback explicito necessario antes de cada gate G6.

## Proxima Acao

`humano` mantem o bastao e decide:
1. Se abre Onda 2.
2. Se cria onda pequena para as observacoes CHANGELOG dual-header e README Current Status.
3. Se pausa o ciclo.

## Leitura Obrigatoria Para Novas IAs

- `agents/wave-protocol.md` (CONTRATO de execucao em ondas).
- `docs/MATURITY-MATRIX.md` (estado canonico por componente).
- `docs/PHAGOCYTOSIS.md` (doutrina do Universal Translator honesto).
- Lista doutrinaria imutavel em v0.3.0: `Readback`, `Hearback`, `Guardian`, `Truth Barrier`, `ERP`, `Relay`, `Baton`, `Consent`, `Handoff`, `Track`, `Universal Translator`, `Phagocytosis`, `usehbn`, `hbn`, `use hbn`. NAO renomear, NAO traduzir, NAO substituir.
- `usehbn` e `hbn` sao igualmente canonicos (decisao humana Q14). `usehbn` tem prioridade semantica humana.
- Use uma marcacao visivel de status no inicio do ciclo: `✅ HBN ACTIVE`, `❌ HBN SECURITY BLOCKED SUGGESTION` ou `🟡 HBN NEEDS HUMAN DECISION`.
- Em bloqueios ou decisoes humanas, use `hbn notify` quando houver execucao local disponivel.
- Arquivos ativos de coordenacao usam o padrao `0001-Assunto.md`.
- Arquivos resolvidos saem de `.hbn/relay/` e vao para `.hbn/relay-archive/` com prefixo de timestamp.
- Mantenha em `.hbn/relay/` apenas o contexto operacional realmente ativo.
