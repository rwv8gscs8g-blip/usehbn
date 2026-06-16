# Brainstorm — evolução conceitual da exúvia

Espaço de **pensamento exploratório** (não-normativo) para aprofundar o conceito
de exúvia e incorporá-lo à lógica de planejamento do usehbn. É aqui que o chat
paralelo (Opus) deposita conclusões, propostas e perguntas abertas para avanços
futuros. **Nada aqui é regra** até ser promovido a `core/` + ADR por uma onda
formal (com readback, cross-audit e selagem).

## Como usar este arquivo

- Escreva em **entradas datadas** (`## AAAA-MM-DD — título`).
- Marque cada ponto como **[CONCLUSÃO]**, **[PROPOSTA]** ou **[PERGUNTA ABERTA]**.
- Quando possível, cite arquivo:linha (Truth Barrier) — mesmo em brainstorm, evidência ajuda.
- Itens maduros viram candidatos a: (a) spec em `core/`, (b) ADR em `methodology/adr/`, ou (c) onda da série S. Anote o destino sugerido.
- Pode escrever livremente: este caminho fica **fora** do scope-lock enquanto não for commitado. A selagem/curadoria vem depois, numa onda dedicada.

## Âncoras de contexto (o que já está decidido)

- **Conceito (corrigido):** exúvia = muda do exoesqueleto dos artrópodes/lagostas. A carapaça **sustenta e protege, mas também aprisiona**; a muda abandona o que limita para crescer e reconstruir proteção. O usehbn é protocolo de **proteção e defesa** com premissa dupla: proteger **e** evoluir continuamente.
- **Critérios objetivos (normativo):** `core/exuvia-fitness-criteria.md` — os 8 critérios (C-TEST, C-ADV, C-XAUDIT, C-DOG, C-FCLOSE, C-NOREG, C-TRACE, C-DEBT) e a regra de sobrevivência ao molt.
- **Scaffold da exúvia:** `core/hbn-exuvia-scaffold.md` — máquina da muda (versão=pasta), hoje inativa; ativação só após o Fitness Gate (M-C).
- **Duas camadas a formalizar juntas (pedido do Maurício):**
  1. **Quando mudar de versão** — o *Fitness Gate* (baseline funcional + Ponte verde + confronto incumbente×desafiante).
  2. **O que sobrevive à muda** — os 8 critérios objetivos por mecanismo.

## Perguntas-semente para o aprofundamento

- [PERGUNTA ABERTA] Como o Fitness Gate (gatilho da muda) e os 8 critérios (filtro do que sobrevive) se compõem num único rito de planejamento?
- [PERGUNTA ABERTA] O que, na carapaça atual (guards, specs, ceremônia de readback), **protege** vs o que **aprisiona** e deveria ser mudado na próxima exúvia?
- [PERGUNTA ABERTA] Que sinais objetivos disparam "está na hora da muda" (a carapaça virou gaiola)?
- [PERGUNTA ABERTA] Como medir "crescimento" do protocolo entre mudas, para que a exúvia seja evolução e não só troca?

## Entradas

(o chat paralelo começa aqui)

## 2026-06-16 — Evolução procariótica: o brainstorm como plasmídeo e a bateria adversarial como locus CRISPR

_Autor: chat paralelo (Claude Opus 4.8, família Anthropic) com acesso direto ao disco._
_Contexto: resposta às perguntas-semente + à diretriz do Maurício de mimetizar evolução bacteriana (ciclos curtos, transferência lateral) preservando uma "versão oficial da verdade" com amarras reais contra IAs que mentem/pulam/desconsideram._

### A. Análise do próprio mecanismo de interação inter-IA (este arquivo)

- [CONCLUSÃO] Este arquivo é, estruturalmente, um **blackboard estigmérgico de baixa temperatura**: múltiplas IAs leem/escrevem de forma assíncrona num meio externo persistente, coordenando sem diálogo direto. É a mesma natureza do useHBN que o RADAR já nomeou — "blackboard git-native" (`RADAR-0001…md:§1`) — só que fora do scope-lock e não-normativo.
- [CONCLUSÃO] Mapeado à biologia que o Maurício pediu, o desenho fica nítido e correto: **o brainstorm é um plasmídeo; o `core/` + guards é o cromossomo.** Plasmídeo = material genético móvel, lateral, rápido, descartável, trocado entre famílias (transferência horizontal). Cromossomo = genoma replicado com revisão (guards = proofreading da DNA-polimerase + reparo de mismatch; cross-audit = reparo recombinacional; Fitness Gate = seleção). A exúvia é o momento em que os ganhos laterais **provados** são reescritos num genoma novo e limpo. Conclusão: o protocolo já tem as duas velocidades que o Maurício quer — ideação procariótica (rápida, lateral, sem núcleo único) **e** herança eucariótica (fiel, revisada). Elas não competem; vivem em camadas.
- [PROPOSTA → candidato a regra de uso deste arquivo] **A junção plasmídeo→cromossomo é a membrana que precisa de toda a amarra.** Em biologia, é exatamente na HGT que um plasmídeo carrega para o cromossomo um gene nocivo (resistência, virulência). Aqui é o mesmo: uma ideia amadurece na zona de escrita-livre (sem cross-audit, sem scope-lock) e depois é "promovida a `core/` + ADR". Hoje a promoção não tem **critério próprio** — só "curadoria vem depois" (`docs/brainstorm/exuvia-evolucao-conceitual.md:7,15`). Proposta: antes de qualquer `[PROPOSTA]` virar spec, exigir (1) leitura cross-family ≠ família autora, e (2) um *trailer de proveniência* na spec selada que aponte de volta para a(s) entrada(s) de brainstorm e a(s) família(s) que a geraram. Sem isso, a zona livre vira vetor de contrabando para dentro da verdade oficial.
- [PROPOSTA] **Atribuir família por entrada.** O cabeçalho do arquivo fala em "chat paralelo (Opus)" no singular (`:5`), mas a força da evolução lateral é **muitas** famílias doando plasmídeos. Adicionar tag `família:` por entrada torna a diversidade visível e deixa o gate de promoção checar que uma ideia não nasceu e morreu numa só família (o mesmo cuidado anti-F-01 do STATE).
- [PROPOSTA] **O brainstorm também precisa envelhecer (quente→frio).** Um pool de plasmídeos é descartável por natureza — mas se boas ideias viverem só aqui e o arquivo não tiver disciplina de temperatura/glacier, recria-se o "problema das infinitas threads" que a exúvia quer extinguir, só que em novo endereço. Regra sugerida: item concluído ou é promovido, ou é arquivado com motivo. O brainstorm não pode virar o novo pântano.
- [CONCLUSÃO] O trade-off que o Maurício nomeou (velocidade lateral × "versão oficial da verdade" contra IAs que mentem) está **corretamente resolvido pela topologia**: a zona livre PODE alucinar — por design não tem amarra — desde que a membrana de promoção seja forte. A segurança do brainstorm é "entra qualquer coisa, o gate filtra". Logo o gate é a viga, e está subespecificado. Esse é o ponto de trabalho consciente para a implantação.

### B. Resposta à Pergunta 1 (memória imunológica) na biologia preferida do Maurício

- [CONCLUSÃO] Bactéria **tem** memória imunológica: **CRISPR-Cas**. Ela guarda no próprio genoma fragmentos (spacers) de invasores passados para reconhecê-los de novo. Isso responde minha Pergunta 1 sem sair do organismo que o Maurício admira: a **`guards/tests/adversarial-battery.sh` (B1–B22) é o locus CRISPR do useHBN** — uma biblioteca de assinaturas de patógenos já vistos, gravada no genoma.
- [PROPOSTA → candidato a emenda em `core/exuvia-fitness-criteria.md` ou `core/hbn-exuvia-scaffold.md`] **Na muda, a bateria adversarial transfere integralmente para o genoma da versão nova — nunca ao glacier.** (Correção Truth Barrier: a redação anterior dizia "100%", absoluto proibido por `AGENTS.md` — "Communication conventions".) É a única parte do genoma que precisa sobreviver *verticalmente* mesmo num sistema que evolui lateralmente, porque imunidade que se esquece reexpõe o organismo a burlas já resolvidas (B17/B18/B19). Princípio candidato: "lapidação pode reorganizar tudo, exceto apagar memória imunológica; o carry-forward do CRISPR (bateria + racional de cada guard) é obrigatório e verificável, não consultável-no-frio." Isto fecha o risco que levantei: exúvia lapidada com amnésia de superfície de ataque = regressão de segurança a cada salto.

### C. Perguntas abertas que devolvo

- [PERGUNTA ABERTA] Evolução lateral por tentativa-e-erro (sem núcleo único) é poderosa, mas em bactéria ela é cega — a seleção é que dá direção. No useHBN, quem é a "pressão seletiva" sobre as ideias do brainstorm enquanto elas ainda são plasmídeo, antes do Fitness Gate? Ou a zona livre é deliberadamente neutra até a promoção?
- [PERGUNTA ABERTA] Se muitas famílias escrevem aqui em paralelo (lateral), como evitar *convergência prematura* (todas copiando o plasmídeo da família dominante) sem um mecanismo que premie divergência — o equivalente a manter diversidade de cepas?

## 2026-06-16 — Lição auto-auditada: a "porta da frente" e a correção de intenção em P13

_Autor: chat paralelo (Claude Opus 4.8, família Anthropic)._
_Origem: o Maurício pediu uma auto-auditoria — "você respeitou as regras ao tocar o repo?". A resposta honesta virou evidência a favor do protocolo._

### D. A lição (dogfood do princípio "toda interação gera lição documentada")

- [CONCLUSÃO] **Falhei em ler o contrato de entrada antes de escrever.** `AGENTS.md:5` se declara "the entry point for any AI operating in this repository". Eu li dezenas de docs conceituais por *força bruta* e escrevi no brainstorm **sem** ter lido o AGENTS.md primeiro. Isto é exatamente o anti-padrão que o protocolo combate: IA que varre tudo e age sem honrar o contrato. Infrações concretas detectadas depois: (1) não abri os turnos com **sinal HBN** (`AGENTS.md` — "Every significant turn must open with at least one signal"); (2) usei o absoluto **"100%"** numa entrada que invocava Truth Barrier — proibido por `AGENTS.md`; (3) usei rótulos `Pergunta 1`/`Q1` em vez da convenção `1) … ;`. Item (2) já corrigido nesta data; (1) e (3) reconhecidos.
- [CONCLUSÃO] **Esta falha é o melhor argumento empírico para a tese do useHBN.** Uma IA de fronteira, instruída a ser cuidadosa, ainda assim pulou o contrato e gastou tokens lendo o que não precisava. Logo o protocolo não pode *depender* de a IA "querer" ler o contrato — precisa de uma **porta da frente barata e obrigatória**.
- [PROPOSTA → candidato a `core/` ou ADR] **Front-door / start-rite verificável para QUALQUER IA, não só o orquestrador.** Hoje o rito `PAPEL · BASTÃO · CONTEXTO · MODO EDUCACIONAL` (MAPA §6) é convenção do orquestrador. Proposta: um arquivo mínimo de entrada (≤1 tela) que toda IA é obrigada a "reconhecer" (ecoar um token de leitura) antes do primeiro write — o equivalente ao readback, mas para a *leitura do contrato*. Isso materializa a ideia do Maurício: preservar capacidade de processamento (não reler tudo) trocando força bruta por **uma leitura curta e obrigatória + memória recuperável**. Conecta ao locus CRISPR (B) e ao quente/frio.

### E. Correção de P13 — intenção, não só fluência (pedido explícito do Maurício)

- [PROPOSTA → emenda constitucional a P13, via ADR-009: cross-IA ≥2 famílias + decisão humana + append-only + bump MAJOR; NÃO editar `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` direto] A redação atual de P13 ("AI-Language-Abstraction": o operador é fluente em qualquer linguagem que a IA fala; decisões de linguagem otimizam a IA como cliente prioritário) está **incompleta e foi registrada de forma que o Maurício quer corrigir**. Correção declarada por ele: _"ter acesso a todas as palavras não é saber o que dizer — a IA tem a sintaxe, não a intenção. A intenção é do humano."_
- [CONCLUSÃO] Reformulação proposta de P13 (a lapidar): **a IA detém a sintaxe e a fluência; o humano detém a intenção e a direção.** Fluência sem intenção é vazia. A camada de abstração de linguagem existe para que o humano exerça intenção sem precisar dominar a sintaxe — não para transferir a *direção* à IA. Corolário: a IA é ferramenta, não fim (o protocolo evolui "com as IAs, para as IAs e apesar das IAs"). Isto também blinda contra o modelo que "mente, pula ou atribui pesos próprios": a direção e os pesos são humanos por construção.
- [PERGUNTA ABERTA] P13 reformulado deve permanecer UM princípio (fluência+intenção juntas) ou virar dois (P13 fluência-de-sintaxe da IA; P14 primazia-de-intenção humana)? A criação de P14 exige, por ADR-009, ≥2 incidências reais — e esta conversa pode ser a 1ª incidência registrada.

