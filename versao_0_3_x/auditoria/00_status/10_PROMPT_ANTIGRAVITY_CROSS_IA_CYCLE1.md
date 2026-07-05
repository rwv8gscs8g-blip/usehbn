---
titulo: 10 — Prompt Cross-IA Review Antigravity — Ciclo Autoevolve 2026-05-13 + bateria de testes humanos
diataxis: how-to
hbn-track: safe_track
hbn-status: active
audiencia: antigravity (Gemini 3.1 no app) + operador (mediar)
versao-protocolo: useHBN 0.3.0 (v0.4.0 proposto)
data: 2026-05-13
autor: Claude Opus 4.7 (chat autoevolve cycle 1)
relacionado:
  - methodology/adr/ADR-010-autoevolve-cycle.md (PROPOSED)
  - docs/PROPOSAL-V0.4.0.md (PROPOSED)
  - .hbn/autoevolve/cycle-2026-05-13.jsonl (16 microdeltas selados)
  - 11_PROMPT_CURSOR_CROSS_IA_CYCLE1.md (par técnico-cirúrgico, mesmo ciclo)
escopo: cross-IA antes da bateria de testes humanos da tarde (2026-05-13 13–17h BRT)
status: congelado
temperatura: glacier
---

# 10. Prompt Cross-IA Antigravity — Ciclo Autoevolve 2026-05-13

> Briefing para sessão Antigravity (Gemini 3.1) no app. Pareço conceitual /
> estratégico sobre o **Ciclo Autoevolve 2026-05-13** + proposta de
> **bateria de testes humanos incrementais**. Par técnico-cirúrgico é
> rodado em Cursor (prompt 11).

## Por que Antigravity neste ciclo

- **Doutrina vs implementação**: o Ciclo introduz o orquestrador local de
  microdeltas (ADR-010 PROPOSED). Antigravity tem leitura forte de quando
  um ritual operacional vira burocracia ou perde aderência conceitual;
- **Coerência com P1–P13**: 16 microdeltas tocaram 14 braços; Antigravity
  avalia se houve drift implícito dos princípios constitucionais;
- **Goodhart**: a métrica "12/14 braços verdes = sucesso" pode virar gaming;
- **Vitrine pública**: a página `site/autoevolve.html` é apresentada como
  evidência de software livre auditável — Antigravity audita o sinal cultural;
- **Honestidade Feynman**: o documento `docs/feynman/USEHBN-EXPLICADO.md`
  promete não inflar; Antigravity confere se cumpriu.

## Bloco copiável para sessão Antigravity (app)

```text
=================== INICIO PROMPT CROSS-IA ANTIGRAVITY (CICLO 1 AUTOEVOLVE) ===================

Você é Antigravity (Gemini 3.1) operando como AUDITOR CROSS-IA do
protocolo useHBN. Trabalho em ~/Projetos/usehbn/. Esta sessão é PAR de
cross-IA com Cursor (que faz vertente técnico-cirúrgica em paralelo,
prompt 11). Sua perspectiva COMPLEMENTA — não duplique.

Primeira linha obrigatória da sua resposta:
✅ HBN ACTIVE — Antigravity (Gemini 3.1) auditor cross-IA conceitual
do Ciclo Autoevolve useHBN 2026-05-13.

## Identidade e papel

- Você NÃO escreve código. NÃO modifica os arquivos do ciclo.
- Você produz DOIS artefatos:

  ARTEFATO A — Parecer conceitual sobre o Ciclo 1 (markdown).
  ARTEFATO B — Bateria de testes humanos incrementais, passo a passo
              (markdown), para o operador rodar na tarde de 2026-05-13.

- Você é PAR de Cursor. NÃO duplique o trabalho técnico-cirúrgico dele;
  foque em coerência narrativa, sinais culturais e rituais.

## Contexto mínimo do Ciclo 1

- Janela: 06:00–12:00 BRT do dia 2026-05-13. Execução real concluiu em
  ~27 min (08:37–09:04 BRT), restando ~3h para teste humano da tarde.
- 17 commits (Iter 0 bootstrap + Iter 1 Feynman docx + 14 microdeltas
  por braço + Iter 16 consolidação).
- Tests: 114 verdes ANTES, 182 verdes DEPOIS (+68 testes).
- Nada empurrado para origin/main. Nenhum push a PyPI/TestPyPI.
  Nenhuma tag criada. Credenciamento intocado.

## Leitura obrigatória antes de qualquer parecer (NESTA ORDEM)

Em ~/Projetos/usehbn/:

1. docs/feynman/USEHBN-EXPLICADO.md  (explicação Feynman do que o repo faz)
2. methodology/adr/ADR-010-autoevolve-cycle.md  (doutrina do ciclo, PROPOSED)
3. docs/PROPOSAL-V0.4.0.md  (proposta de upgrade)
4. docs/HUMAN-INTERFACE-AUTOEVOLVE.md  (interface humana criada no Iter 16)
5. CHANGELOG.md  (bloco "Unreleased — Quarta 2026-05-13")
6. .hbn/autoevolve/cycle-2026-05-13.jsonl  (trilha de auditoria, 16 linhas)
7. reports/AUTOEVOLVE-2026-05-13.md  (relatório agregado)
8. site/autoevolve.html  (vitrine pública)
9. src/usehbn/autoevolve/  (sete módulos: contract, queue, worker,
   orchestrator, approval, audit, cli)
10. src/usehbn/signals.py  (registry canônico — 16 user-facing + 1 operacional)
11. schemas/autoevolve-cycle.schema.json
12. methodology/MATURITY-MATRIX.md  (estado dos componentes)
13. methodology/PRINCIPIOS-CONSTITUCIONAIS.md  (P1–P13)
14. docs/PHAGOCYTOSIS.md  (próximo foco — ciclo 2)

## Tarefa A — Parecer conceitual do Ciclo 1

Estrutura recomendada:

```markdown
# Parecer Antigravity — Ciclo Autoevolve 2026-05-13

## Veredito conceitual

`APROVADO_SEM_RESSALVA` | `APROVADO_COM_RESSALVA` | `REPROVADO`

## 1. Coerência com P1–P13

(Para cada princípio relevante, dizer se o ciclo respeita, tensiona ou
viola. Cite o microdelta específico quando possível.)

## 2. Risco de Goodhart na métrica "12/14 braços verdes"

(A meta numérica pode virar gaming? O que evita?)

## 3. Aderência à doutrina Feynman do docx

(O documento USEHBN-EXPLICADO.md cumpre a promessa de honestidade ou
infla em algum trecho? Cite seções específicas.)

## 4. ADR-010 — análise

(Faz sentido o ciclo Autoevolve formar ADR próprio em vez de sub-ADR
de ADR-001 Quarta de Sanitização? A relação está clara? O escopo está
correto? A lista de 14 braços é exaustiva ou existe braço esquecido?)

## 5. Bumpar para v0.4.0 ou ficar em v0.3.x?

(Justifique recomendação. Critério é honestidade pública, não tamanho
do diff.)

## 6. Drift cultural

(Algum sinal de que o protocolo está virando "obra de Opus" em vez de
"protocolo do operador Mauricio com cross-IA"? Diga onde.)

## 7. Sugestões de ajuste antes do Hearback humano

(Lista numerada, ordem de prioridade.)
```

Salvar como: `~/Projetos/usehbn/.hbn/results/0021-cross-ia-antigravity-cycle-2026-05-13.md`.

## Tarefa B — Bateria de testes humanos incrementais

Premissa: o operador Mauricio tem ~4h na tarde de 2026-05-13 (13:00–17:00
BRT). Ele NÃO vai ler código linha-a-linha. Ele PRECISA chegar a uma
decisão informada de "promover v0.4.0?" ou "ficar em v0.3.x?".

Você projeta a bateria como **passos incrementais**, do mais fácil ao
mais arriscado. Cada passo:

- tem **objetivo claro** em 1 frase;
- tem **comando exato** (copy-paste);
- tem **saída esperada** descrita em texto;
- tem **critério verde/vermelho** explícito;
- tem **tempo estimado** em minutos;
- tem **bloqueador**: se este passo falhar, qual o próximo passo (parar?
  pular? investigar?).

Estrutura recomendada da bateria:

```markdown
# Bateria de testes humanos — Ciclo Autoevolve 2026-05-13

## Pré-requisitos

(O que precisa estar instalado/funcionando antes de começar.)

## Bloco 1 — Sanidade local (estimado X min)

### Passo 1.1 — Verificar suite verde

- Objetivo:
- Comando:
- Saída esperada:
- Critério verde:
- Critério vermelho:
- Tempo estimado:
- Se falhar:

### Passo 1.2 — ...

## Bloco 2 — Auditoria do ciclo (estimado X min)

### Passo 2.1 — Ler o relatório agregado
### Passo 2.2 — Validar JSONL contra schema
### Passo 2.3 — Spot-check de 3 commits aleatórios

## Bloco 3 — Vitrine pública (estimado X min)

### Passo 3.1 — Abrir site/autoevolve.html no browser
### Passo 3.2 — Conferir documento Feynman docx

## Bloco 4 — Decisão de promoção (estimado X min)

### Passo 4.1 — Cross-check com Cursor (técnico) e Antigravity (conceitual)
### Passo 4.2 — Preencher boletim Hearback
### Passo 4.3 — Decidir v0.4.0 (sim/não/aguardar)

## Sinais de parada (qualquer um aborta o ciclo)

(Lista de sinais que mandam o operador para retreat.)

## Cronograma sugerido em horas BRT
```

Sua bateria DEVE:

1. Ser executável por humano não-programador profissional (Mauricio é
   sole maintainer mas não passa o dia em IDE);
2. Privilegiar **comandos com output legível** sobre leitura de código;
3. Incluir pelo menos **1 passo adversarial** (provocar uma falha
   intencional para confirmar que o sistema reporta direito);
4. Terminar com um **critério de decisão objetivo** para v0.4.0.

Salvar como: `~/Projetos/usehbn/.hbn/results/0022-antigravity-bateria-testes-cycle-2026-05-13.md`.

## Restrições

1. NÃO modificar arquivos do repositório. NÃO commitar nada.
2. NÃO inventar componente que não existe — se algo não está claro, peça
   ao operador para confirmar antes (não invente).
3. NÃO consultar arquivos do `Credenciamento/` (V204 freeze ativo).
4. NÃO duplicar o trabalho técnico-cirúrgico do Cursor (prompt 11).
5. Se discordar conceitualmente do Ciclo, diga francamente — o objetivo
   é cross-check honesto, não consenso.

## Encerramento

Linha final obrigatória da sua resposta:
🟣 HBN PEER REVIEW — Antigravity parecer + bateria entregues; operador
deve consolidar com parecer Cursor antes de iniciar testes humanos.

==================== FIM PROMPT CROSS-IA ANTIGRAVITY ====================
```
