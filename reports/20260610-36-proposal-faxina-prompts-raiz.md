---
id-global: 20260610-36
titulo: Faxina classe-A/T1 (DRY-RUN) — prompts órfãos da raiz → docs/prompts/ com id ADR-011
status: proposed
temperatura: quente
tipo: proposal
classe: A (manutenção mecânica, ADR-013) — em DRY-RUN conforme rampa Q2
tier: T1 (doc não-normativo; commit atômico + linhas no REGISTRY)
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente D)
executor-da-aplicacao: Maurício no Terminal (sandbox não escreve em git — knowledge 0003/0021)
evidencia: |
  `ls /Users/macbookpro/Projetos/usehbn/PROMPT_*.md` em 2026-06-10 08:04 lista
  7 arquivos na raiz; `GIT_OPTIONAL_LOCKS=0 git status --short` mostra
  PROMPT_D_CHAIN_FABLE5.md untracked. Todos violam ADR-011 Decisão 1
  (artefato fora de série sem id AAAAMMDD-NN) — criados por orquestradores
  (incl. Opus) DEPOIS da regra existir. O guard 20260610-35
  (guards/assert-registry-line.sh) impede recorrência; esta faxina limpa o estoque.
---

# Faxina dos prompts órfãos — DRY-RUN (nada foi movido)

Regra da operação: **MOVER, nunca deletar**; conteúdo intacto, só o path muda
(`git mv`; PROMPT_D é untracked → `mv` + `git add`). Cada move gera uma linha
no REGISTRY no mesmo commit. Temperatura dos movidos: **frio** (ciclos
encerrados; o de hoje, PROMPT_D, esfria quando esta corrente terminar — a
linha de move já o registra frio porque a execução será posterior ao ciclo).

## Os 7 moves (ids 51–57 reservados; se outro depósito consumir antes, renumerar na execução)

| # | de (raiz) | para | linha REGISTRY a appendar |
|---|---|---|---|
| 1 | PROMPT_ANALISE_PROFUNDA_PROTOCOLO_FABLE5.md | docs/prompts/20260610-51-prompt-analise-profunda-protocolo-fable5.md | `20260610-51 \| docs/prompts/... \| prompt \| frio \| —` |
| 2 | PROMPT_EVOLUCAO_PROTOCOLO_FABLE5.md | docs/prompts/20260610-52-prompt-evolucao-protocolo-fable5.md | `20260610-52 \| docs/prompts/... \| prompt \| frio \| —` |
| 3 | PROMPT_C1_BASTAO_FABLE5.md | docs/prompts/20260610-53-prompt-c1-bastao-fable5.md | `20260610-53 \| docs/prompts/... \| prompt \| frio \| —` |
| 4 | PROMPT_C2_CHAIN_FABLE5.md | docs/prompts/20260610-54-prompt-c2-chain-fable5.md | `20260610-54 \| docs/prompts/... \| prompt \| frio \| —` |
| 5 | PROMPT_C3_CHAIN_FABLE5.md | docs/prompts/20260610-55-prompt-c3-chain-fable5.md | `20260610-55 \| docs/prompts/... \| prompt \| frio \| —` |
| 6 | PROMPT_C6C7_CHAIN_FABLE5.md | docs/prompts/20260610-56-prompt-c6c7-chain-fable5.md | `20260610-56 \| docs/prompts/... \| prompt \| frio \| —` |
| 7 | PROMPT_D_CHAIN_FABLE5.md (untracked) | docs/prompts/20260610-57-prompt-d-chain-fable5.md | `20260610-57 \| docs/prompts/... \| prompt \| frio \| —` |

Fora do escopo (decisão consciente): `20260610-31-prompt-consolidacao-codex.md`
já tem id e linhas no REGISTRY (31/33) — movê-lo agora quebraria o nome citado
nessas linhas; candidato a move futuro com linha própria. Docs estáveis da raiz
(README, AGENTS, CHANGELOG…) são endereços, não eventos — ficam.
`AUDITORIA_SUPERPOWERS.md` e `HBN-ARCHITECTURAL-REVIEW-2026-04.md` são legado
mapeado (seção Legado do REGISTRY) — ADR-011 não exige rename de história.

## Comando atômico copiável (knowledge 0001) — SÓ após hearback

```bash
cd /Users/macbookpro/Projetos/usehbn && mkdir -p docs/prompts \
&& git mv PROMPT_ANALISE_PROFUNDA_PROTOCOLO_FABLE5.md docs/prompts/20260610-51-prompt-analise-profunda-protocolo-fable5.md \
&& git mv PROMPT_EVOLUCAO_PROTOCOLO_FABLE5.md docs/prompts/20260610-52-prompt-evolucao-protocolo-fable5.md \
&& git mv PROMPT_C1_BASTAO_FABLE5.md docs/prompts/20260610-53-prompt-c1-bastao-fable5.md \
&& git mv PROMPT_C2_CHAIN_FABLE5.md docs/prompts/20260610-54-prompt-c2-chain-fable5.md \
&& git mv PROMPT_C3_CHAIN_FABLE5.md docs/prompts/20260610-55-prompt-c3-chain-fable5.md \
&& git mv PROMPT_C6C7_CHAIN_FABLE5.md docs/prompts/20260610-56-prompt-c6c7-chain-fable5.md \
&& mv PROMPT_D_CHAIN_FABLE5.md docs/prompts/20260610-57-prompt-d-chain-fable5.md \
&& git add docs/prompts/20260610-57-prompt-d-chain-fable5.md
# em seguida: appendar as 7 linhas no REGISTRY.md (bloco pronto abaixo), git add REGISTRY.md,
# e commit: git commit -m "chore(faxina): prompts órfãos da raiz -> docs/prompts/ com id ADR-011 (T1, proposal 20260610-36)"
```

Bloco REGISTRY pronto para colar:

```
| 20260610-51 | docs/prompts/20260610-51-prompt-analise-profunda-protocolo-fable5.md | prompt | frio | — |
| 20260610-52 | docs/prompts/20260610-52-prompt-evolucao-protocolo-fable5.md | prompt | frio | — |
| 20260610-53 | docs/prompts/20260610-53-prompt-c1-bastao-fable5.md | prompt | frio | — |
| 20260610-54 | docs/prompts/20260610-54-prompt-c2-chain-fable5.md | prompt | frio | — |
| 20260610-55 | docs/prompts/20260610-55-prompt-c3-chain-fable5.md | prompt | frio | — |
| 20260610-56 | docs/prompts/20260610-56-prompt-c6c7-chain-fable5.md | prompt | frio | — |
| 20260610-57 | docs/prompts/20260610-57-prompt-d-chain-fable5.md | prompt | frio | — |
```

DONE-check desta proposta: os 7 órfãos listados com destino, id e linha de
REGISTRY; zero arquivo movido neste dry-run (verificável: `git status` não
mostra renames).
