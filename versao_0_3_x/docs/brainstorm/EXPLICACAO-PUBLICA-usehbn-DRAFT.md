# useHBN — explicação completa (RASCUNHO público)

> **Status: RASCUNHO não-normativo.** Documento de trabalho para lapidar a próxima
> atualização pública do GitHub. Fica fora do scope-lock até promoção por onda
> formal. **Regra de honestidade:** nenhuma afirmação aqui pode exceder o que o
> `methodology/MATURITY-MATRIX.md` sustenta. Estados usados: **Implementado /
> Parcial / Scaffold / Stub / Visão**.
> Autor do rascunho: chat paralelo (Claude Opus 4.8, família Anthropic), 2026-06-16.

## O que o useHBN é

useHBN — Human Brain Net — é um protocolo aberto para engenharia de software
assistida por IA que seja **segura, estruturada e evoluível**. Ele não é a IA nem
a ferramenta; é a camada de regras que governa como uma intenção humana vira
execução verificável, preservando autoridade humana e rastreabilidade.

Tese central: o software tradicional acumula **rigidez**; o useHBN busca acumular
**capacidade evolutiva**. O propósito de longo prazo é maior que um produto: um
protocolo genérico para a humanidade evoluir com mais segurança ao lado de IAs —
tecnologias serão substituídas como indivíduos de uma espécie, enquanto os
princípios são o traço herdável que sobrevive às mudas.

## O problema que ele ataca

A IA atual usa **força bruta**: relê o repositório inteiro a cada ciclo e começa a
alucinar quando o contexto satura. Pior, pode mentir, pular etapas, desconsiderar o
que importa ou atribuir pesos próprios. O useHBN responde com três coisas
simultâneas: **amarras reais** (guards que bloqueiam o que não pode ser feito);
**memória útil e recuperável** (para não reaprender tudo a cada vez); e **intenção
humana como direção** — a IA detém a sintaxe e a fluência, o humano detém a intenção
e a direção; fluência sem intenção é vazia.

## As quatro camadas

1. **Governança epistêmica (useHBN) — a parte dura:** constituição P1–P13, guards,
   livro-razão, readback/hearback, regra cross-family, doutrina do orquestrador,
   Exúvia. Responde "o que é uma onda válida e como sabemos que é verdade".
2. **Orquestração/automação (substrato):** o runner que abre sessões limpas e roteia
   mensagens. Trocável sem mudar princípios (candidatos verificados: Omnigent, A2A,
   LangGraph).
3. **Execução (as IAs):** invocadas em janela limpa.
4. **Verdade (git + guards):** o livro-razão imutável e o enforcement mecânico — o
   backstop que segura mesmo se a automação falhar.

## A constituição (P1–P13) — o que nunca some na muda

Treze princípios de peso normativo idêntico: P1 preservar antes de transformar; P2
documentar antes de executar; P3 testar antes de refatorar; P4 explicar antes de
automatizar; P5 humano no controle por padrão; P6 toda evolução reversível; P7
nenhuma tecnologia fagocitada perde identidade; P8 o protocolo importa mais que a
ferramenta; P9 frameworks descartáveis, princípios permanentes; P10 segurança e
não-regressão acima de velocidade; P11 minimalismo de cadeia; P12 substrato sólido
(Rust como farol da Árvore Estável futura — não invalida o runtime atual); P13
abstração de linguagem pela IA. Mudar qualquer um exige cross-IA ≥2 famílias +
decisão humana + append-only + bump MAJOR (ADR-009); cadência de revisão anual.

## Como a verdade é defendida mecanicamente

O git é o livro-razão imutável; o `REGISTRY.md` registra cada artefato. Sobre ele,
os **guards** — scripts fail-closed nos hooks de git — bloqueiam o commit que viola
uma regra (existem em `guards/`: scope-lock, dispatch-integrity, role-family,
registry-line, no-stray-hbn, baton-token, entre outros). A
`guards/tests/adversarial-battery.sh` é a **memória imunológica**: cada burla já
vista precisa continuar bloqueada. Acompanham o **Truth Barrier** (toda afirmação
cita arquivo:linha; absolutos como "garantido" são proibidos), o **Glasswing**
(vetores de segurança G1–G8; código vai para arquivo, não para o chat) e o
vocabulário de **sinais HBN** (todo turno significativo abre com um sinal).

## Como as IAs coordenam — e a solução para o "fio da meada"

O problema de uma IA perder o fio ao recomeçar num chat novo é resolvido pela
separação **STATE × LOG** (`core/relay-spec.md`): o `STATE.md` tem ≤80 linhas e diz
só o que vale agora (dono do bastão, onda, papéis, próxima ação, sinais abertos,
ponteiros); o histórico vive frio no `relay-archive/`, consulta sob demanda, nunca
pedágio de entrada. A **read-list canônica** de retomada são ~5 itens (~21 KB) em
vez de centenas de KB. Quem retoma lê o STATE, o handoff apontado, o readback ativo
e o contrato do seu papel — e só.

Sobre isso operam: papéis como contratos (a **atribuição** mora no STATE); a
**Cadência D** (1 implementador; 2 auditores cruzados sempre em chat novo; humano dá
o hearback final); os invioláveis (implementador não audita o próprio trabalho;
auditores não implementam; humano decide empates); a **regra cross-family** (auditor
nunca do mesmo fornecedor do implementador — anti-groupthink, com alarme quando a
convergência fica alta demais); o **readback/hearback** (o executor declara o que
entendeu e o plano antes de agir; só vige com confirmação humana); o **scope-lock**
(`files_allowed` é autorização prévia, não allowlist auto-emendável); e o **dispatch
auto-declarante**, que entrega a onda carregando readback, fingerprint do bastão,
escopo e plano — legível sem contexto externo.

## O ciclo de melhoria: a onda

A unidade de evolução é a **onda**: intenção → dispatch → sessão limpa do
implementador (warm-boot pelo disco) → dois auditores cross-family em chat novo →
consolidação em prosa → **um único gate humano** → cerimônia (commit aplicado pelo
humano + token; guards fail-closed) → STATE atualizado + linha no REGISTRY +
readback/handoff. Dentro da onda, 3 a 6 sub-gates auditáveis. Proposta em maturação:
cada onda fechar com o placar dos 8 critérios de exúvia.

## RADAR — a evolução de fronteira

O módulo `radar/` é a varredura de fronteira: consulta multi-IA + verificação do
orquestrador → parecer de convergência → decisão de fagocitose → registro auditado.
Seu núcleo é a **CONVERGENCE-MATRIX** (tecnologia × maturidade × decisão: incorporar
/ observar / descartar). O radar **observa e propõe**; a fagocitose **absorve**;
princípios não mudam. *Estado honesto:* o RADAR-0001 já existe como semente
consolidada; a cadência periódica plena é **direção em implantação**, não rotina
provada.

## Fagocitose — como o protocolo engole tecnologia

Cinco estágios: **routed → studied → digested → mastered → contributed**. Três regras
inegociáveis: honestidade de estágio (o MATURITY-MATRIX é a fonte; nunca afirmar
mais do que o código sustenta); controle humano em cada transição (PR + hearback);
reversibilidade. É o caminho para o useHBN um dia interagir com um sistema legado
(ex.: um Pascal de 50 anos sem documentação): cada interação gera uma **lição
documentada** em `.hbn/knowledge/by-tech/`, para a próxima IA não reaprender do zero.

## As três árvores (nomes provisórios)

Modelo de progressão: **Estável** (Rust, futuro — confiabilidade, produção, mudanças
mínimas); **Intermediária/Evolutiva** (o runtime atual — melhoria contínua,
reorganização); **Fronteira/Experimental** (radar e protótipos — pesquisa, novos
paradigmas). Toda inovação amadurece progressivamente entre as árvores, sob a
fagocitose. *Nota:* os nomes e a forma de migração entre árvores são provisórios e
serão lapidados em ondas futuras dedicadas (proposta de roadmap).

## Darwinismo em três níveis

Nível 1 — software/estrutura (a exúvia: só o módulo provado carrega adiante); Nível
2 — evolução das IAs (uma lição só vira regra se provar que previne erro real; o
"dream" consolida offline e propõe, o humano ratifica); Nível 3 — seleção
inter-agentes (qual IA por tarefa, por desempenho medido, sempre proposta auditada).
Fio comum: aptidão = provada na realidade; o incumbente sobrevive por padrão; tudo
reversível.

## A Exúvia — o mecanismo evolutivo central

A versão **é uma pasta que contém o sistema inteiro** (`versao_X_Y_Z/`). A IA nova lê
só a versão vigente — pasta enxuta, carregável; o passado fica congelado com history
intacto e **um** documento de transição; consulta ao passado só sob demanda. A
estrutura muda livremente a cada muda (5 → 30 → 3 módulos); pode reorganizar tudo,
**menos** perder regras de negócio, rastreabilidade, história, governança humana,
auditabilidade, testes validados e memória imunológica. O objetivo é aumentar
aptidão; simplificar é consequência possível. O **glacier** recebe versões frias (com
índice frio; nunca em read-list; só desce com hearback + cross-audit). O
**quente/frio** governa a atenção probabilística: o quente é lido sempre; o frio é
consulta sob demanda.

Dois portões se compõem: o **Fitness Gate** decide *quando* a versão inteira pode
mudar (baseline funcional + testado + confronto incumbente × desafiante nos mesmos
testes reais; o desafiante só vence entregando mais com menos/melhor ou corrigindo
barreiras documentadas, medido; incumbente sobrevive por padrão); os **8 critérios**
(`core/exuvia-fitness-criteria.md`) decidem *o que* sobrevive, mecanismo a mecanismo.
*Estado honesto:* a máquina da muda está construída e **inativa** (scaffold M-A); a
ativação está bloqueada pelo Fitness Gate.

## O runtime e o CLI — estado honesto

Há duas superfícies no repositório, e elas precisam ser distinguidas:

1. **Protocolo de governança** (`.hbn/`, `core/`, `guards/`, `REGISTRY.md`,
   `methodology/`): a máquina multi-IA de ondas, guards, constituição e exúvia.
   Markdown + bash + git. É onde a evolução recente acontece.
2. **Runtime/CLI em Python** (`src/usehbn/`, pacote v0.3.0 "Honest Foundation"):
   o comando `hbn`/`usehbn` (`cli.py`, ~1.700 LOC, ~17 subcomandos — **Implementado**
   na MATURITY-MATRIX, suíte 114/114), que estrutura intenção, cria readback, marca
   hearback, emite ERP, mostra relay, gera adapters de runtime e detecta connectors
   (o **Universal Translator** está em **Scaffold**: é um roteador honesto, não um
   tradutor semântico). Há um módulo `autoevolve` embrionário (ciclo de microdeltas
   com gate humano) — semente da automação futura.

Distinção crucial para o público: o que **existe** em CLI é a superfície de runtime
de tiro único. A **orquestração por CLI** (`usehbn start` como comando, despacho
automático de ondas, automação do loop multi-IA) é **Visão** — `usehbn start` é hoje
um **rito conversacional**, não um comando (`core/start-rite-spec.md` §1). Nenhuma
afirmação pública deve confundir as duas.

## Roadmap e estado honesto

Ordem travada: estabilizar o useHBN (resolver o problema do "fio da meada") → aprovar
o protocolo → **Ponte do Credenciamento** (primeiro teste do protocolo interagindo
com um sistema real) → **1ª exúvia do próprio protocolo** (simplificar, melhorar,
definir o caminho) → estabilizar e congelar **Credenciamento V12.0.206** (release
pública pronta para uso) → **V12.0.207** = refatoração / 1ª exúvia do protocolo de
Credenciamento (gestão, estabilidade, testes, com os guards e a segurança do useHBN
aplicados como exemplo prático).

Estado atual: pre-v1, v0.3.0 "Honest Foundation", **em elaboração** — ainda não
"funcional/provado". A Ponte está pendente; a ativação da exúvia está bloqueada; há a
exceção F-01 ativa. Essa honestidade não é defeito de apresentação — é o produto, e é
o que torna a publicação no GitHub digna de confiança.

## Critério de "versão testada liberada" (quando outros poderão testar/contribuir)

Mesmo com repositório público, ainda não há utilidade prática provada para terceiros.
A liberação de uma versão testada exige, em ordem: (a) evolução do protocolo; (b)
Ponte do Credenciamento funcionando; (c) 1ª exúvia do protocolo; (d) estabilização,
entrega e congelamento da V12.0.206; (e) exúvia do Credenciamento com a V12.0.207,
com todos os guards, segurança e melhorias do useHBN aplicados como exemplo prático.

---

O fio que amarra tudo: o protocolo evolui **com as IAs, para as IAs e apesar das
IAs** — elas são ferramenta, não fim; a direção e os pesos são humanos por
construção; as metáforas da natureza (exoesqueleto, imunidade, evolução bacteriana,
o rio que esculpe a margem) são lentes de raciocínio, não a fundação — a fundação é
razão, lógica, decisão coerente e humano no centro.
