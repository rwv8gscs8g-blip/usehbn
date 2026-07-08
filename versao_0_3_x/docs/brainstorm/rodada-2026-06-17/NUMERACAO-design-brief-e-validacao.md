# Numeração / identificação do useHBN como protocolo GLOBAL e ABERTO — design brief + validação ≠-família

NÃO-NORMATIVO (fronteira). Orquestrador (opus-4-8), 2026-06-17. Insumo para decisão de
EXÚVIA (a numeração nasce na muda). Não bloqueia o freeze.

---

## 1. A visão (mudou o problema)
useHBN não é numeração de UM sistema — é um **protocolo geral e aberto**, para ser adotado
em larga escala por muitos sistemas, em muitos mercados, com muitas tecnologias, por
desenvolvedores (humanos e IAs) **autônomos**, muitos ainda inexistentes. Logo a
identificação precisa ser:
1. **Livre de colisão entre adotantes independentes** que NUNCA se coordenam (federação).
2. **Sem autoridade central** (nenhum registro central que precise existir/sobreviver).
3. **Legível por humano** E parseável por máquina.
4. **Agnóstica de tecnologia e de mercado.**
5. **Sequência legível** (dá pra ver a progressão dos passos).
6. **Estável através de exúvias** (eixo de genoma/versão por sistema).
7. **Simples** (P11) — adoção sem fricção.

## 2. Crítica honesta da minha 1ª proposta (g1.cNN.wMM-slug)
Boa em 3,5,6,7 DENTRO de um sistema. **Falha em 1 e 2**: não tem namespace → colide entre
adotantes; e assume um histórico de genoma linear único. Foi pensada para o useHBN sozinho,
não para a federação. Não validar como está.

## 3. Arte prévia (o mundo já resolveu pedaços disto)
- **SemVer** (X.Y.Z): ótimo para versão; não identifica passo/onda nem namespace.
- **Reverse-DNS / Go modules** (`com.org.sys` / `github.com/org/repo`): namespace
  federado, **sem registro central**, auto-atribuído, battle-tested.
- **npm scopes** (`@org/pkg`): namespace simples, mas exige um registro central.
- **DOI** (`10.<registrant>/<suffix>`): global, mas com autoridade central de prefixos.
- **UUID / ULID**: colisão-livre global sem coordenação; ULID é ordenável por tempo; ambos
  **opacos** (não legíveis).
- **Content-addressing** (hash): colisão-livre + verificável, mas opaco e não ordenável.

Lição: **namespace federado (reverse-DNS/URL) + esquema local legível** é o casamento que a
indústria convergiu para "muitos atores independentes sem coordenação".

## 4. Candidatos a avaliar
- **A. Linear único** `g1.c01.w03-slug` — simples, 1 sistema. (Colide na federação.)
- **B. Namespaced federado** `<ns>:g1.c01.w03-slug`, com `<ns>` reverse-DNS/URL
  auto-atribuído (ex.: `com.credenciamento:g1.c02.w03-auth-screen`). Dentro do próprio repo
  o `<ns>` é implícito/omitido; só aparece ao cruzar fronteiras de sistema.
- **C. Híbrido legível+único** `<ns>:g1.c01.w03-slug` PARA humano + um **ULID/hash** anexo
  para unicidade global verificável (legibilidade E colisão-zero).
- **D. Só global-opaco** (ULID/hash) com label legível separado. (Colisão-zero, baixa
  legibilidade.)

## 5. As perguntas exatas para a validação ≠-família (Gemini, Codex, Grok)
1. Para um protocolo GLOBAL/ABERTO/federado (req. 1–7), qual esquema (A/B/C/D ou outro) é o
   **mais adequado e mais simples** — sem cair em over-engineering nem em colisão?
2. **Namespace:** reverse-DNS, URL de repo, handle escolhido, ou hash? Como garantir
   colisão-livre **sem autoridade central**?
3. **Genoma/exúvia:** como versionar as mudas (cada sistema molta no seu tempo) de forma que
   o histórico cross-exúvia continue rastreável?
4. **Artefatos federados:** como referenciar cross-audits/knowledge COMPARTILHADOS entre
   sistemas distintos sem ambiguidade?
5. **Migração:** o REGISTRY antigo (esquema `00NN`) fica read-only; o novo nasce no esquema
   escolhido. Há risco/atrito nessa coexistência?
6. **Leveza (P11):** o que NESTE design é maquinaria a mais que um dev autônomo recusaria?
   Qual o subconjunto mínimo que serve 90% dos adotantes?

## 6. Bloco de validação (colar em janela nova de cada — Gemini/Google, Codex/OpenAI, Grok/xAI)
```
PARA: <gemini|codex|grok> — parecer de DESIGN (3 familias distintas) sobre numeracao de protocolo.
DE: claude-opus-4-8 (orquestrador useHBN)
CONTEXTO: useHBN e um protocolo de governanca de IA via git, que sera adotado em larga escala
por muitos sistemas/mercados/tecnologias, por devs autonomos independentes (federacao, sem
autoridade central). Precisamos de um esquema de IDENTIFICACAO de passos (onda/readback),
pareceres, knowledge e do livro-razao (REGISTRY) que seja: colisao-livre entre adotantes que
nao se coordenam; sem registro central; legivel por humano + parseavel; agnostico de
tecnologia/mercado; com sequencia legivel; estavel atraves de exuvias (mudas); e SIMPLES (P11).
Leia docs/brainstorm/rodada-2026-06-17/NUMERACAO-design-brief-e-validacao.md (secoes 3-4) para
a arte previa e os candidatos A/B/C/D.
TAREFA: responda as 6 perguntas da secao 5 do brief. Recomende UM esquema (ou proponha outro),
com a forma EXATA de um id de exemplo, a estrategia de colisao sem autoridade central, e o
subconjunto MINIMO. Aponte over-engineering. Sem absolutos; justifique.
ENTREGUE: texto estruturado (nao precisa tocar o repo). Se quiser, deposite em
.hbn/results/AAAAMMDD-HHMMSS-<apelido>-design-numeracao.md com SOU canonico na 1a linha.
```

## 7. Recomendação de quando validar
A numeração **nasce na exúvia** (Fase E), não bloqueia o freeze (Fase B). Então:
- **Framing feito agora** (este brief) — é onde o orquestrador atual agrega.
- **Rodar a validação ≠-família**: pode ser AGORA (se quiser travar o esquema cedo) ou
  entregue como **tarefa ao próximo orquestrador**, na abertura do design da Exúvia. Recomendo
  passar ao próximo (preserva contexto desta janela para o caminho do freeze), com este brief
  como o insumo pronto. Como é DESIGN (não auditoria de implementação), usar Codex/OpenAI como
  um dos 3 validadores é adequado (3 famílias: Google + OpenAI + xAI).
```
