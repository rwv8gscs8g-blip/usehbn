---
titulo: "operators — registro opt-in de chaves públicas de operadores humanos"
status: ativo
temperatura: quente
path: versao_3_0_0/.hbn/operators/README.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
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
