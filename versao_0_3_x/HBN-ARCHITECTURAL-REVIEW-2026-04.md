# HBN Architectural Review — April 2026

**Reviewer**: Independent Systems Architect (Claude Opus 4.6)
**Codebase version**: 0.2.0
**Test suite**: 88 tests, 100% passing
**Source LOC**: ~4,884 (Python) | **Test LOC**: ~1,588
**Date**: 2026-04-03

---

## PART 1 — FINDINGS BY SEVERITY

### CRITICAL (Blocks credible adoption)

**F-01: The "Universal Translator" is not a translator.**
`src/usehbn/translation/universal.py` does exactly one thing: it detects the string `use hbn` in text, reads environment variables and directory markers, then returns a JSON dict saying "run `hbn run <sentence>`." There is no semantic transformation, no natural-language understanding, no interface adaptation, and no target-language code generation. The function `translate_natural_entry()` is an anchor-routing dispatch table, not a translator. Calling this a "universal translator" in documentation and architecture docs creates a credibility gap that will repel serious adopters. Severity: **critical for adoption trust**, not for runtime safety.

**F-02: Bridge generation produces documentation, not executable bridges.**
The single concrete bridge (`src/usehbn/bridge/vba.py`) returns a Python dict with string recommendations. It outputs `"bridge_type": "conceptual_only"`. There is no VBA code generation, no module scaffolding, no file creation, no AST manipulation. The catalog lists connectors for Python, Java, C, C++, C# — every single one resolves to the same catalog.py file that contains only metadata descriptors. No bridge for any target language generates executable output. The term "bridge" currently means "a JSON document describing what a bridge might do."

**F-03: Guardian and Truth Barrier are regex-based advisories with no enforcement power.**
`truth_barrier.py` scans text for words like "always", "guaranteed", "100%". `guardian.py` checks if `risks` is non-empty while `validation_requirements` is empty. Neither blocks execution. Neither gates any downstream action. Neither integrates with the actual execution pipeline in a way that prevents unsafe outcomes. They produce warnings that are logged and returned in JSON but have zero effect on whether execution proceeds. The protocol flow in the README lists them as steps 3 and 4 of 9, but the engine passes through them unconditionally.

**F-04: State is split across `.hbn/` and project root without clear ownership.**
Execution logs go to `logs/` (project root). Persistent state goes to `state/hbn-state.json` (project root). Readbacks go to `state/readbacks/`. Results go to `state/results/`. Connector approvals, registry, and markers go to `.hbn/connectors/`. Relay coordination goes to `.hbn/relay/`. Knowledge goes to `.hbn/knowledge/`. Consent records go to `state/consents/`. This creates a split-brain problem: a user cloning a repo gets `.hbn/` but not `state/` or `logs/`, and vice versa if gitignoring differently. There is no manifest that declares which directories are protocol-essential versus ephemeral.

### HIGH (Degrades reliability or creates false confidence)

**F-05: Connector "activation" relies on weak evidence.**
`contracts.py::_detect_connector_presence()` considers a connector "active" if any of three signals exist: a `.hbn/connectors/<id>.json` marker file, an `active_runtime_signal` (meaning the runtime was detected in the environment), or `host_shell_entrypoint` (meaning PATH is set and coupling mode is bootstrap_wrapper). None of these prove the connector is actually functional. A `.claude/` directory existing does not mean Claude Code is running. A marker file existing does not mean the bridge works. The evidence model conflates "something was detected" with "the connector is operational."

**F-06: Connector lifecycle has no formal states.**
Connectors jump from "resolved" to "active" via marker file creation. There is no `installed`, `verified`, `revoked`, or `degraded` state. The registry (`registry.json`) only logs events like `"connector_assumed_existing"` — it does not track the current state of any connector. There is no way to query "which connectors are currently active and verified" versus "which were once detected."

**F-07: Remote connector lookup is not implemented.**
`remote.py` contains the function `resolve_remote_connector_descriptor()` which, when called without a registry file (the default), returns `"status": "awaiting_remote_registry"`. The `DEFAULT_REGISTRY_SOURCE` is a GitHub URL that does not exist (`usehbn/usehbn/tree/main/registry/connectors`). The remote lookup path is scaffolded but non-functional.

**F-08: Privacy contract is declarative, not enforced.**
`contracts.py` builds a privacy contract declaring things like `"stores_only_on_user_machine": True`, `"external_collection": False`, and lists `forbidden_payload_scope` fields. But nothing in the runtime validates that outbound data actually conforms to these declarations. The `build_remote_lookup_descriptor()` function does filter fields against the allowed list, which is good — but there is no integration test proving the forbidden fields are never leaked, and no enforcement at the protocol level if a future contributor adds a new outbound path.

**F-09: Intent extraction is shallow regex parsing.**
`intent.py::structure_intent()` uses four regex patterns to extract constraints, validation requirements, risks, and an objective from free-form text. The objective is whatever comes after the trigger phrase. Constraints are anything matching words like "without", "must", "should". Risks are anything matching "risk" or high-risk keywords like "delete", "production". This works for simple English sentences but fails for: non-English input, complex multi-clause sentences, implicit constraints, domain-specific risk language, and any sentence structure that doesn't follow the expected pattern.

### MEDIUM (Creates friction or confuses contributors)

**F-10: Packaging is not yet on PyPI and `get-hbn` is fragile.**
`get-hbn` is a shell script that creates a venv and installs from the local source tree. There is no `curl | sh` installer. There is no PyPI publication. The `dist/` directory contains a built wheel, but it has never been published. First-time onboarding requires git clone plus manual script execution.

**F-11: Runtime adapter body is a 250-line hardcoded string.**
`runtime.py::_adapter_body()` constructs the entire adapter as a Python string concatenation. It includes Portuguese text, emoji markers, detailed protocol instructions, and fallback rules. This is not templated, not i18n-aware, not testable in isolation, and not customizable by the target runtime. Any change requires editing a massive string literal.

**F-12: Schema validation is present but schemas are permissive.**
`validators.py::assert_valid_payload()` validates against JSON schemas, and the test suite confirms this works. However, schemas like `result.schema.json` and `intent.schema.json` accept broad string enums and do not constrain field contents tightly enough to prevent semantic drift. The `hbn_outcome` field, for example, is an enum of 7 values — but nothing prevents a caller from constructing an internally contradictory record.

**F-13: Test coverage is narrow — happy-path focused.**
88 tests all pass, which is a strong signal of internal consistency. But coverage is focused on the happy path: correct inputs, expected environment, single-agent scenarios. There are no tests for: malformed JSON state files, concurrent access to state, race conditions during handoff, adapter generation on non-Unix systems, real remote registry resolution, or adversarial input to the truth barrier.

**F-14: Bilingual interface without i18n infrastructure.**
The adapter body, blocking notices, consent questions, and contract messages mix Portuguese and English. There is no locale framework, no message catalog system (beyond the two-language `_message_catalog()` in contracts.py), and no contributor path for adding additional languages. The `detect_human_language_profile()` reads `$LANG` but the result only selects between "pt" and "everything else" in one place.

### LOW (Polish and evolution items)

**F-15: No versioned protocol wire format.**
The JSON shapes in state, readbacks, results, and contracts have no explicit version field that would allow forward-compatible evolution. If a schema changes, old state files become silently incompatible.

**F-16: `hbn-state.json` is append-only with no compaction.**
The state file grows without bound. Every execution, decision, and context entry is appended. For a long-lived project, this file will become unwieldy. There is no archival, rotation, or summarization mechanism.

**F-17: Connector scoring is opaque.**
`resolver.py::_score_connector()` uses magic numbers (6, 5, 3, 2, 1) for scoring, with no explanation of why these weights were chosen or how they should evolve. Same for `remote.py::_score_registry_connector()`.

---

## PART 2 — MATURITY CLASSIFICATION

### What Is Implemented and Working

These components have real code, real tests, and produce real artifacts:

- Semantic trigger detection (`trigger.py`) — simple, correct, well-tested
- Intent extraction (`intent.py`) — shallow but functional for English
- Truth barrier (`truth_barrier.py`) — regex advisory, works as documented
- Guardian (`guardian.py`) — advisory, works as documented
- Consent protocol (`consent.py`) — creates local JSON records
- Execution engine (`engine.py`) — orchestrates the pipeline, writes logs and state
- Readback/hearback cycle (`readback.py`) — creates records, enforces hearback before ERP
- Result protocol (`result.py`) — creates ERP records with risk flags
- State persistence (`store.py`) — JSON append-only store
- Runtime detection (`runtime.py`) — file-marker and env-var based
- Adapter generation (`runtime.py`) — writes markdown instruction files
- CLI (`cli.py`) — functional entry point with init, run, translate, inspect, doctor, etc.
- Environment profiling (`profiles.py`) — detects OS, shell, language, technology
- Connector resolution (`resolver.py`) — scores and selects connectors from catalog
- Connector storage (`storage.py`) — local filesystem records for approvals and markers
- Privacy-aware remote descriptor builder (`remote.py`) — field filtering works
- Schema validation — present and enforced on key payloads

### What Is Scaffold (Structure exists, behavior is partial or stub)

- Universal translator — routing dispatch, not translation
- Bridge generation — metadata/documentation only, no executable output
- Remote connector lookup — function exists, endpoint does not
- Connector lifecycle — no formal state machine, only marker files
- Guardian enforcement — advisory warnings only, no gating
- Truth barrier enforcement — advisory warnings only, no gating
- Multi-language support — two languages hardcoded in one function
- Privacy contract enforcement — declarations without runtime validation
- Bridge extensibility for legacy technologies — catalog entries without bridge implementations

### What Is Speculative (Described in docs/README but not in code)

- True semantic translation across natural languages and technologies
- Legacy bridge generation that produces executable code for VBA, COBOL, Pascal, etc.
- Remote connector registry on GitHub
- Distributed relay across multiple AI runtimes
- Native execution inside Codex/Claude Code/Copilot/Cursor without adapter files
- Cross-platform one-command installation
- SaaS or hosted coordination
- Deep runtime-native integration (beyond adapter markdown files)

---

## PART 3 — PROPOSED TARGET ARCHITECTURE

### 3.1 Universal Translator — Proposed Real Architecture

The current translator should be renamed to what it is: `EnvironmentRouter` or `AnchorDispatcher`. The real universal translator should be a layered pipeline:

**Layer 1 — Interface Detection**
Determine where the human is typing: shell, IDE plugin, runtime chat window, web form, API call, legacy terminal. This is partially done today via `detect_runtime_context()` but needs to be a first-class concern with a stable interface detection contract. Each interface should declare its capabilities (can execute commands, can display structured output, can prompt for approval, supports file I/O, etc.).

**Layer 2 — Human Language Profile**
Go beyond `$LANG` environment variable. Accept an explicit language preference in `.hbn/config.json`. Support language detection on the input text itself (using simple heuristics or a lightweight model). Carry the detected language through the entire pipeline so messages, readbacks, and approval prompts render in the user's language.

**Layer 3 — Intent Normalization**
Replace regex-based intent extraction with a structured intent schema that the calling environment (the AI runtime) fills in. The current approach of parsing free-form text with regex is inherently fragile. Instead, define a clear JSON intent schema that AI runtimes are instructed to produce, and accept raw text only as a fallback for shell/manual usage.

**Layer 4 — Target Technology Fingerprint**
The current `detect_technology_fingerprint()` is reasonable. Extend it with a plugin model: let each bridge declare what files/markers it looks for, so new technologies can be added without modifying `profiles.py`.

**Layer 5 — Bridge Resolution**
Match the intent + environment + technology fingerprint to a concrete bridge. This is where the connector catalog and scoring live. The bridge should declare: what it takes as input (HBN intent schema), what it produces (code, config, documentation), and what verification it requires.

**Layer 6 — Bridge Execution and Verification**
Actually generate or invoke the bridge. For a VBA bridge, this means generating a `.bas` file or a set of VBA module templates. For a Python bridge, this means generating a Python script or library call. Verification means: did the bridge produce valid output? Can the output be parsed by the target technology? Does it preserve declared invariants?

**Layer 7 — Trust and Approval Model**
Before any bridge execution, evaluate trust. The current `evaluate_connector_trust()` is a reasonable starting point. Extend it to support: connector signatures (hash-verified bridge artifacts), approval history (was this connector approved before in this project?), scope limitation (this bridge is approved for read-only operations but not writes), and revocation (this connector was previously approved but is now revoked).

### 3.2 Connector Lifecycle States

Replace the current informal state with an explicit finite state machine:

```
detected → resolved → installed → verified → active
                                                 ↓
                                              revoked
```

**detected**: A connector catalog entry matched the environment, but no bridge artifact exists. Evidence: scoring returned a positive match.

**resolved**: The connector's delivery strategy has been computed (language, coupling mode, target). Evidence: `resolve_connector_strategy()` returned `status: "resolved"`.

**installed**: A bridge artifact has been written to the filesystem (code file, adapter file, marker). Evidence: the artifact file exists and is non-empty.

**verified**: The installed bridge artifact has been tested or validated against the target. Evidence: a verification record exists linking the artifact to a test result or hash check.

**active**: The bridge is in use — the protocol is routing through it for current operations. Evidence: the connector marker includes `"lifecycle_state": "active"` and a last-used timestamp.

**revoked**: The bridge was previously active but has been explicitly disabled by human decision or by a failed verification. Evidence: a revocation record exists with a reason.

Each state transition should be recorded in the connector registry with a timestamp, the triggering event, and the actor (human or agent).

### 3.3 Privacy-by-Default and Explicit Approval Model

The current privacy contract declarations are a strong starting point. To make them enforceable:

**Principle 1 — No outbound data without explicit code-path audit.**
Every function that could transmit data outside the local machine must be annotated and registered. Today there is only one: `build_remote_lookup_descriptor()`. This should be tracked in a manifest. Any new outbound path must be added to the manifest and pass review.

**Principle 2 — Approval records are immutable and append-only.**
The current `create_connector_approval_record()` writes to `approvals/`. These should never be modified after creation. A revocation is a new record, not a modification.

**Principle 3 — Consent is scoped and time-bounded.**
The current consent record includes `scope` and `duration` fields. Enforce duration expiry: a consent record with `"duration": "session"` should not survive process restart. A consent record with `"duration": "30d"` should be ignored after 30 days.

**Principle 4 — Remote lookups require double-confirmation.**
The current contract says remote lookups need human approval. Add a second confirmation: show the exact payload that will be sent, then ask for approval. The current `build_remote_lookup_descriptor()` filters fields correctly, but the human never sees the actual filtered payload before it's sent.

**Principle 5 — Local storage paths are documented and bounded.**
The contract lists `.hbn/` and `.usehbn/` as storage paths. Add a maximum retention policy: state files older than N days can be archived or compacted. Add a clear `hbn purge` command for users who want to remove all HBN data from a project.

### 3.4 Bridge Extensibility Model

To support contributors from VBA, COBOL, Pascal, Lua, Swift, C, C++, C#, Java, Python, and future technologies:

**Define a Bridge Contributor Interface (BCI):**

```python
class BridgeContributor:
    """Interface that every bridge implementation must satisfy."""

    @property
    def technology_id(self) -> str: ...

    @property
    def file_markers(self) -> list[str]: ...

    @property
    def delivery_languages(self) -> list[str]: ...

    def detect(self, target: Path) -> bool: ...

    def generate(self, intent: dict, config: dict) -> list[BridgeArtifact]: ...

    def verify(self, artifacts: list[BridgeArtifact], target: Path) -> VerificationResult: ...
```

Each bridge contributor registers with the catalog. The catalog becomes a plugin registry rather than a hardcoded list. Bridge contributors can be distributed as separate packages (`usehbn-bridge-vba`, `usehbn-bridge-cobol`, etc.) or bundled with the core.

**For legacy technologies (VBA, COBOL, Pascal):**
Bridge generation should produce files in the target language, not markdown documentation. A VBA bridge should produce `.bas` and `.cls` files with HBN protocol wrappers. A COBOL bridge should produce copybooks and JCL templates. These are the actual artifacts that make HBN useful in legacy environments — without them, the bridge is just a document.

**For modern technologies (Python, Java, C#, Swift):**
Bridges can be lighter — often just a library import or a configuration file. The bridge generates the integration code that connects HBN protocol primitives (intent, readback, result) to the target project's build and test infrastructure.

---

## PART 4 — HARDENING ROADMAP

### Immediate (Next 2 weeks)

1. **Rename the translator.** Change `translate_natural_entry()` to `route_natural_entry()` or `dispatch_hbn_entry()`. Update `docs/UNIVERSAL-TRANSLATOR.md` to clearly state this is environment-aware routing, not semantic translation. The semantic translation vision belongs in a separate future-architecture document.

2. **Consolidate state directories.** Move all mutable state under `.hbn/` — including `logs/`, `state/`, `readbacks/`, `results/`, `consents/`. Make the project root clean. Define `.hbn/manifest.json` as the single source of truth for what exists.

3. **Add connector lifecycle state to marker files.** Every connector marker should include a `"lifecycle_state"` field with values from the defined state machine. Update `storage.py` to enforce valid transitions.

4. **Add enforcement mode to guardian.** Add a `--enforce` flag (or config option) that makes the guardian block execution when warnings are present, instead of just logging them. Default to advisory mode, but make enforcement available.

5. **Publish to TestPyPI.** This is already on the roadmap and should be the next delivery milestone. A working `pip install usehbn` path removes the biggest onboarding friction.

### Next Iteration (1-3 months)

6. **Define the Bridge Contributor Interface.** Create `src/usehbn/bridge/interface.py` with the abstract base class. Refactor `vba.py` to implement it — even if the VBA bridge initially only generates documentation, it should conform to the interface so contributors see the pattern.

7. **Build one real bridge.** Pick the technology with the most immediate demand (likely Python or VBA based on project origin) and implement a bridge that produces executable output. For Python: generate a `hbn_protocol.py` file that a project can import. For VBA: generate `.bas` modules with protocol wrapper functions.

8. **Extract adapter body to templates.** Replace the 250-line string literal in `runtime.py` with a Jinja2 or simple string template system. Support per-language template variants.

9. **Add integration tests for privacy contract enforcement.** Write tests that verify: (a) `build_remote_lookup_descriptor()` never includes forbidden fields under any environment configuration, (b) no other code path transmits data outside `.hbn/`, (c) consent records with expired durations are not honored.

10. **Formalize protocol versioning.** Add a `"protocol_version"` field to every JSON artifact (state, readback, result, connector marker). Define migration rules for when the version changes.

### 12 Months

11. **Ship bridge contributors for 3+ technologies.** VBA, Python, and one of (Java, C#, or COBOL) should have working bridges that generate executable output. Each bridge should be independently installable.

12. **Implement a lightweight intent schema for AI runtimes.** Instead of parsing free-form text with regex, define a structured JSON schema that AI runtimes can populate directly. Keep the regex path as a fallback for shell-only usage.

13. **Build a real remote connector registry.** Host a simple JSON registry on GitHub (or a static CDN) that lists community-contributed connectors with their trust levels, signatures, and compatibility matrices. Implement the client-side resolution that already has scaffolding in `remote.py`.

14. **Implement bridge verification.** When a bridge generates output, verify it: parse the generated code, check for syntax errors, run a minimal smoke test if possible, and record the verification result.

15. **Add i18n infrastructure.** Replace hardcoded bilingual strings with a proper message catalog. Support at least English, Portuguese, and Spanish. Make the catalog extensible for community contributions.

### 3 Years

16. **True semantic translation layer.** This is where the "universal translator" ambition becomes real. With enough bridge implementations and intent schema maturity, build a layer that can take a structured HBN intent and produce the correct bridge invocation across heterogeneous environments. This requires stable bridge interfaces, mature intent schemas, and real-world feedback from multiple technology communities.

17. **Cross-runtime relay protocol.** Formalize the handoff protocol so that a Claude Code session can hand off to a Codex session with full protocol state transfer. This requires serializable state, compatible adapter contracts, and human-gated transitions.

18. **Guardian enforcement with risk-proportional gating.** Evolve the guardian from advisory to a risk-proportional enforcement system: low-risk work proceeds automatically, medium-risk work requires readback confirmation, high-risk work requires human hearback plus verification evidence.

19. **Connector trust hierarchy.** Implement signed connectors, community trust ratings, and organizational approval policies. An enterprise deploying HBN should be able to whitelist specific connectors and block unknown ones.

20. **Protocol conformance test suite.** Publish a standalone test suite that any HBN implementation (in any language) can run to verify protocol compliance. This is essential for adoption beyond the Python reference implementation.

### 10 Years

21. **HBN as a cross-platform governance protocol.** If the intermediate steps succeed, HBN becomes a protocol that any AI runtime, IDE, or legacy system can adopt to make AI-assisted work traceable and governable. The value is not in the Python implementation but in the protocol specification and the ecosystem of bridges.

22. **Formal protocol specification.** Publish an RFC-style specification for the HBN protocol — independent of any implementation. This enables reimplementation in Rust, Go, TypeScript, or any other language without depending on the Python reference.

23. **Federated trust model.** Organizations can run their own connector registries with their own trust policies, federated with the public registry. This mirrors how package ecosystems work (npm, PyPI) but with governance-first design.

24. **Semantic translation across human languages.** The long-term vision of a user typing in Portuguese and the system generating a COBOL bridge with JCL documentation in English requires advances in structured multilingual AI integration. This is a 10-year aspiration, not a near-term deliverable.

---

## PART 5 — RISKS IF CURRENT DIRECTION CONTINUES UNCHANGED

**Risk 1: Credibility collapse from over-promise.**
The README and documentation describe HBN using language that implies capabilities far beyond the current implementation. Terms like "universal translator," "bridge generation," and "connector activation" suggest working systems that generate code and connect technologies. The reality is anchor routing, JSON documentation, and marker files. If an external engineer evaluates HBN today and discovers this gap, they will dismiss the entire project — including the genuinely valuable parts (the protocol flow, the readback/hearback cycle, the consent model).

**Risk 2: Scope expansion before foundation hardening.**
The codebase already spans 7 runtime adapters, 12+ technology fingerprints, 13 connector catalog entries, relay/handoff/archive cycles, consent management, remote lookup scaffolding, and a distributed-style registry. But the core protocol (intent → truth barrier → guardian → readback → hearback → result) still has no enforcement. Adding more surface area without hardening the core increases the maintenance burden without increasing the protocol's actual power.

**Risk 3: Single-contributor bus factor.**
The project is founder-led with one maintainer. The architecture is dense, the naming is unconventional (ERP, CCP, truth barrier, guardian, relay baton, hearback), and there is no contributor onboarding beyond CONTRIBUTING.md. The bridge contributor interface does not exist, so external contributors cannot add technology support without understanding the entire codebase.

**Risk 4: Legacy bridge promise without delivery.**
The strongest unique value proposition of HBN is connecting AI-assisted engineering to legacy technologies (VBA, COBOL). But the legacy bridge is the least implemented part of the system. If HBN ships without real legacy bridges, it competes with existing AI coding tools on their home turf (modern languages, IDE plugins) where it has no advantage.

**Risk 5: Privacy claims without enforcement.**
HBN positions privacy-by-default as a core principle. The declarations are thorough and well-designed. But without runtime enforcement, integration testing, and audit tooling, these claims are aspirational. A single contributor adding an unfiltered outbound call would silently violate the privacy contract.

---

## PART 6 — EXECUTIVE SUMMARY

HBN has a genuinely interesting core idea: a protocol for making AI-assisted engineering work explicit, traceable, and human-governed. The readback/hearback cycle, the consent model, the structured intent capture, and the privacy-first connector design are architecturally sound and unlike anything in the current ecosystem.

The execution, however, is ahead of itself. The project names components for what they aspire to be rather than what they currently do. This is the single biggest architectural risk: not a code bug, but a vocabulary inflation that will erode trust.

The path forward is clear: **rename what exists to match reality, harden the core protocol, build one real bridge that generates executable output, publish to PyPI, and resist the temptation to add more surface area before the foundation can bear weight.**

The 10-year vision — a universal governance protocol for AI-assisted engineering across technologies and human languages — is worth pursuing. But it requires brutal honesty about where the project stands today, and disciplined prioritization of depth over breadth for the next 12-24 months.

---

*This review was conducted against commit state as of 2026-04-03. All findings are based on direct code reading, test execution (88/88 passing), and schema analysis.*
