---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (bump 0.3.1 adiado — nota 20260610-34)"
onda_atual: "orquestração-start adotada — ADR-024 + 4 specs core + 4 guards + suíte 63; guards novos FORA do runner"
proprietario_bastao: claude-fable-5
papel_bastao: arquiteto (bastão devolvido após adoção Codex da orquestração-start)
papeis:
  arquiteto: "claude-fable-5 — dono do desenho da orquestração-start; por ADR-018 NÃO audita a própria onda"
  auditor_validador_fixo: "claude-opus-4-8 (Cowork) — validador fixo EM PROSA; fora do campo mecânico `auditores` até o hearback 0002 ser confirmado (correção F-04)"
  gate_humano: "Maurício — confirmou o readback 0004; mantém o gate humano para adoções safe_track"
proxima_acao: "claude-fable-5: receber o bastão pós-adoção da orquestração-start, conferir o commit e decidir a próxima onda sem ativar guards novos no runner"
sinais_abertos:
  - "🟢 HBN ADOÇÃO ORQUESTRAÇÃO-START — ADR-024, 4 specs, 4 guards e suíte 63 adotados por readback 0004 confirmado"
  - "🟢 REAUDITORIA SEM VETO — 0032 Codex e 0033 Antigravity/Gemini retornaram VETO_ADOCAO: NAO; 0 bloqueadores, 0 fortes, 0 marginais"
  - "🟢 SUÍTE 63 — guards/tests/run-guard-tests.sh: 63 checks totais; seção ADR-024 com 30 checks e 20 negativos de bloqueio"
  - "🟡 G-STR/G-NUM/G-PTR/G-RLT continuam FORA de guards/hbn-guards-runner.sh; ativação futura exige onda própria e testes negativos dos 5 guards legados"
  - "🟡 D2 contrato do orquestrador e D6 log frio/read-list seguem doutrina-sem-enforcement/backlog; adoção não cria subcomando CLI start"
  - "🟡 hearback 0002 (exceção fable×opus) DRAFT pendente de assinatura — até lá opus-4-8 fora do campo mecânico auditores"
  - "🟡 hearback em lote H1–H6 da corrente D PENDENTE — pareceres 0021/0022 entregues"
  - "🟡 bump 0.3.1 adiado para onda de auditoria __version__×PROTOCOL_VERSION (nota 20260610-34)"
  - "🟡 inbox/credenciamento com 2 propostas não consolidadas (20260610-01-0017-parametrica, 20260610-44-freeze-gate-v206)"
  - "🟡 backlog: assinatura GPG/SSH de hearbacks (eleva aviso de autor do G-HRB a bloqueio — ADR-023 Decisão 4); ativação futura dos guards novos no runner; F-05 renumeração da faxina 36 antes de H2; F-07 semântica de proprietario_bastao quando próxima ação é humana; 0022/F-05 G-FAM cruzar STATE completo (bastao×chapeu); gate script versionado do dual-run (0021/F-06); decidir versionamento de .hbn/readbacks/; resolver colisão de numeração readback 0002 × hearback 0002"
readback_ativo: ".hbn/readbacks/0004-adocao-orquestracao-start.json (adoção orquestração-start — confirmed)"
handoff_mais_recente: ".hbn/messages/20260610-205910-fable-5-handoff-guards-orquestracao-start.md"
ancora_rollback: "603805e (checkpoint protocol fix 3 FORTE — antes da adoção orquestração-start)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "corrente E adotada; orquestração-start adotada por readback 0004; corrente D segue pendente nos itens H1-H6"
ultima_atualizacao: "2026-06-10T23:07:10-03:00"
atualizado_por: codex
atribuicao:
  chapeu_atual: consolidador
  implementador: codex
  auditores: [codex, gemini-3-5]
  gravada_em: "2026-06-10T23:07:10-03:00"
  hearback_ref: ".hbn/readbacks/0004-adocao-orquestracao-start.json"
---

Nota da onda (adoção orquestração-start, readback 0004): Maurício confirmou
o readback 0004; Codex executou a adoção documental de ADR-024, 4 specs core
(start-rite, orchestrator-profile, pointer, state-report), 4 guards
(G-STR/G-NUM/G-PTR/G-RLT) e a seção ADR-024 da suíte 63. A cadeia de auditoria
fica preservada: 0030/0031 vetaram o pré-fix; 603805e corrigiu os 3 FORTE
(G-NUM token exato + data serial, G-RLT heading/cápsula, rito start≠CLI);
0032/0033 removeram o veto com 0 findings. Nenhum guard novo entra no runner.
`usehbn start` permanece rito declarativo textual, não subcomando CLI.

Nota de continuidade: o fechamento da corrente E segue adotado por readback
0003, com G-SLF/G-HRB e hardening G-REG fora do runner. A regra firewall
continua vigente: esta adoção é doc-only no canônico; nenhuma escrita de
domínio, VBA, Excel, src/, tests/ de produto, workflows, modules, examples,
inbox, auditoria ou radar foi autorizada por esta onda.
