SOU: xAI · grok-build-0.1 · apelido: grok · papel auditor

# PARECER DE DESIGN — Eixo: Evolução de Estágios de Árvore (fronteira → intermediária → estável)

- **Auditor**: grok (família xAI)
- **Data**: 2026-06-17T23:30:00-03:00
- **Papel**: auditor de design (cross-audit ≠-família) — foco no eixo não coberto pelos 3 pareceres de numeração
- **Insumos lidos no disco (Truth Barrier)**:
  - `docs/brainstorm/rodada-2026-06-17/NUMERACAO-decisao-consolidada.md` (especialmente seção 6:67-109)
  - `core/arvores-spec.md` (promocao=append-only tipo=arvore-promocao; linha de nascimento nunca editada; gate reusa 8 critérios + cross-audit + humano; estavel=>quente)
  - `guards/assert-arvore-label.sh` (bloqueia intermediaria|estavel sem evento rastreavel de promocao; só olha linhas ADDED)
  - `AGENTS.md:51` (P6: "Toda evolução deve ser reversível")
  - `docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md:202-204` (despromoção é caminho válido e reversível)
  - `core/exuvia-fitness-criteria.md:75-97` (os 8 critérios C-TEST..C-DEBT)
  - Evidência de REGISTRY going-forward 7-colunas e linhas R2 com arvore=fronteira (ex.: REGISTRY.md:1068-1078)
  - Resultados prévios de arvores: `.hbn/results/20260617-192141-grok-cross-ia-arvores-0049.md`, `.hbn/results/20260617-192729-antigravity-cross-ia-arvores-0049.md`
- **Princípio em teste (confirmado no brief)**: estágio de árvore é **estado mutável**; o id é **identidade imutável**. Estágio NÃO entra no id (`cNN.wMM-slug` permanece estável).

---

## 1. Transparência e prova de teatro: eventos append-only no REGISTRY são suficientes?

**Resposta direta**: Sim, a evolução (promoção **e** despromoção) fica transparente e à prova de teatro **principalmente** pelos eventos append-only no REGISTRY, **sem** colocar o estágio corrente no id ou no manifesto do artefato.

### Evidência e raciocínio

- `core/arvores-spec.md:44-46`: "Promocao de arvore e sempre evento append-only no REGISTRY, com `tipo=arvore-promocao`. A linha original de nascimento nunca e editada em lugar para trocar a arvore."
- `guards/assert-arvore-label.sh:130-133`: "se arvore == intermediaria|estavel e tipo != arvore-promocao → bloqueia. Artefato nasce fronteira; intermediaria/estavel so por promocao append-only."
- `guards/assert-arvore-label.sh:7-10`: o guard só age sobre linhas **novas** (git diff +|); não confia em front-matter nem em estado mutável de arquivo individual.
- `NUMERACAO-decisao-consolidada.md:84-88`: "a evolução já é tratada — e de forma transparente — por mecanismo separado, não pelo id." "cada promoção é ela mesma um evento numerado, datado, cross-auditado — uma onda cNN.wMM com seu readback."

**Por que o id/manifesto NÃO deve expor o estágio corrente como parte da identidade**:
- Se o id virasse `c02.w03-foo@estavel`, promover para intermediária ou estável **quebraria todas as referências** que usavam o id anterior. Isso viola o princípio "identidade imutável" que os 3 pareceres de numeração já convergiram (E/B-mínimo separa identidade de verificação; aqui separamos identidade de maturidade).
- Colocar `arvore: estavel` no front-matter do artefato criaria **dual source of truth** (o arquivo diz uma coisa; o REGISTRY diz outra). O guard e a spec já rejeitaram isso explicitamente: "Nao existe front-matter `arvore:` em artefatos" (`core/arvores-spec.md:39`).

**Onde um ponteiro/índice "current stage" é aceitável**:
- Como **otimização derivável** (cache read-only), não como fonte. Ex.: uma seção em `.hbn/relay/STATE.md` ou um arquivo gerado `current-arvores.json` que é reconstruído a partir do REGISTRY no final de cada onda. Deve ser invalidável (se o REGISTRY mudar, o índice é suspeito até rebuild). Nunca pode ser editado manualmente sem passar pelo mesmo guard.

**Risco se depender só de índice sem log append-only**:
- Teatro fácil: alguém edita o índice para dizer que algo é estável sem nunca ter passado pelo Fitness Gate + cross-audit + humano. O append-only + guard + readback referenciado fecha isso.

**Conclusão Q1**: REGISTRY append-only (com tipo=transição + readback + onda) é a base da prova. Um índice resolvível de "estágio vigente" pode existir como conveniência, mas **deve ser derivável do log** e nunca autoridade primária. O id e o manifesto do artefato permanecem limpos do estágio.

---

## 2. Reconstruir a trajetória completa (incluindo despromoções/reversões — P6)

**Método barato e não-ambíguo**:

1. Filtrar o REGISTRY por `artefato (path)` (ou, após adoção da numeração E, pelo id estável `cNN.wMM-slug` dentro do namespace).
2. Ordenar as linhas pelo `id` (ou `created_at`) — o REGISTRY é append-only e o id da onda é monotônico.
3. A sequência de valores da coluna `arvore` é a trajetória:
   - Nascimento: linha com `tipo` normal + `arvore=fronteira` (default honesto).
   - Promoção: linha com `tipo=arvore-promocao` + `arvore=intermediaria|estavel` + referência a `.hbn/readbacks/NNNN-*.json`.
   - Despromoção/reversão: linha com `tipo=arvore-transicao` (ou `arvore-promocao` reaproveitado semanticamente) + `arvore` menor + readback de justificativa (ex.: regressão detectada, C-NOREG falhou em uso real, hearback humano).

Exemplo de trajetória reconstruída (ilustrativo, com a numeração futura):

```
artefato: core/relay-spec.md
  c01.w01-relay-spec          | nascimento     | fronteira     | readback inicial
  c03.w02-relay-promotion     | arvore-transicao | intermediaria | readback 0031 + cross-audit antigravity/grok
  c05.w01-relay-stable        | arvore-transicao | estavel       | readback 0049 + 8 critérios + humano + quente
  c07.w04-relay-regression    | arvore-transicao | intermediaria | readback 0055 + "regressão em guard X sob load real"
```

**Custo**: O(N) scan do REGISTRY por path. REGISTRY é ledger humano-escala (centenas de linhas, não milhões). Barato o suficiente. Para queries frequentes, o índice derivado (reconstruído deterministicamente) resolve.

**Não-ambiguidade**:
- A linha mais recente para um dado path/artefato é o estado corrente (mesma lógica de `superseded_by`).
- Despromoções aparecem explicitamente como novas linhas (nunca edição in-place).
- Cada transição não-fronteira carrega referência ao readback versionado → auditável.
- Âncora na onda: quando a numeração E for adotada, o próprio `id` da linha de transição (ex.: `c07.w04-relay-regression`) é a coordenada `cNN.wMM` da promoção/despromoção.

**P6 (reversibilidade)**: `AGENTS.md:51` e `A2-arvores-portao-promocao.md:202` confirmam que despromoção é permitida. O mecanismo atual (append-only) já suporta; o guard atual tem viés de nome ("promocao"), mas a lógica só força o tipo para subir de fronteira. Recomendação: renomear o tipo para `arvore-transicao` ou documentar que "promocao" é o nome do evento de *mudança de árvore* (up ou down), sempre com readback.

**Risco de reconstrução frágil**:
- Se alguém reescrever histórico git (force-push) → quebra a prova. Mitigação: proteção de branch + tags + espelhamento (já em prática no ecossistema).
- Paths renomeados: mas ADR-011 e regras proíbem rename de artefatos normativos.

---

## 3. Atravessar exúvia (g1 → g2): re-provar ou herdar com evidência?

**Recomendação forte**: o estágio **NÃO herda automaticamente**. Deve ser **re-provado** pelo Fitness Gate + 8 critérios no genoma novo. Evidência do estágio anterior pode (e deve) ser citada como material de suporte na nova transição, mas não substitui a re-prova.

### Evidência no disco

- `NUMERACAO-decisao-consolidada.md:96-99`: "Ao atravessar exúvias: o estágio NÃO migra automático no molt. O que sobrevive re-prova pelo Fitness Gate + 8 critérios (anti-teatro): um artefato estavel em g1 precisa reconquistar o estágio em g2 (ou migrar com evidência). Só a bateria adversarial (CRISPR) atravessa integralmente."
- `core/exuvia-fitness-criteria.md:90-91`: "Um mecanismo SOBREVIVE ao molt se e somente se C-TEST a C-TRACE = SIM ..."

### Riscos de cada opção

**Opção A — Herdar com evidência (sem re-gate)**:
- Risco alto de **teatro de maturidade**: um artefato ganhou `estavel` em g1 sob um conjunto de adversários, enforcement surface, e pressupostos de linguagem/ambiente. Em g2 a superfície muda (ex.: Rust rewrite, nova dispatch, novos guards). A "prova" antiga não é mais válida.
- Violação de anti-teatro e P10 (segurança > velocidade).
- Custo inicial baixo, dívida explosiva depois (quando a "estável" herdada quebra em produção real no genoma novo).
- Exceção justificada: a **memória imunológica CRISPR completa** (bateria adversarial inteira + racional de cada guard) pode carregar "crédito de desconfiança zero" para aquele mecanismo específico — mas ainda assim a re-execução da bateria no novo contexto é desejável.

**Opção B — Re-provar sempre (Fitness Gate + 8 critérios + cross-audit ≠-família + humano)**:
- Custo: repetição de trabalho de auditoria/cross-audit por molt.
- Benefício: prova fresca, sob as regras e adversários do genoma atual. Mantém o "anti-teatro" vivo.
- Mitigação de custo: (a) só mecanismos que *sobrevivem* ao molt entram na discussão de estágio; (b) a cadeia de eventos de g1 pode ser anexada como anexo ao novo readback de transição em g2 (reduz justificativa de zero para "já provado em g1 + delta de g2"); (c) para artefatos que só mudaram de forma trivial (ex.: renome de variável sem alterar semântica), o gate pode ter um caminho "fast-track com evidência de equivalência" — mas ainda exige marcação explícita e aprovação humana.

**Risco de herdar "só o que passou CRISPR"**:
- A bateria adversarial é forte, mas não é o universo completo de ameaças futuras. Um mecanismo pode passar todos os Bxx conhecidos em g1 e ainda ser explorado por um ataque novo em g2. Re-prova (mesmo que leve) continua necessária.

**Conclusão Q3**: Re-prova obrigatória para o rótulo de árvore. Herança de *evidência* (a trilha de transições anteriores) é bem-vinda e barata (basta citar os ids das ondas/passagens anteriores no novo readback). Herança de *rótulo* sem re-prova = dívida de prova.

---

## 4. Over-engineering: o que um dev autônomo recusaria? Subconjunto mínimo

Um dev autônomo (ou IA autônoma) trabalhando em seu próprio repositório, sem time de plataforma, recusaria:

- Ter que manter manualmente "current stage" em múltiplos lugares (front-matter + índice + manifesto).
- Ver o estágio dentro do id (quebra referências em toda promoção).
- Um "compilador de maturidade" ou parser que transforma o markdown em runtime dependendo de árvore.
- Exigir reverse-DNS próprio ou registro central só para poder rotular algo como intermediária.
- Ter que rodar um gate pesado de 8 critérios + cross-audit de 3 famílias para **toda** promoção, inclusive as internas de um único dev (o gate deve escalar: para uso solo, "humano decide" + dogfood local pode bastar; para federação normativa, o full gate é obrigatório).

### Subconjunto mínimo que ainda entrega o eixo (P11)

1. **REGISTRY append-only como única fonte de verdade** do estágio e da história (7 colunas: ... | arvore | ...). `core/arvores-spec.md:31-37`.
2. **Guard mínimo (G-ARVORE-LABEL)**: bloqueia nascimento ou salto para intermediaria|estavel sem linha de transição rastreável (tipo + readback ref). `guards/assert-arvore-label.sh:130-140`. (Pode ser relaxado localmente via bypass documentado para devs autônomos.)
3. **Transições são eventos numerados**: cada promoção/despromoção é uma linha no REGISTRY, preferencialmente ancorada numa onda `cNN.wMM` (quando a numeração E for adotada). Isso torna a trajetória legível sem ferramenta extra.
4. **Invariante estavel => quente** (barato de checar).
5. **Na exúvia**: re-prova via Fitness Gate + 8 critérios para sobrevivência; estágio não migra. Evidência de g1 é citável, não herdável como rótulo.
6. **P6 explícito**: despromoção é permitida por append de nova linha de transição + justificativa (readback ou nota humana). Não se apaga o passado.

**O que pode ficar de fora (over-engineering)**:
- Campo `arvore:` no front-matter de artefatos.
- Parser/compilador/ partição física por árvore.
- Índice obrigatório de "current stage" mantido à mão.
- Exigir cross-audit ≠-família para toda transição interna de um único adotante (só para artefatos que serão consumidos por terceiros ou entrarem no núcleo estável federado).
- Qualquer coisa que faça o id carregar o estágio.

Este mínimo já fecha o teatro para consumo federado (o consumidor olha o REGISTRY + readback + onda, não o arquivo), preserva P11, e compõe com a numeração E (cada transição vira uma onda endereçável).

---

## Veredito (sem absolutos)

- O design registry-centric atual (append-only + guard que só confia em evento rastreável) **está correto** para o princípio "estágio mutável, id imutável".
- A pergunta da seção 6 da consolidação é respondida: **eventos append-only no REGISTRY são suficientes para transparência e prova de teatro**; índice/ponteiro de estágio corrente só como derivado.
- A reconstrução de trajetória é barata via scan do ledger + âncora em ondas cNN.wMM.
- Exúvia exige re-prova (anti-teatro); evidência pode viajar, rótulo não.
- O subconjunto mínimo acima é o que um dev autônomo aceitaria sem sentir "cerimônia desproporcional".

Tudo citado com arquivo:linha ou seção. Nada aqui é "confie em mim".

— grok (xAI), papel auditor, 2026-06-17
