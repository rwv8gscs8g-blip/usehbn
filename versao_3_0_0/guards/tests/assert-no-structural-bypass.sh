#!/usr/bin/env bash
# Anti-regressão: classe estrutural nunca aceita bypass, nem com nota+hearback.
set -uo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
VERSION_ROOT="$(cd "${TESTS_DIR}/../.." && pwd -P)"
COMMON="${VERSION_ROOT}/guards/lib/common.sh"
MANIFEST="${VERSION_ROOT}/guards/MANIFEST.yaml"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/hbn-no-structural-bypass.XXXXXX")"
trap 'rm -rf "$TMP" 2>/dev/null || true' EXIT INT TERM

fail() { printf '[anti-bypass] FALHA: %s\n' "$*" >&2; exit 1; }

python3 - "$MANIFEST" <<'PY' || fail 'MANIFEST sem classe completa/válida'
import sys
path = sys.argv[1]
records = []
current = None
for raw in open(path, encoding="utf-8"):
    line = raw.strip()
    if line.startswith("- guard:"):
        if current:
            records.append(current)
        current = {"guard": line.split(":", 1)[1].strip()}
    elif current is not None and line.startswith("classe:"):
        current["classe"] = line.split(":", 1)[1].strip()
if current:
    records.append(current)
if not records or any(r.get("classe") not in {"estrutural", "documental"} for r in records):
    raise SystemExit(1)
PY

mkdir -p "$TMP/.hbn/bypasses" "$TMP/.hbn/hearbacks" "$TMP/guards"
printf '.\n' > "$TMP/.hbn/active-version"
cat > "$TMP/guards/MANIFEST.yaml" <<'EOF'
guards:
  - guard: prova-estrutural
    classe: estrutural
    path: guards/prova-estrutural.sh
EOF
cat > "$TMP/.hbn/hearbacks/0001-confirmado.json" <<'EOF'
{"status":"confirmado","gate":{"assinatura":"Gate Humano"}}
EOF
cat > "$TMP/.hbn/bypasses/20260711-190000-teste-prova.md" <<'EOF'
hearback_ref: .hbn/hearbacks/0001-confirmado.json
motivo: prova negativa de bypass estrutural
EOF
(
    cd "$TMP" || exit 1
    git init -q
    git config user.email tests@hbn.local
    git config user.name hbn-tests
    git add .
    GUARD_NAME=prova-estrutural HBN_GUARDS_BYPASS=1 bash -c \
        'source "$1"; guard_check_bypass' _ "$COMMON"
) >/dev/null 2>&1 && fail 'guard estrutural aceitou bypass com nota+hearback'

while IFS= read -r guard; do
    [[ -n "$guard" ]] || continue
    (
        cd "$(cd "$VERSION_ROOT/.." && pwd -P)" || exit 1
        GUARD_NAME="$guard" GLASSWING_BYPASS=1 bash -c \
            'source "$1"; guard_check_bypass' _ "$COMMON"
    ) >/dev/null 2>&1 && fail "guard estrutural aceitou bypass: ${guard}"
done < <(awk '$1=="-" && $2=="guard:" {g=$3} $1=="classe:" && $2=="estrutural" {print g}' "$MANIFEST")

printf '[anti-bypass] OK: classes completas; bypass estrutural sempre recusado.\n'
