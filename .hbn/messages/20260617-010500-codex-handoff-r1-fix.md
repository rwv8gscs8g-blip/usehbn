---
titulo: "Handoff - R1-fix dedup estado"
tipo: handoff
status: final
temperatura: quente
path: .hbn/messages/20260617-010500-codex-handoff-r1-fix.md
id-global: 20260617-010500-codex-handoff-r1-fix
autor: codex
readback: 0039-r1-fix-dedup-estado
created_at: "2026-06-17T01:05:00-03:00"
---

# RELATO DE ESTADO — codex · implementador · 2026-06-17T01:05:00-03:00
STATE: ultima_atualizacao=2026-06-17T01:05:00-03:00 R1-fix dedup estado entregue no branch `proposta/reestruturacao-m-a-s0`.
SINAIS: R1-fix entregue; pytest 212/212; adversarial B1-B33 verde; G-EXC ativo com implementador=codex.
PRÓXIMA AÇÃO: re-cross-audit R1+R1-fix nao-OpenAI, depois selagem R1.
PARA O HUMANO: o bloqueador de duplicacao em `decisions` e `context_history` foi corrigido sem tocar CLI, guards, core, schemas, constituicao ou brainstorm.

## Commits

- C1 `aeaf692` — `r1-fix: abre readback 0039`
- C2 `5d47b17` — `r1-fix: dedup de decisions e context_history no merge`
- C3 `b04319d` — `r1-fix: teste de nao-duplicacao com fixtures nao-vazias`
- C4 — `r1-fix: atualiza state e handoff`

## Placar de evidencias

- Implementacao: `src/usehbn/state/store.py:94` define identidade por `execution_id` quando presente e por conteudo JSON deterministico quando ausente; `src/usehbn/state/store.py:103` aplica dedup preservando a primeira ocorrencia; `src/usehbn/state/store.py:117` e `src/usehbn/state/store.py:118` usam o dedup para `decisions` e `context_history`.
- Teste com ids: `tests/test_state_dual_read.py:126` cria fixtures canonica+legado nao-vazias; `tests/test_state_dual_read.py:181` confirma que `decisions` e `context_history` tem `exec-shared` uma vez e que canonico vence.
- Teste sem ids: `tests/test_state_dual_read.py:196` cobre dedup por conteudo; `tests/test_state_dual_read.py:251` confirma que o item compartilhado sem id aparece uma vez em `decisions`; `tests/test_state_dual_read.py:252` faz o mesmo para `context_history`.
- Antes (sonda in-memory com `HEAD~2:src/usehbn/state/store.py`): `old_logic decisions: len=4 shared_count=2 ids=['exec-shared', 'exec-only-canonical', 'exec-shared', 'exec-only-legacy']`; `old_logic context_history: len=4 shared_count=2 ids=['exec-shared', 'exec-only-canonical', 'exec-shared', 'exec-only-legacy']`.
- Depois: `.venv/bin/pytest tests/test_state_dual_read.py` -> `7 passed in 0.03s`.
- Suite completa: `.venv/bin/pytest -q` -> `212 passed in 0.74s`.
- Adversarial: `bash guards/tests/adversarial-battery.sh` -> `BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.`

## Guardrails

- `main` permaneceu em `4db692876381a0d7909985c8500d999f2e677b04`.
- Nenhum arquivo em `main`, `core/**`, `guards/**`, `schemas/**`, `docs/brainstorm/**` ou `src/usehbn/cli.py` foi modificado.
- Antes de cada commit C1-C4, `bash guards/hbn-guards-runner.sh` rodou verde com o indice preparado.
- Trailers contiguos usados em todos os commits: `HBN-Readback: 0039`, `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)`, `HBN-Token-FP: 34a7f2f9`.
- Arquivos untracked preexistentes em `.hbn/results/**`, `.hbn/state/**` e `docs/brainstorm/**` foram preservados e nao staged.

## Continuidade

1. Orquestrador retoma para re-cross-audit R1+R1-fix por familia nao-OpenAI.
2. Se aprovado, selar R1; so depois retomar R2 arvores registry-centric/freeze.
