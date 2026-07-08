# Dynamic Workflows, Loops e Skills como arquitetura do processo de evolução do useHBN

> ANÁLISE PRÉVIA — SOMENTE LEITURA, NÃO-NORMATIVA (zona livre, untracked). Esteira de
> Fronteira (Claude Opus 4.8, Anthropic). Nada foi escrito no código; nenhum guard/git
> rodado. Papel: auditar e propor antes da implementação. A decisão de escopo é do
> orquestrador; o Codex implementa depois, sob o rito. Fontes: 3 posts do blog da Anthropic
> (via WebSearch, o fetch direto deu timeout) + 4 subagentes lendo o repo com Truth Barrier.

## 0. Tese em uma linha

Os três primitivos são a **camada de harness/execução** — substrato fagocitável (P8/P9),
não o protocolo. O achado central: o useHBN **já inventou, por conta própria e como
governança enforçada, os mesmos padrões** que a Anthropic empacotou como features. A
oportunidade é adotá-los como **motor da esteira read-only de preparação da Exúvia**,
enquanto a governança (cross-família ≠-fornecedor, gate humano, guards fail-closed,
livro-razão) cavalga por cima e permanece o núcleo **não-automatizável**.

## 1. A convergência — os 6 padrões de Dynamic Workflows já existem no useHBN

Um "harness" é o programa que decide o que a IA lê, quando age e como a saída é checada; um
"workflow" é um harness que a própria IA escreve, orquestrando subagentes. Ele resolve dois
modos de falha: **(a)** a IA declara "feito" com trabalho parcial (o exemplo canônico da
Anthropic: revisão de segurança cobrindo 35 de 50 itens); **(b)** a IA prefere os próprios
achados ao julgar a si mesma. **Esses dois teatros são exatamente os que o useHBN nomeia e
barra.** Mapa (evidência dos subagentes, no disco):

| Padrão (Claude Code) | Mecanismo useHBN equivalente | Evidência |
|---|---|---|
| classify-and-act | RADAR (incorporar/observar/descartar) + severidades BLOQUEADOR/FORTE/MARGINAL | `core/cadence-d.md:50-54` |
| fan-out-and-synthesize | batches de subagentes temáticos read-only + consolidação convergência×divergência | `docs/brainstorm/rodada-2026-06-16/INDEX.md:18-37,59-63`; `core/esteira-pre-transicao.md:14-19` |
| adversarial verification | cross-audit ≠-família (G-DIVERSITY) **+** bateria adversarial mecânica | `core/cadence-d.md:23-34`; `guards/assert-audit-diversity.sh:278-286`; `guards/tests/adversarial-battery.sh:6-16` |
| generate-and-filter | placar dos 8 critérios C-TEST..C-DEBT (SIM/NÃO por mecanismo) | `core/exuvia-fitness-criteria.md:75-96` |
| tournament | Fitness Gate: confronto incumbente × desafiante (champion/challenger) | `core/hbn-exuvia-scaffold.md:13-15`; `core/exuvia-fitness-criteria.md:70-73` |
| loop-until-done | freeze-gate (exit-0 congelável / exit-1 "o que falta") + Fitness Gate bloqueante | `guards/freeze-gate.sh:4-11`; `core/esteira-pre-transicao.md:45-53` |

**O que isso valida:** a resposta correta a "o modelo mente por omissão e se auto-favorece"
**não é um prompt melhor — é estrutura enforçada** (`ORQUESTRADOR-HANDOFF…:19`). A Anthropic
chegou à mesma conclusão parcial (verificação estruturada); o useHBN vai dois eixos além, que
um harness mono-fornecedor não alcança: **diversidade de fornecedor** e **gate humano
criptográfico**.

## 2. Os três primitivos, um a um

### 2.1 Dynamic Workflows → motor da esteira, não substituto do gate
Um workflow dinâmico pode escrever o script de uma **onda de validação de Exúvia** reusando
os padrões: (1) classify-and-act = triagem do inventário (sobrevive / dívida / legado);
(2) fan-out = subagentes temáticos read-only (os temas da esteira) → consolidação; (3)
generate-and-filter = preencher o placar de 8 colunas por mecanismo; (4) adversarial = exigir
linha Bxx BLOQUEADA na bateria; (5) loop-until-done = teste de auto-contenção do genoma em
laço; (6) tournament = Fitness Gate incumbente×desafiante. **Mas o selo fica fora do
workflow:** exige hearback humano + cross-audit ≠-família (`core/hbn-exuvia-scaffold.md:93`).

### 2.2 Loops → o Fitness Gate é o "done" que impede o teatro
O valor do `/goal` é **definir "done" para a IA não parar cedo demais**. O useHBN já fez
isso: trocou opinião por placar — "oito perguntas de SIM ou NÃO que qualquer pessoa confere
olhando o repositório" (`core/exuvia-fitness-criteria.md:39`); a regra de sobrevivência
(`:90-91`) é o predicado booleano de terminação; e o exit code do `freeze-gate.sh:5` é o
sinal binário de done. O `/loop` recorrente mapeia à cadência do RADAR, do dream e do
champion/challenger (`MECANISMO-aptidao-darwinismo-exuvia.md:32-41`). **O guardrail que o
loop puro não tem:** "done" é auto-julgado — pode fazer os "35 de 50" passarem **vazios**
(precedente real de falso-verde: `.hbn/results/20260611-172049-…:109`). O useHBN insere três
cunhas que a IA não controla: exit code rodado por **humano** (`freeze-gate.sh:17`), validação
em **uso real** (`ORQUESTRADOR-HANDOFF…:98-99,130`) e **cross-audit ≠-família**
(`exuvia-fitness-criteria.md:50,81`).

### 2.3 Skills → a unidade de encapsulamento que falta, governada por árvore
Uma skill (pasta: instruções + scripts + recursos; description = **quando acionar**, não
resumo; cresce com edge cases) é quase 1:1 com um **mecanismo useHBN** (spec `.md` + guard
`.sh` + testes + burla adversarial) — `guards/README.md:2` já chama o conjunto de "conjunto
executável de governança". O `description=trigger` já existe como **role-cards / front-door**
(`core/role-cards.md:14-32`) e âncoras semânticas (`skills/hbn/SKILL.md:6-14`). "Skills crescem
com edge cases" é **literalmente** a `adversarial-battery` que ganha um Bxx a cada burla nova
(`adversarial-battery.sh:2-16`; hoje B1→B54+). **A tensão de governança:** skill que "só
cresce" por edição livre burla P2/P4 e os guards de escopo. **Resolução (do subagente):** skills
de governança são **artefatos governados** — nascem `fronteira` (crescer é livre e barato),
sobem de árvore **só por evento append-only + 8 critérios + cross-audit ≠-família + hearback**
(`core/arvores-spec.md:44-63`). Crescer é livre; **enrijecer é ritualizado.**

## 3. Como organizar o PROCESSO DE PENSAMENTO das IAs na validação/preparação da Exúvia

Este é o coração do pedido. A proposta é dar à IA um **harness explícito** (o workflow) que
force cobertura e verificação, com os pontos de família-diversa e gate-humano **marcados como
não-automatizáveis**. Um "pensamento estruturado" para a Exúvia, passo a passo:

1. **Triar (classify-and-act):** varrer o candidato-a-genoma; rotular cada mecanismo
   `candidato-a-sobreviver / dívida-C-DEBT / legado-read-only`. Distinção CRISPR:
   casca→glacier vs imunidade→genoma novo. — *automatizável (leitura).*
2. **Cobrir (fan-out-and-synthesize):** N subagentes temáticos read-only, um relatório cada,
   citando arquivo:linha; consolidador tabula convergência×divergência; **ausência de tema =
   bloqueio** (mata o "35 de 50"). — *automatizável (leitura), Anthropic OK aqui.*
3. **Filtrar (generate-and-filter):** placar de 8 colunas por mecanismo; descarta quem não
   fecha 7-de-7. — *automatizável para as colunas mecânicas (C-TEST/C-ADV/C-FCLOSE/C-NOREG).*
4. **Atacar (adversarial):** cada mecanismo sobrevivente precisa de burla Bxx BLOQUEADA;
   bateria transferida integralmente (memória imunológica). — *automatizável (mecânico).*
5. **Fechar (loop-until-done):** teste de auto-contenção do genoma em laço até zero ponteiros
   ao legado, no formato exit-1 "o que falta". — *automatizável (verificável no disco).*
6. **Confrontar (tournament):** Fitness Gate incumbente×desafiante em testes reais. —
   **NÃO automatizável sozinho: exige uso real + julgamento.**
7. **Ratificar e selar:** cross-audit ≠-família (Gemini/Codex/Grok reais) + hearback humano +
   freeze com exit code no Terminal. — **NÃO automatizável: núcleo humano + ≠-fornecedor.**

A regra de corte (do subagente de loops) é a mesma que o spec já usa: delegue ao loop o que é
**mecanicamente verificável no disco**; mantenha sob humano/≠-família o que exige **julgamento
sobre uso real ou aprovação de outra família** — exatamente a fronteira C-TEST/C-ADV/C-FCLOSE/
C-NOREG (iterável) × C-XAUDIT/C-TRACE (requer humano) de `exuvia-fitness-criteria.md:94-96`.

## 4. As três camadas — onde cada primitivo se encaixa (P8/P9)

A VISÃO já define a estratificação e nomeia o Claude Code como **substrato**, não governança
(`VISAO-hbn-governanca-automatizada-sobre-substratos.md:26-28`):
- **Governança epistêmica (permanente, cavalga por cima):** constituição P1–P13, cross-família,
  guards fail-closed, livro-razão, readback/hearback. Responde "o que é onda válida e como
  sabemos que é verdade".
- **Harness/execução (fagocitável):** **Dynamic Workflows** = o runner que abre sessões limpas
  e roteia; **Loops** = o laço de execução do passo; **Skills** = adapters/scaffold reutilizável
  (mesma categoria que o repo já trata como Runtime Adapters intercambiáveis,
  `methodology/MATURITY-MATRIX.md:67`).
- **Verdade (git + guards):** o backstop fail-closed, mesmo se a automação falhar
  (`VISAO…:24-25`).

Regra dura: cada primitivo entra como **ficha no Radar com critério de saída (P9)**, nunca como
premissa arquitetural. Se sumir, a governança fica intacta.

## 5. Limitações e a linha dura — o que NÃO automatizar

- **Quebra do cross-família:** um workflow que faz fan-out para subagentes Claude é
  **Anthropic-sobre-Anthropic**. O G-DIVERSITY computa famílias distintas ≠-implementador e
  **bloqueia** com só uma (`guards/assert-audit-diversity.sh:278-286`;
  `guards/data/auditor-families.txt:2-3` colapsa opus/claude→Anthropic). O projeto **já
  ratificou isso como limite de desenho, não defeito**
  (`docs/brainstorm/exuvia-evolucao-conceitual.md:133`). Adversarial-verification entre clones
  da mesma família **é teatro**. A diversidade ≠-fornecedor (Gemini/Codex/Grok reais) precisa
  ser **injetada manualmente** no C-XAUDIT e na selagem.
- **Teatro automatizado:** loop-until-done com "done" auto-julgado declara conclusão sem o
  artefato que a prova. Barrado pela checklist de honestidade (`ORQUESTRADOR-HANDOFF…:129-132`).
- **Reserva de P5 (nunca automatizar):** hearback humano; escolha de exúvia e a decisão (a)/(b)
  do V207 (com dados reais de uso, `:126`); promoção a `estavel` / mudança de árvore; cross-audit
  ≠-família; aprovação da `files_allowed` exata (auto-emenda proibida, B16); mudança
  constitucional P1–P13; `main`/merge/token.
- **Pode automatizar com segurança (a automação propõe; o git dispõe):** fan-out de **leitura**
  (a Esteira de Pré-Transição já é isso, `core/esteira-pre-transicao.md:14-15`); geração de
  rascunho/despacho; **loops de test-fixing cujo "done" = exit-code de guard**, não prosa.
- **Lock-in (P9):** se o processo depender da *forma* Claude Code e a feature mudar, evapora.
  Mitigação: a fonte da verdade é **git+guards** (agnósticos de vendor); o rito é **textual** e
  vive em `core/` (reexecutável 100% manual — Fase 0 da VISÃO); cada primitivo entra com
  **critério de saída** e vira ficha `archived` se descontinuado; transporte inter-família por
  **A2A** (padrão aberto), não API proprietária. Teste de sobrevivência antes de adotar: "se
  isto sumir amanhã, o useHBN sobrevive sem reescrita massiva?".

## 6. Caminho de incorporação faseado (fagocitose + critério de saída)

Adotar pela própria doutrina de Fagocitose (routed→studied→digested→mastered→contributed),
cada estágio com artefato verificável e critério de saída:
1. **Routed:** registrar os 3 primitivos como fichas no RADAR/CONVERGENCE-MATRIX, cada uma com
   "critério de saída documentado" (P9). Sem código.
2. **Studied:** um piloto **read-only** — usar um Dynamic Workflow para orquestrar a próxima
   esteira de pré-transição (fan-out temático), medindo se reduz atrito sem tocar governança.
3. **Digested:** encapsular **um** rito já estável como skill co-localizada (candidato:
   `skill-de-honestidade/anti-teatro` — Truth Barrier), rotulada `fronteira`, evoluindo por
   evento governado.
4. **Mastered:** loops de test-fixing com "done"=guard verde entram no ciclo de estabilização
   (não na exúvia real), com a linha dura da seção 5 respeitada.
5. **Contributed:** só depois de provado em uso real, propor à comunidade — sempre com o
   humano no gate e o processo expressável fora do Claude Code.

## 7. Propostas concretas (insumo para o orquestrador decidir; Codex implementa depois)

- **Workflow-como-motor-da-esteira:** adotar o script de 7 passos da seção 3 como a forma
  canônica de uma onda de validação de Exúvia, com os passos 6–7 marcados "gate humano +
  ≠-família".
- **Taxonomia de skills de governança** (co-localizar ritos dispersos, cada um com rótulo de
  árvore): `skill-de-exuvia` (placar 8 col.), `skill-de-cross-audit` (≥2 famílias ≠), `skill-de-
  freeze-gate`, `skill-de-numeracao`, `skill-de-front-door`, `skill-de-honestidade/anti-teatro`,
  `skill-de-rollback`. Cada uma nasce `fronteira`; sobe por evento append-only + 8 critérios +
  cross-audit + hearback.
- **Candidatos a loop-until-done** (verificáveis por guard): transferência íntegra da bateria
  adversarial; fechamento de C-DEBT; C-TEST/C-FCLOSE por mecanismo; teste de auto-contenção do
  genoma. **NÃO** loop: Fitness Gate, C-XAUDIT, promoção dream, freeze, decisão V207.
- **Guardrail obrigatório em qualquer adoção:** "done" sempre amarrado a exit-code de guard;
  cross-audit sempre por famílias ≠-fornecedor reais; hearback humano preservado.

## 8. Encaminhamento

Insumo de Fronteira, não-normativo. Recomendo ao orquestrador: (1) registrar os 3 primitivos
como fichas de RADAR com critério de saída (P9) — passo mais barato e mais seguro; (2) avaliar
o piloto read-only da seção 6.2 (workflow orquestrando a esteira) como candidato a onda; (3)
tratar a taxonomia de skills como trabalho de **pós-exúvia** (co-localizar ritos já provados),
não pré-freeze. Nada normativo até uma onda governada, com cross-audit ≠-família e hearback do
Maurício. A linha que atravessa tudo: **a ferramenta muda; o protocolo permanece** — os
primitivos são o harness que faltava para automatizar a preparação, mas o cross-família e o
humano continuam a fronteira que nenhum harness mono-fornecedor fecha.
