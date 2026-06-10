#!/usr/bin/env bash
# =============================================================================
# guards/assert-self-path.sh
# path: guards/assert-self-path.sh · id-global: 20260610-80
# Guarda G-SLF: dá dente ao ADR-021 (documentos auto-localizáveis).
#   (1) Recusa arquivo novo/renomeado que declara `path:` (front-matter .md ou
#       chave top-level "path" em .json) DIFERENTE do caminho real no repo.
#       Auto-localização mentirosa é pior que nenhuma: manda humano e IA, com
#       confiança, ao lugar errado.
#   (2) Recusa artefato GOVERNADO novo (subconjunto .md da tabela do ADR-011
#       Decisão 2 + hearbacks .json) que NÃO declara `path:`.
#
# status: proposed (corrente E — fechamento, 2026-06-10) — NÃO está no runner.
#   Ativação futura = onda própria (ADR-020 Decisão 2: suíte verde + hearback).
# Padrão C3: guard_diff staged local; HBN_DIFF_BASE...HEAD em CI.
# Escopo: arquivos ADICIONADOS/RENOMEADOS (diff-filter=AR) — rename gera path
#   novo carregando `path:` antigo, exatamente o caso que (1) bloqueia.
# Teste negativo: guards/tests/run-guard-tests.sh (seção G-SLF).
# Usa python3 só para JSON (precedente assert-scope-lock/assert-role-family).
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-self-path"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"

guard_added_files() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git diff --name-only --diff-filter=AR "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
    else
        git diff --cached --name-only --diff-filter=AR 2>/dev/null || true
    fi
}

ADDED="$(guard_added_files)"
if [[ -z "$ADDED" ]]; then
    guard_ok "Nenhum arquivo novo/renomeado no diff."
    exit 0
fi

# Extrai `path:` do PRIMEIRO bloco de front-matter YAML de um .md.
fm_declared_path() {
    awk 'NR==1 && $0!="---"{exit} NR>1 && $0=="---"{exit} NR>1{print}' "$1" \
        | grep -E '^path:' | head -1 \
        | sed -E 's/^path:[[:space:]]*//; s/^["'"'"']//; s/["'"'"']$//; s/[[:space:]]+$//' \
        || true
}

# Extrai chave top-level "path" de um .json (vazio se ausente/ilegível).
json_declared_path() {
    python3 - "$1" <<'PYEOF' || true
import json, sys
try:
    v = json.load(open(sys.argv[1])).get("path", "")
    print(v if isinstance(v, str) else "")
except Exception:
    print("")
PYEOF
}

# Artefatos governados que DEVEM declarar path (ADR-021 Decisão 2, regra 2):
# subconjunto .md dos tipos numerados do ADR-011 + hearbacks .json.
requires_path() {
    case "$1" in
        methodology/adr/ADR-[0-9]*.md) return 0 ;;
        .hbn/knowledge/[0-9][0-9][0-9][0-9]-*.md) return 0 ;;
        .hbn/results/[0-9][0-9][0-9][0-9]-*.md) return 0 ;;
        .hbn/messages/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]-*.md) return 0 ;;
        reports/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]-*.md) return 0 ;;
        docs/prompts/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]-*.md) return 0 ;;
        .hbn/hearbacks/[0-9][0-9][0-9][0-9]-*.json) return 0 ;;
    esac
    return 1
}

FAIL=0
while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    abs="${REPO_ROOT}/${f}"
    [[ -f "$abs" ]] || continue
    declared=""
    case "$f" in
        *.md)   declared="$(fm_declared_path "$abs")" ;;
        *.json) declared="$(json_declared_path "$abs")" ;;
        *) continue ;;
    esac
    if [[ -n "$declared" && "$declared" != "$f" ]]; then
        guard_fail "Auto-localização mentirosa: '${f}' declara path: '${declared}' ≠ caminho real (ADR-021 Decisão 2.1). Corrija o front-matter — ou, se moveu o arquivo, atualize o path: no MESMO commit."
        FAIL=1
    elif [[ -z "$declared" ]] && requires_path "$f"; then
        guard_fail "Artefato governado novo '${f}' sem campo path: declarado (ADR-021 Decisão 2.2: todo artefato governado nasce dizendo onde mora)."
        FAIL=1
    fi
done <<< "$ADDED"

if [[ "$FAIL" -ne 0 ]]; then
    exit 1
fi

guard_ok "Todo arquivo novo com path: declarado mora onde diz; artefatos governados declaram path."
exit 0
