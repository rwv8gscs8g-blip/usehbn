---
titulo: 00 - Bootstrap do protocolo useHBN — retomada do chat arquiteto
diataxis: status
hbn-track: safe_track
hbn-status: active
audiencia: ambos
versao-protocolo: pre-v1 (working release v0.3.0)
data: 2026-05-09
autor: Claude Opus 4.7 (Cowork) — chat arquiteto-mestre useHBN (CWD ~/Projetos/usehbn/)
licenca-target: AGPLv3 atual; ADR-005 propoe migracao para Apache 2.0
---

# 00. Bootstrap do protocolo useHBN — 2026-05-09

> Este documento e o ponto-zero do chat novo `~/Projetos/usehbn/` apos o
> handoff do chat anterior em `~/Projetos/Credenciamento/`
> (doc 66 v2.0). Inclui inventario do repo, mapa das ~35 docs em 7-8
> cernes funcionais, esqueletos dos 9 ADRs (001-009 com 008 sendo o de
> migracao), plano de microdeltas pre-v204-final, e flags de
> reconciliacao com a doutrina chegada do chat anterior.

> **Estado de bastao:** Opus chat-novo recebe bastao F2 (protocolo
> useHBN). Codex CLI mantem bastao F1 (Credenciamento V204) e esta em
> pausa operacional MICRO49 (doc 68 do Credenciamento) aguardando
> nova sessao para RCA. As duas pistas sao oficialmente paralelas.

## 1. Estado atual do repo `~/Projetos/usehbn/`

### 1.1 Inventario de raiz

```
README.md              CHANGELOG.md     ROADMAP.md      LICENSE
GOVERNANCE.md          MAINTAINERS.md   CODE_OF_CONDUCT.md
CONTRIBUTING.md        SECURITY.md      SUPPORT.md
AUDITORIA_SUPERPOWERS.md
HBN-ARCHITECTURAL-REVIEW-2026-04.md
agents/   core/   docs/   schemas/   src/usehbn/   tests/   examples/
reports/  site/   skills/ logs/      state/        .usehbn/  .hbn/
```

### 1.2 `core/` (5 arquivos — base normativa)

```
command-spec.md   protocol.md   readback-spec.md
semantic-layer.md validation-rules.md
```

### 1.3 `docs/` (~35 arquivos, ~3.775 linhas)

Categorias agrupaveis (detalhe em §3):

| Categoria | Docs | Observacao |
|---|---|---|
| Constitucional/doutrinario | PRINCIPLES, VISION, FOUNDING-NOTES, HBN-LANGUAGE-v0.1, INTENT-RISK-MATRIX, GUARDIAN, TRUTH-BARRIER | 8 principios atuais; doc 66 v2.0 cita P1-P12 (gap) |
| Doutrina de evolucao | PHAGOCYTOSIS, EVOLUTION-POLICY, MATURITY-MATRIX | maior peso (PHAGO 233 lin) |
| Tecnico/arquitetural | ARCHITECTURE, how-it-works, UNIVERSAL-TRANSLATOR, RUNTIME-ADAPTERS, CONNECTORS | superficie da implementacao |
| Integracoes (Cat A) | INTEGRATION-DIATAXIS, INTEGRATION-LLMS-TXT, INTEGRATION-AGENTS-MD, INTEGRATION-GLASSWING, INTEGRATION-CLA-CONTROLLED-ACCESS, VBA | Glasswing + Diataxis + agents.md + llms.txt + CLA |
| Governanca/release | LICENSING, OPEN-SOURCE-STRATEGY, PUBLISHING, PUBLISHING-DECISION, EXECUTION-DECISION | duas docs de publish (PUBLISHING e PUBLISHING-DECISION) |
| Operacional/tutorial | CONTRIBUTOR-QUICKSTART, SAFE-TESTING, ANALYTICS, DOMAINS, PROMPT-CLAUDE-UNIVERSAL-TRANSLATOR | mistura de Diataxis tutorial + how-to |
| Caso de uso | CASE-STUDY-CREDENCIAMENTO | 144 lin |
| Plano | WAVE-PLAN-V0.3.0 (920 lin), roadmap.md, ROADMAP.md (raiz) | duplicidade roadmap/ROADMAP |
| RFC | rfc/RFC-0001-enforce-mode | enforce mode opt-in para Truth Barrier/Guardian |

### 1.4 `agents/`

```
agents.md   claude.md   codex.md   safety.md   wave-protocol.md
```

`AGENTS.md` na raiz **nao existe** ainda; convencao do ecossistema (Cat A
agents.md) e que `AGENTS.md` em raiz seja o contrato unico — hoje so
`agents/agents.md` existe. Item para ADR-002 ou Onda 5 do plano v0.3.0.

### 1.5 `schemas/`

7 schemas: `connector-approval`, `connector-contract`, `consent`, `guardian`,
`intent`, `readback`, `result`. Recente: Onda 2 nova adicionou
`protocol_version` opcional em `readback` e `result` (commit `4a09523`).

### 1.6 `.hbn/relay/`

```
INDEX.md  0008-architect-correcao-onda3.md  0009-onda-3-relay-invariants.md
```

Estado: bastao com `claude-opus-4.7 (architect)` desde 2026-04-29; iteracao
0008 aguardando hearback humano para Nova Onda 3 (Relay Invariants em
runtime). **Conflito leve**: o bastao deste chat-novo e Opus 4.7, mas a
iteracao 0008 estava em hearback aberto desde abril; precisa decisao
operacional sobre se o chat-novo absorve esse bastao ou apenas observa.

### 1.7 Ondas em curso (do `WAVE-PLAN-V0.3.0`)

```
Onda 1 — Honestidade Narrativa            CONCLUIDA (commit 43c4c5d)
Onda 2 — Schema Versioning                CONCLUIDA (commit 4a09523)
Onda 3 — Relay Invariants em Runtime      AGUARDANDO HEARBACK HUMANO
Onda 4 — Connector Lifecycle Registry     PENDENTE
Onda 5 — Cleanup + state/ Legacy          PENDENTE
Onda 6 — Vitrine + Release v0.3.0         PENDENTE
```

### 1.8 Discrepancias normativas detectadas

| # | Discrepancia | Implicacao |
|---|---|---|
| D1 | `docs/PRINCIPLES.md` lista **8 principios**; doc 66 v2.0 cita **P1-P12** como constitucionais (P6 Reversibilidade, P11 Minimalismo de Cadeia, P12 Substrato Solido) | ADR-009 precisa formalizar a constituicao P1-P12 ou rebaixar a citacao do doc 66 a 8 atuais |
| D2 | Existe `ROADMAP.md` (raiz) e `docs/roadmap.md` com conteudos diferentes | Onda 5 (Cleanup) ou ADR-007 deve unificar |
| D3 | `docs/PUBLISHING.md` e `docs/PUBLISHING-DECISION.md` coexistem | Decisao Q13 (TestPyPI primeiro) vive em PUBLISHING-DECISION; PUBLISHING parece predecessor |
| D4 | `AGENTS.md` (raiz) nao existe; so `agents/agents.md` | Cat A integrations exigem raiz; ajustar em ADR-002 ou Onda 5 |
| D5 | `auditoria/` nao existia no repo (criada agora para este doc) | Topologia ADR-003: auditoria do PROTOCOLO vive aqui (F2); auditoria da APP fica no Credenciamento (F1) |
| D6 | Nao ha pasta `modules/` nem `methodology/` mencionadas no doc 66 §3.2 | ADR-003 propoe criacao na Onda futura; bootstrap nao mexe |
| D7 | `.hbn/meta/` nao existe; doc 66 v2.0 §11.1 ratificou criacao em fase 1 | Pendente; nao e pre-requisito imediato |

## 2. Reconciliacao com decisoes do chat anterior (doc 66 v2.0)

| Decisao chat anterior | Estado neste repo | Acao |
|---|---|---|
| Solucao A: `additionalDirectories` | ✅ Configurado em `.claude/settings.local.json` | nada |
| AGENTS.md em raiz | ❌ ausente | Onda 5 ou ADR-002 |
| `.usehbn-snapshot/` no Credenciamento | ❌ pendente — pos-v204 | ADR-008 esqueleto |
| Quarta de Sanitizacao + janela 12:00 BRT | ❌ ainda nao existe ritual | ADR-001 esqueleto |
| Tipologia Founding/Consuming Application | ✅ ratificada conceitualmente; ❌ nao formalizada em ADR | ADR-002 esqueleto |
| Topologia mono-repo modular (modules/methodology/auditoria) | ❌ so `auditoria/` criada agora | ADR-003 esqueleto |
| SemVer + sinais multi-repo | ✅ `protocol_version` ja foi para schemas (Onda 2) | ADR-004 esqueleto + ADR-006 esqueleto |
| Apache 2.0 vs AGPLv3 | ❌ AGPLv3 ainda; recomendacao Apache 2.0 | ADR-005 esqueleto |
| Quartas pos-v204 final | ❌ pre-Quartas apenas | Plano §6 |

## 3. Mapa de fusao das docs (Antigravity Q3 — fusao em 7-8 cernes)

> Proposta inicial. NAO e merge; e mapa de destino para a Onda futura
> "Documental Sanitization" (sera proposta em ADR-007 + ratificada em
> Quarta apos v204 final). Aqui apenas registramos a topologia alvo.

### 3.1 Cernes propostos (7 funcionais + 1 imutavel)

| # | Cerne (caminho alvo) | Fonte (docs atuais que fundem) | Linhas estimadas |
|---|---|---|---|
| C1 | `methodology/PRINCIPLES.md` | PRINCIPLES + VISION + FOUNDING-NOTES + HBN-LANGUAGE-v0.1 + INTENT-RISK-MATRIX + GUARDIAN + TRUTH-BARRIER | ~242 |
| C2 | `methodology/PHAGOCYTOSIS.md` | PHAGOCYTOSIS + EVOLUTION-POLICY (compativel) | ~345 |
| C3 | `methodology/MATURITY-MATRIX.md` | MATURITY-MATRIX (intacto — fonte unica de verdade) | ~101 |
| C4 | `modules/PROTOCOL-CONTRACT.md` | ARCHITECTURE + how-it-works + UNIVERSAL-TRANSLATOR + RUNTIME-ADAPTERS + CONNECTORS | ~644 |
| C5 | `modules/INTEGRATIONS.md` | INTEGRATION-DIATAXIS + INTEGRATION-LLMS-TXT + INTEGRATION-AGENTS-MD + INTEGRATION-GLASSWING + INTEGRATION-CLA-CONTROLLED-ACCESS + VBA | ~625 |
| C6 | `modules/GOVERNANCE.md` | LICENSING + OPEN-SOURCE-STRATEGY + PUBLISHING + PUBLISHING-DECISION + EXECUTION-DECISION | ~345 |
| C7 | `methodology/TUTORIALS.md` (Diataxis tutorial+how-to) | CONTRIBUTOR-QUICKSTART + SAFE-TESTING + ANALYTICS + DOMAINS + PROMPT-CLAUDE-UNIVERSAL-TRANSLATOR | ~433 |
| C8 | `auditoria/case-studies/CREDENCIAMENTO.md` | CASE-STUDY-CREDENCIAMENTO (mantem standalone; vai crescer) | ~144 |

WAVE-PLAN, ADRs e RFCs vivem em outras particoes:
- `methodology/wave-plans/v0.3.0.md` ← `docs/WAVE-PLAN-V0.3.0.md`
- `methodology/adr/ADR-NNN-*.md` ← arquivos novos (este bootstrap)
- `methodology/rfc/RFC-NNNN-*.md` ← `docs/rfc/RFC-0001-enforce-mode.md`

ROADMAP.md raiz e `docs/roadmap.md` viram unico `methodology/ROADMAP.md`.

### 3.2 Total: 35 docs -> 8 cernes + ADRs/RFCs/wave-plans (compressao de 35 -> ~8 cernes principais).

### 3.3 Reducao estimada

- Linhas atuais: ~3.775
- Linhas alvo (sem perda informacional): ~2.879 + ADRs novos
- Reducao estimada de duplicacao: 20-25%

## 4. Esqueletos dos 9 ADRs

> Cada esqueleto declara: titulo, status, contexto, decisao proposta,
> consequencias, e PROXIMO PASSO (cross-IA + ratificacao humana).
> Nada aqui esta merged; tudo aguarda Hearback humano + cross-IA.

### 4.1 ADR-001 — Quarta de Sanitizacao: ritual de auto-evolucao assistida

**Status proposto:** PROPOSED
**Cross-IA review necessario:** Opus + (Antigravity OU Codex)
**Origem:** doc 66 v2.0 §7.4 + §11.3

**Contexto.** O protocolo precisa de mecanismo continuo de auto-revisao
que detecte hipertrofia documental, deriva de principios, divergencia
inter-IA, e que opere dentro da janela de faturamento da plataforma de IA.
Sem isso, a doutrina cresce e os principios se diluem.

**Decisao proposta.** Adotar a Quarta de Sanitizacao semanal com:

1. **Anatomia em 5 estagios** (terca-noite intake → quarta 09h triage →
   quarta 14h debate cross-IA → quarta 17h human-ratify → quarta 18h
   commit + propagacao).
2. **Cinco principios constitucionais da Quarta**:
   - P6-Reversibilidade: todo MERGE traz seu rollback ADR.
   - P12-Substrato-Solido: principios constitucionais so mudam apos
     **3 Quartas consecutivas** debaterem.
   - P11-Minimalismo-de-Cadeia: duvida = DELETE, nunca DEFER indefinido.
   - **Cross-IA obrigatorio**: single-IA = DEFER automatico.
   - **Metrica viva**: cada MERGE da Quarta N vira input mensuravel da
     Quarta N+4.
3. **Clausula da Janela de Faturamento** (texto canonico em doc 66 v2.0
   §11.3.1): quarta-feira ate 12:00 BRT (-03:00); origem ciclo Anthropic
   semanal; sinal `🟠 HBN BILLING WINDOW DRIFT` quando parametros mudam;
   intersecao para multi-plataforma.
4. **Quarta 0 inaugural** so apos v204 final do Credenciamento.

**Consequencias.**
- Operador precisa estar disponivel quarta 17h para HUMAN-RATIFY (boletim
  curto, nao revisao linha-a-linha).
- Custo de coordenacao adicional (~3-4h/semana).
- Beneficio: protocolo auto-corretivo, anti-hipertrofia.

**Proximo passo.** Hearback humano + Antigravity audit cruzado.

---

### 4.2 ADR-002 — Tipologia formal: Founding/Consuming Application vs Module

**Status proposto:** PROPOSED
**Cross-IA review necessario:** Opus + Codex
**Origem:** doc 66 v2.0 §3.1

**Contexto.** O ecossistema misturou ate aqui o status do Credenciamento
("modulo do protocolo" vs "aplicacao consumidora"). Tres auditorias
cruzadas (Antigravity + Codex + Opus) convergiram em 2026-05-09 que
Credenciamento e **Aplicacao Fundadora + Aplicacao Consumidora**, NUNCA
modulo. A tipologia precisa ser formalizada para evitar regressao.

**Decisao proposta.** Adotar a tipologia:

| Termo | Definicao | Aplicacao atual |
|---|---|---|
| **Founding Application** | Aplicacao onde os padroes do protocolo foram descobertos empiricamente. Status historico, nao tecnico | Credenciamento |
| **Consuming Application** | Aplicacao que consome o protocolo como dependencia. Status tecnico atual e futuro | Credenciamento (e futuras) |
| **Reference Implementation** | Codigo-base oficial que materializa o protocolo | Sera construida em `~/Projetos/usehbn/examples/` |
| **Protocol Specification** | Especificacao normativa | `~/Projetos/usehbn/modules/` (a criar) |
| **NAO-modulo** | Status proibido para qualquer aplicacao consumidora | Credenciamento NUNCA recebe esse rotulo |

**Consequencias.**
- `docs/CASE-STUDY-CREDENCIAMENTO.md` precisa atualizar terminologia.
- `MATURITY-MATRIX.md` linha "Credenciamento" muda de "Visao / referencia
  externa" para "Founding/Consuming Application — referencia externa".
- Comunicacao publica passa a usar tipologia consistente.
- AGENTS.md (raiz, a criar em Onda 5 ou ADR-008) declara `useHBN-version`.

**Proximo passo.** Hearback humano + Codex audit cruzado.

---

### 4.3 ADR-003 — Topologia de repositorios e relay multi-camada

**Status proposto:** PROPOSED
**Cross-IA review necessario:** Opus + Antigravity
**Origem:** doc 66 v2.0 §3.2

**Contexto.** Hoje o protocolo vive em `~/Projetos/usehbn/` como mono-repo
sem particao funcional clara entre normativo (`modules/`), arquitetural
(`methodology/`) e historico (`auditoria/`). Codex Q3 + Antigravity Q3
convergiram que mono-repo modular com particao funcional e correto.

**Decisao proposta.** Adotar topologia:

```
~/Projetos/usehbn/                  FONTE DE VERDADE
├── modules/                        especificacao normativa (RFC-style)
├── methodology/                    arquitetura, principios, ADRs, RFCs
├── auditoria/                      historico do PROTOCOLO (F2)
├── examples/                       Reference Implementation
├── core/                           (legado — sera fundido em modules/)
├── docs/                           (legado — sera particionado em
│                                   modules/methodology/ via Onda
│                                   "Documental Sanitization")
├── .hbn/meta/                      meta-relay entre repos (fase 1)
└── .hbn/                           coordenacao inter-IA do PROTOCOLO

~/Projetos/Credenciamento/          APLICACAO CONSUMIDORA
├── src/vba/                        codigo da app
├── auditoria/                      historico da APP (F1)
├── .hbn/                           coordenacao inter-IA da APP
├── usehbn/                         (legado — substituir pos-v204
│                                   conforme ADR-008)
├── .usehbn-snapshot/               read-only mirror (apos ADR-008)
└── AGENTS.md                       declara useHBN-version
```

**Consequencias.**
- Migracao das ~35 docs em fases (mapa em §3 deste bootstrap).
- `core/` torna-se `modules/` (renomeacao + ajuste de imports docs).
- `.hbn/meta/` criado em fase 1 (subdir, nao repo separado — decisao
  ratificada em doc 66 v2.0 §11.1 O2).

**Proximo passo.** Hearback humano + Antigravity audit cruzado.

---

### 4.4 ADR-004 — SemVer do protocolo + sinalizacao para aplicacoes consumidoras

**Status proposto:** PROPOSED
**Cross-IA review necessario:** Opus + Codex (foco no contrato AGENTS.md)
**Origem:** doc 66 v2.0 §7.3

**Contexto.** O protocolo precisa de versionamento semantico claro
(`MAJOR.MINOR.PATCH`) e de mecanismo de propagacao para aplicacoes
consumidoras quando MAJOR/MINOR mudam. Sem isso, drift entre
versao consumida e versao canonica e silencioso.

**Decisao proposta.**

1. **SemVer do protocolo** (ja parcialmente ativo via Onda 2):
   - **MAJOR**: mudanca em principio constitucional (P1-Pn), remocao de
     campo required em schema, renomeacao de termo doutrinario.
   - **MINOR**: novo principio, novo sinal HBN, nova particao de docs,
     novo schema, novo subcomando CLI.
   - **PATCH**: correcao de redacao, fusao sem mudanca normativa, fix de
     bug em codigo.
2. **AGENTS.md em apps consumidoras** declara:
   ```yaml
   useHBN-version: ^1.0.0
   ```
3. **Sinal `⛓️ HBN PROTOCOL DEP CHANGE`** emitido quando MAJOR ou MINOR
   muda — apps consumidoras recebem PR ou nota.
4. **Sinal `🪞 HBN MIRROR DRIFT`** emitido por auditor cruzado quando
   versao consumida diverge muito da canonica.

**Consequencias.**
- Schemas ja tem `protocol_version` opcional (Onda 2). Tornar required em
  v1.0.0 (decisao Q4 do plano v0.3.0) sera bump MAJOR.
- AGENTS.md raiz precisa existir para declarar versao (bloqueia ADR-002).

**Proximo passo.** Hearback humano + Codex audit (foco no contrato).

---

### 4.5 ADR-005 — Licenciamento — proposta de migracao AGPLv3 → Apache 2.0

**Status proposto:** PROPOSED
**Cross-IA review necessario:** Opus + Antigravity (sensibilidade legal)
**Origem:** doc 66 v2.0 §11.4

**Contexto.** Repo atual usa AGPLv3 (decisao da Frente 2 / E1 em
2026-05-02 quando o protocolo era pensado em integracao com
`usehbn-phago/`). Doc 66 v2.0 reabre a questao com analise comparativa
fundamentada para protocolo universal.

**Decisao proposta.** Migrar para **Apache 2.0** quando este ADR for
ratificado. Justificativas detalhadas em doc 66 v2.0 §11.4.3:

1. Protocolos abertos universais (MCP, LSP, OpenTelemetry, Kubernetes
   API, Diataxis) usam Apache/MIT — AGPL bloqueia missao de coordenacao
   inter-IA universal.
2. Fagocitose reciproca exige licenca permissiva.
3. Adocao corporativa: AGPL contamina stack interna; Apache 2.0 e neutro.
4. Patent grant explicito em ambas; Apache nao e mais fraco em protecao.
5. Compatibilidade com TPGL v1.1 do Credenciamento e com auto-conversao
   futura.

**Caminho de transicao.**
1. ADR-005 ratificado por Opus + Antigravity + humano.
2. Re-licenciamento de contribuicoes AGPLv3 ja feitas em
   `~/Projetos/usehbn-phago/` (autor unico = Mauricio, exige autorizacao
   explicita).
3. `LICENSE` atualizado para Apache 2.0.
4. `~/Projetos/usehbn-phago/` arquivado ou tornado read-only com banner
   "superseded by usehbn (Apache 2.0)".
5. CHANGELOG bumpa MAJOR (mudanca de licenca afeta consumidores).

**Consequencias.**
- Sinal `🟤 HBN LICENSE SPLIT REQUIRED` resolvido.
- Mais facil para Credenciamento citar useHBN como dependencia sem
  ativar GPL clauses.
- Pode haver objecao filosofica (AGPL e mais "garantia anti-fechamento");
  a decisao final e do operador.

**Proximo passo.** Hearback humano + Antigravity audit (revisao legal
externa nao planejada nesta fase — o operador e autor unico).

---

### 4.6 ADR-006 — Sinais HBN multi-repo (🌐, ⛓️, 🧊, 🪞, 🟠)

**Status proposto:** PROPOSED
**Cross-IA review necessario:** Opus + Codex (forma operacional)
**Origem:** doc 66 v2.0 §7.2 + §11.3.2

**Contexto.** Os sinais HBN existentes (✅ ACTIVE, 🟡 NEEDS HUMAN, ❌
SECURITY BLOCKED, 🔵 HANDOFF READY, 🟣 PEER REVIEW, ⚪ AUDIT-ONLY, 🔴
RELEASE BLOCKER, 🟢 CHECKPOINT CLEAN, 🟠 SOURCE DRIFT, 🟤 LICENSE SPLIT
REQUIRED) cobrem operacao single-repo. Multi-repo e janela de
faturamento exigem sinais novos.

**Decisao proposta.** Formalizar 5 sinais multi-repo:

| Sinal | Origem | Destino | Significado |
|---|---|---|---|
| 🌐 **HBN CROSS-REPO LOCK** | qualquer | todas | "estou tocando arquivos refletidos em outros repos; aguardar" |
| ⛓️ **HBN PROTOCOL DEP CHANGE** | useHBN | apps consumidoras | "protocolo mudou de SemVer; revisao necessaria" |
| 🧊 **HBN APP FROZEN** | app | protocolo | "esta app esta em janela de release; nao tocar" |
| 🪞 **HBN MIRROR DRIFT** | auditor cruzado | ambos | "protocolo canonico divergiu do consumido por X aplicacao" |
| 🟠 **HBN BILLING WINDOW DRIFT** | qualquer IA | operador | "janela de faturamento mudou; reajustar Quarta" |

**Consequencias.**
- Catalogo de sinais cresce (~15 → ~20). `core/protocol.md` ou
  `modules/PROTOCOL-CONTRACT.md` (apos ADR-003) incorpora.
- `agents/wave-protocol.md` precisa secao de uso destes sinais.

**Proximo passo.** Hearback humano + Codex audit (foco operacional).

---

### 4.7 ADR-007 — Metricas de saude do protocolo + alarmes

**Status proposto:** PROPOSED (P1, fora do bloco P0)
**Cross-IA review necessario:** Opus + (Antigravity OU Codex)
**Origem:** doc 66 v2.0 §7.5

**Contexto.** Sem metricas mensuraveis, o ritual da Quarta vira culto
sem feedback loop. Doc 66 v2.0 propos 6 metricas. Este ADR formaliza.

**Decisao proposta.** Implementar coleta automatica de:

| Metrica | Alarme |
|---|---|
| `total_docs_canonicos` | crescimento >10%/mes = hipertrofia |
| `adrs_ativos` | razao docs/adr >5 = falta de formalizacao |
| `principios_constitucionais` | crescimento >1/trimestre = deriva |
| `quartas_sem_merge_consecutivas` | >3 = ritual virou burocracia |
| `cross_ia_divergencia_pct` | >40% = principios mal redigidos |
| `app_consumidoras_em_drift` | >0 sem plano = falha de propagacao |

Coleta em `bin/hbn-health.sh` (a criar). Output em `.hbn/meta/health.json`.

**Consequencias.**
- Cada Quarta começa lendo `health.json` antes de triage.
- Quartas viciosas (sem MERGE por 3 ciclos) viram MD de revisao.

**Proximo passo.** Hearback humano. Pode ficar para 2a Quarta (nao
bloqueia v0.3.0).

---

### 4.8 ADR-008 — Migracao `Credenciamento/usehbn/` → `~/Projetos/usehbn/` + `.usehbn-snapshot/` no consumidor

**Status proposto:** PROPOSED (DEPENDE de v204 final)
**Cross-IA review necessario:** Opus + Codex (Codex e dono do
Credenciamento; toca diretamente a esteira)
**Origem:** doc 66 v2.0 §11.5

**Contexto.** `~/Projetos/Credenciamento/usehbn/` hoje contem fonte de
verdade do protocolo misturada com aplicacao consumidora. Topologia alvo
do ADR-003 exige que essa pasta deixe de existir em duas etapas: (a)
extracao do conteudo canonico (ja iniciada com criacao de
`~/Projetos/usehbn/`); (b) substituicao por README depreciado +
`.usehbn-snapshot/` read-only.

**Decisao proposta.** Apos v204 final do Credenciamento:

1. **Extracao**: confirmar que tudo de `Credenciamento/usehbn/` ja foi
   migrado para `~/Projetos/usehbn/` (auditoria pre-migracao por Opus +
   Codex).
2. **Substituicao**: `Credenciamento/usehbn/` vira README de uma linha
   (texto em doc 66 v2.0 §11.5.5).
3. **`.usehbn-snapshot/`**: populado por `bin/usehbn-fetch.sh` (a criar)
   copiando da ultima tag estavel do `~/Projetos/usehbn/`. Imutavel
   dentro do release. Validavel por checksum
   (`PROTOCOL_SHA256.txt`).
4. **AGENTS.md do Credenciamento** ganha secao "Dependencia de protocolo:
   useHBN" com `useHBN-version: ^X.Y.Z` (formato em doc 66 v2.0 §11.5.4).
5. **NAO submodule git** — decisao explicita pela simplicidade
   (justificativa em doc 66 v2.0 §11.5.6).

**Consequencias.**
- Codex precisa parar de tocar `Credenciamento/usehbn/` durante v204
  (ja parou — esta congelado).
- Apos v204, Codex executa o passo 2-4 com Hearback explicito.
- Risco: drift entre snapshot e canonico se `bin/usehbn-fetch.sh` falhar
  silenciosamente. Mitigacao: checksum obrigatorio em `hbn doctor`.

**Proximo passo.** Hearback humano. ESTE ADR NAO MERGE ate v204 final.

---

### 4.9 ADR-009 — Constituicao: P1-P12 imutaveis e processo de mudanca

**Status proposto:** PROPOSED (P0 — bloqueia ADR-001 §P12 substrato solido)
**Cross-IA review necessario:** Opus + Antigravity + Codex (constitucional
exige 3 IAs — sera primeiro caso)
**Origem:** doc 66 v2.0 §10.2 (lista P1-P12) e §3.4 (P6/P11/P12 citados)

**Contexto.** Doc 66 v2.0 cita "P6 Reversibilidade, P11 Minimalismo de
Cadeia, P12 Substrato Solido" como principios constitucionais imutaveis.
Mas `docs/PRINCIPLES.md` atual lista apenas **8 principios**. Discrepancia
D1 deste bootstrap.

**Decisao proposta.** Formalizar 12 principios constitucionais:

| # | Nome (proposta) | Origem |
|---|---|---|
| P1 | Humano e raiz da confianca | PRINCIPLES.md atual #1 |
| P2 | Sem comportamento oculto | PRINCIPLES.md atual #2 |
| P3 | Intent explicito antes de execucao | PRINCIPLES.md atual #3 |
| P4 | Restricoes visiveis e validadas | PRINCIPLES.md atual #4 |
| P5 | Risco nomeado, nao implicito | PRINCIPLES.md atual #5 |
| **P6** | **Reversibilidade primeiro** | doc 66 v2.0 §7.4 |
| P7 | Claims proporcionais a evidencia | PRINCIPLES.md atual #6 |
| P8 | Toda mudanca e rastreavel | PRINCIPLES.md atual #7 |
| P9 | Simplicidade sobre complexidade | PRINCIPLES.md atual #8 |
| P10 | Cross-IA review e default em decisao estrutural | doc 66 v2.0 §7.4 |
| **P11** | **Minimalismo de cadeia** (duvida = DELETE) | doc 66 v2.0 §7.4 |
| **P12** | **Substrato solido** (3 Quartas para mudar P1-Pn) | doc 66 v2.0 §7.4 |

Processo de mudanca de qualquer P1-P12:

1. Proposta vira MD em `methodology/adr/ADR-NNN-mudanca-PXX.md`.
2. **3 Quartas consecutivas** debatem (P12 Substrato Solido).
3. **Cross-IA review obrigatorio** (P10): minimo 2 IAs distintas com
   parecer assinado.
4. **Humano ratifica** (P1).
5. Bump SemVer **MAJOR** (ADR-004).

**Consequencias.**
- `docs/PRINCIPLES.md` reescrito (Onda futura — bloqueia ADR-002 e
  ADR-001).
- Toda doc publica passa a citar P1-P12.
- Doc 66 v2.0 §3.4 fica coerente com repo.

**Proximo passo.** Hearback humano + Antigravity + Codex (3 IAs por
exigencia do proprio ADR).

## 5. Plano de execucao em microdeltas (pre-v204-final)

> Padrao MD identico aos do Credenciamento. Cada MD: arquivos permitidos,
> arquivos proibidos, gates, riscos, rollback. **Nenhum MD e auto-merge**;
> todos esperam ratificacao + cross-IA conforme P10.

### 5.1 MD-A: Bootstrap doc + memory system

**Tema:** materializar este `00_BOOTSTRAP_PROTOCOLO_2026_05_09.md` +
inicializar memoria persistente do chat.
**Estado:** EM EXECUCAO (este turno).
**Arquivos permitidos:**
- `auditoria/00_status/00_BOOTSTRAP_PROTOCOLO_2026_05_09.md` (este doc)
- `~/.claude/projects/-Users-macbookpro-Projetos-usehbn/memory/MEMORY.md`
- `~/.claude/projects/-Users-macbookpro-Projetos-usehbn/memory/*.md` (4 base)

**Gate:** unico — humano confirma que pode prosseguir para MD-B.

### 5.2 MD-B: ADR-001..009 esqueletos como arquivos versionados

**Tema:** transformar os 9 esqueletos do §4 em arquivos
`methodology/adr/ADR-NNN-*.md` (criar pasta).
**Pre-requisito:** Hearback do MD-A.
**Arquivos permitidos:**
- `methodology/adr/` (criar)
- `methodology/adr/ADR-001-quarta-de-sanitizacao.md` (P0)
- `methodology/adr/ADR-002-tipologia-founding-consuming.md` (P0)
- `methodology/adr/ADR-003-topologia-repos-relay.md` (P0)
- `methodology/adr/ADR-004-semver-protocolo.md` (P0)
- `methodology/adr/ADR-005-licenciamento-apache.md` (P1)
- `methodology/adr/ADR-006-sinais-multi-repo.md` (P1)
- `methodology/adr/ADR-007-metricas-saude.md` (P2)
- `methodology/adr/ADR-008-migracao-snapshot.md` (P0 — bloqueada por v204)
- `methodology/adr/ADR-009-constituicao-p1-p12.md` (P0)

**Arquivos proibidos:**
- `core/`, `agents/`, `schemas/`, `src/`, `docs/PRINCIPLES.md` (so muda em
  Onda dedicada com 3 Quartas — P12).

**Gate:** Hearback humano + 1 cross-IA (Antigravity ou Codex) por ADR P0.

### 5.3 MD-C: AGENTS.md raiz declarando dependencia conceitual

**Tema:** criar `AGENTS.md` na raiz do repo (Cat A integration); declara
seccao para tipologia (futura ratificacao do ADR-002) sem antecipar
decisoes constitucionais.
**Pre-requisito:** Hearback do MD-B + ratificacao parcial de ADR-002.
**Arquivos permitidos:**
- `AGENTS.md` (raiz)

**Gate:** ADR-002 ao menos com cross-IA review (mesmo que nao merged).

### 5.4 MD-D: Acompanhamento da pausa Codex (read-only)

**Tema:** ler periodicamente `~/Projetos/Credenciamento/.hbn/results/0055-*.json`
quando a nova sessao Codex registrar o RCA do MICRO49. Compor
"Prompt-Retomada-Codex-V204" citando ADRs ratificados (passo 10 do plano
§11.7 do doc 66 v2.0).
**Pre-requisito:** RCA do Codex disponivel + ADRs ao menos com cross-IA.
**Arquivos permitidos:**
- `auditoria/00_status/01_PROMPT_RETOMADA_CODEX_V204.md` (entregavel
  copiavel para o operador colar no chat Codex).

**Arquivos proibidos:** todos do Credenciamento (deny rule ativa).

**Gate:** Hearback humano sobre o conteudo do prompt antes do operador
colar no Codex.

### 5.5 MD-E: Pre-Quartas (rascunho de ritual sem ratificacao)

**Tema:** simular uma Quarta-zero pre-v204 apenas como prep, sem ratificar
nenhum ADR ainda. Producao de `auditoria/quartas/0000-pre-quarta-prep.md`.
**Pre-requisito:** ADRs P0 com cross-IA completos.
**Gate:** humano confirma se quer simular antes da Quarta 0 real.

### 5.6 Microdeltas pos-v204 (apenas listados — nao no escopo deste chat)

| MD | Tema |
|---|---|
| MD-X1 | ADR-008 ratificacao + execucao da migracao `Credenciamento/usehbn/` -> snapshot |
| MD-X2 | Onda "Documental Sanitization" (fusao de docs em 8 cernes) |
| MD-X3 | ADR-005 cross-IA + re-licenciamento Apache 2.0 |
| MD-X4 | Promocao publica do `~/Projetos/usehbn/` (release v0.3.0 + push GitHub) |
| MD-X5 | Quarta 0 inaugural |

## 6. Riscos e premissas deste bootstrap

| # | Risco/Premissa | Mitigacao |
|---|---|---|
| R1 | Discrepancia D1 (8 vs 12 principios) pode atrasar ADR-001 | ADR-009 listado como P0; debate em paralelo |
| R2 | Bastao de iteracao 0008 (Onda 3 do plano v0.3.0) ainda aberto desde 2026-04-29 | Item para humano: confirmar se chat-novo absorve Onda 3 ou observa apenas |
| R3 | RCA Codex (MICRO49) pode demorar mais que 1-3 dias | MD-D nao bloqueia MD-B/C; ADRs avancam em paralelo |
| R4 | Operador pode rejeitar Apache 2.0 (preferindo manter AGPLv3) | ADR-005 e P1 (nao bloqueia ADRs P0); decisao reversivel |
| R5 | Mapa de fusao §3 pode ter perda informacional ao implementar | Onda "Documental Sanitization" tera revisao linha-a-linha + cross-IA |
| A1 | Repo `~/Projetos/usehbn/` foi confirmado como git valido | `git status` no startup confirmou |
| A2 | Operador prefere convencao numerada com ponto-e-virgula no chat (1) ... ; 2) ...) | Aplicado a partir deste turno |
| A3 | Truth Barrier estrito: claims sem evidencia proibidos | Nenhum claim absoluto neste bootstrap |
| A4 | Glasswing G6: codigo no chat e proibido | Nenhum codigo VBA/python/json neste doc — so paths e snippets em blocos `markdown` para esqueleto |

## 7. Sinais HBN deste bootstrap

- ✅ **HBN ACTIVE** — chat-novo Opus 4.7 ativo; bastao F2 absorvido.
- 🟡 **HBN NEEDS HUMAN DECISION** — 5 perguntas pendentes (§8).
- ⚪ **HBN AUDIT-ONLY** sobre Credenciamento — nenhuma escrita ali; deny
  rules ativas em `.claude/settings.local.json`.
- 🧊 **HBN APP FROZEN** — Credenciamento congelado para Codex CLI; Opus
  chat-novo nao toca.
- 🔵 **HBN HANDOFF READY** — pacote pronto para o operador ratificar
  passo a passo.
- 🟣 **HBN PEER REVIEW** — todos os 9 ADRs P0/P1 marcados como exigentes
  de cross-IA antes de merge.
- 🟤 **HBN LICENSE SPLIT REQUIRED** — pendente ate ADR-005.

## 8. Itens em aberto para o operador (Hearback necessario)

1) **Bastao da Onda 3 (iteracao 0008)** — chat-novo absorve para
   prosseguir Relay Invariants em runtime, ou apenas observa enquanto
   foca em ADRs?

2) **Ordem de cross-IA** dos 5 ADRs P0 (001/002/003/004/009) — todas em
   paralelo, ou serial (ex.: 002 → 003 → 004 → 001 → 009)? Recomendacao
   Opus: serial 002 → 003 → 004 → 009 → 001 (Quarta depende dos outros).

3) **Janela do MD-D** (compor Prompt-Retomada-Codex-V204) — esperar RCA
   completo da nova sessao Codex, ou compor um prompt provisorio que ja
   cite ADRs marcados PROPOSED (sem aguardar ratificacao)?

4) **Apache 2.0 vs AGPLv3** (ADR-005) — manter recomendacao Apache 2.0,
   reverter para AGPLv3 (status quo), ou explorar 3a opcao
   (ex.: Apache 2.0 + CLA leve)?

5) **Discrepancia D1 (8 vs 12 principios)** — ADR-009 sobe a P0
   imediatamente, ou fica como preparatorio para Quarta 0 inaugural
   (pos-v204)?

## 9. Versao deste documento

- v1.0 — 2026-05-09 — Opus 4.7 chat-novo entrega bootstrap inicial com
  inventario do repo, mapa de fusao 35 → 8 cernes, esqueletos dos 9 ADRs
  (001-009), plano de microdeltas pre-v204-final, e 5 perguntas
  pendentes para Hearback humano.
