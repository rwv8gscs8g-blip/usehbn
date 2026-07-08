# Claude Usage

Claude should operate under the same repository contract defined in `agents/agents.md`.

## Supported Claude variants

This guidance applies to all Claude variants used in HBN-governed work:

- **Claude Code** (CLI tool) — invoked from terminal, has bash + file
  tools by default.
- **Claude API** (programmatic via Anthropic SDK) — invoked from
  application code, tools depend on integration.
- **Claude Cowork** (desktop research-preview product, 2026) — invoked
  from a desktop app on the user's machine, has scoped file tools (Read,
  Write, Edit) plus a sandboxed Linux shell. Cowork sessions interact
  with mounted folders the user explicitly approves.
- **Claude in browser/Chrome** (browsing variant) — invoked from a
  browser-context, has DOM and navigation tools.
- **Claude Desktop chat** — base chat variant.

Models known to support HBN at the time of writing (2026-04): Claude
Opus 4.7, Claude Sonnet 4.6, Claude Haiku 4.5.

## Activation paths

HBN protocol becomes active in a Claude session in any of three ways:

1. **Semantic trigger:** the user types `usehbn` or `use hbn` inside a
   sentence. The Claude variant detects the trigger and switches to HBN
   protocol response mode (markers, readback, hearback gating).
2. **Explicit baton mandate:** the user opens an HBN-governed
   repository, points Claude at `.hbn/relay/INDEX.md`, and grants
   baton ownership in chat. Once baton is granted, the variant operates
   under HBN protocol for that session.
3. **CLI installation:** if the `hbn` CLI is installed on the host
   (via `get-hbn` or `pip install -e .`), Claude Code can invoke
   `hbn run`, `hbn readback`, `hbn result` directly. Cowork and API
   variants typically do not have the CLI installed and rely on
   modes (1) or (2).

If the variant does not see an `hbn` CLI on PATH, mode (2) — explicit
baton mandate — is the canonical activation. Claude Cowork in
particular operates in mode (2) for now.

## Working Pattern

1. Interpret the request precisely.
2. Organize the response around protocol structure.
3. Keep reasoning explainable.
4. Preserve human authority over final decisions.
5. Document results and assumptions.
6. **Before sending a response that contains code that goes into the
   user's product**, stop. Move the code into the appropriate file in
   the repository (e.g., `local-ai/vba_import/...` for VBA, project's
   source folder for other languages). Update the procedure document
   (e.g., `auditoria/03_ondas/onda_NN_*/<NN+1>_PROCEDIMENTO_IMPORT.md`).
   Reply with a path table and operational shell commands, **never the
   product code itself**. This corresponds to Glasswing-style vector G6
   in the Credenciamento case study.

## Repository Expectations

- Preserve the protocol-first identity of HBN.
- Keep documentation readable and globally understandable.
- Avoid speculative claims about future capabilities.
- Treat governance and safety language as part of the system, not as
  side material.

## Safety Expectation

Claude must not conceal reasoning that affects behavior, weaken safety
language, or turn undocumented assumptions into protocol facts.

Claude must not output product code in chat when the project's
operational contract requires file-based delivery (Glasswing-style
vector G6, see `usehbn/docs/INTEGRATION-GLASSWING.md`).
