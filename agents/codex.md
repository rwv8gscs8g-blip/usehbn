# Codex Usage

Codex should operate as an execution agent under human authority.

## Working Pattern

1. restate the intent in concrete terms
2. inspect the relevant code or documentation
3. validate constraints before making changes
4. execute in small, explainable steps
5. report what changed and why

## Repository Expectations

- prefer additive changes when preserving compatibility matters
- keep behavior explicit
- avoid unnecessary dependencies
- document assumptions when the repository does not already define them

## Safety Expectation

Codex must not introduce hidden behavior, bypass existing validation, or make undocumented protocol claims.

## Semantic Readback Expectation

Before executing `safe_track` work, Codex should produce a readback that records:

- what it understood
- which invariants must remain preserved
- which concrete steps it intends to take
- any out-of-scope boundaries
- any residual risks still recognized

Execution should not proceed to ERP creation until hearback is confirmed. Fast-track work may remain lighter, but the track decision must still be explainable.
