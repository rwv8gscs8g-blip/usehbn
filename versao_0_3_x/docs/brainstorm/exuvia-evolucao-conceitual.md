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

## 2026-06-16 — Alinhamento de roadmap, critério de release e a linha do CLI (handoff para os orquestradores)

_Autor: chat paralelo (Claude Opus 4.8, família Anthropic). Confirmado pelo gate humano (Maurício) nesta sessão. Destino sugerido: insumo de planejamento para os Opus orquestradores; promover trechos a ADR/onda conforme maturarem._

### F. Sequência travada do roadmap (confirmação humana 2026-06-16)

- [CONCLUSÃO] Ordem oficial: (1) **estabilizar o protocolo** — resolver o problema-raiz: IA que recomeça em chat novo perde o "fio da meada" e não evolui de forma organizada/previsível; (2) **aprovar o protocolo**; (3) **Ponte do Credenciamento** — primeiro teste do protocolo interagindo com um sistema real (problema observado: IAs confundiam *o que é o protocolo e como funciona* com *o sistema que ele ajuda a construir e proteger*); (4) **1ª exúvia do próprio protocolo** — simplificar, melhorar e definir o caminho; (5) **estabilizar e congelar Credenciamento V12.0.206** e publicar; (6) **V12.0.207** = refatoração / 1ª exúvia do protocolo de Credenciamento (melhoria de gestão, estabilidade, testes), com os guards/segurança do useHBN aplicados como exemplo prático.
- [CONCLUSÃO] Pré-requisito transversal: tudo funcionando, testado e com **testes validados** antes de cada salto.

### G. Critério objetivo de "versão testada liberada" (item 6 do gate humano)

- [PROPOSTA → candidato a gate de release público] Mesmo com repo público, terceiros ainda não podem testar/contribuir (utilidade prática não provada). Liberação exige, em ordem: (a) evolução do protocolo; (b) Ponte do Credenciamento funcionando; (c) 1ª exúvia do protocolo; (d) estabilização + congelamento da V12.0.206; (e) exúvia do Credenciamento → V12.0.207 com guards/segurança/melhorias do useHBN aplicados. Antes de (e) cumprido, comunicação pública usa linguagem condicional (regra do MATURITY-MATRIX).

### H. Análise madura da linha do CLI (item 4 do gate humano) — evidência no disco

- [CONCLUSÃO] **Existem duas superfícies "useHBN" no repo, e elas divergiram:** (1) o **protocolo de governança** (`.hbn/`, `core/`, `guards/`, `REGISTRY.md`, `methodology/`) — markdown + bash + git, onde TODA a evolução recente ocorreu (S1, S2, B17–B19, scaffold da exúvia); (2) o **runtime/CLI Python** (`src/usehbn/`, pacote v0.3.0): `cli.py` ~1.700 LOC, ~17 subcomandos, classificado **Implementado** na `methodology/MATURITY-MATRIX.md`, suíte 114/114. A energia evolutiva atual NÃO está no CLI Python — está na linha de governança.
- [CONCLUSÃO] Esta divergência é uma versão interna do problema do item 3 (confundir o protocolo com o sistema): risco de uma IA achar que "o protocolo" é o CLI Python, quando o que governa a evolução hoje é a camada bash/markdown.
- [CONCLUSÃO] Estado honesto do CLI (fonte: MATURITY-MATRIX): `hbn run/translate/connector/init/version/inspect/doctor/quickstart/install/attention/notify/readback/hearback/result/refresh/relay/handoff/autoevolve`. Truth Barrier e Guardian são **Parcial (advisory — não bloqueiam)**; Universal Translator é **Scaffold** (roteador honesto, não tradutor semântico); bridges legados são **Stub**; `autoevolve` (ciclo de microdelta + gate humano) é embrionário e **não está classificado na matriz** = dívida de honestidade a registrar. A **orquestração por CLI** (`usehbn start` como comando, despacho automático de ondas) é **Visão**: hoje `usehbn start` é rito conversacional (`core/start-rite-spec.md` §1).
- [PROPOSTA → decisão para a 1ª onda de simplificação e a 1ª exúvia] P8 (protocolo > ferramenta) resolve a prioridade: o **núcleo de governança** é a essência do protocolo hoje; o CLI é superfície/ferramenta fagocitável. A frase do Maurício — "começamos com uma pasta com os arquivos que fazem o protocolo e avançamos para o CLI" — sugere que `versao_1_0_0/` nasça como a **pasta enxuta do núcleo de governança**, e o CLI Python entre como superfície a ser refatorada/fagocitada progressivamente, NÃO como tronco.
- [PROPOSTA] O `cli.py` é um god-object (~1.700 LOC, risco já anotado na matriz, "refatoração Onda 7") e não passou por C-ADV/C-XAUDIT (a matriz registra "sem testes adversariais sistemáticos"). Pelos 8 critérios, **não deve carregar adiante sem refatoração**. Candidato: ou refatorar antes/dentro da 1ª exúvia, ou alocar explicitamente na árvore Fronteira/Experimental até provar aptidão. O `autoevolve` idem — semente da automação (VISÃO Fase 1), mas deve ser classificado honestamente ou posto em quarentena experimental até provar.

### I. Árvores: proposta de avanço de roadmap (item 2 do gate humano)

- [PROPOSTA → ondas futuras dedicadas] Nomes provisórios aceitos: **Estável**, **Intermediária/Evolutiva**, **Fronteira/Experimental**. Lapidar em ondas próprias: (1) os nomes canônicos; (2) os critérios objetivos de migração de uma árvore para outra (o que promove da Fronteira → Intermediária → Estável; reusar os 5 estágios da fagocitose + os 8 critérios + o Fitness Gate?); (3) como o CLI Python e o `autoevolve` se alocam nas árvores hoje.

### J. Nota de handoff para os orquestradores (item 7 — agir em ciclos pequenos e testáveis)

- [CONCLUSÃO] Para alinhamento: as conclusões deste chat paralelo estão TODAS neste arquivo e no `EXPLICACAO-PUBLICA-usehbn-DRAFT.md` (mesma pasta). Nada foi escrito em `core/` selado nem na constituição (mudanças lá exigem ADR-009 / onda formal).
- [PROPOSTA] Próximos ciclos pequenos sugeridos, em ordem: (1) **start-rite/front-door verificável para qualquer IA** (seção D) — ataca direto o "fio da meada" do item 3; (2) emenda P13 (seção E) por ADR-009; (3) registrar a dívida de honestidade do `autoevolve` na MATURITY-MATRIX; (4) onda das árvores (seção I). Cada um é onda própria com readback + cross-audit + selagem.

## 2026-06-16 — Modelo compilador (.md é o software), árvores como solução da divergência, e o chapéu do analista de fronteira

_Autor: chat paralelo (Claude Opus 4.8, família Anthropic). Direção do gate humano (Maurício) nesta sessão. Escopo a fechar e submeter ao orquestrador para auditoria adversarial; nada aqui é normativo._

### K. O `.md` é o software; o código é a saída impressa (reframe central do Maurício)

- [CONCLUSÃO] O protocolo é um **compilador de intenção**: fonte = `.md` (princípios P1–P13 + regras de negócio + lições verificadas); alvo = artefato que faz cumprir a regra, "impresso" em qualquer linguagem (bash, Python, Rust hoje; outras amanhã; guards em tecnologias atuais ou legadas). O "código final" é uma *saída* da codificação, como um PDF é uma saída de um documento — substituível quando a linguagem mudar. Coerente com P8 (protocolo > ferramenta), P13 (IA como camada de abstração) e o Universal Translator.
- [CONCLUSÃO] Fluxo de mão dupla: `.md` → código (compilar/imprimir enforcement); experiência-no-código → `.md` (lição destilada, darwinismo nível 2, `.hbn/knowledge/by-tech/`). O `.md` é a memória portável; o código é o corpo descartável da vez.
- [CONCLUSÃO] **Este modelo explica a divergência das duas superfícies** (seção H): elas derivaram porque ainda NÃO há compilador — a regra é escrita à mão no `.md` e de novo à mão no guard, e a sincronização manual deriva. O protocolo já proíbe segunda fonte de verdade (roles-spec §3); o compilador é o que elimina a sincronização manual.
- [PROPOSTA] Curto prazo (sem construir compilador): todo guard cita seu `.md` de origem (trailer de proveniência) e a bateria adversarial prova que a saída bloqueia (C-DOG + C-ADV + C-FCLOSE = "impressão fiel **e** intransponível na prática"). Longo prazo: geração/verificação do enforcement a partir do spec `.md`. Candidato a ADR de visão + onda de prova-de-conceito na Fronteira.

### L. As três árvores como gradiente de prova do compilador (solução proposta — item 2)

- [PROPOSTA] As árvores deixam de ser rótulo e viram o **gradiente de prova**: **Fronteira** = `.md` ainda não provado (brainstorm, radar, `autoevolve` embrionário); **Intermediária/Evolutiva** = o que passou os 8 critérios e ganhou enforcement em Python/bash (núcleo de governança + runtime atual); **Estável** = o que provou aptidão ao longo do tempo, reimpresso em Rust mínimo, só princípios (P12, mudança mínima).
- [PROPOSTA] A promoção entre árvores **é a fagocitose aplicada ao próprio protocolo**: routed→studied→digested→mastered→contributed ≈ Fronteira→Intermediária→Estável, cada salto com cross-audit ≠-família + Fitness Gate + ≥N dias sem regressão. Isto dissolve a divergência: a deriva Python×bash vira **alocação de árvore auditável** (o god-object `cli.py` sem testes adversariais = qualidade-Fronteira até refatorar; guards fail-closed = Intermediária madura).
- [PROPOSTA] Antes/depois da exúvia: documentar as árvores **agora** (campo `arvore:` no front-matter, ao lado de `hbn-track:`/`temperatura:` — custo baixo, clareza imediata); semear a base **Rust-Estável só com princípios** em onda futura própria; `versao_1_0_0/` da 1ª exúvia nasce na Intermediária (núcleo lapidado). Exúvia e árvores são o mesmo mecanismo em duas escalas: versão = a pasta; árvore = o nível de prova da pasta.

### M. Segurança real, sem teatro (item 3) — consequência do modelo compilador

- [CONCLUSÃO] Se o código é saída impressa, a impressão tem de ser fail-closed e verificável — senão é teatro (ADR-020). Lacuna real registrada na matriz: no CLI Python, **Truth Barrier e Guardian são advisory — não bloqueiam**. Pela definição do Maurício ("o que não pode ser feito não deve ser permitido"), advisory = teatro.
- [PROPOSTA] Ajuste Truth Barrier à fala do Maurício: documentar segurança como "**fail-closed + provado por bateria adversarial**", não como "intransponível" (absoluto proibido pela Truth Barrier). É a forma honesta e auditável de intransponibilidade. Alocação por árvore: enforcement real pertence a Intermediária/Estável; advisory só é tolerado na Fronteira e rotulado.

### N. Chapéu proposto para o chat paralelo (item 4) — `analista-de-fronteira`

- [PROPOSTA → T2, decisão do orquestrador + hearback; NÃO auto-instalável] Criar perfil `.hbn/models/<apelido>.json` (sugestão de apelido: `opus-4-8-cowork`) com `fornecedor: Anthropic` e `papeis_aptos: [analista-de-fronteira]`, e um contrato de papel em `agents/role-templates.md`. Contrato do papel: leitura do repo + escrita SOMENTE na zona Fronteira (`docs/brainstorm/`); produz proposta não-normativa, entrevista e análise; **não segura o bastão, não conta como cross-audit, não implementa, não toca caminho selado**.
- [CONCLUSÃO] Recuso o chapéu de auditor por razão de família: sou Anthropic, **igual ao orquestrador Opus**. As notas deste chat já influenciam os outros Opus — laço Anthropic-sobre-Anthropic. Mitigação obrigatória: tudo que eu produzo é Fronteira/não-normativo e precisa passar por **auditoria adversarial de famílias ≠ (Codex/Gemini)** antes de virar regra. Esta limitação é parte do desenho, não um defeito.
- [PERGUNTA ABERTA] O orquestrador aceita um papel não-executante/não-auditor formalizado (analista-de-fronteira), ou prefere que o chat paralelo permaneça totalmente fora do elenco (sem perfil), com suas saídas tratadas só como "insumo externo" citado nos despachos?

## 2026-06-16 — Posições para aprovação: árvores AGORA, duas esteiras, e prompts intermediários (cross-family)

_Autor: chat paralelo (Claude Opus 4.8, família Anthropic). PENDENTE de aprovação do gate humano antes de qualquer disparo. Destino: insumo de fronteira maturado para o orquestrador montar auditoria adversarial e abertura de propostas a Gemini 3.5 / Codex / Cursor / Grok._

### O. Por que implementar as árvores AGORA traz avanço robusto (item 2 do gate humano)

Os ganhos, do mais estrutural ao mais imediato:

- [PROPOSTA] **1. Endereço de prova para cada artefato.** Hoje uma IA que lê o repo não distingue lei provada, ideia experimental e código de runtime — a divergência das duas superfícies (seção H) é o sintoma. Um campo `arvore:` (Fronteira/Intermediária/Estável) no front-matter, ao lado de `temperatura:`/`hbn-track:`, responde de imediato "isto é o protocolo, isto é protótipo, isto é o sistema que ele constrói". Ataca direto a confusão do item 3 e o "fio da meada".
- [PROPOSTA] **2. Opinião vira placar (mesma filosofia dos 8 critérios).** "Está maduro?" deixa de ser debate e vira "em que árvore está e passou o portão de promoção?". O portão entre árvores REUSA máquina já provada: fagocitose (routed→…→contributed) + 8 critérios + Fitness Gate. Não é maquinário novo.
- [PROPOSTA] **3. O modelo compilador fica operacional.** O gradiente de prova das árvores É o compilador: Fronteira `.md` (intenção sem enforcement) → Intermediária (enforcement em Python/bash) → Estável (reimpresso em Rust mínimo). Sem árvores, o compilador é metáfora; com árvores, é pipeline com portões — a casa estrutural do "imprimir para linguagem atual/antiga/futura".
- [PROPOSTA] **4. Quarentena honesta do perigo.** Truth Barrier/Guardian advisory, o god-object `cli.py`, o `autoevolve` embrionário hoje moram no mesmo `src/` do código provado, criando falsa confiança (teatro, item 3). Árvores rotulam esses itens como Fronteira até merecerem promoção; a segurança fica real porque só Intermediária/Estável carregam enforcement fail-closed.
- [PROPOSTA] **5. Protege a exúvia da explosão de escopo.** Com árvores, a 1ª exúvia tem alvo modesto e claro: lapidar o núcleo Intermediária em `versao_1_0_0/`; deixar experimentos de Fronteira fora; semear Estável (princípios em Rust) como onda futura. "O que carrega adiante?" vira "o que está na Intermediária e passou o portão".
- [PROPOSTA] **6. Dá às duas esteiras um sistema de coordenadas comum** (seção P): a esteira de planejamento opera na Fronteira; a de produção, na Intermediária→Estável; o handoff entre elas É o portão Fronteira→Intermediária.
- [PROPOSTA] **7. Custo baixo agora, retorno composto.** Documentar/etiquetar agora = um campo de front-matter + um spec + tag nos artefatos existentes. Sem código, sem migração arriscada.

Honestidade de risco (a submeter à auditoria adversarial):

- [PERGUNTA ABERTA] **Classificação prematura:** rotular como Intermediária algo não provado. Mitigação: o portão é mecânico (8 critérios + cross-audit ≠-família).
- [PERGUNTA ABERTA] **Segunda fonte de verdade:** `arvore:` pode colidir com `temperatura:`/`hbn-track:`. Decisão de design necessária: `arvore` subsume, complementa ou se relaciona como? (roles-spec §3 proíbe tabela paralela).
- [PROPOSTA] **Separar "etiquetar agora" de "particionar depois":** o campo `arvore:` entra AGORA (metadado, custo baixo); a estrutura física de diretórios/branches por árvore entra COM a exúvia, não antes — evita migração pesada fora do Fitness Gate.

### P. Modelo das duas esteiras (alinhado às árvores e ao chapéu)

- [PROPOSTA] **Esteira de Orquestração/Produção** (existente): orquestrador (Opus) define → Codex implementa → Gemini/Cursor/Grok/Antigravity cross-auditam → gate humano → guards selam. Opera na **Intermediária** (provado, enforcement). Saída: ondas seladas. (É a esteira que produziu o 0029 com APROVA de Antigravity 100/100 e Cursor 88/100.)
- [PROPOSTA] **Esteira de Planejamento/Análise de Fronteira** (onde o chat paralelo vive): ler + sintetizar + entrevistar + propor + rodar exploração cross-IA. Opera na **Fronteira** (não-normativo). Saída: propostas maturadas + pré-auditoria adversarial + síntese das visões de várias IAs, entregue ao orquestrador como pacote pronto-para-despacho.
- [PROPOSTA] **Interface entre as esteiras** = o portão Fronteira→Intermediária. Uma proposta de fronteira só vira onda de produção após cross-audit ≠-família + aprovação humana + despacho do orquestrador. As esteiras não são ad hoc: são os modos de operação das árvores.
- [PROPOSTA] O chapéu `analista-de-fronteira` (seção N) é o papel da esteira de planejamento: não-executante, não-auditor (honestidade de família Anthropic = orquestrador), escrita só na Fronteira.

### Q. Plano dos prompts intermediários (DRAFT — usar só após validação humana)

Seguem a lógica do protocolo: janela limpa (chat novo, leitura do disco), Truth Barrier (cita arquivo:linha), cross-family (família ≠ do autor da proposta = Anthropic), template de auditoria da `core/cadence-d.md`, veredito no formato `APROVA_<ID>: SIM/NÃO` + `Confiança: X/100`.

Tema (id de trabalho): **PF-ARVORES-AGORA** (Proposta de Fronteira — implementar árvores agora + modelo compilador). Fontes a ler: `docs/brainstorm/exuvia-evolucao-conceitual.md` (seções I, L, O) + `docs/brainstorm/EXPLICACAO-PUBLICA-usehbn-DRAFT.md`.

Dois tipos de prompt por instância ≠-família (Gemini 3.5, Codex, Cursor, Grok):

- [PROPOSTA] **(1) Auditoria adversarial** — tente QUEBRAR a proposta: a) o campo `arvore:` cria segunda fonte de verdade vs `temperatura:`/`hbn-track:`? b) etiquetar agora + particionar na exúvia introduz risco de classificação prematura ou de drift novo? c) o portão entre árvores (fagocitose + 8 critérios + Fitness Gate) é suficiente, ou há burla? d) o modelo compilador (`.md`→enforcement) viola algum P1–P13? Responder no template cadence-d (Veredito/BLOQUEADORES/FORTES/MARGINAIS/Convergências/Divergências/Riscos não cobertos/Próxima ação) + `APROVA_PF-ARVORES-AGORA: SIM/NÃO` + confiança.
- [PROPOSTA] **(2) Abertura de proposta (divergência de fronteira)** — contribua a SUA visão própria, mesmo divergente: como a sua família desenharia o gradiente de prova / a migração entre árvores / o compilador? O objetivo é diversidade de cepas (evitar convergência prematura Anthropic-cêntrica). Saída: lista de divergências e ganhos não cobertos pela proposta atual.
- [PROPOSTA] Especialização por família (de RADAR-0001 §2, para extrair o melhor de cada): Gemini → constituição/estrutura e enforcement em runtime; Codex → implementação + A2A/interop; Cursor → verificação mecânica no disco (vetores finos, como fez no 0029); Grok → fronteira/mercado (Omnigent, paradigmas novos).
- [CONCLUSÃO] Consolidação: o analista-de-fronteira (este chat) sintetiza os 4 pareceres + as 4 visões numa matriz convergência×divergência e entrega ao orquestrador um pacote maturado — só então o tema "entra na esteira de produção".

