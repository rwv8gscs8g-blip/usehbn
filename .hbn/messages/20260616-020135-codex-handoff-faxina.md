---
titulo: "Handoff da faxina 0027"
tipo: handoff
status: final
temperatura: quente
path: .hbn/messages/20260616-020135-codex-handoff-faxina.md
id-global: 20260616-020135-codex-handoff-faxina
autor: codex
readback: .hbn/readbacks/0027-faxina-pendencias.json
created_at: "2026-06-16T02:01:35-03:00"
---

RELATO DE ESTADO — codex · implementador · 2026-06-16T02:01:35-03:00
STATE: ultima_atualizacao=2026-06-16T02:01:35-03:00
PRÓXIMA AÇÃO: Enviar a faxina 0027 para cross-audit Gemini+Cursor; se aprovada, selar em micro-onda 0028.

# Handoff da faxina 0027

## Feito

- C1 abriu `.hbn/readbacks/0027-faxina-pendencias.json` e registrou nascimento no REGISTRY.
- C2 corrigiu G-EXC em CI para ler `%B` em vez de `%(trailers)`, com README atualizado.
- C3 adicionou testes CI positivo/negativo e burla B23; `run-guard-tests` fechou 154/154 e `adversarial-battery` bloqueou B1-B23.
- C4 adicionou `.gitignore` para scratch de suites e removeu os diretorios remanescentes best-effort.
- C5 selou os seis artefatos historicos antigos no REGISTRY.
- C6 promoveu `core/exuvia-fitness-criteria.md` e selou triagem + documento-fonte.
- C7 atualizou o STATE e este handoff.

## Evidencia mecanica

- `bash guards/hbn-guards-runner.sh` passou antes de cada commit C1-C7.
- `bash guards/tests/run-guard-tests.sh` passou com 154/154.
- `bash guards/tests/adversarial-battery.sh` bloqueou B1-B23.
- `main` permaneceu em `4db692876381a0d7909985c8500d999f2e677b04`.

## Fora desta onda

- EXTRA-1/EXTRA-2 do Cursor sobre dispatch path e `dispatch_id` diferente de `readback_id` ficam para S3.
- D-ORQ-WRITE e G-ACTOR-WRITE-MATRIX seguem não habilitados.
