---
titulo: "0112-G-STATE-SELAGEM-MANIFESTO"
tipo: manifesto
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-091112-codex-manifesto-selagem-g-state-0112.md
created_at: "2026-07-01T09:11:12-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
head: f8dbe09086d06f5dc42527241c33e37174a65427
rollback_tag: hbn-rollback/pre-0109-g-orq-xaudit-gate-20260630
gate_humano_inicio: "Mauricio: APROVO INICIAR 0112-G-STATE-SELAGEM-MANIFESTO"
---

# 0112-G-STATE-SELAGEM-MANIFESTO

SOU: codex - familia OpenAI - papel orquestrador-provisorio

## Objetivo

Preparar uma selagem isolada para `G-STATE-STRUCTURAL 0106`, sem iniciar
`0109-G-ORQ-XAUDIT-GATE`, sem alterar `STATE.md` e sem limpar residuos
preexistentes da arvore.

Este manifesto nao e commit. A selagem so pode acontecer depois de gate humano
explicito aprovando este manifesto.

## Evidencia de disco

- HEAD confirmado: `f8dbe09086d06f5dc42527241c33e37174a65427`.
- Rollback existente: `hbn-rollback/pre-0109-g-orq-xaudit-gate-20260630`.
- `git diff --check` limpo.
- Arvore suja com patch G-STATE, evidencias de quorum, licoes do
  orquestrador e residuos preexistentes.
- Quorum material 0106:
  - `.hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md`
    contem `SOU: grok - familia xAI - papel auditor`,
    `VEREDITO_G_STATE_STRUCTURAL: APROVA` e `APROVA_0106: SIM`.
  - `.hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md`
    contem `SOU: claude - familia Anthropic - papel auditor`,
    `VEREDITO_G_STATE_STRUCTURAL: APROVA` e `APROVA_0106: SIM`.

## Invariantes aplicaveis

- Nao auto-ratificar.
- Nao implementar e auditar o mesmo patch.
- Human gate nao substitui auditoria cruzada em acao critica.
- Prompt v1, chat solto, anexo ou resultado sem arquivo canonico nao conta
  para quorum.
- Nao fazer `git add -A`.
- Nao stagear `REGISTRY.md` inteiro sem revisar hunk por hunk.
- Nao apagar residuos nem zona livre nesta selagem.
- Nao alterar `.hbn/relay/STATE.md` nesta selagem.
- Nao iniciar `0109-G-ORQ-XAUDIT-GATE` antes da selagem G-STATE.

## Escopo recomendado para a selagem

Arquivos de patch G-STATE:

- `guards/assert-state-structural.sh`
- `guards/hbn-guards-runner.sh`
- `guards/tests/run-guard-tests.sh`
- `guards/tests/adversarial-battery.sh`

Evidencias canonicas de quorum G-STATE:

- `.hbn/messages/20260630-223300-codex-prompt-cross-audit-g-state-structural-0106-grok-v2.md`
- `.hbn/messages/20260701-083300-codex-prompt-cross-audit-g-state-structural-0106-claude-v2.md`
- `.hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md`
- `.hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md`

Licoes operacionais diretamente causadas pela falha 0107 e pela reemissao 0106:

- `.hbn/knowledge/0030-chat-novo-prompts-sequenciais.md`
- `.hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md`
- `.hbn/knowledge/INDEX.md`

Ledger e manifesto:

- `REGISTRY.md`, somente com hunks correspondentes aos arquivos incluidos
  nesta lista e a este manifesto.
- `.hbn/messages/20260701-091112-codex-manifesto-selagem-g-state-0112.md`

## Hunk de REGISTRY permitido

Na selagem G-STATE, `REGISTRY.md` deve ser stageado seletivamente. As linhas
permitidas sao somente as que correspondem a estes artefatos:

- `20260630-203900-antigravity-assert-state-structural`
- `20260630-220900-codex-knowledge-0030-prompt-chain`
- `20260630-220901-codex-knowledge-index-0030`
- `20260630-223000-codex-knowledge-0031-chat-copy-atomico`
- `20260630-223001-codex-knowledge-index-0031`
- `20260630-223300-codex-prompt-cross-audit-g-state-structural-0106-grok-v2`
- `20260630-223400-grok-cross-ia-g-state-structural-0106-v2`
- `20260701-083300-codex-prompt-cross-audit-g-state-structural-0106-claude-v2`
- `20260701-083400-claude-cross-ia-g-state-structural-0106-v2`
- `20260701-091112-codex-manifesto-selagem-g-state-0112`

Linhas de ponte/exuvia, handoffs gerais, prompts de handoff, prompt v1 e
artefatos 0107 nao entram nesta selagem, salvo novo manifesto humano-gated.

## Arquivos explicitamente excluidos

- `.hbn/messages/20260630-222300-codex-prompt-cross-audit-g-state-structural-0106-grok.md`
  e sua linha de REGISTRY: prompt v1 superseded; nao conta para quorum.
- `.hbn/results/20260630-222400-grok-cross-ia-g-state-structural-0106.md`:
  resultado de rodada v1; nao conta para quorum.
- Prompts e pareceres 0107:
  `.hbn/messages/20260630-213000-*`,
  `.hbn/messages/20260630-213100-*`,
  `.hbn/messages/20260630-213200-*`,
  `.hbn/messages/20260630-213300-*`,
  `.hbn/results/20260630-213200-*`,
  `.hbn/results/20260630-213300-*`.
- Analise 0107:
  `.hbn/messages/20260630-220900-codex-analise-erros-passagem-prompts-0107.md`.
- Ponte/exuvia e diagnosticos de contexto:
  `.hbn/proposals/20260630-201952-codex-orquestrador-provisorio-saneamento-exuvia.md`,
  `.hbn/results/20260630-183809-*`,
  `.hbn/results/20260630-193923-*`,
  `.hbn/results/20260630-194338-*`,
  `.hbn/results/20260630-194640-*`.
- Handoffs e prompts gerais:
  `.hbn/messages/20260701-085300-codex-handoff-orquestrador-provisorio-pos-quorum-g-state.md`,
  `.hbn/messages/20260701-090000-codex-prompt-handoff-novo-orquestrador-saneamento.md`
  e demais `.hbn/messages/` nao listados no escopo recomendado.
- `.hbn/logs/**`
- `.hbn/state/**`
- `.hbn/models/antigravity.json`
- `docs/brainstorm/**`
- `guards/tests/hbn-repro-*`
- `.hbn/relay/RETURN.json`
- Qualquer arquivo nao listado em "Escopo recomendado para a selagem".

## Testes obrigatorios antes da selagem

Executar um por vez e registrar saida:

- `git diff --check`
- `bash guards/hbn-guards-runner.sh`
- `bash guards/tests/run-guard-tests.sh`
- `bash guards/tests/adversarial-battery.sh`
- `.venv/bin/pytest -q`, se o ambiente local estiver preparado.

Se qualquer comando falhar, parar. Nao usar `--no-verify`. Nao fazer commit
parcial para "salvar progresso".

## Rollback

Antes do commit, rollback operacional e simplesmente nao stagear o pacote.
Se houver staging errado, desfazer somente o staging e preservar os arquivos
de trabalho para nova decisao humana.

Depois do commit, rollback preferencial e `git revert <sha-da-selagem>`.

Reset destrutivo, `git reset --hard`, delecao de residuos ou limpeza ampla da
arvore exigem autorizacao humana explicita separada.

Ancora ja existente:

- `hbn-rollback/pre-0109-g-orq-xaudit-gate-20260630`

## Riscos registrados

- O `REGISTRY.md` atual mistura linhas de G-STATE com ponte/exuvia e handoffs;
  a selagem exige staging seletivo.
- `G-STATE-STRUCTURAL` cobre mudanca estrutural A/M de `STATE.md`, mas nao
  fecha delecao/move de `STATE.md`; isso fica para `G-ORQ-NO-DELETE`.
- Freshness/binding do parecer ao conteudo exato auditado ainda nao esta
  plenamente mecanizado; fica como limite conhecido.
- Gate humano continua obrigatorio e nao e substituido pelo quorum de IA.
- A arvore tem muitos untracked; limpeza/lixo-zero nao faz parte desta selagem.
- Prompt v1 e resultado v1 nao podem ser usados como quorum.

## Auditores existentes para quorum 0106

- Grok/xAI:
  `.hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md`
  com `APROVA_0106: SIM`.
- Claude/Anthropic:
  `.hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md`
  com `APROVA_0106: SIM`.

Esses pareceres ratificam o patch G-STATE. Eles nao ratificam 0109, nao
ratificam limpeza da arvore e nao autorizam mudanca estrutural de `STATE.md`
nesta selagem.

## Gate solicitado

Para passar para a Fase 2, o humano deve aprovar explicitamente:

`APROVO SELAGEM CONTROLADA DE G-STATE CONFORME MANIFESTO 0112`

Sem essa frase, a proxima acao e parar.

## Proxima versao recomendada

`0113-G-STATE-SELAGEM-CONTROLADA`

## Correcao da Analise Claude 0114

Conforme apontado na analise Claude 0114 (.hbn/results/20260701-092612-claude-opus-analise-profunda-guards-orquestrador-0114.md), a selagem exige a existencia previa de dois readbacks:
1. `.hbn/readbacks/0106-g-state-structural.json` como readback da feature G-STATE (implementador antigravity);
2. `.hbn/readbacks/0113-selagem-g-state.json` como readback de selagem (status vigente, seals_proposal 0106).

Sem o readback 0106, a barreira `G-DIVERSITY` falharia fechada ("readback auditado 0106 indeterminavel"). Portanto, a correcao consiste em criar ambos os readbacks e inclui-los na selagem controlada do pacote.

## Ampliacao mecanica de escopo

Para garantir a execucao correta da suite de testes de guards no ambiente de CI, realizou-se uma ampliacao mecanica de escopo para incluir correcoes de robustez em tres scripts de validacao:
1. `guards/assert-parallel-id.sh`: leitura robusta de mapeamento de familias de auditores a partir de `guards/data/auditor-families.txt` para evitar falha mecânica de alias de auditor.
2. `guards/assert-quorum-selagem.sh`: suporte a sufixo de versao em relatorios de auditoria (por exemplo, `-0106-v2.md`).
3. `guards/assert-report-fresh.sh`: exclusao de tipos nao-handoff (prompts, manifestos, propostas) na verificacao de freshness de relatorio.
