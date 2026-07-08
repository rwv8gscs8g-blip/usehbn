---
titulo: "Handoff do orquestrador provisorio pos-quorum G-STATE"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-085300-codex-handoff-orquestrador-provisorio-pos-quorum-g-state.md
created_at: "2026-07-01T08:53:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
head: f8dbe09086d06f5dc42527241c33e37174a65427
rollback_tag: hbn-rollback/pre-0109-g-orq-xaudit-gate-20260630
---

# Handoff - orquestrador provisorio pos-quorum G-STATE

SOU: codex · familia OpenAI · papel orquestrador-provisorio

## Estado

HEAD lido em disco: `f8dbe09086d06f5dc42527241c33e37174a65427`.

Rollback ja existe: `hbn-rollback/pre-0109-g-orq-xaudit-gate-20260630`.

G-STATE-STRUCTURAL 0106 tem quorum material de auditoria cruzada em disco:

- `.hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md`
  - familia: xAI
  - `VEREDITO_G_STATE_STRUCTURAL: APROVA`
  - `APROVA_0106: SIM`
- `.hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md`
  - familia: Anthropic
  - `VEREDITO_G_STATE_STRUCTURAL: APROVA`
  - `APROVA_0106: SIM`

Isto ainda nao e selagem. Falta manifesto de arquivos, gate humano e commit
controlado.

## Invariantes ativos

- Nao auto-ratificar.
- Nao implementar e auditar o mesmo patch.
- Nao contar prompt truncado, chat solto ou anexo como quorum.
- Nao permitir que readback `entregue` altere STATE estrutural sem quorum.
- Nao avancar 0109 enquanto G-STATE nao estiver isolado/selado ou explicitamente
  separado.
- Um passo por vez: um bloco copiavel por passo, comandos atomicos, sem cercas
  Markdown internas em prompts externos.

## Achados que seguem abertos

Os dois auditores aprovaram G-STATE, mas registraram limites para ondas
seguintes:

- delecao de `.hbn/relay/STATE.md` nao e coberta por `G-STATE-STRUCTURAL`;
  destino natural: `G-ORQ-NO-DELETE`;
- freshness/binding de parecer ao conteudo auditado ainda nao esta mecanizada;
- gate humano continua obrigatorio e nao e substituido pelo quorum de IA;
- prompts externos precisam de guard proprio contra truncamento e entrega
  incompleta; knowledge 0031 ja registra a licao.

## Arvore suja - classes

Classe A - patch G-STATE-STRUCTURAL:

- `guards/assert-state-structural.sh`
- `guards/hbn-guards-runner.sh`
- `guards/tests/run-guard-tests.sh`
- `guards/tests/adversarial-battery.sh`
- entradas correspondentes em `REGISTRY.md`

Classe B - quorum e evidencias G-STATE:

- `.hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md`
- `.hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md`
- prompts v2 correspondentes em `.hbn/messages/`
- prompt v1 Grok marcado como superseded; nao contar para quorum

Classe C - licoes aprendidas do orquestrador:

- `.hbn/knowledge/0030-chat-novo-prompts-sequenciais.md`
- `.hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md`
- `.hbn/knowledge/INDEX.md`
- entradas correspondentes em `REGISTRY.md`

Classe D - 0107 falha fechada:

- prompts 0107 e pareceres 0107 `APROVA_0107: NAO`
- manter como evidencia, mas nao usar como quorum nem como implementacao

Classe E - legado/untracked preexistente:

- varios `.hbn/messages/`, `.hbn/results/`, `docs/brainstorm/`, `.hbn/logs/`,
  `.hbn/state/` e `guards/tests/hbn-repro-*`
- nao incluir em commit sem manifesto proprio;
- nao apagar sem classificacao e gate humano.

## Proxima versao recomendada

`0112-G-STATE-SELAGEM-MANIFESTO`

Objetivo: produzir manifesto de selagem isolada para G-STATE, com lista exata de
arquivos a incluir, arquivos a excluir, rollback, testes a rodar e gate humano.

Somente depois do manifesto aprovado: stage/commit controlado de G-STATE.

Somente depois de G-STATE isolado: reabrir `0109-G-ORQ-XAUDIT-GATE`.

