#!/usr/bin/env bash
# =============================================================================
# guards/assert-role-family.sh
# Guarda G-FAM: invariante anti-groupthink (ADR-018 Decisão 2).
#   família(auditor de X) ≠ família(implementador de X)
# família = campo `fornecedor` do perfil .hbn/models/<apelido>.json (ADR-015).
#
# status: accepted (correntes D/E, 2026-06-10) — NÃO está no runner.
#   Invocação sob demanda (atribuição de onda / handoff):
#     bash guards/assert-role-family.sh <atribuicao.json>
#   onde o JSON tem a forma do campo `atribuicao` do STATE
#   (core/roles-assignment-spec.md §2).
# BLOQUEADOR: auditor da família do implementador sem exceção COBERTA;
#             papel fora de papeis_aptos sem exceção COBERTA;
#             hearback_ref presente mas inexistente/ilegível/não-confirmed.
# AVISO:      auditores todos da mesma família entre si.
# ADR-020 (anti-teatro, corrente E): hearback_ref é DEREFERENCIADO — o
#   arquivo precisa existir, ter status=confirmed e declarar a exceção exata
#   em excecoes_cobertas ({tipo:familia,entre:[a,b]} | {tipo:papel,modelo,papel}).
#   String não-vazia NÃO é mais bypass (bug F-03 das auditorias 0021/0022).
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
python3 - "$ATRIB" "$MODELS_DIR" "$REPO_ROOT" <<'PYEOF'
import json, os, sys

atrib_path, models_dir, repo_root = sys.argv[1], sys.argv[2], sys.argv[3]
a = json.load(open(atrib_path))

def perfil(apelido):
    p = os.path.join(models_dir, f"{apelido}.json")
    if not os.path.isfile(p):
        print(f"  ✗ BLOQUEADOR: perfil inexistente para '{apelido}' ({p})")
        return None
    return json.load(open(p))

impl = a.get("implementador")
auditores = a.get("auditores") or []
falhas, avisos = [], []

# --- ADR-020: dereferência do hearback_ref (anti-teatro) --------------------
hearback_ref = a.get("hearback_ref")
hearback = None  # dict carregado SOMENTE se existe + legível + confirmed
if hearback_ref:
    hp = hearback_ref if os.path.isabs(hearback_ref) else os.path.join(repo_root, hearback_ref)
    if not os.path.isfile(hp):
        falhas.append(f"hearback_ref '{hearback_ref}' NÃO existe no disco (anti-teatro, ADR-020)")
    else:
        try:
            h = json.load(open(hp))
        except Exception as e:
            falhas.append(f"hearback_ref '{hearback_ref}' ilegível como JSON: {e} (ADR-020)")
        else:
            if h.get("status") != "confirmed":
                falhas.append(f"hearback_ref '{hearback_ref}' com status '{h.get('status')}' ≠ confirmed (ADR-020)")
            else:
                hearback = h

def _excecoes(tipo):
    return [e for e in (hearback or {}).get("excecoes_cobertas", [])
            if isinstance(e, dict) and e.get("tipo") == tipo]

def cobre_familia(m1, m2):
    """Exceção de família coberta = entrada exata {tipo:familia, entre:{m1,m2}}."""
    return any(set(e.get("entre", [])) == {m1, m2} for e in _excecoes("familia"))

def cobre_papel(modelo, papel):
    """Exceção de papel coberta = entrada exata {tipo:papel, modelo, papel}."""
    return any(e.get("modelo") == modelo and e.get("papel") == papel
               for e in _excecoes("papel"))
# ---------------------------------------------------------------------------

if not impl:
    falhas.append("atribuicao sem implementador")
if not auditores:
    falhas.append("atribuicao sem auditores")

p_impl = perfil(impl) if impl else None
if p_impl is None and impl:
    falhas.append(f"perfil do implementador '{impl}' ausente")
elif p_impl and "implementador" not in p_impl.get("papeis_aptos", []) and not cobre_papel(impl, "implementador"):
    falhas.append(f"'{impl}' não tem 'implementador' em papeis_aptos (ADR-015) e nenhum hearback confirmado cobre a exceção (excecoes_cobertas tipo=papel — ADR-020)")

fam_impl = (p_impl or {}).get("fornecedor")
fams_aud = []
for aud in auditores:
    p = perfil(aud)
    if p is None:
        falhas.append(f"perfil do auditor '{aud}' ausente")
        continue
    if not any(r.startswith("auditor") for r in p.get("papeis_aptos", [])) and not cobre_papel(aud, "auditor"):
        falhas.append(f"'{aud}' não tem papel de auditor em papeis_aptos e nenhum hearback confirmado cobre a exceção (ADR-020)")
    fam = p.get("fornecedor")
    fams_aud.append(fam)
    if fam and fam_impl and fam == fam_impl and not cobre_familia(aud, impl):
        falhas.append(
            f"GROUPTHINK: auditor '{aud}' e implementador '{impl}' são da mesma família "
            f"({fam}) e nenhum hearback confirmado declara a exceção exata em "
            f"excecoes_cobertas (ADR-018 Decisão 2 + ADR-020)"
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
