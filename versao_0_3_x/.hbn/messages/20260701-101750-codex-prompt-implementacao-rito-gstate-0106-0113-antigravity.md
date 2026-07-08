---
titulo: "Prompt de implementacao - rito corrigido G-STATE 0106/0113 - Antigravity"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-101750-codex-prompt-implementacao-rito-gstate-0106-0113-antigravity.md
created_at: "2026-07-01T10:17:50-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
destino: antigravity
resultado_esperado: .hbn/messages/20260701-101750-antigravity-handoff-rito-gstate-0106-0113.md
---

⟦HBN-COPY dest=antigravity⟧ BEGIN
SOU: antigravity · familia Google · papel implementador

CHAT NOVO, SEM MEMORIA.

OBJETIVO:
Implementar a Onda A recomendada pela analise Claude 0114: corrigir o rito de selagem de G-STATE criando os readbacks 0106 e 0113, sem bypass, sem tocar STATE e sem iniciar G-ORQ-XAUDIT-GATE 0109.

REPO:
/Users/macbookpro/Projetos/usehbn

HEAD ESPERADO:
f8dbe09086d06f5dc42527241c33e37174a65427

PAPEL:
Voce e o implementador externo preferencial, familia Google. Voce implementa o pacote minimo e salva handoff. Voce nao audita o proprio trabalho.

NAO FAZER:
- Nao commite.
- Nao use --no-verify.
- Nao use git add -A.
- Nao toque .hbn/relay/STATE.md.
- Nao toque docs/brainstorm/**.
- Nao toque .hbn/logs/**.
- Nao toque .hbn/state/**.
- Nao toque .hbn/models/**.
- Nao toque guards/tests/hbn-repro-*.
- Nao inclua RETURN.json.
- Nao inicie 0109-G-ORQ-XAUDIT-GATE.
- Nao emita prompt de auditoria.

LEIA ANTES DE AGIR:
- AGENTS.md
- core/role-cards.md
- agents/codex.md
- agents/wave-protocol.md
- core/orchestrator-profile-spec.md
- .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md
- .hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
- .hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
- .hbn/messages/20260701-091112-codex-manifesto-selagem-g-state-0112.md
- .hbn/results/20260701-092612-claude-opus-analise-profunda-guards-orquestrador-0114.md
- docs/brainstorm/rodada-2026-06-17/HARNESS-workflows-loops-skills-analise-e-plano.md
- guards/assert-scope-lock.sh
- guards/assert-state-structural.sh
- guards/assert-audit-diversity.sh
- guards/assert-quorum-selagem.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- REGISTRY.md

PREFLIGHT, UM COMANDO POR VEZ:
COMANDO 1: git -C /Users/macbookpro/Projetos/usehbn rev-parse HEAD
COMANDO 2: git -C /Users/macbookpro/Projetos/usehbn status --short
COMANDO 3: git -C /Users/macbookpro/Projetos/usehbn diff --cached --name-only
COMANDO 4: git -C /Users/macbookpro/Projetos/usehbn diff --check

SE O PREFLIGHT MOSTRAR HEAD DIFERENTE OU INDICE JA STAGED:
Pare, salve handoff bloqueado no destino abaixo e explique. Nao tente corrigir por conta propria.

CONTEXTO TECNICO:
A tentativa de selagem G-STATE conforme manifesto 0112 foi bloqueada corretamente por G-SCOPE porque o readback ativo 0105 proibe guards/**. A analise Claude 0114 apontou outro bloqueador: a selagem inclui results cross-ia 0106, mas ainda nao existe .hbn/readbacks/0106-*.json; assim G-DIVERSITY falharia fechado. A correcao e criar dois readbacks sem tocar STATE:
1. 0106-g-state-structural.json como readback da feature G-STATE, implementador antigravity.
2. 0113-selagem-g-state.json como readback de selagem, status vigente, seals_proposal 0106, liberando o pacote exato.

ARQUIVOS PERMITIDOS:
- .hbn/readbacks/0106-g-state-structural.json
- .hbn/readbacks/0113-selagem-g-state.json
- .hbn/messages/20260701-091112-codex-manifesto-selagem-g-state-0112.md
- .hbn/messages/20260701-101750-antigravity-handoff-rito-gstate-0106-0113.md
- REGISTRY.md

ARQUIVOS QUE PODEM SER STAGED COMO PARTE DO PACOTE G-STATE SE JA EXISTIREM NO WORKTREE:
- guards/assert-state-structural.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
- .hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
- .hbn/knowledge/INDEX.md
- .hbn/messages/20260630-223300-codex-prompt-cross-audit-g-state-structural-0106-grok-v2.md
- .hbn/messages/20260701-083300-codex-prompt-cross-audit-g-state-structural-0106-claude-v2.md
- .hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md
- .hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md

ARQUIVOS PROIBIDOS:
- .hbn/relay/STATE.md
- .hbn/relay/RETURN.json
- docs/brainstorm/**
- .hbn/logs/**
- .hbn/state/**
- .hbn/models/**
- .hbn/results/** fora dos dois results v2 listados acima
- .hbn/messages/** fora dos prompts v2, manifesto 0112 e seu handoff
- guards/tests/hbn-repro-*
- src/**
- core/**
- methodology/**
- schemas/**
- scripts/**
- repo Credenciamento

IMPLEMENTACAO:
1. Criar .hbn/readbacks/0106-g-state-structural.json.
   Campos minimos: readback_id 0106-g-state-structural; execution_id g-state-structural-0106; agent_id antigravity; implementador_id antigravity; track safe_track; status entregue; hearback_status confirmed; human_status confirmed; path correto; understanding explicando G-STATE; authorization com humano Mauricio e evidencia do gate; scope.files_allowed com os 4 arquivos do patch G-STATE; scope.files_forbidden preservando STATE, docs/brainstorm, .hbn/logs, .hbn/state, .hbn/models, src, core, methodology, schemas e Credenciamento; HBN-Readback 0106; HBN-Human-Authorization Mauricio; HBN-Token-FP 34a7f2f9; created_at local; protocol_version 0.3.0.
2. Criar .hbn/readbacks/0113-selagem-g-state.json.
   Campos minimos: readback_id 0113-selagem-g-state; execution_id selagem-g-state-0113; agent_id codex; implementador_id antigravity; track safe_track; status vigente; seals_proposal 0106; hearback_status confirmed; human_status confirmed; path correto; orq_entrada_ref .hbn/attestations/34a7f2f9-orq-entrada.json; understanding explicando que sela G-STATE sem tocar STATE; authorization com humano Mauricio e evidencia do gate; scope.files_allowed contendo exatamente o pacote permitido; scope.files_forbidden contendo todos os proibidos; HBN-Readback 0113; HBN-Human-Authorization Mauricio; HBN-Token-FP 34a7f2f9; created_at local; protocol_version 0.3.0.
3. Atualizar o manifesto 0112 para registrar a correcao da analise Claude 0114: a selagem exige 0106 feature e 0113 selagem; sem 0106 G-DIVERSITY falha. Nao remova historico.
4. Atualizar REGISTRY.md com linhas para 0106, 0113, o resultado Claude 0114 se ainda nao estiver registrado, e o handoff Antigravity.
5. Nao altere os arquivos de guard existentes salvo se algum teste falhar por erro mecanico diretamente relacionado ao rito 0106/0113. Se alterar, explique no handoff.
6. Preparar staging seletivo somente do pacote permitido. Use interativo se necessario para REGISTRY.md. Nunca stagear REGISTRY inteiro se houver linhas fora do pacote.
7. Rodar os comandos de validacao um por vez.

VALIDACAO, UM COMANDO POR VEZ:
COMANDO 5: git -C /Users/macbookpro/Projetos/usehbn diff --check
COMANDO 6: bash guards/hbn-guards-runner.sh
COMANDO 7: bash guards/tests/run-guard-tests.sh
COMANDO 8: bash guards/tests/adversarial-battery.sh
COMANDO 9: .venv/bin/pytest -q
COMANDO 10: git -C /Users/macbookpro/Projetos/usehbn diff --cached --name-only

CRITERIO DE PRONTO:
- Os dois readbacks existem.
- STATE nao foi modificado nem staged.
- REGISTRY nao carrega linhas fora do pacote se houver staging.
- G-SCOPE passa com 0113 como readback de selagem.
- G-DIVERSITY nao bloqueia por readback 0106 ausente.
- Runner verde.
- Suite verde.
- Bateria verde.
- Pytest verde ou falha ambiental explicitamente explicada.
- Handoff salvo no destino canonico abaixo.
- Nenhum commit criado.

DESTINO DO HANDOFF:
Salve em:
.hbn/messages/20260701-101750-antigravity-handoff-rito-gstate-0106-0113.md

FORMATO DO HANDOFF:
- Front matter com tipo: handoff, autor: antigravity, familia: Google, path correto, created_at local.
- Linha SOU.
- Resumo do que foi criado.
- Lista exata de arquivos tocados.
- Saida resumida dos comandos 1 a 10.
- Se houve staging, liste exatamente o resultado de diff --cached --name-only.
- Se algum guard bloqueou, explique o guard e pare.
- Ultima linha:
ANTIGRAVITY_RITO_GSTATE_0106_0113: PRONTO
⟦HBN-COPY END⟧
