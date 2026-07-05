# Integration: CLA-controlled access for source-available projects

> Category A integration (per `docs/EVOLUTION-POLICY.md`). HBN composes
> with a "public-auditable + CLA-controlled tooling" governance model
> without absorbing it as core protocol.

## Context

Some open-source projects need a middle ground between fully open
(everyone clones everything) and fully proprietary (no public access).
The "source-available with controlled tooling" model achieves this:

- **Source code of the product** is fully public and auditable.
- **Documentation, evidence, governance** is fully public.
- **Tooling that can modify the operational package** is restricted to
  contributors who signed the project's CLA.

This pattern is common in critical-infrastructure software, government
systems, and projects with strong supply-chain integrity requirements.

## Why HBN composes with CLA-controlled access

HBN focuses on **how AI-assisted engineering work flows**. CLA-controlled
access focuses on **who has authority to modify operational tooling**.
They operate at different layers:

- HBN: did the AI go through readback before changing code? Was hearback
  confirmed?
- CLA-controlled access: does this contributor have authorization to
  receive and modify the operational tooling?

Together they create a project where:

- the AI cannot bypass review (HBN)
- the human contributor cannot modify operational tooling without
  formal commitment (CLA)
- auditors can verify everything that matters (public docs + public code)

## Project structure pattern

```
project-root/
  README.md                    # public
  LICENSE                      # public (source-available)
  CLA.md                       # public CLA text
  CONTRIBUTING.md              # public flow
  src/                         # public — product source
  docs/                        # public — Diataxis structure
  auditoria/ or audit/         # public — evidence, rules
  .hbn/                        # public — HBN coordination
  obsidian-vault/              # public — institutional showcase
  local-ai/                    # CLA-CONTROLLED — gitignored
    scripts/                   # tooling that operates the product
    package/                   # operational artifacts (e.g., import
                               # bundles for compiled targets)
    historico/                 # internal historical snapshots
    incoming/                  # raw exports for analysis
```

The `.gitignore` includes `local-ai/` (or equivalent path).

## Three distribution models for the CLA-controlled content

### A — Private mirror repository

Maintainer keeps a parallel private repo (e.g., `<project>-tooling-private`)
with the `local-ai/` content fully versioned. Contributors with signed
CLA receive read/write access. Best for teams of 5+ active contributors.

### B — Release zip (recommended start)

Maintainer packages `local-ai/` as encrypted zip per release. After CLA
signed and validated, contributor receives unique download link with
sha256 checksum and decryption password through separate channel. Best
for projects starting out or with infrequent contributors.

### C — Git submodule with private remote

`local-ai/` is a git submodule pointing to a private repository.
Contributors with SSH keys deployed receive submodule content
automatically on clone. Best for teams with managed SSH key
distribution.

## Integration with other HBN concepts

### With Truth Barrier

When AI executor proposes a commit that promotes content from
`local-ai/` to public, the readback should explicitly state the
intention and the human reviewer must explicitly confirm. The Truth
Barrier flags claims like "this is just a script" or "this needs to
be public for auditability" without supporting evidence.

### With Glasswing-style preventive checks

Add a project-specific Glasswing vector (suggested code: G9):

> G9 — Public/CLA segregation respected. AI executor must verify
> before generating PR or commit that no CLA-controlled file was
> promoted to public, and no runtime dependency from public product
> code was introduced into CLA-controlled content.

Verification: `git diff --name-only HEAD` checks no `local-ai/...`
appears in staged content. `grep -rE "local-ai/" src/` confirms
product code is independent.

### With relay/baton system

When baton is granted to an AI working on the project, the relay
record explicitly states whether the AI has access to CLA-controlled
content. AI without access operates in audit mode only and cannot
generate operational changes.

## License compatibility

This model is compatible with:

- **Source-available licenses** (BSL, SSPL, TPGL v1.1, custom)
- **Time-bounded restrictions** (e.g., "auto-converts to OSI-approved
  license after N years")
- **Contributor License Agreements** (Apache CLA-style, project-specific)

It is **not** compatible with strict OSI definition of open-source
because of the CLA-controlled tooling layer. Projects that need OSI
approval cannot adopt this model directly — they would need to
publish the tooling under the same OSI license.

## Reference instantiation: Credenciamento V12.0.0203

The Brazilian municipal Credenciamento project adopted this model in
April 2026:

- License: TPGL v1.1 (source-available, auto-converts to Apache 2.0
  in 4 years per release)
- Distribution model: B (release zip)
- Vectors: G7 (vba_import sync) + G8 (Public Type isolated) +
  G9 (planned)
- Documentation:
  - `Credenciamento/.hbn/knowledge/0007-acesso-controlado-via-cla.md`
    (HBN-native protocol)
  - `Credenciamento/docs/explanation/MODELO_DE_ACESSO_CONTROLADO.md`
    (Diataxis explanation)
  - `Credenciamento/docs/how-to/COMO_OBTER_FERRAMENTAS_VBA.md`
    (Diataxis how-to)
  - `Credenciamento/docs/reference/MATRIZ_PUBLICO_VS_CLA.md`
    (Diataxis reference)

## How to adopt in your project

1. Decide the categorization: which content is public, which is
   CLA-controlled.
2. Add `local-ai/` (or your equivalent path) to `.gitignore`.
3. Write a CLA appropriate to your jurisdiction. The Credenciamento
   CLA follows Brazilian Law 9.610/98 — adapt for your context.
4. Choose distribution model A, B, or C based on team size.
5. Document the model publicly in 4 layers:
   - HBN-native protocol in `.hbn/knowledge/`
   - Diataxis explanation in `docs/explanation/`
   - Diataxis how-to in `docs/how-to/`
   - Diataxis reference in `docs/reference/`
6. Add Glasswing G9 (or equivalent) to your preventive checks.
7. Update CLA and CONTRIBUTING with explicit clauses on tooling access.

## Out of scope

- HBN does not enforce the segregation. The project does that via
  `.gitignore` and operational discipline.
- HBN does not host the release zips. The maintainer chooses the
  hosting (Box, Drive, S3, private email).
- HBN does not validate CLA signatures. The maintainer does manually
  or via signed-off-by in commits.

## Reference

- Credenciamento case study: `docs/CASE-STUDY-CREDENCIAMENTO.md`
- Glasswing vectors: `docs/INTEGRATION-GLASSWING.md`
- License frameworks compatible with this model:
  - Business Source License (BSL)
  - Server Side Public License (SSPL)
  - Termo de Promessa de Garantia de Liberdade (TPGL) v1.1
