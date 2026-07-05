---
titulo: "Parecer Cross-IA — o orquestrador e o bug de protocolo"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260614-200849-codex-cross-ia-orquestrador-bug.md
id-global: 20260614-200849-codex-cross-ia-orquestrador-bug
autoria: codex
familia: OpenAI
created_at: "2026-06-14T20:08:49-03:00"
---

IDENTIDADE: sou Codex, token `codex`, familia OpenAI.

# Parecer independente: o orquestrador e o bug

## Veredito

ORQUESTRADOR_INSEGURO: SIM.

O protocolo contem freios bons para artefatos ja staged/commitados, mas ainda
nao contem freios suficientes para constranger o orquestrador antes da acao.
A causa-raiz nao e falta de G-REG/G-NUM: esses guards ja dao dente ao ledger e
ao slug. A causa-raiz e que o contrato do orquestrador permanece, por desenho,
doutrina-sem-enforcement; a sessao conversacional que declara, roteia e
despacha consegue derivar antes de produzir um artefato validavel.

## Confirmacao dos itens E

E1: parcial / nao verificavel integralmente no Git. No estado atual nao existe
arquivo `181924-opus` em `.hbn/messages/`, e `git log --all --name-status --
.hbn/messages` nao preserva entrada com `181924` ou `opus`. Logo, se houve
escrita direta e posterior remocao, ela foi working tree nao commitada ou veio
de contexto externo ao Git. A regra mecanica que teria bloqueado o commit
existe: G-REG exige linha no REGISTRY no mesmo commit para `.hbn/messages/`
novos (`guards/assert-registry-line.sh:85-135`), e o runner chama G-REG
(`guards/hbn-guards-runner.sh:49-64`).

E2: confirmado como ausencia de prova verificavel, nao como leitura mental. O
contrato exige "verificar no disco antes de afirmar" e cita arquivo:linha
(`core/orchestrator-profile-spec.md:28-30`), alem de warm boot por leitura da
read-list (`core/orchestrator-profile-spec.md:116-122`). Nao encontrei
artefato de entrada do orquestrador com relato de leitura para esta derivacao.
O G-RLT so verifica `tipo: entrada` quando ha handoff staged com esse front
matter (`guards/assert-report-fresh.sh:129-151`); nao ha prova universal de
boot-read para toda janela conversacional.

E3: parcialmente confirmado. O estado M-A registra Opus como
"orquestrador/desenho" e Codex como implementador (`.hbn/relay/STATE.md:10-14`,
`:37-42`), e o readback confirma que Opus desenhou/despachou enquanto Codex
implementou (`.hbn/readbacks/0012-M-A-scaffold-inativo.json:12-16`). Nao achei
`BOOT-orquestrador` no disco. O problema real e que nao ha guard de
"declaracao-antes-de-acao" que obrigue a aprovacao humana antes de qualquer
despacho conversacional ou artefato preparatorio.

E4: confirmado no resultado observavel do disco. O STATE exige cross-audit
Gemini+Grok (`.hbn/relay/STATE.md:12`, `:14`, `:40`), mas o disco contem apenas
o parecer M-A de Gemini em `.hbn/results/20260614-193452-gemini-3-5-cross-ia-m-a-scaffold.md`.
Nao ha parecer Grok M-A gravado. Tambem confirmo que slug maiusculo seria
bloqueado por G-NUM: o slug aceito e `^[a-z0-9][a-z0-9-]*` apos token exato
(`guards/assert-parallel-id.sh:138-159`).

E5: nao confirmado no disco por nome. Busca textual nao encontrou
`BOOT-orquestrador` preservado. A critica, porem, e procedente como desenho:
o contrato diz que o disco e o ativo e que a janela nova deve ler contrato +
read-list canonica (`core/orchestrator-profile-spec.md:18-24`, `:116-122`).
Um boot separado e fora desse mapa aumenta o risco de fonte canonica
fragmentada.

E6: confirmado como falha de interface. O handoff M-A deixa ao humano "revisar
diff e decidir commit por paths explicitos" (`.hbn/messages/20260614-183746-codex-handoff-m-a-scaffold-inativo.md:17-18`)
e o resultado M-A lista "Pontos para Gemini + Grok" (`.hbn/results/20260614-183746-codex-m-a-scaffold-inativo.md:106-115`).
Isso nao e uma interface ruim por si so, mas combinado com despacho externo
mal parametrizado gera exatamente o humano-carteiro que a camada de abstracao
deveria evitar (`core/orchestrator-profile-spec.md:48-56`).

E7: confirmado como lacuna mecanica. O contrato exige cabecalho com PAPEL,
BASTAO, CONTEXTO e MODO EDUCACIONAL (`core/orchestrator-profile-spec.md:82-90`)
e clausula de fadiga em `handoff_threshold` (`core/orchestrator-profile-spec.md:44-47`).
Mas o proprio documento declara que o conteudo e doutrina-sem-enforcement e
que `MODO EDUCACIONAL` esta fora do G-RLT (`core/orchestrator-profile-spec.md:136-147`).
Nao ha guard que force `%contexto` declarado em toda resposta do orquestrador.

## Confirmacao dos itens D

D1: confirmado. `271ca85bf5ccf2f06b7505262ce27b471608486e` esta em
`proposta/M-A-scaffold-inativo`, nao em `main`; `main` aponta para `4db6928`.
O commit inclui scaffold inteiro, guards, rollback, STATE, REGISTRY, handoff,
readback, resultado Codex e parecer Gemini. Autor/committer:
`claude-fable-5 (Cowork)`, trailers `HBN-Readback:
0012-M-A-scaffold-inativo`, `HBN-Human-Authorization: Mauricio (...)`,
`HBN-Token-FP: 34a7f2f9`.

D2: confirmado. Para M-A ha somente dois arquivos de resultado no disco:
o resultado de implementacao Codex e o parecer Gemini. Nao ha segundo parecer
cross-family gravado para Grok, apesar de `auditores: [gemini-3-5, grok]` no
STATE (`.hbn/relay/STATE.md:37-42`).

D3: confirmado. O rollback calcula `active_rel` e `state_path` antes do reset
(`scripts/hbn-exuvia-rollback.sh:67-81`), executa `git reset --hard "$TARGET"`
depois (`scripts/hbn-exuvia-rollback.sh:114`) e continua usando o `state_path`
antigo (`scripts/hbn-exuvia-rollback.sh:116-127`). Se o target mudar
`.hbn/active-version`, o script reconcilia o STATE no caminho errado ou falha.

D4: confirmado. G-NUM bloqueia evento novo sem
`AAAAMMDD-HHMMSS-<agente>-<slug>` e exige slug minusculo (`guards/assert-parallel-id.sh:125-159`).
O CI Shield e o backstop real porque hooks locais ausentes nao executam a si
mesmos; o proprio parecer Gemini registrou isso (`.hbn/results/20260614-193452-gemini-3-5-cross-ia-m-a-scaffold.md:53-55`).
Branch protection segue pendente no STATE (`.hbn/relay/STATE.md:25`). Fixtures
temporarias estao untracked em `guards/tests/cr-*` e `guards/tests/adv-*`.

## Causa-raiz no protocolo

1. O orquestrador tem contrato, mas nao tem gate de entrada universal. A
read-list existe, porem so vira evidencia mecanica quando algum artefato
staged aciona G-RLT. A conversa que antecede o artefato continua fora do
alcance dos guards.

2. O runner valida o commit, nao o ator. Nao ha matriz mecanica que diga
"orquestrador nao escreve no ledger governado". G-REG garante linha no
REGISTRY; nao garante que o papel correto escreveu.

3. A ordem do gate nao esta codificada como maquina de estados. Hoje o
protocolo bloqueia nomes, linhas, ponteiros, escopo e algumas familias; ele
nao bloqueia "implementacao + primeira auditoria no mesmo commit antes da
segunda auditoria e ratificacao".

4. O despacho para auditores e texto livre. Nao ha schema que force token
auto-declarado, familia, output path, id-global, requisito de nao editar
manualmente, nem exclusao dinamica de fornecedor. Por isso um prompt com
`gemini-3-5` fixo pode ser reaproveitado para outro auditor e corromper a
identidade.

5. A diversidade/familia do auditor fica fraca no runner. O G-FAM em modo
runner so checa `implementador ∉ auditores` (`guards/assert-role-family.sh:34-71`).
A checagem completa de fornecedor e papel existe, mas e modo sob demanda com
JSON de atribuicao (`guards/assert-role-family.sh:83-185`).

6. Contexto e fadiga sao doutrina, nao enforcement. O documento reconhece a
lacuna (`core/orchestrator-profile-spec.md:136-147`). Sem medicao ou recibo de
contexto, o orquestrador pode operar em tunel sem que o protocolo o pare.

## Alternativas concretas

1. G-ORQ-NOWRITE: criar matriz de permissao por papel e token. Se
`STATE.atribuicao.chapeu_atual` ou um `HBN_ACTOR_TOKEN` declarado indicar
orquestrador, bloquear alteracoes em `.hbn/messages/`, `.hbn/results/`,
`REGISTRY.md`, `core/`, `guards/` e `scripts/`, salvo artefato frio de log em
`logs/` ou dispatch schema permitido. Resolve E1/E3. Custo: medio, porque
exige declarar ator de forma confiavel no rito local; sem isso, vira teatro.

2. G-BOOT-READ: toda janela de orquestrador precisa depositar um artefato de
entrada `tipo: entrada` com `RELATO DE LEITURA` e citacoes arquivo:linha antes
de qualquer despacho ou proposta. O guard deve exigir que esse recibo exista
e seja posterior ao ultimo STATE. Resolve E2/E7 parcialmente. Custo: baixo a
medio; mais atrito, mas auditavel.

3. DECLARE-BEFORE-ACTION: introduzir `intent`/`readback` obrigatorio com
`human_status: confirmed`, `files_allowed`, `phase` e `next_allowed_actions`.
Pre-commit bloqueia qualquer path fora do escopo aprovado e qualquer
`audit-result` antes da fase `implemented`. Resolve E3 e D1. Custo: medio; e
o endurecimento natural do escopo que ja aparece em readbacks.

4. G-PHASE: codificar a ordem do gate como maquina de estados no STATE:
`declared -> human_approved -> implemented -> audit_1 -> audit_2 -> consolidated -> ratified`.
Cada tipo de artefato so nasce em fases permitidas, e `audit_2` exige familia
distinta. Resolve D1/D2. Custo: alto, porque exige migrar ondas existentes e
evitar falsos positivos em excecoes historicas.

5. DISPATCH-SCHEMA: substituir prompt livre por `.hbn/dispatches/*.json` ou
front matter padronizado contendo `target_token`, `target_family`,
`expected_self_declaration`, `output_path`, `id_global`, `registry_line`,
`must_not_edit_by_human: true`, `families_excluded`. Um validador renderiza o
prompt final sem "troque X por Y". Resolve E4/E6. Custo: baixo a medio.

6. G-AUDIT-RECEIPT: todo `audit-result` deve declarar `auditor_token`,
`familia`, `audited_commit`, `audited_artifacts`, `independent: true` e
`implements_by`. Guard agrega os audit-results da onda e exige contagem/familia
antes de consolidacao. Resolve D2 e evita Grok rotulado como Gemini. Custo:
medio.

7. G-CONTEXT: exigir `context_pct` e `handoff_threshold` no header de relato e
em dispatches; quando `context_pct >= threshold`, bloquear novas acoes exceto
handoff. Resolve E7 no que for artefato. Custo: medio; depende de valor
auto-declarado, mas ao menos cria recibo auditavel.

8. CANON-MAP-ONLY: proibir novos `BOOT*`/`warm-boot*` governados fora de
STATE/MAPA/relay sem linha de supersedencia explicita. Resolve E5. Custo:
baixo; cuidado para nao bloquear documentos historicos.

## Recomendacao sobre M-A

1. Manter `271ca85` na branch, em quarentena. Nao reescrever por padrao: o
commit ainda e evidencia util e `main` esta intocada. A condicao dura e nao
mergear enquanto faltar segunda auditoria cross-family correta, consolidacao e
ratificacao humana.

2. Corrigir `scripts/hbn-exuvia-rollback.sh` antes de M-B/M-C. A correcao deve
resolver o `state_path` a partir do target ou recalcula-lo apos o reset, e deve
ser testada em worktree temporaria que simule troca de `.hbn/active-version`.

3. Reemitir a segunda auditoria cross-family com dispatch schema ou prompt
auto-declarante. Se Grok for usado, registrar perfil `.hbn/models/grok.json`
ou declarar excecao aprovada; sem perfil, a verificacao completa de familia
fica impossivel.

4. Tratar slug `-M-A-` como rejeitado. Todos os novos artefatos devem manter
slug minusculo como `m-a`.

5. Ativar branch protection no GitHub exigindo Shield/hbn-guards no push antes
de qualquer merge para `main`. Hooks locais sao conveniencia, nao fronteira de
seguranca.

6. Limpar fixtures untracked `guards/tests/cr-*` e `guards/tests/adv-*` em
commit/ato separado ou remove-las antes da ratificacao, sem mistura-las com
correcao de rollback.

## Truth Barrier

Confianca: 86/100.

Nao consegui verificar diretamente: existencia passada dos arquivos
`181924-opus` se foram criados e removidos antes de commit; conteudo do prompt
externo que teria feito Grok se declarar Gemini; se Opus leu ou nao leu
mentalmente os arquivos antes de agir; branch protection remota no GitHub,
pois esta auditoria ficou no disco local.

O que verifiquei: branch, commit `271ca85`, paths do commit, REGISTRY, STATE,
resultado Codex, parecer Gemini, guards G-REG/G-NUM/G-RLT/G-FAM e bug estatico
do rollback.
