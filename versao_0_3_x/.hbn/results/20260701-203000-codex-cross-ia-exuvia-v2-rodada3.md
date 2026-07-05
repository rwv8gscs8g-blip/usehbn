---
tipo: audit-result
titulo: "Auditoria adversarial — exuvia v2 rodada 3"
autor: codex
familia: OpenAI
papel: auditor-adversarial-read-only
status: congelado
temperatura: glacier
arvore: fronteira
path: .hbn/results/20260701-203000-codex-cross-ia-exuvia-v2-rodada3.md
created_at: "2026-07-01T20:30:00-03:00"
alvo: versao_2_0_0
rodada: 3
---

SOU: codex · familia OpenAI · papel AUDITOR adversarial READ-ONLY do useHBN.

# Parecer — exuvia v2 rodada 3

Escopo auditado: `/Users/macbookpro/Projetos/usehbn`, alvo
`versao_2_0_0` (fable-5/Anthropic, 2026-07-01). Nao confiei nos numeros do
prompt; medi no disco.

## V1 C-NOREG

Resultado: PASSA.

Evidencia:

- `diff -r guards versao_2_0_0/guards` -> sem saida, exit 0.
- `diff -r schemas versao_2_0_0/schemas` -> sem saida, exit 0.
- `diff -r .hbn/knowledge versao_2_0_0/.hbn/knowledge` -> sem saida, exit 0.

Interpretacao: a paridade fisica foi restaurada. Isso nao prova que nata-0b
foi executada; prova justamente que o harness v2 continua byte a byte igual ao
incumbente.

## V2 Escrita Confinada

Resultado: PASSA para o criterio pedido (nenhum M/D rastreado fora de
`versao_2_0_0/`).

Evidencia:

- `git status --short --untracked-files=no` -> sem saida.
- `git status --short` lista muitos `??` historicos fora de `versao_2_0_0/`;
  nao ha `M` ou `D` rastreado. Este parecer acrescenta somente o arquivo atual
  em `.hbn/results/`.

## V3 Suites Nos Dois Contextos

Resultado: FALHA.

Evidencia medida:

- Raiz: `bash guards/tests/run-guard-tests.sh` -> exit 0; final
  `== resumo: 272 passaram, 0 falharam ==`.
- Raiz: `bash guards/tests/adversarial-battery.sh` -> exit 0; final
  `BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.`
- v2: `cd versao_2_0_0 && bash guards/tests/adversarial-battery.sh` -> exit 0;
  final `BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.`
- v2: `cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh` -> exit 1;
  final `== resumo: 271 passaram, 1 falharam ==`; falha:
  `readlist: templates+4 specs core sem referência quebrada`.

Explicacao da divergencia: as duas copias do harness ainda apontam para a
read-list do incumbente, nao para BOOT/specs v2. Em ambas as copias,
`guards/tests/run-guard-tests.sh:3656-3682` e
`versao_2_0_0/guards/tests/run-guard-tests.sh:3656-3682` verificam
`agents/role-templates.md`, `core/start-rite-spec.md`,
`core/orchestrator-profile-spec.md`, `core/pointer-spec.md` e
`core/state-report-spec.md`. Esses arquivos existem na raiz incumbente, mas
nao existem no layout v2, que tem `BOOT.md` e `core/02-papeis.md` etc.

O proprio manifesto declara essa adaptacao como divida nata-0b:
`versao_2_0_0/MANIFESTO-MIGRACAO.md:58`. Logo, o disco atual nao corresponde
ao prompt "pos-ondas nata-0/nata-0b".

## V4 Consolidacao Fiel

Resultado: PARCIAL. A consolidacao textual corrigiu varios pontos da rodada 2,
mas a ativacao continua bloqueada pelas dividas nata-0/nata-0b nao fechadas.

Amostra vinculante:

1. G-FRONTDOOR x `core/role-cards.md`: preservado. O guard exige
   `core/role-cards.md`, max 140 linhas, max 8192 bytes e read-list <=6
   (`guards/assert-frontdoor.sh:19-21`, `:56-58`, `:129-138`). A v2 criou
   ponteiro fino com quatro itens (`versao_2_0_0/core/role-cards.md:15-28`).
2. I-10 x rito de entrada: preservado. O guard exige heading exato
   `## RELATO DE LEITURA` e item com `arquivo:linha`
   (`guards/assert-report-fresh.sh:137-155`). A v2 incorporou isso em
   `versao_2_0_0/core/03-rito-da-onda.md:65-71`.
3. P1-P13: preservado. A v2 aponta para
   `../../methodology/PRINCIPIOS-CONSTITUCIONAIS.md`
   (`versao_2_0_0/core/01-principios.md:15-19`), e `ls -l` confirmou que o
   caminho existe.
4. Arvores: autoridade preservada, com divida declarada. O incumbente diz que
   o REGISTRY e fonte unica e que nao existe front-matter `arvore:`
   (`core/arvores-spec.md:29-40`). A v2 preserva o REGISTRY como fonte unica e
   torna front-matter apenas espelho informativo
   (`versao_2_0_0/core/04-artefatos.md:46-56`), mas seu REGISTRY ainda nao tem
   coluna `arvore` (`versao_2_0_0/REGISTRY.md:13-24`); a divida nata-3b esta
   declarada em `versao_2_0_0/MANIFESTO-MIGRACAO.md:62`.
5. Quorum: preservado. A v2 exige `2x APROVA_NNNN: SIM`, familias distintas
   entre si e do implementador (`versao_2_0_0/core/03-rito-da-onda.md:29-30`).
6. Anti-auto-emenda de escopo: preservado. Alterar `files_allowed` no mesmo
   commit do artefato autorizado e violacao; extensao exige `scope_extension`
   com campos definidos (`versao_2_0_0/core/03-rito-da-onda.md:37-43`).
7. Nome universal ADR-025: preservado. A v2 torna
   `AAAAMMDD-HHMMSS-<token>-<slug>` incondicional e elimina o regime
   serial/paralelo para eventos (`versao_2_0_0/core/04-artefatos.md:16-21`).

## V5 Orcamento

Resultado: PASSA.

Evidencia:

- `wc -l versao_2_0_0/BOOT.md` -> 161 linhas, abaixo do teto de 300.
- `find versao_2_0_0/core -maxdepth 1 -name '*.md' -print` -> 12 arquivos
  `.md`, exatamente no teto. A inclusao de `core/role-cards.md` consumiu a
  folga restante.
- `awk` na secao `## Resumo executivo` do STATE -> 17 linhas nao vazias; abaixo
  do teto de 30. O trecho esta em `versao_2_0_0/.hbn/relay/STATE.md:34-50`.

## V6 Brechas Tentadas

1. Burlar a auditoria por narrativa: aceitar a frase do prompt "pos-ondas
   nata-0/nata-0b". Falhou contra o disco: so encontrei despachos
   `versao_2_0_0/.hbn/messages/20260701-200700-...nata-0...md` e
   `20260701-200800-...nata-0b...md`; nao encontrei implementacao/selagem, e
   a suite v2 segue vermelha.
2. Burlar C-NOREG por paridade vazia: manter as duas copias do harness iguais.
   Passa V1, mas falha V3, porque a suite v2 continua usando paths do
   incumbente (`run-guard-tests.sh:3677-3682`).
3. Burlar nata-0 por fail-closed: `guards/assert-role-family.sh` calcula
   `ACTIVE_ROOT` em `:80`, mas a dereferencia de `hearback_ref` ainda usa
   `repo_root` em `:105`. Isso nao abre permissao indevida; bloqueia uso
   legitimo pos-flip e impede ativacao honesta enquanto nata-0 nao fechar.
4. Burlar por front-door parcial: `core/role-cards.md` satisfaz G-FRONTDOOR,
   mas o item dinamico "readback ativo apontado no STATE" nao e path concreto
   validado pelo guard (`versao_2_0_0/core/role-cards.md:25-28`;
   `guards/assert-frontdoor.sh:113-121`). E aceitavel como ponteiro fino, mas
   nao prova leitura do readback.
5. Burlar por divida declarada demais: `core/read-list-canonica.txt` ainda tem
   `PENDENTE_REHASH` em linhas 5-18. A divida esta declarada, mas qualquer
   ativacao que trate C-DEBT como "basta nomear uma onda" vira teatro.
6. Bateria documentada: B1-B96 foram tentadas pelas duas execucoes de
   `adversarial-battery.sh` e todas foram bloqueadas.

## V7 Fitness

Resultado: PARCIAL; ainda nao e gate suficiente para aprovar.

- C-TEST e C-ADV sao objetivos por comando (`FITNESS-CHECKLIST.md:20-21`).
  C-ADV passou nos dois contextos; C-TEST falhou no contexto v2.
- C-XAUDIT e contavel por pareceres (`FITNESS-CHECKLIST.md:22`), mas a rodada 3
  ainda esta em andamento; este parecer e apenas uma familia.
- C-DOG e objetivo em tese (`FITNESS-CHECKLIST.md:23`), mas nao foi executado
  nesta auditoria.
- C-FCLOSE e objetivo em tese (`FITNESS-CHECKLIST.md:24`), mas a tabela nao
  fornece comando canonico completo alem dos casos ja existentes na suite.
- C-NOREG e objetivo e passou (`FITNESS-CHECKLIST.md:25`).
- C-TRACE e C-DEBT continuam parcialmente humanos
  (`FITNESS-CHECKLIST.md:26-32`). A clausula anti-teatro melhora o rito ao
  anular parecer sem amostra, mas nao e suficiente como medicao objetiva
  exaustiva: nao ha parser que confira cobertura total do manifesto nem
  diferencie divida "designada" de divida pre-ativacao nao concluida.

## Achados

- BLOQUEADOR: C-TEST falha no contexto v2. Comando
  `cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh` terminou exit 1
  com `271 passaram, 1 falharam`; falha em
  `readlist: templates+4 specs core sem referência quebrada`.
- BLOQUEADOR: a premissa de rodada 3 "pos-ondas nata-0/nata-0b" nao se sustenta
  no disco. O manifesto ainda declara nata-0 e nata-0b como pendentes antes da
  ativacao (`versao_2_0_0/MANIFESTO-MIGRACAO.md:57-58`), o FITNESS exige ambas
  concluidas antes do flip (`versao_2_0_0/FITNESS-CHECKLIST.md:100-102`), e o
  codigo ainda mostra as duas lacunas (`guards/assert-role-family.sh:80,105`;
  `guards/tests/run-guard-tests.sh:3677-3682`).
- FORTE: C-DEBT/C-TRACE ainda permitem validacao por amostragem humana, nao por
  inventario mecanico. Evidencia: `FITNESS-CHECKLIST.md:26-32`.
- FORTE: o modelo de arvores esta coerente quanto a autoridade do REGISTRY, mas
  ainda nao esta operacional no REGISTRY v2 porque falta a coluna `arvore`.
  Evidencia: `versao_2_0_0/core/04-artefatos.md:49-56`,
  `versao_2_0_0/REGISTRY.md:13-24`,
  `versao_2_0_0/MANIFESTO-MIGRACAO.md:62`.
- MARGINAL: `git status --short` permanece muito ruidoso por `??` historicos
  fora de `versao_2_0_0/`; nao viola o criterio M/D pedido, mas aumenta risco
  operacional de depositos fora do chokepoint.

## Confianca

Alta para V1, V2, V3 e V5: medi por comandos locais. Media-alta para V4:
conferi amostra vinculante, nao a totalidade dos 22 specs/27 ADRs. Media para
V7: avaliei o checklist e executei as suites, mas nao rodei C-DOG nem um
repo-teste dedicado de C-FCLOSE fora dos casos existentes.

## Nao Verificado

Nao verifiquei freeze V206 do Credenciamento (C-DOG), nao executei flip de
`.hbn/active-version`, nao rodei commit/hook real, nao validei pareceres de
outras familias da rodada 3, nao fiz inventario C-TRACE exaustivo de todos os
elementos do manifesto.

APROVA_EXUVIA_V2: NAO
