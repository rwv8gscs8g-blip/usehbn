---
titulo: "Proposta hbn-exuvia — plano v2 antes da 1a muda"
tipo: proposal
status: proposed
temperatura: quente
id-global: 20260614-030748-codex-exuvia-plano-v2
path: .hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md
data: 2026-06-14
created_at: "2026-06-14T03:07:48-03:00"
autoria: "codex (implementador da emenda; desenho/orquestracao: claude-opus-4-8)"
track: safe_track
escopo: "design-only; emenda de plano; nenhuma muda executada"
supersedes: .hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md
relacionado:
  - .hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md
  - /Users/macbookpro/Projetos/EXUVIA-requisitos-plano-v2.md
  - /Users/macbookpro/Projetos/RADAR-0001-consolidacao-fronteira-orquestracao.md
  - methodology/adr/ADR-004-semver-protocolo.md
  - methodology/adr/ADR-009-constituicao-p1-p13.md
  - methodology/adr/ADR-010-autoevolve-cycle.md
  - methodology/adr/ADR-012-naming-versoes-ondas.md
  - methodology/adr/ADR-013-arquiteto-autonomo-classes-a-b.md
  - .hbn/knowledge/0022-firewall-workflow-fast-track.md
  - .hbn/relay/STATE.md
---

# Proposta hbn-exuvia — plano v2 antes da 1a muda

Esta onda atualiza o plano Exuvia para a v2. Ela nao congela, nao renasce,
nao move estrutura, nao altera guards e nao toca `src`/dominio. O corte real
fica para M2, depois de cross-audit Gemini e ratificacao humana.

Convenção usada: **supersedencia via REGISTRY**. A proposta 0010 permanece
intocada no disco; sua linha no `REGISTRY.md` passa a apontar
`superseded_by=20260614-030748-codex-exuvia-plano-v2`, e este documento e a
nova proposta viva.

## Truth Barrier

- O plano 0010 declara explicitamente escopo de PLANO, sem congelar,
  renascer, mover estrutura, alterar guard ou mudar dominio
  (`.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md:23`).
- A fase de congelamento do 0010 ja definia a casca como forma anterior
  imutavel, mas ainda sem a ancoragem anti-GC exigida depois pelo parecer
  (`.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md:109`).
- O 0010 admitia ponteiro temporario na raiz para o ledger, ponto substituido
  nesta v2 por atualizacao direta de guard em M2, sem symlink
  (`.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md:292`).
- O 0010 inventariava untracked historicos, mas deixava os handoffs fora do
  commit vivo por B1; a v2 exige `git add -f` deles no congelamento da casca
  (`.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md:269`).
- O parecer Gemini aprovou com reserva: 0 bloqueador, 3 fortes e 1 marginal
  (`.hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md:20`).
- F-01 exige tag Git formal apontando para o commit congelado, para impedir
  perda por `git gc --prune`
  (`.hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md:44`).
- F-02 exige atualizar `guards/assert-registry-line.sh` diretamente para
  `.hbn/ledger/REGISTRY.md`, sem symlink na raiz
  (`.hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md:49`).
- F-03 exige `git add -f` dos untracked preservados no commit de congelamento
  (`.hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md:54`).
- M-01 recomenda publicar `HBN PROTOCOL DEP CHANGE` apos a muda
  (`.hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md:63`).
- Os requisitos consolidados tornam obrigatorios: tag `hbn-exuvia/protocol-0.3.x`,
  guard direto, `git add -f`, sinal de dependencia, painel, trilha de
  aprendizagem, ponte bidirecional, retencao fria, politica do arquiteto,
  nome oficial e inventario modular
  (`/Users/macbookpro/Projetos/EXUVIA-requisitos-plano-v2.md:7`,
  `/Users/macbookpro/Projetos/EXUVIA-requisitos-plano-v2.md:17`).
- O RADAR fixa o MVP da Exuvia como tag Git imutavel + manifesto + ponte
  bidirecional; fork real no GitHub so quando publicar
  (`/Users/macbookpro/Projetos/RADAR-0001-consolidacao-fronteira-orquestracao.md:32`,
  `/Users/macbookpro/Projetos/RADAR-0001-consolidacao-fronteira-orquestracao.md:60`).
- O RADAR tambem fixa A2A como interop futura, bootstrap de registro para
  projetos novos e a parte dura persistente: P1-P13 + isolamento,
  cross-family, gate humano, auditabilidade e reversibilidade
  (`/Users/macbookpro/Projetos/RADAR-0001-consolidacao-fronteira-orquestracao.md:55`,
  `/Users/macbookpro/Projetos/RADAR-0001-consolidacao-fronteira-orquestracao.md:61`).
- ADR-004 define `0.3.x -> 1.0.0` como MAJOR quando `protocol_version` vira
  required e define o sinal de dependencia para MAJOR/MINOR
  (`methodology/adr/ADR-004-semver-protocolo.md:93`,
  `methodology/adr/ADR-004-semver-protocolo.md:120`).
- ADR-012 exige um nome canonico por versao e onda; nomes legados nao viram
  chave nova (`methodology/adr/ADR-012-naming-versoes-ondas.md:31`,
  `methodology/adr/ADR-012-naming-versoes-ondas.md:44`).
- ADR-009 torna P1-P13 a constituicao canônica e exige processo forte para
  mudanca constitucional (`methodology/adr/ADR-009-constituicao-p1-p13.md:71`,
  `methodology/adr/ADR-009-constituicao-p1-p13.md:98`).
- ADR-010 grava trilha de auditoria em JSONL e mantem scaffold distribuido
  sem trocar o orquestrador; a trilha fria da v2 se encaixa nesse desenho
  (`methodology/adr/ADR-010-autoevolve-cycle.md:73`,
  `methodology/adr/ADR-010-autoevolve-cycle.md:87`).
- ADR-013 decompoe o arquiteto autonomo, define classes A/B e impõe operar
  no canonico com firewall preservado
  (`methodology/adr/ADR-013-arquiteto-autonomo-classes-a-b.md:35`,
  `methodology/adr/ADR-013-arquiteto-autonomo-classes-a-b.md:48`,
  `methodology/adr/ADR-013-arquiteto-autonomo-classes-a-b.md:85`).
- O STATE vigente mantem F-01 vermelho/proposed e a proxima acao ainda era
  cross-audit do plano; esta v2 muda o alvo para plano v2 sem baixar F-01
  (`.hbn/relay/STATE.md:14`, `.hbn/relay/STATE.md:16`).
- O firewall 0022 segue vigente: escrita de dominio, produto, `src`,
  `examples` e `inbox` e safe_track humano-aplicada; esta onda so toca
  artefatos do protocolo (`.hbn/knowledge/0022-firewall-workflow-fast-track.md:21`).
- O REGISTRY e append-only e usa `superseded_by` para declarar artefato
  ultrapassado sem apagar historia (`REGISTRY.md:13`).
- O guard G-REG atual le `REGISTRY.md` por `git show :REGISTRY.md`; por isso
  M2 deve trocar o caminho do guard diretamente, nao usar symlink
  (`guards/assert-registry-line.sh:50`, `guards/assert-registry-line.sh:54`).

## Decisão de nome

O nome oficial do mecanismo e **hbn-exuvia**. E a forma adjetival: a exuvia do
HBN. Em M2, este nome deve virar acao documentada:

- criar ou emendar uma spec/ADR com o nome oficial `hbn-exuvia`;
- registrar a spec/ADR no REGISTRY no mesmo commit;
- usar `hbn-exuvia` nos manifestos e tags futuras;
- manter `Exuvia` como nome humano do protocolo, nao como chave divergente.

Versoes canônicas:

- forma antiga: `0.3.x`;
- forma nova proposta: `1.0.0`;
- transicao: `0.3.x -> 1.0.0`;
- tag obrigatoria da casca: `hbn-exuvia/protocol-0.3.x`;
- branch arquival opcional: `archive/hbn-exuvia/protocol-0.3.x`;
- fork real no GitHub: somente quando houver publicacao remota.

## Fases v2

1. **PLANO (esta onda M1)**: produzir esta proposta v2, readback 0011,
   handoff, STATE e REGISTRY. Nao mover estrutura.
2. **CROSS-AUDIT**: Gemini audita o plano v2. Se houver bloqueador/forte, a
   v2 e emendada antes de qualquer corte.
3. **RATIFICACAO HUMANA**: Mauricio confirma item a item e autoriza M2.
4. **CONGELAMENTO (M2)**: criar commit da casca 0.3.x, incluindo tracked tree
   e untracked preservados por `git add -f`; criar tag imutavel
   `hbn-exuvia/protocol-0.3.x` apontando para esse commit; opcionalmente criar
   branch arquival.
5. **RENASCIMENTO (M2)**: nascer forma 1.0.0 com carry-forward ratificado,
   manifesto, ledger novo e estrutura modular. Se o ledger sair da raiz,
   atualizar `guards/assert-registry-line.sh` no mesmo corte para ler o novo
   caminho diretamente.
6. **PONTE (M2)**: gravar manifesto nova->velha e ponte bidirecional:
   o ultimo documento da casca 0.3.x aponta para o primeiro documento da forma
   1.0.0, e esse primeiro documento cita o ultimo documento da casca.
7. **VERIFICACAO (M2)**: suite verde, simulacoes G-SCO/G-REG/G-PAR/G-SLF/G-RLT,
   rollback declarado, sinal de dependencia publicado.

## Correções incorporadas do parecer Gemini

### F-01: anti-GC obrigatório

No congelamento, o commit da casca nao pode ficar so como SHA solto em
manifesto. M2 deve executar:

```text
git tag hbn-exuvia/protocol-0.3.x <commit-da-casca>
```

A tag e a ancora de retencao minima. Uma branch arquival pode existir, mas nao
substitui a tag. O manifesto registra `frozen_shell.tag`,
`frozen_shell.commit_sha` e, se houver, `frozen_shell.archive_branch`.

### F-02: ledger sem symlink

Se `REGISTRY.md` migrar para `.hbn/ledger/REGISTRY.md`, M2 deve alterar
`guards/assert-registry-line.sh` diretamente para:

```text
REGISTRY=".hbn/ledger/REGISTRY.md"
```

Nao criar symlink `REGISTRY.md -> .hbn/ledger/REGISTRY.md`. O guard atual usa
`git show :REGISTRY.md`; em symlink, Git retorna o caminho do alvo, nao a tabela.

### F-03: untracked preservado entra no commit da casca

O congelamento deve fazer `git add -f` dos untracked preservados, no minimo:

- `.hbn/messages/20260612-122102-fable5-handoff-orquestracao-pos-onda-0006.md`;
- `.hbn/messages/20260613-112502-fable5-handoff-orquestracao-pos-adocao-onda-0006.md`;
- `.hbn/results/20260613-234731-gemini-3-5-cross-ia-onda-0009-confirma-emenda.md`, se ainda estiver fora da casca no clone executor;
- `.hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md`;
- qualquer outro parecer/handoff historico listado por `git status --short`
  no momento de M2.

Arquivo untracked preservado nao basta ser citado no manifesto; precisa entrar
no commit da casca ou ser explicitamente marcado como nao-parte por decisao
humana.

### M-01: sinal de dependencia

Apos a muda confirmada, publicar:

```text
HBN PROTOCOL DEP CHANGE
```

O payload deve citar `0.3.x -> 1.0.0`, `protocol_version required`, tag
`hbn-exuvia/protocol-0.3.x`, manifesto da muda e roteiro de upgrade
multi-projeto. O emoji do sinal (`⛓️`) pode aparecer na interface humana; o
texto acima e a chave registravel.

## Gate humano incorporado

### Painel comum

M2 deve criar `.hbn/relay/PAINEL.md` como denominador comum para toda IA. O
painel nao substitui STATE nem REGISTRY; ele aponta para eles e torna visivel:

- status dos guards relevantes;
- excecoes e sinais abertos, mantendo `F-01/PROPOSED`;
- token/fingerprint publico vigente;
- ponteiros para readback, handoff e plano ativo;
- indice da trilha de aprendizagem fria.

Toda IA que retomar o protocolo deve ler o painel junto com STATE/readback.

### Trilha de aprendizagem

Cada janela de IA deve depositar um log frio em:

```text
logs/<timestamp>-<agente>-log-janela.md
```

O log entra no painel como indice, nao como read-list quente. Retencao padrao:
30 dias, configuravel por politica. A limpeza nao acontece no fechamento da
janela; acontece em passagem de manutencao do protocolo, com registro no
REGISTRY ou no mecanismo que a forma 1.0.0 ratificar.

### Loop do arquiteto autonomo

O loop do arquiteto autonomo passa a ter politica configuravel por usuario:

- `delete_each_round`: apaga material operacional da rodada apos consolidar o
  resultado auditavel;
- `glacier_each_round`: envia o material ao glacier frio.

Material retido vira guia de estudo do comportamento das IAs e insumo futuro
para Memory/Dream. Nada disso autoaplica regra: consolidacoes viram propostas
auditadas, coerentes com ADR-010 e ADR-013.

### Ponte de controle bidirecional

A cadeia da muda deve ter dois ponteiros:

- ultimo documento da casca 0.3.x: `next_form_first_doc` aponta para o primeiro
  documento vivo da 1.0.0;
- primeiro documento vivo da 1.0.0: `previous_shell_last_doc` aponta para o
  ultimo documento da casca 0.3.x.

O primeiro documento da 1.0.0 deve ser o manifesto ou o documento de bootstrap
ratificado em M2. A ponte impede que a casca vire arquivo morto sem retorno.

## Fronteira RADAR incorporada

O plano v2 adota as conclusoes de RADAR-0001:

- Exuvia-como-fork MVP e tag Git imutavel + manifesto + ponte; branch arquival
  e opcional; fork real no GitHub so quando publicar.
- Interop futura entre arvores/forks sera A2A. Nao inventar transporte.
- Projeto novo nasce com obrigacao de registrar no livro-razao e com documento
  de hierarquia do protocolo.
- A parte dura que persiste por exuvias e P1-P13 + invariantes: isolamento de
  janelas, auditoria cross-family, gate humano, auditabilidade e reversibilidade.
- Frameworks, linguagem-base, transporte e runtime sao fagocitaveis; principios
  e rastro auditavel nao sao.

## Inventário atual de módulos

Observado nesta janela em `/Users/macbookpro/Projetos/usehbn`:

| Modulo atual | Subpastas/arquivos atuais | Disposicao v2 |
|---|---|---|
| nucleo-protocolo | `core/`, `methodology/`, `schemas/`, `README.md`, `AGENTS.md` | carry-forward quente |
| guards | `guards/`, `guards/lib/`, `guards/tests/` | carry-forward; em M2 ajustar G-REG se ledger mover |
| runtime | `src/usehbn/`, `tests/`, `pyproject.toml`, `setup.cfg`, `setup.py` | carry-forward, sem tocar nesta M1 |
| relay-governanca | `.hbn/relay/`, `.hbn/readbacks/`, `.hbn/messages/`, `.hbn/results/`, `.hbn/hearbacks/`, `REGISTRY.md` | reorganizar em `governanca/` e `.hbn/ledger/` se ratificado |
| conhecimento | `.hbn/knowledge/`, `docs/`, `reports/`, `auditoria/` | quente/frio conforme manifesto |
| autoevolve-arquiteto | `.hbn/autoevolve/`, `.hbn/queue/`, `agents/` | carry-forward com politica de loop configuravel |
| conectores-modelos | `.hbn/connectors/`, `.hbn/models/`, `skills/` | carry-forward |
| inbox-fagocitose | `inbox/` | alvo de modulo `fagocitose/`, preservando firewall 0022 |
| logs-aprendizagem | `logs/` | frio, retencao 30 dias configuravel, indexado no painel |
| adaptadores-ia | `.claude/`, `.gemini/`, `.chatgpt/`, `.antigravity/` | frio/compatibilidade, nao parte dura |
| build-distribuicao | `build/`, `dist/`, `site/`, `get-hbn` | frio ou reconstruivel, conforme manifesto |
| legado-prompts-raiz | `PROMPT_*`, `20260610-*` | casca/glacier, nao read-list quente |
| hbn-exuvia | ainda nao existe como subpasta | nasce em M2 |
| radar | nao existe como subpasta dedicada; semente externa e o RADAR-0001 | nasce como modulo em M2 |

## Árvore-alvo proposta para 1.0.0

Esta arvore e proposta de forma, nao execucao:

```text
.hbn/
  ledger/
    REGISTRY.md
    MANIFEST-1.0.0.md
  relay/
    STATE.md
    PAINEL.md
  readbacks/
  hearbacks/
  messages/
  results/
  knowledge/
  models/
  connectors/

hbn-exuvia/
  protocol/
    SPEC.md
    ADR-hbn-exuvia.md
  shells/
    protocol-0.3.x/
      LAST-DOC.md
      MANIFEST.md
      untracked-inventory.md
      snapshot-ref.txt
  bridge/
    0.3.x-to-1.0.0.md

orquestracao/
  agents/
  relay/
  roles/
  start-rite/
  state-report/

fagocitose/
  inbox/
  decisions/
  adopted/
  rejected/

radar/
  CONVERGENCE-MATRIX.md
  cycles/
  reports/

governanca/
  principles/
  adr/
  schemas/
  guards/
  audit/

runtime/
  src/usehbn/
  tests/
  packaging/

docs/
logs/
glacier/
```

Regra de reconstrucao: a forma 1.0.0 so carrega como quente o que for
ratificado. O restante fica na casca `hbn-exuvia/protocol-0.3.x` ou no glacier
frio com ponteiro no manifesto.

## Manifesto mínimo v2

O manifesto de M2 deve conter, no minimo:

```yaml
manifest_version: 2
subject:
  kind: protocol
  name: usehbn
  transition_name: hbn-exuvia
  from_version: 0.3.x
  to_version: 1.0.0
  trigger: "MAJOR: protocol_version required"
frozen_shell:
  commit_sha: "<commit-da-casca>"
  tag: "hbn-exuvia/protocol-0.3.x"
  archive_branch: "archive/hbn-exuvia/protocol-0.3.x|null"
  frozen_at: "<ISO8601 local com offset>"
  immutable_policy: "tag required; shell append-only"
  untracked_added_with_git_add_f: []
bridge:
  old_last_doc: "hbn-exuvia/shells/protocol-0.3.x/LAST-DOC.md"
  new_first_doc: ".hbn/ledger/MANIFEST-1.0.0.md"
  bidirectional_required: true
new_form:
  protocol_version: 1.0.0
  ledger_path: ".hbn/ledger/REGISTRY.md"
  panel_path: ".hbn/relay/PAINEL.md"
  module_tree: "see hbn-exuvia bridge"
carry_forward: []
renamed: []
left_behind: []
open_debts:
  - id: "F-01"
    status: "PROPOSED_UNTIL_CROSS_AUDIT"
retention:
  learning_logs_days: 30
  configurable: true
  cleanup: "maintenance_pass"
autonomous_architect_loop:
  policy: "delete_each_round|glacier_each_round"
  retained_material_use: "Memory/Dream study guide; proposals only"
signals_after_cut:
  - "HBN PROTOCOL DEP CHANGE"
guards_transition:
  registry_guard_direct_path_update: true
  no_root_symlink_for_registry: true
  simulations_required: ["G-SCO", "G-REG", "G-PAR", "G-SLF", "G-RLT"]
interop_future:
  transport: "A2A"
  no_custom_transport: true
rollback:
  before_cut_sha: "<sha>"
  frozen_shell_tag: "hbn-exuvia/protocol-0.3.x"
  procedure: "git revert da muda ou checkout da ancora; tag da casca intacta"
ratification:
  cross_audits: []
  human_status: "pending"
```

## Checklist de M2

M2 so pode comecar apos cross-audit Gemini e ratificacao humana. A execucao deve:

1. Rodar pre-flight e confirmar main/HEAD.
2. Remover locks locais apenas com comandos zsh-safe.
3. Congelar casca com tracked tree + `git add -f` dos untracked preservados.
4. Criar tag `hbn-exuvia/protocol-0.3.x` apontando para o commit da casca.
5. Criar branch arquival opcional se o humano quiser navegabilidade extra.
6. Nascer forma 1.0.0 com arvore modular ratificada.
7. Mover ledger somente se G-REG for atualizado diretamente no mesmo corte.
8. Criar `.hbn/relay/PAINEL.md`.
9. Ativar trilha de aprendizagem fria e politica de retencao.
10. Criar spec/ADR do nome oficial `hbn-exuvia` e registrar no REGISTRY.
11. Criar manifesto com ponte bidirecional.
12. Manter `F-01/PROPOSED` ate baixa formal permitida por B2/G-HRB/G-REG.
13. Publicar `HBN PROTOCOL DEP CHANGE`.
14. Rodar suite + simulacoes G-SCO/G-REG/G-PAR/G-SLF/G-RLT.

## Cerimônia zsh-safe desta M1

Esta proposta nao executa commit. A cerimonia para o operador aplicar esta M1
deve ser:

```zsh
cd ~/Projetos/usehbn
rm -f .git/index.lock .git/refs/heads/main.lock
git reset
git add -f .hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md
git add -f .hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md
git add -f .hbn/readbacks/0011-emenda-plano-exuvia-v2.json
git add -f .hbn/messages/20260614-030748-codex-handoff-emenda-plano-exuvia-v2.md
git add -f .hbn/relay/STATE.md
git add -f REGISTRY.md
bash guards/tests/run-guard-tests.sh | tail -2
bash guards/assert-scope-lock.sh
bash guards/assert-registry-line.sh
bash guards/assert-parallel-id.sh
bash guards/assert-self-path.sh
bash guards/assert-report-fresh.sh
git diff --cached --check
git commit -m "docs: emenda plano hbn-exuvia v2" \
  -m "HBN-Readback: 0011" \
  -m "HBN-Token-FP: 34a7f2f9"
```

`git add ..` e `git add .` continuam proibidos.

## REGISTRY

Linhas desta M1: ver `REGISTRY.md`, secao "Onda 0011". A proposta 0010 e
supersedida por esta v2 via coluna `superseded_by`.
