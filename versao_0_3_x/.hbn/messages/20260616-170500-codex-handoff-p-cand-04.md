---
titulo: "Handoff - P-CAND-04 area temporaria scratch"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260616-170500-codex-handoff-p-cand-04.md
id-global: 20260616-170500-codex-handoff-p-cand-04
autor: codex
readback: 0033-area-temporaria-scratch
created_at: "2026-06-16T17:05:00-03:00"
---

RELATO DE ESTADO — codex · implementador · 2026-06-16T17:05:00-03:00
STATE: ultima_atualizacao=2026-06-16T17:05:00-03:00 P-CAND-04 entregue; /scratch/ ativo
SINAIS: /scratch/ gitignored; G-SCRATCH-* bloqueantes; suites 165/165 e B1-B28 verdes
PENDENTE: cross-audit P-CAND-04; depois bloqueio total deny-by-default da zona livre
PRÓXIMA AÇÃO: Cross-audit P-CAND-04; depois bloqueio total deny-by-default da zona livre.
PARA O HUMANO: main intocada; commits C1-C5 com runner verde; trailers contiguos

## Fechamento

P-CAND-04 foi entregue sob o readback 0033. A raiz agora tem `scratch/` como
area efemera local, com `scratch/README.md` versionado como contrato e o restante
ignorado por `.gitignore`.

Entraram bloqueantes no runner:

- `guards/assert-scratch-lock.sh` bloqueia qualquer path staged sob `scratch/`
  que nao seja `scratch/README.md`.
- `guards/assert-scratch-symlink.sh` bloqueia modo Git `120000` sob `scratch/`.
- `guards/assert-scratch-ignore.sh` impede remover de `.gitignore` as linhas
  `/scratch/` e `!/scratch/README.md`.

## Evidencia mecanica

- `git check-ignore scratch/x.tmp` -> ignorado.
- `git check-ignore scratch/README.md` -> nao reportado depois do force-add do
  README versionado.
- `bash guards/tests/run-guard-tests.sh` -> 165/165 verde.
- `bash guards/tests/adversarial-battery.sh` -> B1-B28 bloqueadas.
- `bash guards/hbn-guards-runner.sh` -> verde antes de cada commit C1-C5.

## Continuidade

O bastao volta ao orquestrador para cross-audit P-CAND-04. Depois disso, a
sequencia indicada e o bloqueio total deny-by-default da zona livre. A proposta
das arvores segue parada ate aprovacao humana especifica.
