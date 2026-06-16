#!/usr/bin/env bash
# =============================================================================
# guards/assert-frontdoor.sh
# G-FRONTDOOR: garante que core/role-cards.md continue sendo a porta da frente
# minima: arquivo presente/legivel, teto anti-monolito e read-list limitada.
# Le o blob staged localmente e HEAD em CI; working tree solta nao conta.
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-frontdoor"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

ROLE_CARDS_PATH="core/role-cards.md"

blob_ref() {
    local p
    p="$(guard_version_repo_path "$1")" || return 1
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        echo "HEAD:$p"
    else
        echo ":$p"
    fi
}

ROLE_REF="$(blob_ref "$ROLE_CARDS_PATH" || true)"
if [[ -z "$ROLE_REF" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel localizar ${ROLE_CARDS_PATH}."
    exit 1
fi

if ! git cat-file -e "$ROLE_REF" 2>/dev/null; then
    guard_fail "Porta da frente ausente no indice/HEAD: ${ROLE_CARDS_PATH}."
    exit 1
fi

CONTENT="$(git show "$ROLE_REF" 2>/dev/null || true)"
if [[ -z "$CONTENT" ]]; then
    guard_fail "Porta da frente ilegivel no indice/HEAD: ${ROLE_CARDS_PATH}."
    exit 1
fi

LINE_COUNT="$(printf '%s\n' "$CONTENT" | wc -l | tr -d '[:space:]')"
if [[ "${LINE_COUNT:-0}" -gt 140 ]]; then
    guard_fail "${ROLE_CARDS_PATH} excede o teto anti-monolito: ${LINE_COUNT} linhas (maximo 140)."
    exit 1
fi

READLIST_ITEMS="$(printf '%s\n' "$CONTENT" | awk '
    /^##[[:space:]]+PARTE A[[:space:]-]/ { in_part = 1; seen = 1; next }
    /^##[[:space:]]+PARTE B[[:space:]-]/ { in_part = 0 }
    in_part && /^[[:space:]]*([0-9]+\.|-|\*)[[:space:]]+/ { count++ }
    END {
        if (!seen) {
            print "MISSING"
        } else {
            print count + 0
        }
    }
')"

if [[ "$READLIST_ITEMS" == "MISSING" ]]; then
    guard_fail "Secao 'PARTE A - READ-LIST DA PORTA DA FRENTE' ausente em ${ROLE_CARDS_PATH}."
    exit 1
fi

if [[ "$READLIST_ITEMS" -gt 6 ]]; then
    guard_fail "Read-list da porta da frente tem ${READLIST_ITEMS} itens (maximo 6)."
    exit 1
fi

guard_ok "Porta da frente OK: ${LINE_COUNT} linhas; read-list com ${READLIST_ITEMS} item(ns)."
exit 0
