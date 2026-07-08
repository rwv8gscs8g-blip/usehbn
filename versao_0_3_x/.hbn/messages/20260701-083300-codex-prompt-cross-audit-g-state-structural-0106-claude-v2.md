---
titulo: "Prompt de auditoria canonica v2 - G-STATE-STRUCTURAL 0106 - claude/Anthropic"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-083300-codex-prompt-cross-audit-g-state-structural-0106-claude-v2.md
created_at: "2026-07-01T08:33:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
auditor_destino: "claude (Anthropic)"
rollback_tag: hbn-rollback/pre-0109-g-orq-xaudit-gate-20260630
rollback_head: f8dbe09086d06f5dc42527241c33e37174a65427
evidencia_previa: .hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md
---

⟦HBN-COPY dest=claude⟧ BEGIN
SOU: claude · familia Anthropic · papel auditor

CHAT NOVO, SEM MEMORIA.

ATENCAO:
Este prompt e um campo unico colavel. Ele nao contem cercas Markdown internas. Se voce recebeu esta mensagem truncada, incompleta ou fora de ordem, falhe fechado com APROVA_0106: NAO.

PAPEL:
Voce e auditor cruzado independente da familia Anthropic. Seu papel e read-only para o codigo. A unica escrita permitida e o parecer no destino canonico indicado abaixo. Nao implemente correcao. Nao altere outros arquivos. Nao faca staging. Nao faca commit. Nao use --no-verify.

REPO:
/Users/macbookpro/Projetos/usehbn

HEAD ESPERADO:
f8dbe09086d06f5dc42527241c33e37174a65427

OBJETIVO:
Auditar de forma independente o patch G-STATE-STRUCTURAL 0106 que esta em disco. A finalidade e isolar G-STATE antes de qualquer implementacao da onda 0109 G-ORQ-XAUDIT-GATE.

CONTEXTO:
Ja existe um parecer canonico de uma familia independente, xAI, em .hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md com APROVA_0106: SIM. Nao use esse parecer como substituto da sua propria analise. Primeiro audite o patch em disco. Depois voce pode comparar divergencias relevantes.

NAO AUDITE:
- 0109 G-ORQ-XAUDIT-GATE.
- prompts antigos truncados.
- resultado solto em chat ou anexo como quorum.
- o arquivo .hbn/results/20260630-222400-grok-cross-ia-g-state-structural-0106.md como evidencia de quorum, pois veio de prompt v1 superseded.

LEIA ANTES DE CONCLUIR:
- AGENTS.md
- core/role-cards.md
- .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
- .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md
- .hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
- .hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
- .hbn/proposals/20260630-201952-codex-orquestrador-provisorio-saneamento-exuvia.md
- guards/assert-state-structural.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- guards/data/auditor-families.txt
- REGISTRY.md

PREFLIGHT FAIL-CLOSED:
Se qualquer item abaixo falhar, salve parecer com APROVA_0106: NAO e explique:
1. repo inacessivel;
2. HEAD diferente do esperado sem justificativa clara no disco;
3. guards/assert-state-structural.sh ausente;
4. runner nao registra assert-state-structural.sh;
5. testes de G-STATE ausentes em run-guard-tests.sh;
6. B91/B92 ausentes em adversarial-battery.sh;
7. tentativa de usar chat ou anexo como quorum;
8. este prompt chegou incompleto;
9. o patch auditado for de 0109 em vez de G-STATE.

ESCOPO DA AUDITORIA:
Avalie se o patch G-STATE-STRUCTURAL fecha a lacuna 0103-0105: mudanca estrutural de .hbn/relay/STATE.md nao pode ser autorizada apenas por readback status entregue; precisa de quorum de auditoria cruzada por familias distintas em .hbn/results/.

PERGUNTAS OBRIGATORIAS:
1. Bloqueia repoint estrutural de STATE com readback entregue e sem quorum?
2. Bloqueia quorum falso por dois pareceres da mesma familia?
3. Ignora resultado nao registrado/staged e SOU/familia inconsistentes?
4. B91/B92 reproduzem a falha real 0103-0105?
5. O patch e pequeno e isolavel para selagem propria?
6. Quais limites devem ficar registrados para ondas seguintes, especialmente delecao de STATE, freshness de parecer e gate humano?

COMANDOS:
Execute um comando por vez. Nao cole como bloco unico. Registre a saida de cada comando.

COMANDO 1:
git rev-parse HEAD

COMANDO 2:
git status --short

COMANDO 3:
bash guards/tests/run-guard-tests.sh

COMANDO 4:
bash guards/tests/adversarial-battery.sh

DESTINO CANONICO DO PARECER:
.hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md

SE VOCE NAO CONSEGUIR SALVAR NO DISCO:
Responda no chat com o conteudo integral do arquivo acima e declare exatamente: NAO SALVEI NO DISCO.

FORMATO MINIMO DO ARQUIVO:
---
tipo: audit-result
autor: claude
familia: Anthropic
path: .hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md
id-global: 20260701-083400-claude-cross-ia-g-state-structural-0106-v2
arvore: fronteira
created_at: "2026-07-01T08:34:00-03:00"
---
SOU: claude · familia Anthropic · papel auditor

# Auditoria G-STATE-STRUCTURAL 0106 v2

## Veredito
VEREDITO_G_STATE_STRUCTURAL: APROVA ou REPROVA

## Evidencias
Inclua comandos rodados, saidas relevantes e arquivos/linhas citados.

## Achados
Liste achados por severidade: BLOQUEADOR, FORTE, MARGINAL.

## Respostas obrigatorias
Responda as 6 perguntas obrigatorias.

APROVA_0106: SIM ou NAO

CRITERIO DE APROVACAO:
Use APROVA_0106: SIM somente se o patch em disco realmente bloquear a classe 0103-0105 e os testes/bateria sustentarem isso. Caso contrario, use APROVA_0106: NAO.

ULTIMA LINHA DA SUA RESPOSTA NO CHAT:
APROVA_0106: SIM ou APROVA_0106: NAO
⟦HBN-COPY END⟧
