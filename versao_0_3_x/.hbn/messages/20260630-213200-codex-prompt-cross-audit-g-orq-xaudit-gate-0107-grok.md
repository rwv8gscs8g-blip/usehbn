---
titulo: "Prompt cross-audit — G-ORQ-XAUDIT-GATE 0107 — Grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260630-213200-codex-prompt-cross-audit-g-orq-xaudit-gate-0107-grok.md
created_at: "2026-06-30T21:32:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
auditor_destino: "grok (xAI)"
---

⟦HBN-COPY dest=grok⟧ BEGIN
SOU: grok · familia xAI · papel auditor

PAPEL: auditor cruzado read-only da onda 0107 `G-ORQ-XAUDIT-GATE`.
REPO: `/Users/macbookpro/Projetos/usehbn`.
READ-ONLY: não comite, não faça staging, não altere arquivos versionados, não use `--no-verify`.

ALVO:
Auditar o patch entregue por Antigravity/Google para `G-ORQ-XAUDIT-GATE`, especialmente se ele bloqueia prompts de auditoria cruzada que não declaram entrega dupla: parecer integral no chat e arquivo canônico em `.hbn/results/`.

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
1. O guard bloqueia prompt cross-audit sem path `.hbn/results/...`?
2. O guard bloqueia prompt que entrega só no chat, sem arquivo canônico?
3. O guard exige path canônico com apelido do auditor e NNNN?
4. O guard exige `SOU`, frontmatter de `audit-result` e `APROVA_NNNN: SIM|NAO` coerentes?
5. Há bypass por comentário, echo, heredoc, substring, família errada ou NNNN divergente?
6. Os testes e a bateria cobrem os casos ruins reais?
7. O patch tocou somente o escopo permitido?

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
`.hbn/results/20260630-213200-grok-cross-ia-g-orq-xaudit-gate-0107.md`

Use exatamente este cabeçalho no arquivo salvo:
---
titulo: "Auditoria G-ORQ-XAUDIT-GATE 0107 — grok/xAI"
tipo: audit-result
temperatura: frio
arvore: fronteira
path: .hbn/results/20260630-213200-grok-cross-ia-g-orq-xaudit-gate-0107.md
id-global: 20260630-213200-grok-cross-ia-g-orq-xaudit-gate-0107
created_at: "2026-06-30T21:32:00-03:00"
autor: grok
familia: xAI
---

SOU: grok · familia xAI · papel auditor

Formato mínimo:
- VEREDITO_G_ORQ_XAUDIT_GATE: APROVA|REPROVA
- ACHADOS: BLOQUEADOR/FORTE/MARGINAL com arquivo:linha ou comando+saída
- RECOMENDAÇÃO: pode ou não seguir para segundo auditor
- APROVA_0107: SIM|NAO

A última linha deve ser exatamente uma destas:
APROVA_0107: SIM
APROVA_0107: NAO
⟦HBN-COPY END⟧
