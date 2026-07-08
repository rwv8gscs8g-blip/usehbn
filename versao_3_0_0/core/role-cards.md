---
titulo: role-cards — porta da frente mecânica (ponteiro fino; contrato do G-FRONTDOOR)
tipo: spec
status: ativo
temperatura: quente
path: core/role-cards.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: versao_2_0_0
id_original: core/role-cards.md
created_at_original: "2026-07-01T20:06:00-03:00"
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
arvore: fronteira
---
# Porta da Frente de Papéis (v2 — ponteiro fino)

Este arquivo satisfaz o contrato mecânico do guard herdado
`guards/assert-frontdoor.sh` (G-FRONTDOOR: presença, teto anti-monolito,
read-list ≤ 6 itens com paths existentes). A porta de entrada narrativa do
v2 é o `BOOT.md`; os contratos completos de papel vivem em
`core/02-papeis.md`. Este cartão NÃO duplica regra (uma regra, um lugar).

## PARTE A - READ-LIST DA PORTA DA FRENTE

Qualquer IA lê estes itens ao assumir o bastão, antes de agir:

1. `BOOT.md`
2. `.hbn/relay/STATE.md`
3. O readback ativo apontado no STATE.
4. `core/02-papeis.md`

## PARTE B - CARTOES (PONTEIRO)

Os cartões de papel (Orquestrador, Implementador, Auditor, Arquiteto,
Humano-gate) estão consolidados em `core/02-papeis.md` (≤ 40 linhas por
papel) e resumidos em uma linha por papel no `BOOT.md` §5. Ler apenas a
seção do próprio papel; o restante é sob demanda (BOOT §9/R1).
