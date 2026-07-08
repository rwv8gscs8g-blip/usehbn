#!/usr/bin/env bash
# =============================================================================
# guards/assert-no-pending-exuvia.sh
# G-NO-PENDING-EXUVIA (terceira exuvia, v3.0.0): nunca mais um "proposto"
# pendurado. Fecha a causa-raiz C1/L2 do relatorio critico 20260705-001142
# (versao_2_0_0 ficou 4 dias em status proposto sem ativacao, e todo o
# trabalho correu na versao errada).
#
# Regra mecanica (fail-closed):
#   1. Varre o INDICE (ou HEAD em CI) por diretorios versao_X_Y_Z/ contendo
#      BOOT.md cujo front-matter declara `status:` contendo "proposto".
#   2. Se existir versao pendente (proposto) que NAO e a versao ativa:
#      commits de DESENVOLVIMENTO normais sao BLOQUEADOS. So passam commits
#      que resolvem a pendencia:
#        (a) flip de .hbn/active-version para a versao pendente (ativacao
#            da exuvia — G-HOT-WRITE e G-ACTIVE-VERSION validam o resto); ou
#        (b) mudanca do BOOT.md da versao pendente (retirando "proposto":
#            congelamento/descarte da proposta); ou
#        (c) remocao (D) do diretorio da versao pendente.
#   3. Se a PROPRIA versao ativa declara "proposto": BLOCK sempre — versao
#      ativa proposta e estado invalido (ativa = ativa; proposta = inativa).
#
# Ou se ativa, ou se congela/descarta a pasta proposta. Nao ha terceiro estado.
# Teste negativo: guards/tests/run-guard-tests.sh (secao G-NO-PENDING-EXUVIA).
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

GUARD_NAME="assert-no-pending-exuvia"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

# Sem bypass por desenho (mesma classe do G-HOT-WRITE).
if [[ "${HBN_GUARDS_BYPASS:-0}" == "1" || "${GLASSWING_BYPASS:-0}" == "1" ]]; then
    guard_warn "Variavel de bypass detectada e IGNORADA: G-NO-PENDING-EXUVIA nao aceita bypass por desenho."
fi

ACTIVE_REL="$(guard_active_version_rel || true)"
if [[ -z "$ACTIVE_REL" ]]; then
    guard_fail "Ponteiro .hbn/active-version invalido: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Falha fechada."
    exit 1
fi

CURRENT_SOURCE="$(hbn_context_current_source)"
current_blob() { # <repo-path>
    if [[ "$CURRENT_SOURCE" == "HEAD" ]]; then
        git show "HEAD:$1" 2>/dev/null || true
    else
        git show ":$1" 2>/dev/null || true
    fi
}

list_tree_paths() {
    if [[ "$CURRENT_SOURCE" == "HEAD" ]]; then
        git ls-tree -r --name-only HEAD 2>/dev/null || true
    else
        git ls-files 2>/dev/null || true
    fi
}

diff_files_raw() { # paths brutos + status
    if hbn_ci_range_mode; then
        git diff --name-status "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
    else
        git diff --cached --name-status 2>/dev/null || true
    fi
}

boot_status() { # <boot-repo-path> -> valor da linha status: do front-matter
    current_blob "$1" | awk '
        NR==1 && $0!="---" { exit }
        NR>1 && $0=="---" { exit }
        NR>1 && $0 ~ /^status:/ {
            sub(/^status:[[:space:]]*/, "")
            gsub(/^["'"'"']|["'"'"']$/, "")
            print
            exit
        }
    '
}

# Diretorios de versao presentes no indice/HEAD com BOOT.md:
PENDING=()
ACTIVE_PENDING=""
while IFS= read -r boot; do
    [[ -z "$boot" ]] && continue
    ver="${boot%%/*}"
    st="$(boot_status "$boot")"
    if printf '%s' "$st" | grep -qi 'proposto'; then
        if [[ "$ver" == "$ACTIVE_REL" ]]; then
            ACTIVE_PENDING="$ver"
        else
            PENDING+=("$ver")
        fi
    fi
done < <(list_tree_paths | grep -E '^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+/BOOT\.md$' || true)

if [[ -n "$ACTIVE_PENDING" ]]; then
    guard_fail "A versao ATIVA (${ACTIVE_PENDING}) declara status 'proposto' no BOOT.md — estado invalido: versao ativa proposta. A ativacao (flip) e a mudanca de status para 'ativo' sao o MESMO commit atomico de exuvia."
    exit 1
fi

if [[ ${#PENDING[@]} -eq 0 ]]; then
    guard_ok "Nenhuma exuvia pendente: nenhum versao_X_Y_Z/BOOT.md com status proposto fora da versao ativa."
    exit 0
fi

# Ha versao pendente: o commit atual resolve a pendencia?
DIFF="$(diff_files_raw)"
TAB=$'\t'
resolves_pending() { # <versao-pendente>
    local ver="$1" st
    # (a) flip do ponteiro para a versao pendente
    if grep -qE "^[AM][0-9]*${TAB}\.hbn/active-version$" <<< "$DIFF"; then
        local new_val
        new_val="$(current_blob ".hbn/active-version" | grep -v '^[[:space:]]*#' | grep -v '^[[:space:]]*$' | head -1 | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
        [[ "$new_val" == "$ver" ]] && return 0
    fi
    # (b) BOOT.md da pendente muda neste diff (congelamento/decisao)
    if grep -qE "^[AMD][0-9]*${TAB}${ver}/BOOT\.md$" <<< "$DIFF"; then
        st="$(boot_status "${ver}/BOOT.md")"
        printf '%s' "$st" | grep -qi 'proposto' || return 0
        [[ -z "$st" ]] && return 0   # BOOT removido/sem status = removido da pendencia
    fi
    # (c) remocao do diretorio inteiro
    if grep -qE "^D[0-9]*${TAB}${ver}/" <<< "$DIFF" && ! list_tree_paths | grep -q "^${ver}/"; then
        return 0
    fi
    return 1
}

BLOCKING=()
for ver in "${PENDING[@]}"; do
    if ! resolves_pending "$ver"; then
        BLOCKING+=("$ver")
    fi
done

if [[ ${#BLOCKING[@]} -gt 0 ]]; then
    guard_fail "EXUVIA PENDENTE de Fitness Gate: ${BLOCKING[*]} em status 'proposto'. Commits de desenvolvimento normais estao BLOQUEADOS ate a decisao: (a) ativar a exuvia (flip de .hbn/active-version, com autorizacao do gate); (b) congelar/descartar a proposta (mudar status do BOOT.md); ou (c) remover a pasta proposta. Nunca mais um 'proposto' pendurado (L2, relatorio 20260705-001142)."
    exit 1
fi

guard_ok "Exuvia pendente (${PENDING[*]}) esta sendo RESOLVIDA neste commit (ativacao, congelamento ou remocao)."
exit 0
