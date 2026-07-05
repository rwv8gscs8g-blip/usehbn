#!/usr/bin/env bash
# =============================================================================
# guards/hbn-guards-runner.sh
# Orquestra todos os guards na ordem correta. Chamado pelo .git/hooks/pre-commit.
# Cada guard é independente e falha cedo (fail-fast). Logs claros.
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARD_NAME="hbn-guards-runner"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if [[ -t 1 ]]; then
    C_BOLD=$'\033[1m'
    C_DIM=$'\033[2m'
    C_END=$'\033[0m'
else
    C_BOLD="" ; C_DIM="" ; C_END=""
fi

echo "${C_BOLD}[hbn-guards] Iniciando bateria de guards de governança…${C_END}" >&2

if [[ "${1:-}" == "--commit-msg" ]]; then
    MSG_FILE="${2:-}"
    if [[ -z "$MSG_FILE" || ! -f "$MSG_FILE" ]]; then
        guard_fail "Uso: hbn-guards-runner.sh --commit-msg <arquivo-da-mensagem>."
        exit 1
    fi
    COMMIT_MSG_GUARDS=(
        "assert-baton-token.sh"
        "assert-exception-traceable.sh"
        "assert-trailers-contiguous.sh"
    )
    OVERALL=0
    for g in "${COMMIT_MSG_GUARDS[@]}"; do
        echo "${C_DIM}---${C_END}" >&2
        if bash "${SCRIPT_DIR}/${g}" "$MSG_FILE"; then
            :
        else
            rc=$?
            OVERALL=$rc
            break
        fi
    done
    echo "${C_DIM}---${C_END}" >&2
    if [[ $OVERALL -eq 0 ]]; then
        echo "${C_BOLD}[hbn-guards] Guards de commit-msg passaram.${C_END}" >&2
    else
        echo "${C_BOLD}[hbn-guards] Guards de commit-msg FALHARAM (código $OVERALL).${C_END}" >&2
    fi
    exit $OVERALL
elif [[ $# -gt 0 ]]; then
    guard_fail "Uso: hbn-guards-runner.sh [--commit-msg <arquivo-da-mensagem>]."
    exit 1
fi

ACTIVE_ROOT="$(get_canonical_root || true)"
if [[ -z "$ACTIVE_ROOT" ]]; then
    guard_fail "Versão ativa inválida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Enforcement bloqueado até resolução explícita."
    exit 1
fi
RUNNER_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd -P)"
if [[ "$RUNNER_ROOT" != "$ACTIVE_ROOT" ]]; then
    guard_fail "Runner invocado fora da versão ativa. runner=${RUNNER_ROOT}; ativa=${ACTIVE_ROOT}. Use o shim de .git/hooks ou repare .hbn/active-version."
    exit 1
fi
if ! guard_check_hooks_current; then
    echo "${C_BOLD}[hbn-guards] Pre-flight de hooks FALHOU.${C_END}" >&2
    exit 1
fi

# Ordem importa: raiz canônica primeiro (se errada, nada do resto faz sentido).
# ATIVAÇÃO 2026-06-11 (readback 0005, ordem Maurício): G-SLF/G-REG/G-NUM/
# G-PTR/G-RLT entram no runner. Pré-condição do STATE paga: a suíte ganhou a
# seção "guards legados" (testes negativos dos 5 legados) — 75/75 verde.
# G-STR fica FORA por desenho (recebe a atribuição por argumento, não por diff).
# ONDA 0006 (readback 0006, I-08): entram G-FAM e G-HRB em modo runner
# (sem argumento): implementador ∉ auditores no STATE staged; hearback
# staged junto com obra = BLOCK; assinatura SSH quando houver chave em
# .hbn/operators/. G-EXC (exceção rastreável) entra no commit I-09, junto
# com o 4º sinal no STATE (ver header do assert-exception-traceable.sh).
# TERCEIRA EXUVIA (v3.0.0): G-HOT-WRITE roda PRIMEIRO — a versao quente ativa
# e a unica superficie de escrita (relatorio critico 20260705-001142, L3).
# AUTO-PROTECAO DO RUNNER: se o script do G-HOT-WRITE nao existe ao lado do
# runner, o commit e abortado — remover o guard desarma a contencao inteira.
if [[ ! -f "${SCRIPT_DIR}/assert-only-hot-version-writable.sh" ]]; then
    guard_fail "assert-only-hot-version-writable.sh AUSENTE em ${SCRIPT_DIR} — desarme do G-HOT-WRITE detectado. Commit abortado (fail-closed)."
    exit 1
fi

GUARDS=(
    "assert-only-hot-version-writable.sh"
    "assert-no-pending-exuvia.sh"
    "assert-active-version-integrity.sh"
    "assert-canonical-root.sh"
    "forbid-tmp-worktree.sh"
    "forbid-env-files.sh"
    "forbid-legacy-paths.sh"
    "assert-scratch-lock.sh"
    "assert-scratch-symlink.sh"
    "assert-scratch-ignore.sh"
    "assert-scope-lock.sh"
    "assert-zona-livre.sh"
    "assert-readlist-rite.sh"
    "assert-orq-entrada.sh"
    "validate-dispatch.sh"
    "assert-dispatch-integrity.sh"
    "assert-orq-entrada-ref.sh"
    "assert-self-path.sh"
    "assert-registry-line.sh"
    "assert-arvore-label.sh"
    "assert-auditor-id.sh"
    "assert-audit-diversity.sh"
    "assert-quorum-selagem.sh"
    "assert-parallel-id.sh"
    "assert-pointer-honest.sh"
    "assert-copy-block.sh"
    "assert-next-checkpoint.sh"
    "assert-state-structural.sh"
    "assert-knowledge-index.sh"
    "assert-frontdoor.sh"
    "assert-ci-battery.sh"
    "assert-report-fresh.sh"
    "assert-no-stray-hbn.sh"
    "assert-role-family.sh"
    "assert-hearback-integrity.sh"
    "assert-exception-traceable.sh"
)

if hbn_ci_range_mode; then
    GUARDS+=("assert-trailers-contiguous.sh")
fi

OVERALL=0
for g in "${GUARDS[@]}"; do
    echo "${C_DIM}---${C_END}" >&2
    if bash "${SCRIPT_DIR}/${g}"; then
        :
    else
        rc=$?
        OVERALL=$rc
        # Para nos primeiros erros para feedback rápido
        break
    fi
done

echo "${C_DIM}---${C_END}" >&2
if [[ $OVERALL -eq 0 ]]; then
    echo "${C_BOLD}[hbn-guards] Todos os guards passaram.${C_END}" >&2
else
    echo "${C_BOLD}[hbn-guards] Guards FALHARAM (código $OVERALL).${C_END}" >&2
fi
exit $OVERALL
