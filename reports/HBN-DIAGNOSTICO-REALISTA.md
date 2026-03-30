# HBN — Diagnóstico Realista e Caminho para a Primeira Versão Funcional

**Data:** 2026-03-30
**Baseline verificado:** 21 testes passando, CLI funcional, cadeia completa intent → readback → hearback → ERP operacional
**Autor:** Claude Opus 4.6 (papel de Arquiteto Principal)

---

## PREÂMBULO — O QUE O HBN É HOJE

O HBN nasceu como um experimento mental e está ganhando forma e força como estrutura de arquitetura de sistema. Ele já demonstrou viabilidade concreta: um protocolo com 7 camadas funcionais (ativação, intent, truth barrier, guardian, consent, readback, ERP), validação por schemas JSON, CLI instalável, e 21 testes automatizados. É um sistema real, não apenas documentação.

Ao mesmo tempo, existe um abismo entre o que o repositório entrega tecnicamente e o que um usuário externo consegue usar na prática. Este documento confronta essa realidade com honestidade e propõe o caminho concreto para a primeira versão verdadeiramente funcional — capaz de tratar a tecnologia atual, incorporar a tecnologia futura e resgatar a tecnologia do passado, por meio do processamento orquestrado de IAs sob o protocolo HBN.

---

## PARTE 1 — AUDITORIA DE VERDADE DA DOCUMENTAÇÃO

### 1.1 O Que a Documentação Promete vs. O Que Existe

| Aspecto | O que a documentação sugere | O que realmente existe | Veredicto |
|---------|---------------------------|----------------------|-----------|
| Instalação | `pip install -e .` funciona | Funciona, mas instala em diretório fora do PATH. Usuário recebe `command not found` | **Problema real** |
| CLI `usehbn` | Comando pronto para uso | Funciona após instalação correta, mas o PATH precisa ser configurado manualmente | **Documentação incompleta** |
| Ativação semântica | Detecta "use hbn" em texto | Funciona corretamente via regex | **Preciso** |
| Estruturação de intent | Extrai objetivo, constraints, riscos | Funciona, mas é heurístico (regex em inglês). Refraseamentos simples escapam | **Preciso, mas com limitações não documentadas** |
| Truth Barrier | Detecta overconfidence | Funciona para padrões literais ("always", "guaranteed"). Não detecta overconfidence semântica | **Preciso** |
| Guardian | Detecta riscos e gaps de validação | Funciona para keywords. Emite warnings, não bloqueia | **Preciso** |
| Semantic Readback | Contrato pré-execução | Implementado como classificação de track + hearback gate. **Mas NÃO contém os campos `understanding`, `invariants_preserved`, `action_plan`** da especificação arquitetural | **Implementação parcial** |
| ERP | Registro de resultado | Funciona completamente. Guards contra duplicação, overwrite, e validação de hearback | **Preciso** |
| VBA Bridge | Integração com sistemas legados | Retorna dicionário estático descritivo. Não faz integração real | **Conceitualmente forte, operacionalmente prematuro** |
| Orquestração multi-agente | Nenhuma promessa explícita | Não existe | **Honesto** |
| Execução engine | "Minimal execution engine" | Orquestra pipeline corretamente, persiste estado | **Preciso** |

### 1.2 Descoberta Crítica: Gap no Readback

A implementação do Readback pelo Codex **divergiu significativamente** da especificação arquitetural. A especificação definia 5 campos semânticos essenciais:

- `understanding` (o que o executor entendeu)
- `invariants_preserved` (o que não vai mudar)
- `action_plan` (o que será feito)
- `out_of_scope` (o que está fora do escopo)
- `residual_risks` (riscos reconhecidos)

A implementação atual contém apenas:

- `readback_id`, `execution_id`, `agent_id`
- `track` (fast/safe)
- `hearback_status`
- `classification_basis` (3 booleans)
- `created_at`

Isso significa que o Readback atual é um **gate de classificação**, não um **contrato semântico**. O mecanismo de bloqueio funciona (ERP não é criado sem hearback confirmado para safe_track), mas o conteúdo semântico que dá valor ao readback — a declaração de entendimento do executor — está ausente.

**Impacto:** O readback funciona como trava de segurança, mas não funciona como ferramenta de compreensão. A peça mais valiosa do protocolo (forçar o executor a declarar o que entendeu) não foi implementada.

### 1.3 O Que Deve Ser Corrigido Imediatamente na Documentação

**Problema 1 — Instalação.** O README diz `pip install -e .` mas não menciona que o comando `usehbn` pode ser instalado em um diretório fora do PATH. Deve incluir instruções para `pipx install -e .` ou orientação de PATH.

**Problema 2 — "Current Status" desatualizado.** O README não menciona ERP, Readback, ou Hearback. Lista apenas as 5 camadas originais. Está defasado em relação ao código real.

**Problema 3 — Nenhuma menção ao fluxo completo.** O fluxo real agora é: `usehbn "..."` → `usehbn readback ...` → `usehbn hearback ...` → `usehbn result ...`. Isso não está documentado em lugar nenhum.

**Problema 4 — Schema de Readback não documenta a limitação.** Ninguém lendo o schema atual entende que o readback deveria ter campos semânticos e não tem.

### 1.4 O Que Está Correto e Deve Ser Preservado

- A descrição "open protocol for safe, structured, and evolvable AI-assisted software engineering" é precisa
- A seção "What HBN Is Not" é honesta e valiosa
- A governança founder-led é apropriada para o estágio atual
- A licença AGPLv3 é bem justificada
- Os princípios em `docs/principles.md` são sólidos e refletidos no código
- A separação protocol (core/) vs implementação (src/) está correta

---

## PARTE 2 — ANÁLISE DE DISTRIBUIÇÃO

### 2.1 O Modelo de 3 Camadas: `get-hbn` / `hbn` / `usehbn`

| Camada | Papel | Tipo |
|--------|-------|------|
| `get-hbn` | Bootstrap, instalação, atualização | Instalador |
| `hbn` | CLI operacional real | Runtime |
| `usehbn` | Gatilho semântico dentro de prompts e artefatos | Linguagem |

**Avaliação:** Esta separação é arquiteturalmente correta e deve ser adotada. Razões:

1. **`usehbn` como executável é um acidente.** O nome surgiu do gatilho semântico ("use hbn"), não de uma decisão de CLI design. "usehbn" é ótimo como trigger linguístico mas ruim como nome de binário — é confuso, não segue convenções Unix, e mistura a camada semântica com a camada de execução.

2. **`hbn` é o nome natural do CLI.** Curto, memorável, segue padrão (`git`, `npm`, `gh`). Subcomandos naturais: `hbn init`, `hbn run`, `hbn readback`, `hbn result`, `hbn inspect`.

3. **`get-hbn` resolve o bootstrapping.** Um usuário não deveria precisar clonar o repo e rodar `pip install -e .`. Deveria executar um comando de instalação e ter o sistema pronto.

### 2.2 Estratégias de Distribuição

| Estratégia | Simplicidade | Confiança | Portabilidade | Manutenção | Veredicto |
|-----------|-------------|-----------|---------------|-----------|-----------|
| `curl \| bash` | Alta | Baixa (risco de segurança) | Linux/Mac | Baixa | **Não recomendado para v1** |
| `pip install hbn` | Alta | Média | Todas | Média | **Recomendado para v1** |
| `pipx install hbn` | Alta | Alta (isolado) | Todas | Baixa | **Ideal para usuários finais** |
| Homebrew | Média | Alta | Mac/Linux | Alta | **Fase 2** |
| Binário standalone | Média | Alta | Todas | Alta | **Fase 3** |
| Script `get-hbn` | Alta | Média | Linux/Mac | Média | **Fase 2 (wrapper para pipx)** |

**Recomendação para v1:**
- Publicar no PyPI como `hbn`
- Instrução primária: `pipx install hbn` (ou `pip install hbn`)
- `get-hbn` como script opcional que verifica Python, instala pipx se necessário, e roda `pipx install hbn`
- Manter compatibilidade com `usehbn` como alias/backward-compat

### 2.3 Cross-Platform desde o Dia 1

O código atual é Python puro sem dependências nativas. Isso já é cross-platform. O que falta:

- Testar em Windows (paths com `\`, diretórios `.usehbn`)
- Garantir que `Path` é usado consistentemente (já é — verificado no código)
- Não assumir bash (o `get-hbn` deve ter alternativa para Windows)

**Linux como alvo primário:** Sim, é correto para o estágio atual (Codex roda em Linux, desenvolvedores técnicos usam Linux/Mac). Mas o código não deve ter hardcoding de Linux.

---

## PARTE 3 — HBN COMO ARQUITETURA ATRAVÉS DO TEMPO

### 3.A — Presente: O Que Funciona Agora

O HBN hoje é um **analisador de intenção local com pipeline de validação**. Ele:

1. Recebe uma frase em linguagem natural
2. Detecta o gatilho semântico
3. Extrai objetivo, constraints, riscos, requisitos de validação
4. Aplica truth barrier (qualidade de claims)
5. Aplica guardian (completude de validação)
6. Classifica track (fast/safe)
7. Registra readback com gate de hearback
8. Registra resultado (ERP) com guards de integridade

Isso funciona. É real. É testado. Mas opera apenas no **contexto do próprio repositório HBN**. Não há mecanismo para apontar o HBN para um repositório externo e iniciar protocolo lá.

### 3.B — Passado/Legado: Sistemas Que Nunca Foram Projetados para IA

**O problema fundamental:** Um sistema VBA de 2005 com 50 módulos, 200 UserForms e zero testes não sabe que IA existe. Não tem metadata, não tem schemas, não tem testes automatizados. Mas é exatamente o tipo de sistema que mais precisa de proteção quando alguém decide "modernizá-lo com IA."

**Como o HBN deve se conectar a sistemas legados:**

1. **`hbn init --target <path>`** — Cria um diretório `.hbn/` no repositório ou pasta alvo contendo:
   - `hbn-manifest.json` — Metadados do sistema (nome, tipo, linguagens detectadas, data de inicialização)
   - `hbn-state.json` — Estado de execuções HBN sobre este sistema
   - `readbacks/` — Registros de readback
   - `results/` — Registros de ERP

2. **Detecção de tipo de sistema** — O HBN deve ser capaz de identificar:
   - Repositório git (presença de `.git/`)
   - Projeto Python (presença de `setup.py`, `pyproject.toml`, `requirements.txt`)
   - Projeto VBA/Excel (presença de `.xlsm`, `.bas`, `.cls`, `.frm`)
   - Projeto genérico (fallback)

3. **Inventário de invariantes** — Para sistemas legados, o HBN deve facilitar a criação de um inventário de invariantes *antes* de qualquer modificação:
   - "Quais módulos existem?"
   - "Quais event handlers estão conectados?"
   - "Quais named ranges são usados?"
   - Este inventário se torna a base dos `invariants_preserved` nos readbacks futuros

4. **Contexto de continuidade** — Cada execução HBN no sistema legado acumula contexto. O próximo agente que trabalhar no sistema pode ler o histórico de intents, readbacks, e resultados para entender o que já foi feito.

### 3.C — Futuro: Multi-Agente e SaaS

O HBN deve evoluir em 3 fases:

**Fase 1 (Atual → v1.0):** CLI local, repositório como alvo, humano como validador único.

**Fase 2 (v1.x → v2.0):** API local ou server leve, múltiplos agentes registrados, readback semântico completo, reconciliação automática readback ↔ ERP, indexação de estado para busca.

**Fase 3 (v2.x+):** SaaS opcional, orquestração de agentes remotos, dashboards de rastreabilidade, integração com CI/CD, marketplace de protocol extensions.

**Princípio fundamental:** Cada fase deve funcionar completamente offline e local. SaaS é uma camada opcional sobre o protocolo, não um requisito. O protocolo é o produto; o SaaS é um serviço sobre o produto.

---

## PARTE 4 — PRIMEIRA VERSÃO FUNCIONAL

### 4.1 Escopo Mínimo Válido

A primeira versão verdadeiramente funcional deve permitir que um usuário:

1. Instale o HBN com um comando (`pip install hbn`)
2. Inicialize um repositório (`hbn init`)
3. Execute uma análise de intenção (`hbn run "analyze the auth module"`)
4. Veja o resultado estruturado (JSON no terminal)
5. Registre um readback antes de agir (`hbn readback <exec_id> --agent-id codex --intent-json '...'`)
6. Confirme o readback (`hbn hearback <exec_id> --status confirmed`)
7. Registre o resultado (`hbn result <exec_id> --agent-id codex --action "..." --outcome executed --human-status approved`)
8. Inspecione o histórico (`hbn inspect`)

### 4.2 Fluxo Mínimo de Instalação

```bash
pip install hbn        # ou pipx install hbn
cd meu-repositorio
hbn init               # cria .hbn/ com manifest e state
hbn run "use hbn refactor auth module without breaking tests"
# → JSON com intent, truth barrier, guardian, track classification
```

### 4.3 Contrato Mínimo de Comando

```
hbn init [--target <path>]          # Inicializa protocolo no diretório
hbn run "<sentence>"                # Analisa intent (substitui o atual `usehbn "..."`)
hbn readback <exec_id> [--args]     # Cria registro de readback
hbn hearback <exec_id> --status X   # Atualiza hearback
hbn result <exec_id> [--args]       # Registra resultado ERP
hbn inspect [--target <path>]       # Mostra estado atual do protocolo
hbn version                         # Versão do protocolo e CLI
```

### 4.4 Artefatos Mínimos no Repositório-Alvo

```
.hbn/
├── manifest.json        # Tipo de sistema, data de init, versão do protocolo
├── state.json           # Histórico de execuções, decisões, contexto
├── readbacks/           # Registros de readback por execution_id
└── results/             # Registros ERP por execution_id
```

### 4.5 O Que Deve Ficar Explicitamente Fora da v1

- Orquestração multi-agente
- API server
- Interface web
- Dashboard
- Integração CI/CD
- Publicação automática de estado
- Semantic validator agent
- Reconciliação automática readback ↔ ERP
- Suporte a idiomas além de inglês na extração de intent

---

## PARTE 5 — MODELO DE COMANDOS RECOMENDADO

### 5.1 Avaliação

| Comando | Para v1? | Justificativa |
|---------|----------|--------------|
| `hbn init --target <repo>` | **Sim** | Essencial. Sem init, não há onde persistir estado |
| `hbn run "<sentence>"` | **Sim** | Core. Substitui o atual `usehbn "..."` |
| `hbn readback <exec_id>` | **Sim** | Já existe (como `usehbn readback`) |
| `hbn hearback <exec_id>` | **Sim** | Já existe (como `usehbn hearback`) |
| `hbn result <exec_id>` | **Sim** | Já existe (como `usehbn result`) |
| `hbn inspect --target <repo>` | **Sim** | Necessário para usabilidade mínima |
| `hbn handoff --target <repo>` | **Não** | Requer multi-agente (fase 2) |
| `hbn version` | **Sim** | Trivial e útil |
| `get-hbn` | **Fase 2** | `pip install` é suficiente para v1 |

### 5.2 `usehbn` — Executável ou Semântico?

**Recomendação: Manter `usehbn` como alias do `hbn run` para backward-compatibility, mas migrar a identidade primária para `hbn`.**

O gatilho semântico "use hbn" continua existindo dentro da linguagem do protocolo — é o trigger que o `hbn run` detecta. Mas o executável primário deve ser `hbn`.

O `setup.cfg` deve registrar dois entry points:
```ini
[options.entry_points]
console_scripts =
    hbn = usehbn.cli:main
    usehbn = usehbn.cli:main
```

---

## PARTE 6 — ESTRATÉGIA DE CORREÇÃO DA DOCUMENTAÇÃO

### 6.1 README — Correções Necessárias

**Seção "How To Use":** Substituir por instruções que funcionam:
```markdown
## Instalação

```bash
pip install hbn
```

Ou, se estiver desenvolvendo localmente:
```bash
pip install -e .
```

Nota: Se `hbn` não for encontrado após instalação, adicione o diretório
de scripts Python ao seu PATH ou use `pipx install hbn`.
```

**Seção "Command":** Atualizar para refletir o modelo de subcomandos:
```markdown
## Comandos

Comando principal:
```bash
hbn run "use hbn analyze this system"
```

Subcomandos do protocolo:
```bash
hbn readback <exec_id> [...]    # Registro de readback pré-execução
hbn hearback <exec_id> [...]    # Confirmação humana do readback
hbn result <exec_id> [...]      # Registro ERP pós-execução
```
```

**Seção "Current Status":** Adicionar ERP, Readback, e Hearback à lista de capacidades.

**Nova seção "Protocol Flow":** Documentar o fluxo completo:
```
Intent → Truth Barrier → Guardian → Track Classification →
Readback (safe_track) → Hearback → Execution → ERP Result
```

### 6.2 Princípio da Correção

Toda reescrita deve seguir:
- **Não remover ambição** — HBN é ambicioso por natureza. A documentação deve preservar a visão
- **Separar "o que existe" de "direção futura"** — Seções claras: "Current Capabilities" vs "Roadmap"
- **Ser honesto sobre limitações** — "A extração de intent é heurística e funciona apenas em inglês"
- **Mostrar o fluxo real** — Com exemplos de terminal que funcionam
- **Manter credibilidade** — Cada afirmação no README deve ser verificável rodando o código

---

## PARTE 7 — ROADMAP DE IMPLEMENTAÇÃO

### Fase 1 — Completar o Readback Semântico (1-2 semanas)

O readback atual é um gate de classificação. Precisa se tornar o contrato semântico que foi especificado. Isso significa adicionar ao schema e ao módulo:

- `understanding` (string, max 2000 chars)
- `invariants_preserved` (array de strings, min 1)
- `action_plan` (array de strings, min 1)
- `out_of_scope` (array opcional)
- `residual_risks` (array)

E atualizar o CLI para aceitar esses campos via argumentos ou JSON.

**Prioridade:** ALTA. Sem isso, o readback é um semáforo sem conteúdo.

### Fase 2 — Renomear para `hbn` e Adicionar `hbn init` (1 semana)

- Adicionar entry point `hbn` no setup.cfg
- Implementar `hbn init` que cria `.hbn/` no diretório-alvo
- Implementar `hbn inspect` que mostra o estado do protocolo
- Migrar `hbn run` para operar sobre o `.hbn/` do diretório atual
- Manter `usehbn` como alias backward-compatible
- Atualizar README

### Fase 3 — Publicação e Distribuição (1 semana)

- Preparar `pyproject.toml` para publicação no PyPI
- Publicar como pacote `hbn`
- Testar `pip install hbn` e `pipx install hbn`
- Criar script `get-hbn` como wrapper para pipx
- Atualizar documentação de instalação

### Ordem de Build Priorizada

```
1. [CRÍTICO]  Completar readback semântico (schema + module + tests)
2. [ALTO]     Renomear CLI para `hbn` + entry points
3. [ALTO]     Implementar `hbn init` + `.hbn/` directory
4. [ALTO]     Atualizar README e documentação
5. [MÉDIO]    Implementar `hbn inspect`
6. [MÉDIO]    Preparar publicação PyPI
7. [BAIXO]    Script `get-hbn`
```

---

## PARTE 8 — PROMPT DE IMPLEMENTAÇÃO PARA O CODEX

```
========================================================================
CODEX TASK: HBN v1.0 — Primeira Versão Funcional
========================================================================

CONTEXTO:
Você está trabalhando no repositório HBN — Human Brain Net.
Estado atual: 21 testes passando. CLI funcional com subcomandos
readback, hearback, e result. Pipeline completo de intent até ERP.

O readback atual é um gate de classificação (track + hearback_status)
mas NÃO contém campos semânticos (understanding, invariants_preserved,
action_plan). Esses campos são essenciais para que o readback
cumpra sua função de contrato pré-execução.

Sua tarefa: implementar as 3 mudanças que transformam o HBN de
scaffold funcional em primeira versão usável.

========================================================================
REGRAS MANDATÓRIAS:
========================================================================
1. Não modificar src/usehbn/execution/engine.py
2. Não quebrar nenhum teste existente
3. Não adicionar dependências externas
4. Usar apenas Python standard library
5. Seguir padrões existentes no código
6. Rodar TODOS os testes após CADA etapa
7. Mudanças são ADITIVAS

========================================================================
ETAPA 1: Completar o Readback Semântico
========================================================================

1A. Atualizar schema: schemas/readback.schema.json

Adicionar ao "required":
  - "understanding"
  - "invariants_preserved"
  - "action_plan"

Adicionar ao "properties":
  "understanding": {
    "type": "string",
    "minLength": 1,
    "maxLength": 2000
  },
  "invariants_preserved": {
    "type": "array",
    "items": { "type": "string", "minLength": 1 },
    "minItems": 1
  },
  "action_plan": {
    "type": "array",
    "items": { "type": "string", "minLength": 1 },
    "minItems": 1
  },
  "out_of_scope": {
    "type": "array",
    "items": { "type": "string", "minLength": 1 }
  },
  "residual_risks": {
    "type": "array",
    "items": { "type": "string", "minLength": 1 }
  }

Manter TODOS os campos existentes (readback_id, execution_id,
agent_id, track, hearback_status, classification_basis, created_at).

1B. Atualizar módulo: src/usehbn/protocol/readback.py

Modificar create_readback_record() para aceitar novos parâmetros:
  - understanding: str (obrigatório)
  - invariants_preserved: List[str] (obrigatório)
  - action_plan: List[str] (obrigatório)
  - out_of_scope: Optional[List[str]] = None
  - residual_risks: Optional[List[str]] = None

Incluir no record dict:
  record["understanding"] = understanding
  record["invariants_preserved"] = invariants_preserved
  record["action_plan"] = action_plan
  record["residual_risks"] = residual_risks or []
  if out_of_scope is not None:
      record["out_of_scope"] = out_of_scope

1C. Atualizar CLI: src/usehbn/cli.py

Adicionar argumentos ao readback_parser:
  --understanding (required, string)
  --invariant (action="append", required, repeatable)
  --plan-step (action="append", required, repeatable,
               help="Action plan step")
  --out-of-scope (action="append", optional, repeatable)
  --residual-risk (action="append", optional, repeatable)

Atualizar run_readback_protocol() para passar os novos campos
a create_readback_record().

1D. Atualizar testes existentes: tests/test_semantic_readback.py

TODOS os testes que chamam create_readback_record() precisam
receber os novos parâmetros obrigatórios. Adicionar a cada
chamada existente:
  understanding="Test understanding for this execution.",
  invariants_preserved=["Public API unchanged"],
  action_plan=["Execute the planned change"],

Adicionar NOVOS testes:
  - test_readback_requires_understanding (vazio = erro)
  - test_readback_requires_invariants (lista vazia = erro)
  - test_readback_requires_action_plan (lista vazia = erro)
  - test_readback_preserves_semantic_content (criar, carregar,
    verificar que understanding, invariants, action_plan persistem)
  - test_readback_understanding_max_length (2001 chars = erro)

VALIDAÇÃO: Rodar pytest. TODOS os testes devem passar.

========================================================================
ETAPA 2: Adicionar Entry Point `hbn` e Comando `hbn init`
========================================================================

2A. Atualizar setup.cfg

Adicionar entry point:
  [options.entry_points]
  console_scripts =
      hbn = usehbn.cli:main
      usehbn = usehbn.cli:main

2B. Criar comando `hbn init`

Adicionar ao build_root_parser():
  init_parser = subparsers.add_parser(
      "init",
      help="Initialize HBN protocol in a target directory.",
  )
  init_parser.add_argument(
      "--target", default=".",
      help="Target directory. Defaults to current directory.",
  )

Criar função:
  def run_init(args: argparse.Namespace) -> Dict[str, Any]:
      target = Path(args.target).resolve()
      hbn_dir = target / ".hbn"
      if hbn_dir.exists():
          return {
              "status": "already_initialized",
              "hbn_dir": str(hbn_dir),
          }
      hbn_dir.mkdir(parents=True)
      (hbn_dir / "readbacks").mkdir()
      (hbn_dir / "results").mkdir()
      manifest = {
          "protocol_version": __version__,
          "initialized_at": utc_now_iso(),
          "target_path": str(target),
          "system_type": "generic",
      }
      write_json(hbn_dir / "manifest.json", manifest)
      write_json(hbn_dir / "state.json", {
          "executions": [],
          "decisions": [],
          "context_history": [],
          "results": [],
          "readbacks": [],
      })
      return {
          "status": "initialized",
          "hbn_dir": str(hbn_dir),
          "manifest": manifest,
      }

Atualizar main() para rotear "init":
  elif len(sys.argv) > 1 and sys.argv[1] == "init":

Importar utc_now_iso de usehbn.utils.time.

2C. Criar comando `hbn version`

  version_parser = subparsers.add_parser("version", help="Show version.")

  def run_version() -> Dict[str, Any]:
      return {"protocol_version": __version__, "cli": "hbn"}

2D. Adicionar testes:
  - test_hbn_init_creates_directory (tmp_path)
  - test_hbn_init_idempotent (segunda chamada retorna already_initialized)
  - test_hbn_init_manifest_has_version

VALIDAÇÃO: Rodar pytest. TODOS os testes devem passar.

========================================================================
ETAPA 3: Atualizar Documentação
========================================================================

3A. Atualizar README.md

Seção "How To Use":
  Substituir por instruções com `hbn` como comando primário.
  Adicionar nota que `usehbn` continua funcionando como alias.

Seção "Command":
  Documentar todos os subcomandos: init, run, readback, hearback,
  result, version.

Seção "Current Status":
  Adicionar: "Execution Result Protocol (ERP)", "Semantic Readback
  with hearback gate", "Track classification (fast/safe)".

Adicionar seção "Protocol Flow":
  Diagrama texto do fluxo completo:
  Intent → Truth Barrier → Guardian → Track → Readback → Hearback
  → Execution → ERP

3B. Atualizar agents/codex.md

Adicionar seção "Semantic Readback Expectation" documentando que
o Codex deve produzir readback com understanding, invariants,
action_plan antes de execuções safe_track.

3C. Criar core/readback-spec.md

Documentar o protocolo de Semantic Readback:
- Definição (contrato pré-execução)
- Campos obrigatórios e seus propósitos
- Track classification (fast vs safe)
- Hearback protocol
- Não-objetivos
- Storage

========================================================================
VALIDAÇÃO FINAL
========================================================================

1. Rodar: python -m pytest tests/ -v
   Todos os testes existentes + novos devem passar.

2. Rodar: hbn version
   Deve retornar JSON com protocol_version.

3. Rodar: hbn init --target /tmp/hbn-test
   Deve criar /tmp/hbn-test/.hbn/ com manifest e state.

4. Rodar: hbn run "use hbn refactor auth without breaking tests"
   Saída idêntica ao comportamento atual do usehbn.

5. Rodar: hbn readback <exec_id> \
     --agent-id codex \
     --understanding "Auth module uses JWT for session tokens" \
     --invariant "Public API signatures unchanged" \
     --invariant "Existing tests continue passing" \
     --plan-step "Extract JWT validation to jwt.py" \
     --plan-step "Update imports" \
     --out-of-scope "Database layer" \
     --residual-risk "New module needs additional tests"
   Deve criar readback com TODOS os campos semânticos.

6. Verificar que usehbn "..." continua funcionando (backward compat).

========================================================================
RELATÓRIO
========================================================================
Após completar TODAS as etapas, criar REPORT-V1.md com:
- Data e escopo
- Arquivos criados e modificados
- Testes antes vs depois
- Validação de backward compatibility
- Desvios do prompt e justificativa
- Confirmação: "Nenhum comportamento existente foi quebrado."
========================================================================
```

---

## SÍNTESE FINAL

O HBN é um sistema real e funcional. 21 testes passam. O pipeline completo opera. Mas existem 3 gaps concretos entre o que existe e o que deveria existir:

1. **O Readback está incompleto** — funciona como gate de segurança, mas não contém o conteúdo semântico que é sua razão de existir

2. **Não existe `hbn init`** — o protocolo não pode ser aplicado a um repositório externo, apenas opera dentro do próprio repositório HBN

3. **A documentação está defasada** — não reflete o estado atual do código (ERP, Readback, subcomandos)

Corrigir esses 3 gaps transforma o HBN de scaffold funcional em primeira versão usável — o passo que separa "experimento mental que ganhou forma" de "sistema que um desenvolvedor pode instalar e usar."
