---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (bump 0.3.1 adiado — nota 20260610-34)"
onda_atual: "onda-0006 enforcement-sem-excecao — IMPLEMENTADA na branch proposta/onda-0006 (13 commits — git rev-list --count main..proposta/onda-0006 = 13; um por item I-00..I-13; main INTOCADA); cross-audit Codex (170633) + Antigravity (172049) retornou VETO_CHERRY_PICKS; correções C-01..C-06 aplicadas em proposta/onda-0006-v2 (rebase -i declarado, fixes squashados, v1 intacta); aguarda re-auditoria do range-diff e aprovação item a item"
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: claude-fable-5
papel_bastao: "implementador da onda 0006 em branch de PROPOSTA (EXCEÇÃO F-01 autorizada: ordem direta de Maurício 2026-06-11 'corrigir TUDO em uma única passada'; authorization no readback 0006)"
papeis:
  arquiteto: "claude-fable-5 — desenhou (consolidação 20260611-131310/131311) e implementou por exceção autorizada; PROPOSED_UNTIL_CROSS_AUDIT"
  auditor_validador_fixo: "claude-opus-4-8 (Cowork) — validador fixo EM PROSA; fora do campo mecânico `auditores` até o hearback 0002 ser confirmado"
  gate_humano: "Maurício — aprova item a item: cd ~/Projetos/usehbn && git cherry-pick -n <sha> && git commit -C <sha> (preserva AUTOR+mensagem+trailers e roda os hooks — correção C-03b dos pareceres 170633/172049; tabela de aprovação v2)"
proxima_acao: "Maurício: re-auditoria do range-diff v1→v2 pelos auditores e aprovação item a item pela tabela v2 (instalar hooks → 13 picks com -n + commit -C → cerimônia de token → verificação)"
sinais_abertos:
  - "🔴 EXCEÇÃO F-01 ATIVA (onda 0006) — desenhista=implementador=claude-fable-5 por ordem direta de Maurício; estado PROPOSED_UNTIL_CROSS_AUDIT: adoção SÓ com 2 pareceres de famílias ≠ Anthropic + hearback humano (G-EXC fiscaliza os 4 sinais)"
  - "🔴 PONTE VETADA — 0034 (Codex) e 0035 (Antigravity) retornaram VETO_ADOCAO: SIM; descongelar só após corrigir bloqueadores"
  - "🟢 SUÍTE 123/123 verde no SANDBOX Linux/Bash 5 (run 2026-06-12T11:45:11-03:00, saída colada na tabela v2: '== resumo: 123 passaram, 0 falharam =='); Bash 3.2/macOS: VERIFICAÇÃO TERMINAL PENDENTE — número do Terminal só entra aqui com saída colada pelo operador (C-04 dos pareceres 170633/172049); BATERIA ADVERSARIAL 14/14 burlas BLOQUEADAS no sandbox (guards/tests/adversarial-battery.sh)"
  - "🟢 RUNNER COM 14 GUARDS — onda 0006 ativou G-FAM e G-HRB (modo runner, I-08) e G-EXC (I-09, junto com este sinal); hook commit-msg TOLERANTE instalado (guard ausente no worktree = avisa e libera — C-03a; runbook na tabela v2) chamando G-TOK+G-EXC"
  - "🟢 ESCAPES LACRADOS — CI=true local FAIL (G-CR I-05); bypass env só com nota staged (I-06); G-STRAY v2 fail-closed/maxdepth6/symlink/allowlist (I-07); naming universal incondicional ADR-025 (I-02/I-03); 0036/0037 renomeados para carimbo real (I-04)"
  - "🟡 G-TOK v2 instalado, HASH PENDENTE — campo bastao_token_sha256 acima está VAZIO de propósito (rampa); na CERIMÔNIA DE TOKEN (APÓS o último cherry-pick I-09 — ordem corrigida pelo C-03c, deadlock apontado pelo parecer 172049), Maurício roda o comando único da tabela v2: gera o token em .git/hbn-baton-token (segredo NUNCA no histórico), grava o sha256 no campo e commita com trailer HBN-Token-FP (fingerprint público; state-report-spec §6)"
  - "🟡 G-HRB assinatura PENDENTE DE CHAVE — Maurício gera/registra .hbn/operators/<nome>.pub para ativar ssh-keygen -Y verify (ADR-023 D4); sem chave o guard avisa e mantém travas de histórico"
  - "🟡 F-02 (0035 UTC×REGISTRY) NÃO corrigido nesta onda — formato da linha de correção (superseded_by) é decisão do humano (consolidação §F-02)"
  - "🟡 commits I-00..I-07 da branch foram REWORDED (filter-branch, trees intactas) para carregar HBN-Human-Authorization exigido pelo G-EXC — declarado nos corpos de I-00/I-05/I-08 e no relato final; a v2 nasceu de git rebase -i main da v1 com fixes SQUASHADOS nos itens (I-04/I-13/I-12/I-09 amendados; range-diff v1→v2 entregue para re-auditoria; v1 intacta)"
  - "🟡 branch protection no GitHub (hbn-shield obrigatório no push) = ação humana pendente (F-10 backstop)"
  - "🟡 hearback 0002 (exceção fable×opus) DRAFT pendente de assinatura"
  - "🟡 bump 0.3.1 adiado para onda de auditoria __version__×PROTOCOL_VERSION (nota 20260610-34)"
  - "🟡 inbox/credenciamento com 2 propostas não consolidadas (20260610-01-0017-parametrica, 20260610-44-freeze-gate-v206)"
  - "🟡 backlog: F-05 renumeração da faxina 36 antes de H2; F-07 semântica de proprietario_bastao quando próxima ação é humana; gate script do dual-run (0021/F-06); versionamento de .hbn/readbacks/; colisão readback 0002 × hearback 0002; propostas glacier/zona-de-corte/refatoração-árvore em usehbn-entregas/onda-0006 (I-11) aguardando auditoria adversarial"
readback_ativo: ".hbn/readbacks/0006-onda-enforcement-sem-excecao.json (onda 0006 — human_status confirmed por ordem direta; PROPOSED_UNTIL_CROSS_AUDIT)"
handoff_mais_recente: ".hbn/messages/20260610-205910-fable-5-handoff-guards-orquestracao-start.md"
ancora_rollback: "65b4af0 (HEAD da main — a branch proposta/onda-0006 inteira é descartável sem tocar a main)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "onda 0006 v2 (correções pós-veto 170633/172049); aguarda: (1) re-auditoria do range-diff v1→v2, (2) cherry-picks item a item (tabela v2: hooks → 13 picks -n/-C → cerimônia de token → verificação), (3) chave SSH do operador, (4) decisão F-02"
ultima_atualizacao: "2026-06-12T11:45:11-03:00"
atualizado_por: claude-fable-5-corretor-0006-v2
atribuicao:
  chapeu_atual: implementador
  implementador: claude-fable-5
  auditores: [codex, gemini-3-5]
  gravada_em: "2026-06-11T16:22:10-03:00"
  hearback_ref: ".hbn/readbacks/0006-onda-enforcement-sem-excecao.json"
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

Nota de continuidade: a ponte usehbn⇄Credenciamento permanece VETADA
(0034/0035) e fora do escopo; propostas glacier/zona-de-corte/refatoração
da árvore (I-11) estão FORA do repo em
~/Projetos/usehbn-entregas/onda-0006/ — são propostas para auditoria
adversarial, não execução.
