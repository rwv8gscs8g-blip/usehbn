# HBN Knowledge Base

Indice vivo das licoes reutilizaveis entre IAs. Este arquivo e ponteiro:
liste a entrada e o uso; nao replique o conteudo da knowledge.

| Entrada | Status | Temperatura | Uso |
|---|---|---|---|
| `0001-comandos-atomicos-copiaveis.md` | accepted | quente | Comandos ao humano em blocos atomicos, copiaveis e sem comentarios inline. |
| `0002-entrega-operacional-minimalista.md` | accepted | quente | Entrega ao operador com comando unico, expectativa e fallback. |
| `0003-git-sandbox-sem-lock.md` | accepted | quente | Leitura git em sandbox sem criar `index.lock` no repo canonico. |
| `0019-severidades-veto.md` | accepted | quente | Severidades de auditoria, veto por BLOQUEADOR e checklist anti-vies. |
| `0022-firewall-workflow-fast-track.md` | accepted | quente | Firewall de escrita: workflows fast_track e dominio safe_track humano-aplicado. |
| `0023-area-temporaria-e-fixtures-efemeras.md` | accepted | quente | Fixtures efemeras fora de paths governados; usar tmp da sessao ou area temporaria oficial protegida. |
| `0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md` | accepted | quente | Zona livre nao entra em commit/selagem sem aprovacao humana explicita por arquivo. |
| `0025-auditor-read-only-sem-no-verify.md` | accepted | quente | Auditor cruzado fica read-only; commit de fixture com --no-verify so em branch descartavel e limpa. |
| `0026-auto-id-auditor-gate-enforcado.md` | accepted | quente | Auto-ID e familia do auditor viram gate enforcado antes de contar parecer na diversidade. |
| `0027-trailers-contiguos-independente-de-excecao.md` | accepted | quente | G-TRAILERS exige os 3 trailers HBN contiguos em todo commit governado, independente de implementador no STATE. |
| `distribution-model.md` | decisao atual | — | Distribuicao fase 2, bootstrap local e adapters de runtime. |
| `relay-protocol.md` | decisao atual | — | Continuidade de bastao e uso dos arquivos de relay. |
| `runtime-command-model.md` | decisao atual | — | `hbn` como CLI operacional primario e `usehbn` como compatibilidade. |

## Convencoes

- Nomeie arquivos numerados como `0001-assunto.md`, `0002-assunto.md` e assim por diante.
- Registre apenas descobertas reutilizaveis entre IAs.
- Nao use a knowledge base para historico operacional de curto prazo.
- Toda entrada `.hbn/knowledge/*.md`, exceto este `INDEX.md`, deve aparecer citada aqui.
