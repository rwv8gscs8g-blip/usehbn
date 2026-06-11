---
tipo: cross-ia-reaudit
status: final
path: .hbn/results/0032-cross-ia-codex-fix-orquestracao-start.md
auditor: codex-openai
familia: OpenAI
implementador-auditado: claude-fable-5
escopo: re-auditoria curta do fix dos 3 FORTE ADR-024
veto_adocao: nao
findings_total: 0
---

# Re-auditoria Codex — FIX dos 3 FORTE (ADR-024)

## Veredito

**VETO_ADOCAO: NAO.**

Contagem: **0 BLOQUEADOR; 0 FORTE; 0 MARGINAL**.

Os 3 FORTE dos pareceres 0030/0031 morreram no escopo reexecutado:

1. G-NUM agora bloqueia `alpha-1` quando apenas `alpha` esta em
   `escrita_paralela`, usando token exato mais longo conhecido;
2. G-NUM agora bloqueia id serial `AAAAMMDD-NN` com data divergente do
   `created_at`;
3. G-RLT agora exige heading exato `## Decisões informais (cápsula)` e nao
   aceita substring solta;
4. ADR-024 D1 e `core/start-rite-spec.md` dizem inequivocamente que
   `usehbn start` e rito declarativo, nao subcomando de `src/usehbn/cli.py`.

Nao encontrei teatro novo que justifique veto de adocao nesta re-auditoria.

## Pre-flight

1. `pwd` -> `/Users/macbookpro/Projetos/usehbn` ;
2. `GIT_OPTIONAL_LOCKS=0 git status --short` -> sem saida ;
3. `git log --oneline -1` -> `603805e checkpoint(protocol): ADR-024 fix 3 FORTE (G-NUM token exato, G-RLT heading capsula, start rito≠CLI) + marginais — suite 63 — proposed, fora do runner` ;
4. Reexecucao hermetica: clone local em `/tmp/usehbn-reaudit-codex-nxIvm7/repo` ;
5. Suíte: `bash guards/tests/run-guard-tests.sh` -> `== resumo: 63 passaram, 0 falharam ==` ;
6. Provas adversariais proprias: `/tmp/usehbn-targeted-codex-j7OGmQ` -> `targeted_pass=6 targeted_fail=0` ;
7. Repo canonico depois dos testes: `GIT_OPTIONAL_LOCKS=0 git status --short` -> sem saida.

## Checks do escopo

### (1) G-NUM

**Aprovado.** O guard documenta e implementa token exato: universo de apelidos
conhecidos vem da atribuicao staged e dos perfis; o match escolhe o apelido
conhecido mais longo e depois compara por igualdade com `escrita_paralela`
(`guards/assert-parallel-id.sh:89-149`).

Provas em `/tmp`:

1. `escrita_paralela: [alpha]` + arquivo
   `.hbn/proposals/20260610-101010-alpha-1-ideia.md` -> `rc=1`, motivo contem
   `agente 'alpha-1'` ;
2. linha nova `REGISTRY.md` com id serial `20260101-08` e `created_at:
   2026-06-10T09:00:00-03:00` -> `rc=1`, motivo contem
   `id serial declara data 20260101`.

A suíte tambem cobre estes casos em `guards/tests/run-guard-tests.sh:399-453`.

### (2) G-RLT

**Aprovado.** O guard exige heading exato por regex de linha inteira e extrai o
chapeu pelo campo delimitado por `·`; header malformado bloqueia
(`guards/assert-report-fresh.sh:123-136`).

Provas em `/tmp`:

1. `(cápsula)` em nota solta, sem heading exato -> `rc=1`, motivo contem
   `sem o heading EXATO` ;
2. agente `orquestrador-1`, chapeu real `implementador`, sem capsula ->
   `rc=0` ;
3. header sem separador `·` -> `rc=1`, motivo contem `fora da forma fixa`.

A suíte cobre a substring solta em `guards/tests/run-guard-tests.sh:638-649`.

### (3) Start como rito, nao CLI

**Aprovado.** ADR-024 D1 afirma que `usehbn start` e nome de rito, nao comando
de software, e que nao deve existir subcomando `start` em `src/usehbn/cli.py`
(`methodology/adr/ADR-024-orquestracao-start.md:73-88`). A spec repete que
nao ha implementacao CLI prevista nesta onda e que o rito termina imprimindo,
com commit humano (`core/start-rite-spec.md:17-28`).

No codigo, `start` nao aparece no conjunto de subcomandos aceitos
(`src/usehbn/cli.py:1695-1715`). Testei em `/tmp` com
`PYTHONPATH=src python3 -m usehbn.cli start`: a CLI caiu no motor generico de
frase livre com `hbn_activated: false`; nao materializou o rito ADR-024.
Observacao nao-veto: por causa do fallback generico (`src/usehbn/cli.py:1765-1768`),
a palavra `start` ainda produz um log generico se digitada como argumento. Isso
nao e um subcomando `start`, mas uma futura onda pode reservar a palavra para
reduzir ambiguidade de UX.

### (4) Marginais anteriores

**Aprovado.**

1. G-PTR ignora `⟦HBN⟧` dentro de code-fence por `awk` com estado `infence`
   (`guards/assert-pointer-honest.sh:134-137`). Prova em `/tmp`: ponteiro real
   valido fora do fence + ponteiro falso dentro do fence -> `rc=0`;
2. A contagem esta honesta: a propria suíte declara 30 checks ADR-024, 20
   negativos de bloqueio, e nao "26 negativos"
   (`guards/tests/run-guard-tests.sh:22-26`). Contagem por `awk`:
   `suite_total=63 suite_block=43 suite_pass_or_warning=20`;
   `adr024_total=30 adr024_block=20 adr024_pass_or_warning=10`;
3. D6 log frio entrou no mapa de enforcement como
   `doutrina-sem-enforcement, backlog`
   (`methodology/adr/ADR-024-orquestracao-start.md:182`).

### (5) Suíte 63/63 e staged-skew

**Aprovado.** A suíte passou inteira em clone `/tmp`, nao no canonico. Nao
detectei teste que passe sempre no sentido de tornar a suíte verde sem guard
funcional: os guards novos tem casos bons e ruins, e os casos centrais do fix
foram reexecutados com checagem do motivo do bloqueio.

Risco residual conhecido, sem severidade nesta re-auditoria: o helper `check()`
continua validando `block` por `rc != 0`; portanto, um caso ruim isolado ainda
poderia ficar verde por erro generico. Isso nao se manifestou aqui porque a
suíte tem casos `pass` por guard e os adversariais principais bateram mensagens
especificas.

## Checklist anti-vies B1-B6

1. **B1 — Li os artefatos diretamente:** sim; 0030/0031 historicos exigidos,
   guards, ADR-024 D1/D6, start spec, pointer/state specs e suíte ;
2. **B2 — Reexecutei fora do canonico:** sim; clone em `/tmp` e provas
   adversariais em `/tmp` ;
3. **B3 — Procurei razoes para reprovar:** sim; tentei reproduzir prefixo
   `alpha-1`, data serial divergente, capsula solta, parser de chapeu e
   ponteiro em code-fence ;
4. **B4 — Separei resultado da narrativa:** sim; confirmei contagem por `awk`
   e nao apenas pelo comentario da suíte ;
5. **B5 — Independencia:** nao li parecer corrente de outro auditor; li somente
   0030/0031 porque estavam no escopo explicito da re-auditoria ;
6. **B6 — Pressao de concordancia:** so removi o veto depois da suíte 63/63 e
   das provas adversariais com motivos esperados.

## Resumo para humano

VETO_ADOCAO: NAO. Os 3 FORTE foram corrigidos no codigo, specs e testes; a
suíte real passou 63/63 em `/tmp`; os adversariais independentes passaram 6/6.
Nao encontrei BLOQUEADOR, FORTE ou MARGINAL novo.
