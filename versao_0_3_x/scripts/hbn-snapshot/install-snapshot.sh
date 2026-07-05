#!/usr/bin/env bash
# scripts/hbn-snapshot/install-snapshot.sh — distribui o snapshot read-only do PROTOCOLO useHBN.
# Modos: --dry-run (default) | --verify-only | --install | --upgrade
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
gen_manifest() { # imprime "mode sha256(LF) path" ordenado por path, da TREE do tag
  git -C "$PROTO" ls-tree -r -z --full-tree "$TAG" -- $SURFACE \
  | while IFS= read -r -d '' rec; do
      meta="${rec%%$'\t'*}"; path="${rec#*$'\t'}"; mode="${meta%% *}"; oid="${meta##* }"
      csha="$(git -C "$PROTO" cat-file blob "$oid" | tr -d '\r' | sha256)"
      printf '%s %s %s\n' "$mode" "$csha" "$path"
    done | LC_ALL=C sort -k3
}
echo "PROTO=$PROTO"; echo "TAG=$TAG"; echo "COMMIT=$COMMIT"; echo "SURFACE=$SURFACE"
MANFILE="$(mktemp)"; gen_manifest > "$MANFILE"
COUNT="$(grep -c . "$MANFILE")"; PROTOCOL_SHA256="$(sha256 < "$MANFILE")"
echo "FILE_COUNT=$COUNT"; echo "PROTOCOL_SHA256=$PROTOCOL_SHA256"
GUARDS_PROJETO="assert-canonical-root forbid-tmp-worktree forbid-env-files forbid-legacy-paths assert-scratch-lock assert-scratch-symlink assert-scratch-ignore assert-zona-livre assert-scope-lock assert-hearback-integrity assert-no-stray-hbn assert-self-path assert-trailers-contiguous assert-report-fresh assert-readlist-rite assert-knowledge-index"
GUARDS_EXCL="assert-orq-entrada assert-orq-entrada-ref validate-dispatch assert-dispatch-integrity assert-registry-line assert-pointer-honest assert-arvore-label assert-auditor-id assert-audit-diversity assert-quorum-selagem assert-parallel-id freeze-gate assert-baton-token"
echo "GUARDS_PROJETO=$GUARDS_PROJETO"; echo "GUARDS_GENOMA_EXCLUIDOS=$GUARDS_EXCL"

write_membrane() { # $1 = SNAP dir (ja existe, vazio)
  local SNAP="$1"
  git -C "$PROTO" archive --format=tar "$TAG" -- $SURFACE | tar -x -C "$SNAP"
  cp "$MANFILE" "$SNAP/PROTOCOL_MANIFEST.sha256"
  printf 'protocol_sha256=%s\ntag=%s\ncommit=%s\ngenerated_at=%s\nsurface=%s\nfile_count=%s\n' \
    "$PROTOCOL_SHA256" "$TAG" "$COMMIT" "$(date -u +%FT%TZ)" "$SURFACE" "$COUNT" > "$SNAP/PROTOCOL_SHA256.txt"
  printf '%s\n' "$TAG" > "$SNAP/VERSION"
  cat > "$SNAP/USEHBN-HEADER.txt" <<HDR
ISTO E O PROTOCOLO useHBN (usehbn@$TAG, commit $COMMIT) — read-only.
NAO EDITAR. Para ler a regra: aqui (.usehbn-snapshot/, read-only).
Para trabalhar no projeto: na raiz do projeto. Para melhorar o protocolo:
deposite em inbox/credenciamento/ do protocolo (nunca edite o genoma direto).
Qualquer edicao deste diretorio e bloqueada por assert-snapshot-integrity.
HDR
  cat > "$SNAP/CONSUMER-PROFILE.md" <<PROF
# Perfil de consumidor do snapshot (usehbn@$TAG)
protocol_sha256: $PROTOCOL_SHA256
surface: $SURFACE
guards_projeto: $GUARDS_PROJETO
guards_genoma_excluidos: $GUARDS_EXCL
PROF
}

write_integrity_guard() { # $1 = TGT_TOP
  local d="$1/scripts/hbn-snapshot"; mkdir -p "$d"
  cat > "$d/assert-snapshot-integrity.sh" <<'GUARD'
#!/usr/bin/env bash
# assert-snapshot-integrity.sh (LOCAL) — bloqueia drift/edicao de .usehbn-snapshot/.
set -euo pipefail; export LC_ALL=C
G="assert-snapshot-integrity"
TOP="$(git rev-parse --show-toplevel)"; SNAP="$TOP/.usehbn-snapshot"
sha256(){ if command -v sha256sum >/dev/null 2>&1; then sha256sum; else shasum -a 256; fi | cut -d' ' -f1; }
[[ -d "$SNAP" ]] || { echo "[$G] sem .usehbn-snapshot — nada a verificar."; exit 0; }
[[ -e "$SNAP/.git" ]] && { echo "[$G] ✗ .git dentro do snapshot" >&2; exit 1; }
if find "$SNAP" -type l | grep -q .; then echo "[$G] ✗ symlink no snapshot" >&2; exit 1; fi
if git -C "$TOP" diff --cached --name-only -- .usehbn-snapshot 2>/dev/null | grep -q .; then
  echo "[$G] ✗ mudancas staged em .usehbn-snapshot/ (read-only; use install-snapshot.sh --upgrade)" >&2; exit 1; fi
MAN="$SNAP/PROTOCOL_MANIFEST.sha256"; [[ -f "$MAN" ]] || { echo "[$G] ✗ manifesto ausente" >&2; exit 1; }
RC=0
while read -r mode csha path; do
  f="$SNAP/$path"
  [[ -f "$f" ]] || { echo "[$G] ✗ faltando $path" >&2; RC=1; continue; }
  cur="$(tr -d '\r' < "$f" | sha256)"
  [[ "$cur" == "$csha" ]] || { echo "[$G] ✗ drift em $path" >&2; RC=1; }
done < "$MAN"
ndisk="$(find "$SNAP" -type f -not -name 'PROTOCOL_MANIFEST.sha256' -not -name 'PROTOCOL_SHA256.txt' -not -name 'VERSION' -not -name 'USEHBN-HEADER.txt' -not -name 'CONSUMER-PROFILE.md' | wc -l | tr -d ' ')"
nman="$(grep -c . "$MAN")"
[[ "$ndisk" == "$nman" ]] || { echo "[$G] ✗ arquivos extra no snapshot (disco=$ndisk manifesto=$nman)" >&2; RC=1; }
[[ $RC -eq 0 ]] && echo "[$G] ✓ snapshot integro ($nman arquivos)" || exit 1
GUARD
  chmod +x "$d/assert-snapshot-integrity.sh"
}

case "$MODE" in
  --dry-run) echo "DRY-RUN: nada escrito no projeto (TARGET=${TARGET:-<nao informado>})."; rm -f "$MANFILE";;
  --verify-only)
    [[ -n "$TARGET" ]] || { echo "verify-only exige --target" >&2; rm -f "$MANFILE"; exit 2; }
    SNAP="$TARGET/.usehbn-snapshot"; HAVE=""
    [[ -f "$SNAP/PROTOCOL_SHA256.txt" ]] && HAVE="$(grep -oE '[0-9a-f]{64}' "$SNAP/PROTOCOL_SHA256.txt" | head -1)"
    rm -f "$MANFILE"
    [[ "$HAVE" == "$PROTOCOL_SHA256" ]] && echo "VERIFY OK: snapshot bate com $TAG" || { echo "VERIFY FALHOU: ausente ou != $TAG" >&2; exit 1; } ;;
  --install)
    [[ -n "$TARGET" ]] || { echo "install exige --target" >&2; rm -f "$MANFILE"; exit 2; }
    TGT_TOP="$(git -C "$TARGET" rev-parse --show-toplevel 2>/dev/null || true)"
    [[ -n "$TGT_TOP" ]] || { echo "target nao e repo git: $TARGET" >&2; rm -f "$MANFILE"; exit 2; }
    PROTO_TOP="$(git -C "$PROTO" rev-parse --show-toplevel)"
    [[ "$TGT_TOP" != "$PROTO_TOP" ]] || { echo "target == proto; recusado" >&2; rm -f "$MANFILE"; exit 2; }
    SNAP="$TGT_TOP/.usehbn-snapshot"
    [[ -e "$SNAP" ]] && { echo "$SNAP ja existe; use --upgrade" >&2; rm -f "$MANFILE"; exit 2; }
    rm -rf "$SNAP.tmp"; mkdir -p "$SNAP.tmp"; write_membrane "$SNAP.tmp"; mv "$SNAP.tmp" "$SNAP"
    write_integrity_guard "$TGT_TOP"
    mkdir -p "$TGT_TOP/.hbn"; printf '.\n' > "$TGT_TOP/.hbn/active-version"
    chmod -R a-w "$SNAP" 2>/dev/null || true
    rm -f "$MANFILE"
    echo "INSTALL OK: $SNAP (protocol_sha256=$PROTOCOL_SHA256; $COUNT arquivos); guard local + .hbn/active-version=. criados." ;;
  --upgrade) rm -f "$MANFILE"; echo "MODE --upgrade ainda nao implementado (P2-C+)." >&2; exit 3;;
esac
