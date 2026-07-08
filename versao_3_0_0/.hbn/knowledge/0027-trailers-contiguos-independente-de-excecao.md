---
titulo: Trailers contiguos independente de excecao
tipo: knowledge
status: accepted
temperatura: quente
path: .hbn/knowledge/0027-trailers-contiguos-independente-de-excecao.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: v0.3.x
id_original: 0027
created_at_original: 2026-06-17T00:00:00-03:00
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
knowledge-id: 0027
data: 2026-06-17
origem: meta-validacao R1
revisar-em: 2026-12-17
---
# 0027 — trailers contiguos independente de excecao

O G-EXC so checava trailers sob a excecao F-01
(`implementador == agent_id`). Com `implementador=null`, padrao entre ondas,
ele saia verde e trailers nao-contiguos passavam. Na R1, 5 de 6 commits
governados passaram assim.

G-TRAILERS torna a contiguidade dos 3 trailers HBN uma exigencia de todo
commit governado, independente do estado do implementador:

- `HBN-Readback`
- `HBN-Human-Authorization`
- `HBN-Token-FP`

Commits governados devem colocar esses tres trailers em linhas consecutivas
no ultimo paragrafo da mensagem. A zona livre/efemera continua isenta quando
o commit toca somente `docs/brainstorm/**` ou `scratch/**`.
