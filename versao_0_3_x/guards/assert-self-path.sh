#!/usr/bin/env bash
# =============================================================================
# guards/assert-self-path.sh
# path: guards/assert-self-path.sh · id-global: 20260610-80
# Guarda G-SLF: dá dente ao ADR-021 (documentos auto-localizáveis).
#   (1) Recusa arquivo novo/renomeado que declara `path:` (front-matter .md ou
#       chave top-level "path" em .json) DIFERENTE do caminho real no repo
#       (ou, sob versao_X_Y_Z/, do caminho relativo à raiz dessa versão).
#       Auto-localização mentirosa é pior que nenhuma: manda humano e IA, com
#       confiança, ao lugar errado.
#   (2) Recusa artefato GOVERNADO novo (subconjunto .md da tabela do ADR-011
#       Decisão 2 + hearbacks .json) que NÃO declara `path:`.
#
# status: accepted (corrente E — fechamento, readback 0003, 2026-06-10) — NÃO está no runner.
#   Ativação futura = onda própria (ADR-020 Decisão 2: suíte verde + hearback).
# Padrão C3: guard_diff staged local; HBN_DIFF_BASE...HEAD em CI.
# E-FECH-01 (re-auditoria 0027): valida o BLOB STAGED (git show :path), nunca
#   a working tree — o verde tem que provar o conteúdo que entra no commit.
#   Em CI (HBN_DIFF_BASE) lê HEAD:path, que É o conteúdo pushed.
# Escopo: arquivos ADICIONADOS/RENOMEADOS (diff-filter=AR) — rename gera path
#   novo carregando `path:` antigo, exatamente o caso que (1) bloqueia.
# Teste negativo: guards/tests/run-guard-tests.sh (seção G-SLF).
# Usa python3 só para JSON (precedente assert-scope-lock/assert-role-family).
# =============================================================================
# ---HBN-REQUIRES-BEGIN---
# requires:
#   files: []
#   dirs: []
#   state_fields: []
#   guards: []
#   env: []
# ---HBN-REQUIRES-END---
set -euo pipefail

GUARD_NAME="assert-self-path"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

guard_added_files() {
    if hbn_ci_range_mode; then
        git diff --name-only --diff-filter=AR "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
    else
        git diff --cached --name-only --diff-filter=AR 2>/dev/null || true
    fi | guard_paths_to_version_paths
}

ADDED="$(guard_added_files)"
if [[ -z "$ADDED" ]]; then
    guard_ok "Nenhum arquivo novo/renomeado no diff."
    exit 0
fi

# Referência do blob a validar: índice (staged) localmente; HEAD em CI.
# E-FECH-01: NUNCA a working tree — ela não é o que será commitado.
blob_ref() {
    local p
    p="$(guard_version_repo_path "$1")" || return 1
    if hbn_ci_range_mode; then
        echo "HEAD:$p"
    else
        echo ":$p"
    fi
}

version_root_relative_path() {
    local p="$1"
    if [[ "$p" =~ ^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+/(.+)$ ]]; then
        printf '%s\n' "${BASH_REMATCH[1]}"
        return 0
    fi
    return 1
}

declared_path_matches_file() {
    local declared="$1" active_path="$2" repo_path="$3" version_path
    [[ "$declared" == "$active_path" || "$declared" == "$repo_path" ]] && return 0
    version_path="$(version_root_relative_path "$repo_path" || true)"
    [[ -n "$version_path" && "$declared" == "$version_path" ]]
}

# Extrai `path:` do PRIMEIRO bloco de front-matter YAML de um .md (stdin).
fm_declared_path() {
    awk 'NR==1 && $0!="---"{exit} NR>1 && $0=="---"{exit} NR>1{print}' \
        | grep -E '^path:' | head -1 \
        | sed -E 's/^path:[[:space:]]*//; s/^["'"'"']//; s/["'"'"']$//; s/[[:space:]]+$//' \
        || true
}

# Extrai chave top-level "path" de um .json (stdin; vazio se ausente/ilegível).
# -c em vez de heredoc: o stdin é o BLOB (heredoc roubaria o stdin do python).
json_declared_path() {
    python3 -c '
import json, sys
try:
    v = json.load(sys.stdin).get("path", "")
    print(v if isinstance(v, str) else "")
except Exception:
    print("")
' || true
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
        # ADR-025 (onda 0006 I-03): formato carimbo AAAAMMDD-HHMMSS-<agente>
        # nas séries de evento também é artefato governado — exige path:.
        # Os padrões seriais acima ficam como LEITURA de legado (arquivo novo
        # serial nessas séries é bloqueado pelo G-NUM antes de chegar aqui).
        .hbn/results/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-*.md) return 0 ;;
        .hbn/proposals/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-*.md) return 0 ;;
        .hbn/messages/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-*.md) return 0 ;;
        reports/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-*.md) return 0 ;;
        docs/prompts/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-*.md) return 0 ;;
    esac
    return 1
}

FAIL=0
while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    repo_path="$(guard_version_repo_path "$f")"
    ref="$(blob_ref "$f")"
    git cat-file -e "$ref" 2>/dev/null || continue
    declared=""
    case "$f" in
        *.md)   declared="$(git show "$ref" 2>/dev/null | fm_declared_path)" ;;
        *.json) declared="$(git show "$ref" 2>/dev/null | json_declared_path)" ;;
        *) continue ;;
    esac
    if [[ -n "$declared" ]] && ! declared_path_matches_file "$declared" "$f" "$repo_path"; then
        guard_fail "Auto-localização mentirosa: '${repo_path}' declara path: '${declared}' incompatível com caminho real '${repo_path}' e referencial ativo '${f}' (ADR-021 Decisão 2.1) — no conteúdo STAGED. Corrija o front-matter E re-stage (git add) — ou, se moveu o arquivo, atualize o path: no MESMO commit."
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
