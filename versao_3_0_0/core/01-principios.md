---
titulo: "01 — Princípios e fundamento do desenho"
status: ativo
temperatura: quente
path: versao_3_0_0/core/01-principios.md
created_at: "2026-07-01T19:32:00-03:00"
autor: fable-5
familia: Anthropic
---

# 01 — Princípios

## P1–P13 (inalterados)

Os 13 princípios constitucionais do useHBN permanecem em vigor com peso
normativo idêntico. Fonte canônica (não migrada, por decisão — histórico
imutável): `../../methodology/PRINCIPIOS-CONSTITUCIONAIS.md` no exoesqueleto
v0.3.x. Mudança em qualquer P1–P13 exige cross-IA ≥ 2 famílias + hearback
humano (ADR-009), agora somado à emenda constitucional do BOOT §9.

## Axioma de desconfiança produtiva

Confiar em disciplina de modelo é design quebrado. Toda regra vinculante tem:
(a) trava mecânica no chokepoint (commit/CI), OU
(b) detecção ex-post (sweep) com correção obrigatória, OU
(c) gate humano assinado.
Regra sem (a), (b) ou (c) é recomendação e mora em `docs/`, nunca em `core/`.

## As quatro causas mecânicas de violação (evidência histórica)

Registradas na consolidação `20260611-131310` (v0.3.x) e confirmadas na
varredura de 2026-07-01; são a razão de cada escolha estrutural desta versão:

1. **Ambiguidade vence pela plausibilidade** → uma regra, um lugar, sem
   versões concorrentes vivas (temperatura + REGISTRY resolvem conflito).
2. **Regra fora do contexto não existe** → orçamento R1; leitura sob demanda.
3. **Modelo preenche em vez de parar** → Truth Barrier fail-closed (BOOT §3).
4. **Escape hatch documentado será usado** → sem bypass; exceção só G-EXC.

## Darwinismo em 3 níveis (decisão travada 2026-06-15 §4.4)

- Software: só muda quem está funcional e testado (Fitness Gate).
- Lições de IA: viram knowledge numerada, nunca doutrina obrigatória (R2/R4).
- Seleção inter-agentes: papéis medidos por resultado auditado, não por promessa.
