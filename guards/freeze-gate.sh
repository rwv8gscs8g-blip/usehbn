#!/usr/bin/env bash
# =============================================================================
# guards/freeze-gate.sh
# Gate G-FRZ: lê um freeze-checklist (schemas/freeze-checklist.schema.json) e
# responde "congelável: sim" (exit 0) ou "congelável: não" + o que falta (exit 1).
#
# status: proposed (corrente D, 2026-06-10) — NÃO está no runner de pre-commit
#   (não é guard de commit: é gate de release, invocado sob demanda):
#     bash guards/freeze-gate.sh <caminho/do/checklist.json>
# Regras (ADR-017): obrigatorio=true precisa ok; ok exige evidencia;
#   na exige justificativa; bloqueadores_abertos > 0 = veto.
# Usa python3 só para parsear JSON (mesmo precedente do assert-scope-lock).
# Knowledge 0021: em sandbox informativo; conclusivo no Terminal do operador.
# =============================================================================
set -euo pipefail

GUARD_NAME="freeze-gate"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

CHECKLIST="${1:-}"
if [[ -z "$CHECKLIST" || ! -f "$CHECKLIST" ]]; then
    guard_fail "Uso: freeze-gate.sh <freeze-checklist.json> (arquivo não encontrado: '${CHECKLIST}')"
    exit 2
fi

set +e
python3 - "$CHECKLIST" <<'PYEOF'
import json, sys

path = sys.argv[1]
try:
    c = json.load(open(path))
except Exception as e:
    print(f"congelável: não — checklist ilegível: {e}")
    sys.exit(1)

faltas = []

blo = c.get("bloqueadores_abertos")
if not isinstance(blo, int):
    faltas.append("campo bloqueadores_abertos ausente/ inválido")
elif blo > 0:
    faltas.append(f"{blo} BLOQUEADOR(es) aberto(s) — veto (cadência D)")

criterios = c.get("criterios") or []
if not criterios:
    faltas.append("checklist sem critérios")

for cr in criterios:
    cid = cr.get("id", "<sem-id>")
    st = cr.get("status")
    if st == "ok" and not cr.get("evidencia"):
        faltas.append(f"critério '{cid}': ok SEM evidência (Truth Barrier)")
    elif st == "na" and not cr.get("justificativa"):
        faltas.append(f"critério '{cid}': na SEM justificativa")
    elif cr.get("obrigatorio") and st != "ok":
        desc = cr.get("descricao", "")
        faltas.append(f"critério obrigatório '{cid}' está '{st}': {desc}")

alvo = c.get("versao_alvo", "?")
if faltas:
    print(f"congelável: não — {alvo}")
    for f in faltas:
        print(f"  ✗ {f}")
    sys.exit(1)
print(f"congelável: sim — {alvo} (todos os critérios obrigatórios ok, com evidência; zero BLOQUEADOR)")
sys.exit(0)
PYEOF
RC=$?
set -e
if [[ $RC -eq 0 ]]; then
    guard_ok "Gate de freeze: PASSA."
else
    guard_fail "Gate de freeze: NÃO congelável (lista acima)."
fi
exit $RC
