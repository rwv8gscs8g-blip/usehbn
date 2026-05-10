# Licensing

## License choice

HBN is released under the **Apache License, Version 2.0**.

The project migrated from AGPLv3 to Apache 2.0 on 2026-05-10. The full
decision (including the analysis of trade-offs against AGPLv3, MIT,
and Apache 2.0 + traditional CLA) is recorded in
[`methodology/adr/ADR-005-licenciamento-apache-cla.md`](../methodology/adr/ADR-005-licenciamento-apache-cla.md).
Historical entries describing the AGPLv3 era are preserved in
`CHANGELOG.md` and in `auditoria/00_status/` (P7 — preserve identity
of what was incorporated).

## Why Apache 2.0

useHBN positions itself as a **universal protocol for AI-assisted
software engineering coordination**, in the same stratum as the Model
Context Protocol (MCP), Language Server Protocol (LSP), OpenTelemetry,
gRPC, and Diataxis. Every one of those peers is Apache- or MIT-licensed.
Adopting Apache 2.0 removes the corporate-adoption friction that AGPLv3
carried (many companies have internal policies that flatly disallow
AGPL dependencies because of fear of viral contamination). Apache 2.0
also grants an explicit patent license, protecting both contributors
and downstream users against patent-troll claims tied to the project's
contributions.

The original AGPLv3 choice was rooted in protecting against closed
network derivatives. That protection trade-off is reduced under Apache
2.0; the mitigation is now structural — strong governance documented
in `GOVERNANCE.md`, public-facing `MAINTAINERS.md`, and the cadence of
upstream evolution itself (a fork that never contributes back falls
behind, reducing capture risk).

## What the license supports

Apache 2.0 allows:

- use (including commercial use)
- study
- modification
- redistribution
- sublicensing
- patent grant from each contributor
- distribution under different license terms for derivative works

under the conditions stated in the license (preserve attribution,
NOTICE file if present, mark modified files, do not use trademarks
without permission, do not initiate patent litigation against the
project on covered works).

## Contributor agreement (DCO)

Contributions must carry a `Signed-off-by:` trailer in each commit
(use `git commit -s`). This implements the **Developer Certificate of
Origin v1.1** (https://developercertificate.org) — the lightweight
contributor agreement used by the Linux kernel and CNCF projects.

There is no separate CLA form. By adding the trailer, the contributor
certifies the right to submit under the project license. See
`CONTRIBUTING.md` and ADR-005 §2 for details.

## No extra claims

The license does not make HBN secure, correct, or complete. It governs
openness, attribution, and patent reciprocity, not engineering quality
by itself.

## Compatibility

Apache 2.0 is compatible with:

- MIT, BSD-2/3-Clause (one-way absorption: Apache can include them)
- LGPL (in linked usage)
- GPLv3 (one-way: Apache code can be included in GPLv3 projects, but
  GPLv3 code cannot be incorporated into Apache-licensed code without
  re-licensing)

This compatibility footprint is one of the main reasons the project
migrated. It enables **fagocytosis** (per `docs/PHAGOCYTOSIS.md`) —
useHBN can incorporate patterns from Apache/MIT peer protocols, and
those peers can absorb useHBN patterns, without licensing friction.
