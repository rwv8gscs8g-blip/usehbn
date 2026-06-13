---
titulo: "Parecer Codex — re-auditoria da onda 0006 v2"
tipo: result
path: .hbn/results/20260612-121318-codex-cross-ia-reaudit-onda-0006-v2.md
id-global: 20260612-121318-codex-cross-ia-reaudit-onda-0006-v2
temperatura: frio
auditor: codex-openai
alvo: "branch proposta/onda-0006-v2 — re-auditoria restrita aos achados do parecer 20260611-170633"
reviewed_at: "2026-06-12T12:13:18-03:00"
---

# Parecer — re-auditoria onda 0006 v2

## Resumo

1. Escopo respeitado: verifiquei apenas os bloqueadores/fortes do meu parecer `20260611-170633`; não reabri mérito já aprovado da v1.
2. Independência: não li o parecer Antigravity desta re-auditoria.
3. R1 passou no Bash 3.2 local: `123 passaram, 0 falharam`.
4. R2 foi redesenhado: segredo em `.git/hbn-baton-token`, histórico só com fingerprint público; replay por leitura do log não se reproduz.
5. R3 foi sanado: primeiro pick que falhava agora passa com hook tolerante e `commit -C`, preservando autor/trailers.
6. R4 e R5 foram sanados por números reais, ressalva de shell, baseline sha256 e declaração de whitespace preservado.
7. R6 procede como justificativa técnica; não vi brecha nova dentro do runbook v2.
8. R7 passou no Bash 3.2 local: bateria adversarial verde.

VETO_CHERRY_PICKS: NÃO

## Truth Barrier

- Parecer anterior relido: bloqueadores e fortes em `.hbn/results/20260611-170633-codex-cross-ia-onda-0006.md:175-209`; veto em `:211-217`.
- Range-diff lido: C-01/C-02/C-03 em `/Users/macbookpro/Projetos/usehbn-entregas/onda-0006/20260612-120133-fable5-range-diff-v1-v2.txt:101-455`; C-04 em `:502-612`; C-05 em `:1-64`.
- Tabela v2 lida: saídas e ressalva em `/Users/macbookpro/Projetos/usehbn-entregas/onda-0006/20260612-120145-fable5-tabela-aprovacao-onda-0006-v2.md:20-40`; runbook em `:63-135`; mapa C-xx em `:155-205`.
- Log de simulação lido: picks e cerimônia em `/Users/macbookpro/Projetos/usehbn-entregas/onda-0006/20260612-120134-fable5-log-simulacao-cerimonia-v2.txt:1-35`.
- Arquivos vivos lidos: `guards/assert-baton-token.sh:77-174`, `.git/hooks/commit-msg:1-13`, `core/state-report-spec.md:106-149`, `.hbn/relay/STATE.md:1-76`, `guards/assert-exception-traceable.sh:17-29` e `:100-145`.

## R1 — C-01 Bash 3.2

Veredito: SANADO.

Severidade: OK.

Evidência: `bash --version` no repositório retornou `GNU bash, version 3.2.57(1)-release`. O guard removeu `${EXPECTED,,}` e usa `lc()` via `tr` em `guards/assert-baton-token.sh:85-99`; o fallback `sha256sum`/`shasum` está em `:77-82`.

Comando e saída:

```text
$ bash guards/tests/run-guard-tests.sh | tail -2
== resumo: 123 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

## R2 — C-02 Token fora do histórico

Veredito: SANADO para o replay descrito na v1.

Severidade: OK, com limitação declarada sem veto.

Evidência: o segredo vive em `.git/hbn-baton-token` e o commit carrega só `HBN-Token-FP` conforme `core/state-report-spec.md:108-127`; o guard exige arquivo local e fingerprint em `guards/assert-baton-token.sh:125-160`. O próprio spec declara que G-TOK não prova posse exclusiva em `core/state-report-spec.md:129-135`.

Comandos e saídas:

```text
$ git grep -n 'HBN-Token:' proposta/onda-0006-v2
<sem saída; rc=1>

$ git log --format='%h %s' -G'HBN-Token:' main..proposta/onda-0006-v2
<sem saída>

$ git ls-tree -r --name-only proposta/onda-0006-v2 | rg 'hbn-baton-token'
<sem saída; rc=1>

$ if test -e .git/hbn-baton-token; then printf 'present\n'; else printf 'absent\n'; fi
absent
```

Conclusão: o replay que eu descrevi na v1 dependia de ler `HBN-Token` secreto no histórico. Na v2 não há trailer secreto; copiar o fingerprint público não abre o hook sem o arquivo local. O risco residual é outro e está declarado: qualquer processo com leitura de `.git/` na mesma máquina pode copiar o arquivo.

## R3 — C-03 Hook/runbook/cherry-pick

Veredito: SANADO.

Severidade: OK.

Evidência documental: o hook vivo é tolerante a guard ausente em `.git/hooks/commit-msg:5-12`; a tabela usa `git cherry-pick -n <sha> && git commit -C <sha>` em `20260612-120145-fable5-tabela-aprovacao-onda-0006-v2.md:63-74`; a cerimônia de token vem após o último pick em `:111-133`.

Re-simulação do primeiro pick que falhou na minha auditoria v1, em clone descartável fora de `/tmp`:

```text
$ <clone em /Users/macbookpro/Projetos/usehbn-entregas/onda-0006/codex-reaudit-clone.0D8Sha>; git checkout main; git reset --hard 65b4af0; hook commit-msg tolerante; git cherry-pick -n dfbc5ab; git commit -C dfbc5ab
hook commit-msg: guards/assert-baton-token.sh ausente no worktree — liberado (vale após o cherry-pick que o cria)
hook commit-msg: guards/assert-exception-traceable.sh ausente no worktree — liberado (vale após o cherry-pick que o cria)
[main f8722f2] onda-0006/I-00: readback 0006 (enforcement-sem-excecao) + linha REGISTRY
 Author: claude-fable-5 (Cowork) <mauriciozanin@gmail.com>
 2 files changed, 101 insertions(+)
 create mode 100644 .hbn/readbacks/0006-onda-enforcement-sem-excecao.json
status=
head=f8722f2
subject=onda-0006/I-00: readback 0006 (enforcement-sem-excecao) + linha REGISTRY
author=claude-fable-5 (Cowork) <mauriciozanin@gmail.com>
trailers:
HBN-Readback: 0006
HBN-Agent: fable5-impl-0006
HBN-Human-Authorization: readback-0006-authorization (ordem Mauricio 2026-06-11, corrigir tudo em uma unica passada)
```

## R4 — C-04 STATE/tabela com números reais e ressalva de shell

Veredito: SANADO.

Severidade: OK.

Evidência: `.hbn/relay/STATE.md:17` declara suíte `123/123` no sandbox e pendência explícita para Bash 3.2/macOS; `.hbn/relay/STATE.md:56-60` repete a ressalva. A tabela v2 cola as saídas reais em `20260612-120145-fable5-tabela-aprovacao-onda-0006-v2.md:20-40`.

Comandos locais:

```text
$ git rev-list --count main..proposta/onda-0006-v2
13

$ bash guards/tests/run-guard-tests.sh | tail -2
== resumo: 123 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

## R5 — C-05 id-global, baseline sha256, whitespace

Veredito: SANADO.

Severidade: OK; whitespace segue presente, mas está declarado e não era bloqueador.

Evidência: `REGISTRY.md:324-325` alinha os ids globais aos paths. Os front-matters dos dois artefatos renomeados têm `path` e `id-global` alinhados, conforme comando abaixo. A tabela declara baseline e impossibilidade de prova Git em `20260612-120145-fable5-tabela-aprovacao-onda-0006-v2.md:183-191`; declara whitespace preservado em `:192-194`.

Comandos e saídas:

```text
$ shasum -a 256 .hbn/results/20260611-110642-codex-cross-ia-ativacao-enforcement.md .hbn/results/20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement.md
1a43ea7b5406162e593d61a2cdd4ece12e22a8b4fc3bc6e4163b4a61d28688b0  .hbn/results/20260611-110642-codex-cross-ia-ativacao-enforcement.md
dcaae44833870e8c7de243482d1fcb7b083da07235a1330ab5f09da39586919c  .hbn/results/20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement.md

$ rg -n "20260611-110642|20260611-125809" REGISTRY.md
324:| 20260611-110642-codex-cross-ia-ativacao-enforcement | .hbn/results/20260611-110642-codex-cross-ia-ativacao-enforcement.md | audit-result | frio | — | 2026-06-11T11:06:42-03:00 |
325:| 20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement | .hbn/results/20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement.md | audit-result | frio | — | 2026-06-11T12:58:09-03:00 |

$ git diff --check main..proposta/onda-0006-v2
.hbn/results/20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement.md:52: trailing whitespace.
+* **Análise:** 
.hbn/results/20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement.md:60: trailing whitespace.
+* **Análise:** 
.hbn/results/20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement.md:70: trailing whitespace.
+* **Análise:** 
```

## R6 — G-EXC modo mensagem só antes do último pick

Veredito: A JUSTIFICATIVA PROCEDE; não vejo brecha nova no runbook v2.

Severidade: OK, com observação operacional.

Evidência: `guards/assert-exception-traceable.sh:17-29` documenta que ativar antes do 4º sinal bloquearia a própria onda, e o código realmente exige o sinal vermelho + `PROPOSED_UNTIL_CROSS_AUDIT` em `:100-108` antes de validar trailers. Como o sinal nasce no I-09, instalar o hook commit-msg antes do último pick faria o guard bloquear commits intermediários depois que o arquivo do guard existisse e antes do STATE final. A tabela reconhece isso em `20260612-120145-fable5-tabela-aprovacao-onda-0006-v2.md:102-110`.

Comando de range na v2:

```text
$ HBN_DIFF_BASE=main bash guards/assert-exception-traceable.sh
[hbn-guards/assert-exception-traceable] EXCEÇÃO EM CURSO: implementador == agente do readback ativo (claude-fable-5). Exigindo sinais (F-01).
[hbn-guards/assert-exception-traceable] ✓ Exceção F-01 RASTREÁVEL: authorization no readback, sinais no STATE, trailers verificados — PROPOSED_UNTIL_CROSS_AUDIT vigente.
```

Observação: a segurança do runbook depende de seguir `commit -C` em todos os picks e manter a checagem de range antes da adoção final. Isso está coerente com a tabela v2 e com o comando acima.

## R7 — Bateria adversarial no Bash 3.2

Veredito: SANADO.

Severidade: OK.

Evidência: a B14 foi adaptada para o G-TOK v2 em `guards/tests/adversarial-battery.sh:136-146`, copiando fingerprint público com arquivo local errado; a execução local no Bash 3.2 bloqueou a burla.

Comando e saída:

```text
$ bash guards/tests/adversarial-battery.sh | tail -2

BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

## Fecho

Os achados que motivaram meu veto da v1 foram sanados no escopo desta re-auditoria. Não há novo bloqueador nos pontos R1..R7. O G-TOK não virou prova de posse exclusiva, mas a v2 corrigiu a promessa: prova posse do arquivo local naquele clone e declara explicitamente os limites. O runbook v2 é aceitável para cherry-pick item a item, desde que executado literalmente e com verificação final.

REGISTRY:

| 20260612-121318-codex-cross-ia-reaudit-onda-0006-v2 | .hbn/results/20260612-121318-codex-cross-ia-reaudit-onda-0006-v2.md | result | frio | — | 2026-06-12T12:13:18-03:00 |
