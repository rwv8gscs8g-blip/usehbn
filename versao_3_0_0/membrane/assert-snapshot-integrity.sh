#!/usr/bin/env bash
# =============================================================================
# membrane/assert-snapshot-integrity.sh — guard do CONSUMIDOR (v3.0.0)
# Instalado no projeto consumidor (ex.: Credenciamento) pelo
# hbn-upgrade-snapshot.sh, em scripts/hbn-snapshot/assert-snapshot-integrity.sh.
#
# Contrato explicito da membrana (TAREFA 6): os arquivos sob .usehbn-snapshot/
# devem corresponder EXATAMENTE (sha256 byte-a-byte) ao MEMBRANE_MANIFEST.json,
# que declara source_version + source_commit do genoma. Fail-closed:
#   - manifesto ausente/ilegivel            -> BLOCK
#   - hash divergente / arquivo faltando    -> BLOCK
#   - arquivo extra fora do manifesto       -> BLOCK
#   - mudanca staged em .usehbn-snapshot/   -> BLOCK (upgrade so pelo script)
#   - symlink ou .git dentro do snapshot    -> BLOCK
# =============================================================================
set -euo pipefail
export LC_ALL=C

G="assert-snapshot-integrity"
TOP="$(git rev-parse --show-toplevel)"
SNAP="$TOP/.usehbn-snapshot"
MAN="$SNAP/MEMBRANE_MANIFEST.json"

sha256() {
    if command -v sha256sum >/dev/null 2>&1; then sha256sum; else shasum -a 256; fi | cut -d' ' -f1
}

[[ -d "$SNAP" ]] || { echo "[$G] sem .usehbn-snapshot — nada a verificar."; exit 0; }
[[ -e "$SNAP/.git" ]] && { echo "[$G] ✗ .git dentro do snapshot" >&2; exit 1; }
if find "$SNAP" -type l | grep -q .; then
    echo "[$G] ✗ symlink dentro do snapshot" >&2; exit 1
fi
if git -C "$TOP" diff --cached --name-only -- .usehbn-snapshot 2>/dev/null | grep -q .; then
    echo "[$G] ✗ mudancas staged em .usehbn-snapshot/ — o snapshot e read-only; atualize SOMENTE via hbn-upgrade-snapshot.sh do genoma" >&2
    exit 1
fi
[[ -f "$MAN" ]] || { echo "[$G] ✗ MEMBRANE_MANIFEST.json ausente — membrana sem contrato (terceira exuvia exige manifesto explicito)" >&2; exit 1; }

RC=0
# Valida o proprio manifesto + cada arquivo declarado (JSON via python3).
CHECKS="$(python3 - "$MAN" <<'PY'
import json
import sys

man_path = sys.argv[1]
try:
    data = json.load(open(man_path, encoding="utf-8"))
except Exception as exc:
    print(f"ERR manifesto ilegivel: {exc}")
    sys.exit(0)
for field in ("source_version", "source_commit", "files"):
    if not data.get(field):
        print(f"ERR campo obrigatorio ausente no manifesto: {field}")
files = data.get("files") or {}
if not isinstance(files, dict) or not files:
    print("ERR manifesto sem dicionario files")
else:
    print(f"META {data.get('source_version')} {data.get('source_commit')}")
    for path, digest in sorted(files.items()):
        if "/.." in path or path.startswith(("/", "..")):
            print(f"ERR path inseguro no manifesto: {path}")
            continue
        print(f"FILE {digest} {path}")
PY
)"

META_LINE="$(grep '^META ' <<< "$CHECKS" || true)"
if grep -q '^ERR ' <<< "$CHECKS"; then
    grep '^ERR ' <<< "$CHECKS" | sed "s/^ERR /[$G] ✗ /" >&2
    exit 1
fi

DECLARED_COUNT=0
while read -r kind digest path; do
    [[ "$kind" == "FILE" ]] || continue
    DECLARED_COUNT=$((DECLARED_COUNT + 1))
    f="$SNAP/$path"
    if [[ ! -f "$f" ]]; then
        echo "[$G] ✗ arquivo declarado FALTANDO no snapshot: $path" >&2
        RC=1
        continue
    fi
    cur="$(sha256 < "$f")"
    if [[ "$cur" != "$digest" ]]; then
        echo "[$G] ✗ DRIFT byte-a-byte em $path (esperado ${digest:0:12}…, atual ${cur:0:12}…)" >&2
        RC=1
    fi
done <<< "$CHECKS"

# Arquivos extra: tudo no disco que nao e o manifesto nem esta declarado.
NDISK="$(cd "$SNAP" && find . -type f -not -name 'MEMBRANE_MANIFEST.json' | sed 's|^\./||' | wc -l | tr -d ' ')"
if [[ "$NDISK" != "$DECLARED_COUNT" ]]; then
    echo "[$G] ✗ contagem divergente: disco=$NDISK declarados=$DECLARED_COUNT (arquivo extra ou removido fora do manifesto)" >&2
    while IFS= read -r f; do
        rel="${f#./}"
        grep -q "^FILE [0-9a-f]* ${rel}$" <<< "$CHECKS" || echo "[$G]     extra: ${rel}" >&2
    done < <(cd "$SNAP" && find . -type f -not -name 'MEMBRANE_MANIFEST.json')
    RC=1
fi

if [[ $RC -eq 0 ]]; then
    echo "[$G] ✓ snapshot integro (${DECLARED_COUNT} arquivos; ${META_LINE#META })"
    exit 0
fi
echo "[$G] Como corrigir: NUNCA edite .usehbn-snapshot/ a mao. Rode no genoma: bash <hot>/scripts/hbn-upgrade-snapshot.sh --target $TOP" >&2
exit 1
