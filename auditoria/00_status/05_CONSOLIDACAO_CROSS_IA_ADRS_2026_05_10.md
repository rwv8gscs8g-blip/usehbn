---
titulo: 05 - Consolidação Cross-IA dos 9 ADRs (Codex CLI + Antigravity)
diataxis: status
hbn-track: safe_track
hbn-status: active
audiencia: ambos
versao-protocolo: useHBN pre-v1
data: 2026-05-10
autor: Claude Opus 4.7 (chat arquiteto-mestre useHBN) — consolidação dos pareceres de Codex CLI e Antigravity (Gemini 3.1)
relacionado:
  - .hbn/results/0001..0010 (Codex CLI — JSON)
  - .hbn/results/0011..0020 (Antigravity — MD)
  - methodology/adr/ADR-001 a ADR-009
  - 03_PROMPT_CODEX_CROSS_IA_REVIEW.md
  - 04_PROMPT_ANTIGRAVITY_CROSS_IA_REVIEW.md
---

# 05. Consolidação Cross-IA dos 9 ADRs — 2026-05-10

> Este documento consolida os pareceres independentes de **Codex CLI**
> (perspectiva técnico-cirúrgica, JSONs `0001-0010`) e **Antigravity
> (Gemini 3.1)** (perspectiva conceitual-estratégica, MDs `0011-0020`)
> em recomendação operacional única por ADR. Onde as duas IAs
> convergiram, RATIFICAR é o caminho. Onde divergiram, prevalece a
> visão mais conservadora — em todos os casos deste ciclo, o Codex
> achou conflitos técnicos objetivos que Antigravity, por design da
> sua perspectiva, não tinha como ver.

## A. Sumário executivo (1 página)

### A.1 Validação da estratégia complementar

A divisão de papéis funcionou: Codex pegou conflitos objetivos no código
(ex.: divergência `PROTOCOL_VERSION` vs `__version__`); Antigravity
pegou riscos antropológicos (ex.: hierarquia de castas P1-P10 vs
P11-P13, alarme inferior de groupthink em métricas). Há zero
sobreposição substantiva — cada parecer agregou diferente.

### A.2 Decisão consolidada por ADR

| ADR | Codex | Antigravity | Consolidação Opus |
|---|---|---|---|
| ADR-001 Quarta | RATIFICAR_APÓS_RESSALVAS | RATIFICAR (com nota) | **RATIFICAR_APÓS_AJUSTES** (4 ajustes) |
| ADR-002 Tipologia | RATIFICAR_APÓS_RESSALVAS | RATIFICAR_APÓS_AJUSTES_NARRATIVOS | **RATIFICAR_APÓS_AJUSTES** (3 ajustes) |
| ADR-003 Topologia | RATIFICAR_APÓS_RESSALVAS | RATIFICAR | **RATIFICAR_APÓS_AJUSTES** (1 ajuste — plano de compatibilidade) |
| ADR-004 SemVer | **NÃO_RATIFICAR_AGORA** | RATIFICAR | **NÃO_RATIFICAR_AGORA** — divergência P0 entre `PROTOCOL_VERSION 0.3.0`, `__version__ 0.2.0`, `setup.cfg 0.2.0` precisa resolução técnica primeiro |
| ADR-005 Licença | RATIFICAR_APÓS_RESSALVAS | RATIFICAR | **RATIFICAR_APÓS_AJUSTES** (2 ajustes — checklist de 35 arquivos + decisão sobre enforcement DCO) |
| ADR-006 Sinais | RATIFICAR_APÓS_RESSALVAS | RATIFICAR | **RATIFICAR_APÓS_AJUSTES** (3 ajustes — colisão 🟠, runtime adapters, `.hbn/meta/`) |
| ADR-007 Métricas | RATIFICAR_APÓS_RESSALVAS | RATIFICAR_APÓS_AJUSTES_NARRATIVOS | **RATIFICAR_APÓS_AJUSTES** (3 ajustes — incluindo limite inferior groupthink do Antigravity) |
| ADR-008 Migração | **NÃO_RATIFICAR_AGORA** | RATIFICAR (cond. v204) | **NÃO_RATIFICAR_AGORA** — 3 pilares técnicos ausentes (scripts, checksum determinístico, doctor snapshot) + matriz origem→destino faltante |
| ADR-009 Constituição | RATIFICAR_APÓS_RESSALVAS | RATIFICAR_APÓS_AJUSTES_NARRATIVOS | **RATIFICAR_APÓS_AJUSTES** (4 ajustes — incluindo eliminar hierarquia P1-P10 vs P11-P13 do Antigravity) |

### A.3 Resultado final

- **7 ADRs** vão para `RATIFICAR_APÓS_AJUSTES` — execução em MDs subsequentes.
- **2 ADRs** (ADR-004 e ADR-008) vão para `NÃO_RATIFICAR_AGORA` — voltam à mesa para resolução técnica antes de Hearback final.

### A.4 Próximas microdeltas geradas por esta consolidação

| MD novo | Tema | Bloqueia |
|---|---|---|
| MD-H | Resolver divergência de versão (`__version__`, `PROTOCOL_VERSION`, `setup.cfg`) | ADR-004 |
| MD-I | Especificar `bin/usehbn-fetch.sh` + `bin/usehbn-verify.sh` + manifest determinístico + estender `hbn doctor` | ADR-008 |
| MD-J | Aplicar 7 conjuntos de ajustes nos ADRs 001/002/003/005/006/007/009 | promoção PROPOSED → ACCEPTED |
| MD-K | Auditoria pré-migração matriz origem→destino do `Credenciamento/usehbn/` | ADR-008 |

## B. Análise por ADR — pareceres cruzados + ajustes consolidados

### B.1 ADR-001 Quarta de Sanitização

**Codex (técnico):** APROVADO_COM_RESSALVA — 4 ressalvas não-bloqueantes; comando `hbn quarta --manual` ainda não existe; dependências do "Quarta 0" precisam alinhar (ADR-001 cita 002/003/004/009 mas Quarta 0 também exige 005/008); cláusula "todo MERGE traz rollback ADR" pode inflar ADRs se literal.

**Antigravity (conceitual):** RATIFICAR — diagrama mermaid bem desenhado; alerta antropológico forte: cargo cult, abuso da Quarta manual, decisões precipitadas se filas de API estiverem lentas.

**Convergência:** ambos aceitam direção; ressalvas complementares.

**Ajustes consolidados antes de ACCEPTED:**
1. Marcar `hbn quarta --manual` explicitamente como "contrato futuro pós-v0.3.0" no ADR §5.
2. Alinhar dependências do Quarta 0 — incluir 005 e 008 na lista de pré-requisitos (ADR §7).
3. Substituir "todo MERGE traz seu rollback ADR" por "todo MERGE traz seção `rollback` no MD ou ADR sucessor — rollback é obrigatório, criação de ADR novo não" (ADR §4.1).
4. Adicionar nota em §6: "Quarta manual não pode ser invocada mais de N vezes/mês sem revisão — limite anti-abuso a definir em ADR-007 métricas".

### B.2 ADR-002 Tipologia Founding/Consuming

**Codex (técnico):** APROVADO_COM_RESSALVA — 2 ressalvas bloqueantes:
(a) Contrato `useHBN-version` em AGENTS.md hoje é só documental (`docs/INTEGRATION-AGENTS-MD.md:105` diz que HBN não parseia AGENTS.md; sem schema; runtime não usa).
(b) ADR afirma que nem useHBN nem Credenciamento têm AGENTS.md raiz, mas `Credenciamento/AGENTS.md:1` existe.

**Antigravity (conceitual):** RATIFICAR_APÓS_AJUSTES_NARRATIVOS — termo "Founding" pode soar pretensioso; sugere frase didática no README ("O Credenciamento foi a fundição onde o HBN foi forjado; hoje, é apenas seu primeiro consumidor").

**Convergência:** ambos ratificam a tipologia; complementam ajustes.

**Ajustes consolidados antes de ACCEPTED:**
1. Corrigir afirmação errada no ADR-002: declarar que `Credenciamento/AGENTS.md` existe mas ainda **sem seção de dependência useHBN-version** (ADR §5.1 da decisão).
2. Declarar `useHBN-version` como **contrato documental inicial** (não enforcement automático em v0.3.0 — vira validação em `hbn doctor` na fase pós-MD-H/MD-I).
3. Adicionar frase didática Antigravity ao README pós-ratificação (MD subsequente).

### B.3 ADR-003 Topologia mono-repo modular

**Codex (técnico):** APROVADO_COM_RESSALVA — 1 ressalva bloqueante: renomeação `core/` → `modules/` precisa plano de compatibilidade. Conflitos: `README.md:406`, `README.md:421` referenciam `core/`; `site/index.html:40` aponta para `core/protocol.md` no GitHub; `agents/wave-protocol.md:155` inclui `core/` no grep doutrinário. Sem imports Python para `core/` em `src/usehbn/` (não é runtime), apenas superfície pública e doc.

**Antigravity (conceitual):** RATIFICAR — diagrama mermaid; alerta "arquitetura de astronauta" (criar pastas complexas antes de volume). Defere riscos de script ao Codex.

**Convergência:** ambos ratificam; Codex agrega o blast radius operacional.

**Ajustes consolidados antes de ACCEPTED:**
1. Adicionar §nova ao ADR-003: "Plano de compatibilidade core/ → modules/" — `core/` permanece como diretório legado com **redirect em README + banner em cada arquivo (`SUPERSEDED: see modules/...`) por ≥1 release**. MD subsequente lista os 4 arquivos a atualizar (README.md:406, README.md:421, site/index.html:40, agents/wave-protocol.md:155).
2. Não popular `modules/` na ratificação — apenas declarar a topologia. Fusão das ~35 docs vai como Onda Documental Sanitization separada (não bloqueia ADR-003).

### B.4 ADR-004 SemVer — **NÃO_RATIFICAR_AGORA**

**Codex (técnico):** **REPROVADO** — 3 ressalvas bloqueantes objetivas (P0):
- `src/usehbn/__init__.py:11` define `PROTOCOL_VERSION = "0.3.0"`
- `src/usehbn/__init__.py:29` define `__version__ = "0.2.0"`
- `setup.cfg:3` define `version = 0.2.0`
- `src/usehbn/cli.py:1079-1084` publica `protocol_version` usando `__version__` — **isto é um bug**: app consumidora chamando `hbn version` recebe `0.2.0` enquanto records gravados declaram `protocol_version 0.3.0`.

**Antigravity (conceitual):** RATIFICAR — alerta "fadiga de alarme" se MAJOR for banalizado; precedente Rust Edition System.

**Divergência forte:** Codex viu o que Antigravity, sem grep no código, não tinha como ver. **A visão técnica prevalece.**

**Decisão consolidada:** **NÃO_RATIFICAR_AGORA**. ADR-004 volta à mesa.

**MD-H (novo, P0) — pré-requisito antes de re-submeter ADR-004:**
1. Decidir distinção canônica entre `package_version` (CLI/PyPI) e `protocol_version` (schemas/records).
2. Corrigir `cli.py:1079-1084`: `hbn version` deve publicar **ambos** (`package_version` E `protocol_version`) ou explicitar qual.
3. Alinhar `__init__.py`, `setup.cfg`, `pyproject.toml` em fonte única.
4. Definir loader/migrador de records legados sem `protocol_version` antes do bump v1.0.0.
5. Reescrever ADR-004 §1 absorvendo essa distinção.

### B.5 ADR-005 Licenciamento Apache 2.0 + DCO

**Codex (técnico):** APROVADO_COM_RESSALVA — 2 ressalvas bloqueantes:
(a) Mudança de licença espalhada: 35 arquivos com refs `AGPL` (LICENSE, setup.cfg:8, README.md:466, CONTRIBUTING.md:60, headers em `src/usehbn/*.py`, `docs/LICENSING.md`). Risco de transição parcial deixar LICENSE Apache + headers AGPL = ambiguidade legal.
(b) DCO precisa decidir: enforcement no CI (`DCO check` GitHub Action) desde dia 1, ou só texto em CONTRIBUTING inicialmente.

**Antigravity (conceitual):** RATIFICAR — análise estratégica forte (Apache = "encanamento" como TCP/IP, K8s, Diataxis); DCO = sweet spot vs ICLA pesado; trade-off filosófico Apache absorbe "Humano no controle" pela governança humana, não pela coerção legal.

**Convergência:** ambos ratificam Apache + DCO; complementam ajustes.

**Ajustes consolidados antes de ACCEPTED:**
1. Adicionar §nova ao ADR-005: "Checklist completo de transição (35 arquivos)" — listar todos os arquivos no MD-G de execução, com gate "tudo ou nada" (não permitir transição parcial).
2. Definir explicitamente: **DCO check no CI fica para fase 2 (após CONTRIBUTING.md atualizado e exemplos de `git commit -s`)**. Fase 1 = só texto em CONTRIBUTING. Razão: evitar bloquear contribuidores antes de eles saberem da mudança. (Confirmado: `git log --format='%an'` retornou apenas Mauricio — autor único confirma re-licenciamento simples.)

### B.6 ADR-006 Sinais multi-repo

**Codex (técnico):** APROVADO_COM_RESSALVA — 2 ressalvas bloqueantes:
(a) Runtime adapters só conhecem 3 marcadores. `runtime.py:54-58` (`HBN_STATUS_MARKERS`); `runtime.py:186-190` injeta apenas esses 3; `core/command-spec.md:96-100` lista apenas 3.
(b) Persistência `signals-log.jsonl` depende de `.hbn/meta/` que `hbn init` não cria.

Achou também **colisão visual**: 🟠 já é `HBN SOURCE DRIFT` (sinal antigo) — ADR-006 propõe 🟠 `HBN BILLING WINDOW DRIFT`.

**Antigravity (conceitual):** RATIFICAR — alerta proliferação visual (15 sinais) → fadiga cognitiva humana; sugestão futura: condensar exibição para ≤3 sinais ativos por header.

**Convergência:** ambos ratificam direção; ajustes complementares.

**Ajustes consolidados antes de ACCEPTED:**
1. **Resolver colisão 🟠**: trocar `HBN BILLING WINDOW DRIFT` por outro emoji (sugestão Opus: ⏳ ou 💰 ou 🔶 — operador escolhe). Atualizar ADR-001, ADR-006 e memória.
2. Atualizar `runtime.py:54` (`HBN_STATUS_MARKERS`), `agents/wave-protocol.md:96`, `core/protocol.md:17` para listar 15 sinais (após resolver colisão).
3. Adicionar `.hbn/meta/` ao `hbn init` (`cli.py:999-1077`) — pequena alteração, baixo risco.
4. Definir schema mínimo para `signals-log.jsonl` (proposta Codex: `{signal, ts, origin_repo, destination, context}`).

### B.7 ADR-007 Métricas — Goodhart resolvido

**Codex (técnico):** APROVADO_COM_RESSALVA — 1 ressalva bloqueante: `bin/hbn-health.sh` e `hbn doctor --health` não existem; ADR fica como "contrato futuro" claro. Ressalvas não-bloqueantes: `total_docs_canonicos` precisa contar `docs/` durante transição; substituir "MIRROR-PROPAGATE force-push" por linguagem auditável.

**Antigravity (conceitual):** RATIFICAR_APÓS_AJUSTES_NARRATIVOS — **insight crítico:** `cross_ia_divergencia_pct < 5%` também é alarme (groupthink, viés de prompt). Recomenda limite inferior `<10%` como "Alarme de Viés/Alinhamento de Prompt".

**Convergência:** ambos ratificam; insight Antigravity (groupthink) é genuinamente novo.

**Ajustes consolidados antes de ACCEPTED:**
1. Adicionar à tabela §1: `cross_ia_divergencia_pct < 10%` = **🔍 HBN GROUPTHINK ALARM** (sinal novo a propor em ADR-006 v2 ou sub-ADR).
2. Declarar ADR-007 explicitamente como "contrato futuro pós-v0.3.0" — escolher superfície: **`hbn doctor --health`** (preferência Codex; reaproveita comando existente vs criar shell script paralelo).
3. Durante transição core+docs → modules+methodology, `total_docs_canonicos` conta `docs/` + `methodology/` + `modules/` (somatório).

### B.8 ADR-008 Migração snapshot — **NÃO_RATIFICAR_AGORA**

**Codex (técnico):** **REPROVADO** — 4 ressalvas bloqueantes objetivas:
- `bin/usehbn-fetch.sh` e `bin/usehbn-verify.sh` não existem (`bin/` inexistente).
- Algoritmo de checksum não é determinístico (sem manifest, ordenação, normalização de path/line endings, decisão sobre se PROTOCOL_SHA256.txt entra no hash).
- `hbn doctor` não verifica snapshot nem mirror drift (`cli.py:1096-1199` não tem essas checagens).
- Conteúdo do `Credenciamento/usehbn/` ainda não totalmente migrado (`methodology/`, `modules/`, `radar/`, `audits/`, `site/` ainda lá).

**Antigravity (conceitual):** RATIFICAR (cond. v204) — análise positiva do padrão *vendoring* (Go) vs submodule; defere mecânica do script ao Codex.

**Divergência:** Codex viu pilares técnicos ausentes que Antigravity não tinha como ver. **Visão técnica prevalece.**

**Decisão consolidada:** **NÃO_RATIFICAR_AGORA**. ADR-008 mantém-se BLOQUEADO até v204 final + 3 pilares técnicos.

**MD-I (novo, P0) — pré-requisito antes de re-submeter ADR-008:**
1. Especificar e implementar `bin/usehbn-fetch.sh` + `bin/usehbn-verify.sh`.
2. Definir `PROTOCOL_MANIFEST.json` determinístico: por arquivo, `path` relativo normalizado (POSIX), `size`, `sha256` por arquivo; hash final = sha256 do manifest serializado canonicamente.
3. Estender `hbn doctor` com checks: `snapshot_version`, `snapshot_checksum`, `mirror_drift`.
4. Adicionar `VERSION` raiz ao useHBN (não existe hoje).

**MD-K (novo, P0) — antes de remover Credenciamento/usehbn/:**
- Auditoria origem→destino com matriz de migração (`Credenciamento/usehbn/methodology/`, `modules/`, `radar/`, `audits/`, `site/`, `study-plans/` → destino correspondente em `~/Projetos/usehbn/`).

### B.9 ADR-009 Constituição P1-P13

**Codex (técnico):** APROVADO_COM_RESSALVA — 4 ressalvas não-bloqueantes:
(a) README.md:13 ainda aponta para `docs/MATURITY-MATRIX.md` ao falar de princípios.
(b) **P12 (Substrato Sólido = Rust)** pode ser interpretado como mandato imediato de migrar runtime Python; ADR deve explicitar "P12 orienta substrato futuro, não invalida runtime Python v0.3.0".
(c) `auditoria/cápsulas/` usa acento — preferível ascii em paths futuros.
(d) Pontos filosóficos deferidos a Antigravity.

**Antigravity (conceitual):** RATIFICAR_APÓS_AJUSTES_NARRATIVOS — **insight crítico:** eliminar hierarquia visual P1-P10 fundadores vs P11-P13 operacionais. "Constituição não pode ter castas." Listar plano 1 a 13. Histórico de promoção fica em metadado/rodapé.

Risco de "Inflação Constitucional" se P14, P15+ forem adicionados sem rigor — ADR já trata via "≥2 incidências reais" mas vale reforçar.

**Convergência:** ambos ratificam; insight Antigravity (eliminar castas) é narrativa-crítico.

**Ajustes consolidados antes de ACCEPTED:**
1. **Reescrever `methodology/PRINCIPIOS-CONSTITUCIONAIS.md`** removendo o cabeçalho "## Os 10 princípios constitucionais" / "## Os 3 princípios operacionais (P11-P13)". Listar P1 a P13 em sequência única. Origem (V1 da tese vs janela 2026-05-02→2026-05-06) vai como nota de rodapé/metadado por princípio.
2. Adicionar parágrafo em P12 (no PRINCIPIOS-CONSTITUCIONAIS.md) explicitando: "P12 orienta a Árvore Estável futura. NÃO invalida o runtime Python v0.3.0. Runtime atual e P12 coexistem; transição para Rust é processo plurianual via Phagocytosis."
3. Atualizar `README.md:13` para apontar tanto MATURITY-MATRIX (estado por componente) quanto PRINCIPIOS-CONSTITUCIONAIS (axiomas).
4. Padronizar `auditoria/capsulas/` (ascii) — sem acento. Renomear `cápsulas/` se já criado.

## C. Convergências e divergências — análise sistêmica

### C.1 ADRs com convergência completa entre Codex e Antigravity (ambos ratificam com ressalvas)

ADR-001, ADR-002, ADR-003, ADR-005, ADR-006, ADR-007, ADR-009 — **7 ADRs**. Pareceres complementam, não conflitam.

### C.2 ADRs com divergência forte (Codex REPROVA, Antigravity APROVA)

ADR-004 e ADR-008 — **2 ADRs**.

**Análise da divergência:** não é desacordo conceitual. Antigravity APROVOU porque a perspectiva conceitual é sólida; Codex REPROVOU porque encontrou o que Antigravity não tinha como ver (conflitos no código, scripts ausentes). **Esta é exatamente a função do cross-IA**: cobrir ângulos que cada IA sozinha não cobre. A consolidação Opus prevalece com a visão mais conservadora.

### C.3 Métrica auto-aplicada (preview ADR-007)

Aplicando a métrica `cross_ia_divergencia_pct` a este próprio ciclo:

- Pareceres totalmente convergentes: 7/9 = 78%
- Pareceres com divergência forte (Codex REPROVA, Antigravity APROVA): 2/9 = 22%

`22%` está **dentro da janela saudável** sugerida pela própria síntese: nem groupthink (>10% é OK) nem desalinhamento de prompts (>40% seria alarme). O ciclo cross-IA foi **válido como auditoria**.

### C.4 Insights não-óbvios (cada IA agregou valor próprio)

| Insight novo | Origem | Por que é importante |
|---|---|---|
| Divergência `PROTOCOL_VERSION 0.3.0` vs `__version__ 0.2.0` | Codex | Bug no `cli.py:1079-1084` que app consumidora vê |
| Colisão visual 🟠 SOURCE DRIFT vs 🟠 BILLING WINDOW DRIFT | Codex | Quebraria parse de IA cruzada |
| Hierarquia P1-P10 vs P11-P13 cria "castas" | Antigravity | Risco narrativo de constituição com peso desigual |
| Limite inferior `<10%` em `cross_ia_divergencia_pct` (groupthink) | Antigravity | Métrica DORA-like que vira meta cega — Antigravity preveniu |
| 35 arquivos com refs AGPL (não só LICENSE) | Codex | Risco de transição parcial criar ambiguidade legal |
| `hbn quarta --manual` não existe | Codex | Manter ADR-001 como contrato futuro, não capacidade atual |
| Análise comparativa MCP/LSP/OTel/Diataxis posicionando useHBN | Antigravity | Identidade pública: "camada cognitiva entre llms.txt e agents.md" |

## D. Plano de execução (próximas microdeltas)

| MD | Status | Pré-requisito | Output esperado |
|---|---|---|---|
| **MD-H** | **NOVO** P0 | nenhum | resolver divergência de versão; `__version__` × `PROTOCOL_VERSION` × `setup.cfg` em fonte única; `cli.py:1079-1084` corrigido; loader de records legados |
| **MD-I** | **NOVO** P0 | nenhum (independente) | `bin/usehbn-fetch.sh`, `bin/usehbn-verify.sh`, `PROTOCOL_MANIFEST.json` determinístico, extensão `hbn doctor` |
| **MD-J** | **NOVO** P1 | MD-H opcional | aplicar 7 conjuntos de ajustes nos ADRs 001/002/003/005/006/007/009 (revisões dos arquivos `.md`) |
| **MD-K** | **NOVO** P0 | nenhum | matriz origem→destino do `Credenciamento/usehbn/` para preparar ADR-008 |
| **MD-G** | inalterado | MD-J + ADR-005 ACCEPTED | re-licenciamento Apache 2.0 + DCO (35 arquivos) |
| **MD-C** | inalterado | ADR-002 ACCEPTED | criar `AGENTS.md` raiz do useHBN |
| **MD-E** | inalterado | ADRs P0 ratificados | pré-Quarta inaugural |

### D.1 Sequência recomendada Opus

```
MD-H (versão)  ────►  ADR-004 re-deposit  ────►  cross-IA  ────►  ACCEPTED
                                                                       │
MD-I (snapshot tooling)                                                │
                                                                       │
MD-K (matriz Credenciamento)  ─────► ADR-008 re-deposit   ────────────┤
                                                                       │
MD-J (ajustes 001/002/003/005/006/007/009)  ──► ACCEPTED em batch ◄────┤
                                                                       │
MD-G (re-licenciamento)  ◄───── ADR-005 ACCEPTED                       │
                                                                       │
MD-C (AGENTS.md raiz)  ◄──── ADR-002 ACCEPTED                          │
                                                                       │
MD-E (pré-Quarta)  ◄─── todos ADRs P0 ACCEPTED                         │
```

MD-H, MD-I, MD-K podem rodar em paralelo (independentes). MD-J pode acontecer em paralelo a MD-H/MD-I.

## E. Sinais HBN deste ciclo

- ✅ **HBN ACTIVE** — consolidação produzida; cross-IA entregou o que devia.
- 🟣 **HBN PEER REVIEW** — completo para 7 ADRs; pendente para 2 (004, 008) que voltam à mesa após MDs técnicos.
- 🟡 **HBN NEEDS HUMAN DECISION** — 2 itens pendentes (§F).
- 🔵 **HBN HANDOFF READY** — pacote completo; operador decide a sequência das próximas MDs.

## F. Itens em aberto para o operador

1) **Decisão sobre o emoji da `BILLING WINDOW DRIFT`** (resolução da colisão com 🟠 SOURCE DRIFT). Opções: ⏳ (ampulheta — semântica de tempo), 💰 (saco de dinheiro — semântica de faturamento), 🔶 (losango laranja — variação visual), 🪙 (moeda — semântica financeira). Recomendação Opus: **⏳** — preserva o sentido temporal da janela.

2) **Sequência de execução das MDs novas**: paralelo (MD-H + MD-I + MD-K simultâneos) ou serial? Recomendação Opus: **paralelo** — independentes, e MD-K + MD-I são pré-requisito comum para ADR-008.

## G. Versão

- v1.0 — 2026-05-10 — Opus 4.7 chat arquiteto-mestre — consolidação inicial dos pareceres Codex (10 JSONs) + Antigravity (10 MDs). Validação da estratégia complementar: 78% convergência total, 22% divergência onde Codex agregou conflitos técnicos objetivos. 7 ADRs ratificáveis após ajustes; 2 ADRs (004, 008) voltam à mesa.
