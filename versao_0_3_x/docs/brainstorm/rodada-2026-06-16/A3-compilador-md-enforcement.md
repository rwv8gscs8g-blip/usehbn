---
arvore: fronteira
status: congelado
tema: compilador-md-enforcement
autor: subagente-opus-evolucao
data: 2026-06-16
temperatura: glacier
---

# A3 — O compilador de intenção: derivar e verificar guards a partir do `.md` de origem

Prova-de-conceito de **design** (não-implementação). Trabalho de Fronteira,
não-normativo. Aprofunda a seção K do brainstorm (`docs/brainstorm/exuvia-evolucao-conceitual.md:108-117`):
o `.md` é o software; o guard em bash/Python/Rust é a **saída impressa** da
codificação. Toda afirmação cita arquivo:linha ou comando+saída (Truth Barrier).

## Resumo da tese (reframe do Maurício, verificado)

- [CONCLUSÃO] O reframe já está registrado: "o protocolo é um **compilador de
  intenção**: fonte = `.md` (...); alvo = artefato que faz cumprir a regra,
  'impresso' em qualquer linguagem" (`exuvia-evolucao-conceitual.md:114`). E a
  causa-raiz da divergência das duas superfícies: "elas derivaram porque ainda
  NÃO há compilador — a regra é escrita à mão no `.md` e de novo à mão no guard,
  e a sincronização manual deriva" (`:116`).
- [CONCLUSÃO] Este documento responde: qual a **forma mínima machine-consumível**
  que um spec `.md` precisaria ter, e que verificação dupla fecha o ciclo, sem
  ainda construir um gerador de código.

## 1. O estado real no disco (linha de base honesta)

- [CONCLUSÃO] **A regra hoje vive escrita à mão em dois lugares.** Exemplo
  vivo: a Invariante Zsh-Safe ("o corpo colável de um dispatch não pode conter
  linha iniciada por `#`") está em prosa no spec (`core/dispatch-spec.md:47-52`)
  e re-codificada à mão em bash no guard `G-DSP-FMT`. O spec só *cita* o guard
  ("G-DSP-FMT valida a forma e esta regra zsh-safe", `:54`); não há link que uma
  máquina possa seguir do spec para o guard nem do guard para o spec.
- [CONCLUSÃO] **A proveniência é informal e inconsistente.** Varredura dos
  cabeçalhos (comando+saída):
  ```
  for g in guards/*.sh; do head -25 "$g" | grep -oE 'core/[a-z-]+spec\.md|ADR-[0-9]+' ...
  ```
  resultado: 9 dos ~22 guards citam um `core/*spec*.md` ou um `ADR-NNN` num
  comentário de topo (ex.: `assert-pointer-honest.sh` → `core/pointer-spec.md`,
  `ADR-024`, `ADR-021`); os demais — incluindo `assert-scope-lock.sh`,
  `assert-dispatch-integrity.sh`, `assert-frontdoor.sh`, `forbid-env-files.sh` —
  **não citam nada** machine-consumível. O guard mais importante do scope
  (`guards/assert-scope-lock.sh:1-15`) descreve em prosa "converte o 'O Que NÃO
  Será Feito' do markdown em verificação automatizada", mas **não nomeia o
  arquivo .md de origem**. A proveniência existe na cabeça de quem escreveu, não
  no artefato.
- [CONCLUSÃO] **Já existe UM caso que é quase o compilador**: o tripé
  `core/dispatch-spec.md` (fonte em prosa) → `schemas/dispatch.schema.json`
  (forma machine-consumível) → `G-DSP-INT`/`G-DSP-FMT` (enforcement bash). O
  próprio spec aponta: "O schema executável é `schemas/dispatch.schema.json`"
  (`core/dispatch-spec.md:31`). Isto é o embrião: parte da regra (a *forma* do
  front matter) **já não é escrita à mão duas vezes** — o schema é a fonte única
  da forma, consumida pelo guard. O que falta é (a) o spec apontar de volta para
  o schema de modo verificável, (b) cobrir também a *semântica* (não só a forma),
  e (c) o trailer de proveniência no guard.
- [CONCLUSÃO] A divergência maior já está nomeada no brainstorm: duas superfícies
  "useHBN" (governança bash/md × CLI Python) derivaram (`exuvia-evolucao-conceitual.md:93-94`).
  O compilador é a tese de como **estruturalmente** isso para de acontecer.

## 2. A forma mínima machine-consumível de um spec `.md`

- [PROPOSTA] **Não inventar linguagem nova.** O custo-zero é colocar no
  front-matter do spec `.md` um bloco `enforcement:` que lista, por **cláusula
  normativa**, o que a impressão (guard) precisa satisfazer. O corpo em prosa
  continua sendo a fonte para humanos; o bloco é a projeção verificável — exatamente
  a mesma relação que `dispatch.schema.json` tem com `core/dispatch-spec.md`
  (a descrição do schema diz isso: "Projection of the YAML front matter",
  `schemas/dispatch.schema.json:4`).
- [PROPOSTA] Forma mínima (rascunho, a auditar por ≠-família):

  ```yaml
  # front-matter de core/<nome>-spec.md
  id-global: 20260616-003203-codex-dispatch-spec   # já existe (:3 do dispatch-spec)
  enforcement:
    impresso_por:                # guards que "imprimem" este spec
      - guard: G-DSP-FMT
        arquivo: guards/validate-dispatch.sh
      - guard: G-DSP-INT
        arquivo: guards/assert-dispatch-integrity.sh
    schema: schemas/dispatch.schema.json   # quando a regra é de forma
    clausulas:
      - id: C-ZSH-SAFE
        prosa_ref: "core/dispatch-spec.md:47-52"
        regra: "corpo colável não contém linha iniciada por '#'"
        prova_positiva: fixtures/.../good-dispatch.md
        prova_negativa: fixtures/.../bad-hash-line.md
        caso_teste: "run-guard-tests.sh::dsp-fmt-comentario-zsh"
        burla_adversarial: B20
  ```
- [PROPOSTA] Três níveis de "machine-consumível", em ordem de viabilidade:
  1. **Cláusula com ids estáveis + ponteiros** (C-ZSH-SAFE → prosa:linha →
     guard → caso de teste → linha Bxx). É só metadado disciplinado. Viável já.
  2. **Schema declarativo** para a fração da regra que é forma/estrutura
     (JSON Schema, como `dispatch.schema.json`). Viável já onde a regra é
     forma — não cobre regra de comportamento ("se X então bloqueia").
  3. **Predicado executável** (a regra como expressão que um motor avalia). Isto
     é o gerador de código de verdade — **pesquisa de longo prazo** (§6).
- [CONCLUSÃO] A regra constitucional que justifica isto já existe: roles-spec §3
  proíbe segunda fonte de verdade — o brainstorm cita "O protocolo já proíbe
  segunda fonte de verdade (roles-spec §3); o compilador é o que elimina a
  sincronização manual" (`exuvia-evolucao-conceitual.md:116`). O bloco
  `enforcement:` **não** é segunda fonte: a prosa é a fonte, o bloco é a sua
  projeção verificável e ligada por ponteiro à própria prosa (`prosa_ref`).

## 3. O trailer de proveniência: o guard aponta para o `.md` que o originou

- [PROPOSTA] **Bidirecional e verificável.** Hoje o ponteiro, quando existe, é
  comentário humano em texto livre (§1). Proposta: padronizar um trailer no topo
  de cada guard, simétrico ao bloco `enforcement:` do spec:

  ```bash
  # HBN-Spec-Source: core/dispatch-spec.md#C-ZSH-SAFE
  # HBN-Spec-Id: 20260616-003203-codex-dispatch-spec
  # HBN-Clause: C-ZSH-SAFE
  ```
- [PROPOSTA] O par fecha por **id estável**, não por path frágil: o spec já
  carrega `id-global` no front-matter (`core/dispatch-spec.md:3`;
  `core/exuvia-fitness-criteria.md:7`). O trailer `HBN-Spec-Id` referencia esse
  id. Renomear o arquivo do spec não quebra o elo (o id sobrevive ao rename), o
  que casa com a lição já dura do G-REG: rename de artefato numerado sem nova
  linha é bloqueado (`guards/tests/run-guard-tests.sh:227-231`).
- [PROPOSTA] Isto materializa o que o próprio brainstorm pediu para as specs
  *promovidas*: "um *trailer de proveniência* na spec selada que aponte de volta
  para a(s) entrada(s) de brainstorm" (`exuvia-evolucao-conceitual.md:46`). Aqui
  é o mesmo trailer, um nível abaixo: do **guard** de volta para o **spec**. A
  cadeia completa de proveniência fica: brainstorm → spec (trailer p/ brainstorm)
  → guard (trailer p/ spec) → teste/Bxx (citados no spec). Rastreabilidade
  fim-a-fim, que é exatamente C-TRACE (`core/exuvia-fitness-criteria.md:85`).
- [PERGUNTA ABERTA] O trailer deve ser **bloqueante** (um guard-meta `G-PROV`
  que recusa commit de guard novo sem `HBN-Spec-Source` resolvível) ou só
  advisory na Fronteira até maturar? Pela própria doutrina anti-teatro do repo
  (advisory = teatro, `exuvia-evolucao-conceitual.md:127`), a resposta madura é
  bloqueante — mas só depois que a forma machine-consumível (§2) existir nos
  specs, senão `G-PROV` não tem alvo para resolver.

## 4. A verificação dupla — "impressão fiel" + "impressão intransponível na prática"

A metáfora do Maurício ("o código é o PDF impresso do documento") exige duas
provas distintas, que mapeiam exatamente nos critérios de exúvia já selados
(`core/exuvia-fitness-criteria.md:75-86`):

- [PROPOSTA] **(A) Impressão fiel — o guard implementa o que o spec diz.**
  Verifica que cada cláusula `enforcement.clausulas[*]` do spec tem:
  (1) um guard que a declara como origem via trailer (§3),
  (2) prova positiva E negativa na suíte → **C-TEST** ("caso positivo E
  negativo na suíte", `core/exuvia-fitness-criteria.md:79`),
  (3) o mecanismo aplicado a si mesmo → **C-DOG** ("o despacho que criou a regra
  de despacho foi o primeiro a passar pela regra", `:51`, `:82`).
  Fidelidade = "o que o documento diz aparece no PDF". É verificação de
  **cobertura**: nenhuma cláusula do spec sem guard que a imprima, nenhum guard
  sem cláusula que o origine.
- [PROPOSTA] **(B) Impressão intransponível na prática — a bateria adversarial
  prova o bloqueio.** Cada cláusula aponta uma linha `Bxx` em
  `guards/tests/adversarial-battery.sh` que tenta a burla e **deve** ser
  bloqueada → **C-ADV** ("burla adversarial documentada e bloqueada", `:80`),
  e o insumo ausente bloqueia → **C-FCLOSE** ("falta de insumo BLOQUEIA",
  `:83`). Intransponibilidade = "o PDF não pode ser adulterado sem detecção".
- [CONCLUSÃO] Truth Barrier sobre a palavra: o repo proíbe o absoluto
  "intransponível" (`exuvia-evolucao-conceitual.md:128`). A forma honesta é
  **"fail-closed + provado por bateria adversarial"** — exatamente C-FCLOSE +
  C-ADV. "Impressão intransponível na prática" = "toda burla conhecida (Bxx) está
  bloqueada e a ausência de insumo falha fechado", não "impossível em absoluto".
- [CONCLUSÃO] **C-DOG + C-ADV + C-FCLOSE = a verificação dupla operacionalizada.**
  Esta é a frase já no brainstorm — "C-DOG + C-ADV + C-FCLOSE = 'impressão fiel
  **e** intransponível na prática'" (`exuvia-evolucao-conceitual.md:117`). Este
  documento só decompõe: fidelidade ≈ {C-TEST, C-DOG, cobertura cláusula↔guard};
  intransponibilidade-na-prática ≈ {C-ADV, C-FCLOSE}; e C-NOREG garante que
  imprimir a regra nova não apaga uma antiga.

## 5. Como isso elimina a divergência das duas superfícies

- [CONCLUSÃO] A divergência nasce de **duas escritas-à-mão da mesma regra** (§1,
  `exuvia-evolucao-conceitual.md:116`). O par bloco-`enforcement:` ↔ trailer-de-
  proveniência transforma o que hoje é "duas cópias que derivam" em "**um elo
  verificado entre fonte e impressão**". A regra continua escrita uma vez (na
  prosa do spec); o guard deixa de ser uma *segunda redação* e passa a ser uma
  *impressão rastreável e auditada* da primeira.
- [PROPOSTA] **Um guard-meta fecha o ciclo sem gerar código** (curto prazo):
  `G-PROV`/`G-MIRROR` que, a cada commit, verifica:
  - toda cláusula `enforcement` de um spec tem guard com trailer resolvível
    (sem cláusula órfã);
  - todo guard governado tem `HBN-Spec-Source` que resolve a um `id-global`
    existente (sem guard órfão — o anti-padrão do §1, metade dos guards hoje);
  - cada cláusula cita caso de teste existente e linha Bxx existente (reusa o
    padrão F-08 "path citado em template/spec deve existir",
    `guards/tests/run-guard-tests.sh:33-34`).
  Isto **não gera** o guard; **detecta a deriva** no instante em que ela nasce.
  É o passo barato que mata a divergência sem esperar o gerador (§6).
- [CONCLUSÃO] Encaixa no gradiente de árvores (seção L do brainstorm,
  `exuvia-evolucao-conceitual.md:119-123`): Fronteira = `.md` sem enforcement
  (cláusula sem guard ainda); Intermediária = cláusula com guard + trailer +
  testes (impressão fiel e fail-closed verificada); o salto entre elas é
  literalmente "a cláusula ganhou sua impressão verificada". O compilador deixa
  de ser metáfora e vira o portão entre árvores.

## 6. Roadmap honesto

### Curto prazo — viável já (proveniência + verificação, sem gerar código)

- [PROPOSTA] **(C1) Trailer de proveniência** `HBN-Spec-Source`/`HBN-Spec-Id`
  nos guards. Custo: convenção textual + um campo. Reusa `id-global` que já
  existe. Pode ser adotado guard-a-guard, retroativamente.
- [PROPOSTA] **(C2) Bloco `enforcement:` nos specs** com cláusulas de id
  estável apontando prosa:linha, guard, caso de teste e Bxx. Custo: metadado.
  Começar pelo caso que já é quase-compilador (`dispatch-spec` + schema).
- [PROPOSTA] **(C3) Guard-meta `G-PROV`** que verifica o elo bidirecional e
  bloqueia órfãos (§5). Reusa máquina existente (padrão F-08; suíte
  positivo+negativo de `run-guard-tests.sh`). É verificação, não geração.
- [CONCLUSÃO] Nada em C1–C3 exige escrever um compilador. Tudo são metadados +
  um guard que confere ponteiros — a mesma natureza dos guards que já existem
  (G-SLF confere `path:` declarado == real, `run-guard-tests.sh:329-337`; aqui
  confere `HBN-Spec-Source` == spec existente).

### Médio prazo — pesquisa aplicada (schema cobre mais da regra)

- [PERGUNTA ABERTA] **(M1)** Quanto da regra é expressável como *forma*
  (JSON Schema, como `dispatch.schema.json`) vs quanto é *comportamento*
  ("se staged fora de scope → bloqueia", a lógica de `assert-scope-lock.sh`)?
  O schema cobre o primeiro hoje; o segundo precisa de uma linguagem de
  predicado que ainda não existe no repo. Mapear essa fronteira é uma onda de
  pesquisa, não de implementação.

### Longo prazo — pesquisa de fronteira (geração real de código)

- [PERGUNTA ABERTA] **(L1) Gerar o guard a partir do spec.** É o sentido forte
  de "compilador". Exige: (a) uma DSL de predicados que cubra também
  comportamento; (b) um backend por linguagem (bash hoje, Rust na Árvore
  Estável — P12, `methodology/PRINCIPIOS-CONSTITUCIONAIS.md:263-274`); (c)
  confiança de que o gerador não introduz a própria deriva. **NÃO é viável
  ainda** e não deve ser prometido como tal — colide com a Truth Barrier se
  comunicado como pronto.
- [CONCLUSÃO] **O que NÃO é viável agora**, declarado explicitamente: (i) gerar
  guards executáveis a partir de prosa livre; (ii) extrair regra de comportamento
  de `.md` sem uma DSL intermediária; (iii) reimprimir os guards bash em Rust
  automaticamente. Tudo isso é L1+ e deve morar na Fronteira até prova. O ganho
  estrutural real e imediato — matar a divergência das duas superfícies — vem de
  C1–C3 (verificação do elo), **não** da geração.
- [CONCLUSÃO] Lição que realimenta o `.md` (mão-dupla, `exuvia-evolucao-conceitual.md:115`):
  toda vez que uma burla nova (Bxx) é provada no código e bloqueada, a cláusula
  correspondente no spec ganha a linha `burla_adversarial: Bxx`. O código ensina
  o `.md`; o `.md` permanece a memória portável. Isto já acontece de fato — o
  cabeçalho de `run-guard-tests.sh:9` registra "os 3 bugs provados pela auditoria
  cruzada"; o compilador só torna esse fluxo um campo verificável em vez de prosa.

## 7. Riscos e honestidade de família

- [PERGUNTA ABERTA] O bloco `enforcement:` pode virar a **segunda fonte de
  verdade** que ele pretende matar, se divergir da prosa. Mitigação de design:
  o campo `prosa_ref` ancora cada cláusula numa faixa de linhas do próprio corpo,
  e G-PROV pode exigir que a faixa exista — mas "a cláusula descreve fielmente a
  prosa" é semântico e **não** verificável mecanicamente hoje. É um risco real,
  não resolvido por C1–C3. Precisa de auditoria humana + ≠-família.
- [CONCLUSÃO] Autor é família Anthropic, igual ao orquestrador (mesma limitação
  da seção N, `exuvia-evolucao-conceitual.md:130-133`). Tudo aqui é Fronteira,
  não-normativo, e precisa de auditoria adversarial ≠-família (Codex/Gemini/
  Cursor/Grok) antes de qualquer promoção a `core/` ou ADR. Esta é parte do
  desenho, não defeito.
