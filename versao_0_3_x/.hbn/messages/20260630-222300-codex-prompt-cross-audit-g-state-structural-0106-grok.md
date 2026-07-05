---
titulo: "Prompt de auditoria canonica — G-STATE-STRUCTURAL 0106 — grok/xAI"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260630-222300-codex-prompt-cross-audit-g-state-structural-0106-grok.md
created_at: "2026-06-30T22:23:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
auditor_destino: "grok (xAI)"
rollback_tag: hbn-rollback/pre-0109-g-orq-xaudit-gate-20260630
rollback_head: f8dbe09086d06f5dc42527241c33e37174a65427
superseded_by: .hbn/messages/20260630-223300-codex-prompt-cross-audit-g-state-structural-0106-grok-v2.md
motivo_superseded: "Prompt continha cercas de codigo internas e comandos agrupados; nao atende campo unico copiavel nem comando atomico."
---

⟦HBN-COPY dest=grok⟧ BEGIN
SOU: grok · familia xAI · papel auditor

CHAT NOVO, SEM MEMORIA.

PAPEL:
Auditor cruzado independente, read-only, da onda de isolamento `G-STATE-STRUCTURAL 0106`.
Voce nao e implementador. Nao corrija patch. Nao faca staging. Nao faca commit. Nao use `--no-verify`.

REPO:
`/Users/macbookpro/Projetos/usehbn`

HEAD ESPERADO:
`f8dbe09086d06f5dc42527241c33e37174a65427`

CONTEXTO MINIMO:
O orquestrador abriu 0109 `G-ORQ-XAUDIT-GATE`, mas a pre-condicao humana foi "APOS ISOLAR G-STATE".
A working tree contem um patch anterior de `G-STATE-STRUCTURAL` ainda nao selado. A auditoria desta tarefa deve avaliar somente esse patch de G-STATE e produzir evidencia canonica em `.hbn/results/`. Nao audite 0109 e nao conte prompts/pareceres soltos em chat ou anexos como quorum.

LEIA ANTES DE CONCLUIR:
- `AGENTS.md`
- `core/role-cards.md`
- `.hbn/knowledge/0025-auditor-read-only-sem-no-verify.md`
- `.hbn/knowledge/0029-lei-submissao-pelo-exemplo.md`
- `.hbn/knowledge/0030-chat-novo-prompts-sequenciais.md`
- `.hbn/proposals/20260630-201952-codex-orquestrador-provisorio-saneamento-exuvia.md`
- `guards/assert-state-structural.sh`
- `guards/hbn-guards-runner.sh`
- `guards/tests/run-guard-tests.sh`
- `guards/tests/adversarial-battery.sh`
- `guards/data/auditor-families.txt`
- `REGISTRY.md`

PREFLIGHT FAIL-CLOSED:
Se qualquer item abaixo falhar, salve parecer com `APROVA_0106: NAO` e explique:
1. repo inacessivel;
2. HEAD diferente do esperado sem justificativa clara no disco;
3. `guards/assert-state-structural.sh` ausente;
4. runner nao registra `assert-state-structural.sh`;
5. testes de G-STATE ausentes em `run-guard-tests.sh`;
6. B91/B92 ausentes em `adversarial-battery.sh`;
7. tentativa de usar somente chat/anexo como quorum.

ESCOPO DA AUDITORIA:
Avalie se o patch `G-STATE-STRUCTURAL` fecha a lacuna 0103-0105: mudanca estrutural de `.hbn/relay/STATE.md` nao pode ser autorizada apenas por readback `status: entregue`; precisa de quorum de auditoria cruzada por familias distintas em `.hbn/results/`.

PERGUNTAS OBRIGATORIAS:
1. Bloqueia repoint estrutural de STATE com readback `entregue` e sem quorum?
2. Bloqueia quorum falso por dois pareceres da mesma familia?
3. Ignora resultado nao registrado/staged e SOU/familia inconsistentes?
4. B91/B92 reproduzem a falha real 0103-0105?
5. O patch e pequeno e isolavel para selagem propria?
6. Quais limites devem ficar registrados para ondas seguintes, especialmente delecao de STATE, freshness de parecer e gate humano?

COMANDOS MINIMOS:
Rode, se o ambiente permitir:
```
git rev-parse HEAD
git status --short
bash guards/tests/run-guard-tests.sh
bash guards/tests/adversarial-battery.sh
```

DESTINO CANONICO DO PARECER:
Salve o parecer em:
`.hbn/results/20260630-222400-grok-cross-ia-g-state-structural-0106.md`

Se voce estiver em chat sem acesso de escrita ao disco, responda com o conteudo integral desse arquivo para deposito humano e declare explicitamente: "NAO SALVEI NO DISCO".

FORMATO MINIMO DO ARQUIVO:
```
---
tipo: audit-result
autor: grok
familia: xAI
path: .hbn/results/20260630-222400-grok-cross-ia-g-state-structural-0106.md
id-global: 20260630-222400-grok-cross-ia-g-state-structural-0106
arvore: fronteira
created_at: "2026-06-30T22:24:00-03:00"
---
SOU: grok · familia xAI · papel auditor

# Auditoria G-STATE-STRUCTURAL 0106

## Veredito
VEREDITO_G_STATE_STRUCTURAL: APROVA|REPROVA

## Evidencias
Inclua comandos rodados e resultados relevantes.

## Achados
Liste achados por severidade: BLOQUEADOR, FORTE, MARGINAL.

## Respostas obrigatorias
Responda as 6 perguntas obrigatorias.

APROVA_0106: SIM|NAO
```

CRITERIO DE APROVACAO:
Use `APROVA_0106: SIM` somente se o patch em disco realmente bloquear a classe 0103-0105 e os testes/bateria sustentarem isso. Caso contrario, use `APROVA_0106: NAO`.

ULTIMA LINHA DA RESPOSTA NO CHAT:
`APROVA_0106: SIM` ou `APROVA_0106: NAO`
⟦HBN-COPY END⟧
