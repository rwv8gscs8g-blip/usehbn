#!/usr/bin/env bash
# =============================================================================
# guards/assert-orq-entrada-ref.sh
# G-ORQ-REF: atos de autoridade do orquestrador devem apontar para a
# atestacao de entrada vigente por orq_entrada_ref.
#
# Escopo do gate: despacho (.hbn/dispatch/*.md), selagem (readback com
# authority_act=selagem, status selado/vigente ou nome contendo selagem) e
# freeze (.hbn/freeze/*.json). Entregas de implementacao e pareceres nao sao
# gateados por este guard.
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-orq-entrada-ref"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

REPO_ROOT="$(guard_repo_root)"
if [[ -z "$REPO_ROOT" ]]; then
    guard_fail "Nao foi possivel resolver a raiz Git."
    exit 1
fi

ACTIVE_PREFIX="$(guard_active_version_prefix || true)"
if [[ -z "${ACTIVE_PREFIX+x}" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}."
    exit 1
fi

FILES_LIST="$(mktemp)"
ERR_FILE="$(mktemp)"
trap 'rm -f "$FILES_LIST" "$ERR_FILE"' EXIT

while IFS= read -r version_path; do
    [[ -z "$version_path" ]] && continue
    repo_path="$(guard_version_repo_path "$version_path" || true)"
    [[ -z "$repo_path" ]] && continue
    printf '%s\t%s\n' "$version_path" "$repo_path" >> "$FILES_LIST"
done < <(guard_diff_files)

PY_OUT="$(
    cd "$REPO_ROOT"
    python3 - "$ACTIVE_PREFIX" "$FILES_LIST" 2>"$ERR_FILE" <<'PY'
import json
import os
import re
import subprocess
import sys

active_prefix, files_list = sys.argv[1:3]
use_head = bool(os.environ.get("HBN_DIFF_BASE"))
errors = []

def fail(message):
    errors.append(message)

def repo_path(version_path):
    return f"{active_prefix}{version_path}" if active_prefix else version_path

def spec_for_repo(repo):
    return f"HEAD:{repo}" if use_head else f":{repo}"

def read_version_blob(version_path):
    return subprocess.check_output(
        ["git", "show", spec_for_repo(repo_path(version_path))],
        stderr=subprocess.DEVNULL,
    ).decode("utf-8")

def blob_exists(version_path):
    return subprocess.call(
        ["git", "cat-file", "-e", spec_for_repo(repo_path(version_path))],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ) == 0

def unquote(value):
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
        return value[1:-1]
    return value

def state_value(state_text, key):
    pat = re.compile(rf"^\s*{re.escape(key)}:")
    for line in state_text.splitlines():
        if not pat.search(line):
            continue
        value = re.sub(r"\s+#.*$", "", line.split(":", 1)[1]).strip()
        return unquote(value)
    return ""

def dispatch_readback_path(path):
    try:
        text = read_version_blob(path)
    except Exception as exc:
        fail(f"{path}: despacho ilegivel no indice/HEAD ({exc})")
        return ""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        fail(f"{path}: despacho sem front matter YAML")
        return ""
    end = None
    for idx in range(1, len(lines)):
        if lines[idx].strip() == "---":
            end = idx
            break
    if end is None:
        fail(f"{path}: front matter YAML nao fechado")
        return ""
    readback_id = ""
    for raw in lines[1:end]:
        if raw.startswith("readback_id:"):
            readback_id = unquote(raw.split(":", 1)[1])
            break
    if not readback_id:
        fail(f"{path}: despacho sem readback_id")
        return ""
    if readback_id.startswith(".hbn/readbacks/"):
        return readback_id
    return f".hbn/readbacks/{readback_id}.json"

def is_authority_readback(path, data):
    values = []
    for key in ("authority_act", "ato_autoridade", "tipo_ato", "act", "kind"):
        value = data.get(key)
        if isinstance(value, str):
            values.append(value.lower())
    if any(value in {"despacho", "selagem", "freeze"} for value in values):
        return True

    readback_id = data.get("readback_id", "")
    status = data.get("status", "")
    haystack = f"{path} {readback_id}".lower()
    if "selagem" in haystack:
        return True
    if isinstance(status, str) and status.lower() in {"selado", "sealed", "vigente"}:
        return True
    return False

changed = []
with open(files_list, encoding="utf-8") as handle:
    for raw in handle:
        raw = raw.rstrip("\n")
        if not raw:
            continue
        version_path, repo = raw.split("\t", 1)
        changed.append((version_path, repo))

authority_targets = []
authority_paths = []
for path, _repo in changed:
    if re.match(r"^\.hbn/dispatch/.*\.md$", path):
        authority_paths.append(path)
        target = dispatch_readback_path(path)
        if target:
            authority_targets.append(target)
        continue

    if re.match(r"^\.hbn/freeze/.*\.json$", path):
        authority_paths.append(path)
        authority_targets.append(path)
        continue

    if re.match(r"^\.hbn/readbacks/.*\.json$", path):
        try:
            data = json.loads(read_version_blob(path))
        except Exception as exc:
            if "selagem" in path.lower():
                authority_paths.append(path)
                fail(f"{path}: readback de selagem ilegivel ou JSON invalido ({exc})")
            continue
        if isinstance(data, dict) and is_authority_readback(path, data):
            authority_paths.append(path)
            authority_targets.append(path)

if not authority_paths:
    print("AUTH\t0\t")
    sys.exit(0)

try:
    state_text = read_version_blob(".hbn/relay/STATE.md")
except Exception as exc:
    fail(f"STATE ausente/ilegivel para ato de autoridade ({exc})")
    state_text = ""

token_sha = state_value(state_text, "bastao_token_sha256")
if not re.fullmatch(r"[0-9a-fA-F]{64}", token_sha or ""):
    fail("STATE sem bastao_token_sha256 valido para dereferenciar orq_entrada_ref")
    token_fp = ""
else:
    token_fp = token_sha[:8].lower()

expected_ref = f".hbn/attestations/{token_fp}-orq-entrada.json" if token_fp else ""
if expected_ref and not blob_exists(expected_ref):
    fail(f"atestacao orq_entrada_ref ausente no indice/HEAD: {expected_ref}")

seen = set()
for target in authority_targets:
    if target in seen:
        continue
    seen.add(target)
    try:
        data = json.loads(read_version_blob(target))
    except subprocess.CalledProcessError:
        fail(f"ato de autoridade aponta para JSON ausente no indice/HEAD: {target}")
        continue
    except Exception as exc:
        fail(f"{target}: JSON de ato de autoridade ilegivel ({exc})")
        continue
    if not isinstance(data, dict):
        fail(f"{target}: JSON de ato de autoridade deve ser objeto")
        continue
    value = data.get("orq_entrada_ref")
    if not isinstance(value, str) or not value.strip():
        fail(f"{target}: campo orq_entrada_ref ausente")
        continue
    if expected_ref and value != expected_ref:
        fail(f"{target}: orq_entrada_ref '{value}' diverge do esperado '{expected_ref}'")

if errors:
    for message in errors:
        print(f"G-ORQ-REF: {message}", file=sys.stderr)
    sys.exit(1)

print(f"AUTH\t{len(authority_paths)}\t{expected_ref}")
PY
)" || {
    while IFS= read -r err; do
        [[ -z "$err" ]] && continue
        guard_fail "$err"
    done < "$ERR_FILE"
    exit 1
}

AUTH_COUNT="$(printf '%s\n' "$PY_OUT" | awk -F'\t' '$1=="AUTH"{print $2; exit}')"
EXPECTED_REF="$(printf '%s\n' "$PY_OUT" | awk -F'\t' '$1=="AUTH"{print $3; exit}')"

if [[ "${AUTH_COUNT:-0}" == "0" ]]; then
    guard_ok "Nenhum ato de autoridade do orquestrador staged/HEAD — G-ORQ-REF nao opina."
    exit 0
fi

changed_attestation="$(awk -F'\t' '$1 ~ /^\.hbn\/attestations\/[0-9a-fA-F]{8}-orq-entrada\.json$/ {print $1}' "$FILES_LIST" | sort -u || true)"
if [[ -n "$changed_attestation" && -z "${HBN_DIFF_BASE:-}" ]]; then
    guard_fail "Re-pin de atestacao no mesmo commit de ato de autoridade e vedado: $(echo "$changed_attestation" | xargs). Gere nova atestacao em commit proprio antes do ato."
    exit 1
fi

if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
    while IFS= read -r commit; do
        [[ -z "$commit" ]] && continue
        files="$(git diff-tree --no-commit-id --name-only -r "$commit" 2>/dev/null | guard_paths_to_version_paths || true)"
        has_auth="$(printf '%s\n' "$files" | grep -E '^\.hbn/dispatch/.*\.md$|^\.hbn/freeze/.*\.json$|^\.hbn/readbacks/.*selagem.*\.json$' || true)"
        has_repin="$(printf '%s\n' "$files" | grep -E '^\.hbn/attestations/[0-9a-fA-F]{8}-orq-entrada\.json$' || true)"
        if [[ -n "$has_auth" && -n "$has_repin" ]]; then
            guard_fail "Commit ${commit:0:12} mistura ato de autoridade e re-pin de atestacao orq-entrada; re-pin deve ocorrer em commit proprio."
            exit 1
        fi
    done < <(git rev-list "${HBN_DIFF_BASE}..HEAD" 2>/dev/null || true)
fi

if ! bash "${SCRIPT_DIR}/assert-orq-entrada.sh"; then
    guard_fail "Atestacao referenciada por orq_entrada_ref nao passa o assert-orq-entrada.sh vigente (${EXPECTED_REF})."
    exit 1
fi

guard_ok "orq_entrada_ref dereferenciado e atestacao vigente validada para ${AUTH_COUNT} ato(s) de autoridade."
exit 0
