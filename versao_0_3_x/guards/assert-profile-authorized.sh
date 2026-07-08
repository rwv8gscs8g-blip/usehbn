#!/usr/bin/env bash
# =============================================================================
# guards/assert-profile-authorized.sh
# G-PROFILE-MATRIX: todo guard fisico do snapshot deve estar em exatamente um
# estado do perfil consumidor v2. Omissao silenciosa = falha da exuvia.
#
# Contexto:
# - consumidor real: marcador/perfil versionado no indice/HEAD ou no baseline.
#   Env/diretorio solto no filesystem nao ativam o guard sozinhos.
# - genoma/nao-consumidor: sem marcador/perfil versionado. O guard nao tem alvo
#   consumidor, nao opina sobre matriz e sai 0.
# =============================================================================
# ---HBN-REQUIRES-BEGIN---
# requires:
#   files:
#     - path: CONSUMER-PROFILE.md
#       install: refuse
#   dirs: []
#   state_fields: []
#   guards: []
#   env: [HBN_CONSUMER_PROFILE, HBN_PROFILE_SNAPSHOT_GUARDS_DIR]
# ---HBN-REQUIRES-END---
set -euo pipefail

GUARD_NAME="assert-profile-authorized"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

REPO_ROOT="$(guard_repo_root)"
ACTIVE_ROOT="$(get_canonical_root || true)"
if [[ -z "$ACTIVE_ROOT" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel validar perfil consumidor."
    exit 1
fi

MARKER_PATH=".usehbn-snapshot"
ROOT_PROFILE_PATH="CONSUMER-PROFILE.md"
SNAPSHOT_PROFILE_PATH=".usehbn-snapshot/CONSUMER-PROFILE.md"
MARKER_REPO_PATH="$(guard_version_repo_path "$MARKER_PATH" || true)"
ROOT_PROFILE_REPO_PATH="$(guard_version_repo_path "$ROOT_PROFILE_PATH" || true)"
SNAPSHOT_PROFILE_REPO_PATH="$(guard_version_repo_path "$SNAPSHOT_PROFILE_PATH" || true)"
if [[ -z "$MARKER_REPO_PATH" || -z "$ROOT_PROFILE_REPO_PATH" || -z "$SNAPSHOT_PROFILE_REPO_PATH" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel localizar marcador/perfil consumidor."
    exit 1
fi

MARKER_STATE="$(hbn_context_dep_state "$MARKER_REPO_PATH")"
ROOT_PROFILE_STATE="$(hbn_context_dep_state "$ROOT_PROFILE_REPO_PATH")"
SNAPSHOT_PROFILE_STATE="$(hbn_context_dep_state "$SNAPSHOT_PROFILE_REPO_PATH")"

if [[ "$MARKER_STATE" == "DISARM" ]]; then
    guard_fail "${MARKER_PATH}/ existia no HEAD/base e foi removido neste commit/range. G-PROFILE nao vira no-op por desarme; restaure o marcador consumidor ou trate a remocao fora deste commit."
    exit 1
fi
if [[ "$ROOT_PROFILE_STATE" == "DISARM" ]]; then
    guard_fail "${ROOT_PROFILE_PATH} existia no HEAD/base e foi removido neste commit/range. G-PROFILE nao vira no-op por desarme; restaure o perfil consumidor ou trate a remocao fora deste commit."
    exit 1
fi
if [[ "$SNAPSHOT_PROFILE_STATE" == "DISARM" ]]; then
    guard_fail "${SNAPSHOT_PROFILE_PATH} existia no HEAD/base e foi removido neste commit/range. G-PROFILE nao vira no-op por desarme; restaure o perfil consumidor ou trate a remocao fora deste commit."
    exit 1
fi

CONSUMER_VERSIONED=false
if [[ "$MARKER_STATE" == "ATIVO" || "$ROOT_PROFILE_STATE" == "ATIVO" || "$SNAPSHOT_PROFILE_STATE" == "ATIVO" ]]; then
    CONSUMER_VERSIONED=true
fi

if [[ "$CONSUMER_VERSIONED" != "true" ]]; then
    guard_ok "Sem marcador/perfil consumidor versionado no indice/HEAD/base: contexto genoma/nao-consumidor; guard sem alvo, matriz nao opinada. Use scripts/hbn-install-guard ao instalar um consumidor."
    exit 0
fi

PROFILE_TMP=""
cleanup_profile_tmp() {
    [[ -n "$PROFILE_TMP" ]] && rm -f "$PROFILE_TMP"
}
trap cleanup_profile_tmp EXIT

profile_from_current_ref() { # <repo-path>
    local repo_path="$1"
    PROFILE_TMP="$(mktemp)"
    git show "$(hbn_context_current_ref "$repo_path")" > "$PROFILE_TMP" 2>/dev/null
}

PROFILE_PATH=""
if [[ "$ROOT_PROFILE_STATE" == "ATIVO" ]]; then
    if ! profile_from_current_ref "$ROOT_PROFILE_REPO_PATH"; then
        guard_fail "Perfil consumidor ilegivel no indice/HEAD: ${ROOT_PROFILE_PATH}."
        exit 1
    fi
    PROFILE_PATH="$PROFILE_TMP"
elif [[ "$SNAPSHOT_PROFILE_STATE" == "ATIVO" ]]; then
    if ! profile_from_current_ref "$SNAPSHOT_PROFILE_REPO_PATH"; then
        guard_fail "Perfil consumidor ilegivel no indice/HEAD: ${SNAPSHOT_PROFILE_PATH}."
        exit 1
    fi
    PROFILE_PATH="$PROFILE_TMP"
elif [[ -n "${HBN_CONSUMER_PROFILE:-}" ]]; then
    PROFILE_PATH="${HBN_CONSUMER_PROFILE}"
else
    PROFILE_PATH="${ACTIVE_ROOT}/${ROOT_PROFILE_PATH}"
fi

if [[ ! -f "$PROFILE_PATH" ]]; then
    guard_fail "Perfil consumidor ausente: ${PROFILE_PATH}. Instale/declare CONSUMER-PROFILE.md v2 antes de ativar a matriz total."
    exit 1
fi

SNAPSHOT_GUARDS_DIR="${HBN_PROFILE_SNAPSHOT_GUARDS_DIR:-}"
if [[ -z "$SNAPSHOT_GUARDS_DIR" ]]; then
    if [[ "$MARKER_STATE" == "ATIVO" && -d "${ACTIVE_ROOT}/.usehbn-snapshot/guards" ]]; then
        SNAPSHOT_GUARDS_DIR="${ACTIVE_ROOT}/.usehbn-snapshot/guards"
    else
        SNAPSHOT_GUARDS_DIR="${ACTIVE_ROOT}/guards"
    fi
fi
if [[ ! -d "$SNAPSHOT_GUARDS_DIR" ]]; then
    guard_fail "Diretorio de guards fisicos ausente: ${SNAPSHOT_GUARDS_DIR}."
    exit 1
fi

python3 - "$SNAPSHOT_GUARDS_DIR" "$PROFILE_PATH" "$REPO_ROOT" "$ACTIVE_ROOT" <<'PY'
import json
import os
import re
import sys
from collections import defaultdict

guards_dir, profile_path, repo_root, active_root = sys.argv[1:5]
states = [
    "guards_projeto",
    "guards_orquestracao",
    "guards_condicionais",
    "guards_commit_msg",
    "guards_a_instalar",
    "exclusoes_autorizadas",
]
guard_re = re.compile(r"^(assert|forbid)-[a-z0-9-]+\.sh$|^freeze-gate\.sh$|^validate-dispatch\.sh$")
key_re = re.compile(r"^([A-Za-z_][A-Za-z0-9_-]*)\s*:\s*(.*)$")

def clean(value):
    value = value.split("#", 1)[0].strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
        return value[1:-1]
    return value

def inline_list(value):
    value = clean(value)
    if not (value.startswith("[") and value.endswith("]")):
        return None
    inside = value[1:-1].strip()
    if not inside:
        return []
    return [clean(item) for item in inside.split(",") if clean(item)]

def parse_profile(path):
    text = open(path, encoding="utf-8").read().splitlines()
    data = {state: [] for state in states}
    idx = 0
    while idx < len(text):
        raw = text[idx]
        idx += 1
        if not raw.strip() or raw.lstrip().startswith("#") or raw.startswith("```"):
            continue
        if raw[0].isspace():
            continue
        match = key_re.match(raw)
        if not match:
            continue
        key, value = match.group(1), match.group(2)
        if key not in states:
            continue
        inline = inline_list(value)
        if inline is not None:
            data[key].extend({"guard": item} for item in inline)
            continue
        if clean(value):
            data[key].extend({"guard": item} for item in clean(value).split() if item)
            continue
        while idx < len(text):
            item = text[idx]
            if not item.strip() or item.lstrip().startswith("#"):
                idx += 1
                continue
            if not item.startswith("  "):
                break
            stripped = item.strip()
            if stripped.startswith("- "):
                body = stripped[2:]
                idx += 1
                entry = {}
                if ":" in body:
                    k, v = body.split(":", 1)
                    entry[k.strip()] = clean(v)
                else:
                    entry["guard"] = clean(body)
                while idx < len(text):
                    child = text[idx]
                    if not child.strip() or child.lstrip().startswith("#"):
                        idx += 1
                        continue
                    if not child.startswith("    "):
                        break
                    c = child.strip()
                    if ":" not in c:
                        raise SystemExit(f"{profile_path}: linha invalida em {key}: {child}")
                    ck, cv = c.split(":", 1)
                    entry[ck.strip()] = clean(cv)
                    idx += 1
                data[key].append(entry)
                continue
            # compat: "  - guard" already handled; "  guard" whitespace list
            data[key].append({"guard": clean(stripped)})
            idx += 1
    return data

physical = sorted(
    name[:-3] if name.endswith(".sh") else name
    for name in os.listdir(guards_dir)
    if guard_re.match(name)
)
profile = parse_profile(profile_path)
seen = defaultdict(list)
errors = []

def inside(path, root):
    try:
        return os.path.commonpath([os.path.realpath(path), os.path.realpath(root)]) == os.path.realpath(root)
    except ValueError:
        return False

def check_hearback(ref):
    if not ref:
        return "hearback_ref vazio"
    path = ref if os.path.isabs(ref) else os.path.join(active_root, ref)
    if not inside(path, active_root):
        return f"hearback_ref fora da raiz ativa: {ref}"
    if not os.path.isfile(path):
        return f"hearback_ref inexistente: {ref}"
    try:
        data = json.load(open(path, encoding="utf-8"))
    except Exception as exc:
        return f"hearback_ref ilegivel como JSON: {ref}: {exc}"
    if data.get("status") != "confirmed":
        return f"hearback_ref sem status confirmed: {ref}"
    return None

for state, entries in profile.items():
    for entry in entries:
        guard = entry.get("guard", "").strip()
        if not guard:
            errors.append(f"{state}: entrada sem guard")
            continue
        seen[guard].append(state)
        if state == "guards_condicionais" and not (entry.get("gatilho") or entry.get("trigger")):
            errors.append(f"{state}: {guard} sem gatilho declarado")
        if state == "guards_a_instalar" and not (entry.get("fase") and (entry.get("dependencia") or entry.get("dependencias"))):
            errors.append(f"{state}: {guard} sem fase/dependencia")
        if state == "exclusoes_autorizadas":
            for field in ("motivo", "autorizado_por_humano", "hearback_ref", "validade"):
                if not entry.get(field):
                    errors.append(f"{state}: {guard} sem {field}")
            hb_error = check_hearback(entry.get("hearback_ref", ""))
            if hb_error:
                errors.append(f"{state}: {guard}: {hb_error}")

for guard in physical:
    states_for_guard = seen.get(guard, [])
    if len(states_for_guard) == 0:
        errors.append(f"guard fisico fora da matriz: {guard}")
    elif len(states_for_guard) > 1:
        errors.append(f"guard em mais de um estado: {guard} -> {states_for_guard}")

for guard in sorted(seen):
    if guard not in physical:
        errors.append(f"perfil referencia guard inexistente no snapshot: {guard}")

if errors:
    for error in errors:
        print(f"G-PROFILE-MATRIX: {error}", file=sys.stderr)
    raise SystemExit(1)

print(f"G-PROFILE-MATRIX: {len(physical)} guards fisicos cobertos exatamente uma vez.")
PY
RC=$?
if [[ "$RC" -eq 0 ]]; then
    guard_ok "Perfil consumidor cobre todos os guards fisicos exatamente uma vez."
else
    guard_fail "Perfil consumidor v2 invalido: matriz total incompleta, duplicada ou com exclusao sem hearback confirmado."
fi
exit "$RC"
