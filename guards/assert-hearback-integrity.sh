#!/usr/bin/env bash
# =============================================================================
# guards/assert-hearback-integrity.sh
# path: guards/assert-hearback-integrity.sh · id-global: 20260610-83
# Guarda G-HRB: dá dente ao ADR-023 (integridade de hearback / anti-auto-
# assinatura — responde ao FORTE F-05 da re-auditoria 0026, "Teatro de 3º
# Nível": IA forja hearback confirmed e o commita junto com a violação).
#
# Uso: bash guards/assert-hearback-integrity.sh <hearback-path> [commit-da-mudanca]
#   (commit-da-mudanca default: HEAD — o commit de adoção que CITA o hearback)
#
# Veredicto — o hearback é válido como autorização? Recusa quando:
#   (1) hearback NÃO commitado antes da mudança (staged/untracked não
#       pré-existe a nada — ADR-023 Decisão 1b);
#   (2) hearback nasceu/foi alterado no MESMO commit da mudança
#       (auto-assinatura clássica — caso-ruim canônico do teste negativo);
#   (3) o commit do hearback NÃO é puro: toca arquivos fora de
#       .hbn/hearbacks/ (autorização misturada com obra).
# Critério de autor (autor do hearback = autor da mudança): AVISO, não
#   bloqueio, enquanto o repo usar identidade git única (shell compartilhado
#   — a igualdade é o caso legítimo normal). Elevação a bloqueio quando
#   houver identidades separadas / assinatura GPG-SSH (ADR-023 Decisão 4,
#   backlog). LIMITE HONESTO: a trava lógica é parcial; a barreira final é a
#   revisão humana do diff de .hbn/hearbacks/ (ADR-023 Decisão 3).
#
# status: accepted (corrente E — fechamento, readback 0003, 2026-06-10) — NÃO está no runner.
# Teste negativo: guards/tests/run-guard-tests.sh (seção G-HRB) — ADR-020.
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-hearback-integrity"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

HB="${1:-}"
CHANGE="${2:-HEAD}"

if [[ -z "$HB" ]]; then
    guard_fail "Uso: assert-hearback-integrity.sh <hearback-path> [commit-da-mudanca=HEAD]"
    exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

CHANGE_SHA="$(git rev-parse --verify "${CHANGE}^{commit}" 2>/dev/null || true)"
if [[ -z "$CHANGE_SHA" ]]; then
    guard_fail "Commit da mudança '${CHANGE}' não resolve para um commit."
    exit 1
fi

# (1) O hearback precisa estar COMMITADO no histórico até a mudança.
HB_COMMIT="$(git log -1 --format=%H "$CHANGE_SHA" -- "$HB" 2>/dev/null || true)"
if [[ -z "$HB_COMMIT" ]]; then
    guard_fail "Hearback '${HB}' não existe no histórico até '${CHANGE}' (ADR-023 Decisão 1b: a autorização PRÉ-EXISTE à mudança; hearback staged/untracked não vale)."
    exit 1
fi

# (2) Auto-assinatura: hearback nasceu/foi alterado no MESMO commit da mudança.
if [[ "$HB_COMMIT" == "$CHANGE_SHA" ]]; then
    guard_fail "Hearback '${HB}' nasceu ou foi alterado no MESMO commit da mudança (${CHANGE_SHA:0:7}) — auto-assinatura (ADR-023: hearback é commit SEPARADO, anterior, do humano)."
    exit 1
fi

# (3) Pureza: o commit do hearback toca APENAS .hbn/hearbacks/.
IMPUROS="$(git show --name-only --format= "$HB_COMMIT" | grep -v '^\.hbn/hearbacks/' | grep -v '^$' || true)"
if [[ -n "$IMPUROS" ]]; then
    guard_fail "O commit do hearback (${HB_COMMIT:0:7}) NÃO é puro — toca também: $(echo "$IMPUROS" | tr '\n' ' ')(ADR-023 Decisão 1b: o commit do hearback só pode tocar .hbn/hearbacks/)."
    exit 1
fi

# (autor) Aviso — não bloqueio — enquanto identidade git única (ADR-023 Dec. 2).
A_HB="$(git show -s --format='%an <%ae>' "$HB_COMMIT")"
A_CH="$(git show -s --format='%an <%ae>' "$CHANGE_SHA")"
if [[ "$A_HB" == "$A_CH" ]]; then
    guard_warn "Autor do commit do hearback == autor da mudança (${A_HB}). Em shell compartilhado isto é o caso normal e NÃO distingue humano de IA — trava lógica PARCIAL (ADR-023 Decisão 3). Barreira final: revisão humana do diff de .hbn/hearbacks/. Elevação futura: assinatura GPG/SSH (backlog)."
fi

guard_ok "Hearback '${HB}' íntegro: commit puro ${HB_COMMIT:0:7}, anterior à mudança ${CHANGE_SHA:0:7}."
exit 0
