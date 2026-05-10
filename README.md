# HBN — Human Brain Net

Created by Luis Mauricio Junqueira Zanin

HBN is an open protocol for safe, structured, and evolvable AI-assisted software engineering.

HBN starts from a simple discipline: AI-assisted work should remain legible, reviewable, and governable by humans. Intent should be explicit. Validation expectations should be visible. Safety-related uncertainty should not disappear behind convenience.

This repository is not a hosted orchestration platform. It is the local, inspectable runtime and documentation base for an operable HBN scaffold that can now also generate repository-local runtime adapters.

## Maturidade por Componente

Fonte canonica: [`docs/MATURITY-MATRIX.md`](docs/MATURITY-MATRIX.md). README e docs publicos nao devem afirmar capacidades acima do estado registrado nessa matriz.

| Componente | Estado v0.3.0 | Resumo publico permitido |
|---|---|---|
| CLI | Implementado | Funciona hoje; superficie publica congelada em v0.3.0. |
| Trigger / Ativacao semantica | Implementado | Funciona hoje para ativacao por `usehbn` e `use hbn`. |
| Intent (estruturacao) | Parcial | Funciona com limites conhecidos em PT, multi-clausulas e dominios fora do ingles. |
| Truth Barrier | Parcial (advisory) | Emite warnings; nao bloqueia o pipeline hoje. |
| Guardian | Parcial (advisory) | Emite/loga warnings; nao bloqueia o pipeline hoje. |
| Consent (CCP) | Implementado | Funciona hoje para captura local de consentimento. |
| Readback | Implementado | Funciona via CLI; limite atual: nao e chamado automaticamente pelo engine. |
| Hearback | Implementado | Funciona como gate quando ha Readback associado. |
| ERP (Result) | Implementado | Funciona hoje com gates de Hearback e Readback em `safe_track`. |
| Relay | Parcial | Convencoes e comandos existem; invariantes ainda nao sao validadas em runtime. |
| Baton | Parcial | Campo de dono existe; sem timeout ou audit trail completo. |
| Handoff | Implementado | Funciona hoje para transferencia validada e arquivamento. |
| Universal Translator | Scaffold | Hoje e roteador honesto: detecta ambiente/tecnologia e resolve connector; nao traduz semanticamente. |
| Runtime Adapters | Implementado | Gera arquivos de instrucao em filesystem para runtimes suportados. |
| Connectors (resolver) | Parcial | Resolve estrategia; "active" por presenca de arquivo e provisoriamente convencional. |
| Connectors (lifecycle) | Visao em v0.3.0 | Lifecycle formal ainda e linha planejada; Onda 4 registra estado sem enforcement. |
| Connectors (verify) | Stub | Apenas placeholder; sem verificacao funcional. |
| Connectors (remote lookup) | Scaffold | Estrutura existe; registry remoto real nao existe e default e off. |
| State (json append-only) | Parcial | Funciona com lacunas de compactacao, versionamento e fragmentacao de diretorios. |
| Schemas | Implementado | Schemas e validador customizado funcionam hoje. |
| Privacy Contract | Parcial / declarativo | Parte e codificada; parte ainda e declarativa, sem certificacao legal. |
| Bridge generation (legado) | Stub | Produz scaffold documental; nao gera bridges executaveis. |
| Tests | Parcial | Suite existe e passa; cobertura adversarial ainda e limitada. |
| Distribuicao | Parcial | Metadata existe; pacote ainda nao foi publicado em PyPI. |
| Phagocytosis (doutrina) | Visao | Doutrina canonica; sem codigo associado em v0.3.0. |
| Credenciamento (caso de uso) | Visao / referencia externa | Referencia externa; nenhum codigo de Credenciamento neste repo. |

## Repositórios Operacionais

- `usehbn-phago`: skeleton operacional dos módulos técnicos multi-braco. Link: https://github.com/rwv8gscs8g-blip/usehbn-phago

## What HBN Is

HBN is a protocol and working language for AI-assisted software engineering. In this repository it currently provides:

- semantic activation through `usehbn` and `use hbn`
- structured intent capture
- local consent capture
- truth barrier warnings
- guardian warnings
- semantic readback and hearback gating
- ERP result recording
- JSON-backed execution traceability
- repository-local protocol initialization via `.hbn/`

## Why HBN Exists

AI-assisted engineering often fails in the same way: a request sounds clear, but objectives, constraints, risks, review conditions, and implementation boundaries remain implicit. That ambiguity becomes drift, overconfidence, and hidden responsibility transfer.

HBN exists to counter that drift with protocol structure instead of autonomy claims.

## What Problem HBN Solves

HBN makes AI-assisted engineering work more explicit by recording:

- what was requested
- what the executor understood
- what must remain invariant
- what validation is missing
- what was actually done
- what requires human confirmation before execution

## What HBN Is Not

HBN is not:

- a product
- a framework
- a hosted platform
- a background agent system
- a distributed execution engine
- a token economy
- an AGI claim
- a replacement for human review

## Command

Use HBN

HBN has three related command layers:

- semantic trigger: `usehbn` or `use hbn` inside a sentence
- operational CLI: `hbn`
- local bootstrap script: `get-hbn`

Canonical semantic references:

- `usehbn`
- `use hbn`
- `usehbn.com`
- `usehbn.org`

The semantic trigger is case-insensitive and can appear inside longer text. The operational CLI is installed locally and currently exposes `hbn` as the primary entry point and `usehbn` as a compatibility alias.
The domains are treated as canonical semantic references for the protocol identity. In the current system, adapters and documentation should normalize them to HBN semantics without assuming that browsing is required.

## Public Domains

The public web strategy is now explicit:

- `https://usehbn.org` is the canonical public site
- `https://usehbn.com` should permanently redirect to `https://usehbn.org`

This keeps one stable public site while preserving both semantic anchors.

Conforme [`docs/PUBLISHING-DECISION.md`](docs/PUBLISHING-DECISION.md), `usehbn` e `hbn` sao nomes igualmente canonicos no CLI. `usehbn` e a forma semantica humana e tem prioridade sobre tecnologia. `usehbn.org` e o site canonico.

## Installation

Bootstrap install:

```bash
./get-hbn
```

This script creates or reuses a local `.venv/` and writes deterministic local `hbn`, `usehbn`, and `use` wrappers against the checked-out source tree.

Development install:

```bash
python3 -m pip install -e .
```

Build-system metadata is now declared through `pyproject.toml` with setuptools.

Verify the CLI:

```bash
hbn version
```

Safest first-time local validation:

```bash
hbn quickstart --target /tmp/hbn-sandbox --runtime auto
hbn doctor --target /tmp/hbn-sandbox
```

Natural shell entry after bootstrap:

```bash
use hbn analyze this system
```

If `hbn` or `usehbn` is not on your shell `PATH`, use one of:

```bash
.venv/bin/hbn version
python3 -m usehbn version
```

On older `pip`/setuptools combinations, editable install may still depend on legacy behavior. In those cases, prefer `./get-hbn` for local bootstrapping because it does not depend on a package index or wheel tooling.

## How To Use

Initialize HBN protocol state in a target repository:

```bash
hbn init
```

Initialize and auto-detect the runtime adapter based on environment signals:

```bash
hbn init --runtime auto
```

Create a disposable local sandbox with starter guidance:

```bash
hbn quickstart --target /tmp/hbn-sandbox --runtime auto
```

Diagnose onboarding and next steps for a target:

```bash
hbn doctor --target /tmp/hbn-sandbox
```

Inspect the connector contract, privacy model, and delivery strategy:

```bash
hbn connector inspect --target . --interface shell
```

Ensure the correct bridge path with explicit approval and local records:

```bash
hbn connector ensure --target . --interface shell
```

Translate a natural HBN entry into the machine path for the current environment:

```bash
hbn translate "use hbn analyze this system" --target .
```

This translation path now also profiles human language, host device, target
technology, and connector strategy with explicit approval policy.

The connector strategy now distinguishes:

- implementation language of the connector
- delivery language chosen for the destination environment
- coupling mode chosen for the destination environment
- whether the bridge should be embedded in target code or installed in the host
- whether HBN can assume the process immediately or must ask for approval/manual input
- the local-only privacy contract for connector discovery and bridge construction

## Universal Translator (estado atual)

Em v0.3.0, o Universal Translator esta em estagio Routed da Phagocytosis. Ele reconhece a tecnologia como alvo possivel, detecta sinais de ambiente e direciona a execucao para o runtime adapter ou connector apropriado. Ele nao carrega conhecimento profundo sobre como cada tecnologia se comporta e nao realiza traducao semantica entre linguas humanas ou entre tecnologias.

O nome Universal Translator e mantido por decisao humana porque descreve a visao de longo prazo. O estado atual honesto e: roteador de ambiente + resolvedor de connector, com evolucao documentada em [`docs/PHAGOCYTOSIS.md`](docs/PHAGOCYTOSIS.md).

## Phagocytosis: como o HBN aprende novas tecnologias

Phagocytosis e a doutrina canonica para incorporar tecnologias ao HBN de forma progressiva, reversivel e sob controle humano. O caminho e `routed` -> `studied` -> `digested` -> `mastered` -> `contributed`. Cada tecnologia deve avancar por PR, evidencia e Hearback humano; saltar estagios nao e permitido. Em `routed`, HBN apenas detecta e roteia. Em estagios posteriores, pode passar a citar docs, validar regras, gerar artefatos verificaveis e delegar para pacotes externos. O detalhe normativo esta em [`docs/PHAGOCYTOSIS.md`](docs/PHAGOCYTOSIS.md).

Inspect the current protocol state:

```bash
hbn inspect --target .
```

Run the protocol on a sentence:

```bash
hbn run "use hbn analyze this system"
```

Generate a runtime adapter:

```bash
hbn install --runtime claude-code
```

Other supported runtime targets now include:

- `codex`
- `chatgpt`
- `gemini`
- `antigravity`
- `cursor`
- `copilot`

Refresh all installed runtime adapters in a target after updating HBN:

```bash
hbn refresh --target /path/to/project
```

Check relay baton status:

```bash
hbn relay status --target /path/to/project
```

Handoff the relay baton to another agent:

```bash
hbn handoff --to claude --summary "DEV passed. Review needed."
```

Confirm the most recent pending readback:

```bash
hbn hearback --last --status confirmed
```

Backward-compatible alias:

```bash
usehbn "use hbn analyze this system"
```

Each execution writes:

- a structured execution log to `logs/`
- persistent state to `state/hbn-state.json`
- protocol-local coordination artifacts to `.hbn/` after `hbn init`

Inside `.hbn/`, the current local contract now distinguishes:

- `relay/` for active coordination
- `relay-archive/` for resolved iterations
- `knowledge/` for reusable discoveries between IAs
- `reports/` for concise human-facing output documents
- `connectors/` for local approvals, generated bridges, anonymized remote lookup requests, and connector registry records

## Protocol Flow

The current local flow is:

1. Activation
2. Intent capture
3. Truth barrier
4. Guardian
5. Track classification
6. Readback
7. Hearback
8. Execution
9. ERP result

`safe_track` work requires readback plus hearback confirmation before ERP creation. `fast_track` work can remain lighter, but classification is still explicit.

For human attention during blocked or approval-gated cycles, local targets can now store an alert preference in `.hbn/attention.json` and use:

```bash
hbn attention --mode sound
hbn notify --event human_decision
```

Available modes:

- `sound`
- `flash`
- `silent`

Shortcut for humans during a live cycle:

```text
Digite A para retirar o aviso sonoro ou digite B para apenas piscar a tela quando terminar.
```

## CLI Surface

```bash
hbn version
hbn translate "<sentence>" [--target <path>] [--interface <shell|runtime_adapter>]
hbn init [--target <path>] [--runtime <auto|claude-code|codex|copilot|cursor>]
hbn inspect [--target <path>]
hbn doctor [--target <path>]
hbn quickstart [--target <path>] [--runtime <auto|claude-code|codex|copilot|cursor|chatgpt|gemini|antigravity>]
hbn install --runtime <claude-code|codex|copilot|cursor|chatgpt|gemini|antigravity> [--target <path>] [--force]
hbn refresh [--target <path>]
hbn relay status [--target <path>]
hbn handoff --to <agent_id> --summary <text> [--target <path>]
hbn attention --mode <sound|flash|silent> [--target <path>]
hbn notify --event <security_blocked_suggestion|human_decision> [--target <path>]
hbn run "<sentence>"
hbn readback <exec_id> --agent-id <id> --intent-json <json> --understanding <text> --invariant <text> --plan-step <text>
hbn hearback [<exec_id>] --status <confirmed|rejected|pending> [--last]
hbn result <exec_id> --agent-id <id> --action <text> --outcome <value> --human-status <value> [--env-key key=value]
```

## Example Usage

Base execution:

```bash
hbn run "use hbn review the authentication flow and verify rollback coverage"
```

Readback for `safe_track` work:

```bash
hbn readback exec-001 \
  --agent-id codex \
  --intent-json '{"objective":"review auth","constraints":["no breaking changes"],"risks":["authentication regressions"],"validation_requirements":["run auth tests"]}' \
  --guardian-json '{"status":"warn","warnings":[{"code":"guardian-1","message":"Validation evidence is incomplete."}]}' \
  --understanding "The request is limited to review and incremental hardening." \
  --invariant "Public login API unchanged" \
  --plan-step "Inspect the current authentication flow" \
  --plan-step "List compatible incremental improvements" \
  --out-of-scope "Database schema migration" \
  --residual-risk "Some auth paths may lack automated coverage"
```

ERP after hearback confirmation:

```bash
hbn result exec-001 \
  --agent-id codex \
  --action "Recorded validated review outcome." \
  --outcome executed_with_risk \
  --human-status conditional \
  --readback-id readback-exec-001
```

## Project Structure

```text
usehbn/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── GOVERNANCE.md
├── ROADMAP.md
├── agents/
├── core/
├── docs/
├── examples/
├── reports/
├── schemas/
├── site/
├── src/usehbn/
├── tests/
└── .hbn/
```

Main areas:

- `src/usehbn/`: local runtime implementation
- `schemas/`: protocol contracts
- `core/`: protocol specifications
- `agents/`: repository agent rules
- `reports/`: historical implementation and audit artifacts
- `.hbn/`: active inter-IA coordination and knowledge for this repository
- `get-hbn`: local bootstrap helper for deterministic local installation
- `core/semantic-layer.md`: semantic normalization rules across natural language, commands, and adapters
- `docs/DOMAINS.md`: canonical public-domain and DNS strategy
- `docs/ANALYTICS.md`: visit tracking strategy for the canonical public site
- `docs/SAFE-TESTING.md`: safest public test path without deployment risk
- `docs/CONTRIBUTOR-QUICKSTART.md`: contributor-oriented first-run sequence
- `docs/UNIVERSAL-TRANSLATOR.md`: universal natural-entry translation layer
- `docs/CONNECTORS.md`: connector and bridge contribution model

## Adopted External Protocols

HBN composes openly with external protocols when the integration adds
value without diluting protocol identity. The contract for incorporation
is in `docs/EVOLUTION-POLICY.md` (categories A/B/C, hard limits).

Currently adopted as **category A integrations**:

| External protocol | Document | Role |
|---|---|---|
| [Diataxis](https://diataxis.fr/) | `docs/INTEGRATION-DIATAXIS.md` | docs/ structure for humans (4 quadrants) |
| [llms.txt](https://llmstxt.org/) | `docs/INTEGRATION-LLMS-TXT.md` | curated map for LLM consumption |
| [agents.md](https://agents.md/) | `docs/INTEGRATION-AGENTS-MD.md` | unified agent contract file |
| Glasswing-style preventive security | `docs/INTEGRATION-GLASSWING.md` | domain-specific preventive checks (composing with Truth Barrier + Guardian) |

A first production-scale composition of HBN with all four is documented
as a case study in `docs/CASE-STUDY-CREDENCIAMENTO.md`.

## Governance

HBN is founder-led and review-based. Luis Mauricio Junqueira Zanin is the founder and initial protocol steward. Human review is the root of trust. Safety and protocol integrity take priority over acceleration.

See `GOVERNANCE.md` and `MAINTAINERS.md`.

## Contribution

Contributions are welcome when they improve protocol clarity, implementation discipline, documentation quality, traceability, or test coverage without weakening safety or governance rules.

Start with `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, and `SECURITY.md`.

## License

HBN is released under the GNU Affero General Public License v3.0.

AGPLv3 is used because HBN is intended to remain open and inspectable even when adapted into network-facing systems. Modified network-facing deployments must still make corresponding source available. That protects the protocol from disappearing behind closed operational layers.

See `LICENSE` and `docs/LICENSING.md`.

## What Works Today

The repository currently provides a real local runtime for:

- semantic trigger detection
- structured intent extraction
- local consent storage
- truth barrier and guardian warnings
- execution logging and JSON state persistence
- semantic readback with hearback gating
- ERP result recording linked to readbacks with optional environment capture
- `hbn init` for repository-local protocol state with optional `--runtime auto` detection
- `hbn inspect` for repository-local protocol inspection
- `hbn doctor` for onboarding diagnostics and next-step recommendations
- `hbn quickstart` for disposable safe test targets with starter relay guidance
- `hbn translate` for environment-aware natural-entry translation
- `hbn install` for runtime adapter file generation
- `hbn refresh` for batch adapter refresh across all installed runtimes
- `hbn relay status` for baton ownership and active iteration visibility
- `hbn handoff` for validated relay baton transfer with archive enforcement
- `hbn hearback --last` for quick confirmation of the most recent pending readback
- self-describing adapter fallback that works without CLI installed
- connector strategy resolution across runtime, device, target technology, and human language, with lifecycle and verify limits documented in `docs/MATURITY-MATRIX.md`
- compatibility alias `usehbn`
- `.hbn/relay/` and `.hbn/knowledge/` as the basis for inter-IA continuity
- `.hbn/relay/state.json` as structured relay state for baton tracking
- local bootstrap via `get-hbn`
- packaging metadata prepared through `pyproject.toml`
- distribution metadata prepared for the TestPyPI-first path described in `docs/PUBLISHING-DECISION.md`

## What Does Not Work Yet

This repository does not yet provide:

- native execution inside Codex, Claude Code, Copilot, or Cursor without local adapter installation
- packaged distribution on PyPI
- remote or one-command cross-platform installers
- SaaS or hosted coordination
- relay query or search across knowledge entries
- semantic translation between human languages or between technologies by the Universal Translator
- executable legacy bridge generation; current legacy bridge generation is Stub/scaffold documental
- connector lifecycle enforcement or automatic connector verification
- Guardian or Truth Barrier blocking; both are advisory until a future accepted RFC enables opt-in enforcement

## Current Status

HBN is now at a solid L4 level: installable, inspectable, protocolized, traceable, and able to generate local adapter files for multiple AI runtimes. The relay system now includes structured baton tracking and validated handoff. Adapters include a self-describing fallback block for graceful operation without the CLI.

The repository is currently being managed as a hardened `0.2.x` runtime. Long-
range `v0.3` ideas are being treated as a research and architecture track, not
as immediate implementation commitments. Public distribution via PyPI is the
next delivery milestone. See `docs/EXECUTION-DECISION.md` and `ROADMAP.md`.

For a safe first test before public distribution, use `hbn quickstart` plus
`hbn doctor` and follow `docs/SAFE-TESTING.md`.
