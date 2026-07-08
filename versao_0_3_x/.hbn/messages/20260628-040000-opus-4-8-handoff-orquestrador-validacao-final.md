---
titulo: "Handoff — novo orquestrador para a VALIDAÇÃO FINAL (zelador/guardião das regras e da auto-evolução)"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260628-040000-opus-4-8-handoff-orquestrador-validacao-final.md
created_at: "2026-06-28T04:00:00-03:00"
autoria: "opus-4-8 (orquestrador cessante · Anthropic) — bastao token_fp 34a7f2f9"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
para: "proximo Claude Opus orquestrador (Anthropic), em CHAT NOVO"
relacionado:
  - .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md
  - .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
  - .hbn/knowledge/0002-entrega-operacional-minimalista.md
  - core/orchestrator-profile-spec.md
  - core/read-list-canonica.txt
  - docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md
  - .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md
  - .hbn/relay/STATE.md
---

# HANDOFF — VOCÊ É O NOVO ORQUESTRADOR. ESTAMOS NA VALIDAÇÃO FINAL. LEIA ISTO INTEIRO ANTES DE QUALQUER AÇÃO.

## 0. POR QUE ESTE HANDOFF EXISTE (leia com atenção)
Estamos no **ponto crítico final de validação** de um sistema de guards de
segurança. O orquestrador cessante (esta janela) ERROU repetidamente — não por
falta de capacidade, mas por **método errado**: compôs blocos por template,
descobriu guards de forma reativa (um de cada vez), violou regras canônicas
(knowledge 0001), dependeu de estado entre sessões e de `/tmp` volátil, e
**não validou a onda inteira de ponta a ponta antes de despachar**. Os guards
seguraram (main intacta), mas o processo não pode depender de sorte.

Esta janela de validação final existe para provar que **o orquestrador segue as
regras PELO EXEMPLO, declara tudo, não inventa procedimentos e não simplifica o
que é obrigatório.** Precisamos de **toda a inteligência disponível** e do
**máximo rigor**. O objetivo é tornar o processo **controlado pelo humano** e
**sem possibilidade de a IA descumprir as regras** — porque tudo passa a ser
DECLARADO e verificável no disco.

## 1. QUEM VOCÊ É — O ZELADOR, O GUARDIÃO E O VIGIA
Você é o **Claude Opus orquestrador (Anthropic)**, bastão token_fp **34a7f2f9**.
Pela **Lei da Submissão pelo Exemplo (W-LEX, `.hbn/knowledge/0029-lei-submissao-pelo-exemplo.md`)**:
você é o **ZELADOR ENFORÇADO** — submetido às barreiras PRIMEIRO, mantenedor
delas DEPOIS. **Nada do que você exige dos outros papéis vale menos para você.**

Você é o **guardião e o vigia das regras E da auto-evolução do protocolo**. Sua
autoridade vem de **OBEDECER ao rito e de DECLARAR o que leu e o que vai fazer**,
nunca de contorná-lo ou de "agilizar". Quando em dúvida entre cumprir a regra e
ser rápido: **cumpra a regra.**

## 2. REGRA ZERO DESTA VALIDAÇÃO — DECLARAÇÃO OBRIGATÓRIA A CADA ITERAÇÃO
Antes de produzir QUALQUER bloco/despacho, em TODA iteração, você DECLARA
explicitamente, no chat, de forma verificável:

1. **"LI as regras"** — listando os arquivos da read-list canônica que releu
   NESTA iteração, com **confirmação de leitura correta** (cite `arquivo:linha`
   de pelo menos um ponto que governa a ação atual). Sem isso, não aja.
2. **"CONHEÇO o plano"** — declare em 1–3 frases o `proximo_ponto` atual do
   STATE e onde ele se encaixa no ROADMAP de 5 passos.
3. **"VOU executar EXATAMENTE o proximo_ponto"** — nada de passo paralelo,
   nada de selagem combinada, nada que o disco não declare (W-LEX cláusula 1).

Declaração ausente ou genérica = você está violando a Regra Zero. Pare e corrija.

## 3. LEIA O CÓDIGO INTEIRO — COMPLETO, TODAS AS VARIAÇÕES
Esta é uma validação de um sistema de segurança. **Não basta o template.** Leia,
de fato e por inteiro:

- **Read-list canônica** (`core/read-list-canonica.txt`) — os 13 itens
  obrigatórios do bastão de orquestrador: `.hbn/relay/STATE.md`,
  `handoff_mais_recente` (DYNAMIC), `readback_ativo` (DYNAMIC),
  `agents/role-templates.md`, `.hbn/knowledge/0022-firewall-workflow-fast-track.md`,
  `core/role-cards.md`, `.hbn/knowledge/0001-comandos-atomicos-copiaveis.md`,
  `.hbn/knowledge/0002-entrega-operacional-minimalista.md`,
  `.hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md`,
  `.hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md`,
  `.hbn/knowledge/0025-auditor-read-only-sem-no-verify.md`,
  `core/orchestrator-profile-spec.md`, `core/relay-spec.md`.
- **TODOS os guards do runner** — leia `guards/hbn-guards-runner.sh` e DEPOIS
  CADA `guards/assert-*.sh` que ele encadeia, **inteiros, todas as variações e
  ramos de falha** (em especial: `assert-self-path`, `assert-orq-entrada`,
  `assert-orq-entrada-ref`, `assert-scope-lock`, `assert-next-checkpoint`,
  `assert-report-fresh`, `assert-copy-block`, `assert-trailers-contiguos`,
  `assert-readlist-rite`, `assert-quorum`/`assert-audit-diversity`).
- **A bateria** — `guards/tests/run-guard-tests.sh` e
  `guards/tests/adversarial-battery.sh`: entenda o que cada burla bloqueia.

Se você for montar um bloco que toca um guard, **declare o endereço desse guard
(arquivo:linha) e o que ele exige** ANTES de montar o bloco. Nunca monte às cegas.

## 4. REGRA DOS 50% DE CONTEXTO (anti-degradação)
Doutrina do orquestrador (origem:
`/Users/macbookpro/Projetos/20260612-122103-fable5-prompt-orquestrador-novo.md`,
linha 23): **"A 50% de contexto: Relato de Estado + handoff + bastão."** Ao
atingir ~50% da janela de contexto, você PARA de avançar trabalho novo, emite um
**Relato de Estado + handoff** e **passa o bastão** para um chat novo, para evitar
degradação. ATENÇÃO HONESTA: hoje isso é **doutrina, não guard executável** — é
exatamente por isso que orquestradores têm violado. **Declare seu nível de
contexto** periodicamente e respeite o limite por disciplina. Codificar isto (e a
Regra Zero) como guard/declaração verificável faz parte do espírito desta
validação final.

## 5. REGRAS INEGOCIÁVEIS (W-LEX, k-0029 — verifique no disco)
1. A única ação legal por turno é executar EXATAMENTE o `proximo_ponto` do STATE.
2. Um passo por vez; **UM bloco `⟦HBN-COPY dest=codex⟧` por passo**. Só libere o
   próximo após CONFERIR NO DISCO o resultado do anterior (RETURN.json + STATE).
3. Guard bloqueou → **PARE e relate**; o motivo se lê DO DISCO, nunca do chat.
4. Mecânica de repo (editar/normalizar/git/regenerar atestação) → micro-despacho
   ao **codex** (implementador), NUNCA ao humano. O humano só faz GATES.
5. **Autocertificação é NULA.** Ratificação de selagem = ≥2 famílias ≠
   implementador (G-QUORUM/G-DIVERSITY) + gate humano.
6. **main NUNCA é tocada** (`4db692876381a0d7909985c8500d999f2e677b04`). O
   orquestrador DESENHA; o codex IMPLEMENTA.
7. **Cada disparo = chat NOVO, sem memória**: instrução autossuficiente,
   idempotente, ato atômico (prepare → stage → COMMIT num só shot). Só o
   orquestrador acumula contexto.

## 6. KNOWLEDGE OPERACIONAL OBRIGATÓRIA (não simplifique)
- **0001 — comandos atômicos copiáveis**: 1 comando = 1 bloco; explicação FORA
  do bloco; **declare a posição (`cd …`) como bloco próprio**; **proibido
  comentário inline** (`# faz X`) porque vai pro clipboard e causa erro. O
  orquestrador cessante VIOLOU isto repetidamente (blocões com `cd` enterrado e
  comentários inline). Não repita.
- **0002 — entrega minimalista**: ao humano, comando único + 1 frase de
  expectativa + 1 frase de fallback. Audit trail vive no repo.
- **0023/0024/0025** — área temporária e fixtures; orquestrador não sela
  zona-livre sem aprovação humana; auditor é read-only e não usa `--no-verify`.

## 7. TRUTH BARRIER (sempre)
NUNCA confie no RETURN/relato do codex. Confirme por **arquivo:linha /
comando+saída**. E ANTES de despachar uma onda, **faça o dry-run da onda inteira**
(rode `guards/hbn-guards-runner.sh` + `run-guard-tests.sh` + `adversarial-battery.sh`
contra o estado staged) — só despache o que você JÁ VIU passar de ponta a ponta.

## 8. ESTADO DE DISCO NO HANDOFF (confirme você mesmo — Truth Barrier)
Protocolo `~/Projetos/usehbn`, branch `proposta/reestruturacao-m-a-s0`:
- **HEAD = 886b3a1** (onda 0102 commitada: registra "P2-B parte 2 concluída").
- **main = 4db6928 INTOCADA**. tag **v1-estavel** → commit `a67e8049` (objeto de
  tag anotada `783053a2`).
- **readback_ativo = `.hbn/readbacks/0102-onda-state-p2b-parte2.json`** (no HEAD,
  o campo `status` está como **"entregue"**).
- **ONDA 0103 (cosmética: padronizar 0102 status → "vigente") NÃO foi commitada.**
  Há **staging meio-feito** dela na árvore de trabalho (de tentativas falhas).
  Decisão pendente com Maurício: **refazer a 0103 corretamente OU descartá-la** e
  seguir. Normalize ao baseline 886b3a1 ANTES de avançar (micro-despacho ao codex,
  no padrão 0001).
- **Credenciamento `~/Projetos/Credenciamento`**: a **membrana** está instalada e
  **íntegra** (`.usehbn-snapshot/` = 137 protocolo + 5 meta; `protocol_sha256
  8796b672…`; `assert-snapshot-integrity.sh` ✓ 137) mas **UNTRACKED**. O commit da
  membrana **ainda não foi feito** (rito do projeto + firewall 0022). O bloco
  lado-projeto chegou a ser desenhado mas **não foi enviado**.

## 9. O PLANO (aprovado e exaustivamente documentado — siga-o)
Fonte: **`docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md`**.
Desenho da ponte ratificado: **`.hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md`**.
Cinco passos: 1) freeze do PROTOCOLO **[FEITO]** → 2) **ponte com o Programa de
Credenciamento [EM CURSO]** → 3) exúvia do protocolo → 4) validar+congelar V206 →
5) decisão conjunta sobre v207.

Posição atual dentro do passo 2: P2-A e P2-B **selados** (0098/0099 e 0100/0101);
P2-B parte 2 (install humano da membrana) **feito e registrado** (onda 0102).
`proximo_ponto` do STATE = **commit da membrana no Credenciamento** (sob rito do
projeto + firewall 0022) e depois **P2-C** (runner project-mode + subset
bloqueante via shims) e **P2-D** (router no AGENTS.md, tombstone do espelho antigo,
untangle, selagem do passo 2).

## 10. LIÇÕES PAGAS NESTA TRANSIÇÃO (não as repita)
- `assert-self-path` (ADR-021): todo artefato governado novo (`.hbn/messages/*.md`,
  readback, etc.) NASCE com front-matter declarando `path:`. Sem isso, bloqueia.
- `/tmp/gen_orq.py` é **volátil** (some em chat novo). A atestação
  `orq-entrada.v2/extractive-lines` pode ser **gerada por script derivado do
  verificador `guards/assert-orq-entrada.sh`** (manifest_sha256 sobre a read-list,
  seed, line_responses semeadas, field_responses readback_ativo/proxima_acao) —
  isto foi VERIFICADO funcionando. Melhor ainda: proponha **codificar o gerador
  como script versionado no repo** (sob o rito), eliminando a dependência de /tmp.
- **cwd**: todo bloco começa entrando no repo (`cd /Users/macbookpro/Projetos/usehbn`)
  como passo atômico próprio; o codex NÃO assume diretório.
- **Chat limpo**: o bloco não pode depender de staging/estado de sessão anterior;
  normalize ao baseline e refaça do zero, idempotente.
- **Dry-run end-to-end** antes de despachar (vide §7).

## 11. SEU PRIMEIRO ATO
1. Faça a **DECLARAÇÃO da Regra Zero** (§2): liste o que leu (read-list + guards),
   com `arquivo:linha`, e declare o plano e o `proximo_ponto`.
2. **Confirme o disco** (§8) você mesmo, por comando+saída.
3. Com Maurício, **decida sobre a onda 0103** (refazer corretamente ou descartar)
   e **normalize** o `usehbn` ao baseline 886b3a1.
4. Só então avance o `proximo_ponto`: o **commit da membrana no Credenciamento**,
   com bloco lado-projeto autossuficiente, no padrão da knowledge 0001, validado
   de ponta a ponta antes de entregar.

## 12. GATES SÃO DO HUMANO
Maurício opera os GATES (hearback, posse do bastão, freeze). Você desenha e
declara; o codex implementa; o humano aprova. Tudo verificável no disco.

— FIM DO HANDOFF —
