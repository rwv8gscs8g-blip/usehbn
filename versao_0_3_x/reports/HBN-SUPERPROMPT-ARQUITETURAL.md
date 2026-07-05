# HBN — Análise Arquitetural de Maturidade e Superprompt de Implementação

**Data:** 2026-03-30
**Baseline verificado:** 21 testes passando, pipeline completo operacional
**Referências externas analisadas:** GSD (get-shit-done), OpenClaw
**Autor:** Claude Opus 4.6 (Arquiteto Principal)

---

## 1. FUNDAMENTAÇÃO DA REJEIÇÃO

O prompt anterior não é rejeitado por ser errado — é rejeitado por ser insuficiente. Ele identificou corretamente os 3 gaps (readback incompleto, ausência de `hbn init`, documentação defasada), mas tratou o problema como uma sequência de correções pontuais quando o problema real é de **maturidade sistêmica**.

Deficiências específicas do prompt anterior:

**D1 — Não formalizou uma estrutura de projeto estável.** O repositório hoje tem 8 arquivos `.md` na raiz que são relatórios de auditoria (HBN-EVOLUTION-ANALYSIS.md, HBN-ERP-HARDENING-AUDIT.md, etc.), misturados com documentação real (README.md, ROADMAP.md). Não existe separação entre documentação do protocolo, relatórios de desenvolvimento, e artefatos operacionais.

**D2 — Não tratou comunicação inter-IAs.** O HBN foi desenvolvido por Claude Opus, Codex, e possivelmente GPT em sequência, mas não existe nenhum mecanismo para que uma IA saiba o que a outra fez, decidiu, ou deixou pendente. Cada sessão começa do zero.

**D3 — Não definiu homologação.** Não existe critério formal para dizer "esta versão está pronta". Os testes passam, mas não há staging, não há checklist de release, não há política de versionamento.

**D4 — Não incorporou lições de sistemas reais.** O GSD demonstra que artefatos fixos no filesystem (`PROJECT.md`, `STATE.md`, `REQUIREMENTS.md`) são suficientes para manter continuidade entre sessões e agentes — sem banco de dados, sem API, sem complexidade. O OpenClaw demonstra que abstração de canal permite operar em qualquer plataforma. O HBN não aproveita nenhuma dessas lições.

**D5 — Não tratou o HBN como auto-alimentável.** O protocolo que exige readback/hearback/ERP para outros sistemas não usa esses mecanismos para seu próprio desenvolvimento.

---

## 2. AUDITORIA DE MATURIDADE

### 2.1 O Que Existe Hoje (Inventário Verificado)

| Componente | Arquivos | Testes | Estado |
|-----------|---------|--------|--------|
| Trigger (ativação semântica) | trigger.py | 3 | Funcional |
| Intent (estruturação) | protocol/intent.py | 2 | Funcional, heurístico |
| Truth Barrier | protocol/truth_barrier.py | 0 diretos | Funcional |
| Guardian | protocol/guardian.py | 0 diretos | Funcional |
| Consent | protocol/consent.py | 1 | Funcional |
| Readback | protocol/readback.py | 4 | Gate funcional, **sem conteúdo semântico** |
| ERP (Result) | protocol/result.py | 8 | Funcional, hardened |
| Execution Engine | execution/engine.py | 2 | Funcional |
| State Store | state/store.py | via outros | Funcional |
| Validators | utils/validators.py | via outros | Funcional, maxLength suportado |
| CLI | cli.py | via outros | Funcional, 3 subcomandos |
| Schemas | 5 arquivos JSON | validados | Corretos |

**Total: 21 testes, 12 módulos Python, 5 schemas, 4 contratos de agente.**

### 2.2 Classificação de Maturidade

| Nível | Descrição | Onde o HBN está |
|-------|-----------|----------------|
| **L0** — Conceito | Documentação sem código | Superado |
| **L1** — Protótipo | Código funcional sem disciplina | Superado |
| **L2** — Scaffold estruturado | Código + schemas + testes básicos | **← AQUI** |
| **L3** — Sistema operável | Instalável, inicializável, documentado honestamente | Próximo passo |
| **L4** — Sistema distribuível | PyPI, multi-runtime, cross-platform | Fase 2 |
| **L5** — Plataforma | Multi-agente, SaaS, marketplace | Futuro |

### 2.3 O Que Falta para L3

1. **Entry point `hbn`** — Não existe. Apenas `usehbn`.
2. **Comando `hbn init`** — Não existe. O protocolo não pode ser aplicado a repositórios externos.
3. **Readback semântico** — Campos `understanding`, `invariants_preserved`, `action_plan` ausentes.
4. **Documentação atualizada** — README não reflete o estado real do código.
5. **Árvore de projeto limpa** — Relatórios de auditoria misturados com documentação.
6. **Comunicação inter-IAs** — Nenhum mecanismo.
7. **Política de versionamento** — Inexistente formalmente.

---

## 3. TRÊS ÁRVORES DE ARQUITETURA

### 3.A — Árvore Estável (o que deve existir na v1)

```
hbn/
├── src/hbn/                    # Runtime Python (renomear de usehbn)
│   ├── __init__.py
│   ├── cli.py                  # Entry point principal
│   ├── trigger.py              # Detecção semântica
│   ├── protocol/
│   │   ├── intent.py           # Estruturação de intent
│   │   ├── consent.py          # CCP
│   │   ├── truth_barrier.py    # Qualidade de claims
│   │   ├── guardian.py         # Completude de validação
│   │   ├── readback.py         # Contrato pré-execução
│   │   └── result.py           # ERP
│   ├── execution/
│   │   └── engine.py           # Orquestrador do pipeline
│   ├── state/
│   │   └── store.py            # Persistência JSON
│   └── utils/
│       ├── config.py
│       ├── logger.py
│       ├── time.py
│       └── validators.py
├── schemas/                    # Contratos de dados
│   ├── intent.schema.json
│   ├── consent.schema.json
│   ├── guardian.schema.json
│   ├── readback.schema.json
│   └── result.schema.json
├── core/                       # Especificação do protocolo
│   ├── protocol.md
│   ├── command-spec.md
│   ├── validation-rules.md
│   └── readback-spec.md
├── agents/                     # Contratos de agente
│   ├── agents.md
│   ├── codex.md
│   ├── claude.md
│   └── safety.md
├── tests/                      # Validação
├── README.md
├── LICENSE
├── CHANGELOG.md
├── setup.cfg (ou pyproject.toml)
└── setup.py
```

**O que NÃO entra na árvore estável:**
- Relatórios de auditoria (HBN-*.md)
- Reports de implementação (REPORT-*.md)
- Site estático (site/)
- Bridge conceitual (bridge/vba.py)
- Documentação de visão expandida (docs/ inteiro)

### 3.B — Árvore de Testes/Homologação

```
tests/
├── unit/                       # Testes unitários por módulo
│   ├── test_trigger.py
│   ├── test_intent.py
│   ├── test_consent.py
│   ├── test_truth_barrier.py
│   ├── test_guardian.py
│   ├── test_readback.py
│   ├── test_result.py
│   └── test_validators.py
├── integration/                # Testes de pipeline completo
│   ├── test_full_pipeline.py   # Intent → readback → hearback → ERP
│   ├── test_cli_commands.py    # Testes end-to-end do CLI
│   └── test_init.py            # hbn init em diferentes cenários
├── regression/                 # Testes de regressão específicos
│   └── test_hardening.py       # Guards de duplicação, overwrite, etc.
└── fixtures/                   # Dados de teste reutilizáveis
    ├── sample_intents.json
    └── sample_readbacks.json
```

### 3.C — Árvore Avançada/Evolutiva

```
hbn/
├── docs/                       # Documentação expandida
│   ├── architecture.md
│   ├── vision.md
│   ├── principles.md
│   ├── roadmap.md
│   ├── legacy/                 # Guias para sistemas legados
│   │   ├── vba-guide.md
│   │   └── monolith-guide.md
│   └── inter-ai/               # Protocolo inter-IAs
│       └── communication-spec.md
├── .hbn/                       # Meta: HBN usando HBN
│   ├── manifest.json
│   ├── state.json
│   ├── relay/                  # Comunicação inter-IAs (ativa)
│   │   └── 0001-*.md
│   ├── relay-archive/          # Histórico resolvido
│   └── knowledge/              # Descobertas reutilizáveis
│       └── index.md
├── contrib/                    # Extensões futuras
│   ├── runtimes/               # Adaptadores para Claude Code, Codex, etc.
│   ├── skills/                 # Skills instaláveis (formato GSD)
│   └── bridges/                # Bridges para sistemas legados
├── site/                       # Landing page
├── examples/                   # Exemplos de uso
└── reports/                    # Relatórios de auditoria e implementação
    ├── HBN-EVOLUTION-ANALYSIS.md
    ├── HBN-ERP-HARDENING-AUDIT.md
    └── ...
```

### Relacionamento Entre Árvores

- **Estável** é o pacote publicável. Tudo que entra aqui está testado e homologado.
- **Testes** valida a estável. Nada entra na estável sem teste correspondente.
- **Avançada** é o workspace de evolução. Pode conter código experimental, mas nunca contamina a estável sem passar pela homologação.

**Para v1:** Implementar a árvore estável completa + mover testes existentes para a estrutura de testes. A árvore avançada começa com `.hbn/relay/` e `reports/`.

---

## 4. DISTRIBUIÇÃO E BOOTSTRAP

### 4.1 Modelo de 3 Camadas

| Camada | Nome | Tipo | Quando |
|--------|------|------|--------|
| Bootstrap | `get-hbn` | Script de instalação | Fase 2 |
| Runtime | `hbn` | CLI operacional | **v1** |
| Linguagem | `usehbn` / `use hbn` | Trigger semântico | Já existe |

**Decisão para v1:** O entry point primário é `hbn`. O `usehbn` continua como alias. O `get-hbn` é fase 2.

### 4.2 Estratégia de Distribuição

**v1 — Mínimo funcional:**
```bash
pip install hbn          # ou pip install -e . (desenvolvimento)
hbn version              # verifica instalação
hbn init                 # inicializa no diretório atual
hbn run "use hbn ..."    # executa pipeline
```

**v1.1 — Melhorada:**
```bash
pipx install hbn         # instalação isolada
```

**v2 — Multi-runtime (inspirado no GSD):**
```bash
npx get-hbn@latest       # ou equivalente Python
# Pergunta: instalar para Claude Code, Codex, Copilot, Cursor?
# Instala prompts/skills específicos por runtime
```

### 4.3 Compatibilidade Multi-Runtime (Lição do GSD)

O GSD resolve o problema de multi-runtime com **prompts como artefatos de filesystem**. Cada runtime (Claude Code, Codex, Copilot) tem um diretório de configuração diferente, mas os prompts são os mesmos. O instalador copia o prompt correto para o local correto.

HBN deve adotar a mesma estratégia na fase 2:
- `.claude/commands/hbn.md` para Claude Code
- `skills/hbn/SKILL.md` para Codex
- `.github/copilot-instructions.md` para Copilot
- `.cursor/rules/hbn.mdc` para Cursor

O conteúdo é o mesmo: instruções para que o agente use o protocolo HBN. A diferença é apenas o local e formato do arquivo.

### 4.4 Respostas Diretas

1. **Forma mais robusta de começar:** `pip install hbn` (PyPI). Sem shell scripts, sem curl|bash, sem dependência de npm.
2. **Linux primeiro?** Sim, mas o código já é Python puro e cross-platform. Basta testar Windows.
3. **Como evitar Linux-only?** Usar `pathlib` (já usa), não assumir bash no runtime, testar CI em Windows.
4. **Menor fluxo zero-to-working:** `pip install hbn && hbn init && hbn run "use hbn analyze this"`.
5. **Instalação local → skill/plugin:** Na fase 2, `hbn` gera os arquivos de integração para cada runtime via `hbn install --runtime claude-code`.

---

## 5. HBN NO PASSADO, PRESENTE E FUTURO

### 5.A — Presente

O que deve acontecer quando um usuário roda `hbn init` num repositório:

1. Cria `.hbn/manifest.json` com metadados (versão do protocolo, data, tipo de sistema detectado)
2. Cria `.hbn/state.json` vazio (estrutura padrão)
3. Cria `.hbn/readbacks/` e `.hbn/results/` vazios
4. Detecta tipo de sistema (git? Python? Node? genérico?)
5. Imprime confirmação

A partir daí, `hbn run "..."` opera sobre o `.hbn/` local, persistindo estado ali.

### 5.B — Passado/Legado

Para um sistema VBA de 2005 sem testes:

```bash
cd /caminho/para/planilhas/
hbn init                          # Cria .hbn/
hbn run "use hbn inventory this VBA system"
# → Intent estruturado: objetivo "inventory this VBA system"
# → Guardian: warn (sem validation_requirements para sistema complexo)
# → Track: safe_track

hbn readback exec-001 \
  --agent-id claude \
  --understanding "Sistema com 12 módulos VBA, 3 UserForms, events em Sheet1-Sheet5" \
  --invariant "Nenhum módulo será modificado nesta fase" \
  --invariant "Nenhuma macro será executada" \
  --plan-step "Listar todos os módulos e suas dependências" \
  --plan-step "Mapear event handlers por sheet" \
  --plan-step "Identificar named ranges em uso"

hbn hearback exec-001 --status confirmed
# Agora o inventário pode ser executado

hbn result exec-001 \
  --agent-id claude \
  --action "Inventário completo: 12 módulos, 47 subs, 3 forms, 23 named ranges" \
  --outcome executed \
  --human-status approved \
  --readback-id readback-exec-001
```

Este fluxo cria um inventário rastreável sem tocar no sistema legado.

### 5.C — Futuro

**Fase 2 — Multi-runtime:** `hbn install --runtime claude-code` gera `.claude/commands/hbn-run.md` com instruções para o Claude Code usar o protocolo.

**Fase 3 — Multi-agente:** Agentes registram-se via `.hbn/agents/` com identidade e capacidades. O relay (`relay/`) coordena tarefas entre agentes.

**Fase 4 — SaaS opcional:** API sobre o `.hbn/` local. Dashboard de rastreabilidade. Nenhuma funcionalidade core depende do SaaS.

---

## 6. PROTOCOLO DE COMUNICAÇÃO INTER-IAs

### 6.1 Arquitetura

```
.hbn/
├── relay/                      # Zona ativa de coordenação
│   ├── INDEX.md                # Estado atual: quem tem o bastão, pendências
│   ├── 0001-init-erp.md        # Iteração 1
│   ├── 0002-hardening.md       # Iteração 2
│   └── 0003-readback-v2.md     # Iteração 3 (ativa)
├── relay-archive/              # Iterações resolvidas
│   ├── 0001-init-erp.md
│   └── 0002-hardening.md
└── knowledge/                  # Descobertas reutilizáveis
    ├── INDEX.md                # Índice por tema/tecnologia
    ├── python-pathlib-gotchas.md
    ├── json-schema-maxlength.md
    └── vba-event-handler-mapping.md
```

### 6.2 Convenções

**Nomenclatura:**
```
NNNN-assunto-em-kebab-case.md
```
Numeração sequencial. Nunca reusar números. Gaps são aceitáveis (0001, 0002, 0005).

**Estrutura de cada arquivo de relay:**

```markdown
# NNNN — Título da Iteração

**Bastão:** claude-opus | codex | gpt-4 | humano
**Estado:** ativo | pendente-humano | resolvido
**Criado:** 2026-03-30T01:00:00Z
**Atualizado:** 2026-03-30T02:00:00Z

## Contexto Recebido
O que esta IA recebeu como ponto de partida.

## O Que Foi Feito
Lista concreta de ações executadas.

## O Que Foi Alterado
Arquivos criados, modificados, deletados.

## Próximo Passo
O que a próxima IA (ou humano) deve fazer.

## Pendências
O que ficou sem resolver e por quê.

## Riscos
O que pode dar errado.

## Decisões Tomadas
Decisões que afetam o futuro do sistema.
```

**Convenção de bastão:**
- Apenas UMA entidade tem o bastão por vez
- O `INDEX.md` registra quem tem o bastão
- Ao finalizar, a IA atualiza o INDEX e passa o bastão
- Se uma IA lê o relay e o bastão não é dela, ela lê mas não modifica

**Convenção de encerramento de ciclo:**
1. A IA que finaliza marca o estado como "resolvido"
2. Move o arquivo para `relay-archive/`
3. Atualiza `INDEX.md`
4. Se houve descobertas reutilizáveis, cria entrada em `knowledge/`
5. Deixa apenas o `INDEX.md` e iterações ativas em `relay/`

**Convenção de compactação:**
- Quando `relay/` tem mais de 5 arquivos ativos, a IA deve consolidar os resolvidos
- A compactação move resolvidos para `relay-archive/` e atualiza o INDEX
- O INDEX nunca excede 50 linhas (forçar concisão)

### 6.3 INDEX.md (Template)

```markdown
# HBN Relay — Estado Atual

**Bastão atual:** claude-opus
**Última atualização:** 2026-03-30T02:00:00Z

## Iterações Ativas
| # | Assunto | Estado | Bastão |
|---|---------|--------|--------|
| 0003 | readback-v2 | ativo | claude-opus |

## Pendências Globais
- Readback semântico: campos understanding/invariants não implementados
- Entry point `hbn` não registrado

## Próxima Ação
Completar readback semântico (schema + module + tests)
```

### 6.4 Economia de Tokens

A estrutura é projetada para que uma IA nova:
1. Leia `INDEX.md` (~50 linhas, ~200 tokens)
2. Leia apenas a iteração ativa (~100 linhas, ~400 tokens)
3. Saiba exatamente o que fazer sem ler todo o histórico

Se precisar de contexto profundo, lê os arquivos de `knowledge/`. Se precisar do histórico completo, lê `relay-archive/`. Mas o caminho padrão é: INDEX → iteração ativa → executar.

---

## 7. MEMÓRIA COLETIVA E PEDRA DE ROSETA

### 7.1 Estrutura

```
.hbn/knowledge/
├── INDEX.md                    # Índice mestre
├── by-tech/
│   ├── python.md              # Descobertas sobre Python no HBN
│   ├── json-schema.md         # Padrões e gotchas de JSON Schema
│   └── vba.md                 # Conhecimento sobre sistemas VBA
├── by-pattern/
│   ├── duplicate-guard.md     # Padrão de proteção contra duplicação
│   ├── timestamp-standard.md  # Padrão de timestamp Z-suffix
│   └── schema-validation.md   # Como funciona a validação customizada
└── by-decision/
    ├── why-agplv3.md          # Por que AGPLv3
    ├── why-no-external-deps.md # Por que zero dependências externas
    └── why-local-only.md      # Por que processamento local
```

### 7.2 INDEX.md de Knowledge

```markdown
# HBN Knowledge Base

## Por Tecnologia
| Tema | Arquivo | Última atualização |
|------|---------|-------------------|
| Python pathlib | by-tech/python.md | 2026-03-30 |
| JSON Schema | by-tech/json-schema.md | 2026-03-30 |

## Por Padrão
| Padrão | Arquivo | Onde é usado |
|--------|---------|-------------|
| Duplicate guard | by-pattern/duplicate-guard.md | result.py, store.py |
| Timestamp Z | by-pattern/timestamp-standard.md | time.py, consent.py, result.py |

## Por Decisão
| Decisão | Arquivo | Impacto |
|---------|---------|---------|
| AGPLv3 | by-decision/why-agplv3.md | Licenciamento |
| Zero deps | by-decision/why-no-external-deps.md | Arquitetura |
```

### 7.3 Política de Crescimento

- Cada entrada tem no máximo 100 linhas
- Se uma entrada crescer além de 100 linhas, deve ser dividida
- Novas entradas requerem atualização do INDEX
- Entradas obsoletas são marcadas como `[OBSOLETO]` no INDEX, não deletadas
- A IA que descobre algo reutilizável é responsável por criar a entrada

### 7.4 Onde Vive

- **`knowledge/`** é subdiretório de `.hbn/` (dentro do diretório que o HBN protocoliza)
- Para o próprio repositório HBN: `.hbn/knowledge/`
- Para repositórios externos: `.hbn/knowledge/` do repositório alvo
- Não é parte de `docs/` (que é documentação pública). Knowledge é memória operacional.

---

## 8. POLÍTICA DE HOMOLOGAÇÃO E VERSIONAMENTO

### 8.1 Estágios de Homologação

| Estágio | Nome | Critério de entrada | Critério de saída |
|---------|------|--------------------|--------------------|
| **H0** | Desenvolvimento | Código escrito | Testes unitários passam |
| **H1** | Validação | Testes passam | Testes de integração passam, regressão zero |
| **H2** | Homologação | Integração ok | Documentação atualizada, CLI testado manualmente |
| **H3** | Release | Homologado | CHANGELOG atualizado, tag criada, PyPI publicado |

### 8.2 Versionamento (SemVer Estrito)

```
MAJOR.MINOR.PATCH
```

| Tipo | Quando | Exemplo | Homologação necessária |
|------|--------|---------|----------------------|
| **PATCH** | Bug fix sem mudança de interface | 0.1.1 | H1 (testes) |
| **MINOR** | Nova funcionalidade backward-compatible | 0.2.0 | H2 (documentação) |
| **MAJOR** | Breaking change em schema, CLI, ou protocolo | 1.0.0 | H3 + aprovação humana explícita |

### 8.3 Canais

| Canal | Versão | Público | Estabilidade |
|-------|--------|---------|-------------|
| **stable** | Tags no main | PyPI | Máxima |
| **beta** | Branch develop | TestPyPI ou pip install git+ | Média |
| **experimental** | Branches feature/* | Apenas local | Nenhuma garantia |

### 8.4 O Que NUNCA Pode Ser Promovido Sem Validação

- Mudança em qualquer schema JSON (afeta todos os registros existentes)
- Mudança na semântica de `hearback_status` ou `hbn_outcome`
- Remoção de campo de qualquer schema
- Mudança no formato de `execution_id` ou `readback_id`
- Qualquer mudança no `engine.py`
- Qualquer mudança que faça testes existentes falharem

### 8.5 Critérios de Bloqueio

Uma release é bloqueada se:
- Qualquer teste falha
- A documentação do README não reflete o estado do código
- Existe schema JSON que o validador não consegue enforçar completamente
- Existe promessa documental sem funcionalidade correspondente

---

## 9. CORREÇÕES NECESSÁRIAS NA DOCUMENTAÇÃO

### 9.1 README.md — Correções Obrigatórias

**PROBLEMA:** O README não menciona ERP, Readback, Hearback, subcomandos, ou o fluxo completo do protocolo.

**CORREÇÃO:** Reescrever "Current Status" para incluir todos os 7 layers (ativação, intent, truth barrier, guardian, consent, readback, ERP).

**PROBLEMA:** A instalação diz `pip install -e .` mas não explica o PATH.

**CORREÇÃO:** Adicionar: "Se `usehbn` não for encontrado, use `python -m usehbn` ou adicione o diretório de scripts ao PATH."

**PROBLEMA:** Nenhuma menção ao fluxo de subcomandos.

**CORREÇÃO:** Documentar: `usehbn readback`, `usehbn hearback`, `usehbn result` com exemplos reais.

### 9.2 O Que Está Honesto e Deve Ser Preservado

- "HBN is not: a product, a framework, a hosted platform..." — CORRETO
- Princípios em principles.md — CORRETOS
- Licença AGPLv3 com justificativa — CORRETO
- Governança founder-led — CORRETO para o estágio

### 9.3 Relatórios — Reorganização

Mover para `reports/`:
- HBN-EVOLUTION-ANALYSIS.md
- HBN-ERP-HARDENING-AUDIT.md
- HBN-SEMANTIC-READBACK-SPEC.md
- HBN-DIAGNOSTICO-REALISTA.md
- REPORT.md
- REPORT-ERP-MVP.md
- REPORT-HBN-HARDENING.md

A raiz do projeto deve ter apenas: README.md, LICENSE, CHANGELOG.md, ROADMAP.md, setup.cfg/pyproject.toml, CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md, GOVERNANCE.md, MAINTAINERS.md, SUPPORT.md.

---

## 10. ROADMAP REALISTA DE IMPLEMENTAÇÃO

### Fase 1 — Fundação v1.0 (prioridade máxima)

```
1.1 [CRÍTICO] Completar readback semântico
    - Adicionar understanding, invariants_preserved, action_plan ao schema
    - Atualizar readback.py para aceitar novos campos
    - Atualizar CLI para aceitar novos argumentos
    - Atualizar testes existentes + adicionar novos

1.2 [ALTO] Registrar entry point `hbn`
    - Adicionar `hbn = usehbn.cli:main` ao setup.cfg

1.3 [ALTO] Implementar `hbn init`
    - Criar .hbn/ com manifest.json e state.json
    - Detectar tipo de sistema (git, python, genérico)

1.4 [ALTO] Implementar `hbn version`

1.5 [ALTO] Atualizar README
    - Documentar todos os subcomandos
    - Documentar fluxo completo
    - Corrigir instruções de instalação

1.6 [MÉDIO] Organizar raiz do repositório
    - Mover relatórios para reports/

1.7 [MÉDIO] Criar .hbn/ no próprio repositório HBN
    - HBN passa a usar HBN para seu próprio desenvolvimento
    - Criar primeiro relay (0001-v1-foundation.md)
```

### Fase 2 — Distribuição e Multi-Runtime (após v1.0)

```
2.1 Preparar pyproject.toml para PyPI
2.2 Publicar como pacote `hbn`
2.3 Criar adaptadores multi-runtime (Claude Code, Codex, Copilot)
2.4 Criar script get-hbn
2.5 Implementar hbn install --runtime <runtime>
2.6 Implementar hbn inspect
```

### Fase 3 — Comunicação Inter-IAs e Knowledge (após v1.1)

```
3.1 Implementar relay/ com convenções
3.2 Implementar knowledge/ com index
3.3 Implementar compactação automática de relay
3.4 Documentar protocolo inter-IAs
```

---

## 11. SUPERPROMPT FINAL

```
================================================================
SUPERPROMPT: HBN v1.0 — Fundação Operacional Completa
================================================================
TARGET: Codex / GPT com inteligência máxima
MODO: Implementação incremental, anti-regressão, auto-alimentada
================================================================

CONTEXTO OBRIGATÓRIO — LEIA PRIMEIRO

Você está trabalhando no repositório HBN — Human Brain Net.
https://github.com/hbn-protocol/hbn (ou equivalente local)

O HBN é um protocolo aberto para engenharia de software assistida
por IA com segurança, estrutura, rastreabilidade e autoridade humana.

ESTADO ATUAL VERIFICADO:
- 21 testes passando
- Pipeline: ativação → intent → truth barrier → guardian → consent
  → readback (gate) → hearback → ERP
- CLI: usehbn com subcomandos readback, hearback, result
- Entry point: apenas "usehbn" (NÃO existe "hbn")
- Readback: gate de classificação APENAS (NÃO tem conteúdo semântico)
- Não existe "hbn init"
- Não existe "hbn version"
- Não existe .hbn/ para repositórios externos
- README desatualizado
- Relatórios de auditoria misturados na raiz

O QUE ESTE PROMPT RESOLVE:
Transforma o HBN de scaffold funcional em primeira versão operável,
distribuível e auto-alimentada.

================================================================
REGRAS ABSOLUTAS (NUNCA VIOLAR):
================================================================
R1. NÃO modificar src/usehbn/execution/engine.py
R2. NÃO quebrar nenhum dos 21 testes existentes
R3. NÃO adicionar dependências externas (apenas stdlib Python)
R4. NÃO fazer mudanças que alterem o output do pipeline existente
R5. Rodar python -m pytest tests/ -v após CADA microtarefa
R6. Se algum teste falhar, PARAR e corrigir antes de prosseguir
R7. Toda mudança é ADITIVA (não remover funcionalidade)
R8. Documentar cada decisão tomada durante a implementação

================================================================
MICROTAREFA 1: ORGANIZAR RAIZ DO REPOSITÓRIO
================================================================
Prioridade: MÉDIA (mas deve ser feita primeiro para limpar o espaço)

1.1 Criar diretório reports/ na raiz do repositório.

1.2 Mover TODOS os arquivos HBN-*.md e REPORT*.md para reports/:
    - HBN-EVOLUTION-ANALYSIS.md → reports/
    - HBN-ERP-HARDENING-AUDIT.md → reports/
    - HBN-SEMANTIC-READBACK-SPEC.md → reports/
    - HBN-DIAGNOSTICO-REALISTA.md → reports/
    - HBN-SUPERPROMPT-ARQUITETURAL.md → reports/
    - REPORT.md → reports/
    - REPORT-ERP-MVP.md → reports/
    - REPORT-HBN-HARDENING.md → reports/

1.3 Não mover: README.md, CHANGELOG.md, ROADMAP.md, LICENSE,
    CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md,
    GOVERNANCE.md, MAINTAINERS.md, SUPPORT.md

VALIDAÇÃO: pytest passa. Nenhum import quebrado.

================================================================
MICROTAREFA 2: COMPLETAR READBACK SEMÂNTICO
================================================================
Prioridade: CRÍTICA

O readback atual em protocol/readback.py tem apenas:
- readback_id, execution_id, agent_id, track,
  hearback_status, classification_basis, created_at

Faltam os campos que dão valor ao readback:
- understanding (o que o executor entendeu)
- invariants_preserved (o que NÃO vai mudar)
- action_plan (o que vai ser feito)
- out_of_scope (opcional: o que está fora)
- residual_risks (riscos reconhecidos)

2.1 ATUALIZAR schemas/readback.schema.json:

Adicionar ao array "required":
  "understanding", "invariants_preserved", "action_plan"

Adicionar ao "properties":
  "understanding": {
    "type": "string",
    "minLength": 1,
    "maxLength": 2000
  },
  "invariants_preserved": {
    "type": "array",
    "items": {"type": "string", "minLength": 1},
    "minItems": 1
  },
  "action_plan": {
    "type": "array",
    "items": {"type": "string", "minLength": 1},
    "minItems": 1
  },
  "out_of_scope": {
    "type": "array",
    "items": {"type": "string", "minLength": 1}
  },
  "residual_risks": {
    "type": "array",
    "items": {"type": "string", "minLength": 1}
  }

MANTER todos os campos existentes inalterados.

2.2 ATUALIZAR src/usehbn/protocol/readback.py:

Adicionar parâmetros a create_readback_record():
  understanding: str       # obrigatório
  invariants_preserved: list  # obrigatório, min 1 item
  action_plan: list        # obrigatório, min 1 item
  out_of_scope: list = None  # opcional
  residual_risks: list = None  # opcional

No dict record, adicionar:
  record["understanding"] = understanding
  record["invariants_preserved"] = invariants_preserved
  record["action_plan"] = action_plan
  record["residual_risks"] = residual_risks or []
  if out_of_scope is not None:
      record["out_of_scope"] = out_of_scope

2.3 ATUALIZAR src/usehbn/cli.py:

Adicionar ao readback_parser:
  --understanding (required, string)
  --invariant (action="append", required)
  --plan-step (action="append", required)
  --out-of-scope (action="append", default=[])
  --residual-risk (action="append", default=[])

Atualizar run_readback_protocol() para passar os novos campos.

2.4 ATUALIZAR tests/test_semantic_readback.py:

TODOS os testes que chamam create_readback_record() devem
receber os novos parâmetros obrigatórios:
  understanding="Test understanding.",
  invariants_preserved=["Public API unchanged"],
  action_plan=["Execute planned change"],

Adicionar NOVOS testes:
  def test_readback_semantic_content_persisted(tmp_path):
      # Criar readback com todos os campos semânticos
      # Carregar do disco
      # Verificar que understanding, invariants, action_plan persistem

  def test_readback_understanding_max_length(tmp_path):
      # understanding com 2001 chars deve falhar

  def test_readback_empty_invariants_rejected(tmp_path):
      # invariants_preserved=[] deve falhar

  def test_readback_empty_action_plan_rejected(tmp_path):
      # action_plan=[] deve falhar

  def test_readback_out_of_scope_optional(tmp_path):
      # Criar sem out_of_scope, verificar que não está no record

VALIDAÇÃO: pytest passa. Todos os 21+ testes passam.

================================================================
MICROTAREFA 3: REGISTRAR ENTRY POINT `hbn`
================================================================
Prioridade: ALTA

3.1 Editar setup.cfg:

Mudar:
  [options.entry_points]
  console_scripts =
      usehbn = usehbn.cli:main

Para:
  [options.entry_points]
  console_scripts =
      hbn = usehbn.cli:main
      usehbn = usehbn.cli:main

3.2 Reinstalar: pip install -e .

VALIDAÇÃO: `hbn --help` funciona. `usehbn --help` continua funcionando.
pytest passa.

================================================================
MICROTAREFA 4: IMPLEMENTAR `hbn init`
================================================================
Prioridade: ALTA

4.1 Adicionar ao build_root_parser() em cli.py:

  init_parser = subparsers.add_parser(
      "init",
      help="Initialize HBN protocol in a target directory.",
  )
  init_parser.add_argument(
      "--target", default=".",
      help="Target directory (default: current directory).",
  )
  init_parser.add_argument(
      "--indent", type=int, default=2,
  )

4.2 Criar função run_init():

  def run_init(args: argparse.Namespace) -> Dict[str, Any]:
      target = Path(args.target).resolve()
      hbn_dir = target / ".hbn"
      if hbn_dir.exists():
          return {
              "status": "already_initialized",
              "path": str(hbn_dir),
          }
      hbn_dir.mkdir(parents=True)
      (hbn_dir / "readbacks").mkdir()
      (hbn_dir / "results").mkdir()
      (hbn_dir / "relay").mkdir()
      (hbn_dir / "relay-archive").mkdir()
      (hbn_dir / "knowledge").mkdir()
      manifest = {
          "protocol_version": __version__,
          "initialized_at": utc_now_iso(),
          "target_path": str(target),
      }
      state = {
          "executions": [],
          "decisions": [],
          "context_history": [],
          "results": [],
          "readbacks": [],
      }
      write_json(hbn_dir / "manifest.json", manifest)
      write_json(hbn_dir / "state.json", state)
      # Criar INDEX.md do relay
      index_content = (
          "# HBN Relay — Estado Atual\n\n"
          "**Bastao atual:** humano\n"
          f"**Ultima atualizacao:** {utc_now_iso()}\n\n"
          "## Iteracoes Ativas\n\n"
          "Nenhuma.\n\n"
          "## Proxima Acao\n\n"
          "Iniciar primeira iteracao de trabalho.\n"
      )
      (hbn_dir / "relay" / "INDEX.md").write_text(
          index_content, encoding="utf-8"
      )
      # Criar INDEX.md do knowledge
      knowledge_index = (
          "# HBN Knowledge Base\n\n"
          "Nenhuma entrada ainda.\n"
      )
      (hbn_dir / "knowledge" / "INDEX.md").write_text(
          knowledge_index, encoding="utf-8"
      )
      return {
          "status": "initialized",
          "path": str(hbn_dir),
          "manifest": manifest,
      }

Importar utc_now_iso de usehbn.utils.time.

4.3 Atualizar main() para rotear "init":

  elif len(sys.argv) > 1 and sys.argv[1] == "init":
      parser = build_root_parser()
      args = parser.parse_args()
      result = run_init(args)
      indent = args.indent

4.4 Adicionar testes:

  def test_hbn_init_creates_structure(tmp_path):
      # Simular args com target=tmp_path
      # Chamar run_init
      # Verificar que .hbn/, manifest.json, state.json existem
      # Verificar que relay/, knowledge/ existem
      # Verificar que relay/INDEX.md existe

  def test_hbn_init_idempotent(tmp_path):
      # Chamar run_init duas vezes
      # Segunda chamada retorna "already_initialized"
      # Nada é sobrescrito

VALIDAÇÃO: pytest passa.

================================================================
MICROTAREFA 5: IMPLEMENTAR `hbn version`
================================================================
Prioridade: BAIXA

5.1 Adicionar subparser "version" ao build_root_parser().

5.2 Rotear no main():
  if sys.argv[1] == "version"

5.3 Retornar: {"protocol_version": __version__, "cli": "hbn"}

VALIDAÇÃO: pytest passa. `hbn version` retorna JSON.

================================================================
MICROTAREFA 6: HBN USA HBN (AUTO-ALIMENTAÇÃO)
================================================================
Prioridade: ALTA (conceitual e simbólica)

6.1 Rodar `hbn init` no próprio repositório HBN:
    cd <raiz do repo>
    hbn init

6.2 Criar .hbn/relay/0001-v1-foundation.md com:

    # 0001 — Fundação v1.0

    **Bastao:** codex
    **Estado:** ativo
    **Criado:** <timestamp>

    ## Contexto Recebido
    Repositório HBN com 21 testes, pipeline completo,
    readback sem conteúdo semântico, sem hbn init,
    sem entry point hbn.

    ## O Que Foi Feito
    [preencher com as microtarefas completadas]

    ## O Que Foi Alterado
    [listar arquivos]

    ## Próximo Passo
    Publicar no PyPI como pacote "hbn".

    ## Pendências
    - Adaptadores multi-runtime (fase 2)
    - Script get-hbn (fase 2)

    ## Riscos
    - Nome "hbn" pode estar ocupado no PyPI
    - Rename do package pode quebrar imports

    ## Decisões Tomadas
    - Entry point primário é "hbn", "usehbn" é alias
    - Readback requer understanding + invariants + action_plan
    - .hbn/ é o diretório de estado do protocolo

6.3 Atualizar .hbn/relay/INDEX.md com o estado.

6.4 Adicionar .hbn/ ao .gitignore EXCETO relay/ e knowledge/:
    .hbn/state.json
    .hbn/readbacks/
    .hbn/results/
    .hbn/manifest.json
    # NÃO ignorar:
    # .hbn/relay/
    # .hbn/knowledge/

VALIDAÇÃO: pytest passa. .hbn/ existe.

================================================================
MICROTAREFA 7: ATUALIZAR README
================================================================
Prioridade: ALTA

7.1 Atualizar seção "How To Use":
    pip install -e .  (desenvolvimento)
    hbn version       (verifica instalação)
    hbn init          (inicializa protocolo)
    hbn run "use hbn analyze this system"

7.2 Adicionar seção "Protocol Flow":
    Ativação → Intent → Truth Barrier → Guardian →
    Track Classification → Readback → Hearback →
    Execução → ERP Result

7.3 Atualizar seção "Current Status":
    Adicionar: ERP, Semantic Readback, Hearback gate,
    Track classification, hbn init, comunicação inter-IAs

7.4 Documentar subcomandos:
    hbn init [--target <path>]
    hbn run "<sentence>"
    hbn readback <exec_id> [--args]
    hbn hearback <exec_id> --status <status>
    hbn result <exec_id> [--args]
    hbn version

7.5 Adicionar seção "What Works Today":
    Lista honesta do que funciona e do que não funciona.

7.6 Adicionar seção "What Does NOT Work Yet":
    - Multi-runtime (Claude Code, Codex, Copilot como alvos)
    - Distribuição via PyPI
    - Script get-hbn
    - Orquestração multi-agente
    - SaaS

VALIDAÇÃO: README é honesto e verificável.

================================================================
MICROTAREFA 8: ATUALIZAR core/readback-spec.md
================================================================
Prioridade: MÉDIA

Criar ou atualizar core/readback-spec.md com:
- Definição do Semantic Readback
- Campos obrigatórios e seus propósitos
- Track classification (fast vs safe)
- Hearback protocol
- Integração com ERP (readback_id linkado)
- Não-objetivos

================================================================
MICROTAREFA 9: ATUALIZAR agents/codex.md
================================================================
Prioridade: MÉDIA

Adicionar seção "Semantic Readback Expectation":
- Codex deve produzir readback com understanding,
  invariants_preserved, action_plan antes de execuções safe_track
- Execution só prossegue após hearback confirmed
- Fast-track permite pular readback, mas classificação
  deve ser documentada

================================================================
VALIDAÇÃO FINAL
================================================================

1. python -m pytest tests/ -v
   TODOS os testes devem passar.

2. hbn version
   Retorna JSON com protocol_version.

3. hbn init --target /tmp/hbn-test
   Cria /tmp/hbn-test/.hbn/ com estrutura completa.

4. hbn run "use hbn refactor auth without breaking tests"
   Output idêntico ao comportamento anterior.

5. hbn readback <exec_id> \
     --agent-id codex \
     --intent-json '{"objective":"test","constraints":[],"risks":["risk"],"validation_requirements":[]}' \
     --guardian-json '{"status":"warn","warnings":[{"code":"test"}]}' \
     --understanding "Auth module handles JWT tokens" \
     --invariant "Public API unchanged" \
     --plan-step "Extract JWT validation" \
     --out-of-scope "Database layer" \
     --residual-risk "New module needs tests"
   Cria readback com TODOS os campos semânticos.

6. hbn hearback <exec_id> --status confirmed
   Atualiza hearback.

7. usehbn "use hbn analyze" (backward compatibility)
   Continua funcionando.

8. Verificar que .hbn/ existe no repositório HBN
   com relay/INDEX.md e relay/0001-v1-foundation.md

================================================================
RELATÓRIO FINAL
================================================================

Criar reports/REPORT-V1-FOUNDATION.md com:

- Data e escopo
- Microtarefas completadas (1-9) com status
- Arquivos criados (lista com paths)
- Arquivos modificados (lista com paths e descrição)
- Arquivos movidos (lista de origem → destino)
- Testes antes: 21
- Testes depois: (contar)
- Backward compatibility: verificado/não verificado
- Desvios do prompt e justificativa
- Confirmação: "Nenhum comportamento existente foi quebrado.
  Todas as mudanças são aditivas. engine.py não foi tocado."
- Confirmação: "O HBN agora usa o próprio HBN para
  registrar sua evolução."

================================================================
FIM DO SUPERPROMPT
================================================================
```

---

## NOTAS FINAIS

Este documento estabelece a ponte entre o HBN como scaffold funcional e o HBN como sistema operável. As 9 microtarefas são ordenadas por dependência e risco: organização primeiro (baixo risco), readback semântico segundo (maior impacto), infraestrutura CLI terceiro, auto-alimentação quarto, documentação por último.

O GSD ensinou que **artefatos no filesystem substituem memória de sessão** — o relay/ implementa isso. O OpenClaw ensinou que **abstração de canal permite operar em qualquer plataforma** — os adaptadores multi-runtime da fase 2 implementam isso. O HBN contribui com algo que nenhum dos dois tem: **rastreabilidade semântica pré-execução** via readback/hearback.

O próximo passo imediato é executar as microtarefas 1-7 nesta ordem. O resultado é a v1.0: um sistema que pode ser instalado, inicializado em qualquer repositório, e usado com autoridade humana preservada em cada etapa.
