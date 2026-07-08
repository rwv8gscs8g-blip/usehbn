---
titulo: "04 — Artefatos: nomes, front-matter, REGISTRY, temperatura, árvores"
tipo: spec
status: ativo
temperatura: quente
path: core/04-artefatos.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: versao_2_0_0
id_original: core/04-artefatos.md
created_at_original: "2026-07-01T19:38:00-03:00"
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
---
# 04 — Artefatos

Consolida nesta exúvia: ADR-011, ADR-024, ADR-025, arvores-spec,
pointer-spec, command-spec e as convenções de livro-razão transcritas no
`REGISTRY.md` desta versão.

## Nome universal (incondicional — ADR-025 incorporado)

`AAAAMMDD-HHMMSS-<token>-<slug>.md|json` com hora REAL de -03:00 obtida por
`date +%Y%m%d-%H%M%S` (nunca de memória). Vale para messages, results,
handoffs e prompts. Readbacks usam `NNNN-<slug>.json` sequencial (próximo
número livre conferido no disco). Não existe mais regime "serial vs paralelo".

## Front-matter obrigatório

`titulo, tipo, status, temperatura, path (autolocalizado, relativo à raiz da
versão), created_at (ISO com -03:00), autor (token exato), familia, natureza`.
`natureza` aceita só `nativo` ou `migrado`. Campo `path` divergente do local
real = violação (G-SLF). Referência a arquivo inexistente = violação (G-PTR):
confira com `ls` antes de citar.

## Proveniência do livro-razão (universal, fail-closed)

Decisão do gate Maurício na onda 0003: toda exúvia carrega a proveniência do
documento em si. Documento governado fora deste padrão é rejeitado; ausência de
metadado não é dívida silenciosa.

Para Markdown governado, a proveniência vive no front-matter YAML. Para JSON de
rito, os mesmos campos vivem no top-level do objeto. Arquivos técnicos que não
aceitam esse envelope (schemas, fixtures, manifests gerados, perfis validados
por schema próprio, licença e formatos `.txt` legados) só passam por exceção
explícita registrada em `MANIFESTO-MIGRACAO.md` e comentada no guard.

Campos obrigatórios para todo documento governado:

`titulo, tipo, status, temperatura, path, created_at, autor, familia, natureza`.

Se `natureza: migrado`, o bloco abaixo também é obrigatório:

- `migrado_de`: versão ou corrente de origem (`versao_2_0_0`, `v0.3.x`, etc.).
- `id_original`: id/ledger original, quando houver; senão, path original.
- `created_at_original`: data da criação original.
- `autor_original`: token/autoria original.
- `transcrito_em`: data de transcrição para esta exúvia.
- `transcrito_por`: token que executou a transcrição.
- `validacao_ref`: readback/hearback/parecer que valida a entrada.

Regra de data: nesta versão, `created_at` é a data de nascimento nesta exúvia.
Para migrados, `created_at = transcrito_em`; o passado fica em
`created_at_original`. O ledger da versão se mantém autoconsistente e o passado
permanece cortável.

Referências normativas de documento migrado devem apontar para documentos desta
versão. Glacier é prova histórica, não fonte vigente.

## Autocontenção da versão vigente (universal, fail-closed)

Decisão do gate Maurício no adendo da onda 0003: a versão vigente deve rodar
sozinha. Documento governado não pode depender de endereço fora da própria
versão como fonte normativa vigente. Referência a exúvia anterior, glacier,
exoesqueleto pré-exúvia ou caminho externo só é aceita quando rotulada de modo
explícito como histórico, consulta, origem, proveniência, exemplo negativo ou
proibição.

Regra operacional:

- Fonte vigente deve apontar para path interno da versão ativa ou transcrever o
  conteúdo canônico para dentro dela.
- Citação proibida a `versao_0_3_x/`, `versao_2_0_0/`, `../`, árvores pré-exúvia ou
  caminhos legados como `methodology/` não pode sustentar regra vigente.
- Glacier é prova histórica; nunca é regra ativa.
- A própria documentação de migração pode citar origens históricas, desde que
  o rótulo histórico/consulta/proveniência esteja na mesma linha ou bloco.

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
