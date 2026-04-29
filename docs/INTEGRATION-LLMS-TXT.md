# Integration: llms.txt

> Category A integration (per `docs/EVOLUTION-POLICY.md`). HBN composes
> with llms.txt without absorbing it.

## What llms.txt is

The [llms.txt standard](https://llmstxt.org/) is a markdown file at the
root of a project that provides a **curated map of the project for LLMs**.
It complements (does not replace) `README.md`. Format:

```markdown
# <Project Name>

> <one-sentence summary>

<optional prose>

## <Section>

- [Link title](path/to/file): description after the colon
```

A companion file `llms-full.txt` provides an exhaustive index of all
indexable pages — analogous to a sitemap, but optimized for LLM
consumption.

## Why HBN composes with llms.txt

HBN's `.hbn/relay/INDEX.md` already provides cycle-level coordination
for AIs. `llms.txt` provides **project-level navigation** for LLM
ingestion. The two are at different granularities:

- `llms.txt`: "to understand this project, start here, here, and here."
- `.hbn/relay/INDEX.md`: "the cycle in progress is owned by X, next
  action is Y."

A repo that exposes both is navigable by both single-shot LLM queries
(via `llms.txt`) and continuous AI workers (via `.hbn/`).

## Recommended layout

```
project/
  llms.txt                <- curated map (~1 page)
  llms-full.txt           <- exhaustive index (auto-generated or hand-maintained)
  AGENTS.md               <- agent contract (HBN-aware)
  .hbn/relay/INDEX.md     <- cycle coordination
```

## Generation

Most projects keep `llms.txt` hand-maintained because the curation is
the value. `llms-full.txt` can be auto-generated from a tree walk:

```bash
# Naive llms-full.txt generator:
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" \
  | sort \
  | sed 's|^|- [|;s|$||' > llms-full.txt
```

## Minimal example

`llms.txt` for a small HBN-governed project:

```markdown
# My Project

> A small library for X, governed by HBN, documented per Diataxis.

## Entry for AIs

- [AGENTS.md](AGENTS.md): agent contract
- [.hbn/relay/INDEX.md](.hbn/relay/INDEX.md): current baton owner
- [.hbn/knowledge/INDEX.md](.hbn/knowledge/INDEX.md): durable decisions

## Documentation

- [docs/tutorials/](docs/tutorials/): learning
- [docs/reference/API.md](docs/reference/API.md): API reference
- [docs/explanation/ARCHITECTURE.md](docs/explanation/ARCHITECTURE.md): why we built it this way
```

## Out of scope

- HBN does not parse llms.txt. The format is for LLM consumers.
- HBN does not enforce llms.txt content. Maintainers curate.
- Auto-generation tools live outside HBN.

## Reference

- llms.txt canonical: https://llmstxt.org/
- Mintlify implementation: https://www.mintlify.com/docs/ai/llmstxt
- Fern reference: https://buildwithfern.com/learn/docs/ai-features/llms-txt
