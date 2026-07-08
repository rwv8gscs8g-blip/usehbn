---
tipo: audit-result
autor: cursor
familia: Cursor
path: .hbn/results/20260701-194420-cursor-cross-ia-exuvia-v2-bootstrap.md
arvore: fronteira
created_at: "2026-07-01T19:44:20-03:00"
status: congelado
temperatura: glacier
---

SOU: cursor · familia Cursor · papel auditor adversarial READ-ONLY

# Cross-audit — bootstrap exúvia versao_2_0_0 (2ª passagem)

Auditoria adversarial read-only do bootstrap `versao_2_0_0/` (2026-07-01, fable-5/Anthropic). Nenhum arquivo do bootstrap alterado, sem staging, sem commit. Parecer depositado no incumbente conforme rito.

**Nota de reprodutibilidade:** existe parecer anterior `20260701-193407-cursor-cross-ia-exuvia-v2-bootstrap.md` na mesma família. Esta passagem reflete estado **atual** do disco (harness de testes modificado desde então).

---

## V1 — C-NOREG (vendorização sem regressão)

**Veredito: VERMELHO — diff de `guards/` NÃO vazio**

```bash
diff -rq /Users/macbookpro/Projetos/usehbn/guards /Users/macbookpro/Projetos/usehbn/versao_2_0_0/guards
# Files .../guards/tests/run-guard-tests.sh and .../versao_2_0_0/guards/tests/run-guard-tests.sh differ
# exit 1
```

```bash
diff -r /Users/macbookpro/Projetos/usehbn/schemas /Users/macbookpro/Projetos/usehbn/versao_2_0_0/schemas
# (sem saída) exit 0
```

```bash
diff -r /Users/macbookpro/Projetos/usehbn/.hbn/knowledge /Users/macbookpro/Projetos/usehbn/versao_2_0_0/.hbn/knowledge
# (sem saída) exit 0
```

**Único arquivo divergente:** `guards/tests/run-guard-tests.sh` (~33 linhas de diff). Trecho relevante (`versao_2_0_0/guards/tests/run-guard-tests.sh:3656-3685`):

- Comentário e alvos do teste read-list alterados de `agents/role-templates.md` + 4 specs incumbentes → `BOOT.md` + `core/02-05` + `read-list-canonica.txt`.
- Exceção adicionada para `.hbn/active-version` no scanner.
- Lógica de existência de path ampliada (`-e`, `-d`, `compgen`).

**Scripts assert-* (lógica de guard):** amostra verificada idêntica — `assert-quorum-selagem.sh`, `assert-scope-lock.sh`, `assert-hearback-integrity.sh` (diff -q sem saída).

**Conflito documental:** `MANIFESTO-MIGRACAO.md:18-22` e `core/05-guards.md:15-21` afirmam vendorização **sem alteração**; `FITNESS-CHECKLIST.md:45` declara C-NOREG **VERDE** com diffs vazios — **falso** nesta máquina.

---

## V2 — Escrita confinada

**Veredito: VERDE**

```bash
git -C /Users/macbookpro/Projetos/usehbn status --short
```

Resultado: **zero linhas com prefixo `M` (modificado)**. Apenas `??` (untracked), incluindo `versao_2_0_0/` inteira e classes A–E pré-existentes (`.hbn/messages/`, `.hbn/results/`, `docs/brainstorm/`, etc.) — coerente com handoff `20260701-090000-codex-prompt-handoff-novo-orquestrador-saneamento.md:28-29` que já descrevia árvore suja por untracked, não por modificação do incumbente.

```bash
cat /Users/macbookpro/Projetos/usehbn/.hbn/active-version
# .
```

Incumbente permanece ativo.

---

## V3 — Suítes de teste

### Bateria adversarial

**Veredito: VERDE (B1–B96)**

```bash
cd /Users/macbookpro/Projetos/usehbn/versao_2_0_0 && bash guards/tests/adversarial-battery.sh
# BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

### Suíte de guards

**Veredito: VERDE — 272/272 (paridade total com incumbente nesta máquina)**

```bash
cd /Users/macbookpro/Projetos/usehbn/versao_2_0_0 && bash guards/tests/run-guard-tests.sh
# == resumo: 272 passaram, 0 falharam ==
```

```bash
cd /Users/macbookpro/Projetos/usehbn && bash guards/tests/run-guard-tests.sh
# == resumo: 272 passaram, 0 falharam ==
```

**Comparação com expectativa do prompt (268–272, falhas nata-0 + 2 ambientais):** nenhuma falha observada. A dívida **nata-0** (`MANIFESTO-MIGRACAO.md:57`, `assert-role-family.sh:105` usa `repo_root` em vez de `ACTIVE_ROOT:80`) permanece no código mas **não reproduz falha** com `.hbn/active-version` = `.`.

**Achado crítico de causalidade:** a paridade 272/272 no v2 foi obtida **alterando** `run-guard-tests.sh` (V1 vermelho). O parecer anterior (193407) registrava 271/272 por harness apontando para paths incumbentes; a correção viola a promessa C-NOREG.

**Falhas DIFERENTES das declaradas:** nenhuma. Porém a estratégia de correção introduz divergência não declarada no MANIFESTO como PENDENTE.

---

## V4 — Consolidação fiel (amostra de 5 regras vinculantes)

| Regra (incumbente) | Spec v2 | Preservada? | Evidência |
|---|---|---|---|
| **Quórum de selagem** (≥2 famílias ≠ implementador) | `BOOT.md:79-81`, `core/02-papeis.md:18-20`, `core/03-rito-da-onda.md:29-30` | **SIM** | Incumbente: `core/orchestrator-profile-spec.md:178`; guard `assert-quorum-selagem.sh` idêntico |
| **Anti-auto-emenda de escopo** (G-SCOPE) | `core/03-rito-da-onda.md:39-41` | **SIM (enforcement)** / **PARCIAL (norma)** | Guard `assert-scope-lock.sh:143-148,297` exige `scope_extension` com `human/evidence/created_at/allowed_delta`; spec v2 não repete campos de `readback-spec.md:75-81` |
| **Nome universal ADR-025** | `core/04-artefatos.md:16-21`, `BOOT.md:93-94` | **SIM** | Incondicional; G-NUM herdado |
| **Hearback humano** (G-HRB) | `core/03-rito-da-onda.md:43-47` | **SIM** | Só humano confirma; assinatura SSH; guard idêntico |
| **Temperatura** (quente/frio/glaciar) | `core/04-artefatos.md:37-44`, `BOOT.md:98-99` | **SIM** | Ciclo completo + REGISTRY append-only |

### Regras possivelmente enfraquecidas ou ausentes da normativa legível

| Regra incumbente | Situação no v2 | Severidade |
|---|---|---|
| **RELATO DE LEITURA (I-10)** — `core/state-report-spec.md` §5 | Guard G-RLT ativo; `core/03-rito-da-onda.md:57-61` documenta só Relato de Estado | **FORTE** — enforcement opaco à IA que obedece BOOT |
| **Lei da Submissão (W-LEX)** — `orchestrator-profile-spec.md:171-179` | Parcial em `02-papeis.md:23-29`; knowledge 0029 vendorizada | **MARGINAL** |
| **G-FRONTDOOR / role-cards** | `assert-frontdoor.sh:19` exige `core/role-cards.md`; **arquivo inexistente** em v2 (0 matches glob) | **BLOQUEADOR** pós-flip |
| **ERP Link** — `readback-spec.md:87-89` | Sem menção em specs v2 consolidadas | **MARGINAL** — `command-spec.md` permanece HISTORICO no incumbente |
| **Matriz de escrita** | Declarativa (`actor-write-matrix.txt`); guard PENDENTE nata-1 | **FORTE** |

Nenhuma regra vinculante óbvia encontrada **sumida sem** HISTORICO/PENDENTE no manifesto, exceto gaps normativos (I-10, ERP) onde guards ainda mordem.

---

## V5 — Orçamento e legibilidade

```bash
wc -l /Users/macbookpro/Projetos/usehbn/versao_2_0_0/BOOT.md
# 160  (limite R1: ≤300) ✓

ls /Users/macbookpro/Projetos/usehbn/versao_2_0_0/core/*.md | wc -l
# 11  (8 consolidadas + 3 verbatim; limite R1: ≤12) ✓
```

Resumo executivo STATE: 19 linhas numeradas (`versao_2_0_0/.hbn/relay/STATE.md:36-52`, limite ≤30) ✓

### BOOT sozinho basta para IA nova começar com segurança?

**NÃO, de forma completa.**

1. `BOOT.md:40-41` exige cartão em `core/02-papeis.md`.
2. `core/01-principios.md:17` aponta P1–P13 para `../methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (fora da pasta v2).
3. Guards ativos exigem `core/role-cards.md` (`assert-frontdoor.sh:19`) — ausente; BOOT declara si como única entrada (`BOOT.md:14-17`) **sem alertar** que o runner legado bloqueará.
4. `core/read-list-canonica.txt:10-17` está em `PENDENTE_REHASH` — bastão de orquestrador não pode ser mecanicamente honesto até nata-3.

**Veredito V5:** orçamento numérico **VERDE**; suficiência operacional **AMARELA**.

---

## V6 — Brechas novas (versão=pasta + BOOT enxuto)

| # | Tentativa de ataque | Passa? | Por quê |
|---|---|---|---|
| 1 | IA opera só com BOOT, ignora guards legados | **Parcial** | Disciplina só; G-FRONTDOOR/G-ORQ ainda exigem artefatos v0.3.x |
| 2 | Auditor/implementador escreve fora da matriz de papel | **SIM (até nata-1)** | `G-ACTOR-WRITE-MATRIX` inexistente; matriz só declarativa (`02-papeis.md:63-65`) |
| 3 | Ativar v2 e commitar normativa governada | **FALHA no 1º commit** | `assert-frontdoor.sh:19-40` exige `core/role-cards.md` inexistente |
| 4 | Orquestrador assume bastão com read-list `PENDENTE_REHASH` | **SIM (teatro até nata-3)** | `read-list-canonica.txt:5-8` — hashes inválidos declarados |
| 5 | Citar specs incumbentes na raiz como regra vigente | **Parcial (doutrina)** | BOOT §11 proíbe; sem guard de temperatura em citação de chat |
| 6 | Declarar C-NOREG verde colando saída de diff incompleto | **SIM (teatro documental)** | `FITNESS-CHECKLIST.md:45` afirma diff vazio; `diff -rq guards` prova o contrário |
| 7 | `hearback_ref` pós-flip com paths da versão ativa (nata-0) | **Bloqueia (fail-closed)** | `assert-role-family.sh:105` — bloqueia legítimo, não abre bypass |
| 8 | Parecer de quórum só no chat | **NÃO** | `BOOT.md:148`; G-AUDITOR-ID + G-QUORUM |

**Síntese V6:** brecha real na **matriz de escrita** e **incoerência BOOT ↔ guards legados**; bateria B1–B96 permanece verde.

---

## V7 — Fitness: objetividade dos 8 critérios

| # | Critério | Medição objetiva? | Teatro possível? |
|---|---|---|---|
| 1 | C-TEST | **SIM** — comando + contagem | Baixo, se saída real |
| 2 | C-ADV | **SIM** — B1–B96 | Baixo |
| 3 | C-XAUDIT | **SIM** — contar pareceres + `APROVA_EXUVIA_V2` | Médio |
| 4 | C-DOG | **SIM** — freeze-gate exit 0 + tag | Baixo se freeze real |
| 5 | C-FCLOSE | **SIM** — repo-teste isolado | Baixo |
| 6 | C-NOREG | **SIM** — `diff -r` | **Teatro já ocorreu** — checklist declara verde sem diff real |
| 7 | C-TRACE | **PARCIAL** — auditor humano | **ALTO** — subjetivo |
| 8 | C-DEBT | **PARCIAL** — auditor adversarial | **ALTO** — meta-critério |

Critérios 7–8 não automatizáveis; compensação exige C-XAUDIT diligente (4 famílias).

---

## ACHADOS (deduplicados)

| ID | Severidade | Achado |
|---|---|---|
| A1 | **BLOQUEADOR** | C-NOREG falha: `guards/tests/run-guard-tests.sh` alterado; contradiz MANIFESTO/FITNESS/05-guards |
| A2 | **BLOQUEADOR** | `G-FRONTDOOR` exige `core/role-cards.md` (`assert-frontdoor.sh:19`); v2 não possui arquivo — 1º commit governado pós-flip falha |
| A3 | **BLOQUEADOR** | nata-0 (`assert-role-family.sh:105`) declarada ANTES da ativação (`MANIFESTO:57`) e não corrigida |
| A4 | **FORTE** | `G-ACTOR-WRITE-MATRIX` ausente — matriz sem dente (PENDENTE nata-1) |
| A5 | **FORTE** | `read-list-canonica.txt` em `PENDENTE_REHASH` — teatro de bastão até nata-3 |
| A6 | **FORTE** | RELATO DE LEITURA (I-10) ausente de `03-rito-da-onda.md`; G-RLT ainda exige |
| A7 | **FORTE** | Teatro de validação: `FITNESS-CHECKLIST.md:42-45` declara C-NOREG/C-TEST verdes inconsistentes com evidência desta auditoria |
| A8 | **MARGINAL** | P1–P13 fora da pasta v2 (`01-principios.md:17`) — viola espírito “só vigente” |
| A9 | **MARGINAL** | Concentração fable-5 compensada por C-XAUDIT ampliado — risco residual documentado |

---

## Veredito

O bootstrap entrega **confinamento de escrita**, **bateria adversarial integral** e **suíte 272/272** — mas a paridade de testes foi comprada com **alteração não declarada** do harness (`run-guard-tests.sh`), invalidando C-NOREG e a narrativa “vendorizado sem alteração”. Incoerência BOOT↔G-FRONTDOOR (A2), nata-0 não resolvida (A3) e enforcement pendente (A4–A5) impedem ativação segura.

Recomendação ao consolidador: (1) reclassificar alteração do harness no MANIFESTO como PENDENTE ou reverter e aceitar 271/272 até nata dedicada; (2) criar `core/role-cards.md` mínimo apontando para BOOT **ou** guard version-aware; (3) fechar nata-0; (4) emendar `03-rito-da-onda.md` com I-10 e detalhe de `scope_extension`.

**Nível de confiança:** alto em V1–V3 e V5 numérico; médio em V4 (amostra); médio-baixo em comportamento pós-flip (flip não simulado).

**Não verificado:** C-DOG (freeze V206); C-FCLOSE em repo-teste isolado; hooks instalados nesta máquina; exhaustividade C-TRACE elemento-a-elemento.

APROVA_EXUVIA_V2: NAO
