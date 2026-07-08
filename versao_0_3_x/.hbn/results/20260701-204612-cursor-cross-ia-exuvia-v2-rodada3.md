---
tipo: audit-result
autor: cursor
familia: OpenAI
papel: auditor-adversarial-read-only
status: congelado
temperatura: glacier
arvore: fronteira
path: .hbn/results/20260701-204612-cursor-cross-ia-exuvia-v2-rodada3.md
created_at: "2026-07-01T20:46:12-03:00"
alvo: versao_2_0_0
rodada: 3
repo: /Users/macbookpro/Projetos/usehbn
---

SOU: cursor · família OpenAI · papel AUDITOR adversarial READ-ONLY do useHBN

# Cross-audit — bootstrap exúvia versao_2_0_0 — RODADA 3 (pós-consolidação)

Auditoria adversarial READ-ONLY do bootstrap `versao_2_0_0/` (fable-5/Anthropic, 2026-07-01). CHAT NOVO, SEM MEMÓRIA. Nenhum arquivo fora de `.hbn/results/` foi alterado, escrito, staged ou commitado. Todas as medições foram feitas no disco via comandos reais; nenhum número do prompt foi confiado sem re-medição.

**Contexto medido:** consolidação rodada 2 executada (relatório `~/Projetos/20260701-201000-fable-5-relatorio-consolidacao-exuvia-v2-rodada2.md`); incidente rodada 1 revertido (`versao_2_0_0/FITNESS-CHECKLIST.md` §Registro de incidente). `.hbn/active-version` da raiz = `.` (incumbente ativo). `versao_2_0_0/` permanece untracked (`??`).

**Ambiguidade resolvida por medição:** o prompt declara auditoria "pós-ondas nata-0/nata-0b". No disco, **as ondas não foram aplicadas** — apenas despachos `status: proposto` existem; código inalterado. Este parecer reporta o estado real, não a premissa aspiracional.

---

## V1 — C-NOREG (vendorização sem regressão)

**Veredito: VERDE**

```bash
cd /Users/macbookpro/Projetos/usehbn
diff -r guards versao_2_0_0/guards      # saída vazia, exit 0
diff -r schemas versao_2_0_0/schemas    # saída vazia, exit 0
diff -r .hbn/knowledge versao_2_0_0/.hbn/knowledge  # saída vazia, exit 0
```

Paridade física absoluta nos três alvos. Nenhuma linha divergente. O incidente da rodada 1 (harness adulterado só na v2) permanece revertido; patch preservado em `versao_2_0_0/docs/incidente-20260701-harness-rodada1.patch`.

**Nota:** paridade de arquivos ≠ paridade de comportamento da suíte no contexto v2 (ver V3). C-NOREG como `diff -r` vazio está atendido; C-TEST no contexto v2 não.

---

## V2 — Escrita confinada

**Veredito: VERDE (critério literal M/D)**

```bash
git -C /Users/macbookpro/Projetos/usehbn status --short
# ZERO linhas com prefixo M ou D em qualquer path
# versao_2_0_0/ aparece como ?? (untracked)
```

Nenhum arquivo rastreado modificado ou deletado. Escrita do bootstrap confinada à pasta da exúvia (untracked). Existem dezenas de `??` pré-existentes fora de `versao_2_0_0/` (`.hbn/messages/`, `docs/brainstorm/`, etc.) — ruído histórico, não M/D do bootstrap.

**Risco operacional (não viola V2 literal):** bootstrap inteiro ainda não commitado; vetor untracked documentado no incidente rodada 1 permanece aberto até commit de classe própria.

---

## V3 — Suítes nos DOIS contextos

### run-guard-tests.sh

| Contexto | Comando | Resultado | Exit |
|---|---|---|---|
| Raiz (incumbente) | `cd usehbn && bash guards/tests/run-guard-tests.sh` | `272 passaram, 0 falharam` — SUÍTE VERDE | 0 |
| v2 (desafiante) | `cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh` | `271 passaram, 1 falharam` — SUÍTE VERMELHA | 1 |

**Única falha v2:**
```
✗ readlist: templates+4 specs core sem referência quebrada — esperado pass, obtido rc=1
✓ readlist: referência quebrada é detectada (F-08) (esperado: block)
```

**Causa raiz (medida):** em ambas as cópias idênticas do harness, `REPO_ROOT="$(cd "$GUARDS_DIR/.." && pwd)"` resolve para o diretório pai do `guards/`. No contexto v2 isso é `/.../versao_2_0_0`, onde **não existem** `agents/role-templates.md` nem os 4 specs legados (`core/start-rite-spec.md`, `core/orchestrator-profile-spec.md`, `core/pointer-spec.md`, `core/state-report-spec.md`). O bloco fixo em `guards/tests/run-guard-tests.sh:3677-3682` ainda aponta para esses paths do incumbente.

No contexto raiz, os mesmos paths existem → passa. Divergência **272/0 × 271/1** é determinística, não ambiental.

**Relação com nata-0b:** dívida declarada em `versao_2_0_0/MANIFESTO-MIGRACAO.md:58`; despacho `versao_2_0_0/.hbn/messages/20260701-200800-fable-5-despacho-nata-0b-harness-readlist-v2.md` com `status: proposto`. **Implementação ausente** — o harness continua byte a byte igual ao incumbente (coerente com V1 vazio).

**Relação com nata-0:** `guards/assert-role-family.sh:80` calcula `ACTIVE_ROOT`, mas `:105` dereferencia `hearback_ref` contra `repo_root`, não `ACTIVE_ROOT`. Despacho nata-0 (`20260701-200700-...`) também `status: proposto`. Fail-closed (não abre bypass), mas impede paridade honesta pós-flip.

### adversarial-battery.sh (B1–B96)

| Contexto | Resultado |
|---|---|
| Raiz | `BATERIA VERDE — toda burla documentada foi BLOQUEADA` (B1–B96 ✓) |
| v2 | Idêntico — `BATERIA VERDE` (B1–B96 ✓) |

Paridade perfeita na bateria adversarial. Nenhuma divergência.

**Veredito V3:** FALHA objetiva de C-TEST no contexto v2 (SUÍTE VERMELHA). Divergência explicada e declarada como dívida nata-0b, mas **não resolvida** — contradiz a premissa "pós-ondas nata-0/nata-0b" do prompt e o passo 0 de `versao_2_0_0/FITNESS-CHECKLIST.md:100-102`.

---

## V4 — Consolidação fiel (amostra ≥5 regras vinculantes)

**Veredito: ATENDIDO (emendas textuais da consolidação presentes e coerentes com guards herdados)**

| Regra | Spec v2 | Preservada? | Evidência |
|---|---|---|---|
| **G-FRONTDOOR** × role-cards | `core/role-cards.md` (novo) | Sim — ponteiro fino | Guard: `guards/assert-frontdoor.sh:19-21` (path, 140 linhas, 8192 bytes, PARTE A ≤6). Artefato: `versao_2_0_0/core/role-cards.md:21-28` (4 itens, paths existentes). 35 linhas, 1210 bytes. |
| **I-10** × rito | `core/03-rito-da-onda.md` | Sim — seção adicionada | `versao_2_0_0/core/03-rito-da-onda.md:65-71` (heading `## RELATO DE LEITURA`, citação `arquivo:linha`). Enforcement: `guards/assert-report-fresh.sh:137-155`. |
| **P1–P13** × princípios | `core/01-principios.md` | Sim — ponteiro corrigido | `versao_2_0_0/core/01-principios.md:15-18` → `../../methodology/PRINCIPIOS-CONSTITUCIONAIS.md`; `test -f methodology/PRINCIPIOS-CONSTITUCIONAIS.md` → OK. |
| **Árvores** × artefatos | `core/04-artefatos.md §Árvores` | Sim — registry-centric + dívida | `versao_2_0_0/core/04-artefatos.md:46-56` (REGISTRY fonte única; front-matter espelho; nata-3b declarada). Guard `assert-arvore-label.sh` herdado. |
| **Quórum selagem** | `core/03-rito-da-onda.md` | Sim | `versao_2_0_0/core/03-rito-da-onda.md:29-30` (2× APROVA, famílias distintas ≠ implementador). |
| **Anti-auto-emenda G-SCOPE** | `core/03-rito-da-onda.md` | Sim | `versao_2_0_0/core/03-rito-da-onda.md:37-43` (`scope_extension` com campos documentados). |

Emendas do consolidador (relatório 20260701-201000) conferidas: role-cards criado, I-10 documentado, ponteiros P1–P13 corrigidos, §Árvores reescrito, FITNESS retificado, BOOT §10, MANIFESTO nata-3b, REGISTRY linhas despachos. Nenhuma regra vinculante sumiu sem PENDENTE.

**Ressalva:** fidelidade textual ≠ prontidão de ativação (nata-0/0b pendentes).

---

## V5 — Orçamento

**Veredito: DENTRO DOS TETOS (core/*.md no teto exato)**

```bash
wc -l versao_2_0_0/BOOT.md                    → 161  (≤300 ✓)
ls versao_2_0_0/core/*.md | wc -l             → 12   (≤12 — NO TETO ✓)
# Resumo executivo STATE: linhas 36-52 = 17 linhas de conteúdo (≤30 ✓)
```

Lista dos 12 specs: `01-principios`, `02-papeis`, `03-rito-da-onda`, `04-artefatos`, `05-guards`, `06-freeze-fitness-exuvia`, `07-projetos-membrana`, `08-evolucao`, `dual-run-spec`, `exuvia-fitness-criteria`, `freeze-gate-spec`, `role-cards`.

Risco marginal: qualquer spec adicional exige reorganização ou dívida explícita (teto consumido por `role-cards.md` da consolidação).

---

## V6 — Brechas novas (tentativas concretas)

| # | Tentativa | Resultado | Evidência |
|---|---|---|---|
| 1 | Aceitar narrativa "pós-nata-0/0b" sem código | **FALHOU** | Despachos `status: proposto`; `assert-role-family.sh:105` ainda `repo_root`; harness `:3677-3682` ainda paths incumbente; v2 SUÍTE VERMELHA |
| 2 | Burlar C-NOREG mantendo harness idêntico | **Passa V1, falha V3** | diff vazio + 271/1 no contexto v2 |
| 3 | Escrever guard no incumbente durante bootstrap | **BLOQUEADO** | git status: 0 M/D |
| 4 | Ativar v2 via `.hbn/active-version` sem Fitness Gate | **BLOQUEADO (herdado)** | G-PTR + FITNESS exige hearback + 8 critérios |
| 5 | Frontdoor inflado (>140 linhas / >6 itens) | **BLOQUEADO** | B25/B30 adversarial + `assert-frontdoor.sh` |
| 6 | Usar front-matter `arvore:` como autoridade | **BLOQUEADO** | `04-artefatos.md:49-56` + G-ARVORE-LABEL; promoção vedada até nata-3b |
| 7 | Depositar parecer sem SOU/família coerente | **BLOQUEADO** | G-AUDITOR-ID |
| 8 | Reportar 272/272 na v2 antes da nata-0b | **DETECTÁVEL** | Medição real: 271/1; FITNESS §Registro de incidente documenta padrão de adulteração |

Nenhuma brecha **nova** silenciosa introduzida pelas emendas da consolidação. Vetor histórico real: escrita untracked fora do chokepoint (incidente rodada 1).

---

## V7 — Fitness (8 critérios + cláusula anti-teatro)

| # | Critério | Medição objetiva? | Estado medido |
|---|---|---|---|
| 1 | C-TEST | Sim (contagem + rc) | **FALHA v2** (271/1); raiz VERDE (272/0) |
| 2 | C-ADV | Sim (B1–B96) | VERDE ambos contextos |
| 3 | C-XAUDIT | Sim (contagem pareceres) | Rodada 3 em curso (4 famílias) |
| 4 | C-DOG | Sim (freeze-gate) | Não executado nesta auditoria |
| 5 | C-FCLOSE | Sim (repo-teste) | Não executado nesta auditoria |
| 6 | C-NOREG | Sim (`diff -r`) | VERDE (vazio) |
| 7 | C-TRACE | Parcial (amostra humana) | Cláusula anti-teatro presente |
| 8 | C-DEBT | Parcial (inventário humano) | Cláusula anti-teatro presente |

**Cláusula anti-teatro** (`versao_2_0_0/FITNESS-CHECKLIST.md:29-32`): parecer sem amostra ≥10 com `arquivo:linha` é NULO para o gate. É avanço processual da consolidação rodada 2, mas **não substitui mecânica** — depende de auditor honesto e operador que leia evidências.

### Amostra C-TRACE (≥10 elementos do MANIFESTO conferidos)

1. `guards/` → `versao_2_0_0/guards/` — `MANIFESTO-MIGRACAO.md:22`
2. `schemas/` → `versao_2_0_0/schemas/` — `:23`
3. `.hbn/knowledge/` → `versao_2_0_0/.hbn/knowledge/` — `:24`
4. `core/exuvia-fitness-criteria.md` (verbatim) — `:25`
5. `scripts/hbn-exuvia-rollback.sh` — `:26`
6. `LICENSE` — `:27`
7. `AGENTS.md` → `BOOT.md` — `:33`
8. `relay-spec` + readback/dispatch → `core/03-rito-da-onda.md` — `:35`
9. `arvores-spec` + ADR-011/024/025 → `core/04-artefatos.md` — `:36`
10. `validation-rules` + ADR-020 → `core/05-guards.md` — `:37`
11. `hbn-exuvia-scaffold` → `core/06-freeze-fitness-exuvia.md` — `:38`
12. P1–P13 → `core/01-principios.md` — `:41`

Todos com destino declarado. Dívidas PENDENTE (nata-0, 0b, 1, 3, 3b, 4–6) com onda designada — nenhuma oculta apontada.

**Veredito V7:** critérios mecanizáveis existem, mas C-TEST falha objetivamente no contexto v2; anti-teatro melhora C-TRACE/C-DEBT sem torná-los 100% mecânicos.

---

## Achados consolidados

| ID | Severidade | Achado | Evidência |
|---|---|---|---|
| R3-A | **BLOQUEADOR** | C-TEST falha no contexto v2 (271/1, SUÍTE VERMELHA) | `run-guard-tests.sh` exit 1; falha readlist |
| R3-B | **BLOQUEADOR** | Premissa "pós-ondas nata-0/nata-0b" não sustentada no disco | MANIFESTO `:57-58`; despachos `status: proposto`; código inalterado |
| R3-C | **FORTE** | nata-0 pendente: `ACTIVE_ROOT` calculado mas não usado em hearback_ref | `assert-role-family.sh:80,105` |
| R3-D | **FORTE** (resolvido) | G-FRONTDOOR exigia role-cards ausente (rodada 2) | Resolvido: `core/role-cards.md` criado |
| R3-E | **FORTE** | C-TRACE/C-DEBT permanecem parcialmente humanos | FITNESS `:26-32`; sem parser de cobertura total |
| R3-F | **MARGINAL** | Bootstrap ainda untracked (não commitado) | `git status --short`: `?? versao_2_0_0/` |
| R3-G | **MARGINAL** | `core/*.md` = 12 (teto R1 exato) | `ls core/*.md \| wc -l` |
| R3-H | **MARGINAL** | Ruído de `??` históricos fora da exúvia | git status (dezenas de untracked pré-existentes) |

Nenhum bloqueador estrutural novo do desenho "versão = pasta". Bloqueadores operacionais de ativação (nata-0/0b, C-TEST v2) permanecem abertos.

---

## Nível de confiança

- **ALTA:** V1 (diffs vazios), V2 (git status M/D), V3 (saídas completas run-guard-tests + adversarial nos dois contextos), V5 (wc/ls diretos).
- **MÉDIA-ALTA:** V4 (amostra ≥6 regras + guards cruzados; não exaustividade de 22 specs/27 ADRs).
- **MÉDIA:** V6 (análise adversarial + inspeção de código; sem commit real de burla).
- **MÉDIA:** V7 (checklist lido; C-DOG/C-FCLOSE não executados).

---

## O que NÃO verifiquei

- C-DOG (freeze V206 real do Credenciamento + tag + hearback)
- C-FCLOSE em repo-teste isolado (`.hbn/active-version` ausente/duplicado/conflito)
- Comportamento dos guards no chokepoint durante commit real do bootstrap
- Pareceres das outras 3 famílias desta rodada 3 (sou 1 de 4)
- Exaustividade 100% de todos os elementos do MANIFESTO (amostra ≥12)
- Instalação de hook-shims pós-flip ou comportamento com `.hbn/active-version = versao_2_0_0`
- Pipeline CI remoto (GitHub Actions)

---

## Síntese

A consolidação rodada 2 foi **fielmente aplicada** no texto (V4 verde): role-cards, I-10, ponteiros P1–P13, árvores registry-centric, anti-teatro, orçamentos no teto ou abaixo. C-NOREG de arquivos restaurado (V1). Escrita confinada (V2). Bateria adversarial íntegra (V3 adv).

Porém a premissa desta rodada — auditoria **pós** nata-0/nata-0b — **não corresponde ao disco**. As ondas permanecem despachadas mas não implementadas; a suíte no contexto v2 reporta **SUÍTE VERMELHA** (271/1), violando paridade objetiva de C-TEST. Isso impede aprovação adversarial do bootstrap como pronto para prosseguir ao Fitness Gate completo, apesar do desenho estrutural ser sólido e as dívidas estarem declaradas.

Recomendação operacional: (1) commit de classe própria do bootstrap; (2) executar nata-0 e nata-0b pelo Codex sob rito; (3) re-medir 272/272 nos dois contextos; (4) então reavaliar quórum C-XAUDIT.

APROVA_EXUVIA_V2: NAO
