#!/usr/bin/env bash
# Executado somente por implementador ou gate, fora do processo enjaulado.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=jaula-lib.sh
source "${SCRIPT_DIR}/jaula-lib.sh"
jaula_assert_hot_version

[[ "${HBN_ACTOR_ROLE:-}" == implementador || "${HBN_ACTOR_ROLE:-}" == humano ]] \
    || jaula_die 'promoção exige HBN_ACTOR_ROLE=implementador|humano'
[[ $# -eq 1 ]] || jaula_die 'uso: promote-ledger.sh <artefato-do-ledger>'
[[ -n "${HBN_JAULA_LEDGER:-}" ]] || jaula_die 'HBN_JAULA_LEDGER não definido'

src="$1"
[[ -f "$src" && ! -L "$src" ]] || jaula_die 'artefato ausente, não regular ou symlink'
ledger="$(jaula_realpath_existing "$HBN_JAULA_LEDGER")"
src_real="$(jaula_realpath_existing "$src")"
jaula_path_within "$src_real" "$ledger" || jaula_die 'artefato fora do ledger'
rel="${src_real#${ledger}/}"
case "$rel" in
    prompts/*.md|dispatches/*.md|handoffs/*.md) dest_dir='.hbn/messages' ;;
    readbacks-draft/*.json) dest_dir='.hbn/readbacks' ;;
    *) jaula_die "classe de artefato não promovível: ${rel}" ;;
esac

base="$(basename "$src_real")"
case "$base" in
    *..*|*[!A-Za-z0-9._-]*) jaula_die "nome inseguro: ${base}" ;;
esac
if grep -Eiq '(^|[[:space:]])(diff --git|\*\*\* Begin Patch|\.\./|/\.\./|GIT binary patch)' "$src_real"; then
    jaula_die 'payload executável, patch ou travessia recusado'
fi

VERSION_ROOT="$(jaula_version_root)"
dest="${VERSION_ROOT}/${dest_dir}/${base}"
[[ ! -e "$dest" ]] || jaula_die "destino já existe: ${dest}"

python3 - "$src_real" "$dest_dir/$base" <<'PY'
import json, pathlib, re, sys
p = pathlib.Path(sys.argv[1])
expected = sys.argv[2]
text = p.read_text(encoding='utf-8')
if p.suffix == '.json':
    data = json.loads(text)
    if not isinstance(data, dict): raise SystemExit('JSON deve ser objeto')
    for key in ('tipo', 'status', 'path', 'autor', 'familia'):
        if not data.get(key): raise SystemExit(f'campo obrigatório ausente: {key}')
else:
    if not text.startswith('---\n'): raise SystemExit('front matter ausente')
    end = text.find('\n---\n', 4)
    if end < 0: raise SystemExit('front matter malformado')
    fm = text[4:end]
    data = {}
    for line in fm.splitlines():
        m = re.match(r'^([a-z_]+):\s*["\']?(.*?)["\']?$', line)
        if m: data[m.group(1)] = m.group(2)
    for key in ('titulo', 'tipo', 'status', 'temperatura', 'path', 'created_at', 'autor', 'familia'):
        if not data.get(key): raise SystemExit(f'campo obrigatório ausente: {key}')
declared = str(data['path']).lstrip('./')
allowed = {expected, 'ledger/' + pathlib.Path(sys.argv[1]).name}
if declared not in allowed:
    raise SystemExit(f'path declarado não corresponde ao destino: {declared}')
PY

install -m 0644 "$src_real" "$dest"
git -C "$(jaula_repo_root)" add -- "${dest#$(jaula_repo_root)/}"
jaula_log "promovido e staged cirurgicamente: ${dest#$(jaula_repo_root)/}"
