---
titulo: Severidades de auditoria (BLOQUEADOR/FORTE/MARGINAL), regra de veto e checklist anti-viés
tipo: knowledge
path: .hbn/knowledge/0019-severidades-veto.md
id-global: 20260611-155220-fable5-knowledge-0019-severidades-veto
temperatura: glacier
autoria: claude-fable-5 (implementador onda 0006, item I-01 — F-08 do cross-audit 0036/0037)
fonte: "destilado de core/cadence-d.md §«Severidade e veto (P7)» (linhas 48-57) e §«Checklist anti-viés de bastão (P4)» (linhas 40-47); ADR-022 Decisão 1.2; ADR-019 (achado cita arquivo:linha + severidade + correção)"
created_at: "2026-06-11T15:52:20-03:00"
status: congelado
---

# Severidades, veto e anti-viés — a página que todo auditor lê

Este arquivo era citado por `agents/role-templates.md` (§T2 item 4, §T3
item 4) e por prompts de auditoria SEM EXISTIR (achado FORTE transversal do
parecer 0036; classe de erro agora detectada pelo teste de read-list viva
na suíte). Conteúdo destilado das fontes normativas — em divergência, vale
a fonte.

## Severidades (core/cadence-d.md §P7)

| Severidade | Quando | Efeito |
|---|---|---|
| BLOQUEADOR | segurança, correção, regressão | NÃO prossegue até resolver (**veto**) |
| FORTE | qualidade, manutenibilidade | incorpora OU justifica por escrito |
| MARGINAL | nice-to-have | pode ignorar |

## Regra de veto

- Todo achado declara severidade e EVIDÊNCIA verificável — arquivo:linha ou
  comando+saída; achado sem evidência não é achado (ADR-022 Decisão 1.2;
  Truth Barrier).
- BLOQUEADOR = veto até resolução. Conflito BLOQUEADOR×BLOQUEADOR entre
  auditores → escala ao humano; **nenhuma IA sobrescreve o BLOQUEADOR de
  outra** (core/cadence-d.md:56-57; §T3 do role-templates).
- Parecer fecha com veredito em 1 linha (APROVAR / APROVAR com FORTE
  incorporados / BLOQUEAR) e `VETO_ADOCAO: SIM|NAO` quando o alvo é adoção.

## Checklist anti-viés (core/cadence-d.md §P4)

Ao recomendar destino de bastão (ou qualquer indicação em causa própria), a
IA DEVE: (1) declarar se há auto-indicação; (2) listar evidência objetiva;
(3) reconhecer o viés natural; (4) sugerir mitigações. Estrutural: ≥2-3
recomendadores independentes de famílias distintas; o humano pesa evidência
acima de auto-avaliação.

## Forma da saída

Ordem do parecer legível (ADR-022 Decisão 1): veredito → findings por
severidade com evidência → recomendação por hearback (granularidade de
decisão POR item) → resumo ≤10 linhas. JSON é anexo de máquina, nunca a
entrega principal (ADR-022 Decisão 2).
