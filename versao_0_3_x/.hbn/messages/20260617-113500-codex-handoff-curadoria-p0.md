---
titulo: "Handoff - Curadoria P0 docs"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260617-113500-codex-handoff-curadoria-p0.md
id-global: 20260617-113500-codex-handoff-curadoria-p0
autor: codex
readback: 0045-curadoria-p0-docs
created_at: "2026-06-17T11:35:00-03:00"
---

# RELATO DE ESTADO — codex · implementador · 2026-06-17T11:35:00-03:00
STATE: ultima_atualizacao=2026-06-17T11:35:00-03:00 Curadoria P0 docs entregue no branch `proposta/reestruturacao-m-a-s0`.
SINAIS: AGENTS.md corrigido verbatim; docs/GLOSSARY.md criado; docs/MATURITY-MATRIX.md reduzido a stub; REGISTRY atualizado; pytest 213/213; adversarial B1-B33 verde.
PRÓXIMA AÇÃO: Cross-audit ≠-familia + selagem da Curadoria P0; depois R2 arvores registry-centric.
PARA O HUMANO: bastao retorna ao orquestrador; nenhum arquivo fora do escopo 0045 foi alterado.

## Placar

| item | arquivo:linha | saida |
|---|---|---|
| Porta de entrada corrigida | `AGENTS.md:10`, `AGENTS.md:32`, `AGENTS.md:33`, `AGENTS.md:74`, `AGENTS.md:95`, `AGENTS.md:98` | Bloco aprovado aplicado verbatim; `modules/` e `radar/` aparecem apenas para dizer que nao existem e na nota de versao da curadoria. |
| Glossario canonico | `docs/GLOSSARY.md:1`, `docs/GLOSSARY.md:7` | Arquivo criado com 92 linhas a partir do bloco aprovado. |
| Matriz duplicada deduplicada | `docs/MATURITY-MATRIX.md:1` | Arquivo preservado como stub de 4 linhas apontando para `methodology/MATURITY-MATRIX.md`. |
| REGISTRY | `REGISTRY.md:1002`, `REGISTRY.md:1004`, `REGISTRY.md:1005`, `REGISTRY.md:1006`, `REGISTRY.md:1007` | Linhas adicionadas para readback, glossario, redirect da matriz, STATE final e este handoff. |
| STATE | `.hbn/relay/STATE.md:4`, `.hbn/relay/STATE.md:5`, `.hbn/relay/STATE.md:14`, `.hbn/relay/STATE.md:16` | Onda marcada como entregue, proxima acao = cross-audit ≠-familia + selagem; G-EXC 0045 permanece visivel. |
| Links de AGENTS | comando local | `checked=20`, `missing=NONE` para links markdown; o token cru `core/cartao-entrada.md` e descrito no texto como destino futuro, nao como link atual. |
| Suite pytest | comando local | `.venv/bin/pytest -q` -> `213 passed in 0.75s`. |
| Bateria adversarial | comando local | `bash guards/tests/adversarial-battery.sh` -> `BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.` |
| Main preservada | comando local | `git rev-parse main` -> `4db692876381a0d7909985c8500d999f2e677b04`. |

## Commits

- C1 `2347443` — `curadoria-p0: abre readback 0045`
- C2 `642d8e9` — `curadoria-p0: corrige AGENTS.md (remove modules/ e radar/ inexistentes; core/ como specs vivas; aponta methodology/, glossario, esteira)`
- C3 `463ae1e` — `curadoria-p0: cria glossario canonico docs/GLOSSARY.md`
- C4 `899e402` — `curadoria-p0: reduz docs/MATURITY-MATRIX.md a stub de redirect (dedup)`
- C5 — `curadoria-p0: atualiza state e handoff`

## Guardrails

- Nao houve merge, `--no-verify` ou `git add .`.
- Paths tocados nesta onda: `.hbn/readbacks/0045-curadoria-p0-docs.json`, `AGENTS.md`, `docs/GLOSSARY.md`, `docs/MATURITY-MATRIX.md`, `.hbn/relay/STATE.md`, `REGISTRY.md` e este handoff.
- Fora de escopo preservado: `main`, `guards/**`, `schemas/**`, `src/**`, `core/**`, `methodology/**`, outros `docs/**` e `docs/brainstorm/**`.
- Trailers contiguos usados nos commits: `HBN-Readback: 0045`, `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)`, `HBN-Token-FP: 34a7f2f9`.

## Continuidade

1. Orquestrador retoma o bastao.
2. Rodar cross-audit ≠-familia da Curadoria P0.
3. Selar 0045 se os pareceres aprovarem.
4. Depois seguir R2 arvores registry-centric.
