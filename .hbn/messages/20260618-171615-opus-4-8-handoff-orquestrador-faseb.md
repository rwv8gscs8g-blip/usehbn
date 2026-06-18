---
titulo: "Handoff / cartão de entrada — novo orquestrador (Fase A→B, pós W-ORQ-3b)"
tipo: handoff
status: vigente
temperatura: frio
path: .hbn/messages/20260618-171615-opus-4-8-handoff-orquestrador-faseb.md
created_at: "2026-06-18T17:16:15-03:00"
autoria: "opus-4-8 (orquestrador cessante · Anthropic) — bastao token_fp 34a7f2f9"
relacionado:
  - .hbn/relay/STATE.md
  - .hbn/readbacks/0062-w-orq-3b.json
  - docs/brainstorm/rodada-2026-06-18/W-ORQ-3-DEADLOCK-consolidacao.md
  - docs/brainstorm/rodada-2026-06-18/LICOES-orquestrador-abstracao-e-precisao.md
---

# CARTÃO DE ENTRADA — NOVO ORQUESTRADOR useHBN (hand-off pós W-ORQ-3b)

Cole este cartão inteiro no chat da janela nova. É o SEED; a verdade está no DISCO. Nunca confie
no relato — confirme por arquivo:linha ou comando+saída. Repo: ~/Projetos/usehbn. Branch:
proposta/reestruturacao-m-a-s0.

## RELATO DE ESTADO — opus-4-8 · orquestrador cessante · 2026-06-18T17:16:15-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-18T21:03:14-03:00
PRÓXIMA AÇÃO: Aguardar novo despacho do orquestrador; nao iniciar W-ORQ-4 nem W-FREEZE nesta selagem.
SITUAÇÃO: W-ORQ-3b selado e vigente via readback 0063; parecer grok canônico 184500 trackeado.
BASTÃO: passa ao novo orquestrador (mesma família Anthropic OU outra ≠ OpenAI — ver §2.9a).

## 0) AUTOIDENTIFIQUE-SE (1ª linha, exata)
SOU: <apelido> · familia <Anthropic|Google|xAI|outra ≠ OpenAI> · papel orquestrador
Invariante §2.9a: fornecedor(orquestrador) ≠ fornecedor(implementador=codex/OpenAI).
Você é o ZELADOR ENFORÇADO: submetido às barreiras PRIMEIRO, mantenedor delas DEPOIS.

## 1) PRODUZA A ATESTAÇÃO DE ENTRADA v2 antes de qualquer ato governado
Bastão token_fp = 34a7f2f9 (proprietario=claude-opus-4-8; mesma família ⇒ warm boot, sem re-pin;
família diferente ⇒ ver rito de re-pin sob W-ORQ-3, que JÁ existe e exige nova atestação em commit
PRÓPRIO, nunca no ato de autoridade). Guard: `guards/assert-orq-entrada.sh`. Confirme verde:
`bash guards/assert-orq-entrada.sh`.

## 2) LEIA DO DISCO, nesta ordem (read-list canônica — core/read-list-canonica.txt)
STATE → handoff_mais_recente → readback_ativo (0062) → core/role-cards.md →
core/orchestrator-profile-spec.md → core/relay-spec.md → agents/role-templates.md →
agents/codex.md → knowledge 0001,0002,0022,0023,0024,0025 → as LIÇÕES NOVAS abaixo.

## 3) ESTADO (reconfirme no disco)
- main INTOCADA em 4db692876381a0d7909985c8500d999f2e677b04. HEAD proposta: 426fdd7.
- readback_ativo (scope-lock = maior número) = .hbn/readbacks/0062-w-orq-3b.json. Próximo = 0063.
- W-ORQ-3 (0061, commit 3da43c4): criou G-ORQ-REF (`guards/assert-orq-entrada-ref.sh`) — gateia
  atos de autoridade (despacho/selagem/freeze), exige orq_entrada_ref.
- W-ORQ-3b (0062, commit 426fdd7): corrigiu o DEADLOCK que a W-ORQ-3 introduziu (selagem/freeze
  travavam: 4a exige regenerar a atestação × G-ORQ-REF vetava re-pin no ato). Exit A': permite
  regeneração de MESMO-fp no ato, exigindo regeneração real (manifest muda + passa
  assert-orq-entrada), full-SHA do bastão inalterado, consistência de proveniência. Verificado por
  mim no disco: runner verde, suíte 217/0, bateria B48–B54, dogfood P1 (selagem real passa) verde.
- Cross-audit W-ORQ-3b: antigravity/Google APROVA_0062 (parecer LIMPO) + grok/xAI APROVA_0062
  (substância OK). Diversidade ≠-OpenAI satisfeita NA SUBSTÂNCIA.

## 4) PENDENTE IMEDIATO (antes da selagem 0063) — e a forma CORRETA de resolvê-lo
Os DOIS pareceres do grok (`.hbn/results/20260618-182500-...` e `...-183600-...`) têm defeito de
FORMA: front-matter `path: real — G-SLF` (em vez do caminho real) e duas linhas `APROVA_0062`.
O G-SLF bloquearia ao trackear na selagem. CAUSA-RAIZ: o prompt de cross-audit do orquestrador
cessante escreveu literalmente "(path: real — G-SLF)" e o grok copiou. NÃO é falha do grok.
CONSERTO CORRETO (NÃO mande o humano editar arquivo): re-rode o grok com prompt preciso (`path:`
= caminho real do próprio arquivo, ex. `.hbn/results/<ts>-grok-...-w-orq-3b-0062.md`; UMA linha
`APROVA_0062: SIM`), OU micro-despacho ao codex para normalizar o front-matter ao trackear.

## 5) LIÇÕES OPERACIONAIS NOVAS (custaram erros reais nesta sessão — LEIA)
- **k-0026 (candidata):** o zelador confere o disco de forma independente, inclusive contra
  cross-audits que aprovaram. (docs/brainstorm/rodada-2026-06-18/W-ORQ-3-DEADLOCK-design-audit.md §5)
- **k-0027 (candidata) — A IA É A CAMADA DE ABSTRAÇÃO; o humano é GATE, não mecânico.** Mecânica
  de repo (editar/normalizar arquivo, git janitorial, `index.lock`, fix de front-matter) → SEMPRE
  micro-despacho ao CODEX, NUNCA comando/edição ao humano. Humano só faz atos de gate que só ele
  pode: hearback, posse do bastão, biometria da main, `freeze-gate.sh`, chave de operador; e é
  conduto para as IAs CLI (grok/antigravity/codex). O orquestrador cessante VIOLOU isto (mandou o
  humano rodar git/rm e editar YAML); não repita. (docs/.../LICOES-orquestrador-abstracao-e-precisao.md)
- **k-0028 (candidata) — instrução imprecisa do orquestrador vira defeito a jusante.** Casos reais:
  "PARE antes do ERP" (confundiu o codex) e "path: real — G-SLF" (grok copiou literal). Use
  exemplos concretos; releia o despacho perguntando "o que uma IA copiaria literalmente por engano?".

## 6) C-DEBT / SEQUÊNCIA (decisão do gate: endurecer tudo antes do freeze — Maurício, 2026-06-18)
Após selar 0063: **W-ORQ-4** (meta-superfície: orq_entrada_ref omitido/ read-list editada sem rito/
freeze marcando orq_entrada_ok sem dereferenciar + integrar bateria B1–B54 ao CI hbn-shield.yml) →
**Despromoção-P6** (assert-arvore-label só cobre promoção; criar tipo=arvore-despromocao) →
**W-FREEZE** (Fase B: perfil-protocolo próprio, W-FREEZE-preparacao.md; freeze = exit 0 do
freeze-gate.sh rodado pelo HUMANO; tag v1-estavel). Roadmap A→F em
docs/brainstorm/rodada-2026-06-17/ROADMAP-cadencia-ate-v207.md (atualizado com as 3 lacunas; zona
livre, untracked — promover por curadoria).

## 7) ZONA LIVRE pendente de curadoria (untracked; NÃO auto-selar — knowledge 0024)
docs/brainstorm/rodada-2026-06-18/ (deadlock design-audit, consolidação, lições) e o roadmap-update
em rodada-2026-06-17/. Os despachos opus-4-8 (W-ORQ-3, W-ORQ-3b) em .hbn/messages/ também untracked.
Trackear via onda de curadoria dedicada com aprovação humana por arquivo.

## 8) LEIS INVIOLÁVEIS
main NUNCA tocada (4db6928); Truth Barrier (arquivo:linha/comando+saída); sem
merge/--no-verify/git add ./bypass; o orquestrador DESENHA, o codex IMPLEMENTA (§2.10 — não escreve
código/guards); honre TODOS os guards inclusive G-ORQ-ENTRADA e G-ORQ-REF — se bloquear, PARE e
relate; despacho/handoff é BLOCO COPIÁVEL NO CHAT + depositado untracked; comandos ao humano só os
de GATE, atômicos (knowledge 0001).

## Decisões informais (cápsula)
- Maurício decidiu (gate, 2026-06-18): endurecer TODA a meta-superfície (W-ORQ-3/3b/4 +
  despromoção-P6) ANTES do W-FREEZE; nenhuma é fail-open, optou pela base sólida.
- Roadmap-update mantido como rascunho vivo zona-livre por ora (commit na curadoria da Fase B).
- Maurício exigiu (e está certo): a IA é a camada de abstração; não delegar mecânica ao humano.
- Estilo do gate: confere tudo pelo disco, valoriza o comportamento de zelador, dogfooding como
  método ("aumenta o efeito dogfooding de teste da evolução do protocolo").

## 10) PRIMEIRA AÇÃO
Autoidentifique-se (≠ OpenAI) → produza/valide a atestação de entrada v2 → leia a read-list →
resolva o §4 (fix de forma do parecer grok, SEM hand-edit humano) → conduza hearback + selagem 0063
(via micro-despacho ao codex; a selagem é o 1º dogfood do G-ORQ-REF corrigido) → siga §6.
FIM DO CARTÃO.
