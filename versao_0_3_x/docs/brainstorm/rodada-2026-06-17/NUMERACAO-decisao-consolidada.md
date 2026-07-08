# Numeração federada do useHBN — decisão consolidada (PASSO 4)

> NÃO-NORMATIVO (zona livre, untracked). Consolidação do chat paralelo de Fronteira
> (Claude Opus 4.8, Anthropic) a partir dos 3 pareceres ≠-família no disco. A numeração
> só nasce na onda de design da EXÚVIA, com aprovação humana + cross-audit. Não bloqueia
> o freeze. Truth Barrier: pareceres e mecanismos citados por arquivo.

## 1. Convergência das 3 famílias

Pareceres lidos no disco:
- `.hbn/results/20260617-225428-antigravity-design-numeracao.md` — Google/Gemini.
- `.hbn/results/20260617-225544-codex-eixo-design-numeracao.md` — OpenAI/GPT-5 Codex.
- `.hbn/results/20260617-225600-grok-design-numeracao.md` — xAI/Grok.

**Unânime: candidato E (B-mínimo).** Os três avaliaram A/B/C/D **e** o E, e os três
atacaram o E (separar identidade de verificação). Conclusão convergente: a perda de
"auto-verificabilidade standalone" do E (vs C) é real mas **aceitável**, porque o useHBN é
git-native por decisão arquitetural — o SHA do git já dá content-addressing de graça, e
embutir hash em todo id (C) viola P11. Nenhuma divergência de fundo entre as famílias.

## 2. Esquema recomendado e forma EXATA do id

Três eixos ortogonais, cada um com a ferramenta mais leve:
- **Identidade do adotante (namespace):** URL canônica do repo git (`github.com/org/sys`)
  ou reverse-DNS (`com.org.sys`) para quem tem domínio. Declarado **uma vez** no manifesto;
  implícito localmente; explícito só ao cruzar fronteira.
- **Sequência interna:** `[gN.]cNN.wMM-slug` — `gN` genoma (implícito `g1` até a 1ª
  exúvia), `cNN` ciclo, `wMM` onda, `slug` humano.
- **Verificação de bytes:** SHA do git num pin **opcional**, nunca no id principal.

Formas exatas (convergentes entre os 3 pareceres):
- **Single-system (90% dos casos):** `c02.w03-auth-screen`
- **Cross-system:** `github.com/usehbn/credenciamento:g1.c02.w03-auth-screen`
- **Pin de integridade (auditoria/CI):** `github.com/usehbn/credenciamento@<sha>:g1.c02.w03-auth-screen`
- **Commons compartilhado:** `github.com/usehbn/commons:k-0027-trailers`

Parser mínimo (do parecer Grok): `^c[0-9]{2}\.w[0-9]{2}-` (local); `^[^:]+:.*c[0-9]{2}\.w` (cross); `@[0-9a-f]+:` opcional (pin).

## 3. Estratégia de colisão SEM autoridade central

Estrutural, em 3 camadas: (a) **entre adotantes** — carona no DNS / host de git (autoridade
delegada e externa ao protocolo; nenhum registro central do useHBN precisa existir); (b)
**dentro do adotante** — sequência monotônica `cNN.wMM` + composição com `ADR-025`
(`AAAAMMDD-HHMMSS-<agente>-<slug>`) para eventos de alta frequência; (c) **integridade** —
SHA do git. Codex acrescenta (bem): registrar no manifesto `namespace_since` +
`namespace_evidence` (commit/tag inicial) torna auditável *quando* o sistema passou a usar
o nome — sem criar registro central.

## 4. Versionamento de exúvias (genoma)

`gN` é **local ao namespace** (o `g2` de um adotante ≠ `g2` de outro; o namespace
desambigua). Cada exúvia incrementa `gN`; o genoma anterior fica read-only (tag anti-GC +
`forbidden-paths`); ids legados não se reescrevem; referência cross-exúvia usa `gN`
explícito (`g1.c03.w02-foo` dentro de um repo em `g2`). Rastreabilidade = doc de transição
parseável (deriva, data, commits, regras de congelamento) — o id carrega só a coordenada,
não mais dados.

## 5. Subconjunto mínimo (P11) e over-engineering

**Mínimo que serve 90%:** `cNN.wMM-slug`. Namespace = repo (implícito); genoma = `g1`
implícito; verificação = SHA do git quando precisar.

**Over-engineering a podar (unânime):** ULID/hash em todo id (C); namespace repetido em
cada id local; `gN` obrigatório antes da 1ª exúvia; domínio próprio obrigatório; qualquer
registro central de namespaces.

## 6. EVOLUÇÃO DOS ESTÁGIOS DAS ÁRVORES — o eixo que os pareceres NÃO cobriram

Verificação solicitada pelo Maurício. **Achado honesto:** os 3 pareceres de numeração
**não trataram** a evolução fronteira→intermediaria→estavel — o brief não perguntou (as 6
perguntas eram namespace/genoma/federação/migração/leveza). As únicas menções a "árvore"
nos pareceres são à *árvore de commits do git*, eixo diferente. Logo, **isto não está
validado ≠-família ainda.**

Análise (com evidência no disco, `core/arvores-spec.md` + `guards/assert-arvore-label.sh`):

- **O estágio de árvore é um 4º eixo — maturidade/prova — e NÃO pode entrar no id.**
  Princípio decisivo: o estágio é **estado MUTÁVEL** de um artefato (ele é promovido ao
  longo do tempo); o id é **identidade IMUTÁVEL**. Se `arvore` fosse parte do id, promover
  `fronteira→intermediaria` **mudaria o id** e quebraria toda referência. É a mesma lição
  de "identidade ≠ verificação", aplicada de novo: identidade ≠ maturidade. O esquema E,
  ao manter o estágio FORA do id (`c02.w03-slug` é estável para sempre), está **correto**.
- **A evolução já é tratada — e de forma transparente — por mecanismo separado, não pelo
  id.** `core/arvores-spec.md:42-49`: promoção é **evento append-only no REGISTRY**
  (`tipo=arvore-promocao`) que referencia o readback autorizador; a linha de nascimento
  nunca é editada; o gate reusa os 8 critérios + cross-audit ≠-família + aprovação humana
  (`:61-62`); `estavel⇒quente`. `guards/assert-arvore-label.sh:7-10,130-131`: nascer
  `intermediaria|estavel` sem evento de promoção rastreável **BLOQUEIA**.
- **Como a numeração torna a evolução transparente (composição correta):** cada promoção é
  ela mesma um **evento numerado, datado, cross-auditado** — uma onda `cNN.wMM` com seu
  readback. Então a história de um artefato lê-se como sequência: "nasceu `fronteira` em
  `c02.w03`; promovido a `intermediaria` em `c05.w01` (readback X, parecer ≠-família);
  promovido a `estavel` em `g2.c01.w02`". O id estável do artefato + a cadeia de eventos
  `arvore-promocao` (cada um ancorado numa onda da numeração) = trilha de evolução
  reconstruível e auditável. **Os dois mecanismos se compõem; não competem.**
- **Atravessar exúvias:** o estágio **NÃO** migra automático no molt. O que sobrevive
  re-prova pelo Fitness Gate + 8 critérios (anti-teatro): um artefato `estavel` em `g1`
  precisa **reconquistar** o estágio em `g2` (ou migrar com evidência). Só a bateria
  adversarial (CRISPR) atravessa integralmente. Isto deve ficar explícito no design.

**Recomendação sobre este eixo:** (1) manter o estágio de árvore FORA do id (confirmado
correto); (2) exigir que todo evento `arvore-promocao` cite o **id da onda** (`cNN.wMM`) e o
**id estável do artefato**, para a evolução ser legível na própria numeração; (3) **rodar
uma validação ≠-família dirigida a este eixo** antes de selar a numeração na Exúvia — os 3
pareceres atuais não o cobriram, então tratá-lo como decidido seria furar a própria regra
de cross-audit. Pergunta para essa validação: "a evolução de estágio (promoção/despromoção)
fica transparente e à prova de teatro apenas com eventos append-only no REGISTRY, ou o id/
manifesto precisa expor o estágio corrente de forma resolvível?"

## 7. Veredito e ressalvas (sem absolutos)

- **Adotar E (B-mínimo)** como base da numeração da Exúvia — convergência ≠-família forte.
- **Estágio de árvore permanece eixo separado** (REGISTRY append-only), fora do id — e
  precisa de uma validação ≠-família própria (lacuna de escopo, não erro).
- **Risco residual do E** (apontado pelos 3): id lógico não prova bytes; exige disciplina de
  "quando o pin `@sha` é obrigatório" (importação federada normativa, parecer-evidência,
  mirror offline). Codex propõe tornar o pin obrigatório **por situação**, não por forma —
  adotar essa regra fecha o risco.
- **Nada normativo aqui.** A numeração nasce na onda de design da Exúvia, com `files_allowed`
  aprovada, cross-audit e hearback do Maurício. Este documento é insumo.
