---
arvore: fronteira
status: congelado
tema: code-review-cli-runtime
autor: subagente-opus-evolucao
data: 2026-06-16
escopo: src/usehbn/cli.py + runtime Python (protocol, engine, autoevolve)
truth_barrier: toda afirmacao tecnica cita arquivo:linha
temperatura: glacier
---

# B1 — Code Review de Fronteira: CLI + Runtime Python do useHBN

> Revisao **nao-normativa**. Nao altera a MATURITY-MATRIX nem o codigo. Serve de
> insumo para a Onda 7 (refatoracao interna do god-object) e para o plano da 1a
> exuvia (`versao_1_0_0/`). Marcadores: **[CONCLUSAO]** factual ancorada,
> **[PROPOSTA]** sugestao de design, **[RISCO]** ponto de quebra ou debito.

---

## 0. Mapa de tamanho (medido)

| Arquivo | LOC | Papel |
|---|---:|---|
| `src/usehbn/cli.py` | 1776 | god-object: parser + 17 handlers + IO + estado relay |
| `src/usehbn/runtime.py` | 441 | deteccao runtime + adapter body monolitico + staleness |
| `src/usehbn/execution/engine.py` | 229 | pipeline minimo (trigger→intent→TB→guardian→consent) |
| `src/usehbn/protocol/*.py` | ~437 | intent, readback, consent, guardian, truth_barrier, result |
| `src/usehbn/autoevolve/*.py` | ~452 | orchestrator/worker/queue/approval/audit/cli |

`cli.py` sozinho e ~4x o segundo maior arquivo do runtime. Confirma o rotulo
"god-object (~1700 LOC)" da MATURITY-MATRIX linha 54.

---

## 1. Avaliacao do god-object `cli.py`

### 1.1 Responsabilidades misturadas em um unico modulo

**[CONCLUSAO]** `cli.py` concentra ao menos sete responsabilidades distintas que
deveriam estar em camadas separadas:

1. **Definicao de parsers / contrato CLI** — `build_parser` (`cli.py:113`),
   `build_root_parser` (`cli.py:122-616`), `_add_protocol_arguments`
   (`cli.py:63`). Sozinho o `build_root_parser` ocupa ~495 linhas declarativas.
2. **Dispatch / roteamento** — `main` (`cli.py:1695-1772`), um if/elif gigante
   de 17 ramos (`cli.py:1722-1763`).
3. **Handlers de comando (orquestracao)** — `run_protocol` (`cli.py:639`),
   `run_translate` (`cli.py:660`), `run_connector_inspect/ensure`
   (`cli.py:673`, `695`), `run_init` (`cli.py:1006`), `run_doctor`
   (`cli.py:1106`), `run_quickstart` (`cli.py:1213`), `run_handoff`
   (`cli.py:1600`) etc.
4. **Logica de dominio do Relay/Baton** — `_load_relay_state` (`cli.py:1499`),
   `_save_relay_state` (`cli.py:1527`), `_find_pending_readbacks`
   (`cli.py:1564`), cap de audit_trail (`cli.py:1496`). Isto e *estado de
   protocolo*, nao apresentacao.
5. **Geracao de conteudo (templates de texto)** — `_relay_index`
   (`cli.py:782`), `_knowledge_index` (`cli.py:804`), `_reports_index`
   (`cli.py:816`), `_hbn_readme` (`cli.py:828`). Strings PT longas embutidas.
6. **IO de filesystem direto** — `path.rename` em handoff (`cli.py:1632`),
   `write_text`/`read_text` espalhados, `mkdir` (`cli.py:1031`), edicao de
   INDEX.md por parsing de linha (`cli.py:1671-1680`).
7. **Efeitos colaterais de terminal / UX** — `_emit_attention` escrevendo
   escape codes ANSI e BEL diretamente em stdout (`cli.py:943-949`),
   `input()` interativo em `_prompt_for_consent`/`_prompt_yes_no`
   (`cli.py:619-626`).

**[RISCO]** Misturar (4) estado de protocolo, (6) IO e (5) templates com a
camada de apresentacao (1)(2) significa que qualquer teste de unidade de uma
regra do Relay precisa carregar todo o universo do argparse. Isso desincentiva
testes finos e empurra a suite para happy-path de ponta-a-ponta — exatamente o
debito que a MATURITY-MATRIX reconhece em **Tests** (linha 76).

### 1.2 Pontos de quebra / tratamento de erro

**[RISCO] `main()` nao tem try/except de fronteira.** A unica protecao em
`cli.py` e local: `_parse_json_argument` (`cli.py:630-633`) e o `_scan` interno
de `_find_pending_readbacks` (`cli.py:1581-1583`). Todo o resto sobe excecao
crua:

- `run_attention` levanta `ValueError("Either --mode or --choice is required")`
  (`cli.py:1294`) — vira traceback Python no terminal do usuario, nao mensagem
  amigavel.
- `_parse_risk_flags` levanta `ValueError(f"Unknown risk flag: {flag}")`
  (`cli.py:1358`); `_parse_evidence` idem (`cli.py:1367,1371,1374`);
  `_parse_env_keys` idem (`cli.py:1453`).
- `create_result_record` levanta `ValueError` em quatro invariantes de
  protocolo (`result.py:56,58,60,97`). Um usuario que tenta criar ERP sem
  hearback confirmado recebe um stack trace, nao um JSON de erro.
- `assert_valid_payload` (validador custom) propaga falha de schema sem captura.

**[CONCLUSAO] `main()` sempre retorna `0`** (`cli.py:1772`). Mesmo nos ramos que
produzem `{"error": ...}` (connector desconhecido `cli.py:1732`, relay
desconhecido `cli.py:1759`, handoff sem `.hbn` `cli.py:1607`, hearback sem
exec_id `cli.py:1436`), o exit code e sucesso. **[RISCO]** Scripts e CI que
dependem de exit code (`hbn handoff && deploy`) nunca detectam falha logica do
protocolo. Para um protocolo cujo proposito e *bloquear* avanco inseguro, exit
code sempre-zero e uma contradicao funcional.

**[PROPOSTA]** Introduzir um unico `try/except` em `main()` que (a) mapeie
`ValueError`/`HbnProtocolError` para `{"error": ..., "code": ...}` + `return 2`;
(b) mantenha `return 0` apenas no caminho de sucesso real; (c) preserve o
contrato JSON-em-stdout. Definir uma hierarquia minima de excecoes
(`HbnProtocolViolation`, `HbnUsageError`) em `protocol/` para distinguir erro de
uso (exit 2) de violacao de protocolo (exit 3) de erro interno (exit 1).

### 1.3 Acoplamentos

**[CONCLUSAO] Import tardio para quebrar ciclos** — `cli.py` faz import dentro
de funcao em pelo menos tres pontos: `from usehbn.utils.config import
default_state_dir` em `_find_latest_pending_readback` (`cli.py:1381`) e em
`_find_pending_readbacks` (`cli.py:1573`); `from usehbn.runtime import
compute_baton_staleness` dentro de `run_relay_status` (`cli.py:1554`). Imports
locais sao sintoma classico de modulo que cresceu alem do que suas dependencias
de topo comportam. **[RISCO]** Mascaram acoplamento e tornam a ordem de
inicializacao fragil.

**[CONCLUSAO] Handler chama handler diretamente** — `run_connector_ensure`
chama `run_init` (`cli.py:698`) e `run_quickstart` chama `run_init`
(`cli.py:1221`), ambos fabricando um `argparse.Namespace` na mao
(`cli.py:699-703`, `1222-1226`). **[RISCO]** A camada de apresentacao depende do
formato do Namespace de outra camada de apresentacao; mudar um arg de `init`
quebra silenciosamente ensure/quickstart. O dominio deveria ser uma funcao pura
(`initialize_target(target, runtime)`) chamada por ambos.

**[RISCO] Inconsistencia de diretorio de estado `.hbn/` vs `.usehbn/`.** O CLI
inicializa e opera sobre `.hbn/` (`cli.py:752 _hbn_dir`; readbacks/results
criados em `cli.py:1020-1021`). Mas o runtime de protocolo persiste em
`default_state_dir` = `.usehbn/` (`config.py:12,25`) — `create_readback_record`
grava em `.usehbn/readbacks/` (`readback.py:24-26`), `create_result_record` em
`.usehbn/results/` (`result.py:34-35`), e o engine grava logs em `logs/`
(`engine.py:189`, `config.py:33`) e estado em `.usehbn/` via
`append_execution_state`. O proprio codigo documenta esse bug em
`_find_pending_readbacks` (`cli.py:1564-1572`): a funcao precisou passar a ler
*dois* diretorios e dedupar por execution_id porque o handoff "silently let
pending readbacks through". **[CONCLUSAO]** O fix da Onda 3 (`cli.py:1594-1595`)
remenda **um** consumidor (handoff/doctor), mas a divergencia estrutural
permanece: `init` cria `.hbn/readbacks/` que o protocolo nunca usa, e
`inspect_target` le `.usehbn/hbn-state.json` com fallback `state/hbn-state.json`
(`runtime.py:377-379`) — uma *terceira* convencao. Sao tres locais de verdade
para estado.

### 1.4 Duplicacoes

**[CONCLUSAO]** O envelope de retorno
`{"project": "HBN — Human Brain Net", "protocol_version": PROTOCOL_VERSION, ...}`
e repetido literalmente em ~15 handlers (`cli.py:666, 686, 742, 1088, 1099,
1199, 1244, 1278, 1297, 1327, 1414, 1443, 1477, 1488, 1546, 1604, 1682`).
**[PROPOSTA]** `def _envelope(**payload) -> dict` unico.

**[CONCLUSAO]** O bloco `--indent` (`type=int, default=2, help="JSON
indentation..."`) e declarado ~17 vezes, um por subparser (`cli.py:106-110,
154-158, 184-189, 228-233, ...`). **[PROPOSTA]** Helper `_add_indent(parser)` ou
arg global herdado via `parents=[common]`.

**[CONCLUSAO]** `--target default="."` repetido em quase todo subparser; a
normalizacao `Path(args.target).expanduser().resolve()` aparece em ~12 handlers
(`cli.py:663, 674, 696, 1007, 1098 (sem resolve!), 1107, 1214, 1269, 1286, 1308,
1486, 1544, 1601`). Nota: `run_inspect` (`cli.py:1098`) usa `Path(args.target)`
**sem** `.expanduser().resolve()`, divergindo dos demais — inconsistencia sutil
que afeta `~`-paths e relativos.

**[CONCLUSAO]** A diretiva PT "Digite A para retirar o aviso sonoro ou digite B
para apenas piscar a tela quando terminar." aparece triplicada
(`cli.py:1302-1303, 1338-1339`) e tambem no adapter body (`runtime.py:289`).

### 1.5 Mistura PT/EN

**[CONCLUSAO]** A fronteira de lingua e inconsistente e *load-bearing* (afeta
saida ao usuario):

- Help de argparse, chaves de JSON, status (`"executed"`, `"passed"`,
  `"clear"`) e nomes de funcao: **EN**.
- Conteudo gerado para humanos: **PT** — `_relay_index` (`cli.py:782-801`),
  `_knowledge_index`, `_reports_index`, `_hbn_readme`, mensagens de `run_notify`
  (`cli.py:1320-1326`), `human_prompt` (`cli.py:1302`), e o INDEX.md parseado
  por prefixo `**Bastao atual:` / `**Ultima atualizacao:` (`cli.py:1674-1677`).
- Comentarios de codigo: mistos — "Onda 3 (Relay Invariants): tolerar
  audit_trail ausente" (`cli.py:1504`) PT junto de docstrings EN.

**[RISCO]** O parsing de `run_handoff` depende de strings PT literais sem acento
no INDEX.md ("Bastao", "Ultima atualizacao"). Se algum dia o template for
traduzido ou acentuado, o update do baton falha silenciosamente (o `else`
preserva a linha original — `cli.py:1678`). Acoplamento fragil
template↔parser na mesma lingua nao-versionada.

---

## 2. [PROPOSTA] Decomposicao sem mudar o contrato externo

Premissa: `hbn`/`usehbn` (entry points em `pyproject.toml`) e o JSON de stdout
sao **contrato congelado**. A refatoracao e puramente interna (Onda 7).

### 2.1 Alvo de estrutura

```
src/usehbn/cli/
  __init__.py          # main(): dispatch fino via registry
  registry.py          # mapeia nome→(build_parser, handler); elimina o if/elif
  envelope.py          # _envelope(), _add_indent(), _resolve_target()
  errors.py            # HbnUsageError, HbnProtocolViolation → exit codes
  commands/
    run.py             # run_protocol  (chama execution.engine)
    translate.py
    connector.py       # inspect|ensure (subgrupo)
    lifecycle.py       # init, quickstart, install, refresh, inspect, doctor
    attention.py       # attention, notify  (+ mover _emit_attention p/ ui)
    protocol.py        # readback, hearback, result
    relay.py           # relay status, handoff
src/usehbn/relay/      # NOVO modulo de dominio (sai de cli.py)
  state.py             # _load/_save_relay_state, audit_trail cap, staleness
  handoff.py           # archive + index update (logica pura)
  pending.py           # find_pending_readbacks (uma fonte de verdade)
src/usehbn/scaffolding/
  templates.py         # _relay_index, _knowledge_index, _reports_index, readme
  init.py              # initialize_target() puro (sem Namespace)
src/usehbn/ui/
  terminal.py          # _emit_attention, prompts; isola IO de terminal
```

### 2.2 Como manter o contrato estavel

**[PROPOSTA]**

1. **Registry-driven dispatch.** Substituir o if/elif de `main`
   (`cli.py:1722-1763`) por `COMMANDS = {"run": run.handle, ...}`. Cada modulo
   `commands/*.py` expoe `register(subparsers)` e `handle(args) -> dict`. O
   conjunto `subcommands` (`cli.py:1696-1715`) vira a chave do registry. Saida e
   serializacao continuam centralizadas em `main` (`cli.py:1771`).
2. **Autoevolve ja esta no padrao certo** — dispatch antecipado em
   `main` (`cli.py:1716-1718`) delegando a `autoevolve/cli.py`. Usar isso como
   *template* para os demais grupos (connector, relay, protocol).
3. **Testes de caracterizacao primeiro (golden tests).** Antes de mover linha,
   gravar o JSON de saida atual de cada um dos 17 subcomandos com entradas fixas
   e `--storage-dir` temporario. A refatoracao so passa se o golden bate byte a
   byte. Isso protege o contrato sem depender de revisao manual.
4. **Migrar dominio antes de UI.** Extrair `relay/` e `scaffolding/` primeiro
   (sao logica pura, baixo risco), deixar `cli/commands/*` como cascas finas que
   so traduzem `args`→chamada de dominio→`_envelope`.

---

## 3. Estado real vs MATURITY-MATRIX (confirmar/contestar)

| Componente | Matriz | Veredito de fronteira | Evidencia |
|---|---|---|---|
| CLI | Implementado (god-object) | **Confirmo** o funcionamento e o debito; **acrescento** que exit-code-sempre-0 e a falta de try/except de fronteira nao constam na coluna de risco | `cli.py:1772`, sem try/except em `main` |
| Truth Barrier | Parcial (advisory) | **Confirmo: nao bloqueia.** E puramente regex que so empilha `warnings`; o engine nunca interrompe | `truth_barrier.py:71-74`; `engine.py:65-70 _validation_summary` retorna `warn`, nunca `block` |
| Guardian | Parcial (advisory) | **Confirmo: advisory.** 2 checks (`missing_validation`, `risky_output`) + repassa warnings do TB; so loga | `guardian.py:25-56`; status nunca afeta fluxo em `engine.py:164,187` |
| Intent | Parcial | **Confirmo a lacuna PT.** Regex sao EN-only (`without|with|must|delete|drop|production`...); PT/multi-clausula falham | `intent.py:15-33`; `_extract_clauses` `intent.py:51` |
| Readback | Implementado | **Confirmo + reforco o limite:** `engine.py` **nao** chama readback; so criado manualmente via CLI | `engine.py` nao importa `readback`; `cli.py:1398 run_readback_protocol` e a unica via |
| Hearback | Implementado | **Confirmo** gate efetivo *quando* ha readback | `result.py:54-56`; `find_readback_by_execution` `readback.py:30` |
| ERP/Result | Implementado | **Confirmo;** invariantes reais que levantam excecao | `result.py:56,58,60,97` |
| Consent | Implementado | **Confirmo + nota:** `revocable:true` e gravado mas **nenhum** caminho de revogacao/expiracao existe no runtime | `consent.py:55-57`; sem codigo de revoke |
| Relay/Baton | Parcial honesto | **Confirmo honestidade.** `baton_stale` so e reportado se `baton_staleness_seconds` estiver no state; sem daemon | `runtime.py:18-41`; `cli.py:1554-1560` |
| Runtime Adapters | Implementado (body monolitico, PT/EN) | **Confirmo:** body e uma lista de ~100 strings concatenadas, PT/EN misto | `runtime.py:210-313 _adapter_body` |
| Bridge VBA | Stub | **Confirmo:** retorna dict descritivo com `maturity:"stub"` | `bridge/vba.py:24-38` |

**[CONCLUSAO] Contestacao parcial — autoevolve nao aparece na matriz.** O
subsistema `autoevolve/` (452 LOC, 6 modulos) nao tem linha na MATURITY-MATRIX.
Pela definicao de estados (linhas 23-29), ele e **Scaffold tendendo a Stub**: o
`LocalWorker.report` existe e `run_tests` chama pytest de verdade
(`worker.py:29-39`), mas o `Orchestrator` (`orchestrator.py:21`) **nunca e
instanciado por nenhum caminho do CLI** — `hbn autoevolve` (`cli.py:1716`) so
roteia para `autoevolve/cli.py`, que expoe `status/audit/approve/rollback`
(`autoevolve/cli.py:97-115`), **nenhum** dos quais constroi orchestrator ou
worker. O proprio docstring admite: "the 'apply' is a no-op stub: the actual
code edits are performed by the assistant (Opus) outside this module"
(`worker.py:4-6`). **[PROPOSTA]** Adicionar linha "Autoevolve" a matriz como
Scaffold, com risco "Codex/IA confundir audit-trail com execucao autonoma real".

---

## 4. [PROPOSTA] Alocacao por arvore (Intermediaria madura vs Fronteira)

Criterio: o que tem contrato estavel + testes + caminho de erro vai para
**Intermediaria** (carrega para a 1a exuvia); o que e advisory/scaffold/stub
fica em **Fronteira** ate amadurecer.

### Intermediaria madura (qualidade de release)

- **Engine pipeline** (`engine.py`) — deterministico, persiste traceability,
  caminho idle + ativo cobertos (`engine.py:154-187`).
- **Readback / Hearback / ERP** — invariantes reais, schemas completos, gates
  efetivos (`readback.py`, `result.py:54-60`).
- **Consent (criacao)** — grava registro valido (`consent.py:30-65`); *a parte
  de revogacao fica na Fronteira*.
- **Runtime detection** (`runtime.py:103-196`) — logica de prioridade clara
  (explicit→target dir→env→weak), testavel.
- **Relay state + handoff** — apos o fix de path-mismatch (`cli.py:1564`) o
  caso central funciona; honesto sobre o que nao faz.

### Qualidade-Fronteira (nao prometer no presente do indicativo)

- **Autoevolve inteiro** — embrionario; orchestrator desconectado do CLI
  (secao 3). Worker.apply e no-op (`worker.py:5`).
- **Truth Barrier + Guardian** — advisory; regex EN-only; falsa sensacao de
  protecao (matriz linhas 57-58, confirmado).
- **Bridges** — stub documental (`bridge/vba.py`).
- **Connector verify / remote lookup** — stub/scaffold (matriz linhas 70-71).
- **Intent em PT/multi-dominio** — regex frageis (`intent.py:15-33`).
- **Tratamento de erro do CLI** — sem fronteira de excecao; exit code sempre 0.

---

## 5. [PROPOSTA] Plano compativel com a 1a exuvia (`versao_1_0_0/`)

Principio de exuvia: a versao congelada carrega **apenas contrato + dominio
maduro**; debito de fronteira fica para tras ou e refatorado *antes* do
congelamento, nunca depois.

### Fase A — antes de congelar `versao_1_0_0/` (pre-requisitos)

1. **[RISCO->mitigar] Unificar diretorio de estado.** Decidir `.hbn/` **ou**
   `.usehbn/` como fonte unica e migrar leitores/escritores. Hoje sao tres
   (`.hbn/`, `.usehbn/`, `state/`). Congelar com tres convencoes seria petrificar
   o bug que a Onda 3 ja teve que remendar (`cli.py:1564-1572`). Esta e a
   correcao de maior alavancagem e deve preceder a exuvia.
2. **Fronteira de erro em `main()`** (secao 1.2 [PROPOSTA]) — exit codes
   significativos. Sem isso o protocolo "bloqueia" mas o shell ve sucesso.
3. **Golden tests dos 17 subcomandos** — vira a rede de seguranca que permite
   refatorar com o contrato congelado.

### Fase B — refatoracao Onda 7 (decomposicao da secao 2)

Executar a extracao `relay/` + `scaffolding/` + `commands/` **sob** os golden
tests. Sai do god-object sem tocar o JSON de saida. Pode acontecer dentro da
janela da exuvia desde que os goldens permanecam verdes.

### O que **carrega** para `versao_1_0_0/`

- Contrato CLI (nomes de subcomando, flags, envelope JSON).
- Engine + Readback/Hearback/ERP + Consent(criacao) + Runtime detection.
- Schemas (`schemas/*.json`) — ja Implementado (matriz linha 73).

### O que **fica/refatora antes** (nao entra na exuvia como "Implementado")

- Autoevolve — entra apenas rotulado Scaffold, com `hbn autoevolve` documentado
  como audit-only (status/audit/approve/rollback), sem prometer execucao.
- Truth Barrier / Guardian — entram como advisory explicito; o modo `--enforce`
  (RFC-0001, matriz linhas 57-58) e que seria o gatilho de promocao, nao a
  exuvia.
- Bridges / connector verify / remote — permanecem stub/scaffold.
- Templates PT embutidos — externalizar para `scaffolding/templates.py` (e
  idealmente arquivos `.md` versionados) antes de congelar, para desacoplar do
  parser de INDEX.md (`cli.py:1674-1677`).

---

## 6. Sintese dos achados mais fortes

1. **[RISCO]** `main()` sem try/except de fronteira + `return 0` sempre
   (`cli.py:1772`): violacoes de protocolo (`result.py:56`) viram traceback e
   o shell ve exit 0. Contradiz o proposito de um protocolo que bloqueia.
2. **[RISCO]** Tres convencoes de diretorio de estado (`.hbn/`, `.usehbn/`,
   `state/`) — `config.py:12`, `cli.py:752`, `runtime.py:377-379`. O fix da
   Onda 3 (`cli.py:1564`) so remenda um consumidor; a causa estrutural fica.
3. **[CONCLUSAO]** Autoevolve e desconectado do CLI: `Orchestrator`
   (`orchestrator.py:21`) nunca instanciado; worker.apply e no-op
   (`worker.py:5`). Embrionario e ausente da matriz.
4. **[CONCLUSAO]** Confirmados como advisory que NAO bloqueiam: Truth Barrier
   (`truth_barrier.py:71`) e Guardian (`guardian.py:58`); engine so empilha
   warnings (`engine.py:65-70`).
5. **[CONCLUSAO]** god-object real: ~495 linhas so em `build_root_parser`
   (`cli.py:122-616`), 7 responsabilidades, ~15 envelopes e ~17 blocos
   `--indent` duplicados.

**Arquivo gerado:**
`/Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-16/B1-code-review-cli-runtime.md`
