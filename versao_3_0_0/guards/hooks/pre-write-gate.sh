#!/usr/bin/env bash
# Ponto único de verdade para autorização de escrita antes da ferramenta.
set -euo pipefail

deny() {
    printf '[G-PRE-WRITE] BLOQUEADO: %s\n' "$*" >&2
    exit 2
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
VERSION_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd -P)"
REPO_ROOT="$(git -C "$VERSION_ROOT" rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$REPO_ROOT" ]] || deny 'fora do repositório canônico'
ACTIVE="$(sed '/^[[:space:]]*#/d;/^[[:space:]]*$/d' "$REPO_ROOT/.hbn/active-version" 2>/dev/null || true)"
[[ "$ACTIVE" == "$(basename "$VERSION_ROOT")" ]] || deny 'este gate não pertence à versão quente'

ROLE="${HBN_ACTOR_ROLE:-unknown}"
TOOL="${HBN_TOOL_NAME:-}"
TARGET="${1:-}"
INPUT=''
if [[ -z "$TARGET" && ! -t 0 ]]; then
    INPUT="$(cat)"
    parsed="$(python3 - "$INPUT" <<'PY'
import json, sys
try:
    d = json.loads(sys.argv[1])
except Exception:
    raise SystemExit(0)
tool = d.get('tool_name') or d.get('tool') or ''
i = d.get('tool_input') or d.get('input') or {}
path = i.get('file_path') or i.get('path') or '' if isinstance(i, dict) else ''
command = i.get('command') or '' if isinstance(i, dict) else ''
print(tool)
print(path)
print(command)
PY
)"
    TOOL="$(printf '%s\n' "$parsed" | sed -n '1p')"
    TARGET="$(printf '%s\n' "$parsed" | sed -n '2p')"
    COMMAND="$(printf '%s\n' "$parsed" | sed -n '3p')"
else
    COMMAND="${HBN_TOOL_COMMAND:-}"
fi

TOOL_LOWER="$(printf '%s' "$TOOL" | tr '[:upper:]' '[:lower:]')"
case "$TOOL_LOWER" in
    bash|shell)
        if [[ "$ROLE" == orquestrador && "$COMMAND" != jaula-sh\ * && "$COMMAND" != */jaula-sh\ * ]]; then
            deny 'Bash do orquestrador só pode delegar ao jaula-sh'
        fi
        [[ "$COMMAND" != *'--no-verify'* && "$COMMAND" != *'chmod +w'* ]] \
            || deny 'comando contém flag de burla'
        exit 0
        ;;
esac

[[ -n "$TARGET" ]] || deny 'ferramenta de escrita sem path explícito'
resolved="$(python3 - "$TARGET" <<'PY'
import os, sys
p = os.path.abspath(os.path.expanduser(sys.argv[1]))
print(os.path.join(os.path.realpath(os.path.dirname(p)), os.path.basename(p)))
PY
)"

within() {
    python3 - "$resolved" "$1" <<'PY'
import os, sys
p, b = map(os.path.realpath, sys.argv[1:3])
try: ok = os.path.commonpath((p,b)) == b
except ValueError: ok = False
raise SystemExit(0 if ok else 1)
PY
}

if [[ "$ROLE" == orquestrador ]]; then
    [[ -n "${HBN_JAULA_LEDGER:-}" ]] || deny 'ledger não definido para orquestrador'
    within "$HBN_JAULA_LEDGER" || deny 'orquestrador só escreve no ledger externo'
    [[ ! -L "$TARGET" ]] || deny 'symlink recusado no ledger'
    exit 0
fi

within "$VERSION_ROOT" || deny 'escrita fora da versão quente'

case "$ROLE" in
    implementador|humano) exit 0 ;;
    auditor) within "$VERSION_ROOT/.hbn/results" || deny 'auditor só escreve em .hbn/results'; exit 0 ;;
    arquiteto) within "$VERSION_ROOT/.hbn/messages" || within "$VERSION_ROOT/docs" || deny 'arquiteto fora da matriz'; exit 0 ;;
    *) deny "ator sem capacidade de escrita: ${ROLE}" ;;
esac
