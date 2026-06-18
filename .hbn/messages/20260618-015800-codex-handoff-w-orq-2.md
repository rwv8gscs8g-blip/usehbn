---
tipo: handoff
path: .hbn/messages/20260618-015800-codex-handoff-w-orq-2.md
readback: 0058-w-orq-2
autor: codex
created_at: "2026-06-18T01:58:00-03:00"
---

# Handoff W-ORQ-2

## RELATO DE ESTADO — codex · implementador · 2026-06-18T01:58:00-03:00
SOU: codex · familia OpenAI · papel implementador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-18T01:58:00-03:00
PRÓXIMA AÇÃO: Cross-audit ≠-OpenAI do readback 0058; depois hearback humano + APROVA_0058 + selagem do G-ORQ-ENTRADA v2; Curadoria 0055 segue pendente.
SITUACAO: W-ORQ-2 entregue; G-ORQ-ENTRADA agora usa prova extrativa deterministica; gabarito fisico removido; selagem ainda pendente.
BASTAO: segue sob orquestrador para cross-audit >=2 familias != OpenAI, hearback humano e selagem posterior.

## Entregas

- `.hbn/readbacks/0058-w-orq-2.json`: readback safe_track com escopo exato.
- `guards/assert-orq-entrada.sh`: valida `orq-entrada.v2/extractive-lines` a partir do indice staged; em CI usa `HEAD:path` com `HBN_DIFF_BASE`.
- `guards/data/orq-entrada-desafios.txt`: removido; nao ha mais gabarito fisico.
- `.hbn/attestations/34a7f2f9-orq-entrada.json`: schema v2 com `manifest_sha256`, `challenge.seed_sha256`, `line_responses` e `field_responses`; sem D1-D4.
- `guards/tests/run-guard-tests.sh`: casos de atestacao valida sem gabarito, linha errada, `line_sha256` errado, seed antigo, field ausente e arquivo da read-list mudado.
- `guards/tests/adversarial-battery.sh`: B45-B47 adicionados para linha extrativa forjada, replay de seed antigo e tentativa sem ler linhas.
- `.hbn/relay/STATE.md` e `REGISTRY.md`: estado e ledger atualizados para 0058.

## Provas mecanicas

- `git rev-parse main` = `4db692876381a0d7909985c8500d999f2e677b04`.
- `bash guards/hbn-guards-runner.sh` verde antes da mudanca.
- `bash guards/tests/run-guard-tests.sh` fechou `200 passaram, 0 falharam` antes da mudanca.
- `bash guards/tests/adversarial-battery.sh` bloqueou B1-B44 antes da mudanca.
- Dogfood final: `bash guards/hbn-guards-runner.sh` passou no diff staged com `assert-orq-entrada.sh` v2.
- Dogfood final: `bash guards/tests/run-guard-tests.sh` fechou `202 passaram, 0 falharam`.
- Dogfood final: `bash guards/tests/adversarial-battery.sh` bloqueou B1-B47.

## Cobertura do guard

- Manifesto: para cada path resolvido da read-list, computa `blob_oid`, `sha256`, `bytes` e `nonempty_lines`; `manifest_sha256` usa JSON canonico na ordem da canonica.
- Seed: `sha256("orq-entrada.v2\n"+execution_id+"\n"+token_fp+"\n"+manifest_sha256)`, com `execution_id` vindo do readback ativo.
- Linhas: exige respostas exatas para `.hbn/relay/STATE.md`, `readback_ativo` e `core/orchestrator-profile-spec.md`.
- Campos: exige `readback_ativo` e `proxima_acao` extraidos do STATE.
- Fail-closed: atestacao ausente, linha errada, hash de linha errado, seed velho, field ausente ou drift em arquivo da read-list bloqueiam.

## Fora de escopo preservado

Nao houve merge, nao houve `--no-verify`, nao houve `git add .`, e nao foram
tocados `main`, `src/**`, `methodology/**`, `schemas/**`,
`docs/brainstorm/**`, nem `core/**`.
