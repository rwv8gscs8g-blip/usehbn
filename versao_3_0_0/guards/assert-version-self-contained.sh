#!/usr/bin/env bash
# =============================================================================
# guards/assert-version-self-contained.sh
# G-SELF-CONTAINED: a versao vigente roda sozinha.
# Estrutural: nao honra HBN_GUARDS_BYPASS/GLASSWING_BYPASS.
# =============================================================================
# ---HBN-REQUIRES-BEGIN---
# requires:
#   files: []
#   dirs: []
#   state_fields: []
#   guards: []
#   env: []
# ---HBN-REQUIRES-END---
set -euo pipefail

GUARD_NAME="assert-version-self-contained"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

REPO_ROOT="$(guard_repo_root || true)"
ACTIVE_REL="$(guard_active_version_rel || true)"
if [[ -z "$REPO_ROOT" || -z "$ACTIVE_REL" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel validar autocontencao."
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    guard_fail "python3 ausente — G-SELF-CONTAINED precisa varrer documentos governados de forma deterministica."
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

OFF_VERSION = re.compile(
    r"((?<!\.)\.\./|\bversao_0_3_x\b|\bversao_2_0_0\b|\bmethodology/|\bagents/role-templates\b|\bradar/)",
    re.I,
)
HISTORICAL_OR_FORBIDDING = re.compile(
    "|".join(
        [
            r"hist[oó]ric",
            r"hist[oó]ria",
            r"consulta",
            r"glacier",
            r"glaciar",
            r"congelad",
            r"passad",
            r"preservad",
            r"origem",
            r"proveni",
            r"migrad",
            r"\bmigra\b",
            r"transcri",
            r"morre",
            r"ap[eê]ndice",
            r"supersed",
            r"legad",
            r"antig",
            r"concorrent",
            r"readback",
            r"preflight",
            r"ledger",
            r"livro-raz",
            r"manifesto",
            r"prova",
            r"evid[eê]ncia",
            r"audit",
            r"proibid",
            r"bloque",
            r"rejeit",
            r"reprova",
            r"veda",
            r"impede",
            r"n[aã]o pode",
            r"nunca",
            r"nada de",
            r"exemplo",
            r"teste",
            r"fixture",
            r"regex",
            r"grep",
            r"git ls-tree",
            r"varredura",
            r"fora da vers[aã]o vigente",
            r"rotulad",
        ]
    ),
    re.I,
)
PROVENANCE_KEYS = re.compile(
    r"\b(migrado_de|id_original|created_at_original|autor_original|transcrito_em|transcrito_por|validacao_ref|files_forbidden|preflight)\b",
    re.I,
)


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


def strip_envelope(rel, text):
    if rel.endswith(".md") and text.startswith("---\n"):
        end = text.find("\n---\n", 4)
        if end != -1:
            prefix_lines = text[: end + 5].count("\n")
            return text[end + 5 :], prefix_lines
    if rel.endswith(".txt") and text.startswith("# ---HBN-FRONT-MATTER-BEGIN---\n"):
        marker = "# ---HBN-FRONT-MATTER-END---"
        end = text.find(marker)
        if end != -1:
            after = text.find("\n", end)
            if after != -1:
                return text[after + 1 :], text[: after + 1].count("\n")
    return text, 0


def flatten_json(value, path="json"):
    if isinstance(value, dict):
        lines = []
        for key, item in value.items():
            child = f"{path}.{key}"
            lines.extend(flatten_json(item, child))
        return lines
    if isinstance(value, list):
        lines = []
        for idx, item in enumerate(value):
            lines.extend(flatten_json(item, f"{path}[{idx}]"))
        return lines
    if isinstance(value, str):
        return [f"{path}: {value}"]
    return []


def json_lines(rel, text):
    try:
        data = json.loads(text)
    except Exception:
        return strip_envelope(rel, text)
    return "\n".join(flatten_json(data)), 0


failures = []
checked = 0
for repo_path in list_repo_paths():
    rel = version_rel(repo_path)
    if not rel or not is_candidate(rel):
        continue
    text = read_blob(repo_path)
    if text is None:
        continue
    body, offset = json_lines(rel, text) if rel.endswith(".json") else strip_envelope(rel, text)
    checked += 1
    for idx, line in enumerate(body.splitlines(), 1):
        if not OFF_VERSION.search(line):
            continue
        if PROVENANCE_KEYS.search(line) or HISTORICAL_OR_FORBIDDING.search(line):
            continue
        failures.append((rel, offset + idx, line.strip()))

if failures:
    for rel, line_no, line in failures:
        print(f"G-SELF-CONTAINED: {rel}:{line_no}", file=sys.stderr)
        print(f"  referencia fora da versao vigente sem rotulo historico/consulta/proibicao: {line}", file=sys.stderr)
    raise SystemExit(1)

print(f"G-SELF-CONTAINED OK: {checked} documento(s) governado(s) sem dependencia vigente externa.")
PY

rc=$?
if [[ "$rc" -ne 0 ]]; then
    guard_fail "Documento governado cita fonte externa como vigente ou sem rotulo historico/consulta."
    exit "$rc"
fi

guard_ok "Autocontencao documental validada."
exit 0
