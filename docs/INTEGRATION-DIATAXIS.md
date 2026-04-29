# Integration: Diataxis

> Category A integration (per `docs/EVOLUTION-POLICY.md`). HBN composes
> with Diataxis without absorbing it.

## What Diataxis is

[Diataxis](https://diataxis.fr/) is a documentation framework by Daniele
Procida. It organizes technical documentation into four quadrants based
on user need:

| Quadrant | User need | Content type |
|---|---|---|
| Tutorials | learning | step-by-step, hands-on |
| How-to guides | problem | cookbook, focused recipe |
| Reference | consulting | API, rules, complete spec |
| Explanation | understanding | architecture, decisions, context |

Each quadrant serves a different need; mixing them produces docs that
serve none well.

## Why HBN composes with Diataxis

HBN governs **the act of AI-assisted engineering** (intent, readback,
results, relay). Diataxis governs **the documentation that humans and
LLMs read about a project**. They are orthogonal axes:

- HBN says: "this readback was confirmed at 2026-04-28."
- Diataxis says: "this content is reference, not tutorial."

Together they make a project that an AI can navigate (HBN tells it
which baton it has) and a human can learn from (Diataxis tells them
where to start).

## How a project uses both

```
project/
  AGENTS.md              <- HBN entry (status markers, baton, readbacks)
  .hbn/                  <- HBN coordination
  docs/
    tutorials/           <- Diataxis: learning
    how-to/              <- Diataxis: problem
    reference/           <- Diataxis: consulting
    explanation/         <- Diataxis: understanding
```

The integration is purely structural. No HBN change is needed.

## Frontmatter contract (recommended)

For every `.md` in `docs/`:

```yaml
---
titulo: ...
diataxis: tutorial | how-to | reference | explanation
audiencia: humano | ia | ambos
hbn-track: fast_track | safe_track
---
```

This lets RAG pipelines filter by Diataxis quadrant ("show me only
tutorials") and HBN-aware tooling filter by track.

## Minimal example

```bash
# Project with HBN already initialized:
hbn init

# Add Diataxis structure:
mkdir -p docs/{tutorials,how-to,reference,explanation}

# First tutorial:
cat > docs/tutorials/01-getting-started.md <<EOF
---
titulo: Getting started
diataxis: tutorial
audiencia: humano
hbn-track: fast_track
---

# Getting started
...
EOF
```

## Out of scope

- HBN does not impose Diataxis. Projects can use any structure.
- HBN does not parse `diataxis:` frontmatter. That's the project's job.
- This integration document does not define new HBN concepts.

## Reference

- Diataxis canonical site: https://diataxis.fr/
- LangChain docs (case study): https://python.langchain.com/
- Adoption note: Diataxis is widely adopted in the LLM-tooling
  ecosystem (Numpy, Django, LangChain, StreamingFast).
