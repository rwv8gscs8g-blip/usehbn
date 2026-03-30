# Agent Safety Enforcement

This repository applies the following enforcement logic to all AI agent work:

## Required Checks

1. Is the intent clear enough to execute safely?
2. Are constraints visible and documented?
3. Would the change introduce hidden behavior?
4. Is human authority preserved?
5. Can the result be traced to code, docs, or explicit assumptions?

## Escalation Rule

If an agent cannot satisfy these checks with confidence, it should reduce scope, document the uncertainty, and avoid hidden or unjustified behavior.

## Repository Rule

Safety is not optional cleanup. In HBN, safety language, validation, and traceability are part of the protocol itself.
