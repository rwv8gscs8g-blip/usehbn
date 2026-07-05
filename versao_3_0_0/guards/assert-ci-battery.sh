#!/usr/bin/env bash
# =============================================================================
# guards/assert-ci-battery.sh
# G-CI-BATTERY: o HBN Shield deve rodar, no CI, um entrypoint canonico por
# igualdade exata. Guard invariante: le workflow + entrypoint no indice local
# ou em HEAD no CI, sem depender do diff, e falha fechado se a cobertura sumir.
# =============================================================================
# ---HBN-REQUIRES-BEGIN---
# requires:
#   files:
#     - path: .github/workflows/hbn-shield.yml
#       install: refuse
#     - path: guards/ci-entry.sh
#       install: copy
#       source: guards/ci-entry.sh
#   dirs: []
#   state_fields: []
#   guards: []
#   env: []
# ---HBN-REQUIRES-END---
set -euo pipefail

GUARD_NAME="assert-ci-battery"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

WORKFLOW_PATH=".github/workflows/hbn-shield.yml"
ENTRYPOINT_PATH="guards/ci-entry.sh"

blob_ref() {
    local version_path="$1" repo_path
    repo_path="$(guard_version_repo_path "$version_path")" || return 1
    hbn_context_current_ref "$repo_path"
}

WORKFLOW_REPO_PATH="$(guard_version_repo_path "$WORKFLOW_PATH" || true)"
if [[ -z "$WORKFLOW_REPO_PATH" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel localizar ${WORKFLOW_PATH}."
    exit 1
fi

case "$(hbn_context_dep_state "$WORKFLOW_REPO_PATH")" in
    ATIVO)
        ;;
    NOOP)
        guard_ok "Workflow HBN Shield ausente no indice/HEAD/base: contexto de genese/pre-instalacao; G-CI-BATTERY sem alvo. Instale o contexto com scripts/hbn-install-guard antes de ativar este guard."
        exit 0
        ;;
    DISARM|*)
        guard_fail "${WORKFLOW_PATH} existia no HEAD/base e foi removido neste commit/range. G-CI-BATTERY nao vira no-op por desarme; restaure o workflow ou trate a remocao fora deste commit."
        exit 1
        ;;
esac

WORKFLOW_REF="$(hbn_context_current_ref "$WORKFLOW_REPO_PATH")"

CONTENT="$(git cat-file -p "$WORKFLOW_REF" 2>/dev/null || true)"
if [[ -z "$CONTENT" ]]; then
    guard_fail "Workflow HBN Shield vazio/ilegivel no indice/HEAD: ${WORKFLOW_PATH}."
    exit 1
fi

ENTRYPOINT_REF="$(blob_ref "$ENTRYPOINT_PATH" || true)"
if [[ -z "$ENTRYPOINT_REF" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel localizar ${ENTRYPOINT_PATH}."
    exit 1
fi

if ! git cat-file -e "$ENTRYPOINT_REF" 2>/dev/null; then
    guard_fail "Entrypoint de CI ausente/ilegivel no indice/HEAD: ${ENTRYPOINT_PATH}."
    exit 1
fi

ENTRYPOINT_CONTENT="$(git cat-file -p "$ENTRYPOINT_REF" 2>/dev/null || true)"
if [[ -z "$ENTRYPOINT_CONTENT" ]]; then
    guard_fail "Entrypoint de CI vazio/ilegivel no indice/HEAD: ${ENTRYPOINT_PATH}."
    exit 1
fi

workflow_has_exact_entrypoint() {
    WORKFLOW_CONTENT="$CONTENT" python3 - <<'PY'
import os
import re
import sys

target = "bash guards/ci-entry.sh"
lines = os.environ.get("WORKFLOW_CONTENT", "").splitlines()

def strip_inline_yaml_comment(line):
    if line.lstrip().startswith("#"):
        return ""
    return line.split(" #", 1)[0]

def unquote_scalar(value):
    if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
        return value[1:-1]
    return value

run_re = re.compile(r"^(?P<indent>[ \t]*)-?[ \t]*run:[ \t]*(?P<cmd>.*)$")
commands = []
i = 0
while i < len(lines):
    line = strip_inline_yaml_comment(lines[i]).rstrip()
    match = run_re.match(line)
    if not match:
        i += 1
        continue

    cmd = match.group("cmd").strip()
    if cmd.startswith("|") or cmd.startswith(">"):
        base_indent = len(match.group("indent").replace("\t", "    "))
        block = []
        i += 1
        while i < len(lines):
            nxt = lines[i].rstrip("\n")
            if nxt.strip() == "":
                block.append("")
                i += 1
                continue
            nxt_indent = len(nxt) - len(nxt.lstrip(" \t"))
            if nxt_indent <= base_indent:
                break
            block.append(nxt.strip())
            i += 1
        commands.append("\n".join(block).strip())
        continue

    commands.append(unquote_scalar(cmd).strip())
    i += 1

if any(command == target for command in commands):
    sys.exit(0)

sys.exit(1)
PY
}

entrypoint_has_real_invocations() {
    ENTRYPOINT_CONTENT="$ENTRYPOINT_CONTENT" python3 - <<'PY'
import os
import re
import shlex
import sys

required = [
    "guards/hbn-guards-runner.sh",
    "guards/tests/run-guard-tests.sh",
    "guards/tests/adversarial-battery.sh",
]
lines = os.environ.get("ENTRYPOINT_CONTENT", "").splitlines()

def strip_shell_comment(line):
    if line.lstrip().startswith("#"):
        return ""
    return re.sub(r"\s+#.*$", "", line)

def heredoc_marker(line):
    match = re.search(r"<<(?P<tabs>-)?\s*(?:'(?P<sq>[^']+)'|\"(?P<dq>[^\"]+)\"|\\?(?P<bare>[A-Za-z0-9_./-]+))", line)
    if not match:
        return None
    marker = match.group("sq") or match.group("dq") or match.group("bare")
    return marker, bool(match.group("tabs"))

has_set_e = False
has_hbn_ci = False
seen = {path: False for path in required}
skip_marker = None
strip_tabs = False

for raw in lines:
    if skip_marker is not None:
        candidate = raw.lstrip("\t") if strip_tabs else raw
        if candidate.strip() == skip_marker:
            skip_marker = None
            strip_tabs = False
        continue

    clean = strip_shell_comment(raw).strip()
    if not clean:
        continue

    try:
        tokens = shlex.split(clean, comments=False, posix=True)
    except ValueError:
        tokens = clean.split()

    if tokens and tokens[0] == "set" and any(tok.startswith("-") and "e" in tok for tok in tokens[1:]):
        has_set_e = True

    if re.match(r"^(export[ \t]+)?HBN_CI=(1|true)([ \t]|$)", clean):
        has_hbn_ci = True

    for path in required:
        if re.match(r"^bash[ \t]+" + re.escape(path) + r"([ \t]|$)", clean):
            seen[path] = True

    marker = heredoc_marker(clean)
    if marker is not None:
        skip_marker, strip_tabs = marker

missing = [path for path, ok in seen.items() if not ok]
if not has_set_e:
    missing.append("set -e")
if not has_hbn_ci:
    missing.append("export HBN_CI=1")

if missing:
    print("missing: " + ", ".join(missing), file=sys.stderr)
    sys.exit(1)

sys.exit(0)
PY
}

if ! workflow_has_exact_entrypoint; then
    guard_fail "${WORKFLOW_PATH} nao contem step run exatamente igual a 'bash guards/ci-entry.sh' no indice/HEAD."
    exit 1
fi

if ! entrypoint_has_real_invocations; then
    guard_fail "${ENTRYPOINT_PATH} nao invoca runner, suite e bateria como comandos reais fora de heredoc/comentario/echo, ou nao habilita set -e."
    exit 1
fi

guard_ok "CI preserva entrypoint canonico e invocacoes reais de runner, suite e bateria."
exit 0
