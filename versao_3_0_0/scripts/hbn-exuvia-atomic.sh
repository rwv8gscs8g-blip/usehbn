#!/usr/bin/env bash
# =============================================================================
# scripts/hbn-exuvia-atomic.sh — rito ATOMICO de exuvia (v3.0.0, TAREFA 5)
#
# Garante que uma exuvia ocorra como TRANSICAO ATOMICA DE COMMIT UNICO:
#   criar versao_N+1 a partir da quente -> validar em SANDBOX descartavel ->
#   preparar staging completo (pasta nova + flip do ponteiro + congelamento
#   da anterior) -> PARAR. O commit e ato exclusivo do operador humano, com
#   hearback confirmado (G-HOT-WRITE valida a autorizacao no chokepoint).
#
# Nunca mais um "proposto" pendurado: ou a preparacao termina inteira e
# verde (1 commit pendente), ou TUDO e restaurado ao estado inicial.
#
# Uso:
#   bash scripts/hbn-exuvia-atomic.sh --new versao_4_0_0 [--repo <path>] [--dry-run]
#
# Modos:
#   --dry-run  (default) monta a sandbox, valida e RELATA; nao toca o repo real.
#   --prepare  apos sandbox verde, prepara a working tree real + staging e PARA.
#
# Fail-closed: qualquer falha em qualquer passo => rollback da preparacao
# (a sandbox e sempre descartada). Sem commit automatico JAMAIS.
# =============================================================================
set -euo pipefail
export LC_ALL=C

MODE="--dry-run"
REPO=""
NEW_REL=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run|--prepare) MODE="$1" ;;
        --new) NEW_REL="${2:-}"; shift ;;
        --repo) REPO="${2:-}"; shift ;;
        *) echo "arg desconhecido: $1" >&2; exit 2 ;;
    esac
    shift
done

log()  { echo "[hbn-exuvia-atomic] $*" >&2; }
die()  { echo "[hbn-exuvia-atomic] ✗ ABORTADO: $*" >&2; exit 1; }

[[ -n "$NEW_REL" ]] || die "informe --new versao_X_Y_Z"
[[ "$NEW_REL" =~ ^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+$ ]] || die "nome invalido de versao: ${NEW_REL}"

REPO="${REPO:-$(git rev-parse --show-toplevel 2>/dev/null || true)}"
[[ -n "$REPO" && -d "$REPO/.git" ]] || die "repo git nao resolvido (use --repo)"
cd "$REPO"

# --- Preflight ----------------------------------------------------------------
POINTER=".hbn/active-version"
[[ -r "$POINTER" ]] || die "${POINTER} ausente"
OLD_REL="$(grep -v '^[[:space:]]*#' "$POINTER" | grep -v '^[[:space:]]*$' | head -1 | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
[[ -n "$OLD_REL" ]] || die "ponteiro vazio"
if [[ "$OLD_REL" != "." ]]; then
    [[ "$OLD_REL" =~ ^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+$ ]] || die "ponteiro invalido: ${OLD_REL}"
    [[ -d "$OLD_REL" ]] || die "versao ativa inexistente no disco: ${OLD_REL}"
fi
[[ "$OLD_REL" != "$NEW_REL" ]] || die "nova versao == versao ativa (${NEW_REL})"
[[ ! -e "$NEW_REL" ]] || die "diretorio ${NEW_REL} ja existe — exuvia pendente? Resolva antes (G-NO-PENDING-EXUVIA)."

if ! git diff --cached --quiet 2>/dev/null; then
    die "indice nao esta limpo — exuvia exige staging vazio no inicio (transicao atomica de commit unico)."
fi

if [[ "$OLD_REL" == "." ]]; then
    HOT_GUARDS="guards"
    HOT_ROOT="."
else
    HOT_GUARDS="${OLD_REL}/guards"
    HOT_ROOT="$OLD_REL"
fi
[[ -d "$HOT_GUARDS" ]] || die "guards da versao ativa ausentes: ${HOT_GUARDS}"

HEAD_SHA="$(git rev-parse --short HEAD)"
log "repo=${REPO} HEAD=${HEAD_SHA} ativa=${OLD_REL} nova=${NEW_REL} modo=${MODE}"

# --- Sandbox: monta o NOVO estado num clone descartavel e valida ---------------
SANDBOX="$(mktemp -d "${TMPDIR:-/tmp}/hbn-exuvia-${NEW_REL}.XXXXXX")"
cleanup_sandbox() { rm -rf "$SANDBOX" 2>/dev/null || true; }
trap cleanup_sandbox EXIT INT TERM

log "sandbox: ${SANDBOX}"
git clone -q --no-hardlinks "$REPO" "$SANDBOX/repo"
(
    set -euo pipefail
    cd "$SANDBOX/repo"
    git config user.email "exuvia-sandbox@hbn.local"
    git config user.name "hbn-exuvia-sandbox"

    # 1. Nova versao nasce como copia da quente (a curadoria de conteudo e da
    #    onda de genese; o rito garante a ATOMICIDADE, nao o conteudo).
    mkdir -p "$NEW_REL"
    if [[ "$OLD_REL" == "." ]]; then
        for entry in guards core schemas scripts docs .hbn BOOT.md REGISTRY.md LICENSE; do
            [[ -e "$entry" ]] && cp -R "$entry" "$NEW_REL/" || true
        done
    else
        cp -R "$OLD_REL"/. "$NEW_REL"/
    fi

    # 2. Flip do ponteiro (mesma transacao).
    printf '%s\n' "$NEW_REL" > .hbn/active-version

    # 3. Congela a versao de saida no BOOT (status: congelado, glacier).
    if [[ "$OLD_REL" != "." && -f "$OLD_REL/BOOT.md" ]]; then
        python3 - "$OLD_REL/BOOT.md" <<'PY'
import sys
path = sys.argv[1]
lines = open(path, encoding="utf-8").read().splitlines(keepends=True)
out = []
in_fm = False
done_status = False
done_temp = False
for i, line in enumerate(lines):
    if i == 0 and line.strip() == "---":
        in_fm = True
        out.append(line)
        continue
    if in_fm and line.strip() == "---":
        in_fm = False
        out.append(line)
        continue
    if in_fm and line.startswith("status:"):
        out.append("status: congelado\n"); done_status = True; continue
    if in_fm and line.startswith("temperatura:"):
        out.append("temperatura: glacier\n"); done_temp = True; continue
    out.append(line)
open(path, "w", encoding="utf-8").writelines(out)
PY
    fi

    git add -A

    # 4. Bateria de validacao no estado SIMULADO (indice staged):
    log()  { echo "[hbn-exuvia-atomic/sandbox] $*" >&2; }
    log "rodando suite de testes da nova versao..."
    if [[ -f "$NEW_REL/guards/tests/run-guard-tests.sh" ]]; then
        bash "$NEW_REL/guards/tests/run-guard-tests.sh" >/dev/null 2>&1 \
            || { echo "SUITE-VERMELHA" >&2; exit 1; }
    else
        echo "sem suite em $NEW_REL/guards/tests — exuvia sem prova nao passa." >&2
        exit 1
    fi

    log "validando guards estruturais da transicao (hot-write / pending / active-integrity)..."
    # G-HOT-WRITE deve reconhecer o modo exuvia; sem autorizacao ele DEVE
    # bloquear (fail-closed) — o que provamos aqui e que ele DISPARA, nao
    # que passa. A autorizacao real vem do hearback humano no repo real.
    set +e
    bash "$NEW_REL/guards/assert-only-hot-version-writable.sh" >/dev/null 2>&1
    rc_hot=$?
    set -e
    if [[ "$rc_hot" -eq 0 ]]; then
        echo "AVISO: G-HOT-WRITE passou sem autorizacao staged (ha hearback herdado no clone?)." >&2
    else
        log "G-HOT-WRITE bloqueou a transicao sem hearback (comportamento fail-closed correto)."
    fi
) || {
    die "validacao em sandbox FALHOU — estado inicial do repo real intacto (nada foi tocado). Sandbox descartada."
}
log "sandbox VERDE."

if [[ "$MODE" == "--dry-run" ]]; then
    log "DRY-RUN concluido: nada escrito no repo real. Rode com --prepare para preparar a transicao."
    exit 0
fi

# --- Preparacao no repo REAL (com rollback em falha; SEM commit) ---------------
ROLLBACK_NEEDED=0
rollback() {
    [[ "$ROLLBACK_NEEDED" -eq 1 ]] || return 0
    log "ROLLBACK: restaurando estado inicial..."
    git reset -q HEAD -- . 2>/dev/null || true
    git checkout -q -- "$POINTER" 2>/dev/null || true
    [[ "$OLD_REL" != "." ]] && git checkout -q -- "$OLD_REL/BOOT.md" 2>/dev/null || true
    rm -rf "$NEW_REL"
    log "ROLLBACK concluido (HEAD ${HEAD_SHA} preservado)."
}
trap 'rollback; cleanup_sandbox' EXIT INT TERM
ROLLBACK_NEEDED=1

log "preparando transicao no repo real (staging, sem commit)..."
mkdir -p "$NEW_REL"
if [[ "$OLD_REL" == "." ]]; then
    for entry in guards core schemas scripts docs .hbn BOOT.md REGISTRY.md LICENSE; do
        [[ -e "$entry" ]] && cp -R "$entry" "$NEW_REL/" || true
    done
else
    cp -R "$OLD_REL"/. "$NEW_REL"/
fi
printf '%s\n' "$NEW_REL" > "$POINTER"
if [[ "$OLD_REL" != "." && -f "$OLD_REL/BOOT.md" ]]; then
    python3 - "$OLD_REL/BOOT.md" <<'PY'
import sys
path = sys.argv[1]
lines = open(path, encoding="utf-8").read().splitlines(keepends=True)
out = []
in_fm = False
for i, line in enumerate(lines):
    if i == 0 and line.strip() == "---":
        in_fm = True; out.append(line); continue
    if in_fm and line.strip() == "---":
        in_fm = False; out.append(line); continue
    if in_fm and line.startswith("status:"):
        out.append("status: congelado\n"); continue
    if in_fm and line.startswith("temperatura:"):
        out.append("temperatura: glacier\n"); continue
    out.append(line)
open(path, "w", encoding="utf-8").writelines(out)
PY
fi

git add -A -- "$NEW_REL" "$POINTER"
[[ "$OLD_REL" != "." ]] && git add -- "$OLD_REL/BOOT.md"

ROLLBACK_NEEDED=0
trap cleanup_sandbox EXIT INT TERM

log "PREPARACAO CONCLUIDA. NADA FOI COMMITADO."
cat >&2 <<EOF

  Proximos passos (SO O OPERADOR HUMANO, na ordem):
  1. Gate humano deposita hearback confirmado cobrindo
     {tipo: hot-write-exuvia, from: ${OLD_REL}, to: ${NEW_REL}}
     em commit PURO anterior (G-HRB) e referencia-o no STATE staged de
     ${NEW_REL}/.hbn/relay/STATE.md (marcador hot-write-exuvia + hearback_ref).
  2. Auditoria cruzada >=2 familias com APROVA em .hbn/results/.
  3. hbn-verify / runner verde.
  4. UM commit unico com os 3 trailers HBN — a exuvia inteira numa transacao.

  Rollback manual (se desistir): git reset HEAD -- . && git checkout -- ${POINTER} && rm -rf ${NEW_REL}
EOF
exit 0
