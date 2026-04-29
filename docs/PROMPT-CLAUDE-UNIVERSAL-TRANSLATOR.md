# Prompt for Claude Opus — HBN Universal Translator

Use this prompt when asking Claude Opus to specify the HBN universal
translator as a protocol-grade architecture.

```text
You are acting as a senior protocol architect and systems designer.

I need you to specify, in depth, a universal natural-entry translator for HBN (Human Brain Net).

Context:
- HBN is not just a CLI. It is a semantic protocol layer.
- Canonical anchors are: usehbn, use hbn, usehbn.org, usehbn.com.
- These anchors should survive transitions between human language, machine commands, runtime adapters, and future interface technologies.
- We are building a system that should let a human express "use hbn ..." naturally, and have the system detect the environment, identify the active interface, and translate the instruction into the correct machine path.
- Environments include shell, Codex, Claude Code, Cursor, Copilot, and future runtimes not yet known.
- This translator logic is also intended to become the architectural base for later legacy-system translation and adaptation work.

Please produce a rigorous architectural specification for an HBN Universal Translator with the following goals:

1. It must accept natural entry in human language.
2. It must detect the current environment, runtime, interface surface, and available translation paths.
3. It must normalize all semantic anchors to a canonical internal HBN identity.
4. It must select the correct execution path for the current environment.
5. It must be extensible to technologies and interfaces that do not yet exist.
6. It must support partial or degraded operation when the full HBN CLI is not available.
7. It must preserve human authority and never silently escalate scope.
8. It must be designed so that the same architecture can later support legacy bridges (for example VBA, COBOL, terminal systems, or other constrained interfaces).

I want the output structured as a serious protocol/architecture document, not a casual brainstorm.

Required sections:
- Intent
- Problem definition
- Principles
- Translation model
- Environment detection model
- Interface surface taxonomy
- Canonical normalization rules
- Translation routing logic
- Fallback/degraded mode behavior
- Security and truth-boundary rules
- Extension model for future runtimes
- Extension model for legacy technologies
- Data structures / schemas
- Reference implementation roadmap
- Risks and mitigations
- Open questions

Additional constraints:
- Do not treat this as shell-only.
- Do not reduce it to prompt engineering.
- Do not assume current technologies are the final ones.
- Be explicit about what is protocol logic versus implementation detail.
- Be explicit about how natural human language becomes machine execution without losing semantic continuity.
- Be explicit about how a terminal command like "use hbn ..." should be supported without weakening the multi-runtime model.

Classify the result as a protocol hypothesis requiring human validation before implementation.
```
