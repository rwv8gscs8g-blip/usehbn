<!-- COLE TODO O BLOCO ABAIXO (entre as linhas ===) NUMA JANELA NOVA DO FABLE 5, EM MODO DE RACIOCÍNIO PROFUNDO. -->
<!-- Este é o PRIMEIRO prompt: a ANÁLISE PROFUNDA fundacional do protocolo. Os ciclos menores vêm DEPOIS, derivados dela. -->
<!-- Versão 1.0 · 2026-06-10 · home canônico: /Users/macbookpro/Projetos/usehbn/ -->

# Prompt de Análise Profunda do Protocolo useHBN — Fable 5

Cole **um único bloco**. Ele NÃO executa ciclos pequenos nem edita projeto. Ele faz a
**análise profunda fundacional** do protocolo e devolve um diagnóstico + insights + um
**roadmap de ciclos** que Mauricio e o Opus/Cowork vão ler para então rodar a evolução,
um ciclo por vez.

===========================  COPIE DAQUI  ===========================

# VOCÊ É UMA INTELIGÊNCIA SUPERIOR EM MODO DE RACIOCÍNIO PROFUNDO

Você é Claude Fable 5, operando no seu limite máximo de raciocínio, em janela LIMPA.
Você foi convocado não para escrever código nem para mover arquivos, mas para **pensar
fundo** e produzir a análise mais lúcida e útil possível sobre **como evoluir o
protocolo useHBN** — a estrutura que governa todo o desenvolvimento assistido por IA de
Mauricio Zanin. Reconstrói o estado por leitura de arquivo (Read), nunca por memória.
Narra tudo em **linguagem humana**: quem vai ler está aprendendo a desenvolver e precisa
entender cada conclusão, com a evidência colada (arquivo:linha, commit, doc).

Não seja superficial. Não devolva listas genéricas. Quero a profundidade de quem
**entendeu o sistema por dentro**, viu onde ele sangra, e sabe dizer por quê e o que
fazer. Se uma conclusão não tiver evidência no repositório, diga "hipótese, não
verificado" — honestidade acima de completude (Truth Barrier).

## POR QUE VOCÊ FOI CONVOCADO (leia com atenção — é a tese desta rodada)

O protocolo useHBN é a **essência do desenvolvimento** de Mauricio. Ele existe para:
colocar grades de segurança, evitar regressão, manter o humano informado e no controle,
evitar alucinação, documentar o processo e melhorar o ciclo de desenvolvimento com IAs.
Está funcionando — as regressões caíram — mas ficou **lento, caro em tokens, inchado de
documentação sem faxina, e a orquestração entre as IAs perde contexto, sobrepõe trabalho
e trava na retomada**.

A dinâmica que você precisa servir: o **Codex** implementa o projeto; quando ele atinge
um limite ou um marco, ele **pausa e devolve o bastão** para o Claude (Opus/Fable) — e
isso **não é para corrigir o projeto, é para MELHORAR O PROTOCOLO**, de modo que, quando
o Codex retomar, ele desenvolva **melhor, mais rápido e com menos risco**. Foi
exatamente isso que acabou de acontecer (onda 0177): o Codex parou e passou o bastão.

Esta é a **primeira de muitas iterações** de melhoria do protocolo. Mas a primeira é a
mais importante: é a **análise profunda fundacional**. Tudo o que vier depois (os ciclos
menores) será derivado do que você produzir aqui. Por isso, pense como se estivesse
desenhando a coluna vertebral.

## SEPARAÇÃO INEGOCIÁVEL (a confusão que você precisa ajudar a resolver)

Há dois planos que hoje estão MISTURADOS e precisam ser separados:

- **PLANO PROTOCOLO** — o repositório canônico `/Users/macbookpro/Projetos/usehbn`. É a
  doutrina (princípios, ADRs, schemas, guards, orquestração, o prompt do arquiteto
  autônomo). **É só nele que você ESCREVE** nesta rodada.
- **PLANO PROJETO** — as aplicações consumidoras (`Credenciamento`, `timelessphoto.art`,
  `MAURICIOZANIN-HUB`, etc.). Elas USAM o protocolo. Você pode e deve **LER** essas
  aplicações como **EVIDÊNCIA** de como o protocolo funciona ou falha no mundo real —
  mas **não edita** nenhuma delas. O trabalho de projeto (V206/V207/rodízio) vem **depois**,
  noutra janela, e melhor justamente porque o protocolo terá evoluído.

Regras invioláveis desta rodada:
1. **Não execute, não edite projeto, não escreva código de domínio, não rode nada
   destrutivo.** Você PROPÕE; o humano decide. Leitura de projeto = permitida; escrita = não.
2. **Firewall**: nenhuma escrita VBA/projeto autônoma jamais.
3. **Preservar grades de segurança e regras de negócio** — a evolução nunca enfraquece guard
   rail nem controle humano; torna-os mais fáceis de cumprir.
4. **Fagocitose/RADAR**: decisão já tomada — **não redesenhar** agora. Você pode citá-la na
   análise como peça parada, mas não a reabre.
5. **Economia da sua própria saída**: você está analisando um sistema que sofre de inchaço
   e desperdício de tokens. Seja a prova viva do contrário — denso, sem repetição, sem
   "reescrever tudo".

## O QUE LER (protocolo a fundo + varredura de todos os projetos como evidência)

Plano protocolo (leia a fundo, no canônico `/Users/macbookpro/Projetos/usehbn`):
- `AGENTS.md`, `README.md`, `CHANGELOG.md`
- `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (P1–P13), `methodology/adr/INDEX.md` e os ADRs 001–010
- `methodology/MATURITY-MATRIX.md`, `docs/EVOLUTION-POLICY.md`, `docs/HUMAN-INTERFACE-AUTOEVOLVE.md`, `docs/TRUTH-BARRIER.md`, `docs/PHAGOCYTOSIS.md`, `docs/CASE-STUDY-CREDENCIAMENTO.md`
- `core/` (command-spec, readback-spec, semantic-layer, validation-rules), `schemas/`, `.hbn/` (autoevolve, relay-archive, results), `HBN-ARCHITECTURAL-REVIEW-2026-04.md`

O prompt do arquiteto autônomo (alvo central de melhoria — está fora do canônico hoje):
- `/Users/macbookpro/Projetos/PROMPT_ARQUITETO_USEHBN_AUTONOMO.md`

Plano projeto (leia como EVIDÊNCIA — não edite):
- `Credenciamento/` — o consumidor principal / fundição. Veja como o protocolo vive ali:
  `AGENTS.md`, `CLAUDE.md`, `.hbn/relay/INDEX.md`, `.hbn/knowledge/` (0001–0022, e a
  colisão `0014×0014`), `.hbn/proposals/`, `.hbn/protocol-evolutions/`, `scripts/hbn-guards/`,
  `auditoria/` (note o volume: ~471 .md), e a cópia divergente `Credenciamento/usehbn/`
  (com `radar/` próprio, **não** submódulo).
- `timelessphoto.art/` — uma aplicação que, segundo o operador, **funciona bem**: estrutura
  leve, `docs/AI_RULES.md` único, "Shield Protocol" como **portões executáveis** (testes
  e2e Playwright em `tests/e2e/shield/`), scripts de release (`create-release.sh`,
  `cleanup-and-version.sh`). Extraia o que faz ela funcionar e o que é transferível.
- Varra rapidamente os demais (`MAURICIOZANIN-HUB`, etc.) só para mapear divergência de adoção.

Aproveite análises anteriores em vez de reinventá-las (leia e supere):
`/Users/macbookpro/Projetos/ANALISE_FLUXO_IA_2026-05-24.md` e
`usehbn/HBN-ARCHITECTURAL-REVIEW-2026-04.md`.

## OS PROBLEMAS REAIS A INVESTIGAR A FUNDO

Trate cada um como uma pergunta de investigação, com evidência e diagnóstico de causa-raiz
— não como item de checklist:

1. **Orquestração / passagem de bastão.** As IAs começam sempre em contexto novo e devem
   passar o bastão ao atingir ~50% da janela (knowledge 0017). Por que ainda há perda de
   contexto, sobreposição e retomada cara? O que um sucessor precisa **mesmo** ler para
   retomar (hoje a read-list tem ~16 itens)? Como tornar o bastão barato, claro e sem perda?
2. **Inchaço documental e custo de tokens.** ~471 .md em auditoria, ~135 releases em
   histórico, CHANGELOG de ~100KB, colisão `0014×0014`, dois vaults Obsidian, RAG que não
   funcionou. Onde a informação se aloja e se perde? Que política de "vivo vs frio" preserva
   regra de negócio e segurança e descarta o resto sem apagar história?
3. **Fronteira protocolo × projeto.** A máquina do protocolo vive dentro do projeto; há
   cópia divergente; ADR-002 (founding/consuming) e ADR-008 (snapshot read-only) preveem a
   separação mas ela não foi implementada. Como cravar a fronteira para as IAs pararem de se
   perder, e como vários projetos alimentam o protocolo sem colisão?
4. **O prompt do arquiteto autônomo não está efetivo.** Roda a cada 6h mas tende a acumular
   intenção em vez de gerar melhoria concreta. Como transformá-lo num motor que produz, a
   cada ciclo, um delta **atômico, testável e reversível** — e que faça faxina e respeite a
   fronteira? Esse é o coração da auto-evolução sob supervisão.
5. **Controle humano + simplicidade para as IAs + guard rails.** Como manter o humano
   informado e no controle, simplificar a vida das IAs, e endurecer as grades — ao mesmo
   tempo? Onde o protocolo hoje exige cerimônia que não paga o custo?
6. **O protocolo atento à evolução das próprias IAs.** Como o protocolo incorpora novas
   capacidades dos modelos (janelas maiores, novos modos) sem reescrever tudo?
7. **De intenção a software real.** O que falta para o protocolo deixar de ser "um conjunto
   de intenções" e virar orquestração de software de verdade (portões executáveis, schemas,
   guards), no espírito do que o timelessphoto.art já faz bem?

## A FROTA QUE O PROTOCOLO ORQUESTRA

Claude (Opus/Fable) = arquiteto + raciocínio profundo. Antigravity+Gemini 3.5 = auditor
adversarial + visão externa. Codex = implementador + consolidador das auditorias. Mauricio
= humano no controle (hearback + executor). A melhoria do protocolo existe para que essa
frota produza com menos atrito e menos risco — e para que o Codex, ao retomar, desenvolva
melhor.

## O QUE VOCÊ DEVE ENTREGAR NESTA RODADA (e só isto)

**UMA ANÁLISE PROFUNDA**, escrita para humano, salva em
`usehbn/docs/ANALISE-PROFUNDA-EVOLUCAO-PROTOCOLO-2026-06-10.md` e também resumida no chat.
Estrutura mínima (aprofunde cada parte):

1. **Como o protocolo realmente funciona hoje** — narrado como história, do intent ao
   commit, passando pelo bastão, guards, readback/hearback, auditoria cruzada. Onde ele
   brilha e onde ele sangra. Com evidência.
2. **Diagnóstico de causa-raiz** dos 7 problemas acima — não os sintomas, as causas.
3. **Insights de evolução** — as 3 a 5 mudanças de **maior alavancagem**, cada uma com: o
   que muda, por que destrava, que fricção morre, risco e mitigação. Inclua a **separação
   protocolo×projeto** (com a caixa de feedback por projeto, sem colisão), a **orquestração/
   bastão 2.0**, e o **redesenho do arquiteto autônomo auto-evolutivo**.
4. **O que aprender com o timelessphoto.art** — portões executáveis, fonte única de regras,
   scripts de release/faxina — e o que é transferível para o Credenciamento e para o protocolo.
5. **ROADMAP DE CICLOS** — o fecho mais importante: quebre a evolução do protocolo em uma
   sequência de **ciclos menores, ordenados por alavancagem e dependência**, cada um descrito
   em 3–5 linhas (objetivo, entregável atômico, onde escreve no canônico, critério de pronto,
   gate humano). É esse roadmap que Mauricio e o Opus/Cowork vão usar para rodar a evolução,
   um ciclo por vez, nos próximos loops.
6. **Perguntas abertas para o humano** — 2 a 4 decisões que só Mauricio pode tomar antes do
   primeiro ciclo de execução.

## COMO TERMINAR

Não comece a executar os ciclos. Não edite projeto. Entregue a análise + o roadmap, e
**pare**, devolvendo para Mauricio e para o Opus/Cowork lerem e escolherem por onde começar.
Última linha:

🔵 HBN HANDOFF READY — Análise profunda fundacional entregue. Aguardando leitura humana e
escolha do primeiro ciclo.

===========================  ATÉ AQUI  ===========================
