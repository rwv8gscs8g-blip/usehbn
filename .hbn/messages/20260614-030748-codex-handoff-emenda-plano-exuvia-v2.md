---
titulo: "Handoff — emenda do plano hbn-exuvia v2"
tipo: handoff
status: proposed
temperatura: quente
id-global: 20260614-030748-codex-handoff-emenda-plano-exuvia-v2
path: .hbn/messages/20260614-030748-codex-handoff-emenda-plano-exuvia-v2.md
data: 2026-06-14
created_at: "2026-06-14T03:07:48-03:00"
autoria: "codex (implementador da emenda; desenho/readback do orquestrador claude-opus-4-8)"
hearback-status: "confirmed para esta M1; execucao do corte depende de cross-audit e ratificacao"
relacionado: [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md, .hbn/readbacks/0011-emenda-plano-exuvia-v2.json, .hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md, .hbn/relay/STATE.md, REGISTRY.md]
---

# Emenda do plano hbn-exuvia v2

Esta onda atualizou o plano Exuvia para v2. Nada foi congelado, renascido,
movido ou cortado. O plano 0010 foi supersedido via `REGISTRY.md`, e o arquivo
antigo ficou preservado.

## Entregue

- Proposta `.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md`.
- Registro frio do parecer Gemini 0010:
  `.hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md`.
- Readback 0011, este handoff, STATE e REGISTRY.

## O que NÃO foi feito

Nao houve congelamento da casca, criacao de tag, branch arquival, renascimento,
baixa de F-01, publicacao de sinal de dependencia, criacao de painel/logs,
edicao de guard, edicao de `src`, edicao de dominio ou movimentacao de ledger.

## Verificação local

- `bash guards/tests/run-guard-tests.sh | tail -2` retornou
  `== resumo: 125 passaram, 0 falharam ==` e
  `SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.`
- Re-simulacao G-SCO/G-REG/G-PAR/G-SLF/G-RLT: a executar com staging explicito
  temporario e limpeza posterior do indice.

## Decisões informais (cápsula)

- Convenção escolhida: supersedencia via coluna `superseded_by` no REGISTRY,
  sem editar a proposta 0010.
- `hbn-exuvia` e o nome oficial a documentar em spec/ADR durante M2.
- Painel, trilha de aprendizagem, retencao fria e politica do arquiteto foram
  incorporados ao plano, mas nao criados nesta M1.

```text
RELATO DE ESTADO — codex · implementador · 2026-06-14T03:07:48-03:00
STATE: ultima_atualizacao=2026-06-14T03:07:48-03:00 · bastão → gemini-3-5 · token FP 34a7f2f9 ativo
SINAIS: 🔴 F-01 mantida PROPOSED; plano 0010 supersedido por v2; corte não executado
FEITO: plano v2 + readback 0011 + handoff + STATE + REGISTRY escritos; Gemini 0010 registrado como frio
PENDENTE: cross-audit Gemini; depois ratificação humana e M2
PONTEIROS: plano=.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md; readback=.hbn/readbacks/0011-emenda-plano-exuvia-v2.json
PRÓXIMA AÇÃO: cross-audit Gemini do plano v2; depois ratificação e M2 (execução do corte)
PARA O HUMANO: aplicar cerimônia zsh-safe com paths explícitos; commit com HBN-Readback: 0011 e HBN-Token-FP: 34a7f2f9
```
