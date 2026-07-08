#!/usr/bin/env bash
# =============================================================================
# scripts/hbn-upgrade-snapshot.sh — upgrade ATOMICO da membrana (v3.0.0, TAREFA 6)
#
# Roda NO GENOMA (usehbn). Extrai a superficie da VERSAO QUENTE ATIVA (lida de
# .hbn/active-version, de um commit — nunca da working tree), gera o
# MEMBRANE_MANIFEST.json com sha256 byte-a-byte e substitui .usehbn-snapshot/
# do consumidor de forma atomica (staging dir + mv). Instala/atualiza tambem o
# guard assert-snapshot-integrity.sh do consumidor.
#
# Uso:
#   bash scripts/hbn-upgrade-snapshot.sh --target /caminho/do/consumidor \
#        [--ref HEAD] [--surface "core guards schemas MANIFESTO-MIGRACAO.md"] [--dry-run]
#
# Regras:
#   - source_version = valor de .hbn/active-version no REF (fail-closed se ".").
#   - Snapshot antigo e preservado em .usehbn-snapshot.prev ate o operador
#     conferir e remover (rollback trivial: mv de volta).
#   - Nenhum commit automatico: o commit no consumidor e ato do operador.
# =============================================================================
set -euo pipefail
export LC_ALL=C

MODE="--install"
TARGET=""
REF="HEAD"
SURFACE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) MODE="--dry-run" ;;
        --target) TARGET="${2:-}"; shift ;;
        --ref) REF="${2:-}"; shift ;;
        --surface) SURFACE="${2:-}"; shift ;;
        *) echo "arg desconhecido: $1" >&2; exit 2 ;;
    esac
    shift
done

log() { echo "[hbn-upgrade-snapshot] $*" >&2; }
die() { echo "[hbn-upgrade-snapshot] ✗ ABORTADO: $*" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROTO="$(git -C "$VERSION_ROOT" rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$PROTO" ]] || die "genoma nao resolvido a partir de ${SCRIPT_DIR}"
[[ -n "$TARGET" ]] || die "informe --target <repo consumidor>"
TGT_TOP="$(git -C "$TARGET" rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$TGT_TOP" ]] || die "target nao e repo git: ${TARGET}"
[[ "$TGT_TOP" != "$PROTO" ]] || die "target == genoma; recusado"

COMMIT="$(git -C "$PROTO" rev-parse "${REF}^{commit}")" || die "ref invalido: ${REF}"

# Versao quente ativa LIDA DO COMMIT (nunca da working tree):
ACTIVE="$(git -C "$PROTO" show "${COMMIT}:.hbn/active-version" 2>/dev/null \
    | grep -v '^[[:space:]]*#' | grep -v '^[[:space:]]*$' | head -1 \
    | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')" || true
[[ -n "$ACTIVE" ]] || die ".hbn/active-version ausente no commit ${COMMIT:0:7}"
[[ "$ACTIVE" != "." ]] || die "active-version='.' no commit ${COMMIT:0:7} — genoma sem versao quente numerada; a membrana v3 exige source_version explicita"
[[ "$ACTIVE" =~ ^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+$ ]] || die "active-version invalida: ${ACTIVE}"

SURFACE="${SURFACE:-core guards schemas MANIFESTO-MIGRACAO.md}"
log "genoma=${PROTO} commit=${COMMIT:0:7} hot=${ACTIVE} surface='${SURFACE}' target=${TGT_TOP}"

sha256() {
    if command -v sha256sum >/dev/null 2>&1; then sha256sum; else shasum -a 256; fi | cut -d' ' -f1
}

# --- Monta o snapshot novo em staging dir (atomico por construcao) -------------
STAGING="$(mktemp -d "${TMPDIR:-/tmp}/hbn-membrane.XXXXXX")"
cleanup() { rm -rf "$STAGING" 2>/dev/null || true; }
trap cleanup EXIT INT TERM

SNAP_NEW="$STAGING/snapshot"
mkdir -p "$SNAP_NEW"

# Extrai a superficie da versao quente do COMMIT (paths reescritos sem o
# prefixo versao_X_Y_Z/ — o consumidor ve a superficie "achatada"):
SURFACE_PATHS=()
for s in $SURFACE; do
    SURFACE_PATHS+=("${ACTIVE}/${s}")
done
mkdir -p "$STAGING/raw"
git -C "$PROTO" archive --format=tar "$COMMIT" -- "${SURFACE_PATHS[@]}" | tar -x -C "$STAGING/raw"
[[ -d "$STAGING/raw/${ACTIVE}" ]] || die "superficie vazia no commit (${SURFACE_PATHS[*]})"
cp -R "$STAGING/raw/${ACTIVE}/." "$SNAP_NEW/"

# Poda: testes e fixtures de teste nao descem na membrana (superficie enxuta).
rm -rf "$SNAP_NEW/guards/tests" 2>/dev/null || true

# --- Gera o MEMBRANE_MANIFEST.json ---------------------------------------------
GENERATED_AT="$(date +%Y-%m-%dT%H:%M:%S%z | sed -E 's/([0-9]{2})([0-9]{2})$/\1:\2/')"
python3 - "$SNAP_NEW" "$ACTIVE" "$COMMIT" "$GENERATED_AT" "$SURFACE" <<'PY'
import hashlib
import json
import os
import sys

snap, version, commit, generated_at, surface = sys.argv[1:6]
files = {}
for root, dirs, names in os.walk(snap):
    dirs.sort()
    for name in sorted(names):
        full = os.path.join(root, name)
        rel = os.path.relpath(full, snap)
        if rel == "MEMBRANE_MANIFEST.json":
            continue
        with open(full, "rb") as fh:
            files[rel] = hashlib.sha256(fh.read()).hexdigest()
manifest = {
    "schema_version": 1,
    "origem": "usehbn",
    "source_version": version,
    "source_commit": commit,
    "generated_at": generated_at,
    "surface": surface.split(),
    "files": files,
}
out = os.path.join(snap, "MEMBRANE_MANIFEST.json")
with open(out, "w", encoding="utf-8") as fh:
    json.dump(manifest, fh, ensure_ascii=False, indent=2, sort_keys=True)
    fh.write("\n")
print(f"[hbn-upgrade-snapshot] manifesto: {len(files)} arquivos hasheados", file=sys.stderr)
PY

FILE_COUNT="$(python3 -c "import json,sys; print(len(json.load(open(sys.argv[1]))['files']))" "$SNAP_NEW/MEMBRANE_MANIFEST.json")"
log "snapshot novo montado: ${FILE_COUNT} arquivos (source ${ACTIVE} @ ${COMMIT:0:7})"

if [[ "$MODE" == "--dry-run" ]]; then
    log "DRY-RUN: nada escrito em ${TGT_TOP}."
    exit 0
fi

# --- Troca atomica no consumidor ------------------------------------------------
SNAP_DST="$TGT_TOP/.usehbn-snapshot"
SNAP_TMP="$TGT_TOP/.usehbn-snapshot.new.$$"
SNAP_PREV="$TGT_TOP/.usehbn-snapshot.prev"

rm -rf "$SNAP_TMP"
cp -R "$SNAP_NEW" "$SNAP_TMP"

# Instala/atualiza o guard de integridade do consumidor ANTES do swap.
GUARD_SRC="${VERSION_ROOT}/membrane/assert-snapshot-integrity.sh"
[[ -f "$GUARD_SRC" ]] || die "guard da membrana ausente no genoma: ${GUARD_SRC}"
mkdir -p "$TGT_TOP/scripts/hbn-snapshot"
cp "$GUARD_SRC" "$TGT_TOP/scripts/hbn-snapshot/assert-snapshot-integrity.sh"
chmod +x "$TGT_TOP/scripts/hbn-snapshot/assert-snapshot-integrity.sh"

# Swap atomico: prev <- atual; atual <- novo. Em falha, restaura.
if [[ -e "$SNAP_DST" ]]; then
    rm -rf "$SNAP_PREV"
    chmod -R u+w "$SNAP_DST" 2>/dev/null || true
    mv "$SNAP_DST" "$SNAP_PREV"
fi
if ! mv "$SNAP_TMP" "$SNAP_DST"; then
    [[ -e "$SNAP_PREV" ]] && mv "$SNAP_PREV" "$SNAP_DST"
    die "swap falhou; snapshot anterior restaurado"
fi
chmod -R a-w "$SNAP_DST" 2>/dev/null || true

# Verificacao pos-swap com o proprio guard do consumidor:
if ! ( cd "$TGT_TOP" && bash scripts/hbn-snapshot/assert-snapshot-integrity.sh ); then
    chmod -R u+w "$SNAP_DST" 2>/dev/null || true
    rm -rf "$SNAP_DST"
    [[ -e "$SNAP_PREV" ]] && mv "$SNAP_PREV" "$SNAP_DST"
    die "verificacao pos-swap FALHOU; snapshot anterior restaurado"
fi

log "UPGRADE OK: ${SNAP_DST} (source_version=${ACTIVE}, source_commit=${COMMIT})"
log "snapshot anterior preservado em ${SNAP_PREV} — remova apos conferencia do operador."
log "NADA foi commitado: o commit no consumidor e ato do operador humano com hearback."
exit 0
