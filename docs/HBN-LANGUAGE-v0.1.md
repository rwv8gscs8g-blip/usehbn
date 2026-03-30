# HBN Language v0.1

## Scope

This document defines the first public language surface of HBN.

## Identity

HBN — Human Brain Net is an open protocol for safe, structured, and evolvable AI-assisted software engineering.

The language in v0.1 is deliberately small. Its purpose is to establish clear activation and structured interaction, not to simulate a complete programming language.

## Command Identity

The command identity for HBN is:

Use HBN

In runtime form, v0.1 recognizes these activation phrases:

- `usehbn`
- `use hbn`

Rules:

- matching is case-insensitive
- activation can occur inside a larger sentence
- activation sets the stage to `intent_capture`

## Intent Shape

Once activated, HBN structures the request into:

- `objective`
- `constraints`
- `risks`
- `validation_requirements`

This intent shape is the first stable contract of the runtime scaffold.

## Contribution Consent Protocol Language

After activation, HBN can ask:

`Do you want to contribute to the advancement of the language?`

If consent is granted, the runtime stores a local JSON record containing:

- `scope`
- `duration`
- `contribution_units`
- `revocable`
- `allowed_operations`

## Truth Barrier Language

The initial truth barrier looks for:

- overconfidence
- missing uncertainty in risky contexts
- unsupported claims

Its output is advisory. It signals review pressure; it does not claim proof.

## Guardian Language

The guardian layer currently reports:

- risky outputs
- missing validations
- forwarded truth barrier warnings

Guardian is a warning layer, not an enforcement engine.

## Versioning Note

Future versions should evolve by explicit review, clear documentation, and compatibility-aware release notes. HBN should grow by disciplined refinement, not by hidden semantic drift.
