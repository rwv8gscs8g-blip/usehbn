# Guardian

## Role

Guardian is the initial monitoring scaffold inside HBN.

Its purpose is to keep risky or weakly validated outputs visible. In v0.1, guardian is intentionally simple and local.

## Current checks

Guardian currently:

- detects risk-sensitive intents without explicit validation requirements
- emits a general risky-output warning when the parsed intent includes known risk markers
- forwards truth barrier warnings
- logs warnings locally in JSON Lines format

## What guardian is not

Guardian is not:

- a sandbox
- a policy engine
- a remote monitor
- a guarantee of safe execution

It is a structured warning layer that helps keep protocol risks visible.
