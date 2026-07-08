---
titulo: Re-auditoria cruzada — Corrente E fechamento Blocos 3-6 — Codex
path: .hbn/results/0027-cross-ia-codex-corrente-e-fechamento.md
auditor: codex-openai
data: 2026-06-10T15:07:37-03:00
status: congelado
temperatura: glacier
relacionado:
  - methodology/adr/ADR-021-documentos-auto-localizaveis.md
  - methodology/adr/ADR-022-saida-de-auditoria-legivel.md
  - methodology/adr/ADR-023-integridade-de-hearback.md
  - guards/assert-self-path.sh
  - guards/assert-hearback-integrity.sh
  - guards/assert-registry-line.sh
---

# Re-auditoria cruzada — Corrente E fechamento — Codex

⚪ HBN AUDIT-ONLY · 🟣 HBN PEER REVIEW · 🔴 HBN RELEASE BLOCKER

## Veredito

VETO_ADOCAO: SIM.

Contagem de findings: BLOQUEADOR 3; FORTE 1; MARGINAL 0.

Resumo para humano: a remediacao e real em varios pontos, e o ADR-023 declara honestamente o limite do shell compartilhado. Mesmo assim, ha veto: G-SLF e G-REG podem dar falso verde em pre-commit local por lerem working tree enquanto prometem validar o diff staged, e G-HRB nao bloqueia igualdade de autor apesar de isso ter sido criterio explicito do prompt.

## Pre-flight

1) `pwd`: `/Users/macbookpro/Projetos/usehbn` ;
2) `GIT_OPTIONAL_LOCKS=0 git status --short`: worktree misto, com `AM .hbn/messages/20260610-04-handoff-corrente-e-fechada-fable5.md`, `MM .hbn/relay/STATE.md`, 10 arquivos staged/modificados e 3 arquivos novos de ADR/guard ;
3) `git log --oneline -1`: `e876060 release(protocol): adopt corrente E 50% anti-teatro (ADR-020 + 3 guards + suite) — hearback mauricio; guards fora do runner; 0002 pendente` ;
4) Inconsistencia operacional: o prompt esperava HEAD como checkpoint do fechamento, mas HEAD ainda e o checkpoint da adocao 50%; o fechamento esta no index/working tree. `.git/index.lock` existe no canonico com 0 bytes e nao foi removido por esta auditoria ;
5) NNNN escolhido: `0027`.

## Execucao Em /tmp

1) Copia usada: `/tmp/usehbn-audit-codex-OIeopy/usehbn` ;
2) Removi apenas o lock copiado em `/tmp`, nunca o canonico ;
3) `bash guards/tests/run-guard-tests.sh`: exit `0`, `29 passaram, 0 falharam`, `SUITE VERDE` ;
4) Casos diretos reexecutados em `/tmp`: G-SLF path correto exit `0`; G-SLF path mentiroso exit `1`; G-REG rename, guard aninhado, docs/sub orfao, methodology orfao, `.hbn/models` e workflow sem REGISTRY todos exit `1`; G-HRB mesmo commit exit `1`; G-HRB mesmo autor exit `0`.

## Findings

### BLOQUEADOR — E-FECH-01 — G-SLF valida working tree, nao o staged que sera commitado

Evidencia de codigo: `guards/assert-self-path.sh:34-39` lista arquivos do diff staged com `git diff --cached --name-only --diff-filter=AR`, mas `guards/assert-self-path.sh:86-95` abre `${REPO_ROOT}/${f}` e compara o conteudo da working tree.

Evidencia executada em `/tmp`: criei um ADR novo com `path: docs/outro-lugar.md`, fiz `git add`, depois corrigi o arquivo no working tree sem stage. Resultado: `STAGED_PATH=path: docs/outro-lugar.md`, `WORKTREE_PATH=path: methodology/adr/ADR-099-teste.md`, `RC=0`.

Impacto: o guard verde nao prova o conteudo que entraria no commit. Isso e teatro mecanico na propria correcao do ADR-021.

### BLOQUEADOR — E-FECH-02 — G-REG pode aprovar linha de REGISTRY apenas unstaged

Evidencia de codigo: `guards/assert-registry-line.sh:111-116` exige que `REGISTRY.md` esteja no diff, mas `registry_has_exact` em `guards/assert-registry-line.sh:100-103` grepa o arquivo da working tree.

Evidencia executada em `/tmp`: staged tinha artefato novo e `REGISTRY.md` staged sem a linha exata; working tree tinha a linha exata ainda unstaged. Resultado: `STAGED_HAS_LINE=0`, `WORKTREE_HAS_LINE=1`, `RC=0`.

Impacto: a promessa "linha no mesmo commit" pode falhar localmente. O commit pode sair sem a linha apesar do OK do guard.

### BLOQUEADOR — E-FECH-03 — G-HRB nao bloqueia mesmo autor de commit

Evidencia de codigo: `guards/assert-hearback-integrity.sh:77-84` emite `guard_warn` quando o autor do commit do hearback e igual ao autor da mudanca, mas segue para `guard_ok`. A suite tambem espera pass no fluxo bom de G-HRB em `guards/tests/run-guard-tests.sh:214-219`, usando a mesma identidade git para ambos os commits.

Evidencia executada em `/tmp`: `HB_AUTHOR=hbn-guard-tests <tests@hbn.local>`, `CHANGE_AUTHOR=hbn-guard-tests <tests@hbn.local>`, `RC=0`, com aviso e OK.

Nuance: o ADR-023 nao promete o que nao entrega. Ele declara em `methodology/adr/ADR-023-integridade-de-hearback.md:66-74` que igualdade de autores fica como aviso, e em `methodology/adr/ADR-023-integridade-de-hearback.md:78-86` que a trava e parcial no shell compartilhado. Portanto nao ha teatro de quarto nivel no texto; ha descumprimento do criterio deste prompt, que dizia "mesmo autor de commit -> DEVE bloquear".

### FORTE — E-FECH-04 — O fechamento ainda nao esta em checkpoint de HEAD

Evidencia de comando: `git log --oneline -1` retornou `e876060`, que e a adocao 50%, nao um checkpoint do fechamento. `git status --short` mostra staged/unstaged misto. `.git/index.lock` existe com 0 bytes.

Impacto: a auditoria conseguiu avaliar o worktree, mas a adocao ainda depende de re-stage, revisao humana de diff e commit do fechamento. Qualquer verificacao que dependa de ancestralidade de commit ainda nao tem o commit do fechamento como alvo.

## Veredito Por Escopo

1) G-SLF: caso direto correto passa e path mentiroso bloqueia, mas o bypass staged/working-tree e BLOQUEADOR ;
2) G-HRB/F-05: hearback no mesmo commit bloqueia. Mesmo autor nao bloqueia. ADR-023 declara honestamente o limite do shell compartilhado, sem prometer garantia falsa ;
3) G-REG: rename, guard aninhado, orfaos em docs/methodology, `.hbn/models` e workflow sem REGISTRY bloqueiam. Ainda ha BLOQUEADOR por leitura de REGISTRY da working tree ;
4) Suite 29 casos: real para os casos que cobre. `guards/tests/run-guard-tests.sh:26-35` valida exit code; a execucao em `/tmp` deu 29/29. Nao encontrei teste que sempre passa, mas a suite nao cobre index/worktree skew nem mesmo-autor ;
5) Novos guards tem negativos: G-SLF em `guards/tests/run-guard-tests.sh:175-190`; G-HRB em `guards/tests/run-guard-tests.sh:222-240`. `core/freeze-gate-spec.md:28-31` desambiguou a excecao obrigatorio=true/status=na com hearback verificavel ;
6) Novo teatro/regressao: sim, nos guards staged G-SLF/G-REG; e ha inconsistencia operacional de checkpoint.

## Recomendacao Por Hearback

1) EF1 / ADR-021 + G-SLF: recusar como adotavel ate G-SLF validar o blob staged ou exigir index limpo, com teste negativo para staged ruim + working tree corrigida ;
2) EF2 / ADR-022: sem finding proprio; pode ser decidido depois dos bloqueadores mecanicos, pois a entrega em par `.md` + `.json` foi dogfood nesta auditoria ;
3) EF3 / ADR-023 + G-HRB: recusar se o requisito humano continuar sendo "mesmo autor bloqueia". Alternativa aceitavel somente com hearback humano explicito rebaixando esse criterio a aviso enquanto nao houver identidade/assinatura separada ;
4) EF4 / marginais G-REG: recusar como adotavel ate G-REG validar a versao staged de `REGISTRY.md` e adicionar teste negativo para linha apenas unstaged ;
5) Antes de qualquer adocao: remover o lock no Terminal humano, re-stage, revisar diff e criar checkpoint do fechamento.

## Checklist Anti-Vies B1-B6

1) B1: li os artefatos diretamente e ancorei achados em arquivo:linha e comando executado ;
2) B2: reexecutei a suite e criei cenarios adversariais em `/tmp`, sem mutar o canonico ;
3) B3: procurei falso verde antes de aceitar os 29 casos verdes ;
4) B4: separei o que e limite honesto documentado no ADR-023 do que e falha contra o criterio do prompt ;
5) B5: nao recomendo bastao para Codex nem dependo de acao futura minha ;
6) B6: nao implementei, nao ativei guard, nao removi `.git/index.lock` canonico e nao li parecer concorrente deste fechamento.

## Resumo Para Humano

1) A remediacao nao e vazia: varios casos ruins bloqueiam de verdade ;
2) A suite 29/29 e real para os casos cobertos ;
3) O fechamento ainda nao pode ser adotado porque G-SLF e G-REG podem passar conteudo nao staged ;
4) G-HRB bloqueia auto-assinatura no mesmo commit, mas nao bloqueia mesmo autor ;
5) ADR-023 e honesto sobre o limite do shell compartilhado ;
6) HEAD ainda nao e checkpoint do fechamento ;
7) VETO_ADOCAO: SIM.
