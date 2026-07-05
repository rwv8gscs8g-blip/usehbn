#!/usr/bin/env bash
# =============================================================================
# guards/assert-active-version-integrity.sh
# G-ACTIVE-VERSION: trocar .hbn/active-version nao pode orfanar as dependencias
# protegidas que a versao de saida carregava. NOOP por versao nova vazia e
# desarme, salvo autorizacao humana explicita em STATE + hearback confirmed.
# =============================================================================
# ---HBN-REQUIRES-BEGIN---
# requires:
#   files:
#     - path: .hbn/active-version
#       install: refuse
#     - path: .hbn/relay/STATE.md
#       install: refuse
#   dirs: []
#   state_fields: []
#   guards: []
#   env: []
# ---HBN-REQUIRES-END---
set -euo pipefail

GUARD_NAME="assert-active-version-integrity"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

ACTIVE_VERSION_PATH=".hbn/active-version"

trim_active_value() {
    sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'
}

active_rel_from_blob() { # <blob-ref>
    local ref="$1" raw count value
    if ! raw="$(git show "$ref" 2>/dev/null)"; then
        return 2
    fi
    if grep -qE '^(<<<<<<<|=======|>>>>>>>)' <<< "$raw"; then
        return 3
    fi
    raw="$(printf '%s\n' "$raw" | grep -v '^[[:space:]]*#' | grep -v '^[[:space:]]*$' || true)"
    count="$(printf '%s\n' "$raw" | sed '/^[[:space:]]*$/d' | wc -l | tr -d '[:space:]')"
    [[ "$count" == "1" ]] || return 4
    value="$(printf '%s\n' "$raw" | sed -n '1p' | trim_active_value)"
    if [[ "$value" != "." && ! "$value" =~ ^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+$ ]]; then
        return 5
    fi
    case "$value" in
        /*|*..*|*//*|*\\*|*" "*|*"	"*) return 6 ;;
    esac
    printf '%s\n' "$value"
}

current_blob_ref() { # <repo-path>
    if [[ "$CURRENT_SOURCE" == "HEAD" ]]; then
        printf 'HEAD:%s\n' "$1"
    else
        printf ':%s\n' "$1"
    fi
}

current_path_kind() { # <repo-path>
    if [[ "$CURRENT_SOURCE" == "HEAD" ]]; then
        hbn_ref_path_kind HEAD "$1"
    else
        hbn_index_path_kind "$1"
    fi
}

active_version_touched() {
    if [[ "$CURRENT_SOURCE" == "HEAD" ]]; then
        hbn_ci_range_mode || return 1
        git diff --quiet "${HBN_DIFF_BASE}...HEAD" -- "$ACTIVE_VERSION_PATH" 2>/dev/null && return 1
        return 0
    fi
    git diff --cached --quiet -- "$ACTIVE_VERSION_PATH" 2>/dev/null && return 1
    return 0
}

protected_context_deps() {
    cat <<'EOF'
.hbn/relay/STATE.md
.hbn/knowledge/INDEX.md
core/role-cards.md
core/read-list-canonica.txt
.github/workflows/hbn-shield.yml
guards/ci-entry.sh
CONSUMER-PROFILE.md
.usehbn-snapshot
.usehbn-snapshot/CONSUMER-PROFILE.md
EOF
}

state_declares_active_version_authorization() { # <state-file>
    python3 - "$1" <<'PY'
import re
import sys

text = open(sys.argv[1], encoding="utf-8").read()
lines = text.splitlines()
if not lines or lines[0].strip() != "---":
    sys.exit(1)
end = None
for idx in range(1, len(lines)):
    if lines[idx].strip() == "---":
        end = idx
        break
if end is None:
    sys.exit(1)
front = "\n".join(lines[1:end])
if not re.search(r"active[-_]version[-_]integrity", front, re.I):
    sys.exit(1)
match = re.search(r"^\s*hearback_ref\s*:\s*(.+?)\s*$", front, re.M)
if not match:
    sys.exit(1)
value = re.sub(r"\s+#.*$", "", match.group(1)).strip()
if value in {"", "null", "~"}:
    sys.exit(1)
if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
    value = value[1:-1]
print(value)
PY
}

hearback_covers_active_version_integrity() { # <hearback-file> <old-rel> <new-rel> <missing...>
    python3 - "$@" <<'PY'
import json
import sys

path, old_rel, new_rel, *missing = sys.argv[1:]
try:
    data = json.load(open(path, encoding="utf-8"))
except Exception:
    sys.exit(1)
if data.get("status") != "confirmed":
    sys.exit(1)

valid_types = {"active-version-integrity", "active_version_integrity"}
for item in data.get("excecoes_cobertas", []):
    if not isinstance(item, dict) or item.get("tipo") not in valid_types:
        continue
    from_rel = item.get("from") or item.get("de") or item.get("old") or item.get("saida")
    to_rel = item.get("to") or item.get("para") or item.get("new") or item.get("entrada")
    if from_rel and from_rel != old_rel:
        continue
    if to_rel and to_rel != new_rel:
        continue
    deps = item.get("dependencias") or item.get("deps") or item.get("paths")
    if deps:
        deps = set(deps)
        if any(dep not in deps for dep in missing):
            continue
    sys.exit(0)
sys.exit(1)
PY
}

active_version_authorized() { # <old-rel> <new-rel> <missing...>
    local old_rel="$1" new_rel="$2" state_repo state_ref state_tmp hearback_ref hearback_repo hearback_ref_blob hearback_tmp
    shift 2
    state_repo="$(hbn_version_repo_path_for_rel "$new_rel" ".hbn/relay/STATE.md")"
    if ! hbn_path_kind_active "$(current_path_kind "$state_repo")"; then
        return 1
    fi
    state_ref="$(current_blob_ref "$state_repo")"
    state_tmp="$(mktemp)"
    hearback_tmp=""
    trap 'rm -f "$state_tmp" "$hearback_tmp"' RETURN
    if ! git show "$state_ref" > "$state_tmp" 2>/dev/null; then
        return 1
    fi
    if ! hearback_ref="$(state_declares_active_version_authorization "$state_tmp")"; then
        return 1
    fi
    case "$hearback_ref" in
        /*|*..*|*\\*|"") return 1 ;;
    esac
    hearback_repo="$(hbn_version_repo_path_for_rel "$new_rel" "$hearback_ref")"
    if ! hbn_path_kind_active "$(current_path_kind "$hearback_repo")"; then
        return 1
    fi
    hearback_ref_blob="$(current_blob_ref "$hearback_repo")"
    hearback_tmp="$(mktemp)"
    if ! git show "$hearback_ref_blob" > "$hearback_tmp" 2>/dev/null; then
        return 1
    fi
    hearback_covers_active_version_integrity "$hearback_tmp" "$old_rel" "$new_rel" "$@"
}

CURRENT_SOURCE="$(hbn_context_current_source)"
if ! active_version_touched; then
    guard_ok ".hbn/active-version nao foi alterado neste diff — integridade de versao ativa sem mudanca."
    exit 0
fi

if [[ "$CURRENT_SOURCE" == "HEAD" ]]; then
    OLD_TREE_REF="$HBN_DIFF_BASE"
    OLD_POINTER_REF="${HBN_DIFF_BASE}:${ACTIVE_VERSION_PATH}"
    NEW_POINTER_REF="HEAD:${ACTIVE_VERSION_PATH}"
else
    OLD_TREE_REF="HEAD"
    OLD_POINTER_REF="HEAD:${ACTIVE_VERSION_PATH}"
    NEW_POINTER_REF=":${ACTIVE_VERSION_PATH}"
fi

set +e
NEW_REL="$(active_rel_from_blob "$NEW_POINTER_REF")"
NEW_REL_RC=$?
set -e
if [[ "$NEW_REL_RC" -ne 0 ]]; then
    guard_fail ".hbn/active-version novo e invalido/ausente no ${CURRENT_SOURCE}. Troca de versao falha fechada."
    exit 1
fi

set +e
OLD_REL="$(active_rel_from_blob "$OLD_POINTER_REF")"
OLD_REL_RC=$?
set -e
if [[ "$OLD_REL_RC" -ne 0 ]]; then
    if [[ "$OLD_REL_RC" -ne 2 ]]; then
        guard_fail ".hbn/active-version anterior existe mas e invalido em ${OLD_TREE_REF}. Troca de versao falha fechada."
        exit 1
    fi
    guard_ok ".hbn/active-version nasceu neste diff sem versao anterior committed; G-ACTIVE-VERSION trata como genese real."
    exit 0
fi

if [[ "$OLD_REL" == "$NEW_REL" ]]; then
    guard_ok ".hbn/active-version foi tocado mas continua apontando para ${NEW_REL}; sem troca de versao."
    exit 0
fi

if [[ "$OLD_REL" != "." ]] && ! hbn_path_kind_active "$(hbn_ref_path_kind "$OLD_TREE_REF" "$OLD_REL")"; then
    guard_fail "Versao de saida '${OLD_REL}' nao existe como diretorio em ${OLD_TREE_REF}; active-version anterior inconsistente."
    exit 1
fi
if [[ "$NEW_REL" != "." ]] && ! hbn_path_kind_active "$(current_path_kind "$NEW_REL")"; then
    guard_fail "Versao de entrada '${NEW_REL}' nao existe como diretorio no ${CURRENT_SOURCE}; troca de active-version invalida."
    exit 1
fi

MISSING=()
while IFS= read -r dep; do
    [[ -z "$dep" ]] && continue
    old_path="$(hbn_version_repo_path_for_rel "$OLD_REL" "$dep")"
    new_path="$(hbn_version_repo_path_for_rel "$NEW_REL" "$dep")"
    if hbn_path_kind_present "$(hbn_ref_path_kind "$OLD_TREE_REF" "$old_path")" \
        && ! hbn_path_kind_active "$(current_path_kind "$new_path")"; then
        MISSING+=("$dep")
    fi
done < <(protected_context_deps)

if [[ "${#MISSING[@]}" -eq 0 ]]; then
    guard_ok "active-version ${OLD_REL} -> ${NEW_REL}: versao de entrada preserva as dependencias protegidas da versao de saida."
    exit 0
fi

if active_version_authorized "$OLD_REL" "$NEW_REL" "${MISSING[@]}"; then
    guard_ok "active-version ${OLD_REL} -> ${NEW_REL}: perda de dependencias protegidas autorizada por STATE + hearback confirmed."
    exit 0
fi

guard_fail "active-version ${OLD_REL} -> ${NEW_REL} orfana dependencias protegidas carregadas pela versao de saida: ${MISSING[*]}. Isso e DISARM, nao NOOP; exige STATE da versao de entrada com active-version-integrity + hearback_ref confirmed cobrindo a excecao."
exit 1
