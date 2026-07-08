---
titulo: 02 - Addendum ao Bootstrap — correcoes ratificadas pelo operador 2026-05-09
diataxis: status
hbn-track: safe_track
hbn-status: active
audiencia: ambos
versao-protocolo: useHBN pre-v1
data: 2026-05-09
autor: Claude Opus 4.7 (Cowork) — chat arquiteto-mestre useHBN
relacionado:
  - 00_BOOTSTRAP_PROTOCOLO_2026_05_09.md (corrigido por este addendum)
  - Credenciamento/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md (canonico P1-P13)
  - doc 66 v2.0 §11.3 (Clausula da Janela de Faturamento)
status: congelado
temperatura: glacier
---

# 02. Addendum ao Bootstrap — correcoes 2026-05-09

> Operador respondeu as 5 perguntas pendentes (§8 do bootstrap). Tres
> correcoes substantivas exigem ajuste imediato nos esqueletos de
> ADR-001 e ADR-009 do bootstrap. Onde houver conflito com o doc 00,
> este addendum prevalece.

## A. Correcao critica do ADR-009 — Constituicao P1-P13 (nao P1-P12)

### A.1 Achado

`Credenciamento/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md`
(produzido por Opus 4.7 Frente 2 em 2026-05-09 — mesmo dia do handoff)
ja formaliza **13 principios** com aprovacao explicita do operador
naquele dia. Nao ha P14+. Nao e necessario "criar do zero" os P1-P13;
e necessario **migrar a fonte canonica para `~/Projetos/usehbn/`** e
reconciliar com `docs/PRINCIPLES.md` atual (que lista apenas 8
genericos diferentes).

### A.2 Lista canonica P1-P13 (origem: PRINCIPIOS-CONSTITUCIONAIS.md)

**P1-P10 — fundadores (V1 da tese, 2026-05-02)**

| # | Nome | Declaracao condensada |
|---|---|---|
| P1 | Preservar antes de transformar | Cópias sanitizadas operam sobre o original; o original fica intocado |
| P2 | Documentar antes de executar | Intent/escopo/critério em arquivo do repo antes de executar |
| P3 | Testar antes de refatorar | Refatoracao so sobre codigo com cobertura de teste ativa |
| P4 | Explicar antes de automatizar | Toda automacao tem explicacao textual em doc canonico |
| P5 | Humano no controle por padrao | Decisoes irreversiveis exigem confirmacao humana explicita |
| P6 | Toda evolucao deve ser reversivel | Cada mudanca tem caminho de rollback testado e documentado |
| P7 | Nenhuma tecnologia fagocitada perde sua identidade | Contexto/fonte/racional original preservados |
| P8 | O protocolo importa mais que a ferramenta | Convencoes textuais e schemas sao a camada permanente |
| P9 | Frameworks sao descartaveis; principios sao permanentes | Lock-in em framework e falha de design |
| P10 | Seguranca e nao-regressao > velocidade | Onda fechada com gate de seguranca violado nao e onda fechada |

**P11-P13 — operacionais (formalizados 2026-05-02 → 2026-05-06; promovidos a constitucional 2026-05-09)**

| # | Nome | Marker | Origem |
|---|---|---|---|
| P11 | Minimalismo de Cadeia | 🟦 HBN MINIMALIST GATE | arquivamento de Typer (cadeia inflada) |
| P12 | Substrato Solido | 🟪 HBN SUBSTRATO GATE | inversao do uv (Rust direto) |
| P13 | AI-Language-Abstraction | 🟧 HBN AI-ABSTRACTION GATE | decisao Rust apesar de operador nunca ter digitado Rust |

### A.3 Mudanca no ADR-009 (substitui §4.9 do bootstrap)

ADR-009 reescrito para:

- **NAO** propor "criar P1-P12 do zero"
- **SIM** propor migracao da fonte canonica
  `Credenciamento/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md`
  para `~/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md` +
  reconciliacao com `docs/PRINCIPLES.md`
- **SIM** registrar que `docs/PRINCIPLES.md` (8 itens, herdados de
  v0.2.x) sera **descontinuado** ou rebaixado a "principios de
  comunicacao" (subset informal), com banner "superseded by
  methodology/PRINCIPIOS-CONSTITUCIONAIS.md"
- Numero do ADR mantem-se 009; nome ajustado: "Constituicao P1-P13 —
  migracao da fonte canonica"

**Status:** PROPOSED. Cross-IA: Opus + Antigravity + Codex (3 IAs por
exigencia constitucional, conforme §A.4). Bloqueia ADR-001 (Quarta usa
P6/P10/P11/P12).

### A.4 Cadencia de revisao constitucional (do PRINCIPIOS-CONSTITUCIONAIS.md)

- Revisao **anual** (mais conservadora que tecnologias).
- Mudanca em redacao de qualquer P exige:
  1. Cross-audit com pelo menos 2 IAs auxiliares (Antigravity + Gemini OU Codex)
  2. Decisao Maurício após sintese
  3. Capsula de auditoria registrando o porquê
  4. Append-only — principio antigo permanece com nota `superseded-by`
- Adicao de novo principio (P14+) segue mesmo fluxo, com requisito
  adicional de pelo menos 2 incidencias reais que motivaram a
  formulacao.

Esta cadencia substitui o "3 Quartas consecutivas" que era a proposta
do doc 66 v2.0 (P12 Substrato Solido sentido Quarta — ver §B abaixo
para resolver a sobrecarga semantica).

### A.5 Sobrecarga semantica detectada — P12

"P12 Substrato Solido" tem dois sentidos diferentes:

1. **No PRINCIPIOS-CONSTITUCIONAIS.md (canonico)**: substrato comum
   dos modulos do useHBN deve ser linguagem que oferece estabilidade
   de decadas (Rust). Marker 🟪 HBN SUBSTRATO GATE.
2. **No doc 66 v2.0 §7.4 (proposta da Quarta)**: principios
   constitucionais so mudam apos 3 Quartas consecutivas — sentido
   "estabilidade temporal de regras".

**Resolucao proposta**: P12 e o sentido (1) canonico. O sentido (2)
e renomeado para **"Cadencia Constitucional"** e entra como
**clausula operacional do ADR-001** (Quarta de Sanitizacao), nao como
principio numerado novo. Isso preserva os 13 principios formalizados
e nao infla a constituicao.

## B. Reorganizacao da Quarta de Sanitizacao — janela de 12:00 BRT

### B.1 Validacao da proposta original (do doc 66 v2.0)

| Estagio | Horario proposto | Consome tokens IA? | Esta antes de 12h BRT? |
|---|---|---|---|
| AGENT-INTAKE | Terca a noite | Sim | Sim (terca, fora ciclo da quarta) |
| AGENT-TRIAGE | Quarta 09h | Sim | ✅ Sim |
| AGENT-DEBATE | Quarta 14h | Sim | ❌ NAO |
| HUMAN-RATIFY | Quarta 17h | Nao (so humano) | n/a (humano sem token IA) |
| AGENT-COMMIT | Quarta 18h | Sim | ❌ NAO |

**Veredito**: a proposta original VIOLA a regra "tokens consumidos
ate 12h BRT" em 2 dos 3 estagios IA da quarta (DEBATE e COMMIT).

### B.2 Reorganizacao proposta

| Estagio | Novo horario | Consome tokens? | Janela? |
|---|---|---|---|
| AGENT-INTAKE | Terca 21h-23h BRT | Sim | n/a (terca) |
| AGENT-TRIAGE | Quarta 06h-07h | Sim | ✅ |
| AGENT-DEBATE (cross-IA) | Quarta 07h-10h | Sim | ✅ |
| AGENT-COMMIT-DRAFT | Quarta 10h-11:30 | Sim | ✅ |
| **HARD CUT-OFF tokens** | **Quarta 12:00 BRT** | — | linha de corte |
| HUMAN-RATIFY | Quarta 12h-17h | Nao | n/a (so humano lê drafts e ratifica) |
| HUMAN-PROPAGATE | Quinta manha | Nao (humano dispara CI/PR) | n/a |

Janela ativa de tokens IA: **terca-noite + quarta 06-12h BRT** (~6h
de janela na quarta + intake na terca).

### B.3 Implicacoes

- Cross-IA debate fica em paralelo, nao sequencial (cada IA produz
  parecer independente em ate 3h).
- AGENT-COMMIT-DRAFT gera ADR drafts mas **NAO commita**; commit real
  e feito por humano + CI na quinta apos ratificacao.
- Se um estagio IA estourar 12:00 BRT, vira DEFER automatico (P11
  Minimalismo de Cadeia: duvida = adiar para proxima Quarta).
- Sinal `🟠 HBN BILLING WINDOW DRIFT` continua valido se a janela
  Anthropic mudar.

## C. Quarta de Sanitizacao Manual (gatilho on-demand)

### C.1 Necessidade

Operador pediu mecanismo manual alem da Quarta automatica recorrente.
Casos de uso:

- Revisao emergencial apos auditoria cruzada nao planejada (ex.: hoje
  2026-05-09 — 3 auditorias convergiram fora de quarta-feira).
- Sanitizacao pontual quando metricas de saude (`adrs_ativos`,
  `total_docs_canonicos`) cruzam alarme entre Quartas regulares.
- Decisao de release publico que exige limpeza pre-tag.

### C.2 Mecanismo proposto

Dois gatilhos:

**(1) Comando CLI** — `hbn quarta --manual [--scope=<tema>]`

- Executa o pipeline AGENT-INTAKE → AGENT-TRIAGE → AGENT-DEBATE →
  AGENT-COMMIT-DRAFT em sessao unica (sem esperar terca-noite).
- Janela de 12h BRT continua valida: se executado pre-12h, segue ate
  o cut-off; se executado pos-12h, gera apenas INTAKE+TRIAGE e
  DEFER do DEBATE para a manha seguinte (06h BRT).
- Argumentos:
  - `--scope <tema>` opcional: limita varredura (ex.: "licenca",
    "topologia").
  - `--dry-run`: gera relatorio sem produzir ADR drafts.

**(2) Convocacao por sinal** — qualquer IA emite
`🌐 HBN CROSS-REPO LOCK` ou `🟠 HBN BILLING WINDOW DRIFT` ou
`🪞 HBN MIRROR DRIFT`. Operador, ao receber o sinal, decide se
invoca `hbn quarta --manual` imediatamente.

### C.3 Diferenca entre Quarta automatica e manual

| Atributo | Quarta automatica | Quarta manual |
|---|---|---|
| Frequencia | Semanal (toda quarta) | On-demand |
| Quorum cross-IA | Obrigatorio antes do COMMIT-DRAFT | Obrigatorio antes do COMMIT-DRAFT |
| HUMAN-RATIFY | Quarta 12-17h BRT | Imediato apos COMMIT-DRAFT |
| Constraint janela 12h | Sim | Sim (com fallback DEFER) |
| Output | ADR drafts em `methodology/adr/` | Idem |
| Append em metricas | Conta como Quarta N | Conta como Quarta N.k (sub-indice) |

### C.4 Implementacao

`bin/hbn-quarta.sh` ou subcomando Python — escopo de ondas pos-v0.3.0
(nao bloqueia ADR-001). Por ora, "manual" e operado por instrucao do
arquiteto Opus + ratificacao humana, sem CLI.

## D. Atualizacao das microdeltas do bootstrap

| MD original | Estado pos-addendum |
|---|---|
| MD-A (bootstrap doc + memory) | ✅ CONCLUIDO neste turno |
| MD-B (criar 9 ADRs como arquivos) | Aguarda Hearback do humano sobre licenca (4) e cross-IA serial 002 → 003 → 004 → 009 → 001 (decisao 2 do operador) |
| MD-C (AGENTS.md raiz) | Inalterado |
| MD-D (Prompt-Retomada-Codex-V204) | ✅ CONCLUIDO neste turno (`01_PROMPT_RETOMADA_CODEX_V204.md`) |
| MD-E (pre-Quartas) | Inalterado |

Nova MD adicionada:

| MD | Tema |
|---|---|
| MD-F (urgente) | Reconciliar `docs/PRINCIPLES.md` (8 itens v0.2.x) com PRINCIPIOS-CONSTITUCIONAIS.md (13 itens). Migrar fonte canonica do Credenciamento/usehbn/ para usehbn/methodology/. Bloqueia ADR-009. |

## E. Resumo executivo deste addendum

1) Bastao F2 absorvido pelo Opus chat-novo (decisao 1 ratificada);
   iteracao 0008 e 0009 (Onda 3 Relay Invariants) seguem com este
   chat — vou pensar como executar dentro do ciclo da janela 12h BRT.

2) Cross-IA dos ADRs P0 segue serial: 002 → 003 → 004 → 009 → 001
   (recomendacao Opus ratificada; decisao 2).

3) Rollback MICRO49 → MICRO48 ratificado; prompt entregue em
   `01_PROMPT_RETOMADA_CODEX_V204.md`; ADRs em flight citados como
   informativos sem bloquear (decisao 3).

4) Licencas: explicacao didatica AGPLv3 vs Apache 2.0 vs MIT entregue
   no chat conversacional (decisao 4 — operador decide depois de ler).

5) Constituicao P1-P13 ja existe (canonica em Credenciamento/usehbn/
   methodology/); ADR-009 reescrito como "migracao + reconciliacao";
   "Substrato Solido sentido Quarta" renomeado para "Cadencia
   Constitucional" (clausula operacional, nao principio novo).

6) Quarta de Sanitizacao reorganizada para janela 06-12h BRT (4 estagios
   IA antes do cut-off; 2 estagios humanos depois).

7) Quarta Manual proposta como dois gatilhos: comando CLI
   `hbn quarta --manual` (futuro) + convocacao por sinal HBN multi-repo
   (operacional ja).

## F. Versao deste documento

- v1.0 — 2026-05-09 — Opus 4.7 chat-novo entrega addendum apos receber
  as 5 ratificacoes do operador. Corrige ADR-009 (P1-P13 canonicos),
  reorganiza Quarta para janela 12h BRT, e propoe Quarta manual.
