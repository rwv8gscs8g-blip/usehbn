---
arvore: fronteira
status: congelado
tema: github-readme-honesto
autor: subagente-opus-evolucao
data: 2026-06-16
escopo: plano de atualização HONESTA do GitHub/README para o MVP público — NÃO-NORMATIVO; nada aqui altera arquivo público, só propõe
fonte-canonica: methodology/MATURITY-MATRIX.md (v0.3.0, locked)
truth-barrier: toda afirmação cita arquivo:linha
depende-de: docs/brainstorm/rodada-2026-06-16/B2-honestidade-maturity-matrix.md
base-refinada: docs/brainstorm/EXPLICACAO-PUBLICA-usehbn-DRAFT.md
temperatura: glacier
---

# C4 — Plano de atualização HONESTA do GitHub/README para o MVP público

> Documento de FRONTEIRA, não-normativo. Não promove componente de estado nem
> altera README/AGENTS. Pela regra de evolução da matriz
> (`methodology/MATURITY-MATRIX.md:33-40`), qualquer mudança de estado exige PR
> com evidência + Hearback humano. Este arquivo apenas **propõe** o texto e as
> correções para uma onda futura aprovar.

## Régua mestra (a regra que governa tudo abaixo)

[CONCLUSÃO] A matriz é a fonte única e nenhuma afirmação pública pode excedê-la
(`methodology/MATURITY-MATRIX.md:5-6`; reafirmado em `README.md:40` e
`AGENTS.md:17`). A regra de redação pública está cravada na própria matriz:

> "Se a afirmacao depende de algo no estado **Scaffold**, **Stub** ou **Visao**,
> a afirmacao deve usar linguagem condicional [...] e nunca verbo no presente do
> indicativo absoluto." (`methodology/MATURITY-MATRIX.md:84-87`)

[CONCLUSÃO] Os cinco — e ÚNICOS — estados oficiais são **Implementado /
Parcial / Scaffold / Stub / Visão** (`methodology/MATURITY-MATRIX.md:21-29`).
Qualquer escala fora desses cinco (ex.: "L4") não tem âncora canônica e viola o
espírito da matriz (ver §(b) abaixo, dívida P1).

---

## (a) O que o README / página pública DEVE dizer no MVP

Mapeamento estado-da-matriz → registro verbal permitido. Cada bloco cita a
regra (`methodology/MATURITY-MATRIX.md:23-29`) e o estado-fonte da matriz.

### a.1 — Implementado → presente do indicativo ("funciona hoje")

[PROPOSTA] Permitido afirmar em presente, porque a regra diz "Funciona hoje."
(`methodology/MATURITY-MATRIX.md:25`). Componentes elegíveis: CLI
(`methodology/MATURITY-MATRIX.md:54`), Trigger (`:55`), Consent (`:59`),
Readback — com o limite citado (`:60`), Hearback (`:61`), ERP (`:62`), Handoff
(`:65`), Runtime Adapters (`:67`), Schemas (`:73`).

Texto-modelo: *"useHBN provê hoje, neste repositório, um runtime local que:
detecta o gatilho semântico `usehbn`/`use hbn`, estrutura intenção, captura
consentimento local, registra Readback com gate de Hearback, emite ERP, e gera
arquivos de adapter para 7 runtimes."* — já alinhado com `README.md:77-87` e
`README.md:513-541`.

[DÍVIDA] Mesmo em "Implementado", os LIMITES citados na matriz precisam
aparecer. Ex.: Readback é Implementado mas "Nao chamado pelo `engine.py`;
criado manualmente via CLI" (`methodology/MATURITY-MATRIX.md:60`) — o README já
honra isso (`README.md:50`), manter.

### a.2 — Parcial → presente + limites citados ("funciona com limites X e Y")

[PROPOSTA] A regra exige nomear as lacunas: "Funciona com limites X e Y. Lacunas
devem ser citadas." (`methodology/MATURITY-MATRIX.md:26`). Aplicar a:

- **Truth Barrier** / **Guardian**: "Parcial (advisory)" — "emite warnings; nao
  bloqueia" (`methodology/MATURITY-MATRIX.md:57-58`). A página pública DEVE dizer
  *"emitem avisos; não bloqueiam o pipeline em v0.3.0"* e nunca chamar de
  "barreira que protege". B2 confirma que o README já está honesto nisso
  (`README.md:555`), mas o NOME "Barrier"/"Guardian" carrega risco semântico de
  bloqueio (B2 §(c); `src/usehbn/execution/engine.py:88` grava literalmente "not
  enforced in v0.3.0"). **Manter a frase de "What Does Not Work Yet" e nunca
  promover para verbo de proteção.**
- **Intent** (PT/multi-cláusula falham, `methodology/MATURITY-MATRIX.md:56`),
  **Relay**/**Baton** ("Parcial honesto", `:63-64`), **Connectors (resolver)**
  ("active" por mera presença de arquivo, `:68`), **State** (dual-read,
  `:72`), **Privacy Contract** ("Parcial / declarativo", `:64` README /
  `:74` matriz), **Tests** ("sem testes adversariais", `:76`), **Distribuição**
  ("nao publicado em PyPI", `:77`).

### a.3 — Scaffold → linguagem condicional ("há estrutura; comportamento conceitual")

[PROPOSTA] Regra: "Ha estrutura, mas o comportamento ainda e conceitual."
(`methodology/MATURITY-MATRIX.md:27`). Exemplo válido já dado pela matriz
(`:91-93`). Aplicar a:

- **Universal Translator**: "roteador honesto", NÃO tradutor semântico
  (`methodology/MATURITY-MATRIX.md:66`). README já correto (`README.md:252-256`).
- **Connectors (lifecycle)** — 6 estados registrados, "Sem FSM ainda"
  (`methodology/MATURITY-MATRIX.md:69`).
- **Connectors (remote lookup)** — "registry remoto real nao existe e default e
  off" (`methodology/MATURITY-MATRIX.md:71`).
- **Autoevolve (orchestrator/worker/queue/approval)** — ver §(b) P0. Hoje
  AUSENTE da matriz; B2 classifica como Scaffold/Stub com worker no-op
  (`src/usehbn/autoevolve/worker.py:1-6`) e gate de diff inerte
  (`approval.py:27` sobre campos sempre 0). **Não pode aparecer na página
  pública como automação real até a matriz documentá-lo.**

### a.4 — Stub → "apenas placeholder; nada acontece em runtime"

[PROPOSTA] Regra: "Apenas placeholder. Nada acontece em runtime."
(`methodology/MATURITY-MATRIX.md:28`). Aplicar a: **Connectors (verify)**
(`:70`), **Bridge generation legado** (`:75`; README correto em `:553`,
`:65`).

### a.5 — Visão → "linha de pesquisa; sem código associado"

[PROPOSTA] Regra: "Linha de pesquisa. Sem codigo associado."
(`methodology/MATURITY-MATRIX.md:29`). Aplicar a: **Phagocytosis** (doutrina,
`:78`), **Credenciamento** (referência externa, `:79`), e — refinando o DRAFT
— a **orquestração por CLI / `usehbn start` automático**, que o DRAFT já
classifica como Visão / rito conversacional, não comando
(`docs/brainstorm/EXPLICACAO-PUBLICA-usehbn-DRAFT.md:172-176`). As metáforas
(exúvia, três árvores, darwinismo) são Visão e devem ir para uma seção rotulada
"O que é visão", não misturadas com "o que funciona hoje".

---

## (b) Lista de correções concretas (antes do MVP público)

Priorização herdada de B2 §(e) (`B2-honestidade-maturity-matrix.md:243-284`).

### P0 — Bloqueiam a release pela própria regra da matriz

[DÍVIDA] **P0-1 — Documentar `autoevolve` na matriz canônica.** O braço é
roteado no CLI (`src/usehbn/cli.py:1716-1718`), tem ADR ACCEPTED e vitrine, mas
está AUSENTE de `methodology/MATURITY-MATRIX.md` (B2 §(b)). A matriz exige
auditoria por linha a cada minor (`methodology/MATURITY-MATRIX.md:104-109`);
sem essa linha "a release nao sai" (`:109`). Ação: adicionar 3 linhas (audit =
Parcial honesto; orchestrator/worker/queue/approval = Scaffold; cli = Parcial)
via PR + Hearback. **Correção de MATRIZ, não de README — fora do meu escopo de
escrita; aqui só registro.**

[DÍVIDA] **P0-2 — Neutralizar o teatro do autoevolve antes de qualquer menção
pública.** Nome "autoevolve"/"distributed-ready"
(`src/usehbn/autoevolve/orchestrator.py:1`, `__init__.py:6`) contradiz
diretamente o README: *"HBN is not: a background agent system"*
(`README.md:113`). Worker é no-op (`src/usehbn/autoevolve/worker.py:1-6`); gate
de diff é inerte (`approval.py:27`). Ação: (i) implementar worker/diff de
verdade, OU (ii) renomear/rotular como "scaffold conceitual, evolução
humano-no-loop" em código E matriz. **A página pública NÃO pode dizer
"auto-evolução" no presente até isso resolver.**

### P1 — Dívidas de honestidade baratas e de alta visibilidade (tocam docs públicos)

[DÍVIDA] **P1-1 — Contagem de testes 93/93 → 114/114 em `AGENTS.md:57`.**
`AGENTS.md` diz "currently 93/93 passing" (`AGENTS.md:57`), mas matriz
(`methodology/MATURITY-MATRIX.md:76`) e README (`README.md:5`) dizem 114/114.
Três documentos, dois números (B2 §(a.4)). **NÃO posso editar AGENTS.md
(isolamento) — registro a correção exata para a onda dona do AGENTS.md aplicar:
trocar `93/93` por `114/114` na linha 57.**

[DÍVIDA] **P1-2 — Ponteiro de fonte única em `AGENTS.md:17`.** AGENTS aponta
maturidade para `docs/MATURITY-MATRIX.md`, que está **SUPERSEDED** desde
2026-05-10 (`docs/MATURITY-MATRIX.md:3-11`; banner descrito em
`methodology/MATURITY-MATRIX.md:42-48`). Ponteiro canônico correto:
`methodology/MATURITY-MATRIX.md` (o README já acerta em `README.md:40`).
**Correção exata para a onda dona do AGENTS.md: na linha 17 trocar o link e o
texto de `docs/MATURITY-MATRIX.md` por `methodology/MATURITY-MATRIX.md`.**

[DÍVIDA] **P1-3 — Escala "L4" fora dos 5 estados, em `README.md:559`.** "HBN is
now at a solid L4 level" usa escala paralela sem âncora canônica
(`methodology/MATURITY-MATRIX.md:21-29` só define 5 estados). Ação proposta:
trocar por linguagem ancorada na matriz, ex.: *"HBN está em v0.3.0 'Honest
Foundation': instalável, inspecionável, rastreável; com componentes nos estados
Implementado / Parcial / Scaffold / Stub / Visão conforme
`methodology/MATURITY-MATRIX.md`."* OU definir "L4" num doc canônico. **Toca o
README — registro a edição; aplicação por onda dona do README.**

[DÍVIDA] **P1-4 — Coerência "Universal Translator" nome×estado.** O nome de
visão é mantido por decisão humana (`methodology/MATURITY-MATRIX.md:66`;
`README.md:256`). Manter, mas SEMPRE acompanhado da frase "roteador honesto;
não traduz semanticamente". Já honrado; vigiar para não regredir.

[DÍVIDA] **P1-5 — Ambiguidade "operable scaffold" + autoevolve.** `README.md:34`
("operable HBN scaffold") combinado ao braço autoevolve não-documentado abre
janela para leitura de "auto-evolução operável" (B2 §(d)). Após P0-2 resolvido,
reavaliar a frase; enquanto autoevolve for scaffold humano-no-loop, NÃO reforçar
"operable" perto de qualquer menção a evolução automática.

### P2 — Lacuna doutrina↔runtime (não é overclaim hoje, mas é pré-requisito de afirmação futura)

[PROPOSTA] **P2-1 — Advisory→enforcing fail-closed por árvore.** Truth
Barrier/Guardian só avisam (`src/usehbn/execution/engine.py:88`). Não é dívida
de honestidade hoje porque está bem declarado (`README.md:555`), mas é
pré-requisito para QUALQUER afirmação pública de que "protegem"/"bloqueiam"
(B2 §(c), plano em `B2:176-203`). Até o merge + testes adversariais, a página
pública mantém o verbo "avisam", nunca "protegem".

---

## (c) Estrutura de seções recomendada para a página pública

[PROPOSTA] Reorganizar a página pública em blocos que SEPARAM "o que funciona"
de "o que é visão", refinando a base do
`docs/brainstorm/EXPLICACAO-PUBLICA-usehbn-DRAFT.md`. Ordem proposta:

1. **O que useHBN é** — protocolo aberto para engenharia assistida por IA
   segura, estruturada, evoluível; não é a IA nem a ferramenta
   (`DRAFT:10-15`; `README.md:75-87`). Verbos em presente só para Implementado.

2. **O que useHBN NÃO é** — lista de negações explícitas, herdada de
   `README.md:106-118`: não é produto, framework, plataforma hospedada,
   **sistema de agente em background** (`README.md:113`), motor de execução
   distribuída, economia de tokens, alegação de AGI, substituto de revisão
   humana. **Esta seção é a âncora de honestidade — manter literal e no topo,
   pois é ela que blinda contra a leitura "autoevolve = automação".**

3. **O que funciona hoje** — só estado Implementado/Parcial, com limites
   citados (regra `methodology/MATURITY-MATRIX.md:25-26`). Reaproveitar
   `README.md:513-541` ("What Works Today") e a "Maturidade por Componente"
   (`README.md:42-69`), que já espelha a matriz.

4. **O que ainda não funciona / é visão** — fundir "What Does Not Work Yet"
   (`README.md:543-556`) com os conceitos de visão (Phagocytosis, exúvia, três
   árvores, orquestração automática, `usehbn start` como comando). Cada item em
   linguagem condicional (regra `methodology/MATURITY-MATRIX.md:84-87`). Rótulo
   explícito: "linha de pesquisa / direção de longo prazo".

5. **Como contribuir — e por que terceiros ainda NÃO podem testar com utilidade
   prática** — ver §(d). Deixar EXPLÍCITO que, mesmo com repo público, "ainda
   não há utilidade prática provada para terceiros"
   (`DRAFT:195`), e remeter a `docs/SAFE-TESTING.md`, `CONTRIBUTING.md`,
   `CODE_OF_CONDUCT.md`, `SECURITY.md` (`README.md:485-489`, `README.md:563`).

6. **Governança e licença** — founder-led, review-based, Apache 2.0 + DCO
   (`README.md:479-511`). Sem mudança proposta.

[PROPOSTA] Princípio de layout: a seção 2 ("o que NÃO é") vem ANTES de qualquer
descrição de capacidade, e a seção 4 ("visão") nunca usa presente do indicativo
absoluto. Isso operacionaliza a regra `methodology/MATURITY-MATRIX.md:84-87` na
arquitetura da página, não só no texto.

---

## (d) Critério "versão testada liberada" como GATE de comunicação pública

[CONCLUSÃO] O DRAFT já define o gate (a)–(e)
(`docs/brainstorm/EXPLICACAO-PUBLICA-usehbn-DRAFT.md:193-199`). Refinado como
**gate de comunicação pública** (nenhuma chamada do tipo "experimente agora /
use em produção" pode ser feita antes de cumprir TODOS):

- **(a)** evolução do protocolo concluída;
- **(b)** Ponte do Credenciamento funcionando (primeiro teste do protocolo
  interagindo com sistema real);
- **(c)** 1ª exúvia do próprio protocolo;
- **(d)** estabilização, entrega e congelamento da V12.0.206 (release pública
  pronta para uso);
- **(e)** exúvia do Credenciamento na V12.0.207, com todos os guards, segurança
  e melhorias do useHBN aplicados como exemplo prático.

[PROPOSTA] Regra de comunicação derivada: **enquanto (a)–(e) não estiverem
cumpridos, a página pública pode dizer "está público para inspeção e
contribuição de protocolo", mas NÃO "pronto para uso/teste por terceiros".**
Estado atual honesto: pre-v1, v0.3.0 "Honest Foundation", **em elaboração** —
ainda não "funcional/provado"; Ponte pendente; exúvia bloqueada
(`DRAFT:188-191`). Essa honestidade "é o produto" e o que torna a publicação
"digna de confiança" (`DRAFT:190-191`) — deve ser dita, não escondida.

[PROPOSTA] Badge/status sugerido: manter "Status: alpha"
(`README.md:7`) e acrescentar, na seção 5, a frase-gate: *"v0.3.0 é uma
fundação honesta aberta à inspeção; a liberação para teste prático por
terceiros está condicionada ao critério (a)–(e) de 'versão testada liberada'."*

---

## Síntese de fronteira

[CONCLUSÃO] O README de v0.3.0 é majoritariamente honesto (linguagem condicional
para Scaffold/Stub; seções "What HBN Is Not" e "What Does Not Work Yet").
As correções públicas concretas são quatro: (1) `AGENTS.md:57` 93/93→114/114;
(2) `AGENTS.md:17` ponteiro SUPERSEDED→`methodology/MATURITY-MATRIX.md`; (3)
`README.md:559` remover/ancorar "L4"; (4) blindar qualquer menção a "autoevolve"
até P0-2 — porque "distributed-ready" contradiz "not a background agent system"
(`README.md:113`). Tudo sob a régua única: nenhuma afirmação pode exceder
`methodology/MATURITY-MATRIX.md` (`:5-6`, `:84-87`) e qualquer mudança de estado
passa por PR + Hearback (`:33-40`). As correções em AGENTS.md/README.md são
REGISTRADAS aqui, não aplicadas — fora do meu isolamento de escrita.
