#!/usr/bin/env bash
# =============================================================================
# guards/tests/adversarial-battery.sh
# path: guards/tests/adversarial-battery.sh · id-global: 20260611-162102-fable5-bateria-adversarial
# BATERIA ADVERSARIAL (onda 0006 I-12 — critério de aceite mecânico da onda,
# ADR-020): tenta CADA burla documentada nos cross-audits 0036/0037 e na
# consolidação 20260611-131310 e EXIGE que o guard correspondente BLOQUEIE.
# Qualquer burla passando = bateria vermelha = onda reprovada.
#
# É também a semente da auditoria Glasswing periódica (desenho §6.4): a cada
# N ondas, uma janela adversarial de família ≠ implementador tenta burlar os
# guards; toda burla nova achada vira linha permanente AQUI.
#
# Uso: bash guards/tests/adversarial-battery.sh   (exit 0 = todas bloqueadas)
# Saída: tabela BURLA × GUARD × RESULTADO.
# =============================================================================
set -uo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARDS_DIR="$(dirname "$TESTS_DIR")"
unset HBN_GUARDS_BYPASS GLASSWING_BYPASS HBN_DIFF_BASE CI GITHUB_ACTIONS 2>/dev/null || true

SUITE_TMP="$(mktemp -d "${TMPDIR:-/tmp}/hbn-adv.XXXXXX")"
export TMPDIR="$SUITE_TMP"
trap 'rm -rf "$SUITE_TMP" "$TESTS_DIR"/adv-cr.* 2>/dev/null || true; true' EXIT INT TERM

FALHAS=0
ROWS=()
try_burla() { # <descricao> <guard> <rc-obtido>  (esperado: rc != 0 = BLOQUEADA)
    local desc="$1" guard="$2" rc="$3" res
    if [[ "$rc" -ne 0 ]]; then
        res="BLOQUEADA ✓"
    else
        res="PASSOU ✗ (FALHA DA ONDA)"
        FALHAS=$((FALHAS + 1))
    fi
    ROWS+=("$(printf '%-52s | %-8s | %s' "$desc" "$guard" "$res")")
}

mk_repo() { # repo git mínimo
    local d; d="$(mktemp -d)"
    ( cd "$d" && git init -q && git config user.email a@b && git config user.name a ) >/dev/null 2>&1
    echo "$d"
}

# B1 — nome SERIAL novo em série de evento (o caso 0036/0037)
d="$(mk_repo)"
( cd "$d" && mkdir -p .hbn/results && echo x > .hbn/results/0099-parecer-burlado.md && git add -A ) >/dev/null 2>&1
try_burla "B1 nome serial novo em .hbn/results/" "G-NUM" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-parallel-id.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B2 — created_at em UTC na linha nova do REGISTRY
d="$(mk_repo)"
( cd "$d" && echo x > nota.md && printf '| id | a | t | T | s | created_at |\n|---|---|---|---|---|---|\n' > REGISTRY.md && git add -A && git commit -qm i \
  && printf '| 20260611-101010-agente-x | nota.md | doc | frio | — | 2026-06-11T10:10:10Z |\n' >> REGISTRY.md && git add REGISTRY.md ) >/dev/null 2>&1
try_burla "B2 created_at UTC (Z) no REGISTRY"            "G-NUM"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-parallel-id.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B3 — CI=true em commit local (o bypass do readback 0005)
d="$(mktemp -d -p "$TESTS_DIR" adv-cr.XXXXXX)"
( cd "$d" && git init -q && mkdir .hbn && pwd -P > .hbn/canonical-root ) >/dev/null 2>&1
try_burla "B3 CI=true local (sem CI real)"               "G-CR"    "$( ( cd "$d" && CI=true bash "$GUARDS_DIR/assert-canonical-root.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B4 — HBN_GUARDS_BYPASS=1 sem nota staged (Glasswing como burla)
d="$(mk_repo)"
( cd "$d" && git commit -q --allow-empty -m i && echo "SECRET=x" > .env && git add .env ) >/dev/null 2>&1
try_burla "B4 bypass env sem nota em .hbn/bypasses/"     "comuns"  "$( ( cd "$d" && HBN_GUARDS_BYPASS=1 bash "$GUARDS_DIR/forbid-env-files.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B5 — .hbn órfão FUNDO (5 níveis; o falso negativo do maxdepth 4)
r="$(mktemp -d)"
mkdir -p "$r/a/b/c/d/.hbn"
try_burla "B5 .hbn órfão a 5 níveis de profundidade"     "G-STRAY" "$( ( HBN_SCAN_ROOT="$r" bash "$GUARDS_DIR/assert-no-stray-hbn.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$r"

# B6 — SYMLINK chamado .hbn (invisível ao find -type d)
r="$(mktemp -d)"
mkdir -p "$r/alvo" "$r/proj" && ln -s "$r/alvo" "$r/proj/.hbn"
try_burla "B6 symlink .hbn órfão"                        "G-STRAY" "$( ( HBN_SCAN_ROOT="$r" bash "$GUARDS_DIR/assert-no-stray-hbn.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$r"

# B7 — esconder .hbn sob pasta 'backups2' (fora da allowlist)
r="$(mktemp -d)"
mkdir -p "$r/backups2/oculto/.hbn"
try_burla "B7 .hbn escondido sob backups2/"              "G-STRAY" "$( ( HBN_SCAN_ROOT="$r" bash "$GUARDS_DIR/assert-no-stray-hbn.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$r"

# B8 — SCAN_ROOT inválido (fail-open virava bypass ambiental)
try_burla "B8 HBN_SCAN_ROOT apontando para o nada"       "G-STRAY" "$( ( HBN_SCAN_ROOT=/nao/existe bash "$GUARDS_DIR/assert-no-stray-hbn.sh" >/dev/null 2>&1 ); echo $? )"

# B9 — scope.files_allowed VAZIO em safe_track (caso readback 0004)
d="$(mk_repo)"
( cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/readbacks docs \
  && printf '{"readback_id":"0001-t","track":"safe_track","human_status":"confirmed","scope":{"files_allowed":[],"files_forbidden":[]}}\n' > .hbn/readbacks/0001-t.json \
  && echo x > docs/x.md && git add docs/x.md ) >/dev/null 2>&1
try_burla "B9 scope vazio em safe_track"                 "G-SCO"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-scope-lock.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B10 — implementador escalado como auditor de si mesmo
d="$(mk_repo)"
( cd "$d" && mkdir -p .hbn/relay \
  && printf -- '---\natribuicao:\n  implementador: ego-1\n  auditores: [ego-1, outro-2]\n---\n' > .hbn/relay/STATE.md \
  && git add -A && git commit -qm i ) >/dev/null 2>&1
try_burla "B10 implementador == auditor (groupthink)"    "G-FAM"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-role-family.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B11 — hearback forjado por IA SEM assinatura, com chave de operador registrada
kd="$(mktemp -d)"
ssh-keygen -q -t ed25519 -N "" -f "$kd/op" >/dev/null 2>&1
mkdir -p "$kd/ops" && cp "$kd/op.pub" "$kd/ops/op.pub"
d="$(mk_repo)"
( cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/hearbacks \
  && printf '{"status":"confirmed","signed_by":"Humano Forjado"}\n' > .hbn/hearbacks/9999-forjado.json \
  && git add .hbn/hearbacks/9999-forjado.json ) >/dev/null 2>&1
try_burla "B11 hearback sem assinatura (chave registrada)" "G-HRB"  "$( ( cd "$d" && HBN_OPERATORS_DIR="$kd/ops" bash "$GUARDS_DIR/assert-hearback-integrity.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d" "$kd"

# B12 — hearback staged JUNTO com a obra que ele autoriza
d="$(mk_repo)"
( cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/hearbacks docs \
  && printf '{"status":"confirmed"}\n' > .hbn/hearbacks/9998-junto.json \
  && echo obra > docs/obra.md && git add -A ) >/dev/null 2>&1
try_burla "B12 hearback no mesmo commit da obra"         "G-HRB"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-hearback-integrity.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B13 — exceção F-01 (impl==agente do readback) SEM os sinais exigidos
d="$(mk_repo)"
( cd "$d" && mkdir -p .hbn/relay .hbn/readbacks \
  && printf '{"readback_id":"0007-t","agent_id":"ego-1","track":"safe_track","human_status":"confirmed"}\n' > .hbn/readbacks/0007-t.json \
  && printf -- '---\nsinais_abertos:\n  - "tudo normal"\natribuicao:\n  implementador: ego-1\n  auditores: [outro-2]\n---\n' > .hbn/relay/STATE.md \
  && git add -A -f && git commit -qm i ) >/dev/null 2>&1
try_burla "B13 exceção impl==agente sem os 4 sinais"     "G-EXC"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-exception-traceable.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B14 — posse forjada: arquivo .git/hbn-baton-token com token ERRADO e
# fingerprint correto copiado do log (G-TOK v2 — replay do fingerprint
# público NÃO abre o hook sem o arquivo de token legítimo)
d="$(mk_repo)"
( cd "$d" && mkdir -p .hbn/relay \
  && HASH_LEGIT="$(printf '%s' token-legitimo | sha256sum | awk '{print $1}')" \
  && printf -- '---\nbastao_token_sha256: %s\n---\n' "$HASH_LEGIT" > .hbn/relay/STATE.md \
  && git add -A && git commit -qm i \
  && printf '%s\n' token-roubado > .git/hbn-baton-token \
  && printf 'feat: x\n\nHBN-Token-FP: %s\n' "$(printf '%s' "$HASH_LEGIT" | cut -c1-8)" > msg.txt ) >/dev/null 2>&1
try_burla "B14 arquivo de token local ERRADO + FP do log" "G-TOK"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-baton-token.sh" "$d/msg.txt" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# --- Saída legível (ADR-022): BURLA × GUARD × RESULTADO ----------------------
echo ""
printf '%-52s | %-8s | %s\n' "BURLA" "GUARD" "RESULTADO"
printf '%.0s-' {1..80}; echo ""
for row in "${ROWS[@]}"; do echo "$row"; done
echo ""
if [[ "$FALHAS" -ne 0 ]]; then
    echo "BATERIA VERMELHA — ${FALHAS} burla(s) PASSARAM. Onda reprovada (ADR-020)."
    exit 1
fi
echo "BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente."
exit 0
