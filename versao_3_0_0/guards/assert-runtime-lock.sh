#!/usr/bin/env bash
# G-RUNTIME-LOCK — runtime só pode nascer dentro da versão quente e sem drift.
# ---HBN-REQUIRES-BEGIN---
# requires:
#   files:
#     - path: usehbn/_lock.py
#       install: copy
#       source: usehbn/_lock.py
#     - path: scripts/jaula/BASELINE.sha256
#       install: copy
#       source: scripts/jaula/BASELINE.sha256
#   dirs: []
#   state_fields: []
#   guards: []
#   env: []
# ---HBN-REQUIRES-END---
set -euo pipefail
GUARD_NAME="assert-runtime-lock"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

ACTIVE_ROOT="$(get_canonical_root || true)"
THIS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd -P)"
if [[ -z "$ACTIVE_ROOT" || "$ACTIVE_ROOT" != "$THIS_ROOT" ]]; then
    guard_fail "runtime lock fora da versão ativa: ativa=${ACTIVE_ROOT:-inválida}; guard=${THIS_ROOT}"
    exit 1
fi

LOCK="${THIS_ROOT}/usehbn/_lock.py"
BASELINE="${THIS_ROOT}/scripts/jaula/BASELINE.sha256"
[[ -f "$LOCK" && -f "$BASELINE" ]] || {
    guard_fail 'módulo de lock ou baseline ausente'
    exit 1
}

manifest_expected="$(awk '$2=="guards/MANIFEST.yaml" {print $1}' "$BASELINE")"
manifest_actual="$(python3 - "${THIS_ROOT}/guards/MANIFEST.yaml" <<'PY'
import hashlib, pathlib, sys
print(hashlib.sha256(pathlib.Path(sys.argv[1]).read_bytes()).hexdigest())
PY
)"
if [[ -z "$manifest_expected" || "$manifest_expected" != "$manifest_actual" ]]; then
    guard_fail 'hash do MANIFEST diverge da baseline assinável'
    exit 1
fi

PYTHONPATH="$THIS_ROOT${PYTHONPATH:+:$PYTHONPATH}" python3 - <<'PY' || {
import usehbn._lock  # noqa: F401 -- a prova é o efeito fail-closed do import
PY
    guard_fail 'import do runtime lock não validou a versão ativa e o MANIFEST'
    exit 1
}

if rg -n --glob '*.py' --glob '!_lock.py' '(subprocess\.|os\.system\(|os\.popen\()' "$THIS_ROOT/usehbn" 2>/dev/null; then
    guard_fail 'entrypoint usa subprocess/os.system fora do chokepoint auditado'
    exit 1
fi

while IFS= read -r py; do
    [[ "$(basename "$py")" == _lock.py ]] && continue
    rg -q '(^|[[:space:]])(from[[:space:]]+usehbn[[:space:]]+import[[:space:]]+_lock|from[[:space:]]+usehbn\._lock[[:space:]]+import|import[[:space:]]+usehbn\._lock)' "$py" || {
        guard_fail "entrypoint Python sem import do runtime lock: ${py#${THIS_ROOT}/}"
        exit 1
    }
done < <(find "$THIS_ROOT/usehbn" -type f -name '*.py' 2>/dev/null)

guard_ok 'runtime preso à versão quente; MANIFEST íntegro; APIs perigosas ausentes.'
