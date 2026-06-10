---
titulo: PROMPT — Codex consolida lotes C1–C7 (ratificação pós-hearback)
id-global: 20260610-31
tipo: prompt
status: accepted
temperatura: frio
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN) — hearback de Maurício registrado em .hbn/hearbacks/0001
tier: T2 (executa exatamente o readback 0001; hearback confirmed)
---

# CODEX · CONSOLIDAÇÃO C1–C7 · BASTÃO: codex (consolidador)

Você é o Codex, consolidador. Maurício APROVOU os 5 lotes (C1–C7) em
2026-06-10. Sua onda executa EXATAMENTE o action_plan do readback ativo —
nada além, nada aquém.

## Read-list (nesta ordem, e só isto)

1. `.hbn/readbacks/0001-consolidacao-c1-c7.json` — seu contrato (action_plan
   de 7 passos, scope.files_allowed, out_of_scope).
2. `.hbn/hearbacks/0001-consolidacao-c1-c7.json` — a autorização (confirmed).
3. `REGISTRY.md` — estado dos artefatos (20260610-01..31).
4. `CHANGELOG.md` §Unreleased — os bullets que você vai mover para v0.3.1.

## Execução

- `cd /Users/macbookpro/Projetos/usehbn && bash guards/hbn-guards-runner.sh`
  (o scope-lock agora TEM alvo: readback 0001, safe_track, confirmed —
  qualquer arquivo fora de `scope.files_allowed` será recusado; isso é
  desejado).
- Siga os passos 1→7 do action_plan. Flip = editar front-matter
  (PROPOSED→ACCEPTED) + appendar linha nova no REGISTRY (nunca editar linha
  antiga). Temperatura: prompts C1–C7 → frio; PROMPT_ARQUITETO v1.6 →
  ultrapassado (nota de legado do REGISTRY).
- Bump 0.3.1 conforme `reports/20260610-15-proposal-bump-versao-canonico.md`.
- **1 commit atômico** (regra de ouro ADR-013), mensagem:
  `release(protocol): adopt C1-C7 + bump 0.3.1 — hearback mauricio 2026-06-10`
  com trailer `HBN-Readback: .hbn/readbacks/0001-consolidacao-c1-c7.json`.
- Verificação final (passo 7): guards verdes + pytest verde +
  `grep -rl "status: PROPOSED" methodology/adr | wc -l` = 0 nos adotados.

## NÃO FAÇA

Conteúdo novo. Código de domínio. Tocar Credenciamento (a proposta
`inbox/credenciamento/20260610-01-0017-parametrica.md` PERMANECE proposta).
Integrar CLI. Relaxar threshold de perfil. Promover rampa classe A (segue
DRY-RUN até hearback pós-semana). Renomear história.

## Ao terminar

Appendar no REGISTRY as linhas de flip; sinal no chat:
`🔵 CONSOLIDAÇÃO C1–C7 COMMITADA — bastão devolvido a claude-fable-5
(análise V206/V207, conforme decisão de Maurício 2026-06-10)`.
