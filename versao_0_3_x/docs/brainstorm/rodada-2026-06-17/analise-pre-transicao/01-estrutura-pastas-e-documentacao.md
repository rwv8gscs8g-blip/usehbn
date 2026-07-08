# Arquitetura de Pastas e Documentação pós-Exúvia — useHBN

**Classificação:** NÃO-NORMATIVO (fronteira) — insumo de pré-transição
**Autor:** subagente de análise (arquiteto de informação read-only)
**Data:** 2026-06-17

**Resumo (3 linhas):** O canônico atual tem 30 arquivos soltos na raiz (≈8 justificáveis), `docs/` e `core/` declarados "legado" no próprio AGENTS.md, ponteiros para pastas inexistentes (`modules/`, `radar/`) e duplicações (MATURITY-MATRIX, ROADMAP). Este documento propõe uma árvore-alvo pós-exúvia com REGISTRY central, "nada solto na raiz exceto justificados", convenções de nomenclatura padronizadas e um plano de limpeza sem big-bang que preserva os antigos na pasta original para auditoria. Toda afirmação cita arquivo:linha ou comando+saída.

---

## 0. Método e barreira de verdade

Toda investigação foi feita read-only sobre `/Users/macbookpro/Projetos/usehbn`. As fontes são `git ls-files`, `ls -la` e leitura de arquivos. Citações no formato `arquivo:linha` ou `comando → saída`.

---

## 1. Estado atual no disco (evidência)

### 1.1 Top-level (comando: `git ls-files | sed 's#/.*##' | sort | uniq -c`)

Pastas rastreadas e contagem de arquivos:

```
272 .hbn        53 guards      47 docs       43 src        32 methodology
31 tests        17 schemas     15 reports    14 auditoria  10 inbox
 7 agents        5 site         3 local-ai    2 examples     2 scripts
 1 scratch       1 state        1 logs        1 skills       1 .github
```

Mais **30 arquivos soltos na raiz** (ver §2). Pastas presentes no disco mas
fora do git (efêmeras/derivadas): `build/`, `dist/`, `auditoria` já parcial,
`site/` (gerado), `.venv/`, `.pytest_cache/` — confirmado por `ls -la` na raiz.

### 1.2 O que vive em cada pasta-núcleo

- **`core/`** (18 arquivos): specs normativas do protocolo — `protocol.md`, `command-spec.md`, `dispatch-spec.md`, `readback-spec.md`, `relay-spec.md`, `start-rite-spec.md`, `freeze-gate-spec.md`, `validation-rules.md`, `semantic-layer.md`, `hbn-exuvia-scaffold.md`, `exuvia-fitness-criteria.md` etc. (`git ls-files core`). **Porém AGENTS.md:69 declara `core/` como "legacy partition; superseded by modules/ progressively".**
- **`methodology/`** (32): `PRINCIPIOS-CONSTITUCIONAIS.md`, `MATURITY-MATRIX.md`, `ADR-AND-MD-PRIMER.md`, `adr/ADR-001..025` + `adr/INDEX.md`, `templates/ADR-TEMPLATE.md` e `MD-TEMPLATE.md` (`git ls-files methodology`).
- **`docs/`** (47): mistura de docs de produto/visão (`VISION.md`, `ARCHITECTURE.md`, `PRINCIPLES.md`, `MATURITY-MATRIX.md`), integrações (`INTEGRATION-*.md`), `rfc/RFC-0001-enforce-mode.md`, `brainstorm/`, `feynman/`, `prompts/` (implícito por §4). **AGENTS.md:70 declara `docs/` como "legacy partition; pieces being migrated".**
- **`.hbn/`** (272): o livro-de-bordo operacional vivo — `messages/` (handoffs), `dispatch/`, `hearbacks/`, `readbacks/`, `results/`, `relay/` (inclui `STATE.md`), `relay-archive/`, `knowledge/` (com `INDEX.md`), `reports/`, `proposals/`, `queue/`, `models/`, `connectors/`, `autoevolve/`, `stray-allowlist`, `attention.json`, `canonical-root`, `active-version` (`ls .hbn/`).
- **`guards/`** (53): scripts `assert-*.sh`, `forbid-*.sh`, `freeze-gate.sh`, `hbn-guards-runner.sh`, `lib/common.sh`, `hook-shims/`, `tests/` com fixtures (`git ls-files guards`).
- **`schemas/`** (17): contratos JSON-Schema (`state`, `handoff`, `hearback`, `dispatch`, `readback`, `result`, `intent`, etc.).
- **`src/`** (43): runtime Python `src/usehbn/` (protocol, connectors, autoevolve, execution, state, translation, utils).
- **`tests/`** (31): pytest.
- **`scratch/`** (1 rastreado: `scratch/README.md`): área temporária governada por guards (`assert-scratch-*.sh`).

---

## 2. Arquivos soltos na raiz (comando: `git ls-files | grep -v /`)

30 arquivos. Classificação em **justificados** vs **devem migrar**:

### 2.1 Justificados (convenção de ecossistema OSS / contrato de entrada)

| Arquivo | Por que fica na raiz |
|---|---|
| `README.md` | porta de entrada padrão GitHub |
| `LICENSE` | exigido na raiz (Apache-2.0, AGENTS.md:14) |
| `AGENTS.md` | contrato único de IA na raiz por agents.md Category A (AGENTS.md:1-8) |
| `REGISTRY.md` | livro-razão central; precisa ser trivial de achar (§5) |
| `CHANGELOG.md` | convenção Keep-a-Changelog |
| `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `GOVERNANCE.md`, `MAINTAINERS.md`, `SECURITY.md`, `SUPPORT.md` | health files OSS reconhecidos pelo GitHub na raiz |
| `pyproject.toml`, `setup.cfg`, `setup.py`, `.gitignore` | manifestos de build/packaging na raiz por exigência das ferramentas |
| `get-hbn` | instalador shell (entry-point distribuição; ADR-003) |
| `ROADMAP.md` | aceitável, **mas duplica `docs/roadmap.md`** (ver §3.4) |

### 2.2 Devem migrar (artefatos de ciclo / análises que não pertencem à raiz)

| Arquivo | Destino sugerido | Evidência da violação |
|---|---|---|
| `20260610-31-prompt-consolidacao-codex.md` | `docs/prompts/` | prompt de ciclo encerrado |
| `20260610-51-prompt-pack-auditoria-cruzada-corrente-d.md` | `docs/prompts/` | idem |
| `20260610-61-prompt-auditoria-seguranca-antigravity.md` | `docs/prompts/` | idem |
| `20260610-62-prompt-auditoria-seguranca-codex.md` | `docs/prompts/` | idem |
| `PROMPT_ANALISE_PROFUNDA_PROTOCOLO_FABLE5.md` | `docs/prompts/` | já flagrado: `reports/20260610-36-proposal-faxina-prompts-raiz.md` (proposta DRY-RUN nunca executada) |
| `PROMPT_EVOLUCAO_PROTOCOLO_FABLE5.md` | `docs/prompts/` | idem proposta 36 |
| `PROMPT_C1_BASTAO_FABLE5.md` | `docs/prompts/` | idem |
| `PROMPT_C2_CHAIN_FABLE5.md` | `docs/prompts/` | idem |
| `PROMPT_C3_CHAIN_FABLE5.md` | `docs/prompts/` | idem |
| `PROMPT_C6C7_CHAIN_FABLE5.md` | `docs/prompts/` | idem |
| `AUDITORIA_SUPERPOWERS.md` | `reports/` ou `auditoria/` | análise; já no REGISTRY Legado como `audit` frio (REGISTRY.md:31) |
| `HBN-ARCHITECTURAL-REVIEW-2026-04.md` | `reports/` | análise; REGISTRY Legado linha `analise` frio (REGISTRY.md:30) |

**Achado central:** a proposta `reports/20260610-36-proposal-faxina-prompts-raiz.md` já mapeou os 7 PROMPT_*_FABLE5 para `docs/prompts/20260610-5x-...` com regra "MOVER, nunca deletar; linha no REGISTRY no mesmo commit" — mas os arquivos **continuam na raiz** (`git ls-files | grep -v /`). A faxina foi desenhada e nunca aplicada. A exúvia é a oportunidade de fechá-la.

---

## 3. Inconsistências de nomenclatura e organização (evidência)

### 3.1 Ponteiros para pastas que NÃO existem (SUPERSEDED apontados)

AGENTS.md descreve uma topologia-alvo que não está no disco:

- AGENTS.md:26 — "Protocol Specification ... `modules/`"
- AGENTS.md:63 — `modules/   normative protocol specification`
- AGENTS.md:66 — `radar/   technology phagocytosis tracking`
- AGENTS.md:69 — `core/   legacy partition; superseded by modules/ progressively`
- AGENTS.md:70 — `docs/   legacy partition; pieces being migrated to modules/`

Comando `ls -d modules radar` → `No such file or directory`; `git ls-files modules radar` → vazio. **Ou seja: o contrato de entrada (AGENTS.md) promete `modules/` e `radar/` que nunca nasceram, e declara `core/` e `docs/` "legado" enquanto `core/` segue sendo a casa das specs normativas vivas.** Esta é a maior dívida de honestidade estrutural do repositório (viola o espírito de `methodology/MATURITY-MATRIX.md` — "no public claim may exceed it", AGENTS.md:18).

### 3.2 Sobreposição docs/ × methodology/ × core/

- `docs/MATURITY-MATRIX.md` (117 linhas) **e** `methodology/MATURITY-MATRIX.md` (112 linhas) coexistem (`wc -l`). AGENTS.md:18 elege `methodology/MATURITY-MATRIX.md` como "single source of truth" — logo `docs/MATURITY-MATRIX.md` é cópia ambígua.
- `docs/PRINCIPLES.md` × `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (PT, fonte normativa P1-P13, AGENTS.md:30-33) × `docs/brainstorm/principios-candidatos.md` — três artefatos sobre "princípios" com pesos normativos diferentes e sem ponteiro único.
- `core/` = specs normativas; `methodology/` = princípios+ADR; `docs/` = produto/visão+integrações. A fronteira normativa/não-normativa não está marcada nos nomes de pasta.

### 3.3 `docs/brainstorm/` — padrão de rodadas datadas inconsistente

- Há rodadas datadas: `docs/brainstorm/rodada-2026-06-16/` e `docs/brainstorm/rodada-2026-06-17/` (`ls docs/brainstorm/`). Padrão bom: `rodada-AAAA-MM-DD/`.
- **Mas** arquivos soltos no nível de `docs/brainstorm/` quebram o padrão: `EXPLICACAO-PUBLICA-usehbn-DRAFT.md`, `PROMPTS-PF-ARVORES-AGORA-DRAFT.md`, `PROPOSTA-arvores-agora.md`, `exuvia-evolucao-conceitual.md`, `principios-candidatos.md`, e `_cursor-audit-w3-probe.md` (14 bytes — provável probe/lixo). Estes deveriam estar dentro de uma `rodada-*` ou em `docs/brainstorm/avulsos/`.
- Dentro de `rodada-2026-06-16/` o naming dos itens é `A1-`, `B2-`, `C3-`, `INDEX.md`, `PROMPT-...`, `SUPERPROMPT-...`, `CONSOLIDACAO-...` — padrão razoável por prefixo de trilha, mas sem `INDEX.md` em todas as rodadas (a de 2026-06-17 não tem `INDEX.md`; só `SINTESE-PROFUNDA-pre-freeze.md`).

### 3.4 Duplicação ROADMAP

`ROADMAP.md` (raiz) e `docs/roadmap.md` coexistem (`git ls-files | grep -iE roadmap`). Dois roadmaps com naming divergente (MAIÚSCULA-raiz vs minúscula-docs).

### 3.5 Deriva de colunas no REGISTRY

As tabelas going-forward mudaram de schema no meio do livro: blocos antigos têm 5 colunas `| id | artefato | tipo | temperatura | superseded_by |` (REGISTRY.md:46, 93, 127, 154) e blocos novos têm 6 colunas, adicionando `| created_at |` (REGISTRY.md:267, 341, 361...). Append-only justifica não reescrever o passado, mas a convenção going-forward precisa fixar **6 colunas** como padrão único daqui pra frente.

### 3.6 `reports/` (raiz) × `.hbn/reports/`

Dois lugares para "reports": `reports/` (15, análises/baselines/proposals) e `.hbn/reports/INDEX.md` (índice operacional). Sem regra clara de qual relatório vai onde.

---

## 4. REGISTRY.md como livro-razão (leitura do formato)

Header YAML (REGISTRY.md:1-9): `status: accepted`, `regras: append-only; uma linha por evento; nunca rename, nunca delete`, `evidencia: ADR-011 Decisões 4 e 5`. Estrutura:

1. **Legado** (REGISTRY.md:21) — costura órfãos pré-ADR-011 com data efetiva reconstruída do git/mtime; 6 colunas incluindo "evidência da data".
2. **Linhas going-forward** (REGISTRY.md:44) — id `AAAAMMDD-NN`, depois evoluiu para `AAAAMMDD-HHMMSS-autor-slug` (ver tail: `20260617-093000-codex-handoff-r1-fix2`).
3. **Blocos por onda/corrente** — cada onda tem um header `## <Nome> (<data>) — <status> — readback NNNN` (32 headers, REGISTRY.md:91..932). Isto é excelente: liga cada artefato a uma onda e a um readback.

**Regra de ouro já vigente** (REGISTRY.md:18-19): "Quem deposita artefato novo appenda a linha no mesmo commit do depósito." O guard `guards/assert-registry-line.sh` (citado em proposal 36) impede recorrência de órfãos. A estrutura de pastas **deve servir essa regra**: quanto mais previsível o destino de cada tipo de artefato, mais barato é gerar a linha correta.

---

## 5. PROPOSTA A — Árvore-alvo pós-exúvia

Princípio: **a hbn-exuvia nasce limpa; o canônico velho permanece como camada de auditoria.** Cada pasta tem função única e legível por humano. "Normativo" e "não-normativo" ficam separados por pasta.

```
hbn-exuvia/
├── README.md                  # porta de entrada (o que é, como começar)
├── LICENSE                    # Apache-2.0
├── AGENTS.md                  # contrato único de IA (deve refletir a árvore REAL)
├── REGISTRY.md                # LIVRO-RAZÃO central, append-only (§5 detalhe)
├── CHANGELOG.md               # histórico de versões human-facing
├── pyproject.toml/setup.*     # manifestos de build (exigência de ferramenta)
├── get-hbn                    # instalador
├── .gitignore
│
├── .github/                   # health files OSS (CONTRIBUTING, CODE_OF_CONDUCT,
│                              #   GOVERNANCE, MAINTAINERS, SECURITY, SUPPORT)
│                              #   → tira 6 arquivos da raiz sem perder reconhecimento GitHub
│
├── spec/                      # NORMATIVO: a especificação do protocolo (era core/ + futuro modules/)
│   ├── INDEX.md               #   índice das specs normativas
│   ├── protocol.md, command-spec.md, dispatch-spec.md, readback-spec.md ...
│   └── (cada spec com header self-locating + linha no REGISTRY)
│
├── methodology/               # NORMATIVO-DECISÓRIO: por que o protocolo é assim
│   ├── PRINCIPIOS-CONSTITUCIONAIS.md   # ÚNICA fonte P1-P13
│   ├── MATURITY-MATRIX.md              # ÚNICA fonte de maturidade
│   ├── adr/                            # ADRs + INDEX.md
│   └── templates/                      # ADR-TEMPLATE, MD-TEMPLATE
│
├── docs/                      # NÃO-NORMATIVO: produto, visão, integrações, guias
│   ├── INDEX.md
│   ├── product/               # VISION, ARCHITECTURE, PRINCIPLES(explicativo), ROADMAP (único)
│   ├── integrations/          # INTEGRATION-*.md, CONNECTORS, RUNTIME-ADAPTERS
│   ├── guides/                # CONTRIBUTOR-QUICKSTART, how-it-works, SAFE-TESTING
│   ├── prompts/               # prompts de ciclo (destino dos PROMPT_* da raiz)
│   ├── rfc/                   # RFCs em discussão
│   ├── feynman/               # explicações didáticas
│   └── brainstorm/            # FRONTEIRA (não-normativo); ver §6.3
│       └── rodada-AAAA-MM-DD/ # uma pasta por rodada, com INDEX.md obrigatório
│
├── knowledge/                 # LIÇÕES destiladas (era .hbn/knowledge) + INDEX.md vivo
│
├── ledger/  (= .hbn/)         # LIVRO-DE-BORDO operacional vivo
│   ├── messages/              # handoffs/despachos entre IAs
│   ├── dispatch/              # despachos auto-declarantes
│   ├── readbacks/ hearbacks/  # confirmações de leitura/escuta
│   ├── results/               # resultados de auditoria/execução
│   ├── relay/STATE.md         # estado corrente (single source of runtime state)
│   ├── relay-archive/         # estados selados
│   ├── reports/INDEX.md       # índice operacional de relatórios
│   ├── proposals/ queue/ models/ connectors/ autoevolve/
│   └── canonical-root, active-version, attention.json, stray-allowlist
│
├── reports/                   # análises/baselines/auditorias profundas datadas
├── auditoria/                 # meta-história do protocolo (bootstrap, cross-IA)
├── inbox/                     # despachos por app-consumidor (credenciamento, etc.)
│
├── schemas/                   # contratos JSON-Schema
├── guards/                    # scripts de verificação + tests/fixtures
├── src/usehbn/                # runtime Python
├── tests/                     # pytest
├── scratch/                   # área temporária governada (efêmera)
└── examples/                  # Reference Implementation (quando existir)
```

**Regra "nada solto na raiz exceto":** `README.md`, `LICENSE`, `AGENTS.md`,
`REGISTRY.md`, `CHANGELOG.md`, manifestos de build (`pyproject.toml`,
`setup.cfg`, `setup.py`, `.gitignore`) e `get-hbn`. **Todo o resto vive em
pasta.** Health files OSS migram para `.github/` (reconhecido pelo GitHub).
Um guard `assert-no-stray-root.sh` (irmão do `assert-no-stray-hbn.sh`
existente em `guards/`) pode tornar essa regra executável.

> Notas de migração de nomes: `core/` → `spec/` (resolve o "legacy/superseded"
> de AGENTS.md:69 promovendo-a a normativa real, OU mantém `core/` e corrige
> AGENTS.md — a decisão é humana). `.hbn/` pode permanecer `.hbn/` (já é o
> nome operacional consolidado); "ledger/" acima é só o papel conceitual.
> O importante é: **um só lugar por tipo de artefato.**

---

## 6. PROPOSTA B — Convenções de nomenclatura padronizadas

### 6.1 IDs de artefato (já vigente — formalizar)

- Série going-forward: `AAAAMMDD-HHMMSS-<autor>-<slug-kebab>` (ex.: `20260617-093000-codex-handoff-r1-fix2`, REGISTRY tail). Para artefatos sem timestamp fino: `AAAAMMDD-NN`.
- **Fora do padrão hoje:** os PROMPT_*_FABLE5 na raiz usam `SCREAMING_SNAKE_CASE` sem id de série (ex.: `PROMPT_C1_BASTAO_FABLE5.md`) — violam ADR-011 Decisão 1 (citado em `reports/20260610-36-...`:header). A faxina os renomeia para `docs/prompts/20260610-53-prompt-c1-bastao-fable5.md`.

### 6.2 Arquivos

- **kebab-case minúsculo** para artefatos de protocolo (`dispatch-spec.md`, `assert-scope-lock.sh`) — já é o padrão dominante em `core/`, `guards/`, `schemas/`.
- **MAIÚSCULAS** reservadas só para health files OSS na raiz/.github e para os "single source of truth" (`PRINCIPIOS-CONSTITUCIONAIS.md`, `MATURITY-MATRIX.md`).
- **Fora do padrão:** `AUDITORIA_SUPERPOWERS.md`, `HBN-ARCHITECTURAL-REVIEW-2026-04.md` (snake/caps na raiz), `_cursor-audit-w3-probe.md` (prefixo `_` + 14 bytes, provável probe — `ls docs/brainstorm/`).

### 6.3 Pastas datadas

- Padrão: `rodada-AAAA-MM-DD/` com **`INDEX.md` obrigatório** dentro. Já existe em `docs/brainstorm/rodada-2026-06-16/INDEX.md`.
- **Fora do padrão:** `docs/brainstorm/rodada-2026-06-17/` não tem `INDEX.md` (só `SINTESE-PROFUNDA-pre-freeze.md`); e há 6 arquivos avulsos soltos no nível de `docs/brainstorm/` (§3.3) que deveriam estar em rodada ou em `docs/brainstorm/avulsos/`.
- Sub-itens de rodada por trilha: prefixo `<Trilha><N>-slug.md` (`A1-`, `B2-`, `C3-`) — manter.

### 6.4 Datas

- ISO-8601 sempre: `AAAA-MM-DD` em prosa/pastas; `AAAA-MM-DDTHH:MM:SS-03:00` em `created_at` do REGISTRY (já vigente no tail).

---

## 7. PROPOSTA C — Onde vive cada coisa e como se liga ao REGISTRY

| Tipo de artefato | Pasta-alvo | Normativo? | Liga ao REGISTRY |
|---|---|---|---|
| Princípios constitucionais P1-P13 | `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` | SIM (MAJOR) | linha + ADR (ADR-009) |
| Specs normativas (comando, dispatch, readback...) | `spec/` (era `core/`) | SIM | uma linha por spec, `tipo=spec-core` |
| Decisões arquiteturais | `methodology/adr/` + `INDEX.md` | SIM | `tipo=adr` |
| Metodologia/primer/templates | `methodology/` | SIM-decisório | linha |
| Conhecimento/lições | `knowledge/` (era `.hbn/knowledge/`) + `INDEX.md` vivo | não | `tipo=knowledge` |
| Mensagens/despachos entre IAs | `.hbn/messages/`, `.hbn/dispatch/` | não | `tipo=handoff`/`dispatch` |
| Readbacks/hearbacks | `.hbn/readbacks/`, `.hbn/hearbacks/` | não | `tipo=readback`/`hearback` |
| Resultados de auditoria | `.hbn/results/` (operacional) e `reports/` (profundo) | não | `tipo=audit-result`/`audit` |
| Estado corrente | `.hbn/relay/STATE.md` (único) | não | `tipo=state`, sempre quente |
| Brainstorm/fronteira | `docs/brainstorm/rodada-AAAA-MM-DD/` | NÃO (fronteira) | linha `tipo=fronteira` quando depositado |
| Livro-razão | `REGISTRY.md` (raiz) | meta | ele próprio |

**Princípio de ligação:** todo depósito appenda **uma linha no mesmo commit**
(REGISTRY.md:18). A árvore-alvo facilita isso porque o `tipo` da coluna
deriva mecanicamente da pasta de destino — um futuro guard pode validar
`pasta ⇒ tipo` automaticamente.

---

## 8. PROPOSTA D — Plano de limpeza para a exúvia (sem big-bang)

Princípio operativo (de `reports/20260610-36-...`): **MOVER, nunca deletar;
conteúdo intacto, só o path muda; cada move gera linha no REGISTRY no mesmo
commit. ANTIGOS permanecem na pasta original do canônico para auditoria; os
NOVOS nascem na estrutura limpa da hbn-exuvia.**

**Ordem sugerida (cada passo = uma onda própria, com readback):**

1. **Corrigir AGENTS.md (zero-move, só verdade):** remover/ajustar ponteiros para `modules/` e `radar/` inexistentes (AGENTS.md:26,63,66,69,70). É a dívida de honestidade mais barata de pagar e desbloqueia o resto. (Onda T1, doc não-normativo.)
2. **Executar a faxina 36 (já desenhada):** mover os 7 `PROMPT_*_FABLE5.md` + os 4 `20260610-*-prompt-*.md` da raiz para `docs/prompts/` com id ADR-011; appendar linhas. (Onda T1.)
3. **Resolver duplicatas:** eleger `methodology/MATURITY-MATRIX.md` como única e marcar `docs/MATURITY-MATRIX.md` como `superseded_by` no REGISTRY (sem deletar); idem `ROADMAP.md` vs `docs/roadmap.md` (escolher um, apontar o outro).
4. **Consolidar brainstorm:** criar `INDEX.md` na `rodada-2026-06-17/`; mover os 6 avulsos de `docs/brainstorm/` para uma rodada ou `docs/brainstorm/avulsos/`; remover/registrar o probe `_cursor-audit-w3-probe.md`.
5. **Fixar schema do REGISTRY going-forward:** declarar 6 colunas (`+created_at`) como padrão único daqui pra frente (passado preservado).
6. **Migrar health files para `.github/`** (CONTRIBUTING, CODE_OF_CONDUCT, GOVERNANCE, MAINTAINERS, SECURITY, SUPPORT) — esvazia a raiz mantendo reconhecimento GitHub.
7. **Promover `core/` → `spec/`** OU manter `core/` e refletir isso em AGENTS.md — decisão humana; só depois dos passos baratos.
8. **Tornar a regra executável:** adicionar `guards/assert-no-stray-root.sh` espelhando `assert-no-stray-hbn.sh`, parametrizado pela allowlist da raiz (§5).

Cada onda respeita: nada de big-bang, nada de delete, cada move com linha no
REGISTRY no mesmo commit, e os arquivos antigos do canônico **permanecem onde
estão** — a hbn-exuvia é um repositório novo que importa só o limpo.

---

## 9. Síntese dos achados verificáveis

1. 30 arquivos soltos na raiz; ~8 justificados, ~12 devem migrar (`git ls-files | grep -v /`).
2. AGENTS.md promete `modules/` e `radar/` que não existem (`ls -d modules radar` → No such file) e chama `core/`/`docs/` de "legado" (AGENTS.md:69-70) enquanto `core/` segue normativa viva.
3. Duplicações: MATURITY-MATRIX (docs/ 117 linhas × methodology/ 112), ROADMAP (raiz × docs/), reports (raiz × .hbn/reports).
4. Brainstorm: padrão `rodada-AAAA-MM-DD/` bom mas com 6 avulsos soltos e `INDEX.md` ausente na rodada de 2026-06-17.
5. REGISTRY: livro-razão sólido (append-only, header going-forward, blocos por onda+readback) mas com deriva de 5→6 colunas a padronizar.
6. A faxina da raiz já foi desenhada (`reports/20260610-36-proposal-faxina-prompts-raiz.md`) e nunca executada — a exúvia é o momento de fechá-la.
