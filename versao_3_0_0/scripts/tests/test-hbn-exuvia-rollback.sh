#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ROLLBACK="${REPO_ROOT}/scripts/hbn-exuvia-rollback.sh"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

sha256_of() {
    if command -v sha256sum >/dev/null 2>&1; then
        printf '%s' "$1" | sha256sum | awk '{print $1}'
    else
        printf '%s' "$1" | shasum -a 256 | awk '{print $1}'
    fi
}

assert_eq() {
    local expected="$1" actual="$2" label="$3"
    if [[ "$expected" != "$actual" ]]; then
        echo "FAIL: ${label}" >&2
        echo "  esperado: ${expected}" >&2
        echo "  obtido:   ${actual}" >&2
        exit 1
    fi
}

assert_file_contains() {
    local file="$1" needle="$2" label="$3"
    if ! grep -qF "$needle" "$file"; then
        echo "FAIL: ${label}" >&2
        echo "  arquivo: ${file}" >&2
        echo "  esperado conter: ${needle}" >&2
        exit 1
    fi
}

fixture="${tmpdir}/repo"
mkdir -p "${fixture}/.hbn/relay"
git -C "$tmpdir" init repo >/dev/null
git -C "$fixture" config user.name "HBN Test"
git -C "$fixture" config user.email "hbn-test@example.invalid"

printf '.\n' > "${fixture}/.hbn/active-version"
cat > "${fixture}/.hbn/relay/STATE.md" <<'EOF'
---
bastao_token_sha256: target-placeholder
proprietario_bastao: codex
---
EOF
git -C "$fixture" add .hbn/active-version .hbn/relay/STATE.md
git -C "$fixture" commit -m "target root state" >/dev/null
target_commit="$(git -C "$fixture" rev-parse HEAD)"

mkdir -p "${fixture}/versao_1_0_0/.hbn/relay"
printf 'versao_1_0_0\n' > "${fixture}/.hbn/active-version"
cat > "${fixture}/versao_1_0_0/.hbn/relay/STATE.md" <<'EOF'
---
bastao_token_sha256: head-placeholder
proprietario_bastao: codex
---
EOF
git -C "$fixture" add .hbn/active-version versao_1_0_0/.hbn/relay/STATE.md
git -C "$fixture" commit -m "head versioned state" >/dev/null
head_before="$(git -C "$fixture" rev-parse HEAD)"

token="codex"
expected_hash="$(sha256_of "$token")"
printf '%s\n' "$token" > "${fixture}/.git/hbn-baton-token"

dry_run_output="${tmpdir}/dry-run.out"
(
    cd "$fixture"
    "$ROLLBACK" --dry-run --target "$target_commit" > "$dry_run_output"
)
head_after_dry_run="$(git -C "$fixture" rev-parse HEAD)"
assert_eq "$head_before" "$head_after_dry_run" "--dry-run nao deve mover HEAD"
assert_eq "versao_1_0_0" "$(tr -d '[:space:]' < "${fixture}/.hbn/active-version")" "--dry-run nao deve alterar active-version"
assert_file_contains "$dry_run_output" "state_path: .hbn/relay/STATE.md" "--dry-run deve planejar STATE do TARGET"

(
    cd "$fixture"
    "$ROLLBACK" --apply --target "$target_commit" >/dev/null
)
head_after_apply="$(git -C "$fixture" rev-parse HEAD)"
assert_eq "$target_commit" "$head_after_apply" "--apply deve resetar para TARGET"
assert_eq "." "$(tr -d '[:space:]' < "${fixture}/.hbn/active-version")" "--apply deve restaurar active-version do TARGET"
assert_file_contains "${fixture}/.hbn/relay/STATE.md" "bastao_token_sha256: ${expected_hash}" "--apply deve reconciliar STATE ativo do TARGET"

if [[ -e "${fixture}/versao_1_0_0/.hbn/relay/STATE.md" ]]; then
    echo "FAIL: --apply reconciliou ou preservou STATE da versao antiga" >&2
    exit 1
fi

echo "PASS: rollback --apply reconcilia STATE usando active-version do TARGET; --dry-run nao altera o worktree"
