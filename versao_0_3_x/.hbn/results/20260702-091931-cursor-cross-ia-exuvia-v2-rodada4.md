---
tipo: audit-result
autor: cursor
familia: Cursor
path: .hbn/results/20260702-091931-cursor-cross-ia-exuvia-v2-rodada4.md
arvore: fronteira
created_at: "2026-07-02T09:19:31-03:00"
status: congelado
temperatura: glacier
---

SOU: cursor · humano · gate. CHAT NOVO, SEM MEMÓRIA. Família Cursor. Papel: auditor adversarial READ-ONLY do useHBN. Rodada 4 — bootstrap `versao_2_0_0/`. Nenhum arquivo alterado fora deste depósito; sem staging; sem commit; sem `--no-verify`.

# Cross-audit exúvia v2 — rodada 4 (Cursor)

## Escopo e método

Medição integral no disco em 2026-07-02T09:19-03:00. Rodadas 1–3 tratadas como anuladas/viciadas conforme `versao_2_0_0/FITNESS-CHECKLIST.md:61-119`. Ondas nata-0/nata-0b conferidas no **código** (`assert-role-family.sh`, bloco read-list de `run-guard-tests.sh`), não em relatos de chat.

**Confiança global:** alta (V0–V3, V5, C-NOREG); média (C-TRACE/C-DEBT amostra manual); baixa onde não executado (C-DOG, C-FCLOSE isolado).

---

## V0 — Estado Git

| Verificação | Resultado | Evidência |
|---|---|---|
| Commits bootstrap + natas | **OK** | `git log --oneline -3` → `c3723ec` nata-0b · `8e80461` nata-0 · `de87a37` bootstrap |
| Tag `hbn-exuvia/bootstrap-v2-consolidado-r2` contém `versao_2_0_0/` | **OK** | `git rev-parse hbn-exuvia/bootstrap-v2-consolidado-r2` = `de87a37`; `git show de87a37 --stat` lista `versao_2_0_0/BOOT.md`, `core/`, `guards/`, etc. |
| Tag = HEAD pós-natas | **MARGINAL** | HEAD=`c3723ec` (2 commits à frente da tag). Tag marca o commit do bootstrap; natas estão commitadas mas não re-tagueadas. |

**Severidade:** MARGINAL (tag operacional desatualizada em relação às natas; não invalida o conteúdo da exúvia).

---

## V1 — C-NOREG (vendorização sem regressão)

```bash
diff -rq --exclude='wt-main.*' --exclude='cr-*' --exclude='tmp-*' guards/ versao_2_0_0/guards/
diff -rq schemas/ versao_2_0_0/schemas/
diff -rq .hbn/knowledge/ versao_2_0_0/.hbn/knowledge/
# (sem saída — exit 0)
```

| Árvore | Diff | Severidade |
|---|---|---|
| `guards/` | Vazio (excl. efêmero `guards/tests/wt-main.*` de harness) | — |
| `schemas/` | Vazio | — |
| `.hbn/knowledge/` | Vazio nos **tracked** | — |
| Vendorizados nata-0c | 13 knowledge (`0019`, `0022`–`0032`), `core/exuvia-fitness-criteria.md`, `guards/tests/fixtures/hearbacks/` presentes **untracked** nas duas árvores | **FORTE** (dívida declarada, não oculta) |

**nata-0 aplicada (código):** `guards/assert-role-family.sh:80-81,114-119` usa `ACTIVE_ROOT` na dereferência de `hearback_ref`; `diff guards/assert-role-family.sh versao_2_0_0/guards/assert-role-family.sh` → IDENTICAL.

**nata-0b aplicada (código):** `guards/tests/run-guard-tests.sh:3696-3753` — bloco read-list version-aware com alvos `BOOT.md` + `core/02-05` + `read-list-canonica.txt` quando existem; fallback incumbente caso contrário; skip de `.hbn/active-version` via parent (`3724-3727`).

**Reconciliação com MANIFESTO §PENDENTE nata-0c:** `versao_2_0_0/MANIFESTO-MIGRACAO.md:59` explica G-SLF × `path:` incorreto — cópias ficam fora do commit até dereferência version-aware. Paridade `diff -r` dos tracked permanece intacta.

**Veredito V1:** VERDE nos tracked; FORTE na dívida nata-0c (declarada).

---

## V2 — Escrita confinada

```bash
git status --short | grep -E '^[MD]' || echo ZERO_M_D
# ZERO_M_D
```

Apenas `??` (untracked pré-existentes + vendorizados nata-0c). Nenhum `M`/`D` em arquivo tracked.

**Severidade:** — (verde).

---

## V3 — Suítes (raiz e `versao_2_0_0`)

| Contexto | Comando | Resultado |
|---|---|---|
| Raiz | `bash guards/tests/run-guard-tests.sh` | **274/274** — `== resumo: 274 passaram, 0 falharam ==` |
| `versao_2_0_0` | `cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh` | **274/274** — idêntico |
| Raiz | `bash guards/tests/adversarial-battery.sh` | **B1–B96 BLOQUEADAS** |
| `versao_2_0_0` | idem | **B1–B96 BLOQUEADAS** |

Contagem 274 = 272 + 2 checks nata-0 (`run-guard-tests.sh:157-158`, `236-246`: hearback dentro/fora da versão ativa). F-08 (read-list viva) passa em ambos os contextos.

**Veredito V3:** VERDE.

---

## V4 — Consolidação fiel (amostra ≥5)

| Regra | Spec v2 | Evidência de fidelidade |
|---|---|---|
| **G-FRONTDOOR** | `core/role-cards.md` | Arquivo presente (`versao_2_0_0/core/role-cards.md:21-28`): read-list 4 itens ≤6; ponteiro fino para `BOOT.md` e `core/02-papeis.md`; `wc -l` = 35 ≤140. Guard: `cd versao_2_0_0 && bash guards/assert-frontdoor.sh` → rc=0. |
| **I-10** | `core/03-rito-da-onda.md` | `versao_2_0_0/core/03-rito-da-onda.md:71-77`: heading `## RELATO DE LEITURA`, prova `arquivo:linha`, enforcement `assert-report-fresh.sh` regra 6. |
| **P1–P13** | `core/01-principios.md` | `versao_2_0_0/core/01-principios.md:13-19`: peso normativo idêntico, fonte histórica `methodology/PRINCIPIOS-CONSTITUCIONAIS.md`, emenda via BOOT §9. |
| **Árvores** | `core/04-artefatos.md §Árvores` | `versao_2_0_0/core/04-artefatos.md:46-56`: fronteira→intermediária→estável; REGISTRY fonte única; G-ARVORE-LABEL; dívida nata-3b explícita. |
| **Quórum** | `core/02-papeis.md` + `core/03-rito-da-onda.md` | `versao_2_0_0/core/02-papeis.md:18-21`: 2 SIM, famílias distintas, implementador ∉ auditores. `versao_2_0_0/core/03-rito-da-onda.md:29-30`: G-QUORUM + G-DIVERSITY no passo 9. |

**Veredito V4:** VERDE.

---

## V5 — Orçamento

| Métrica | Medição | Teto | Resultado |
|---|---|---|---|
| `BOOT.md` | `wc -l` → **161** | ≤300 | OK |
| `core/*.md` | `ls … \| wc -l` → **12** | ≤12 | **NO TETO** |
| STATE resumo | linhas 34–52 → **19** | ≤30 | OK |

**Severidade:** MARGINAL em `core/*.md` (12/12 — sem margem para spec nova sem consolidação).

---

## V6 — Brechas novas (tentativas)

| # | Tentativa | Resultado |
|---|---|---|
| 1 | `HBN_GUARDS_BYPASS=1` no runner | **Não executado ao vivo** (política read-only bloqueou invocação direta). Evidência indireta: harness `adversarial-battery.sh` B4 e `run-guard-tests.sh:1896` — bypass sem nota → BLOCK. |
| 2 | `--no-verify` no commit | **Não tentado** (proibido pelo prompt e `knowledge/0025`). |
| 3 | Parecer com `familia:` alheia ao token | Rodada 3 invalidou `20260701-204612-cursor-…rodada3.md` (`familia: OpenAI`). Este parecer usa `cursor` + `Cursor` coerentes. |
| 4 | Escrita fora de `versao_2_0_0/` durante bootstrap | `git status` sem `M`/`D` — vetor do incidente rodada 1 (`FITNESS-CHECKLIST.md:63-74`) não se repetiu no estado atual. |
| 5 | Adulterar harness read-list sem rito | Incidente revertido; estado atual com commits `8e80461`/`c3723ec` sob rito — suíte 274/274 honesta. |
| 6 | Ativar exúvia com knowledge incompleto no Git | 13 arquivos knowledge + `exuvia-fitness-criteria.md` untracked em v2 — **fail-closed operacional** até nata-0c; não é bypass se declarado. |

Nenhuma brecha nova não coberta pelo harness foi demonstrada.

---

## V7 — Fitness (8 critérios)

| # | Critério | Medição | Verde? | Notas |
|---|---|---|---|---|
| 1 | C-TEST | 274/274 raiz e v2 | **SIM** | Paridade plena |
| 2 | C-ADV | B1–B96 ambos contextos | **SIM** | |
| 3 | C-XAUDIT | Este parecer (1/4 famílias rodada 4) | **PARCIAL** | Quórum pendente das outras 3 famílias |
| 4 | C-DOG | — | **NÃO VERIFICADO** | Freeze V206 Credenciamento fora do escopo read-only |
| 5 | C-FCLOSE | — | **NÃO VERIFICADO** | Repo-teste isolado bloqueado pela política read-only; código `assert-canonical-root.sh:48-54` indica fail-closed |
| 6 | C-NOREG | diff vazio (tracked) | **SIM** | |
| 7 | C-TRACE | Amostra abaixo (≥10) | **SIM** com ressalva nata-0c | |
| 8 | C-DEBT | §PENDENTE manifesto | **SIM** (declarada) / **FORTE** (nata-0c aberta) | |

### C-TRACE / C-DEBT — amostra (anti-teatro, ≥10)

| # | Elemento manifesto | Destino declarado | Evidência |
|---|---|---|---|
| 1 | `guards/` completo | `versao_2_0_0/guards/` | `MANIFESTO-MIGRACAO.md:22` · diff vazio |
| 2 | `schemas/` (17 JSON) | `versao_2_0_0/schemas/` | `MANIFESTO-MIGRACAO.md:23` · diff vazio |
| 3 | `.hbn/knowledge/` | `versao_2_0_0/.hbn/knowledge/` | `MANIFESTO-MIGRACAO.md:24` · 7 tracked + 13 untracked nata-0c |
| 4 | `core/exuvia-fitness-criteria.md` | `versao_2_0_0/core/` verbatim | `MANIFESTO-MIGRACAO.md:25` · untracked (`path:` incumbente) |
| 5 | AGENTS.md | `BOOT.md` | `MANIFESTO-MIGRACAO.md:33` · `versao_2_0_0/BOOT.md:1-161` existe |
| 6 | relay/readback/dispatch specs | `core/03-rito-da-onda.md` | `MANIFESTO-MIGRACAO.md:35` · 12 passos `03-rito:16-33` |
| 7 | ADR-011/024/025 + árvores | `core/04-artefatos.md` | `MANIFESTO-MIGRACAO.md:36` · §Árvores `04-artefatos:46-56` |
| 8 | ADR-020 anti-teatro | `core/05-guards.md` | `MANIFESTO-MIGRACAO.md:37` · `05-guards:13-21` vendorização |
| 9 | scaffold exúvia | `core/06-freeze-fitness-exuvia.md` | `MANIFESTO-MIGRACAO.md:38` · arquivo commitado |
| 10 | proposta-ponte v2 | `core/07-projetos-membrana.md` | `MANIFESTO-MIGRACAO.md:39` · arquivo commitado |
| 11 | PRINCIPIOS P1–P13 | `core/01-principios.md` | `MANIFESTO-MIGRACAO.md:41` · `01-principios:13-19` |
| 12 | Dívida nata-0 | G-FAM version-aware | `MANIFESTO-MIGRACAO.md:57` · commit `8e80461` + código |
| 13 | Dívida nata-0b | harness read-list | `MANIFESTO-MIGRACAO.md:58` · commit `c3723ec` + `run-guard-tests.sh:3701-3717` |
| 14 | Dívida nata-0c | G-SLF untracked | `MANIFESTO-MIGRACAO.md:59` · `git status` confirma `??` nas duas árvores |

---

## Achados consolidados

| ID | Severidade | Achado |
|---|---|---|
| A1 | **FORTE** | Vendorizados nata-0c (13 knowledge + `exuvia-fitness-criteria.md` + fixtures hearback) existem no disco mas **fora do commit** em v2 — ativação bloqueada até onda nata-0c; dívida **declarada** em `MANIFESTO-MIGRACAO.md:59`. |
| A2 | **MARGINAL** | Tag `hbn-exuvia/bootstrap-v2-consolidado-r2` em `de87a37`, não em `c3723ec` (natas). |
| A3 | **MARGINAL** | `core/*.md` = 12/12 — orçamento de specs no teto. |
| A4 | — | C-DOG e C-FCLOSE não verificados por este auditor (escopo read-only / bloqueio de repo-teste). |

**Nenhum BLOQUEADOR** mecanizado encontrado nas verificações executadas (C-NOREG tracked, 274/274, B1–B96, escrita confinada, natas 0/0b no código).

---

## O que NÃO verifiquei

- C-DOG (freeze V206 do Credenciamento sob rito completo).
- C-FCLOSE com repo-teste isolado (`.hbn/active-version` ausente/duplicado/conflito).
- Quórum das outras 3 famílias na rodada 4 (Google/OpenAI/xAI).
- Instalação real de hook-shims pós-flip.
- Rollback dry-run (`scripts/hbn-exuvia-rollback.sh`).

---

## Veredito

O bootstrap `versao_2_0_0/` está **mecanicamente íntegro** pós-natas 0/0b: paridade tracked, suíte 274/274 honesta, bateria adversarial verde, consolidação normativa coerente, orçamento dentro dos tetos. A dívida nata-0c é **forte mas declarada** e impede ativação até fechamento — não invalida a aprovação do desenho/bootstrap com ressalvas.

**APROVA_EXUVIA_V2: SIM**
