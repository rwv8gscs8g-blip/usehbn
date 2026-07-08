---
arvore: fronteira
status: congelado
tema: escopo-primeira-exuvia
autor: subagente-opus-evolucao
data: 2026-06-16
escopo: bootstrap da 1a exuvia (versao_0_3_x -> versao_1_0_0) — nucleo de governanca
truth_barrier: toda afirmacao tecnica cita arquivo:linha
nota: NAO-NORMATIVO. Nao ativa exuvia, nao altera core/guards/.hbn/src. Insumo de design.
temperatura: glacier
---

# C3 — Escopo MODESTO e seguro da 1a exúvia (bootstrap)

> Análise de FRONTEIRA, exploratória. **Não autoriza a muda real** — a ativação
> continua VEDADA pelo Fitness Gate (`core/hbn-exuvia-scaffold.md:12-14`). Este doc
> só desenha o *escopo mínimo viável* da 1a exúvia, alinhado a três travas:
> (i) só muda baseline PROVADO (`MECANISMO-aptidao-darwinismo-exuvia.md:12-21`);
> (ii) a `versao_1_0_0/` nasce como o **núcleo de governança Intermediária lapidado**,
> deixando o compilador/runtime avançado como pesquisa de Fronteira
> (`B1-code-review-cli-runtime.md:273-302`);
> (iii) carry-forward darwiniano — só o mais apto sobrevive
> (`MODELO-exuvia-versao-contem-sistema-inteiro.md:28-34`).
> Marcadores: **[CONCLUSÃO]** factual ancorada · **[PROPOSTA]** design sugerido ·
> **[PERGUNTA ABERTA]** decisão deixada ao gate humano.

---

## 0. Premissa de modéstia (por que o escopo é pequeno)

**[CONCLUSÃO]** O modelo canônico exige que a pasta da versão seja pequena o bastante
para ser **carregável inteira em contexto/memória**
(`MODELO-exuvia-versao-contem-sistema-inteiro.md:21-26`). Isso é, por si, uma trava de
modéstia: a `versao_1_0_0/` não pode ser "tudo o que existe hoje na raiz" — tem de ser
o subconjunto **lapidado e provado**.

**[CONCLUSÃO]** O B1 mapeou que o runtime Python (`cli.py` god-object de 1776 LOC,
autoevolve embrionário, Truth Barrier/Guardian apenas advisory) está em estado de
**Fronteira**, não de release (`B1-code-review-cli-runtime.md:20-32, 292-302`). Logo a
1a exúvia **não promove o compilador**: ela consolida o **núcleo de governança** (a
máquina de guards + protocolo de relay/baton + constituição), que é o que já tem
contrato estável, testes e caminho de erro.

**[PROPOSTA]** Regra de ouro do bootstrap: *na dúvida, não carrega*. O que não fecha os
8 critérios (`core/exuvia-fitness-criteria.md:75-96`) fica no exoesqueleto `versao_0_3_x/`
(congelado, history intacto) ou desce ao glacier mais tarde.

---

## (a) O que CARREGA vs. o que NÃO carrega para `versao_1_0_0/`

### CARREGA — o núcleo de governança Intermediária (provado)

**[PROPOSTA]** Carry-forward, cada item gated pelo placar de 8 critérios
(`core/exuvia-fitness-criteria.md:100-111` já mostra S1/B17/B18/B19/S2 com veredito
SOBREVIVE):

| Bloco | Conteúdo | Por que carrega (âncora) |
|---|---|---|
| `core/` essencial | `protocol.md`, `dispatch-spec.md`, `relay-spec.md`, `readback-spec.md`, `state-report-spec.md`, `pointer-spec.md`, `freeze-gate-spec.md`, `role-cards.md`, `roles-assignment-spec.md`, `validation-rules.md`, `start-rite-spec.md`, `command-spec.md`, `cadence-d.md`, `exuvia-fitness-criteria.md` | specs de contrato estável; fitness-criteria é `accepted` (`exuvia-fitness-criteria.md:4`) |
| `guards/` | os guards que SOBREVIVEM ao placar: scope-lock, dispatch-integrity, registry-line, no-stray-hbn, pointer-honest, baton-token, canonical-root, hearback-integrity, role-family, etc. + `lib/common.sh` (com `get_canonical_root()`) + `hbn-guards-runner.sh` + `guards/tests/` (positivo+negativo+adversarial) | C-TEST..C-NOREG já verdes para os mecanismos selados (`exuvia-fitness-criteria.md:102-106`) |
| `guards/hook-shims/` | `pre-commit` e `commit-msg` (templates auditáveis com marcador de versão) | versionados e fail-closed (`hbn-exuvia-scaffold.md:36-48`); shim atual = `HBN_HOOK_SHIM_VERSION=M-A-20260614` |
| `.hbn/` núcleo | `active-version`, `canonical-root`, estrutura de `relay/`, `readbacks/`, `hearbacks/`, `results/`, `messages/`, `knowledge/`, `dispatch/`, `connectors/`, `proposals/`, `models/`, `stray-allowlist`, `alt-roots`, `README.md` | é o estado vivo de governança; o ponteiro é a fonte única (`hbn-exuvia-scaffold.md:16-29`) |
| `REGISTRY.md` | reapontado para paths relativos à `versao_1_0_0/` (G-REG lê o REGISTRY da versão ativa, `hbn-exuvia-scaffold.md:56-58`) | rastreabilidade C-TRACE (`exuvia-fitness-criteria.md:85`) |
| `methodology/` essencial | `PRINCIPIOS-CONSTITUCIONAIS.md`, `MATURITY-MATRIX.md`, `ADR-AND-MD-PRIMER.md`, `adr/` (os ADRs ratificados), `templates/` | constituição P1–P13 + invariantes persistem por todas as exúvias (`MODELO-...:63-64`) |
| `schemas/` | os schemas já Implementados (matriz linha 73, `B1-code-review-cli-runtime.md:333`) | contrato congelado |
| `scripts/` | `hbn-exuvia-rollback.sh` (dry-run/reversibilidade) | suporta P6 reversibilidade (`hbn-exuvia-scaffold.md:79-81`) |

### NÃO CARREGA — fica no exoesqueleto `versao_0_3_x/` ou vai ao glacier

**[CONCLUSÃO]** Pela alocação por árvore do B1
(`B1-code-review-cli-runtime.md:292-302`), permanecem como **Fronteira** (não entram
como "Implementado"):

| Item | Destino | Âncora |
|---|---|---|
| `src/usehbn/autoevolve/` (orchestrator desconectado, worker.apply no-op) | exoesqueleto / Fronteira | `B1-code-review-cli-runtime.md:258-269, 294` |
| Truth Barrier + Guardian (advisory; regex EN-only; não bloqueiam) | exoesqueleto / Fronteira | `B1-code-review-cli-runtime.md:296-298` |
| Bridges (`bridge/vba.py` stub), connector verify/remote (scaffold) | exoesqueleto / Fronteira | `B1-code-review-cli-runtime.md:298-299` |
| Intent PT/multi-domínio (regex frágeis) | exoesqueleto / Fronteira | `B1-code-review-cli-runtime.md:300` |
| `cli.py` na forma god-object monolítica (1776 LOC) | NÃO carrega como está — ou refatora antes (§(d)/Fase B) ou fica em `versao_0_3_x/` | `B1-code-review-cli-runtime.md:35-71` |
| Massa de prompts/relatórios soltos na raiz (`PROMPT_*.md`, `2026...-prompt-*.md`, `auditoria/`, `inbox/`, `reports/` antigos, `HBN-ARCHITECTURAL-REVIEW-2026-04.md`, `AUDITORIA_SUPERPOWERS.md`) | exoesqueleto (history intacto) → glacier futuro | lapidação darwiniana `MODELO-...:28-34`; glacier calendarizado `hbn-exuvia-scaffold.md:84-93` |
| `build/`, `dist/`, `site/`, `.pytest_cache/`, `logs/`, caches | ignorados, nunca carregam | `hbn-exuvia-scaffold.md:84-86` |

**[PERGUNTA ABERTA]** O `cli.py` é o ponto sensível: o protocolo *opera* via CLI hoje.
Se a `versao_1_0_0/` não pode prometer o compilador como release, ela precisa carregar
um CLI que apenas **expõe o núcleo de governança maduro** (engine + readback/hearback/
ERP + consent-criação + runtime detection — `B1-code-review-cli-runtime.md:280-290`),
com autoevolve/TB/Guardian documentados como Scaffold/advisory. Decidir se isso exige
a refatoração da Onda 7 (§(d) Fase B) ANTES do congelamento, ou se entra com rótulo
honesto e refatora dentro da janela.

---

## (b) Passos do bootstrap (citando o scaffold)

**[CONCLUSÃO]** A 1a exúvia é um BOOTSTRAP especial porque hoje tudo está na raiz
(forma 0.3.x), o ponteiro `.hbn/active-version` está em `.`
(`hbn-exuvia-scaffold.md:27-28`; verificado no disco: vale `.`) e ainda não há pasta de
versão (`MODELO-exuvia-versao-contem-sistema-inteiro.md:51-57`).

**[PROPOSTA]** Sequência mecânica (toda gated pelo Fitness Gate — nada disto roda nesta
rodada):

1. **Pré-flight de aptidão.** Confirmar baseline provado: suíte verde + adversarial
   verde + Ponte do Credenciamento funcionando (`MECANISMO-...:15-17`). Rodar o placar
   de 8 critérios sobre cada mecanismo a carregar
   (`exuvia-fitness-criteria.md:123`). Sem isto, PARA.
2. **Congelar a forma atual como `versao_0_3_x/`** com `git mv` (nunca `cp`, para não
   duplicar history — `hbn-exuvia-scaffold.md:85`). Criar a tag anti-GC
   `hbn-exuvia/protocol-0.3.x` apontando para o commit que congela a casca
   (`hbn-exuvia-scaffold.md:74-77`).
3. **Nascer `versao_1_0_0/`** com o carry-forward lapidado (estrutura simplificada,
   renumerada — `MODELO-...:52-54`). Guards passam a operar relativos à pasta da versão:
   `get_canonical_root()` resolve a raiz ativa e `guard_diff_files()` entrega paths
   relativos a ela (`hbn-exuvia-scaffold.md:51-58`).
4. **Reapontar os hooks.** Editar `.hbn/active-version` de `.` para `versao_1_0_0`
   (`hbn-exuvia-scaffold.md:18-20`). Os shims em `.git/hooks/` leem o ponteiro, validam
   e delegam aos guards da versão ativa (`hbn-exuvia-scaffold.md:33-39`); reinstalar a
   partir de `guards/hook-shims/` mantendo o marcador de versão
   (`hbn-exuvia-scaffold.md:37-39, 45-47`).
5. **Reconciliar token × STATE.** O token de posse fica em `.git/hbn-baton-token`
   (compartilhado, nunca versionado); o `STATE.md` que governa é o da versão ativa.
   Aplicar a reconciliação de 4 passos do scaffold (preservar token local → sha256 →
   ajustar `bastao_token_sha256` do STATE ativo → preservar fingerprint público
   `34a7f2f9`) — `hbn-exuvia-scaffold.md:60-72`.
6. **Criar `EXUVIAS.md`** na raiz: índice de versões + ponteiros
   (`MODELO-...:13-16`). É o lugar do registro "estava em X, agora em `versao_1_0_0/...`".
7. **Confronto incumbente × desafiante** nos mesmos testes reais; incumbente
   (`versao_0_3_x/`, congelado e intacto) sobrevive por padrão se o desafiante não
   vencer (`MECANISMO-...:18-23`). Caminho de rollback via
   `scripts/hbn-exuvia-rollback.sh --apply` reservado ao operador pós-gate
   (`hbn-exuvia-scaffold.md:79-81`).

---

## (c) Conteúdo mínimo do doc de transição ("de-onde-para-onde")

**[CONCLUSÃO]** O modelo exige **UM único documento de transição** que, e só ele,
registra os remapeamentos — sem reescrever links internos do exoesqueleto abandonado
(`MODELO-exuvia-versao-contem-sistema-inteiro.md:36-40`). Isso preserva
auditabilidade (P1) sem o custo de reescrever tudo.

**[PROPOSTA]** Conteúdo mínimo de `versao_1_0_0/TRANSICAO.md` (ou seção do `EXUVIAS.md`):

1. **Cabeçalho de muda:** data, commit congelado, tag `hbn-exuvia/protocol-0.3.x`,
   ponteiro antes (`.`) → depois (`versao_1_0_0`).
2. **Tabela de remapeamento de caminhos:** "o que estava em `<raiz>/X` agora está em
   `versao_1_0_0/X`" para cada bloco carregado (core, guards, .hbn, REGISTRY,
   methodology, schemas, scripts). É o requisito explícito do modelo (`MODELO-...:38-40`).
3. **O que ficou para trás e por quê:** lista do §(a) "NÃO carrega" com o motivo
   darwiniano (menos apto / Fronteira / debt) e o destino (exoesqueleto vs. glacier).
4. **Placar de fitness aplicado:** referência ao resultado do placar de 8 critérios que
   justificou cada sobrevivência (`exuvia-fitness-criteria.md:100-111`).
5. **Reconciliação token/STATE:** o sha256 reconciliado e o fingerprint preservado
   (`hbn-exuvia-scaffold.md:60-72`), para auditoria do baton.
6. **Plano de rollback:** como reverter para o incumbente congelado (P6,
   `MECANISMO-...:24-25`; `hbn-exuvia-scaffold.md:79-81`).

---

## (d) Correções pré-exúvia que entram ANTES (para o baseline ser "provado")

**[CONCLUSÃO]** O B1 já nomeia, na Fase A (pré-requisitos antes de congelar), as
correções de maior alavancagem (`B1-code-review-cli-runtime.md:311-322`). Elas têm de
entrar ANTES porque congelar com elas pendentes **petrifica o bug** na carapaça nova:

1. **Exit-code significativo em `main()`** (corrige o "exit 0 sempre" —
   `B1-code-review-cli-runtime.md:91-104, 318-320`). Hoje `main()` retorna 0 mesmo em
   ramos de erro (`cli.py:1772`), o que contradiz um protocolo cujo propósito é
   *bloquear*. Sem isto, o baseline não pode ser declarado "funcional/provado" porque
   CI/scripts não detectam falha lógica. → `try/except` de fronteira + hierarquia mínima
   de exceções (`HbnUsageError`/`HbnProtocolViolation`) com exit 1/2/3.
2. **Unificação do diretório de estado** (corrige as TRÊS convenções `.hbn/`,
   `.usehbn/`, `state/` — `B1-code-review-cli-runtime.md:125-140, 313-317, 354-356`).
   Decidir uma fonte única e migrar leitores/escritores. É a correção de maior
   alavancagem (`B1:317`): congelar com três convenções petrificaria o bug que a Onda 3
   só remendou em um consumidor (`cli.py:1564-1572`).
3. **Golden tests dos 17 subcomandos** como rede de segurança que permite refatorar com
   o contrato congelado (`B1-code-review-cli-runtime.md:321-322, 232-235`).

**[PROPOSTA]** As duas primeiras (exit-code e unificação de estado) são **pré-condição
dura** do baseline provado. A refatoração do god-object (Onda 7, decomposição do
`B1:188-238`) pode acontecer **dentro da janela da exúvia** desde que os goldens
permaneçam verdes (`B1-code-review-cli-runtime.md:323-326`).

**[PERGUNTA ABERTA]** A unificação de estado escolhe `.hbn/` ou `.usehbn/`? O CLI
inicializa `.hbn/` (`cli.py:752`) mas o runtime persiste em `.usehbn/`
(`config.py:12,25`). Decisão do gate — afeta migração de readbacks/results no disco.

---

## (e) Checklist objetivo de prontidão para a muda

### Fitness Gate (precondição de aptidão — 5 itens, `MECANISMO-...:12-25`)

- [ ] **FG-1** Versão atual funcional + testada: suíte verde + testes reais passando.
- [ ] **FG-2** Ponte do Credenciamento funcionando (precondição de qualquer muda,
  `MAPA-...:46`).
- [ ] **FG-3** Confronto incumbente × desafiante desenhado nos mesmos testes reais.
- [ ] **FG-4** Critério de vitória do desafiante medido (mais com menos/melhor OU
  corrige barreira documentada) — senão incumbente sobrevive.
- [ ] **FG-5** Caminho de rollback (P6) pronto e testado em dry-run
  (`scripts/hbn-exuvia-rollback.sh`).

### Os 8 critérios de fitness, por mecanismo carregado (`exuvia-fitness-criteria.md:75-96`)

Para CADA mecanismo do §(a)-CARREGA, placar SIM/NÃO; sobrevive sse C-TEST..C-TRACE = SIM
e C-DEBT registrada:

- [ ] **C-TEST** caso positivo E negativo na suíte (verde).
- [ ] **C-ADV** burla adversarial documentada e BLOQUEADA.
- [ ] **C-XAUDIT** aprovado por ≥2 famílias distintas do implementador.
- [ ] **C-DOG** dogfood: o mecanismo se aplica a si mesmo, sem grandfathering.
- [ ] **C-FCLOSE** fail-closed: falta de insumo BLOQUEIA (exit ≠ 0).
- [ ] **C-NOREG** sem regressão: invariantes/guards anteriores intactos.
- [ ] **C-TRACE** rastreável: readback + autorização humana + token FP + linha no REGISTRY.
- [ ] **C-DEBT** dívida conhecida registrada e aceita (ou inexistente).

### Pré-requisitos de bootstrap específicos desta muda

- [ ] **PB-1** Correções pré-exúvia §(d)-1 e §(d)-2 mergeadas (exit-code + estado único).
- [ ] **PB-2** Golden tests dos 17 subcomandos verdes (§(d)-3).
- [ ] **PB-3** Tag `hbn-exuvia/protocol-0.3.x` planejada apontando ao commit de congelamento.
- [ ] **PB-4** `git mv` (não `cp`) confirmado para o congelamento; build/dist/caches ignorados.
- [ ] **PB-5** Reconciliação token×STATE roteirizada (sha256 + fingerprint `34a7f2f9`).
- [ ] **PB-6** `EXUVIAS.md` + doc de transição §(c) redigidos antes de repontar o ponteiro.
- [ ] **PB-7** Cross-audit Gemini+Grok da máquina de muda antes de qualquer ativação
  (`MAPA-...:44`).
- [ ] **PB-8** Hearback humano no gate (a muda é EARNED, `MECANISMO-...:3-5`).

**[CONCLUSÃO]** Só quando Fitness Gate (5) + 8 critérios (por mecanismo) + PB-1..PB-8
estiverem TODOS marcados, a muda é "merecida". Caso contrário, incumbente sobrevive por
padrão (`MECANISMO-...:20-21`).

---

## Síntese de fronteira

**[CONCLUSÃO]** A 1a exúvia é modesta por construção: carrega o **núcleo de governança
maduro** (specs core de contrato estável, guards que sobrevivem ao placar, `.hbn/`
vivo, REGISTRY, methodology constitucional, schemas) e **deixa o compilador/runtime
avançado** (autoevolve, Truth Barrier/Guardian advisory, bridges, intent PT) como
pesquisa de Fronteira no exoesqueleto. **[PROPOSTA]** Antes de congelar, entram só as
duas correções de alavancagem do B1 (exit-code significativo e unificação do diretório
de estado) + a rede de golden tests; o resto refatora dentro da janela. **[PERGUNTA
ABERTA]** persiste a escolha `.hbn/` vs `.usehbn/` e o grau de refatoração do `cli.py`
exigido antes do congelamento — decisões do gate humano.
</content>
</invoke>
