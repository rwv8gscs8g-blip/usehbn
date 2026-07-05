---
titulo: "Prompt cross-audit - auditoria de rito do orquestrador - Claude"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-173742-codex-prompt-cross-audit-orquestrador-saneamento-0115-claude.md
created_at: "2026-07-01T17:37:42-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
destino: claude
resultado_esperado: /Users/macbookpro/Projetos/usehbn/.hbn/results/20260701-174500-claude-cross-ia-orquestrador-saneamento-0115.md
---

⟦HBN-COPY dest=claude⟧ BEGIN
SOU: claude · familia Anthropic · papel auditor

CHAT NOVO, SEM MEMORIA.

OBJETIVO:
Auditar o rito de orquestracao ocorrido no saneamento do protocolo usehbn ate o HEAD 17ac01bc63d14721107e79466d66b2ea7c59fee8. O objetivo nao e implementar; e diagnosticar violacoes do papel de orquestrador, falhas de handoff, falhas de contexto, excesso de artefatos soltos e propor mecanismos definitivos que impeçam repeticao por novos orquestradores.

REPO:
/Users/macbookpro/Projetos/usehbn

BRANCH ESPERADA:
proposta/reestruturacao-m-a-s0

HEAD ESPERADO:
17ac01bc63d14721107e79466d66b2ea7c59fee8

DESTINO DO RESULTADO:
/Users/macbookpro/Projetos/usehbn/.hbn/results/20260701-174500-claude-cross-ia-orquestrador-saneamento-0115.md

NAO FAZER:
- Nao editar arquivos.
- Nao stagear.
- Nao commitar.
- Nao push.
- Nao usar bypass.
- Nao propor P2-D4 sem antes fechar o saneamento de orquestracao.
- Nao assumir que orientacao textual basta; priorize regra mecanica, guard, ou gate humano verificavel.

CONTEXTO MINIMO:
- O projeto Credenciamento esta limpo e sincronizado no commit 0f4819c32dc01dcebd14a78eb4e5f124d4e7dd74, com P2-D3 fechado.
- O repo usehbn esta no commit 17ac01bc63d14721107e79466d66b2ea7c59fee8.
- O commit 0115 foi implementado por Codex, que estava exercendo papel de orquestrador. Isso violou segregacao de funcoes.
- Antigravity auditou 0115 e registrou APROVA_0115: SIM tecnico provisorio, com achados de portabilidade e rito.
- Ha muitos artefatos untracked historicos em .hbn/messages, .hbn/results, docs/brainstorm, .hbn/logs e .hbn/state. A limpeza sem classificacao pode destruir evidencia.
- O usuario apontou falha recorrente de transicao de contexto: novos chats gastam contexto sem decisao, prompts pouco autocontidos, implementadores sem destino claro e orquestrador tomando acoes fora do papel.

LEIA NO DISCO:
- /Users/macbookpro/Projetos/usehbn/.hbn/relay/STATE.md
- /Users/macbookpro/Projetos/usehbn/core/role-cards.md
- /Users/macbookpro/Projetos/usehbn/guards/assert-copy-block.sh
- /Users/macbookpro/Projetos/usehbn/.hbn/readbacks/0115-g-copy-autocontido.json
- /Users/macbookpro/Projetos/usehbn/.hbn/results/20260701-173000-antigravity-cross-ia-g-copy-autocontido-0115.md
- /Users/macbookpro/Projetos/usehbn/.hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
- /Users/macbookpro/Projetos/usehbn/.hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
- /Users/macbookpro/Projetos/usehbn/.hbn/knowledge/0032-prompts-autocontidos-output-canonico.md
- /Users/macbookpro/Projetos/usehbn/REGISTRY.md

PREFLIGHT, UM COMANDO POR VEZ:
COMANDO 1: git -C /Users/macbookpro/Projetos/usehbn rev-parse HEAD
COMANDO 2: git -C /Users/macbookpro/Projetos/usehbn status --short --branch
COMANDO 3: git -C /Users/macbookpro/Projetos/Credenciamento status --short --branch

INVENTARIO, UM COMANDO POR VEZ:
COMANDO 4: find /Users/macbookpro/Projetos/usehbn/.hbn/messages -maxdepth 1 -type f | wc -l
COMANDO 5: find /Users/macbookpro/Projetos/usehbn/.hbn/results -maxdepth 1 -type f | wc -l
COMANDO 6: find /Users/macbookpro/Projetos/usehbn/.hbn/logs -maxdepth 2 -type f | wc -l
COMANDO 7: find /Users/macbookpro/Projetos/usehbn/.hbn/state -maxdepth 2 -type f | wc -l

PERGUNTAS DE AUDITORIA:
1. Quais regras de orquestrador foram violadas por Codex nesta sessao?
2. Quais violacoes devem ser BLOQUEADORAS para qualquer novo orquestrador?
3. Como impedir mecanicamente que orquestrador implemente codigo quando o papel atual e despacho, validacao e controle?
4. Qual guard, readback ou gate humano deve existir para separar orquestrador, implementador e auditor?
5. Como aplicar regra de 50 por cento de contexto de modo verificavel e util para transicao perfeita de chat?
6. Como transformar licoes aprendidas em canal canonico para o projeto Credenciamento via membrana, sem gerar teatro ou complexidade inutil?
7. Como classificar residuos untracked entre lixo de teste, evidencia canonica, zona livre e material a arquivar?
8. Qual e o menor plano seguro para voltar ao desenvolvimento do Credenciamento sem enfraquecer o protocolo?
9. O 0115 deve ser mantido como correcao provisoria, sucedido por patch de implementador externo, ou revertido?

FORMATO DO RESULTADO:
- Front matter com tipo: audit-result, autor: claude, familia: Anthropic, path correto, created_at local.
- Linha SOU canonica.
- Veredito em linha propria: APROVA_0115: SIM ou APROVA_0115: NAO.
- Secao "Violacoes do Orquestrador" com severidade.
- Secao "Correcoes Definitivas" com regras mecanicas propostas.
- Secao "Plano Minimo para Retomar Credenciamento" com passos ordenados.
- Secao "Tratamento de Residuos" separando apagar, arquivar, versionar e ignorar.
- Resultado resumido dos comandos 1 a 7.
- Ultima linha:
CLAUDE_AUDIT_ORQUESTRADOR_SANEAMENTO_0115: PRONTO
⟦HBN-COPY END⟧
