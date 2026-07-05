---
titulo: "Parecer Codex — cross-audit ex-post da onda ativação-enforcement (readback 0005)"
tipo: result
path: .hbn/results/20260611-110642-codex-cross-ia-ativacao-enforcement.md
id-global: 20260611-110642-codex-cross-ia-ativacao-enforcement
temperatura: glacier
auditor: codex-openai
alvo: "commits 27775bd, ffd40c5, 65b4af0 + readback 0005"
reviewed_at: "2026-06-11T11:06:42-03:00"
status: congelado
---

Resumo humano:
1. Mérito técnico: a suíte mecânica passou de verdade (`bash guards/tests/run-guard-tests.sh`: `79 passaram, 0 falharam`) e o sweep G-STRAY está limpo.
2. O hook chama o runner por `git rev-parse --show-toplevel`, sem path absoluto, mas há bypass ambiental documentado.
3. A pré-condição mínima da ADR-020 foi paga, mas a cobertura dos guards legados ainda tem lacunas adversariais.
4. G-STRAY é útil, porém tem falsos negativos relevantes: profundidade, symlink, poda `backups/` e fail-open por raiz inválida.
5. O REGISTRY está coerente nas linhas novas, mas a alteração de front-matter de artefatos antes untracked não é auditável por diff.
6. O uso local de `CI=true` para delegar canonical-root é aceitável só como exceção declarada; sem trava, vira bypass disfarçado.
7. O processo foi violado em severidade BLOQUEADOR: implementador desenhou, executou e commitou antes de cross-audit.
8. A cadeia ex-post é suficiente apenas se o humano mantiver status PROPOSED e exigir remediações abaixo antes de adoção.

VETO_ADOCAO: SIM

Referência quebrada transversal: o prompt mandou ler `.hbn/knowledge/0019-*` para severidades, e `agents/role-templates.md:75` também exige `.hbn/knowledge/0019`; o comando `ls -la .hbn/knowledge/0019-*` retornou `zsh:1: no matches found: .hbn/knowledge/0019-*`. Isso não impede este parecer, mas é achado FORTE de rastreabilidade do próprio rito de auditoria.

## P1 — Hook

Veredito: PASSA COM RESSALVA. Severidade: MARGINAL.

Evidência: `.git/hooks/pre-commit:3` executa `bash "$(git rev-parse --show-toplevel)/guards/hbn-guards-runner.sh"`, então sobrevive a repo movido/renomeado quando o hook roda dentro de um worktree Git. O runner resolve seu próprio diretório em `guards/hbn-guards-runner.sh:9` e chama cada guard por `${SCRIPT_DIR}` em `guards/hbn-guards-runner.sh:43`, sem depender do CWD.

Vetor de não-execução restante: `HBN_GUARDS_BYPASS=1` retorna sucesso em `guards/lib/common.sh:63-65` e todos os guards chamam `guard_check_bypass` (ex.: `guards/assert-no-stray-hbn.sh:40-42`). Isso é bypass de emergência, mas precisa de guard/CI que exija nota rastreável quando usado.

## P2 — Ativação e testes legados

Veredito: PRÉ-CONDIÇÃO MÍNIMA PAGA, COBERTURA NÃO EXAUSTIVA. Severidade: MARGINAL.

Evidência normativa: ADR-020 exige pelo menos um teste negativo verde antes de ativar guard no runner em `methodology/adr/ADR-020-anti-validacao-de-teatro.md:52-61`. A suíte declara a seção legada em `guards/tests/run-guard-tests.sh:27-29` como 12 checks, 8 `block` e 4 `pass`. Os casos cobrem G-ENV em `guards/tests/run-guard-tests.sh:687-695`, G-LEG em `guards/tests/run-guard-tests.sh:697-705`, G-SCO em `guards/tests/run-guard-tests.sh:707-732`, G-CR em `guards/tests/run-guard-tests.sh:734-742`, e G-TMP em `guards/tests/run-guard-tests.sh:744-754`.

Análise adversarial: os testes não são só caminho feliz, porque há casos `block` para `.env`, path proibido, scope fora/pendente/vazio, raiz canônica divergente e `/tmp`. Lacunas: o negativo de G-CR em `guards/tests/run-guard-tests.sh:735-737` mistura "toplevel diferente" com repo em `/tmp`; o negativo de G-TMP em `guards/tests/run-guard-tests.sh:747-749` testa worktree principal em `/tmp`, mas não a promessa do guard de recusar "QUALQUER worktree" registrada em `guards/forbid-tmp-worktree.sh:4-5`.

## P3 — Qualidade dos testes G-TMP/G-CR

Veredito: OK COM RISCO RESIDUAL BAIXO. Severidade: MARGINAL.

Evidência: o caso ruim de G-TMP força `/tmp` literal em `guards/tests/run-guard-tests.sh:747`, corrigindo o problema de `mktemp` obedecer `TMPDIR`; o guard cobre `/tmp/*` e `/private/tmp/*` em `guards/forbid-tmp-worktree.sh:34`, que é a normalização relevante no macOS. O caso bom de G-CR cria repo descartável dentro de `guards/tests` em `guards/tests/run-guard-tests.sh:739-741` e remove em `guards/tests/run-guard-tests.sh:742`.

Conclusão: o repo aninhado não enviesou o resultado observado; o comando P9 terminou verde. O risco é apenas operacional durante a execução, porque a suíte cria temporariamente diretórios não rastreados dentro da árvore de testes, mas os remove logo em seguida.

## P4 — G-STRAY

Veredito: ÚTIL, MAS NÃO SUFICIENTE COMO BARREIRA FINAL. Severidade: FORTE.

Evidência positiva: a regra do guard é "pai sem `.git`" em `guards/assert-no-stray-hbn.sh:70-72`. Como usa `-e` e não `-d` em `guards/assert-no-stray-hbn.sh:71`, worktree linkado e submódulo com `.git` arquivo são aceitos corretamente. A suíte cobre `.hbn` em repo, órfão na raiz, órfão em subpasta e poda de backup em `guards/tests/run-guard-tests.sh:756-775`.

Falsos negativos: `find` limita `-maxdepth 4` em `guards/assert-no-stray-hbn.sh:74`, então `.hbn` mais profundo passa. Symlink chamado `.hbn` não é coberto porque a busca usa `-type d -name ".hbn"` em `guards/assert-no-stray-hbn.sh:76` sem `-L`. A poda `backups` em `guards/assert-no-stray-hbn.sh:75` pode esconder órfão operacional se alguém escrever entrega real sob uma pasta com esse nome. O fail-open em raiz indeterminada (`guard_warn` + `exit 0`) está em `guards/assert-no-stray-hbn.sh:62-64`; se `HBN_SCAN_ROOT` for apontado para caminho inválido (`guards/assert-no-stray-hbn.sh:51-52`), isso vira bypass ambiental.

Remediação proposta: tratar `HBN_SCAN_ROOT` inválido como `exit 1` no modo guard, manter fail-open apenas em `--sweep` se explicitamente desejado, adicionar casos negativos para profundidade >4 e symlink, e exigir allowlist explícita para `backups/` em vez de poda global.

## P5 — REGISTRY e honestidade temporal

Veredito: REGISTRY COERENTE, MAS PROVA DE NÃO-ALTERAÇÃO DE TERCEIROS É FRACA. Severidade: FORTE.

Evidência REGISTRY: as 10 linhas novas estão em `REGISTRY.md:310-319`. Em cada linha, o HHMMSS do id bate com o `created_at`: por exemplo `REGISTRY.md:318` usa `20260611-014200...` e `2026-06-11T01:42:00-03:00`; `REGISTRY.md:319` usa `20260611-101851...` e `2026-06-11T10:18:51-03:00`. O readback também declara `created_at` em `.hbn/readbacks/0005-ativacao-enforcement.json:76`.

Inconsistência 0035: o parecer Antigravity tem `id-global: 20260611-025900...` em `.hbn/results/0035-cross-ia-antigravity-ponte.md:6` e `reviewed_at: "2026-06-11T02:59:00Z"` em `.hbn/results/0035-cross-ia-antigravity-ponte.md:9`; o REGISTRY registra o `.md` em `REGISTRY.md:315` como `20260610-235830...` com `created_at 2026-06-10T23:58:30-03:00`. Isso é MARGINAL para a adoção desta onda porque a linha do REGISTRY está internamente coerente, mas viola o espírito da ADR-024 D5 sobre hora local com offset em `methodology/adr/ADR-024-orquestracao-start.md:144-151`.

Artefatos de terceiros: o 0034 atual tem `path`, `id-global` e `temperatura` em `.hbn/results/0034-cross-ia-codex-ponte.md:4-6`, e a proposal Codex tem `path` relativo em `.hbn/proposals/20260610-221540-codex-ponte-002-008.md:3`. Porém `git show 27775bd` mostrou esses arquivos como `new file mode 100644`, sem preimage versionado; portanto a alegação do readback de que "Nenhum conteudo de parecer de terceiros ... é alterado em substancia" em `.hbn/readbacks/0005-ativacao-enforcement.json:47` não é mecanicamente auditável pelo Git. Para terceiros, isso deveria exigir anexo de hash pré-commit ou preservar o arquivo bruto original.

## P6 — `CI=true` nos commits do sandbox

Veredito: EXCEÇÃO DECLARADA, MAS ABRE BRECHA. Severidade: FORTE.

Evidência: `guards/assert-canonical-root.sh:19-23` retorna OK quando `CI=true`, delegando a raiz canônica ao pre-commit local. O readback declara que os commits no sandbox usaram `CI=true` em `.hbn/readbacks/0005-ativacao-enforcement.json:48` e lista o risco residual em `.hbn/readbacks/0005-ativacao-enforcement.json:66-68`. Os `git show 27775bd`, `git show ffd40c5` e `git show 65b4af0` exibem trailers `HBN-Sandbox: CI=true`.

Julgamento: como exceção ex-post, o uso é legítimo porque foi declarado e a suíte/sweep foram reexecutados no Terminal desta auditoria. Como regra permanente, é brecha: qualquer commit local pode exportar `CI=true` e pular a checagem mais crítica de raiz. Trava proposta: `assert-canonical-root.sh` só deve aceitar skip de CI quando houver sinal de CI real e range (`HBN_DIFF_BASE` em `guards/lib/common.sh:78-80`, ou `GITHUB_ACTIONS=true`/equivalente), e deve falhar em pre-commit local se `CI=true` vier sem esse contexto.

## P7 — Violação de processo

Veredito: BLOQUEIA ADOÇÃO AUTOMÁTICA. Severidade: BLOQUEADOR.

Evidência: o próprio STATE marca `proprietario_bastao: claude-fable-5` em `.hbn/relay/STATE.md:6` e papel de "orquestrador-implementador" por exceção em `.hbn/relay/STATE.md:7`. O readback traz `agent_id: claude-fable-5` em `.hbn/readbacks/0005-ativacao-enforcement.json:4`, `human_status: confirmed` em `.hbn/readbacks/0005-ativacao-enforcement.json:8`, e autorização textual em `.hbn/readbacks/0005-ativacao-enforcement.json:11-15`. O template de auditor cruzado diz "Você NÃO implementa — só audita" em `agents/role-templates.md:66-68` e "Não edite NENHUM outro arquivo do projeto" em `agents/role-templates.md:83`. A ADR-024 também registrava que guards novos não entrariam no runner naquela onda em `methodology/adr/ADR-024-orquestracao-start.md:47-50`.

Classificação: a violação é BLOQUEADOR de processo, não porque o mérito técnico falhou, mas porque o rito normal foi invertido: desenhista = implementador = commitador, com cross-audit só depois. A cadeia ex-post (este parecer + Antigravity + hearback humano + manter PROPOSED) é suficiente para aceitar a exceção somente se a adoção final registrar explicitamente que foi uma exceção autorizada, não precedente.

Regra proposta: criar um guard de "exceção rastreável" para safe_track direto por IA. Exigir simultaneamente: campo `authorization` no readback com citação humana e timestamp; trailer de commit `HBN-Readback: <id>` e `HBN-Human-Authorization: <id>`; sinal no STATE; e, se `agent_id` for também implementador, status automático `PROPOSED_UNTIL_CROSS_AUDIT` até dois auditores externos e hearback humano. Sem os quatro sinais, o commit deve bloquear.

## P8 — STATE

Veredito: NÃO REFLETE FIELMENTE O ESTADO FINAL. Severidade: FORTE.

Evidência: o STATE atual ainda diz "suíte 75" em `.hbn/relay/STATE.md:5`, mas a versão final da suíte declara total 79 em `guards/tests/run-guard-tests.sh:30-31` e o P9 confirmou `79 passaram, 0 falharam`. O sinal em `.hbn/relay/STATE.md:15` diz "12 checks negativos", mas a própria suíte declara 12 checks com 8 `block` e 4 `pass` em `guards/tests/run-guard-tests.sh:27-29`. A nota da onda menciona criação do G-STRAY em `.hbn/relay/STATE.md:48`, mas o cabeçalho/sinais não registram que o runner final tem 11 guards, comprovado por `guards/hbn-guards-runner.sh:26-38`.

Claims com lastro: o hook existe e chama o runner (`.git/hooks/pre-commit:3`); o readback 0005 é o ativo (`.hbn/relay/STATE.md:26`); a âncora de rollback `27775bd` está em `.hbn/relay/STATE.md:28`; e a nota de `CI=true` pendente está em `.hbn/relay/STATE.md:18`. Mas as inconsistências de contagem e o estado final de G-STRAY precisam ser corrigidos antes de qualquer adoção.

## P9 — Reprodutibilidade

Veredito: PASSA. Severidade: MARGINAL.

Evidência: o comando `bash guards/tests/run-guard-tests.sh` saiu com código 0 e encerrou com `== resumo: 79 passaram, 0 falharam ==` e `SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.`. O comando `bash guards/assert-no-stray-hbn.sh --sweep` saiu com código 0 e imprimiu `[hbn-guards/assert-no-stray-hbn] ✓ Nenhum .hbn órfão sob /Users/macbookpro/Projetos (todo .hbn mora em raiz de repo git).`

Isso confirma a parte mecânica principal da onda. O veto desta auditoria é por rastreabilidade/processo e por lacunas de regra, não por falha atual da suíte.

## Linha REGISTRY proposta

| 20260611-110642-codex-audit-ativacao-enforcement | .hbn/results/0036-cross-ia-codex-ativacao-enforcement.md | audit-result | frio | — | 2026-06-11T11:06:42-03:00 |
