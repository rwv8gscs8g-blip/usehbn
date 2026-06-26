---
titulo: "Despacho — W-FREEZE HEARBACK-SCOPE"
tipo: despacho
status: entregue
temperatura: frio
path: .hbn/messages/20260626-000000-opus-4-8-despacho-w-freeze-hearback-scope.md
readback_alvo: 0094-w-freeze-hearback-scope
created_at: "2026-06-26T00:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - .hbn/readbacks/0093-selagem-w-freeze-checklist.json
  - .hbn/hearbacks/freeze-protocolo-v1-estavel.json
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho W-FREEZE HEARBACK-SCOPE

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-26T00:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador (zelador das regras pelo exemplo — k-0029).
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-26T00:00:00-03:00 readback_ativo=.hbn/readbacks/0094-w-freeze-hearback-scope.json; main intocada 4db6928; HEAD 803739f.
PRÓXIMA AÇÃO: W-FREEZE hearback humano: Mauricio cria o hearback do freeze (commit puro sob readback 0094); depois freeze-gate.sh exit 0 + tag v1-estavel
BASTÃO: opus-4-8 (Anthropic), atestacao v2 valida (34a7f2f9). Ato de autoridade sob G-ORQ-REF (Exit A').

## Decisões informais (cápsula)
- Autorizar somente o escopo do commit puro do hearback do freeze sob readback 0094. Codex nao cria o hearback, nao roda o gate e nao cria tag; proximo ato e humano de Mauricio.

⟦HBN-COPY dest=codex⟧ BEGIN
PARA: codex (implementador · OpenAI). SOB: bastao token_fp 34a7f2f9. ORQUESTRADOR: opus-4-8 · Anthropic. TRACK: safe_track.
HEAD esperado: 803739f. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
OBJETIVO: autorizar o escopo do commit puro do hearback do freeze (readback 0094). NAO criar o hearback. NAO rodar o gate. NAO criar tag.
LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne.
IMPORTANTE: SALVE O DESPACHO DO ORQUESTRADOR VERBATIM (bloco RELATO DE ESTADO + heading "## Decisões informais (cápsula)"). NAO reescreva o relato (G-RLT compara strings exatas).

C1. SALVAR o despacho do orquestrador (verbatim) em .hbn/messages/20260626-000000-opus-4-8-despacho-w-freeze-hearback-scope.md

C2. CRIAR .hbn/readbacks/0094-w-freeze-hearback-scope.json com o scaffold do fim do despacho (status "entregue"; files_allowed INCLUI .hbn/hearbacks/freeze-protocolo-v1-estavel.json).

C3. EDITAR .hbn/relay/STATE.md:
   - protocolo: APENDAR "; W-FREEZE hearback-scope: readback 0094 autoriza o commit puro do hearback do freeze (proximo: ato humano de Mauricio)"
   - onda_atual: "W-FREEZE HEARBACK-SCOPE — readback 0094 (entregue); autoriza o escopo do commit puro do hearback .hbn/hearbacks/freeze-protocolo-v1-estavel.json. Proximo: Mauricio faz o commit puro do hearback (sob 0094), roda freeze-gate.sh exit 0 e git tag v1-estavel."
   - proxima_acao: "W-FREEZE hearback humano: Mauricio cria o hearback do freeze (commit puro sob readback 0094); depois freeze-gate.sh exit 0 + tag v1-estavel"
   - ultima_atualizacao: "2026-06-26T00:00:00-03:00"
   - readback_ativo: ".hbn/readbacks/0094-w-freeze-hearback-scope.json"
   - handoff_mais_recente: ".hbn/messages/20260626-000000-opus-4-8-despacho-w-freeze-hearback-scope.md"
   - mantenha roadmap_ativo
   - proximo_ponto vira EXATAMENTE:
proximo_ponto:
  passo: "W-FREEZE hearback humano: Mauricio cria o hearback do freeze (commit puro sob readback 0094); depois freeze-gate.sh exit 0 + git tag v1-estavel"
  ato: hearback
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/messages/20260626-000000-opus-4-8-despacho-w-freeze-hearback-scope.md
  status: pendente
   - INSERIR no topo de sinais_abertos:
     - "🟡 W-FREEZE HEARBACK-SCOPE — readback 0094 autoriza o commit puro do hearback do freeze. Proximo e o ato HUMANO de Mauricio (commit puro do hearback + freeze-gate exit 0 + tag v1-estavel)."

C4. APPEND em REGISTRY.md (7-col) — 2 linhas:
| 20260626-000000-opus-despacho-w-freeze-hearback-scope | .hbn/messages/20260626-000000-opus-4-8-despacho-w-freeze-hearback-scope.md | despacho | frio | fronteira | — | 2026-06-26T00:00:00-03:00 |
| 20260626-000002-codex-readback-w-freeze-hearback-scope | .hbn/readbacks/0094-w-freeze-hearback-scope.json | readback | frio | fronteira | — | 2026-06-26T00:00:02-03:00 |

C5. STAGE + atestacao:
   git add .hbn/relay/STATE.md .hbn/messages/20260626-000000-opus-4-8-despacho-w-freeze-hearback-scope.md .hbn/readbacks/0094-w-freeze-hearback-scope.json REGISTRY.md
   python3 /tmp/gen_orq.py
   git add .hbn/attestations/34a7f2f9-orq-entrada.json
   bash guards/assert-orq-entrada.sh   # verde

C6. Runner + suite + bateria; commit UNICO:
   bash guards/hbn-guards-runner.sh
   bash guards/tests/run-guard-tests.sh
   bash guards/tests/adversarial-battery.sh
   git rev-parse main   # == 4db692876381a0d7909985c8500d999f2e677b04
   git add .hbn/attestations/34a7f2f9-orq-entrada.json .hbn/relay/STATE.md .hbn/messages/20260626-000000-opus-4-8-despacho-w-freeze-hearback-scope.md .hbn/readbacks/0094-w-freeze-hearback-scope.json REGISTRY.md
   git commit -m "chore(w-freeze): autorizar escopo do commit puro do hearback do freeze (readback 0094)" -m "HBN-Readback: 0094
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9"
Apos o commit: SOBRESCREVA .hbn/relay/RETURN.json {status: ok, sha: <NOVO>, readback: "0094-w-freeze-hearback-scope", w_freeze_started: false}. NAO criar hearback, NAO rodar gate, NAO criar tag. Reporte o SHA e cole `git rev-parse main`.
⟦HBN-COPY END⟧

## scaffold — .hbn/readbacks/0094-w-freeze-hearback-scope.json
{
  "readback_id": "0094-w-freeze-hearback-scope",
  "execution_id": "w-freeze-hearback-scope-2026-06-26",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "entregue",
  "hearback_status": "pending",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0094-w-freeze-hearback-scope.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260626-000000-opus-4-8-despacho-w-freeze-hearback-scope.md",
  "understanding": "Autorizar exclusivamente o escopo do proximo commit puro do hearback do freeze: .hbn/hearbacks/freeze-protocolo-v1-estavel.json. Esta entrega nao cria o hearback, nao roda freeze-gate, nao cria tag e nao inicia W-FREEZE operacional; apenas deixa o readback 0094 governando o ato humano de Mauricio.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Despacho do orquestrador opus-4-8 de 2026-06-26T00:00:00-03:00 sob token_fp 34a7f2f9; objetivo autorizado: autorizar o escopo do commit puro do hearback do freeze, sem criar hearback, sem rodar gate e sem criar tag nesta entrega.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      ".hbn/hearbacks/freeze-protocolo-v1-estavel.json",
      ".hbn/messages/20260626-000000-opus-4-8-despacho-w-freeze-hearback-scope.md",
      ".hbn/readbacks/0094-w-freeze-hearback-scope.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main", "guards/**", "src/**", "core/**", "methodology/**", "schemas/**", "docs/brainstorm/**", ".hbn/freeze/**"]
  },
  "stop_condition": "Readback 0094 entregue: escopo autorizado para o commit puro humano do hearback do freeze. NAO criar hearback, NAO rodar freeze-gate, NAO criar tag nesta entrega.",
  "HBN-Readback": "0094",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-26T00:00:02-03:00",
  "protocol_version": "0.3.0"
}
