# Numeração do useHBN — dossiê de entrada para a onda de design da Exúvia

> NÃO-NORMATIVO (zona livre, untracked). Preparado pela esteira de Fronteira (Claude Opus
> 4.8, Anthropic) para o ORQUESTRADOR ler, ponderar e decidir o escopo. Não é despacho nem
> decisão: é o insumo pronto para o orquestrador abrir a onda de design (Fase E). O Codex
> implementa depois, sob o rito (readback → cross-audit ≠-família → hearback do Maurício →
> selagem). A numeração **nasce na Exúvia** e **não bloqueia o freeze**.

## 0. Em uma frase

Dois eixos foram validados por 3 famílias distintas (Google, OpenAI, xAI): **identidade**
(esquema E / B-mínimo) e **maturidade/árvore** (registry-centric, append-only). Restam **4
decisões** do orquestrador e **4 lacunas** concretas para virar ondas — a numeração entra
no design da Exúvia já com a base validada.

## 1. Estado de validação (evidência no disco)

Eixo IDENTIDADE — pareceres ≠-família (unânime: candidato E):
- `.hbn/results/20260617-225428-antigravity-design-numeracao.md` (Google)
- `.hbn/results/20260617-225544-codex-eixo-design-numeracao.md` (OpenAI)
- `.hbn/results/20260617-225600-grok-design-numeracao.md` (xAI)
- Consolidação: `docs/brainstorm/rodada-2026-06-17/NUMERACAO-decisao-consolidada.md`

Eixo MATURIDADE/ÁRVORE — pareceres ≠-família (unânime: registry-centric append-only):
- `.hbn/results/20260617-232525-antigravity-estagio-arvore.md` (Google)
- `.hbn/results/20260617-232608-codex-arvore-estagio-arvore.md` (OpenAI)
- `.hbn/results/20260617-233000-grok-estagio-arvore.md` (xAI)
- Consolidação: `docs/brainstorm/rodada-2026-06-17/NUMERACAO-estagio-arvore-consolidada.md`

Brief e análise de origem: `NUMERACAO-design-brief-e-validacao.md`,
`NUMERACAO-analise-fronteira-opus.md`. Mecanismo de árvore já no disco: `core/arvores-spec.md`,
`guards/assert-arvore-label.sh`.

## 2. Eixo identidade — recomendação (esquema E / B-mínimo)

Três sub-eixos ortogonais, cada um com a ferramenta mais leve:
- **Namespace (quem):** URL canônica do repo git (`github.com/org/sys`) ou reverse-DNS;
  declarado uma vez no manifesto; implícito local, explícito ao cruzar fronteira.
- **Sequência (onde no fio):** `[gN.]cNN.wMM-slug` — `gN` genoma (implícito `g1` até a 1ª
  exúvia), `cNN` ciclo, `wMM` onda, `slug` humano.
- **Verificação (quais bytes):** SHA do git num **pin opcional**, nunca no id.

Formas exatas:
- Local (90% dos casos): `c02.w03-auth-screen`
- Cross-system: `github.com/usehbn/credenciamento:g1.c02.w03-auth-screen`
- Pin: `github.com/usehbn/credenciamento@<sha>:g1.c02.w03-auth-screen`
- Commons: `github.com/usehbn/commons:k-0027-trailers`

Colisão sem autoridade central: carona no DNS / host de git (autoridade delegada, externa ao
protocolo). Genoma `gN` é **local ao namespace**; exúvia incrementa; legado read-only; ids
nunca renomeados.

## 3. Eixo maturidade/árvore — recomendação (registry-centric)

- Estágio (`fronteira`/`intermediaria`/`estavel`) **fora do id e fora do front-matter**
  (identidade imutável × maturidade mutável; dual-source proibido).
- Fonte única = coluna `arvore` no REGISTRY; transição = evento append-only com readback;
  estágio corrente = último evento válido; índice derivado opcional (REGISTRY vence).
- Trajetória reconstruída por scan O(N) do ledger, ancorada em ondas `cNN.wMM`.
- Exúvia: estágio **não herda** automaticamente; evidência viaja, rótulo re-prova; CRISPR
  migra integral. `estavel⇒quente`.

## 4. DECISÕES pendentes (do orquestrador — não foram tomadas aqui)

1. **Re-prova na exúvia: estrita ou proporcional?** Grok = re-provar o rótulo sempre;
   Codex/Antigravity = proporcional (re-prova se mudou; `arvore-revalidacao` se intocado +
   CRISPR passa). Define se cria o evento `arvore-revalidacao`.
2. **`estavel` exige Rust?** Antigravity recomenda **remover** o acoplamento a Rust (que A2
   propunha) e definir `estavel` por maturidade lógica/temporal. Conflito a resolver.
3. **Gate escala para modo "solo"?** Grok propõe rito leve para adotante solo e cross-audit
   ≠-família de 3 famílias só para o núcleo federado/normativo (P11). Aceitar ou não.
4. **Nome do evento:** manter `arvore-promocao` + adicionar `arvore-despromocao`, ou unificar
   em `arvore-transicao` (up/down). Decisão de redação.
5. **(Identidade) Pin `@sha` obrigatório por situação:** Codex propõe torná-lo obrigatório só
   em importação federada normativa, parecer-evidência e mirror offline. Confirmar a regra.

## 5. LACUNAS concretas (candidatas a ondas do Codex, se o orquestrador aprovar)

- **Despromoção/reversão append-only (P6) — URGENTE:** o guard/spec só cobre promoção hoje
  (`assert-arvore-label.sh`). Sem cobertura para descer de estágio de forma rastreável.
  Codex propõe `tipo=arvore-despromocao` (motivo + `reverte_evento`), também append-only.
- **Anti-"teatro de omissão":** detectar/bloquear mutação de bytes de artefato `estavel` sem
  novo evento/ciclo (Antigravity).
- **Índice derivado de estágio corrente:** cache regenerável, REGISTRY-autoritativo (todos).
- **Política de exúvia do rótulo:** virar regra explícita após a decisão 1.

## 6. Subconjunto mínimo consolidado (P11)

Identidade: `cNN.wMM-slug` (namespace e genoma implícitos; pin só quando precisa).
Maturidade: REGISTRY append-only como fonte única; nascimento `fronteira`; transição (up/down)
= evento rastreável com readback; estágio corrente = último evento; `estavel⇒quente`; estágio
nunca no id/front-matter. Tudo o mais é opt-in, aparece ao cruzar fronteira ou em auditoria.

## 7. Encaminhamento ao orquestrador

1. Decidir os 5 pontos da seção 4.
2. Avaliar as 4 lacunas da seção 5 como candidatas a ondas do Codex (a **despromoção** é a
   mais urgente, por ser P6 e estar sem cobertura — pode até preceder o design completo da
   numeração, pois corrige um gap do mecanismo de árvore já selado).
3. Levar a numeração inteira (identidade E + maturidade) para a Fase E (design da Exúvia),
   com `files_allowed` aprovada, cross-audit e hearback do Maurício.
4. Lembrete de cadência: isto **não bloqueia o freeze** (Fase B); é insumo durável para a
   Fase E. Nada normativo até a onda de design selar, com aprovação humana.
