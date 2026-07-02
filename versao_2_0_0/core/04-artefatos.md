---
titulo: "04 — Artefatos: nomes, front-matter, REGISTRY, temperatura, árvores"
status: proposto
temperatura: quente
path: versao_2_0_0/core/04-artefatos.md
created_at: "2026-07-01T19:38:00-03:00"
autor: fable-5
familia: Anthropic
---

# 04 — Artefatos

Consolida: ADR-011, ADR-024, ADR-025, arvores-spec, pointer-spec, command-spec
e as convenções do REGISTRY do v0.3.x.

## Nome universal (incondicional — ADR-025 incorporado)

`AAAAMMDD-HHMMSS-<token>-<slug>.md|json` com hora REAL de -03:00 obtida por
`date +%Y%m%d-%H%M%S` (nunca de memória). Vale para messages, results,
handoffs e prompts. Readbacks usam `NNNN-<slug>.json` sequencial (próximo
número livre conferido no disco). Não existe mais regime "serial vs paralelo".

## Front-matter obrigatório

`titulo, tipo, status, temperatura, path (autolocalizado, relativo à raiz da
versão), created_at (ISO com -03:00), autor (token exato), familia`.
Campo `path` divergente do local real = violação (G-SLF). Referência a
arquivo inexistente = violação (G-PTR): confira com `ls` antes de citar.

## REGISTRY (livro-razão)

`REGISTRY.md` da versão, append-only: uma linha por evento (nascimento ou
mudança de temperatura), no MESMO commit do artefato (G-REG). Nunca rename,
nunca delete. Dado o livro, a ordem e a vigência de qualquer artefato se
resolvem sem abrir arquivo.

## Temperatura (ciclo de vida)

- `quente`: vigente — única versão que uma IA pode citar como regra.
- `frio`: histórico — consulta permitida, citação como regra proibida.
- `glaciar`: arquivo morto — fora de qualquer read-list; só o REGISTRY o vê.
Rebaixamento = nova linha no REGISTRY (+ `superseded_by` quando houver sucessor).
Duas versões `quentes` do mesmo assunto = bug de processo; rebaixe uma ANTES
de prosseguir (resolve a causa mecânica nº 1).

## Árvores (maturidade)

`fronteira` (nasce aqui) → `intermediaria` (sobreviveu a 1 ciclo auditado) →
`estavel` (selada; mudar exige onda tier alto). **Fonte única da árvore: o
REGISTRY** (decisão registry-centric do v0.3.x, preservada — o guard herdado
G-ARVORE-LABEL valida a coluna `arvore` de linhas novas do REGISTRY, não
front-matter). O rótulo `arvore:` no front-matter de `.hbn/results` e specs é
espelho informativo, sem autoridade; em divergência, vale o REGISTRY. Dívida
declarada: o formato de linha do REGISTRY v2 ainda não tem a coluna `arvore`
(MANIFESTO §PENDENTE, nata-3b); até fechá-la, promoção/despromoção de árvore
está VEDADA nesta versão.

## Zona livre

`docs/brainstorm/**` é zona livre: rascunho sem rito. NUNCA é selada pelo
orquestrador sem aprovação humana explícita (knowledge 0024). Conteúdo só vira
norma passando pelo rito da onda (R2).
