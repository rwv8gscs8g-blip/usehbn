# Intent Risk Matrix

## Objective

This matrix gives maintainers and contributors a shared starting point for interpreting HBN intent fields.

| Intent pattern | Example | Risk level | Expected validation posture |
| --- | --- | --- | --- |
| Read-only analysis | `usehbn analyze this system` | Low | Human review of summary may be enough |
| Refactoring with constraints | `use hbn refactor this module without breaking tests` | Medium | Existing tests plus targeted regression checks |
| Authentication or security work | `usehbn review authentication logic` | High | Explicit rollback and validation requirements |
| Data migration or deletion | `use hbn migrate this schema` | High | Staged validation, backups, and rollback planning |
| Production-sensitive change | `usehbn deploy this fix to production` | High | Change review, validation evidence, and operational controls |

## Interpretation

The matrix is guidance, not policy automation. Risk classifications should remain explicit in code review and release notes when the protocol evolves.
