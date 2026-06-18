#!/usr/bin/env bash
# =============================================================================
# guards/assert-orq-entrada.sh
# G-ORQ-ENTRADA: bastao de orquestrador exige atestacao de leitura valida.
#
# Gatilho: STATE staged (local) ou HEAD (CI) com papel_bastao=orquestrador ou
# atribuicao.chapeu_atual contendo "orquestrador". Fora desse caso, nao opina.
#
# Fail-closed: sem STATE legivel, sem token, sem atestacao, read-list ausente,
# item ausente, hash divergente ou desafio invalido bloqueia commit local.
# =============================================================================
set -euo pipefail

GUARD_NAME="assert-orq-entrada"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if guard_check_bypass; then
    exit 0
fi

REPO_ROOT="$(guard_repo_root)"
ACTIVE_ROOT="$(get_canonical_root || true)"
STATE_PATH=".hbn/relay/STATE.md"
STATE_REPO_PATH="$(guard_version_repo_path "$STATE_PATH" || true)"

if [[ -z "$ACTIVE_ROOT" || -z "$STATE_REPO_PATH" ]]; then
    guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR:-erro desconhecido}. Nao e possivel localizar STATE."
    exit 1
fi

state_content() {
    if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
        git show "HEAD:${STATE_REPO_PATH}" 2>/dev/null
    else
        git show ":${STATE_REPO_PATH}" 2>/dev/null || git show "HEAD:${STATE_REPO_PATH}" 2>/dev/null
    fi
}

STATE_CONTENT="$(state_content || true)"
if [[ -z "$STATE_CONTENT" ]]; then
    guard_fail "STATE ausente/ilegivel no indice/HEAD: ${STATE_PATH}."
    exit 1
fi

state_value() {
    local key="$1"
    printf '%s\n' "$STATE_CONTENT" \
        | grep -E "^[[:space:]]*${key}:" \
        | head -1 \
        | sed -E 's/^[^:]+:[[:space:]]*//; s/[[:space:]]+#.*$//; s/^[[:space:]]+//; s/[[:space:]]+$//; s/^["'\'']//; s/["'\'']$//' \
        || true
}

PAPEL_BASTAO="$(state_value "papel_bastao" | tr '[:upper:]' '[:lower:]')"
CHAPEU_ATUAL="$(state_value "chapeu_atual" | tr '[:upper:]' '[:lower:]')"

if [[ "$PAPEL_BASTAO" != "orquestrador" && "$CHAPEU_ATUAL" != *"orquestrador"* ]]; then
    guard_ok "Bastao atual nao e de orquestrador — G-ORQ-ENTRADA nao opina."
    exit 0
fi

TOKEN_SHA="$(state_value "bastao_token_sha256" | grep -Eo '^[0-9a-fA-F]{64}$' || true)"
if [[ -z "$TOKEN_SHA" ]]; then
    guard_fail "STATE de orquestrador sem bastao_token_sha256 valido."
    exit 1
fi
TOKEN_FP="${TOKEN_SHA:0:8}"

HANDOFF_PATH="$(state_value "handoff_mais_recente")"
READBACK_PATH="$(state_value "readback_ativo")"
CANON_FILE="${ACTIVE_ROOT}/core/read-list-canonica.txt"
ATTEST_FILE="${ACTIVE_ROOT}/.hbn/attestations/${TOKEN_FP}-orq-entrada.json"
GABARITO_FILE="${ACTIVE_ROOT}/guards/data/orq-entrada-desafios.txt"

if [[ ! -r "$CANON_FILE" ]]; then
    guard_fail "Read-list canonica ausente/ilegivel: core/read-list-canonica.txt."
    exit 1
fi
if [[ ! -r "$GABARITO_FILE" ]]; then
    guard_fail "Gabarito de desafios ausente/ilegivel: guards/data/orq-entrada-desafios.txt."
    exit 1
fi
if [[ ! -r "$ATTEST_FILE" ]]; then
    guard_fail "Atestacao de entrada ausente para bastao ${TOKEN_FP}: .hbn/attestations/${TOKEN_FP}-orq-entrada.json."
    exit 1
fi

EXPECTED_FILE="$(mktemp)"
trap 'rm -f "$EXPECTED_FILE"' EXIT

CANON_FAIL=0
while IFS= read -r raw_line; do
    line="${raw_line%%#*}"
    line="$(printf '%s' "$line" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
    [[ -z "$line" ]] && continue

    if [[ "$line" =~ ^DYNAMIC[[:space:]]+([A-Za-z0-9_]+)$ ]]; then
        field="${BASH_REMATCH[1]}"
        case "$field" in
            handoff_mais_recente) resolved="$HANDOFF_PATH" ;;
            readback_ativo) resolved="$READBACK_PATH" ;;
            *)
                guard_fail "Read-list canonica contem DYNAMIC desconhecido: ${field}."
                CANON_FAIL=1
                continue
                ;;
        esac
        if [[ -z "$resolved" ]]; then
            guard_fail "STATE nao resolve campo dinamico obrigatorio: ${field}."
            CANON_FAIL=1
            continue
        fi
        printf '%s\n' "$resolved" >> "$EXPECTED_FILE"
    elif [[ "$line" =~ ^[0-9a-fA-F]{7,40}[[:space:]]+(.+)$ ]]; then
        printf '%s\n' "${BASH_REMATCH[1]}" >> "$EXPECTED_FILE"
    else
        guard_fail "Linha invalida em core/read-list-canonica.txt: ${raw_line}"
        CANON_FAIL=1
    fi
done < "$CANON_FILE"

EXPECTED_COUNT="$(sed '/^[[:space:]]*$/d' "$EXPECTED_FILE" | wc -l | tr -d '[:space:]')"
if [[ "$EXPECTED_COUNT" != "13" ]]; then
    guard_fail "Read-list canonica deve resolver 13 itens; resolveu ${EXPECTED_COUNT}."
    CANON_FAIL=1
fi
if [[ "$CANON_FAIL" -ne 0 ]]; then
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    guard_fail "python3 ausente — nao consigo validar JSON da atestacao com seguranca."
    exit 2
fi

if ! (
    cd "$REPO_ROOT"
    python3 - "$TOKEN_FP" "$ATTEST_FILE" "$EXPECTED_FILE" "$GABARITO_FILE" <<'PY'
import json
import pathlib
import re
import subprocess
import sys

token_fp, attest_path, expected_file, gabarito_file = sys.argv[1:5]
errors = []

def fail(message):
    errors.append(message)

try:
    with open(attest_path, encoding="utf-8") as f:
        data = json.load(f)
except Exception as exc:
    print(f"G-ORQ-ENTRADA: atestacao JSON ilegivel: {exc}", file=sys.stderr)
    sys.exit(1)

if not isinstance(data, dict):
    fail("atestacao deve ser um objeto JSON")

if data.get("bastao_token_fp") != token_fp:
    fail(f"bastao_token_fp divergente: esperado {token_fp}, obtido {data.get('bastao_token_fp')!r}")

if data.get("papel") != "orquestrador":
    fail("campo papel deve ser 'orquestrador'")

if data.get("read_list_ref") != "core/read-list-canonica.txt":
    fail("read_list_ref deve apontar para core/read-list-canonica.txt")

items = data.get("itens")
item_map = {}
if not isinstance(items, list):
    fail("campo itens deve ser lista de objetos {path, blob_hash}")
else:
    for idx, item in enumerate(items, 1):
        if not isinstance(item, dict):
            fail(f"itens[{idx}] nao e objeto")
            continue
        path = item.get("path")
        blob_hash = item.get("blob_hash")
        if not isinstance(path, str) or not path.strip():
            fail(f"itens[{idx}] sem path valido")
            continue
        if path in item_map:
            fail(f"item duplicado em itens: {path}")
            continue
        item_map[path] = blob_hash

expected_paths = [
    line.strip()
    for line in pathlib.Path(expected_file).read_text(encoding="utf-8").splitlines()
    if line.strip()
]

for path in expected_paths:
    att_hash = item_map.get(path)
    if not att_hash:
        fail(f"item ausente na atestacao: {path}")
        continue
    try:
        current = subprocess.check_output(
            ["git", "hash-object", "--", path],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except subprocess.CalledProcessError:
        fail(f"nao foi possivel calcular git hash-object do item: {path}")
        continue
    if att_hash != current:
        fail(f"blob_hash divergente para {path}: atestacao={att_hash}; atual={current}")

gabaritos = {}
for raw in pathlib.Path(gabarito_file).read_text(encoding="utf-8").splitlines():
    line = raw.strip()
    if not line or line.startswith("#"):
        continue
    if ":" not in line:
        fail(f"linha invalida no gabarito: {raw}")
        continue
    key, pattern = line.split(":", 1)
    key = key.strip()
    pattern = pattern.strip()
    if not key or not pattern:
        fail(f"linha invalida no gabarito: {raw}")
        continue
    gabaritos[key] = pattern

desafios = data.get("desafios")

def resposta_para(chave):
    if isinstance(desafios, dict):
        value = desafios.get(chave)
        if isinstance(value, dict):
            return value.get("resposta_desafio") or value.get("resposta") or ""
        if isinstance(value, str):
            return value
    if isinstance(desafios, list):
        for item in desafios:
            if not isinstance(item, dict):
                continue
            if item.get("id") == chave or item.get("desafio") == chave:
                return item.get("resposta_desafio") or item.get("resposta") or ""
    return ""

for chave, pattern in sorted(gabaritos.items()):
    resposta = resposta_para(chave)
    if not isinstance(resposta, str) or not resposta.strip():
        fail(f"resposta_desafio vazia ou ausente para {chave}")
        continue
    try:
        ok = re.search(pattern, resposta, flags=re.IGNORECASE) is not None
    except re.error as exc:
        fail(f"regex invalido no gabarito {chave}: {exc}")
        continue
    if not ok:
        fail(f"resposta_desafio de {chave} nao satisfaz gabarito: {pattern}")

if errors:
    for message in errors:
        print(f"G-ORQ-ENTRADA: {message}", file=sys.stderr)
    sys.exit(1)
PY
); then
    guard_fail "Atestacao de entrada do orquestrador invalida para bastao ${TOKEN_FP}."
    exit 1
fi

guard_ok "Atestacao de entrada valida para bastao de orquestrador ${TOKEN_FP}."
exit 0
