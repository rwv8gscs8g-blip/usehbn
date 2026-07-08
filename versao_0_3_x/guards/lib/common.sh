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
HBN_HOOK_SHIM_VERSION="M-A-20260614"

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

# Retorna a raiz do repositório Git.
guard_repo_root() {
    local repo_root
    repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"
    if [[ -z "$repo_root" ]]; then
        echo ""
        return 1
    fi
    echo "$repo_root"
}

# Retorna o caminho canônico esperado do repositório a partir de
# .hbn/canonical-root. Esse é o trilho físico do repo; a raiz operacional da
# versão ativa é resolvida por get_canonical_root().
guard_repo_canonical_root() {
    local repo_root
    repo_root="$(guard_repo_root)" || return 1
    local f="${repo_root}/.hbn/canonical-root"
    if [[ ! -f "$f" ]]; then
        echo ""
        return 1
    fi
    # Lê primeira linha não vazia/não comentário
    grep -v '^[[:space:]]*#' "$f" | grep -v '^[[:space:]]*$' | head -1
}

# Lê e valida .hbn/active-version. Política: exatamente uma versão ativa vence.
# Arquivo ausente, vazio, com conflito de merge ou apontando para path inseguro
# é estado inválido e deve falhar fechado.
guard_active_version_rel() {
    HBN_ACTIVE_VERSION_ERROR=""
    local repo_root pointer raw count value
    repo_root="$(guard_repo_root)" || {
        HBN_ACTIVE_VERSION_ERROR="não foi possível resolver a raiz do repositório Git"
        return 1
    }
    pointer="${repo_root}/.hbn/active-version"
    if [[ ! -r "$pointer" ]]; then
        HBN_ACTIVE_VERSION_ERROR="ponteiro ${pointer} ausente ou ilegível"
        return 1
    fi
    if grep -qE '^(<<<<<<<|=======|>>>>>>>)' "$pointer" 2>/dev/null; then
        HBN_ACTIVE_VERSION_ERROR="ponteiro ${pointer} contém marcador de conflito de merge; resolva manualmente para uma única versão ativa"
        return 1
    fi
    raw="$(grep -v '^[[:space:]]*#' "$pointer" | grep -v '^[[:space:]]*$' || true)"
    count="$(printf '%s\n' "$raw" | sed '/^[[:space:]]*$/d' | wc -l | tr -d '[:space:]')"
    if [[ "$count" != "1" ]]; then
        HBN_ACTIVE_VERSION_ERROR="ponteiro ${pointer} deve conter exatamente uma linha ativa; encontrou ${count}"
        return 1
    fi
    value="$(printf '%s\n' "$raw" | sed -n '1p' | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
    if [[ "$value" != "." && ! "$value" =~ ^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+$ ]]; then
        HBN_ACTIVE_VERSION_ERROR="ponteiro ${pointer} aponta para valor inválido '${value}' (permitido: '.' ou versao_X_Y_Z)"
        return 1
    fi
    case "$value" in
        /*|*..*|*//*|*\\*|*" "*|*"	"*)
            HBN_ACTIVE_VERSION_ERROR="ponteiro ${pointer} contém path inseguro '${value}'"
            return 1
            ;;
    esac
    printf '%s\n' "$value"
}

# API pedida pela onda M-A: raiz canônica = raiz da versão ativa.
get_canonical_root() {
    local repo_root rel root
    repo_root="$(guard_repo_root)" || return 1
    rel="$(guard_active_version_rel)" || return 1
    if [[ "$rel" == "." ]]; then
        root="$repo_root"
    else
        root="${repo_root}/${rel}"
    fi
    if [[ ! -d "$root" ]]; then
        HBN_ACTIVE_VERSION_ERROR="ponteiro .hbn/active-version aponta para versão inexistente: ${rel}"
        return 1
    fi
    ( cd "$root" && pwd -P )
}

# Compatibilidade com os guards existentes: agora retorna a raiz da versão ativa.
guard_canonical_root() {
    get_canonical_root
}

guard_active_version_prefix() {
    local rel
    rel="$(guard_active_version_rel)" || return 1
    if [[ "$rel" == "." ]]; then
        echo ""
    else
        printf '%s/' "$rel"
    fi
}

# Converte path relativo à versão ativa para path relativo ao repo Git.
guard_version_repo_path() {
    local p="$1" rel
    case "$p" in
        /*) printf '%s\n' "$p"; return 0 ;;
    esac
    rel="$(guard_active_version_rel)" || return 1
    if [[ "$rel" == "." ]]; then
        printf '%s\n' "$p"
    else
        printf '%s/%s\n' "$rel" "$p"
    fi
}

# Converte path relativo ao repo Git para path relativo à versão ativa.
guard_repo_path_to_version_path() {
    local p="$1" prefix
    prefix="$(guard_active_version_prefix)" || return 1
    if [[ -n "$prefix" && "$p" == "$prefix"* ]]; then
        printf '%s\n' "${p#"$prefix"}"
    else
        printf '%s\n' "$p"
    fi
}

guard_paths_to_version_paths() {
    local p
    while IFS= read -r p; do
        [[ -z "$p" ]] && continue
        guard_repo_path_to_version_path "$p"
    done
}

hbn_ci_range_mode() {
    [[ -n "${HBN_DIFF_BASE:-}" ]] || return 1
    case "${HBN_CI:-}" in
        1|true|TRUE|yes|YES) return 0 ;;
    esac
    case "${GITHUB_ACTIONS:-}" in
        1|true|TRUE) return 0 ;;
    esac
    [[ -n "${CI:-}" && "${CI:-}" != "0" && "${CI:-}" != "false" && "${CI:-}" != "FALSE" ]]
}

hbn_effective_diff_base() {
    hbn_ci_range_mode || return 1
    printf '%s\n' "$HBN_DIFF_BASE"
}

hbn_index_has_staged_changes() {
    ! git diff --cached --quiet --ignore-submodules -- 2>/dev/null
}

hbn_context_current_source() {
    if hbn_ci_range_mode && ! hbn_index_has_staged_changes; then
        printf 'HEAD\n'
    else
        printf 'INDEX\n'
    fi
}

hbn_context_current_ref() { # <repo-path>
    local p="${1%/}"
    if [[ "$(hbn_context_current_source)" == "HEAD" ]]; then
        printf 'HEAD:%s\n' "$p"
    else
        printf ':%s\n' "$p"
    fi
}

hbn_index_path_kind() { # <repo-path> -> file|dir|symlink|gitlink|absent
    local p="${1%/}" mode found
    [[ -z "$p" ]] && { printf 'absent\n'; return 0; }
    mode="$(git ls-files --stage -- "$p" 2>/dev/null | awk -v p="$p" '$4 == p { print $1; exit }')"
    case "$mode" in
        100644|100755) printf 'file\n'; return 0 ;;
        120000) printf 'symlink\n'; return 0 ;;
        160000) printf 'gitlink\n'; return 0 ;;
    esac
    found="$(git ls-files --cached -- "${p}/" 2>/dev/null | sed -n '1p')"
    if [[ -n "$found" ]]; then
        printf 'dir\n'
    else
        printf 'absent\n'
    fi
}

hbn_ref_path_kind() { # <ref> <repo-path> -> file|dir|symlink|gitlink|absent
    local ref="$1" p="${2%/}" mode
    [[ -z "$p" ]] && { printf 'absent\n'; return 0; }
    mode="$(git ls-tree "$ref" -- "$p" 2>/dev/null | awk -v p="$p" '$4 == p { print $1; exit }')"
    case "$mode" in
        040000) printf 'dir\n' ;;
        100644|100755) printf 'file\n' ;;
        120000) printf 'symlink\n' ;;
        160000) printf 'gitlink\n' ;;
        *) printf 'absent\n' ;;
    esac
}

hbn_path_kind_active() {
    case "$1" in
        file|dir) return 0 ;;
        *) return 1 ;;
    esac
}

hbn_path_kind_present() {
    case "$1" in
        file|dir|symlink|gitlink) return 0 ;;
        *) return 1 ;;
    esac
}

hbn_index_has_path() { # <repo-path> ; aceita blob regular ou tree versionada
    hbn_path_kind_active "$(hbn_index_path_kind "$1")"
}

hbn_ref_has_path() { # <ref> <repo-path> ; aceita blob regular ou tree versionada
    hbn_path_kind_active "$(hbn_ref_path_kind "$1" "$2")"
}

hbn_ref_has_any_path() { # <ref> <repo-path> ; baseline: presença inclui symlink/gitlink
    hbn_path_kind_present "$(hbn_ref_path_kind "$1" "$2")"
}

hbn_version_repo_path_for_rel() { # <active-version-rel> <version-path>
    local rel="$1" p="${2%/}"
    if [[ "$rel" == "." ]]; then
        printf '%s\n' "$p"
    else
        printf '%s/%s\n' "$rel" "$p"
    fi
}

hbn_logical_dep_path_from_repo_path() { # <repo-path>
    local p="${1%/}"
    if [[ "$p" =~ ^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+/ ]]; then
        printf '%s\n' "${p#*/}"
    else
        printf '%s\n' "$p"
    fi
}

hbn_ref_has_committed_logical_dep() { # <ref> <version-path>
    local ref="$1" logical="${2%/}" version
    [[ -z "$logical" ]] && return 1
    if hbn_ref_has_any_path "$ref" "$logical"; then
        return 0
    fi
    while IFS= read -r version; do
        [[ -z "$version" ]] && continue
        if hbn_ref_has_any_path "$ref" "$(hbn_version_repo_path_for_rel "$version" "$logical")"; then
            return 0
        fi
    done < <(git ls-tree -d --name-only "$ref" 2>/dev/null | grep -E '^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+$' || true)
    return 1
}

# Estado de uma dependencia de contexto versionada:
# ATIVO  = presente no indice local, ou em HEAD apenas em range puro sem indice staged.
# NOOP   = ausente no ponto atual e tambem ausente no baseline (genese/pre-install).
# DISARM = ausente no ponto atual, mas presente no baseline (remocao neste commit/range).
hbn_context_dep_state() { # <repo-path>
    local p="${1%/}" base current_kind current_source logical
    if [[ -z "$p" ]]; then
        printf 'DISARM\n'
        return 0
    fi

    current_source="$(hbn_context_current_source)"
    if [[ "$current_source" == "HEAD" ]]; then
        current_kind="$(hbn_ref_path_kind HEAD "$p")"
    else
        current_kind="$(hbn_index_path_kind "$p")"
    fi

    if hbn_ci_range_mode; then
        base="$HBN_DIFF_BASE"
    else
        base="HEAD"
    fi

    if hbn_path_kind_active "$current_kind"; then
        printf 'ATIVO\n'
        return 0
    fi
    if hbn_path_kind_present "$current_kind"; then
        printf 'DISARM\n'
        return 0
    fi

    if [[ "$current_source" == "INDEX" ]] && hbn_ref_has_any_path HEAD "$p"; then
        printf 'DISARM\n'
        return 0
    fi
    if hbn_ref_has_any_path "$base" "$p"; then
        printf 'DISARM\n'
        return 0
    fi

    logical="$(hbn_logical_dep_path_from_repo_path "$p")"
    if hbn_ref_has_committed_logical_dep HEAD "$logical"; then
        printf 'DISARM\n'
        return 0
    fi
    if [[ "$base" != "HEAD" ]] && hbn_ref_has_committed_logical_dep "$base" "$logical"; then
        printf 'DISARM\n'
        return 0
    fi

    printf 'NOOP\n'
}

guard_hook_path() {
    local hook="$1" repo_root p
    repo_root="$(guard_repo_root)" || return 1
    p="$(git rev-parse --git-path "hooks/${hook}" 2>/dev/null || echo "")"
    [[ -z "$p" ]] && return 1
    case "$p" in
        /*) printf '%s\n' "$p" ;;
        *) printf '%s/%s\n' "$repo_root" "$p" ;;
    esac
}

guard_check_hooks_current() {
    local hook path fail=0
    for hook in pre-commit commit-msg; do
        path="$(guard_hook_path "$hook" || true)"
        if [[ -z "$path" || ! -f "$path" ]]; then
            guard_fail "Hook ${hook} ausente em .git/hooks. Clone sem onboarding não tem enforcement; instale o shim HBN antes de operar."
            fail=1
            continue
        fi
        if [[ ! -x "$path" ]]; then
            guard_fail "Hook ${hook} existe mas não é executável: ${path}"
            fail=1
        fi
        if ! grep -q "HBN_HOOK_SHIM_VERSION=${HBN_HOOK_SHIM_VERSION}" "$path" 2>/dev/null; then
            guard_fail "Hook ${hook} desatualizado: falta marcador HBN_HOOK_SHIM_VERSION=${HBN_HOOK_SHIM_VERSION}. Reinstale o shim version-aware."
            fail=1
        fi
    done
    [[ "$fail" -eq 0 ]]
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
    if hbn_ci_range_mode; then
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

# Arquivos sob analise: staged (pre-commit local) OU range de CI real.
# HBN_DIFF_BASE sozinho nao muda o modo: exige sinal de CI (GITHUB_ACTIONS,
# CI ou HBN_CI setado pelo entrypoint).
guard_diff_files() {
    if hbn_ci_range_mode; then
        git diff --name-only --diff-filter=ACMR "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
    else
        git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || true
    fi | guard_paths_to_version_paths
}

# Extrai a atribuicao do front-matter do STATE sem depender de grep em YAML.
# Saida em linhas shell-safe: status=ok|missing|error, implementador=...,
# orquestrador=..., auditores="a b", escrita_paralela="a b".
hbn_extract_assignment_kv() { # <state-file>
    local state_file="$1"
    python3 - "$state_file" <<'PY'
import re
import shlex
import sys

path = sys.argv[1]

try:
    text = open(path, encoding="utf-8").read()
except Exception as exc:
    print("status=error")
    print("error=" + shlex.quote(f"STATE ilegivel: {exc}"))
    sys.exit(0)

def frontmatter(src):
    lines = src.splitlines()
    if not lines or lines[0].strip() != "---":
        return lines
    for idx in range(1, len(lines)):
        if lines[idx].strip() == "---":
            return lines[1:idx]
    return lines

def strip_comment(value):
    in_single = False
    in_double = False
    escaped = False
    for idx, char in enumerate(value):
        if escaped:
            escaped = False
            continue
        if char == "\\" and in_double:
            escaped = True
            continue
        if char == "'" and not in_double:
            in_single = not in_single
            continue
        if char == '"' and not in_single:
            in_double = not in_double
            continue
        if char == "#" and not in_single and not in_double and (idx == 0 or value[idx - 1].isspace()):
            return value[:idx].rstrip()
    return value.strip()

def scalar(value):
    value = strip_comment(value).strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
        return value[1:-1]
    if value in ("null", "~"):
        return ""
    return value

def inline_list(value):
    value = strip_comment(value).strip()
    if not (value.startswith("[") and value.endswith("]")):
        return None
    inside = value[1:-1].strip()
    if not inside:
        return []
    return [scalar(part.strip()) for part in inside.split(",") if scalar(part.strip())]

KEY_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_-]*)\s*:\s*(.*)$")
ITEM_RE = re.compile(r"^-\s*(.*)$")

lines = frontmatter(text)
atrib_start = None
atrib_indent = None
for idx, raw in enumerate(lines):
    if not raw.strip() or raw.lstrip().startswith("#"):
        continue
    indent = len(raw) - len(raw.lstrip(" "))
    m = KEY_RE.match(raw.strip())
    if m and m.group(1) == "atribuicao":
        atrib_start = idx
        atrib_indent = indent
        if strip_comment(m.group(2).strip()):
            print("status=error")
            print("error=" + shlex.quote("atribuicao deve ser bloco YAML, nao escalar inline"))
            sys.exit(0)
        break

block = []
if atrib_start is not None:
    for raw in lines[atrib_start + 1 :]:
        if not raw.strip() or raw.lstrip().startswith("#"):
            block.append(raw)
            continue
        indent = len(raw) - len(raw.lstrip(" "))
        if indent <= atrib_indent:
            break
        block.append(raw[atrib_indent + 2 :])
else:
    block = lines

data = {}
idx = 0
while idx < len(block):
    raw = block[idx]
    idx += 1
    if not raw.strip() or raw.lstrip().startswith("#"):
        continue
    indent = len(raw) - len(raw.lstrip(" "))
    if indent != 0:
        continue
    m = KEY_RE.match(raw.strip())
    if not m:
        continue
    key, value = m.group(1), m.group(2).strip()
    if key not in {"orquestrador", "implementador", "auditores", "escrita_paralela"}:
        continue
    as_list = inline_list(value)
    if as_list is not None:
        data[key] = as_list
        continue
    if strip_comment(value):
        data[key] = scalar(value)
        continue
    items = []
    while idx < len(block):
        child = block[idx]
        if not child.strip() or child.lstrip().startswith("#"):
            idx += 1
            continue
        child_indent = len(child) - len(child.lstrip(" "))
        if child_indent <= indent:
            break
        im = ITEM_RE.match(child.strip())
        if im:
            items.append(scalar(im.group(1)))
            idx += 1
            continue
        km = KEY_RE.match(child.strip())
        if km:
            break
        print("status=error")
        print("error=" + shlex.quote(f"linha de lista invalida em atribuicao.{key}: {child.strip()}"))
        sys.exit(0)
    data[key] = [item for item in items if item]

if not data:
    print("status=missing")
    sys.exit(0)

def list_value(value):
    if isinstance(value, list):
        return " ".join(str(item) for item in value if str(item))
    if value:
        return str(value)
    return ""

print("status=ok")
for key in ("orquestrador", "implementador"):
    print(f"{key}={shlex.quote(str(data.get(key, '') or ''))}")
for key in ("auditores", "escrita_paralela"):
    print(f"{key}={shlex.quote(list_value(data.get(key, [])))}")
PY
}
