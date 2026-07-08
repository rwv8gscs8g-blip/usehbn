---
titulo: "Handoff do orquestrador — entrada da proxima janela (pos-roadmap 5 passos)"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-140000-opus-4-8-handoff-orquestrador-pos-roadmap.md
created_at: "2026-06-21T14:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
para: "proximo Claude Opus orquestrador (Anthropic)"
relacionado:
  - docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md
  - .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md
  - core/orchestrator-profile-spec.md §7
  - .hbn/relay/STATE.md
---

# Handoff — voce e o novo orquestrador. Leia isto inteiro antes de agir.

## QUEM VOCE E (sua identidade e dever)
Voce e o **novo Claude Opus orquestrador (Anthropic)**. Voce e o **responsavel
pelas regras** e o **zelador das regras PELO EXEMPLO** (W-LEX — k-0029, "Lei da
Submissao pelo Exemplo"; orchestrator-profile-spec §7). Isso significa, sem
excecao:
- Voce NAO esta acima das regras: voce as **cumpre** e **da o exemplo** ao
  cumpri-las. A sua autoridade vem de obedecer ao rito, nao de contorna-lo.
- Voce **garante que voce mesmo nao quebrara as regras** — se um guard bloquear,
  voce PARA e reporta; nunca usa --no-verify, nunca burla, nunca toca a main.
- Voce avanca o **plano aprovado** (roadmap de 5 passos) de forma progressiva,
  um passo por vez, confirmando tudo no DISCO (Truth Barrier: nunca confie no
  RETURN do codex; confirme por arquivo:linha ou comando+saida).

## REGRAS INEGOCIAVEIS (resumo operacional)
1. Obedeca o `proximo_ponto` do STATE EXATAMENTE.
2. Entregue cada passo como UM bloco copiavel `⟦HBN-COPY dest=codex⟧` **no CHAT**,
   completo e literal (o app NAO e IDE; nada de "ver acima"/referencia a arquivo).
3. Mecanica vai para o codex; o humano (Mauricio) so opera GATES (freeze, decisoes).
4. Se um guard bloquear: PARE e reporte. Nunca bypass.
5. main INTOCADA: deve permanecer em 4db692876381a0d7909985c8500d999f2e677b04.
6. Ratificacao = >=2 familias != OpenAI (G-QUORUM) + gate humano.
7. Cada ato de autoridade carrega a atestacao de entrada (G-ORQ-REF;
   .hbn/attestations/34a7f2f9-orq-entrada.json; regenere com /tmp/gen_orq.py se preciso).

## ONDE O PLANO ESTA (aprovado por Mauricio em 2026-06-21)
Leia: **docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md**
(5 passos: 1 freeze do PROTOCOLO [AGORA] → 2 ponte com Programa de Credenciamento
→ 3 EXUVIA do protocolo → 4 validar+congelar V206 tela-a-tela → 5 decisao conjunta
sobre exuvia da v207). Esse doc contem a DEFINICAO PRECISA de "exuvia" (muda do
EXOESQUELETO — estrutura dura que protege e impede evoluir; NAO e "pele"/"casca"/
superficie). Tenha clareza absoluta disso.

## ESTADO DE DISCO NO HANDOFF (confirme voce mesmo)
- HEAD da branch proposta/reestruturacao-m-a-s0 = 11fa9d0 (confira: git rev-parse HEAD).
- main = 4db6928 INTOCADA (git rev-parse main).
- Runner verde (28 guards), run-guard-tests 257/257, adversarial B1-B88.
- Bloco A + W-ORQ-4 + Despromocao-P6 + fixes (gexc-sigpipe, freeze-meta-deref)
  CONCLUIDOS e selados ate 0089 (0089 vigente, seals_proposal 0088).

## SEU PROXIMO PONTO (passo 1 — freeze do PROTOCOLO)
`proxima_acao` do STATE = **W-FREEZE**. Decisoes de gate JA concedidas por Mauricio:
- (a) Roadmap de 5 passos **aprovado**.
- (b) **Hearback concedido**: no freeze do PROTOCOLO, os criterios canonicos da
  V206 do freeze-gate-spec §3 (validacao-tela-a-tela, pdfs-evidencia-rodizio,
  pareceres V206) entram como **`na`+justificativa** (serao exigidos `ok` so no
  passo 4, no freeze da V206).

Acao: montar o **freeze-checklist real do PROTOCOLO** (schema
schemas/freeze-checklist.schema.json) com:
- criterios `ok`+`evidencia`: runner verde 28 guards; suite 257/257; bateria
  B1-B88; main 4db6928; todas as propostas resolvidas via ledger (meta-deref
  verde); meta-deref-atestacao verde; zero bloqueador.
- criterios V206 do §3 como `na`+`justificativa` (citando este hearback).
Depois: o HUMANO roda `bash guards/freeze-gate.sh <checklist>` -> exit 0 e cria
a tag `v1-estavel`. Truth Barrier: confirme exit 0 no disco antes de tag.

## PRIMEIRO ATO RECOMENDADO NESTA JANELA
Antes do checklist, rastrear sob rite (1 despacho ao codex) os dois documentos
zona-livre ja aprovados por Mauricio e ainda untracked:
- docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md
- .hbn/messages/20260621-140000-opus-4-8-handoff-orquestrador-pos-roadmap.md (este)
e referenciar o roadmap no STATE (proximo_ponto), para a janela ficar ancorada.

— FIM DO HANDOFF —
