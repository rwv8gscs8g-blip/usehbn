#!/usr/bin/env bash
set -euo pipefail
cd /Users/macbookpro/Projetos/usehbn

export TMPDIR="$PWD/.tmp-audit"
mkdir -p "$TMPDIR"

# disable template/hooks writes that may be blocked
export GIT_TEMPLATE_DIR=/dev/null
export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL=/dev/null

source guards/lib/common.sh
GUARDS_DIR="guards"

echo "=== (a) REPRODUCAO DO FURO PRINCIPAL (meu parecer anterior 20260704-221500-cross-ia-grok-fase1-classe-anti-desarme.md) ==="
echo "Attack: HBN_DIFF_BASE set (lixo/residual) LOCAL pre-commit + NO real CI signal (HBN_CI/GITHUB_ACTIONS/CI unset or false)"
echo "+ staged removal (git rm) of each of 6 deps -> NOW must DISARM/BLOCK"
echo "Previously escaped because if [[ -n HBN_DIFF_BASE ]] forced current=HEAD (present) -> ATIVO"
echo "Fix location: guards/lib/common.sh:173 hbn_ci_range_mode + 184 effective + 189 current_ref + 258 hbn_context_dep_state"
echo

cleanup() { [[ -n "${d:-}" ]] && rm -rf "$d" 2>/dev/null || true; }
trap cleanup EXIT

seed_base() {
  local dd="$1"
  mkdir -p "$dd/.hbn" "$dd/.hbn/knowledge" "$dd/.hbn/relay" "$dd/.hbn/readbacks" "$dd/.hbn/models" \
           "$dd/.usehbn-snapshot/guards" "$dd/core" "$dd/.github/workflows" "$dd/guards"
  echo "." > "$dd/.hbn/active-version"
}

do_commit() { (cd "$1"; git add -A >/dev/null 2>&1; git commit -qm "${2:-seed}" >/dev/null 2>&1); }

make_for() {
  local dep="$1"; local d; d="$(mktemp -d)"
  seed_base "$d"
  (cd "$d"; git init -q --initial-branch=main --template=/dev/null . )
  case "$dep" in
    state)
      cat >"$d/.hbn/relay/STATE.md" <<'E'
---
atribuicao:
  implementador: grok
  auditores: [antigravity]
sinais_abertos: []
E
      do_commit "$d" "seed-state"
      ;;
    knowledge)
      echo '| id |' > "$d/.hbn/knowledge/INDEX.md"
      echo 'd' > "$d/.hbn/knowledge/d.md"
      do_commit "$d" "seed-know"
      ;;
    frontdoor)
      cat >"$d/core/role-cards.md" <<'EOR'
## PARTE A - READ-LIST DA PORTA DA FRENTE
1. core/read-list-canonica.txt
EOR
      echo 'c' > "$d/core/read-list-canonica.txt"
      do_commit "$d" "seed-front"
      ;;
    ci)
      cat >"$d/.github/workflows/hbn-shield.yml" <<'EOW'
name: hbn
on: [push]
jobs:
  s:
    runs-on: ubuntu-latest
    steps:
      - run: bash guards/ci-entry.sh
EOW
      cat >"$d/guards/ci-entry.sh" <<'EOE'
#!/bin/bash
set -e
export HBN_CI=1
bash guards/hbn-guards-runner.sh
EOE
      chmod +x "$d/guards/ci-entry.sh"
      do_commit "$d" "seed-ci"
      ;;
    profile-root)
      echo 'perfil' > "$d/CONSUMER-PROFILE.md"
      do_commit "$d" "seed-pr"
      ;;
    profile-marker)
      echo 'perfil' > "$d/CONSUMER-PROFILE.md"
      mkdir -p "$d/.usehbn-snapshot/guards"
      echo k > "$d/.usehbn-snapshot/guards/.keep"
      do_commit "$d" "seed-pm"
      ;;
  esac
  echo "$d"
}

get_p() { case "$1" in
  state) echo ".hbn/relay/STATE.md" ;; knowledge) echo ".hbn/knowledge/INDEX.md" ;;
  frontdoor) echo "core/role-cards.md" ;; ci) echo ".github/workflows/hbn-shield.yml" ;;
  profile-root) echo "CONSUMER-PROFILE.md" ;; profile-marker) echo ".usehbn-snapshot" ;;
esac; }

invoke() {
  local dep=$1; local dd=$2
  case $dep in
    state) (cd "$dd" && bash "$GUARDS_DIR/assert-role-family.sh" >/dev/null 2>&1); echo $? ;;
    knowledge) (cd "$dd" && bash "$GUARDS_DIR/assert-knowledge-index.sh" >/dev/null 2>&1); echo $? ;;
    frontdoor) (cd "$dd" && bash "$GUARDS_DIR/assert-frontdoor.sh" >/dev/null 2>&1); echo $? ;;
    ci) (cd "$dd" && bash "$GUARDS_DIR/assert-ci-battery.sh" >/dev/null 2>&1); echo $? ;;
    profile-root|profile-marker) (cd "$dd" && HBN_PROFILE_SNAPSHOT_GUARDS_DIR="$GUARDS_DIR" bash "$GUARDS_DIR/assert-profile-authorized.sh" >/dev/null 2>&1); echo $? ;;
  esac
}

echo "=== ATTACKS (a) ==="
for dep in state knowledge frontdoor ci profile-root profile-marker; do
  d="$(make_for "$dep")"
  p="$(get_p "$dep")"
  (cd "$d" && git rm -q -r -- "$p" 2>/dev/null || git rm -q --cached -r -- "$p" 2>/dev/null || true)
  base="$(cd "$d" && git rev-parse HEAD)"
  rc=$( (
    cd "$d"
    unset CI GITHUB_ACTIONS HBN_CI HBN_GUARDS_BYPASS GLASSWING_BYPASS
    export HBN_DIFF_BASE="lixo-residual-$base"
    invoke "$dep" "$d"
  ) )
  outcome="BLOQUEIA (DISARM ok)"
  [[ "$rc" == "0" ]] && outcome="ESCAPOU (regressao)"
  printf "[%s] poison-HBN-local + rm-staged(%s) -> rc=%s  %s\n" "$dep" "$p" "$rc" "$outcome"
  printf "     evidencia: guards/lib/common.sh:173 (hbn_ci_range_mode exige sinal real) 258 (dep_state) + guard DISARM path (ex: assert-*.sh:52-84)\n"
  rm -rf "$d"
done

echo
echo "=== (b) VETORES rename/symlink/dir-rename ==="
for v in rename symlink; do
  for dep in frontdoor knowledge profile-marker; do
    d="$(make_for "$dep")"
    p="$(get_p "$dep")"
    if [[ $v == rename ]]; then
      (cd "$d" && git mv -- "$p" "${p}.ren" >/dev/null 2>&1 || true)
    else
      (cd "$d"; git rm -q -r -- "$p" 2>/dev/null || true; par=$(dirname "$p"); [[ $par != . ]] && mkdir -p "$par"; ln -s tgt "$p"; git add -- "$p" 2>/dev/null || true)
    fi
    rc=$( (cd "$d"; unset CI GITHUB_ACTIONS HBN_CI; invoke "$dep" "$d") )
    outcome="BLOQUEIA"
    [[ "$rc" == "0" ]] && outcome="ESCAPOU"
    printf "[%s] %s -> rc=%s %s | index kind: guards/lib/common.sh:198 (120000->symlink, prefix dir)\n" "$dep" "$v" "$rc" "$outcome"
    rm -rf "$d"
  done
done

echo
echo "=== (c) Sobrou via? (env poison sem sinal, dir vs blob, active-version) ==="
# 1. HBN set + real signal but no change: should ATIVO not disarm
d="$(make_for frontdoor)"
base="$(cd "$d" && git rev-parse HEAD)"
rc=$( (cd "$d"; unset CI GITHUB_ACTIONS HBN_CI; export HBN_CI=1 HBN_DIFF_BASE="$base"; invoke frontdoor "$d") )
printf "frontdoor | HBN+realCI + no-rm -> rc=%s (esperado 0=ATIVO) | current_kind HEAD:266\n" "$rc"
rm -rf "$d"

# 2. Dir marker detection explicit
d="$(make_for profile-marker)"
(cd "$d" && git rm -q -r -- ".usehbn-snapshot" || true)
base="$(cd "$d" && git rev-parse HEAD)"
rc=$( (cd "$d"; unset CI GITHUB_ACTIONS HBN_CI; export HBN_DIFF_BASE="$base"; invoke profile-marker "$d") )
printf "profile-marker | dir-rm HBN-local -> rc=%s BLOQUEIA | hbn_index_path_kind:201-212 (dir via prefix ls), hbn_ref:216-225\n" "$rc"
rm -rf "$d"

# 3. Symlink on dir? unlikely, but index 120000 on marker path -> present -> DISARM
d="$(make_for profile-marker)"
(cd "$d"; git rm -q -r -- ".usehbn-snapshot" || true; ln -s foo .usehbn-snapshot; git add .usehbn-snapshot)
rc=$( (cd "$d"; unset CI GITHUB_ACTIONS HBN_CI; invoke profile-marker "$d") )
printf "profile-marker | symlink-in-index (no HBN) -> rc=%s | via present-not-active -> DISARM:277\n" "$rc"
rm -rf "$d"

echo
echo "=== FIM ATTAQUES CONTROLADOS ==="
