---
titulo: Re-auditoria curta - fix staged-skew E-FECH-01/02 - Codex
path: .hbn/results/0029-cross-ia-codex-fix-staged-skew.md
auditor: codex-openai
data: 2026-06-10T15:44:26-03:00
status: congelado
temperatura: glacier
escopo: fix staged-skew G-SLF/G-REG
relacionado:
  - .hbn/results/0027-cross-ia-codex-corrente-e-fechamento.md
  - guards/assert-self-path.sh
  - guards/assert-registry-line.sh
  - guards/tests/run-guard-tests.sh
  - guards/lib/common.sh
---

# Re-auditoria curta - fix staged-skew E-FECH-01/02 - Codex

⚪ HBN AUDIT-ONLY · 🟢 HBN CHECKPOINT CLEAN

## Veredito

VETO_ADOCAO: NAO, no escopo estrito do fix staged-skew E-FECH-01/02.

Contagem de findings: BLOQUEADOR 0; FORTE 0; MARGINAL 0.

Resumo para humano: os dois bloqueadores de staged-skew morreram. G-SLF e G-REG agora validam o blob que entra no commit local (`:path` / `:REGISTRY.md`) e, no caminho de CI com `HBN_DIFF_BASE`, validam `HEAD:path` / `HEAD:REGISTRY.md`. Nao encontrei novo falso-verde nem teatro novo no fix.

## Pre-flight

1) `pwd`: `/Users/macbookpro/Projetos/usehbn` ;
2) `GIT_OPTIONAL_LOCKS=0 git status --short`: sem saida, worktree limpa antes da escrita deste parecer ;
3) `git log --oneline -1`: `5f0aea3 checkpoint(protocol): fix staged-skew G-SLF/G-REG (E-FECH-01/02 — guards leem o blob staged) — status: proposed` ;
4) NNNN escolhido: `0029` (`0028` ja existe; nao li o conteudo do parecer concorrente) ;
5) Copia de execucao principal: `/tmp/usehbn-audit-codex-fix-skew-RZXqww/usehbn`.

## Evidencia De Codigo

1) G-SLF local: `guards/assert-self-path.sh:35-40` lista arquivos adicionados/renomeados do index com `git diff --cached`; `guards/assert-self-path.sh:49-57` define `blob_ref` como `:path` localmente e `HEAD:path` com `HBN_DIFF_BASE`; `guards/assert-self-path.sh:98-103` extrai `path:` via `git show "$ref"`, nao pela working tree ;
2) G-SLF CI: o mesmo `blob_ref` usa `HEAD:$1` em `guards/assert-self-path.sh:52-53`, entao o range `HBN_DIFF_BASE...HEAD` valida o conteudo pushed ;
3) G-REG local: `guards/assert-registry-line.sh:52-59` le `REGISTRY.md` via `git show ":REGISTRY.md"` localmente; `guards/assert-registry-line.sh:113-116` faz o casamento exato em cima desse conteudo, nao do arquivo da working tree ;
4) G-REG CI: `guards/assert-registry-line.sh:55-56` le `HEAD:REGISTRY.md` quando `HBN_DIFF_BASE` existe; `guards/lib/common.sh:74-82` confirma que o diff comum em CI e `HBN_DIFF_BASE...HEAD`.

## Execucao Em /tmp

1) `bash guards/tests/run-guard-tests.sh` em clone `/tmp`: exit `0`, `33 passaram, 0 falharam`, `SUITE VERDE` ;
2) E-FECH-01A, G-SLF: staged com `path: docs/outro-lugar.md` e working tree corrigida para `path: methodology/adr/ADR-099-teste.md` retornou `RC=1`; esperado: bloqueia ;
3) E-FECH-01B, G-SLF: staged correto e working tree quebrada retornou `RC=0`; esperado: passa ;
4) E-FECH-02A, G-REG: `REGISTRY.md` staged sem a linha e working tree com a linha retornou `RC=1`; esperado: bloqueia ;
5) E-FECH-02B, G-REG: linha no staged e removida da working tree retornou `RC=0`; esperado: passa ;
6) Caminho CI G-SLF: `HBN_DIFF_BASE` com `HEAD` mentiroso e working tree corrigida retornou `RC=1`; `HEAD` correto e working tree quebrada retornou `RC=0` ;
7) Caminho CI G-REG: `HEAD:REGISTRY.md` sem linha e working tree com linha retornou `RC=1`; `HEAD:REGISTRY.md` com linha e working tree sem linha retornou `RC=0`.

## Casos Novos De Skew

Os 4 casos novos da suite sao reais, nao apenas nomes:

1) `guards/tests/run-guard-tests.sh:165-189` cria os dois skews de G-REG depois de `git add -A`: linha apenas na working tree deve bloquear; linha staged e removida da working tree deve passar ;
2) `guards/tests/run-guard-tests.sh:223-245` cria os dois skews de G-SLF depois de `git add -A`: path mentiroso staged deve bloquear; path correto staged com working tree mentirosa deve passar ;
3) A reexecucao direta reproduziu a mesma matriz fora da suite, com os valores staged/worktree impressos.

## Findings

Nenhum finding no escopo E-FECH-01/02.

### BLOQUEADOR

Nenhum.

### FORTE

Nenhum.

### MARGINAL

Nenhum.

## Regressao Ou Falso-Verde

Nao encontrei regressao nem novo falso-verde no fix staged-skew. O comportamento observado e o desejado: quando o conteudo que sera commitado esta ruim, o guard bloqueia mesmo que a working tree esteja boa; quando o conteudo que sera commitado esta bom, o guard passa mesmo que a working tree esteja ruim. O caminho de CI tambem ficou coerente: com `HBN_DIFF_BASE`, a fonte de verdade e `HEAD:path`.

## Recomendacao Por Hearback

1) E-FECH-01 / G-SLF: aprovar o fix staged-skew ;
2) E-FECH-02 / G-REG: aprovar o fix staged-skew ;
3) Ativacao futura dos guards no runner continua fora deste parecer; este resultado apenas remove o veto especifico de staged-skew.

## Checklist Anti-Vies B1-B6

1) B1: li os artefatos pedidos e ancorei o parecer em arquivo:linha e comando executado ;
2) B2: reexecutei a suite e cenarios adversariais em `/tmp`, sem mutar o canonico ;
3) B3: testei as duas direcoes do skew para cada guard, nao apenas o caso de bloqueio ;
4) B4: validei separadamente caminho local (`:path`) e caminho CI (`HEAD:path`) ;
5) B5: mantive parecer independente, sem herdar bastao do implementador ;
6) B6: nao implementei, nao adotei, nao ativei guard, nao commitei e nao li o conteudo do parecer concorrente `0028`.

## Resumo Para Humano

1) Os bloqueadores E-FECH-01 e E-FECH-02 morreram ;
2) A suite esta verde com `33/33` ;
3) Os 4 casos novos de skew sao exercicios reais de index versus working tree ;
4) O caminho CI usa `HEAD:path` / `HEAD:REGISTRY.md` e tambem foi validado ;
5) Nao encontrei teatro novo no fix ;
6) VETO_ADOCAO: NAO no escopo do fix staged-skew.
