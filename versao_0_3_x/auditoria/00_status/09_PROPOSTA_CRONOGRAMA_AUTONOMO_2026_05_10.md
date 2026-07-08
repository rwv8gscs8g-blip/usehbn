---
titulo: 09 - Proposta de cronograma autônomo até release v0.3.0 publicável
diataxis: explanation
hbn-track: safe_track
hbn-status: proposed
audiencia: operador (ratificar) + IA (executar pós-aprovação)
versao-protocolo: useHBN pre-v1 → v0.3.0
data: 2026-05-10
autor: Claude Opus 4.7 (chat arquiteto-mestre useHBN)
escopo: cronograma de iterações sucessivas com delegação de autonomia para Opus arquiteto + execução cirúrgica via Codex CLI quando código é tocado
relacionado:
  - 05_CONSOLIDACAO_CROSS_IA_ADRS_2026_05_10.md
  - methodology/ADR-AND-MD-PRIMER.md
  - 7 ADRs ACCEPTED + 2 NÃO_RATIFICAR
  - docs/WAVE-PLAN-V0.3.0.md (plano original v0.3.0)
status-aprovacao: AGUARDANDO HEARBACK HUMANO
status: congelado
temperatura: glacier
---

# 09. Proposta de cronograma autônomo — útil para aprovação

> **Este documento é proposta, não plano executado.** Aguarda aprovação
> do operador. Após aprovação, segue execução autônoma até o protótipo
> funcional v0.3.0 testável, com gates humanos explícitos apenas em
> pontos de no-go (push, tag, publish).

## A. Sumário em uma página

**Objetivo final.** Entregar `useHBN v0.3.0 estável` como protótipo
funcional pronto para testes manuais + push para GitHub + TestPyPI
publish. Reduzir o protocolo de "forte parte de propostas verbais"
para "início de sistemas formais materializados em código".

**Estado atual real (2026-05-10).**
- 7 ADRs ACCEPTED (decisões prontas).
- 2 ADRs NÃO_RATIFICAR (precisam código antes de re-deposit).
- 11 MDs depositados, 8 concluídos (A/B/D/F/J/K) + 2 specs entregues sem patch (H/I) + 3 destravados sem execução (C/E/G).
- 90/90 testes pytest verdes (baseline OK).
- 5 arquivos modificados sem commit + 6 untracked (auditoria/, methodology/, etc. — todo o trabalho desta sessão é WIP local).

**Estratégia.** 4 fases, ~13 iterações. Cada iteração é um MD discreto
com gates explícitos. Pontos de no-go claramente demarcados (push,
tag, license header em massa). Pós-aprovação inicial, Opus executa em
sequência com relatórios de fim-de-iteração ao operador.

**Duração estimada.** Difícil precisar sem disparar; estimativa
otimista de 4-6 sessões agentic do operador (cada uma podendo cobrir
2-4 iterações). Pessimista: 8-10 sessões. Inclui esperas por testes
multi-OS + decisões humanas em gates.

## B. Princípios da delegação de autonomia

Esta proposta pede **autonomia delegada com gates de no-go**, alinhada
a P5 (Humano no controle por padrão) e P10 (Cross-IA obrigatório).

### B.1 O que Opus faz autonomamente após aprovação

- Aplicar ajustes em arquivos `.md` em `methodology/`, `docs/`,
  `auditoria/`, `core/` (renomeação para `modules/` parcial), `agents/`.
- Atualizar `INDEX.md`, `CHANGELOG.md`, `ROADMAP.md`, `MEMORY.md`.
- Compor MDs novos para Codex executar quando código for tocado.
- Rodar `pytest -q`, `hbn doctor`, `hbn version` para verificar
  baseline antes/depois de cada iteração.
- Atualizar memória persistente após cada iteração.
- Fazer commits locais em sequência atômica.
- Reportar fim de cada iteração (estado, próxima iteração, riscos
  detectados).

### B.2 O que Opus NÃO faz sem Hearback humano explícito

| Ação | Razão |
|---|---|
| `git push` para `origin/main` | release pública é decisão humana |
| `git push` para qualquer remote | mesma razão |
| `git tag` de release (ex.: `v0.3.0`) | tag é commitment público |
| Publicar em TestPyPI ou PyPI | publicação consumidora externa |
| Mudar `LICENSE` raiz | ato legal — exige confirmação |
| Aplicar headers AGPL → Apache em massa em `src/usehbn/*.py` | mudança em ~35 arquivos críticos — Codex CLI executa após Hearback explícito |
| `git push --force` qualquer | proibição absoluta (P6 — reversibilidade) |
| Tocar `~/Projetos/Credenciamento/**` | deny rules em settings.local.json |
| Mudança em P1-P13 (constituição) | exige 3 IAs + 3 Quartas (regra de cadência anual) |
| Adicionar dependência Python nova ao `pyproject.toml` | toca cadeia de produção (P11) |

### B.3 Mecânica do "fim de iteração"

Ao fechar cada iteração, Opus produz **relatório curto** (≤300 palavras) com:

- O que mudou (arquivos + sumário).
- Testes (baseline antes/depois).
- Riscos detectados durante a execução.
- Próxima iteração planejada.
- Sinal HBN apropriado (✅ / 🟡 / ❌ / 🔵).

Se Opus encontrar **bloqueador inesperado** (pré-requisito não
conhecido, conflito grave, dependência externa não declarada), **PARA**
e emite 🟡 HBN NEEDS HUMAN DECISION com proposta de resolução.

## C. Inventário de pendências (entrada)

### C.1 Estado git

```
Modificados (M):
  .gitignore
  .hbn/relay/INDEX.md
  README.md
  docs/PRINCIPLES.md
  docs/WAVE-PLAN-V0.3.0.md

Untracked (??):
  .gitignore.tmp                       # arquivo temporário órfão
  .hbn/relay/0008-architect-correcao-onda3.md
  .hbn/relay/0009-onda-3-relay-invariants.md
  auditoria/                            # toda a auditoria desta sessão (~10 docs)
  local-ai/                             # diretório novo (verificar conteúdo)
  methodology/                          # toda a methodology (PRINCIPIOS, adr/, templates/, primer)
```

Todo o trabalho de 2026-05-09 e 2026-05-10 é **WIP não commitado**.

### C.2 Estado dos ADRs

| ADR | Status | Próximo passo |
|---|---|---|
| 001, 002, 003, 005, 006, 007, 009 | ACCEPTED v1.1/v1.2 | execução em MDs |
| 004 | NÃO_RATIFICAR | MD-H aplicar patch → re-deposit |
| 008 | NÃO_RATIFICAR | MD-I implementar + Onda Documental + v204 final → re-deposit |

### C.3 Estado dos MDs

| MD | Status |
|---|---|
| A, B, D, F, J, K | concluído |
| C (AGENTS.md raiz) | destravado, sem execução |
| E (pré-Quarta) | destravado, sem execução |
| G (re-licenciamento Apache + DCO) | destravado, sem execução |
| H (patch versão) | spec entregue, sem execução |
| I (snapshot tooling) | spec entregue, sem execução |

### C.4 Itens externos do plano v0.3.0 ainda abertos (`docs/WAVE-PLAN-V0.3.0.md`)

| Onda original | Estado |
|---|---|
| Onda 3 (Relay Invariants em runtime) | bastão com architect desde 2026-04-29; readback em `.hbn/relay/0009-...` |
| Onda 4 (Connector Lifecycle Registry) | pendente |
| Onda 5 (Cleanup + state/ legacy) | pendente |
| Onda 6 (Vitrine + Release v0.3.0) | pendente |

## D. Critério "MVP sem risco"

**MVP** aqui significa: **release v0.3.0 estável publicável** com
todas as decisões cross-IA absorvidas, sem introduzir capacidade nova
não testada.

**Sem risco** significa:
- Tudo que já existe e funciona (90/90 testes verdes) **permanece**.
- Adições novas são **aditivas e advisory** (não bloqueantes em runtime).
- Nada de feature nova de produto entra em v0.3.0 — apenas hardening.
- Documentação alinhada com `MATURITY-MATRIX.md` (honestidade narrativa P10).
- Rollback testado em cada iteração via `git revert`.

**O que entra em v0.3.0:**
- 7 ADRs ACCEPTED materializados em código onde aplicável (006 sinais, 007 estrutura, 009 docs).
- MD-G re-licenciamento Apache 2.0 + DCO.
- MD-H patch versão (corrige bug, alinha 0.2.0 → 0.3.0).
- MD-C AGENTS.md raiz declarativo.
- Onda 3 Relay Invariants (path mismatch fix + audit_trail + baton_staleness).
- Onda 4 Connector Lifecycle Registry (sem enforcement).
- Onda 5 Cleanup + state/ dual-read.
- Onda 6 Vitrine site + README refresh.
- Validação pós-implementação documentada.

**O que NÃO entra em v0.3.0:**
- ADR-008 execução (snapshot tooling): entra em v0.4.0 ou v0.3.1 (depende de v204 final).
- ADR-001 execução (Quarta de Sanitização ritual): entra após v204 + Quarta 0 inaugural.
- `hbn doctor --health` implementado (ADR-007): entra em v0.4.0.
- Onda Documental Sanitization (matriz MD-K): pós-v204.
- Reescrita de runtime em Rust (P12): plurianual via Phagocytosis.
- 5+ sinais multi-repo (ADR-006) implementados em runtime.py: parcial em v0.3.0 (estrutura), completo em v0.4.0.

## E. Cronograma proposto — 4 fases, 13 iterações

### Fase 1 — Limpeza & estabilização do estado atual (Iterações 1-3)

#### Iteração 1 — Commit do trabalho WIP em série atômica

**Tipo:** execução documental.
**Output:** ~6 commits atômicos em sequência:
1. `chore(legacy): mark docs/PRINCIPLES.md as superseded by methodology/PRINCIPIOS-CONSTITUCIONAIS.md`
2. `feat(methodology): add PRINCIPIOS-CONSTITUCIONAIS, ADR-and-MD primer, templates`
3. `feat(adr): deposit ADR-001 to ADR-009 + cross-IA results + consolidation`
4. `chore(auditoria): add bootstrap, addendum, cross-IA prompts, MD-H/MD-I/MD-K specs`
5. `chore(relay): update .hbn/relay/INDEX.md with current bastão state`
6. `chore: update .gitignore (remove .gitignore.tmp orphan; verify local-ai/)`

**Gate:** `pytest -q` 90/90 antes e depois de cada commit.
**No-go:** sem push para origin (operador autoriza no final).
**Rollback:** `git reset --soft HEAD~6` se for preciso desfazer série inteira.
**Estimativa:** 1 sessão.

#### Iteração 2 — MD-H aplicado em código (resolução de versão)

**Tipo:** patch de código (Opus arquiteto compõe MD detalhado; Codex
CLI executa em sessão dedicada).
**Output:**
- `src/usehbn/__init__.py`: bumpa `__version__` 0.2.0 → 0.3.0; mantém `PROTOCOL_VERSION = "0.3.0"`; adiciona `PACKAGE_VERSION = __version__`; exporta em `__all__`.
- `setup.cfg`: `version = 0.3.0`.
- `pyproject.toml`: adiciona `[project]` com `name`, `version`, `license`, `requires-python`.
- `src/usehbn/cli.py:1079-1084`: corrige bug — `protocol_version` em records usa `PROTOCOL_VERSION`, não `__version__`. `hbn version` imprime ambos: `usehbn package 0.3.0 (protocol 0.3.0)`.
- 2 testes novos em `tests/`.

**Gate:** `pytest -q` ≥ 92/92 (90 antigos + 2 novos).
**No-go:** sem mudança de licença ainda (essa é Iteração 3).
**Rollback:** `git revert <sha>`.
**Pós-iteração:** ADR-004 reescrito v2 absorvendo decisão; cross-IA leve por 1 IA confirma; promove para `ACCEPTED`.
**Estimativa:** 1 sessão (Codex faz patch; Opus revisa + atualiza ADR).

#### Iteração 3 — MD-G executado (Apache 2.0 + DCO)

**Tipo:** mudança de licença em massa (operação delicada).
**Pré-requisito:** Hearback humano explícito antes de iniciar (mesmo
estando dentro do cronograma aprovado — esta é uma operação de
~35 arquivos com implicação legal). **Esta iteração tem gate humano
intermediário** mesmo após aprovação inicial do cronograma.
**Output:**
- `LICENSE`: substitui texto AGPLv3 por texto completo Apache 2.0.
- `setup.cfg`/`pyproject.toml`: campo `license = "Apache-2.0"`.
- `README.md`: seção License atualizada.
- `CONTRIBUTING.md`: seção DCO adicionada (fase 1 — texto, sem CI enforcement).
- Headers em `src/usehbn/*.py`: AGPLv3 → Apache 2.0 (todos os arquivos atingidos por `rg -l 'AGPL|Affero'`).
- `docs/LICENSING.md`: atualizado.
- `MATURITY-MATRIX.md`: linha sobre licença atualizada.
- 1 commit atômico ou série revertível em bloco.

**Gate:** `pytest -q` 92/92 + `rg 'AGPL|Affero'` retorna 0 hits em código de produção (refs históricas em CHANGELOG e auditoria/ podem permanecer).
**No-go:** sem push após — espera Iteração 12.
**Rollback:** `git revert <sha-único>` reverte em bloco.
**Estimativa:** 1 sessão (Codex executa em rg + sed + commit).

### Fase 2 — Hardening pendente da Onda 3 (Iterações 4-5)

#### Iteração 4 — MD-C executado (AGENTS.md raiz do useHBN)

**Tipo:** documento novo + reorganização menor.
**Output:**
- `AGENTS.md` raiz criado com:
  - Identidade do projeto (Founding Application + Consuming Application convenção — ADR-002).
  - Lista doutrinária P1-P13 referenciada (link para `methodology/PRINCIPIOS-CONSTITUCIONAIS.md`).
  - Stack do projeto.
  - Ponteiros para `agents/agents.md`, `agents/claude.md`, `agents/codex.md`, `agents/safety.md`, `agents/wave-protocol.md`.
  - Seção `useHBN-version` com formato proposto (declarativo).
  - 3-5 sinais HBN principais como referência rápida.
- `agents/agents.md` atualizado com referência cruzada para `AGENTS.md` raiz.

**Gate:** `pytest -q` 92/92.
**Rollback:** `git revert <sha>`.
**Estimativa:** 1 sessão (Opus arquiteto executa).

#### Iteração 5 — Onda 3 Relay Invariants em runtime

**Tipo:** patch de código (existe iteração 0008/0009 desde 2026-04-29
com bastão de architect; absorvo agora). Compor MD detalhado para
Codex executar.
**Output:**
- `src/usehbn/cli.py`: `_find_pending_readbacks` lê **ambos** `.hbn/readbacks/` e `.usehbn/readbacks/` com dedup por `execution_id` (path mismatch fix).
- `src/usehbn/cli.py`: `audit_trail` (lista de últimas 10 transições) em `.hbn/relay/state.json`.
- `src/usehbn/cli.py`: `baton_staleness_seconds` opcional (advisory).
- 7 testes novos conforme `0009-onda-3-relay-invariants.md`.

**Gate:** `pytest -q` ≥ 99/99 (92 antigos + 7 novos).
**Rollback:** `git revert <sha>`.
**Pós-iteração:** `MATURITY-MATRIX.md` linha "Relay" e "Baton" passam de `Parcial` → `Parcial honesto` (com lacunas restantes documentadas).
**Estimativa:** 1-2 sessões (Codex executa).

### Fase 3 — Implementação dos ADRs ACCEPTED em código (Iterações 6-9)

#### Iteração 6 — ADR-006 sinais multi-repo em runtime adapters

**Tipo:** patch de código aditivo.
**Output:**
- `src/usehbn/runtime.py`: `HBN_STATUS_MARKERS` expandido de 3 → 16 marcadores (10 originais + 6 multi-repo: 🌐 ⛓️ 🧊 🪞 ⏳ 🔍).
- `src/usehbn/runtime.py:_adapter_body`: adapters injetam os 16 nos 7 runtime targets.
- `core/protocol.md`: lista 16 sinais.
- `agents/wave-protocol.md`: seção nova "Sinais multi-repo".
- `src/usehbn/cli.py`: `hbn init` cria `.hbn/meta/` para `signals-log.jsonl`.
- 1 teste novo: `test_runtime_adapter_includes_16_markers`.

**Gate:** `pytest -q` ≥ 100/100.
**Rollback:** `git revert <sha>`.
**Estimativa:** 1 sessão.

#### Iteração 7 — Onda 4 Connector Lifecycle Registry (sem enforcement)

**Tipo:** patch de código aditivo (do plano v0.3.0 original).
**Output:**
- Campo `lifecycle_state` em `.hbn/connectors/registry.json`.
- Estados `detected/resolved/installed/verified/active/revoked` documentados (sem FSM).
- Leitura tolerante a ausência (default `"detected"`).
- 2 testes novos.

**Gate:** `pytest -q` ≥ 102/102.
**Rollback:** `git revert <sha>`.
**Estimativa:** 1 sessão.

#### Iteração 8 — Onda 5 Cleanup + state/ legacy migration path

**Tipo:** higiene + dual-read.
**Output:**
- `CHANGELOG.md`: dual-header `## Unreleased` resolvido.
- `README.md` "Current Status": atualizado para refletir v0.3.0 (não 0.2.x).
- `src/usehbn/state/store.py`: dual-read (lê de `.usehbn/` e `state/` se existirem; escreve apenas em `.usehbn/`).
- 2 testes novos em `tests/test_state_dual_read.py`.

**Gate:** `pytest -q` ≥ 104/104.
**Rollback:** `git revert <sha>`.
**Estimativa:** 1 sessão.

#### Iteração 9 — MATURITY-MATRIX update + atualizações dependentes

**Tipo:** documentação canônica de honestidade.
**Output:**
- `MATURITY-MATRIX.md` atualiza promoções: Relay/Baton (Parcial → Parcial honesto), Connectors lifecycle (Visão → Scaffold), State (Parcial → Parcial com dual-read), etc.
- `README.md:13` aponta tanto `MATURITY-MATRIX.md` quanto `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (ajuste ADR-009).
- `methodology/MATURITY-MATRIX.md` migrado de `docs/` (decisão ADR-003).
- `docs/MATURITY-MATRIX.md` recebe banner SUPERSEDED + redirect.

**Gate:** `pytest -q` 104/104.
**Rollback:** `git revert <sha>`.
**Estimativa:** 1 sessão.

### Fase 4 — Vitrine, release e validação pós-implementação (Iterações 10-13)

#### Iteração 10 — Site refresh (`site/index.html`)

**Tipo:** vitrine pública.
**Output:**
- Hero com tagline + subtagline v0.3.0 Honest Foundation.
- Seção "Maturity Matrix" visual (3 colunas: Today / Partial / Vision).
- Seção "Phagocytosis" com diagrama horizontal Routed → Studied → Digested → Mastered → Contributed.
- Seção "13 Principles" linkando para `methodology/PRINCIPIOS-CONSTITUCIONAIS.md`.
- Footer com governance + Apache 2.0.
- Meta Open Graph + Twitter cards.

**Gate:** rendering OK em Chrome/Firefox/Safari (verificação manual humana — recomenda Iteração 11 antes de declarar fechado).
**No-go:** sem push para `origin/gh-pages` (humano decide).
**Rollback:** `git revert <sha>`.
**Estimativa:** 1-2 sessões.

#### Iteração 11 — README refresh (topo)

**Tipo:** vitrine textual.
**Output:**
- Topo do `README.md` reorganizado: tagline + quickstart 60s + badges (Apache 2.0, Python 3.9+, Tests passing 104, Status: alpha).
- Seções "Founding Application" e "Why HBN" alinhadas com ADR-002.
- Frase didática Antigravity: "O Credenciamento foi a fundição onde o HBN foi forjado; hoje, é apenas seu primeiro consumidor."

**Gate:** README renderiza OK no GitHub (verificação manual humana antes do push).
**Rollback:** `git revert <sha>`.
**Estimativa:** 1 sessão.

#### Iteração 12 — Release prep v0.3.0

**Tipo:** preparação de release.
**Output:**
- `pyproject.toml`/`setup.cfg`/`__init__.py` confirmam `0.3.0`.
- `CHANGELOG.md` entrada `v0.3.0` com sumário das 11 iterações anteriores.
- Smoke test local: `pip install -e .`, `hbn version`, `hbn quickstart`, `hbn doctor`.
- Build sdist + wheel: `python -m build` (se houver `build` instalado, senão usar setuptools direto).
- Smoke test do build: `pip install dist/usehbn-0.3.0.tar.gz` em sandbox.
- Tag local **NÃO criada** ainda (gate humano).
- TestPyPI publish **NÃO feito** ainda (gate humano).

**Gate:** todos os smoke tests OK; `pytest -q` 104/104; `hbn doctor` clean.
**No-go até Hearback humano:** `git tag v0.3.0`, `twine upload --repository testpypi`, `git push`.
**Rollback:** `git revert` da entrada do CHANGELOG; bumps de versão revertidos.
**Estimativa:** 1 sessão.

#### Iteração 13 — Validação pós-implementação

**Tipo:** documentação de teste/validação.
**Output:**
- `auditoria/post-implementation/v0.3.0-validation.md` com:
  - Checklist de capacidades (alinhada com MATURITY-MATRIX).
  - Resultado de smoke test em mac (linux/windows ficam para humano executar).
  - Verificação de `hbn quickstart`, `hbn doctor`, `hbn install --runtime claude-code`, `hbn translate`, `hbn relay status`, `hbn handoff`, `hbn readback`, `hbn hearback --last`, `hbn result`, `hbn refresh`, `hbn inspect`, `hbn run`, `hbn version`.
  - 7 runtime adapters gerados e validados.
  - Output de `pytest -q` final.
  - Checksums de `dist/*` para reprodutibilidade.
- Relatório final de cronograma: o que foi entregue, o que ficou para v0.3.1 ou v0.4.0.

**Gate:** humano lê e ratifica a validação. Se OK → tag + publish + push (Hearback explícito por ação).
**Estimativa:** 1 sessão.

## F. Pontos de no-go consolidados

Mesmo dentro do cronograma aprovado, Opus PARA e pede Hearback humano antes de:

1. Iteração 1 → push para `origin/main` (operador autoriza no final).
2. Iteração 3 → início da troca de licença em massa (segundo Hearback explícito mesmo dentro do cronograma).
3. Iteração 12 → smoke test 3 OS (humano executa em Linux e Windows).
4. Iteração 13 → tag `v0.3.0` + TestPyPI publish + push para `origin/main`.
5. Em qualquer iteração: bloqueador inesperado, dependência externa nova, conflito grave em runtime.

## G. Métricas de saúde do cronograma

Aplicação preview de ADR-007 ao próprio cronograma:

- `total_docs_canonicos` ao final esperado: estável (Onda Documental Sanitization fica para pós-v0.3.0).
- `adrs_ativos` ao final esperado: 9 (atual) + ADR-004 v2 ratificado pós-Iteração 2 = 10. Plus-1 talvez para ADR-010 documentando a delegação autônoma deste cronograma.
- `quartas_sem_merge_consecutivas`: n/a (Quartas começam pós-v204 final).
- `cross_ia_divergencia_pct`: medida no próximo ciclo cross-IA (não neste cronograma).
- Testes: 90 → 104 esperado (+14 testes novos ao longo das iterações).

## H. Riscos do cronograma

| # | Risco | Mitigação |
|---|---|---|
| R1 | Codex CLI indisponível para iterações que exigem patch (2, 3, 5, 6, 7) | Opus arquiteto compõe MDs detalhados — Codex pode executar assíncrono em qualquer sessão futura |
| R2 | Iteração 3 (re-licenciamento) falhar em algum header de arquivo edge case | `hbn doctor` check `license_consistency` (proposto em ADR-005) detecta; rollback `git revert` é simples |
| R3 | Smoke test em Linux/Windows revelar regressão | Iteração 13 explicitamente marca isso como gate humano antes de publish |
| R4 | Operador interromper o cronograma a qualquer momento (mudança de prioridade) | Cronograma é série de MDs independentes; cada um termina antes do próximo começar; interrupção não corrompe estado |
| R5 | Bug detectado em `cli.py` durante MD-H pode escalar | Iteração 2 isolada do resto; testes novos cobrem; rollback simples |
| R6 | Conflito entre Iteração 6 (sinais) e runtime adapter cache de instalações antigas | `hbn refresh` força regeneração; documentar em CHANGELOG |
| R7 | Site refresh (Iteração 10) introduzir afirmação supra-MATURITY | Validação cruzada Opus revisa antes de declarar fechado; auditoria contra MATURITY-MATRIX é gate |

## I. O que esta proposta NÃO promete

- Não promete v0.3.1 (que segue para PyPI estável após validação humana de TestPyPI).
- Não promete v0.4.0 (que inclui ADR-008 + ADR-001 ritual + `hbn doctor --health` operacional).
- Não promete reescrita em Rust (P12 — plurianual via Phagocytosis).
- Não promete migração documental do `Credenciamento/usehbn/` (Onda Documental Sanitization, pós-v204).
- Não promete Quarta 0 inaugural (pós-v204 final).
- Não promete adoção pública (esta é a primeira release; adoção é trabalho posterior).

## J. Decisão pedida ao operador

Aprovar (sim/não/com ajustes):

1) **Aprovar o cronograma de 4 fases / 13 iterações como descrito** —
   ou pedir alteração de escopo, ordem, ou granularidade?

2) **Confirmar a delegação de autonomia descrita em §B** — Opus
   executa autonomamente as iterações 1 a 13 (com gates de no-go em
   §F), reportando ao fim de cada iteração? Ou prefere Hearback a
   cada iteração?

3) **Iteração 1 (commit do WIP) é OK começar imediatamente após
   aprovação?** Significa ~6 commits locais sem push. Push fica para
   Iteração 13.

4) **Iteração 3 (re-licenciamento) precisa de Hearback adicional
   antes de iniciar mesmo com aprovação geral do cronograma?** —
   Recomendação Opus: SIM, porque toca LICENSE e ~35 arquivos.
   Operador confirma ou ajusta.

5) **Algum ponto de no-go a adicionar** (§F) ou remover?

## K. Versão

- v1.0 — 2026-05-10 — Opus 4.7 chat arquiteto-mestre — proposta inicial. Aguarda Hearback humano. Status: PROPOSED. Sem nenhuma execução iniciada — este documento é apenas plano.
