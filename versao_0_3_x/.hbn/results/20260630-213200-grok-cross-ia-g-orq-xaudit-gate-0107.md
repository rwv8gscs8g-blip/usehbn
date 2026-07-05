---
titulo: "Auditoria G-ORQ-XAUDIT-GATE 0107 — grok/xAI"
tipo: audit-result
temperatura: glacier
arvore: fronteira
path: .hbn/results/20260630-213200-grok-cross-ia-g-orq-xaudit-gate-0107.md
id-global: 20260630-213200-grok-cross-ia-g-orq-xaudit-gate-0107
created_at: "2026-06-30T21:32:00-03:00"
autor: grok
familia: xAI
status: congelado
---

SOU: grok · familia xAI · papel auditor

## VEREDITO

**VEREDITO_G_ORQ_XAUDIT_GATE: REPROVA**

O patch da onda 0107 **não foi entregue**. O artefato central `guards/assert-orq-xaudit-gate.sh` não existe no repositório (nem em HEAD nem na working tree). O plano confirma explicitamente ausência de implementação. As únicas mudanças locais pendentes referem-se a **G-STATE-STRUCTURAL** — escopo proibido e guard distinto —, não a `G-ORQ-XAUDIT-GATE`.

## EVIDÊNCIAS DE COMANDO

### `git rev-parse HEAD`

```
f8dbe09086d06f5dc42527241c33e37174a65427
```

### `bash guards/tests/run-guard-tests.sh`

```
== resumo: 268 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

Não há seção `assert-orq-xaudit-gate (G-ORQ-XAUDIT-GATE)` na suíte. A suíte verde cobre guards existentes, não o guard alvo desta onda.

### `bash guards/tests/adversarial-battery.sh`

```
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

Últimos casos: B91–B92 (`G-STATE-STRUCTURAL`). Não existem B93+ para burlas de prompt cross-audit sem entrega dupla, conforme exigido pelo plano (`.hbn/messages/20260630-213000-codex-plano-g-orq-xaudit-gate-0107.md:81-85`).

## VERIFICAÇÃO DOS 7 CRITÉRIOS

| # | Critério | Resultado |
|---|----------|-----------|
| 1 | Bloqueia prompt cross-audit sem path `.hbn/results/` | **FALHA** — guard inexistente |
| 2 | Bloqueia prompt só no chat | **FALHA** — guard inexistente |
| 3 | Exige path canônico com apelido e NNNN | **FALHA** — guard inexistente |
| 4 | Exige SOU, frontmatter `audit-result`, `APROVA_NNNN` | **FALHA** — guard inexistente |
| 5 | Resiste a bypass (comentário, echo, heredoc, substring, família errada, NNNN divergente) | **N/A** — sem implementação a testar |
| 6 | Testes e bateria cobrem a falha real | **FALHA** — zero casos para G-ORQ-XAUDIT-GATE |
| 7 | Patch tocou só escopo permitido | **FALHA** — patch 0107 ausente; working tree contém artefatos fora de escopo |

## ACHADOS

### BLOQUEADOR

1. **Guard principal ausente.** `guards/assert-orq-xaudit-gate.sh` não existe.
   - Comando: `ls guards/assert-orq-xaudit-gate.sh` → `No such file or directory`
   - Plano linha 21: *"Nenhum patch implementado por Codex."* (`.hbn/messages/20260630-213000-codex-plano-g-orq-xaudit-gate-0107.md:21`)

2. **Guard não registrado no runner.** `guards/hbn-guards-runner.sh` lista `assert-state-structural.sh` (linha 108) mas não `assert-orq-xaudit-gate.sh`.

3. **Readback da onda ausente.** `.hbn/readbacks/0107-g-orq-xaudit-gate.json` não existe (`ls .hbn/readbacks/0107*` → sem correspondência).

4. **Handoff do implementador ausente.** `.hbn/messages/20260630-213100-antigravity-implementacao-g-orq-xaudit-gate-0107.md` não existe.

5. **Invariantes 1–7 da onda não são enforçáveis.** Sem o guard, um orquestrador pode commitar prompt cross-audit sem contrato de entrega dupla; `G-COPY` (`guards/assert-copy-block.sh:100-157`) valida apenas estrutura do bloco HBN-COPY, não o contrato de `.hbn/results/`, SOU, frontmatter nem `APROVA_NNNN` no prompt.

### FORTE

6. **Suíte de testes sem cobertura do guard alvo.** `grep` em `guards/tests/run-guard-tests.sh` por `xaudit|G-ORQ-XAUDIT` → zero ocorrências. Os 268 casos verdes não substituem os 8 casos obrigatórios do prompt de implementação (`.hbn/messages/20260630-213100-codex-prompt-implementacao-g-orq-xaudit-gate-0107.md:78-86`).

7. **Bateria adversarial incompleta para a onda.** Últimos casos são B91–B92 (`G-STATE-STRUCTURAL`, `guards/tests/adversarial-battery.sh:1644-1699`). Faltam B93+ para: chat-only, path não canônico, SOU ausente, família errada, `APROVA_NNNN` ausente/divergente.

8. **Escopo violado na working tree (outra onda).** Diff desde `hbn-rollback/pre-g-orq-xaudit-gate-20260630-2115`:
   - `guards/assert-state-structural.sh` (untracked) — **proibido** pelo escopo 0107 (`.hbn/messages/20260630-213000-codex-plano-g-orq-xaudit-gate-0107.md:59`)
   - `guards/hbn-guards-runner.sh` — adiciona `assert-state-structural.sh`, não o guard 0107
   - `REGISTRY.md` — entradas de ponte-diagnóstico-exuvia e `assert-state-structural`, não `0107-g-orq-xaudit-gate`

### MARGINAL

9. **Prompts de cross-audit da própria onda 0107 estão bem formados** (ex.: `.hbn/messages/20260630-213200-codex-prompt-cross-audit-g-orq-xaudit-gate-0107-grok.md:56-84` declara entrega dupla, path canônico, SOU e `APROVA_0107`), mas permanecem **untracked** e **não são validados** por nenhum guard mecânico até a implementação existir.

10. **`G-AUDITOR-ID`** (`guards/assert-auditor-id.sh`) valida pareceres em `.hbn/results/` quando adicionados, mas **não** valida o contrato embutido em prompts cross-audit novos — escopo distinto do `G-ORQ-XAUDIT-GATE`.

## COBERTURA PARCIAL EXISTENTE (insuficiente)

| Guard existente | O que cobre | Lacuna para 0107 |
|----------------|-------------|------------------|
| `G-COPY` | Bloco HBN-COPY único e bem-formado | Não exige `.hbn/results/`, SOU nem `APROVA_NNNN` no prompt |
| `G-AUDITOR-ID` | Identidade em `.hbn/results/*.md` adicionados | Não inspeciona prompts cross-audit em `.hbn/messages/` |
| `G-QUORUM` | Quorum em selagem | Não valida contrato de entrega no prompt |

## RECOMENDAÇÃO

**Não seguir para segundo auditor nem selagem.** Devolver à Antigravity/Google para implementação completa conforme `.hbn/messages/20260630-213100-codex-prompt-implementacao-g-orq-xaudit-gate-0107-antigravity.md`.

Checklist mínimo antes de re-auditoria:

1. Criar `guards/assert-orq-xaudit-gate.sh` com detecção por `prompt-cross-audit` no nome ou `PAPEL: auditor cruzado` no corpo.
2. Registrar no `guards/hbn-guards-runner.sh`.
3. Adicionar 8 casos na suíte + B93+ na bateria adversarial.
4. Criar `.hbn/readbacks/0107-g-orq-xaudit-gate.json` e handoff do implementador.
5. Atualizar `REGISTRY.md` somente com artefatos da onda 0107.
6. Reverter ou isolar mudanças de `G-STATE-STRUCTURAL` (escopo proibido nesta onda).
7. Re-rodar `run-guard-tests.sh` e `adversarial-battery.sh` com saída citável.

APROVA_0107: NAO
