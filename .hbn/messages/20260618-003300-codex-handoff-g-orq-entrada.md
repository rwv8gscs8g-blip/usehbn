---
tipo: handoff
path: .hbn/messages/20260618-003300-codex-handoff-g-orq-entrada.md
readback: 0056-g-orq-entrada
autor: codex
created_at: "2026-06-18T00:33:00-03:00"
---

# Handoff G-ORQ-ENTRADA

## RELATO DE ESTADO — codex · implementador · 2026-06-18T00:33:00-03:00
SOU: codex · familia OpenAI · papel implementador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-18T00:33:00-03:00
PRÓXIMA AÇÃO: Cross-audit ≠-OpenAI do readback 0056; depois hearback humano + selagem do gate G-ORQ-ENTRADA; retomar Curadoria 0055 pendente.
SITUACAO: G-ORQ-ENTRADA entregue; Curadoria 0055 pendente por decisao humana, nao abandonada.
BASTAO: segue sob orquestrador para validacao/selagem.

## Entregas

- `.hbn/readbacks/0056-g-orq-entrada.json`: readback safe_track com escopo exato da onda.
- `core/read-list-canonica.txt`: 13 itens da read-list de entrada do orquestrador; `handoff_mais_recente` e `readback_ativo` sao dinamicos via STATE.
- `.hbn/attestations/34a7f2f9-orq-entrada.json`: atestacao do bastao atual com hashes de disco e respostas D1-D4.
- `guards/data/orq-entrada-desafios.txt`: gabarito D1-D4.
- `guards/assert-orq-entrada.sh`: guard fail-closed para bastao de orquestrador.
- `guards/hbn-guards-runner.sh`: wire-in local do novo guard.
- `guards/tests/run-guard-tests.sh`: 1 caso positivo e 4 negativos para G-ORQ-ENTRADA.
- `guards/tests/adversarial-battery.sh`: B41-B44 para as quatro burlas exigidas.
- `.hbn/relay/STATE.md` e `REGISTRY.md`: estado e ledger atualizados.

## Provas mecanicas

- `bash -n guards/assert-orq-entrada.sh`
- `bash -n guards/tests/run-guard-tests.sh`
- `bash -n guards/tests/adversarial-battery.sh`
- `bash -n guards/hbn-guards-runner.sh`
- `bash guards/tests/run-guard-tests.sh` fechou `200 passaram, 0 falharam`.
- `bash guards/tests/adversarial-battery.sh` bloqueou B1-B44.

## Cobertura do guard

- Gatilho: `papel_bastao: orquestrador` ou `atribuicao.chapeu_atual` contendo `orquestrador`.
- Atestacao: `.hbn/attestations/<fp>-orq-entrada.json`, onde `<fp>` sao os 8 primeiros hex de `bastao_token_sha256`.
- Read-list: todo item resolvido de `core/read-list-canonica.txt` precisa estar em `itens`.
- Frescor: cada `blob_hash` precisa igualar `git hash-object <path>` no disco.
- Desafios: toda resposta D1-D4 precisa existir e satisfazer o gabarito.

## Fora de escopo preservado

Nao houve merge, nao houve `--no-verify`, nao houve `git add .`, e nao foram
tocados `main`, `src/**`, `methodology/**`, `schemas/**`,
`docs/brainstorm/**`, nem `core/**` fora de `core/read-list-canonica.txt`.
Constituicao/knowledge-do-erro fica para onda posterior.
