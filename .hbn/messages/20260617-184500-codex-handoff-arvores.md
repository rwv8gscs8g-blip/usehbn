---
tipo: handoff
path: .hbn/messages/20260617-184500-codex-handoff-arvores.md
readback: 0049-arvores-registry-centric
autor: codex
created_at: "2026-06-17T18:45:00-03:00"
---

# Handoff R2 — arvores registry-centric

## RELATO DE ESTADO — codex · implementador · 2026-06-17T18:45:00-03:00
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-17T18:45:00-03:00
PRÓXIMA AÇÃO: cross-audit ≠-OpenAI + hearback + selagem do R2; depois curadoria dos 4 batch1-fronteira; depois R3/freeze.
SITUACAO: R2 entregue operacionalmente em 6 commits; G-EXC segue PROPOSED_UNTIL_CROSS_AUDIT.
ESCOPO: nenhum `src/**`, `methodology/**`, `schemas/**`, outra spec de `core/**` ou `docs/brainstorm/**` foi tocado.
NAO FEITO: os 4 batch1-fronteira continuam untracked; G-REG nao foi estendido para M geral; Camada 2 do G-AUDITOR-ID e exuvia ficam fora.
BASTAO: volta ao orquestrador para auditoria, hearback e selagem.

## Entregas

- `core/arvores-spec.md`: spec curta registry-centric, sem front-matter `arvore:`, sem parser YAML, sem compilador e sem particao fisica.
- `REGISTRY.md`: bloco R2 going-forward em 7 colunas na ordem `id | artefato (path) | tipo | temperatura | arvore | superseded_by | created_at`.
- `guards/assert-registry-line.sh`: matcher por coluna 2 do REGISTRY e exigencia de `arvore` valida para nascimento novo.
- `guards/assert-parallel-id.sh`: `created_at` lido como ultima coluna, tolerando 6-col legado e 7-col novo.
- `guards/assert-arvore-label.sh`: novo G-ARVORE-LABEL ativo no runner; bloqueia `intermediaria|estavel` sem `arvore-promocao` rastreavel e `estavel` nao-quente.

## Placar

| Mecanismo | C-TEST | C-ADV | C-XAUDIT | C-DOG | C-FCLOSE | C-NOREG | C-TRACE | C-DEBT | Veredito |
|---|---|---|---|---|---|---|---|---|---|
| R2 arvores registry-centric | SIM (`run-guard-tests` 187/187) | SIM (B38 bloqueada) | PENDENTE | SIM (REGISTRY/guards registrados no proprio ledger 7-col) | SIM (G-ARVORE falha se REGISTRY/STATE ilegivel) | SIM (runner + adversarial + pytest verdes) | SIM (readback 0049 + REGISTRY + trailers) | bootstrap G-NUM antecipado no C1 registrado | ENTREGUE para cross-audit |

## Provas mecanicas

- `bash guards/hbn-guards-runner.sh` passou antes de cada commit; no C4/C5 ja incluiu `assert-arvore-label.sh`.
- `bash guards/tests/run-guard-tests.sh` fechou `187 passaram, 0 falharam`.
- `bash guards/tests/adversarial-battery.sh` fechou `BATERIA VERDE` com `B38 arvore estavel sem promocao | G-ARVORE | BLOQUEADA`.
- `.venv/bin/pytest -q` fechou `213 passed`.
- Matcher de path: a suite preserva o negativo de substring (`reg: substring de path registrado`) e o positivo 7-col (`num: linha de 7 colunas com arvore+created_at passa no G-REG`).
- `created_at` column-aware: G-NUM continuou passando nos casos 6-col da suite e passou nos commits reais com linhas R2 7-col do REGISTRY.
- `main` permaneceu em `4db692876381a0d7909985c8500d999f2e677b04`.

## Notas para selagem

- C1 antecipou o ajuste column-aware de `assert-parallel-id.sh`; sem isso, a primeira linha R2 em 7 colunas seria bloqueada pelo G-NUM legado antes do C3.
- A spec nasceu `arvore=fronteira` para evitar circularidade; promocao posterior deve ser evento append-only `tipo=arvore-promocao` referenciando readback selado.
- A linha original de nascimento de artefato nao deve ser editada para promover arvore.
