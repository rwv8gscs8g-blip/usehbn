---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (bump 0.3.1 adiado — nota 20260610-34)"
onda_atual: "corrente D — auditoria cruzada PREPARADA (prompt-pack 20260610-51)"
proprietario_bastao: claude-fable-5
papel_bastao: auditor-arquiteto
papeis:
  arquiteto: "claude-fable-5 — implementou a corrente D; por ADR-018 NÃO a audita; preparou o prompt-pack"
  auditor_cruzado_1: "codex (OpenAI) — PENDENTE: PROMPT 1 do pack 51 em chat limpo"
  auditor_cruzado_2: "antigravity-gemini-3-5 (Google) — PENDENTE: PROMPT 2 do pack 51 em chat limpo"
  auditor_validador_fixo: "claude-opus-4-8 (Cowork) — decisão Maurício corrente D"
  gate_humano: "Maurício — aplica os 2 prompts; depois hearback em lote H1–H6 à luz dos pareceres"
proxima_acao: "Maurício: colar os 2 prompts de 20260610-51-prompt-pack-auditoria-cruzada-corrente-d.md em chats limpos (Codex e Antigravity/Gemini 3.5); saídas em .hbn/results/0021 e 0022; só então hearback H1–H6"
sinais_abertos:
  - "🔵 HBN HANDOFF READY — prompt-pack de auditoria cruzada pronto (51/52)"
  - "🟣 auditoria cruzada da corrente D PENDENTE — pareceres 0021 (codex) e 0022 (antigravity) não existem ainda"
  - "🟡 hearback em lote H1–H6 PENDENTE — decidir APÓS os 2 pareceres (BLOQUEADOR de auditor = veto)"
  - "🟡 bump 0.3.1 adiado para onda de auditoria __version__×PROTOCOL_VERSION (nota 20260610-34)"
  - "🟡 inbox/credenciamento com 2 propostas não consolidadas (20260610-01-0017-parametrica, 20260610-44-freeze-gate-v206)"
readback_ativo: ".hbn/readbacks/0001-consolidacao-c1-c7.json"
handoff_mais_recente: ".hbn/messages/20260610-02-handoff-auditoria-cruzada-corrente-d-fable5.md"
ancora_rollback: "9a9cb11"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "corrente D proposed sobre 0.3.0; nada adotado sem hearback; auditoria cruzada em curso"
ultima_atualizacao: "2026-06-10T11:05:00-03:00"
atualizado_por: claude-fable-5
atribuicao:
  chapeu_atual: auditor-arquiteto
  implementador: fable-5
  auditores: [codex, gemini-3-5, opus-4-8]
  gravada_em: "2026-06-10T11:05:00-03:00"
  hearback_ref: ".hbn/hearbacks/0001-consolidacao-c1-c7.json"
---

Nota da onda: corrente D (35–50) está depositada e AGUARDA auditoria cruzada
antes do hearback. Fable-5 implementou e por isso não audita (ADR-018 +
cadência D); o pack 51 entrega prompts de chat limpo para Codex (OpenAI) e
Antigravity/Gemini 3.5 (Google) — famílias distintas entre si e do
implementador: o invariante G-FAM é satisfeito pelos auditores cruzados;
opus-4-8 permanece como validador fixo (exceção fable×opus coberta pelo
hearback_ref, ADR-018 Decisão 3). Pareceres são independentes (Antigravity
não lê o do Codex). Ids 51–52 consumiram a reserva da faxina → renumerar 53+
na execução (previsto na proposal 36). Nada implementado/adotado/movido.
