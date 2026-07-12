#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=jaula-lib.sh
source "${SCRIPT_DIR}/jaula-lib.sh"
jaula_assert_hot_version

VERSION_ROOT="$(jaula_version_root)"
STATE="${VERSION_ROOT}/.hbn/relay/STATE.md"
READ_LIST="${VERSION_ROOT}/core/read-list-canonica.txt"
PROFILE="${SCRIPT_DIR}/jaula-sh"
RULES="${VERSION_ROOT}/BOOT.md"
LEDGER="${HBN_JAULA_LEDGER:-${1:-}}"
[[ -n "$LEDGER" ]] || jaula_die 'informe o ledger ou defina HBN_JAULA_LEDGER'
mkdir -p "${LEDGER}/handoffs"
LEDGER="$(jaula_realpath_existing "$LEDGER")"

for required in "$STATE" "$READ_LIST" "$PROFILE" "$RULES"; do
    [[ -r "$required" ]] || jaula_die "insumo ausente: ${required}"
done

stamp="$(jaula_timestamp)"
out="${LEDGER}/handoffs/${stamp}-orq-enjaulado.md"
bundle="$(mktemp "${TMPDIR:-/tmp}/hbn-jaula-attest.XXXXXX")"
trap 'rm -f "$bundle"' EXIT
{
    printf 'BOOT %s  %s\n' "$(jaula_sha256 "$RULES")" "${RULES#${VERSION_ROOT}/}"
    printf 'PROFILE %s  %s\n' "$(jaula_sha256 "$PROFILE")" "${PROFILE#${VERSION_ROOT}/}"
    printf 'READ_LIST %s  %s\n' "$(jaula_sha256 "$READ_LIST")" "${READ_LIST#${VERSION_ROOT}/}"
} > "$bundle"
attestation="$(jaula_sha256 "$bundle")"

cat > "$out" <<EOF
---
titulo: "Handoff automático — orquestrador enjaulado"
tipo: handoff
status: proposto
temperatura: quente
path: ledger/handoffs/$(basename "$out")
created_at: "$(TZ=America/Cuiaba date '+%Y-%m-%dT%H:%M:%S-04:00')"
autor: jaula
familia: mecanica
---
# Orquestrador enjaulado

O habitat é somente-leitura. A única superfície gravável é o ledger externo.
Use \`jaula-sh\`; comandos não listados e escrita fora do ledger falham fechados.
O orquestrador propõe artefatos no ledger; implementador ou gate promove após validação.

STATE_SHA256: $(jaula_sha256 "$STATE")
READ_LIST_SHA256: $(jaula_sha256 "$READ_LIST")
ATTESTATION_SHA256: ${attestation}
ATTESTATION_OPERATOR: ${HBN_ATTESTATION_OPERATOR:-PENDENTE}

## Prompt curto do papel

HOT_VERSION: $(jaula_active_version) | BOOT: $(jaula_active_version)/BOOT.md | CONFIRMACAO_DISCO: SIM
PAPEL orquestrador. Leia, analise e deposite somente propostas no ledger. Não implemente,
não audite, não sele, não commite, não faça push e não tente alterar a jaula.
EOF

printf '%s\n' "$out"
