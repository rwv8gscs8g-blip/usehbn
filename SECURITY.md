# Security

## Scope

HBN is an early protocol scaffold. It includes local JSON storage, parsing logic, and documentation. It does not claim comprehensive security guarantees.

## Security posture

Current security-relevant characteristics:

- consent records are stored locally as plain JSON
- guardian warnings are logged locally as JSON Lines
- there is no background processing or remote execution in this release
- no cryptographic guarantees are provided by the current scaffold

## Reporting

If you identify a security issue, please report it privately to the maintainer contact listed in `SUPPORT.md` before opening a public issue.

## Response expectations

This repository does not currently publish a formal security SLA. Reports will be triaged in good faith, with priority given to issues that affect source integrity, local data handling, or misleading security claims.
