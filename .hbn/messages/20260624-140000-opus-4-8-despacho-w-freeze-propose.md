---
titulo: "Despacho — W-FREEZE PROPOSE"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260624-140000-opus-4-8-despacho-w-freeze-propose.md
readback_alvo: 0091-w-freeze-propose
created_at: "2026-06-24T14:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - .hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho W-FREEZE PROPOSE

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-24T14:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador (zelador das regras pelo exemplo — k-0029).
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-24T14:00:00-03:00 readback_ativo=.hbn/readbacks/0091-w-freeze-propose.json; main intocada 4db6928; HEAD 63cf35a.
PRÓXIMA AÇÃO: W-FREEZE cross-audit do freeze-checklist (readback 0091); depois selagem, hearback e gate humano
BASTÃO: opus-4-8 (Anthropic), atestacao v2 valida (34a7f2f9). Ato de autoridade sob G-ORQ-REF (Exit A').

## Decisões informais (cápsula)
- Trackear o freeze-checklist do PROTOCOLO como proposta (readback 0091), pendente de cross-audit !=OpenAI. Nao rodar freeze-gate nesta onda, nao criar tag e nao trackear hearback; o hearback real fica para depois da cross-audit/selagem.

⟦HBN-COPY dest=codex⟧ BEGIN
PARA: codex (implementador · OpenAI). SOB: bastao token_fp 34a7f2f9. ORQUESTRADOR: opus-4-8 · Anthropic. TRACK: safe_track.
HEAD esperado: 63cf35a. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
OBJETIVO: trackear o freeze-checklist do PROTOCOLO como PROPOSTA (readback 0091), pendente de cross-audit !=OpenAI. NAO rodar o gate. NAO criar tag. NAO trackear hearback algum nesta onda.
LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne.
IMPORTANTE: SALVE O DESPACHO ENTREGUE PELO ORQUESTRADOR VERBATIM (byte-a-byte, incluindo o bloco RELATO DE ESTADO e o heading "## Decisões informais (cápsula)"). NAO reescreva o relato — o G-RLT compara STRINGS EXATAS (token `ultima_atualizacao=2026-06-24T14:00:00-03:00`, linha `PRÓXIMA AÇÃO:` identica ao proxima_acao do STATE, heading acentuado).

P1. NAO stage .hbn/hearbacks/0003-w-freeze.json (stand-in de dry-run). Se existir, `rm -f .hbn/hearbacks/0003-w-freeze.json`.

P2. No checklist .hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json (ja existe untracked): TROQUE toda ocorrencia de `.hbn/hearbacks/0003-w-freeze.json` por `.hbn/hearbacks/freeze-protocolo-v1-estavel.json`. Depois: git add .hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json

P3. SALVAR o despacho do orquestrador (verbatim) em .hbn/messages/20260624-140000-opus-4-8-despacho-w-freeze-propose.md

P4. CRIAR .hbn/readbacks/0091-w-freeze-propose.json com o scaffold do fim do despacho (status implemented_pending_cross_audit / PROPOSED_UNTIL_CROSS_AUDIT).

P5. EDITAR .hbn/relay/STATE.md:
   - protocolo: APENDAR "; W-FREEZE propose: freeze-checklist do PROTOCOLO trackeado (readback 0091, pendente cross-audit !=OpenAI)"
   - onda_atual: "W-FREEZE PROPOSE — readback 0091; freeze-checklist perfil-protocolo trackeado e validado em dry-run; pendente cross-audit !=OpenAI + selagem + hearback + gate humano (freeze-gate exit 0 + tag v1-estavel)"
   - proxima_acao: "W-FREEZE cross-audit do freeze-checklist (readback 0091); depois selagem, hearback e gate humano"
   - ultima_atualizacao: "2026-06-24T14:00:00-03:00"
   - readback_ativo: ".hbn/readbacks/0091-w-freeze-propose.json"
   - handoff_mais_recente: ".hbn/messages/20260624-140000-opus-4-8-despacho-w-freeze-propose.md"
   - mantenha roadmap_ativo
   - proximo_ponto vira EXATAMENTE:
proximo_ponto:
  passo: "cross-audit do freeze-checklist do PROTOCOLO (readback 0091) por >=2 familias !=OpenAI"
  ato: cross-audit
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/messages/20260624-140000-opus-4-8-despacho-w-freeze-propose.md
  status: pendente
   - INSERIR no topo de sinais_abertos:
     - "🟡 W-FREEZE PROPOSE — readback 0091; freeze-checklist do PROTOCOLO trackeado; dry-run do freeze-gate = congelavel:sim (pytest ok). Pendente: cross-audit !=OpenAI, selagem 0092, hearback do freeze, gate humano + tag v1-estavel."
     - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0091 safe_track, implementador=codex, autorização humana Mauricio, orq_entrada_ref presente e trailers contiguos; aguarda cross-audit !=OpenAI + hearback + selagem 0092."

P6. APPEND em REGISTRY.md (7-col):
| 20260624-01-freeze-protocolo-v1-estavel | .hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json | freeze-checklist | frio | fronteira | — | 2026-06-24T14:00:00-03:00 |
| 20260624-140000-opus-despacho-w-freeze-propose | .hbn/messages/20260624-140000-opus-4-8-despacho-w-freeze-propose.md | despacho | frio | fronteira | — | 2026-06-24T14:00:00-03:00 |
| 20260624-140002-codex-readback-w-freeze-propose | .hbn/readbacks/0091-w-freeze-propose.json | readback | frio | fronteira | — | 2026-06-24T14:00:02-03:00 |

P7. STAGE + atestacao:
   git add .hbn/relay/STATE.md .hbn/messages/20260624-140000-opus-4-8-despacho-w-freeze-propose.md .hbn/readbacks/0091-w-freeze-propose.json .hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json REGISTRY.md
   python3 /tmp/gen_orq.py
   git add .hbn/attestations/34a7f2f9-orq-entrada.json
   bash guards/assert-orq-entrada.sh   # verde

P8. Runner + suite + bateria; commit UNICO:
   bash guards/hbn-guards-runner.sh
   bash guards/tests/run-guard-tests.sh
   bash guards/tests/adversarial-battery.sh
   git rev-parse main   # == 4db692876381a0d7909985c8500d999f2e677b04
   git add .hbn/attestations/34a7f2f9-orq-entrada.json .hbn/relay/STATE.md .hbn/messages/20260624-140000-opus-4-8-despacho-w-freeze-propose.md .hbn/readbacks/0091-w-freeze-propose.json .hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json REGISTRY.md
   git commit -m "chore(w-freeze): trackear freeze-checklist do PROTOCOLO (readback 0091, pendente cross-audit)" -m "HBN-Readback: 0091
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9"
Apos o commit: SOBRESCREVA .hbn/relay/RETURN.json {status: ok, sha: <NOVO>, readback: "0091-w-freeze-propose", w_freeze_started: false}. Reporte o SHA e cole `git rev-parse main`.

## scaffold — .hbn/readbacks/0091-w-freeze-propose.json
{
  "readback_id": "0091-w-freeze-propose",
  "execution_id": "w-freeze-propose-2026-06-24",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0091-w-freeze-propose.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260624-140000-opus-4-8-despacho-w-freeze-propose.md",
  "understanding": "Trackear o freeze-checklist do PROTOCOLO como proposta (readback 0091), sem rodar o freeze-gate nesta onda, sem criar tag e sem trackear hearback. O checklist fica versionado para cross-audit !=OpenAI; depois virao selagem 0092, hearback do freeze e gate humano (freeze-gate exit 0 + tag v1-estavel).",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Despacho do orquestrador opus-4-8 de 2026-06-24T14:00:00-03:00 sob token_fp 34a7f2f9; objetivo autorizado: trackear freeze-checklist do PROTOCOLO como PROPOSTA, pendente de cross-audit !=OpenAI, sem gate, sem tag e sem hearback nesta onda.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      ".hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json",
      ".hbn/messages/20260624-140000-opus-4-8-despacho-w-freeze-propose.md",
      ".hbn/readbacks/0091-w-freeze-propose.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main", ".hbn/hearbacks/**", "guards/**", "src/**", "core/**", "methodology/**", "schemas/**", "docs/brainstorm/**"]
  },
  "stop_condition": "Readback 0091 proposto e freeze-checklist do PROTOCOLO trackeado. Parar para cross-audit !=OpenAI; NAO rodar freeze-gate, NAO criar tag e NAO trackear hearback nesta onda.",
  "HBN-Readback": "0091",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-24T14:00:02-03:00",
  "protocol_version": "0.3.0"
}
⟦HBN-COPY END⟧
