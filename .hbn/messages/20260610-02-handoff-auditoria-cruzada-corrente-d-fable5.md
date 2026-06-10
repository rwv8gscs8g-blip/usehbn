---
id: 20260610-02
id-global: 20260610-52
tipo: handoff
projeto: usehbn (canônico)
de: claude-fable-5 (arquiteto, corrente D — preparador da auditoria cruzada)
para: Maurício (gate humano) → Codex e Antigravity/Gemini 3.5 em chats limpos
data: 2026-06-10
temperatura: quente
status: proposed
---

# Handoff — prompt-pack de auditoria cruzada da corrente D

## O que esta onda depositou

| id | artefato | tipo |
|---|---|---|
| 20260610-51 | 20260610-51-prompt-pack-auditoria-cruzada-corrente-d.md | prompt |
| 20260610-52 | .hbn/messages/20260610-02-handoff-auditoria-cruzada-corrente-d-fable5.md | handoff |

## Por que auditoria cruzada (e por que não eu)

Fable-5 implementou a corrente D. Por ADR-018 (anti-groupthink) e pela
cadência D, o implementador não audita o próprio trabalho. Os dois auditores
são de famílias diferentes entre si E do implementador: Codex (OpenAI) e
Antigravity/Gemini 3.5 (Google). Teste vivo da máquina de auditoria do
protocolo — inclusive do próprio invariante G-FAM que a corrente D propôs.

## O que Maurício faz

1. Colar PROMPT 1 do pack 51 num chat limpo do Codex.
2. Colar PROMPT 2 do pack 51 num chat limpo do Antigravity (Gemini 3.5).
3. Conferir saídas: .hbn/results/0021-cross-ia-codex-corrente-d.json e
   .hbn/results/0022-cross-ia-antigravity-corrente-d.md (pareceres
   independentes; Antigravity não lê o do Codex).
4. Decidir hearback H1–H6 (handoff 20260610-01) À LUZ dos dois pareceres e
   dos VETO_ADOÇÃO. BLOQUEADOR de auditor = veto.

## Invariantes

Nada foi implementado/adotado/movido nesta onda. Guards seguem fora do
runner. Faxina 36 segue dry-run (ids reservados 51–57 → renumerar para 53+
na execução, conforme previsto na proposal). Auditores têm write permitido
SÓ no próprio arquivo de resultado.
