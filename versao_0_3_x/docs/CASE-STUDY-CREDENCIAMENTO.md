# Case study: Credenciamento V12.0.0203

> First production-scale composition of HBN with Diataxis, llms.txt,
> AGENTS.md, and Glasswing-style preventive security.

## Project

[Credenciamento e Rodizio de Pequenos Reparos](https://github.com/...)
(Brazilian municipal small-repairs vendor management).

| Field | Value |
|---|---|
| Domain | Public sector procurement / vendor rotation |
| Language | VBA (Excel `.xlsm`) |
| Public release | TPGL v1.1, source-available, audit-first |
| Authors | Sergio Cintra (creator), Luis Mauricio Junqueira Zanin (V12.x development) |
| AI authors | Codex (V12.0.0202 stabilization), Claude Opus 4.7 (V12.0.0203 stabilization) |

## Why this case study matters

Most HBN deployments to date have been small projects with one or two
AIs and one human reviewer. Credenciamento is different:

- 37 VBA modules, 13 forms, ~21000 lines of code
- 6 stabilization waves over 2 months
- 3 AI runtimes used in series (Claude Opus → Codex → Claude Opus)
- Public-facing with auditability requirements
- Real users (Brazilian municipalities) running the released versions

This makes Credenciamento the first place where HBN's relay/baton
abstraction met sustained multi-IA cycles with real consequences for
"who edits next".

## What was composed

### HBN core

- `.hbn/relay/INDEX.md` — baton ownership, current cycle, next action
- `.hbn/knowledge/` — durable decisions (10 V203 rules, golden rule of
  vba_import package, Glasswing layer)
- `.hbn/readbacks/` — explicit confirmations before safe_track work
- `.hbn/results/` — ERPs linked to readbacks

### Diataxis

- `docs/tutorials/` — onboarding for new integrators
- `docs/how-to/` — concrete recipes (run tests, import package, generate
  evidence)
- `docs/reference/` — VBA API, governance rules, compliance mapping
- `docs/explanation/` — architecture, design decisions, V2 test scenario
  rationale

### llms.txt + AGENTS.md

- `llms.txt` — curated map for LLMs
- `llms-full.txt` — exhaustive index
- `AGENTS.md` — single canonical agent entry; `CLAUDE.md`, `.cursorrules`
  point here

### Glasswing-style preventive security

- 5 vectors documented in
  `.hbn/knowledge/0003-glasswing-style-preventive-security.md`:
  - G1: no untrusted macros in import package
  - G2: config validation before behavior
  - G3: privileged formulas isolated
  - G4: audit log append-only
  - G5: claims proportional to evidence

## Lessons learned

### What worked

1. **Single AGENTS.md eliminated prompt drift.** Before the convergence,
   different AIs had different mental models of the project rules.
   After: all reads from one place.

2. **`.hbn/relay/INDEX.md` made baton conflict visible.** The April 2026
   Onda 1-5 incident (Claude took baton without permission) was hard to
   spot before the relay file existed. Now baton state is explicit.

3. **Glasswing G5 (claims without evidence) caught real cases.** Three
   audit documents in early Ondas claimed "100% testado" — Truth Barrier
   plus G5 forced removal.

4. **Diataxis quadrants reduced doc duplication.** Before: same content
   appeared as both reference and tutorial. After: each piece has one
   home.

5. **llms.txt sped up new-AI onboarding.** First-message-to-productive
   cycle dropped because the AI starts with a curated map, not a tree
   walk.

### What was harder than expected

1. **Migrating existing wave documents to subfolders preserved git
   history but broke external links.** Mitigation: grep -r before mv,
   update all references in one commit.

2. **HBN frontmatter retrofitting on 30+ existing audit documents took
   one full Onda by itself.** Lesson: adopt frontmatter from project
   inception.

3. **Glasswing vectors are project-specific.** The 5 vectors here do not
   transfer directly to web projects. Each domain needs its own list.

4. **The integration is reversible.** Credenciamento can in theory remove
   `.hbn/`, `llms.txt`, and Diataxis quadrants and operate without them.
   The integrations enhance but do not lock in.

## Replication cost

For a project of similar scale (~20kloc, 3+ AIs, public release):

| Phase | Effort | Calendar time |
|---|---|---|
| HBN init + relay setup | 1 person-day | day 1 |
| AGENTS.md + llms.txt + llms-full.txt | 0.5 person-day | day 1 |
| Diataxis quadrant migration | 1-2 person-days | day 2-3 |
| Glasswing vector authoring | 0.5-1 person-day per 5 vectors | day 3 |
| Frontmatter retrofit on existing docs | depends on doc count | day 2-5 |

Total for a 30-doc project: ~5 person-days. For Credenciamento
specifically, Onda 6 (consolidation) was scoped as 1 chat session of
focused execution by Claude Opus.

## Measured outcomes

To be filled in after V12.0.0203 ships publicly. Targets:

- Time-to-first-productive-action for new AI: <5 minutes (read
  AGENTS.md, generate readback, get hearback)
- Doc duplication: 0 (each fact has one canonical home)
- Public repo size: <10 MB (down from ~80 MB pre-Onda 6)
- Glasswing violations caught in pre-onda checks: TBD

## Reference

- Credenciamento repo: TBD (after public push of V12.0.0203)
- Credenciamento `.hbn/relay/INDEX.md` (snapshot): see Credenciamento
  repo
- This integration was composed by Luis Mauricio Junqueira Zanin and
  Claude Opus 4.7 (Cowork) on 2026-04-28 during Onda 6 of V12.0.0203
  stabilization.
