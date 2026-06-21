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

ACTIVE_LINES="$(printf '%s\n' "$CONTENT" | sed '/^[[:space:]]*#/d')"
FAIL=0

if ! grep -Eq '(^|[^A-Za-z0-9_./-])bash[[:space:]]+guards/tests/run-guard-tests\.sh([^A-Za-z0-9_./-]|$)' <<< "$ACTIVE_LINES"; then
    guard_fail "${WORKFLOW_PATH} nao invoca 'bash guards/tests/run-guard-tests.sh' no indice/HEAD."
    FAIL=1
fi

if ! grep -Eq '(^|[^A-Za-z0-9_./-])bash[[:space:]]+guards/tests/adversarial-battery\.sh([^A-Za-z0-9_./-]|$)' <<< "$ACTIVE_LINES"; then
    guard_fail "${WORKFLOW_PATH} nao invoca 'bash guards/tests/adversarial-battery.sh' no indice/HEAD."
    FAIL=1
fi

if [[ "$FAIL" -ne 0 ]]; then
    exit 1
fi

guard_ok "CI preserva run-guard-tests.sh e adversarial-battery.sh no HBN Shield."
exit 0
