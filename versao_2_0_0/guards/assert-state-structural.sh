#!/usr/bin/env bash
# =============================================================================
# guards/assert-state-structural.sh
# G-STATE-STRUCTURAL: Mudanca estrutural em STATE.md exige quorum de auditoria
# cruzada previa (>=2 familias distintas != OpenAI/implementador).
#
# Escopo: commits em que .hbn/relay/STATE.md seja adicionado/modificado.
# Local: valida o blob staged (:path). CI: valida HEAD:path no range
# HBN_DIFF_BASE...HEAD. Nunca le a working tree de STATE.md.
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-state-structural"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

STATE_PATH=".hbn/relay/STATE.md"
MAP_PATH="guards/data/auditor-families.txt"

if ! ACTIVE_PREFIX="$(guard_active_version_prefix)"; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel validar ${STATE_PATH}."
    exit 1
fi

state_diff_files() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git diff --name-only --diff-filter=AM "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
    else
        git diff --cached --name-only --diff-filter=AM 2>/dev/null || true
    fi | guard_paths_to_version_paths
}

blob_ref() {
    local p repo_path
    p="$1"
    repo_path="$(guard_version_repo_path "$p")" || return 1
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        printf 'HEAD:%s\n' "$repo_path"
    else
        printf ':%s\n' "$repo_path"
    fi
}

old_ref() {
    local p repo_path
    p="$1"
    repo_path="$(guard_version_repo_path "$p")" || return 1
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        printf '%s:%s\n' "${HBN_DIFF_BASE}" "$repo_path"
    else
        printf 'HEAD:%s\n' "$repo_path"
    fi
}

STATE_TOUCHED=0
while IFS= read -r f; do
    [[ "$f" == "$STATE_PATH" ]] && STATE_TOUCHED=1
done < <(state_diff_files)

if [[ "$STATE_TOUCHED" -ne 1 ]]; then
    guard_ok "STATE nao foi modificado neste diff — G-STATE-STRUCTURAL nao opina."
    exit 0
fi

STATE_REF="$(blob_ref "$STATE_PATH" || true)"
OLD_STATE_REF="$(old_ref "$STATE_PATH" || true)"
MAP_REF="$(blob_ref "$MAP_PATH" || true)"

if [[ -z "$STATE_REF" || -z "$MAP_REF" ]]; then
    guard_fail "Nao foi possivel resolver referencias staged/HEAD para STATE ou mapa de auditores."
    exit 1
fi

if ! git cat-file -e "$STATE_REF" 2>/dev/null; then
    guard_fail "STATE ausente/ilegivel no indice/HEAD: ${STATE_PATH}."
    exit 1
fi
if ! git cat-file -e "$MAP_REF" 2>/dev/null; then
    guard_fail "Mapa de apelidos ausente/ilegivel no indice/HEAD: ${MAP_PATH}."
    exit 1
fi

# Se old state nao existe em git, passa vazio para python
if ! git cat-file -e "$OLD_STATE_REF" 2>/dev/null; then
    OLD_STATE_REF=""
fi

added_readbacks() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git diff --name-only --diff-filter=AM "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
    else
        git diff --cached --name-only --diff-filter=AM 2>/dev/null || true
    fi | guard_paths_to_version_paths | grep -E '^\.hbn/readbacks/[0-9]{4}-[^/]+\.json$' || true
}

list_results() {
    local results_repo_dir
    results_repo_dir="$(guard_version_repo_path ".hbn/results" || true)"
    [[ -n "$results_repo_dir" ]] || return 0
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git ls-tree -r --name-only HEAD -- "$results_repo_dir" 2>/dev/null || true
    else
        git ls-files -- "$results_repo_dir" 2>/dev/null || true
    fi | guard_paths_to_version_paths | grep -E '^\.hbn/results/[^/]+\.md$' || true
}

if ! command -v python3 >/dev/null 2>&1; then
    guard_fail "python3 ausente — nao consigo validar mudancas estruturais em ${STATE_PATH}."
    exit 2
fi

READBACKS_FILE="$(mktemp)"
RESULTS_FILE="$(mktemp)"
REFS_FILE="$(mktemp)"
trap 'rm -f "${READBACKS_FILE:-}" "${RESULTS_FILE:-}" "${REFS_FILE:-}"' EXIT

added_readbacks > "$READBACKS_FILE"

while IFS= read -r result_path; do
    [[ -z "$result_path" ]] && continue
    result_ref="$(blob_ref "$result_path" || true)"
    if [[ -z "$result_ref" ]] || ! git cat-file -e "$result_ref" 2>/dev/null; then
        continue
    fi
    printf '%s\n' "$result_path" >> "$RESULTS_FILE"
    printf '%s\t%s\n' "$result_path" "$result_ref" >> "$REFS_FILE"
done < <(list_results)

if ! python3 - "$STATE_REF" "$OLD_STATE_REF" "$READBACKS_FILE" "$MAP_REF" "$RESULTS_FILE" "$REFS_FILE" "${HBN_DIFF_BASE:-}" <<'PY'
import json
import os
import re
import subprocess
import sys

state_ref, old_state_ref, readbacks_file, map_ref, results_file, refs_file, diff_base = sys.argv[1:8]
use_head = bool(diff_base)
errors = []

def fail(message):
    errors.append(message)

def git_text(*args):
    return subprocess.check_output(["git", *args], stderr=subprocess.DEVNULL).decode("utf-8")

def parse_state_yaml(text):
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return {}
    end = None
    for idx in range(1, len(lines)):
        if lines[idx].strip() == "---":
            end = idx
            break
    if end is None:
        return {}

    fm_lines = lines[1:end]
    fields = {}
    in_proximo_ponto = False
    proximo_ponto_lines = []

    for line in fm_lines:
        if not line.strip() or line.lstrip().startswith("#"):
            continue

        if line.startswith(" ") or line.startswith("\t"):
            if in_proximo_ponto:
                proximo_ponto_lines.append(line.strip())
            continue
        else:
            in_proximo_ponto = False

        match = re.match(r"^([A-Za-z_][A-Za-z0-9_-]*)\s*:\s*(.*)$", line)
        if not match:
            continue
        key = match.group(1)
        value = match.group(2).strip()

        value = re.sub(r"\s+#.*$", "", value).strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
            value = value[1:-1]

        if key == "proximo_ponto":
            in_proximo_ponto = True
            proximo_ponto_lines = []
            fields[key] = proximo_ponto_lines
        else:
            fields[key] = value

    if "proximo_ponto" in fields:
        pp_dict = {}
        for line in fields["proximo_ponto"]:
            m = re.match(r"^([A-Za-z_][A-Za-z0-9_-]*)\s*:\s*(.*)$", line)
            if m:
                k = m.group(1)
                v = m.group(2).strip()
                v = re.sub(r"\s+#.*$", "", v).strip()
                if len(v) >= 2 and v[0] == v[-1] and v[0] in {"'", '"'}:
                    v = v[1:-1]
                pp_dict[k] = v
        fields["proximo_ponto"] = pp_dict

    return fields

try:
    new_state_text = git_text("show", state_ref)
    new_state = parse_state_yaml(new_state_text)
except Exception as exc:
    print(f"G-STATE-STRUCTURAL: {state_ref} ilegivel ({exc})", file=sys.stderr)
    sys.exit(1)

old_state = {}
if old_state_ref:
    try:
        old_state_text = git_text("show", old_state_ref)
        old_state = parse_state_yaml(old_state_text)
    except Exception:
        old_state = {}

STRUCTURAL_KEYS = [
    "proxima_acao",
    "proximo_ponto",
    "onda_atual",
    "readback_ativo",
    "bastao_token_sha256",
    "proprietario_bastao",
    "papel_bastao"
]

changed = []
for key in STRUCTURAL_KEYS:
    val_new = new_state.get(key)
    val_old = old_state.get(key)
    if val_new != val_old:
        changed.append(key)

if not changed:
    sys.exit(0)

readbacks = []
if os.path.exists(readbacks_file):
    with open(readbacks_file, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                readbacks.append(line)

if not readbacks:
    print(f"G-STATE-STRUCTURAL: Mudanca estrutural em STATE ({', '.join(changed)}) exige um readback correspondente no diff.", file=sys.stderr)
    sys.exit(1)

def parse_map(text):
    alias_to_family = {}
    families = set()
    for line_no, raw in enumerate(text.splitlines(), 1):
        line = raw.split("#", 1)[0].strip()
        if not line:
            continue
        parts = line.split()
        if len(parts) != 2:
            continue
        alias, family = parts
        alias_to_family[alias] = family
        families.add(family)
    return alias_to_family, families

try:
    alias_to_family, known_families = parse_map(git_text("show", map_ref))
except Exception as exc:
    print(f"G-STATE-STRUCTURAL: erro ao carregar mapa de familias {map_ref} ({exc})", file=sys.stderr)
    sys.exit(1)

results_refs = {}
if os.path.exists(refs_file):
    with open(refs_file, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                parts = line.split("\t", 1)
                if len(parts) == 2:
                    results_refs[parts[0]] = parts[1]

results_list = []
if os.path.exists(results_file):
    with open(results_file, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                results_list.append(line)

def parse_frontmatter(text, path):
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return {}, text
    end = None
    for idx in range(1, len(lines)):
        if lines[idx].strip() == "---":
            end = idx
            break
    if end is None:
        return {}, text
    fields = {}
    for raw in lines[1:end]:
        if not raw.strip() or raw.lstrip().startswith("#"):
            continue
        if raw[0].isspace():
            continue
        match = re.match(r"^([A-Za-z_][A-Za-z0-9_-]*)\s*:\s*(.*)$", raw)
        if not match:
            continue
        key, value = match.group(1), match.group(2).strip()
        value = re.sub(r"\s+#.*$", "", value).strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
            value = value[1:-1]
        fields[key] = value
    return fields, "\n".join(lines[end + 1 :])

for rb_path in readbacks:
    rb_ref = f"HEAD:{rb_path}" if use_head else f":{rb_path}"
    try:
        rb_data = json.loads(git_text("show", rb_ref))
    except Exception as exc:
        fail(f"{rb_path}: JSON ilegivel ({exc})")
        continue

    if not isinstance(rb_data, dict):
        fail(f"{rb_path}: readback deve ser objeto JSON")
        continue

    rb_num = os.path.basename(rb_path).split("-", 1)[0]
    if not re.fullmatch(r"[0-9]{4}", rb_num):
        fail(f"{rb_path}: nome do readback nao contem numero de proposta valido")
        continue

    impl_id = rb_data.get("implementador_id", "")
    impl_family = alias_to_family.get(impl_id, "")

    matching_results = []
    suffix = f"-{rb_num}.md"
    for r_path in results_list:
        base = os.path.basename(r_path)
        if base.endswith(suffix) or re.search(rf"-{rb_num}-v[0-9]+\.md$", base):
            matching_results.append(r_path)

    families_with_sim = set()
    approval_re = re.compile(rf"^APROVA_{re.escape(rb_num)}:\s*SIM$", re.MULTILINE | re.IGNORECASE)

    for r_path in matching_results:
        r_ref = results_refs.get(r_path)
        if not r_ref:
            continue
        try:
            r_text = git_text("show", r_ref)
        except Exception as exc:
            fail(f"{r_path}: blob ilegivel ({exc})")
            continue

        fields, body = parse_frontmatter(r_text, r_path)
        autor = fields.get("autor", "")
        familia = fields.get("familia", "")

        if not autor or not familia:
            sou_match = re.search(r"^SOU:\s*([A-Za-z0-9._-]+)\s*·\s*familia\s+([A-Za-z0-9._-]+)\s*·\s*papel\s+auditor\s*$", r_text, re.MULTILINE)
            if sou_match:
                autor = sou_match.group(1)
                familia = sou_match.group(2)

        if not autor or not familia:
            continue

        expected_family = alias_to_family.get(autor)
        if expected_family != familia:
            continue

        if not approval_re.search(body):
            continue

        if familia != "OpenAI" and (not impl_family or familia != impl_family):
            families_with_sim.add(familia)

    if len(families_with_sim) < 2:
        found = ",".join(sorted(families_with_sim)) or "nenhuma"
        fail(
            f"repoint de STATE para {rb_num} com {len(families_with_sim)} familia(s) distinta(s) != OpenAI/implementador com APROVA_{rb_num}: SIM; exige >=2; encontradas={found}"
        )

if errors:
    for err in errors:
        print(f"G-STATE-STRUCTURAL: {err}", file=sys.stderr)
    sys.exit(1)
PY
then
    guard_fail "${STATE_PATH} modificacao estrutural inauditada ou sem quorum."
    exit 1
fi

guard_ok "Modificacao estrutural em STATE verificada com sucesso."
exit 0
