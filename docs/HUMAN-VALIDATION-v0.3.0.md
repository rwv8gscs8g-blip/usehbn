# Human Validation Guide — useHBN v0.3.0 "Honest Foundation"

> Step-by-step script for a human operator to validate the v0.3.0
> prototype before the public release gates (tag, publish, push). If
> any step diverges from "Expected output," **stop**, file the
> divergence in the log template at
> [`auditoria/post-implementation/v0.3.0-validation-log-template.md`](../auditoria/post-implementation/v0.3.0-validation-log-template.md),
> and decide whether to fix-then-retry or abort the release.
>
> This guide intentionally avoids any irreversible action until you
> explicitly say "go" at the per-section gates marked `🟡 HUMAN GATE`.

## Audience

Anyone who can:

- open a terminal,
- run `python` and `git` commands,
- read JSON output and compare it with a small expected payload.

You do not need to know the protocol internals. The guide tells you
what to type, where to type it, and what should come back.

## Prerequisites

| Item | Minimum | How to check |
|---|---|---|
| Python | 3.9 or newer | `python3 --version` |
| pip | any | `python3 -m pip --version` |
| Git | any | `git --version` |
| Terminal | macOS Terminal, Linux shell, or Windows PowerShell | open it |
| Internet | needed only for cloning + the optional TestPyPI/PyPI steps | n/a |
| Disk space | ~80 MB for the repo + venv | `df -h` (macOS/Linux) |

You do **not** need administrator/root for anything in this guide.

## How to read this guide

Each section is independent. You can run sections in order or jump to
the one most relevant for the OS you have at hand. The whole script
takes about 25 minutes per OS, plus 10 minutes for the optional
TestPyPI walk at the end.

The colored markers tell you what each step does:

- 🟢 **READ-ONLY** — local commands that create at most a sandbox folder.
- 🟡 **HUMAN GATE** — irreversible or public-facing action; do not
  proceed without explicit decision.
- ❌ **DO NOT RUN** without operator confirmation, no matter what the
  next instruction looks like.

---

## Part 1 — Local smoke test (macOS / Linux)

This is the safest part — everything happens in folders you choose,
and nothing reaches the network unless you explicitly run a publish
step.

### 1.1 Clone the repository 🟢

Pick a folder on your machine (e.g., `~/Projetos/` on macOS or
`~/code/` on Linux). Open a terminal there and run:

```bash
git clone https://github.com/rwv8gscs8g-blip/usehbn
cd usehbn
```

If you are validating an already-local checkout (the path on the
maintainer's machine is `~/Projetos/usehbn/`), just `cd` into it.

**Expected:** the prompt now shows you inside the `usehbn/` folder
and `ls` shows files such as `README.md`, `LICENSE`, `setup.cfg`,
plus the directories `src/`, `tests/`, `methodology/`, `auditoria/`,
and `docs/`.

### 1.2 Create an isolated Python environment 🟢

The repo already has a `.venv/` folder on the maintainer's machine.
On a new machine, create a fresh one:

```bash
python3 -m venv .venv
.venv/bin/pip install --upgrade pip
.venv/bin/pip install -e .
```

The `-e .` flag installs `usehbn` in editable mode, so the `hbn` and
`usehbn` commands point at the source you just cloned.

**Expected:** the last line of `pip install -e .` reads
`Successfully installed usehbn-0.3.0`.

### 1.3 Check the CLI version 🟢

```bash
.venv/bin/hbn version
```

**Expected output (exact):**

```json
{
  "project": "HBN — Human Brain Net",
  "package_version": "0.3.0",
  "protocol_version": "0.3.0",
  "cli": "hbn"
}
```

If `package_version` or `protocol_version` is anything else, **stop**
— the MD-H fix (Iteration 2 of the autonomous roadmap) did not land.

### 1.4 Run the test suite 🟢

```bash
.venv/bin/python -m pytest -q
```

**Expected:** the last line reads `114 passed` (or higher if new
tests landed after this guide). Time should be under 2 seconds on a
modern laptop.

If anything fails, **stop**, save the output, and file it in the log.

### 1.5 Create a disposable sandbox 🟢

This walks through the safest evaluation path described in
[`docs/SAFE-TESTING.md`](SAFE-TESTING.md).

```bash
SANDBOX=$(mktemp -d)
echo "Sandbox path: $SANDBOX"
.venv/bin/hbn quickstart --target "$SANDBOX" --runtime auto
```

(On Windows PowerShell, use `$SANDBOX = New-TemporaryFile; Remove-Item $SANDBOX; New-Item -ItemType Directory $SANDBOX` and then `& .venv\Scripts\hbn quickstart --target $SANDBOX --runtime auto`.)

**Expected:** JSON output with `"initialized": true`, a `quickstart_note`
path pointing at `0001-Quickstart.md`, and a `next_steps` list with
four `hbn ...` commands.

### 1.6 Diagnose the sandbox 🟢

```bash
.venv/bin/hbn doctor --target "$SANDBOX"
```

**Expected:** a JSON `doctor` block with `"status": "pass"` on most
checks and one or two `warnings` (such as
`"Target has no installed runtime adapter."` if auto-detection found
none). No errors.

### 1.7 Verify the new `.hbn/meta/` directory exists (ADR-006) 🟢

```bash
ls "$SANDBOX/.hbn/"
```

**Expected:** the listing includes `meta/` (along with `readbacks`,
`results`, `relay`, `relay-archive`, `knowledge`, `reports`,
`connectors`). The `meta/` directory is the new Iteration 6 addition;
its absence indicates a stale install.

### 1.8 Try a runtime adapter install 🟢

Pick the runtime closest to what you actually use (replace
`<RUNTIME>`):

| Runtime you use | Use this token |
|---|---|
| Claude Code (CLI) | `claude-code` |
| OpenAI Codex CLI | `codex` |
| ChatGPT (web) | `chatgpt` |
| Gemini (web/CLI) | `gemini` |
| Antigravity | `antigravity` |
| GitHub Copilot | `copilot` |
| Cursor | `cursor` |

```bash
.venv/bin/hbn install --runtime <RUNTIME> --target "$SANDBOX" --force
```

**Expected:** `"status": "installed"` and a `path` showing where the
adapter file was written (e.g., `.claude/commands/hbn.md` for Claude
Code; `agents.md` or similar for others).

Open the file and look for the line "Visible HBN response modes (10
single-repo + 6 multi-repo signals)" — that's the Iteration 6 marker.
If the adapter says only 3 markers, the iteration is stale.

### 1.9 Try the relay invariants (Iteration 5 — Onda 3) 🟢

```bash
.venv/bin/hbn readback exec-validation-001 \
  --agent-id human-validator \
  --intent-json '{"objective":"validate v0.3.0","constraints":[],"risks":[],"validation_requirements":[]}' \
  --guardian-json '{"status":"ok","warnings":[]}' \
  --understanding "Validation run" \
  --invariant "No state change" \
  --plan-step "Smoke check" \
  --storage-dir "$SANDBOX"

.venv/bin/hbn handoff --to claude --summary "Should fail with pending readback" --target "$SANDBOX"
```

**Expected on the second command:** an `"error"` field containing the
string `"pending readbacks"`. This proves the path-mismatch fix
landed: handoff now reads pending readbacks from `.usehbn/readbacks/`
as well as `.hbn/readbacks/`.

Confirm and clean up:

```bash
.venv/bin/hbn hearback exec-validation-001 --status confirmed --storage-dir "$SANDBOX"
.venv/bin/hbn handoff --to claude --summary "Now should succeed" --target "$SANDBOX"
```

**Expected on the second command:** a `handoff` object with `"to":
"claude"` and an `archived_files` list.

Now inspect the audit trail:

```bash
cat "$SANDBOX/.hbn/relay/state.json"
```

**Expected:** the JSON includes `"audit_trail": [...]` with at least
one entry whose `"to"` is `"claude"`. If the field is absent, the
Iteration 5 audit_trail support did not land.

### 1.10 Clean the sandbox (optional) 🟢

```bash
rm -rf "$SANDBOX"
```

Part 1 done. If everything matched, mark Section 1 as PASS in the log
template.

---

## Part 2 — Linux smoke test

If Part 1 ran on macOS, repeat the same steps on Linux. Easiest paths:

### Option A — Docker

If Docker is installed:

```bash
docker run --rm -it -v "$PWD:/work" -w /work python:3.11-slim bash -c '
  apt-get update -qq && apt-get install -y -qq git >/dev/null
  python -m venv /tmp/v
  /tmp/v/bin/pip install -q -e .
  /tmp/v/bin/hbn version
  /tmp/v/bin/python -m pytest -q
'
```

**Expected:** `hbn version` reports `package_version: 0.3.0` and
`protocol_version: 0.3.0`; pytest line reads `114 passed`.

### Option B — Linux VM / cloud / WSL

Open a fresh Ubuntu/Debian shell and run Part 1 starting at 1.1. The
only difference is `python3-venv` may need explicit install:

```bash
sudo apt-get install -y python3-venv git
```

### Option C — GitHub Actions (CI smoke)

If you have access to the GitHub repo, push a branch with a no-op
commit and let CI (if configured) run pytest on Linux. **Note**: this
is operator-gated since it touches the public repository. See
Section 6 below for the push gate.

---

## Part 3 — Windows smoke test

### 3.1 Windows + PowerShell

Open PowerShell (not cmd) and run:

```powershell
git clone https://github.com/rwv8gscs8g-blip/usehbn
cd usehbn
python -m venv .venv
.\.venv\Scripts\python -m pip install --upgrade pip
.\.venv\Scripts\pip install -e .
.\.venv\Scripts\hbn version
.\.venv\Scripts\python -m pytest -q
```

**Expected:** same JSON shape as macOS, `114 passed` from pytest.

If `python` resolves to Python 2.x, use `py -3` instead:

```powershell
py -3 -m venv .venv
```

For the sandbox steps, replace `mktemp -d` with:

```powershell
$SANDBOX = (New-Item -ItemType Directory -Path ([System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString())).FullName
```

The rest of Part 1 (sections 1.5 onward) works identically.

### 3.2 Windows + WSL

If you have WSL, treat it as a Linux box and follow Part 2 inside the
WSL shell. This is the easiest path for Windows users who prefer the
Linux command set.

---

## Part 4 — Targeted validation of the architectural decisions

These are extra checks that verify the v0.3.0 architectural decisions
(ADRs) actually landed in the code, not just in the docs. All 🟢
READ-ONLY against the cloned repo (no sandbox needed).

### 4.1 Verify Apache 2.0 license migration (ADR-005, Iteration 3) 🟢

```bash
head -3 LICENSE
grep -c 'Affero\|AGPL' src/usehbn/*.py src/usehbn/**/*.py tests/*.py LICENSE setup.cfg 2>/dev/null
```

**Expected:**
- `head -3 LICENSE` starts with `Apache License`, `Version 2.0, January 2004`.
- The `grep -c` total across all files **must be 0**. If any number
  is non-zero, license migration did not land cleanly.

### 4.2 Verify CONTRIBUTING.md mentions DCO 🟢

```bash
grep -c 'Signed-off-by\|Developer Certificate of Origin\|DCO' CONTRIBUTING.md
```

**Expected:** a number **≥ 3**.

### 4.3 Verify the 13 constitutional principles are canonical 🟢

```bash
grep -c '^### P[0-9]\+ —' methodology/PRINCIPIOS-CONSTITUCIONAIS.md
head -1 docs/PRINCIPLES.md
```

**Expected:**
- Count is **13** (P1 through P13, each with its own subsection).
- `docs/PRINCIPLES.md` starts with `# HBN Principles` and contains a
  SUPERSEDED banner pointing to `methodology/PRINCIPIOS-CONSTITUCIONAIS.md`.

### 4.4 Verify the 9 ADRs are present 🟢

```bash
ls methodology/adr/ADR-*.md | wc -l
grep -c '^status: ACCEPTED' methodology/adr/ADR-*.md
```

**Expected:**
- The first count is **9** (ADR-001 through ADR-009).
- The second `grep -c` total across files reports **8** ACCEPTED
  entries (ADR-008 stays NÃO_RATIFICAR — that's by design, blocked
  on v204 final).

### 4.5 Verify 16 HBN signals in the adapter body (ADR-006, Iteration 6) 🟢

```bash
.venv/bin/python -c "from usehbn.runtime import HBN_STATUS_MARKERS; print(len(HBN_STATUS_MARKERS), 'markers'); print('\n'.join(HBN_STATUS_MARKERS))"
```

**Expected:** the first line prints `16 markers`. The list includes
the six multi-repo ones: 🌐 CROSS-REPO LOCK, ⛓️ PROTOCOL DEP CHANGE,
🧊 APP FROZEN, 🪞 MIRROR DRIFT, ⏳ BILLING WINDOW DRIFT, 🔍 GROUPTHINK ALARM.

If you see only 3 markers, Iteration 6 did not land.

### 4.6 Verify connector lifecycle states (Onda 4, Iteration 7) 🟢

```bash
.venv/bin/python -c "from usehbn.connectors.storage import LIFECYCLE_STATES, DEFAULT_LIFECYCLE_STATE; print('states:', LIFECYCLE_STATES); print('default:', DEFAULT_LIFECYCLE_STATE)"
```

**Expected:** states is the exact tuple `('detected', 'resolved',
'installed', 'verified', 'active', 'revoked')` and default is
`'detected'`.

### 4.7 Verify state dual-read (Onda 5, Iteration 8) 🟢

```bash
.venv/bin/python -c "
from pathlib import Path
from usehbn.state.store import state_file_path, _legacy_state_file_path
print('canonical:', state_file_path(Path('/tmp/test-target')).relative_to('/tmp/test-target'))
print('legacy:   ', _legacy_state_file_path(Path('/tmp/test-target')).relative_to('/tmp/test-target'))
"
```

**Expected:**
- `canonical: .usehbn/hbn-state.json`
- `legacy:    state/hbn-state.json`

### 4.8 Verify version constants are independent (MD-H, Iteration 2) 🟢

```bash
.venv/bin/python -c "from usehbn import PACKAGE_VERSION, PROTOCOL_VERSION, __version__; print(f'PACKAGE_VERSION={PACKAGE_VERSION!r}'); print(f'PROTOCOL_VERSION={PROTOCOL_VERSION!r}'); print(f'__version__={__version__!r}')"
```

**Expected:** all three print `'0.3.0'`. They are currently aligned
but the constants are independent and may diverge in future
releases — what matters is that they exist and the CLI surfaces them
separately.

---

## Part 5 — Build the distribution artifacts

Already validated by the maintainer's autonomous run, but a human
should reproduce it on a clean machine.

### 5.1 Clean any old artifacts 🟢

```bash
rm -rf dist build usehbn.egg-info
```

### 5.2 Build sdist + wheel 🟢

```bash
.venv/bin/python setup.py sdist bdist_wheel
```

**Expected:** `dist/` now contains exactly two files:

```
dist/usehbn-0.3.0.tar.gz
dist/usehbn-0.3.0-py3-none-any.whl
```

Compute SHA-256 checksums:

```bash
shasum -a 256 dist/usehbn-0.3.0*       # macOS/Linux
# Windows PowerShell: Get-FileHash dist/usehbn-0.3.0-py3-none-any.whl -Algorithm SHA256
```

**Expected:** record the two checksums in the validation log. They
will differ from the maintainer's reference values because of
timestamp metadata in the tarball — this is normal. What matters is
that **the wheel installs cleanly and the version reports 0.3.0**.

### 5.3 Install the wheel in a throwaway venv 🟢

```bash
TESTENV=$(mktemp -d)
python3 -m venv "$TESTENV/v"
"$TESTENV/v/bin/pip" install dist/usehbn-0.3.0-py3-none-any.whl
"$TESTENV/v/bin/hbn" version
rm -rf "$TESTENV"
```

**Expected:** `hbn version` returns the same JSON as Section 1.3
(`package_version: 0.3.0`, `protocol_version: 0.3.0`).

---

## Part 6 — Release publication 🟡 HUMAN GATE

Everything until this point was local-only and reversible. From this
section on, actions are **public** and require your explicit go.

### 6.1 Pre-publish checklist (read this before doing anything) 🟡

- [ ] Parts 1, 4, 5 PASSED on macOS.
- [ ] Part 2 PASSED on Linux (Docker is fine).
- [ ] Part 3 PASSED on Windows (WSL is fine).
- [ ] You can revert any unwanted publish by uploading a `0.3.1` fix
      to TestPyPI/PyPI (never delete a published version; only
      supersede).
- [ ] You have credentials configured for TestPyPI (see 6.2) and
      separately for PyPI (see 6.5).
- [ ] You are on the `main` branch with a clean working tree:
      `git status` reports `nothing to commit, working tree clean`.

### 6.2 Configure TestPyPI credentials (one-time setup) 🟡

If you have not done this before, create an API token at
`https://test.pypi.org/manage/account/token/` (scope: project
`usehbn` or your whole account for the first upload).

Save it to `~/.pypirc` (Linux/macOS) or `%USERPROFILE%\.pypirc`
(Windows):

```ini
[distutils]
index-servers =
    testpypi
    pypi

[testpypi]
repository = https://test.pypi.org/legacy/
username = __token__
password = pypi-AgENdGVzdC5weXBpLm9yZ...    # your TestPyPI token

[pypi]
username = __token__
password = pypi-AgEIcHlwaS5vcmcCJDQ...      # your PyPI token (Section 6.5)
```

Install `twine` if it is not already:

```bash
.venv/bin/pip install twine
```

### 6.3 Upload to TestPyPI 🟡 HUMAN GATE

This is your first public action. **Decide explicitly to do it.**

```bash
.venv/bin/twine upload --repository testpypi dist/usehbn-0.3.0*
```

**Expected:** twine reports two files uploaded and prints a URL like
`https://test.pypi.org/project/usehbn/0.3.0/`. Open the URL in a
browser and confirm the page shows useHBN 0.3.0 with the Apache 2.0
license badge.

### 6.4 Validate the TestPyPI installation 🟡

In a brand-new sandbox machine (or a fresh venv):

```bash
TESTENV=$(mktemp -d)
python3 -m venv "$TESTENV/v"
"$TESTENV/v/bin/pip" install --index-url https://test.pypi.org/simple/ \
    --extra-index-url https://pypi.org/simple/ \
    usehbn==0.3.0
"$TESTENV/v/bin/hbn" version
rm -rf "$TESTENV"
```

(The `--extra-index-url` is needed because TestPyPI does not host
runtime dependencies; we fall back to PyPI for them.)

**Expected:** `hbn version` returns the same JSON as Section 1.3.

If anything is off, **stop**. Do not proceed to Section 6.5. Yank the
TestPyPI release if necessary (`twine` does not yank — use the
TestPyPI web UI) and prepare a `0.3.1` fix.

### 6.5 Upload to PyPI (production) 🟡 HUMAN GATE

After TestPyPI validates, repeat for PyPI. **This is irreversible —
PyPI does not allow re-uploading the same version.** If you discover
a bug, you must bump to `0.3.1` and re-release.

```bash
.venv/bin/twine upload dist/usehbn-0.3.0*
```

**Expected:** PyPI page at `https://pypi.org/project/usehbn/0.3.0/`
shows the package.

### 6.6 Tag and push the commit 🟡 HUMAN GATE

```bash
git tag -a v0.3.0 -m "useHBN v0.3.0 — Honest Foundation (Apache 2.0 + DCO)"
git push origin main
git push origin v0.3.0
```

**Expected:** the tag appears at
`https://github.com/rwv8gscs8g-blip/usehbn/releases/tag/v0.3.0`.

You can optionally create a GitHub Release from that tag with the
v0.3.0 entry of `CHANGELOG.md` pasted as the release notes.

---

## Part 7 — Post-release smoke (optional, recommended) 🟢

After PyPI is live, validate the public install path one last time:

```bash
TESTENV=$(mktemp -d)
python3 -m venv "$TESTENV/v"
"$TESTENV/v/bin/pip" install usehbn==0.3.0
"$TESTENV/v/bin/hbn" version
"$TESTENV/v/bin/hbn" quickstart --target "$TESTENV/sandbox" --runtime auto
rm -rf "$TESTENV"
```

**Expected:** identical results to all previous version + quickstart
runs.

---

## Approval criteria — final checklist

Fill in the log template at
[`auditoria/post-implementation/v0.3.0-validation-log-template.md`](../auditoria/post-implementation/v0.3.0-validation-log-template.md).
All items below must be marked PASS for v0.3.0 to ship.

- [ ] **Part 1 (macOS or your primary OS)**: every step matched expected output.
- [ ] **Part 2 (Linux)**: pytest 114/114; `hbn version` 0.3.0/0.3.0.
- [ ] **Part 3 (Windows)**: pytest 114/114; `hbn version` 0.3.0/0.3.0.
- [ ] **Part 4 (architectural decisions)**: all 8 targeted checks passed.
- [ ] **Part 5 (build)**: sdist + wheel built; throwaway venv install OK.
- [ ] **Part 6.3 (TestPyPI upload)**: package visible at TestPyPI.
- [ ] **Part 6.4 (TestPyPI install)**: `hbn version` 0.3.0/0.3.0 from TestPyPI install.
- [ ] **Part 6.5 (PyPI upload)**: package visible at PyPI.
- [ ] **Part 6.6 (Tag + push)**: tag visible on GitHub.
- [ ] **Part 7 (post-release smoke)**: public `pip install usehbn==0.3.0` works.

When the checklist is full, reply to the maintainer with
`v0.3.0 — APPROVED`. Otherwise, file divergences with section numbers
in the log.

## Where things live (quick reference)

| Asset | Path |
|---|---|
| 13 constitutional principles | [`methodology/PRINCIPIOS-CONSTITUCIONAIS.md`](../methodology/PRINCIPIOS-CONSTITUCIONAIS.md) |
| 9 architectural decisions (ADRs) | [`methodology/adr/`](../methodology/adr/) |
| Maturity Matrix (state per component) | [`methodology/MATURITY-MATRIX.md`](../methodology/MATURITY-MATRIX.md) |
| ADR + MD primer | [`methodology/ADR-AND-MD-PRIMER.md`](../methodology/ADR-AND-MD-PRIMER.md) |
| Autonomous roadmap that produced this release | [`auditoria/00_status/09_PROPOSTA_CRONOGRAMA_AUTONOMO_2026_05_10.md`](../auditoria/00_status/09_PROPOSTA_CRONOGRAMA_AUTONOMO_2026_05_10.md) |
| Post-implementation validation report (maintainer side) | [`auditoria/post-implementation/v0.3.0-validation.md`](../auditoria/post-implementation/v0.3.0-validation.md) |
| This human guide | `docs/HUMAN-VALIDATION-v0.3.0.md` (you are here) |
| Log template (you fill it) | [`auditoria/post-implementation/v0.3.0-validation-log-template.md`](../auditoria/post-implementation/v0.3.0-validation-log-template.md) |
| Root agent contract | [`AGENTS.md`](../AGENTS.md) |
| Safe testing primer | [`docs/SAFE-TESTING.md`](SAFE-TESTING.md) |

## What to do if something breaks

1. **Local failure (Parts 1-5)**: file the section number, the
   command, the actual output, and what the expected output was.
   Send it to the maintainer; the fix is a `0.3.1` patch.
2. **TestPyPI failure (Part 6.3-6.4)**: do not yank silently —
   document the divergence first. The TestPyPI release can be
   left visible; just do not promote to PyPI.
3. **PyPI failure after upload (Part 6.5)**: PyPI does not allow
   re-uploading the same version. Bump to `0.3.1`, fix, and release
   the patch. The broken `0.3.0` stays as a yanked entry.
4. **Push/tag failure (Part 6.6)**: tags can be deleted locally
   (`git tag -d v0.3.0`) and on the remote (`git push --delete origin
   v0.3.0`). Reset and retry.

## Version

- v1.0 — 2026-05-11 — initial version produced together with the
  v0.3.0 release prep so that human validation is a clean, repeatable
  script rather than ad-hoc instructions.
