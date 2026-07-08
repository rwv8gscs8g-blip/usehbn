---
titulo: "Codex — cross-audit da proposta árvores leve + fechamento MVP"
tipo: result
status: congelado
temperatura: glacier
id-global: 20260616-153723-codex-cross-ia-proposta-arvores-mvp
path: .hbn/results/20260616-153723-codex-cross-ia-proposta-arvores-mvp.md
autor: codex
created_at: "2026-06-16T15:37:23-03:00"
---

APROVA_PROPOSTA: NAO + ajustes objetivos

# Auditoria Codex - proposta arvores leve + fechamento MVP

Auditor: codex (OpenAI)  
Data: 2026-06-16T15:37:23-03:00  
Escopo: design review, sem implementacao.  
Confianca: 86/100.

## Evidencia de contexto

- Branch/tip conferidos: `git rev-parse --abbrev-ref HEAD -> proposta/reestruturacao-m-a-s0`; `git rev-parse --short HEAD -> 2d4ad86`; `git rev-parse --short main -> 4db6928`.
- Worktree nao estava limpo antes desta auditoria: `git status --short --branch -> ?? .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md; ?? .hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md; ?? .hbn/results/20260616-153302-antigravity-cross-ia-proposta-arvores-mvp.md`.
- A proposta auditada se declara nao normativa e sem alterar guard/core/roadmap por si so (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:15-16`).

## 1. Arvores: paths obrigatorios e guards .sh

Recomendacao: manter `arvore:` obrigatorio, nesta onda leve, apenas para artefatos Markdown/JSON com metadado estruturado e que sejam NOVOS ou TOCADOS nos caminhos de governanca: `core/*.md`, `methodology/**/*.md`, `.hbn/knowledge/*.md`, `.hbn/proposals/*.md`, `.hbn/results/*.md`, `.hbn/messages/*.md` e `docs/brainstorm/*.md`. Nao fazer retrofit em massa. Nao exigir `# arvore:` em `guards/*.sh` nesta onda; isso cria um segundo parser e uma segunda fonte de verdade. Para guards, a arvore deve ser inferida do mecanismo/spec que o guard implementa ate uma futura onda de proveniencia de guard.

Evidencia: a proposta limita a obrigatoriedade nova a `core/**` e `docs/brainstorm/**` (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:42-46`), mas o proprio repo define o nucleo de governanca como `.hbn/`, `core/`, `guards/`, `REGISTRY.md` e `methodology/` (`docs/brainstorm/exuvia-evolucao-conceitual.md:91-97`; `docs/brainstorm/EXPLICACAO-PUBLICA-usehbn-DRAFT.md:157-166`). Tambem ha contradicao interna: a proposta diz que docs novos em `docs/brainstorm/**` sem `arvore:` bloqueiam (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:44`), mas logo em seguida diz que `docs/brainstorm/**` sem campo assume `fronteira` por padrao (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:45`).

Viabilidade Codex: o guard e pequeno porque ja existe `guard_diff_files()` para staged local e range CI (`guards/lib/common.sh:240-248`). O cuidado e parsear apenas front matter delimitado por `---`, como `validate-dispatch` faz (`guards/validate-dispatch.sh:218-236`), e nao usar grep solto no arquivo inteiro.

## 2. Transicao entre arvores

Recomendacao: o gate ainda nao esta objetivo o suficiente. Definir na spec:

- `fronteira -> intermediaria`: aprovacao humana + cross-audit de familia distinta + C-TEST/C-ADV/C-XAUDIT/C-FCLOSE/C-NOREG/C-TRACE e C-DEBT registrado; C-DOG quando aplicavel a mecanismo executavel.
- `intermediaria -> estavel`: todos os criterios acima + historico minimo sem regressao com numero definido, ou remocao explicita do requisito temporal.
- Artefatos nao executaveis precisam criterio proprio de "promocao documental", porque os 8 criterios sao descritos para mecanismos como guard/regra/schema (`core/exuvia-fitness-criteria.md:47-55`, `core/exuvia-fitness-criteria.md:75-96`).

Evidencia: a proposta atual so diz "cross-audit + aprovacao humana" para promocao (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:41`). O brainstorm que originou a ideia ainda formula isso como pergunta: "reusar os 5 estagios da fagocitose + os 8 criterios + o Fitness Gate?" (`docs/brainstorm/exuvia-evolucao-conceitual.md:99-102`). Outra entrada sugere `>=N dias sem regressao`, mas nao define N (`docs/brainstorm/exuvia-evolucao-conceitual.md:121-123`).

## 3. MVP freeze e bloqueadores da Ponte

Recomendacao: a lista 1-6 nao esta completa nem fiel ao disco. Antes de freeze/tag, corrigir:

1. P-CAND-04 precisa ser realmente selado, nao apenas entregue.
2. Deny-by-default precisa virar readback/guard/teste, porque hoje e conhecimento candidato nao versionado.
3. Hardening conhecido deve entrar antes do freeze: G-KNOW substring/ponteiro-morto, G-FRONTDOOR teto por bytes/existencia de paths, G-EXC ultimo bloco de trailers.
4. Bloqueadores da Ponte precisam ser remediados ou explicitamente aceitos por hearback antes da tag, nao depois.

Evidencia P-CAND-04: a proposta chama P-CAND-04 de selado (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:66`), mas o readback 0033 ainda esta `status: in_progress` (`.hbn/readbacks/0033-area-temporaria-scratch.json:6-9`), o handoff diz `PENDENTE: cross-audit P-CAND-04` (`.hbn/messages/20260616-170500-codex-handoff-p-cand-04.md:13-18`) e o STATE diz que a proxima acao e cross-audit P-CAND-04 (`.hbn/relay/STATE.md:14-19`, `.hbn/relay/STATE.md:52-56`).

Evidencia deny-by-default: a proposta chama o item de selado e aponta `knowledge 0024` (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:67`), mas `knowledge 0024` aparece untracked no status citado acima e nao esta no INDEX vivo (`.hbn/knowledge/INDEX.md:6-16`). O proprio STATE ainda trata "bloqueio total deny-by-default da zona livre" como proxima acao futura (`.hbn/relay/STATE.md:14-19`, `.hbn/relay/STATE.md:56`).

Bloqueadores 0034/0035 da Ponte:

- 0034 Codex: B-01, conta e criterio `SO-COPIA=0` inseguros apos R8 (`.hbn/results/0034-cross-ia-codex-ponte.md:67-81`); B-02, split do firewall 0022 sem corpo/patch auditavel (`.hbn/results/0034-cross-ia-codex-ponte.md:83-89`); fortes adicionais em T3, claim "so fetch" e R8/rollback (`.hbn/results/0034-cross-ia-codex-ponte.md:93-115`).
- 0035 Antigravity: F-01, guard de snapshot com path absoluto `~/Projetos/usehbn/bin/usehbn-verify.sh` quebrando CI (`.hbn/results/0035-cross-ia-antigravity-ponte.md:83-87`); F-02, split do firewall sem texto explicito (`.hbn/results/0035-cross-ia-antigravity-ponte.md:89-93`); F-03, R8 colide com forbidden-paths/pre-commit (`.hbn/results/0035-cross-ia-antigravity-ponte.md:95-99`); F-04/F-06, conta e delecao total do snapshot (`.hbn/results/0035-cross-ia-antigravity-ponte.md:101-117`).

## 4. Deny-by-default

Recomendacao: o mecanismo mais simples e robusto e uma extensao de `assert-scope-lock`, nao uma blacklist nova. Regra proposta: se `scope.files_allowed` contem `docs/brainstorm/**` ou qualquer path de `docs/brainstorm/`, o readback deve ter um campo de curadoria humana com lista exata de arquivos e resumo de 1 linha por arquivo; em selagem, `docs/brainstorm/**` e bloqueado por padrao. Bloquear tambem glob amplo (`docs/brainstorm/**`) sem lista exata.

Evidencia: knowledge 0024 identifica a causa-raiz como `files_allowed` inflado com zona livre que o humano nao viu arquivo a arquivo (`.hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md:33-44`). O guard atual ja compara staged contra `scope.files_allowed` (`guards/assert-scope-lock.sh:101-105`, `guards/assert-scope-lock.sh:349-352`) e ja bloqueia auto-emenda de escopo usada no mesmo commit (`guards/assert-scope-lock.sh:284-327`). O vetor de bypass que sobra e social/mecanico: um readback com path de brainstorm aprovado de forma ampla; readbacks reais ja incluiram brainstorm em `files_allowed` (`.hbn/readbacks/0032-selagem-s3-2.json:19-25`, `.hbn/readbacks/0030-selagem-s3-1.json:19-28`).

## 5. Leveza / P-CAND-01

Recomendacao: ha maquinaria a mais se W4 tentar classificar tudo agora. A via mais leve e: `core/arvores-spec.md` curto + `G-ARVORE` apenas para novos/tocados + testes de enum/front matter + burla. Nao header-comment para `.sh`, nao retrofit global, nao particao fisica, nao tabela paralela no REGISTRY.

Evidencia: P-CAND-01 pede perguntar se ha forma mais simples/racional para mudancas de peso (`docs/brainstorm/principios-candidatos.md:10-31`). A proposta promete custo baixo com "um campo + spec + guard" (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:33-37`), mas o tamanho honesto da migracao sem recorte nao e pequeno: `find core methodology docs/brainstorm guards schemas .hbn/knowledge .hbn/proposals .hbn/results .hbn/messages -type f | wc -l -> 787`; apenas `core methodology docs/brainstorm` em Markdown ja da `55`; `guards/*.sh -> 25`; `schemas/*.json -> 17`. O CLI/runtime tambem e uma superficie grande e honesta de fronteira/intermediaria: `wc -l src/usehbn/cli.py -> 1776`, e a matriz registra CLI como god-object e Truth Barrier/Guardian como advisory (`methodology/MATURITY-MATRIX.md:54-58`).

## 6. Sequencia W1-W5

Recomendacao: reordenar para reduzir retrabalho:

1. W0: selar de verdade P-CAND-04 (cross-audit + readback/status/STATE coerentes).
2. W1: hardening dos guards conhecidos.
3. W2: deny-by-default da zona livre, apoiado no G-SCOPE ja endurecido.
4. W3: arvores etiqueta leve.
5. W4: remediar/decidir bloqueadores 0034/0035 da Ponte.
6. W5: freeze/tag somente depois de W0-W4 verdes ou dividas formalmente aceitas.

Evidencia: a sequencia proposta poe deny-by-default antes do hardening (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:73-75`), mas o STATE ainda lista dividas de hardening em G-KNOW/G-FRONTDOOR/G-EXC (`.hbn/relay/STATE.md:21`, `.hbn/relay/STATE.md:28`, `.hbn/relay/STATE.md:36`). A propria definicao de "estavel" exige brechas conhecidas fechadas ou aceitas com divida registrada (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:58-62`), e a Ponte continua marcada como vetada/fitness gate bloqueado no STATE (`.hbn/relay/STATE.md:45-50`).

## Extra Codex - viabilidade e tamanho honesto

Implementar `G-ARVORE` e viavel em 1 onda curta se ele reaproveitar o padrao de `validate-dispatch`: ler blob staged/HEAD, exigir front matter na primeira linha quando o path esta no escopo, validar enum e path declarado quando existir (`guards/validate-dispatch.sh:46-57`, `guards/validate-dispatch.sh:218-244`). O custo real esta na decisao semantica de classificacao, nao no Bash/Python do guard. Se a onda exigir classificar `guards/*.sh` por comentario ou todo o historico, ela deixa de ser leve; se exigir apenas novos/tocados, o custo e honesto e incremental, alinhado ao precedente da migracao "so daqui para frente" da temperatura (`methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md:125-135`).

Assinatura: codex / OpenAI, 2026-06-16.
