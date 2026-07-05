# VBA Bridge

## Purpose

HBN includes a conceptual VBA bridge because many operational systems still depend on Excel and VBA for business-critical workflows.

The bridge in v0.1 is documentary and conceptual. It is meant to help teams apply HBN protocol principles to legacy environments without pretending that the repository already automates those environments.

## How To Apply HBN To Excel/VBA Systems

1. identify workbook entry points, macros, forms, and module dependencies
2. state the business objective of the change in clear language
3. capture explicit constraints, risks, and validation requirements
4. define invariants before editing the workbook or macro logic
5. require regression evidence before accepting confident claims about correctness

## Example Invariants

- total calculations must remain consistent for a fixed historical dataset
- exported files must preserve the expected structure when integrations depend on them
- form validation rules must not change unless intentionally revised
- macro execution order must preserve the business process it supports

## Regression Prevention

Recommended regression controls for VBA systems include:

- representative workbook fixtures
- before-and-after calculation comparisons
- golden-file comparisons for exports
- explicit rollback paths for workbook releases
- human review of forms, macros, and business-critical outputs

## Current Status

The repository provides:

- a conceptual bridge helper in code
- protocol documentation for intent, risk, and validation framing

The repository does not yet provide Excel automation, VBA execution tooling, or workbook mutation features.
