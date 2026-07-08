#!/usr/bin/env bash
# =============================================================================
# .cursor/hooks/hbn-boot-lock.sh — BOOT-LOCK client-side (TAREFA 7, v3.0.0)
# Intercepta ferramentas de ESCRITA do agente ANTES de atingirem o disco:
# se o path de destino esta fora da pasta da versao quente ativa (lida de
# .hbn/active-version) e fora da allowlist minima de raiz, a gravacao e
# NEGADA. Espelho client-side do G-HOT-WRITE (que defende o chokepoint de
# commit); este hook defende o proprio disco.
# Fail-closed: ponteiro ilegivel/invalido => deny.
# =============================================================================
set -uo pipefail

INPUT="$(cat)"

HOOK_INPUT="$INPUT" python3 - "$PWD" <<'PY'
import json
import os
import sys

repo = sys.argv[1]
try:
    data = json.loads(os.environ.get("HOOK_INPUT", ""))
except Exception:
    print(json.dumps({"permission": "deny",
                      "user_message": "BOOT-LOCK: input do hook ilegivel (fail-closed).",
                      "agent_message": "BOOT-LOCK: input ilegivel; escrita negada por seguranca."}))
    sys.exit(0)

def collect_paths(obj, found):
    if isinstance(obj, dict):
        for key, val in obj.items():
            if key in ("path", "file_path", "target_notebook", "filePath") and isinstance(val, str):
                found.append(val)
            else:
                collect_paths(val, found)
    elif isinstance(obj, list):
        for item in obj:
            collect_paths(item, found)

paths = []
collect_paths(data, paths)
if not paths:
    print(json.dumps({"permission": "allow"}))
    sys.exit(0)

pointer = os.path.join(repo, ".hbn", "active-version")
active = None
try:
    with open(pointer, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line and not line.startswith("#"):
                active = line
                break
except Exception:
    active = None

import re
if active is None or (active != "." and not re.fullmatch(r"versao_\d+_\d+_[A-Za-z0-9]+", active)):
    print(json.dumps({"permission": "deny",
                      "user_message": "BOOT-LOCK: .hbn/active-version ausente/invalido — escrita negada (fail-closed).",
                      "agent_message": "BOOT-LOCK: ponteiro de versao ativa invalido; rode `cat .hbn/active-version` e corrija antes de escrever."}))
    sys.exit(0)

# active == "." (project-mode): sem pasta quente separada; hook delega.
if active == ".":
    print(json.dumps({"permission": "allow"}))
    sys.exit(0)

ALLOW_PREFIXES = (
    active + "/",
)
# Allowlist ESTRITA, espelho exato do G-HOT-WRITE em modo normal (readback
# 0002 T3, Opcao A): shims de raiz (README.md, AGENTS.md, .hbn/canonical-root,
# .hbn/active-version, .github/workflows/**, .cursor/**) NAO sao escreviveis
# por agente em dev normal — mudam so em exuvia autorizada ou em commit com
# autorizacao hot-write-root-shim, executado pelo operador humano.
ALLOW_EXACT = {
    ".gitignore",
    ".hbn/relay/STATE.md",
}
ALLOW_DIR_PREFIXES = (
    ".hbn/hearbacks/",
)

repo_real = os.path.realpath(repo)
violations = []
for p in paths:
    absolute = p if os.path.isabs(p) else os.path.join(repo, p)
    real = os.path.realpath(absolute)
    if not (real == repo_real or real.startswith(repo_real + os.sep)):
        # fora do repo: nao e jurisdicao deste hook (outros projetos)
        continue
    rel = os.path.relpath(real, repo_real)
    if rel.startswith(ALLOW_PREFIXES):
        continue
    if rel in ALLOW_EXACT:
        continue
    if any(rel.startswith(d) for d in ALLOW_DIR_PREFIXES):
        continue
    violations.append(rel)

if violations:
    listed = ", ".join(violations[:5])
    print(json.dumps({
        "permission": "deny",
        "user_message": f"BOOT-LOCK: escrita fora da versao quente ativa '{active}' NEGADA antes do disco: {listed}",
        "agent_message": (
            f"BOOT-LOCK (BOOT.md §0): a versao quente ativa e '{active}'. "
            f"Escreva o artefato sob '{active}/' (paths negados: {listed}). "
            "Allowlist de raiz: .gitignore, .hbn/relay/STATE.md, .hbn/hearbacks/**. "
            "Shims de raiz (README.md, AGENTS.md, .hbn/active-version, .hbn/canonical-root, "
            ".github/workflows/**, .cursor/**) so mudam em exuvia autorizada ou commit "
            "hot-write-root-shim do operador humano."
        ),
    }))
    sys.exit(0)

print(json.dumps({"permission": "allow"}))
PY
