---
titulo: "Despacho — P2-A: implementar install-snapshot.sh e rodar --dry-run (readback 0098)"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260626-160000-opus-4-8-despacho-p2a-dryrun.md
readback_alvo: 0098-p2a-install-snapshot-dryrun
created_at: "2026-06-26T16:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md
  - .hbn/results/20260626-031000-codex-auditoria-executiva-ponte.md
  - .hbn/relay/STATE.md
---

# HBN — Despacho P2-A (install-snapshot.sh + dry-run)

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-26T16:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador (zelador das regras pelo exemplo — k-0029).
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-26T16:00:00-03:00 readback_ativo=.hbn/readbacks/0098-p2a-install-snapshot-dryrun.json; main intocada 4db6928; HEAD 267f047.
PRÓXIMA AÇÃO: P2-A cross-audit do install-snapshot.sh + dry-run (readback 0098); depois selagem 0099, depois P2-B
BASTÃO: opus-4-8 (Anthropic), atestacao v2 valida (34a7f2f9). Ato de autoridade sob G-ORQ-REF (Exit A').

## Decisões informais (cápsula)
- Proposta-ponte v2 ratificada e selada (0096 via 0097). P2-A implementa o `scripts/hbn-snapshot/install-snapshot.sh` (ferramenta de distribuicao do protocolo) e roda `--dry-run`: gera manifesto determinístico + PROTOCOL_SHA256, lista os 137 arquivos do snapshot, reporta o subset de guards. NAO toca o Credenciamento; NAO cria .usehbn-snapshot/.
- Alvo reproduzivel (PoC do codex na auditoria executiva): superficie `core methodology schemas guards` no tag v1-estavel = 137 arquivos; manifesto `mode sha256(LF-normalizado) path` ordenado por path (LC_ALL=C) => protocol_sha256 8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1. O dry-run DEVE reproduzir esses numeros (prova de determinismo).
- readback 0098 e PROPOSTA (PROPOSED_UNTIL_CROSS_AUDIT): o script e codigo executavel novo; vai a cross-audit !=OpenAI + selagem antes de ser USADO para instalar (P2-B).

⟦HBN-COPY dest=codex⟧ BEGIN
PARA: codex (implementador · OpenAI). SOB: bastao token_fp 34a7f2f9. ORQUESTRADOR: opus-4-8 · Anthropic. TRACK: safe_track.
HEAD esperado: 267f047. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
OBJETIVO: implementar `scripts/hbn-snapshot/install-snapshot.sh` e rodar `--dry-run` (que NAO toca o Credenciamento e NAO cria .usehbn-snapshot/). Entregar como PROPOSTA (0098) pendente de cross-audit.
LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO; readback gitignored -> git add -f); honre TODOS os guards; se UM bloquear, PARE e relate.
IMPORTANTE: SALVE ESTE DESPACHO VERBATIM (RELATO DE ESTADO + heading "## Decisões informais (cápsula)"). NAO reescreva o relato (G-RLT: strings exatas — token `ultima_atualizacao=2026-06-26T16:00:00-03:00`, linha `PRÓXIMA AÇÃO:` igual ao proxima_acao do STATE, heading acentuado).

C1. CRIAR `scripts/hbn-snapshot/install-snapshot.sh` (chmod +x) com o conteudo abaixo (ajuste apenas se necessario para robustez/cross-OS, mantendo o manifesto determinístico que reproduz o protocol_sha256 alvo). O manifesto DEVE ser byte-identico ao do PoC da auditoria executiva (mode sha256 path, LF-normalizado, ordenado por path em LC_ALL=C, uma linha por arquivo terminando em \n):
#!/usr/bin/env bash
# scripts/hbn-snapshot/install-snapshot.sh — distribui o snapshot read-only do PROTOCOLO useHBN.
# Modos: --dry-run (default) | --verify-only | --install | --upgrade
# P2-A: --dry-run e --verify-only implementados; --install/--upgrade fail-closed (P2-B+ sob hearback).
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
echo "PROTO=$PROTO"; echo "TAG=$TAG"; echo "COMMIT=$COMMIT"; echo "SURFACE=$SURFACE"
MANFILE="$(mktemp)"
git -C "$PROTO" ls-tree -r -z --full-tree "$TAG" -- $SURFACE \
| while IFS= read -r -d '' rec; do
    meta="${rec%%$'\t'*}"; path="${rec#*$'\t'}"
    mode="${meta%% *}"; oid="${meta##* }"
    csha="$(git -C "$PROTO" cat-file blob "$oid" | tr -d '\r' | sha256)"
    printf '%s %s %s\n' "$mode" "$csha" "$path"
  done | LC_ALL=C sort -k3 > "$MANFILE"
COUNT="$(grep -c . "$MANFILE")"
PROTOCOL_SHA256="$(sha256 < "$MANFILE")"
echo "FILE_COUNT=$COUNT"
echo "PROTOCOL_SHA256=$PROTOCOL_SHA256"
echo "GUARDS_PROJETO=assert-canonical-root forbid-tmp-worktree forbid-env-files forbid-legacy-paths assert-scratch-lock assert-scratch-symlink assert-scratch-ignore assert-zona-livre assert-scope-lock assert-hearback-integrity assert-no-stray-hbn assert-self-path assert-trailers-contiguous assert-report-fresh assert-readlist-rite assert-knowledge-index"
echo "GUARDS_GENOMA_EXCLUIDOS=assert-orq-entrada assert-orq-entrada-ref validate-dispatch assert-dispatch-integrity assert-registry-line assert-pointer-honest assert-arvore-label assert-auditor-id assert-audit-diversity assert-quorum-selagem assert-parallel-id freeze-gate assert-baton-token"
case "$MODE" in
  --dry-run) echo "DRY-RUN: nada escrito no projeto (TARGET=${TARGET:-<nao informado>})."; rm -f "$MANFILE";;
  --verify-only)
    [[ -n "$TARGET" ]] || { echo "verify-only exige --target" >&2; rm -f "$MANFILE"; exit 2; }
    SNAP="$TARGET/.usehbn-snapshot"; HAVE=""
    [[ -f "$SNAP/PROTOCOL_SHA256.txt" ]] && HAVE="$(grep -oE '[0-9a-f]{64}' "$SNAP/PROTOCOL_SHA256.txt" | head -1)"
    rm -f "$MANFILE"
    [[ "$HAVE" == "$PROTOCOL_SHA256" ]] && echo "VERIFY OK: snapshot bate com $TAG" || { echo "VERIFY FALHOU: snapshot ausente ou != $TAG" >&2; exit 1; }
    ;;
  --install|--upgrade) rm -f "$MANFILE"; echo "MODE $MODE bloqueado em P2-A; usar --dry-run/--verify-only (install/upgrade vem em P2-B sob hearback)." >&2; exit 3;;
esac

C2. RODAR o dry-run e CONFERIR os numeros (cole a saida no RETURN/relato):
   bash scripts/hbn-snapshot/install-snapshot.sh --dry-run --proto . --tag v1-estavel
   ESPERADO: FILE_COUNT=137 e PROTOCOL_SHA256=8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1
   (Se o sha divergir, NAO commite: ajuste o manifesto para casar o PoC da auditoria — provavel causa: normalizacao/ordenacao. Relate.)

C3. SALVAR ESTE DESPACHO (verbatim) em .hbn/messages/20260626-160000-opus-4-8-despacho-p2a-dryrun.md

C4. CRIAR .hbn/readbacks/0098-p2a-install-snapshot-dryrun.json com EXATAMENTE o scaffold do fim deste bloco (PROPOSED_UNTIL_CROSS_AUDIT; human_status/hearback_status confirmed).

C5. EDITAR .hbn/relay/STATE.md:
   - na string `protocolo:`, APENDAR: `; P2-A: install-snapshot.sh entregue + dry-run (readback 0098, pendente cross-audit); FILE_COUNT=137 protocol_sha256 8796b672…`
   - `onda_atual: "PASSO 2 / P2-A — install-snapshot.sh entregue e dry-run executado (readback 0098); 137 arquivos, protocol_sha256 8796b672… reproduzido. Pendente cross-audit !=OpenAI + selagem 0099; depois P2-B (instalar a membrana sob hearback)."`
   - `proxima_acao: "P2-A cross-audit do install-snapshot.sh + dry-run (readback 0098); depois selagem 0099, depois P2-B"`
   - `ultima_atualizacao: "2026-06-26T16:00:00-03:00"`
   - `readback_ativo: ".hbn/readbacks/0098-p2a-install-snapshot-dryrun.json"`
   - `handoff_mais_recente: ".hbn/messages/20260626-160000-opus-4-8-despacho-p2a-dryrun.md"`
   - mantenha `roadmap_ativo`.
   - bloco `proximo_ponto` inteiro vira EXATAMENTE:
proximo_ponto:
  passo: "P2-A cross-audit do install-snapshot.sh + dry-run (readback 0098) por >=2 familias !=OpenAI"
  ato: cross-audit
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/messages/20260626-160000-opus-4-8-despacho-p2a-dryrun.md
  status: pendente
   - INSERIR no topo de sinais_abertos:
     - "🟡 P2-A — install-snapshot.sh + dry-run entregue (readback 0098); 137 arquivos, protocol_sha256 8796b672… (determinismo reproduzido). Pendente cross-audit !=OpenAI + selagem 0099; depois P2-B."
     - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0098 safe_track, implementador=codex, autorização humana Mauricio, orq_entrada_ref e trailers contiguos; aguarda cross-audit !=OpenAI + hearback + selagem 0099."

C6. APPEND em REGISTRY.md (7-col) — 3 linhas:
| 20260626-160000-opus-install-snapshot-sh | scripts/hbn-snapshot/install-snapshot.sh | script | frio | fronteira | — | 2026-06-26T16:00:00-03:00 |
| 20260626-160001-opus-despacho-p2a-dryrun | .hbn/messages/20260626-160000-opus-4-8-despacho-p2a-dryrun.md | despacho | frio | fronteira | — | 2026-06-26T16:00:01-03:00 |
| 20260626-160002-codex-readback-p2a-dryrun | .hbn/readbacks/0098-p2a-install-snapshot-dryrun.json | readback | frio | fronteira | — | 2026-06-26T16:00:02-03:00 |

C7. STAGE EXPLICITO + atestacao:
   git add scripts/hbn-snapshot/install-snapshot.sh .hbn/relay/STATE.md .hbn/messages/20260626-160000-opus-4-8-despacho-p2a-dryrun.md REGISTRY.md
   git add -f .hbn/readbacks/0098-p2a-install-snapshot-dryrun.json
   python3 /tmp/gen_orq.py
   git add .hbn/attestations/34a7f2f9-orq-entrada.json
   bash guards/assert-orq-entrada.sh   # verde

C8. Runner + suite + bateria; commit UNICO:
   bash guards/hbn-guards-runner.sh
   bash guards/tests/run-guard-tests.sh
   bash guards/tests/adversarial-battery.sh
   git rev-parse main   # == 4db692876381a0d7909985c8500d999f2e677b04
   git add scripts/hbn-snapshot/install-snapshot.sh .hbn/attestations/34a7f2f9-orq-entrada.json .hbn/relay/STATE.md .hbn/messages/20260626-160000-opus-4-8-despacho-p2a-dryrun.md REGISTRY.md
   git add -f .hbn/readbacks/0098-p2a-install-snapshot-dryrun.json
   git commit -m "feat(passo2 P2-A): install-snapshot.sh + dry-run (readback 0098, pendente cross-audit)" -m "HBN-Readback: 0098
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9"
Apos o commit: SOBRESCREVA .hbn/relay/RETURN.json {status: ok, sha: <NOVO>, readback: "0098-p2a-install-snapshot-dryrun", w_freeze_started: true, file_count: 137, protocol_sha256: "8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1"}. Reporte o SHA, cole `git rev-parse main` e a saida do dry-run (C2).

## scaffold — .hbn/readbacks/0098-p2a-install-snapshot-dryrun.json
{
  "readback_id": "0098-p2a-install-snapshot-dryrun",
  "execution_id": "p2a-install-snapshot-2026-06-26",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0098-p2a-install-snapshot-dryrun.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260626-160000-opus-4-8-despacho-p2a-dryrun.md",
  "understanding": "P2-A da ponte: implementar scripts/hbn-snapshot/install-snapshot.sh (ferramenta de distribuicao do protocolo) e rodar --dry-run. O dry-run gera o manifesto determinístico (mode sha256(LF-normalizado) path, ordenado por path em LC_ALL=C) sobre a superficie core+methodology+schemas+guards do tag v1-estavel, reproduzindo o PoC da auditoria executiva: 137 arquivos, protocol_sha256 8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1. --verify-only implementado; --install/--upgrade fail-closed (P2-B+ sob hearback). NAO toca o Credenciamento, NAO cria .usehbn-snapshot/. Entrega como PROPOSTA: o script e codigo executavel novo e vai a cross-audit !=OpenAI + selagem 0099 antes de ser usado para instalar (P2-B). Ato de autoridade sob G-ORQ-REF (Exit A').",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Proposta-ponte v2 ratificada e selada (0096 via 0097); Mauricio aprovou a sequencia P2-A..D. P2-A (dry-run) nao toca o projeto.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "scripts/hbn-snapshot/install-snapshot.sh",
      ".hbn/messages/20260626-160000-opus-4-8-despacho-p2a-dryrun.md",
      ".hbn/readbacks/0098-p2a-install-snapshot-dryrun.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","guards/**","src/**","core/**","methodology/**","schemas/**","docs/brainstorm/**",".hbn/freeze/**",".hbn/hearbacks/**",".hbn/operators/**",".hbn/proposals/**"]
  },
  "stop_condition": "install-snapshot.sh entregue + dry-run executado (137 arquivos, protocol_sha256 8796b672…). Parar para cross-audit !=OpenAI + hearback + selagem 0099. NAO rodar --install; NAO tocar o Credenciamento.",
  "HBN-Readback": "0098",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-26T16:00:00-03:00",
  "protocol_version": "0.3.0"
}
⟦HBN-COPY END⟧

— FIM DO DESPACHO —