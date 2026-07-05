---
tipo: cross-ia-audit
status: congelado
path: .hbn/results/0030-cross-ia-codex-orquestracao-start.md
auditor: codex-openai
familia: OpenAI
implementador-auditado: claude-fable-5
escopo: ADR-024 + 4 specs + 4 guards + suite guards/tests/run-guard-tests.sh
veto_adocao: sim
findings_total: 4
temperatura: glacier
---

# Cross-audit Codex — ADR-024 orquestração-start

## Veredito

**VETO_ADOCAO: SIM** para adotar estes 4 guards como enforcement suficiente do
ADR-024 neste estado. A suíte oficial passa em `/tmp` (`59 passaram, 0 falharam`),
e os casos ruins principais são reais, mas encontrei 2 gaps fortes de enforcement
com provas adversariais independentes.

Contagem: **0 BLOQUEADOR; 2 FORTE; 2 MARGINAL**.

## Pre-flight

1. `pwd` → `/Users/macbookpro/Projetos/usehbn` ;
2. `GIT_OPTIONAL_LOCKS=0 git status --short` → sem saída ;
3. `git log --oneline -1` → `72afa1c checkpoint(protocol): ADR-024 metade 2 — 4 guards (G-STR/G-NUM/G-PTR/G-RLT) + 26 testes negativos (suite 59) — proposed, fora do runner` ;
4. Reexecução hermética: clone local em `/tmp/usehbn-cross-audit-codex-cVMarF/repo`; comando `bash guards/tests/run-guard-tests.sh`; saída final `== resumo: 59 passaram, 0 falharam ==` ;
5. Provas adversariais extras em `/tmp/num-prefix-theater-1FTBnh` e `/tmp/rlt-capsule-theater-XUUHh7`.

## Findings

### F-01 · FORTE · G-NUM aceita ambiguidade prefixo-agente × slug

**Evidência.** A spec exige que o `<agente>` do nome pertença a
`escrita_paralela` (`core/start-rite-spec.md:101-103`). O schema de perfil
permite apelidos com hífen (`schemas/model-profile.schema.json:29-32`). O guard,
porém, valida por prefixo textual de cada agente declarado seguido de `-slug`
(`guards/assert-parallel-id.sh:98-103`).

Prova em `/tmp`: com `escrita_paralela: [alpha]`, criei o arquivo
`.hbn/proposals/20260610-101010-alpha-1-ideia.md` e linha de REGISTRY coerente.
`bash .../guards/assert-parallel-id.sh` retornou `rc=0`. Se existir ou vier a
existir um perfil `alpha-1`, o guard não distingue "agente alpha + slug 1-ideia"
de "agente alpha-1 + slug ideia". O teste ruim atual cobre `delta-9`
(`guards/tests/run-guard-tests.sh:379-388`), mas não cobre colisão por prefixo.

**Impacto.** Em famílias reais com aliases prefixados, um escritor paralelo não
declarado pode passar pelo G-NUM como slug de um escritor declarado. Isso enfraquece
a promessa de `agente ∈ escrita_paralela`.

**Recomendação.** Antes da adoção, escolher uma regra não ambígua: delimitador
entre agente e slug que não exista em apelido, proibição schema de aliases
prefixados, ou validação contra a lista completa de perfis com detecção de
ambiguidade. Adicionar teste negativo prefixado.

### F-02 · FORTE · G-RLT aceita teatro de cápsula por substring solta

**Evidência.** A spec exige seção `## Decisões informais (cápsula)` quando o
chapéu é `conversacional-orquestrador` (`core/state-report-spec.md:42-44`) e
lista isso como bloqueador (`core/state-report-spec.md:60`). O guard só procura
a substring `(cápsula)` em qualquer ponto do handoff
(`guards/assert-report-fresh.sh:125-127`).

Prova em `/tmp`: criei handoff com relato fresco, sem heading de cápsula, mas
com a linha `PENDENTE: cross-audit; seção de (cápsula) ainda não existe`.
`bash .../guards/assert-report-fresh.sh` retornou `rc=0` e declarou "cápsula
presente onde devida".

**Impacto.** A face checável da D6 vira teatro: qualquer menção casual a
`(cápsula)` satisfaz o guard sem a seção prometida no handoff.

**Recomendação.** Exigir heading exato, por exemplo
`^## Decisões informais \\(cápsula\\)$`, e adicionar teste negativo onde a palavra
aparece fora do heading.

### F-03 · MARGINAL · A contagem "26 testes negativos" não é literal

**Evidência.** A suíte tem 59 checks e passa. A seção ADR-024 adiciona 26 checks
totais: G-STR 5 (`guards/tests/run-guard-tests.sh:309-313`), G-NUM 8
(`365-445`), G-PTR 6 (`474-509`) e G-RLT 7 (`564-611`). Desses, 17 esperam
`block`; os demais são casos bons, compatibilidade G-REG ou `pass-com-aviso`.

Além disso, `pass-com-aviso` não é assertado como aviso: `check()` valida apenas
`rc` (`guards/tests/run-guard-tests.sh:33-42`) e os runners redirecionam a saída.

**Impacto.** Não invalida a suíte, mas a narrativa "26 negativos" superestima o
que foi provado como bloqueio.

**Recomendação.** Renomear para "26 checks adicionados, 17 negativos de bloqueio"
ou assertar explicitamente os warnings quando eles forem parte do contrato.

### F-04 · MARGINAL · D6 log frio fica sem linha explícita de enforcement/backlog

**Evidência.** ADR-024 D6 declara log frio em `logs/`, consulta sob demanda e
"NUNCA em read-list" (`methodology/adr/ADR-024-orquestracao-start.md:152-154`).
A spec do orquestrador ainda normatiza nome pela regra serial/paralela
(`core/orchestrator-profile-spec.md:57-61`). O mapa de enforcement cobre a
presença da seção de cápsula e marca o conteúdo da cápsula como backlog
(`methodology/adr/ADR-024-orquestracao-start.md:171-172`), mas não explicita o
status de enforcement/backlog para log frio/naming/read-list.

**Impacto.** Pequeno, porque a adoção material de `logs/` ainda é passo futuro,
mas a própria regra "ADR sem enforcement é só md" pede que toda regra normativa
tenha dente ou backlog declarado.

**Recomendação.** Acrescentar linha no mapa: "D6 log frio/naming/read-list —
doutrina-sem-enforcement, backlog" ou definir guard futuro específico.

## Checks Positivos

1. G-STR bloqueia os casos ruins prometidos: groupthink sem hearback via
delegação ao G-FAM, orquestrador sem aptidão e escritor paralelo fora do elenco
(`guards/tests/run-guard-tests.sh:309-313`) ;
2. G-STR por argumento é coerente com a spec: o input é o JSON impresso pelo
rito antes de existir blob staged (`guards/assert-start-cast.sh:18-22`);
isso é seguro para uso sob demanda, mas não deve ser tratado como hook de commit
sem adaptação ;
3. G-NUM, G-PTR e G-RLT leem staged local ou `HEAD:path` em CI, seguindo o padrão
pós staged-skew (`guards/assert-parallel-id.sh:44-72`,
`guards/assert-pointer-honest.sh:38-43`, `guards/assert-report-fresh.sh:37-43`) ;
4. G-PTR bloqueia path inexistente, path divergente do front-matter e destino só
na working tree (`guards/tests/run-guard-tests.sh:477-509`) ;
5. G-RLT bloqueia divergência de `proxima_acao`, `ultima_atualizacao` de memória
e STATE bom só na working tree (`guards/tests/run-guard-tests.sh:573-605`) ;
6. ADR-024 consolida fielmente os três brainstorms nas decisões centrais: start
declarativo, rejeição do CLI executor/registro imediato, ponteiro de 1 linha e
cápsula como destilação em disco (`methodology/adr/ADR-024-orquestracao-start.md:59-71`).

## Recomendação Por Hearback

1. **Bloquear adoção dos guards como enforcement suficiente** até corrigir F-01
e F-02 com testes negativos novos ;
2. **Aceitar a direção arquitetural do ADR-024 com ressalva**, porque a
consolidação ADR × specs está coerente e a suíte oficial está verde em `/tmp` ;
3. **Corrigir narrativa/contagem** de "26 testes negativos" para não inflar a
prova oferecida ao humano ;
4. **Explicitar backlog de D6 log frio** no mapa de enforcement antes de marcar
o DONE-check como fechado.

## Checklist Anti-viés B1-B6

1. **B1 — Li os artefatos diretamente:** sim; ADR-024, ADR-022, 4 specs, 4
guards, G-SLF padrão staged-read, G-FAM delegado, suíte e fixtures ;
2. **B2 — Reexecutei fora do canônico:** sim; clone em `/tmp` e suíte 59/59 ;
3. **B3 — Procurei razões para reprovar:** sim; duas provas adversariais extras
foram construídas em `/tmp` ;
4. **B4 — Separei resultado da narrativa:** sim; suíte verde reconhecida, mas
contagem "26 negativos" tratada como problema marginal de precisão ;
5. **B5 — Controle de independência:** houve limitação de higiene: uma busca
ampla retornou trechos de um resultado alheio em `.hbn/results/`; não abri o
arquivo como fonte e só mantive achados reproduzidos por leitura/execução própria
em `/tmp` ;
6. **B6 — Pressão de concordância:** veto mantido apesar de 59/59 verde, porque
os bypasses adversariais são concretos.

## Resumo Para Humano

VETO_ADOCAO: SIM. A suíte oficial passa em `/tmp` com 59/59 e os principais
negativos são reais. O problema é que G-NUM aceita ambiguidade de agente por
prefixo com hífen, e G-RLT aceita qualquer `(cápsula)` solto como se fosse a
seção obrigatória. Há ainda ajuste marginal de contagem: são 26 checks ADR-024,
não 26 negativos de bloqueio. Corrigir F-01/F-02 e adicionar os testes
adversariais antes de adotar estes guards como enforcement suficiente.
