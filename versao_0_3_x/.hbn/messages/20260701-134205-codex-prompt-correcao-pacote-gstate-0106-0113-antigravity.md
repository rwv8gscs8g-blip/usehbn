---
titulo: "Prompt de correcao - pacote G-STATE 0106/0113 - Antigravity"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-134205-codex-prompt-correcao-pacote-gstate-0106-0113-antigravity.md
created_at: "2026-07-01T13:42:05-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
destino: antigravity
resultado_esperado: .hbn/messages/20260701-134205-antigravity-handoff-correcao-pacote-gstate-0106-0113.md
---

⟦HBN-COPY dest=antigravity⟧ BEGIN
SOU: antigravity - familia Google - papel implementador

CHAT NOVO, SEM MEMORIA.

OBJETIVO:
Corrigir a embalagem do pacote G-STATE 0106/0113 que voce deixou staged. Nao e uma nova implementacao. O foco e deixar o indice selavel: diff-check limpo, REGISTRY curado, manifesto/readback coerentes com o pacote real, handoff completo e validacoes rerodadas.

REPO:
/Users/macbookpro/Projetos/usehbn

HEAD ESPERADO:
f8dbe09086d06f5dc42527241c33e37174a65427

NAO FAZER:
- Nao commite.
- Nao use --no-verify.
- Nao use git add -A.
- Nao toque .hbn/relay/STATE.md.
- Nao toque docs/brainstorm/**.
- Nao toque .hbn/logs/**.
- Nao toque .hbn/state/**.
- Nao toque .hbn/models/**.
- Nao apague residuos.
- Nao inicie 0109-G-ORQ-XAUDIT-GATE.
- Nao emita prompt de auditoria.

LEIA ANTES:
- .hbn/messages/20260701-101750-codex-prompt-implementacao-rito-gstate-0106-0113-antigravity.md
- .hbn/messages/20260701-101750-antigravity-handoff-rito-gstate-0106-0113.md
- .hbn/readbacks/0106-g-state-structural.json
- .hbn/readbacks/0113-selagem-g-state.json
- .hbn/messages/20260701-091112-codex-manifesto-selagem-g-state-0112.md
- .hbn/relay/RETURN.json
- REGISTRY.md

DIAGNOSTICO DO ORQUESTRADOR:
1. Voce criou os readbacks 0106/0113 e o runner passou.
2. O indice atual ainda nao e selavel.
3. git diff --cached --check falha por:
   - trailing whitespace em guards/assert-state-structural.sh linhas 162, 167, 171, 178, 184, 188, 195, 208.
   - blank line extra no EOF de .hbn/messages/20260701-091112-codex-manifesto-selagem-g-state-0112.md.
   - blank line extra no EOF de REGISTRY.md.
4. REGISTRY.md staged inclui linhas fora do pacote 0112: ponte/exuvia, prompt v1, handoffs gerais e artefatos nao staged.
5. O handoff salvo tem so resumo, nao lista comandos 1 a 10 e nao termina com ANTIGRAVITY_RITO_GSTATE_0106_0113: PRONTO.
6. O pacote real inclui tres correcoes mecanicas extras em guards/assert-parallel-id.sh, guards/assert-quorum-selagem.sh e guards/assert-report-fresh.sh. Se elas forem necessarias para o pacote passar em CI, ratifique explicitamente essa ampliacao no manifesto 0112, no readback 0113 e no REGISTRY. Se nao conseguir justificar, pare e explique.

ARQUIVOS QUE VOCE PODE TOCAR:
- guards/assert-state-structural.sh
- guards/assert-parallel-id.sh
- guards/assert-quorum-selagem.sh
- guards/assert-report-fresh.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/readbacks/0106-g-state-structural.json
- .hbn/readbacks/0113-selagem-g-state.json
- .hbn/messages/20260701-091112-codex-manifesto-selagem-g-state-0112.md
- .hbn/messages/20260701-101750-antigravity-handoff-rito-gstate-0106-0113.md
- .hbn/messages/20260701-134205-antigravity-handoff-correcao-pacote-gstate-0106-0113.md
- .hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
- .hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
- .hbn/knowledge/INDEX.md
- .hbn/messages/20260630-223300-codex-prompt-cross-audit-g-state-structural-0106-grok-v2.md
- .hbn/messages/20260701-083300-codex-prompt-cross-audit-g-state-structural-0106-claude-v2.md
- .hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md
- .hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md
- REGISTRY.md

CORRIGIR AGORA:
1. Remover trailing whitespace e blank line extra ate git diff --cached --check ficar limpo.
2. Recurar REGISTRY.md. O staged final de REGISTRY deve conter somente linhas correspondentes ao pacote staged final. Remova do hunk staged linhas de ponte/exuvia, prompt v1, handoffs gerais, prompt 101750 do Codex se o arquivo nao estiver staged, resultado Claude 0114 se o arquivo nao estiver staged, e qualquer linha cujo arquivo nao esteja no pacote final.
3. Se voce mantiver guards/assert-parallel-id.sh, guards/assert-quorum-selagem.sh e guards/assert-report-fresh.sh no pacote, acrescente no manifesto 0112 uma secao "Ampliacao mecanica de escopo" explicando que essas alteracoes sao prerequisitos mecanicos para o pacote G-STATE 0106/0113 passar com results v2, alias claude e prompts/manifestos staged. Atualize tambem o files_allowed do readback 0113 e as linhas correspondentes no REGISTRY.
4. Completar .hbn/messages/20260701-101750-antigravity-handoff-rito-gstate-0106-0113.md ou criar o novo handoff de correcao no destino abaixo. Ele deve listar comandos 1 a 10, arquivos tocados, diff --cached --name-only final, e terminar com a linha exata ANTIGRAVITY_RITO_GSTATE_0106_0113: PRONTO.
5. Preservar STATE fora do indice.
6. Deixar o indice staged pronto para selagem, mas sem commit.

COMANDOS OBRIGATORIOS, UM POR VEZ:
COMANDO 1: git -C /Users/macbookpro/Projetos/usehbn rev-parse HEAD
COMANDO 2: git -C /Users/macbookpro/Projetos/usehbn status --short
COMANDO 3: git -C /Users/macbookpro/Projetos/usehbn diff --cached --name-only
COMANDO 4: git -C /Users/macbookpro/Projetos/usehbn diff --cached --check
COMANDO 5: git -C /Users/macbookpro/Projetos/usehbn diff --name-only -- .hbn/relay/STATE.md
COMANDO 6: bash guards/hbn-guards-runner.sh
COMANDO 7: bash guards/tests/run-guard-tests.sh
COMANDO 8: bash guards/tests/adversarial-battery.sh
COMANDO 9: .venv/bin/pytest -q
COMANDO 10: git -C /Users/macbookpro/Projetos/usehbn diff --cached --name-only

CRITERIO DE PRONTO:
- COMANDO 4 retorna zero.
- COMANDO 5 nao mostra STATE.
- Runner verde.
- Suite verde.
- Bateria verde.
- Pytest verde ou falha ambiental explicitamente explicada.
- REGISTRY staged nao inclui linhas fora do pacote final.
- Handoff salvo no destino abaixo e termina com ANTIGRAVITY_RITO_GSTATE_0106_0113: PRONTO.
- Nenhum commit criado.

DESTINO DO HANDOFF:
.hbn/messages/20260701-134205-antigravity-handoff-correcao-pacote-gstate-0106-0113.md

ULTIMA LINHA DO HANDOFF:
ANTIGRAVITY_RITO_GSTATE_0106_0113: PRONTO
⟦HBN-COPY END⟧
