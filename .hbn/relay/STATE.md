---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (bump 0.3.1 adiado — nota 20260610-34)"
onda_atual: "corrente E — anti-teatro: guards endurecidos + suíte de testes negativos (50% — Blocos 1-2 + marginais entregues; Blocos 3-4 pendentes)"
proprietario_bastao: claude-fable-5
papel_bastao: arquiteto-implementador (corrente E)
papeis:
  arquiteto: "claude-fable-5 — implementou a corrente E (ADR-020 + guards endurecidos); por ADR-018 NÃO a audita"
  auditor_validador_fixo: "claude-opus-4-8 (Cowork) — validador fixo EM PROSA; fora do campo mecânico `auditores` até o hearback 0002 ser confirmado (correção F-04)"
  gate_humano: "Maurício — roda a suíte no Terminal (conclusivo) e dá hearback do lote E"
proxima_acao: "Maurício: (1) bash guards/tests/run-guard-tests.sh no Terminal — sandbox foi informativo, 15/15 verde; (2) hearback lote corrente E (guards endurecidos + ADR-020 + perfil fable-5 + marginais); (3) decidir hearback 0002 (exceção fable×opus) — confirmar devolve opus ao campo mecânico; (4) janela nova para Blocos 3-4 da corrente E (auto-localização `path:` + saída de auditoria legível)"
sinais_abertos:
  - "🔵 HBN HANDOFF READY — corrente E aos 50% (handoff 20260610-67)"
  - "🟡 hearback lote corrente E PENDENTE — nada ativado no runner (ADR-020 Decisão 2 exige suíte verde + hearback)"
  - "🟡 hearback 0002 (exceção fable×opus) DRAFT pendente de assinatura — até lá opus-4-8 fora do campo mecânico auditores"
  - "🟡 hearback em lote H1–H6 da corrente D PENDENTE — pareceres 0021/0022 entregues; correções dos 3 bugs (F-01/F-02/F-03) já aplicadas pela corrente E"
  - "🟡 bump 0.3.1 adiado para onda de auditoria __version__×PROTOCOL_VERSION (nota 20260610-34)"
  - "🟡 inbox/credenciamento com 2 propostas não consolidadas (20260610-01-0017-parametrica, 20260610-44-freeze-gate-v206)"
  - "🟡 backlog corrente E (não inflado nesta metade): F-05 renumeração da faxina 36 antes de H2; F-07 semântica de proprietario_bastao quando próxima ação é humana; 0022/F-05 G-FAM cruzar STATE completo (bastao×chapeu); gate script versionado do dual-run (0021/F-06)"
readback_ativo: ".hbn/readbacks/0001-consolidacao-c1-c7.json"
handoff_mais_recente: ".hbn/messages/20260610-03-handoff-corrente-e-50pct-fable5.md"
ancora_rollback: "e5ad876"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "correntes D e E proposed sobre 0.3.0; nada adotado sem hearback; suíte guards/tests 15/15 verde em sandbox (informativa)"
ultima_atualizacao: "2026-06-10T15:10:00-03:00"
atualizado_por: claude-fable-5
atribuicao:
  chapeu_atual: arquiteto-implementador
  implementador: fable-5
  auditores: [codex, gemini-3-5]
  gravada_em: "2026-06-10T15:10:00-03:00"
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
Google) e papéis aptos (perfil fable-5 ganhou 'implementador' — adição
proposed, fato exercido nas correntes D/E). Blocos 3-4 (auto-localização
`path:` + saída de auditoria legível por humano) ficam para a próxima
janela — ver handoff.
