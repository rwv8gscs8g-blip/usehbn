---
titulo: Relay Protocol
tipo: knowledge
status: accepted
temperatura: quente
path: .hbn/knowledge/relay-protocol.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: v0.3.x
id_original: .hbn/knowledge/relay-protocol.md
created_at_original: "2026-07-05T02:30:00-03:00"
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
---
# Relay Protocol

O relay do HBN existe para reduzir perda de contexto entre IAs e diminuir consumo desnecessário de tokens.

Regras atuais:

- `INDEX.md` resume o estado ativo
- cada iteracao ativa usa arquivo `NNNN-assunto.md`
- apenas uma entidade deve deter o bastao operacional por vez
- arquivos resolvidos devem migrar para `relay-archive/`
- o relay guarda contexto operacional, nao documentacao publica
