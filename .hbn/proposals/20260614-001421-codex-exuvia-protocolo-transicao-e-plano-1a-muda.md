---
titulo: "Proposta Exúvia — protocolo de transição e plano da 1a muda"
tipo: proposal
status: proposed
temperatura: quente
id-global: 20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda
path: .hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md
data: 2026-06-14
autoria: "codex (implementador da onda prévia; desenho/orquestração: claude-opus-4-8)"
track: safe_track
escopo: "design-only; nenhuma muda executada"
relacionado:
  - /Users/macbookpro/Projetos/CONCEITO-exuvia-muda-do-protocolo-usehbn.md
  - methodology/adr/ADR-004-semver-protocolo.md
  - methodology/adr/ADR-012-naming-versoes-ondas.md
  - .hbn/relay/STATE.md
  - core/orchestrator-profile-spec.md
  - .hbn/knowledge/0022-firewall-workflow-fast-track.md
---

# Proposta Exúvia — protocolo de transição e plano da 1a muda

Esta onda é a etapa de PLANO. Ela não congela, não renasce, não move estrutura,
não altera guard e não muda código de domínio. O entregável é uma spec candidata
para a transição Exúvia e um plano executável, ainda sujeito a cross-audit e
ratificação humana.

## Truth Barrier

- O conceito validado define Exúvia como a casca deixada pela muda: guarda a
  forma exata anterior e permite crescer com rastro auditável
  (`/Users/macbookpro/Projetos/CONCEITO-exuvia-muda-do-protocolo-usehbn.md:7-18`).
- O gate humano já validou: aplica-se a protocolo e projetos em cadências
  distintas; gatilho só em versão MAJOR; cross-audit propõe carry-forward e o
  humano ratifica; multi-projeto fica para outra onda
  (`/Users/macbookpro/Projetos/CONCEITO-exuvia-muda-do-protocolo-usehbn.md:20-30`).
- A mecânica pré-proposta já pede congelar `vN`, renascer `vN+1`, criar manifesto
  e descer a casca mais antiga ao glacier quando houver duas acumuladas
  (`/Users/macbookpro/Projetos/CONCEITO-exuvia-muda-do-protocolo-usehbn.md:32-39`).
- ADR-004 define MAJOR como mudança constitucional, campo required novo ou
  promoção de `protocol_version` a required; o exemplo natural é
  `0.3.x -> 1.0.0` quando `protocol_version` virar required
  (`methodology/adr/ADR-004-semver-protocolo.md:89-95`).
- ADR-004 também estabelece o caminho de `protocol_version`: v0.3.0 opcional,
  v0.4.0+ warning, v1.0.0 required + bump MAJOR
  (`methodology/adr/ADR-004-semver-protocolo.md:125-131`).
- ADR-012 exige um nome canônico por versão e uma chave de onda `NNNN`; nomes
  legados viram descrição humana, não chave
  (`methodology/adr/ADR-012-naming-versoes-ondas.md:31-50`).
- O STATE atual ainda aponta a fase-2 herdada de B1/B2/B3, mantém F-01 em
  vermelho/proposed, registra suite stale `123/123`, e lista dívidas de REGISTRY,
  branch protection, readback/hearback e propostas glacier fora do repo
  (`.hbn/relay/STATE.md:14-34`).
- A doutrina 0.2.0 do orquestrador exige ler o disco, citar arquivo:linha, manter
  Truth Barrier e preservar o núcleo de "o que aconteceu, por quê, trade-off e
  próxima decisão" em todos os modos educativos
  (`core/orchestrator-profile-spec.md:18-30`,
  `core/orchestrator-profile-spec.md:76-90`).
- O firewall 0022 mantém workflows/produto como leitura/diagnóstico e escrita de
  domínio como safe_track humano-aplicada; esta proposta só toca metadados do
  protocolo (`.hbn/knowledge/0022-firewall-workflow-fast-track.md:21-31`).
- A onda 0007 declarou os três deadlocks: B1 handoffs históricos versus G-RLT,
  B2 G-REG versus G-HRB para hearback numerado, e B3 baixa formal de F-01
  (`.hbn/messages/20260613-125502-fable-5-handoff-onda-regularizacao-minima.md:26-36`).
- O readback 0007 congelou a decisão: B1/B2/B3 ficam para fase-2 planejada, sem
  improvisar guard (`.hbn/readbacks/0007-onda-regularizacao-minima.json:10-14`,
  `.hbn/readbacks/0007-onda-regularizacao-minima.json:42-45`,
  `.hbn/readbacks/0007-onda-regularizacao-minima.json:54`).
- O REGISTRY confirma que a linha de handoff é exigida pelo G-REG e que a
  formalização ADR-023 segue adiada por B2
  (`REGISTRY.md:332-339`, `REGISTRY.md:367-377`).
- P1, P6 e P10 são constitucionais: preservar antes de transformar, evolução
  reversível, e segurança/não-regressão acima de velocidade
  (`methodology/adr/ADR-009-constituicao-p1-p13.md:71-80`).

## Decisão de nome e versão

O humano usou "V2 -> V3" como linguagem informal de geração. Pela regra
canônica do protocolo, a primeira muda deve ser registrada como
`0.3.x -> 1.0.0`, porque o gatilho normativo é tornar `protocol_version`
required. "V3" pode aparecer só como descrição humana ("terceira forma do
molde"), nunca como chave de versão, nome de onda ou campo de STATE.

O nome desta transição proposta é:

- versão antiga: `0.3.x` (forma atual; `0.3.0` no código, bump `0.3.1` adiado);
- versão nova proposta: `1.0.0`;
- onda de design: `onda-0010` / "onda prévia Exúvia";
- protocolo de transição reutilizável: `Exúvia`.

## Parte A — Spec candidata do protocolo Exúvia

### A1. Gatilho

Exúvia só dispara em virada MAJOR. Para o protocolo useHBN, a primeira instância
natural é `0.3.x -> 1.0.0`, quando `protocol_version` deixa de ser opcional e
passa a ser required nos records governados.

Para projetos consumidores, o mesmo protocolo vale, mas cada projeto tem sua
própria cadência e seu próprio SemVer. A onda multi-projeto não é pré-condição
desta primeira muda do protocolo; ela continua uma onda separada.

### A2. Fases

1. **PLANO**: inventário da forma atual, proposta de carry-forward, desenho da
   forma nova, schema do manifesto, risco e rollback. Esta onda entrega apenas
   esta fase. Saída: proposta + readback + handoff + STATE. Depois vem
   cross-audit e ratificação humana.
2. **CONGELAMENTO**: a forma inteira anterior vira casca-exúvia imutável. A
   casca deve incluir o tree tracked, inventário dos untracked conhecidos e
   âncoras Git suficientes para reconstrução. Ela não é read-list quente.
3. **RENASCIMENTO**: a forma `1.0.0` nasce limpa, carregando somente o
   carry-forward ratificado. O layout novo pode mudar nomes, pastas e ledger,
   desde que o manifesto preserve o mapa.
4. **PONTE**: o manifesto liga a forma nova à casca anterior, lista o que foi
   carregado, renomeado, deixado, resolvido ou ainda pendente, e aponta para a
   cadeia de exúvias.
5. **VERIFICAÇÃO**: guards verdes na forma nova, com simulações explícitas para
   G-SCO, G-REG, G-PAR/G-NUM, G-SLF e G-RLT, além do runner completo.

### A3. Conteúdo da casca

A casca de uma muda MAJOR contém a forma antiga completa:

- tree Git do commit de congelamento;
- inventário top-level e `.hbn/`;
- `REGISTRY.md` antigo, STATE antigo, readbacks, handoffs, results, knowledge,
  queue, relay archive, schemas, guards, tests, docs, source e metadados;
- lista de untracked conhecidos no momento do congelamento, com decisão explícita
  para cada um: incorporado à casca, registrado antes do congelamento ou deixado
  como não-parte com justificativa humana;
- checksum/sha de cada âncora relevante;
- instrução de reconstrução da forma 0.x.

A regra é P1: nada se perde. A casca pode ser um snapshot Git-tree + manifesto
auditável, ou um diretório/archive frio gerado a partir do tree + untracked
allowlist. A implementação posterior deve escolher o mecanismo mais simples que
seja reconstruível e auditável.

### A4. Curadoria do carry-forward

O carry-forward é proposto por cross-audit e ratificado pelo humano. A regra
prática:

- "quente/válido" migra;
- histórico completo congela;
- dívida reconhecida vira item explícito no manifesto, não some do STATE por
  edição silenciosa;
- nada migra só por estar no root atual.

### A5. Schema mínimo do manifesto

O manifesto da muda deve ser um artefato quente da forma nova, com estes campos:

```yaml
manifest_version: 1
subject:
  kind: protocol|project
  name: usehbn
  from_version: 0.3.x
  to_version: 1.0.0
  trigger: "MAJOR: protocol_version required"
frozen_shell:
  tree_sha: "<sha>"
  archive_path: "<path ou ref>"
  frozen_at: "<ISO8601 local com offset>"
  immutable_policy: "append-only; sem edição da casca"
previous_exuvia:
  manifest_path: null
  shell_ref: null
new_form:
  protocol_version: 1.0.0
  canonical_root: "<repo root ou novo root ratificado>"
  ledger_path: ".hbn/ledger/REGISTRY.md"
carry_forward:
  - old_path: "core/orchestrator-profile-spec.md"
    new_path: "core/orchestrator-profile-spec.md"
    kind: "spec-core"
    status: "carried"
    reason: "doutrina 0.2.0 quente"
renamed:
  - old_path: "REGISTRY.md"
    new_path: ".hbn/ledger/REGISTRY.md"
    bridge: "root pointer temporário, se guard exigir"
left_behind:
  - old_path: ".hbn/relay/STATE.md"
    disposition: "frozen; novo STATE consolidado nasce limpo"
open_debts:
  - id: "B2"
    disposition: "dissolvido por novo modelo de ledger/hearback"
guards_transition:
  runner_expected: "green"
  simulations_required: ["G-SCO", "G-REG", "G-PAR", "G-SLF", "G-RLT"]
rollback:
  anchor_before_freeze: "<sha>"
  anchor_after_renascence: "<sha>"
  procedure: "git revert da muda ou checkout do anchor; casca intacta"
ratification:
  cross_audits: []
  human_status: "pending|confirmed"
```

### A6. Relação com glacier

Exúvia é granularidade de época/versão; glacier é armazenamento frio por
retenção. Com duas cascas acumuladas para o mesmo sujeito, a mais antiga vira
candidata obrigatória a glacier. O manifesto da casca mais nova mantém o link
da cadeia; a descida ao glacier não apaga a casca, só muda seu endereço frio.

### A7. Guards na virada

Na primeira muda, a raiz Git deve permanecer `/Users/macbookpro/Projetos/usehbn`
salvo ratificação explícita em contrário. Isso evita transformar G-CR em problema
de migração antes da onda multi-projeto. O `assert-canonical-root` continua
fail-closed contra `.hbn/canonical-root` e só aceita alternativas versionadas em
`.hbn/alt-roots` (`.hbn/canonical-root:1`, `.hbn/alt-roots:1-11`,
`guards/assert-canonical-root.sh:42-92`).

Demais guards devem ser tratados assim na onda de execução:

- **G-SCO**: readback da execução lista paths exatos e forbids fortes. Nenhum
  `git add .` ou `git add ..`.
- **G-REG**: todo artefato novo do congelamento, renascimento e ponte nasce com
  linha no ledger que o guard vigente entende. Se o ledger canônico mudar para
  `.hbn/ledger/REGISTRY.md`, a execução deve prever uma ponte compatível até o
  guard ser atualizado/ratificado.
- **G-PAR/G-NUM**: nomes novos em `.hbn/proposals`, `.hbn/messages` e
  `.hbn/results` usam `AAAAMMDD-HHMMSS-<agente>-<slug>` e `created_at` local com
  offset coerente.
- **G-SLF**: todo `.md` governado novo declara `path:` real.
- **G-RLT**: qualquer handoff novo entra no mesmo commit do STATE, com
  `PRÓXIMA AÇÃO` exatamente igual à do STATE e `ultima_atualizacao` idêntico.
- **G-HRB/G-EXC**: não baixar sinais nem criar hearbacks formais em commits que
  ainda reproduzam o deadlock B2. A forma nova deve dissolver B2 antes da baixa
  formal.

### A8. Invariante de auditabilidade

O protocolo Exúvia obedece P1, P6 e P10:

- P1: preservar antes de transformar. A casca é completa e navegável.
- P6: reversibilidade. A muda tem âncora antes/depois e rollback declarado.
- P10: segurança e não-regressão acima de velocidade. A execução só começa após
  cross-audit, ratificação humana e suíte verde na forma nova.

## Parte B — Plano da 1a muda (`0.3.x -> 1.0.0`)

### B1. Inventário da forma atual

Top-level atual observado nesta janela:

`.antigravity`, `.chatgpt`, `.claude`, `.gemini`, `.git`, `.github`, `.gitignore`,
`.hbn`, `.pytest_cache`, `.usehbn`, `.venv`, prompts `20260610-*`, `AGENTS.md`,
`AUDITORIA_SUPERPOWERS.md`, `CHANGELOG.md`, `CODE_OF_CONDUCT.md`,
`CONTRIBUTING.md`, `GOVERNANCE.md`, `HBN-ARCHITECTURAL-REVIEW-2026-04.md`,
`LICENSE`, `MAINTAINERS.md`, `PROMPT_*`, `README.md`, `REGISTRY.md`,
`ROADMAP.md`, `SECURITY.md`, `SUPPORT.md`, `agents`, `auditoria`, `build`,
`core`, `dist`, `docs`, `examples`, `get-hbn`, `guards`, `inbox`, `local-ai`,
`logs`, `methodology`, `pyproject.toml`, `reports`, `schemas`, `setup.cfg`,
`setup.py`, `site`, `skills`, `src`, `state`, `tests`.

`.hbn` atual observado:

`README.md`, `alt-roots`, `attention.json`, `autoevolve`, `canonical-root`,
`connectors`, `hearbacks`, `knowledge`, `messages`, `models`, `proposals`,
`queue`, `readbacks`, `relay`, `relay-archive`, `reports`, `results`,
`stray-allowlist`.

Untracked conhecidos nesta janela:

- `.hbn/messages/20260612-122102-fable5-handoff-orquestracao-pos-onda-0006.md`;
- `.hbn/messages/20260613-112502-fable5-handoff-orquestracao-pos-adocao-onda-0006.md`;
- `.hbn/results/20260613-234731-gemini-3-5-cross-ia-onda-0009-confirma-emenda.md`.

O terceiro item entra nesta onda como parecer frio registrado no REGISTRY. Os
dois handoffs históricos continuam fora do commit vivo por B1 e devem entrar na
casca/inventário de congelamento sem reabrir G-RLT.

### B2. Dívida a dissolver por desenho

- **B1 - G-RLT handoff arquival**: handoffs históricos não devem ser forçados
  para a série viva `.hbn/messages/`. Na forma 1.0.0, a casca contém o histórico
  completo e a forma nova só mantém handoff vigente/ponte, eliminando a necessidade
  de "consertar" handoff velho para passar G-RLT.
- **B2 - G-REG x G-HRB**: hearback formal numerado não pode depender de editar um
  segundo arquivo de ledger no mesmo commit puro. Na forma 1.0.0, o ledger do
  hearback deve ser o próprio artefato ou um índice transacional compatível com
  commit puro; assim o hearback ADR-023 volta a ser possível.
- **B3 - baixa formal F-01**: a baixa não deve editar o STATE 0.x para apagar a
  história. A casca preserva a exceção ativa e o manifesto 1.0.0 carrega o status
  ratificado/resolvido com link para as evidências.
- **REGISTRY na raiz**: muda para `.hbn/ledger/REGISTRY.md` como endereço canônico
  da forma nova. Se necessário, a raiz mantém ponteiro temporário somente para
  compatibilidade de guard durante a execução.
- **STATE stale**: a linha `123/123` deve ser encerrada como fato da casca 0.x; a
  forma nova nasce com o estado consolidado real, sem carregar contagens antigas
  como verdade vigente.
- **Untracked históricos**: entram no manifesto de congelamento como `untracked`
  inventariado, e não como mutação viva improvisada.

### B3. Forma nova proposta

Layout conceitual da forma `1.0.0`:

```text
.hbn/
  ledger/
    REGISTRY.md
    MANIFEST-1.0.0.md
  exuviae/
    protocol-0.x/
      MANIFEST.md
      snapshot-ref.txt
      untracked-inventory.md
  relay/
    STATE.md
    INDEX.md
  readbacks/
  hearbacks/
  messages/
  results/
  knowledge/
core/
guards/
schemas/
src/
tests/
docs/
methodology/
```

O livro-razão sai da raiz e passa a morar em `.hbn/ledger/`. O root fica para
entrada humana mínima e arquivos de pacote. A doutrina, specs, schemas e guards
continuam em seus endereços estáveis quando o endereço já é bom; o que muda é o
papel do ledger e do STATE:

- STATE 1.0.0 contém só presente consolidado;
- a casca 0.x contém o passado completo;
- `MANIFEST-1.0.0.md` é a ponte auditável entre os dois;
- B1/B2/B3 deixam de ser problemas de "regularização em arquivo vivo" e viram
  itens explicitamente resolvidos ou carregados pelo manifesto.

### B4. Carry-forward proposto para ratificação humana

Proposta inicial do conjunto quente/válido:

- `core/` specs aceitas, com destaque para `orchestrator-profile-spec.md` v0.2.0,
  `relay-spec.md`, `state-report-spec.md`, `roles-assignment-spec.md`,
  `start-rite-spec.md`, `pointer-spec.md`, `readback-spec.md`,
  `freeze-gate-spec.md`, `dual-run-spec.md`, `protocol.md` e `validation-rules.md`;
- ADRs aceitas e quentes em `methodology/adr/`, em especial ADR-004, ADR-009,
  ADR-011, ADR-012, ADR-014, ADR-015, ADR-018, ADR-020, ADR-021, ADR-022,
  ADR-023, ADR-024 e ADR-025;
- `schemas/*.schema.json` governados;
- `guards/*.sh`, `guards/lib/common.sh`, `guards/tests/run-guard-tests.sh` e
  `guards/tests/adversarial-battery.sh`, desde que a suíte esteja verde na forma
  nova;
- `.hbn/models/*.json`, `.hbn/knowledge/0019-severidades-veto.md`,
  `.hbn/knowledge/0022-firewall-workflow-fast-track.md`, `.hbn/alt-roots`,
  `.hbn/canonical-root` e `.hbn/stray-allowlist`;
- `REGISTRY.md` como conteúdo migrado para `.hbn/ledger/REGISTRY.md`, com
  ponteiro/compatibilidade se o guard vigente ainda exigir root;
- STATE consolidado, não copiado literalmente: só sinais abertos reais e próximos
  passos ratificados;
- docs públicos essenciais (`README.md`, `CHANGELOG.md`, `docs/`, `AGENTS.md`,
  `skills/hbn/SKILL.md`) sem carregar prompts/históricos como read-list quente.

Tudo que não for ratificado como quente fica congelado na casca 0.x.

### B5. O que fica na casca 0.x

Fica congelado na casca:

- a história completa da raiz atual;
- `REGISTRY.md` na raiz como livro-razão 0.x;
- `.hbn/relay/STATE.md` com sinais e dívidas no estado 0.x;
- `relay-archive`, `messages`, `results`, `readbacks`, `hearbacks`, `queue`,
  `autoevolve`, `connectors`, prompts e relatórios históricos;
- dois handoffs históricos untracked, por inventário explícito;
- qualquer proposta glacier/zona-de-corte/refatoração anterior que não tenha sido
  ratificada para carry-forward.

### B6. Risco e rollback

Riscos principais:

- quebrar guards ao mover o ledger antes da ponte de compatibilidade;
- perder histórico se a casca excluir untracked conhecidos;
- transformar a muda em refactor amplo sem manifesto;
- apagar F-01 como texto em vez de resolvê-la por ato auditável.

Mitigações:

- congelamento e renascimento são commits separados, ambos com âncoras;
- manifesto lista carry-forward, renamed e left-behind;
- root `REGISTRY.md` só deixa de ser caminho operacional quando G-REG novo for
  ratificado;
- rollback P6: `git revert` dos commits da execução ou checkout da âncora antes
  da muda; a casca continua navegável e a cadeia de manifestos permanece intacta.

### B7. Hearbacks formais pendentes

F-01 e a doutrina 0.2.0 continuam sem hearback ADR-023 formal por B2. A forma
1.0.0 deve resolver isso antes de declarar a muda concluída:

- o modelo de hearback precisa permitir commit puro sem depender de uma linha
  REGISTRY separada no mesmo commit;
- após B2 dissolvido, o humano emite hearback formal para F-01, marcando a exceção
  como `ADOTADA-NAO-PRECEDENTE` ou status equivalente ratificado;
- o hearback formal da doutrina 0.2.0 entra pelo mesmo mecanismo;
- o manifesto da muda referencia esses hearbacks como fechamento da transição.

## REGISTRY

Linha a acrescentar no mesmo commit desta proposta:

```text
| 20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda | .hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md | proposal | quente | — | 2026-06-14T00:14:21-03:00 |
```
