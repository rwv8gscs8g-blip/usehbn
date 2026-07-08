---
titulo: "Prompt cross-audit - G-COPY autocontido 0115 - Grok"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-173741-codex-prompt-cross-audit-g-copy-autocontido-0115-grok.md
created_at: "2026-07-01T17:37:41-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
destino: grok
resultado_esperado: /Users/macbookpro/Projetos/usehbn/.hbn/results/20260701-174000-grok-cross-ia-g-copy-autocontido-0115.md
---

⟦HBN-COPY dest=grok⟧ BEGIN
SOU: grok · familia xAI · papel auditor

CHAT NOVO, SEM MEMORIA.

OBJETIVO:
Fazer auditoria cruzada independente do readback 0115 e do commit 17ac01bc63d14721107e79466d66b2ea7c59fee8 no repo usehbn. O foco e verificar se o endurecimento de G-COPY e tecnicamente correto, se cobre a falha real de prompt nao-autocontido, e se os achados do relatorio Antigravity exigem refatoracao antes de selagem.

REPO:
/Users/macbookpro/Projetos/usehbn

BRANCH ESPERADA:
proposta/reestruturacao-m-a-s0

HEAD ESPERADO:
17ac01bc63d14721107e79466d66b2ea7c59fee8

DESTINO DO RESULTADO:
/Users/macbookpro/Projetos/usehbn/.hbn/results/20260701-174000-grok-cross-ia-g-copy-autocontido-0115.md

NAO FAZER:
- Nao editar arquivos.
- Nao stagear.
- Nao commitar.
- Nao push.
- Nao usar bypass.
- Nao propor continuidade para P2-D4.
- Nao tratar 0115 como selado.

LEIA NO DISCO:
- /Users/macbookpro/Projetos/usehbn/guards/assert-copy-block.sh
- /Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh
- /Users/macbookpro/Projetos/usehbn/guards/tests/adversarial-battery.sh
- /Users/macbookpro/Projetos/usehbn/.hbn/readbacks/0115-g-copy-autocontido.json
- /Users/macbookpro/Projetos/usehbn/.hbn/knowledge/0032-prompts-autocontidos-output-canonico.md
- /Users/macbookpro/Projetos/usehbn/.hbn/results/20260701-173000-antigravity-cross-ia-g-copy-autocontido-0115.md
- /Users/macbookpro/Projetos/usehbn/REGISTRY.md

PREFLIGHT, UM COMANDO POR VEZ:
COMANDO 1: git -C /Users/macbookpro/Projetos/usehbn rev-parse HEAD
COMANDO 2: git -C /Users/macbookpro/Projetos/usehbn status --short --branch
COMANDO 3: git -C /Users/macbookpro/Projetos/usehbn show --stat --oneline --decorate --no-renames HEAD

VALIDACAO TECNICA, UM COMANDO POR VEZ:
COMANDO 4: cd /Users/macbookpro/Projetos/usehbn && bash guards/hbn-guards-runner.sh
COMANDO 5: cd /Users/macbookpro/Projetos/usehbn && bash guards/tests/run-guard-tests.sh
COMANDO 6: cd /Users/macbookpro/Projetos/usehbn && bash guards/tests/adversarial-battery.sh
COMANDO 7: cd /Users/macbookpro/Projetos/usehbn && .venv/bin/pytest -q

PERGUNTAS DE AUDITORIA:
1. APROVA_0115 deve ser SIM ou NAO como correcao provisoria?
2. O guard em guards/assert-copy-block.sh esta tecnicamente correto?
3. O acoplamento ao caminho local absoluto e BLOQUEADOR, ALTO, MEDIO ou BAIXO?
4. A validacao de destino canonico deveria usar raiz canonica dinamica do repo? Proponha criterio mecanico.
5. O bloqueio literal do arquivo solto de plano gerado por UI e correto ou precisa ser substituido por regra de path permitido?
6. Os testes B93-B96 reproduzem a falha real de orquestracao?
7. Ha falso positivo ou falso negativo relevante?
8. O relatorio Antigravity esta tecnicamente correto?
9. O pacote 0115 deve ser mantido, revertido, ou sucedido por patch de implementador externo?

FORMATO DO RESULTADO:
- Front matter com tipo: audit-result, autor: grok, familia: xAI, path correto, created_at local.
- Linha SOU canonica.
- Veredito em linha propria: APROVA_0115: SIM ou APROVA_0115: NAO.
- Achados ordenados por severidade: BLOQUEADOR, ALTO, MEDIO, BAIXO.
- Evidencia com arquivo e linha quando aplicavel.
- Resultado resumido dos comandos 1 a 7.
- Recomendacao objetiva: manter provisoriamente, refatorar, ou rejeitar.
- Ultima linha:
GROK_AUDIT_G_COPY_AUTOCONTIDO_0115: PRONTO
⟦HBN-COPY END⟧
