# PROPOSTA — dedup da Maturity Matrix duplicada (não-normativo até aplicado)

> Zona livre / untracked (knowledge 0024). Proposta de curadoria P0 a ser
> promovida por onda formal. Truth Barrier: cada ponteiro citado abaixo foi
> verificado por `grep -rn 'MATURITY-MATRIX' .` no disco.

## O problema (verificado no disco)

Existem **dois** arquivos de Maturity Matrix:

1. `methodology/MATURITY-MATRIX.md` — **fonte única canônica**. AGENTS.md:17,
   README.md:40 e `site/index.html:76` apontam para cá; ela carrega o estado
   vigente pós-Ondas (Relay/Baton "Parcial honesto", Connectors lifecycle
   "Scaffold", autoevolve orchestrator "Scaffold", etc.). Confirmado
   `methodology/MATURITY-MATRIX.md:1-6` (cabeçalho "Tabela viva… normativo").

2. `docs/MATURITY-MATRIX.md` — **duplicata marcada SUPERSEDED** (banner em
   `docs/MATURITY-MATRIX.md:3-17`), porém **ainda contém o conteúdo stale
   completo** abaixo do banner (a tabela inteira em estado v0.3.0
   pre-Onda-3/4/5). Esse conteúdo duplicado pode ser lido por engano por uma IA
   ou humano que abra o arquivo e role além do banner.

## Ação EXATA recomendada para `docs/MATURITY-MATRIX.md`

**Reduzir o arquivo a um stub de redirecionamento de 2-3 linhas**, removendo todo
o conteúdo stale duplicado, mas **preservando o arquivo** (não deletar — para não
quebrar ponteiros históricos que apontam para ele, P7/P1). Texto proposto integral
do arquivo após a faxina:

```
# HBN — Maturity Matrix (SUPERSEDED)

> **SUPERSEDED desde 2026-05-10. Fonte única: [`methodology/MATURITY-MATRIX.md`](../methodology/MATURITY-MATRIX.md).**
> Conteúdo stale removido na curadoria P0 de 2026-06-17 (mantinha tabela em estado pré-Ondas, risco de leitura por engano).
> Arquivo preservado apenas como redirect para não quebrar ponteiros históricos (P7). Não há estado de componente aqui — leia a fonte canônica.
```

Justificativa: o banner atual (`docs/MATURITY-MATRIX.md:3-17`) já declara
SUPERSEDED e manda apontar para `methodology/`, mas o conteúdo stale logo abaixo
(`docs/MATURITY-MATRIX.md:19` em diante) contradiz a própria intenção do banner —
a regra "toda comunicação aponta para methodology/" só fica segura quando a
tabela duplicada deixa de existir no arquivo.

## Outros ponteiros no repo que apontam para `docs/MATURITY-MATRIX.md` (grep)

Ponteiros **vivos** (docs ativos/runtime) que precisam ser corrigidos para
`methodology/MATURITY-MATRIX.md` na mesma onda, senão continuam levando leitores
ao arquivo esvaziado / ao caminho errado:

| Arquivo:linha | Trecho | Ação |
|---|---|---|
| `docs/PHAGOCYTOSIS.md:32` | "visivel em `docs/MATURITY-MATRIX.md`" | trocar por `methodology/MATURITY-MATRIX.md` |
| `docs/PHAGOCYTOSIS.md:58` | "Linha na tabela `docs/MATURITY-MATRIX.md`" | idem |
| `docs/PHAGOCYTOSIS.md:190` | "atualiza `docs/MATURITY-MATRIX.md`" | idem |
| `docs/PHAGOCYTOSIS.md:218` | "Estado canonico \| `docs/MATURITY-MATRIX.md`" | idem |
| `docs/RUNTIME-ADAPTERS.md:6` | "`docs/MATURITY-MATRIX.md`" | idem |
| `docs/ARCHITECTURE.md:38` | "governed by `docs/MATURITY-MATRIX.md`" | idem |
| `docs/ARCHITECTURE.md:70` | "These limits follow `docs/MATURITY-MATRIX.md`" | idem |
| `docs/WAVE-PLAN-V0.3.0.md:74,352,612,794,818,898` | múltiplas refs a `docs/MATURITY-MATRIX.md` | idem (ou marcar wave-plan como histórico) |
| `docs/PROPOSAL-V0.4.0.md:94-95` | já edita `methodology/...` mas comentário cita matriz | revisar texto |

Ponteiros **históricos/imutáveis** que NÃO devem ser editados (são registro
append-only ou prompts datados — corrigi-los reescreveria história):
`CHANGELOG.md:159`, `auditoria/00_status/04_PROMPT_ANTIGRAVITY_CROSS_IA_REVIEW.md:91`,
`auditoria/00_status/05_CONSOLIDACAO_CROSS_IA_ADRS_2026_05_10.md:202`,
`auditoria/post-implementation/v0.3.0-validation.md:57`,
`PROMPT_EVOLUCAO_PROTOCOLO_FABLE5.md:33`, e os arquivos sob
`docs/brainstorm/**` e `.hbn/results/**` (zona livre / pareceres datados). Estes
permanecem como estão; o stub de redirect em `docs/MATURITY-MATRIX.md` garante que,
mesmo seguidos, levem o leitor ao redirect e não a dados stale.

## Nota de rastreabilidade

Ao aplicar (em onda própria): a redução do `docs/MATURITY-MATRIX.md` a stub e a
correção dos ponteiros vivos geram uma linha no `REGISTRY.md` (mudança de
temperatura do artefato `docs/MATURITY-MATRIX.md` → frio/redirect), per ADR-011.
