---
titulo: "Despacho — P2-B: implementar --install no install-snapshot.sh (readback 0100, pendente cross-audit)"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260626-190000-opus-4-8-despacho-p2b-install.md
readback_alvo: 0100-p2b-install-mode
created_at: "2026-06-26T19:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md
  - scripts/hbn-snapshot/install-snapshot.sh
  - .hbn/relay/STATE.md
---

# HBN — Despacho P2-B (implementar --install)

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-26T19:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador (zelador das regras pelo exemplo — k-0029).
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-26T19:00:00-03:00 readback_ativo=.hbn/readbacks/0100-p2b-install-mode.json; main intocada 4db6928; HEAD 4af2462.
PRÓXIMA AÇÃO: P2-B cross-audit do --install (readback 0100); depois selagem 0101; depois Mauricio roda --install no Credenciamento
BASTÃO: opus-4-8 (Anthropic), atestacao v2 valida (34a7f2f9). Ato de autoridade sob G-ORQ-REF (Exit A').

## Decisões informais (cápsula)
- P2-A selado (0098 via 0099). P2-B implementa o modo `--install` do install-snapshot.sh (hoje fail-closed): cria `.usehbn-snapshot/` (git archive do tag + manifesto/sha + header + VERSION + CONSUMER-PROFILE), escreve `scripts/hbn-snapshot/assert-snapshot-integrity.sh` LOCAL no target, cria `.hbn/active-version=.` e aplica chmod read-only. NAO toca o Credenciamento nesta onda: a entrega so MODIFICA o script no protocolo; o `--install` real no projeto e ato HUMANO (P2-B parte 2, firewall 0022).
- Validado pelo orquestrador no sandbox (target git temporario): dry-run 137/8796b672…; --install cria membrana correta; integridade verde pos-install e detecta drift; --install recusa se ja existe. readback 0100 e PROPOSTA (PROPOSED_UNTIL_CROSS_AUDIT): codigo novo -> cross-audit !=OpenAI + selagem antes do uso real.

⟦HBN-COPY dest=codex⟧ BEGIN
PARA: codex (implementador · OpenAI). SOB: bastao token_fp 34a7f2f9. ORQUESTRADOR: opus-4-8 · Anthropic. TRACK: safe_track.
HEAD esperado: 4af2462. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
OBJETIVO: substituir scripts/hbn-snapshot/install-snapshot.sh pela versao com --install implementado (abaixo, VERBATIM). NAO rodar --install no Credenciamento (isso e ato humano de P2-B parte 2). Entregar como PROPOSTA (0100).
LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO; readback gitignored -> git add -f); honre TODOS os guards; se UM bloquear, PARE e relate.
IMPORTANTE: SALVE ESTE DESPACHO VERBATIM (RELATO DE ESTADO + heading "## Decisões informais (cápsula)"). NAO reescreva o relato (G-RLT: strings exatas — token `ultima_atualizacao=2026-06-26T19:00:00-03:00`, linha `PRÓXIMA AÇÃO:` igual ao proxima_acao do STATE, heading acentuado).

C1. SOBRESCREVER scripts/hbn-snapshot/install-snapshot.sh com EXATAMENTE este conteudo (chmod +x):
```bash
#!/usr/bin/env bash
# scripts/hbn-snapshot/install-snapshot.sh — distribui o snapshot read-only do PROTOCOLO useHBN.
# Modos: --dry-run (default) | --verify-only | --install | --upgrade
set -euo pipefail
export LC_ALL=C
MODE="--dry-run"; PROTO="${HBN_PROTO:-$HOME/Projetos/usehbn}"; TAG="${HBN_TAG:-v1-estavel}"
TARGET=""; SURFACE="core methodology schemas guards"
while [[ $# -gt 0 ]]; do case "$1" in
  --dry-run|--verify-only|--install|--upgrade) MODE="$1";;
  --proto) PROTO="$2"; shift;; --tag) TAG="$2"; shift;;
  --target) TARGET="$2"; shift;; --surface) SURFACE="$2"; shift;;
  *) echo "arg desconhecido: $1" >&2; exit 2;; esac; shift; done
sha256() { if command -v sha256sum >/dev/null 2>&1; then sha256sum; else shasum -a 256; fi | cut -d' ' -f1; }
COMMIT="$(git -C "$PROTO" rev-parse "${TAG}^{commit}")"
gen_manifest() { # imprime "mode sha256(LF) path" ordenado por path, da TREE do tag
  git -C "$PROTO" ls-tree -r -z --full-tree "$TAG" -- $SURFACE \
  | while IFS= read -r -d '' rec; do
      meta="${rec%%$'\t'*}"; path="${rec#*$'\t'}"; mode="${meta%% *}"; oid="${meta##* }"
      csha="$(git -C "$PROTO" cat-file blob "$oid" | tr -d '\r' | sha256)"
      printf '%s %s %s\n' "$mode" "$csha" "$path"
    done | LC_ALL=C sort -k3
}
echo "PROTO=$PROTO"; echo "TAG=$TAG"; echo "COMMIT=$COMMIT"; echo "SURFACE=$SURFACE"
MANFILE="$(mktemp)"; gen_manifest > "$MANFILE"
COUNT="$(grep -c . "$MANFILE")"; PROTOCOL_SHA256="$(sha256 < "$MANFILE")"
echo "FILE_COUNT=$COUNT"; echo "PROTOCOL_SHA256=$PROTOCOL_SHA256"
GUARDS_PROJETO="assert-canonical-root forbid-tmp-worktree forbid-env-files forbid-legacy-paths assert-scratch-lock assert-scratch-symlink assert-scratch-ignore assert-zona-livre assert-scope-lock assert-hearback-integrity assert-no-stray-hbn assert-self-path assert-trailers-contiguous assert-report-fresh assert-readlist-rite assert-knowledge-index"
GUARDS_EXCL="assert-orq-entrada assert-orq-entrada-ref validate-dispatch assert-dispatch-integrity assert-registry-line assert-pointer-honest assert-arvore-label assert-auditor-id assert-audit-diversity assert-quorum-selagem assert-parallel-id freeze-gate assert-baton-token"
echo "GUARDS_PROJETO=$GUARDS_PROJETO"; echo "GUARDS_GENOMA_EXCLUIDOS=$GUARDS_EXCL"

write_membrane() { # $1 = SNAP dir (ja existe, vazio)
  local SNAP="$1"
  git -C "$PROTO" archive --format=tar "$TAG" -- $SURFACE | tar -x -C "$SNAP"
  cp "$MANFILE" "$SNAP/PROTOCOL_MANIFEST.sha256"
  printf 'protocol_sha256=%s\ntag=%s\ncommit=%s\ngenerated_at=%s\nsurface=%s\nfile_count=%s\n' \
    "$PROTOCOL_SHA256" "$TAG" "$COMMIT" "$(date -u +%FT%TZ)" "$SURFACE" "$COUNT" > "$SNAP/PROTOCOL_SHA256.txt"
  printf '%s\n' "$TAG" > "$SNAP/VERSION"
  cat > "$SNAP/USEHBN-HEADER.txt" <<HDR
ISTO E O PROTOCOLO useHBN (usehbn@$TAG, commit $COMMIT) — read-only.
NAO EDITAR. Para ler a regra: aqui (.usehbn-snapshot/, read-only).
Para trabalhar no projeto: na raiz do projeto. Para melhorar o protocolo:
deposite em inbox/credenciamento/ do protocolo (nunca edite o genoma direto).
Qualquer edicao deste diretorio e bloqueada por assert-snapshot-integrity.
HDR
  cat > "$SNAP/CONSUMER-PROFILE.md" <<PROF
# Perfil de consumidor do snapshot (usehbn@$TAG)
protocol_sha256: $PROTOCOL_SHA256
surface: $SURFACE
guards_projeto: $GUARDS_PROJETO
guards_genoma_excluidos: $GUARDS_EXCL
PROF
}

write_integrity_guard() { # $1 = TGT_TOP
  local d="$1/scripts/hbn-snapshot"; mkdir -p "$d"
  cat > "$d/assert-snapshot-integrity.sh" <<'GUARD'
#!/usr/bin/env bash
# assert-snapshot-integrity.sh (LOCAL) — bloqueia drift/edicao de .usehbn-snapshot/.
set -euo pipefail; export LC_ALL=C
G="assert-snapshot-integrity"
TOP="$(git rev-parse --show-toplevel)"; SNAP="$TOP/.usehbn-snapshot"
sha256(){ if command -v sha256sum >/dev/null 2>&1; then sha256sum; else shasum -a 256; fi | cut -d' ' -f1; }
[[ -d "$SNAP" ]] || { echo "[$G] sem .usehbn-snapshot — nada a verificar."; exit 0; }
[[ -e "$SNAP/.git" ]] && { echo "[$G] ✗ .git dentro do snapshot" >&2; exit 1; }
if find "$SNAP" -type l | grep -q .; then echo "[$G] ✗ symlink no snapshot" >&2; exit 1; fi
if git -C "$TOP" diff --cached --name-only -- .usehbn-snapshot 2>/dev/null | grep -q .; then
  echo "[$G] ✗ mudancas staged em .usehbn-snapshot/ (read-only; use install-snapshot.sh --upgrade)" >&2; exit 1; fi
MAN="$SNAP/PROTOCOL_MANIFEST.sha256"; [[ -f "$MAN" ]] || { echo "[$G] ✗ manifesto ausente" >&2; exit 1; }
RC=0
while read -r mode csha path; do
  f="$SNAP/$path"
  [[ -f "$f" ]] || { echo "[$G] ✗ faltando $path" >&2; RC=1; continue; }
  cur="$(tr -d '\r' < "$f" | sha256)"
  [[ "$cur" == "$csha" ]] || { echo "[$G] ✗ drift em $path" >&2; RC=1; }
done < "$MAN"
ndisk="$(find "$SNAP" -type f -not -name 'PROTOCOL_MANIFEST.sha256' -not -name 'PROTOCOL_SHA256.txt' -not -name 'VERSION' -not -name 'USEHBN-HEADER.txt' -not -name 'CONSUMER-PROFILE.md' | wc -l | tr -d ' ')"
nman="$(grep -c . "$MAN")"
[[ "$ndisk" == "$nman" ]] || { echo "[$G] ✗ arquivos extra no snapshot (disco=$ndisk manifesto=$nman)" >&2; RC=1; }
[[ $RC -eq 0 ]] && echo "[$G] ✓ snapshot integro ($nman arquivos)" || exit 1
GUARD
  chmod +x "$d/assert-snapshot-integrity.sh"
}

case "$MODE" in
  --dry-run) echo "DRY-RUN: nada escrito no projeto (TARGET=${TARGET:-<nao informado>})."; rm -f "$MANFILE";;
  --verify-only)
    [[ -n "$TARGET" ]] || { echo "verify-only exige --target" >&2; rm -f "$MANFILE"; exit 2; }
    SNAP="$TARGET/.usehbn-snapshot"; HAVE=""
    [[ -f "$SNAP/PROTOCOL_SHA256.txt" ]] && HAVE="$(grep -oE '[0-9a-f]{64}' "$SNAP/PROTOCOL_SHA256.txt" | head -1)"
    rm -f "$MANFILE"
    [[ "$HAVE" == "$PROTOCOL_SHA256" ]] && echo "VERIFY OK: snapshot bate com $TAG" || { echo "VERIFY FALHOU: ausente ou != $TAG" >&2; exit 1; } ;;
  --install)
    [[ -n "$TARGET" ]] || { echo "install exige --target" >&2; rm -f "$MANFILE"; exit 2; }
    TGT_TOP="$(git -C "$TARGET" rev-parse --show-toplevel 2>/dev/null || true)"
    [[ -n "$TGT_TOP" ]] || { echo "target nao e repo git: $TARGET" >&2; rm -f "$MANFILE"; exit 2; }
    PROTO_TOP="$(git -C "$PROTO" rev-parse --show-toplevel)"
    [[ "$TGT_TOP" != "$PROTO_TOP" ]] || { echo "target == proto; recusado" >&2; rm -f "$MANFILE"; exit 2; }
    SNAP="$TGT_TOP/.usehbn-snapshot"
    [[ -e "$SNAP" ]] && { echo "$SNAP ja existe; use --upgrade" >&2; rm -f "$MANFILE"; exit 2; }
    rm -rf "$SNAP.tmp"; mkdir -p "$SNAP.tmp"; write_membrane "$SNAP.tmp"; mv "$SNAP.tmp" "$SNAP"
    write_integrity_guard "$TGT_TOP"
    mkdir -p "$TGT_TOP/.hbn"; printf '.\n' > "$TGT_TOP/.hbn/active-version"
    chmod -R a-w "$SNAP" 2>/dev/null || true
    rm -f "$MANFILE"
    echo "INSTALL OK: $SNAP (protocol_sha256=$PROTOCOL_SHA256; $COUNT arquivos); guard local + .hbn/active-version=. criados." ;;
  --upgrade) rm -f "$MANFILE"; echo "MODE --upgrade ainda nao implementado (P2-C+)." >&2; exit 3;;
esac
```

C2. VALIDAR sem tocar o Credenciamento (cole a saida no RETURN):
   bash scripts/hbn-snapshot/install-snapshot.sh --dry-run --proto . --tag v1-estavel   # 137 / 8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1
   T=$(mktemp -d); git -C "$T" init -q; git -C "$T" commit -q --allow-empty -m init
   bash scripts/hbn-snapshot/install-snapshot.sh --install --proto . --tag v1-estavel --target "$T"   # INSTALL OK ... 137 arquivos
   ( cd "$T" && bash scripts/hbn-snapshot/assert-snapshot-integrity.sh )   # ✓ snapshot integro (137 arquivos)
   rm -rf "$T"
   CONFIRME: NENHUMA mudanca em ~/Projetos/Credenciamento (git -C ~/Projetos/Credenciamento status deve seguir igual).

C3. SALVAR ESTE DESPACHO (verbatim) em .hbn/messages/20260626-190000-opus-4-8-despacho-p2b-install.md

C4. CRIAR .hbn/readbacks/0100-p2b-install-mode.json com EXATAMENTE o scaffold do fim deste bloco (PROPOSED_UNTIL_CROSS_AUDIT; human/hearback confirmed).

C5. EDITAR .hbn/relay/STATE.md:
   - na string `protocolo:`, APENDAR: `; P2-B: --install implementado no install-snapshot.sh (readback 0100, pendente cross-audit); validado em target temp; Credenciamento intocado`
   - `onda_atual: "PASSO 2 / P2-B — modo --install implementado e validado em target temporario (readback 0100); cria .usehbn-snapshot/ + assert-snapshot-integrity local + .hbn/active-version=. ; Credenciamento ainda intocado. Pendente cross-audit !=OpenAI + selagem 0101; depois Mauricio roda --install no projeto (humano-gated)."`
   - `proxima_acao: "P2-B cross-audit do --install (readback 0100); depois selagem 0101; depois Mauricio roda --install no Credenciamento"`
   - `ultima_atualizacao: "2026-06-26T19:00:00-03:00"`
   - `readback_ativo: ".hbn/readbacks/0100-p2b-install-mode.json"`
   - `handoff_mais_recente: ".hbn/messages/20260626-190000-opus-4-8-despacho-p2b-install.md"`
   - mantenha `roadmap_ativo`.
   - bloco `proximo_ponto` inteiro vira EXATAMENTE:
proximo_ponto:
  passo: "P2-B cross-audit do --install do install-snapshot.sh (readback 0100) por >=2 familias !=OpenAI"
  ato: cross-audit
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/messages/20260626-190000-opus-4-8-despacho-p2b-install.md
  status: pendente
   - INSERIR no topo de sinais_abertos:
     - "🟡 P2-B — --install implementado e validado em target temp (readback 0100); membrana correta, integridade detecta drift, Credenciamento intocado. Pendente cross-audit !=OpenAI + selagem 0101; depois install humano no projeto."
     - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0100 safe_track, implementador=codex, autorização humana Mauricio, orq_entrada_ref e trailers contiguos; aguarda cross-audit !=OpenAI + hearback + selagem 0101."

C6. APPEND em REGISTRY.md (7-col) — 2 linhas (o script ja tem linha de P2-A; e MODIFY):
| 20260626-190000-opus-despacho-p2b-install | .hbn/messages/20260626-190000-opus-4-8-despacho-p2b-install.md | despacho | frio | fronteira | — | 2026-06-26T19:00:00-03:00 |
| 20260626-190002-codex-readback-p2b-install | .hbn/readbacks/0100-p2b-install-mode.json | readback | frio | fronteira | — | 2026-06-26T19:00:02-03:00 |

C7. STAGE EXPLICITO + atestacao:
   git add scripts/hbn-snapshot/install-snapshot.sh .hbn/relay/STATE.md .hbn/messages/20260626-190000-opus-4-8-despacho-p2b-install.md REGISTRY.md
   git add -f .hbn/readbacks/0100-p2b-install-mode.json
   python3 /tmp/gen_orq.py
   git add .hbn/attestations/34a7f2f9-orq-entrada.json
   bash guards/assert-orq-entrada.sh   # verde

C8. Runner + suite + bateria; commit UNICO:
   bash guards/hbn-guards-runner.sh
   bash guards/tests/run-guard-tests.sh
   bash guards/tests/adversarial-battery.sh
   git rev-parse main   # == 4db692876381a0d7909985c8500d999f2e677b04
   git add scripts/hbn-snapshot/install-snapshot.sh .hbn/attestations/34a7f2f9-orq-entrada.json .hbn/relay/STATE.md .hbn/messages/20260626-190000-opus-4-8-despacho-p2b-install.md REGISTRY.md
   git add -f .hbn/readbacks/0100-p2b-install-mode.json
   git commit -m "feat(passo2 P2-B): implementar --install no install-snapshot.sh (readback 0100, pendente cross-audit)" -m "HBN-Readback: 0100
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9"
Apos o commit: SOBRESCREVA .hbn/relay/RETURN.json {status: ok, sha: <NOVO>, readback: "0100-p2b-install-mode", w_freeze_started: true}. Reporte o SHA, cole `git rev-parse main` e a saida de C2.

## scaffold — .hbn/readbacks/0100-p2b-install-mode.json
{
  "readback_id": "0100-p2b-install-mode",
  "execution_id": "p2b-install-mode-2026-06-26",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0100-p2b-install-mode.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260626-190000-opus-4-8-despacho-p2b-install.md",
  "understanding": "P2-B parte 1: implementar o modo --install do scripts/hbn-snapshot/install-snapshot.sh (antes fail-closed). O --install cria .usehbn-snapshot/ no --target a partir da tree do tag v1-estavel (git archive), grava PROTOCOL_MANIFEST.sha256 + PROTOCOL_SHA256.txt + VERSION + USEHBN-HEADER.txt + CONSUMER-PROFILE.md, escreve scripts/hbn-snapshot/assert-snapshot-integrity.sh LOCAL no target, cria .hbn/active-version=. e aplica chmod read-only; recusa se snapshot ja existe (use --upgrade). Validado pelo orquestrador no sandbox em target git temporario: dry-run 137/8796b672…; install cria membrana correta; integridade verde pos-install e detecta drift; recusa duplicado. Esta onda NAO toca o Credenciamento (so modifica o script no protocolo). Entrega como PROPOSTA: cross-audit !=OpenAI + selagem 0101 antes do --install real no projeto (P2-B parte 2, humano-gated, firewall 0022). Ato de autoridade sob G-ORQ-REF (Exit A').",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Mauricio aprovou implementar o --install agora (P2-B). P2-B parte 1 nao toca o Credenciamento; o install real e ato humano posterior.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "scripts/hbn-snapshot/install-snapshot.sh",
      ".hbn/messages/20260626-190000-opus-4-8-despacho-p2b-install.md",
      ".hbn/readbacks/0100-p2b-install-mode.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","guards/**","src/**","core/**","methodology/**","schemas/**","docs/brainstorm/**",".hbn/freeze/**",".hbn/hearbacks/**",".hbn/operators/**",".hbn/proposals/**"]
  },
  "stop_condition": "--install implementado e validado em target temporario. Parar para cross-audit !=OpenAI + hearback + selagem 0101. NAO rodar --install no Credenciamento neste commit.",
  "HBN-Readback": "0100",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-26T19:00:00-03:00",
  "protocol_version": "0.3.0"
}
⟦HBN-COPY END⟧

— FIM DO DESPACHO —