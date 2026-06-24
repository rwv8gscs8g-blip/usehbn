---
titulo: "Macro-roadmap pos-blindagem (5 passos) — do freeze do PROTOCOLO ate a possivel exuvia v207"
tipo: roadmap
status: proposto
temperatura: frio
path: docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md
created_at: "2026-06-21T13:30:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9; direcao de Mauricio em 2026-06-21"
relacionado:
  - .hbn/messages/20260620-180000-opus-4-8-handoff-orquestrador-faseC.md  (cartao faseC, §6.A/B/C)
  - docs/brainstorm/rodada-2026-06-17/ROADMAP-cadencia-ate-v207.md  (roadmap anterior — este o refina/ordena)
  - docs/brainstorm/rodada-2026-06-17/W-FREEZE-preparacao.md
  - docs/brainstorm/rodada-2026-06-17/SINTESE-PROFUNDA-pre-freeze.md
  - docs/brainstorm/rodada-2026-06-17/NUMERACAO-dossie-entrada-design-exuvia.md  (LINHA MAIOR / exuvia)
  - .hbn/readbacks/0010-*.json, 0011-*.json  (plano exuvia v2)
  - .hbn/readbacks/0012-*.json, 0016-*.json  (M-A scaffold)
---

# Macro-roadmap pos-blindagem do orquestrador — 5 passos

Direcao de Mauricio (2026-06-21). Este documento RESGATA o plano anterior
(cartao faseC §6 + ROADMAP-cadencia-ate-v207) e o ORDENA em 5 passos
progressivos, para que a proxima IA orquestradora (ou opus-4-8 com contexto)
avance sem se perder. Verdade no DISCO; cada passo so anda apos confirmar o
anterior no disco (RETURN.json + STATE).

---

## 0. ONDE ESTAMOS (status atual — evidencia de disco, 2026-06-21)

- **Bloco A "blindar o orquestrador" (faseC §6.A): COMPLETO e selado.**
  W-RET (0067→0068), G-NEXT (0066→0069), G-QUORUM (0070→0071), W-LEX (0072→0073).
- **Roadmap B ate o freeze (faseC §6.B): COMPLETO e selado.**
  W-ORQ-4 inteiro: 4a G-READLIST-RITE (0074→0075), 4b G-ORQ-REF/messages (0076→0077),
  4c freeze-gate meta-deref (0078→0079), 4d CI battery + G-CI-BATTERY
  (0080/0081 reprovados → redesenho igualdade-exata 0082→0085).
  Despromocao-P6 G-ARVORE-LABEL cobre despromocao (0086→0087).
  Dois fixes pegos pelo cross-audit/Truth Barrier: fix-gexc-sigpipe (0083→0084)
  e fix-freeze-meta-deref (0088→0089).
- **HEAD = 11fa9d0; main INTOCADA = 4db6928.** Runner verde (28 guards),
  run-guard-tests 257/257, adversarial B1-B88, atestacao 34a7f2f9 valida.
- **proxima_acao no STATE = "W-FREEZE".** O freeze-gate ja roda o
  meta-deref (4c) e nao veta mais por propostas (todas resolvidas pelo ledger,
  fix 0088/0089). Falta APENAS o checklist real do freeze do PROTOCOLO.

---

## ESCLARECIMENTO CRITICO — existem DOIS congelamentos distintos

1. **Freeze do PROTOCOLO** (`v1-estavel` do HBN em si): e o **passo 1** (agora).
   Congela o conjunto de guards/specs/ritos que blindam o orquestrador.
2. **Freeze da V206** (o app de DOMINIO que o protocolo auxilia): e o **passo 4**.
   Usa os criterios canonicos do `core/freeze-gate-spec.md §3`
   (validacao-tela-a-tela, pdfs-evidencia-rodizio, pareceres 0034/0035/0036).

Esses criterios §3 sao do PERFIL V206; **no freeze do PROTOCOLO (passo 1) eles
entram como `na` com hearback humano** (nao se aplicam a um freeze de protocolo).
Confundir os dois foi um risco real; aqui fica cravado que sao freezes separados.

---

## DEFINICAO PRECISA DE "EXUVIA" (leitura obrigatoria para TODA IA)

EXUVIA **NAO** e "troca de pele", "troca de casca", "aparencia" nem nada
superficial. Exuvia e a **muda do EXOESQUELETO** — a estrutura DURA que, nos
artropodes (lagosta, caranguejo, etc.), ao mesmo tempo **protege** o organismo
**e impede o seu crescimento**. A exuvia e o momento em que essa carapaca rigida
e abandonada justamente para o organismo **poder crescer e avancar**.

Aplicado ao protocolo: a exuvia e o momento de abandonar a **estrutura dura que
hoje protege o protocolo mas que, mantida, o impediria de evoluir**, para que o
protocolo **cresca e avance**. Nao e cosmetico; e mudanca estrutural profunda.
Esta documentacao e exaustiva e canonica — nenhuma IA deve reduzir "exuvia" a
metafora de pele/casca/superficie.

---

## OS 5 PASSOS (na ordem de execucao)

### PASSO 1 — Validar/evoluir/congelar o PROTOCOLO (v1-estavel)  [AGORA]
- **O que e:** rodar o `freeze-gate.sh` com um checklist real do PROTOCOLO
  (exit 0) e cravar a tag `v1-estavel` do protocolo. Ato de **GATE humano**.
- **Criterio de pronto:** `bash guards/freeze-gate.sh <checklist-protocolo>` exit 0;
  tag `v1-estavel` criada; main intocada.
- **Checklist do protocolo (o orquestrador prepara; humano roda):**
  criterios `ok`+evidencia apropriados ao protocolo (runner verde 28 guards;
  suite 257/257; bateria B1-B88; main 4db6928; todas as propostas resolvidas
  via ledger; meta-deref-atestacao verde); criterios V206 do §3
  (tela-a-tela, pdfs-rodizio, pareceres V206) como `na`+justificativa com
  **hearback de Mauricio**.
- **Gate:** Mauricio confirma o `na`+hearback dos criterios V206 e roda o freeze+tag.
- **Refs:** faseC §6.B; W-FREEZE-preparacao.md; SINTESE-PROFUNDA-pre-freeze.md.

### PASSO 2 — Ponte com o Programa de Credenciamento
- **O que e:** ligar o protocolo NOVO (selado em v1-estavel) ao Programa de
  Credenciamento para VALIDAR, na pratica, que o protocolo funciona e e bom —
  uma "ponte" entre o protocolo e os sistemas que ele auxilia.
- **Criterio de pronto:** evidencia de que o protocolo selado credencia/valida
  corretamente (a definir no rito do passo 2); a ponte fica explicita e
  transparente (e o que torna o passo 3, a exuvia, clara).
- **Refs:** LINHA MAIOR (faseC §6.C); M-A scaffold (readbacks 0012/0016).

### PASSO 3 — Exuvia do PROTOCOLO (muda do exoesqueleto + pasta nova)
- **O que e:** a EXUVIA do protocolo (ver "DEFINICAO PRECISA DE EXUVIA" acima) —
  abandonar a estrutura DURA que hoje protege o protocolo mas que, mantida,
  impediria sua evolucao, para que ele **cresca e avance**. Concretamente,
  o protocolo renasce reorganizado numa PASTA NOVA — tudo organizado, facil e
  detalhado, para que as IAs NAO se percam. Mudanca ESTRUTURAL, nao cosmetica.
  Como a ponte (passo 2) ja estara feita, o vinculo protocolo↔sistemas fica
  claro e transparente na nova organizacao.
- **Criterio de pronto:** nova pasta com o protocolo reorganizado; equivalencia
  de arvore/funcao provada; ritos preservados; entrada da nova janela trivial.
- **Refs:** NUMERACAO-dossie-entrada-design-exuvia.md; readbacks 0010/0011 (exuvia v2).

### PASSO 4 — Validar e congelar a V206 (app de dominio)
- **O que e:** com o protocolo renovado (pos-exuvia), validar os pontos finais
  e **tela a tela** da V206; SOMENTE quando isso estiver vencido e validado,
  congelar a V206 (o freeze do app de dominio, criterios §3).
- **Criterio de pronto:** `freeze-gate.sh` da V206 exit 0 com os criterios §3
  (tela-a-tela, pdfs-rodizio, pareceres) todos `ok`+evidencia; tag da V206.
- **Refs:** core/freeze-gate-spec.md §3.

### PASSO 5 — (Decisao conjunta) Exuvia da v207 para construir a v207
- **O que e:** apos a estabilizacao, DECIDIR EM CONJUNTO se fazemos a exuvia
  da v207 para refatorar e melhorar o sistema — o momento adequado para o
  refatoramento pos-estabilizacao.
- **Gate:** decisao conjunta Mauricio + orquestrador. Nao iniciar sem este gate.
- **Refs:** ROADMAP-cadencia-ate-v207.md.

---

## RECONCILIACAO COM O PLANO ANTERIOR (faseC §6)

- §6.A (blindar o orquestrador) → CONCLUIDO (ver secao 0).
- §6.B (W-ORQ-4 → Despromocao-P6 → W-FREEZE) → W-ORQ-4 e Despromocao-P6
  CONCLUIDOS; o "W-FREEZE" do §6.B = **passo 1** (freeze do PROTOCOLO).
- §6.C (LINHA MAIOR: ponte / exuvia / M-A scaffold; "so apos o freeze e com novo
  rito") → desdobrada e ORDENADA nos **passos 2 (ponte), 3 (exuvia do protocolo),
  4 (V206), 5 (v207)**. O ajuste de Mauricio (2026-06-21): inserir a **ponte com
  o Programa de Credenciamento (passo 2)** ANTES da exuvia, para validar que o
  protocolo selado funciona; e separar claramente o freeze do PROTOCOLO (passo 1)
  do freeze da V206 (passo 4).

## COMO A PROXIMA JANELA RETOMA
1. Le o STATE (`proxima_acao`/`proximo_ponto`) — sempre a bussola.
2. Le ESTE documento para o macro-contexto dos 5 passos.
3. Executa EXATAMENTE o proximo_ponto; um passo por vez; confirma no disco antes de avancar.
4. Cada ato de autoridade sob G-ORQ-REF; cada selagem com quorum >=2 familias !=-OpenAI (G-QUORUM); main NUNCA tocada.

— FIM DO ROADMAP —
