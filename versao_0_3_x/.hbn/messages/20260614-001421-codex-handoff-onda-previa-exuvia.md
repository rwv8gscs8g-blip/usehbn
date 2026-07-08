---
titulo: "Handoff — onda prévia Exúvia: proposta de protocolo de transição e plano da 1a muda"
tipo: handoff
status: congelado
temperatura: glacier
id-global: 20260614-001421-codex-handoff-onda-previa-exuvia
path: .hbn/messages/20260614-001421-codex-handoff-onda-previa-exuvia.md
data: 2026-06-14
autoria: "codex (implementador da onda prévia; desenho/readback do orquestrador claude-opus-4-8)"
hearback-status: "confirmed para esta onda; hearbacks formais pendentes seguem para fase-2"
relacionado: [.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md, .hbn/readbacks/0010-onda-previa-exuvia.json, .hbn/results/20260613-234731-gemini-3-5-cross-ia-onda-0009-confirma-emenda.md, .hbn/relay/STATE.md, REGISTRY.md]
---

# Onda prévia Exúvia — proposta, não execução

Esta onda autorou a proposta do protocolo Exúvia e o plano da primeira muda
`0.3.x -> 1.0.0`. Nada foi congelado, renascido ou movido. O corte real fica
para onda posterior, somente após cross-audit e ratificação humana.

## Entregue

- Proposta `.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md` com Parte A (spec candidata Exúvia) e Parte B (plano da 1a muda).
- Registro frio do parecer Gemini 0009 que estava untracked:
  `.hbn/results/20260613-234731-gemini-3-5-cross-ia-onda-0009-confirma-emenda.md`.
- Readback 0010, este handoff, STATE e REGISTRY.

## O que NÃO foi feito

Não houve congelamento da casca, renascimento da forma nova, baixa de F-01,
hearback ADR-023 formal, edição de guard, edição de `src`, edição de domínio ou
movimentação de estrutura. Os dois handoffs históricos untracked continuam fora
da cerimônia viva por B1 e foram tratados como item do inventário de casca.

## Verificação local

- `bash guards/tests/run-guard-tests.sh | tail -2` retornou
  `== resumo: 125 passaram, 0 falharam ==` e
  `SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.`
- Re-simulação com staging explícito dos paths desta onda: G-SCO, G-REG,
  G-PAR/G-NUM, G-SLF e G-RLT verdes.
- `git diff --cached --check` foi verde no índice temporário; o staging foi
  limpo depois com `git reset`.

## Decisões informais (cápsula)

Nenhuma decisão informal nova além do escopo do pedido: desenhar Exúvia agora,
auditar depois, ratificar com humano e só então executar o corte.

```
RELATO DE ESTADO — codex · implementador · 2026-06-14T00:14:21-03:00
STATE: ultima_atualizacao=2026-06-14T00:14:21-03:00 · bastão → Maurício (gate) · token FP 34a7f2f9 ativo · MODO EDUCACIONAL intermediário
SINAIS: 🔴 F-01 mantida PROPOSED; B1/B2/B3 dissolvidos apenas como plano; parecer Gemini 0009 registrado como frio
FEITO: proposta Exúvia + readback 0010 + handoff + STATE + REGISTRY escritos; corte NÃO executado
PENDENTE: cross-audit Gemini e ratificação humana; execução do corte só em onda posterior
PONTEIROS: proposta=.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md; readback=.hbn/readbacks/0010-onda-previa-exuvia.json
PRÓXIMA AÇÃO: cross-audit Gemini do plano da Exúvia; depois ratificação humana e onda de execução do corte
PARA O HUMANO: aplicar a cerimônia zsh-safe com paths explícitos; esperado suíte verde e commit com HBN-Readback: 0010 e HBN-Token-FP: 34a7f2f9
```
