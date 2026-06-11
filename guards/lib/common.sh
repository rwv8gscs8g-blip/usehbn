#!/usr/bin/env bash
# =============================================================================
# guards/lib/common.sh
# Funções comuns aos hbn-guards. NÃO executar isolado — sourceado por scripts.
# =============================================================================

# ANSI colors (degradam graciosamente em terminal sem suporte)
if [[ -t 1 ]]; then
    C_RED=$'\033[0;31m'
    C_GREEN=$'\033[0;32m'
    C_YELLOW=$'\033[0;33m'
    C_BLUE=$'\033[0;34m'
    C_BOLD=$'\033[1m'
    C_DIM=$'\033[2m'
    C_END=$'\033[0m'
else
    C_RED="" ; C_GREEN="" ; C_YELLOW="" ; C_BLUE="" ; C_BOLD="" ; C_DIM="" ; C_END=""
fi

# Identificação do guard que chama (usar no início do script: GUARD_NAME="assert-canonical-root")
GUARD_NAME="${GUARD_NAME:-hbn-guard}"

guard_log() {
    echo "${C_DIM}[hbn-guards/${GUARD_NAME}]${C_END} $*" >&2
}

guard_ok() {
    echo "${C_GREEN}${C_BOLD}[hbn-guards/${GUARD_NAME}] ✓${C_END} $*" >&2
}

guard_warn() {
    echo "${C_YELLOW}${C_BOLD}[hbn-guards/${GUARD_NAME}] ⚠${C_END} $*" >&2
}

guard_fail() {
    echo "" >&2
    echo "${C_RED}${C_BOLD}[hbn-guards/${GUARD_NAME}] ✗ COMMIT BLOQUEADO${C_END}" >&2
    echo "${C_RED}  motivo:${C_END} $*" >&2
    echo "" >&2
}

# Retorna o caminho canônico esperado a partir de .hbn/canonical-root
guard_canonical_root() {
    local repo_root
    repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"
    if [[ -z "$repo_root" ]]; then
        echo ""
        return 1
    fi
    local f="${repo_root}/.hbn/canonical-root"
    if [[ ! -f "$f" ]]; then
        echo ""
        return 1
    fi
    # Lê primeira linha não vazia/não comentário
    grep -v '^\s*#' "$f" | grep -v '^\s*$' | head -1
}

# Bypass de emergência — alinhado com a convenção GLASSWING_BYPASS já existente.
# Parâmetro opcional: nome do guard (usado apenas em logs).
#
# F-10 (onda 0006 I-06, cross-audit 0036 P1 / 0037 P1): a env de bypass só
# surte efeito se houver NOTA ADICIONADA em .hbn/bypasses/ no MESMO diff
# staged (formato <AAAAMMDD-HHMMSS>-<agente>-<motivo>.md). Env sem nota =
# bypass IGNORADO: os guards rodam normalmente, com aviso. Era a ironia
# apontada pelos auditores: o mecanismo da auditoria anti-burla (Glasswing)
# era ele mesmo uma burla silenciosa. CI: nota de bypass sem hearback
# correspondente = achado (auditoria de trailers, runbook).
guard_check_bypass() {
    local name="${1:-${GUARD_NAME:-hbn-guard}}"
    local envname=""
    if [[ "${HBN_GUARDS_BYPASS:-0}" == "1" ]]; then
        envname="HBN_GUARDS_BYPASS"
    elif [[ "${GLASSWING_BYPASS:-0}" == "1" ]]; then
        envname="GLASSWING_BYPASS"
    fi
    [[ -z "$envname" ]] && return 1
    local notes
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        notes="$(git diff --name-only --diff-filter=A "${HBN_DIFF_BASE}...HEAD" 2>/dev/null \
            | grep -E '^\.hbn/bypasses/[0-9]{8}-[0-9]{6}-[A-Za-z0-9._-]+\.md$' || true)"
    else
        notes="$(git diff --cached --name-only --diff-filter=A 2>/dev/null \
            | grep -E '^\.hbn/bypasses/[0-9]{8}-[0-9]{6}-[A-Za-z0-9._-]+\.md$' || true)"
    fi
    if [[ -n "$notes" ]]; then
        guard_warn "BYPASS ATIVO (${envname}=1) em $name COM nota staged: $(echo "$notes" | xargs). Hearback humano obrigatório na adoção; CI cruza nota×hearback."
        return 0
    fi
    guard_warn "${envname}=1 IGNORADO em $name: nenhuma nota ADICIONADA em .hbn/bypasses/<carimbo>-<agente>-<motivo>.md neste diff (F-10, onda 0006). Guards rodam normalmente."
    return 1
}

# Arquivos sob analise: staged (pre-commit local) OU range de CI.
# Em CI, exporte HBN_DIFF_BASE=<sha base> (o Shield faz isso) para validar
# o range pushed em vez do index (vazio em CI).
guard_diff_files() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git diff --name-only --diff-filter=ACMR "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
    else
        git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || true
    fi
}
