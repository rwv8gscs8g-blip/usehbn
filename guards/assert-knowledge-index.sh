#!/usr/bin/env bash
# =============================================================================
# guards/assert-knowledge-index.sh
# path: guards/assert-knowledge-index.sh
# G-KNOW-INDEX: garante que toda entrada .hbn/knowledge/*.md esteja citada no
# .hbn/knowledge/INDEX.md. O INDEX e ponteiro vivo, nao inventario manual
# opcional: omissao vira bloqueio.
#
# Padrao dos guards C3: localmente le o indice staged; em CI le HEAD no range
# validado por HBN_DIFF_BASE. A working tree solta nao conta.
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-knowledge-index"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

INDEX_PATH=".hbn/knowledge/INDEX.md"
KNOWLEDGE_DIR=".hbn/knowledge"
INDEX_REPO_PATH="$(guard_version_repo_path "$INDEX_PATH" || true)"
KNOWLEDGE_REPO_DIR="$(guard_version_repo_path "$KNOWLEDGE_DIR" || true)"

if [[ -z "$INDEX_REPO_PATH" || -z "$KNOWLEDGE_REPO_DIR" ]]; then
    guard_fail "Versão ativa inválida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Não é possível localizar a knowledge base."
    exit 1
fi

index_content() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git show "HEAD:${INDEX_REPO_PATH}" 2>/dev/null
    else
        git show ":${INDEX_REPO_PATH}" 2>/dev/null
    fi
}

knowledge_files() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git ls-tree -r --name-only HEAD -- "$KNOWLEDGE_REPO_DIR" 2>/dev/null || true
    else
        git ls-files --cached -- "$KNOWLEDGE_REPO_DIR" 2>/dev/null || true
    fi | guard_paths_to_version_paths \
        | grep -E '^\.hbn/knowledge/[^/]+\.md$' \
        | sort -u || true
}

if ! INDEX_CONTENT="$(index_content)"; then
    guard_fail "INDEX da knowledge ausente ou ilegível no índice/HEAD: ${INDEX_PATH}. G-KNOW-INDEX falha fechado."
    exit 1
fi

FAIL=0
COUNT=0
while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    base="$(basename "$f")"
    [[ "$base" == "INDEX.md" ]] && continue
    COUNT=$((COUNT + 1))
    if ! grep -Fq "$base" <<< "$INDEX_CONTENT"; then
        guard_fail "Entrada de knowledge sem citação no INDEX: ${f}. Adicione '${base}' em ${INDEX_PATH} no mesmo commit."
        FAIL=1
    fi
done <<< "$(knowledge_files)"

if [[ "$FAIL" -ne 0 ]]; then
    exit 1
fi

guard_ok "INDEX da knowledge cita todas as entradas .md (${COUNT})."
exit 0
