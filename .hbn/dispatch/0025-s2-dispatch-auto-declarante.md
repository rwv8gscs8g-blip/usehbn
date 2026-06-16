---
schema_version: dispatch.v1
dispatch_id: 0025-s2-dispatch-auto-declarante
path: .hbn/dispatch/0025-s2-dispatch-auto-declarante.md
readback_id: 0025-s2-dispatch-auto-declarante
token_fp: 34a7f2f9
human_authorization: Mauricio (Luis Mauricio Junqueira Zanin)
agent_id: codex
role: implementador
status: executed
created_at: 2026-06-16T00:42:23-03:00
summary: Primeiro dispatch auto-declarante S2, usado como dogfood dos guards G-DSP-FMT e G-DSP-INT.
scope:
  files_allowed:
    - .hbn/readbacks/0025-s2-dispatch-auto-declarante.json
    - schemas/dispatch.schema.json
    - core/dispatch-spec.md
    - guards/validate-dispatch.sh
    - guards/assert-dispatch-integrity.sh
    - guards/hbn-guards-runner.sh
    - guards/README.md
    - guards/tests/run-guard-tests.sh
    - guards/tests/adversarial-battery.sh
    - .hbn/dispatch/0025-s2-dispatch-auto-declarante.md
    - .hbn/relay/STATE.md
    - REGISTRY.md
  files_forbidden:
    - main
    - src/
    - site/
    - examples/
    - inbox/
    - .hbn/models/
    - .hbn/hearbacks/
    - .hbn/messages/20260612-122102-fable5-handoff-orquestracao-pos-onda-0006.md
    - .hbn/messages/20260613-112502-fable5-handoff-orquestracao-pos-adocao-onda-0006.md
    - .hbn/results/20260614-032800-gemini-3-5-cross-ia-onda-0011-plano-v2.md
    - .hbn/results/20260614-043647-antigravity-cross-ia-exuvia-impl.md
    - .hbn/results/20260614-043826-codex-cross-ia-exuvia-impl.md
    - .hbn/results/20260614-044555-opus-4-8-consolidacao-cross-audit-exuvia-impl.md
action_plan:
  - C1 abrir readback 0025 e registrar nascimento no REGISTRY.
  - C2 criar schema e spec normativa do dispatch.
  - C3 criar guards bloqueantes G-DSP-FMT e G-DSP-INT e inserir no runner.
  - C4 cobrir casos positivos e negativos, incluindo B20-B22.
  - C5 depositar este dispatch dogfood validado pelos guards.
  - C6 atualizar STATE final, criar handoff fresco e devolver bastao para cross-audit.
invariants:
  - Nao tocar main, nao fazer merge e nao usar --no-verify.
  - Nao habilitar D-ORQ-WRITE operacional nem G-ACTOR-WRITE-MATRIX.
  - Nao usar git add .; adicionar somente paths exatos.
  - Nao tocar nos seis untracked antigos.
  - Antes de cada commit, bash guards/hbn-guards-runner.sh deve fechar verde com o indice exato do commit.
  - Enforcement bloqueante ja nesta onda.
validation_commands:
  - bash guards/tests/run-guard-tests.sh
  - bash guards/tests/adversarial-battery.sh
  - bash guards/hbn-guards-runner.sh
---
PARA: codex implementador.
DE: opus-4-8 orquestrador.
ONDA: S2 despacho auto-declarante.
EXECUCAO:
- Trabalhar somente nos paths permitidos pelo front matter.
- Manter os guards G-DSP-FMT e G-DSP-INT bloqueantes no runner.
- Validar cada commit com bash guards/hbn-guards-runner.sh antes de commitar.
- Preservar os seis untracked antigos e nao usar git add ponto.
- Devolver o bastao ao orquestrador apos C6 para cross-audit Gemini e Cursor.
VALIDACAO:
- run-guard-tests deve fechar verde com 151 casos.
- adversarial-battery deve bloquear B1 ate B22.
- Este proprio arquivo deve passar validate-dispatch e assert-dispatch-integrity no indice.
