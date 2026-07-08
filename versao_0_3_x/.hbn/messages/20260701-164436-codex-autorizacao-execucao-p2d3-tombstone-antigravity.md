---
titulo: "Autorizacao de execucao - P2-D3 tombstone Credenciamento - Antigravity"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-164436-codex-autorizacao-execucao-p2d3-tombstone-antigravity.md
created_at: "2026-07-01T16:44:36-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
destino: antigravity
relacionado_a: .hbn/messages/20260701-163300-codex-prompt-p2d3-tombstone-credenciamento-antigravity.md
resultado_esperado: /Users/macbookpro/Projetos/Credenciamento/.hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md
---

⟦HBN-COPY dest=antigravity⟧ BEGIN
SOU: codex · familia OpenAI · papel orquestrador-provisorio

AUTORIZACAO CONTROLADA:
Mauricio autorizou avancar na execucao do plano P2-D3 tombstone controlado do espelho usehbn/ no repo Credenciamento.

CONTINUE A PARTIR DO SEU PLANO, MAS MANTENHA O ESCOPO DO PROMPT ORIGINAL:
/Users/macbookpro/Projetos/usehbn/.hbn/messages/20260701-163300-codex-prompt-p2d3-tombstone-credenciamento-antigravity.md

REPO ALVO:
/Users/macbookpro/Projetos/Credenciamento

HEAD ESPERADO:
eb3f2850b8beb03aa50ddbe9143e4f00341d051e

CORRECAO OBRIGATORIA SOBRE implementation_plan.md:
- implementation_plan.md nao e artefato permitido do patch P2-D3.
- Se implementation_plan.md existir dentro de /Users/macbookpro/Projetos/Credenciamento, trate como rascunho efemero.
- Nao stagear implementation_plan.md.
- Nao incluir implementation_plan.md no handoff como arquivo tocado.
- O conteudo relevante do plano deve aparecer somente no handoff final em .hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md.
- Se implementation_plan.md aparecer em git status --short ao final, pare e reporte; nao commite.

EXECUTE SOMENTE:
1. Criar .hbn/readbacks/0184-rb-p2d3-tombstone-usehbn.json.
2. Criar usehbn/TOMBSTONE.md.
3. Remover do Git, via git rm escopado, os arquivos versionados sob usehbn/methodology/** e usehbn/modules/**.
4. Criar o handoff em .hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md.
5. Stagear somente readback 0184, TOMBSTONE, remocoes dos dois diretorios e handoff.
6. Rodar os comandos 6 a 11 do prompt original.

NAO FAZER:
- Nao commite.
- Nao push.
- Nao use --no-verify.
- Nao use git add -A.
- Nao use HBN_GUARDS_BYPASS.
- Nao toque .usehbn-snapshot/**.
- Nao inicie P2-D4 nem P2-D5.
- Nao toque codigo de dominio, VBA, workbook, scripts, backups, AGENTS.md ou docs/reference/**.

CRITERIO DE PRONTO:
- git diff --cached --name-status mostra somente o pacote P2-D3 permitido.
- git ls-files usehbn mostra somente usehbn/TOMBSTONE.md.
- validate-readback 0184 verde.
- hbn-guards-runner verde ou bloqueio explicado sem bypass.
- Nenhum commit criado.

Ultima linha do handoff:
ANTIGRAVITY_P2D3_TOMBSTONE_USEHBN: PRONTO
⟦HBN-COPY END⟧
