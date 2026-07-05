#!/usr/bin/env bash
set -euo pipefail

# reproduction script for W-ORQ-3 deadlock under G-ORQ-REF
# Created by Antigravity (Google family, auditor role)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
GUARDS_DIR="${REPO_ROOT}/guards"

# Create a temporary directory
TEMP_DIR="$(mktemp -d)"
echo "Created temporary repo at: ${TEMP_DIR}"
cd "${TEMP_DIR}"

# Initialize git
git init -q
git config user.email "auditor@hbn.local"
git config user.name "Auditor Antigravity"

# Copy guards directory structure/files needed
mkdir -p guards/lib guards/data schemas
cp -r "${GUARDS_DIR}/lib/" guards/lib/
cp -r "${GUARDS_DIR}/data/" guards/data/
cp "${GUARDS_DIR}/assert-orq-entrada.sh" guards/
cp "${GUARDS_DIR}/assert-orq-entrada-ref.sh" guards/
cp "${REPO_ROOT}/schemas/dispatch.schema.json" schemas/

# Setup HBN structure
mkdir -p .hbn/relay .hbn/readbacks .hbn/messages .hbn/attestations .hbn/knowledge agents core

# Write active-version and canonical-root
echo "." > .hbn/active-version
pwd -P > .hbn/canonical-root

# Write base files
cat > .hbn/relay/STATE.md <<'EOF'
---
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: claude-opus-4-8
papel_bastao: "orquestrador"
readback_ativo: ".hbn/readbacks/0056-g-orq-entrada.json"
handoff_mais_recente: ".hbn/messages/20260618-003300-codex-handoff-g-orq-entrada.md"
proxima_acao: "Cross-audit do gate G-ORQ-ENTRADA."
atribuicao:
  chapeu_atual: orquestrador
  implementador: codex
---
EOF

echo '{"readback_id":"0056-g-orq-entrada","execution_id":"g-orq-entrada-test-2026-06-18","agent_id":"codex","track":"safe_track","human_status":"confirmed","authorization":{"human":"Mauricio","evidence":"teste"}}' > .hbn/readbacks/0056-g-orq-entrada.json
echo "# Handoff G-ORQ-ENTRADA" > .hbn/messages/20260618-003300-codex-handoff-g-orq-entrada.md
echo "# role templates" > agents/role-templates.md
echo "# firewall 0022" > .hbn/knowledge/0022-firewall-workflow-fast-track.md
echo "# role cards" > core/role-cards.md
echo "# comandos" > .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
echo "# entrega" > .hbn/knowledge/0002-entrega-operacional-minimalista.md
echo "# temporaria" > .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md
echo "# gate enforcado falha fechado" > .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md
echo "# auditor read-only" > .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
echo "# fornecedor(implementador) != fornecedor(orquestrador)" > core/orchestrator-profile-spec.md
echo "# STATE <= 80 linhas" > core/relay-spec.md

# Generate core/read-list-canonica.txt
cat > core/read-list-canonica.txt <<EOF
$(git hash-object .hbn/relay/STATE.md) .hbn/relay/STATE.md
DYNAMIC handoff_mais_recente
DYNAMIC readback_ativo
$(git hash-object agents/role-templates.md) agents/role-templates.md
$(git hash-object .hbn/knowledge/0022-firewall-workflow-fast-track.md) .hbn/knowledge/0022-firewall-workflow-fast-track.md
$(git hash-object core/role-cards.md) core/role-cards.md
$(git hash-object .hbn/knowledge/0001-comandos-atomicos-copiaveis.md) .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
$(git hash-object .hbn/knowledge/0002-entrega-operacional-minimalista.md) .hbn/knowledge/0002-entrega-operacional-minimalista.md
$(git hash-object .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md) .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md
$(git hash-object .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md) .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md
$(git hash-object .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md) .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
$(git hash-object core/orchestrator-profile-spec.md) core/orchestrator-profile-spec.md
$(git hash-object core/relay-spec.md) core/relay-spec.md
EOF

git add -A

# Helper to write valid orq attestation
write_attestation() {
    python3 - <<'PY'
import hashlib, json, re, subprocess

TOKEN_FP = "34a7f2f9"
ALGORITHM = "orq-entrada.v2/extractive-lines"
STATE = ".hbn/relay/STATE.md"
READ_LIST = "core/read-list-canonica.txt"

def git_bytes(*args):
    return subprocess.check_output(["git", *args], stderr=subprocess.DEVNULL)

def blob(path):
    oid = git_bytes("rev-parse", f":{path}").decode().strip()
    return oid, git_bytes("cat-file", "-p", oid)

def sha256_b(value):
    return hashlib.sha256(value).hexdigest()

def sha256_s(value):
    return sha256_b(value.encode())

def canonical(value):
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))

def state_value(text, key):
    for line in text.splitlines():
        if not re.match(rf"^\s*{re.escape(key)}:", line):
            continue
        value = re.sub(r"\s+#.*$", "", line.split(":", 1)[1]).strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
            value = value[1:-1]
        return value
    return ""

_, state_content = blob(STATE)
state_text = state_content.decode()
handoff = state_value(state_text, "handoff_mais_recente")
readback = state_value(state_text, "readback_ativo")

_, read_list_content = blob(READ_LIST)
paths = []
for raw in read_list_content.decode().splitlines():
    line = raw.split("#", 1)[0].strip()
    if not line:
        continue
    if line == "DYNAMIC handoff_mais_recente":
        paths.append(handoff)
    elif line == "DYNAMIC readback_ativo":
        paths.append(readback)
    else:
        paths.append(line.split(None, 1)[1])

manifest = []
content_by_path = {}
for path in paths:
    oid, content = blob(path)
    text = content.decode()
    nonempty = [(i, line) for i, line in enumerate(text.splitlines(), 1) if line.strip()]
    content_by_path[path] = (content, nonempty)
    manifest.append({
        "path": path,
        "blob_oid": oid,
        "sha256": sha256_b(content),
        "bytes": len(content),
        "nonempty_lines": len(nonempty),
    })

manifest_sha = sha256_s(canonical(manifest))
readback_data = json.loads(content_by_path[readback][0].decode())
execution_id = readback_data["execution_id"]
seed = sha256_s(f"orq-entrada.v2\n{execution_id}\n{TOKEN_FP}\n{manifest_sha}")

line_responses = []
for path in [STATE, readback, "core/orchestrator-profile-spec.md"]:
    record = next(item for item in manifest if item["path"] == path)
    idx = int(sha256_s(f"{seed}\n{path}\n{record['blob_oid']}")[:8], 16) % record["nonempty_lines"]
    line_no, line_text = content_by_path[path][1][idx]
    line_responses.append({
        "path": path,
        "line_no": line_no,
        "line_text": line_text,
        "line_sha256": sha256_s(line_text),
    })

data = {
    "papel": "orquestrador",
    "identidade": "opus-4-8",
    "proprietario_bastao": "claude-opus-4-8",
    "bastao_token_fp": TOKEN_FP,
    "algorithm": ALGORITHM,
    "execution_id": execution_id,
    "read_list_ref": READ_LIST,
    "atestado_por": "opus-4-8",
    "atestado_em": "2026-06-18T01:58:00-03:00",
    "manifest_sha256": manifest_sha,
    "challenge": {
        "seed_sha256": seed,
        "line_responses": line_responses,
        "field_responses": [
            {"path": STATE, "field": "readback_ativo", "value": readback},
            {"path": STATE, "field": "proxima_acao", "value": state_value(state_text, "proxima_acao")},
        ],
    },
}
with open(".hbn/attestations/34a7f2f9-orq-entrada.json", "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
}

write_attestation
git add .hbn/attestations/34a7f2f9-orq-entrada.json
git commit -qm "init orq-entrada and attestation"

# Update active readback with orq_entrada_ref
python3 - <<'PY'
import json
path = ".hbn/readbacks/0056-g-orq-entrada.json"
data = json.load(open(path, encoding="utf-8"))
data["orq_entrada_ref"] = ".hbn/attestations/34a7f2f9-orq-entrada.json"
json.dump(data, open(path, "w", encoding="utf-8"), indent=2, ensure_ascii=False)
open(path, "a", encoding="utf-8").write("\n")
PY
git add .hbn/readbacks/0056-g-orq-entrada.json
write_attestation
git add .hbn/attestations/34a7f2f9-orq-entrada.json
git commit -qm "add orq_entrada_ref"

echo "=== Base state committed successfully. ==="
echo "Active readback now points to: $(python3 -c "import json; print(json.load(open('.hbn/readbacks/0056-g-orq-entrada.json'))['orq_entrada_ref'])")"

# Now we stage a "selagem" change:
# 1. Update STATE.md (simulating updating readback_ativo to a new selagem readback and proxima_acao)
cat > .hbn/relay/STATE.md <<'EOF'
---
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: claude-opus-4-8
papel_bastao: "orquestrador"
readback_ativo: ".hbn/readbacks/0062-selagem-teste.json"
handoff_mais_recente: ".hbn/messages/20260618-003300-codex-handoff-g-orq-entrada.md"
proxima_acao: "Selagem realizada."
atribuicao:
  chapeu_atual: orquestrador
  implementador: codex
---
EOF

# 2. Create the new authority readback file (selagem)
cat > .hbn/readbacks/0062-selagem-teste.json <<'EOF'
{
  "readback_id": "0062-selagem-teste",
  "execution_id": "selagem-teste-execution-1234",
  "agent_id": "codex",
  "track": "safe_track",
  "authority_act": "selagem",
  "status": "selado",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json"
}
EOF

git add .hbn/relay/STATE.md .hbn/readbacks/0062-selagem-teste.json

echo ""
echo "=== Case 1: Staging changes but NOT regenerating the attestation ==="
echo "Running assert-orq-entrada-ref.sh..."
if bash guards/assert-orq-entrada-ref.sh; then
    echo "Case 1 PASSED (unexpected - should be blocked)"
else
    echo "Case 1 BLOCKED (as expected)"
fi

echo ""
echo "=== Case 2: Regenerating the attestation in the same commit ==="
echo "Generating new attestation..."
# Update the read-list index hash references before generating the attestation so that git rev-parse :path resolves the newly staged contents
# We update the canonical read-list to point to the new staged hash for STATE.md
# Wait, let's update read-list-canonica.txt to have the staged hashes of state and readback
cat > core/read-list-canonica.txt <<EOF
$(git hash-object .hbn/relay/STATE.md) .hbn/relay/STATE.md
DYNAMIC handoff_mais_recente
DYNAMIC readback_ativo
$(git hash-object agents/role-templates.md) agents/role-templates.md
$(git hash-object .hbn/knowledge/0022-firewall-workflow-fast-track.md) .hbn/knowledge/0022-firewall-workflow-fast-track.md
$(git hash-object core/role-cards.md) core/role-cards.md
$(git hash-object .hbn/knowledge/0001-comandos-atomicos-copiaveis.md) .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
$(git hash-object .hbn/knowledge/0002-entrega-operacional-minimalista.md) .hbn/knowledge/0002-entrega-operacional-minimalista.md
$(git hash-object .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md) .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md
$(git hash-object .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md) .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md
$(git hash-object .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md) .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
$(git hash-object core/orchestrator-profile-spec.md) core/orchestrator-profile-spec.md
$(git hash-object core/relay-spec.md) core/relay-spec.md
EOF
git add core/read-list-canonica.txt

write_attestation
git add .hbn/attestations/34a7f2f9-orq-entrada.json

echo "Running assert-orq-entrada-ref.sh..."
if bash guards/assert-orq-entrada-ref.sh; then
    echo "Case 2 PASSED (unexpected - should be blocked)"
else
    echo "Case 2 BLOCKED (as expected)"
fi

# Clean up
rm -rf "${TEMP_DIR}"
