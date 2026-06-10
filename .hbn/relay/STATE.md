---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (bump 0.3.1 adiado — nota 20260610-34)"
onda_atual: "corrente E — anti-teatro 50% ADOTADA (ADR-020 + 3 guards endurecidos + suíte; Blocos 3-4 pendentes)"
proprietario_bastao: claude-fable-5
papel_bastao: arquiteto-implementador (corrente E)
papeis:
  arquiteto: "claude-fable-5 — implementou a corrente E (ADR-020 + guards endurecidos); por ADR-018 NÃO a audita"
  auditor_validador_fixo: "claude-opus-4-8 (Cowork) — validador fixo EM PROSA; fora do campo mecânico `auditores` até o hearback 0002 ser confirmado (correção F-04)"
  gate_humano: "Maurício — confirmou o readback 0002 para adoção da Corrente E 50%; mantém F-05 por revisão visual de diff"
proxima_acao: "claude-fable-5: fechar a Corrente E após revisão humana do diff final; não ativar guards no runner; manter 0002 fable×opus pendente; planejar Blocos 3-4 em janela futura"
sinais_abertos:
  - "🔵 HBN HANDOFF READY — corrente E 50% adotada; bastão devolvido a claude-fable-5"
  - "🟢 HBN CHECKPOINT CLEAN — ADR-020 + 3 guards endurecidos + suíte guards/tests adotados; nada ativado no runner"
  - "🟡 hearback 0002 (exceção fable×opus) DRAFT pendente de assinatura — até lá opus-4-8 fora do campo mecânico auditores"
  - "🟡 hearback em lote H1–H6 da corrente D PENDENTE — pareceres 0021/0022 entregues; correções dos 3 bugs (F-01/F-02/F-03) já aplicadas pela corrente E"
  - "🟡 bump 0.3.1 adiado para onda de auditoria __version__×PROTOCOL_VERSION (nota 20260610-34)"
  - "🟡 inbox/credenciamento com 2 propostas não consolidadas (20260610-01-0017-parametrica, 20260610-44-freeze-gate-v206)"
  - "🟡 backlog corrente E (não inflado nesta metade): F-05 renumeração da faxina 36 antes de H2; F-07 semântica de proprietario_bastao quando próxima ação é humana; 0022/F-05 G-FAM cruzar STATE completo (bastao×chapeu); gate script versionado do dual-run (0021/F-06); decidir versionamento de .hbn/readbacks/; resolver colisão de numeração readback 0002 × hearback 0002"
readback_ativo: ".hbn/readbacks/0002-adocao-corrente-e.json"
handoff_mais_recente: ".hbn/messages/20260610-03-handoff-corrente-e-50pct-fable5.md"
ancora_rollback: "e5ad876"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "corrente E 50% accepted sobre 0.3.0; D segue pendente nos itens H1-H6; Blocos 3-4 da E pendentes"
ultima_atualizacao: "2026-06-10T13:34:44-03:00"
atualizado_por: codex
atribuicao:
  chapeu_atual: arquiteto-implementador
  implementador: fable-5
  auditores: [codex, gemini-3-5]
  gravada_em: "2026-06-10T13:34:44-03:00"
  hearback_ref: null
---

Nota da onda: a corrente E endureceu os 3 guards contra "validação de
teatro" (ADR-020): G-FAM dereferencia hearback_ref (existe + confirmed +
excecoes_cobertas com a entrada exata); G-REG casa coluna exata no REGISTRY
e cobre core/*.md, .hbn/models/*.json, .github/workflows/* e órfãos em
docs/prompts/; G-FRZ aceita na-obrigatório só com hearback verificável.
Prova: guards/tests/run-guard-tests.sh — 15/15, incluindo teste negativo
para cada bug da auditoria cruzada. Correção F-04: o hearback 0001 NÃO
cobre a exceção fable×opus; o draft 0002 a cerca de forma estruturada e,
até Maurício confirmá-lo, opus-4-8 saiu do campo mecânico `auditores`
(segue validador fixo em prosa). A atribuição acima passa no G-FAM
endurecido SEM exceção alguma: famílias cruzadas (Anthropic × OpenAI ×
Google) e papéis aptos. A adoção E 50% foi confirmada no readback 0002;
as evidências 0025/0026 e o readback entram no commit para evitar referência
fantasma. Blocos 3-4 (auto-localização
`path:` + saída de auditoria legível por humano) ficam para a próxima
janela — ver handoff.
