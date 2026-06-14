---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (plano hbn-exuvia v2 proposto; execução M2 posterior)"
onda_atual: "onda 0011 — emenda do plano hbn-exuvia v2"
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: codex
papel_bastao: "implementador"
modo_educacional: "intermediário"
papeis:
  arquiteto: "claude-opus-4-8 — orquestrador/desenho do plano hbn-exuvia v2; distinto do implementador codex"
  auditor_validador_fixo: "gemini-3-5 — próxima auditoria cross-vendor do plano v2; fornecedor Google != implementador OpenAI"
  gate_humano: "Maurício — aprova item a item: cd ~/Projetos/usehbn && git cherry-pick -n <sha> && git commit -C <sha> (preserva AUTOR+mensagem+trailers e roda os hooks — correção C-03b dos pareceres 170633/172049; tabela de aprovação v2)"
proxima_acao: "cross-audit Gemini do plano v2; depois ratificação e M2 (execução do corte)"
sinais_abertos:
  - "🔴 EXCEÇÃO F-01 ATIVA (onda 0006) — desenhista=implementador=claude-fable-5 por ordem direta de Maurício; estado PROPOSED_UNTIL_CROSS_AUDIT: adoção SÓ com 2 pareceres de famílias ≠ Anthropic + hearback humano (G-EXC fiscaliza os 4 sinais). NOTA (onda 0007): o gate de adoção está SATISFEITO no disco (2 pareceres ≠ Fable sem VETO de adoção: NÃO + cerimônia humana de token); o registro FORMAL da baixa (sinal → ADOTADA-NÃO-PRECEDENTE + hearback ADR-023) fica ADIADO para a fase-2 por causa de G-EXC/G-HRB/G-REG — ver readback 0007. NOTA (onda 0009): MANTER 🔴 F-01/PROPOSED; fora do escopo desta emenda. Mantido 🔴 + PROPOSED_UNTIL_CROSS_AUDIT até a fase-2"
  - "🔴 PONTE VETADA — 0034 (Codex) e 0035 (Antigravity) retornaram VETO_ADOCAO: SIM; descongelar só após corrigir bloqueadores"
  - "🟢 SUÍTE 125/125 verde no SANDBOX Linux/Bash 5 nesta linha de trabalho (ver handoff/readback 0011; 0010 tambem verde); Bash 3.2/macOS: VERIFICAÇÃO TERMINAL PENDENTE — número do Terminal só entra aqui com saída colada pelo operador; BATERIA ADVERSARIAL 14/14 burlas BLOQUEADAS no sandbox (guards/tests/adversarial-battery.sh)"
  - "🟢 RUNNER COM 14 GUARDS — onda 0006 ativou G-FAM e G-HRB (modo runner, I-08) e G-EXC (I-09, junto com este sinal); hook commit-msg TOLERANTE instalado (guard ausente no worktree = avisa e libera — C-03a; runbook na tabela v2) chamando G-TOK+G-EXC"
  - "🟢 ESCAPES LACRADOS — CI=true local FAIL (G-CR I-05); bypass env só com nota staged (I-06); G-STRAY v2 fail-closed/maxdepth6/symlink/allowlist (I-07); naming universal incondicional ADR-025 (I-02/I-03); 0036/0037 renomeados para carimbo real (I-04)"
  - "🟢 G-TOK ATIVO, FP `34a7f2f9` — campo bastao_token_sha256 (linha 6) preenchido na CERIMÔNIA DE TOKEN concluída na adoção da onda 0006 (commit `75d2e9d`); o token vive só em .git/hbn-baton-token (segredo NUNCA no histórico) e todo commit local exige trailer HBN-Token-FP: 34a7f2f9 (fingerprint público; state-report-spec §6). Contradição 'HASH PENDENTE/VAZIO' eliminada"
  - "🟡 G-HRB assinatura PENDENTE DE CHAVE — Maurício gera/registra .hbn/operators/<nome>.pub para ativar ssh-keygen -Y verify (ADR-023 D4); sem chave o guard avisa e mantém travas de histórico"
  - "🟡 F-02 (0035 UTC×REGISTRY) NÃO corrigido nesta onda — formato da linha de correção (superseded_by) é decisão do humano (consolidação §F-02)"
  - "🟡 commits I-00..I-07 da branch foram REWORDED (filter-branch, trees intactas) para carregar HBN-Human-Authorization exigido pelo G-EXC — declarado nos corpos de I-00/I-05/I-08 e no relato final; a v2 nasceu de git rebase -i main da v1 com fixes SQUASHADOS nos itens (I-04/I-13/I-12/I-09 amendados; range-diff v1→v2 entregue para re-auditoria; v1 intacta)"
  - "🟡 branch protection no GitHub (hbn-shield obrigatório no push) = ação humana pendente (F-10 backstop)"
  - "🟡 hearback 0002 (exceção fable×opus) DRAFT pendente de assinatura"
  - "🟡 bump 0.3.1 adiado para onda de auditoria __version__×PROTOCOL_VERSION (nota 20260610-34)"
  - "🟡 inbox/credenciamento com 2 propostas não consolidadas (20260610-01-0017-parametrica, 20260610-44-freeze-gate-v206)"
  - "🟡 backlog: F-05 renumeração da faxina 36 antes de H2; F-07 semântica de proprietario_bastao quando próxima ação é humana; gate script do dual-run (0021/F-06); versionamento de .hbn/readbacks/; colisão readback 0002 × hearback 0002; propostas glacier/zona-de-corte/refatoração-árvore em usehbn-entregas/onda-0006 (I-11) aguardando auditoria adversarial"
readback_ativo: ".hbn/readbacks/0011-emenda-plano-exuvia-v2.json"
handoff_mais_recente: ".hbn/messages/20260614-030748-codex-handoff-emenda-plano-exuvia-v2.md"
ancora_rollback: "65b4af0 (HEAD da main — a branch proposta/onda-0006 inteira é descartável sem tocar a main)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "onda 0006 v2 (correções pós-veto 170633/172049); aguarda: (1) re-auditoria do range-diff v1→v2, (2) cherry-picks item a item (tabela v2: hooks → 13 picks -n/-C → cerimônia de token → verificação), (3) chave SSH do operador, (4) decisão F-02"
ultima_atualizacao: "2026-06-14T03:07:48-03:00"
atualizado_por: codex-implementador-exuvia-0011
atribuicao:
  chapeu_atual: implementador
  implementador: codex
  auditores: [gemini-3-5]
  gravada_em: "2026-06-14T03:07:48-03:00"
  hearback_ref: null
---

Nota da onda 0006 (enforcement-sem-exceção, readback 0006): após os vetos
0036/0037 e a consolidação 20260611-131310, Maurício ordenou "corrigir TUDO
em uma única passada... vamos commitando uma a uma". Esta onda implementou,
em branch de proposta (main intocada), TODOS os itens: I-00 readback; I-01
knowledge 0019 + 0022 (firewall — segunda referência quebrada da classe
F-08, achada no censo e autorizada em chat) + read-list viva na suíte; I-02
ADR-025 (nome universal incondicional); I-03 G-NUM incondicional + UTC=BLOCK
+ G-SLF/G-REG/.gitignore; I-04 renomeação 0036/0037; I-05 G-CR lacrado +
.hbn/alt-roots (sandbox autorizado pelo gate); I-06 bypass só com nota
staged; I-07 G-STRAY v2 + suíte robusta; I-08 G-EXC + assinatura SSH no
G-HRB + G-FAM/G-HRB no runner; I-10 rito de entrada checável; I-13 G-TOK
(token de posse do bastão); I-12 bateria adversarial (14/14 BLOQUEADAS);
I-09 este STATE. Contagens REAIS do run de 2026-06-12T11:45:11-03:00 no
sandbox (Linux/Bash 5): suíte 123/123 ('== resumo: 123 passaram, 0
falharam =='); bateria 14/14; runner com 14 guards; 13 commits na branch
(git rev-list --count = 13). Verificação no Terminal do operador (Bash
3.2/macOS) PENDENTE — o número do Terminal entra aqui apenas com a saída
colada por Maurício (C-04). A v2 corrigiu os achados dos pareceres
20260611-170633-codex e 20260611-172049-gemini-3-5 (C-01 Bash 3.2 no
G-TOK; C-02 token fora do histórico; C-03 hook tolerante + cherry-pick -C
+ cerimônia de token após o último pick; C-04 este STATE; C-05 id-global
dos pareceres renomeados). A exceção F-01 (mesmo agente desenha e
implementa) está ATIVA e
RASTREÁVEL: PROPOSED_UNTIL_CROSS_AUDIT até 2 pareceres de famílias ≠
Anthropic + hearback humano. A regra firewall (knowledge 0022) continua
vigente: nenhuma escrita de domínio, VBA, src/ de produto, examples ou
inbox nesta onda.

Nota da onda prévia Exúvia (readback 0010): escreveu apenas a proposta de
protocolo de transição e plano da primeira muda 0.3.x -> 1.0.0. A onda 0011
supersede o plano 0010 com a v2, incorporando parecer Gemini, gate humano e
RADAR. Não houve congelamento, renascimento, tag, baixa de F-01, hearback
formal, edição de guard, edição de src ou movimentação de estrutura. Próximo:
cross-audit Gemini do plano v2; depois ratificação e M2 (execução do corte).
