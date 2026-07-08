---
arvore: fronteira
status: congelado
tema: honestidade-maturity-matrix
autor: subagente-opus-evolucao
data: 2026-06-16
escopo: auditoria de honestidade de fronteira (NAO-NORMATIVA) — nada aqui promove estado; só registra divergências
fonte-canonica: methodology/MATURITY-MATRIX.md (v0.3.0, locked)
truth-barrier: toda afirmação cita arquivo:linha
temperatura: glacier
---

# B2 — Auditoria de Honestidade contra a MATURITY-MATRIX

> Documento de FRONTEIRA, não-normativo. Não promove componente de estado.
> Pela regra de evolução da matriz (`methodology/MATURITY-MATRIX.md:33-40`),
> só um PR com evidência + Hearback humano muda a coluna **Estado**. Este
> arquivo apenas levanta as divergências para esse PR futuro.

Princípio do dono adotado como régua de medição: "tudo que não pode ser
feito não deve ser permitido; código pronto tem de ser verdadeiro e não
pode estimular teatro; segurança real, fail-closed, verificável." A matriz
é a fonte única; nenhuma afirmação pública pode excedê-la
(`methodology/MATURITY-MATRIX.md:5-6`, `README.md:40`, `AGENTS.md:17`).

---

## (a) Componentes cujo estado REAL no código diverge da matriz

### A.1 — Truth Barrier: matriz diz "Parcial (advisory)", código confirma advisory puro

[CONCLUSÃO] A matriz declara Truth Barrier como **Parcial (advisory)**:
"regex; emite `warnings`; nao bloqueia (`engine.py:_validation_summary`)"
(`methodology/MATURITY-MATRIX.md:57`). O código confirma exatamente isso:
`evaluate_truth_barrier` retorna apenas `{"status": ..., "warnings": [...]}`
sem qualquer caminho de bloqueio (`src/usehbn/protocol/truth_barrier.py:71-74`).
No engine, o resultado vira só um item de `checks` e os warnings são
concatenados em `validation["warnings"]`; o pipeline segue independentemente
do status (`src/usehbn/execution/engine.py:54-70, 163-187`). A própria razão
gravada admite: "Validation flagged N advisory warning(s); not enforced in
v0.3.0" (`src/usehbn/execution/engine.py:88`).

[CONCLUSÃO] Aqui a matriz NÃO diverge — está honesta. A divergência real é de
risco semântico: o nome "Barrier" sugere bloqueio, mas o comportamento é
advisory. A própria matriz nomeia o risco: "Falsa sensacao de protecao"
(`methodology/MATURITY-MATRIX.md:57`). Ver seção (c).

### A.2 — Guardian: matriz diz "2 checks"; código tem 2 checks locais + passthrough

[CONCLUSÃO] A matriz diz Guardian **Parcial (advisory)**, "2 checks; loga em
`logs/guardian.jsonl`" (`methodology/MATURITY-MATRIX.md:58`). O código tem de
fato 2 checks próprios — `missing_validation` e `risky_output`
(`src/usehbn/protocol/guardian.py:25-41`) — e ainda reanexa os warnings do
Truth Barrier (`src/usehbn/protocol/guardian.py:43`). Loga em
`logs/guardian.jsonl` (`src/usehbn/protocol/guardian.py:47`). Estado da matriz
está fiel. Como Truth Barrier, é advisory: nunca bloqueia o engine.

### A.3 — DIVERGÊNCIA: "CLI Implementado, ~17 subcomandos" omite o braço autoevolve

[DÍVIDA] A linha CLI da matriz lista os subcomandos integrados a Readback,
Hearback, ERP, Relay, Handoff, Connector e diz "~17 subcomandos roteados em
`main()`" (`methodology/MATURITY-MATRIX.md:54`). Porém `main()` também
despacha um braço inteiro `hbn autoevolve` para um parser separado
(`src/usehbn/cli.py:1716-1718`), com stub para aparecer no `--help`
(`src/usehbn/cli.py:609-612`). Esse braço (status/audit/approve/rollback)
NÃO está contabilizado nem descrito em nenhuma linha da matriz. A superfície
pública real do CLI excede o que a matriz documenta. Divergência **para mais**
(o código faz mais do que a matriz declara) — e o que ele faz a mais é
exatamente o componente de maior risco de teatro (ver (b)).

### A.4 — DIVERGÊNCIA de número entre docs: 93/93 vs 114/114

[DÍVIDA] A matriz registra "Suite verde 114/114"
(`methodology/MATURITY-MATRIX.md:76`), o README estampa "Tests: 114/114"
(`README.md:5`), mas o `AGENTS.md` — declarado entry-point para qualquer IA
no repo (`AGENTS.md:6`) — ainda diz "pytest (`tests/`, currently 93/93
passing)" (`AGENTS.md:57`). Três documentos, dois números. Para um protocolo
cujo selo é "Honest Foundation", número de testes desatualizado no contrato de
agentes é dívida de honestidade de baixo custo e alta visibilidade.

### A.5 — Readback: matriz honesta sobre "não chamado pelo engine"

[CONCLUSÃO] A matriz diz Readback **Implementado** mas "Nao chamado pelo
`engine.py`; criado manualmente via CLI" (`methodology/MATURITY-MATRIX.md:60`).
Confirmado: `engine.execute_request` não importa nem invoca readback; o fluxo
do engine vai de Guardian direto a consent/validation/state
(`src/usehbn/execution/engine.py:14-22, 161-187`). Estado fiel.

---

## (b) Classificação honesta do módulo `autoevolve` (dívida de honestidade)

[DÍVIDA] O módulo `src/usehbn/autoevolve/` (orchestrator, worker, queue,
approval, audit, contract, cli) **não aparece em nenhuma linha da matriz
canônica** (`methodology/MATURITY-MATRIX.md` inteiro — busca por
"autoevolve/microdelta/sanitiza" retorna zero). Isto é uma omissão: o módulo
tem ADR ACCEPTED ratificado por hearback (`methodology/adr/ADR-010-autoevolve-cycle.md:3-9`),
página de vitrine (`site/autoevolve.html`), 4 suítes de teste, e é roteado no
CLI. A matriz exige auditoria por linha a cada release minor
(`methodology/MATURITY-MATRIX.md:104-109`); este componente escapou dela.

Classificação honesta por arquivo, com evidência:

[CONCLUSÃO] **autoevolve.audit** → **Implementado / Parcial honesto.** É a
única parte com runtime real: escreve JSONL por ciclo, agrega por status/arm,
renderiza markdown e fragmento HTML (`src/usehbn/autoevolve/audit.py:38-104`).
Tem dados reais em disco (`.hbn/autoevolve/cycle-2026-06-10.jsonl`,
`cycle-2026-05-13.jsonl`) e schema (`schemas/autoevolve-cycle.schema.json`).
Lacuna: a coluna `commit` no relatório é sempre vazia porque `MicrodeltaResult.commit`
nunca é populado por nenhum código (default `None`,
`src/usehbn/autoevolve/contract.py:51`; nada o seta — só consumido em
`cli.py:87` via argumento humano e exibido truncado em `audit.py:96`).

[CONCLUSÃO] **autoevolve.cli** → **Parcial.** Os 4 subcomandos roteados
(status, audit, approve, rollback) funcionam, mas são todos de
leitura/relatório/toggle (`src/usehbn/autoevolve/cli.py:93-117`). Não há
subcomando `plan` nem `run`: o orchestrator nunca é acionável pela linha de
comando. `rollback` apenas imprime o comando `git revert`, não reverte
(`src/usehbn/autoevolve/cli.py:86-90`).

[DÍVIDA] **autoevolve.orchestrator + worker + queue + approval + contract**
→ **Scaffold (e parcialmente Stub).** Evidência de scaffold, declarada pelos
próprios docstrings: o orchestrator "is the *scaffold* that the future
distributed pool will plug into" (`src/usehbn/autoevolve/orchestrator.py:1-7`);
o worker "apply is a no-op stub: the actual code edits are performed by the
assistant (Opus) outside this module" (`src/usehbn/autoevolve/worker.py:1-6`).
Evidência de não-uso em runtime: `Orchestrator`, `LocalWorker` e `FileQueue`
são instanciados **apenas em testes** (`tests/test_autoevolve.py:35,44,99-110`)
— nenhum chamador em `src/` fora do próprio pacote. O gate de approval checa
`diff_added + diff_removed > max_diff_lines`
(`src/usehbn/autoevolve/approval.py:27`) mas `diff_added`/`diff_removed` nunca
são preenchidos (default 0, `src/usehbn/autoevolve/contract.py:49-50`; nenhum
código os seta), então o orçamento de diff é teatro: sempre passa.

[DÍVIDA] **Risco de teatro autônomo.** O nome "autoevolve" + "Orchestrator"
+ "distributed-ready" (`src/usehbn/autoevolve/orchestrator.py:1`,
`__init__.py:6`) sugere automação que **não existe**: não há loop que puxe da
fila, edite código e commite. As edições "are produced by the assistant (Opus)
in the main loop" fora do módulo (`src/usehbn/autoevolve/orchestrator.py:3-5`).
Pelo princípio do dono ("não pode estimular teatro"), um módulo chamado
autoevolve cuja evolução é 100% humano-no-loop, com worker no-op e gate de diff
inerte, é exatamente o tipo de fachada que a matriz existe para impedir
(`methodology/MATURITY-MATRIX.md:11-14`). E ele contradiz o próprio README, que
afirma "HBN is not: a background agent system" (`README.md:113`).

[PROPOSTA] Adicionar à matriz canônica, na próxima onda de auditoria, linhas
explícitas:
- `Autoevolve (audit/report)` → Parcial honesto (evidência acima).
- `Autoevolve (orchestrator/worker/queue/approval)` → Scaffold; risco
  principal: "Promessa de automação inexistente; worker no-op; gate de diff
  inerte." O que precisa para subir: worker que de fato aplique e meça diff +
  loop acionável por CLI + enforcement do orçamento.
- `Autoevolve CLI` → Parcial (4 comandos read/report; sem plan/run; rollback
  apenas imprime).

---

## (c) Lacuna advisory → enforcing (Truth Barrier e Guardian)

[CONCLUSÃO] Pela definição do dono ("tudo que não pode ser feito não deve ser
permitido; fail-closed; verificável"), um "Barrier" e um "Guardian" que só
emitem warnings e nunca bloqueiam são **teatro de segurança**. O código é
explícito: o engine segue o pipeline independentemente do status warn
(`src/usehbn/execution/engine.py:65-70, 163-187`); a razão registrada diz
literalmente "not enforced in v0.3.0" (`src/usehbn/execution/engine.py:88`).
A matriz já nomeia esse risco como "Falsa sensacao de protecao"
(`methodology/MATURITY-MATRIX.md:57-58`) e aponta o caminho "RFC-0001 + modo
`--enforce` opt-in (roadmap)".

[CONCLUSÃO] A honestidade ATUAL está preservada: README "What Does Not Work
Yet" lista "Guardian or Truth Barrier blocking; both are advisory until a
future accepted RFC enables opt-in enforcement" (`README.md:555`), e AGENTS
mantém "Truth Barrier strict" só como convenção de chat, não enforcement de
runtime (`AGENTS.md:101`). Logo, não há overclaim — há **lacuna de
capacidade** entre a doutrina (fail-closed) e o runtime (advisory).

[PROPOSTA] Fechar a lacuna sem quebrar a honestidade nem o contrato v0.3.0:

1. [PROPOSTA] Introduzir `evaluate_truth_barrier(..., mode="advisory"|"enforce")`
   e `assess_guardian(..., mode=...)`, default `advisory` para preservar
   contrato. Em `enforce`, retornar `status="blocked"` quando houver warning de
   severidade alta (overconfidence/unsupported_claim em contexto risky), e o
   engine deve **fail-closed**: não persistir ERP, não gravar consent granted,
   retornar `stage="blocked"`. Tocaria `src/usehbn/execution/engine.py:161-187`
   atrás de uma flag — sem alterar o comportamento default.

2. [PROPOSTA] **Alocação por árvore (fail-closed no Tronco, advisory na
   Fronteira).** Operações classificadas `safe_track` / risky-context
   (`src/usehbn/protocol/truth_barrier.py:21-24`) ⇒ enforce por padrão
   (fail-closed); operações exploratórias de Fronteira ⇒ advisory permitido
   explicitamente. Isto materializa "tudo que não pode ser feito não deve ser
   permitido" sem matar a exploração.

3. [PROPOSTA] Tornar verificável: cada bloqueio grava um registro de decisão
   `category="validation", decision="blocked"` (já há o slot em
   `src/usehbn/execution/engine.py:112-118`) e emite o sinal canônico
   ❌ `HBN SECURITY BLOCKED SUGGESTION` (`AGENTS.md:80`). Sem registro
   verificável, enforcement vira outra forma de teatro.

4. [PROPOSTA] Só DEPOIS de (1)-(3) com testes adversariais, abrir PR que mova a
   matriz de "Parcial (advisory)" para "Parcial (advisory por padrão; enforce
   opt-in verificado)" — respeitando `methodology/MATURITY-MATRIX.md:33-40`.
   Enquanto isso, manter a regra: a matriz NÃO pode anunciar enforce antes do
   merge.

---

## (d) Afirmações em README/AGENTS que excedem a matriz

[CONCLUSÃO] A maior parte do README está disciplinada: usa linguagem
condicional para Scaffold/Stub (Universal Translator `README.md:252-256`;
bridges Stub `README.md:553`) e tem seções honestas "What HBN Is Not"
(`README.md:106-118`) e "What Does Not Work Yet" (`README.md:543-556`). Mas há
pontos a vigiar:

[DÍVIDA] **README:5 / README:34 — "operable HBN scaffold".** O resumo de topo
afirma "Tests: 114/114" (ok com a matriz) mas a auto-descrição como runtime
"operable" combinada à existência do braço `autoevolve` não-documentado na
matriz (ver (a.3)/(b)) cria uma janela para leitura de "auto-evolução
operável". Não é overclaim textual direto, mas é o tipo de ambiguidade que a
matriz pede evitar (`methodology/MATURITY-MATRIX.md:81-87`).

[DÍVIDA] **README:559 — "HBN is now at a solid L4 level".** "L4" não é um dos
cinco estados oficiais da matriz (`methodology/MATURITY-MATRIX.md:21-29`) nem
está definido nela. É uma escala paralela, sem âncora canônica, com adjetivo
de força ("solid"). Pelo espírito da matriz (sem verbo de maturidade que o
código não sustenta, `methodology/MATURITY-MATRIX.md:11-14`), recomenda-se
definir "L4" num doc canônico ou trocar por linguagem ancorada na matriz.

[CONCLUSÃO] **AGENTS:17** ainda aponta a "fonte da verdade" de maturidade para
`docs/MATURITY-MATRIX.md`, que está **SUPERSEDED** desde 2026-05-10
(`docs/MATURITY-MATRIX.md:3-11`). O ponteiro canônico correto é
`methodology/MATURITY-MATRIX.md` (`methodology/MATURITY-MATRIX.md:42-48`). O
README já aponta certo (`README.md:40`); o AGENTS aponta para o redirect. Não
é overclaim de capacidade, mas é dívida de consistência de fonte única.

[CONCLUSÃO] Não foram encontradas as três frases proibidas da matriz
("traduz qualquer linguagem", "gera bridges executaveis automaticamente",
"garante privacidade local" — `methodology/MATURITY-MATRIX.md:99-102`) no
README. Boa aderência nesse ponto.

---

## (e) Lista priorizada de dívidas de honestidade antes do MVP público

[DÍVIDA] **P0 — Documentar `autoevolve` na matriz canônica.** É o maior buraco:
um componente roteado no CLI (`src/usehbn/cli.py:1716-1718`), com ADR ACCEPTED
e vitrine, ausente da fonte única. Classificar audit=Parcial honesto,
orchestrator/worker/queue/approval=Scaffold, cli=Parcial. Sem isso, a auditoria
exigida em `methodology/MATURITY-MATRIX.md:104-109` está incompleta e a release
não deveria sair pela própria regra da matriz.

[DÍVIDA] **P0 — Neutralizar o teatro do autoevolve.** Worker no-op
(`src/usehbn/autoevolve/worker.py:1-6`) + gate de diff inerte
(`approval.py:27` sobre campos sempre 0, `contract.py:49-50`) + nome
"distributed-ready" contradizem "HBN is not a background agent system"
(`README.md:113`). Ou (i) implementar worker/diff de verdade, ou (ii)
renomear/marcar claramente como "scaffold conceitual, evolução humano-no-loop"
em código E matriz.

[DÍVIDA] **P1 — Alinhar contagem de testes.** `AGENTS.md:57` (93/93) vs
matriz/README (114/114, `methodology/MATURITY-MATRIX.md:76`, `README.md:5`).
Correção trivial, alto valor simbólico para "Honest Foundation".

[DÍVIDA] **P1 — Corrigir ponteiro de fonte única no AGENTS.md.** `AGENTS.md:17`
→ `docs/MATURITY-MATRIX.md` (SUPERSEDED, `docs/MATURITY-MATRIX.md:3-11`).
Apontar para `methodology/MATURITY-MATRIX.md`.

[DÍVIDA] **P1 — Definir ou remover "L4".** `README.md:559` usa escala fora dos
cinco estados oficiais (`methodology/MATURITY-MATRIX.md:21-29`). Ancorar num
doc canônico ou substituir por linguagem da matriz.

[PROPOSTA] **P2 — Plano advisory→enforcing com fail-closed por árvore.** Ver
(c). Não é dívida de honestidade hoje (o advisory está bem declarado em
`README.md:555`), mas é a maior lacuna entre doutrina ("fail-closed,
verificável") e runtime. É pré-requisito para qualquer afirmação pública de
que Truth Barrier/Guardian "protegem" — hoje só "avisam"
(`src/usehbn/execution/engine.py:88`).

[CONCLUSÃO] Veredito de fronteira: a base v0.3.0 é majoritariamente honesta no
README sobre o que NÃO funciona. As duas dívidas materiais são (1) o módulo
autoevolve invisível à matriz e com fachada de automação, e (2) a defasagem
doutrina↔runtime em Truth Barrier/Guardian (advisory ≠ barrier). Ambas devem
ser tratadas por PR + Hearback antes do MVP público, pela própria regra de
evolução da matriz (`methodology/MATURITY-MATRIX.md:33-40, 104-109`).
