# Síntese profunda pré-freeze — useHBN (2026-06-17)

NÃO-NORMATIVO (zona livre / fronteira). Insumo de decisão produzido pelo orquestrador
(opus-4-8) a partir de 5 subagentes de análise read-only (Truth Barrier: cada achado
ancorado em arquivo:linha ou comando+saída). Nada aqui altera guard/core/roadmap por si só.

/ HEAD da branch de trabalho na análise: `2396e38` (selagem R1+R1-fix). `main` intacta em `4db6928`. /

---

## 0. TL;DR para decisão

1. **A metodologia funcionou — e mostrou seu limite no mesmo movimento.** O cross-audit ≠-família (Antigravity/Google) pegou um bug real de duplicação de estado que um auditor de família mais próxima do implementador aprovou. **Provado no disco.** Mas:
2. **A análise profunda achou um SEGUNDO bug de perda de dados — na própria R1-fix que acabamos de selar — que os 3 auditores e eu deixamos passar.** A R1-fix deduplica `decisions`/`context_history` por `execution_id`, mas o engine grava **3 decisions com o mesmo `execution_id`** por execução. No merge canônico+legado, as 3 colapsam em 1 → **validation e consent são perdidas silenciosamente.** Reproduzido por execução (3→1). É a mesma CLASSE do bug original, um nível mais sutil, mascarada por uma fixture irreal (1 decision por id).
3. **Consequência para o plano:** entra uma micro-onda de runtime **R1-fix-2** ANTES da R2 (árvores). Sequência corrigida até a tag: **R1-fix-2 (runtime dedup) → R2 (árvores registry-centric) → R3 (hardening curto) → W-FREEZE.**
4. Estamos a **~75-80%** do freeze. O perigo dominante não é fragilidade técnica (os verdes são reais) — é **não puxar o gatilho** e deixar a Fronteira inflar a casca.

---

## 1. Meta-validação: o protocolo funcionou na onda R1?

### 1.1 O que está PROVADO (no disco)
- **Diversidade de família tem valor empírico.** Bloqueador original em `src/usehbn/state/store.py:104-105` (pré-fix, commit `aeaf692`): `decisions`/`context_history` concatenados sem dedup → inchaço quadrático no merge. Antigravity (Google) deu `APROVA_0038: NAO` (`.hbn/results/20260617-003532-antigravity-cross-ia-r1-runtime.md:18`); o auditor Cursor da 1ª rodada VIU o mesmo concat e classificou como "marginal não-bloqueador" e **aprovou** (`...033849-cursor-composer...:133,143`). Sem a família ≠, o bug entraria.
- **O ciclo readback→cross-audit→fix→re-audit→selagem fecha um bloqueador, rastreável no git.** Prova ANTES/DEPOIS reproduzida por 3 famílias na 2ª rodada.
- **Scope-lock e main-protection seguraram** nos 3 ranges (R1, R1-fix, selagem): nenhum vazamento para guard/core/schema; `main` em `4db6928`.
- **Truth Barrier produz auditoria reproduzível**: pareceres rodaram pytest, adversarial-battery, git diff, overlay do store.py pré-fix.

### 1.2 O que NÃO está provado / continua sendo confiança (as fragilidades do processo)
- **G-EXC ficou INATIVO a onda inteira.** `guards/assert-exception-traceable.sh:88-94`: se `implementador` no STATE for `null`/ausente, o guard sai verde sem checar trailers. Durante R1 o STATE tinha `implementador: null` → 5 de 6 commits da R1 saíram com **trailers não-contíguos** e passaram. A contiguidade na R1-fix veio de **disciplina do executor, não de enforcement.** Ou seja: onde não houve gate ativo, houve violação — a tese "só gate enforçado vincula" é reforçada *negativamente*.
- **A "família" do auditor é auto-declarada e instável.** O mesmo Cursor declarou `Cursor/Antigravity` (1ª rodada) e `OpenAI` (2ª rodada) dentro da MESMA onda. A contagem de "famílias distintas" que justifica a selagem depende de uma string que o próprio auditor escolhe.
- **A honestidade da contagem de testes depende de humanos rodarem pytest.** A deriva 211→212 só foi pega por inspeção manual dos auditores; não há gate que case `pytest -q` com o número nos docs.
- **O bug mais profundo (decisions/3-por-id) passou por TODOS.** Três auditores ≠-família e o orquestrador validaram a R1-fix como correta. O bug sobreviveu porque **todos ancoraram na mesma fixture irreal** (1 decision/execution_id). A defesa real seria testar contra dados com a forma que o engine realmente produz.

### 1.3 Lições para o freeze (do agente de meta-validação)
1. Tornar a **contiguidade de trailers um gate independente** de `implementador==agent_id`.
2. **Normalizar a família do auditor** por um mapa canônico (stack→família), não confiar na string.
3. **Gate de honestidade de contagem de testes**: guard que compara `pytest -q` real com o número nos docs.
4. **Testar contra dados engine-reais** (não fixtures sintéticas de 1 registro) — é o que teria pego o bug das decisions.

---

## 2. O novo bloqueador de runtime (R1-fix-2) — provado

### 2.1 Evidência
- `src/usehbn/execution/engine.py:101-125` (`_decision_records`): retorna **3 dicts** com o mesmo `execution_id`, distintos só por `category` (`activation`/`validation`/`consent`).
- `src/usehbn/state/store.py` (`load_state_document`): `_record_identity` chaveia `decisions`/`context_history` por `execution_id`; `_merged_with_dedup` colapsa registros de mesma identidade.
- Reprodução (canônico `.hbn/` + legado `.usehbn/`, forma do engine):
  ```
  decisions após merge (esperado 3): 1
    - activation        (validation e consent perdidas)
  ```
- **Impacto:** só dispara na coexistência `.hbn/` + legado — exatamente o cenário de migração que o R1 introduziu. Não corrompe arquivo (escrita canônica é íntegra), mas **perde a trilha de decisão de validação/consent silenciosamente.**

### 2.2 O fix (requisito, não implementação)
A identidade de dedup tem de ser **assimétrica e correta**:
- `executions`, `results`: continuam por `execution_id` (são únicos por execução; canônico vence). MANTER.
- `decisions`, `context_history`: dois registros só são "o mesmo" se `execution_id` **E** `category` (e/ou conteúdo integral) coincidem. Assim as 3 categorias sobrevivem e duplicatas reais (mesma exec+category re-migrada) colapsam com canônico vencendo.
- **Teste obrigatório engine-real:** usar `_decision_records` (3 decisions/execution) no fixture e asserir que as 3 sobrevivem a um merge canônico+legado. O teste deve FALHAR no código atual e PASSAR com o fix.

### 2.3 Por que é micro-onda própria (não dentro da R2)
Princípio de leveza/lixo-zero: uma onda, uma preocupação. R1-fix-2 é runtime/estado; R2 é livro-razão/árvores. Misturar esconde regressão e quebra a rastreabilidade do que cada onda fechou.

---

## 3. Mapa do runtime (`src/usehbn/`) — o que é sólido, dívida, bloqueador

**SÓLIDO para freeze:** hierarquia de exit codes e fail-closed de violação (`protocol/result.py:34-45`, `cli.py:1713-1828`) — honesto e coberto por golden tests; `utils/config.py`, `protocol/readback.py`, `execution/engine.py`. Suíte 212/212.

**Scaffold honestamente declarado (não-teatro escondido):** `autoevolve/worker.py:1-6` (no-op stub), `orchestrator.py:1-7` (scaffold), `cli.py:616-620` ("no autonomous evolution in v0.3.0"). `contract/queue/approval/audit` são infra mínima real.

**Dívida aceitável (anotar, não bloqueia):** `cli.py` monolítico (1832 LOC, funções longas, templates markdown hardcoded); duplicação em `runtime.py:104-197`; validador JSON caseiro (`utils/validators.py`); `project_root()` por `parents[3]` (`config.py:19`); dicts de erro de subcomando sem envelope `code` (`cli.py:1772,1799`); `result` não-atômico (`cli.py:1483-1505`, mitigado por guarda de overwrite); `.venv` hardcoded no worker.

**BLOQUEADOR de freeze:** o bug das decisions (seção 2). Único bloqueador de código real.

**Buracos de teste perigosos para v1:** (1) nenhum teste exercita merge com múltiplos registros por execution_id — onde o bug vive; (2) sem teste de atomicidade do `result`; (3) `inspect_target` com manifest.json corrompido sem teste.

**Candidatos a exúvia:** subsistema `autoevolve/` enquanto no-op; templates markdown embutidos → arquivos de recurso; validador JSON caseiro → `jsonschema`; quebrar `cli.py` em `commands/`.

---

## 4. Mapa dos guards + bateria adversarial

22 guards no runner `guards/hbn-guards-runner.sh:49-72` (fail-fast/fail-closed, pré-checa raiz canônica). Bateria adversarial **VERDE** (B1–B33 bloqueadas, rodada de verdade).

**Guards sólidos:** G-SCOPE (anti-auto-emenda B16, anti-symlink B18/B19), G-FRONTDOOR (teto duplo byte+linha), G-KNOW-INDEX (anti-substring + ponteiro-morto — **a premissa de falso-positivo por substring JÁ ESTÁ FECHADA**, `assert-knowledge-index.sh:55-59`), G-SCRATCH-*, G-ZONA-LIVRE, G-HRB (assinatura SSH real), G-TOK (posse anti-replay). Prosa-trailer (G-EXC) JÁ fechado (último-parágrafo, B31).

**Lacunas que a R2 DEVE fechar:**
- **G-REG só `--diff-filter=AR`** (`assert-registry-line.sh:71-73`) — NÃO dispara em Modification (M). A própria regra do livro-razão diz "mudança de temperatura/ciclo = nova linha" (`REGISTRY.md:7`), mas é **não-enforçada para M**. É a reescrita silenciosa do livro-razão — o vetor central das "árvores". **Mais o guard anti-mislabel** (árvore `estavel`/`intermediaria` exige registro de promoção referenciável; invariante `estavel ⇒ quente`). Adicionar burla nova na bateria (hoje inexistente para M).
- **G-EXC com `implementador` ausente/null** (`assert-exception-traceable.sh:88-94`) — opt-out por omissão de metadado. Tratar como caso a investigar, não como "sem exceção" verde.

**Lacunas aceitáveis-com-dívida até a exúvia:** dispatch `human_authorization` como texto livre (`assert-dispatch-integrity.sh:201`, sem assinatura) e `zona_livre_curada` auto-declarado (`assert-zona-livre.sh:118`) — a defesa de posse (G-TOK) e a cadeia hearback SSH cobrem o caminho crítico.

**Risco estrutural (meta-padrão knowledge 0024):** os guards governam bem ADIÇÃO de conteúdo (A/R) e PRESENÇA de marcadores, mas governam mal a **MUTAÇÃO de metadado de controle (M)** e a **AUTENTICIDADE** desses marcadores. A próxima superfície não-governada é o **metadado autodeclarado (STATE/readback/REGISTRY) que CONFIGURA os gates, sob Modification.** O hardening mais alavancado é exatamente o G-REG-em-M + anti-mislabel.

---

## 5. R2 — design das árvores (registry-centric) + complemento Fronteira

**Decisão confirmada (ADENDO `proposta-arvores...mvp.md:126-128`): registry-centric leve** — uma coluna/campo `arvore` no REGISTRY.md, **SEM** front-matter `arvore:`, **SEM** parser YAML, **SEM** `core/arvores-spec.md` pesado, **SEM** `G-ARVORE`. Isso REVOGA o design original (Parte 1.3) da própria proposta. Promoção reusa os 8 critérios de exúvia (`core/exuvia-fitness-criteria.md:79-86`).

**As 3 árvores (eixo de PROVA, ortogonal a `temperatura`=tempo e `hbn-track`=processo):** fronteira (não provado, fora do MVP) → intermediaria (enforcement existe, entra no MVP) → estavel (lei provada).

**Escopo mínimo e suficiente da R2:**
1. **Campo `arvore` no REGISTRY** como fonte ÚNICA do nível-de-prova. **Decisão de design a fixar:** 7ª coluna física vs. campo inline (o REGISTRY já carrega metadado inline na coluna `tipo`, ex.: `REGISTRY.md:920`). Cuidado com `registry_has_exact` (`assert-registry-line.sh:117-135`) — casamento exato de coluna pode quebrar.
2. **Extensão G-REG para `diff-filter=M`** restrita a metadado de ciclo, exigindo linha de evento de promoção no mesmo commit. Corrigir junto o comentário-header desatualizado (G-REG ESTÁ no runner, `hbn-guards-runner.sh:61`).
3. **Guard anti-mislabel** (`guards/assert-arvore-label.sh`), fail-closed + 1 caso positivo, 1 negativo na suíte + 1 burla na adversarial-battery (mislabel→`estavel` sem promoção → BLOQUEADA).
4. **Selagem dos 4 pareceres `*batch1-fronteira*`** (untracked, fora do REGISTRY — confirmado) + linha no REGISTRY.
5. Gate de promoção (8 critérios) como **spec de referência**, não maquinaria executável nova.

**FICA FORA (exúvia/R3):** compilador `.md→Rust`, partição física `versao_x/`, bloco `enforcement:`, `G-PROV`/`HBN-Spec-Source` (R3), `G-FDACK` com token (R3), assinatura criptográfica, front-matter `arvore:`/`G-ARVORE`/parser YAML (mortos pelo ADENDO), trailer `# hbn-arvore:` em bash (micro-guard a mais, contra P11).

**3 maiores riscos da R2:**
1. **Duplo-dono-da-verdade não-resolvido:** A2 e PROPOSTA-arvores-agora ainda dizem **front-matter**, o ADENDO diz **REGISTRY**. gpt-5 elevou isso a BLOQUEADOR B-01 (`gpt-5...:14,56`). **Mitigação: o 1º commit da R2 reconcilia a fonte** (reescreve a spec para "REGISTRY é o dono") antes de implementar.
2. **Motivação anulada do G-REG-para-M:** a razão original (vigiar `arvore:` no front-matter) some no modelo registry-centric, onde a promoção é append-line no REGISTRY. **Mitigação: escopo cirúrgico** — M cobre `temperatura:` em specs com front-matter; árvore é validada como linha de promoção pelo anti-mislabel.
3. **Quebra do parser exato do REGISTRY** ao adicionar coluna (R-01 gpt-5). **Mitigação: decidir inline-vs-coluna e testar o casamento antes de selar.**

---

## 6. Prontidão de freeze + exúvia

**Checklist de freeze (estado REAL pós-R1, mais verde que a proposta sugeria):**
- P-CAND-04 (scratch + G-SCRATCH-*): **SELADO** (0035).
- Deny-by-default / G-ZONA-LIVRE: **SELADO** (0037). Limite: é deny-by-default *da zona livre*, não global; `zona_livre_curada` auto-declarado = dívida rastreada.
- Hardening das marginais (W2): **SELADO**.
- Árvores etiqueta leve: **FUTURO / R2 em voo** (4 pareceres untracked).
- Tag v1-estável: **FUTURO** — a tag NÃO existe (`git tag -l`); `.hbn/freeze/` não existe; a maquinaria (`guards/freeze-gate.sh`, `schemas/freeze-checklist.schema.json`) nunca foi rodada para v1.
- Ponte (VETO 0034/0035): **ABERTO** — mas é **pré-uso-real-no-V206, NÃO pré-freeze** (os 4 bloqueadores auditam a proposta de migração `usehbn ⇄ Credenciamento`, não o protocolo). Congelar v1 sem resolver a Ponte é legítimo.

**Definição de "estável" (proposta 2.1):** as 6 propriedades (teste +/-, adversarial, cross-audit ≠-família, fail-closed, sem regressão, rastreabilidade) estão **verdes para o núcleo já selado**, com 2 ressalvas: G-EXC null (rastreabilidade) e o bug das decisions (que precisa do R1-fix-2).

**Exúvia — o que o freeze deve deixar pronto como "genoma limpo":** (a) tag v1 = casca 0.3.x congelada; (b) REGISTRY com a coluna `arvore` separando estavel/intermediaria (entram no genoma) de fronteira (ficam fora); (c) a bateria adversarial B1–B33 carregada como **CRISPR/memória imunológica** a transferir integralmente (`exuvia-evolucao-conceitual.md:53-54`); (d) toda dívida conhecida **registrada** (C-DEBT), não escondida. Adiados deliberadamente (todos na Fronteira, não-normativos): compilador `.md→Rust`, partição física, assinatura criptográfica, emenda P13, CRISPR formal, esteiras/chapéu.

---

## 7. Sequência recomendada até a tag v1-estável

1. **R1-fix-2 (runtime)** — corrigir a identidade de dedup de `decisions`/`context_history` (incluir `category`/conteúdo) + teste engine-real. Re-cross-audit ≠-OpenAI + hearback + selagem.
2. **R2 (árvores registry-centric)** — reconciliar fonte→REGISTRY (1º commit), campo `arvore`, G-REG-em-M + anti-mislabel, selar os 4 batch1-fronteira. Cross-audit ≥2 famílias + hearback + selagem.
3. **R3 (hardening curto)** — fechar G-EXC implementador=null (gate de trailer independente do acoplamento); registrar como C-DEBT a dívida `zona_livre_curada`; (candidato) gate de honestidade de contagem de testes.
4. **Gate humano em paralelo** — Maurício gera/registra `.hbn/operators/<nome>.pub` (ativa G-HRB; branch protection biométrica já armada).
5. **W-FREEZE** — criar `.hbn/freeze/<id>-freeze-v1.json`, preencher critérios com evidência, rodar `guards/freeze-gate.sh` no Terminal (humano), suíte+adversarial verdes, revisar main, **tag `v1-estavel`**, STATE/REGISTRY marcam v1.
6. **(pós-freeze, independente) Ponte** — corrigir os 4 bloqueadores 0034/0035 → uso real no V206.

**Risco dominante: tarde demais.** A esteira tem deriva de escopo crônica; a Fronteira infla a casca a cada onda. Congelar deve significar: parar de adicionar, criar o checklist, rodar o gate, taggear — e mover todo o resto (incluindo a Ponte) para depois da casca fechada.
