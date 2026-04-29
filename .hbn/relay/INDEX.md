# HBN Relay — Estado Atual

**Bastao atual:** codex
**Bastao desde:** 2026-04-29T06:34:00Z
**Ultima atualizacao:** 2026-04-29T06:34:00Z

## Iteracoes Ativas

| # | Assunto | Estado | Bastao |
|---|---------|--------|--------|
| 0003 | onda-1-honestidade-narrativa | aguardando-readback-do-codex | codex |

## Ultimo Handoff

| Campo | Valor |
|-------|-------|
| De | claude-opus-4.7 (architect) |
| Para | codex |
| Em | 2026-04-29T06:34:00Z |
| Aprovador | humano:luis-mauricio |
| Hearback | confirmado para iteracao 0002 (architect deposit) e Onda 1 |

## Iteracoes Arquivadas Recentemente

- `20260429T0530-0002-onda-bastao-claude-v0.3.0-foundation.md` (architect deposit concluido; 6 artefatos doutrinarios depositados sem tocar em codigo).

## Pendencias Globais

- **Onda 1 — Codex**: criar Readback `.hbn/relay/0003-onda-1-honestidade-narrativa.md`, parar, aguardar Hearback humano sobre o plano de diff, executar conforme superprompt, gravar ERP, devolver bastao para `humano`.
- **RFC-0001** (`--enforce`): aberta em `docs/rfc/RFC-0001-enforce-mode.md` para janela de comentarios humanos. Implementacao apenas em v0.4.0.
- **Decisao Q13** (TestPyPI primeiro): documentada em `docs/PUBLISHING-DECISION.md`. Hearback explicito necessario antes de cada gate G6.

## Proxima Acao

`codex` deve:
1. Ler `agents/wave-protocol.md` e os arquivos da `Lista de Leitura Obrigatoria` do superprompt da Onda 1.
2. Criar `.hbn/relay/0003-onda-1-honestidade-narrativa.md` (Readback inicial).
3. PARAR. Aguardar Hearback humano explicito sobre o diff planejado.
4. Apos Hearback `confirmed`: executar Passos 2-5 do superprompt.
5. NAO fazer commit, NAO fazer push, NAO abrir PR.
6. Devolver bastao para `humano` no fim.

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
