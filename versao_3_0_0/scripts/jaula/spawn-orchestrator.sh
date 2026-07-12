#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=jaula-lib.sh
source "${SCRIPT_DIR}/jaula-lib.sh"
jaula_assert_hot_version

ROOT="$(jaula_repo_root)"
BASE="${HBN_JAULA_HOME:-${HOME}/Projetos/.hbn-orq}"
stamp="$(jaula_timestamp)-$$"
HABITAT="${BASE}/${stamp}"
REPO="${HABITAT}/repo"
LEDGER="${HABITAT}/ledger"
mkdir -p "$LEDGER"/{prompts,dispatches,handoffs,readbacks-draft,quarantine}

cleanup() {
    if [[ "${spawn_ok:-0}" != 1 ]]; then
        chmod -R u+w "$HABITAT" 2>/dev/null || true
        git -C "$ROOT" worktree remove --force "$REPO" >/dev/null 2>&1 || true
    fi
}
trap cleanup EXIT

HBN_JAULA_LEDGER="$LEDGER" HBN_ATTESTATION_OPERATOR="${HBN_ATTESTATION_OPERATOR:-PENDENTE}" \
    "${SCRIPT_DIR}/gen-orchestrator-handoff.sh" "$LEDGER" >/dev/null
handoff="$(find "$LEDGER/handoffs" -type f -name '*-orq-enjaulado.md' -print | sort | tail -1)"
[[ -n "$handoff" ]] || jaula_die 'handoff atestado não foi gerado'
[[ "$(sed -n 's/^ATTESTATION_OPERATOR: //p' "$handoff")" != PENDENTE ]] \
    || jaula_die 'spawn exige HBN_ATTESTATION_OPERATOR definido pelo gate'

git -C "$ROOT" worktree add --detach "$REPO" HEAD >/dev/null

# Confere a atestação contra regras canônicas, nunca contra o texto narrativo.
VERSION="$(jaula_active_version)"
jaula_verify_handoff_attestation "$handoff" "$REPO/$VERSION" \
    || jaula_die 'atestação do handoff diverge das regras canônicas'

chmod -R a-w "$REPO"
chmod -R u+rwX "$LEDGER"
cat > "${HABITAT}/environment" <<EOF
export HBN_ACTOR_ROLE=orquestrador
export HBN_JAULA_HABITAT='${HABITAT}'
export HBN_JAULA_REPO='${REPO}'
export HBN_JAULA_LEDGER='${LEDGER}'
export PATH='${REPO}/${VERSION}/scripts/jaula:/usr/bin:/bin:/usr/sbin:/sbin'
export GIT_CONFIG_GLOBAL=/dev/null
export GIT_TERMINAL_PROMPT=0
export GIT_ASKPASS=/usr/bin/false
EOF
chmod 0444 "${HABITAT}/environment"
spawn_ok=1
trap - EXIT
printf 'HABITAT=%s\nREPO=%s\nLEDGER=%s\nHANDOFF=%s\n' "$HABITAT" "$REPO" "$LEDGER" "$handoff"
