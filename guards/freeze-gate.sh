#!/usr/bin/env bash
# =============================================================================
# guards/freeze-gate.sh
# Gate G-FRZ: lê um freeze-checklist (schemas/freeze-checklist.schema.json) e
# responde "congelável: sim" (exit 0) ou "congelável: não" + o que falta (exit 1).
#
# status: accepted (correntes D/E, 2026-06-10) — NÃO está no runner de pre-commit
#   (não é guard de commit: é gate de release, invocado sob demanda):
#     bash guards/freeze-gate.sh <caminho/do/checklist.json>
# Regras (ADR-017 + spec §2): obrigatorio=true precisa ok; ok exige evidencia;
#   na exige justificativa; bloqueadores_abertos > 0 = veto.
# ADR-020 (anti-teatro, corrente E; bug F-01 das auditorias 0021/0022):
#   critério OBRIGATÓRIO pode ser na SOMENTE se a justificativa cita hearback
#   VERIFICÁVEL — path .json que existe no repo e tem status=confirmed
#   (alinha guard×spec×schema no contrato da spec §2.4).
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

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

set +e
python3 - "$REPO_ROOT" <<'PYEOF'
import json
import subprocess
import sys

repo_root = sys.argv[1]

try:
    raw = subprocess.check_output(
        ["git", "-C", repo_root, "ls-files", "-z", "--", ".hbn/readbacks/*.json"],
        stderr=subprocess.DEVNULL,
    )
except Exception as exc:
    print(f"congelável: não — meta-deref-propostas falhou fechado: {exc}")
    sys.exit(2)

pendentes = []
ilegiveis = []
for path in [p for p in raw.decode("utf-8").split("\0") if p]:
    try:
        content = subprocess.check_output(
            ["git", "-C", repo_root, "cat-file", "-p", f":{path}"],
            stderr=subprocess.DEVNULL,
        )
        data = json.loads(content.decode("utf-8"))
    except Exception as exc:
        ilegiveis.append(f"{path} ({exc})")
        continue
    if not isinstance(data, dict):
        ilegiveis.append(f"{path} (JSON não é objeto)")
        continue

    activation_status = data.get("activation_status")
    status = data.get("status")
    if activation_status == "PROPOSED_UNTIL_CROSS_AUDIT" or status == "implemented_pending_cross_audit":
        pendentes.append(
            f"{path} (activation_status={activation_status!r}, status={status!r})"
        )

if ilegiveis:
    print("congelável: não — meta-deref-propostas encontrou readback tracked ilegível")
    for item in ilegiveis:
        print(f"  ✗ {item}")
    sys.exit(1)

if pendentes:
    print("congelável: não — meta-deref-propostas: proposta(s) pendente(s) sem cross-audit/hearback")
    for item in pendentes:
        print(f"  ✗ {item}")
    sys.exit(1)

sys.exit(0)
PYEOF
RC_META_PROPOSTAS=$?
set -e
if [[ $RC_META_PROPOSTAS -ne 0 ]]; then
    guard_fail "Gate de freeze: NÃO congelável (meta-deref-propostas)."
    exit $RC_META_PROPOSTAS
fi

set +e
ORQ_ENTRADA_OUTPUT="$(cd "$REPO_ROOT" && bash "${SCRIPT_DIR}/assert-orq-entrada.sh" 2>&1)"
RC_ORQ_ENTRADA=$?
set -e
if [[ $RC_ORQ_ENTRADA -ne 0 ]]; then
    printf '%s\n' "$ORQ_ENTRADA_OUTPUT"
    echo "congelável: não — meta-deref-atestacao: atestação de entrada do orquestrador não dereferencia limpo"
    guard_fail "Gate de freeze: NÃO congelável (meta-deref-atestacao; guards/assert-orq-entrada.sh rc=${RC_ORQ_ENTRADA})."
    exit $RC_ORQ_ENTRADA
fi

set +e
python3 - "$CHECKLIST" "$REPO_ROOT" <<'PYEOF'
import json, os, re, sys

path, repo_root = sys.argv[1], sys.argv[2]
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

def hearback_verificavel(texto):
    """Procura na justificativa um path .json que EXISTE e tem status=confirmed.
    Anti-teatro (ADR-020): citar hearback é dereferenciável, não decorativo."""
    for cand in re.findall(r"[A-Za-z0-9_./-]+\.json", texto or ""):
        p = cand if os.path.isabs(cand) else os.path.join(repo_root, cand)
        if os.path.isfile(p):
            try:
                h = json.load(open(p))
            except Exception:
                continue
            if h.get("status") == "confirmed":
                return cand
    return None

for cr in criterios:
    cid = cr.get("id", "<sem-id>")
    st = cr.get("status")
    if st == "ok" and not cr.get("evidencia"):
        faltas.append(f"critério '{cid}': ok SEM evidência (Truth Barrier)")
    elif st == "na":
        just = cr.get("justificativa")
        if not just:
            faltas.append(f"critério '{cid}': na SEM justificativa")
        elif cr.get("obrigatorio"):
            hb = hearback_verificavel(just)
            if hb:
                print(f"  • critério obrigatório '{cid}' = na coberto por hearback confirmado: {hb}")
            else:
                faltas.append(
                    f"critério obrigatório '{cid}' = na sem hearback VERIFICÁVEL na "
                    f"justificativa (path .json existente com status=confirmed — spec §2.4, ADR-020)"
                )
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
