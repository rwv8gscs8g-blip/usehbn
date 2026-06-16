#!/usr/bin/env bash
# =============================================================================
# guards/tests/adversarial-battery.sh
# path: guards/tests/adversarial-battery.sh · id-global: 20260611-162102-fable5-bateria-adversarial
# BATERIA ADVERSARIAL (onda 0006 I-12 — critério de aceite mecânico da onda,
# ADR-020): tenta CADA burla documentada nos cross-audits 0036/0037 e na
# consolidação 20260611-131310 e EXIGE que o guard correspondente BLOQUEIE.
# Qualquer burla passando = bateria vermelha = onda reprovada.
#
# É também a semente da auditoria Glasswing periódica (desenho §6.4): a cada
# N ondas, uma janela adversarial de família ≠ implementador tenta burlar os
# guards; toda burla nova achada vira linha permanente AQUI.
#
# Uso: bash guards/tests/adversarial-battery.sh   (exit 0 = todas bloqueadas)
# Saída: tabela BURLA × GUARD × RESULTADO.
# =============================================================================
set -uo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARDS_DIR="$(dirname "$TESTS_DIR")"
REPO_ROOT="$(cd "$GUARDS_DIR/.." && pwd)"
unset HBN_GUARDS_BYPASS GLASSWING_BYPASS HBN_DIFF_BASE CI GITHUB_ACTIONS 2>/dev/null || true

SUITE_TMP="$(mktemp -d "${TMPDIR:-/tmp}/hbn-adv.XXXXXX")"
export TMPDIR="$SUITE_TMP"
trap 'rm -rf "$SUITE_TMP" "$TESTS_DIR"/adv-cr.* 2>/dev/null || true; true' EXIT INT TERM

FALHAS=0
ROWS=()
try_burla() { # <descricao> <guard> <rc-obtido>  (esperado: rc != 0 = BLOQUEADA)
    local desc="$1" guard="$2" rc="$3" res
    if [[ "$rc" -ne 0 ]]; then
        res="BLOQUEADA ✓"
    else
        res="PASSOU ✗ (FALHA DA ONDA)"
        FALHAS=$((FALHAS + 1))
    fi
    ROWS+=("$(printf '%-52s | %-8s | %s' "$desc" "$guard" "$res")")
}

mk_repo() { # repo git mínimo
    local d; d="$(mktemp -d)"
    ( cd "$d" && git init -q && git config user.email a@b && git config user.name a && mkdir -p .hbn && echo "." > .hbn/active-version ) >/dev/null 2>&1
    echo "$d"
}

# B1 — nome SERIAL novo em série de evento (o caso 0036/0037)
d="$(mk_repo)"
( cd "$d" && mkdir -p .hbn/results && echo x > .hbn/results/0099-parecer-burlado.md && git add -A ) >/dev/null 2>&1
try_burla "B1 nome serial novo em .hbn/results/" "G-NUM" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-parallel-id.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B2 — created_at em UTC na linha nova do REGISTRY
d="$(mk_repo)"
( cd "$d" && echo x > nota.md && printf '| id | a | t | T | s | created_at |\n|---|---|---|---|---|---|\n' > REGISTRY.md && git add -A && git commit -qm i \
  && printf '| 20260611-101010-agente-x | nota.md | doc | frio | — | 2026-06-11T10:10:10Z |\n' >> REGISTRY.md && git add REGISTRY.md ) >/dev/null 2>&1
try_burla "B2 created_at UTC (Z) no REGISTRY"            "G-NUM"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-parallel-id.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B3 — CI=true em commit local (o bypass do readback 0005)
d="$(mktemp -d -p "$TESTS_DIR" adv-cr.XXXXXX)"
( cd "$d" && git init -q && mkdir .hbn && echo "." > .hbn/active-version && pwd -P > .hbn/canonical-root ) >/dev/null 2>&1
try_burla "B3 CI=true local (sem CI real)"               "G-CR"    "$( ( cd "$d" && CI=true bash "$GUARDS_DIR/assert-canonical-root.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B4 — HBN_GUARDS_BYPASS=1 sem nota staged (Glasswing como burla)
d="$(mk_repo)"
( cd "$d" && git commit -q --allow-empty -m i && echo "SECRET=x" > .env && git add .env ) >/dev/null 2>&1
try_burla "B4 bypass env sem nota em .hbn/bypasses/"     "comuns"  "$( ( cd "$d" && HBN_GUARDS_BYPASS=1 bash "$GUARDS_DIR/forbid-env-files.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B5 — .hbn órfão FUNDO (5 níveis; o falso negativo do maxdepth 4)
r="$(mktemp -d)"
mkdir -p "$r/a/b/c/d/.hbn"
try_burla "B5 .hbn órfão a 5 níveis de profundidade"     "G-STRAY" "$( ( HBN_SCAN_ROOT="$r" bash "$GUARDS_DIR/assert-no-stray-hbn.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$r"

# B6 — SYMLINK chamado .hbn (invisível ao find -type d)
r="$(mktemp -d)"
mkdir -p "$r/alvo" "$r/proj" && ln -s "$r/alvo" "$r/proj/.hbn"
try_burla "B6 symlink .hbn órfão"                        "G-STRAY" "$( ( HBN_SCAN_ROOT="$r" bash "$GUARDS_DIR/assert-no-stray-hbn.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$r"

# B7 — esconder .hbn sob pasta 'backups2' (fora da allowlist)
r="$(mktemp -d)"
mkdir -p "$r/backups2/oculto/.hbn"
try_burla "B7 .hbn escondido sob backups2/"              "G-STRAY" "$( ( HBN_SCAN_ROOT="$r" bash "$GUARDS_DIR/assert-no-stray-hbn.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$r"

# B8 — SCAN_ROOT inválido (fail-open virava bypass ambiental)
try_burla "B8 HBN_SCAN_ROOT apontando para o nada"       "G-STRAY" "$( ( HBN_SCAN_ROOT=/nao/existe bash "$GUARDS_DIR/assert-no-stray-hbn.sh" >/dev/null 2>&1 ); echo $? )"

# B9 — scope.files_allowed VAZIO em safe_track (caso readback 0004)
d="$(mk_repo)"
( cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/readbacks docs \
  && printf '{"readback_id":"0001-t","track":"safe_track","human_status":"confirmed","scope":{"files_allowed":[],"files_forbidden":[]}}\n' > .hbn/readbacks/0001-t.json \
  && git add .hbn/readbacks/0001-t.json && git commit -qm readback \
  && echo x > docs/x.md && git add docs/x.md ) >/dev/null 2>&1
try_burla "B9 scope vazio em safe_track"                 "G-SCO"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-scope-lock.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B10 — implementador escalado como auditor de si mesmo
d="$(mk_repo)"
( cd "$d" && mkdir -p .hbn/relay \
  && printf -- '---\natribuicao:\n  implementador: ego-1\n  auditores: [ego-1, outro-2]\n---\n' > .hbn/relay/STATE.md \
  && git add -A && git commit -qm i ) >/dev/null 2>&1
try_burla "B10 implementador == auditor (groupthink)"    "G-FAM"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-role-family.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B11 — hearback forjado por IA SEM assinatura, com chave de operador registrada
kd="$(mktemp -d)"
ssh-keygen -q -t ed25519 -N "" -f "$kd/op" >/dev/null 2>&1
mkdir -p "$kd/ops" && cp "$kd/op.pub" "$kd/ops/op.pub"
d="$(mk_repo)"
( cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/hearbacks \
  && printf '{"status":"confirmed","signed_by":"Humano Forjado"}\n' > .hbn/hearbacks/9999-forjado.json \
  && git add .hbn/hearbacks/9999-forjado.json ) >/dev/null 2>&1
try_burla "B11 hearback sem assinatura (chave registrada)" "G-HRB"  "$( ( cd "$d" && HBN_OPERATORS_DIR="$kd/ops" bash "$GUARDS_DIR/assert-hearback-integrity.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d" "$kd"

# B12 — hearback staged JUNTO com a obra que ele autoriza
d="$(mk_repo)"
( cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/hearbacks docs \
  && printf '{"status":"confirmed"}\n' > .hbn/hearbacks/9998-junto.json \
  && echo obra > docs/obra.md && git add -A ) >/dev/null 2>&1
try_burla "B12 hearback no mesmo commit da obra"         "G-HRB"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-hearback-integrity.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B13 — exceção F-01 (impl==agente do readback) SEM os sinais exigidos
d="$(mk_repo)"
( cd "$d" && mkdir -p .hbn/relay .hbn/readbacks \
  && printf '{"readback_id":"0007-t","agent_id":"ego-1","track":"safe_track","human_status":"confirmed"}\n' > .hbn/readbacks/0007-t.json \
  && printf -- '---\nsinais_abertos:\n  - "tudo normal"\natribuicao:\n  implementador: ego-1\n  auditores: [outro-2]\n---\n' > .hbn/relay/STATE.md \
  && git add -A -f && git commit -qm i ) >/dev/null 2>&1
try_burla "B13 exceção impl==agente sem os 4 sinais"     "G-EXC"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-exception-traceable.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B14 — posse forjada: arquivo .git/hbn-baton-token com token ERRADO e
# fingerprint correto copiado do log (G-TOK v2 — replay do fingerprint
# público NÃO abre o hook sem o arquivo de token legítimo)
d="$(mk_repo)"
( cd "$d" && mkdir -p .hbn/relay \
  && HASH_LEGIT="$(printf '%s' token-legitimo | sha256sum | awk '{print $1}')" \
  && printf -- '---\nbastao_token_sha256: %s\n---\n' "$HASH_LEGIT" > .hbn/relay/STATE.md \
  && git add -A && git commit -qm i \
  && printf '%s\n' token-roubado > .git/hbn-baton-token \
  && printf 'feat: x\n\nHBN-Token-FP: %s\n' "$(printf '%s' "$HASH_LEGIT" | cut -c1-8)" > msg.txt ) >/dev/null 2>&1
try_burla "B14 arquivo de token local ERRADO + FP do log" "G-TOK"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-baton-token.sh" "$d/msg.txt" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B15 — conflito de merge no ponteiro de versão ativa deve falhar fechado
d="$(mktemp -d -p "$TESTS_DIR" adv-cr-active.XXXXXX)"
(
  cd "$d" && git init -q && mkdir -p .hbn versao_1_0_0 \
  && pwd -P > .hbn/canonical-root \
  && printf '<<<<<<< ours\n.\n=======\nversao_1_0_0\n>>>>>>> theirs\n' > .hbn/active-version
) >/dev/null 2>&1
try_burla "B15 active-version com conflito de merge"    "G-CR"    "$( ( cd "$d" && bash "$GUARDS_DIR/assert-canonical-root.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B16 — auto-emenda de escopo: readback estende files_allowed e usa o delta no
# mesmo commit (regressao do drible ca69ef9).
d="$(mk_repo)"
(
  cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/readbacks \
  && cat > .hbn/readbacks/0001-t.json <<'EOF'
{
  "readback_id": "0001-t",
  "track": "safe_track",
  "human_status": "confirmed",
  "scope": {
    "files_allowed": [".hbn/readbacks/0001-t.json", "docs/vigente/**"],
    "files_forbidden": []
  }
}
EOF
  git add .hbn/readbacks/0001-t.json && git commit -qm readback \
  && cat > .hbn/readbacks/0001-t.json <<'EOF'
{
  "readback_id": "0001-t",
  "track": "safe_track",
  "human_status": "confirmed",
  "scope_extension": {
    "human": "Tester Humano",
    "evidence": "autoriza somente extensao isolada",
    "created_at": "2026-06-15T10:43:09-03:00",
    "allowed_delta": ["docs/novo/**"]
  },
  "scope": {
    "files_allowed": [".hbn/readbacks/0001-t.json", "docs/vigente/**", "docs/novo/**"],
    "files_forbidden": []
  }
}
EOF
  mkdir -p docs/novo && echo x > docs/novo/parecer.md \
  && git add .hbn/readbacks/0001-t.json docs/novo/parecer.md
) >/dev/null 2>&1
try_burla "B16 auto-emenda files_allowed + uso"          "G-SCO"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-scope-lock.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B17 — smuggling por meta-path: payload de tipo/nome arbitrario em caminhos de
# coordenacao nao pode ser auto-permitido pelo scope-lock.
d="$(mk_repo)"
(
  cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/readbacks .hbn/bypasses .hbn/messages \
  && cat > .hbn/readbacks/0001-t.json <<'EOF'
{
  "readback_id": "0001-t",
  "track": "safe_track",
  "human_status": "confirmed",
  "scope": {
    "files_allowed": ["docs/**"],
    "files_forbidden": []
  }
}
EOF
  git add .hbn/readbacks/0001-t.json && git commit -qm readback \
  && printf 'echo payload\n' > .hbn/bypasses/payload.sh \
  && printf 'print(1)\n' > .hbn/messages/exploit.py \
  && git add .hbn/bypasses/payload.sh .hbn/messages/exploit.py
) >/dev/null 2>&1
try_burla "B17 smuggling meta-path tipo/nome arbitrario" "G-SCO"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-scope-lock.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B18 — symlink com basename ADR-025 em meta-path governado nao pode ser
# auto-permitido pelo scope-lock.
d="$(mk_repo)"
(
  cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/readbacks .hbn/messages \
  && cat > .hbn/readbacks/0001-t.json <<'EOF'
{
  "readback_id": "0001-t",
  "track": "safe_track",
  "human_status": "confirmed",
  "scope": {
    "files_allowed": ["docs/**"],
    "files_forbidden": []
  }
}
EOF
  git add .hbn/readbacks/0001-t.json && git commit -qm readback \
  && printf 'echo payload\n' > payload.sh \
  && ln -s ../../payload.sh .hbn/messages/20260615-120000-codex-handoff-x.md \
  && git add .hbn/messages/20260615-120000-codex-handoff-x.md
) >/dev/null 2>&1
try_burla "B18 symlink ADR-025 em meta-path governado"  "G-SCO"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-scope-lock.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B19 — symlink em path governado nao-.hbn com nome que casa files_allowed
# permissivo tambem deve ser bloqueado.
d="$(mk_repo)"
(
  cd "$d" && git commit -q --allow-empty -m i && mkdir -p .hbn/readbacks guards \
  && cat > .hbn/readbacks/0001-t.json <<'EOF'
{
  "readback_id": "0001-t",
  "track": "safe_track",
  "human_status": "confirmed",
  "scope": {
    "files_allowed": ["guards/**"],
    "files_forbidden": []
  }
}
EOF
  git add .hbn/readbacks/0001-t.json && git commit -qm readback \
  && printf 'echo payload\n' > payload.sh \
  && ln -s ../payload.sh guards/falso-guard.sh \
  && git add guards/falso-guard.sh
) >/dev/null 2>&1
try_burla "B19 symlink em guards/ permitido por escopo" "G-SCO"   "$( ( cd "$d" && bash "$GUARDS_DIR/assert-scope-lock.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B20 — dispatch com token_fp diferente do prefixo do STATE.
mk_dispatch_repo() {
    local d; d="$(mktemp -d)"
    (
      cd "$d"
      git init -q
      git config user.email a@b
      git config user.name a
      mkdir -p .hbn/relay .hbn/readbacks .hbn/dispatch schemas
      echo "." > .hbn/active-version
      cp "$REPO_ROOT/schemas/dispatch.schema.json" schemas/dispatch.schema.json
      cat > .hbn/relay/STATE.md <<'EOF'
---
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
readback_ativo: ".hbn/readbacks/0025-s2-dispatch-auto-declarante.json"
---
EOF
      cat > .hbn/readbacks/0025-s2-dispatch-auto-declarante.json <<'EOF'
{"readback_id":"0025-s2-dispatch-auto-declarante","track":"safe_track","human_status":"confirmed","scope":{"files_allowed":[".hbn/dispatch/0025-s2-dispatch-auto-declarante.md"],"files_forbidden":[]}}
EOF
      git add -A
      git commit -qm init
    ) >/dev/null 2>&1
    echo "$d"
}
write_dispatch_adv() {
    local d="$1" rb="${2:-0025-s2-dispatch-auto-declarante}" fp="${3:-34a7f2f9}" body="${4:-Executar despacho sem comentario.}"
    (
      cd "$d" && cat > .hbn/dispatch/0025-s2-dispatch-auto-declarante.md <<EOF
---
dispatch_id: 0025-s2-dispatch-auto-declarante
path: .hbn/dispatch/0025-s2-dispatch-auto-declarante.md
readback_id: ${rb}
token_fp: ${fp}
human_authorization: Mauricio (Luis Mauricio Junqueira Zanin)
scope:
  files_allowed:
    - .hbn/dispatch/0025-s2-dispatch-auto-declarante.md
  files_forbidden:
    - main
action_plan:
  - Executar S2
---
${body}
EOF
      git add .hbn/dispatch/0025-s2-dispatch-auto-declarante.md
    ) >/dev/null 2>&1
}
d="$(mk_dispatch_repo)"
write_dispatch_adv "$d" "0025-s2-dispatch-auto-declarante" "deadbeef"
try_burla "B20 dispatch token_fp divergente do STATE"  "G-DSP-INT" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-dispatch-integrity.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B21 — dispatch declarando readback inexistente/nao-ativo.
d="$(mk_dispatch_repo)"
write_dispatch_adv "$d" "0099-inexistente" "34a7f2f9"
try_burla "B21 dispatch readback inexistente/nao-ativo" "G-DSP-INT" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-dispatch-integrity.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B22 — corpo colavel quebra zsh-safe com linha iniciada por '#'.
d="$(mk_dispatch_repo)"
write_dispatch_adv "$d" "0025-s2-dispatch-auto-declarante" "34a7f2f9" "# comentario que nao pode ser colado"
try_burla "B22 dispatch com linha # no corpo colavel" "G-DSP-FMT" "$( ( cd "$d" && bash "$GUARDS_DIR/validate-dispatch.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B23 — G-EXC em modo CI nao pode aceitar commit que termina com HBN-Token-FP
# mas omite HBN-Human-Authorization.
d="$(mk_repo)"
(
  cd "$d"
  mkdir -p .hbn/relay .hbn/readbacks docs
  cat > .hbn/readbacks/0007-t.json <<'EOF'
{"readback_id":"0007-t","agent_id":"ego-1","authorization":{"human":"Tester Humano","evidence":"ordem em chat 2026-06-16"},"track":"safe_track","human_status":"confirmed","scope":{"files_allowed":["**"],"files_forbidden":[]}}
EOF
  cat > .hbn/relay/STATE.md <<'EOF'
---
sinais_abertos:
  - "🔴 EXCEÇÃO F-01 ATIVA — PROPOSED_UNTIL_CROSS_AUDIT"
atribuicao:
  implementador: ego-1
  auditores: [outro-2]
---
EOF
  git add -A -f
  git commit -qm init
) >/dev/null 2>&1
base="$(git -C "$d" rev-parse HEAD)"
(
  cd "$d"
  echo payload > docs/b23.md
  git add docs/b23.md
  git commit -qm $'feat: b23\n\nHBN-Readback: 0007\nHBN-Token-FP: 34a7f2f9'
) >/dev/null 2>&1
try_burla "B23 CI trailer token sem autorizacao humana" "G-EXC" "$( ( cd "$d" && HBN_DIFF_BASE="$base" bash "$GUARDS_DIR/assert-exception-traceable.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B24 — knowledge nova sem linha no INDEX nao pode entrar.
d="$(mk_repo)"
(
  cd "$d"
  mkdir -p .hbn/knowledge
  cat > .hbn/knowledge/INDEX.md <<'EOF'
# Knowledge Index

| Entrada | Uso |
|---|---|
| `0001-base.md` | Base testada. |
EOF
  echo "# Base" > .hbn/knowledge/0001-base.md
  git add -A
  git commit -qm init
  echo "# Burla" > .hbn/knowledge/9999-burla-sem-index.md
  git add .hbn/knowledge/9999-burla-sem-index.md
) >/dev/null 2>&1
try_burla "B24 knowledge nova ausente do INDEX" "G-KNOW" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-knowledge-index.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B25 — role-cards inflado e read-list estourada nao pode entrar.
d="$(mk_repo)"
(
  cd "$d"
  mkdir -p core
  cat > core/role-cards.md <<'EOF'
# Porta Da Frente De Papeis

## PARTE A - READ-LIST DA PORTA DA FRENTE

1. `.hbn/relay/STATE.md`
2. O readback ativo apontado no STATE.
3. `core/role-cards.md`
4. `.hbn/knowledge/0001-comandos-atomicos-copiaveis.md`
5. `.hbn/knowledge/0002-entrega-operacional-minimalista.md`
6. `.hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md`
7. `docs/tentativa-de-monolito.md`

## PARTE B - TRES CARTOES
EOF
  for i in {1..135}; do echo "linha inflada $i"; done >> core/role-cards.md
  git add core/role-cards.md
) >/dev/null 2>&1
try_burla "B25 role-cards inflado/read-list >6" "G-FRONT" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-frontdoor.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B26 — arquivo staged em scratch/ nao pode entrar no historico.
d="$(mk_repo)"
(
  cd "$d"
  mkdir -p scratch
  echo segredo > scratch/segredo.txt
  git add scratch/segredo.txt
) >/dev/null 2>&1
try_burla "B26 arquivo staged em scratch/" "G-SCRATCH-LOCK" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-scratch-lock.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B27 — symlink staged em scratch/ nao pode escapar da area efemera.
d="$(mk_repo)"
(
  cd "$d"
  mkdir -p scratch
  ln -s ../core scratch/link
  git add scratch/link
) >/dev/null 2>&1
try_burla "B27 symlink staged em scratch/" "G-SCRATCH-SYMLINK" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-scratch-symlink.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B28 — .gitignore staged sem /scratch/ remove a protecao da area efemera.
d="$(mk_repo)"
(
  cd "$d"
  printf '!/scratch/README.md\n' > .gitignore
  git add .gitignore
) >/dev/null 2>&1
try_burla "B28 .gitignore staged sem /scratch/" "G-SCRATCH-IGNORE" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-scratch-ignore.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B29 — INDEX nao pode satisfazer 0002 via substring em 10002 nem manter
# ponteiro morto para NNNN-*.md inexistente.
d="$(mk_repo)"
(
  cd "$d"
  mkdir -p .hbn/knowledge
  cat > .hbn/knowledge/INDEX.md <<'EOF'
# Knowledge Index

| Entrada | Uso |
|---|---|
| `0001-base.md` | Base testada. |
| `10002-nova.md` | Substring que antes satisfazia 0002-nova.md. |
| `9999-ponteiro-morto.md` | Ponteiro morto. |
EOF
  echo "# Base" > .hbn/knowledge/0001-base.md
  git add -A
  git commit -qm init
  echo "# Nova" > .hbn/knowledge/0002-nova.md
  git add .hbn/knowledge/0002-nova.md
) >/dev/null 2>&1
try_burla "B29 knowledge substring + ponteiro morto" "G-KNOW" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-knowledge-index.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B30 — linha unica densa abaixo do teto de linhas antigo nao pode passar.
d="$(mk_repo)"
(
  cd "$d"
  mkdir -p core
  {
    echo "# Porta Da Frente De Papeis"
    printf 'x%.0s' {1..9000}
    echo
    echo "## PARTE A - READ-LIST DA PORTA DA FRENTE"
    echo "1. \`.hbn/relay/STATE.md\`"
    echo "## PARTE B - TRES CARTOES"
  } > core/role-cards.md
  mkdir -p .hbn/relay
  echo "---" > .hbn/relay/STATE.md
  git add core/role-cards.md .hbn/relay/STATE.md
) >/dev/null 2>&1
try_burla "B30 frontdoor linha unica densa" "G-FRONT" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-frontdoor.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B30 — path concreto inexistente na read-list tambem deve bloquear.
d="$(mk_repo)"
(
  cd "$d"
  mkdir -p core .hbn/relay .hbn/knowledge
  cat > core/role-cards.md <<'EOF'
# Porta Da Frente De Papeis

## PARTE A - READ-LIST DA PORTA DA FRENTE

1. `.hbn/relay/STATE.md`
2. O readback ativo apontado no STATE.
3. `core/role-cards.md`
4. `core/inexistente-na-read-list.md`

## PARTE B - TRES CARTOES
EOF
  echo "---" > .hbn/relay/STATE.md
  git add core/role-cards.md .hbn/relay/STATE.md
) >/dev/null 2>&1
try_burla "B30 frontdoor path inexistente" "G-FRONT" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-frontdoor.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# B31 — prosa no corpo com linhas HBN-* nao substitui trailers reais no ultimo
# paragrafo.
d="$(mk_repo)"
(
  cd "$d"
  mkdir -p .hbn/relay .hbn/readbacks
  cat > .hbn/readbacks/0007-t.json <<'EOF'
{"readback_id":"0007-t","agent_id":"ego-1","authorization":{"human":"Tester Humano","evidence":"ordem em chat 2026-06-16"},"track":"safe_track","human_status":"confirmed","scope":{"files_allowed":["**"],"files_forbidden":[]}}
EOF
  cat > .hbn/relay/STATE.md <<'EOF'
---
sinais_abertos:
  - "🔴 EXCEÇÃO F-01 ATIVA — PROPOSED_UNTIL_CROSS_AUDIT"
atribuicao:
  implementador: ego-1
  auditores: [outro-2]
---
EOF
  git add -A -f
  git commit -qm init
  cat > msg-b31.txt <<'EOF'
feat: b31

Corpo menciona trailers antigos:
HBN-Readback: 0007
HBN-Human-Authorization: ordem-tester

Resumo final sem trailers reais.
EOF
) >/dev/null 2>&1
try_burla "B31 prosa HBN-* no corpo sem trailers finais" "G-EXC" "$( ( cd "$d" && bash "$GUARDS_DIR/assert-exception-traceable.sh" "$d/msg-b31.txt" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# --- Saída legível (ADR-022): BURLA × GUARD × RESULTADO ----------------------
echo ""
printf '%-52s | %-8s | %s\n' "BURLA" "GUARD" "RESULTADO"
printf '%.0s-' {1..80}; echo ""
for row in "${ROWS[@]}"; do echo "$row"; done
echo ""
if [[ "$FALHAS" -ne 0 ]]; then
    echo "BATERIA VERMELHA — ${FALHAS} burla(s) PASSARAM. Onda reprovada (ADR-020)."
    exit 1
fi
echo "BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente."
exit 0
