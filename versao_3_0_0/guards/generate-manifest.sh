#!/usr/bin/env bash
# Gera guards/MANIFEST.yaml a partir dos blocos ---HBN-REQUIRES--- dos guards.
# v3.0.0: resolve a pasta de guards RELATIVA A ESTE SCRIPT (version-aware) —
# nunca a raiz do git, que pos-exuvia nao contem logica ativa.
set -euo pipefail
GUARDS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

python3 - "$GUARDS_DIR" <<'PY'
import os
import re
import sys

guards_dir = sys.argv[1]
begin = "# ---HBN-REQUIRES-BEGIN---"
end = "# ---HBN-REQUIRES-END---"
install_values = {"skeleton", "copy", "refuse"}
guard_re = re.compile(r"^(assert|forbid)-[a-z0-9-]+\.sh$|^freeze-gate\.sh$|^validate-dispatch\.sh$")

def strip_comment_prefix(line):
    if line.startswith("# "):
        return line[2:]
    if line == "#":
        return ""
    if line.startswith("#"):
        return line[1:]
    return line

def extract_block(path):
    lines = open(path, encoding="utf-8").read().splitlines()
    starts = [i for i, line in enumerate(lines) if line.strip() == begin]
    ends = [i for i, line in enumerate(lines) if line.strip() == end]
    if len(starts) != 1 or len(ends) != 1 or starts[0] >= ends[0]:
        raise SystemExit(f"{path}: bloco requires ausente, duplicado ou malformado")
    return [strip_comment_prefix(line) for line in lines[starts[0] + 1 : ends[0]]]

def parse_inline_list(value):
    value = value.strip()
    if value == "[]":
        return []
    if value.startswith("[") and value.endswith("]"):
        inside = value[1:-1].strip()
        if not inside:
            return []
        return [item.strip().strip('"').strip("'") for item in inside.split(",") if item.strip()]
    return None

def parse_block(lines, source):
    if not lines or lines[0].strip() != "requires:":
        raise SystemExit(f"{source}: bloco deve iniciar com requires:")
    data = {"files": [], "dirs": [], "state_fields": [], "guards": [], "env": []}
    idx = 1
    current = None
    while idx < len(lines):
        raw = lines[idx]
        idx += 1
        if not raw.strip():
            continue
        if not raw.startswith("  "):
            raise SystemExit(f"{source}: indentacao invalida: {raw}")
        item = raw[2:]
        if ":" not in item:
            raise SystemExit(f"{source}: chave invalida: {raw}")
        key, value = item.split(":", 1)
        key = key.strip()
        value = value.strip()
        if key not in data:
            raise SystemExit(f"{source}: chave nao permitida: {key}")
        current = key
        inline = parse_inline_list(value)
        if inline is not None:
            data[key] = inline
            continue
        if value:
            raise SystemExit(f"{source}: valor inline invalido em {key}: {value}")
        if key in ("files", "dirs"):
            while idx < len(lines):
                nxt = lines[idx]
                if not nxt.strip():
                    idx += 1
                    continue
                if nxt.startswith("  ") and not nxt.startswith("    "):
                    break
                if not nxt.startswith("    - "):
                    raise SystemExit(f"{source}: item invalido em {key}: {nxt}")
                first = nxt[6:]
                idx += 1
                obj = {}
                if ":" not in first:
                    raise SystemExit(f"{source}: item sem chave em {key}: {nxt}")
                k, v = first.split(":", 1)
                obj[k.strip()] = v.strip().strip('"').strip("'")
                while idx < len(lines):
                    child = lines[idx]
                    if not child.strip():
                        idx += 1
                        continue
                    if child.startswith("    - ") or (child.startswith("  ") and not child.startswith("    ")):
                        break
                    if not child.startswith("      ") or ":" not in child:
                        raise SystemExit(f"{source}: campo invalido em item de {key}: {child}")
                    ck, cv = child[6:].split(":", 1)
                    obj[ck.strip()] = cv.strip().strip('"').strip("'")
                    idx += 1
                data[key].append(obj)
        else:
            values = []
            while idx < len(lines):
                nxt = lines[idx]
                if not nxt.strip():
                    idx += 1
                    continue
                if nxt.startswith("  ") and not nxt.startswith("    "):
                    break
                if not nxt.startswith("    - "):
                    raise SystemExit(f"{source}: item invalido em {key}: {nxt}")
                values.append(nxt[6:].strip().strip('"').strip("'"))
                idx += 1
            data[key] = values
    if current is None:
        raise SystemExit(f"{source}: requires vazio")
    for key in ("files", "dirs", "state_fields", "guards", "env"):
        if key not in data:
            raise SystemExit(f"{source}: requires sem {key}")
    for group in ("files", "dirs"):
        for item in data[group]:
            extra = set(item) - {"path", "install", "source", "reason"}
            if extra:
                raise SystemExit(f"{source}: campos nao permitidos em {group}: {sorted(extra)}")
            if not item.get("path"):
                raise SystemExit(f"{source}: item de {group} sem path")
            if item.get("install") not in install_values:
                raise SystemExit(f"{source}: install invalido para {item.get('path')}: {item.get('install')}")
            if item["install"] in {"skeleton", "copy"} and not item.get("source") and group == "files":
                raise SystemExit(f"{source}: {item['install']} exige source para {item['path']}")
    return data

def emit_scalar(value):
    if not value:
        return '""'
    if re.fullmatch(r"[A-Za-z0-9._/\-]+", value):
        return value
    return '"' + value.replace('"', '\\"') + '"'

guards = sorted(name for name in os.listdir(guards_dir) if guard_re.match(name))
records = []
for name in guards:
    path = os.path.join(guards_dir, name)
    block = parse_block(extract_block(path), path)
    records.append((name[:-3] if name.endswith(".sh") else name, f"guards/{name}", block))

print("guards:")
for guard, path, req in records:
    print(f"  - guard: {guard}")
    print(f"    path: {path}")
    print("    requires:")
    for group in ("files", "dirs"):
        if not req[group]:
            print(f"      {group}: []")
        else:
            print(f"      {group}:")
            for item in req[group]:
                print(f"        - path: {emit_scalar(item['path'])}")
                print(f"          install: {item['install']}")
                if item.get("source"):
                    print(f"          source: {emit_scalar(item['source'])}")
                if item.get("reason"):
                    print(f"          reason: {emit_scalar(item['reason'])}")
    for group in ("state_fields", "guards", "env"):
        values = req[group]
        if values:
            print(f"      {group}: [{', '.join(emit_scalar(v) for v in values)}]")
        else:
            print(f"      {group}: []")
PY
