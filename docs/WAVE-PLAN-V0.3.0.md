# HBN v0.3.0 — Plano de Ondas (Honest Foundation)

> Plano canonico de execucao do ciclo v0.3.0. Cada onda e uma transacao
> protocolada em `agents/wave-protocol.md`. Nenhuma onda comeca sem Hearback
> humano explicito. Nenhuma onda termina sem ERP gravado e Readback arquivado.

## Objetivo do Ciclo

Transformar o HBN de scaffold honesto em **fundacao publicavel honesta**:
codigo robusto onde a doutrina ja foi alinhada, sem inflar superficie nem
prometer capacidade que ainda nao existe. Ao final do ciclo: site mais
expressivo em `usehbn.org`, README mais legivel para humanos, e tag `v0.3.0`
publicada via TestPyPI primeiro (decisao Q13).

## Versao alvo

`v0.3.0 — Honest Foundation`. SemVer minor bump. Sem mudanca de termos
doutrinarios. Compatibilidade dual com `state/` legado mantida (decisao Q2).

## Documentos Normativos Vinculantes

- `agents/wave-protocol.md` — contrato operacional de toda onda.
- `docs/MATURITY-MATRIX.md` — estado canonico por componente.
- `docs/PHAGOCYTOSIS.md` — doutrina do Universal Translator.
- `docs/PUBLISHING-DECISION.md` — TestPyPI primeiro, gate G6.
- `docs/rfc/RFC-0001-enforce-mode.md` — RFC aberta, NAO autoriza implementacao em v0.3.0.
- `reports/HBN-ERP-HARDENING-AUDIT.md` — base auditada das Ondas 2, 3, 4.
- `.hbn/relay-archive/20260429T0530-0002-onda-bastao-claude-v0.3.0-foundation.md` — decisoes humanas vinculantes (20 perguntas).

## Lista Doutrinaria Imutavel (lembrete)

`Readback`, `Hearback`, `Guardian`, `Truth Barrier`, `ERP`, `Relay`, `Baton`,
`Consent`, `Handoff`, `Track` (`fast_track`/`safe_track`),
`Universal Translator`, `Phagocytosis`, `usehbn`, `hbn`, `use hbn`. NAO
renomear, NAO traduzir, NAO substituir em codigo, schemas ou docs sem RFC +
bump major.

## Ordem das Ondas

```
Onda 1 — Honestidade Narrativa            [CONCLUIDA — commit 43c4c5d]
Onda 2 — ERP Hardening Batch 1 (P0 Data Integrity)
Onda 3 — ERP Hardening Batch 2 (P1 Input Quality)
Onda 4 — ERP Hardening Batch 3 (P2 Schema Honesty)
Onda 5 — Schema Versioning (protocol_version opcional)
Onda 6 — Relay Invariants em Runtime
Onda 7 — Connector Lifecycle Registry (sem enforcement)
Onda 8 — Cleanup + state/ Legacy Migration Path
Onda 9 — Vitrine + Release v0.3.0 (TestPyPI + GitHub vitrine)
```

A ordem foi escolhida por:

1. **Risco descendente em integridade de dados primeiro** (Ondas 2-4 fecham os
   defeitos auditados de ERP).
2. **Capacidade incremental antes de release** (Ondas 5-7 entregam novidades
   bem delimitadas).
3. **Higiene + migracao** (Onda 8 fecha pontos cosmeticos e preparara remocao
   de legado em v0.4.0).
4. **Vitrine apenas no final** (Onda 9), conforme decisao humana de 2026-04-29.

---

## Onda 1 — Honestidade Narrativa  *(CONCLUIDA)*

- **Estado:** arquivada em `.hbn/relay-archive/20260429T065632Z-0003-onda-1-honestidade-narrativa.md`.
- **Commit:** `43c4c5d feat(docs): onda 1 — honestidade narrativa (alinhamento com MATURITY-MATRIX)`.
- **Resultado:** 6 docs alinhados a MATURITY-MATRIX; `pytest -q` 88/88 verde.

---

## Onda 2 — ERP Hardening Batch 1 (P0 Data Integrity)

### Objetivo

Bloquear sobrescrita silenciosa de records ERP por `execution_id` duplicado.
Defeito P0 auditado em `reports/HBN-ERP-HARDENING-AUDIT.md` (correcoes 2 e 3).

### Justificativa

Em sistema de rastreabilidade, sobrescrever um record sem aviso destroi
audit history. O contrato 1 `execution_id` -> 1 `result` precisa ser
imposto em duas camadas: arquivo (file system) e estado agregado (state
store).

### Arquivos permitidos

- `src/usehbn/protocol/result.py`
- `src/usehbn/state/store.py`
- `tests/test_result_protocol.py`

### Arquivos proibidos

- `src/usehbn/execution/engine.py` (congelado em v0.3.0)
- `schemas/*.json` (sem mudanca nesta onda)
- `core/`, `agents/`, `docs/`, `.github/`
- `reports/HBN-ERP-HARDENING-AUDIT.md` (fonte auditada, nao reescrever)
- Qualquer outro `*.py` fora dos 2 alvos

### Tests

- `tests/test_result_protocol.py::test_state_append`: corrigir para
  esperar `ValueError` no segundo append.
- Adicionar `test_overwrite_blocked`: verificar que segunda chamada
  com mesmo `execution_id` levanta `ValueError`.
- `pytest -q` deve permanecer verde (88 + ajuste de 1 + 1 novo = 88+).

### Gates obrigatorios

- G1 (Hearback humano antes de tocar codigo).
- G2 (mudanca toca state store): plano de migracao + rollback documentados
  no Readback. Como o defeito atual e sobrescrita silenciosa, "rollback" =
  reverter a duas mudancas isoladas via `git revert`.
- G7 nao se aplica (nenhum termo doutrinario tocado).

### Riscos e mitigacao

- **R1**: bloqueio quebrar uso atual em fluxos legitimos onde `execution_id`
  e reutilizado por engano. **Mitigacao**: mensagem de erro deve indicar
  "use unique execution_id or delete the existing record explicitly".
- **R2**: testes legados que dependiam de duplicidade silenciosa. **Mitigacao**:
  o teste existente `test_state_append` ja foi identificado como dependente
  do bug; sera corrigido na propria onda.
- **R3**: state store em prod com duplicidade pre-existente. **Mitigacao**:
  enforcement so afeta novos appends; estado historico permanece.

### Rollback

- Unico commit local. `git revert` reverte os 3 arquivos atomicamente.

### Superprompt para Codex (Onda 2)

```
CODEX TASK: HBN v0.3.0 — Onda 2 (ERP Hardening Batch 1)

LEITURA OBRIGATORIA antes de qualquer alteracao:
- agents/wave-protocol.md (contrato de execucao em ondas)
- docs/MATURITY-MATRIX.md
- docs/WAVE-PLAN-V0.3.0.md (este plano, secao Onda 2)
- reports/HBN-ERP-HARDENING-AUDIT.md (Correcoes 2 e 3)
- .hbn/relay/INDEX.md (estado atual do relay)

REGRAS CRITICAS:
1. PARAR apos criar o Readback inicial. Nao prosseguir sem Hearback humano explicito.
2. Nao tocar engine.py (congelado em v0.3.0).
3. Nao tocar schemas/ nesta onda.
4. Nao adicionar dependencia.
5. Nao renomear funcoes, classes, ou termos doutrinarios.
6. Nao executar git push, git pr, ou qualquer release.
7. Apos execucao: gravar ERP, atualizar relay, devolver bastao para humano.

ESCOPO ALVO (e SO esses 3 arquivos):
- src/usehbn/protocol/result.py
- src/usehbn/state/store.py
- tests/test_result_protocol.py

PASSO 1 — Criar Readback inicial em
.hbn/relay/0005-onda-2-erp-hardening-batch-1.md, declarando:
- diff planejado por arquivo (com snippets exatos das linhas a inserir);
- arquivos proibidos;
- testes que serao adicionados/ajustados;
- riscos R1/R2/R3 com mitigacao;
- proximo passo: PARAR e aguardar Hearback humano.

PASSO 2 — Apos Hearback humano explicito:

A. Em src/usehbn/protocol/result.py, dentro de create_result_record(),
ANTES de write_json(), inserir checagem de existencia:
  output_path = _results_dir(storage_dir) / f"{execution_id}.json"
  if output_path.exists():
      raise ValueError(
          f"Result record already exists for execution_id: "
          f"{execution_id}. Cannot overwrite."
      )
  write_json(output_path, record)

B. Em src/usehbn/state/store.py, dentro de append_result_state(),
ANTES do append:
  existing_ids = [
      r.get("traceability", {}).get("execution_id")
      for r in document.get("results", [])
  ]
  exec_id = result_record.get("traceability", {}).get("execution_id")
  if exec_id in existing_ids:
      raise ValueError(
          f"Result for execution_id {exec_id} already in state."
      )

C. Em tests/test_result_protocol.py:
  - Corrigir test_state_append: append duplicado deve levantar ValueError.
  - Adicionar test_overwrite_blocked: segunda chamada de
    create_result_record com mesmo execution_id deve levantar ValueError
    com "already exists" na mensagem.

PASSO 3 — Verificacoes:
- pytest -q (deve passar; espera 89+ tests verdes).
- git diff --stat (apenas 3 arquivos alvo modificados).
- grep doutrinario (nenhum termo da lista imutavel renomeado).

PASSO 4 — Gravar ERP:
hbn result exec-<onda2-id> --agent-id codex \
  --action "Onda 2: ERP hardening batch 1 (overwrite + state dedup guards)" \
  --outcome executed --human-status not_reviewed \
  --readback-id readback-exec-<onda2-id> \
  --evidence "audit:reports/HBN-ERP-HARDENING-AUDIT.md" \
  --evidence "plan:docs/WAVE-PLAN-V0.3.0.md"

PASSO 5 — Atualizar .hbn/relay/INDEX.md:
- Bastao volta para humano.
- Iteracao 0005 marcada como "resolvido-aguardando-hearback-final".
- Readback permanece em .hbn/relay/ ate Hearback final.

PASSO 6 — Reportar resultado ao humano. Aguardar Hearback final antes
de qualquer arquivamento ou commit.
```

---

## Onda 3 — ERP Hardening Batch 2 (P1 Input Quality)

### Objetivo

Validar parsing de evidence no CLI e padronizar geracao de timestamp UTC
ISO-8601 com sufixo `Z` em todos modulos do protocolo.

### Justificativa

Correcoes 6 e 1 do `reports/HBN-ERP-HARDENING-AUDIT.md`. Resolvem dois
problemas: (a) erros de evidence so apareciam em validacao de schema deep
no pipeline; (b) `consent.py` usa `utcnow()` (deprecated em Py3.12) e
`result.py` usa `datetime.now(timezone.utc)` com `+00:00` — duas estrategias
diferentes em um protocolo que afirma rastreabilidade.

### Arquivos permitidos

- `src/usehbn/cli.py` (apenas funcao `_parse_evidence`)
- `src/usehbn/utils/time.py` (NOVO arquivo, ~10 linhas)
- `src/usehbn/protocol/result.py` (apenas substituir geracao de timestamp)
- `src/usehbn/protocol/consent.py` (apenas substituir geracao de timestamp)
- `tests/test_result_protocol.py`

### Arquivos proibidos

- Qualquer outro arquivo em `src/`, `schemas/`, `docs/`, `core/`.

### Tests

- `test_evidence_empty_type_rejected`: `_parse_evidence([":ref"])` deve
  levantar ValueError.
- `test_evidence_empty_reference_rejected`: `_parse_evidence(["log:"])` idem.
- `test_timestamp_format`: `utc_now_iso()` deve terminar em `Z` e nao
  conter `+00:00`.

### Gates obrigatorios

- G1 (Hearback humano).
- G8 nao se aplica (sem nova dependencia; `datetime` e stdlib).

### Riscos e mitigacao

- **R1**: substituicao de timestamp pode mudar formatacao em records
  historicos? **Nao**: so afeta records criados apos a onda. Records
  antigos nao sao tocados.
- **R2**: removar `from datetime import` em consent.py pode quebrar
  outro uso. **Mitigacao**: Codex deve verificar todos usos de `datetime`
  no arquivo antes de remover import.

### Rollback

- `git revert` do commit unico.

### Superprompt para Codex (Onda 3)

> [Estrutura identica a Onda 2: leitura obrigatoria, regras criticas,
> escopo alvo, Readback inicial, parar para Hearback, depois aplicar as
> 4 mudancas: novo `utils/time.py`; substituir timestamp em `result.py`;
> substituir timestamp em `consent.py`; reescrever `_parse_evidence` em
> `cli.py`. Adicionar 3 testes. Gravar ERP. Devolver bastao.]

---

## Onda 4 — ERP Hardening Batch 3 (P2 Schema Honesty)

### Objetivo

Tornar o schema honesto: `other_emergent_risk` deve ser opcional;
`action_taken` deve ter `maxLength` enforced. Inclui adicionar suporte a
`maxLength` no validador customizado.

### Justificativa

Correcoes 4 e 5 do `reports/HBN-ERP-HARDENING-AUDIT.md`. Schema declara
constraint que validador nao verifica = "false guarantee". Schema declara
campo como required mas sistema autopreenche com `""` = falsa exigencia.

### Arquivos permitidos

- `schemas/result.schema.json`
- `src/usehbn/protocol/result.py`
- `src/usehbn/utils/validators.py`
- `tests/test_result_protocol.py`

### Arquivos proibidos

- Outros schemas. Outros protocolos. Engine.

### Tests

- `test_other_emergent_risk_optional`: record sem `other_emergent_risk`
  nao deve conter o campo.
- `test_action_taken_too_long`: `action_taken` com 501 chars deve
  levantar ValueError.
- `test_maxlength_validator`: validar string excedendo `maxLength`
  retorna lista de erros nao vazia.

### Gates obrigatorios

- G1 (Hearback humano).
- **G3 (mudanca de schema)**: RFC nao e necessaria pois e correcao
  bem auditada (correcoes 4 e 5 ja validadas em
  `reports/HBN-ERP-HARDENING-AUDIT.md`). Mas a mudanca de schema deve ser
  declarada explicitamente no Readback com analise de impacto retroativo:
  - `other_emergent_risk` opcional: records antigos com campo presente
    continuam validos.
  - `action_taken` com `maxLength: 500`: records antigos com `action_taken`
    longer que 500 falhariam revalidacao. Mitigacao: garantir que
    nenhum record historico atinge 500+ chars (verificar em
    `.usehbn/results/`); se atingir, aumentar limite.

### Riscos e mitigacao

- **R1**: records historicos invalidados pelo `maxLength`. **Mitigacao**:
  Codex deve checar `.usehbn/results/` no inicio da onda e reportar maior
  comprimento de `action_taken` no Readback. Se >= 500, ajustar limite.
- **R2**: validador adicional pode quebrar outros campos com `maxLength`
  pre-existente. **Mitigacao**: e onda aditiva; se ja havia `maxLength` em
  outros schemas, comportamento muda. Listar no Readback.

### Rollback

- `git revert`.

---

## Onda 5 — Schema Versioning (protocol_version opcional)

### Objetivo

Implementar decisao Q3: adicionar campo `protocol_version` opcional em
`readback.schema.json` e `result.schema.json`. Setar default `"0.3.0"`
em codigo. Preparar caminho para v1.0.0 onde o campo passa a `required`
(decisao Q4).

### Justificativa

Sem `protocol_version` em records, evolucao do schema futuramente quebra
records historicos sem caminho de migracao. Adicionar agora como opcional
e barato e preserva audit trail.

### Arquivos permitidos

- `schemas/readback.schema.json`
- `schemas/result.schema.json`
- `src/usehbn/protocol/readback.py`
- `src/usehbn/protocol/result.py`
- `src/usehbn/__init__.py` (apenas para constante de versao do protocolo)
- `tests/test_result_protocol.py`
- `tests/test_readback.py` (se existir; senao nao criar)

### Gates obrigatorios

- G1 + **G3 (schema)**.

### Riscos e mitigacao

- **R1**: adicionar `protocol_version` como opcional ainda assim adiciona
  campo em records novos. Tooling externo que validate exact match poderia
  quebrar. **Mitigacao**: documentar em CHANGELOG; ja decidido (Q3).

---

## Onda 6 — Relay Invariants em Runtime

### Objetivo

Validar invariantes do relay em runtime: (a) `handoff` deve falhar se
existir Readback pending sem Hearback; (b) registrar `audit_trail` simples
em `.hbn/relay/state.json` (last 10 transitions); (c) timeout configuravel
de baton (default infinito = mantem comportamento atual).

### Justificativa

Maturity matrix marca Relay como Parcial: "Convencoes e comandos existem;
invariantes ainda nao sao validadas em runtime". Esta onda promove Relay
para `Implementado` parcial.

### Arquivos permitidos

- `src/usehbn/relay/*.py` (apenas funcoes existentes; nao criar arquivos)
- `tests/test_relay.py`

### Arquivos proibidos

- `engine.py`. Schemas (relay state nao tem schema externo). CLI (sem
  novos subcomandos nesta onda).

### Riscos e mitigacao

- **R1**: enforcement de "Readback pending bloqueia handoff" pode quebrar
  fluxos atuais. **Mitigacao**: Codex deve verificar `.hbn/readbacks/`
  estado atual antes de implementar; se ha pending, decidir com humano
  se invalida-os primeiro ou se enforcement so vale para novos handoffs.

---

## Onda 7 — Connector Lifecycle Registry (sem enforcement)

### Objetivo

Registrar estados `detected/resolved/installed/verified/active/revoked`
em `.hbn/connectors/registry.json` como campo `lifecycle_state`. Sem FSM,
sem transicao automatica, sem enforcement. Apenas registro honesto.

### Justificativa

Maturity matrix marca lifecycle como `Visao em v0.3.0`. Esta onda nao
muda esse estado — apenas adiciona estrutura para que v0.4.0 possa
implementar FSM real.

### Arquivos permitidos

- `src/usehbn/connectors/storage.py`
- `schemas/connector-contract.schema.json` (apenas se necessario)
- `tests/test_connectors.py`

### Riscos e mitigacao

- **R1**: registry.json existente pode ja ter records sem
  `lifecycle_state`. **Mitigacao**: leitura tolerante a ausencia
  (default = `"detected"`); migracao implicita ao primeiro write.

---

## Onda 8 — Cleanup + state/ Legacy Migration Path

### Objetivo

Tres limpezas: (a) fundir headers duplicados `## Unreleased` no
`CHANGELOG.md` (observacao da auditoria pos-Onda 1); (b) atualizar
`README.md` secao "Current Status" removendo referencias residuais ao
track `0.2.x`; (c) implementar dual-read em `state/` legado (decisao Q1+Q2):
ler de `.usehbn/` e `state/` se existir, mas escrever apenas em `.usehbn/`.

### Arquivos permitidos

- `CHANGELOG.md`
- `README.md`
- `src/usehbn/state/store.py` (apenas dual-read)
- `tests/test_state_dual_read.py` (NOVO arquivo)

### Riscos e mitigacao

- **R1**: dual-read pode causar duplicidade se mesmo record existe em
  `state/` e `.usehbn/`. **Mitigacao**: dedup por `execution_id`,
  preferindo `.usehbn/`.

---

## Onda 9 — Vitrine + Release v0.3.0

### Objetivo

Onda de fechamento do ciclo. Tres frentes:

1. **Vitrine GitHub Pages (`site/`)**: refresh visual do `usehbn.org`
   refletindo v0.3.0 honestamente — Maturity Matrix visual, secao
   Phagocytosis, "Honest Foundation" tagline, paleta atual mantida,
   melhor metadata Open Graph para compartilhamento social.

2. **Vitrine README**: reorganizar topo do `README.md` para primeira
   impressao de adocao — quick-start em 3 comandos, badges (Python
   version, License AGPLv3, Status: alpha), secao "Why HBN" mais
   convidativa para humanos sem perder honestidade.

3. **Release**: tag local `v0.3.0`, smoke test em 3 OS (mac/linux/win),
   publicacao em **TestPyPI primeiro** conforme `docs/PUBLISHING-DECISION.md`,
   push para `main` no GitHub. PyPI estavel apenas em onda subsequente
   apos validacao humana.

### Arquivos permitidos

- `site/index.html`
- `site/styles.css`
- `site/` (assets novos como og-image.png, se decidido)
- `README.md` (reorganizacao do topo + badges)
- `CHANGELOG.md` (entrada `v0.3.0`)
- `pyproject.toml` (apenas bump de versao)
- `src/usehbn/__init__.py` (apenas bump de versao)

### Arquivos proibidos

- `core/`, `agents/`, `docs/MATURITY-MATRIX.md`, `docs/PHAGOCYTOSIS.md`,
  `docs/PUBLISHING-DECISION.md`, `docs/rfc/`, `schemas/`, `src/usehbn/`
  exceto `__init__.py`.

### Tests

- `pytest -q` deve passar em mac, linux, e windows (smoke test manual ou
  via CI minimo).
- Validar `hbn version` retorna `0.3.0`.
- Validar instalacao via TestPyPI:
  `pip install --index-url https://test.pypi.org/simple/ usehbn==0.3.0`
  em sandbox limpo.

### Gates obrigatorios

- G1 (Hearback humano para escopo + para conteudo da vitrine).
- **G6 (release publica)**: smoke test 3 OS + CHANGELOG fechado +
  Hearback explicito sobre conteudo do site e README. Sem G6, sem push.
- G8 nao deveria aplicar (sem nova dependencia esperada).

### Riscos e mitigacao

- **R1**: vitrine pode introduzir afirmacao supra-matriz. **Mitigacao**:
  Claude (architect) audita o conteudo do site e README antes de release;
  conformidade explicita com `docs/MATURITY-MATRIX.md` e obrigatoria.
- **R2**: TestPyPI publish falhar por nome reservado ou versao colidir.
  **Mitigacao**: Codex deve verificar disponibilidade do nome `usehbn` em
  TestPyPI antes da publish; se tomado, pausar e pedir Hearback humano
  sobre estrategia de naming.
- **R3**: GitHub push pode acidentalmente expor secrets. **Mitigacao**:
  Codex deve rodar `git diff --stat` final + `grep` por padroes de secret
  antes de push; humano confirma resultado.
- **R4**: usehbn.org pode quebrar visualmente em browsers antigos.
  **Mitigacao**: testar em Chrome, Firefox, Safari atuais; sem suporte
  obrigatorio a IE/legacy.

### Rollback

- Tag `v0.3.0`: `git tag -d v0.3.0 && git push --delete origin v0.3.0`.
- TestPyPI: nao remover release; publicar `0.3.1` como fix se necessario.
- Site: `git revert` do commit do site.

### Conteudo proposto da vitrine (para Hearback humano)

**Hero refresh:**
- Tagline: "An open protocol for safe, structured, and evolvable AI-assisted software engineering."
- Subtagline: "v0.3.0 — Honest Foundation. Built by humans, for humanity."
- CTA primario: "Start in 60 seconds" (link para README quickstart).
- CTA secundario: "Read the protocol" (link para `docs/PRINCIPLES.md`).

**Secao "Maturity Matrix" (nova):**
- 3 colunas visuais: "What Works Today" / "What Is Partial" / "What Is Vision".
- Cada coluna lista os componentes da matriz. Cores: verde / amarelo /
  azul. Honestidade explicita.

**Secao "Phagocytosis" (nova):**
- Diagrama horizontal: Routed -> Studied -> Digested -> Mastered -> Contributed.
- Texto curto: "Como o HBN aprende novas tecnologias progressivamente."

**Rodape:**
- AGPLv3 + governance + contribution path.
- Link para CONTRIBUTING.md, GOVERNANCE.md, SECURITY.md.

**Meta:**
- `og:title`, `og:description`, `og:image` para preview rico em
  redes sociais.
- `twitter:card` summary_large_image.

**README refresh (topo):**
```markdown
# HBN — Human Brain Net

> An open protocol for safe, structured, and evolvable AI-assisted software engineering.
> v0.3.0 — Honest Foundation.

[badges: License AGPLv3, Python 3.9+, Tests passing, Status alpha]

## Quickstart in 60 seconds

```bash
git clone https://github.com/<org>/usehbn
cd usehbn
./get-hbn
hbn run "use hbn analyze this system"
```

[continua com as secoes existentes]
```

### Superprompt para Codex (Onda 9)

> [Estrutura identica as anteriores. Crucial: Codex deve PARAR antes
> de cada gate (G1, G6) e aguardar Hearback. Codex nao executa
> `git push` nem publish em TestPyPI sem Hearback explicito sobre
> o conteudo finalizado.]

### Criterio de aceite final do ciclo v0.3.0

- Todas as 9 ondas com Readback arquivado em `.hbn/relay-archive/`.
- Todos ERPs gravados.
- `pytest -q` verde em mac+linux+win (smoke test).
- Tag `v0.3.0` no GitHub.
- Release em TestPyPI verificavel.
- Site em `usehbn.org` refletindo v0.3.0.
- README coerente com `docs/MATURITY-MATRIX.md`.
- Hearback humano final autorizando o release.

---

## Pos-v0.3.0 (fora do ciclo, fora do plano)

Sera planejado em iteracao futura:

- v0.3.1: PyPI estavel apos validacao humana de TestPyPI (decisao Q13).
- v0.4.0: implementacao de RFC-0001 (`--enforce` opt-in); FSM real do
  connector lifecycle; remocao de `state/` legado.
- v0.5.0+: Phagocytosis avancado, Universal Translator estagio Studied,
  case studies adicionais alem de Credenciamento.

## Auditoria entre ondas

Apos cada onda, antes da proxima comecar, humano pode invocar:

> "Claude, auditar Onda <n> contra `agents/wave-protocol.md` e
> `docs/WAVE-PLAN-V0.3.0.md`."

A auditoria retorna: pass | warn | fail; recomendacao explicita.
