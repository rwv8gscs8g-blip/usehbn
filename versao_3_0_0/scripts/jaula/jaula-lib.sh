#!/usr/bin/env bash
set -euo pipefail

jaula_die() {
    printf '[jaula] BLOQUEADO: %s\n' "$*" >&2
    exit 1
}

jaula_log() {
    printf '[jaula] %s\n' "$*" >&2
}

jaula_script_dir() {
    cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P
}

jaula_version_root() {
    cd "$(jaula_script_dir)/../.." && pwd -P
}

jaula_repo_root() {
    git -C "$(jaula_version_root)" rev-parse --show-toplevel 2>/dev/null \
        || jaula_die 'não foi possível localizar a raiz Git canônica'
}

jaula_active_version() {
    local root pointer active count
    root="$(jaula_repo_root)"
    pointer="${root}/.hbn/active-version"
    [[ -r "$pointer" ]] || jaula_die "ponteiro ausente ou ilegível: ${pointer}"
    active="$(grep -v '^[[:space:]]*#' "$pointer" | sed '/^[[:space:]]*$/d')"
    count="$(printf '%s\n' "$active" | sed '/^[[:space:]]*$/d' | wc -l | tr -d '[:space:]')"
    [[ "$count" == 1 ]] || jaula_die 'active-version deve conter uma única linha'
    case "$active" in
        versao_[0-9]*_[0-9]*_[A-Za-z0-9]*) printf '%s\n' "$active" ;;
        *) jaula_die "active-version inseguro: ${active}" ;;
    esac
}

jaula_assert_hot_version() {
    local expected actual
    expected="$(basename "$(jaula_version_root)")"
    actual="$(jaula_active_version)"
    [[ "$actual" == "$expected" ]] \
        || jaula_die "script fora da versão quente: script=${expected}; ativa=${actual}"
}

jaula_realpath_existing() {
    python3 - "$1" <<'PY'
import os, sys
print(os.path.realpath(sys.argv[1]))
PY
}

jaula_realpath_target() {
    python3 - "$1" <<'PY'
import os, sys
p = os.path.abspath(sys.argv[1])
parent = os.path.realpath(os.path.dirname(p))
print(os.path.join(parent, os.path.basename(p)))
PY
}

jaula_path_within() {
    python3 - "$1" "$2" <<'PY'
import os, sys
path, base = map(os.path.realpath, sys.argv[1:3])
try:
    ok = os.path.commonpath((path, base)) == base
except ValueError:
    ok = False
raise SystemExit(0 if ok else 1)
PY
}

jaula_sha256() {
    if command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | awk '{print $1}'
    else
        sha256sum "$1" | awk '{print $1}'
    fi
}

jaula_timestamp() {
    TZ=America/Cuiaba date '+%Y%m%d-%H%M%S'
}

jaula_attestation_hash() { # <version-root>
    local root="$1" bundle
    bundle="$(mktemp "${TMPDIR:-/tmp}/hbn-jaula-attest-verify.XXXXXX")"
    {
        printf 'BOOT %s  BOOT.md\n' "$(jaula_sha256 "$root/BOOT.md")"
        printf 'PROFILE %s  scripts/jaula/jaula-sh\n' "$(jaula_sha256 "$root/scripts/jaula/jaula-sh")"
        printf 'READ_LIST %s  core/read-list-canonica.txt\n' "$(jaula_sha256 "$root/core/read-list-canonica.txt")"
    } > "$bundle"
    jaula_sha256 "$bundle"
    rm -f "$bundle"
}

jaula_verify_handoff_attestation() { # <handoff> <version-root>
    local handoff="$1" root="$2" declared expected
    [[ -f "$handoff" ]] || return 1
    declared="$(sed -n 's/^ATTESTATION_SHA256: //p' "$handoff")"
    [[ -n "$declared" ]] || return 1
    expected="$(jaula_attestation_hash "$root")" || return 1
    [[ "$declared" == "$expected" ]]
}
