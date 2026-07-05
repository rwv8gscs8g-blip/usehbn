#!/usr/bin/env bash
# =============================================================================
# guards/assert-manifest-current.sh
# G-MANIFEST: guards/MANIFEST.yaml deve ser derivado dos blocos requires.
# =============================================================================
# ---HBN-REQUIRES-BEGIN---
# requires:
#   files:
#     - path: guards/MANIFEST.yaml
#       install: copy
#       source: guards/MANIFEST.yaml
#   dirs: []
#   state_fields: []
#   guards: []
#   env: []
# ---HBN-REQUIRES-END---
set -euo pipefail

GUARD_NAME="assert-manifest-current"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

MANIFEST_PATH="guards/MANIFEST.yaml"
MANIFEST_REPO_PATH="$(guard_version_repo_path "$MANIFEST_PATH" || true)"
if [[ -z "$MANIFEST_REPO_PATH" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel resolver ${MANIFEST_PATH}."
    exit 1
fi

blob_ref() {
    if hbn_ci_range_mode; then
        echo "HEAD:$1"
    else
        echo ":$1"
    fi
}

if ! git cat-file -e "$(blob_ref "$MANIFEST_REPO_PATH")" 2>/dev/null; then
    guard_fail "${MANIFEST_PATH} ausente no indice/HEAD. Rode: bash guards/generate-manifest.sh > guards/MANIFEST.yaml e stageie o resultado."
    exit 1
fi

GENERATED="$(mktemp)"
CURRENT="$(mktemp)"
trap 'rm -f "$GENERATED" "$CURRENT"' EXIT

if ! bash "${SCRIPT_DIR}/generate-manifest.sh" > "$GENERATED"; then
    guard_fail "Falha ao gerar MANIFEST a partir dos blocos requires. Corrija sentinelas ou schema dos guards."
    exit 1
fi
git show "$(blob_ref "$MANIFEST_REPO_PATH")" > "$CURRENT"

if ! cmp -s "$GENERATED" "$CURRENT"; then
    guard_fail "${MANIFEST_PATH} divergente dos blocos requires. Regenerar com: bash guards/generate-manifest.sh > guards/MANIFEST.yaml"
    diff -u "$CURRENT" "$GENERATED" >&2 || true
    exit 1
fi

guard_ok "MANIFEST atual: ${MANIFEST_PATH} deriva dos blocos requires."
exit 0
