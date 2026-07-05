---
titulo: "Prompt de implementação — G-ORQ-XAUDIT-GATE 0107 — Antigravity/Google"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260630-213100-codex-prompt-implementacao-g-orq-xaudit-gate-0107-antigravity.md
created_at: "2026-06-30T21:31:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
implementador_destino: "antigravity (Google)"
rollback_tag: hbn-rollback/pre-g-orq-xaudit-gate-20260630-2115
rollback_head: f8dbe09086d06f5dc42527241c33e37174a65427
---

⟦HBN-COPY dest=antigravity⟧ BEGIN
SOU: antigravity · familia Google · papel implementador

PAPEL: implementador externo da onda 0107 `G-ORQ-XAUDIT-GATE`.
REPO: `/Users/macbookpro/Projetos/usehbn`.
MODO: patch pequeno, sem commit, sem `git add .`, sem `--no-verify`, sem tocar `main`.

OBJETIVO:
Criar um guard que obrigue todo prompt/despacho de auditoria cruzada a declarar, dentro do bloco copiável do chat, o destino canônico do parecer em `.hbn/results/`, o template mínimo do arquivo e o veredito `APROVA_NNNN: SIM|NAO`. Isto corrige a falha operacional onde o orquestrador pediu auditoria mas não declarou onde o relatório deveria ser salvo.

ROLLBACK JA REGISTRADO:
- HEAD: `f8dbe09086d06f5dc42527241c33e37174a65427`
- tag: `hbn-rollback/pre-g-orq-xaudit-gate-20260630-2115`
- rollback preferido: `git revert` dos commits da onda, se houver commit. Não use reset destrutivo.

LEIA ANTES DE EDITAR:
- `.hbn/messages/20260630-213000-codex-plano-g-orq-xaudit-gate-0107.md`
- `AGENTS.md`
- `core/role-cards.md`
- `.hbn/knowledge/0001-comandos-atomicos-copiaveis.md`
- `.hbn/knowledge/0002-entrega-operacional-minimalista.md`
- `.hbn/knowledge/0025-auditor-read-only-sem-no-verify.md`
- `.hbn/knowledge/0029-lei-submissao-pelo-exemplo.md`
- `guards/assert-copy-block.sh`
- `guards/assert-auditor-id.sh`
- `guards/assert-registry-line.sh`
- `guards/tests/run-guard-tests.sh`
- `guards/tests/adversarial-battery.sh`

ESCOPO PERMITIDO:
- criar `guards/assert-orq-xaudit-gate.sh`
- editar `guards/hbn-guards-runner.sh`
- editar `guards/tests/run-guard-tests.sh`
- editar `guards/tests/adversarial-battery.sh`
- editar `REGISTRY.md`
- criar `.hbn/readbacks/0107-g-orq-xaudit-gate.json`
- criar `.hbn/messages/20260630-213100-antigravity-implementacao-g-orq-xaudit-gate-0107.md`

ESCOPO PROIBIDO:
- `.hbn/relay/STATE.md`
- `.hbn/results/**`
- `guards/assert-state-structural.sh`
- `core/**`
- `src/**`
- `schemas/**`
- `methodology/**`
- `docs/brainstorm/**`
- qualquer arquivo fora de `/Users/macbookpro/Projetos/usehbn`

REGRA DO GUARD:
Para arquivo ADICIONADO em `.hbn/messages/*.md` ou `docs/prompts/*.md` cujo nome contenha `prompt-cross-audit` OU cujo corpo contenha `PAPEL: auditor cruzado`, exigir no blob staged/HEAD:
1. um bloco `HBN-COPY` valido;
2. texto explícito dizendo que o auditor deve responder no chat com o parecer integral;
3. texto explícito dizendo que o auditor deve salvar o mesmo parecer em `.hbn/results/`;
4. path canônico: `.hbn/results/AAAAMMDD-HHMMSS-<apelido>-cross-ia-<tema>-NNNN.md`;
5. `SOU: <apelido> · familia <familia> · papel auditor`;
6. frontmatter de resultado contendo `tipo: audit-result`, `autor: <apelido>`, `familia: <familia>`, `path: <mesmo path>`, `id-global: <basename sem .md>`, `arvore: fronteira`, `created_at:`;
7. exatamente uma linha `APROVA_NNNN: SIM|NAO`, com o mesmo NNNN do path.

FAMILIAS VALIDAS:
Use `guards/data/auditor-families.txt`. O apelido do path, o `SOU` e o frontmatter devem concordar com esse mapa.

TESTES OBRIGATORIOS:
1. Caso neutro: arquivo que não é prompt cross-audit não dispara o guard.
2. Caso bom: prompt cross-audit com chat + `.hbn/results/...` + frontmatter + `SOU` + `APROVA_NNNN` passa.
3. Bloquear prompt que pede resposta só no chat e não salva `.hbn/results/`.
4. Bloquear prompt com path não canônico.
5. Bloquear `SOU` ausente.
6. Bloquear família errada para o apelido.
7. Bloquear `APROVA_NNNN` ausente ou divergente do NNNN do path.
8. Adicionar casos equivalentes na bateria adversarial como próximos B após B92.

COMANDOS DE VERIFICACAO:
```
bash guards/tests/run-guard-tests.sh
```

```
bash guards/tests/adversarial-battery.sh
```

```
bash guards/hbn-guards-runner.sh
```

ENTREGA:
1. Não commite.
2. Responda no chat com resumo curto, arquivos tocados e saídas dos comandos.
3. Salve também o handoff em `.hbn/messages/20260630-213100-antigravity-implementacao-g-orq-xaudit-gate-0107.md`.
4. Última linha da resposta: `IMPLEMENTACAO_0107: ENTREGUE` ou `IMPLEMENTACAO_0107: BLOQUEADA`.
⟦HBN-COPY END⟧
