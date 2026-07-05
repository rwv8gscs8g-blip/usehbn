---
titulo: Handoff — corrente E aos 50% (anti-teatro entregue; auto-localização e legibilidade pendentes)
id-global: 20260610-67
path: .hbn/messages/20260610-03-handoff-corrente-e-50pct-fable5.md
de: claude-fable-5 (arquiteto-implementador, corrente E)
para: "Maurício (gate) + próxima janela Fable-5 limpa (Blocos 3-4)"
data: 2026-06-10
temperatura: glacier
status: congelado
relacionado: [ADR-020, guards/tests/run-guard-tests.sh, .hbn/hearbacks/0002-excecao-fable-opus.json, .hbn/results/0021, .hbn/results/0022, .hbn/relay/STATE.md]
---

# Handoff — corrente E aos ~50%

## Resumo para humano (≤10 linhas)

Os 3 bugs provados pela auditoria cruzada estão corrigidos e cada correção
tem teste negativo verde que prova o BLOQUEIO do caso ruim: hearback
fantasma (F-03), substring de path (F-02) e na-sem-hearback (F-01). ADR-020
torna isso lei: guard sem teste negativo não ativa. O gap F-04 foi fechado
com honestidade: o hearback 0001 não cobre fable×opus, então opus saiu do
campo mecânico do STATE e o draft 0002 aguarda sua assinatura. Bônus do
guard endurecido: ele expôs que a própria atribuição do STATE só passava
por teatro — perfis fable-5/codex foram atualizados com papéis exercidos
de fato e a atribuição agora passa SEM exceção. Suíte: 15/15 em sandbox
(informativa) — rode no Terminal para o veredito conclusivo. Nada ativado.

## O que decidir (hearback lote E)

- E1: ADR-020 + guards endurecidos + suíte guards/tests (evidência abaixo).
- E2: hearback 0002 — confirmar devolve opus-4-8 ao campo mecânico
  `auditores` com `hearback_ref` apontando para ele; recusar mantém opus só
  em prosa.
- E3: perfis fable-5 (`implementador`) e codex (`auditor-cruzado`) —
  adições proposed baseadas em papéis exercidos de fato (correntes D/E;
  parecer 0021).
- E4: marginais — nota schema≠gate no dual-run-spec; threshold
  parametrizado no cadence-d; órfãos de docs/prompts no G-REG.

## Evidência (verificável, não narrada)

`bash guards/tests/run-guard-tests.sh` → 15/15, saída termina em
"SUÍTE VERDE". Inclui, por guard, caso-bom e caso-ruim; os casos-ruins
reproduzem os bugs exatos das auditorias 0021/0022. Verificação extra
executada: a atribuição ANTIGA do STATE (opus + hearback 0001) é BLOQUEADA
pelo G-FAM endurecido; a NOVA passa limpa — o diff de comportamento é o
próprio fix do F-04.

## Trabalho restante da corrente E (próxima janela, chat limpo)

- Bloco 3 — auto-localização: campo `path:` obrigatório no front-matter
  (atualizar template dos tipos do ADR-011) + guard leve que recusa
  artefato numerado cujo `path:` ≠ caminho real (com teste negativo, por
  ADR-020). Os artefatos da corrente E já nascem com `path:` (dogfood).
- Bloco 4 — legibilidade: regra "toda auditoria/resultado produz
  renderização markdown legível (veredito; findings por severidade com
  evidência; recomendação por hearback; resumo ≤10 linhas); JSON é anexo de
  máquina" — provavelmente ADR-021 + ajuste no contrato de results.
- Backlog registrado (não inflado nesta metade): renumeração da faxina 36
  antes de H2 (0021/F-05); semântica de `proprietario_bastao` quando a
  próxima ação é humana (0021/F-07); G-FAM cruzar o STATE completo —
  bastão×chapéu (0022/F-05); script versionado do gate dual-run (0021/F-06).

## Caminhos criados/alterados nesta metade (1 linha cada)

- `methodology/adr/ADR-020-anti-validacao-de-teatro.md` — novo: Truth Barrier para guards + regra do teste negativo.
- `guards/assert-role-family.sh` — alterado: dereferencia hearback_ref (existe + confirmed + excecoes_cobertas exata).
- `guards/assert-registry-line.sh` — alterado: coluna exata no REGISTRY; cobre core/*.md, .hbn/models/*.json, workflows, docs/prompts órfãos.
- `guards/freeze-gate.sh` — alterado: na-obrigatório só com hearback verificável citado na justificativa.
- `guards/tests/run-guard-tests.sh` — novo: suíte 15 casos (6 FAM, 5 FRZ, 4 REG), exit 0 = verde.
- `guards/tests/fixtures/` — novo: modelos sintéticos, hearbacks, atribuições e checklists de teste (herméticos).
- `.hbn/hearbacks/0002-excecao-fable-opus.json` — novo: DRAFT pendente que cerca a exceção fable×opus (F-04).
- `.hbn/models/fable-5.json` / `.hbn/models/codex.json` — alterados: papéis exercidos de fato (proposed).
- `core/dual-run-spec.md` — alterado: nota "schema-válido ≠ gate-aprovado" (F-06).
- `core/cadence-d.md` — alterado: "<50%" → handoff_threshold do perfil (F-08).
- `.hbn/relay/STATE.md` — atualizado: corrente E 50%, atribuição corrigida (F-04), backlog em sinais.
- `REGISTRY.md` — append: seção corrente E (ids 64–67 + nota).

🔵 HBN HANDOFF READY — corrente E 50%: anti-teatro entregue e provado; Blocos 3-4 e hearback lote E pendentes.
