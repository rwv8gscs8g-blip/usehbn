SOU: codex · familia OpenAI · papel implementador

# Auditoria executiva de implementação — ponte PROTOCOLO x PROJETO

Escopo: checagem de viabilidade prática do desenho "duas camadas, uma membrana" para `~/Projetos/usehbn` (protocolo) e `~/Projetos/Credenciamento` (projeto). Isto é auditoria read-only, não ratificação, sem `APROVA`, sem commit e sem `--no-verify`.

## Estado verificado no disco

Comando:

```bash
git --no-optional-locks -C /Users/macbookpro/Projetos/usehbn rev-parse v1-estavel^{}
```

Saída:

```text
a67e8049ed6fd4f81423ee60194a2f5896f25af0
```

Comandos:

```bash
git --no-optional-locks -C /Users/macbookpro/Projetos/Credenciamento branch --show-current
git --no-optional-locks -C /Users/macbookpro/Projetos/Credenciamento status --short --branch
```

Saída relevante:

```text
codex/v12-0-0206-planejamento
## codex/v12-0-0206-planejamento...origin/codex/v12-0-0206-planejamento [ahead 12]
 M docs/reference/testes/INDEX.md
 D "obsidian-vault/Sem t\303\255tulo.canvas"
?? .hbn/readbacks/0178-rb-relatorio-prestacao-contas-abril-maio-testes.json
?? .hbn/results/0178-exec-relatorio-prestacao-contas-abril-maio-testes.json
...
```

Observação: os dois worktrees já estavam sujos antes desta auditoria. Não alterei arquivos versionados.

Comandos:

```bash
rg --files core | wc -l
rg --files methodology | wc -l
rg --files schemas | wc -l
rg --files guards | wc -l
find /Users/macbookpro/Projetos/Credenciamento/usehbn -type f | wc -l
find /Users/macbookpro/Projetos/Credenciamento -name .usehbn-snapshot -type d -prune -print
```

Saídas:

```text
22
32
17
66
110
<sem saída>
```

Conclusão de estado: o protocolo tem a estrutura declarada (`core=22`, `methodology=32`, `schemas=17`, `guards=66`); o projeto ainda tem espelho vivo `usehbn/` com 110 arquivos físicos e não tem `.usehbn-snapshot/`.

## 1. Guards do subset fora do repo do protocolo

Primeiro confirmei que os quatro guards analisados não divergiam do tag `v1-estavel` no recorte auditado.

Comando:

```bash
git --no-optional-locks -C /Users/macbookpro/Projetos/usehbn diff --stat v1-estavel -- guards/assert-scope-lock.sh guards/assert-canonical-root.sh guards/assert-knowledge-index.sh guards/assert-hearback-integrity.sh guards/lib/common.sh guards/hbn-guards-runner.sh
```

Saída:

```text
<sem saída>
```

### Dependências diretas

`guards/lib/common.sh` é o ponto de acoplamento principal:

- `guards/lib/common.sh:60-67` lê `.hbn/canonical-root` na raiz do repo Git.
- `guards/lib/common.sh:69-106` exige `.hbn/active-version` com exatamente uma versão ativa.
- `guards/lib/common.sh:109-123` implementa `get_canonical_root()`.
- `guards/lib/common.sh:141-152` implementa `guard_version_repo_path()`.
- `guards/lib/common.sh:243-248` transforma o diff staged/range CI em paths relativos à versão ativa.

Isso quebra no Credenciamento como está, porque o projeto tem `.hbn/canonical-root`, mas não tem `.hbn/active-version`.

Comando:

```bash
ls -la .hbn
test -f .hbn/active-version
```

Saída relevante:

```text
-rw-r--r--@   1 macbookpro  staff    42 May 24 17:16 canonical-root
drwxr-xr-x@ 158 macbookpro  staff  5056 Jun 18 14:19 readbacks
...
<test saiu com código 1>
```

### Execução real dos guards do protocolo na raiz do Credenciamento

Comandos executados em `/Users/macbookpro/Projetos/Credenciamento`:

```bash
bash /Users/macbookpro/Projetos/usehbn/guards/assert-canonical-root.sh
bash /Users/macbookpro/Projetos/usehbn/guards/assert-scope-lock.sh
bash /Users/macbookpro/Projetos/usehbn/guards/assert-knowledge-index.sh
bash /Users/macbookpro/Projetos/usehbn/guards/assert-hearback-integrity.sh
```

Saídas:

```text
[hbn-guards/assert-canonical-root] ✗ COMMIT BLOQUEADO
  motivo: Ponteiro .hbn/active-version inválido: erro desconhecido. Conflito/ausência/corrupção do ponteiro é fail-closed até resolução manual explícita.
```

```text
[hbn-guards/assert-scope-lock] ✗ COMMIT BLOQUEADO
  motivo: Versão ativa inválida: erro desconhecido. Não é possível localizar readbacks da versão ativa.
```

```text
[hbn-guards/assert-knowledge-index] ✗ COMMIT BLOQUEADO
  motivo: Versão ativa inválida: erro desconhecido. Não é possível localizar a knowledge base.
```

```text
[hbn-guards/assert-hearback-integrity] ✓ Nenhum hearback no diff staged.
```

Resultado: como estão, os guards do protocolo não são plug-and-play no projeto. Três dos quatro falham antes da lógica útil por ausência de `.hbn/active-version`. O único que passa (`assert-hearback-integrity`) passa porque seu modo runner cai no caminho simples de diff staged sem hearback.

### Guard a guard

`assert-canonical-root.sh`

- Usa `guard_repo_canonical_root` e `get_canonical_root`: `guards/assert-canonical-root.sh:46-53`.
- Compara `pwd`, `git rev-parse --show-toplevel` e raiz ativa: `guards/assert-canonical-root.sh:57-71`.
- Exige raiz ativa dentro do repo Git: `guards/assert-canonical-root.sh:103-109`.
- Quebra hoje no projeto por falta de `.hbn/active-version`.
- Shim mínimo: criar semântica de consumidor onde a versão ativa do projeto é `"."`, seja por arquivo `.hbn/active-version` com `.` ou por `HBN_PROJECT_MODE=1` no `common.sh`. Sem isso, falha fechado.

`assert-scope-lock.sh`

- Resolve raiz Git e raiz ativa: `guards/assert-scope-lock.sh:27-35`.
- Procura readbacks via `guard_version_repo_path ".hbn/readbacks"`: `guards/assert-scope-lock.sh:33-35`.
- Em pre-commit lê o readback staged por `git show ":${ACTIVE_RB_REPO_PATH}"`: `guards/assert-scope-lock.sh:63-72`.
- Usa `guard_diff_files`: `guards/assert-scope-lock.sh:101`.
- Usa meta-paths `.hbn/hearbacks`, `.hbn/bypasses`, `.hbn/messages`, `.hbn/relay/INDEX.md`: `guards/assert-scope-lock.sh:202-215`.
- Quebra hoje pelo mesmo motivo (`active-version`). Depois do shim `"."`, tende a funcionar melhor que a cópia local porque lê o índice Git, não só a working tree.

`assert-knowledge-index.sh`

- Hard-code de superfície local: `INDEX_PATH=".hbn/knowledge/INDEX.md"` e `KNOWLEDGE_DIR=".hbn/knowledge"` em `guards/assert-knowledge-index.sh:23-24`.
- Converte esses paths por `guard_version_repo_path`: `guards/assert-knowledge-index.sh:25-31`.
- Lê o INDEX staged/HEAD, não a working tree solta: `guards/assert-knowledge-index.sh:33-48`.
- Falha fechado se o INDEX não está no índice/HEAD: `guards/assert-knowledge-index.sh:69-72`.
- Além do shim de `active-version`, o projeto tem uma pré-higiene pendente. Comando:

```bash
python3 - <<'PY'
from pathlib import Path
root=Path('.hbn/knowledge')
idx=(root/'INDEX.md').read_text(encoding='utf-8')
missing=[]
files=sorted(p.name for p in root.glob('*.md') if p.name!='INDEX.md')
for name in files:
    if name not in idx:
        missing.append(name)
print('knowledge_md', len(files))
print('missing_in_index', len(missing))
for name in missing[:20]:
    print(name)
PY
```

Saída:

```text
knowledge_md 24
missing_in_index 7
0007-acesso-controlado-via-cla.md
0008-importador-v2-arquitetura.md
0009-licoes-importador-v3-phase1.md
0013-contratos-executaveis.md
0015-readback-opening-bootstrap.md
0016-bump-build-label-anti-conflito.md
0018-uso-delta-vs-completo.md
```

Conclusão: `assert-knowledge-index` deve entrar só depois de uma onda de higiene do `INDEX.md` ou inicialmente como warning no project-mode.

`assert-hearback-integrity.sh`

- Resolve repo e raiz ativa com fallback para repo root: `guards/assert-hearback-integrity.sh:49-52`.
- Procura chaves em `${ACTIVE_ROOT}/.hbn/operators`: `guards/assert-hearback-integrity.sh:60-61`.
- Modo runner bloqueia hearback staged junto com obra: `guards/assert-hearback-integrity.sh:96-116`.
- Modo com argumento valida commit prévio e pureza histórica: `guards/assert-hearback-integrity.sh:119-159`.
- No projeto passa hoje em modo runner se não houver hearback staged. Ainda assim precisa de decisão sobre chaves `.hbn/operators/*.pub`; sem chave ele vira aviso, não trava criptográfica.

### Comparação com os guards locais do Credenciamento

Comandos:

```bash
bash scripts/hbn-guards/assert-canonical-root.sh
bash scripts/hbn-guards/assert-scope-lock.sh
bash scripts/hbn-guards/hbn-guards-runner.sh
```

Saídas:

```text
[hbn-guards/assert-canonical-root] ✓ Raiz canônica OK: /Users/macbookpro/Projetos/Credenciamento
```

```text
[hbn-guards/assert-scope-lock] Readback ativo: 0178-rb-relatorio-prestacao-contas-abril-maio-testes.json | track=fast_track | human_status=confirmed
[hbn-guards/assert-scope-lock] ✓ track=fast_track — scope lock não obrigatório.
```

```text
[hbn-guards] Iniciando bateria de guards de governança…
---
[hbn-guards/assert-canonical-root] ✓ Raiz canônica OK: /Users/macbookpro/Projetos/Credenciamento
---
[hbn-guards/forbid-tmp-worktree] ✓ Nenhum worktree em /tmp ou áreas voláteis.
---
[hbn-guards/forbid-env-files] ✓ Sem arquivos staged.
---
[hbn-guards/forbid-legacy-paths] ✓ Sem arquivos staged.
---
[hbn-guards/assert-scope-lock] Readback ativo: 0178-rb-relatorio-prestacao-contas-abril-maio-testes.json | track=fast_track | human_status=confirmed
[hbn-guards/assert-scope-lock] ✓ track=fast_track — scope lock não obrigatório.
---
[hbn-guards] Todos os guards passaram.
```

Diferença de desenho: `Credenciamento/scripts/hbn-guards/lib/common.sh:42-57` só lê `.hbn/canonical-root`; não tem `active-version`, `get_canonical_root` nem `guard_version_repo_path`. O protocolo v1-estavel evoluiu para version-aware; o projeto ainda está em layout simples.

## 2. Geração do snapshot a partir do tag

Mecanismo recomendado: `git archive` a partir do tag/commit, não `cp` e não checkout de working tree.

Motivos:

- `cp` copia estado do working tree e pode incluir sujeira local, xattrs e arquivos ignorados.
- `git checkout-index` exige checkout temporário e ainda depende de índice/local state.
- `git archive v1-estavel -- core methodology schemas guards` exporta a tree selada do commit, sem `.git`, sem untracked, sem depender do branch atual.

Comandos de validação:

```bash
git --no-optional-locks -C /Users/macbookpro/Projetos/usehbn ls-tree -r --full-tree --name-only v1-estavel -- core methodology schemas guards | wc -l
```

Saída:

```text
137
```

```bash
git --no-optional-locks -C /Users/macbookpro/Projetos/usehbn archive --format=tar v1-estavel -- core methodology schemas guards | tar -tf - | sed -n '1,16p'
```

Saída:

```text
core/
core/arvores-spec.md
core/cadence-d.md
core/command-spec.md
core/dispatch-spec.md
core/dual-run-spec.md
core/esteira-pre-transicao.md
core/exuvia-fitness-criteria.md
core/freeze-gate-spec.md
core/hbn-exuvia-scaffold.md
core/orchestrator-profile-spec.md
core/pointer-spec.md
core/protocol.md
core/read-list-canonica.txt
core/readback-spec.md
core/relay-return-spec.md
```

O tar bruto repetiu hash localmente:

```bash
git --no-optional-locks -C /Users/macbookpro/Projetos/usehbn archive --format=tar v1-estavel -- core methodology schemas guards | shasum -a 256
```

Saída em duas execuções:

```text
1bf326d7e71c3d3f767f8b924863c0d126bb528f685874531394b4fb65cd9038  -
1bf326d7e71c3d3f767f8b924863c0d126bb528f685874531394b4fb65cd9038  -
```

Mesmo assim, o `PROTOCOL_SHA256` não deve ser o hash do tar. Deve ser o hash de um manifesto determinístico de conteúdo:

- ordenação `LC_ALL=C`;
- path relativo com `/`;
- modo Git (`100644`, `100755`);
- SHA-256 do conteúdo do blob com LF normalizado;
- sem mtime, owner, group, xattrs ou ordem de filesystem.

Prova de conceito do manifesto:

```bash
python3 - <<'PY'
import hashlib, subprocess
repo='.'
tag='v1-estavel'
paths=['core','methodology','schemas','guards']
raw=subprocess.check_output(['git','ls-tree','-r','-z','--full-tree',tag,'--',*paths], cwd=repo)
entries=[]
for rec in raw.rstrip(b'\0').split(b'\0'):
    meta, path_b = rec.split(b'\t', 1)
    mode, typ, oid = meta.decode().split()
    path=path_b.decode('utf-8')
    data=subprocess.check_output(['git','cat-file','blob',oid], cwd=repo)
    normalized=data.replace(b'\r\n', b'\n')
    entries.append((path, f'{mode} {hashlib.sha256(normalized).hexdigest()} {path}'))
entries.sort(key=lambda item: item[0].encode('utf-8'))
manifest=''.join(line+'\n' for _, line in entries).encode('utf-8')
print('count', len(entries))
print('protocol_sha256', hashlib.sha256(manifest).hexdigest())
for _, line in entries[:8]:
    print(line)
PY
```

Saída:

```text
count 137
protocol_sha256 8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1
100644 e334f7693c2047a71dd8437368e4310cc623a565927c75258ba195831f5c9400 core/arvores-spec.md
100644 e544edaa431945a8d24ef31b8d763f46977281d69b9dbbbc4d31e68616e86b1e core/cadence-d.md
100644 ce652a240cf92941be95448e059c4b352c7fdff8248b9865a5c42306368225b4 core/command-spec.md
100644 7d7180b3a6c215561ecfac2e279b3dc7742889fe50c51f154a05cf953da5cedc core/dispatch-spec.md
100644 d19fdf12f974071a4a0c53dd8300d39631eb4360eb44c555aa45c47569531871 core/dual-run-spec.md
100644 d7fb6aa626f0eb0306e2a21af09b2f909bc83ce3d3584817ba7aaee76d2f7471 core/esteira-pre-transicao.md
100644 d213938c0d1c59fe458e6c01c4ac5c4926de832ffd9146f061879e8687e5c50e core/exuvia-fitness-criteria.md
100644 4274181e0306c2c1f7b51129e84de99ef06e885c5d083b50f44ad708857d96e0 core/freeze-gate-spec.md
```

Comando exato recomendado para o instalador:

```bash
PROTO=/Users/macbookpro/Projetos/usehbn
PROJECT=/Users/macbookpro/Projetos/Credenciamento
TAG=v1-estavel
TMP="$(mktemp -d)"
git -C "$PROTO" archive --format=tar "$TAG" -- core methodology schemas guards | tar -x -C "$TMP"
```

Depois disso, o instalador gera `USEHBN-HEADER.txt`, `VERSION`, `PROTOCOL_MANIFEST.sha256` e `PROTOCOL_SHA256.txt` dentro do `TMP`, verifica tudo, e só então troca `$PROJECT/.usehbn-snapshot` em etapa humano-gated. Não gerar snapshot a partir do branch atual nem por `cp`.

## 3. `assert-snapshot-integrity.sh`

Desenho viável: sim, mas deve ser baseado em manifesto, não em "sha recursivo" ad hoc.

Recomendação:

1. `PROTOCOL_MANIFEST.sha256`: linhas `mode sha256 path`, ordenadas por bytes (`LC_ALL=C`), paths relativos ao snapshot.
2. `PROTOCOL_SHA256.txt`: SHA-256 do manifesto inteiro e metadados mínimos (`tag`, `commit`, `generated_at`, `surface=core,methodology,schemas,guards`).
3. `USEHBN-HEADER.txt`: texto humano forte, mas não fonte de verdade.
4. Guard local `scripts/hbn-guards/assert-snapshot-integrity.sh`, fora do snapshot, rodando antes dos guards importados.

Por que guard local, não só dentro do snapshot: se o guard vive apenas em `.usehbn-snapshot/guards/`, uma edição maliciosa ou acidental do snapshot pode alterar o próprio guard no working tree antes do pre-commit. A trava prática é um guard versionado no projeto que falha se houver qualquer diff staged em `.usehbn-snapshot/` fora do modo de instalação/upgrade.

Checks mínimos:

- `git rev-parse --show-toplevel` deve ser `/Users/macbookpro/Projetos/Credenciamento`, nunca `/Users/macbookpro/Projetos/usehbn`.
- `.usehbn-snapshot/.git` não pode existir.
- nenhum symlink dentro do snapshot (`find .usehbn-snapshot -type l` falha).
- todo arquivo do manifesto existe no índice ou no disco conforme modo de execução.
- nenhum arquivo extra existe em `.usehbn-snapshot/` fora dos metadados permitidos.
- modos Git batem (`100644`/`100755`); `120000` bloqueia.
- `git diff --cached --name-only -- .usehbn-snapshot` deve estar vazio no modo normal.
- em modo CI, validar o range por `HBN_DIFF_BASE`.

Edge cases:

- Bootstrap inicial: o snapshot ainda não está em `HEAD`; precisa de modo `--install` invocado por script humano-gated. Fora disso, fail-closed.
- Upgrade de snapshot: só por modo explícito `--upgrade`, com `OLD_PROTOCOL_SHA256` e `NEW_PROTOCOL_SHA256` registrados no readback/hearback.
- Staged blob: em pre-commit, a checagem deve ler o conteúdo staged (`git show ":.usehbn-snapshot/<path>"`) quando existir, não apenas a working tree. Caso contrário, o usuário pode staged uma versão e restaurar outra no disco.
- CRLF: se o manifesto normaliza LF, o verificador deve normalizar do mesmo jeito antes do SHA. Melhor ainda: instalar por `git archive`, que emite blobs do Git sem conversão de working tree.
- Permissão read-only (`chmod -R -w`) é camada de atrito, não segurança. Git consegue substituir arquivos; o guard é a trava real.

## 4. Runner project-mode

Evidência do runner atual do protocolo:

- `guards/hbn-guards-runner.sh:58-66` exige que `RUNNER_ROOT` seja igual à raiz ativa.
- `guards/hbn-guards-runner.sh:83-116` lista todos os guards, incluindo internos ao genoma.
- `guards/hbn-guards-runner.sh:31-33` roda `assert-baton-token.sh`, `assert-exception-traceable.sh` e `assert-trailers-contiguous.sh` no modo commit-msg.

Comando:

```bash
rg -n "assert-(orq-entrada|orq-entrada-ref|dispatch-integrity|registry-line|pointer-honest|arvore-label|auditor-id|audit-diversity|quorum-selagem|parallel-id)|validate-dispatch|freeze-gate|assert-baton-token" guards/hbn-guards-runner.sh guards/hook-shims/commit-msg
```

Saída:

```text
guards/hook-shims/commit-msg:35:for g in assert-baton-token.sh assert-exception-traceable.sh; do
guards/hbn-guards-runner.sh:31:        "assert-baton-token.sh"
guards/hbn-guards-runner.sh:94:    "assert-orq-entrada.sh"
guards/hbn-guards-runner.sh:95:    "validate-dispatch.sh"
guards/hbn-guards-runner.sh:96:    "assert-dispatch-integrity.sh"
guards/hbn-guards-runner.sh:97:    "assert-orq-entrada-ref.sh"
guards/hbn-guards-runner.sh:99:    "assert-registry-line.sh"
guards/hbn-guards-runner.sh:100:    "assert-arvore-label.sh"
guards/hbn-guards-runner.sh:101:    "assert-auditor-id.sh"
guards/hbn-guards-runner.sh:102:    "assert-audit-diversity.sh"
guards/hbn-guards-runner.sh:103:    "assert-quorum-selagem.sh"
guards/hbn-guards-runner.sh:104:    "assert-parallel-id.sh"
guards/hbn-guards-runner.sh:105:    "assert-pointer-honest.sh"
```

Trade-offs:

**(a) Runner novo no snapshot só com subset**

- Prós: superfície clara para consumidores.
- Contras: não existe em `v1-estavel`; colocar um arquivo novo dentro do snapshot pós-archive viola a ideia de snapshot da tree do tag, a menos que esse arquivo seja metadado de instalação fora do manifesto. Além disso, um runner dentro de `.usehbn-snapshot/guards` chamando guards que sourceiam `guards/lib/common.sh` continua exigindo `.hbn/active-version` do projeto.
- Veredito: bom desenho futuro, ruim para executar "como está" a partir do tag selado.

**(b) Runner do protocolo com flag `--project-mode`**

- Prós: melhor solução de longo prazo; uma base de código, subset declarado no protocolo, sem drift entre projetos.
- Contras: a flag não existe em `v1-estavel`; exigiria evolução do protocolo e novo tag. Também precisa separar `HBN_PROJECT_ROOT` de `HBN_PROTOCOL_ROOT`.
- Veredito: recomendar como próxima evolução do protocolo, não como pré-requisito da ponte atual.

**(c) Shims em `scripts/hbn-guards/` apontando para `.usehbn-snapshot/guards/`**

- Prós: implementável agora no projeto; preserva um chokepoint local; permite rodar `assert-snapshot-integrity` antes de invocar guards do snapshot.
- Contras: shim fino não consegue trocar `source "${SCRIPT_DIR}/lib/common.sh"` dentro dos guards do snapshot. Ou o projeto ganha `.hbn/active-version` com `.`, ou o protocolo precisa de `common.sh` project-mode. Também é preciso pré-higiene para `assert-knowledge-index`.
- Veredito: melhor opção prática para esta transição, com ajuste: runner local do projeto enumera subset e chama guards do snapshot individualmente, depois de `assert-snapshot-integrity`; não usar o runner completo do protocolo.

Recomendação operacional:

1. Manter `scripts/hbn-guards/hbn-guards-runner.sh` no projeto como entrypoint.
2. Adicionar `scripts/hbn-guards/assert-snapshot-integrity.sh` local.
3. Adicionar compatibilidade `.hbn/active-version` = `.` no projeto, ou adaptar `common.sh` do protocolo em versão futura para fallback project-mode.
4. Rodar inicialmente subset mínimo: `assert-canonical-root`, `forbid-tmp-worktree`, `forbid-env-files`, `forbid-legacy-paths`, `assert-scope-lock`, `assert-hearback-integrity`.
5. Promover `assert-knowledge-index` após corrigir os 7 itens ausentes do INDEX.

## 5. Tombstone e limpeza de refs `usehbn/`

O comando literal pedido falha em `zsh` se `--include=*.md` não for protegido por aspas ou `noglob`.

Comando literal:

```bash
grep -rn 'usehbn/' Credenciamento --include=*.md --include=*.sh --include=*.txt | wc -l
```

Saída no ambiente atual:

```text
zsh:1: no matches found: --include=*.md
0
```

Comando equivalente correto em `zsh`:

```bash
noglob grep -rn 'usehbn/' Credenciamento --include=*.md --include=*.sh --include=*.txt | wc -l
```

Saída:

```text
649
```

Outras métricas:

```bash
noglob grep -rn 'usehbn/' Credenciamento --include=*.md --include=*.sh --include=*.txt | grep -v '^Credenciamento/usehbn/' | wc -l
noglob grep -rl 'usehbn/' Credenciamento --include=*.md --include=*.sh --include=*.txt | wc -l
git --no-optional-locks -C /Users/macbookpro/Projetos/Credenciamento ls-files usehbn | wc -l
find /Users/macbookpro/Projetos/Credenciamento/usehbn -type f -name .DS_Store -print
```

Saídas:

```text
402
152
108
/Users/macbookpro/Projetos/Credenciamento/usehbn/study-plans/.DS_Store
/Users/macbookpro/Projetos/Credenciamento/usehbn/.DS_Store
```

Interpretação:

- Existem 649 ocorrências textuais de `usehbn/` em `.md/.sh/.txt`.
- Mesmo excluindo o próprio espelho `Credenciamento/usehbn/`, ainda há 402 ocorrências.
- O espelho tem 108 arquivos versionados, 110 arquivos físicos por causa de `.DS_Store` ignorados.
- Sed global cego é arriscado: parte das referências é histórica/auditoria; parte é operacional e precisa mudar.

Refs operacionais observadas:

- `Credenciamento/AGENTS.md:123` ainda manda ler `usehbn/docs/PHAGOCYTOSIS-VBA-PATTERNS.md`.
- `.hbn/knowledge/0008-importador-v2-arquitetura.md:104` aponta para `usehbn/docs/INTEGRATION-VBA-IMPORTER.md`.
- `.hbn/knowledge/0005-protocolo-markers-v2.md:187,200-201,212,233,239,249` aponta para `usehbn/methodology`, `usehbn/modules` e `usehbn/audits`.
- `.hbn/knowledge/0007-acesso-controlado-via-cla.md:170` aponta para `../../../usehbn/docs/...`.
- `.hbn/knowledge/0020-explore-diff-cosmetico-suspeito.md:53` aponta para `usehbn/docs/PHAGOCYTOSIS-VBA-PATTERNS.md`.

Limpeza recomendada:

- Automatizável: gerar relatório de referências e patch candidato para `AGENTS.md`, `scripts/hbn-guards/README.md` e `.hbn/knowledge/*.md`.
- Humano-gated: aceitar ou ajustar cada substituição operacional.
- Não automatizar sed em `auditoria/` histórica sem revisão; ali `usehbn/` pode ser referência arqueológica legítima.
- Tombstone deve ser agressivo: manter `usehbn/README.md` ou `usehbn/TOMBSTONE.md` curto, sem árvore antiga viva. Se a pasta `usehbn/` permanecer com subpastas, a confusão continua.

## 6. D4: renomear `.hbn/` do projeto para `.hbn-local/`

Comandos:

```bash
noglob grep -rn '\.hbn/' Credenciamento --include=*.md --include=*.sh --include=*.txt | wc -l
noglob grep -rl '\.hbn/' Credenciamento --include=*.md --include=*.sh --include=*.txt | wc -l
find /Users/macbookpro/Projetos/Credenciamento/.hbn -type f | wc -l
git --no-optional-locks -C /Users/macbookpro/Projetos/Credenciamento ls-files .hbn | wc -l
```

Saídas:

```text
1597
309
556
553
```

Refs críticas:

- `AGENTS.md:42-65` define contratos executáveis em `.hbn/`.
- `AGENTS.md:100-123` manda ler `.hbn/relay`, `.hbn/knowledge`, `.hbn/schemas`.
- `scripts/hbn-guards/validate-readback.sh:18,32-35` hard-code `.hbn/schemas` e `.hbn/readbacks`.
- `scripts/hbn-guards/forbid-legacy-paths.sh:21-24` hard-code `.hbn/forbidden-paths.txt`.
- `scripts/hbn-guards/assert-scope-lock.sh:28,114-118,191` hard-code `.hbn/readbacks`, `.hbn/hearbacks`, `.hbn/bypasses`, `.hbn/messages`, `.hbn/relay/INDEX.md`.
- `scripts/hbn-guards/lib/common.sh:50` hard-code `.hbn/canonical-root`.

Veredito sobre D4: prático no sentido técnico, mas arriscado demais nesta onda. Renomear `.hbn/` agora toca centenas de arquivos, scripts e contratos mentais do projeto. O ganho contra confusão é menor que o risco de quebrar governança operacional. Melhor solução nesta transição: manter `.hbn/` como estado local do projeto, adicionar router obrigatório no topo do `AGENTS.md` e usar `.usehbn-snapshot/` com header forte para o protocolo.

D4 pode virar P3 dedicado, depois da ponte estável, com script de migração, testes e revisão humana.

## 7. Gotchas e melhorias concretas

Gotchas de implementação:

1. `zsh` quebra comandos `grep --include=*.md` sem aspas ou `noglob`; o prompt de implementação deve usar `noglob` ou aspas.
2. O protocolo v1-estavel é version-aware; o projeto não tem `.hbn/active-version`. Sem isso, vários guards falham antes de validar qualquer coisa.
3. O runner completo do protocolo não serve no projeto porque exige `RUNNER_ROOT == ACTIVE_ROOT` (`guards/hbn-guards-runner.sh:58-66`) e executa guards internos ao genoma (`guards/hbn-guards-runner.sh:94-105`).
4. `assert-knowledge-index` precisa de pré-higiene: o projeto tem 7 knowledge files não citados no INDEX.
5. Hash de tar é bom para diagnóstico, mas frágil como contrato humano; manifest de conteúdo é melhor.
6. `chmod -R -w .usehbn-snapshot` não é barreira de segurança suficiente; Git e editores podem substituir arquivos. A proteção real é guard no pre-commit/CI.
7. Guard de integridade precisa ler blob staged, não só disco.
8. O espelho `usehbn/` tem `.DS_Store` físicos; scripts de tombstone devem operar por `git ls-files` para versionados e tratar lixo ignorado separadamente.
9. O canal inbox é seguro, mas o projeto não deve escrever no repo canônico automaticamente. O contrato do protocolo diz: `inbox/README.md:13-17` projetos consumidores não editam o canônico; `inbox/README.md:61-63` escrita de IA de projeto no canônico é só no inbox.
10. O firewall local confirma que escrita safe_track é humano-aplicada: `.hbn/knowledge/0022-firewall-workflow-fast-track.md:17-30`.

Melhorias concretas ao desenho:

1. Adicionar `PROJECT_MODE.md` ou `CONSUMER-PROFILE.md` no snapshot, gerado pelo instalador, declarando subset ativo e guards excluídos.
2. Fazer `assert-snapshot-integrity` local e primeiro no runner.
3. Adicionar `.hbn/active-version` = `.` no projeto como compatibilidade explícita, com comentário no commit/readback.
4. Promover `assert-knowledge-index` em duas fases: warning primeiro, bloqueante depois da higiene.
5. Criar `scripts/hbn-snapshot/install-snapshot.sh` idempotente, com `--dry-run`, `--verify-only`, `--install` e `--upgrade`.
6. Gerar `PROTOCOL_MANIFEST.sha256` com `mode sha256 path`; `PROTOCOL_SHA256.txt` deve hash do manifesto, não do diretório.
7. Guardar no readback da transição: tag, commit, protocol_sha256, contagem de arquivos, lista de guards ativos e lista de guards excluídos.
8. No `AGENTS.md`, inserir o router antes de "Identidade do projeto", porque hoje a primeira orientação operacional vem só depois e ainda há ref legado em `AGENTS.md:123`.
9. No tombstone, usar linguagem de bloqueio ("não leia, não edite, não use como protocolo") e apontar exclusivamente para `.usehbn-snapshot/` e `inbox/credenciamento/`.
10. Não executar D4 junto com a ponte.

## VEREDITO DE VIABILIDADE

IMPLEMENTAVEL-COM-AJUSTES.

Ajustes obrigatórios antes do prompt de implementação:

1. Não afirmar que os guards do subset rodam "como estão"; eles precisam de compatibilidade project-mode (`.hbn/active-version` = `.` ou fallback no `common.sh`) e runner local.
2. Não usar o runner completo do protocolo no projeto.
3. Gerar snapshot por `git archive v1-estavel`, com manifesto determinístico; não copiar working tree.
4. Implementar `assert-snapshot-integrity` local, lendo staged blobs e bloqueando qualquer diff em `.usehbn-snapshot/` no modo normal.
5. Corrigir ou fasear `assert-knowledge-index`.
6. Tombstone e limpeza de refs devem ser humano-gated; script pode preparar patch e relatório, não aplicar sed global cego.
7. Adiar D4 (`.hbn/` -> `.hbn-local/`) para onda futura dedicada.

## SEQUENCIA DE IMPLEMENTACAO recomendada

P2-A — Tooling e dry-run do snapshot (script)

- Criar/usar script instalador com `--dry-run` que lê `usehbn@v1-estavel`, exporta via `git archive` para temp, gera manifesto, calcula `PROTOCOL_SHA256`, lista 137 arquivos e não toca o projeto.
- Produzir relatório de subset de guards: ativos, excluídos e pendências.
- Humano valida tag, commit e hash.

P2-B — Instalação da membrana no projeto (script + hearback humano)

- Criar `.usehbn-snapshot/` a partir do temp verificado.
- Adicionar `USEHBN-HEADER.txt`, `VERSION`, `PROTOCOL_MANIFEST.sha256`, `PROTOCOL_SHA256.txt`.
- Adicionar `scripts/hbn-guards/assert-snapshot-integrity.sh` local.
- Adicionar compatibilidade `.hbn/active-version` = `.` se esta for a escolha.
- Rodar `assert-snapshot-integrity --install` e runner local em modo informativo.

P2-C — Runner project-mode e subset bloqueante (script + pré-higiene)

- Atualizar o runner local do projeto para rodar: snapshot-integrity, canonical-root, tmp-worktree, env-files, legacy-paths, scope-lock, hearback-integrity.
- Deixar `assert-knowledge-index` como warning até corrigir os 7 itens ausentes do INDEX; depois promover para bloqueante.
- Não incluir guards internos do genoma: orq-entrada/ref, validate-dispatch, dispatch-integrity, registry-line, pointer-honest, arvore-label, auditor-id, audit-diversity, quorum-selagem, parallel-id, freeze-gate, baton-token.

P2-D — Router, tombstone e limpeza controlada (humano-gated)

- Inserir router obrigatório no topo de `AGENTS.md`.
- Substituir o espelho `usehbn/` por tombstone mínimo.
- Rodar relatório de referências `usehbn/`; aplicar correções operacionais em `AGENTS.md`, `.hbn/knowledge` e scripts com revisão humana.
- Preservar referências históricas em auditorias quando forem arqueologia real.
- Registrar no readback final: refs restantes justificadas, hash do snapshot, subset ativo e D4 adiado.

Não recomendo D4 nesta sequência. A renomeação de `.hbn/` deve ser P3 próprio, com migração e rollback dedicados.
