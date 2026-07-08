# Evolução de estágios de árvore — consolidação ≠-família (para o orquestrador decidir)

> NÃO-NORMATIVO (zona livre, untracked). Organizado pela esteira de Fronteira (Claude Opus
> 4.8, Anthropic) para o ORQUESTRADOR ler, ponderar e decidir o que entra; o Codex
> implementa depois, sob o rito. Nada aqui é despacho nem decisão. Pareceres no disco:
> `.hbn/results/20260617-232525-antigravity-estagio-arvore.md`,
> `…-232608-codex-arvore-estagio-arvore.md`, `…-233000-grok-estagio-arvore.md`.

## 1. Convergência das 3 famílias (unânime)

- O estágio de árvore **fica fora do id** (identidade imutável × maturidade mutável). Pôr o
  estágio no id quebraria referências a cada promoção. O esquema E está correto nisto.
- **Sem `arvore:` no front-matter** do artefato (dual source of truth). Fonte única = a
  coluna `arvore` no REGISTRY.
- **Eventos append-only no REGISTRY são suficientes** para transparência e prova de teatro.
- Um **índice de "estágio corrente"** é aceitável só como **cache derivado e regenerável**
  do REGISTRY; se divergir, o REGISTRY vence. Nunca é fonte autoritativa.
- **Trajetória** = scan O(N) do REGISTRY por path/id, ordenado pela sequência de eventos;
  o último evento válido é o estágio corrente.
- **Atravessar exúvia: o estágio NÃO herda automaticamente.** Evidência de g1 pode viajar
  (citada no novo readback); o rótulo precisa ser re-provado. CRISPR migra integral.

## 2. Pontos de atenção e melhoria — POR IA

### Antigravity (Google/Gemini)
- **Atenção — "teatro de omissão":** um artefato promovido a `estavel` pode ter os bytes
  alterados depois sem novo ciclo de teste; passaria como estável sem os novos bytes
  auditados. Sugere detectar mutação pós-promoção.
- **Melhoria:** cache de estado compilado (JSON ou em `.hbn/relay/STATE.md`) para consulta
  barata — sempre derivado, nunca editável à mão (guard intercepta).
- **Melhoria — exúvia híbrida por impacto:** re-prova obrigatória se o artefato **ou** seus
  guards mudaram; herança automática só se intocado **e** passar a suíte CRISPR em g2.
- **Atenção — over-engineering a cortar:** exigir reescrita em **Rust** para `estavel` gera
  fricção injustificada; `estavel` deve significar maturidade lógica/temporal (ex.: 30 dias
  sem regressão), não acoplamento a linguagem. Também: cross-audit humano para alterações
  triviais; ausência de indicador visual local.
- **Mínimo:** coluna no REGISTRY + rótulo visual **não-normativo** em comentário
  (`# hbn-arvore:`) validado contra o REGISTRY; promoção-por-impacto (código sobe a
  intermediária se a suíte passa; só specs-core/políticas exigem rito manual para `estavel`).

### Codex (OpenAI)
- **LACUNA REAL — despromoção/reversão não está normatizada:** o guard/spec só cobre
  promoção. Propõe evento mínimo `tipo=arvore-despromocao` (campos: `arvore` alvo,
  `readback`, `de=<estágio anterior>`, `motivo=regressao|superseded|exuvia|reversao`,
  `reverte_evento=<id>`), também append-only; nunca apaga/edita a promoção anterior. P6
  (reversibilidade) é só uma transição nova que cita o evento revertido.
- **Melhoria — regra de resolução determinística:** estágio corrente = último evento válido;
  ordenação pela ordem física das linhas (`created_at` é evidência humana, não desempate
  normativo). Resolver via `hbn arvore resolve <artefato>` ou `.hbn/index/arvores-current.*`
  regenerável.
- **Melhoria — exúvia com re-prova proporcional:** gate completo se bytes/contrato/deps
  mudaram; evento `arvore-revalidacao` citando a promoção g1 + checks g2 se carregou
  quase-igual; rótulo não migra por osmose.
- **Mínimo:** despromoção **não** exige o mesmo rito pesado da promoção (reduz claim, não
  aumenta) — mas deve ser rastreável.

### Grok (xAI)
- **Atenção — viés de nome do guard:** o evento se chama `promocao` mas a lógica cobre só
  subir de fronteira. Sugere renomear para `arvore-transicao` (cobre up **e** down) ou
  documentar que "promocao" é o evento de mudança de árvore em qualquer direção, sempre com
  readback. (Mesma lacuna de despromoção que o Codex, vista pelo ângulo do nome.)
- **Melhoria — o gate deve ESCALAR:** para dev/IA autônomo solo, "humano decide + dogfood
  local" pode bastar; cross-audit ≠-família de 3 famílias só é obrigatório para artefatos
  consumidos por terceiros ou que entram no núcleo estável federado. Exigir o gate cheio
  para toda transição interna fere P11.
- **Atenção — fragilidade a force-push:** reescrita de histórico git quebra a prova da
  trajetória; mitigar com branch protection + tags + espelhamento.
- **Mínimo:** REGISTRY append-only + guard mínimo (relaxável localmente via bypass
  documentado para solo) + transições ancoradas em ondas `cNN.wMM` + invariante
  `estavel⇒quente`.

## 3. Pontos de DECISÃO para o orquestrador (onde há divergência ou escolha)

1. **Re-prova na exúvia — estrita vs proporcional.** Grok recomenda re-prova do rótulo
   sempre (evidência viaja, rótulo não). Codex e Antigravity propõem proporcional/híbrido
   (re-prova só se mudou; `arvore-revalidacao` se intocado + CRISPR passa). Decisão do
   orquestrador: qual política adotar (e se cria o evento `arvore-revalidacao`).
2. **Critério de `estavel` — exige Rust?** Antigravity recomenda **remover** o acoplamento a
   Rust (que A2 propunha) e definir `estavel` por maturidade lógica/temporal. Conflita com a
   proposta anterior. Decisão do orquestrador.
3. **Escalonamento do gate (solo vs federado).** Grok propõe gate leve para adotante solo e
   gate cheio só para o núcleo federado/normativo. Decisão: o useHBN aceita um modo "solo"
   com rito reduzido?
4. **Nome do evento:** manter `arvore-promocao` (e adicionar `arvore-despromocao`) ou unificar
   em `arvore-transicao`. Decisão de redação.

## 4. Lacunas concretas a fechar (consenso — candidatas a onda do Codex, se o orquestrador aprovar)

- **Despromoção/reversão append-only** (Codex+Grok): o guard/spec só cobre promoção hoje.
- **Anti-"teatro de omissão"** (Antigravity): detectar/bloquear mutação de bytes de um
  artefato `estavel` sem novo evento/ciclo.
- **Índice derivado de estágio corrente** (todos): cache regenerável, REGISTRY-autoritativo.
- **Política de exúvia para o rótulo** (decisão 1 acima) precisa virar regra explícita.

## 5. Subconjunto mínimo consolidado (P11)

REGISTRY append-only como fonte única (coluna `arvore`); nascimento = `fronteira`;
transição (up/down) = evento append-only rastreável com readback; estágio corrente = último
evento válido (índice derivado opcional); `estavel⇒quente`; exúvia re-prova o rótulo
(evidência viaja, não o rótulo); estágio nunca no id nem em front-matter.

## 6. Encaminhamento

Os dois eixos da numeração estão agora validados ≠-família: **identidade** (esquema E,
unânime) e **maturidade/árvore** (este documento). Ambos são insumo para a onda de design da
EXÚVIA. Recomendo que o orquestrador: (a) decida os 4 pontos da seção 3; (b) avalie as 4
lacunas da seção 4 como candidatas a ondas do Codex (despromoção é a mais urgente, por ser
P6 e estar sem cobertura); (c) leve a numeração inteira (E + árvore) para a Fase E (design da
Exúvia), com `files_allowed` aprovada, cross-audit e hearback do Maurício. Nada normativo até lá.
