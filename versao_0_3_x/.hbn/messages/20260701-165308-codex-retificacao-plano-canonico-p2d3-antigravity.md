---
titulo: "Retificacao - plano canonico e execucao P2-D3 tombstone - Antigravity"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-165308-codex-retificacao-plano-canonico-p2d3-antigravity.md
created_at: "2026-07-01T16:53:08-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
destino: antigravity
relacionado_a:
  - .hbn/messages/20260701-163300-codex-prompt-p2d3-tombstone-credenciamento-antigravity.md
  - .hbn/messages/20260701-164436-codex-autorizacao-execucao-p2d3-tombstone-antigravity.md
resultado_esperado:
  - /Users/macbookpro/Projetos/Credenciamento/.hbn/messages/20260701-164100-antigravity-plan-p2d3-tombstone-usehbn.md
  - /Users/macbookpro/Projetos/Credenciamento/.hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md
---

⟦HBN-COPY dest=antigravity⟧ BEGIN
SOU: codex · familia OpenAI · papel orquestrador-provisorio

RETIFICACAO DE FORMA + AUTORIZACAO CONTROLADA:
Mauricio revisou o Implementation Plan apresentado na interface e apontou uma falha de orquestracao: o plano nao foi materializado em path canonico do repo. Corrija isso antes de executar.

PLANO APROVADO:
O plano P2-D3 apresentado esta aprovado quanto ao escopo: criar readback 0184, criar usehbn/TOMBSTONE.md, remover do Git usehbn/methodology/** e usehbn/modules/**, criar handoff, validar, sem commit e sem push.

REPO ALVO:
/Users/macbookpro/Projetos/Credenciamento

HEAD ESPERADO:
eb3f2850b8beb03aa50ddbe9143e4f00341d051e

PATH CANONICO OBRIGATORIO DO PLANO:
/Users/macbookpro/Projetos/Credenciamento/.hbn/messages/20260701-164100-antigravity-plan-p2d3-tombstone-usehbn.md

PATH CANONICO OBRIGATORIO DO HANDOFF:
/Users/macbookpro/Projetos/Credenciamento/.hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md

REGRA CORRIGIDA PARA ESTE CICLO:
- Nao criar implementation_plan.md na raiz do repo.
- Nao criar plano em path solto, temporario ou invisivel ao disco canonico.
- O plano apresentado na interface deve ser salvo no PATH CANONICO OBRIGATORIO DO PLANO acima.
- Se implementation_plan.md existir em qualquer ponto dentro de /Users/macbookpro/Projetos/Credenciamento, ele e residuo de UI e nao pode ser stageado. Mova o conteudo relevante para o path canonico e remova o residuo antes de validar; se nao conseguir remover, pare e reporte.

AJUSTE O READBACK 0184:
Ao criar .hbn/readbacks/0184-rb-p2d3-tombstone-usehbn.json, inclua tambem em scope.files_allowed:
- .hbn/messages/20260701-164100-antigravity-plan-p2d3-tombstone-usehbn.md
- .hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md

ESCOPO APROVADO:
- .hbn/readbacks/0184-rb-p2d3-tombstone-usehbn.json
- .hbn/messages/20260701-164100-antigravity-plan-p2d3-tombstone-usehbn.md
- .hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md
- usehbn/TOMBSTONE.md
- remocoes Git de usehbn/methodology/**
- remocoes Git de usehbn/modules/**

EXECUTE AGORA, COMANDOS UM POR VEZ:
COMANDO A: git -C /Users/macbookpro/Projetos/Credenciamento status --short --branch
COMANDO B: git -C /Users/macbookpro/Projetos/Credenciamento rev-parse HEAD
COMANDO C: find /Users/macbookpro/Projetos/Credenciamento -maxdepth 4 -name implementation_plan.md -type f

SE A, B, C ESTIVEREM OK:
1. Salvar o plano aprovado no path canonico do plano.
2. Criar o readback 0184 com o scope corrigido.
3. Criar usehbn/TOMBSTONE.md.
4. Aplicar git rm escopado nos arquivos versionados sob usehbn/methodology/** e usehbn/modules/**.
5. Criar o handoff no path canonico do handoff.
6. Stagear somente o escopo aprovado.
7. Rodar a validacao do prompt original, comandos 6 a 11.

VALIDACAO FINAL OBRIGATORIA:
- git -C /Users/macbookpro/Projetos/Credenciamento diff --cached --name-status
- git -C /Users/macbookpro/Projetos/Credenciamento diff --cached --check
- git -C /Users/macbookpro/Projetos/Credenciamento ls-files usehbn
- bash /Users/macbookpro/Projetos/Credenciamento/scripts/hbn-guards/validate-readback.sh /Users/macbookpro/Projetos/Credenciamento/.hbn/readbacks/0184-rb-p2d3-tombstone-usehbn.json
- cd /Users/macbookpro/Projetos/Credenciamento && bash scripts/hbn-guards/hbn-guards-runner.sh
- git -C /Users/macbookpro/Projetos/Credenciamento status --short

NAO FAZER:
- Nao commite.
- Nao push.
- Nao use --no-verify.
- Nao use git add -A.
- Nao use HBN_GUARDS_BYPASS.
- Nao toque .usehbn-snapshot/**.
- Nao toque AGENTS.md.
- Nao toque docs/reference/**.
- Nao toque codigo de dominio, VBA, workbook, scripts ou backups.
- Nao inicie P2-D4 nem P2-D5.

CRITERIO DE PRONTO:
- Plano canonico salvo em .hbn/messages/20260701-164100-antigravity-plan-p2d3-tombstone-usehbn.md.
- Readback 0184 inclui o plano canonico e o handoff em scope.files_allowed.
- git ls-files usehbn mostra somente usehbn/TOMBSTONE.md.
- diff staged contem somente o escopo aprovado.
- validate-readback verde.
- hbn-guards-runner verde ou bloqueio explicado sem bypass.
- Nenhum commit criado.
- Nenhum push feito.

Ultima linha do handoff:
ANTIGRAVITY_P2D3_TOMBSTONE_USEHBN: PRONTO
⟦HBN-COPY END⟧
