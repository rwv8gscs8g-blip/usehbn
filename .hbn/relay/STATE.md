---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (bump 0.3.1 adiado — nota 20260610-34)"
onda_atual: "ativação-enforcement — hook pre-commit INSTALADO; G-SLF/G-REG/G-NUM/G-PTR/G-RLT ATIVOS no runner; suíte 75; onda-ponte regularizada no REGISTRY (readback 0005, ordem direta Maurício)"
proprietario_bastao: claude-fable-5
papel_bastao: "orquestrador-implementador (EXCEÇÃO: ordem direta de Maurício 2026-06-11 'ligar na tomada'; registrada em authorization do readback 0005)"
papeis:
  arquiteto: "claude-fable-5 — também implementador desta onda por exceção autorizada; cross-audit posterior por Codex+Antigravity recomendado"
  auditor_validador_fixo: "claude-opus-4-8 (Cowork) — validador fixo EM PROSA; fora do campo mecânico `auditores` até o hearback 0002 ser confirmado (correção F-04)"
  gate_humano: "Maurício — autorizou a onda de enforcement por ordem direta; valida com o roteiro de verificação no Terminal"
proxima_acao: "Maurício: rodar o roteiro de verificação no Terminal (canonical-root e hook só são conclusivos lá); depois, onda do adendo ADR-011×ADR-024 (numeração multi-família em results + consistência de relógio) com cross-audit Codex+Antigravity"
sinais_abertos:
  - "🟢 ENFORCEMENT LIGADO — .git/hooks/pre-commit instalado (2026-06-11) chamando guards/hbn-guards-runner.sh; commits A/B/C desta onda nasceram fiscalizados"
  - "🟢 G-SLF/G-REG/G-NUM/G-PTR/G-RLT ATIVOS no runner — pré-condição paga: suíte ganhou seção 'guards legados' (12 checks negativos G-CR/G-TMP/G-ENV/G-LEG/G-SCO); 75/75 verde"
  - "🟢 ONDA-PONTE REGULARIZADA — 4 proposals + pareceres 0034/0035 commitados com linha de nascimento no REGISTRY (estavam untracked e sem linha)"
  - "🔴 PONTE VETADA — 0034 (Codex) e 0035 (Antigravity) retornaram VETO_ADOCAO: SIM; descongelar só após corrigir bloqueadores (vendorização do verify; aritmética de migração; texto verbatim do split 0022)"
  - "🟡 VERIFICAÇÃO TERMINAL PENDENTE — commits da onda nasceram em sandbox Cowork com CI=true (canonical-root delegado por desenho próprio do guard, linhas 20-23); Maurício valida com o roteiro entregue no chat"
  - "🟡 RELÓGIO — salto observado no relógio do sandbox durante a onda (01:42→10:17 -03:00); created_at do readback 0005 segue o carimbo interno coerente; fixar regra de relógio no adendo ADR-011×ADR-024"
  - "🟡 G-STR fora do runner POR DESENHO (atribuição via argumento); G-COM/Carta de Compromisso rebaixada a doutrina-sem-enforcement por decisão de Maurício (2026-06-11)"
  - "🟡 hearback 0002 (exceção fable×opus) DRAFT pendente de assinatura — até lá opus-4-8 fora do campo mecânico auditores"
  - "🟡 hearback em lote H1–H6 da corrente D PENDENTE — pareceres 0021/0022 entregues"
  - "🟡 bump 0.3.1 adiado para onda de auditoria __version__×PROTOCOL_VERSION (nota 20260610-34)"
  - "🟡 inbox/credenciamento com 2 propostas não consolidadas (20260610-01-0017-parametrica, 20260610-44-freeze-gate-v206)"
  - "🟡 backlog: assinatura GPG/SSH de hearbacks; F-05 renumeração da faxina 36 antes de H2; F-07 semântica de proprietario_bastao quando próxima ação é humana; 0022/F-05 G-FAM cruzar STATE completo; gate script do dual-run (0021/F-06); versionamento de .hbn/readbacks/; colisão readback 0002 × hearback 0002; autoexclusão do canonical-root em CI (desenho pendente)"
readback_ativo: ".hbn/readbacks/0005-ativacao-enforcement.json (ativação enforcement — human_status confirmed por ordem direta)"
handoff_mais_recente: ".hbn/messages/20260610-205910-fable-5-handoff-guards-orquestracao-start.md"
ancora_rollback: "27775bd (commit A da onda enforcement — antes da ativação dos guards no runner)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "onda ativação-enforcement em execução (commits A/B/C); corrente D segue pendente nos itens H1-H6; ponte congelada por veto 0034/0035"
ultima_atualizacao: "2026-06-11T10:17:06-03:00"
atualizado_por: claude-fable-5
atribuicao:
  chapeu_atual: implementador
  implementador: claude-fable-5
  auditores: [codex, gemini-3-5]
  gravada_em: "2026-06-11T10:17:06-03:00"
  hearback_ref: ".hbn/readbacks/0005-ativacao-enforcement.json"
---

Nota da onda (ativação-enforcement, readback 0005): Maurício, após análise
que constatou 4 camadas de vão (hook pre-commit inexistente; canonical-root
autoexcluído em CI; guards novos fora do runner; cegueira write-time),
ordenou execução direta: "pare as orientações anteriores e dispare um
processo de como ligar na tomada". Esta onda: (A) regularizou a onda-ponte
no REGISTRY, abriu o readback 0005 e instalou o hook; (B) pagou a
pré-condição dos testes negativos legados e ativou G-SLF/G-REG/G-NUM/G-PTR/
G-RLT no runner; (C) cria G-STRAY (assert-no-stray-hbn) para o vão
write-time. O scope vazio do readback 0004 foi documentado como caso de
teste da suíte (sco: files_allowed VAZIO é inválido). A regra firewall
continua vigente: nenhuma escrita de domínio, VBA, Excel, src/ de produto,
workflows de produto, examples ou inbox nesta onda.

Nota de continuidade: a ponte usehbn⇄Credenciamento permanece VETADA
(0034/0035) e fora do escopo desta onda; o fechamento da corrente E segue
adotado por readback 0003; a adoção orquestração-start segue por readback
0004 — apenas o ESTADO de ativação dos guards mudou, nada do conteúdo
normativo do ADR-024 foi alterado.
