#!/usr/bin/env bash
# =============================================================================
# guards/assert-only-hot-version-writable.sh
# G-HOT-WRITE (terceira exuvia, v3.0.0): a versao quente ativa e a UNICA
# superficie de escrita. Fecha a causa-raiz C2/L3 do relatorio critico
# 20260705-001142 (semanas de trabalho na versao errada do genoma).
#
# Regras (fail-closed):
#   1. Le .hbn/active-version (raiz do git). Ponteiro invalido = BLOCK.
#   2. Todo arquivo staged deve comecar com "<versao-ativa>/".
#   3. Allowlist estrita na raiz (metadados vitais, fora da versao):
#        .gitignore                (raiz)
#        .hbn/relay/STATE.md       (relay legado de transicao)
#        .hbn/hearbacks/**         (canal de autorizacao humana; a pureza do
#                                   commit de hearback e defendida pelo G-HRB)
#        .hbn/active-version       (SOMENTE em commit de exuvia — ver regra 4)
#   4. MODO EXUVIA: se o diff staged troca o valor de .hbn/active-version
#      (old != new), o commit e uma transicao de exuvia. Nesse modo:
#        - exige autorizacao humana de transicao: o STATE da versao de entrada
#          (staged) declara o marcador hot-write-exuvia + hearback_ref, e o
#          JSON referenciado (hearback OU readback com human_status=confirmed)
#          cobre a excecao {tipo: hot-write-exuvia, from: <old>, to: <new>};
#        - libera adicionalmente: paths sob qualquer versao_X_Y_Z/ (moves de
#          glacier), DELECOES em qualquer path (esvaziamento da raiz), e os
#          shims de raiz que nascem/mudam SO na transicao: README.md,
#          AGENTS.md (BOOT-LOCK), .hbn/canonical-root, .github/workflows/**
#          (roteamento de CI) e .cursor/** (interceptacao de escrita).
#   5. AUTO-PROTECAO: se o proprio script deste guard (na versao ativa) esta
#      staged para modificacao/exclusao sem a mesma autorizacao de transicao
#      (tipo: hot-write-guard-change cobrindo o path exato), BLOCK.
#   6. Ignora QUALQUER variavel de bypass (HBN_GUARDS_BYPASS, GLASSWING_BYPASS
#      etc.): este guard nao chama guard_check_bypass por desenho.
#
# Caso especial honesto: active-version == "." (consumidores em project-mode)
# nao tem pasta quente separada — o guard registra OK e delega ao perfil do
# consumidor. No genoma pos-exuvia o ponteiro nunca volta a ".".
#
# Posicao no runner: PRIMEIRO guard do pre-commit (antes de qualquer outro).
# Teste negativo: guards/tests/run-guard-tests.sh (secao G-HOT-WRITE).
# =============================================================================
# ---HBN-REQUIRES-BEGIN---
# requires:
#   files:
#     - path: .hbn/active-version
#       install: refuse
#   dirs: []
#   state_fields: []
#   guards: []
#   env: []
# ---HBN-REQUIRES-END---
set -euo pipefail

GUARD_NAME="assert-only-hot-version-writable"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

# Regra 6: bypass NUNCA surte efeito aqui — nem com nota staged.
if [[ "${HBN_GUARDS_BYPASS:-0}" == "1" || "${GLASSWING_BYPASS:-0}" == "1" ]]; then
    guard_warn "Variavel de bypass detectada e IGNORADA: G-HOT-WRITE nao aceita bypass por desenho (terceira exuvia, L3)."
fi

ACTIVE_VERSION_PATH=".hbn/active-version"

trim_value() {
    sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'
}

rel_from_blob() { # <blob-ref> -> valor ou rc!=0
    local ref="$1" raw count value
    if ! raw="$(git show "$ref" 2>/dev/null)"; then
        return 2
    fi
    if grep -qE '^(<<<<<<<|=======|>>>>>>>)' <<< "$raw"; then
        return 3
    fi
    raw="$(printf '%s\n' "$raw" | grep -v '^[[:space:]]*#' | grep -v '^[[:space:]]*$' || true)"
    count="$(printf '%s\n' "$raw" | sed '/^[[:space:]]*$/d' | wc -l | tr -d '[:space:]')"
    [[ "$count" == "1" ]] || return 4
    value="$(printf '%s\n' "$raw" | sed -n '1p' | trim_value)"
    if [[ "$value" != "." && ! "$value" =~ ^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+$ ]]; then
        return 5
    fi
    case "$value" in
        /*|*..*|*//*|*\\*|*" "*|*"	"*) return 6 ;;
    esac
    printf '%s\n' "$value"
}

CURRENT_SOURCE="$(hbn_context_current_source)"
current_blob_ref() { # <repo-path>
    if [[ "$CURRENT_SOURCE" == "HEAD" ]]; then
        printf 'HEAD:%s\n' "$1"
    else
        printf ':%s\n' "$1"
    fi
}

current_path_kind() { # <repo-path>
    if [[ "$CURRENT_SOURCE" == "HEAD" ]]; then
        hbn_ref_path_kind HEAD "$1"
    else
        hbn_index_path_kind "$1"
    fi
}

# Diff em paths BRUTOS do repo (sem strip de prefixo) + status por path.
raw_name_status() {
    if hbn_ci_range_mode; then
        git diff --name-status "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
    else
        git diff --cached --name-status 2>/dev/null || true
    fi
}

# --- Resolucao do ponteiro (novo = o que entra no commit; velho = baseline) --
if [[ "$CURRENT_SOURCE" == "HEAD" ]]; then
    NEW_POINTER_REF="HEAD:${ACTIVE_VERSION_PATH}"
    OLD_POINTER_REF="${HBN_DIFF_BASE}:${ACTIVE_VERSION_PATH}"
else
    NEW_POINTER_REF=":${ACTIVE_VERSION_PATH}"
    OLD_POINTER_REF="HEAD:${ACTIVE_VERSION_PATH}"
fi

set +e
NEW_REL="$(rel_from_blob "$NEW_POINTER_REF")"
NEW_REL_RC=$?
set -e
if [[ "$NEW_REL_RC" -ne 0 ]]; then
    # Ponteiro ausente do indice/HEAD: cai para o disco (genese pre-commit do
    # ponteiro), fail-closed em qualquer invalidez.
    NEW_REL="$(guard_active_version_rel || true)"
    if [[ -z "$NEW_REL" ]]; then
        guard_fail "Ponteiro ${ACTIVE_VERSION_PATH} invalido/ausente (${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}). G-HOT-WRITE falha fechado."
        exit 1
    fi
fi

set +e
OLD_REL="$(rel_from_blob "$OLD_POINTER_REF")"
OLD_REL_RC=$?
set -e
if [[ "$OLD_REL_RC" -ne 0 ]]; then
    OLD_REL=""   # sem baseline (genese do proprio ponteiro)
fi

EXUVIA_MODE=0
if [[ -n "$OLD_REL" && "$OLD_REL" != "$NEW_REL" ]]; then
    EXUVIA_MODE=1
fi

if [[ "$NEW_REL" == "." ]]; then
    guard_ok "active-version='.' (project-mode/incumbente): sem pasta quente separada, G-HOT-WRITE delega ao perfil. No genoma pos-exuvia o ponteiro deve apontar para versao_X_Y_Z."
    exit 0
fi

HOT_PREFIX="${NEW_REL}/"
SELF_REPO_PATH="${HOT_PREFIX}guards/assert-only-hot-version-writable.sh"

# --- Autorizacao humana de transicao (STATE staged + JSON confirmado) --------
authorization_json_covers() { # <json-file> <tipo> <from> <to> [path]
    python3 - "$@" <<'PY'
import json
import sys

path, tipo, old_rel, new_rel = sys.argv[1:5]
extra_path = sys.argv[5] if len(sys.argv) > 5 else ""
try:
    data = json.load(open(path, encoding="utf-8"))
except Exception:
    sys.exit(1)
status = data.get("status") or data.get("human_status")
if status != "confirmed":
    sys.exit(1)
for item in data.get("excecoes_cobertas", []):
    if not isinstance(item, dict):
        continue
    if item.get("tipo") != tipo:
        continue
    f = item.get("from") or item.get("de") or item.get("old") or item.get("saida")
    t = item.get("to") or item.get("para") or item.get("new") or item.get("entrada")
    if f and f != old_rel:
        continue
    if t and t != new_rel:
        continue
    if extra_path:
        paths = item.get("paths") or item.get("dependencias") or []
        if extra_path not in paths:
            continue
    sys.exit(0)
sys.exit(1)
PY
}

state_authorization_ref() { # <state-file> <marker-regex> -> hearback_ref
    python3 - "$1" "$2" <<'PY'
import re
import sys

path, marker = sys.argv[1:3]
text = open(path, encoding="utf-8").read()
lines = text.splitlines()
if not lines or lines[0].strip() != "---":
    sys.exit(1)
end = None
for idx in range(1, len(lines)):
    if lines[idx].strip() == "---":
        end = idx
        break
if end is None:
    sys.exit(1)
front = "\n".join(lines[1:end])
if not re.search(marker, front, re.I):
    sys.exit(1)
match = re.search(r"^\s*hearback_ref\s*:\s*(.+?)\s*$", front, re.M)
if not match:
    sys.exit(1)
value = re.sub(r"\s+#.*$", "", match.group(1)).strip()
if value in {"", "null", "~"}:
    sys.exit(1)
if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
    value = value[1:-1]
print(value)
PY
}

transition_authorized() { # <tipo> [path-extra]
    local tipo="$1" extra="${2:-}" state_repo state_tmp auth_ref auth_repo auth_tmp
    state_repo="${HOT_PREFIX}.hbn/relay/STATE.md"
    hbn_path_kind_active "$(current_path_kind "$state_repo")" || return 1
    state_tmp="$(mktemp)"
    auth_tmp="$(mktemp)"
    # shellcheck disable=SC2064
    trap "rm -f '$state_tmp' '$auth_tmp'" RETURN
    git show "$(current_blob_ref "$state_repo")" > "$state_tmp" 2>/dev/null || return 1
    auth_ref="$(state_authorization_ref "$state_tmp" 'hot[-_]write[-_](exuvia|guard[-_]change)')" || return 1
    case "$auth_ref" in
        /*|*..*|*\\*|"") return 1 ;;
    esac
    auth_repo="${HOT_PREFIX}${auth_ref}"
    if ! hbn_path_kind_active "$(current_path_kind "$auth_repo")"; then
        auth_repo="$auth_ref"   # fallback: ref relativo a raiz do repo
        hbn_path_kind_active "$(current_path_kind "$auth_repo")" || return 1
    fi
    git show "$(current_blob_ref "$auth_repo")" > "$auth_tmp" 2>/dev/null || return 1
    authorization_json_covers "$auth_tmp" "$tipo" "${OLD_REL:-.}" "$NEW_REL" "$extra"
}

# --- Varredura do diff --------------------------------------------------------
STAGED_RAW="$(raw_name_status)"
if [[ -z "$STAGED_RAW" ]]; then
    guard_ok "Sem arquivos staged — nada a validar contra a versao quente (${NEW_REL})."
    exit 0
fi

EXUVIA_AUTHORIZED=""
require_exuvia_authorization() {
    if [[ -z "$EXUVIA_AUTHORIZED" ]]; then
        if transition_authorized "hot-write-exuvia"; then
            EXUVIA_AUTHORIZED="yes"
        else
            EXUVIA_AUTHORIZED="no"
        fi
    fi
    [[ "$EXUVIA_AUTHORIZED" == "yes" ]]
}

if [[ "$EXUVIA_MODE" -eq 1 ]] && ! require_exuvia_authorization; then
    guard_fail "Commit de EXUVIA (${OLD_REL:-?} -> ${NEW_REL}) sem autorizacao humana de transicao: o STATE staged de ${NEW_REL} deve declarar hot-write-exuvia + hearback_ref, e o JSON referenciado (hearback ou readback) deve ter status/human_status=confirmed cobrindo {tipo: hot-write-exuvia, from: ${OLD_REL:-.}, to: ${NEW_REL}}."
    exit 1
fi

is_hearback_path() { # canal de autorizacao humana (pureza defendida pelo G-HRB)
    [[ "$1" =~ ^(versao_[0-9]+_[0-9]+_[A-Za-z0-9]+/)?\.hbn/hearbacks/ ]]
}

is_glacier_version_path() {
    [[ "$1" =~ ^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+/ ]]
}

FAIL=0
VIOLATIONS=()
SELF_TOUCHED=""
while IFS=$'\t' read -r st f extra; do
    [[ -z "${st:-}" || -z "${f:-}" ]] && continue
    # Renames (R100\told\tnew): valida origem E destino.
    paths=("$f")
    [[ -n "${extra:-}" ]] && paths+=("$extra")
    for p in "${paths[@]}"; do
        [[ -z "$p" ]] && continue

        # Origem de rename (R*\torigem\tdestino): equivale a DELECAO da origem.
        # Em modo exuvia (autorizado) os moves de glacier esvaziam a raiz.
        if [[ "$EXUVIA_MODE" -eq 1 && "$st" == R* && -n "${extra:-}" && "$p" == "$f" ]]; then
            continue
        fi

        if [[ "$p" == "$SELF_REPO_PATH" && "$st" != A* ]]; then
            SELF_TOUCHED="$st"
        fi

        # Dentro da versao quente: sempre permitido.
        if [[ "$p" == "$HOT_PREFIX"* ]]; then
            continue
        fi

        # Allowlist estrita da raiz (modo normal e exuvia).
        case "$p" in
            .gitignore|.hbn/relay/STATE.md)
                continue
                ;;
            .hbn/active-version)
                if [[ "$EXUVIA_MODE" -eq 1 ]]; then
                    continue
                fi
                VIOLATIONS+=("[$st] $p  (.hbn/active-version so pode mudar em commit de exuvia autorizado)")
                FAIL=1
                continue
                ;;
        esac

        if is_hearback_path "$p"; then
            continue
        fi

        if [[ "$EXUVIA_MODE" -eq 1 ]]; then
            # Moves de glacier e esvaziamento da raiz, sob autorizacao ja validada.
            if is_glacier_version_path "$p"; then
                continue
            fi
            if [[ "$st" == D* ]]; then
                continue
            fi
            case "$p" in
                README.md|AGENTS.md|.hbn/canonical-root) continue ;;
                .github/workflows/*|.cursor/*) continue ;;
            esac
        fi

        VIOLATIONS+=("[$st] $p")
        FAIL=1
    done
done <<< "$STAGED_RAW"

# --- Auto-protecao (regra 5) --------------------------------------------------
if [[ -n "$SELF_TOUCHED" ]]; then
    if ! transition_authorized "hot-write-guard-change" "guards/assert-only-hot-version-writable.sh"; then
        guard_fail "AUTO-PROTECAO: ${SELF_REPO_PATH} esta staged para alteracao/exclusao (${SELF_TOUCHED}) sem autorizacao humana explicita (STATE com hot-write-guard-change + hearback/readback confirmed cobrindo o path exato). Desarme do G-HOT-WRITE e violacao maxima de contencao."
        exit 1
    fi
    guard_warn "Alteracao do proprio G-HOT-WRITE autorizada por STATE + JSON confirmed (hot-write-guard-change)."
fi

if [[ "$FAIL" -ne 0 ]]; then
    guard_fail "CRITICAL HBN-LOCK: tentativa de escrita fora da versao quente ativa '${NEW_REL}'. Todo desenvolvimento reside estritamente em '${HOT_PREFIX}'. Versoes congeladas (glacier) sao read-only."
    echo "  Paths staged em violacao:" >&2
    for v in "${VIOLATIONS[@]}"; do
        echo "    - $v" >&2
    done
    echo "" >&2
    echo "  Allowlist de raiz: .gitignore | .hbn/relay/STATE.md | .hbn/hearbacks/** | .hbn/active-version (so exuvia autorizada)" >&2
    echo "  Como corrigir: git restore --staged <path> e reescreva o artefato sob ${HOT_PREFIX}" >&2
    exit 1
fi

if [[ "$EXUVIA_MODE" -eq 1 ]]; then
    guard_ok "Commit de EXUVIA autorizado (${OLD_REL:-genese} -> ${NEW_REL}): escrita confinada a versao quente, glacier e allowlist de transicao."
else
    guard_ok "Escrita confinada a versao quente ativa '${NEW_REL}' (+ allowlist estrita de raiz)."
fi
exit 0
