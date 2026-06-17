#!/usr/bin/env bash
# =============================================================================
# guards/assert-arvore-label.sh
# path: guards/assert-arvore-label.sh · id-global: 20260617-184300-codex-guard-arvore-label
# Guarda G-ARVORE-LABEL (R2/readback 0049).
#   (1) Em commit que toca REGISTRY.md, linha nova com arvore
#       intermediaria|estavel deve ser um evento rastreavel de promocao
#       (tipo=arvore-promocao) que referencia readback versionado.
#   (2) Nascer intermediaria|estavel sem evento de promocao BLOQUEIA.
#   (3) Invariante estavel => temperatura=quente BLOQUEIA se violado.
#
# Fail-closed: se a versao ativa, REGISTRY ou STATE nao puderem ser lidos, o
# guard bloqueia. Linhas legadas 5/6-col sem arvore sao ignoradas como historico.
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-arvore-label"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

REGISTRY="REGISTRY.md"
STATE_PATH=".hbn/relay/STATE.md"
REGISTRY_REPO_PATH="$(guard_version_repo_path "$REGISTRY" || true)"
STATE_REPO_PATH="$(guard_version_repo_path "$STATE_PATH" || true)"
if [[ -z "$REGISTRY_REPO_PATH" || -z "$STATE_REPO_PATH" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel localizar REGISTRY/STATE."
    exit 1
fi

blob_ref() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        echo "HEAD:$1"
    else
        echo ":$1"
    fi
}

if ! git show "$(blob_ref "$REGISTRY_REPO_PATH")" >/dev/null 2>&1; then
    guard_fail "Nao foi possivel ler ${REGISTRY} no blob ativo ($(blob_ref "$REGISTRY_REPO_PATH"))."
    exit 1
fi
if ! git show "$(blob_ref "$STATE_REPO_PATH")" >/dev/null 2>&1; then
    guard_fail "Nao foi possivel ler ${STATE_PATH} no blob ativo ($(blob_ref "$STATE_REPO_PATH"))."
    exit 1
fi

registry_changed() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git diff --name-only "${HBN_DIFF_BASE}...HEAD" -- "$REGISTRY_REPO_PATH" 2>/dev/null | grep -qxF "$REGISTRY_REPO_PATH"
    else
        git diff --cached --name-only -- "$REGISTRY_REPO_PATH" 2>/dev/null | grep -qxF "$REGISTRY_REPO_PATH"
    fi
}

if ! registry_changed; then
    guard_ok "REGISTRY.md nao esta no diff; sem rotulo de arvore a validar."
    exit 0
fi

registry_added_lines() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git diff "${HBN_DIFF_BASE}...HEAD" -- "$REGISTRY_REPO_PATH" 2>/dev/null
    else
        git diff --cached -- "$REGISTRY_REPO_PATH" 2>/dev/null
    fi | grep -E '^\+\|' | sed 's/^+//' || true
}

registry_col_count() {
    awk -F'|' '{ print (NF >= 2 ? NF - 2 : 0) }' <<< "$1"
}

registry_col() {
    local line="$1" logical="$2" field
    field=$((logical + 1))
    awk -F'|' -v idx="$field" '{ gsub(/^[ \t]+|[ \t]+$/, "", $idx); print $idx }' <<< "$line"
}

valid_arvore() {
    case "$1" in
        fronteira|intermediaria|estavel) return 0 ;;
    esac
    return 1
}

readback_ref_exists() {
    local line="$1" rb rb_repo
    if [[ "$line" =~ \.hbn/readbacks/[0-9][0-9][0-9][0-9]-[A-Za-z0-9._-]+\.json ]]; then
        rb="${BASH_REMATCH[0]}"
    else
        return 1
    fi
    rb_repo="$(guard_version_repo_path "$rb" || true)"
    [[ -n "$rb_repo" ]] || return 1
    git cat-file -e "$(blob_ref "$rb_repo")" 2>/dev/null
}

FAIL=0
while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    id_col="$(registry_col "$line" 1)"
    [[ -z "$id_col" || "$id_col" == "id" ]] && continue
    [[ "$id_col" =~ ^:?-+:?$ ]] && continue

    cols="$(registry_col_count "$line")"
    if [[ "$cols" -lt 7 ]]; then
        continue
    fi

    path_col="$(registry_col "$line" 2)"
    tipo="$(registry_col "$line" 3)"
    temperatura="$(registry_col "$line" 4)"
    arvore="$(registry_col "$line" 5)"

    if ! valid_arvore "$arvore"; then
        guard_fail "Linha nova do ${REGISTRY} com arvore invalida '${arvore}' para '${path_col}' (valores validos: fronteira|intermediaria|estavel)."
        FAIL=1
        continue
    fi

    if [[ "$arvore" == "estavel" && "$temperatura" != "quente" ]]; then
        guard_fail "Linha nova do ${REGISTRY} viola invariante estavel=>quente: '${path_col}' tem temperatura='${temperatura}'."
        FAIL=1
    fi

    if [[ "$arvore" == "intermediaria" || "$arvore" == "estavel" ]]; then
        if [[ "$tipo" != "arvore-promocao" ]]; then
            guard_fail "Linha nova do ${REGISTRY} rotula '${path_col}' como '${arvore}' sem evento tipo=arvore-promocao. Artefato nasce fronteira; intermediaria/estavel so por promocao append-only."
            FAIL=1
            continue
        fi
        if ! readback_ref_exists "$line"; then
            guard_fail "Evento arvore-promocao para '${path_col}' sem referencia a readback versionado em .hbn/readbacks/NNNN-*.json."
            FAIL=1
        fi
    fi
done <<< "$(registry_added_lines)"

if [[ "$FAIL" -ne 0 ]]; then
    exit 1
fi

guard_ok "Rotulos de arvore no REGISTRY: promocao rastreavel quando exigida; estavel=>quente preservado."
exit 0
