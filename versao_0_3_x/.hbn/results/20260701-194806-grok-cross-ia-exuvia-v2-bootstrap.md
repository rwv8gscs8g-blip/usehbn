---
tipo: audit-result
autor: grok
familia: xAI
path: .hbn/results/20260701-194806-grok-cross-ia-exuvia-v2-bootstrap.md
arvore: fronteira
created_at: "2026-07-01T19:48:06-03:00"
status: congelado
temperatura: glacier
---

SOU: fable-5 · familia Anthropic · papel implementador-da-exuvia (auditoria solicitada via gate humano de Mauricio)

# Relatório de Auditoria Adversarial Cruzada (grok/xAI) — Bootstrap useHBN v2

Auditoria adversarial READ-ONLY do bootstrap da primeira exúvia `versao_2_0_0/` construída por fable-5 (Anthropic) em 2026-07-01 sob autorização humana explícita. CHAT NOVO, SEM MEMORIA. Nenhum arquivo alterado, sem staging, sem commit, sem --no-verify. Verificações realizadas via comandos read-only e inspeção de disco.

Contexto: incumbente ativo (`.hbn/active-version = "."`); nova versão só ativa pós Fitness Gate completo + quórum + hearback humano.

---

## V1 C-NOREG

**Veredito: PARCIAL (não vazio como exigido)**

Evidências:

Comandos executados (de /Users/macbookpro/Projetos/usehbn):
```bash
diff -r guards versao_2_0_0/guards
diff -r schemas versao_2_0_0/schemas
diff -r .hbn/knowledge versao_2_0_0/.hbn/knowledge
```

Saídas:
- schemas: vazio (exit 0)
- .hbn/knowledge: vazio (exit 0)
- guards: NÃO vazio. Diff mostra divergências no harness de testes (run-guard-tests.sh), não na lógica de guards principais:

```
diff -r guards/tests/run-guard-tests.sh versao_2_0_0/guards/tests/run-guard-tests.sh
3656,3659c3656,3660
< # --- Read-list viva (onda 0006 I-01 — F-08 dos cross-audits 0036/0037) -------
< # Todo path .hbn/ | core/ | guards/ | schemas/ CITADO em agents/role-templates.md
...
> # --- Read-list viva (v2 bootstrap / onda 0006 I-01 — F-08) -------------------
> # Todo path .hbn/ | core/ | guards/ | schemas/ CITADO em BOOT.md, core/*.md
...
3677,3682c3679,3685
```

Alterações: comentários atualizados + skip para ".hbn/active-version" + ajuste de detecção de paths para bootstrap. 

**Achado:** A afirmação "guards herdados SEM alteração de lógica" (MANIFESTO-MIGRACAO.md:36, core/05-guards.md:15, FITNESS-CHECKLIST) não é estritamente verdadeira para o harness de testes. C-NOREG como definido no prompt ("devem ser vazios") falha.

---

## V2 Escrita confinada

**Veredito: VERDE**

Comando:
```bash
git -C /Users/macbookpro/Projetos/usehbn status --short
```

Saída (resumo relevante):
```
?? .hbn/logs/
?? .hbn/messages/...
?? ... (vários ?? pré-existentes de classes A-E)
?? versao_2_0_0/
```
Nenhum arquivo com prefixo `M ` (modificado), `A ` ou `D ` fora de `versao_2_0_0/`.

Comandos adicionais:
```bash
git -C /Users/macbookpro/Projetos/usehbn diff
git -C /Users/macbookpro/Projetos/usehbn diff --cached
```
Ambos vazios.

`.hbn/active-version` permanece `.` (cat confirma).

Coerente com handoff 20260701-090000 (árvore suja por untracked pre-existentes, não por modificação do incumbente pelo bootstrap).

---

## V3 Suites

**Bateria adversarial:**
```bash
cd versao_2_0_0 && bash guards/tests/adversarial-battery.sh
```
Saída final (terminal): 
```
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```
B1–B96 todas BLOQUEADA ✓ (exit 0). Paridade com incumbente.

**Suíte de guards:**
```bash
cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh
```
Resumo:
```
== resumo: 272 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

Comparação com incumbente (mesma máquina):
```bash
cd /Users/macbookpro/Projetos/usehbn && bash guards/tests/run-guard-tests.sh
```
Também: `272 passaram, 0 falharam`.

Análise vs manifesto: O manifesto lista dívida nata-0 (assert-role-family.sh:105) e menciona falhas ambientais. Na execução atual (active-version ainda `.`), 0 falhas. Nenhuma falha DIFERENTE da dívida declarada. A diferença de contagem histórica (271/1 em relatórios anteriores) coincide com ajustes no harness de v2 (ver V1). Paridade técnica verificada.

---

## V4 Consolidação fiel

Amostra de 5 regras vinculantes do incumbente (fontes antigas em core/ e AGENTS.md + knowledge) conferidas contra specs v2:

1. **Quórum de selagem (G-QUORUM + G-DIVERSITY)**  
   Incumbente: core/orchestrator-profile-spec.md:178 `(e) auto-certificacao e NULA: ratificacao = >=2 familias != implementador + gate humano (G-QUORUM)`; knowledge 0028/0029.  
   v2: BOOT.md:79-81, core/02-papeis.md:18-21, core/03-rito-da-onda.md:29-30, core/05-guards.md:46. Preservado textualmente + reforçado. SEM enfraquecimento.

2. **Anti-auto-emenda de escopo (G-SCOPE)**  
   Incumbente: core/readback-spec.md (campos), guards/assert-scope-lock.sh, bateria B16.  
   v2: core/03-rito-da-onda.md:39-42 "alterar `files_allowed` no mesmo commit do artefato que ele autoriza é violação (anti-auto-emenda, G-SCOPE)". Preservado + guard herdado intacto.

3. **Nome universal ADR-025**  
   Incumbente: guards/assert-parallel-id.sh, core/arvores-spec etc.  
   v2: core/04-artefatos.md:16-21 "Nome universal (incondicional — ADR-025 incorporado) `AAAAMMDD-HHMMSS-<token>-<slug>.md` ... em -03:00", BOOT.md:93-94. Preservado; G-NUM herdado.

4. **Hearback humano (G-HRB)**  
   Incumbente: guards/assert-hearback-integrity.sh, AGENTS/role.  
   v2: core/03-rito-da-onda.md:43-47 "Só o humano escreve `human_status: confirmed`. IA que o preencha comete violação classe F-01." + assinatura SSH. Guard vendorizado intacto. Preservado.

5. **Temperatura (ciclo quente/frio/glaciar + REGISTRY)**  
   Incumbente: core/arvores-spec.md, REGISTRY antigo.  
   v2: core/04-artefatos.md:37-44 (quente=vigente, frio=histórico, glaciar=morto; rebaixamento = linha REGISTRY), BOOT §7. Preservado + trava contra 2 quentes.

**Regras vinculantes que sumiram ou enfraqueceram sem constar adequadamente no MANIFESTO:**

- **Rito de ENTRADA / RELATO DE LEITURA (I-10, state-report-spec §5)**: Guard `assert-report-fresh.sh:137-160` ainda exige `## RELATO DE LEITURA` + citações `arquivo:linha` para handoffs `tipo: entrada`. Porém `core/03-rito-da-onda.md` só documenta "Relato de Estado" (§57-61). Consolidação (MANIFESTO mapeia state-report-spec → 03) omitiu a seção de prova de leitura de entrada. Não listado como PENDENTE/HISTORICO explícito. **Enfraquecimento documental**.

- **Porta da frente (core/role-cards.md)**: AGENTS.md + core/role-cards.md era read-list + cartões mínimos. Guard `assert-frontdoor.sh:19` hardcode "core/role-cards.md" e valida estrutura (PARTE A read-list ≤6 itens). v2 não tem `versao_2_0_0/core/role-cards.md` (substituído por BOOT + 02-papeis). MANIFESTO não lista "role-cards" como pendência de ativação. 

Nenhuma outra regra constitucional sumiu sem rastro; a maioria das 22+ADRs foi mapeada.

---

## V5 Orçamento e legibilidade

Comandos:
```bash
wc -l versao_2_0_0/BOOT.md
ls versao_2_0_0/core/*.md | wc -l
wc -l versao_2_0_0/.hbn/relay/STATE.md
```

Saídas:
- BOOT.md: 160 linhas (≤300 ✓)
- core/*.md: 11 (8 consolidadas + 3 verbatim: exuvia-fitness-criteria, freeze-gate-spec, dual-run-spec) (≤12 ✓)
- STATE: 52 linhas totais; Resumo executivo ~19 linhas numeradas (≤30 ✓)

O BOOT sozinho é suficiente para uma IA nova começar com segurança?

**Parcialmente sim (entrada), mas com ressalvas.** 
- BOOT §2 define rito de 3 passos + preflight + ponteiros para STATE + cartão (02-papeis).
- BOOT §10 é mapa explícito "leia sob demanda".
- Porém: muitos guards (G-FRONTDOOR, G-ORQ-ENTRADA via read-list PENDENTE_REHASH, G-READLIST-RITE) esperam artefatos legados ou hashes pendentes. IA que confiar só no BOOT e tentar commit pós-flip será bloqueada sem aviso no BOOT. O "orçamento constitucional" R1 é cumprido numericamente, mas a superfície de choque BOOT×guards herdados não é toda documentada no BOOT.

---

## V6 Brechas novas

O modelo "versão = pasta inteira + BOOT enxuto" + vendorização de guards abre vetores que o incumbente mitigava com read-list monolítica + role-cards + 22 specs entrelaçadas. Liste tentativas concretas (simulações conceituais baseadas em código de guards + specs; não alterei nada):

1. **Bypass de matriz de escrita via readback forjado (até nata-1)**  
   Tentativa: criar readback com `files_allowed` incluindo `core/` ou `guards/` e committar como "implementador".  
   G-SCOPE valida contra readback staged, mas G-ACTOR-WRITE-MATRIX (declarado em `core/actor-write-matrix.txt`) **não existe**. Matriz é "regra (c)" até onda. Passa parcialmente (sem dente mecânico forte que incumbente pretendia).

2. **Leitura além do orçamento + citação de "fronteira" sem enforcement de BOOT**  
   Tentativa: IA ignora "leia só BOOT+STATE+cartão" e lê `core/*.md` inteiro + knowledge.  
   Incumbente tinha G-FRONTDOOR + read-list canônica com hashes + G-ORQ-ENTRADA como compensação. v2 tem `read-list-canonica.txt` com `PENDENTE_REHASH` (linhas 5-8, 10-18) e G-ORQ-ENTRADA ainda não revalidado. Sem guard de "bytes lidos", só disciplina. Parcialmente passa.

3. **Ativação + operação imediata (frontdoor mismatch)**  
   Flip `.hbn/active-version=versao_2_0_0` → primeiro commit orquestrado.  
   `assert-frontdoor.sh:39` : `git cat-file` de `core/role-cards.md` falha → block. Não é "burla" (fecha), mas quebra uso legítimo que incumbente permitia. Design abre "armadilha de ativação".

4. **Orquestrador assume bastão com read-list não rehashada**  
   Tentativa: orquestrador declara leitura via readback com read_list_rite, mas hashes são PENDENTE_REHASH. G-READLIST-RITE pode não morder até nata-3. Teatro de honestidade de entrada possível.

5. **Citação de princípios fora da versão ativa**  
   Tentativa: citar P1-P13 de `../methodology/PRINCIPIOS-CONSTITUCIONAIS.md` como "vigente".  
   `core/01-principios.md:17` aponta para fora da pasta. G-PTR pode não cobrir (path relativo funciona no git tree). Enfraquece "leia SÓ a vigente".

6. **Smuggle de parecer via chat sem depósito canônico** (já bloqueado, mas)  
   G-AUDITOR-ID + G-QUORUM + rito BOOT §148 exigem `.hbn/results/`. Não passa.

7. **Alteração de STATE sem quórum via orquestrador-provisório**  
   Guard G-STATE + G-NEXT + assert-state-structural bloqueiam. Não passa.

**Síntese V6:** O redesenho não abre bypasses nas 96 burlas adversariais (BATERIA VERDE). Abre brechas de **enforcement incompleto** (matriz, frontdoor, read-list rehash) que o incumbente bloqueava por presença física de artefatos + specs detalhadas. Algumas "passam" (teatro ou bloqueio de uso legítimo) até as ondas natas 0-3.

---

## V7 Fitness

Os 8 critérios do FITNESS-CHECKLIST.md têm medição?

| # | Critério | Medição objetiva executável? | Teatro possível? |
|---|----------|------------------------------|------------------|
| 1 | C-TEST | SIM (`run-guard-tests.sh` + contagem) | Baixo (exige saída real) |
| 2 | C-ADV | SIM (`adversarial-battery.sh` B1-B96) | Baixo |
| 3 | C-XAUDIT | SIM (contar 4 arquivos .hbn/results/ + linha final exata) | Médio (auditor pode mentir; mitigado por 4 famílias + diversidade) |
| 4 | C-DOG | SIM (`freeze-gate` exit 0 + tag + hearback real V206) | Baixo se executado |
| 5 | C-FCLOSE | SIM (repo-teste isolado, active-version ausente/duplicado → block) | Baixo |
| 6 | C-NOREG | SIM (`diff -r` + suíte paridade) | Nenhum (mas ver V1: diff não foi vazio) |
| 7 | C-TRACE | PARCIAL ("conferência do MANIFESTO por auditor") | ALTO — depende de diligência; amostragem vs exaustivo |
| 8 | C-DEBT | PARCIAL ("nenhuma dívida oculta apontada por auditor") | ALTO — meta; só fecha com adversarial real + múltiplas famílias |

C-TRACE e C-DEBT são inerentemente dependentes de auditor humano/IA adversarial. O design aceita isso e compensa com C-XAUDIT de 4 famílias + hearback. Risco de teatro existe se auditor único ou complacente.

---

## ACHADOS

| ID | Severidade | Achado | Evidência |
|----|------------|--------|-----------|
| G1 | BLOQUEADOR | G-FRONTDOOR hard-depende de `core/role-cards.md` ausente na v2. Primeiro commit pós-flip falha. Não declarado como pendência de ativação no MANIFESTO/FITNESS. | `guards/assert-frontdoor.sh:19,39-42`; ausência de role-cards em versao_2_0_0/core/; AGENTS.md + core/role-cards.md no incumbente |
| G2 | BLOQUEADOR | nata-0 (`assert-role-family.sh:105` usa repo_root em vez de ACTIVE_ROOT) declarada no MANIFESTO como "nata-0 (Codex, ANTES da ativação)", mas não corrigida. | MANIFESTO-MIGRACAO.md:57; `guards/assert-role-family.sh`; FITNESS exige correção pré-flip |
| G3 | FORTE | C-NOREG não cumpre "diffs vazios": harness de testes editado (comentários + skips bootstrap). | diff guards/tests/run-guard-tests.sh (linhas ~3656-3685); contraria MANIFESTO:22 e core/05-guards.md:15 |
| G4 | FORTE | Matriz de escrita declarativa (`core/actor-write-matrix.txt`) sem enforcement G-ACTOR-WRITE-MATRIX (nata-1). | core/02-papeis.md:63-65; MANIFESTO §PENDENTE; permite desvio de papel até onda |
| G5 | FORTE | Consolidação omitiu documentação do RELATO DE LEITURA (I-10) na spec de rito; guard ainda exige. IA que lê só BOOT+03 não vê a regra completa. | `assert-report-fresh.sh:137-160`; `core/03-rito-da-onda.md:57-61` só menciona "Relato de Estado"; MANIFESTO mapeamento state-report-spec |
| G6 | MARGINAL | BOOT afirma "ÚNICA leitura obrigatória" (§14) mas rito real exige mais (02-papeis, STATE, read-list pendente, knowledge herdada) e guards esperam artefatos legados. | BOOT.md:14-17,126-141 vs realidade dos guards e read-list-canonica.txt |
| G7 | MARGINAL | Princípios P1-P13 apontam para `../methodology/` fora da versão ativa. | core/01-principios.md:17 |
| G8 | MARGINAL | read-list-canonica.txt com PENDENTE_REHASH (nata-3). Orquestrador não pode ser mecanicamente honesto na entrada até correção. | versao_2_0_0/core/read-list-canonica.txt:5-18 |

Nenhuma dívida oculta além das declaradas + gaps de consolidação acima.

---

## Conclusão

O bootstrap cumpre confinamento de escrita (V2), bateria adversarial (V3), orçamento numérico (V5) e preserva as 5 regras amostradas sem enfraquecimento direto (V4). Porém:

- Incoerências estruturais (G-FRONTDOOR quebrado, nata-0 pendente apesar de manifesto exigir ANTES, harness não idêntico, matriz sem dente) impedem ativação segura.
- O modelo de concentração (design+impl por uma IA) foi contrabalançado por cross-audit, mas os achados BLOQUEADOR/FORTE mostram que o contrapeso ainda não validou prontidão.
- Veredito: não está pronto para Fitness Gate completo nem flip.

**Nível de confiança:** 80% (alta em V1-V3,V5 por comandos diretos; média em V4 por amostragem + inspeção de guards; média-baixa em comportamento exato pós-flip sem simular ativação completa em repo isolado).

**O que não pude verificar:** C-DOG (freeze V206 real do Credenciamento sob membrana); execução com hook-shims instalados apontando para v2; C-FCLOSE em repo-teste isolado com flip; exaustividade 100% do MANIFESTO elemento-a-elemento (amostrei + busquei gaps de consolidação).

APROVA_EXUVIA_V2: NAO
