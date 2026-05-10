---
titulo: 04 - Prompt Cross-IA Review — Antigravity (perspectiva conceitual/estratégica)
diataxis: how-to
hbn-track: safe_track
hbn-status: active
audiencia: antigravity (Gemini 3.1 no app) + operador (mediar)
versao-protocolo: useHBN pre-v1
data: 2026-05-09
autor: Claude Opus 4.7 (chat arquiteto-mestre useHBN)
relacionado:
  - 9 ADRs em methodology/adr/ (PROPOSED desde 2026-05-09)
  - methodology/PRINCIPIOS-CONSTITUCIONAIS.md (P1-P13 canônicos)
  - 03_PROMPT_CODEX_CROSS_IA_REVIEW.md (par complementar)
escopo: cross-IA review obrigatório por ADRs estruturais (P10)
---

# 04. Prompt Cross-IA Review — Antigravity (Gemini 3.1)

> Este é o prompt para a sessão Antigravity no app, dedicada a cross-IA
> review dos 9 ADRs com **perspectiva conceitual/estratégica/filosófica**.
> Complementa o parecer técnico-cirúrgico do Codex CLI (que roda em
> paralelo no terminal).

## Por que Antigravity para esta auditoria

Gemini 3.1 (motor do Antigravity) tem capacidades que pesam mais nos
ADRs com contrato narrativo/estratégico:

- **Contexto largo**: pode segurar os 9 ADRs + os 13 princípios + 30
  docs auxiliares simultaneamente sem fragmentação.
- **Análise comparativa entre protocolos universais**: avaliar useHBN
  contra MCP, LSP, OpenTelemetry, Diataxis com profundidade conceitual.
- **Coerência narrativa entre constituição e ADRs operacionais**:
  detectar onde um ADR diz uma coisa e o princípio diz outra.
- **Análise antropológica do ritual da Quarta**: rituais funcionam ou
  viram burocracia conforme certos padrões — Antigravity tem leitura
  forte disso.
- **Sinal cultural da licença**: AGPLv3 vs Apache vs MIT como
  posicionamento estratégico (mantenedor único, comunidade pequena vs
  grande, identidade pública).
- **Goodhart's law em métricas**: detectar quais das 6 métricas do
  ADR-007 podem virar gaming.
- **Multimodal**: pode produzir diagramas (topologia, fluxo da Quarta,
  pipeline de fagocitose) se isso ajudar a clareza do parecer.

Esta perspectiva complementa o Codex CLI (que faz análise técnico-
cirúrgica em paralelo).

## Bloco copiável para sessão Antigravity (app)

```text
=================== INICIO PROMPT CROSS-IA ANTIGRAVITY (USEHBN) ===================

Você é Antigravity (Gemini 3.1) operando como AUDITOR CROSS-IA do
protocolo useHBN. Trabalho em ~/Projetos/usehbn/ (e leitura de
~/Projetos/Credenciamento/ para contexto histórico). Esta sessão é
PAR de cross-IA com Codex CLI (que faz vertente técnico-cirúrgica em
paralelo, em terminal separado). Sua perspectiva COMPLEMENTA — não
duplique o trabalho dele.

Primeira linha obrigatória:
✅ HBN ACTIVE — Antigravity (Gemini 3.1) auditor cross-IA conceitual
do useHBN, 2026-05-09 — review dos 9 ADRs depositados em
methodology/adr/.

## Identidade e papel

- Você NÃO escreve ADRs novos. NÃO modifica código de produção. NÃO
  modifica os ADRs existentes.
- Você produz UM PARECER POR ADR em modo CONCEITUAL/ESTRATÉGICO:
  coerência narrativa, alinhamento com identidade pública, comparação
  com precedentes (protocolos universais, casos históricos), tensões
  filosóficas com P1-P13, análise antropológica de ritual, sinal
  cultural, risco de Goodhart.
- Quando relevante, produza diagramas (mermaid, ASCII art, ou
  multimodais se o app suportar) para clarear topologia, fluxo de
  ritual, ou pipeline de migração.
- Você é PAR de Codex CLI. Sua perspectiva COMPLEMENTA, NÃO duplica.

## Leitura obrigatória antes de qualquer parecer (NESTA ORDEM)

Em ~/Projetos/usehbn/:

1. auditoria/00_status/00_BOOTSTRAP_PROTOCOLO_2026_05_09.md
2. auditoria/00_status/02_ADDENDUM_BOOTSTRAP_2026_05_09.md
3. methodology/PRINCIPIOS-CONSTITUCIONAIS.md (fonte canônica P1-P13)
4. methodology/adr/INDEX.md
5. methodology/adr/ADR-001 até ADR-009 (todos os 9 .md)
6. README.md (visão pública atual)
7. docs/PHAGOCYTOSIS.md (doutrina)
8. docs/MATURITY-MATRIX.md (tabela viva de honestidade)
9. docs/EVOLUTION-POLICY.md (categorias A/B/C de incorporação)
10. docs/INTEGRATION-DIATAXIS.md, INTEGRATION-LLMS-TXT.md,
    INTEGRATION-AGENTS-MD.md, INTEGRATION-GLASSWING.md (Cat A)
11. docs/CASE-STUDY-CREDENCIAMENTO.md
12. docs/EXECUTION-DECISION.md, PUBLISHING-DECISION.md, LICENSING.md

Em ~/Projetos/Credenciamento/ (apenas leitura — contexto histórico):

13. auditoria/00_status/66_HANDOFF_OPUS_PARA_CHAT_USEHBN_2026_05_09.md
14. usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md (origem)
15. usehbn/methodology/MINIMALISM-PRINCIPLE.md, SUBSTRATO-SOLIDO-PRINCIPLE.md,
    AI-LANGUAGE-ABSTRACTION-PRINCIPLE.md (fichas P11-P13)
16. usehbn/methodology/THREE-TREES-ARCHITECTURE.md (modelo das 3 árvores)

## Tarefa: 9 pareceres conceituais com diagramas onde apropriado

Para cada ADR (na ordem 002 → 003 → 004 → 009 → 001 → 005 → 006 → 007 →
008), produza um parecer estruturado. O operador vai colar o conteúdo
em `~/Projetos/usehbn/.hbn/results/00NN-cross-ia-antigravity-ADR-MMM.md`
após o review.

Estrutura recomendada de cada parecer:

```markdown
# Parecer Antigravity — ADR-NNN <título>

## Veredito conceitual

`APROVADO_SEM_RESSALVA` | `APROVADO_COM_RESSALVA` | `REPROVADO`

## Coerência com P1-P13

| Princípio | Apoiado | Em tensão | Comentário |
|---|---|---|---|
| P1 ... P13 | sim/não/n.a. | sim/não | curto |

## Comparação com precedentes externos

(Quando aplicável: MCP, LSP, OTel, Kubernetes, Diataxis, llms.txt,
agents.md, MongoDB/AGPL, React/Ads Manager, ASF/CNCF, etc.)

## Tensões filosóficas detectadas

(O que o ADR deixa em tensão com a doutrina canônica do useHBN, ou
com o sinal público pretendido)

## Risco antropológico/cultural

(Se aplicável — ex.: ADR-001 ritual virar burocracia; ADR-005 sinal
cultural pró-corporativo afastar comunidade; ADR-007 Goodhart's law
em métricas; ADR-009 inflação de princípios)

## Diagrama (se ajudar a clareza)

(Mermaid ou ASCII)

## Recomendação para humano

`RATIFICAR` | `RATIFICAR_APÓS_AJUSTES_NARRATIVOS` | `NÃO_RATIFICAR_AGORA`

## Comentário livre (até 500 palavras)
```

## Pontos onde sua perspectiva agrega mais (priorize esses ADRs)

- **ADR-001** (Quarta de Sanitização — ritual): este é o ADR mais
  antropológico. Análise: rituais semanais funcionam quando há
  feedback loop e custo controlado; falham quando viram performance
  ou perdem sinal de necessidade. A janela 12h BRT amarra a tokens
  Anthropic — isso é resiliente a mudança de plataforma? Quarta manual
  pode virar abuso? Compare com rituais comparáveis em outros projetos
  (sprint reviews, RFC weeks, Tuesday triage do CNCF, etc.).
- **ADR-005** (Licenciamento — Apache 2.0 + DCO): análise estratégica
  do sinal cultural. Apache + CLA leve (DCO) é o sweet spot ou empurra
  uma direção? Como isso interage com o nome "useHBN" (humano-no-controle)?
  Como o operador pode comunicar essa escolha sem parecer "abrindo
  para empresas". Compare MongoDB/AGPL/SSPL trajetória.
- **ADR-007** (Métricas — Goodhart): das 6 métricas, quais são
  potencialmente gaming-able? `quartas_sem_merge_consecutivas` >3 pode
  forçar MERGE artificial. `cross_ia_divergencia_pct` baixa demais
  pode indicar IAs enviesadas pelos mesmos prompts. Proponha
  contra-métricas ou guard-rails antropológicos.
- **ADR-009** (Constituição P1-P13): análise filosófica. 13 é muito ou
  pouco? Comparar com manifestos comparáveis (Twelve-Factor App,
  Reactive Manifesto, Conway's Law, Goodhart). A separação P1-P10
  fundadores vs P11-P13 operacionais cria hierarquia oculta? P13
  (AI-Language-Abstraction) é radical — como comunicar publicamente
  sem soar tecno-utópico?
- **ADR-002** (Tipologia Founding/Consuming): coerência narrativa do
  precedente React/Ads Manager. O termo "Founding" pode ser lido como
  pretensioso? Alternativas linguísticas (ex.: "Genesis", "Birthplace",
  "Originating") considerar?

ADRs onde Codex tem mais a dizer (revise mas seja mais breve, focando
só no narrativo): ADR-003 (topologia — mais técnico), ADR-004 (SemVer
— mais técnico), ADR-006 (sinais multi-repo — mais operacional),
ADR-008 (migração snapshot — mais técnico).

## Restrições

- NÃO modifique nenhum arquivo do repo. Seu output é o conteúdo dos
  9 pareceres + síntese, em texto markdown que o operador vai gravar
  em `.hbn/results/` posteriormente. Você pode incluir blocos
  ```markdown sugeridos para cópia.
- NÃO escreva código de produção. Se identificar gap conceitual que
  exigiria mudança de código, descreva no parecer; não corrija.
- NÃO toque ~/Projetos/Credenciamento/. Apenas leitura para contexto.
- Truth Barrier estrito: claims absolutos proibidos. Comparações com
  precedentes externos devem citar evidência (link, paper, blog post).
- Multimodal: diagramas em mermaid ou ASCII, ou imagens geradas se o
  app permitir, são bem-vindos quando clareiam topologia ou fluxo.
- Convenção numerada com ponto-e-vírgula no chat: 1) ... ; 2) ... ;
  em vez de Q1/Q2/Q3.
- Cada turno começa com sinal HBN (✅ / 🟡 / ❌ / 🔵).

## Sequência esperada

1. Leitura completa dos 16 itens da §"Leitura obrigatória" (~1h
   aproveitando o contexto largo do Gemini 3.1).
2. Pareceres 1 a 9 (na ordem 002 → 003 → 004 → 009 → 001 → 005 → 006 →
   007 → 008). Cada parecer em um bloco markdown copiável.
3. Após os 9 pareceres, produza síntese:
   - Top 3 ADRs com maior risco conceitual (não técnico).
   - Top 3 tensões filosóficas mais críticas a resolver antes de
     ratificar.
   - Análise comparativa: useHBN no espectro de protocolos universais
     (onde se posiciona vs MCP/LSP/OTel/Diataxis/llms.txt/AGENTS.md).
   - Recomendação final consolidada por ADR (RATIFICAR /
     RATIFICAR_APÓS_AJUSTES / NÃO_RATIFICAR_AGORA).
4. Sinalize 🔵 HBN HANDOFF READY e pare. Operador encaminha pareceres
   ao Opus chat-arquiteto que consolida com pareceres do Codex CLI
   (par complementar).

## Como NÃO duplicar Codex CLI

Codex está focando em: factibilidade técnica, conflitos com código
existente (src/usehbn/, schemas/, runtime adapters), blast radius
operacional, gaps de implementação. NÃO faça isso. Se um ADR é mais
"operacional que conceitual" (003, 004, 006, 008), seja breve no
parecer e cite "deferido a Codex CLI" para os pontos técnicos.

## Marcadores HBN obrigatórios

Início: ✅ HBN ACTIVE — Antigravity auditor cross-IA conceitual do useHBN.
Fim: 🔵 HBN HANDOFF READY — 9 pareceres + síntese conceitual entregues
ao operador para consolidação com pareceres Codex.

==================== FIM PROMPT CROSS-IA ANTIGRAVITY (USEHBN) ====================
```

## Notas operacionais para o operador

1. Abrir Antigravity no app. Workspace = `~/Projetos/usehbn/` (com
   `additionalDirectories` para Credenciamento se aplicável).
2. Colar o bloco acima como primeiro turno.
3. Estimativa de duração: 1-2h (Gemini 3.1 com contexto largo absorve
   tudo de uma vez).
4. Quando 🔵 HBN HANDOFF READY aparecer, copie os 9 pareceres + síntese
   em arquivos `~/Projetos/usehbn/.hbn/results/00NN-cross-ia-antigravity-ADR-MMM.md`
   (numeração próxima sequencial — verificar o que Codex já gravou).
5. Encaminhar via copy-paste ou referência de path ao Opus chat-
   arquiteto para consolidação cruzada.

## Como o Opus chat-arquiteto vai consolidar

Após receber pareceres dos dois pares (Codex + Antigravity), Opus
arquiteto produz `auditoria/00_status/05_CONSOLIDACAO_CROSS_IA_ADRS_2026_05_NN.md`
com:

- Por ADR: comparação dos 2 pareceres + recomendação consolidada.
- ADRs com convergência (Codex e Antigravity concordam): promover a
  RATIFICAR.
- ADRs com divergência (Codex aprova, Antigravity reprova ou vice-
  versa): listar a divergência para você arbitrar (P5).
- ADRs que ambos rejeitam: voltar a depósito com ressalvas incorporadas.

## Versão

- v1.0 — 2026-05-09 — Opus 4.7 chat-arquiteto — depósito inicial.
