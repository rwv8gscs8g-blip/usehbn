---
titulo: Runtime Command Model
tipo: knowledge
status: accepted
temperatura: quente
path: .hbn/knowledge/runtime-command-model.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: v0.3.x
id_original: .hbn/knowledge/runtime-command-model.md
created_at_original: "2026-07-05T02:30:00-03:00"
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
---
# Runtime Command Model

Decisao atual:

- `hbn` = CLI operacional primario
- `usehbn` = alias de compatibilidade e trigger semantico

Motivo:

- separa linguagem do protocolo da operacao de sistema
- melhora a legibilidade de instalacao local
- prepara o caminho para uma futura camada de distribuicao como `get-hbn`
