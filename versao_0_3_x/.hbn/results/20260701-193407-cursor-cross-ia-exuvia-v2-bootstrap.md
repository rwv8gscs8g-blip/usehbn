---
tipo: audit-result
autor: cursor
familia: Cursor
path: .hbn/results/20260701-193407-cursor-cross-ia-exuvia-v2-bootstrap.md
arvore: fronteira
created_at: "2026-07-01T19:34:07-03:00"
status: congelado
temperatura: glacier
---

SOU: cursor · familia Cursor · papel auditor adversarial READ-ONLY

# Cross-audit — bootstrap exúvia versao_2_0_0

Auditoria adversarial read-only do bootstrap `versao_2_0_0/` (2026-07-01, fable-5/Anthropic). Nenhum arquivo alterado, sem staging, sem commit.

---

## V1 — C-NOREG (vendorização sem regressão)

**Veredito: VERDE**

Evidência — diffs vazios (exit 0, sem saída):

```bash
cd /Users/macbookpro/Projetos/usehbn
diff -r guards versao_2_0_0/guards    # exit 0
diff -r schemas versao_2_0_0/schemas  # exit 0
diff -r .hbn/knowledge versao_2_0_0/.hbn/knowledge  # exit 0
```

Conferido em 2026-07-01T19:30-03:00 nesta máquina.

---

## V2 — Escrita confinada

**Veredito: VERDE**

```bash
git -C /Users/macbookpro/Projetos/usehbn status --short
```

Resultado: **zero arquivos com prefixo `M` (modificados)**. Apenas `??` (untracked), incluindo `versao_2_0_0/` inteira e classes A–E pré-existentes (`.hbn/messages/`, `.hbn/results/`, `docs/brainstorm/`, etc.) — coerente com o handoff `20260701-090000-codex-prompt-handoff-novo-orquestrador-saneamento.md` que já descrevia árvore suja por untracked, não por modificação do incumbente.

`.hbn/active-version` permanece `.` (incumbente ativo).

---

## V3 — Suítes de teste

### Bateria adversarial

**Veredito: VERDE (B1–B96)**

```bash
cd /Users/macbookpro/Projetos/usehbn/versao_2_0_0 && bash guards/tests/adversarial-battery.sh
```

Saída final: `BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.` (96/96 bloqueadas).

### Suíte de guards

**Veredito: PARIDADE PARCIAL — 1 falha ambiental documentada; sem falhas extras além do manifesto**

```bash
cd /Users/macbookpro/Projetos/usehbn/versao_2_0_0 && bash guards/tests/run-guard-tests.sh
# == resumo: 271 passaram, 1 falharam ==
```

Falha única:

```
✗ readlist: templates+4 specs core sem referência quebrada — esperado pass, obtido rc=1
```

Causa (código do harness, `versao_2_0_0/guards/tests/run-guard-tests.sh:3677-3682`): o teste referencia paths do **incumbente** (`$REPO_ROOT/agents/role-templates.md`, `core/start-rite-spec.md`, etc.) que não existem no contexto mínimo do desafiante. Coincide com a dívida **ambiental** declarada em `FITNESS-CHECKLIST.md:43-44`.

Comparação com incumbente na mesma máquina:

```bash
cd /Users/macbookpro/Projetos/usehbn && bash guards/tests/run-guard-tests.sh
# == resumo: 272 passaram, 0 falharam ==
```

**Sobre nata-0 (MANIFESTO-MIGRACAO.md:57):** com `.hbn/active-version` = `.`, os casos `fam:` e `str: bypass liveness` passaram (não reproduzi as 2 falhas exclusivas de 268/272 do manifesto). A lacuna em `assert-role-family.sh:105` (`repo_root` vs `ACTIVE_ROOT`) só se manifesta plenamente **após flip** para `versao_2_0_0` — dívida declarada, fail-closed, mas **não corrigida**.

**Achado:** contagem 271/272 ≠ 268/272 do manifesto; divergência explicável pelo `active-version` ainda apontar para `.`. Não é falha *diferente* da dívida declarada.

---

## V4 — Consolidação fiel (amostra de 5 regras vinculantes)

| Regra (incumbente) | Spec v2 | Preservada? | Evidência |
|---|---|---|---|
| **Quórum de selagem** (≥2 famílias ≠ implementador, G-QUORUM+G-DIVERSITY) | `BOOT.md:79-81`, `core/02-papeis.md:18-20`, `core/03-rito-da-onda.md:29-30` | **SIM** — texto equivalente ou mais explícito | Incumbente: `core/orchestrator-profile-spec.md:178` |
| **Anti-auto-emenda de escopo** (G-SCOPE) | `core/03-rito-da-onda.md:39-41`, `BOOT.md:146-147` | **SIM** — mesma proibição + guard herdado | B16 verde na bateria |
| **Nome universal ADR-025** | `core/04-artefatos.md:16-21`, `BOOT.md:93-94` | **SIM** — incondicional, sem regime serial paralelo | Guards G-NUM herdados intactos |
| **Hearback humano** (só humano confirma; G-HRB) | `core/03-rito-da-onda.md:43-47` | **SIM** — preserva assinatura e proibição de IA preencher `confirmed` | Guard `assert-hearback-integrity.sh` vendorizado |
| **Temperatura** (quente/frio/glaciar) | `core/04-artefatos.md:37-44`, `BOOT.md:98-99` | **SIM** — ciclo completo + REGISTRY | ADR-024/025 absorvidos no manifesto |

### Regras possivelmente enfraquecidas ou ausentes da normativa legível

| Regra incumbente | Situação no v2 | Severidade |
|---|---|---|
| **RELATO DE LEITURA (I-10)** — `core/state-report-spec.md` §5 | Guard G-RLT ainda exige (`versao_2_0_0/guards/assert-report-fresh.sh:137-154`), mas `core/03-rito-da-onda.md` só documenta **Relato de Estado** (§57-61), não o rito de **entrada** | **FORTE** — enforcement opaco à IA que lê só BOOT+03 |
| **Lei da Submissão pelo Exemplo** (W-LEX, `orchestrator-profile-spec.md:171-179`) | Parcial em cartão orquestrador (`02-papeis.md:23-29`); knowledge 0029 vendorizada, não citada no BOOT | **MARGINAL** — knowledge herdada cobre |
| **G-FRONTDOOR / role-cards** como porta de frente | `BOOT.md` declara entrada única; **não existe** `versao_2_0_0/core/role-cards.md`; guard `assert-frontdoor.sh:19` ainda exige `core/role-cards.md` | **BLOQUEADOR** pós-ativação — ver V6 |
| **Matriz de escrita papel→path** | Declarativa (`core/actor-write-matrix.txt`); enforcement **PENDENTE** nata-1 (`MANIFESTO-MIGRACAO.md:58`) | **FORTE** — regra (c) até guard nascer |

Nenhuma regra vinculante óbvia do v0.3.x encontrada **sumida sem** entrada HISTORICO/PENDENTE no manifesto, exceto o gap normativo do RELATO DE LEITURA na spec consolidada (guard ainda manda; texto não).

---

## V5 — Orçamento e legibilidade

```bash
wc -l versao_2_0_0/BOOT.md
# 160  (limite R1: ≤300) ✓

ls versao_2_0_0/core/*.md | wc -l
# 11  (8 consolidadas + 3 verbatim; limite R1: ≤12) ✓
```

Resumo executivo STATE: 18 linhas numeradas na seção (≤30) — `versao_2_0_0/.hbn/relay/STATE.md:34-52`.

### BOOT sozinho basta para IA nova começar com segurança?

**NÃO, de forma completa.** O BOOT é excelente como mapa e orçamento (`BOOT.md:126-141`), mas:

1. **Cartão de papel obrigatório** (`BOOT.md:40-41`) exige `core/02-papeis.md` — BOOT não é literalmente único.
2. **Princípios P1–P13** são ponteiro para `../methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (`core/01-principios.md:17`) — fora do BOOT; path relativo funciona da pasta v2, mas viola espírito “só leia a vigente”.
3. **Guards ativos** ainda exigem artefatos do desenho antigo (`role-cards`, `read-list-canonica` com `PENDENTE_REHASH`) — BOOT não alerta que G-FRONTDOOR/G-ORQ-ENTRADA **bloquearão** o primeiro commit pós-flip sem ondas natas 1–3.
4. **REGISTRY da versão v2** não existe ainda — primeira onda normativa precisará de instrução extra.

**Veredito V5:** orçamento numérico **VERDE**; suficiência operacional **AMARELA** (bootstrap honesto sobre ponteiros, mas subestima choque guard≠BOOT na ativação).

---

## V6 — Brechas novas (versão=pasta + BOOT enxuto)

| # | Tentativa de ataque | Passa? | Por quê |
|---|---|---|---|
| 1 | IA ignora orçamento R1 e lê `core/` inteiro antes de agir | **Parcial** | Só disciplina; sem guard de “bytes lidos”. Incumbente tinha G-FRONTDOOR+read-list como compensação — **v2 perde compensação sem substituto** |
| 2 | Commit em `versao_2_0_0/core/` fora do papel (ex.: auditor escreve spec) | **SIM (até nata-1)** | `G-ACTOR-WRITE-MATRIX` inexistente; só G-SCOPE/readback — auditor read-only não commita por rito, mas **não há dente mecânico na matriz** |
| 3 | Ativar `versao_2_0_0` e operar com BOOT como fronteira | **FALHA no 1º commit governado** | `assert-frontdoor.sh:19` exige `core/role-cards.md` inexistente na pasta v2 — runner fail-closed |
| 4 | Orquestrador assume bastão com `read-list-canonica.txt` em `PENDENTE_REHASH` | **SIM (teatro até nata-3)** | `versao_2_0_0/core/read-list-canonica.txt:10-17` — hashes não válidos; G-ORQ-ENTRADA não amarra leitura real ainda |
| 5 | `hearback_ref` relativo à versão ativa após flip (nata-0) | **Bloqueia (fail-closed)** | `assert-role-family.sh:105` usa `repo_root`, não `ACTIVE_ROOT:80` — bloqueia operações legítimas, não abre bypass (conforme manifesto) |
| 6 | Inserir norma nova em `versao_2_0_0/core/*.md` sem guard (viola R2) | **Parcial** | G-REG exige REGISTRY no mesmo commit; mas R2 (“só com guard+teste”) é **doutrina BOOT §117-118**, não guard dedicado — teatro possível até auditoria humana |
| 7 | Depositar parecer só no chat, sem `.hbn/results/` | **NÃO** | G-AUDITOR-ID + rito BOOT §148; quórum só conta arquivo canônico |
| 8 | `git commit --no-verify` no bootstrap | **NÃO** | Proibido BOOT §109; hook-shims herdados (quando instalados) |

**Síntese V6:** o desenho abre brecha real na **matriz de escrita** e na **coerência fronteira BOOT vs guards legados**; não abre bypass nas 96 burlas adversariais herdadas.

---

## V7 — Fitness: objetividade dos 8 critérios

| # | Critério | Medição objetiva? | Teatro possível? |
|---|---|---|---|
| 1 | C-TEST | **SIM** — comando + contagem | Baixo, se colar saída real |
| 2 | C-ADV | **SIM** — B1–B96 | Baixo |
| 3 | C-XAUDIT | **SIM** — contar pareceres + linha `APROVA_EXUVIA_V2` | Médio — exige ler 4 arquivos, não hash |
| 4 | C-DOG | **SIM** — `freeze-gate` exit 0 + tag | Baixo se freeze real |
| 5 | C-FCLOSE | **SIM** — repo-teste isolado | Baixo |
| 6 | C-NOREG | **SIM** — `diff -r` | Nenhum |
| 7 | C-TRACE | **PARCIAL** — “conferência do MANIFESTO por auditor” | **ALTO** — subjetivo; depende de auditor diligente (como esta auditoria) |
| 8 | C-DEBT | **PARCIAL** — “nenhuma dívida oculta apontada por auditor” | **ALTO** — meta-critério; só fecha com auditoria adversarial real |

Critérios 7–8 são inerentemente **não totalmente automatizáveis** — aceitável se C-XAUDIT exigir 4 famílias (compensação ao desenho concentrado em fable-5).

---

## ACHADOS (deduplicados)

| ID | Severidade | Achado |
|---|---|---|
| A1 | **BLOQUEADOR** | `G-FRONTDOOR` exige `core/role-cards.md`; v2 substitui por `BOOT.md` mas não criou `role-cards` nem emendou guard — **primeiro commit governado pós-flip falha** |
| A2 | **BLOQUEADOR** | Dívida **nata-0** (`assert-role-family.sh:105`) declarada mas não corrigida; manifesto exige correção **ANTES da ativação** |
| A3 | **FORTE** | `G-ACTOR-WRITE-MATRIX` ausente — matriz declarativa sem dente (`02-papeis.md:63-65`, PENDENTE nata-1) |
| A4 | **FORTE** | `read-list-canonica.txt` com `PENDENTE_REHASH` — bastão de orquestrador na v2 não pode ser mecanicamente honesto até nata-3 |
| A5 | **FORTE** | RELATO DE LEITURA (I-10) sumiu da normativa consolidada `03-rito-da-onda.md` mas guard G-RLT ainda exige — IA lê menos do que o commit exige |
| A6 | **MARGINAL** | C-TEST 271/272 vs incumbente 272/272 — 1 falha ambiental harness; paridade aceitável se declarada |
| A7 | **MARGINAL** | P1–P13 permanecem no incumbente (`methodology/`); leitura “só vigente” é violada na prática para princípios |
| A8 | **MARGINAL** | Concentração desenho+implementação em fable-5 compensada por C-XAUDIT ampliado — processo ok, risco residual documentado |

---

## Veredito

O bootstrap cumpre **C-NOREG**, **confinamento de escrita**, **bateria adversarial integral** e declara dívidas com honestidade rara. Porém **não está pronto para ativação nem para Fitness Gate completo**: incoerência BOOT↔G-FRONTDOOR (A1), nata-0 não resolvida (A2), e enforcement pendente da matriz de escrita e read-list (A3–A4) são bloqueios estruturais pré-flip. A consolidação normativa é substancialmente fiel nas 5 regras amostradas, com enfraquecimento documental em I-10 (A5).

Recomendação ao arquiteto-consolidador: emendar `core/03-rito-da-onda.md` (I-10), resolver A1 via `role-cards.md` mínimo apontando para BOOT **ou** micro-despacho Codex para guard version-aware; fechar nata-0 antes de flip; não marcar C-TEST verde até reproduzir paridade sob `active-version=versao_2_0_0`.

**Nível de confiança:** alto em V1–V3 e V5 numérico; médio em V4 (amostra, não exaustivo); médio-baixo em comportamento pós-flip (não simulei flip real de `active-version`).

**Não verificado:** C-DOG (freeze V206); C-FCLOSE em repo-teste isolado; comportamento com hooks instalados nesta máquina; exhaustividade C-TRACE elemento-a-elemento do manifesto (amostragem + buscas).

APROVA_EXUVIA_V2: NAO
