#!/usr/bin/env bash
# scripts/hbn-snapshot/install-snapshot.sh — distribui o snapshot read-only do PROTOCOLO useHBN.
# Modos: --dry-run (default) | --verify-only | --install | --upgrade
# P2-A: --dry-run e --verify-only implementados; --install/--upgrade fail-closed (P2-B+ sob hearback).
set -euo pipefail
export LC_ALL=C
MODE="--dry-run"; PROTO="${HBN_PROTO:-$HOME/Projetos/usehbn}"; TAG="${HBN_TAG:-v1-estavel}"
TARGET=""; SURFACE="core methodology schemas guards"
while [[ $# -gt 0 ]]; do case "$1" in
  --dry-run|--verify-only|--install|--upgrade) MODE="$1";;
  --proto) PROTO="$2"; shift;; --tag) TAG="$2"; shift;;
  --target) TARGET="$2"; shift;; --surface) SURFACE="$2"; shift;;
  *) echo "arg desconhecido: $1" >&2; exit 2;; esac; shift; done
sha256() { if command -v sha256sum >/dev/null 2>&1; then sha256sum; else shasum -a 256; fi | cut -d' ' -f1; }
COMMIT="$(git -C "$PROTO" rev-parse "${TAG}^{commit}")"
echo "PROTO=$PROTO"; echo "TAG=$TAG"; echo "COMMIT=$COMMIT"; echo "SURFACE=$SURFACE"
MANFILE="$(mktemp)"
git -C "$PROTO" ls-tree -r -z --full-tree "$TAG" -- $SURFACE \
| while IFS= read -r -d '' rec; do
    meta="${rec%%$'\t'*}"; path="${rec#*$'\t'}"
    mode="${meta%% *}"; oid="${meta##* }"
    csha="$(git -C "$PROTO" cat-file blob "$oid" | tr -d '\r' | sha256)"
    printf '%s %s %s\n' "$mode" "$csha" "$path"
  done | LC_ALL=C sort -k3 > "$MANFILE"
COUNT="$(grep -c . "$MANFILE")"
PROTOCOL_SHA256="$(sha256 < "$MANFILE")"
echo "FILE_COUNT=$COUNT"
echo "PROTOCOL_SHA256=$PROTOCOL_SHA256"
echo "GUARDS_PROJETO=assert-canonical-root forbid-tmp-worktree forbid-env-files forbid-legacy-paths assert-scratch-lock assert-scratch-symlink assert-scratch-ignore assert-zona-livre assert-scope-lock assert-hearback-integrity assert-no-stray-hbn assert-self-path assert-trailers-contiguous assert-report-fresh assert-readlist-rite assert-knowledge-index"
echo "GUARDS_GENOMA_EXCLUIDOS=assert-orq-entrada assert-orq-entrada-ref validate-dispatch assert-dispatch-integrity assert-registry-line assert-pointer-honest assert-arvore-label assert-auditor-id assert-audit-diversity assert-quorum-selagem assert-parallel-id freeze-gate assert-baton-token"
case "$MODE" in
  --dry-run) echo "DRY-RUN: nada escrito no projeto (TARGET=${TARGET:-<nao informado>})."; rm -f "$MANFILE";;
  --verify-only)
    [[ -n "$TARGET" ]] || { echo "verify-only exige --target" >&2; rm -f "$MANFILE"; exit 2; }
    SNAP="$TARGET/.usehbn-snapshot"; HAVE=""
    [[ -f "$SNAP/PROTOCOL_SHA256.txt" ]] && HAVE="$(grep -oE '[0-9a-f]{64}' "$SNAP/PROTOCOL_SHA256.txt" | head -1)"
    rm -f "$MANFILE"
    [[ "$HAVE" == "$PROTOCOL_SHA256" ]] && echo "VERIFY OK: snapshot bate com $TAG" || { echo "VERIFY FALHOU: snapshot ausente ou != $TAG" >&2; exit 1; }
    ;;
  --install|--upgrade) rm -f "$MANFILE"; echo "MODE $MODE bloqueado em P2-A; usar --dry-run/--verify-only (install/upgrade vem em P2-B sob hearback)." >&2; exit 3;;
esac
