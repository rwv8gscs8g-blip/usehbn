# Mapa de Migração para a Exúvia — Genoma Auto-Contido

> **NÃO-NORMATIVO (fronteira) — insumo de pré-transição.**
> Este documento vive na zona livre (`docs/brainstorm/`), fora do scope-lock e
> sem peso normativo. Nada aqui vira regra até ser promovido a `core/` + ADR por
> uma onda formal (readback + cross-audit ≠-família + selagem). É insumo de
> planejamento para a 1ª exúvia do protocolo.

- **Autor:** analista-de-fronteira (Claude Opus 4.8, família Anthropic), read-only.
- **Data:** 2026-06-17.
- **Chapéu:** análise read-only — não toca caminho selado, não conta como cross-audit.

## Resumo (3 linhas)

A exúvia deve nascer **auto-contida**: o novo exoesqueleto carrega, ele mesmo, as
regras que o governam, sem depender de leitura na pasta antiga (que fica read-only
só para auditoria). Este mapa classifica cada artefato normativo em TRANSFERIR /
MELHORAR / ATUALIZAR / APOSENTAR, lista os ponteiros quebráveis que prenderiam o
novo ao velho, define o conjunto mínimo do "genoma auto-contido" e fixa a regra
de preservação dos antigos.

---

## 0. Convenções e Truth Barrier

Toda afirmação cita `arquivo:linha` ou `comando + saída`. O conceito-chave (do
humano): na muda, o protocolo renasce num novo exoesqueleto que **contém as regras
que o governam** (auto-contido); os arquivos antigos ficam na pasta original para
auditoria; os novos nascem leves e profundamente interconectados.

Mecânica da exúvia já existente no disco:

- `.hbn/active-version` é a fonte única da versão ativa; hoje vale `.` (incumbente
  0.3.x na raiz). Valor futuro `versao_X_Y_Z` aponta para a pasta da versão nova
  (`core/hbn-exuvia-scaffold.md:16-28`; verificado: `cat .hbn/active-version` → `.`).
- Os critérios de sobrevivência ao molt (8 critérios C-TEST…C-DEBT) estão em
  `core/exuvia-fitness-criteria.md:75-96`.
- O Fitness Gate (quando a versão inteira muda) é citado em
  `core/exuvia-fitness-criteria.md:70-73` e `core/hbn-exuvia-scaffold.md:12-14`.
- 21 guards compõem o runner (`guards/hbn-guards-runner.sh:50-71`).
- A bateria adversarial hoje vai de **B1 a B33** — cresceu desde os B1–B22 citados
  no doc conceitual (`grep -oE "B[0-9]+" guards/tests/adversarial-battery.sh`
  → B1..B33; o doc `exuvia-evolucao-conceitual.md:53` ainda diz "B1–B22": dívida
  de atualização ao migrar).

---

## A. Tabela de Migração dos Artefatos Normativos

Legenda das colunas de destino:

- **TRANSFERIR integral** — passou os 8 critérios ou é genoma essencial; entra na
  carapaça nova como está (após resolver ponteiros).
- **MELHORAR antes** — sobrevive, mas tem fragilidade/dívida a sanar antes do molt.
- **ATUALIZAR/reescrever** — conteúdo válido, porém os ponteiros/caminhos/banner
  mudam na exúvia e precisam ser reescritos para ficar auto-contido.
- **APOSENTAR (auditoria)** — fica só na pasta antiga, read-only, não migra.

### A.1 `core/` (specs normativas)

| Artefato | Destino | Justificativa (1 linha) | Ponteiros a resolver |
|---|---|---|---|
| `core/exuvia-fitness-criteria.md` | TRANSFERIR | É o próprio critério de sobrevivência ao molt; status accepted. | Atualizar placar retroativo (linhas 100-111) com B1–B33; ref a `state-report-spec`. |
| `core/hbn-exuvia-scaffold.md` | MELHORAR | Status `proposed`; é a máquina da muda — precisa estar accepted antes de governar a própria muda. | `guards/lib/common.sh::get_canonical_root` (:51); tag `hbn-exuvia/protocol-0.3.x` (:75); `scripts/hbn-exuvia-rollback.sh` (:79). |
| `core/role-cards.md` | TRANSFERIR | Porta da frente (G-FRONTDOOR) com read-list mínima; genoma. | Read-list cita `.hbn/relay/STATE.md` e 3 knowledge (linhas 9-12) — precisam co-migrar. |
| `core/orchestrator-profile-spec.md` | TRANSFERIR | Spec completa do orquestrador; referenciada pela porta. | `relacionado:` cita ADR-024/009/014/015/018/022/023 + relay-spec + knowledge (:13) — ver §B. |
| `core/roles-assignment-spec.md` | TRANSFERIR | Atribuição de chapéis (G-ROLE-FAMILY); genoma anti-groupthink. | `relacionado:` ADR-018/015 + relay-spec + cadence-d + guard (:11). |
| `core/relay-spec.md` | TRANSFERIR | STATE/read-list/continuidade — núcleo do "fio da meada". | Cita roles-spec §2 + `schemas/state.schema.json` (:110); knowledge 0022 (:128). |
| `core/state-report-spec.md` | MELHORAR | Relato de estado; candidato a exigir placar de 8 colunas (fitness:122). | `relacionado:` ADR-024/022 + relay/pointer-spec + knowledge 0002 (:12); orch-spec §3 (:84). |
| `core/start-rite-spec.md` | TRANSFERIR | Start-rite / front-door verificável; ataca o item 3 do roadmap. | `relacionado:` ADR-024/015/018/020 + roles-spec + guard (:12). |
| `core/dispatch-spec.md` | TRANSFERIR | Despacho auto-declarante (S2 sobreviveu — fitness:106). | Pareado a `schemas/dispatch.schema.json` + `guards/validate-dispatch.sh`. |
| `core/cadence-d.md` | MELHORAR | Template de auditoria/severidades; tem números de modelo hard-coded (ADR-015:16,89 apontam `cadence-d.md:20`). | Substituir nº de modelo por `handoff_threshold` (ADR-015:89); cita relay-spec (:32,77). |
| `core/pointer-spec.md` | TRANSFERIR | Define ponteiros honestos (G-POINTER); meta-genoma. | Exemplo embute path absoluto `/Users/.../usehbn/...` (:36) — ver §B (ponteiro absoluto). |
| `core/freeze-gate-spec.md` | TRANSFERIR | Freeze gate executável (ADR-017). | `relacionado:` ADR-017/016 + schema + guard + cadence-d (:11). |
| `core/dual-run-spec.md` | MELHORAR | Caracterização dual-run; ainda `proposed`/hearback pendente (schema:4). | Pareado a `schemas/dual-run-result.schema.json` + ADR-016. |
| `core/readback-spec.md` | TRANSFERIR | Rito de readback; genoma de rastreabilidade (C-TRACE). | Pareado a `schemas/readback.schema.json`. |
| `core/command-spec.md` | ATUALIZAR | Descreve superfície de comando do CLI Python (superfície fagocitável, não tronco — `exuvia-evolucao-conceitual.md:96`). | Realinhar à árvore Fronteira/Intermediária; CLI não é tronco da v1. |
| `core/dispatch-spec.md`/`semantic-layer.md`/`validation-rules.md`/`protocol.md` | TRANSFERIR (núcleo curto) | `protocol.md` é a definição mínima do protocolo (objetivos/fronteiras) — genoma de identidade. | `protocol.md` não tem ponteiros internos: já é auto-contido. |

### A.2 `methodology/` (arquitetura, princípios, ADRs)

| Artefato | Destino | Justificativa | Ponteiros a resolver |
|---|---|---|---|
| `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` | TRANSFERIR | Constituição P1–P13, peso idêntico; fonte canônica única (AGENTS.md:32-33). | É a fonte; o que aponta para ela (AGENTS.md, README) é que muda. P13 tem emenda candidata (conceitual §E). |
| `methodology/MATURITY-MATRIX.md` | TRANSFERIR | Fonte única de maturidade; nenhuma claim pública a excede (AGENTS.md:17). | Cita `docs/MATURITY-MATRIX.md` SUPERSEDED (:47) e `docs/PHAGOCYTOSIS.md` (:81) — refs a antigos, ver §B. |
| `methodology/ADR-AND-MD-PRIMER.md` | TRANSFERIR | Doutrina ADR+MD; base do fluxo de evolução. | Auto-contido (define o método). |
| `methodology/adr/ADR-009` (constituição) | TRANSFERIR | Define o rito de emenda constitucional (genoma de governança). | Cita `docs/PRINCIPLES.md` legado superseded (:16,60) + path `Credenciamento/` (:37) — ver §B. |
| `methodology/adr/ADR-011, 012, 014, 015, 017, 018, 020, 021, 023, 024, 025` | TRANSFERIR | ADRs que governam endereçamento, tiers, papéis, freeze, anti-teatro, auto-localização, hearback, start, naming — todos com guard/spec vivo. | `relacionado:` cruzam-se por path `core/`, `schemas/`, `guards/`, knowledge — co-migram (ver §B regra de path relativo). |
| `methodology/adr/ADR-003` (topologia) | ATUALIZAR | Descreve `core/→modules/` e banner SUPERSEDED de 1 release; a topologia muda na exúvia (versão=pasta). | Tabela de paths a atualizar (:138-141); plano `core/→modules/` (:125-143) precisa ser reescrito para a topologia versão_X_Y_Z. |
| `methodology/adr/ADR-008 / ADR-008-v2` (snapshot/credenciamento) | APOSENTAR | NÃO_RATIFICAR (bloqueado por v204 + MD-I, AGENTS.md:154); duas versões coexistem (legado). | Fica para auditoria; cita `Credenciamento/` e snapshot read-only (:97,141). |
| `methodology/adr/ADR-004, 005, 006, 007, 013, 016, 019, 022` | TRANSFERIR | Decisões aceitas com efeito vivo (semver, licença, sinais multi-repo, saúde, classes, dual-run, segurança defensiva, saída legível). | Refs cruzadas por path — co-migram. |
| `methodology/adr/INDEX.md` | ATUALIZAR | Índice dos ADRs; muda ao reorganizar série na nova pasta. | Conta "9 ADRs depositados" desatualizado vs 25 no disco — reescrever. |
| `methodology/templates/ADR-TEMPLATE.md`, `MD-TEMPLATE.md` | TRANSFERIR | Templates auto-localizáveis (ADR-021); genoma de forma. | Auto-contidos. |

### A.3 `guards/` (enforcement executável — CRISPR + proofreading)

| Artefato | Destino | Justificativa | Ponteiros a resolver |
|---|---|---|---|
| Os 21 guards do runner (`assert-canonical-root`, `forbid-tmp-worktree`, `forbid-env-files`, `forbid-legacy-paths`, `assert-scratch-*` ×3, `assert-scope-lock`, `assert-zona-livre`, `validate-dispatch`, `assert-dispatch-integrity`, `assert-self-path`, `assert-registry-line`, `assert-parallel-id`, `assert-pointer-honest`, `assert-knowledge-index`, `assert-frontdoor`, `assert-report-fresh`, `assert-no-stray-hbn`, `assert-role-family`, `assert-hearback-integrity`, `assert-exception-traceable`) | TRANSFERIR integral | São o enforcement fail-closed provado; já são version-aware via `get_canonical_root()` (scaffold:51). | Dependem de `guards/lib/common.sh`, `.hbn/active-version`, schemas e specs `.md` de origem — co-migram como bloco. |
| `guards/tests/adversarial-battery.sh` (B1–B33) | TRANSFERIR integral, OBRIGATÓRIO | **Locus CRISPR / memória imunológica.** Imunidade que esquece reexpõe a burlas resolvidas (`exuvia-evolucao-conceitual.md:53-54`). Carry-forward vertical é mandatório, não consultável-no-frio. | Atualizar racional/contagem (doc conceitual diz B1–B22; disco tem B1–B33). Cada B referencia um guard — co-migram juntos. |
| `guards/tests/` (suíte run-guard-tests) | TRANSFERIR | C-TEST (caso positivo+negativo) — prova de aptidão. | Co-migra com os guards. |
| `guards/lib/common.sh` | TRANSFERIR | Resolve raiz canônica version-aware — peça central da máquina da muda. | Núcleo da exúvia; sem ele os guards não resolvem a versão ativa. |
| `guards/hook-shims/pre-commit`, `commit-msg` | TRANSFERIR | Shims finos que leem `.hbn/active-version` e delegam; carregam o marcador `HBN_HOOK_SHIM_VERSION=M-A-20260614` (scaffold:46). | Marcador de versão muda a cada onda de exúvia — ATUALIZAR o token. |
| `guards/forbid-legacy-paths.sh` (G-LEG) | TRANSFERIR | **É a ferramenta de preservação-read-only dos antigos** (ver §D). Hoje sem alvos: `.hbn/forbidden-paths.txt` ausente (`cat` → erro, arquivo inexistente). | Na exúvia, popular `.hbn/forbidden-paths.txt` com os paths aposentados. |
| `guards/README.md`, `hbn-guards-runner.sh` | TRANSFERIR | Doc + orquestração dos guards. | README cita `core/`, `schemas/`, knowledge (linhas 53,99,111,120) — paths relativos, ok dentro da versão. |
| `guards/freeze-gate.sh` | TRANSFERIR | Freeze gate (ADR-017); pareado a spec+schema. | Co-migra com `core/freeze-gate-spec.md` + `schemas/freeze-checklist.schema.json`. |

### A.4 `schemas/` (contratos JSON)

| Artefato | Destino | Justificativa | Ponteiros a resolver |
|---|---|---|---|
| `state`, `dispatch`, `readback`, `hearback`, `handoff`, `result`, `freeze-checklist`, `dual-run-result`, `model-profile` `.schema.json` | TRANSFERIR | Contratos que os guards validam; genoma de interoperabilidade. | `description` cita `core/*-spec.md` e ADRs em texto (ex.: `freeze-checklist:4`, `dual-run-result:4`, `state:106`) — texto, não `$ref`: vira referência quebrada-de-prosa se a spec não co-migrar. Co-migrar specs pareadas. |
| `audit-pre`, `audit-post`, `autoevolve-cycle`, `connector-*`, `consent`, `guardian`, `intent` `.schema.json` | TRANSFERIR / ATUALIZAR | `connector-*`/`autoevolve` ligam-se ao CLI Python (superfície fagocitável). | `autoevolve-cycle` é embrionário/dívida de honestidade (`exuvia-evolucao-conceitual.md:95`): classificar na árvore Fronteira antes de migrar como tronco. |

### A.5 `.hbn/knowledge/` (lições reutilizáveis — memória portável)

| Artefato | Destino | Justificativa | Ponteiros a resolver |
|---|---|---|---|
| `0001` (comandos atômicos), `0002` (entrega minimalista), `0023` (área temporária) | TRANSFERIR integral | Citados na read-list da porta da frente (`core/role-cards.md:10-12`); genoma operacional. | Co-migram com a porta. |
| `0003, 0019, 0022, 0024, 0025` | TRANSFERIR | Lições aceitas (git sandbox, severidades/veto, firewall, zona-livre, auditor read-only) com uso vivo (INDEX). | `INDEX.md` exige que cada `.md` (exceto INDEX) seja citado (G-KNOW-INDEX) — manter invariante. |
| `INDEX.md` | TRANSFERIR | Ponteiro vivo da knowledge; validado por `assert-knowledge-index`. | Auto-contido (lista interna). |
| `distribution-model.md`, `relay-protocol.md`, `runtime-command-model.md` | MELHORAR | Sem número/temperatura ("decisão atual"); ligam-se ao CLI/distribuição. | Padronizar para o esquema numerado antes de migrar, ou classificar como árvore. |

---

## B. Ponteiros Quebráveis (referências que prenderiam o novo ao antigo)

Cada item: `arquivo:linha` → problema → como tornar auto-contido.

### B.1 Path ABSOLUTO de máquina (o pior tipo — quebra fora desta máquina e fora desta versão)

- `core/pointer-spec.md:36` — embute
  `file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-024-...`.
  **Correção:** trocar por path relativo à raiz da versão
  (`methodology/adr/ADR-024-orquestracao-start.md`). Path absoluto de usuário nunca
  deve entrar no genoma.

### B.2 Ponteiros para documentos SUPERSEDED / legados (o novo nasceria lendo o velho)

- `methodology/MATURITY-MATRIX.md:47` → cita `docs/MATURITY-MATRIX.md` (SUPERSEDED).
  **Correção:** o banner SUPERSEDED é informação de auditoria; a versão nova não
  deve carregar o ponteiro de volta — remover a nota ou movê-la para um apêndice de
  histórico que não é lido em runtime.
- `methodology/MATURITY-MATRIX.md:81` → `docs/PHAGOCYTOSIS.md`. **Correção:** se a
  doutrina de fagocitose migra, citar o destino novo; se fica para auditoria, não
  referenciar de dentro do genoma.
- `methodology/adr/ADR-009:16,60` → `docs/PRINCIPLES.md` (legado superseded).
  **Correção:** o ADR pode manter o registro histórico (é um ADR, append-only), mas
  a versão nova não deve depender de `docs/PRINCIPLES.md` existir; a fonte viva é
  `methodology/PRINCIPIOS-CONSTITUCIONAIS.md`.
- `methodology/adr/ADR-003` inteiro (linhas 125-143, 159, 185) — descreve a migração
  `core/→modules/` + banner SUPERSEDED por ≥1 release. **Correção:** esse plano é da
  topologia antiga; a exúvia usa `versao_X_Y_Z/` (não `modules/`). ATUALIZAR/reescrever
  o ADR-003 (ou emitir ADR sucessor) para a topologia versão=pasta — senão o novo
  nasce com instruções de uma migração que não vai acontecer.

### B.3 Ponteiros para o repositório externo `Credenciamento/` (founding app, fora do protocolo)

- `methodology/adr/ADR-008:59-60,141`, `ADR-009:37`, `ADR-005:122,133`,
  `ADR-001:16` → caminhos `~/Projetos/Credenciamento/...` e snapshot read-only.
  **Correção:** o protocolo NÃO deve depender do Credenciamento no runtime (P8:
  protocolo > sistema que ele constrói). Manter só como referência histórica em ADR
  (auditoria); a versão nova não lê nada de `Credenciamento/`.

### B.4 AGENTS.md — contrato de entrada apontando para topologia antiga

- `AGENTS.md:14` → `~/Projetos/usehbn/` como "local canonical" (path absoluto de
  usuário). **Correção:** referir-se à raiz da versão, não ao caminho de máquina.
- `AGENTS.md:26,64,69-70` → declara `modules/` como spec normativa e `core/`/`docs/`
  como **legacy partition superseded**. **Correção (crítica):** na exúvia, `core/` é
  o genoma vivo migrado para `versao_X_Y_Z/core/` (ou equivalente), não "legado".
  AGENTS.md precisa ATUALIZAR a topologia (modules/ nunca foi populado — é vazio) —
  caso contrário, o contrato de entrada do novo sistema descreve uma estrutura que
  não existe. Esse é o ponteiro quebrável mais perigoso: é o **primeiro arquivo que
  toda IA lê** (`AGENTS.md:6`).
- `AGENTS.md:152` → `docs/WAVE-PLAN-V0.3.0.md`; `:155` → cronograma autônomo em
  `auditoria/`. **Correção:** apontar para o plano vivo da versão nova ou para
  `.hbn/relay/STATE.md` (fonte viva), não para docs datados de 0.3.0.

### B.5 Specs/ADRs que se citam por path em `relacionado:` (cadeia interna)

- `core/orchestrator-profile-spec.md:13`, `roles-assignment-spec.md:11`,
  `state-report-spec.md:12`, `start-rite-spec.md:12`, `freeze-gate-spec.md:11`,
  `relay-spec.md:110,128` etc. citam `core/...`, `schemas/...`, `guards/...`,
  `methodology/adr/...`, `.hbn/knowledge/...`.
  **Diagnóstico:** estes são ponteiros **internos** e ficam corretos SE todos os
  alvos co-migrarem para a mesma versão e os paths forem **relativos à raiz da
  versão** (não absolutos). **Regra:** migrar em **blocos co-dependentes** (spec +
  schema pareado + guard + ADR + knowledge citados), nunca artefato isolado. O
  `get_canonical_root()` (scaffold:51) já resolve paths relativos à versão ativa —
  então paths relativos sobrevivem; paths absolutos (B.1, B.4) quebram.

### B.6 Schemas que citam specs em prosa (referência fraca)

- `schemas/freeze-checklist.schema.json:4`, `dual-run-result.schema.json:4`,
  `state.schema.json:106`, `audit-pre.schema.json:62` citam `core/*-spec.md` e ADRs
  no campo `description` (texto, não `$ref`). **Correção:** garantir que a spec
  pareada co-migre; se a spec for aposentada, atualizar a prosa. Não é quebra de
  validação (é texto), mas é ponteiro de proveniência que vira mentira se o alvo
  some.

### B.7 Hook-shims com marcador de versão fixo

- `core/hbn-exuvia-scaffold.md:46` → `HBN_HOOK_SHIM_VERSION=M-A-20260614` bloqueia o
  runner se o marcador não bater. **Correção:** a exúvia deve atualizar o marcador
  nos templates `guards/hook-shims/*` e reinstalar — senão o pre-flight falha fechado
  na versão nova (comportamento correto, mas exige passo explícito de migração).

### B.8 Números de modelo hard-coded na doutrina

- `core/cadence-d.md:20` (citado por `ADR-015:16,89`) embute nº de modelo.
  **Correção (já prevista):** trocar por `handoff_threshold` do perfil
  (`ADR-015:89`) antes do molt — evita que o genoma novo nasça preso a um modelo
  específico.

---

## C. Definição Operacional do "Genoma Auto-Contido"

**Genoma auto-contido** = o conjunto MÍNIMO de arquivos que, sozinhos, contêm
todas as regras que governam o novo sistema, de modo que uma IA possa operar a
versão nova **sem ler nada da pasta antiga** e sem path absoluto de máquina.

### C.1 Teste de auto-contenção (verificável, fail-closed)

Um candidato a genoma passa se, e somente se:

1. Toda referência interna é **relativa à raiz da versão** (resolvível por
   `get_canonical_root()` — scaffold:51); zero `file:///Users/...` (hoje viola em
   `pointer-spec.md:36`).
2. Nenhum arquivo do genoma **depende em runtime** de um path fora da versão
   (`docs/` antigo, `Credenciamento/`, `auditoria/` datada). Referências a esses só
   podem existir como nota de auditoria não-lida-em-runtime.
3. A porta da frente (`core/role-cards.md`) e tudo em sua read-list existem dentro
   da versão (STATE, readback ativo, knowledge 0001/0002/0023).
4. Os 21 guards do runner resolvem e passam contra a versão nova (`hbn-guards-runner.sh:50-71`).
5. A bateria adversarial B1–B33 transfere integral e passa (CRISPR obrigatório).

### C.2 Conjunto mínimo (o cromossomo)

**Camada 0 — máquina da muda + identidade**
- `.hbn/active-version` (fonte única da versão; scaffold:16)
- `core/hbn-exuvia-scaffold.md` (mecânica) + `core/exuvia-fitness-criteria.md` (8 critérios)
- `core/protocol.md` (definição/identidade mínima — já auto-contido)
- `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (P1–P13, fonte única)
- `methodology/MATURITY-MATRIX.md` (fonte única de maturidade)

**Camada 1 — porta da frente + continuidade (o "fio da meada")**
- `core/role-cards.md` (G-FRONTDOOR) + read-list: STATE, readback ativo,
  `.hbn/knowledge/0001`, `0002`, `0023`
- `core/relay-spec.md` + `core/state-report-spec.md` + `core/start-rite-spec.md`
- `core/pointer-spec.md` (após corrigir o path absoluto)

**Camada 2 — papéis + despacho + ritos**
- `core/orchestrator-profile-spec.md`, `core/roles-assignment-spec.md`,
  `core/dispatch-spec.md`, `core/readback-spec.md`, `core/cadence-d.md`,
  `core/freeze-gate-spec.md`
- ADRs vivos pareados (009, 011, 012, 014, 015, 017, 018, 020, 021, 023, 024, 025)
- `methodology/ADR-AND-MD-PRIMER.md` + `methodology/templates/*`

**Camada 3 — enforcement (proofreading) + memória imunológica (CRISPR)**
- `guards/lib/common.sh` + os 21 guards do runner + `guards/hbn-guards-runner.sh`
- `guards/hook-shims/*` (com marcador de versão atualizado)
- `guards/tests/adversarial-battery.sh` (B1–B33) + suíte de testes — **transferência
  vertical obrigatória**
- `guards/forbid-legacy-paths.sh` + `.hbn/forbidden-paths.txt` (a popular)

**Camada 4 — contratos**
- `schemas/*.schema.json` dos artefatos que o genoma usa (state, dispatch, readback,
  hearback, handoff, result, freeze-checklist, model-profile)

**Camada 5 — knowledge essencial**
- `.hbn/knowledge/INDEX.md` + 0001, 0002, 0003, 0019, 0022, 0023, 0024, 0025

**Fora do genoma (superfície fagocitável, entra por árvore, não como tronco):**
o CLI Python `src/usehbn/` (god-object `cli.py`, sem C-ADV — `exuvia-...:97`),
`autoevolve` (dívida de honestidade — `:95`), connectors. Nascem na árvore
Fronteira/Intermediária, não no tronco da v1 (`exuvia-evolucao-conceitual.md:96`).

### C.3 Invariante do CRISPR (não-negociável)

A bateria adversarial transfere **integralmente** para o genoma da versão nova,
nunca ao glacier: "lapidação pode reorganizar tudo, exceto apagar memória
imunológica" (`exuvia-evolucao-conceitual.md:54`). Imunidade que esquece = regressão
de segurança a cada salto. Verificável por: B1–B33 presentes na versão nova **e**
todas BLOQUEADAS (C-ADV, `exuvia-fitness-criteria.md:80`).

---

## D. Regra de Auditoria — como os antigos ficam preservados sem prender o novo

Princípio: **preservar antes de transformar (P1)** + **toda evolução reversível
(P6)**. Os antigos não somem; ficam read-only para auditoria; o novo não depende
deles.

### D.1 Onde os antigos ficam

- A pasta antiga (raiz atual / casca 0.3.x) **permanece no repositório** enquanto for
  âncora operacional (scaffold:90-91). Congelamento usa `git mv`, nunca `cp`, para
  não duplicar história (scaffold:85).
- Marcação anti-GC: tag `hbn-exuvia/protocol-0.3.x` aponta para o commit que congela
  a casca (scaffold:75) — preserva o histórico mesmo após a muda.
- Glacier só quando houver **duas cascas frias acumuladas**, com índice frio + ponteiro
  de consulta, e **nunca sem hearback humano + cross-audit** (scaffold:91-93).

### D.2 Como os antigos ficam read-only (mecanismo já existente)

- `guards/forbid-legacy-paths.sh` (G-LEG, no runner: `hbn-guards-runner.sh:53`) recusa
  qualquer commit que **toque** um caminho declarado legado. A lista vive em
  `.hbn/forbidden-paths.txt` (uma linha = um glob). **Hoje o arquivo não existe**
  (`cat .hbn/forbidden-paths.txt` → não encontrado), logo o guard libera por não ter
  alvos. **Ação na exúvia:** popular `.hbn/forbidden-paths.txt` com os paths
  aposentados (a casca antiga) → eles ficam fisicamente intocáveis, só legíveis.
- A mensagem do próprio guard ensina o caminho de preservação: "se precisa preservar
  como histórico: `git rm --cached` e deixar fisicamente intocado"
  (`forbid-legacy-paths.sh`, bloco "Como corrigir").

### D.3 Como os antigos ficam referenciáveis sem dependência

- Referências aos antigos só por **endereço de auditoria** (path + tag + commit),
  registradas em ADR (append-only) ou no índice de glacier — **nunca** como ponteiro
  lido em runtime pelo genoma (regra de C.1.2).
- O padrão de banner SUPERSEDED já existe no repo (ex.: `ADR-009:60`,
  `docs/MATURITY-MATRIX.md` via `MATURITY-MATRIX.md:47`): o documento antigo recebe
  banner apontando para o sucessor; o sucessor **não** aponta de volta para o antigo.
  A seta é unidirecional: antigo → novo (auditoria), nunca novo → antigo (dependência).

### D.4 Checklist de corte (resumo operacional)

1. `git mv` da casca para `versao_anterior/` (sem `cp`); tag anti-GC.
2. Popular `.hbn/forbidden-paths.txt` com a casca antiga → G-LEG a torna intocável.
3. `.hbn/active-version` aponta para a versão nova (`versao_X_Y_Z`).
4. Resolver todos os ponteiros da §B no genoma novo (paths relativos, sem `docs/`
   antigo, sem `Credenciamento/`, AGENTS.md reescrito).
5. Rodar os 21 guards + bateria B1–B33 na versão nova → tudo verde (fail-closed).
6. Rollback reconcilia token + STATE (scaffold:64-69); aplicação real só com
   `--apply` pelo operador após o Fitness Gate (scaffold:79-81).

---

## E. Síntese — riscos de migração (a submeter à auditoria adversarial ≠-família)

1. **AGENTS.md desatualizado** (§B.4) é o risco nº 1: é a porta de entrada de toda IA
   e descreve `modules/` (vazio) como tronco e `core/` como legado — o oposto do que
   a exúvia fará. Reescrever antes de qualquer corte.
2. **`docs/` antigo e `Credenciamento/`** são as duas fontes de dependência externa
   que mais prendem o novo ao velho (§B.2, §B.3). Nenhum ponteiro de runtime pode
   apontar para lá.
3. **CRISPR desatualizado**: o doc conceitual diz B1–B22, o disco tem B1–B33 — migrar
   a contagem/racional junto, ou a "memória imunológica" entra incompleta.
4. **`.hbn/forbidden-paths.txt` ausente hoje**: a ferramenta de preservação existe mas
   está desarmada — sem populá-la, a casca antiga fica editável (viola D.2).
5. **CLI Python como tronco**: erro de árvore — `cli.py`/`autoevolve` não passaram
   C-ADV/C-XAUDIT (`exuvia-...:97`); pertencem à Fronteira até provarem aptidão, não
   ao genoma da v1.

---

_Fim. Documento de fronteira, read-only, não-normativo. Promoção a regra exige onda
formal: readback + cross-audit ≥2 famílias ≠ autora (Anthropic) + decisão humana._
