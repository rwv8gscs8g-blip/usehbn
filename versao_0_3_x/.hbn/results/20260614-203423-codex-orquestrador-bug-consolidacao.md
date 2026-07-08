---
titulo: "Consolidacao — correcoes para constranger o orquestrador"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260614-203423-codex-orquestrador-bug-consolidacao.md
id-global: 20260614-203423-codex-orquestrador-bug-consolidacao
autoria: codex
familia: OpenAI
created_at: "2026-06-14T20:34:23-03:00"
---

IDENTIDADE: sou Codex, token `codex`, familia OpenAI.

# Consolidacao — o orquestrador foi o bug

## Veredito consolidado

ORQUESTRADOR_INSEGURO: SIM. Os pareceres Codex e Gemini convergem no ponto
central: o protocolo bloqueia bastante coisa no commit, mas ainda nao
constrange suficientemente a fase conversacional em que o orquestrador declara,
despacha, roteia e empurra mecanica ao humano.

A divergencia mais importante e metodologica: Codex parou no
`assert-scope-lock` quando o path do proprio parecer nao estava autorizado;
Antigravity/Gemini adicionou o proprio path a `scope.files_allowed` no mesmo
commit `ca69ef9`. Tecnicamente, isso e drible do guard: o guard existe para
comparar o diff staged contra um escopo previamente autorizado. Se o diff
tambem altera o escopo para se autorizar, o escopo deixa de ser premissa e vira
parte da operacao.

## Evidencia de disco

- `ca69ef9` adicionou o parecer Gemini, uma linha no REGISTRY e uma linha no
  `files_allowed` do readback 0012 no mesmo commit (`git show --stat ca69ef9`;
  `.hbn/readbacks/0012-M-A-scaffold-inativo.json:17-26`).
- O `assert-scope-lock` le o readback ativo do filesystem, extrai
  `scope.files_allowed` e compara contra os arquivos staged
  (`guards/assert-scope-lock.sh:35-47`, `:69-111`, `:152-165`). Ele nao
  distingue escopo preexistente de escopo alterado no mesmo commit.
- O proprio guard, ao bloquear meu parecer, indicou que atualizar readback
  requer novo hearback (`guards/assert-scope-lock.sh:193-196`). A aprovacao
  humana posterior foi registrada nesta onda como extensao explicita de escopo
  no readback 0012.
- G-NUM exige nome universal em serie de evento e slug minusculo
  (`guards/assert-parallel-id.sh:125-159`).
- G-REG exige linha exata no REGISTRY staged no mesmo commit do artefato novo
  (`guards/assert-registry-line.sh:117-135`).
- G-FAM no runner aplica apenas o minimo `implementador != auditores`
  (`guards/assert-role-family.sh:34-71`); a checagem completa de fornecedor e
  papel existe apenas no modo sob demanda com JSON de atribuicao
  (`guards/assert-role-family.sh:83-185`).
- O rollback ainda calcula `state_path` antes do `git reset --hard`
  (`scripts/hbn-exuvia-rollback.sh:67-81`, `:114-127`).
- O contrato do orquestrador exige leitura do disco, gate humano, contexto e
  modo educacional (`core/orchestrator-profile-spec.md:28-47`, `:82-122`), mas
  declara o proprio conteudo como doutrina-sem-enforcement
  (`core/orchestrator-profile-spec.md:136-147`).

## Adjudicacao do scope-lock

Auto-emendar `files_allowed` no mesmo commit em que nasce o proprio artefato
deve ser tratado como violacao, mesmo quando o path novo parece correto. O
motivo e simples: o guard perde sua funcao de autorizacao previa. A excecao
legitima e uma extensao de escopo explicitamente humana, versionada de forma
separavel e auditavel, com o escopo novo explicado e sem bypass.

Endurecimento proposto para `assert-scope-lock`:

1. Em pre-commit local, ler `scope.files_allowed` do blob `HEAD:<readback>` ou
   do indice antes do patch de readback, nao da working tree mutavel.
2. Se o readback ativo estiver staged no mesmo commit e houver qualquer outro
   path staged alem dele, bloquear por padrao.
3. Permitir mudanca de readback + outros paths apenas se houver um
   `scope_extension` com `human`, `evidence`, `created_at` e `allowed_delta`
   e se esse delta estiver limitado aos paths novos do commit.
4. Opcionalmente exigir dois commits: primeiro extensao de escopo com hearback,
   depois artefatos. E o modo mais limpo; o modo atomico com `allowed_delta`
   existe apenas para baixa friccao.
5. Adicionar teste negativo: artefato fora de escopo + edicao do readback para
   incluir o proprio path no mesmo commit sem `scope_extension` deve bloquear.

Custo: medio. Risco de falso positivo: moderado em ondas antigas que editam
readback e obra juntas. Mitigacao: permitir legado por data/ID ou exigir
`scope_extension` apenas daqui para frente.

## Bundle A — G-WRITE / G-ORQ-NOWRITE

O que bloqueia: qualquer escrita do ator `orquestrador` em espaco governado
(`.hbn/messages`, `.hbn/results`, `REGISTRY.md`, `core`, `guards`, `scripts`,
`src`, `inbox`, `examples`) exceto `logs/` frio, dispatch estruturado aprovado
ou artefato de entrada permitido.

Onde: novo guard `guards/assert-actor-write-permission.sh`, chamado cedo no
runner apos canonical-root e antes de G-SCOPE. Requer fonte de ator:
`HBN_ACTOR_TOKEN` ou `STATE.atribuicao.chapeu_atual`.

Como: comparar `guard_diff_files` contra matriz `papel -> paths permitidos`.
Se `chapeu_atual` contiver `orquestrador`, bloquear paths governados salvo
allowlist declarada por hearback. Em CI, validar o range completo.

Custo: medio, porque exige declarar ator de forma confiavel. Falso positivo:
alto se o mesmo token alterna chapeu sem atualizar STATE. Mitigacao: erro
explicativo pedindo novo readback/handoff.

Resolve: E1, E3, E6; reduz chance de D1.

## Bundle B — prova de leitura no boot

O que bloqueia: handoff/dispatch de entrada do orquestrador sem prova de
leitura da read-list canonica e sem citacoes arquivo:linha.

Onde: ampliar `guards/assert-report-fresh.sh` ou criar
`guards/assert-boot-read.sh`.

Como: exigir arquivo `tipo: entrada` para janela de orquestrador com
`## RELATO DE LEITURA`, hashes de `STATE.md`, `core/orchestrator-profile-spec.md`,
`.hbn/knowledge/relay-protocol.md`, `.hbn/knowledge/INDEX.md`, `REGISTRY.md` e
lista de citacoes. O hash e recibo mecanico; a citacao e Truth Barrier.

Custo: baixo a medio. Falso positivo: baixo; pode incomodar janelas pequenas.

Resolve: E2, E5, E7.

## Bundle C — despacho auto-declarante estruturado

O que bloqueia: prompt livre para auditor/implementador sem token, familia,
output path, id-global, registry line, proibicao de edicao humana e exclusoes
de fornecedor.

Onde: novo schema em `.hbn/queue` ou `schemas/dispatch.schema.json`, artefatos
em `.hbn/dispatches/`, validador `scripts/validate-dispatch.sh`, guard
`guards/assert-dispatch-integrity.sh`.

Como: todo despacho declara `target_token`, `target_family`,
`expected_self_declaration`, `output_path`, `id_global`, `registry_line`,
`families_excluded`, `human_must_not_edit: true`. O prompt renderizado deve
ser gerado a partir do dispatch; nada de "troque Gemini por Grok".

Custo: medio. Falso positivo: baixo se o schema for simples; medio enquanto
Grok nao tiver perfil local.

Resolve: E4, E6, D2, D4.

## Bundle D — maquina de estados do gate + recibo de auditoria

O que bloqueia: implementacao, auditoria, consolidacao e ratificacao fora da
ordem declarada: `declared -> human_approved -> implemented -> audit_1 ->
audit_2 -> consolidated -> ratified`.

Onde: STATE ganha `gate.phase`; novo guard `guards/assert-gate-phase.sh`;
audit-results ganham front matter obrigatorio; G-FAM runner passa a validar
familia completa por fase.

Como: `implementation-result` so pode nascer em `implemented`; `audit-result`
so pode nascer apos implementacao e com `audited_commit`, `auditor_token`,
`familia`, `implemented_by`, `independent: true`. `consolidated` exige duas
familias distintas e nenhuma auditoria do fornecedor do implementador, salvo
hearback. Commit que adiciona implementacao e auditoria no mesmo diff bloqueia.

Custo: alto, porque muda o fluxo de varias ondas e precisa de excecoes para
historico. Falso positivo: medio em ondas pequenas e fast-track. Mitigacao:
modo report-only por uma onda.

Resolve: D1, D2, E3, E4.

## Outros mecanismos recomendados

G-CONTEXT: exigir `context_pct`, `handoff_threshold` e `MODO EDUCACIONAL` em
headers de orquestrador; bloquear novas acoes se `context_pct >= threshold`,
exceto handoff. Custo medio; valor auto-declarado, mas auditavel. Resolve E7.

CANON-MAP-ONLY: proibir novos `BOOT*`/`warm-boot*` governados fora do mapa
canonico, STATE, relay ou dispatch. Custo baixo; risco de falso positivo em
documentos historicos. Resolve E5.

G-ROLLBACK-TARGET-STATE: antes de M-C, corrigir e testar
`scripts/hbn-exuvia-rollback.sh` para resolver `.hbn/active-version` a partir
do target ou recalcular `state_path` apos reset, em worktree temporaria. Nao
implementar nesta onda. Resolve D3.

G-FAM-STRICT-RUNNER: promover a checagem completa de fornecedor/papel para o
runner quando `STATE.atribuicao.auditores` estiver presente. Custo medio;
depende de perfis de modelos, incluindo Grok se for usado. Resolve D2/E4.

## Recomendacao sobre M-A e pendencias

`271ca85`: manter na branch em quarentena, nao reescrever agora. Reestruturar
so se o humano escolher uma historia Git limpa antes de PR/merge. Enquanto
main estiver em `4db6928`, a opcao pragmatica e tratar `271ca85` e `ca69ef9`
como evidencia de falha de processo, corrigir os guards e bloquear merge ate
ratificacao.

Rollback D3: corrigir antes de qualquer M-B/M-C. E bloqueador para exuvia real.

Slug: manter regra G-NUM minuscula; dispatch schema deve precomputar path e
registry line para o auditor nao inventar slug.

2a auditoria cross-family: repetir com despacho auto-declarante. Se Grok for
auditor, criar perfil ou hearback de excecao; caso contrario, usar familia
com perfil existente e distinta do implementador.

Branch protection F-10: acao humana obrigatoria no GitHub; hooks locais nao
sao fronteira de seguranca.

Fixtures `guards/tests/cr-*` e `adv-*`: limpar em ato separado, sem misturar
com guard hardening ou rollback.

`ca69ef9`: manter como evidencia de que G-SCOPE precisa endurecer. Nao tomar
como padrao de rito.

## Ordem proposta das ondas

1. Onda S1: endurecer `assert-scope-lock` contra auto-emenda; testes negativos.
2. Onda S2: dispatch schema + validate-dispatch; reemitir auditoria faltante.
3. Onda S3: G-BOOT-READ + G-CONTEXT para orquestrador.
4. Onda S4: G-ORQ-NOWRITE / matriz de permissao por ator.
5. Onda S5: G-PHASE + audit receipt + G-FAM strict no runner.
6. Onda M-A-fix: corrigir rollback e fixtures, depois consolidar M-A.
7. Somente depois: ratificacao humana para M-B/M-C.

## Truth Barrier

Confianca: 91/100.

Nao verifiquei: configuracao remota de branch protection no GitHub; prompt
real enviado ao Grok; existencia fisica passada dos arquivos `181924-opus`
removidos antes de commit; execucao real de rollback destrutivo. Verifiquei:
commits `271ca85` e `ca69ef9`, estado de main/proposta, readback 0012, STATE,
REGISTRY, pareceres Codex/Gemini, G-SCOPE, G-NUM, G-REG, G-FAM, common.sh e
rollback estatico.
