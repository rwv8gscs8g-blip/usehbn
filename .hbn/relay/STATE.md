---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (modelo versão=pasta; M-A scaffold inativo; S0 corretiva)"
onda_atual: "S0 ratificada (auditada OK)"
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: codex
papel_bastao: "implementador"
modo_educacional: "intermediário"
papeis:
  arquiteto: "claude-opus-4-8 — orquestrador/desenho do mecanismo M-A; distinto do implementador codex"
  auditores_validadores: "gemini-3-5 + cursor — cross-audit S0 concluído; próxima auditoria é D-ORQ-WRITE"
  gate_humano: "Maurício — aprova item a item; commit e tag são atos do operador no Terminal"
proxima_acao: "cross-audit da emenda de doutrina D-ORQ-WRITE; depois Reestruturação (Opção B); depois S1"
sinais_abertos:
  - "🔴 EXCEÇÃO F-01 ATIVA (onda 0006) — desenhista=implementador=claude-fable-5 por ordem direta de Maurício; estado PROPOSED_UNTIL_CROSS_AUDIT. Mantido sem baixa nesta onda M-A."
  - "🔴 PONTE VETADA — 0034 (Codex) e 0035 (Antigravity) retornaram VETO_ADOCAO: SIM; descongelar só após corrigir bloqueadores."
  - "🔴 ATIVAÇÃO DA EXÚVIA BLOQUEADA — Fitness Gate pendente: baseline funcional + Ponte do Credenciamento verde + confronto incumbente×desafiante."
  - "🟢 M-A SCAFFOLD INATIVO — .hbn/active-version aponta para '.', hooks version-aware instalados localmente, get_canonical_root() resolve /Users/macbookpro/Projetos/usehbn; nenhuma versao_1_0_0 criada."
  - "🟢 S0 D3 CORRIGIDO — scripts/hbn-exuvia-rollback.sh resolve state_path a partir do TARGET e teste --apply cobre active-version divergente entre HEAD e TARGET."
  - "🟢 S0 PERFIS ADICIONADOS — .hbn/models/grok.json e .hbn/models/cursor.json criados como proposed para auditoria cross-family futura."
  - "🟢 S0 INDEX RECONCILIADO — .hbn/relay/INDEX.md não é mais fonte de estado; aponta STATE.md como canônico."
  - "🟢 S0 FIXTURES UNTRACKED REMOVIDAS — guards/tests/adv-cr-active.*, cr-conflict-active.*, cr-missing-active.* e cr-version-root.* foram limpas do worktree."
  - "🟢 S0 AUDITADA OK — Gemini(100)+Cursor(OK,2 marginais não-bloqueadoras); pareceres+consolidação depositados"
  - "🟡 cursor.json model_id vs runtime — corrigir ao promover perfil a accepted"
  - "🟢 SUÍTE 132/132 verde no SANDBOX macOS/Bash desta linha de trabalho; bateria adversarial 15/15 burlas BLOQUEADAS; runner real com 14 guards verde."
  - "🟢 G-TOK ATIVO, FP `34a7f2f9` — token vive só em .git/hbn-baton-token; commit local exige trailer HBN-Token-FP: 34a7f2f9."
  - "🟢 ESCAPES LACRADOS herdados — CI=true local FAIL; bypass env só com nota staged; G-STRAY fail-closed/maxdepth6/symlink/allowlist; naming universal ADR-025."
  - "🟡 G-HRB assinatura PENDENTE DE CHAVE — Maurício gera/registra .hbn/operators/<nome>.pub para ativar ssh-keygen -Y verify; sem chave o guard avisa e mantém travas de histórico."
  - "🟡 F-02 (0035 UTC×REGISTRY) NÃO corrigido nesta onda — formato da linha de correção (superseded_by) segue decisão humana."
  - "🟡 branch protection no GitHub (hbn-shield obrigatório no push) = ação humana pendente."
  - "🟡 hearback 0002 (exceção fable×opus) DRAFT pendente de assinatura."
  - "🟡 bump 0.3.1 adiado para onda de auditoria __version__×PROTOCOL_VERSION."
  - "🟡 inbox/credenciamento com 2 propostas não consolidadas (20260610-01-0017-parametrica, 20260610-44-freeze-gate-v206)."
  - "🟡 backlog preservado: F-05 renumeração da faxina 36 antes de H2; F-07 semântica de proprietario_bastao quando próxima ação é humana; gate script do dual-run (0021/F-06); versionamento de .hbn/readbacks/; colisão readback 0002 × hearback 0002; propostas glacier/zona-de-corte/refatoração-árvore aguardando auditoria adversarial."
readback_ativo: ".hbn/readbacks/0014-s0-deposito-auditorias.json"
handoff_mais_recente: ".hbn/messages/20260615-000857-codex-handoff-s0-deposito.md"
ancora_rollback: "4db6928 (HEAD lido no warm boot; M-A não cria tag nem corte real)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "S0 ratificada e depositada; roadmap imediato: cross-audit da emenda D-ORQ-WRITE → Reestruturação (Opção B) → S1"
ultima_atualizacao: "2026-06-15T00:08:57-03:00"
atualizado_por: codex-implementador-s0-deposito-auditorias
atribuicao:
  chapeu_atual: implementador
  implementador: codex
  auditores: [gemini-3-5, cursor]
  gravada_em: "2026-06-15T00:08:57-03:00"
  hearback_ref: null
---

Nota M-A: esta onda construiu a máquina da muda sem disparar a muda. O
ponteiro ativo permanece em `.`; hooks e guards falham fechado quando o
ponteiro está ausente, conflitado ou aponta para versão inexistente. A tag
`hbn-exuvia/protocol-0.3.x` e qualquer `git mv` ficam para M-C, depois do
Fitness Gate. O script de rollback foi testado apenas em dry-run.

Nota S0: esta onda corrigiu somente itens aditivos/corretivos pós-M-A. O bug D3
do rollback foi corrigido com teste de `--apply`; perfis `grok` e `cursor`
foram adicionados como `proposed`; o INDEX foi marcado como superseded pelo
STATE; e as fixtures untracked indicadas foram removidas. Nenhuma lógica de
guard foi alterada.

Nota depósito S0: Gemini (Google) aprovou S0 com confiança 100/100; Cursor
aprovou S0 com duas marginais não-bloqueadoras; opus-4-8 consolidou como OK,
ratificável e sem bloqueador. O marginal `cursor.json` model_id vs runtime fica
rastreado para a promoção futura do perfil a `accepted`.
