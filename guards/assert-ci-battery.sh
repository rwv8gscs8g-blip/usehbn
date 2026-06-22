#!/usr/bin/env bash
# =============================================================================
# guards/assert-ci-battery.sh
# G-CI-BATTERY: o HBN Shield deve rodar, no CI, a suite de guards e a
# bateria adversarial. Guard invariante: le o workflow no indice local ou
# em HEAD no CI, sem depender do diff, e falha fechado se a cobertura sumir.
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-ci-battery"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

WORKFLOW_PATH=".github/workflows/hbn-shield.yml"

blob_ref() {
    local repo_path
    repo_path="$(guard_version_repo_path "$WORKFLOW_PATH")" || return 1
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        printf 'HEAD:%s\n' "$repo_path"
    else
        printf ':%s\n' "$repo_path"
    fi
}

WORKFLOW_REF="$(blob_ref || true)"
if [[ -z "$WORKFLOW_REF" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel localizar ${WORKFLOW_PATH}."
    exit 1
fi

if ! git cat-file -e "$WORKFLOW_REF" 2>/dev/null; then
    guard_fail "Workflow HBN Shield ausente/ilegivel no indice/HEAD: ${WORKFLOW_PATH}."
    exit 1
fi

CONTENT="$(git cat-file -p "$WORKFLOW_REF" 2>/dev/null || true)"
if [[ -z "$CONTENT" ]]; then
    guard_fail "Workflow HBN Shield vazio/ilegivel no indice/HEAD: ${WORKFLOW_PATH}."
    exit 1
fi

FAIL=0

workflow_has_real_invocation() {
    local required_script="$1"
    WORKFLOW_CONTENT="$CONTENT" python3 - "$required_script" <<'PY'
import os
import re
import sys

required = sys.argv[1]
lines = os.environ.get("WORKFLOW_CONTENT", "").splitlines()

def strip_comment(line):
    if line.lstrip().startswith("#"):
        return ""
    return line.split(" #", 1)[0]

cleaned = [strip_comment(line) for line in lines]
run_re = re.compile(r"^(?P<indent>[ \t]*)-?[ \t]*run:[ \t]*(?P<cmd>.*)$")
commands = []
i = 0
while i < len(cleaned):
    line = cleaned[i]
    match = run_re.match(line)
    if not match:
        i += 1
        continue

    cmd = match.group("cmd").strip()
    if cmd.startswith("|") or cmd.startswith(">"):
        base_indent = len(match.group("indent").replace("\t", "    "))
        block = []
        i += 1
        while i < len(cleaned):
            nxt = cleaned[i]
            if nxt.strip() == "":
                block.append("")
                i += 1
                continue
            nxt_indent = len(nxt) - len(nxt.lstrip(" \t"))
            if nxt_indent <= base_indent:
                break
            block.append(nxt.strip())
            i += 1
        commands.append("\n".join(block))
        continue

    commands.append(cmd)
    i += 1

pattern = re.compile(r"^bash\s+" + re.escape(required) + r"(\s|$)")
for command in commands:
    for segment in re.split(r"&&|\|\||[;|\n]", command):
        if pattern.search(segment.strip()):
            sys.exit(0)

sys.exit(1)
PY
}

for REQUIRED_SCRIPT in \
    "guards/tests/run-guard-tests.sh" \
    "guards/tests/adversarial-battery.sh"
do
    if ! workflow_has_real_invocation "$REQUIRED_SCRIPT"; then
        guard_fail "${WORKFLOW_PATH} nao invoca 'bash ${REQUIRED_SCRIPT}' como comando real de step run no indice/HEAD."
        FAIL=1
    fi
done

if [[ "$FAIL" -ne 0 ]]; then
    exit 1
fi

guard_ok "CI preserva run-guard-tests.sh e adversarial-battery.sh no HBN Shield."
exit 0
