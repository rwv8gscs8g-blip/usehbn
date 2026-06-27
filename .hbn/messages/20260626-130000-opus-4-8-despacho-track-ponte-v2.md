---
titulo: "Despacho — trackear a proposta-ponte v2 no protocolo (readback 0096, pendente ratificação)"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260626-130000-opus-4-8-despacho-track-ponte-v2.md
readback_alvo: 0096-track-ponte-v2
created_at: "2026-06-26T13:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md
  - .hbn/relay/STATE.md
---

# HBN — Despacho track da proposta-ponte v2 (passo 2)

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-26T13:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador (zelador das regras pelo exemplo — k-0029).
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-26T13:00:00-03:00 readback_ativo=.hbn/readbacks/0096-track-ponte-v2.json; main intocada 4db6928; HEAD 78dd725.
PRÓXIMA AÇÃO: PASSO 2 cross-audit de ratificacao da proposta-ponte v2 (readback 0096); depois selagem 0097, hearback e P2-A
BASTÃO: opus-4-8 (Anthropic), atestacao v2 valida (34a7f2f9). Ato de autoridade sob G-ORQ-REF (Exit A').

## Decisões informais (cápsula)
- Passo 1 (freeze) concluido. Passo 2: proposta-ponte v2 consolidada (3 consultas: antigravity+grok desenho, codex viabilidade) + direcao de Mauricio. Esta onda TRACKEIA a proposta como PROPOSTA (0096, PROPOSED_UNTIL_CROSS_AUDIT). NAO implementa nada da ponte.
- Decisoes de gate ja tomadas: D4 (renomear .hbn/) ADIADO para P3; shim .hbn/active-version=`.` no projeto (protocolo congelado intacto); escopo B-subset. Proxima_acao: cross-audit de ratificacao !=OpenAI + hearback; depois P2-A (dry-run).

⟦HBN-COPY dest=codex⟧ BEGIN
PARA: codex (implementador · OpenAI). SOB: bastao token_fp 34a7f2f9. ORQUESTRADOR: opus-4-8 · Anthropic. TRACK: safe_track.
HEAD esperado: 78dd725. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
OBJETIVO: trackear no protocolo a proposta-ponte v2 como PROPOSTA pendente de ratificacao (readback 0096). NAO implementar a ponte; NAO tocar o Credenciamento; NAO criar snapshot.
LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne.
IMPORTANTE: SALVE ESTE DESPACHO VERBATIM (bloco RELATO DE ESTADO + heading "## Decisões informais (cápsula)"). NAO reescreva o relato (G-RLT compara strings exatas: token `ultima_atualizacao=2026-06-26T13:00:00-03:00`, linha `PRÓXIMA AÇÃO:` igual ao proxima_acao do STATE, heading acentuado).

C1. CRIAR o arquivo da proposta em .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md com o conteudo VERBATIM do arquivo entregue pelo orquestrador "20260626-ponte-v2-consolidada.md" (o front-matter ja traz path: igual ao destino). NAO altere o conteudo.

C2. SALVAR ESTE DESPACHO (verbatim) em .hbn/messages/20260626-130000-opus-4-8-despacho-track-ponte-v2.md

C3. CRIAR .hbn/readbacks/0096-track-ponte-v2.json com EXATAMENTE o scaffold do fim deste bloco (PROPOSED_UNTIL_CROSS_AUDIT).

C4. EDITAR .hbn/relay/STATE.md (front-matter):
   - na string `protocolo:`, APENDAR: `; PASSO 2: proposta-ponte v2 trackeada (readback 0096, pendente ratificacao !=OpenAI)`
   - `onda_atual: "PASSO 2 — proposta-ponte v2 consolidada e trackeada (readback 0096); 3 consultas (antigravity+grok desenho, codex viabilidade IMPLEMENTAVEL-COM-AJUSTES). Pendente: cross-audit de ratificacao !=OpenAI + selagem 0097 + hearback; depois P2-A (dry-run do install-snapshot)."`
   - `proxima_acao: "PASSO 2 cross-audit de ratificacao da proposta-ponte v2 (readback 0096); depois selagem 0097, hearback e P2-A"`
   - `ultima_atualizacao: "2026-06-26T13:00:00-03:00"`
   - `readback_ativo: ".hbn/readbacks/0096-track-ponte-v2.json"`
   - `handoff_mais_recente: ".hbn/messages/20260626-130000-opus-4-8-despacho-track-ponte-v2.md"`
   - mantenha `roadmap_ativo`.
   - bloco `proximo_ponto` inteiro vira EXATAMENTE:
proximo_ponto:
  passo: "cross-audit de ratificacao da proposta-ponte v2 (readback 0096) por >=2 familias !=OpenAI"
  ato: cross-audit
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/messages/20260626-130000-opus-4-8-despacho-track-ponte-v2.md
  status: pendente
   - INSERIR no topo de sinais_abertos:
     - "🟡 PASSO 2 — PROPOSTA-PONTE v2 TRACKEADA — readback 0096; membrana duas-camadas (B-subset, git archive + manifesto, shims com active-version=., assert-snapshot-integrity local, router, tombstone humano-gated, canal feedback). D4 adiado p/ P3. Pendente cross-audit !=OpenAI + selagem 0097 + hearback; depois P2-A."
     - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0096 safe_track, implementador=codex, autorização humana Mauricio, orq_entrada_ref e trailers contiguos; aguarda cross-audit !=OpenAI + hearback + selagem 0097."

C5. APPEND em REGISTRY.md (7-col) — 3 linhas:
| 20260626-120000-opus-ponte-v2-consolidada | .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md | proposal | frio | fronteira | — | 2026-06-26T12:00:00-03:00 |
| 20260626-130000-opus-despacho-track-ponte-v2 | .hbn/messages/20260626-130000-opus-4-8-despacho-track-ponte-v2.md | despacho | frio | fronteira | — | 2026-06-26T13:00:00-03:00 |
| 20260626-130002-codex-readback-track-ponte-v2 | .hbn/readbacks/0096-track-ponte-v2.json | readback | frio | fronteira | — | 2026-06-26T13:00:02-03:00 |

C6. STAGE EXPLICITO + atestacao:
   git add .hbn/relay/STATE.md .hbn/messages/20260626-130000-opus-4-8-despacho-track-ponte-v2.md .hbn/readbacks/0096-track-ponte-v2.json .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md REGISTRY.md
   python3 /tmp/gen_orq.py
   git add .hbn/attestations/34a7f2f9-orq-entrada.json
   bash guards/assert-orq-entrada.sh   # verde

C7. Runner + suite + bateria; commit UNICO:
   bash guards/hbn-guards-runner.sh
   bash guards/tests/run-guard-tests.sh
   bash guards/tests/adversarial-battery.sh
   git rev-parse main   # == 4db692876381a0d7909985c8500d999f2e677b04
   git add .hbn/attestations/34a7f2f9-orq-entrada.json .hbn/relay/STATE.md .hbn/messages/20260626-130000-opus-4-8-despacho-track-ponte-v2.md .hbn/readbacks/0096-track-ponte-v2.json .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md REGISTRY.md
   git commit -m "chore(passo2): trackear proposta-ponte v2 consolidada (readback 0096, pendente ratificacao)" -m "HBN-Readback: 0096
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9"
Apos o commit: SOBRESCREVA .hbn/relay/RETURN.json {status: ok, sha: <NOVO>, readback: "0096-track-ponte-v2", w_freeze_started: true}. Reporte o SHA e cole `git rev-parse main`.

## scaffold — .hbn/readbacks/0096-track-ponte-v2.json
{
  "readback_id": "0096-track-ponte-v2",
  "execution_id": "track-ponte-v2-2026-06-26",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "path": ".hbn/readbacks/0096-track-ponte-v2.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260626-130000-opus-4-8-despacho-track-ponte-v2.md",
  "understanding": "Trackear no protocolo a proposta-ponte v2 consolidada (.hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md) como PROPOSTA pendente de ratificacao. A proposta sintetiza 3 consultas (antigravity+grok de desenho; codex de viabilidade=IMPLEMENTAVEL-COM-AJUSTES) + a direcao de Mauricio: membrana duas-camadas, escopo B-subset via git archive do tag v1-estavel + manifesto determinístico, guards no projeto via shims locais com .hbn/active-version=. (protocolo congelado intacto), assert-snapshot-integrity local, router obrigatorio no AGENTS.md, tombstone+untangle humano-gated, canal de feedback inbox; D4 (renomear .hbn/) adiado para P3. NAO implementa a ponte nem toca o Credenciamento. Proxima_acao: cross-audit de ratificacao por >=2 familias !=OpenAI (APROVA_0096), selagem 0097, hearback; depois P2-A (dry-run). Ato de autoridade sob G-ORQ-REF (Exit A').",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Mauricio aprovou (2026-06-26) trackear a proposta-ponte v2 e segui-la para ratificacao; decisoes de gate D4-adiado e shim active-version=. confirmadas.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      ".hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md",
      ".hbn/messages/20260626-130000-opus-4-8-despacho-track-ponte-v2.md",
      ".hbn/readbacks/0096-track-ponte-v2.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","guards/**","src/**","core/**","methodology/**","schemas/**","docs/brainstorm/**",".hbn/freeze/**",".hbn/hearbacks/**",".hbn/operators/**"]
  },
  "stop_condition": "Proposta-ponte v2 trackeada como proposta (0096). Parar para cross-audit !=OpenAI + hearback + selagem 0097. NAO implementar a ponte.",
  "HBN-Readback": "0096",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-26T13:00:00-03:00",
  "protocol_version": "0.3.0"
}
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
