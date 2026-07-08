---
titulo: "Severidades de auditoria (BLOQUEADOR/FORTE/MARGINAL), regra de veto e checklist anti-viés"
tipo: knowledge
status: accepted
temperatura: quente
path: .hbn/knowledge/0019-severidades-veto.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: v0.3.x
id_original: 20260611-155220-fable5-knowledge-0019-severidades-veto
created_at_original: "2026-06-11T15:52:20-03:00"
autor_original: "claude-fable-5 (implementador onda 0006, item I-01 — F-08 do cross-audit 0036/0037)"
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
id-global: 20260611-155220-fable5-knowledge-0019-severidades-veto
autoria: "claude-fable-5 (implementador onda 0006, item I-01 — F-08 do cross-audit 0036/0037)"
fonte: "transcrito para esta exúvia a partir de cadence-d/ADR-022/ADR-019; regra vigente neste arquivo e em core/03-rito-da-onda.md"
---
# Severidades, veto e anti-viés — a página que todo auditor lê

Este arquivo era citado por templates e prompts de auditoria antes de existir
como artefato desta exúvia (achado FORTE transversal do parecer 0036; classe
de erro agora detectada pelo teste de read-list viva na suíte). Conteúdo
transcrito para esta versão; em divergência, vale este arquivo e o rito
canônico em `core/03-rito-da-onda.md`.

## Severidades

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
  outra**.
- Parecer fecha com veredito em 1 linha (APROVAR / APROVAR com FORTE
  incorporados / BLOQUEAR) e `VETO_ADOCAO: SIM|NAO` quando o alvo é adoção.

## Checklist anti-viés

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
