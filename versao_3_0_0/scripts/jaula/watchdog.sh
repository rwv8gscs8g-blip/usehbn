#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=jaula-lib.sh
source "${SCRIPT_DIR}/jaula-lib.sh"

HABITAT="${HBN_JAULA_HABITAT:-}"
REPO="${HBN_JAULA_REPO:-${HABITAT}/repo}"
LEDGER="${HBN_JAULA_LEDGER:-${HABITAT}/ledger}"
BASELINE="${SCRIPT_DIR}/BASELINE.sha256"
[[ -d "$REPO" && -d "$LEDGER" ]] || jaula_die 'habitat/ledger ausente'

alert() {
    local reason="$*" stamp alert_file
    stamp="$(jaula_timestamp)"
    alert_file="${LEDGER}/ALERTA-DERIVA-${stamp}.md"
    umask 077
    printf '# ALERTA DE DERIVA\n\n%s\n' "$reason" > "$alert_file"
    if [[ -n "${HBN_JAULA_AGENT_PID:-}" && "${HBN_JAULA_AGENT_PID}" =~ ^[0-9]+$ ]]; then
        kill -TERM "$HBN_JAULA_AGENT_PID" 2>/dev/null || true
    fi
    printf '[jaula/watchdog] DERIVA: %s\n' "$reason" >&2
    exit 1
}

canary="${REPO}/.hbn-jaula-canary.$$"
if ( : > "$canary" ) 2>/dev/null; then
    rm -f "$canary" 2>/dev/null || true
    alert 'canário de escrita no repo teve sucesso'
fi

[[ -r "$BASELINE" ]] || alert 'baseline de TCB ausente'
while read -r expected rel; do
    [[ -n "$expected" && -n "$rel" ]] || continue
    target="$(jaula_version_root)/${rel#\*}"
    [[ -f "$target" ]] || alert "TCB ausente: ${rel}"
    [[ "$(jaula_sha256 "$target")" == "$expected" ]] || alert "hash divergente: ${rel}"
done < "$BASELINE"

while IFS= read -r item; do
    rel="${item#${LEDGER}/}"
    case "$rel" in
        prompts/*.md|dispatches/*.md|handoffs/*.md|readbacks-draft/*.json|quarantine/*|ALERTA-DERIVA-*.md) ;;
        *)
            mkdir -p "$LEDGER/quarantine"
            mv "$item" "$LEDGER/quarantine/$(basename "$item").$(jaula_timestamp)"
            alert "artefato fora do contrato foi posto em quarentena: ${rel}"
            ;;
    esac
done < <(find "$LEDGER" -type f ! -path "$LEDGER/quarantine/*" -print)

denies="${LEDGER}/.denied-count"
count="$(cat "$denies" 2>/dev/null || printf 0)"
[[ "$count" =~ ^[0-9]+$ ]] || alert 'contador de negações inválido'
limit="${HBN_JAULA_DENY_LIMIT:-5}"
(( count <= limit )) || alert "limite de tentativas negadas excedido: ${count}>${limit}"
printf '[jaula/watchdog] OK\n'
