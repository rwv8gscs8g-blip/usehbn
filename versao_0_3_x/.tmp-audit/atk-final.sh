#!/usr/bin/env bash
set -euo pipefail
cd /Users/macbookpro/Projetos/usehbn

# Use ONLY paths inside cwd for temp git repos to respect sandbox write limit
ATK_ROOT="$PWD/.tmp-audit/attacks"
rm -rf "$ATK_ROOT"
mkdir -p "$ATK_ROOT"

export GIT_TEMPLATE_DIR=/dev/null
export GIT_CONFIG_NOSYSTEM=1

source guards/lib/common.sh
GUARDS_DIR="guards"

echo "=== (a) REPRODUCAO DO FURO PRINCIPAL (meu parecer anterior 20260704-221500) ==="
echo "HBN_DIFF_BASE residual em pre-commit LOCAL (sem HBN_CI/GITHUB_ACTIONS/CI real) + rm staged das 6 deps"
echo "Deve agora: DISARM + BLOQUEIO nos 6 guards"
echo "Evidencia: guards/lib/common.sh:173-182 (hbn_ci_range_mode), 258-287 (hbn_context_dep_state)"
echo

atk_dir() { echo "$ATK_ROOT/atk-$1"; }

seed_common() {
  local d="$1"
  mkdir -p "$d/.hbn" "$d/.hbn/knowledge" "$d/.hbn/relay" "$d/.hbn/readbacks" "$d/.hbn/models" \
    "$d/.usehbn-snapshot/guards" "$d/core" "$d/.github/workflows" "$d/guards"
  echo "." > "$d/.hbn/active-version"
  (cd "$d"; git init -q --initial-branch=main . )
}

do_commit() { (cd "$1"; git add -A 2>/dev/null; git commit -qm "${2:-s}" 2>/dev/null ); }

setup_dep() {
  local dep="$1"; local d; d="$(atk_dir "$dep")"; rm -rf "$d"; mkdir -p "$d"
  seed_common "$d"
  case "$dep" in
    state)
      cat >"$d/.hbn/relay/STATE.md" <<E
---
atribuicao:
  implementador: grok
  auditores: [antigravity]
sinais_abertos: []
E
      do_commit "$d" seed-state
      ;;
    knowledge)
      echo '|t|' >"$d/.hbn/knowledge/INDEX.md"; echo d >"$d/.hbn/knowledge/d.md"
      do_commit "$d" seed-k
      ;;
    frontdoor)
      cat >"$d/core/role-cards.md" <<EOR
## PARTE A - READ-LIST DA PORTA DA FRENTE
1. core/read-list-canonica.txt
EOR
      echo c >"$d/core/read-list-canonica.txt"
      do_commit "$d" seed-f
      ;;
    ci)
      cat >"$d/.github/workflows/hbn-shield.yml" <<EOW
name: h
on: [p]
jobs: {s: {runs-on: u, steps: [{run: 'bash guards/ci-entry.sh'}]}}
EOW
      cat >"$d/guards/ci-entry.sh" <<'E'
#!/bin/sh
set -e; export HBN_CI=1; echo ok
E
      chmod +x "$d/guards/ci-entry.sh"
      do_commit "$d" seed-ci
      ;;
    profile-root)
      echo p >"$d/CONSUMER-PROFILE.md"
      do_commit "$d" seed-pr
      ;;
    profile-marker)
      echo p >"$d/CONSUMER-PROFILE.md"
      mkdir -p "$d/.usehbn-snapshot/guards"; echo k>"$d/.usehbn-snapshot/guards/.keep"
      do_commit "$d" seed-pm
      ;;
  esac
  echo "$d"
}

p_of() { case $1 in
  state).hbn/relay/STATE.md;; knowledge).hbn/knowledge/INDEX.md;;
  frontdoor)core/role-cards.md;; ci).github/workflows/hbn-shield.yml;;
  profile-root)CONSUMER-PROFILE.md;; profile-marker).usehbn-snapshot;; esac; }

call_guard() {
  local dep=$1 d=$2
  case $dep in
    state)(cd "$d"&&bash "$GUARDS_DIR/assert-role-family.sh" >/dev/null 2>&1);echo $?;;
    knowledge)(cd "$d"&&bash "$GUARDS_DIR/assert-knowledge-index.sh" >/dev/null 2>&1);echo $?;;
    frontdoor)(cd "$d"&&bash "$GUARDS_DIR/assert-frontdoor.sh" >/dev/null 2>&1);echo $?;;
    ci)(cd "$d"&&bash "$GUARDS_DIR/assert-ci-battery.sh" >/dev/null 2>&1);echo $?;;
    profile-*)(cd "$d"&&HBN_PROFILE_SNAPSHOT_GUARDS_DIR="$GUARDS_DIR" bash "$GUARDS_DIR/assert-profile-authorized.sh" >/dev/null 2>&1);echo $?;;
  esac
}

echo "=== (a) main furo reproduction ==="
for dep in state knowledge frontdoor ci profile-root profile-marker; do
  d=$(setup_dep "$dep")
  p=$(p_of "$dep")
  (cd "$d" && git rm -q -r -- "$p" 2>/dev/null || git rm -q --cached -r -- "$p" 2>/dev/null || true)
  base=$(cd "$d" && git rev-parse HEAD)
  rc=$( (cd "$d"; unset CI GITHUB_ACTIONS HBN_CI; export HBN_DIFF_BASE="lixo-$base"; call_guard "$dep" "$d") )
  out="BLOQUEIA"
  [ "$rc" = "0" ] && out="ESCAPOU"
  echo "$dep: HBN-residual-local + staged-rm($p) rc=$rc $out"
  echo "  file:line common.sh:173 hbn_ci_range_mode; 258 dep_state; ${dep}-guard DISARM check"
  rm -rf "$d"
done

echo
echo "=== (b) rename, symlink, active-version dir marker ==="
for dep in frontdoor knowledge profile-marker; do
  d=$(setup_dep "$dep"); p=$(p_of "$dep")
  # rename
  (cd "$d" && git mv -- "$p" "${p}.r" 2>/dev/null || true)
  rc=$( (cd "$d"; unset CI GITHUB_ACTIONS HBN_CI; call_guard "$dep" "$d") )
  out="BLOQUEIA"; [ "$rc" = "0" ] && out="ESCAPOU"
  echo "$dep rename: rc=$rc $out (old path ausente no index -> base HEAD tem -> DISARM)"
  rm -rf "$d"

  d=$(setup_dep "$dep"); p=$(p_of "$dep")
  # symlink 120000
  (cd "$d"; git rm -q -r -- "$p" 2>/dev/null||true; par=$(dirname "$p"); [ "$par" != . ] && mkdir -p "$par"; ln -s TGT "$p"; git add -- "$p" 2>/dev/null||true )
  rc=$( (cd "$d"; unset CI GITHUB_ACTIONS HBN_CI; call_guard "$dep" "$d") )
  out="BLOQUEIA"; [ "$rc" = "0" ] && out="ESCAPOU"
  echo "$dep symlink: rc=$rc $out (120000 present-not-active -> DISARM per common.sh:277)"
  rm -rf "$d"
done

echo
echo "=== (c) remaining? ==="
# CI real + HBN + removal (simulate by commit the rm, use range)
d=$(setup_dep "knowledge"); p=$(p_of "knowledge")
(cd "$d" && git rm -q -r -- "$p" && git commit -qm "rm-know" )
base=$(cd "$d" && git rev-parse HEAD~1)
rc=$( (cd "$d"; export HBN_CI=1 HBN_DIFF_BASE="$base"; call_guard "knowledge" "$d") )
out="BLOQUEIA (DISARM no range)"; [ "$rc" = "0" ] && out="nao bloqueou"
echo "knowledge CI-real-range removal: rc=$rc $out  (current HEAD no p, base has -> DISARM)"
rm -rf "$d"

# active version torta + poison (covered in suite too)
d=$(setup_dep "state")
mkdir -p "$d/versao_1_0_0/.hbn/relay"
cp "$d/.hbn/relay/STATE.md" "$d/versao_1_0_0/.hbn/relay/STATE.md"
echo "versao_1_0_0" > "$d/.hbn/active-version"
(cd "$d" && git add -A && git commit -qm "v1" )
(cd "$d" && git rm -q -r -- "versao_1_0_0/.hbn/relay/STATE.md" 2>/dev/null || true)
base=$(cd "$d" && git rev-parse HEAD)
rc=$( (cd "$d"; unset CI GITHUB_ACTIONS HBN_CI; export HBN_DIFF_BASE="$base"; call_guard "state" "$d") )
out="BLOQUEIA"; [ "$rc" = "0" ] && out="ESCAPOU"
echo "state active-version!=. + rm + poison-local: rc=$rc $out"
rm -rf "$d"

echo
echo "=== FIM ==="
rm -rf "$ATK_ROOT"
