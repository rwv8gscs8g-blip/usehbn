# Contributing

Thank you for contributing to HBN.

This project is protocol-first. Contributions should improve clarity, testability, and governance discipline before they increase scope.

## Ways to contribute

- improve documentation for global readability
- clarify protocol language and terminology
- add tests for existing behavior
- refine schemas and validation logic
- propose governance and review improvements
- suggest runtime changes that remain consistent with the documented protocol

## Contribution expectations

Please keep contributions aligned with the current release principles:

- do not reframe HBN as a product or framework
- do not introduce hidden processing
- do not make unsupported safety or security claims
- do not add speculative intelligence claims
- keep implementation and documentation consistent

## Pull request checklist

Before opening a pull request:

1. explain the change and why it improves the protocol
2. update docs if protocol semantics changed
3. update tests when behavior changed
4. run `python3 -m unittest discover -s tests`
5. keep commit messages explicit and reviewable

## Protocol-sensitive changes

Changes to any of the following deserve extra care:

- trigger semantics
- consent model
- truth barrier rules
- guardian behavior
- schemas
- governance documents
- licensing posture

## Review standard

Pull requests are reviewed for:

- clarity
- coherence with protocol scope
- test coverage or explicit test rationale
- documentation accuracy
- absence of exaggerated claims

## License for contributions

By contributing, you agree that your contributions will be distributed under the repository license: **Apache License, Version 2.0** (`LICENSE` at the repository root). The project migrated from AGPLv3 to Apache 2.0 on 2026-05-10 — see `methodology/adr/ADR-005-licenciamento-apache-cla.md` and `CHANGELOG.md`.

## Developer Certificate of Origin (DCO)

Every contribution must include a `Signed-off-by:` trailer in the
commit message. Use `git commit -s` (or `git commit --signoff`) to add
it automatically. The trailer looks like:

```
Signed-off-by: Your Name <your.email@example.com>
```

By adding this trailer, you certify the **Developer Certificate of
Origin v1.1** (https://developercertificate.org), which states (in
short): you have the right to submit the contribution under the
project license, and you authorize the project to do so.

This is the lightweight contributor agreement used by the Linux
kernel, CNCF, and other major open-source ecosystems. There is no
separate form to sign — only the `Signed-off-by:` line in each commit.

Per `methodology/adr/ADR-005-licenciamento-apache-cla.md` §2, DCO
enforcement in CI (a `DCO check` GitHub Action that blocks PRs without
the trailer) is **phase 2** and will be activated in a future release.
For now, the requirement is documental. Contributors are encouraged
to start using `git commit -s` immediately so the transition is
seamless.
