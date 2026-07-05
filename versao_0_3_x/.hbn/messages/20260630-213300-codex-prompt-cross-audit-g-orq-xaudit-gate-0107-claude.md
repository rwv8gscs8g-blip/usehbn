---
titulo: "Prompt cross-audit — G-ORQ-XAUDIT-GATE 0107 — Claude/Anthropic"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260630-213300-codex-prompt-cross-audit-g-orq-xaudit-gate-0107-claude.md
created_at: "2026-06-30T21:33:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
auditor_destino: "claude (Anthropic)"
---

⟦HBN-COPY dest=claude⟧ BEGIN
SOU: claude · familia Anthropic · papel auditor

PAPEL: auditor cruzado read-only da onda 0107 `G-ORQ-XAUDIT-GATE`.
REPO: `/Users/macbookpro/Projetos/usehbn`.
READ-ONLY: não comite, não faça staging, não altere arquivos versionados, não use `--no-verify`.

ALVO:
Auditar independentemente o patch entregue por Antigravity/Google para `G-ORQ-XAUDIT-GATE`. Foque em invariantes de orquestração: prompt copiável no chat, arquivo canônico em `.hbn/results/`, identidade do auditor, família, frontmatter e veredito `APROVA_NNNN`.

LEIA:
- `.hbn/messages/20260630-213000-codex-plano-g-orq-xaudit-gate-0107.md`
- `guards/assert-orq-xaudit-gate.sh`
- `guards/assert-copy-block.sh`
- `guards/assert-auditor-id.sh`
- `guards/hbn-guards-runner.sh`
- `guards/tests/run-guard-tests.sh`
- `guards/tests/adversarial-battery.sh`
- `REGISTRY.md`

PERGUNTAS DE AUDITORIA:
1. O guard fecha a falha operacional apontada pelo humano: prompt sem destino de relatório?
2. O prompt continua copiável em um clique e salvo como `.md`?
3. O guard é fail-closed para path ausente, path malformado, `SOU` ausente, família divergente e `APROVA_0107` ausente?
4. O guard evita falso quorum por parecer solto em chat/anexo?
5. O patch é pequeno e isolado?
6. Há bypass por substring, comentário, template incompleto ou NNNN reciclado?
7. Os testes adversariais cobrem a classe da falha real?

COMANDOS A RODAR E CITAR:
```
git rev-parse HEAD
```

```
bash guards/tests/run-guard-tests.sh
```

```
bash guards/tests/adversarial-battery.sh
```

ENTREGA DUPLA OBRIGATORIA:
1. Responda no chat com o parecer integral.
2. Salve o mesmo parecer neste arquivo:
`.hbn/results/20260630-213300-claude-cross-ia-g-orq-xaudit-gate-0107.md`

Use exatamente este cabeçalho no arquivo salvo:
---
titulo: "Auditoria G-ORQ-XAUDIT-GATE 0107 — claude/Anthropic"
tipo: audit-result
temperatura: frio
arvore: fronteira
path: .hbn/results/20260630-213300-claude-cross-ia-g-orq-xaudit-gate-0107.md
id-global: 20260630-213300-claude-cross-ia-g-orq-xaudit-gate-0107
created_at: "2026-06-30T21:33:00-03:00"
autor: claude
familia: Anthropic
---

SOU: claude · familia Anthropic · papel auditor

Formato mínimo:
- VEREDITO_G_ORQ_XAUDIT_GATE: APROVA|REPROVA
- ACHADOS: BLOQUEADOR/FORTE/MARGINAL com arquivo:linha ou comando+saída
- RECOMENDAÇÃO: pode ou não seguir para gate humano
- APROVA_0107: SIM|NAO

A última linha deve ser exatamente uma destas:
APROVA_0107: SIM
APROVA_0107: NAO
⟦HBN-COPY END⟧
