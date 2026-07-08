---
tipo: audit-result
autor: codex
familia: OpenAI
path: .hbn/results/20260701-194543-codex-cross-ia-exuvia-v2-bootstrap.md
arvore: fronteira
created_at: "2026-07-01T19:45:43-03:00"
status: congelado
temperatura: glacier
---

SOU: fable-5 · familia Anthropic · papel implementador-da-exuvia (auditoria solicitada via gate humano de Mauricio)

# Auditoria cruzada adversarial — exuvia v2 bootstrap

DESTINATARIO: codex (familia OpenAI)

Escopo: /Users/macbookpro/Projetos/usehbn/versao_2_0_0, auditoria read-only exceto deposito deste parecer canonico solicitado em .hbn/results.

## V1 C-NOREG

Resultado: FALHA.

Evidencias:

- `diff -r schemas versao_2_0_0/schemas` -> sem saida, exit 0.
- `diff -r .hbn/knowledge versao_2_0_0/.hbn/knowledge` -> sem saida, exit 0.
- `diff -r guards versao_2_0_0/guards` -> exit 1, com diferenca em `guards/tests/run-guard-tests.sh`.

Trecho material do diff:

```diff
diff -r guards/tests/run-guard-tests.sh versao_2_0_0/guards/tests/run-guard-tests.sh
3656,3659c3656,3660
< # --- Read-list viva (onda 0006 I-01 — F-08 dos cross-audits 0036/0037) -------
< # Todo path .hbn/ | core/ | guards/ | schemas/ CITADO em agents/role-templates.md
< # e nos 4 specs core do rito deve EXISTIR no disco. A "referência quebrada"
< # (knowledge 0019/0022 citadas sem existir) vira classe de erro permanente.
---
> # --- Read-list viva (v2 bootstrap / onda 0006 I-01 — F-08) -------------------
> # Todo path .hbn/ | core/ | guards/ | schemas/ CITADO em BOOT.md, core/*.md
> # e read-list-canonica.txt deve EXISTIR no disco (ou ser dir). A "referência
> # quebrada" (knowledge citada sem existir) vira classe de erro permanente.
> # Em bootstrap alguns ponteiros (ex: .hbn/active-version) ficam no repo pai.
3677,3682c3679,3685
< check "readlist: templates+4 specs core sem referência quebrada" pass "$(run_readlist \
<     "$REPO_ROOT/agents/role-templates.md" \
<     "$REPO_ROOT/core/start-rite-spec.md" \
<     "$REPO_ROOT/core/orchestrator-profile-spec.md" \
<     "$REPO_ROOT/core/pointer-spec.md" \
<     "$REPO_ROOT/core/state-report-spec.md")"
---
> check "readlist: BOOT+core+canonica sem referência quebrada (v2)" pass "$(run_readlist \
>     "$REPO_ROOT/BOOT.md" \
>     "$REPO_ROOT/core/02-papeis.md" \
>     "$REPO_ROOT/core/03-rito-da-onda.md" \
>     "$REPO_ROOT/core/04-artefatos.md" \
>     "$REPO_ROOT/core/05-guards.md" \
>     "$REPO_ROOT/core/read-list-canonica.txt")"
```

Isso contradiz `MANIFESTO-MIGRACAO.md:18-24` (maquinaria vendorizada) e `FITNESS-CHECKLIST.md:45`, que declara C-NOREG verde por diff vazio.

## V2 Escrita confinada

Resultado: PASSA para modificados fora de `versao_2_0_0/`.

Evidencias:

- `.hbn/active-version` atual: linha 1 = `.`.
- `git -C /Users/macbookpro/Projetos/usehbn status --short` exibiu apenas entradas `??`, incluindo `versao_2_0_0/` e residuos/classes ja descritos no handoff.
- Consulta filtrada: `git -C /Users/macbookpro/Projetos/usehbn status --short | awk '$1 !~ /^\?\?/ && $2 !~ /^versao_2_0_0\// {print}'` -> sem saida.
- Consulta filtrada: `git -C /Users/macbookpro/Projetos/usehbn status --short | awk '$1 ~ /^M/ {print}'` -> sem saida.
- Handoff base: `.hbn/messages/20260701-090000-codex-prompt-handoff-novo-orquestrador-saneamento.md:114-142` declara arvore suja por muitos untracked, classes A-E, e proibe `git add -A`/apagamento sem manifesto.

## V3 Suites

Resultado operacional: PASSA, com ressalva de V1.

Evidencias:

- `cd versao_2_0_0 && bash guards/tests/adversarial-battery.sh` -> exit 0; final: `BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.`; lista exibida B1-B96 bloqueadas.
- `cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh` -> exit 0; final: `== resumo: 272 passaram, 0 falharam ==` e `SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.`

Ressalva: o verde de `run-guard-tests.sh` roda sobre harness divergente do incumbente, justamente o ponto que faz C-NOREG falhar.

## V4 Consolidacao fiel

Resultado: PARCIAL. Quatro regras amostradas foram preservadas; uma foi enfraquecida/conflitada.

1. Quorum de selagem: preservado. Incumbente: `guards/assert-quorum-selagem.sh:4-9` exige `seals_proposal=NNNN` e duas familias distintas != OpenAI com `APROVA_NNNN: SIM`. V2: `BOOT.md:79-82`, `core/03-rito-da-onda.md:28-30` e `core/05-guards.md:46-47` preservam 2 pareceres SIM, familias distintas e G-QUORUM/G-DIVERSITY.

2. Anti-auto-emenda de escopo: preservado. Incumbente: `core/readback-spec.md:70-85` define `files_allowed` como autorizacao previa e proibe editar escopo e usar delta no mesmo commit. V2: `core/03-rito-da-onda.md:37-41` preserva que alterar `files_allowed` no mesmo commit do artefato autorizado viola G-SCOPE.

3. Nome universal ADR-025: preservado. Incumbente: `guards/assert-parallel-id.sh:5-18` torna incondicional `AAAAMMDD-HHMMSS-<agente>-<slug>` para artefatos novos de evento, com `created_at` local e coerente. V2: `core/04-artefatos.md:16-21` incorpora o nome universal e elimina o regime serial/paralelo.

4. Hearback humano: preservado textualmente. Incumbente: `guards/assert-hearback-integrity.sh:16-22` recusa hearback nao preexistente, no mesmo commit ou impuro. V2: `core/03-rito-da-onda.md:43-47` diz que so humano escreve `human_status: confirmed` e que G-HRB verifica assinatura.

5. Temperatura/arvore: temperatura preservada, arvore conflitada. Incumbente: `core/arvores-spec.md:29-40` diz que o REGISTRY e fonte unica da arvore e que nao existe front-matter `arvore:`. V2: `core/04-artefatos.md:46-51` manda rotulo no front-matter para `.hbn/results` e specs. Isso enfraquece a decisao registry-centric e cria fonte concorrente nao declarada como HISTORICO/PENDENTE.

Achado adicional de rastreabilidade: `core/01-principios.md:15-19` preserva P1-P13 por ponteiro `../methodology/PRINCIPIOS-CONSTITUCIONAIS.md`, mas esse caminho nao existe a partir de `versao_2_0_0/core/`:

- `ls -l /Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md` -> arquivo existe no incumbente.
- `ls -l /Users/macbookpro/Projetos/usehbn/versao_2_0_0/core/../methodology/PRINCIPIOS-CONSTITUCIONAIS.md` -> `No such file or directory`.

Como P1-P13 sao constitucionais e nao foram migrados, esse ponteiro quebrado torna C-TRACE insuficiente.

## V5 Orcamento e legibilidade

Resultado: PASSA no teto; BOOT nao e suficiente sozinho.

Evidencias:

- `wc -l BOOT.md TRANSICAO.md MANIFESTO-MIGRACAO.md FITNESS-CHECKLIST.md .hbn/relay/STATE.md core/0*.md` reportou `BOOT.md` com 160 linhas e as 8 specs consolidadas com 44, 65, 68, 57, 64, 48, 47 e 49 linhas.
- `find versao_2_0_0/core -maxdepth 1 -name '*.md' -print | wc -l` -> 11 arquivos `.md` (8 specs consolidadas + 3 contratos verbatim), dentro do teto <=12.
- BOOT diz em `BOOT.md:14-17` que e a unica leitura obrigatoria, mas o proprio rito de entrada exige ler STATE e cartao de papel em `BOOT.md:38-41`. Portanto BOOT sozinho e bom roteador, mas nao basta para uma IA nova comecar com seguranca; o minimo real e BOOT + STATE + `core/02-papeis.md` do papel.

## V6 Brechas novas

Tentativas concretas:

1. Alterar harness e ainda declarar C-NOREG verde. Passou nas suites (272/0 e B1-B96), mas falha em `diff -r guards`. Isso e uma brecha de teatro se o auditor olhar so V3.

2. Quebrar ponteiro constitucional em spec nao coberta pela read-list viva. Passa V3: o bloco alterado de read-list checa BOOT, specs 02-05 e `read-list-canonica.txt`, mas nao `core/01-principios.md`; manualmente o ponteiro de P1-P13 esta quebrado.

3. Reintroduzir dupla fonte para `arvore` via front-matter. Passa no texto da v2, mas contraria o incumbente registry-centric (`core/arvores-spec.md:29-40`). Risco: auditor/IA pode validar front-matter enquanto guards validam REGISTRY.

4. Ativar com divida nata-0 declarada, nao resolvida. `MANIFESTO-MIGRACAO.md:57` diz que a lacuna de `assert-role-family.sh:105` deve ser corrigida ANTES da ativacao. Mas `FITNESS-CHECKLIST.md:54-59` lista flip de `.hbn/active-version` antes das ondas natas 1-4 e omite nata-0 na sequencia. C-DEBT mede divida declarada, nao resolvida, abrindo ativacao teatral de uma versao com bloqueio fail-closed conhecido.

5. Escrever fora do papel antes de G-ACTOR-WRITE-MATRIX. `core/02-papeis.md:61-65` declara a matriz, mas enforcement fica para a primeira onda obrigatoria. Ate la, a regra depende de gate humano, nao de guard. E divida declarada, mas e brecha operacional durante a janela pos-ativacao/pre-nata-1.

6. Validar C-TRACE/C-DEBT por afirmacao de auditor sem inventario executavel. `FITNESS-CHECKLIST.md:26-27` define ambos por conferencia humana/auditor. Sem script elemento->destino, passa se o auditor nao procurar profundamente.

Algo passa? Sim: (1) e (2) passam nas suites; (4), (5) e (6) podem passar no Fitness se tratado como checklist declarativo. Nenhum desses deveria passar o gate humano se V1/C-TRACE forem aplicados literalmente.

## V7 Fitness

Resultado: PARCIAL; ha criterios objetivos e criterios que permitem teatro.

- C-TEST e C-ADV tem comandos executaveis (`FITNESS-CHECKLIST.md:20-21`) e eu reproduzi verde.
- C-NOREG tem comando executavel (`FITNESS-CHECKLIST.md:25`) e falha nesta auditoria.
- C-XAUDIT e contavel por arquivos/vereditos (`FITNESS-CHECKLIST.md:22`), mas falta comando/parser canonico para validar familia, token e linha final.
- C-DOG (`FITNESS-CHECKLIST.md:23`) e externo ao repo usehbn; pode ser objetivo se acompanhado por `freeze-gate` exit 0, tag e hearback, mas a tabela nao fornece comando completo.
- C-FCLOSE (`FITNESS-CHECKLIST.md:24`) e objetivo em tese; a suite ja tem casos de active-version ausente/conflito/versionada, mas a tabela nao aponta script dedicado.
- C-TRACE e C-DEBT (`FITNESS-CHECKLIST.md:26-27`) permitem teatro: dependem de conferencia e de "nenhuma divida oculta apontada por auditor", sem inventario mecanico nem criterio de exaustividade.
- `FITNESS-CHECKLIST.md:41-50` declara medicoes do bootstrap como verdes, mas C-NOREG verde em `FITNESS-CHECKLIST.md:45` e falso pelo diff real.

## ACHADOS

- BLOQUEADOR: C-NOREG falha. `guards/tests/run-guard-tests.sh` foi alterado na v2, apesar da exigencia de `diff -r guards versao_2_0_0/guards` vazio e da declaracao de vendorizacao sem alteracao.
- BLOQUEADOR: C-TRACE falha para P1-P13 por ponteiro quebrado em `core/01-principios.md:15-19`; o arquivo existe no incumbente, mas o caminho relativo indicado dentro da v2 nao existe.
- BLOQUEADOR: Fitness declara C-NOREG verde (`FITNESS-CHECKLIST.md:45`) contra evidencia contraria; isso e teatro de validacao no proprio gate.
- FORTE: `arvore` foi migrada de fonte unica REGISTRY para front-matter em `core/04-artefatos.md:46-51`, contrariando `core/arvores-spec.md:29-40` sem declarar a decisao antiga como HISTORICO/PENDENTE.
- FORTE: a sequencia de ativacao em `FITNESS-CHECKLIST.md:54-59` nao explicita nata-0 antes do flip, embora `MANIFESTO-MIGRACAO.md:57` diga ANTES da ativacao.
- FORTE: C-TRACE e C-DEBT nao tem medicao executavel exaustiva, permitindo parecer de cobertura por amostragem.
- MARGINAL: BOOT cumpre teto de linhas, mas nao e suficiente sozinho; o proprio BOOT exige STATE + cartao de papel.
- MARGINAL: G-ACTOR-WRITE-MATRIX e regra declarativa ate a onda nata-1; a ausencia e declarada, mas deixa janela pos-ativacao dependente de humano.

Nivel de confianca: alto para V1, V2, V3, V5 e os achados de ponteiro/arvore; medio para exaustividade C-TRACE, porque nao inventariei todos os 22 specs + 27 ADRs elemento a elemento. Nao verifiquei C-DOG no Credenciamento/V206, nem rodei freeze-gate de projeto, nem validei outros pareceres cross-IA ja presentes.
APROVA_EXUVIA_V2: NAO
