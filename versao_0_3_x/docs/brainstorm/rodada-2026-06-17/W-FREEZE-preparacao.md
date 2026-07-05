# W-FREEZE — preparação do congelamento do PROTOCOLO (v1-estável)

NÃO-NORMATIVO (fronteira). Orquestrador (opus-4-8), 2026-06-17. Para o próximo orquestrador
executar a Fase B (freeze). Branch proposta/reestruturacao-m-a-s0; main 4db6928; sem tag v1.

---

## 0. ACHADO CRÍTICO (anti-teatro) — perfil do checklist
`core/freeze-gate-spec.md §3` define critérios canônicos para **app de domínio (V206)**:
`validacao-tela-a-tela`, `correcoes-com-teste-verde`, `idempotencia-provada`,
`pdfs-evidencia-rodizio`, `zero-bloqueador`, `pareceres-fechados`. **Esses são para congelar
o Credenciamento V206, NÃO o protocolo useHBN.** Congelar o protocolo exige um
**perfil-protocolo** próprio. Os critérios de domínio que não se aplicam ao protocolo entram
como `status: na` COM hearback verificável citado (regra §2.4 do spec). NÃO marcar `ok` sem
evidência (não conta — Truth Barrier). NÃO usar o perfil V206 para o protocolo (seria teatro).

## 1. Perfil-protocolo proposto (critérios do freeze de useHBN v1-estável)
Cada `ok` exige `evidencia` (comando+saída / arquivo:linha). Proposta a validar por
cross-audit ≠-família + hearback antes de rodar o gate:

| id | descrição | obrig. | evidência-fonte |
|---|---|---|---|
| suite-pytest-verde | pytest verde na contagem real | sim | `.venv/bin/pytest -q` → 213 passed |
| guard-tests-verde | run-guard-tests verde | sim | `run-guard-tests.sh` → 195/0 |
| adversarial-verde | bateria B1–B40 bloqueada | sim | `adversarial-battery.sh` → BATERIA VERDE |
| cross-audit-diversidade | toda onda selada ratificada por ≥2 famílias ≠-impl (G-DIVERSITY enforça) | sim | REGISTRY + `.hbn/results/` |
| fail-closed-guards | guards falham fechado | sim | run-guard-tests (casos fail-closed) |
| sem-regressao-main | main intacta; branch revisada | sim | `git rev-parse main` = 4db6928 + revisão humana |
| rastreabilidade | toda onda tem readback+hearback+token+REGISTRY | sim | REGISTRY + readbacks 0026–0054 |
| dividas-registradas | C-DEBT listadas, não escondidas | sim | STATE (R3c; zona_livre_curada; 4 batch1) |
| dossie-pre-transicao | Esteira R-PT1: dossiê completo + curado | sim | `docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/00-INDICE.md` |
| g-hrb-chave-operador | chave do operador registrada (assinatura do hearback) | sim* | `.hbn/operators/<nome>.pub` (ação humana) |
| zero-bloqueador | nenhum finding BLOQUEADOR aberto | sim | espelha `bloqueadores_abertos: 0` |

\* `g-hrb-chave-operador`: se a chave não for gerada agora, pode ser `na` com hearback
verificável (decisão humana registrada), mas o ideal é gerá-la (fecha a cadeia criptográfica
do hearback antes de congelar o genoma).

Critérios de domínio (V206) que NÃO se aplicam ao protocolo → `na` + justificativa com
hearback: `validacao-tela-a-tela`, `pdfs-evidencia-rodizio`, `pareceres-fechados (0034/0035/0036)`.

## 2. A onda W-FREEZE (a dispachar pelo próximo orquestrador)
Readback dedicado, safe_track. `files_allowed` mínimo:
- `.hbn/readbacks/<NNNN>-w-freeze.json`
- `.hbn/freeze/<checklist_id>-freeze-v1-estavel.json` (criar; `checklist_id` casa o pattern
  `^[0-9]{8}-[0-9]{2}-freeze-[a-z0-9.-]+$`, ex.: `20260618-01-freeze-v1-estavel`)
- `.hbn/relay/STATE.md`, `REGISTRY.md` (linha 7-col), handoff.
Codex PREENCHE o checklist (perfil-protocolo §1) com evidência por critério. NÃO roda o gate
(é ação humana). Cross-audit ≠-família valida o checklist + as evidências. Hearback.

## 3. Ações HUMANAS (Maurício, no Terminal — conclusivas)
Depois do checklist preenchido + cross-auditado:
1. **Chave do operador (G-HRB):**
   `ssh-keygen -t ed25519 -C "hbn-operador-mauricio" -f ~/.ssh/hbn_mauricio`
   copiar a `.pub` para `.hbn/operators/mauricio.pub` (committar via onda dedicada/curadoria).
2. **Rodar o gate (conclusivo):**
   `bash guards/freeze-gate.sh .hbn/freeze/<checklist_id>-freeze-v1-estavel.json`
   → exit 0 = congelável; exit 1 = lista o que falta. Colar a saída no handoff.
3. **Revisar a main / a branch** (olhar o diff acumulado da branch vs main).
4. **Tag (só com gate verde):**
   `git tag -a v1-estavel -m "useHBN v1-estavel (genoma 0.3.x congelado)"`
   (e push da tag quando o GitHub estiver pronto — Fase C).
5. STATE/REGISTRY marcam `v1-estavel`.

## 4. Ordem recomendada
W-FREEZE (esta) → Fase C (GitHub+Jules) e Fase D (Ponte v206) em paralelo → Fase E (Exúvia:
genoma limpo + nova numeração — usar `NUMERACAO-design-brief-e-validacao.md`) → Fase F (V207).

## 5. Anti-teatro (cole no rito do freeze)
- Nenhum critério `ok` sem `evidencia` real (comando+saída/arquivo:linha).
- O freeze é o **exit 0 do gate rodado pelo humano**, não uma frase de handoff.
- Critério inaplicável = `na` com hearback verificável, NUNCA `ok` vazio.
- Dívidas (R3c etc.) ENTRAM como registradas; não somem no congelamento.
