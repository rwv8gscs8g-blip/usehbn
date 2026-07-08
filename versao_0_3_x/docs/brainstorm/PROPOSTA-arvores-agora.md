# Proposta de Fronteira — implementar as árvores AGORA (PF-ARVORES-AGORA)

> **RASCUNHO não-normativo** (zona Fronteira / fora do scope-lock). Para aprovação
> humana → auditoria adversarial cross-family → decisão do orquestrador no fluxo do
> protocolo. Autor: chat paralelo (Claude Opus 4.8, Anthropic), 2026-06-16.

## 1. O que se propõe, em uma frase

Documentar e **etiquetar** as três árvores agora (campo `arvore:` no front-matter),
deixando a partição física de diretórios para a 1ª exúvia — para que o sistema
ganhe um **endereço de prova** por artefato e o modelo compilador (`.md` →
enforcement) ganhe um pipeline com portões.

## 2. Por que AGORA traz avanço robusto

1. **Endereço de prova para cada artefato.** Hoje uma IA não distingue lei provada,
   ideia experimental e código de runtime — a divergência das duas superfícies
   (governança bash/markdown × CLI Python) é o sintoma. Um campo `arvore:`
   (Fronteira / Intermediária / Estável), ao lado de `temperatura:` e `hbn-track:`,
   responde de imediato: "isto é o protocolo, isto é protótipo, isto é o sistema que
   ele constrói". Ataca direto a confusão (protocolo × sistema) e o "fio da meada".
2. **Opinião vira placar.** "Está maduro?" deixa de ser debate e vira "em que árvore
   está e passou o portão?". O portão **reusa** máquina já provada: fagocitose
   (routed→studied→digested→mastered→contributed) + os 8 critérios de exúvia +
   Fitness Gate. Não é maquinário novo.
3. **O modelo compilador fica operacional.** O gradiente de prova das árvores É o
   compilador: Fronteira (`.md` sem enforcement) → Intermediária (enforcement em
   Python/bash) → Estável (Rust mínimo, só princípios). Sem árvores, o compilador é
   metáfora; com elas, é pipeline com portões — a casa do "imprimir para linguagem
   atual, antiga ou futura".
4. **Quarentena honesta do perigo.** Truth Barrier/Guardian advisory, o god-object
   `cli.py` e o `autoevolve` embrionário hoje moram no mesmo `src/` do código
   provado, criando falsa confiança (teatro). Árvores rotulam isso como Fronteira até
   merecerem promoção; a segurança fica real porque só Intermediária/Estável carregam
   enforcement fail-closed.
5. **Protege a exúvia da explosão de escopo.** A 1ª exúvia ganha alvo modesto e
   claro: lapidar o núcleo Intermediária em `versao_1_0_0/`, deixar Fronteira fora,
   semear Estável (Rust/princípios) como onda futura.
6. **Dá às duas esteiras um sistema de coordenadas comum** (ver §4).
7. **Custo baixo agora.** Etiquetar = um campo de front-matter + um spec + tag nos
   artefatos. Sem código, sem migração arriscada.

## 3. Como a Fronteira interage com o RADAR (ponto 2 do gate humano)

Eles não competem — **o RADAR é o instrumento estruturado da árvore Fronteira.**

- A exploração livre (brainstorm, chat paralelo) é a *captação bruta*. Ela só
  graduará se **cristalizar numa entrada estruturada de RADAR** (uma linha da
  CONVERGENCE-MATRIX: candidato × maturidade × decisão = incorporar / observar /
  descartar). Regra: **nenhuma ideia sai da Fronteira sem virar entrada de RADAR.**
  Isso responde "o processo de exploração deve gerar um processo estruturado do
  radar" — sim, é obrigatório.
- Distinção de objeto (para não borrarem): o RADAR varre **tanto** tecnologia
  externa (Omnigent, A2A, LangGraph) **quanto** ideias internas do protocolo (as
  árvores, o compilador, o front-door). A árvore Fronteira é **onde** isso vive; o
  RADAR é **como** isso é estruturado e decidido. A CONVERGENCE-MATRIX é a **fila de
  promoção** da Fronteira.
- Fluxo: exploração livre → entrada estruturada de RADAR → portão de promoção
  (fagocitose + 8 critérios + cross-audit ≠-família + Fitness Gate) → Intermediária.

## 4. Qual regra o sistema segue — e por que isso precede o Credenciamento

**Invariante proposto (a selar antes da Ponte do Credenciamento):** o sistema em
produção obedece **sempre à árvore mais validada disponível** (Estável > Intermediária).
Regras de Fronteira/exploratórias são **não-vinculantes** até serem promovidas. A
exploração **propõe**; nunca **governa**. (É fail-closed + P10: segurança e
não-regressão acima de velocidade.)

- Para o Credenciamento: ele consome **apenas** o enforcement estável
  (Intermediária/Estável). Ideias de Fronteira só o alcançam **após** passarem o
  portão. Assim o Credenciamento trabalha com as regras mais robustas e validadas,
  como você exige.
- Distinção-chave: **o protocolo evolui na Fronteira, mas faz cumprir no estável.**
  O dogfooding da evolução do protocolo acontece na ponta exploratória; os guards que
  efetivamente rodam (e que o Credenciamento vê) são sempre da camada validada.

## 5. Decisões que precisam do seu aval

1. **Recorte:** etiquetar com `arvore:` agora + particionar diretórios na exúvia
   (recomendado) — vs. já criar diretórios agora (mais caro/arriscado).
2. **Relação de campos:** `arvore:` complementa `temperatura:` (quente/frio = atenção)
   e `hbn-track:` (trilha), sem substituí-los? (Decisão de design para não criar
   segunda fonte de verdade — roles-spec §3.)
3. **Invariante "regra estável governa":** selar antes da Ponte do Credenciamento?
4. **Famílias-alvo** da auditoria adversarial + abertura de proposta: Gemini 3.5,
   Codex, Cursor, Grok — incluir Antigravity (que auditou o 0029)?
5. **Chapéu `analista-de-fronteira`:** formalizar neste pacote ou tratar depois?
