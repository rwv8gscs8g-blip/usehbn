#!/usr/bin/env bash
# =============================================================================
# guards/assert-no-stray-hbn.sh
# path: guards/assert-no-stray-hbn.sh · id-global: 20260611-101851-fable-5-guard-no-stray-hbn
# Guarda G-STRAY: detecta `.hbn/` ÓRFÃO — diretório .hbn cujo pai NÃO é raiz
# de repositório git. Defesa direta contra o incidente opus-4-8 de 2026-06-11
# (orquestrador escreveu .hbn/results/ solto em ~/Projetos, fora de qualquer
# repo — invisível para todos os guards commit-time, porque escrita solta
# não passa por commit).
#
# REGRA: todo `.hbn/` deve morar ao lado de um `.git/` (raiz de worktree).
#   Legítimos hoje: usehbn/.hbn, Credenciamento/.hbn, MAURICIOZANIN-HUB/.hbn.
#   Órfão = bloqueio (no pre-commit) ou achado (no sweep).
#
# DUPLO USO (a escrita solta NÃO comita — o sweep é a única detecção):
#   1. No runner (pre-commit): roda a cada commit do canônico — varre o
#      diretório PAI da raiz canônica e bloqueia se houver órfão.
#   2. Sweep manual/agendado: `bash guards/assert-no-stray-hbn.sh --sweep`
#      (mesma checagem, saída verbosa; rode após qualquer sessão de IA).
#
# Parâmetros (env):
#   HBN_SCAN_ROOT  — raiz da varredura. Default: pai da raiz canônica
#                    (.hbn/canonical-root); se esse caminho não existir na
#                    máquina atual (ex.: sandbox), pai do git toplevel.
#   Profundidade: 4 níveis. Podas: .git, node_modules, .venv, backups
#                 (backup pode conter .hbn históricos sem .git — não é órfão
#                 operacional, é cópia fria).
#
# status: accepted (onda ativação-enforcement, readback 0005, 2026-06-11).
# Teste negativo: guards/tests/run-guard-tests.sh (seção G-STRAY), com
#   HBN_SCAN_ROOT apontando para árvore sintética (ADR-020).
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-no-stray-hbn"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

MODE="guard"
if [[ "${1:-}" == "--sweep" ]]; then
    MODE="sweep"
fi

# Raiz da varredura: HBN_SCAN_ROOT > pai do canonical-root (se existir
# localmente) > pai do git toplevel.
SCAN_ROOT="${HBN_SCAN_ROOT:-}"
if [[ -z "$SCAN_ROOT" ]]; then
    CANONICAL="$(guard_canonical_root || true)"
    if [[ -n "$CANONICAL" && -d "$(dirname "$CANONICAL")" ]]; then
        SCAN_ROOT="$(dirname "$CANONICAL")"
    else
        TOPLEVEL="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"
        [[ -n "$TOPLEVEL" ]] && SCAN_ROOT="$(dirname "$TOPLEVEL")"
    fi
fi

if [[ -z "$SCAN_ROOT" || ! -d "$SCAN_ROOT" ]]; then
    guard_warn "Raiz de varredura indeterminada (HBN_SCAN_ROOT/canonical-root/toplevel). Varredura pulada — rode o sweep no Terminal do operador."
    exit 0
fi

STRAYS=()
while IFS= read -r d; do
    [[ -z "$d" ]] && continue
    parent="$(dirname "$d")"
    if [[ ! -e "${parent}/.git" ]]; then
        STRAYS+=("$d")
    fi
done < <(find "$SCAN_ROOT" -maxdepth 4 \
            \( -name .git -o -name node_modules -o -name .venv -o -name backups \) -prune \
            -o -type d -name ".hbn" -print 2>/dev/null)

if [[ ${#STRAYS[@]} -eq 0 ]]; then
    guard_ok "Nenhum .hbn órfão sob ${SCAN_ROOT} (todo .hbn mora em raiz de repo git)."
    exit 0
fi

guard_fail ".hbn ÓRFÃO detectado (escrita solta fora de repo git — o anti-padrão do incidente opus-4-8):"
for s in "${STRAYS[@]}"; do
    echo "    - $s  (pai sem .git: $(dirname "$s"))" >&2
done
echo "" >&2
echo "  Como corrigir:" >&2
echo "    1. Conteúdo útil? Mover para o .hbn do repo correto (ex.: ${SCAN_ROOT}/usehbn/.hbn/) + linha no REGISTRY" >&2
echo "    2. Vazio/lixo? Remover o diretório órfão" >&2
echo "    3. Registrar P0 em .hbn/readbacks/ se entregáveis nasceram no lugar errado" >&2
echo "    4. NUNCA usar HBN_GUARDS_BYPASS=1 para contornar esta regra" >&2
[[ "$MODE" == "sweep" ]] && echo "  (modo sweep: achado reportado; corrija e rode de novo)" >&2
exit 1
