---
titulo: "Parecer cross-IA — exuvia v2 rodada 4"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260702-092309-codex-cross-ia-exuvia-v2-rodada4.md
created_at: "2026-07-02T09:23:09-03:00"
autor: codex
familia: OpenAI
papel: auditor
alvo: versao_2_0_0
rodada: 4
---

SOU: codex · familia OpenAI · papel auditor

# Parecer adversarial — bootstrap exuvia v2, rodada 4

Escopo do veredito: aprovo ou veto o bootstrap `versao_2_0_0` como candidato pos-natas 0/0b. Isto NAO autoriza flip de `.hbn/active-version`; ativacao segue condicionada ao Fitness Gate completo, hearback humano e rito de flip.

## Achados

| ID | Severidade | Achado | Evidencia |
|---|---|---|---|
| A1 | FORTE | A divida `nata-0c` permanece aberta: twins v2 de knowledge, fixtures de hearback e `core/exuvia-fitness-criteria.md` existem no disco, mantem paridade `diff -r`, mas estao untracked em `versao_2_0_0/`. E declarada, nao oculta. | `versao_2_0_0/MANIFESTO-MIGRACAO.md:59`; `git status --short ...` mostrou `?? versao_2_0_0/.hbn/knowledge/0019...0032`, `?? versao_2_0_0/core/exuvia-fitness-criteria.md`, `?? versao_2_0_0/guards/tests/fixtures/hearbacks/`. |
| A2 | MARGINAL | A formulacao "vendorizados untracked presentes nas duas arvores" nao descreve o indice literalmente: os equivalentes da raiz estao rastreados; os twins v2 e que estao untracked. A paridade de conteudo no disco existe. | `git ls-files .hbn/knowledge ...` lista root `0019`, `0022`-`0032`; `git ls-files versao_2_0_0/...` nao lista os twins v2; `diff -rq .hbn/knowledge versao_2_0_0/.hbn/knowledge` saiu vazio. |
| A3 | MARGINAL | A tag `hbn-exuvia/bootstrap-v2-consolidado-r2` aponta para o commit do bootstrap (`de87a37`), nao para o HEAD pos-natas (`c3723ec`). O requisito do prompt era a tag conter `versao_2_0_0`, e isso esta satisfeito; as natas estao 2 commits a frente. | `git rev-parse hbn-exuvia/bootstrap-v2-consolidado-r2` -> `de87a3796d6ebeacc4c7fa745c6eeeaa9e1fa181`; `git rev-list --count hbn-exuvia/bootstrap-v2-consolidado-r2..HEAD` -> `2`. |
| A4 | MARGINAL | `MANIFESTO-MIGRACAO.md` ainda lista `nata-0` e `nata-0b` em `PENDENTE`, embora o codigo e o historico mostrem ambas aplicadas. E divida de atualizacao do ledger, nao regressao funcional. | `versao_2_0_0/MANIFESTO-MIGRACAO.md:57-58`; `git log --oneline -3` mostra `8e80461` e `c3723ec`; testes 274/274 nos dois contextos. |
| A5 | MARGINAL | Orcamento de specs esta no teto: 12/12 arquivos `core/*.md`; qualquer spec nova exige consolidacao/remocao. | `find versao_2_0_0/core -maxdepth 1 -name '*.md'` listou 12; `versao_2_0_0/BOOT.md:115-116` fixa limite <=12. |

Nenhum BLOQUEADOR mecanico foi encontrado para o bootstrap auditado.

## V0 — Estado Git

Comandos medidos:

```text
git log --oneline -12
c3723ec feat(guards): nata-0b - bloco read-list do harness version-aware (sob rito, pos-incidente)
8e80461 feat(guards): nata-0 - dereferencia version-aware do hearback_ref no G-FAM + teste negativo R2
de87a37 feat(exuvia): bootstrap versao_2_0_0 (INATIVA) + emendas da consolidacao rodada 2
...

git show --stat --oneline --decorate --no-renames hbn-exuvia/bootstrap-v2-consolidado-r2
de87a37 (tag: hbn-exuvia/bootstrap-v2-consolidado-r2) feat(exuvia): bootstrap versao_2_0_0 ...
117 files changed, 16905 insertions(+)
```

A tag contem `versao_2_0_0/BOOT.md`, `FITNESS-CHECKLIST.md`, `core/`, `guards/`, `schemas/` e demais artefatos v2. HEAD atual e `c3723ecb64998ca5690669b7f6651b3ebc5c72bd`.

Natas no codigo, nao em relato:

- `nata-0`: `guards/assert-role-family.sh:80-81` calcula `ACTIVE_ROOT`; `guards/assert-role-family.sh:113-119` resolve `hearback_ref` relativo a `active_root` e bloqueia referencia fora da raiz ativa. O mesmo bloco existe em `versao_2_0_0/guards/assert-role-family.sh:80-119`.
- `nata-0b`: `guards/tests/run-guard-tests.sh:3696-3752` e `versao_2_0_0/guards/tests/run-guard-tests.sh:3696-3752` usam alvos version-aware (`BOOT.md`, `core/02-papeis.md`, `core/03-rito-da-onda.md`, `core/04-artefatos.md`, `core/05-guards.md`, `core/read-list-canonica.txt`) e mantem o caso negativo F-08.

## V1 — C-NOREG

Comandos:

```text
diff -rq guards versao_2_0_0/guards
diff -rq schemas versao_2_0_0/schemas
diff -rq .hbn/knowledge versao_2_0_0/.hbn/knowledge
```

Saida: vazia nos tres comandos.

Explicacao da linha incomum: a paridade e de disco. Parte dos twins v2 esta untracked por decisao declarada em `versao_2_0_0/MANIFESTO-MIGRACAO.md:59`, porque corrigir `path:` nas copias v2 quebraria a paridade byte-idêntica ou o claim verbatim ate a `nata-0c`.

## V2 — Escrita confinada

`git status --short` pos-testes mostrou apenas linhas `??`. Nao ha `M` ou `D`; `git diff --name-status` e `git diff --cached --name-status` sairam vazios.

Observacao factual: durante esta auditoria apareceram no disco os pareceres `.hbn/results/20260702-091812-antigravity-cross-ia-exuvia-v2-rodada4.md` e `.hbn/results/20260702-091931-cursor-cross-ia-exuvia-v2-rodada4.md`, ambos untracked. Eu nao os editei.

## V3 — Suites e baterias

| Contexto | Comando | Resultado |
|---|---|---|
| raiz | `bash guards/tests/run-guard-tests.sh` | `== resumo: 274 passaram, 0 falharam ==` |
| `versao_2_0_0` | `bash guards/tests/run-guard-tests.sh` em `versao_2_0_0/` | `== resumo: 274 passaram, 0 falharam ==` |
| raiz | `bash guards/tests/adversarial-battery.sh` | `BATERIA VERDE`; B1-B96 bloqueadas |
| `versao_2_0_0` | `bash guards/tests/adversarial-battery.sh` em `versao_2_0_0/` | `BATERIA VERDE`; B1-B96 bloqueadas |

A contagem esperada pos-natas se confirma: 272 + 2 checks da `nata-0` = 274. O F-08 bloqueia: a suite registrou `readlist: referencia quebrada e detectada (F-08)` como `block` nos dois contextos.

## V4 — Consolidacao fiel, amostra

| Regra | Fonte incumbente | Consolidado v2 | Resultado |
|---|---|---|---|
| G-FRONTDOOR | `guards/assert-frontdoor.sh:19-20` (`core/role-cards.md`, max 140 linhas) e `guards/assert-frontdoor.sh:129-130` (read-list max 6) | `versao_2_0_0/core/role-cards.md:15-19` declara o contrato; `:21-29` tem 4 itens | Fiel. |
| I-10 | `core/state-report-spec.md:89-97`; `guards/assert-report-fresh.sh:17-20` | `versao_2_0_0/core/03-rito-da-onda.md:71-77` | Fiel: heading exato e citacao `arquivo:linha`. |
| P1-P13 | `methodology/PRINCIPIOS-CONSTITUCIONAIS.md:54,73,92,111,130,151,170,189,209,228,248,263,293` | `versao_2_0_0/core/01-principios.md:13-19` | Fiel por ponteiro, sem reescrever os principios. |
| Arvores | `core/arvores-spec.md:22-35`, `guards/assert-arvore-label.sh:5-12` | `versao_2_0_0/core/04-artefatos.md:46-56` | Fiel e honesto: REGISTRY e fonte unica; nata-3b declara lacuna de coluna. |
| Quorum | `guards/assert-quorum-selagem.sh:9`, `guards/assert-quorum-selagem.sh:273-281`, `guards/assert-audit-diversity.sh:6-10` | `versao_2_0_0/core/02-papeis.md:18-21` e `versao_2_0_0/core/03-rito-da-onda.md:29-30` | Fiel: 2 SIM, familias distintas e fora da familia do implementador. |
| Escopo/readback | `guards/assert-scope-lock.sh` exercitado pela suite (`sco: emenda files_allowed + uso no mesmo commit -> BLOCK`) | `versao_2_0_0/core/03-rito-da-onda.md:35-43` | Fiel. |

## V5 — Orcamento

| Medicao | Saida | Teto |
|---|---:|---:|
| `wc -l versao_2_0_0/BOOT.md` | 161 | <=300 |
| `find versao_2_0_0/core -maxdepth 1 -name '*.md'` | 12 arquivos | <=12 |
| `versao_2_0_0/.hbn/relay/STATE.md` resumo executivo | linhas 36-52 = 17 linhas de conteudo | <=30 |

Orcamento conforme; `core/*.md` esta no teto.

## V6 — Tentativas de burla

Usei a bateria adversarial como tentativa concreta, nos dois contextos. Amostra de resultados:

| Tentativa | Resultado |
|---|---|
| B10 `implementador == auditor (groupthink)` | BLOQUEADA por G-FAM. |
| B34-B37 identidade/familia de auditor malformada | BLOQUEADAS por G-AUD-ID. |
| B42 `arquivo da read-list alterado` | BLOQUEADA por G-ORQ. |
| B48-B54 `orq_entrada_ref` omitido/dangling/fp trocado/auto-repin | BLOQUEADAS por G-ORQREF. |
| B71-B75 quorum falso/insuficiente/OpenAI contado | BLOQUEADAS por G-QUORUM. |
| B91-B92 repoint estrutural de STATE sem quorum ou com quorum insuficiente | BLOQUEADAS por G-STATE. |
| B93-B96 prompt sem chat novo/destino canonico ou dependente de contexto | BLOQUEADAS por G-COPY. |

Nao demonstrei brecha nova que passe. A superficie que ainda exige trabalho e a `nata-0c`, mas ela esta fail-closed/declarada e nao abriu bypass nos testes.

## V7 — Fitness, 8 criterios

| Criterio | Medicao objetiva nesta auditoria | Estado |
|---|---|---|
| C-TEST | Suites raiz e v2: 274/274 | Verde. |
| C-ADV | Baterias raiz e v2: B1-B96 bloqueadas | Verde. |
| C-XAUDIT | Antes deste arquivo havia Google e Cursor rodada4 no disco, ambos com `APROVA_EXUVIA_V2: SIM`; este parecer adiciona OpenAI. Nao medi a rodada xAI/grok. | Minimo de familias SIM parece satisfeito se o gate aceitar os pareceres existentes; meta 4/4 ainda incompleta no disco que medi. |
| C-DOG | Exige freeze V206 do Credenciamento com `freeze-gate` exit 0 + tag + hearback (`versao_2_0_0/FITNESS-CHECKLIST.md:23`). | Nao verificado por mim; nao autoriza flip. |
| C-FCLOSE | A suite exercitou fail-closed de `.hbn/active-version` ausente e conflito (`run-guard-tests.sh` casos `cr: active-version ausente` e `cr: active-version com conflito de merge`) nos dois contextos. | Verde para os casos exercitados; nao fiz ensaio adicional fora do harness. |
| C-NOREG | `diff -rq` vazio em `guards/`, `schemas/`, `.hbn/knowledge/`; `git diff` e `git diff --cached` vazios. | Verde. |
| C-TRACE | Amostra abaixo, >=10 elementos com arquivo:linha. | Verde com ressalva de ledger stale em A4. |
| C-DEBT | `versao_2_0_0/MANIFESTO-MIGRACAO.md:53-66` lista dividas e ondas. | Verde como declaracao; `nata-0c` e divida FORTE aberta antes de ativacao. |

### C-TRACE/C-DEBT — amostra anti-teatro

| # | Elemento | Evidencia |
|---|---|---|
| 1 | `guards/` completo -> `versao_2_0_0/guards/` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:22`; `diff -rq guards versao_2_0_0/guards` sem saida. |
| 2 | `schemas/` -> `versao_2_0_0/schemas/` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:23`; `diff -rq schemas versao_2_0_0/schemas` sem saida. |
| 3 | `.hbn/knowledge/` -> `versao_2_0_0/.hbn/knowledge/` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:24`; `diff -rq .hbn/knowledge versao_2_0_0/.hbn/knowledge` sem saida. |
| 4 | `core/exuvia-fitness-criteria.md`, `freeze-gate-spec.md`, `dual-run-spec.md` -> `versao_2_0_0/core/` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:25`; arquivos listados por `find versao_2_0_0/core`. |
| 5 | Rollback script -> `versao_2_0_0/scripts/` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:26`; `versao_2_0_0/scripts/hbn-exuvia-rollback.sh:4` define `TAG_DEFAULT`. |
| 6 | AGENTS.md -> `BOOT.md` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:33`; `versao_2_0_0/BOOT.md:32-44` contem rito de entrada. |
| 7 | Perfis/papeis/anti-groupthink -> `core/02-papeis.md` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:34`; `versao_2_0_0/core/02-papeis.md:13-21`. |
| 8 | Relay/readback/dispatch/cadencia/start/state-report -> `core/03-rito-da-onda.md` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:35`; `versao_2_0_0/core/03-rito-da-onda.md:16-33`. |
| 9 | ADR-011/024/025 + arvores/pointer/command -> `core/04-artefatos.md` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:36`; `versao_2_0_0/core/04-artefatos.md:16-56`. |
| 10 | ADR-020/Truth Barrier/chokepoints -> `core/05-guards.md` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:37`; `versao_2_0_0/core/05-guards.md:13-21`. |
| 11 | Exuvia/scaffold/freeze -> `core/06-freeze-fitness-exuvia.md` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:38`; `versao_2_0_0/core/06-freeze-fitness-exuvia.md:13-18`. |
| 12 | Ponte/membrana/Credenciamento -> `core/07-projetos-membrana.md` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:39`; `versao_2_0_0/core/07-projetos-membrana.md:14-46`. |
| 13 | Evolucao/workflows/skills -> `core/08-evolucao.md` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:40`; arquivo existe e esta em `core/*.md`. |
| 14 | P1-P13 -> `core/01-principios.md` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:41`; `versao_2_0_0/core/01-principios.md:13-19`. |
| 15 | R1-R5 -> `BOOT.md §9` | `versao_2_0_0/MANIFESTO-MIGRACAO.md:42`; `versao_2_0_0/BOOT.md:113-124`. |
| 16 | Dividas natas 0, 0b, 0c, 1, 2, 3, 3b, 4, 5, 6 | `versao_2_0_0/MANIFESTO-MIGRACAO.md:57-66`; natas 0/0b aplicadas em commits `8e80461` e `c3723ec`, `nata-0c` aberta. |

## O que nao verifiquei

- Freeze V206 real do Credenciamento (C-DOG), tag do projeto e hearback associado.
- Flip de `.hbn/active-version`, reinstalacao de hook-shims e dry-run de rollback.
- Parecer xAI/grok da rodada 4; no momento medido havia Google e Cursor antes deste arquivo.
- Comparacao semantica exaustiva de todos os 22 specs/27 ADRs historicos; fiz amostra dirigida conforme pedido.
- Rede, CI remoto e GitHub; tudo aqui e medicao local.

## Confianca

Alta para V0-V3, V5 e C-NOREG, porque sao medidos por comandos locais e suites verdes. Media para V4 e C-TRACE/C-DEBT, porque usei amostra manual com evidencia arquivo:linha. Baixa/nula para C-DOG e flip, porque nao foram executados nesta auditoria.

Veredito: aprovo o bootstrap `versao_2_0_0` pos-natas 0/0b como candidato mecanicamente integro, com `nata-0c` e C-DOG ainda bloqueando ativacao/flip ate seus ritos proprios.

APROVA_EXUVIA_V2: SIM
