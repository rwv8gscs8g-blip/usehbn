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

By contributing, you agree that your contributions will be distributed under the repository license: GNU Affero General Public License v3.0.
