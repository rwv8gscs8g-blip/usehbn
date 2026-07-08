---
titulo: operators — registro opt-in de chaves públicas de operadores humanos
tipo: dado
status: ativo
temperatura: quente
path: .hbn/operators/README.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: v0.3.x
id_original: .hbn/operators/README.md
created_at_original: "2026-07-05T02:30:00-03:00"
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
---
# .hbn/operators/

Registro **opt-in** de chaves públicas SSH dos operadores humanos, usado pelo
G-HRB (`guards/assert-hearback-integrity.sh`) para exigir assinatura
criptográfica (`<hearback>.sig`) dos hearbacks.

- Sem chave depositada aqui, o G-HRB opera no modo padrão (commit puro
  anterior à obra).
- Com `<nome>.pub` depositado (versionado, via commit governado), todo
  hearback de `<nome>` passa a exigir `.sig` válido.

Nenhuma chave foi depositada até a gênese do v3.0.0 — decisão pendente do
gate humano (ver `ROADMAP.md`, fase de segurança).
