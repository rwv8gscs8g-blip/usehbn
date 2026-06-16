---
titulo: "Cross-audit de implementacao hbn-exuvia: versao como pasta com sistema inteiro"
tipo: result
status: auditado
path: .hbn/results/20260614-043826-codex-cross-ia-exuvia-impl.md
created_at: "2026-06-14T04:38:26-03:00"
agente: codex
escopo: "auditoria de desenho/seguranca + dry-run de guards; sem corte real; sem commit"
---

# Cross-audit de implementacao - hbn-exuvia

## Veredito curto

Recomendacao: **aprovar o desenho apenas para dry-run controlado**, e **nao liberar corte real** ate existir um Fitness Gate executavel que prove baseline funcional, Ponte do Credenciamento e confronto incumbente x desafiante. Isto decorre diretamente do mecanismo de aptidao: a versao atual precisa estar funcional/testada, o desafiante precisa ser confrontado nos mesmos testes reais, e o incumbente sobrevive por padrao se o desafiante nao vencer (`/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md:12`, `/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md:20`).

Dry-run executado nesta auditoria:

- `bash guards/tests/run-guard-tests.sh`: 125 passaram, 0 falharam.
- `bash guards/hbn-guards-runner.sh`: passou no caminho real do hook.

Limite honesto: isto prova a bateria atual de guards e o runner, **nao** prova a exuvia real, porque ainda nao houve confronto incumbente x desafiante nem Ponte do Credenciamento.

## 1. Bootstrap da 1a muda

### Recomendacao

Separar a 1a muda em commits pequenos, com o incumbente ativo ate o Fitness Gate aprovar o desafiante. O plano v2 compacta congelamento, nascimento, ponte e verificacao em M2 (`/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:136`, `/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:147`); para P10, a ativacao deve ser um commit proprio, posterior a prova do desafiante.

### Sequencia segura proposta

**Checkpoint 0 - pre-flight sem commit**

1. Registrar `HEAD`, branch, `git status --short`, suites e runner.
2. Criar ancora P1/P6 antes de qualquer movimentacao estrutural: tag local assinavel/imutavel de trabalho, por exemplo `hbn-exuvia/pre-bootstrap-0.3.x-<timestamp>`.
3. Confirmar que isto ainda e dry-run: a 1a exuvia real so vem depois de estabilizar e provar via Credenciamento (`/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md:49`, `/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md:55`).

**Commit 1 - camada de controle fail-closed, sem mover arvore**

Adicionar um ponteiro de versao vigente no nivel do repo, por exemplo `HBN_ACTIVE_VERSION`, inicialmente em modo compatibilidade (`.` ou `root-0.3.x`), mais shims de hook fail-closed. Motivo: os hooks atuais chamam `guards/` direto do topo Git (`/Users/macbookpro/Projetos/usehbn/.git/hooks/pre-commit:3`) e o `commit-msg` atual libera se guard estiver ausente (`/Users/macbookpro/Projetos/usehbn/.git/hooks/commit-msg:2`, `/Users/macbookpro/Projetos/usehbn/.git/hooks/commit-msg:10`). Depois do bootstrap isso deve ser proibido.

Checkpoint: instalar shims em `.git/hooks/`, rodar `bash guards/tests/run-guard-tests.sh`, `bash guards/hbn-guards-runner.sh`, e um teste manual do `commit-msg` com mensagem temporaria.

**Commit 2 - guards version-aware, ainda na raiz atual**

Alterar `guards/lib/common.sh` para resolver duas raizes: `HBN_REPO_ROOT` e `HBN_VERSION_ROOT`. Hoje `guard_canonical_root()` le sempre `${repo_root}/.hbn/canonical-root` (`/Users/macbookpro/Projetos/usehbn/guards/lib/common.sh:42`, `/Users/macbookpro/Projetos/usehbn/guards/lib/common.sh:50`), e `guard_diff_files()` devolve paths relativos ao repo (`/Users/macbookpro/Projetos/usehbn/guards/lib/common.sh:94`, `/Users/macbookpro/Projetos/usehbn/guards/lib/common.sh:101`). Apos a muda, os paths do Git serao `versao_1_0_0/.hbn/...`, mas os guards precisam operar como `.hbn/...` dentro da versao.

Checkpoint: todos os guards passam em modo raiz atual e em fixture sintetica com `HBN_ACTIVE_VERSION=versao_fixture`.

**Commit 3 - congelar incumbente em `versao_0_3_x/`**

Mover por `git mv` a forma atual rastreada para `versao_0_3_x/`, incluir os untracked preservados com `git add -f` conforme o proprio plano exige (`/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:177`, `/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:190`), criar `EXUVIAS.md` no nivel do repo e atualizar o ponteiro ativo para `versao_0_3_x`. O documento de transicao pode nascer aqui com ponteiro de destino esperado para `versao_1_0_0`, sem exigir que o destino exista ainda; o documento de volta da 1.0.0 nasce depois.

Checkpoint antes do commit: o hook deve executar `versao_0_3_x/guards/hbn-guards-runner.sh` via ponteiro ativo. Depois do commit, tag obrigatoria `hbn-exuvia/protocol-0.3.x` nesse commit, porque o plano exige tag anti-GC (`/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:154`, `/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:163`).

**Commit 4 - nascer `versao_1_0_0/` como desafiante, sem ativar**

Adicionar a pasta completa `versao_1_0_0/` com o carry-forward ratificado, manifesto, ledger, guards e primeiro documento vivo. **Nao atualizar ainda `HBN_ACTIVE_VERSION`**. O incumbente `versao_0_3_x` continua vigente, coerente com "incumbente sobrevive por padrao" (`/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md:20`).

Checkpoint: runner do incumbente passa; runner do desafiante passa em modo explicito; suite, testes reais e Ponte do Credenciamento rodam contra ambos nos mesmos criterios.

**Commit 5 - ativar `versao_1_0_0/` somente apos Fitness Gate**

Commit minimo: trocar `HBN_ACTIVE_VERSION` para `versao_1_0_0`, atualizar `EXUVIAS.md`, registrar manifesto/ponte bidirecional e sinal de dependencia. Este commit e o corte real. Se o runner da 1.0.0 estiver quebrado, o pre-commit ja deve bloquear porque o hook le o ponteiro ativo staged/HEAD e executa o runner da versao apontada.

Checkpoint pos-commit: `bash versao_1_0_0/guards/hbn-guards-runner.sh`, suite completa, Ponte do Credenciamento, teste de rollback em branch temporaria e conferencia de tag do incumbente.

## 2. Hooks e caminho-raiz

### Recomendacao

Os hooks devem virar shims finos, mas fail-closed:

1. Resolver `repo_root` por `git rev-parse --show-toplevel`.
2. Ler `HBN_ACTIVE_VERSION` preferencialmente do index (`git show :HBN_ACTIVE_VERSION`), depois de `HEAD:HBN_ACTIVE_VERSION`, e so por ultimo da working tree. Isto evita que um ponteiro staged diga uma coisa e a working tree outra.
3. Validar que o valor e um diretorio permitido (`versao_X_Y_Z`) e que `guards/hbn-guards-runner.sh` existe dentro dele.
4. Exportar `HBN_REPO_ROOT`, `HBN_ACTIVE_VERSION`, `HBN_VERSION_ROOT`.
5. Executar o runner da versao vigente.

Na proxima muda, repontar para `versao_2_0_0/` vira uma troca atomica do ponteiro ativo, mas so no commit de ativacao. O modelo ja decidiu que hooks no nivel do repo apontam para o runner da versao vigente (`/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md:42`, `/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md:46`); a parte que falta e o shim falhar fechado quando a versao/runner nao existir.

O `assert-canonical-root` tambem precisa mudar de semantica: hoje compara o `git toplevel` com o canonical root (`/Users/macbookpro/Projetos/usehbn/guards/assert-canonical-root.sh:53`, `/Users/macbookpro/Projetos/usehbn/guards/assert-canonical-root.sh:92`). No modelo novo, o `git toplevel` continuara sendo `/Users/macbookpro/Projetos/usehbn`, mas a raiz canonica operacional sera `/Users/macbookpro/Projetos/usehbn/versao_1_0_0`. Logo, a comparacao correta e "repo_root conhecido + version_root ativo existe + cwd dentro do repo permitido + version_root = ponteiro ativo", nao `toplevel == version_root`.

## 3. Guards relativos a versao

### Recomendacao

Criar uma API unica em `guards/lib/common.sh` e proibir cada guard de montar paths manualmente. Minimo:

- `guard_repo_root`
- `guard_active_version`
- `guard_version_root`
- `guard_version_path <rel>`
- `guard_blob_ref <version_rel>`
- `guard_diff_files` retornando paths relativos a versao ativa
- `guard_repo_diff_files` somente para controle de repo (`EXUVIAS.md`, `HBN_ACTIVE_VERSION`, manifests de glacier)

Pontos que hoje quebrariam ou dariam falso positivo/bypass:

- `G-REG`: hardcode em `REGISTRY.md` (`/Users/macbookpro/Projetos/usehbn/guards/assert-registry-line.sh:50`), padroes `.hbn/...`, `guards/...`, `core/...` (`/Users/macbookpro/Projetos/usehbn/guards/assert-registry-line.sh:85`, `/Users/macbookpro/Projetos/usehbn/guards/assert-registry-line.sh:101`) e allowlist de raiz (`/Users/macbookpro/Projetos/usehbn/guards/assert-registry-line.sh:138`) devem operar na raiz da versao, nao na raiz do repo.
- `G-SCO`: procura readbacks em `${REPO_ROOT}/.hbn/readbacks` (`/Users/macbookpro/Projetos/usehbn/guards/assert-scope-lock.sh:27`, `/Users/macbookpro/Projetos/usehbn/guards/assert-scope-lock.sh:31`) e libera meta-paths `.hbn/...` (`/Users/macbookpro/Projetos/usehbn/guards/assert-scope-lock.sh:113`, `/Users/macbookpro/Projetos/usehbn/guards/assert-scope-lock.sh:119`); precisa usar version root.
- `G-NUM`: usa `.hbn/relay/STATE.md`, `REGISTRY.md` e `.hbn/models` diretamente (`/Users/macbookpro/Projetos/usehbn/guards/assert-parallel-id.sh:55`, `/Users/macbookpro/Projetos/usehbn/guards/assert-parallel-id.sh:107`); precisa de blob resolver version-aware.
- `G-RLT`: filtra handoffs por `^\.hbn/messages/` (`/Users/macbookpro/Projetos/usehbn/guards/assert-report-fresh.sh:41`, `/Users/macbookpro/Projetos/usehbn/guards/assert-report-fresh.sh:52`); so funciona se `guard_diff_files` ja stripar `versao_X_Y_Z/`.
- `G-PTR`: gatilha apenas `.hbn/messages/*.md|docs/prompts/*.md` (`/Users/macbookpro/Projetos/usehbn/guards/assert-pointer-honest.sh:79`, `/Users/macbookpro/Projetos/usehbn/guards/assert-pointer-honest.sh:81`) e valida destino por blob ref direto (`/Users/macbookpro/Projetos/usehbn/guards/assert-pointer-honest.sh:110`, `/Users/macbookpro/Projetos/usehbn/guards/assert-pointer-honest.sh:113`); precisa resolver destino dentro da versao ativa.
- `G-HRB`: entra no topo Git (`/Users/macbookpro/Projetos/usehbn/guards/assert-hearback-integrity.sh:49`, `/Users/macbookpro/Projetos/usehbn/guards/assert-hearback-integrity.sh:50`) e considera puro apenas `.hbn/hearbacks/` (`/Users/macbookpro/Projetos/usehbn/guards/assert-hearback-integrity.sh:97`, `/Users/macbookpro/Projetos/usehbn/guards/assert-hearback-integrity.sh:104`, `/Users/macbookpro/Projetos/usehbn/guards/assert-hearback-integrity.sh:137`); no novo modelo, o path real no Git sera `versao_1_0_0/.hbn/hearbacks/`.
- `G-STRAY`: hoje declara que todo `.hbn/` deve morar ao lado de `.git/` (`/Users/macbookpro/Projetos/usehbn/guards/assert-no-stray-hbn.sh:11`, `/Users/macbookpro/Projetos/usehbn/guards/assert-no-stray-hbn.sh:18`) e marca como orfao se o pai nao tem `.git` (`/Users/macbookpro/Projetos/usehbn/guards/assert-no-stray-hbn.sh:99`, `/Users/macbookpro/Projetos/usehbn/guards/assert-no-stray-hbn.sh:105`). Isso bloquearia corretamente hoje, mas seria falso positivo para `versao_1_0_0/.hbn`. Ele deve aceitar `.hbn` dentro de versoes registradas em `EXUVIAS.md` e continuar bloqueando `.hbn` solto fora delas.

## 4. Reversibilidade P6

### Recomendacao

Rollback precisa ter dois niveis:

1. **Rollback operacional imediato:** trocar `HBN_ACTIVE_VERSION` de volta para `versao_0_3_x` em commit minimo, mantendo `versao_1_0_0` inerte. Isto deve ser testado antes do corte real.
2. **Rollback historico:** `git revert` dos commits de ativacao/nascimento se a decisao humana for remover a tentativa, preservando a tag da casca.

P6 exige caminho de rollback documentado e exercitado, nao presumido (`/Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md:151`, `/Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md:163`). O Fitness Gate tambem exige rollback para o incumbente congelado se a muda decepcionar no uso real (`/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md:22`, `/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md:23`).

Checkpoint obrigatorio de P6: em branch temporaria, ativar `versao_1_0_0`, rodar runner, voltar ponteiro para `versao_0_3_x`, rodar runner de novo, e verificar que a tag `hbn-exuvia/protocol-0.3.x` ainda resolve os arquivos congelados.

Risco especifico: o bastao/token vive em `.git/` compartilhado por versoes (`/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md:47`), mas o guard atual le o hash no `STATE` da versao (`/Users/macbookpro/Projetos/usehbn/guards/assert-baton-token.sh:74`, `/Users/macbookpro/Projetos/usehbn/guards/assert-baton-token.sh:98`). Rollback para uma versao congelada pode bloquear commits se o token atual nao casar com o hash antigo. Mitigacao: a ativacao/rollback de versao deve incluir uma cerimonia de token ou mover o hash operacional para uma camada de controle de repo claramente documentada, mantendo o segredo em `.git/`.

## 5. Glacier e leitura

### Recomendacao

A entrada de uma IA deve ler, nesta ordem:

1. `HBN_ACTIVE_VERSION` no nivel do repo.
2. `EXUVIAS.md` apenas como indice de versoes e ponteiros.
3. A read-list auto-contida dentro de `versao_X_Y_Z/` vigente.

Isto materializa o desenho de leitura otimizada: a IA nova le apenas a versao vigente e so consulta anterior se chamada explicitamente (`/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md:21`, `/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md:26`).

Para glacier, nao apagar uma versao antiga ate que:

- exista tag/fork/archive verificavel;
- `EXUVIAS.md` tenha checksum, tag, commit e local frio;
- o documento de transicao continue acessivel via tag/archive;
- a read-list da versao ativa nao aponte diretamente para paths quentes de versoes antigas.

Se a pasta `versao_0_3_x/` sair do repo ativo, links da versao vigente devem apontar para `EXUVIAS.md`/tag/archive, nao para `versao_0_3_x/...` local. O modelo permite glacier para versoes antigas (`/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md:48`, `/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md:49`), mas o documento de transicao precisa sobreviver como ponteiro quente ou como artefato frio enderecado no indice.

## 6. Fitness Gate

### Recomendacao

O `freeze-gate.sh` existente e util, mas insuficiente como Fitness Gate completo. Ele valida checklist, evidencias, `na` justificado e bloqueadores (`/Users/macbookpro/Projetos/usehbn/guards/freeze-gate.sh:3`, `/Users/macbookpro/Projetos/usehbn/guards/freeze-gate.sh:15`); nao compara incumbente x desafiante, nao roda os mesmos testes reais em ambos, e nao conhece a Ponte do Credenciamento.

Criar `guards/fitness-gate.sh` ou estender `freeze-gate.sh` com schema proprio contendo:

- `incumbent.version`, `incumbent.sha`, `incumbent.runner`;
- `challenger.version`, `challenger.sha`, `challenger.runner`;
- comandos e logs de suite, testes reais e Ponte do Credenciamento para ambos;
- metricas de vitoria ("mais com menos, melhor") com evidencia medida;
- veredito `challenger_won: true|false`;
- hearback humano que autoriza a ativacao.

O commit de ativacao (`HBN_ACTIVE_VERSION=versao_1_0_0`) deve ser bloqueado se nao houver artefato de Fitness Gate aprovado no mesmo diff ou preexistente e referenciado.

## 7. Riscos nao previstos / subcobertos

1. **Hooks orfaos e tolerantes.** `.git/hooks` nao e versionado, e o `commit-msg` atual libera quando guard esta ausente (`/Users/macbookpro/Projetos/usehbn/.git/hooks/commit-msg:7`, `/Users/macbookpro/Projetos/usehbn/.git/hooks/commit-msg:10`). Mitigacao: hook shim fail-closed + verificador versionado que compara o conteudo instalado dos hooks com o template aprovado.
2. **`G-STRAY` vai bloquear o modelo novo se nao for adaptado.** A regra atual exige `.hbn` ao lado de `.git` (`/Users/macbookpro/Projetos/usehbn/guards/assert-no-stray-hbn.sh:11`), incompatível com `versao_1_0_0/.hbn`. Mitigacao: allowlist derivada de `EXUVIAS.md`/ponteiro ativo, nao allowlist manual ampla.
3. **Bastao/token compartilhado pode quebrar rollback.** O token em `.git` e compartilhado entre versoes, mas o hash versionado mora no STATE ativo. Mitigacao: cerimonia explicita de token na ativacao e rollback, ou camada operacional de repo para o hash/fingerprint.
4. **Crescimento linear do repo.** O repo atual tem 455 arquivos rastreados e cerca de 62M no worktree observado; duplicar o sistema inteiro por versao cresce rapido, especialmente se `build/`, `dist/` e `site/` forem carregados. O proprio plano marca esses artefatos como frios/reconstruiveis (`/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:287`). Mitigacao: manifesto de carry-forward exclui gerados reconstruiveis por padrao.
5. **Edicoes em versao inativa.** Apos existir `versao_0_3_x` e `versao_1_0_0`, um diff pode tocar a versao inativa e escapar de guards se `guard_diff_files` simplesmente filtrar pela ativa. Mitigacao: guard novo bloqueia qualquer alteracao em versao nao ativa, exceto commits de transicao/glacier explicitamente autorizados por readback e hearback.

## Honestidade: fonte vs inferencia

Fonte direta:

- Modelo de pasta-versao, hooks por versao, canonical root por versao, token em `.git` e glacier: `/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md:6`, `/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md:49`.
- Fitness Gate obrigatorio, incumbente x desafiante, reversibilidade: `/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md:12`, `/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md:23`.
- P1/P6/P10: `/Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md:54`, `/Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md:151`, `/Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md:228`.
- Acoplamentos reais de hooks/guards: arquivos citados acima.

Inferencia tecnica:

- Nome `HBN_ACTIVE_VERSION`, API exata de `common.sh`, commit split entre nascimento e ativacao, e formato do `fitness-gate.sh`. Esses nomes nao estao decididos nos documentos; sao a proposta desta auditoria para executar o modelo decidido com P10/P6.

Especulacao controlada:

- Crescimento futuro do repo, colisao operacional de token em rollback e falhas de glacier dependem da implementacao final. Sao riscos plausiveis, nao falhas ja observadas.
