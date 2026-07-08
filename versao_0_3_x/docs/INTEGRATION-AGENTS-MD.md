# Integration: AGENTS.md

> Category A integration (per `docs/EVOLUTION-POLICY.md`). HBN composes
> with the AGENTS.md format without absorbing it.

## What AGENTS.md is

[agents.md](https://agents.md/) is a simple, open format for guiding
coding agents. It is "a README for agents" — a single canonical file at
the root of a repository (and optionally per subproject) that contains
build steps, test commands, conventions, and other context an AI coding
agent needs to be useful in the codebase.

The format is informal but the role is clear: it is the file the agent
reads first.

## Why HBN composes with AGENTS.md

Before HBN, AI assistants used a fragmented set of instruction files:
`.cursorrules`, `CLAUDE.md`, `.github/copilot-instructions.md`,
`.codex/INSTRUCTIONS.md`, etc. Each with its own audience and format.

`AGENTS.md` is the convergence point. By writing one `AGENTS.md` and
having `CLAUDE.md` / `.cursorrules` / etc. point to it, a project gets:

- single source of truth
- agent-agnostic instructions
- consistent contract regardless of which AI executes

HBN benefits because:

- HBN status markers (`✅ HBN ACTIVE`, etc.) belong in `AGENTS.md`
- Pointer to `.hbn/relay/INDEX.md` belongs in `AGENTS.md`
- Glasswing-style preventive checks belong in `AGENTS.md`

## Recommended structure

```markdown
# AGENTS.md

## Identity
| Field | Value |
| name | ... |
| version | ... |
| protocol | HBN 0.2.x |

## Before any action
1. Read `.hbn/relay/INDEX.md`.
2. Read knowledge entries flagged "always read".
3. Generate readback if work is safe_track.

## Working pattern
- Wave-based cycles
- Readback before destructive change
- Hearback explicit

## Build steps
...

## Test patterns
...

## Convencoes de codigo
...

## Mapas para LLMs (RAG)
- `llms.txt`
- `llms-full.txt`

## Quem tem o bastao agora
See `.hbn/relay/INDEX.md`.

## License + ethics
...
```

## Minimal example

```bash
# Project with HBN already initialized:
hbn init

# Create AGENTS.md pointing to .hbn/:
cat > AGENTS.md <<EOF
# AGENTS.md

## Before any action
1. Read .hbn/relay/INDEX.md
2. Read .hbn/knowledge/INDEX.md
3. Generate readback in .hbn/readbacks/ if safe_track

## Build
...
EOF

# Have CLAUDE.md just point to AGENTS.md:
cat > CLAUDE.md <<EOF
# CLAUDE.md
See AGENTS.md.
EOF
```

## Out of scope

- HBN does not parse AGENTS.md.
- HBN does not enforce AGENTS.md content.
- Multi-agent orchestration is out of scope (HBN handles relay between
  agents already; AGENTS.md just documents that relay).

## Reference

- agents.md canonical: https://agents.md/
- GitHub: https://github.com/agentsmd/agents.md
- OpenAI Codex guide: https://developers.openai.com/codex/guides/agents-md
