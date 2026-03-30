# Publishing

## Current Publishing Posture

HBN now has:

- local bootstrap via `get-hbn`
- packaging metadata bootstrapped through `pyproject.toml`
- setuptools configuration in `setup.cfg`
- a primary CLI name of `hbn`
- a distribution name still set to `usehbn`

This means HBN is prepared for packaging review, but not yet claiming that the package is published on PyPI.

## Release Preconditions

Before public package publication:

1. run the full test suite
2. verify `hbn version`, `hbn inspect`, and `hbn install --runtime ...`
3. verify `./get-hbn` on a clean local checkout
4. confirm the public package name strategy
5. confirm release notes and changelog

## Name Strategy

Current state:

- Python distribution: `usehbn`
- primary CLI: `hbn`
- semantic trigger: `usehbn` / `use hbn`
- canonical semantic references: `usehbn.com` / `usehbn.org`

This is intentional for now. Public publication should validate whether `hbn` is available as a package name before any rename.

## Recommended Publication Sequence

1. validate package-name availability
2. keep current distribution name if conflict exists
3. build a source distribution and wheel in CI or a controlled local environment
4. publish only after the README and changelog match the real shipped behavior

## Non-Goals of This Stage

- automatic upload to package indexes
- hidden install flows
- remote bootstrap scripts
- runtime-native orchestration claims
