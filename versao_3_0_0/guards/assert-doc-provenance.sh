#!/usr/bin/env bash
# =============================================================================
# guards/assert-doc-provenance.sh
# G-PROV: todo documento governado carrega proveniencia do livro-razao.
# Estrutural: nao honra HBN_GUARDS_BYPASS/GLASSWING_BYPASS.
# Valida o indice local inteiro da versao ativa; em CI valida HEAD.
# =============================================================================
# ---HBN-REQUIRES-BEGIN---
# requires:
#   files:
#     - path: MANIFESTO-MIGRACAO.md
#       install: copy
#       source: MANIFESTO-MIGRACAO.md
#   dirs: []
#   state_fields: []
#   guards: []
#   env: []
# ---HBN-REQUIRES-END---
set -euo pipefail

GUARD_NAME="assert-doc-provenance"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

REPO_ROOT="$(guard_repo_root || true)"
ACTIVE_REL="$(guard_active_version_rel || true)"
if [[ -z "$REPO_ROOT" || -z "$ACTIVE_REL" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel validar proveniencia."
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    guard_fail "python3 ausente — G-PROV precisa parsear front-matter/JSON de forma deterministica."
    exit 2
fi

MODE="index"
if hbn_ci_range_mode && ! hbn_index_has_staged_changes; then
    MODE="head"
fi

python3 - "$REPO_ROOT" "$ACTIVE_REL" "$MODE" <<'PY'
import json
import re
import subprocess
import sys

repo, active_rel, mode = sys.argv[1:4]
prefix = "" if active_rel == "." else active_rel + "/"

REQUIRED = [
    "titulo",
    "tipo",
    "status",
    "temperatura",
    "path",
    "created_at",
    "autor",
    "familia",
    "natureza",
]
MIGRATED = [
    "migrado_de",
    "id_original",
    "created_at_original",
    "autor_original",
    "transcrito_em",
    "transcrito_por",
    "validacao_ref",
]
ISO_TZ = re.compile(r"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}-03:00$")

def git(*args):
    return subprocess.run(
        ["git", "-C", repo, *args],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )

def list_repo_paths():
    if mode == "head":
        args = ["ls-tree", "-r", "--name-only", "HEAD"]
        if prefix:
            args.extend(["--", prefix])
        out = git(*args)
    else:
        args = ["ls-files", "--cached"]
        if prefix:
            args.extend(["--", prefix])
        out = git(*args)
    if out.returncode != 0:
        raise SystemExit(out.stderr.strip() or "falha ao listar arquivos")
    return [line.strip() for line in out.stdout.splitlines() if line.strip()]

def version_rel(repo_path):
    if prefix:
        if not repo_path.startswith(prefix):
            return None
        return repo_path[len(prefix):]
    return repo_path

def read_blob(repo_path):
    ref = f"HEAD:{repo_path}" if mode == "head" else f":{repo_path}"
    out = git("show", ref)
    if out.returncode != 0:
        return None
    return out.stdout

def is_exception(rel):
    if rel == "LICENSE":
        return True
    if rel == ".hbn/stray-allowlist":
        return True
    if rel == "guards/MANIFEST.yaml":
        return True
    if rel == "membrane/MEMBRANE_MANIFEST.template.json":
        return True
    if rel.startswith("schemas/") and rel.endswith(".json"):
        return True
    if rel.startswith("guards/tests/fixtures/"):
        return True
    if rel.startswith("guards/fixtures/"):
        return True
    if rel.startswith(".hbn/models/") and rel.endswith(".json"):
        return True
    return False

def is_candidate(rel):
    if is_exception(rel):
        return False
    if rel.endswith(".md") or rel.endswith(".json"):
        return True
    if rel in {"core/read-list-canonica.txt", "core/actor-write-matrix.txt"}:
        return True
    return False

def scalar(value):
    value = str(value or "").strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
        value = value[1:-1]
    return value.strip()

def parse_md(text):
    if not text.startswith("---\n"):
        return None, "sem front-matter YAML"
    end = text.find("\n---\n", 4)
    if end == -1:
        return None, "front-matter YAML sem fechamento"
    fm = {}
    for raw in text[4:end].splitlines():
        if not raw.strip() or raw.startswith((" ", "\t", "-")):
            continue
        if ":" not in raw:
            continue
        key, value = raw.split(":", 1)
        fm[key.strip()] = scalar(value)
    return fm, ""

def parse_txt(text):
    if not text.startswith("# ---HBN-FRONT-MATTER-BEGIN---\n"):
        return None, "txt governado sem cabecalho comentado HBN"
    end = text.find("# ---HBN-FRONT-MATTER-END---")
    if end == -1:
        return None, "cabecalho comentado HBN sem fechamento"
    fm = {}
    for raw in text[:end].splitlines():
        if not raw.startswith("# ") or ":" not in raw:
            continue
        key, value = raw[2:].split(":", 1)
        fm[key.strip()] = scalar(value)
    return fm, ""

def parse_json_doc(text):
    try:
        data = json.loads(text)
    except Exception as exc:
        return None, f"JSON invalido: {exc}"
    if not isinstance(data, dict):
        return None, "JSON governado deve ser objeto top-level"
    return {str(k): scalar(v) if not isinstance(v, (dict, list)) else v for k, v in data.items()}, ""

def validate(rel, meta):
    errors = []
    for key in REQUIRED:
        if not scalar(meta.get(key)):
            errors.append(f"campo obrigatorio ausente/vazio: {key}")
    if scalar(meta.get("path")) != rel:
        errors.append(f"path declarado '{scalar(meta.get('path'))}' != caminho '{rel}'")
    nature = scalar(meta.get("natureza"))
    if nature not in {"nativo", "migrado"}:
        errors.append("natureza deve ser nativo|migrado")
    created = scalar(meta.get("created_at"))
    if created and not ISO_TZ.match(created):
        errors.append(f"created_at fora de ISO -03:00: {created}")
    if nature == "migrado":
        for key in MIGRATED:
            if not scalar(meta.get(key)):
                errors.append(f"proveniencia migrada ausente/vazia: {key}")
        transcribed = scalar(meta.get("transcrito_em"))
        original = scalar(meta.get("created_at_original"))
        if transcribed and transcribed != created:
            errors.append("transcrito_em deve ser igual a created_at")
        if transcribed and not ISO_TZ.match(transcribed):
            errors.append(f"transcrito_em fora de ISO -03:00: {transcribed}")
        if original and not ISO_TZ.match(original):
            errors.append(f"created_at_original fora de ISO -03:00: {original}")
    return errors

failures = []
checked = 0
for repo_path in list_repo_paths():
    rel = version_rel(repo_path)
    if not rel or not is_candidate(rel):
        continue
    text = read_blob(repo_path)
    if text is None:
        continue
    if rel.endswith(".md"):
        meta, err = parse_md(text)
    elif rel.endswith(".json"):
        meta, err = parse_json_doc(text)
    else:
        meta, err = parse_txt(text)
    if err:
        failures.append((rel, [err]))
        continue
    checked += 1
    errors = validate(rel, meta)
    if errors:
        failures.append((rel, errors))

if failures:
    for rel, errors in failures:
        print(f"G-PROV: {rel}", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
    raise SystemExit(1)

print(f"G-PROV OK: {checked} documento(s) governado(s) com proveniencia valida.")
PY

rc=$?
if [[ "$rc" -ne 0 ]]; then
    guard_fail "Documento governado sem proveniencia canonica completa."
    exit "$rc"
fi

guard_ok "Proveniencia canonica validada."
exit 0
