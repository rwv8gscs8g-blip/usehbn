#!/usr/bin/env bash
# =============================================================================
# guards/assert-role-family.sh
# Guarda G-FAM: invariante anti-groupthink (ADR-018 Decisão 2).
#   família(auditor de X) ≠ família(implementador de X)
# família = campo `fornecedor` do perfil .hbn/models/<apelido>.json (ADR-015).
#
# status: proposed (corrente D, 2026-06-10) — NÃO está no runner.
#   Invocação sob demanda (atribuição de onda / handoff):
#     bash guards/assert-role-family.sh <atribuicao.json>
#   onde o JSON tem a forma do campo `atribuicao` do STATE
#   (core/roles-assignment-spec.md §2).
# BLOQUEADOR: auditor da família do implementador sem hearback_ref;
#             papel fora de papeis_aptos sem hearback_ref.
# AVISO:      auditores todos da mesma família entre si.
# Usa python3 só para JSON (precedente assert-scope-lock).
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-role-family"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

ATRIB="${1:-}"
if [[ -z "$ATRIB" || ! -f "$ATRIB" ]]; then
    guard_fail "Uso: assert-role-family.sh <atribuicao.json> (arquivo não encontrado: '${ATRIB}')"
    exit 2
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
MODELS_DIR="${HBN_MODELS_DIR:-${REPO_ROOT}/.hbn/models}"

set +e
python3 - "$ATRIB" "$MODELS_DIR" <<'PYEOF'
import json, os, sys

atrib_path, models_dir = sys.argv[1], sys.argv[2]
a = json.load(open(atrib_path))

def perfil(apelido):
    p = os.path.join(models_dir, f"{apelido}.json")
    if not os.path.isfile(p):
        print(f"  ✗ BLOQUEADOR: perfil inexistente para '{apelido}' ({p})")
        return None
    return json.load(open(p))

impl = a.get("implementador")
auditores = a.get("auditores") or []
hearback = a.get("hearback_ref")
falhas, avisos = [], []

if not impl:
    falhas.append("atribuicao sem implementador")
if not auditores:
    falhas.append("atribuicao sem auditores")

p_impl = perfil(impl) if impl else None
if p_impl is None and impl:
    falhas.append(f"perfil do implementador '{impl}' ausente")
elif p_impl and "implementador" not in p_impl.get("papeis_aptos", []) and not hearback:
    falhas.append(f"'{impl}' não tem 'implementador' em papeis_aptos (ADR-015) e não há hearback_ref")

fam_impl = (p_impl or {}).get("fornecedor")
fams_aud = []
for aud in auditores:
    p = perfil(aud)
    if p is None:
        falhas.append(f"perfil do auditor '{aud}' ausente")
        continue
    if not any(r.startswith("auditor") for r in p.get("papeis_aptos", [])) and not hearback:
        falhas.append(f"'{aud}' não tem papel de auditor em papeis_aptos e não há hearback_ref")
    fam = p.get("fornecedor")
    fams_aud.append(fam)
    if fam and fam_impl and fam == fam_impl and not hearback:
        falhas.append(
            f"GROUPTHINK: auditor '{aud}' e implementador '{impl}' são da mesma família "
            f"({fam}) sem hearback_ref de exceção (ADR-018 Decisão 2)"
        )

if len(auditores) > 1 and len(set(fams_aud)) == 1 and fams_aud and fams_aud[0]:
    avisos.append(f"todos os auditores são da família {fams_aud[0]} — diversidade P2 recomendada")

chapeu = a.get("chapeu_atual")
if not chapeu:
    avisos.append("atribuicao sem chapeu_atual — a janela que retoma fica sem chapéu inequívoco")

for w in avisos:
    print(f"  ⚠ AVISO: {w}")
if falhas:
    for f in falhas:
        print(f"  ✗ {f}")
    sys.exit(1)
print(f"  ✓ invariante ok: implementador={impl} ({fam_impl}) × auditores={list(zip(auditores, fams_aud))}")
sys.exit(0)
PYEOF
RC=$?
set -e
if [[ $RC -eq 0 ]]; then
    guard_ok "Atribuição respeita o invariante anti-groupthink."
else
    guard_fail "Atribuição inválida (lista acima)."
fi
exit $RC
