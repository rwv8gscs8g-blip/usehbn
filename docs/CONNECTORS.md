# Connectors

Nota de estado v0.3.0: Connectors operam em estagio Routed (ver
`docs/PHAGOCYTOSIS.md`). Lifecycle states formais
(`detected`/`resolved`/`installed`/`verified`/`active`/`revoked`) começam a ser
registrados na Onda 4 sem enforcement. "Active" por presença de arquivo é
convenção provisória, não prova de funcionamento.

## Purpose

HBN connectors are the explicit bridge layer between:

- the human and their language
- the intelligence interface in use
- the host device and operating environment
- the target technology being interacted with

The connector layer exists so HBN can adapt to:

- Codex, Claude Code, Cursor, Copilot, Gemini, and future runtimes
- shell, browser, voice, embedded, and runtime-adapter surfaces
- legacy or constrained targets such as VBA, COBOL, Pascal, Lua, C++, Swift, Unix terminals, Linux environments, and future technologies

## Core Rule

Connectors are **not** silent downloaders. They are governed bridges.

Every connector decision must be:

- explicit
- inspectable
- bounded by trust policy
- documented
- human-approved when required

## Current Connector Model

The current repository now includes:

- connector catalog: `src/usehbn/connectors/catalog.py`
- human/device/technology profiling: `src/usehbn/connectors/profiles.py`
- trust policy: `src/usehbn/connectors/trust.py`
- connector strategy resolver: `src/usehbn/connectors/resolver.py`
- operation contract layer: `src/usehbn/connectors/contracts.py`
- local registry and approval storage: `src/usehbn/connectors/storage.py`
- discovery/build flow: `src/usehbn/connectors/discovery.py`
- anonymized remote lookup helpers: `src/usehbn/connectors/remote.py`

## What a Connector Describes

Each connector descriptor identifies:

- runtime family
- supported interface surfaces
- supported human languages
- supported target technologies
- implementation language of the translator bridge
- delivery languages for the destination technology
- coupling mode with the target system
- selected delivery language for the current environment
- selected coupling mode for the current environment
- installation mode
- source and trust level
- whether human approval is required

## Implementation Language vs Delivery Language

These are different things.

- **Implementation language**: the language used to implement the connector logic inside HBN
- **Delivery language**: the language or artifact format delivered into the target environment

Example:

- a connector can be implemented in Python
- but deliver bridge output in VBA, Pascal, C, shell, markdown, or another target-native form

This distinction is necessary because the best delivery format is determined by
the destination technology, not by the language used to build the HBN runtime.

## Coupling Modes

Connectors may attach to the target in different ways:

- `runtime_adapter`: external instruction file for an AI runtime
- `bootstrap_wrapper`: local wrapper installed in the host environment
- `embedded_target_code`: bridge logic delivered directly into the target code or technology
- `documentary_bridge`: structured protocol guidance delivered without executable embedding

This allows HBN to choose the most compatible and least invasive route for the
environment at hand.

In some targets, the best option is **not** an external installation. It is a
bridge delivered inside the destination technology itself.

The resolver now makes that explicit by producing:

- `selected_delivery_language`
- `selected_coupling_mode`
- `delivery_target`
- `requires_host_installation`
- `prefer_embedded_delivery`

## Approval Rules

Aviso de maturidade: estas regras descrevem o contrato operacional e a
politica esperada. Enforcement real depende de `docs/rfc/RFC-0001-enforce-mode.md`
e fica em v0.4+; em v0.3.0, Guardian e Truth Barrier continuam advisory.

### Approved first-party connectors

These may be auto-activated when the environment matches:

- Codex
- Claude Code
- Cursor
- Copilot

### Bridges requiring approval

These require explicit human approval before installation or activation:

- legacy bridges
- unknown connectors
- connectors that require GitHub lookup
- connectors whose source is not approved

## Operational Contract

The connector layer now distinguishes three user-facing operating states:

1. `ready_to_assume_process`
   When a compatible skill or bridge is already active in the environment, HBN
   should assume the process and continue with protocol execution.

2. `approval_required_before_build` or `ready_to_build_connector`
   When a connector is known but not yet active, HBN should offer to discover
   the environment, identify the technology, and build the bridge in the most
   compatible delivery language.

3. `requires_bridge_choice`
   When no approved connector matches, HBN should offer:
   - automatic discovery and bridge construction, with explicit approval
   - manual entry of runtime, device, target technology, human language, and preferred delivery language

This contract is produced in code by:

- `src/usehbn/connectors/contracts.py`

and returned through the translator as `connector_contract`.

The official CLI surface is now:

- `hbn connector inspect --target .`
- `hbn connector ensure --target .`

## Privacy And Data Handling

The connector layer is designed for privacy by default and local-first
operation.

That means:

- no personal identity is required to resolve a connector
- no personal data should be collected externally by default
- no external persistence should happen by default
- any remote lookup requires explicit human approval
- remote lookup, when approved, should use only an anonymized technical descriptor
- connector artifacts and approvals remain on the user's machine

The current contract encodes these principles explicitly as:

- `stores_only_on_user_machine`
- `external_collection`
- `external_persistence_by_default`
- `personal_identity_required`
- `remote_lookup.authorization_required`
- `remote_lookup.allowed_payload_scope`
- `remote_lookup.forbidden_payload_scope`

This is intended to align the connector flow with GDPR-style principles such as
data minimization, purpose limitation, storage limitation, and privacy by
default. It is a technical design goal, not a legal certification claim.

## Local Registry Layout

Connector operations now persist only local records under:

- `.hbn/connectors/registry.json`
- `.hbn/connectors/approvals/`
- `.hbn/connectors/generated/`
- `.hbn/connectors/requests/`

This gives HBN an explicit local audit trail for:

- approved bridge construction
- assumed existing bridges
- generated connector artifacts
- anonymized remote lookup requests

## Contribution Model

The connector architecture is intended to open contribution paths for specialists
in specific technologies.

Example contributor profiles:

- a VBA specialist implementing an Excel/VBA bridge
- a COBOL specialist implementing a mainframe bridge
- a Swift specialist implementing an Apple-device bridge
- a Lua or Pascal specialist implementing connectors for constrained or niche systems

The expected contribution shape is:

1. add a connector descriptor
2. add profile detection signals if needed
3. declare implementation language, delivery languages, and coupling modes
4. add trust policy expectations
5. add tests
6. document the bridge and its constraints

The specialist does not need to rewrite the whole translator. They only need to
declare and implement the bridge for their technology in a way that matches the
connector contract.

## Human Language Inclusion

HBN connectors must carry human language as a first-class profile signal.

This enables future contribution points for:

- accepted language tables
- natural-anchor localization
- language-specific translation policies
- cultural and script-level adaptation

The current implementation detects language from locale hints. That is only the
first step, not the final design.

## Compatibility Direction

The connector model is being shaped so HBN can choose the most adequate and
possible technology for the proposed environment.

That means:

- the bridge may remain external when that is safer
- the bridge may be embedded into the target when that reduces friction
- the bridge may be delivered in the target language itself when that avoids unnecessary installation
- the resolver should make that choice explicitly rather than hiding it inside a generic install path

This is especially important for:

- Unix and Linux environments
- constrained terminals
- legacy systems
- languages such as Lua, Pascal, C++, Swift, COBOL, VBA, and future technologies

## Long-Term Direction

Connectors are the practical contribution surface that makes the universal
translator extensible. This is where HBN becomes capable of maturing across:

- new AI runtimes
- new device classes
- legacy systems
- new human languages
- technologies that do not yet exist
