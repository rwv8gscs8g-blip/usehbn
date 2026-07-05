#!/usr/bin/env bash
set -euo pipefail

TAG_DEFAULT="hbn-exuvia/protocol-0.3.x"
TARGET="$TAG_DEFAULT"
MODE="dry-run"

usage() {
    cat <<'EOF'
Uso: scripts/hbn-exuvia-rollback.sh [--dry-run] [--apply] [--target <ref>]

Prepara/valida rollback da hbn-exuvia reconciliando token local em
.git/hbn-baton-token com o STATE da versão ativa. Por padrão não altera nada.

Opções:
  --dry-run       apenas relata o plano (padrão)
  --apply         executa git reset --hard <ref> e reconcilia o STATE ativo
  --target <ref>  ref/tag de rollback (padrão: hbn-exuvia/protocol-0.3.x)
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) MODE="dry-run"; shift ;;
        --apply) MODE="apply"; shift ;;
        --target)
            [[ $# -ge 2 ]] || { usage >&2; exit 2; }
            TARGET="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Argumento desconhecido: $1" >&2; usage >&2; exit 2 ;;
    esac
done

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$repo_root" ]] || { echo "ERRO: fora de um worktree Git" >&2; exit 1; }
cd "$repo_root"

sha256_of() {
    if command -v sha256sum >/dev/null 2>&1; then
        printf '%s' "$1" | sha256sum | awk '{print $1}'
    else
        printf '%s' "$1" | shasum -a 256 | awk '{print $1}'
    fi
}

git cat-file -e "${TARGET}^{commit}" 2>/dev/null || {
    echo "ERRO: target '${TARGET}' não existe como commit/tag local." >&2
    echo "M-A não cria a tag; ela só deve existir após o corte real M-C." >&2
    exit 1
}

git_common_dir="$(git rev-parse --git-common-dir 2>/dev/null || echo .git)"
case "$git_common_dir" in
    /*) ;;
    *) git_common_dir="${repo_root}/${git_common_dir}" ;;
esac
token_file="${git_common_dir}/hbn-baton-token"

active_rel_from_ref() {
    local ref="$1"
    local rel
    rel="$(git show "${ref}:.hbn/active-version" 2>/dev/null \
        | grep -v '^[[:space:]]*#' \
        | grep -v '^[[:space:]]*$' \
        | head -1 || true)"
    rel="$(printf '%s' "$rel" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
    [[ -z "$rel" ]] && rel="."
    printf '%s\n' "$rel"
}

state_path_for_active_rel() {
    local rel="$1"
    local path=".hbn/relay/STATE.md"
    if [[ "$rel" != "." ]]; then
        path="${rel}/${path}"
    fi
    printf '%s\n' "$path"
}

token_hash=""
token_fp=""
if [[ -f "$token_file" ]]; then
    token="$(tr -d '[:space:]' < "$token_file")"
    token_hash="$(sha256_of "$token")"
    token_fp="$(printf '%s' "$token_hash" | cut -c1-8)"
fi

active_rel="$(active_rel_from_ref "$TARGET")"
state_path="$(state_path_for_active_rel "$active_rel")"

target_state_hash="$(git show "${TARGET}:${state_path}" 2>/dev/null \
    | grep -E '^[[:space:]]*bastao_token_sha256:' | head -1 \
    | sed -E 's/^[[:space:]]*bastao_token_sha256:[[:space:]]*//; s/["'"'"']//g; s/[[:space:]]+$//' || true)"

echo "hbn-exuvia rollback (${MODE})"
echo "repo: ${repo_root}"
echo "target: ${TARGET}"
echo "state_path: ${state_path}"
if [[ -n "$token_hash" ]]; then
    echo "token_local: presente (${token_fp})"
else
    echo "token_local: ausente"
fi
echo "state_target_hash: ${target_state_hash:-ausente}"

if [[ "$MODE" == "dry-run" ]]; then
    echo ""
    echo "DRY-RUN: nenhuma alteração aplicada."
    echo "Plano:"
    echo "  1. preservar ${token_file}"
    echo "  2. git reset --hard ${TARGET}"
    if [[ -n "$token_hash" ]]; then
        echo "  3. reconciliar ${state_path}: bastao_token_sha256=${token_hash}"
        echo "  4. usar trailer HBN-Token-FP: ${token_fp}"
    else
        echo "  3. bloquear reconciliação automática: token local ausente; operador deve restaurar ou rotacionar token"
    fi
    exit 0
fi

if [[ -z "$token_hash" ]]; then
    echo "ERRO: --apply exige token local em ${token_file}; sem ele o STATE não pode ser reconciliado." >&2
    exit 1
fi

git reset --hard "$TARGET"

if [[ ! -f "$state_path" ]]; then
    echo "ERRO: STATE ativo não encontrado após rollback: ${state_path}" >&2
    exit 1
fi

tmp="${state_path}.tmp.$$"
if grep -qE '^[[:space:]]*bastao_token_sha256:' "$state_path"; then
    sed -E "s|^[[:space:]]*bastao_token_sha256:.*|bastao_token_sha256: ${token_hash}|" "$state_path" > "$tmp"
else
    awk -v h="$token_hash" 'NR==2{print "bastao_token_sha256: " h} {print}' "$state_path" > "$tmp"
fi
mv "$tmp" "$state_path"
echo "Rollback aplicado. STATE reconciliado com token local (${token_fp})."
echo "Staging/commit é ato do operador; incluir trailer HBN-Token-FP: ${token_fp}."
