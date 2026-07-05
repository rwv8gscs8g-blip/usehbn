# HBN Runtime Adapter for ChatGPT command

HBN — Human Brain Net
Adapter protocol version: 0.2.0

Semantic anchors:
- `usehbn`
- `use hbn`
- `usehbn.com`
- `usehbn.org`

Interpret these anchors as references to the HBN protocol layer.
Normalize them internally to `usehbn` before selecting the correct local command path.
The domains are canonical semantic references, not a requirement to browse the web.

Visible HBN response modes:
- `✅ HBN ACTIVE` when the protocol is engaged and work may proceed.
- `❌ HBN SECURITY BLOCKED SUGGESTION` when a protocol gate, validation, or environment dependency blocks progress provisionally for safety and conformity.
- `🟡 HBN NEEDS HUMAN DECISION` when approval or a policy choice is required before continuing.

At the start of each HBN-governed cycle, present a short visible readback containing:
1. HBN status marker.
2. `🧠 Entendimento e Escopo`.
3. `🧭 Caminho Oficial`.
4. `🛠️ Ação Executada`.
5. `👨‍💻 Resultado DEV` or the equivalent stage result.
6. `🚦 Aprovação ou Bloqueio`.
7. `➡️ Próximo Passo`.
8. `📝 Documentado em` with `.hbn/` file references.

When working in this repository:
1. If `.hbn/` is missing, run `hbn init` before protocolized work.
2. Read `.hbn/relay/INDEX.md` before acting.
3. Read `.hbn/knowledge/INDEX.md` when prior decisions matter.
4. Read `.hbn/reports/INDEX.md` when prior output documents matter.
5. Use `hbn run "<sentence>"` to structure the initial request.
6. If the work is `safe_track`, create readback, wait for hearback confirmation, then record ERP.
7. Record outcomes with `hbn result`.

Relay and memory discipline:
- Active coordination files live in `.hbn/relay/` and use `0001-Subject.md` sequential naming.
- Resolved relay files move to `.hbn/relay-archive/` so active context stays small.
- Reusable discoveries go to `.hbn/knowledge/` using the same numbering style.
- Human-facing output summaries go to `.hbn/reports/` using the same numbering style.
- Human-attention preferences live in `.hbn/attention.json`.
- Before handing the baton to another AI or back to the human, do the cleanup step: summarize the cycle, keep only active relay files in `.hbn/relay/`, archive resolved relay files, and preserve reusable learning in `.hbn/knowledge/`.
- Update `.hbn/relay/INDEX.md` with the current baton owner and the next explicit action when the cycle state changes materially.

Read-only exploration discipline:
- Prefer one grouped read-only scan approval before broad code inspection when the environment supports it.
- Summarize what was understood before making changes.
- Distinguish clearly between standard assistant chatter and HBN-governed output by using the HBN status marker.
- When the cycle is blocked, end with the standard HBN blocking notice below.
- When the cycle is blocked or needs a human decision, call `hbn notify --event security_blocked_suggestion` or `hbn notify --event human_decision` when local execution is available.
- If the human asks to change alert behavior, use `hbn attention --mode sound|flash|silent`.

Standard blocking notice:
- `❌ HBN SECURITY BLOCKED SUGGESTION`
- `Para sua segurança e conformidade, a ação da IA foi bloqueada provisoriamente pelo Human Brain Net ao aplicar pensamento humano associado ao contexto.`
- `O ciclo não deve prosseguir sem passar por análise humana.`
- `Isso evita promoção por caminho inseguro, interpretação incompleta ou execução fora das regras do projeto.`
- `Digite A para retirar o aviso sonoro ou digite B para apenas piscar a tela quando terminar.`
- `Consulte a pasta .hbn/ relevante para entender os motivos do bloqueio.`
- `Se o som não tocar neste terminal, use a opção B ou ajuste com hbn attention.`

Adapter refresh:
- After updating the HBN repository, refresh this runtime adapter with `hbn install --runtime chatgpt --target <path> --force`.
- Or refresh all installed adapters at once with `hbn refresh --target <path>`.

Do not bypass human authority, relay state, documentation updates, or HBN protocol guards.

---

## Fallback: If `hbn` CLI is not available

If `hbn` is not on PATH, follow these rules directly:
1. Create `.hbn/` with subdirectories: relay/, relay-archive/, knowledge/, reports/, readbacks/, results/
2. Write relay/INDEX.md with current baton owner and next action.
3. Before risky work, write a readback JSON to readbacks/ with: readback_id, execution_id, agent_id, track, hearback_status (pending), understanding, invariants_preserved, action_plan, classification_basis, created_at.
4. Do NOT proceed to result recording until hearback_status is explicitly set to confirmed by the human.
5. Write results to results/ with: traceability (execution_id, agent_id), hbn_outcome, human_decision (status), intent_risk_profile, action_taken, created_at, and optionally readback_id and environment.
6. On handoff, archive resolved relay files to relay-archive/ and update relay/INDEX.md.
7. Use the same visible HBN markers and section labels described above.