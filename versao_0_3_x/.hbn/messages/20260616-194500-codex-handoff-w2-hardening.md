---
titulo: "Handoff - W2 hardening dos guards"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260616-194500-codex-handoff-w2-hardening.md
id-global: 20260616-194500-codex-handoff-w2-hardening
autor: codex
readback: 0034-hardening-guards
created_at: "2026-06-16T19:45:00-03:00"
---

RELATO DE ESTADO — codex · implementador · 2026-06-16T19:45:00-03:00
STATE: ultima_atualizacao=2026-06-16T19:45:00-03:00 W2 entregue; B29-B32 bloqueadas
SINAIS: W2 entregue; run-guard-tests 175/175; adversarial-battery B1-B32 verde
PENDENTE: cross-audit W2; P-CAND-04 sera selado junto na proxima selagem
PRÓXIMA AÇÃO: Cross-audit W2; P-CAND-04 sera selado junto na proxima selagem; depois avaliar deny-by-default/freeze.
PARA O HUMANO: main intocada; commits C1-C7 com runner verde; trailers contiguos

## Fechamento

W2 foi entregue sob o readback 0034. As correcoes aplicadas foram:

- G-KNOW-INDEX agora exige token inteiro para basename e bloqueia ponteiro morto no INDEX.
- G-FRONTDOOR agora aplica teto de 8192 bytes, valida marcadores da read-list e exige existencia dos paths concretos.
- G-EXC agora aceita trailers apenas no ultimo paragrafo nao-vazio da mensagem.
- G-SCRATCH-LOCK/SYMLINK/IGNORE agora falham fechado quando a versao ativa nao resolve.
- O comentario stale de G-REG foi corrigido para refletir que o guard esta no runner.

## Evidencia mecanica

- `bash guards/tests/run-guard-tests.sh` -> 175/175 verde.
- `bash guards/tests/adversarial-battery.sh` -> B1-B32 bloqueadas.
- `bash guards/hbn-guards-runner.sh` -> verde antes de cada commit C1-C7.
- `git rev-parse main` -> 4db692876381a0d7909985c8500d999f2e677b04.

## Continuidade

O bastao volta ao orquestrador para cross-audit W2. P-CAND-04 deve ser selado
junto na proxima selagem; depois disso, avaliar a sequencia deny-by-default e
freeze.
