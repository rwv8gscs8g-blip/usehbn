# Truth Barrier

## Purpose

The truth barrier is an initial protection layer for claim quality. Its job is not to prove statements true. Its job is to reduce the chance that HBN normalizes unsafe confidence or unsupported assertions.

## v0.1 behavior

The current implementation flags:

- certainty language such as guaranteed or perfect
- unsupported phrases such as `100%`, `zero risk`, or `fully secure`
- risky intents that lack an uncertainty or assumption marker

## Output model

Warnings are returned as structured objects with:

- code
- severity
- message
- evidence

## Limits

The truth barrier is heuristic in this release. It is:

- not a verifier
- not a formal safety proof
- not a substitute for testing or review

Its value is early friction against weak claims, not exhaustive adjudication.
