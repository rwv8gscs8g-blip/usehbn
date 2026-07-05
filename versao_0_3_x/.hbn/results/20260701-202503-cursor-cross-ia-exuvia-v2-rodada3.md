---
tipo: audit-result
autor: cursor
familia: Cursor
path: .hbn/results/20260701-202503-cursor-cross-ia-exuvia-v2-rodada3.md
arvore: fronteira
created_at: "2026-07-01T20:25:03-03:00"
status: congelado
temperatura: glacier
---

SOU: cursor · familia Cursor · papel auditor adversarial READ-ONLY do useHBN

# Cross-audit — bootstrap exúvia versao_2_0_0 — RODADA 3 (pós-consolidação)

Auditoria adversarial read-only do bootstrap `versao_2_0_0/` (fable-5/Anthropic, 2026-07-01). CHAT NOVO, SEM MEMÓRIA. Nenhum arquivo fora de `.hbn/results/` foi alterado, escrito, staged ou commitado. Todas as medições foram feitas no disco atual via comandos reais (NÃO confiei em números do prompt). Parecer depositado no incumbente conforme rito.

**Contexto medido:** consolidação executada (relatório 20260701-201000 em ~/Projetos); emendas de texto em `versao_2_0_0/core/` + `BOOT.md` + `FITNESS-CHECKLIST.md` + `MANIFESTO-MIGRACAO.md` + `REGISTRY.md`. Despachos de nata-0/0b presentes em `versao_2_0_0/.hbn/messages/`, mas as edições de código correspondentes (version-aware em guards e harness) NÃO foram aplicadas no disco (ver V3 e V1). `.hbn/active-version` da raiz = "." (versão permanece INATIVA). `versao_2_0_0/` aparece como untracked no git.

---

## V1 — C-NOREG (vendorização sem regressão)

**Veredito: VERDE (diffs vazios nos 3 alvos)**

```bash
diff -r /Users/macbookpro/Projetos/usehbn/guards /Users/macbookpro/Projetos/usehbn/versao_2_0_0/guards
# (sem saída) exit 0
```

```bash
diff -r /Users/macbookpro/Projetos/usehbn/schemas /Users/macbookpro/Projetos/usehbn/versao_2_0_0/schemas
# (sem saída) exit 0
```

```bash
diff -r /Users/macbookpro/Projetos/usehbn/.hbn/knowledge /Users/macbookpro/Projetos/usehbn/versao_2_0_0/.hbn/knowledge
# (sem saída) exit 0
```

Paridade de conteúdo restaurada e mantida para guards/, schemas/, .hbn/knowledge/. Nenhuma alteração de lógica nos guards entre as duas cópias.

**Nota sobre divergência de comportamento de testes (não de arquivos):** ver V3. O bloco de read-list no harness e a resolução de hearback_ref ainda usam paths/caminhos do incumbente (pendente nata-0/0b conforme MANIFESTO-MIGRACAO.md:57-58). Isso não viola C-NOREG de arquivos (diff vazio), é exatamente a dívida declarada.

---

## V2 — Escrita confinada

**Veredito: VERDE**

```bash
git -C /Users/macbookpro/Projetos/usehbn status --short
# (somente linhas ?? untracked; ZERO linhas iniciando com M ou D)
```

Nenhum M/D em qualquer lugar. `versao_2_0_0/` inteiro aparece como ?? (novo), junto com artefatos pré-existentes em `.hbn/` e `docs/brainstorm/`. Nenhum arquivo do incumbente foi modificado ou deletado. Escrita confinada à pasta da exúvia, conforme exigido.

```bash
cat /Users/macbookpro/Projetos/usehbn/.hbn/active-version
# .
```

Incumbente permanece ativo.

---

## V3 — Suítes de teste (ambos os contextos)

### Bateria adversarial (B1–B96)

**Veredito: VERDE em ambos**

```bash
cd /Users/macbookpro/Projetos/usehbn && bash guards/tests/adversarial-battery.sh
# BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

```bash
cd /Users/macbookpro/Projetos/usehbn/versao_2_0_0 && bash guards/tests/adversarial-battery.sh
# BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

### Suíte de guards (run-guard-tests.sh)

**Root (incumbente):**
```bash
cd /Users/macbookpro/Projetos/usehbn && bash guards/tests/run-guard-tests.sh
# == resumo: 272 passaram, 0 falharam ==
# SUÍTE VERDE
```

**versao_2_0_0:**
```bash
cd /Users/macbookpro/Projetos/usehbn/versao_2_0_0 && bash guards/tests/run-guard-tests.sh
# == resumo: 271 passaram, 1 falharam ==
# SUÍTE VERMELHA
# ✗ readlist: templates+4 specs core sem referência quebrada — esperado pass, obtido rc=1
# ✓ readlist: referência quebrada é detectada (F-08) (esperado: block)
```

**Comparação e explicação da divergência:** 272 vs 271/1. A única falha na v2 é exatamente o caso "readlist: templates+4 specs core sem referência quebrada". Causa raiz: `REPO_ROOT="$(cd "$GUARDS_DIR/.." && pwd)"` dentro do contexto v2 resolve para `/.../versao_2_0_0`, onde `agents/role-templates.md` e os 4 specs core legados (`start-rite-spec.md` etc.) não existem. O caso de referência quebrada (F-08) continua BLOCK em ambos. 

Isso é **idêntico ao descrito na dívida nata-0b** (MANIFESTO-MIGRACAO.md:58; FITNESS-CHECKLIST §Registro de incidente e §Medições). Não é regressão nova nem adulteração — é o estado honesto enquanto a adaptação version-aware do harness não for aplicada (nata-0b). Os guards de lógica (assert-*) permanecem idênticos (C-NOREG de arquivos).

---

## V4 — Consolidação fiel (amostra ≥5 regras vinculantes)

| Regra (incumbente / guard) | Spec v2 (pós-consol) | Preservada / Emendada? | Evidência (arquivo:linha ou cmd) |
|---|---|---|---|
| **G-FRONTDOOR** (presença + teto + read-list ≤6) | `core/role-cards.md` (novo) | Criado na consolidação; ponteiro fino + 4 itens existentes | `versao_2_0_0/core/role-cards.md:21-29`; no run v2: `✓ frontdoor: role-cards valido passa` (assert-frontdoor.sh:19) |
| **I-10 (Relato de Leitura)** | `core/03-rito-da-onda.md` | Seção dedicada adicionada na consolidação; enforcement herdado | `versao_2_0_0/core/03-rito-da-onda.md:65-71`; `guards/assert-report-fresh.sh` (regra 6) |
| **P1–P13** | `core/01-principios.md` | Ponteiro corrigido `../methodology` → `../../methodology` | `versao_2_0_0/core/01-principios.md:17`; "P1–P13 (inalterados)" + nota de emenda constitucional |
| **Árvores (fonte de verdade)** | `core/04-artefatos.md §Árvores` | Reescrito: REGISTRY = fonte única; front-matter = espelho sem autoridade; dívida nata-3b declarada | `versao_2_0_0/core/04-artefatos.md:46-56` |
| **Quórum de selagem (G-QUORUM)** | `core/03-rito-da-onda.md` + `BOOT.md` | Mantido (≥2 famílias ≠ implementador) | `versao_2_0_0/core/03-rito-da-onda.md:29-30`; run tests: `✓ quorum: ...` |
| **Hearback humano apenas (G-HRB)** | `core/03-rito-da-onda.md` | Mantido; IA não preenche human_status | `versao_2_0_0/core/03-rito-da-onda.md:45-49` |
| **Temperatura + REGISTRY append-only** | `core/04-artefatos.md` | Mantido | `versao_2_0_0/core/04-artefatos.md:30-44` |
| **Anti-auto-emenda de escopo (G-SCOPE)** | `core/03-rito-da-onda.md` | Mantido + documentação de scope_extension | `versao_2_0_0/core/03-rito-da-onda.md:39-43` |

**Fidelidade às emendas da consolidação (relatório 20260701-201000):** 
- role-cards criado
- 01-principios: ponteiro fixado
- 03-rito: seção I-10 + scope_extension
- 04-artefatos: §Árvores reescrito (REGISTRY-centric)
- FITNESS atualizado (C-TEST honesto, anti-teatro, passo 0, C-XAUDIT r2)
- BOOT §10 + role-cards
- MANIFESTO + dívida nata-3b
- REGISTRY: linhas 20260701-21..23 (role-cards + 2 despachos)

Todas presentes e conferidas. Nenhuma regra vinculante sumiu sem HISTORICO/PENDENTE.

---

## V5 — Orçamento e legibilidade (R1)

```bash
wc -l /Users/macbookpro/Projetos/usehbn/versao_2_0_0/BOOT.md
# 161  (≤300) ✓
```

```bash
ls /Users/macbookpro/Projetos/usehbn/versao_2_0_0/core/*.md | wc -l
# 12  (no teto ≤12) ✓
# (01-principios,02-papeis,03-rito-da-onda,04-artefatos,05-guards,06-freeze-fitness-exuvia,07-projetos-membrana,08-evolucao, dual-run-spec, exuvia-fitness-criteria, freeze-gate-spec, role-cards)
```

Resumo executivo STATE:

```bash
# versao_2_0_0/.hbn/relay/STATE.md:34-53 (## Resumo executivo)
# 7 itens numerados, ~18-20 linhas de conteúdo (≤30) ✓
```

Leveza: BOOT + resumo + cartão de papel dentro da meta de <500 linhas de entrada (incumbente ~2500). BOOT declara-se "ÚNICA leitura obrigatória" com ponteiros explícitos.

---

## V6 — Brechas novas (tentativas concretas de burla)

| # | Tentativa de ataque / burla | Passa no disco atual? | Por quê (comando/evidência) |
|---|---|---|---|
| 1 | Ignorar role-cards e ler só BOOT para "frontdoor" | BLOQUEADO (agora) | G-FRONTDOOR exige core/role-cards.md; arquivo existe e teste frontdoor passa na v2 |
| 2 | Escrever fora de versao_2_0_0/ (ex.: editar guard no root) | BLOQUEADO | git status mostra 0 M/D; G-SCOPE + G-REG + G-SLF |
| 3 | Ativar v2 sem nata-0 (hearback_ref contra toplevel) | FAIL-CLOSED (herdado) | assert-role-family.sh:105 ainda usa repo_root (não ACTIVE_ROOT); bloqueia legítimo mas não abre bypass |
| 4 | Usar front-matter `arvore:` como autoridade para promoção | BLOQUEADO | core/04-artefatos.md:49-52 + G-ARVORE-LABEL usa REGISTRY; dívida nata-3b declarada |
| 5 | Declarar 272/272 na v2 antes da nata-0b | NÃO (honesto) | Medição real: 271/1 com falha explicada e declarada no MANIFESTO |
| 6 | Citar specs legados da raiz como "vigentes na v2" | Proibido por BOOT | BOOT §9 + temperatura; zona livre só com rito |
| 7 | Burlar bateria adversarial pós-consol | BLOQUEADO | B1–B96 todas BLOQUEADAS em ambos contextos (mesmo resultado) |
| 8 | Omitir Relato de Leitura (I-10) em handoff de entrada | BLOQUEADO | assert-report-fresh.sh regra 6 + doc em 03-rito |

**Síntese V6:** nenhuma brecha *nova* introduzida pelas emendas da consolidação. O G-FRONTDOOR blocker anterior foi fechado. As dívidas remanescentes (nata-0/0b, nata-1, nata-3b etc.) continuam fail-closed ou explicitamente declaradas. Bateria adversarial intacta.

---

## V7 — Fitness: os 8 critérios têm medição objetiva? Cláusula anti-teatro suficiente?

| # | Critério | Medição objetiva? | Teatro possível? | Evidência / nota |
|---|---|---|---|---|
| 1 | C-TEST | SIM (contagem + rc do run-guard-tests.sh nos 2 contextos) | Baixo (saída de terminal) | Medimos 272/0 × 271/1 |
| 2 | C-ADV | SIM (B1–B96 + "BATERIA VERDE") | Baixo | Ambos contextos verdes |
| 3 | C-XAUDIT | SIM (contar 4 pareceres + APROVA_EXUVIA_V2 + famílias) | Médio (precisa de 4 famílias reais) | Esta rodada coleta os 4 |
| 4 | C-DOG | SIM (freeze-gate exit 0 + tag + hearback) | Baixo se executado | Não executado nesta auditoria |
| 5 | C-FCLOSE | SIM (testes em repo isolado com active-version ausente/duplicado) | Baixo | Não executado aqui |
| 6 | C-NOREG | SIM (`diff -r` dos 3 alvos) | Baixo (comando determinístico) | Vazio (verde); comportamento de harness é dívida declarada |
| 7 | C-TRACE | PARCIAL (revisão humana/adversarial) | Alto sem amostra | Anti-teatro presente: amostra ≥10 exigida |
| 8 | C-DEBT | PARCIAL (revisão + lista de pendentes) | Alto sem amostra | Anti-teatro presente |

**Cláusula anti-teatro (C-TRACE/C-DEBT):** adicionada na consolidação (FITNESS-CHECKLIST.md:29-32) em resposta a achado FORTE da rodada 2. Exige lista explícita ≥10 elementos com `arquivo:linha`. Esta cláusula é **suficiente como mitigação** quando o auditor a cumpre (como faço abaixo). Sem a lista, o parecer seria NULO para o gate.

**Amostra C-TRACE (≥10 elementos do MANIFESTO-MIGRACAO.md conferidos):**

1. guards/ completo (33 assert + runner + ci + freeze + lib + hooks + tests) → versao_2_0_0/guards/   (MANIFESTO-MIGRACAO.md:22)
2. schemas/ (17 JSON) → versao_2_0_0/schemas/   (MANIFESTO-MIGRACAO.md:23)
3. .hbn/knowledge/ (0001-0032 + INDEX + ...) → versao_2_0_0/.hbn/knowledge/   (MANIFESTO-MIGRACAO.md:24)
4. core/exuvia-fitness-criteria.md etc. → versao_2_0_0/core/ (verbatim)   (MANIFESTO-MIGRACAO.md:25)
5. scripts/hbn-exuvia-rollback.sh → versao_2_0_0/scripts/   (MANIFESTO-MIGRACAO.md:26)
6. LICENSE → versao_2_0_0/LICENSE   (MANIFESTO-MIGRACAO.md:27)
7. AGENTS.md → BOOT.md   (MANIFESTO-MIGRACAO.md:33)
8. relay/readback/dispatch/cadence/start-rite/state-report/... → core/03-rito-da-onda.md   (MANIFESTO-MIGRACAO.md:35)
9. ADR-011/024/025 + arvores-spec + pointer-spec + REGISTRY → core/04-artefatos.md   (MANIFESTO-MIGRACAO.md:36)
10. ADR-020 + doutrina de chokepoints → core/05-guards.md   (MANIFESTO-MIGRACAO.md:37)
11. hbn-exuvia-scaffold + ... → core/06-freeze-fitness-exuvia.md   (MANIFESTO-MIGRACAO.md:38)
12. Consolidação 20260611 + P1–P13 → core/01-principios.md   (MANIFESTO-MIGRACAO.md:41)

Todos conferidos: destino declarado, nenhum "sumido sem rastro". Dívidas na seção PENDENTE todas com onda designada (nata-0 a nata-6 + pós-ativação). Nenhuma dívida oculta apontada.

---

## ACHADOS (deduplicados, pós-consolidação)

| ID | Severidade | Achado | Evidência |
|---|---|---|---|
| R3-1 | MARGINAL | Ondas nata-0 e nata-0b (despachos presentes e registrados) ainda não aplicadas no disco; divergência intencional 272/0 × 271/1 persiste | MANIFESTO-MIGRACAO.md:57-58; REGISTRY 20260701-22/23; medições V3; assert-role-family.sh:105 (usa repo_root) |
| R3-2 | FORTE (resolvido pela consol) | G-FRONTDOOR exigia role-cards ausente (bloqueador da r2) | Resolvido: core/role-cards.md criado + teste passa |
| R3-3 | MARGINAL | C-TEST no FITNESS menciona números específicos (271/272 sandbox, 268/272 operador) que não batem exatamente com esta medição (272/0 × 271/1); ambiente varia | FITNESS-CHECKLIST.md:47-53; nossas saídas de `run-guard-tests.sh` |
| R3-4 | MARGINAL | Bootstrap ainda untracked (não commitado); versao_2_0_0/ como ?? | git status --short |
| R3-5 | MARGINAL | 12 specs no core/ está no teto R1 (aceitável, sem exceder) | ls core/*.md | wc -l = 12 |

Nenhum achado BLOQUEADOR novo. Os bloqueadores da rodada 2 (adulteração de harness, role-cards ausente, I-10 omisso, ponteiros quebrados) foram endereçados pelas emendas.

---

## Nível de confiança e não-verificado

**Confiança:** ALTA em V1 (diffs), V2 (git status), V3 (saídas completas dos testes + adv battery), V5 (wc/ls diretos). MÉDIA-ALTA em V4 (amostra ≥8 regras + checagem das 8 emendas listadas no relatório de consolidação). MÉDIA em V6/V7 (análise adversarial + C-TRACE com amostra).

**O que NÃO verifiquei (escopo read-only, tempo, Truth Barrier):**
- Execução de C-DOG (freeze V206 real do Credenciamento + tag + hearback)
- C-FCLOSE em repo-teste isolado (active-version ausente/duplicado/conflito)
- Comportamento exato dos guards no chokepoint durante commit real do bootstrap (nunca rodei com --no-verify nem adicionei)
- Exaustividade 100% de todos os elementos do MANIFESTO (amostra ≥10 + spot-checks)
- Instalação de hook-shims pós-flip ou comportamento pós-`.hbn/active-version = versao_2_0_0`
- Rodadas de dogfooding reais por outras famílias além das medições mecânicas
- O relatório completo de consolidação 20260701-201000 além da seção lida (~150 linhas iniciais + trechos chave)

---

## Veredito

O estado medido no disco reflete a **consolidação fiel** das emendas da rodada 2 (role-cards criado, I-10 documentado, ponteiros corrigidos, árvores registry-centric, anti-teatro adicionado, orçamentos no teto ou abaixo, C-NOREG de arquivos verde). Escrita confinada, bateria adversarial integral, suítes com divergência explicada e declarada (nata-0b pendente). Nenhuma brecha nova aberta. Os principais bloqueadores da rodada 2 foram resolvidos.

As ondas nata-0/0b ainda não foram aplicadas (código version-aware ausente; 271/1 na v2 é o estado honesto esperado). Isso é dívida conhecida, não violação nova. C-TRACE/C-DEBT agora têm cláusula anti-teatro cumprida neste parecer.

APROVA_EXUVIA_V2: SIM
