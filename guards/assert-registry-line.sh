#!/usr/bin/env bash
# =============================================================================
# guards/assert-registry-line.sh
# Guarda G-REG: dá dente ao ADR-011.
#   (1) Recusa commit que ADICIONE artefato de tipo numerado (ADR-011 Decisão 2)
#       sem a linha correspondente no REGISTRY.md no MESMO commit.
#   (2) Recusa commit que ADICIONE prompt/doc solto na raiz do canônico sem
#       id AAAAMMDD-NN (o anti-padrão dos PROMPT_*.md órfãos de 2026-06-10,
#       criados por orquestrador ignorando a regra que ele mesmo deveria servir).
#
# status: proposed (corrente D, 2026-06-10) — NÃO está no runner.
#   Ativação = 1 linha em hbn-guards-runner.sh, APÓS hearback de Maurício.
# Padrão C3: usa guard_diff_files (staged local; HBN_DIFF_BASE...HEAD em CI).
# Knowledge 0021: em sandbox o guard é informativo; conclusivo no Terminal.
# Escopo: só arquivos ADICIONADOS (diff-filter=A). Tocar arquivo legado
#   existente não dispara — o legado é mapeado pela seção "Legado" do REGISTRY.
# ADR-020 (anti-teatro, corrente E):
#   (a) casamento de path no REGISTRY é EXATO por coluna de tabela (| path |),
#       nunca substring (bug F-02 da auditoria 0022 — 'ADR-01' casava 'ADR-011');
#       consequência: artefato novo exige a SUA linha, 1 artefato por linha;
#   (b) cobertura ampliada: core/*.md, .hbn/models/*.json, .github/workflows/*
#       (bug F-01 da auditoria 0021 — spec-core novo passava sem REGISTRY);
#   (c) órfãos também em docs/prompts/ (F-04 marginal da 0022).
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-registry-line"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
REGISTRY="REGISTRY.md"

# Só arquivos ADICIONADOS neste diff (não M/R: histórico tocado não re-paga).
guard_added_files() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git diff --name-only --diff-filter=A "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
    else
        git diff --cached --name-only --diff-filter=A 2>/dev/null || true
    fi
}

ADDED="$(guard_added_files)"
if [[ -z "$ADDED" ]]; then
    guard_ok "Nenhum arquivo novo no diff."
    exit 0
fi

ALL_CHANGED="$(guard_diff_files)"

# --- Regra 1: tipo numerado (ADR-011 Decisão 2) exige linha no REGISTRY -----
# Padrões de path que caracterizam artefato numerado:
is_numbered_artifact() {
    local f="$1"
    case "$f" in
        methodology/adr/ADR-[0-9]*) return 0 ;;
        .hbn/knowledge/[0-9][0-9][0-9][0-9]-*) return 0 ;;
        .hbn/readbacks/[0-9][0-9][0-9][0-9]-*) return 0 ;;
        .hbn/hearbacks/[0-9][0-9][0-9][0-9]-*) return 0 ;;
        .hbn/proposals/[0-9][0-9][0-9][0-9]-*) return 0 ;;
        .hbn/results/[0-9][0-9][0-9][0-9]-*) return 0 ;;
        .hbn/messages/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]*) return 0 ;;
        reports/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]-*) return 0 ;;
        inbox/*/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]-*) return 0 ;;
        docs/prompts/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]-*) return 0 ;;
        schemas/*.schema.json) return 0 ;;
        guards/*.sh) return 0 ;;
        core/*.md) return 0 ;;
        .hbn/models/*.json) return 0 ;;
        .github/workflows/*) return 0 ;;
    esac
    # Qualquer arquivo já nomeado com id global em qualquer pasta:
    if [[ "$(basename "$f")" =~ ^[0-9]{8}-[0-9]{2}- ]]; then
        return 0
    fi
    return 1
}

# Casamento EXATO: o path precisa ser uma coluna inteira da tabela do
# REGISTRY (| <path> |) — substring NÃO conta (ADR-020; bug F-02).
registry_has_exact() {
    local f="$1" esc
    esc="$(printf '%s' "$f" | sed 's/[][\.^$*+?(){}|]/\\&/g')"
    grep -qE "\|[[:space:]]*${esc}[[:space:]]*\|" "${REPO_ROOT}/${REGISTRY}"
}

FAIL=0
while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    if is_numbered_artifact "$f"; then
        # REGISTRY precisa estar no mesmo diff E conter o path como coluna exata.
        if ! grep -qxF "$REGISTRY" <<< "$ALL_CHANGED"; then
            guard_fail "Artefato governado novo '${f}' sem ${REGISTRY} no mesmo commit (ADR-011 Decisão 4: linha de nascimento no mesmo commit do depósito)."
            FAIL=1
        elif ! registry_has_exact "$f"; then
            guard_fail "Artefato governado novo '${f}' não aparece como coluna exata (| path |) em nenhuma linha do ${REGISTRY} (ADR-011 Decisão 4 + ADR-020: substring não conta)."
            FAIL=1
        fi
    fi
done <<< "$ADDED"

# --- Regra 2: órfão na raiz — doc/prompt novo na raiz sem id AAAAMMDD-NN ----
# Nomes estáveis permitidos na raiz (endereços, não eventos — ADR-011 Decisão 2):
ROOT_ALLOWLIST="README.md CHANGELOG.md REGISTRY.md AGENTS.md CLAUDE.md CONTRIBUTING.md GOVERNANCE.md MAINTAINERS.md SECURITY.md SUPPORT.md CODE_OF_CONDUCT.md LICENSE ROADMAP.md"

while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    # docs/prompts/ também não aceita prompt sem id (ADR-011 Decisão 2; ADR-020)
    if [[ "$f" == docs/prompts/*.md ]]; then
        if [[ ! "$(basename "$f")" =~ ^[0-9]{8}-[0-9]{2}- ]]; then
            guard_fail "Prompt órfão em docs/prompts/: '${f}' sem id AAAAMMDD-NN (ADR-011 Decisão 2)."
            FAIL=1
        fi
        continue
    fi
    # só raiz (sem "/" no path) e só .md
    [[ "$f" == */* ]] && continue
    [[ "$f" != *.md ]] && continue
    if grep -qw "$f" <<< "$ROOT_ALLOWLIST"; then
        continue
    fi
    if [[ ! "$f" =~ ^[0-9]{8}-[0-9]{2}- ]]; then
        guard_fail "Doc/prompt órfão na raiz: '${f}' sem id AAAAMMDD-NN (ADR-011 Decisão 1). Deposite como AAAAMMDD-NN-<tipo>-<slug>.md ou em docs/prompts/."
        FAIL=1
    fi
done <<< "$ADDED"

if [[ "$FAIL" -ne 0 ]]; then
    exit 1
fi

guard_ok "Todo artefato numerado novo tem linha no REGISTRY; nenhum órfão na raiz."
exit 0
