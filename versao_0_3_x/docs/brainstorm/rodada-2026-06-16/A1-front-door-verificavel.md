---
arvore: fronteira
status: congelado
tema: front-door verificavel
autor: subagente-opus-evolucao
data: 2026-06-16
temperatura: glacier
---

# A1 — Front-door / start-rite verificável para QUALQUER IA

> Análise de FRONTEIRA, não-normativa. Tudo aqui é proposta exploratória; nada
> vige até promoção a `core/` + ADR por onda formal (readback + cross-audit
> ≠-família + selagem). Truth Barrier: cada afirmação cita `arquivo:linha` ou
> comando+saída. Família do autor = Anthropic (igual ao orquestrador) → exige
> auditoria adversarial Codex/Gemini antes de virar regra.

## 0. O problema-raiz, em uma frase

Uma IA que recomeça num chat de contexto novo perde o "fio da meada" e às vezes
age **antes** de honrar o contrato de entrada. Evidência concreta no próprio
disco: `docs/brainstorm/exuvia-evolucao-conceitual.md:68` registra o chat
paralelo confessando que "Falhei em ler o contrato de entrada antes de escrever"
— escreveu no brainstorm sem ter lido `AGENTS.md`, que se declara "the entry
point for any AI operating in this repository" (`AGENTS.md:6`). O protocolo não
pode **depender de a IA querer** ler o contrato (`exuvia-...:69`).

- [CONCLUSÃO] O repo já tem **metade** do front-door, e é importante não
  reinventá-la. A porta da frente-arquivo existe: `core/role-cards.md` — ≤1 tela
  por construção, com teto anti-monolito de 140 linhas / 8192 bytes
  (`guards/assert-frontdoor.sh:20-21,45-60`), read-list de ≤6 itens
  (`assert-frontdoor.sh:129-132`) e 3 cartões de papel
  (`core/role-cards.md:14-32`). O guard `G-FRONTDOOR` (`assert-frontdoor.sh`)
  garante que esse arquivo **continue existindo, legível e enxuto**.
- [CONCLUSÃO] O que **falta** é o outro lado da porta: hoje `G-FRONTDOOR` valida
  a *placa na porta* (o arquivo está lá, curto e com a read-list certa), mas
  **nada verifica que a IA que entrou leu a placa antes do 1º write**. Não há
  eco/reconhecimento do contrato amarrado ao primeiro commit. Esta análise
  desenha esse pedaço faltante — chamo-o de **G-FDACK** (front-door
  acknowledgement) — para conviver ao lado do `G-FRONTDOOR` existente, sem
  duplicá-lo.

## 1. O arquivo de entrada mínimo (≤1 tela)

- [CONCLUSÃO] O arquivo já existe e **não deve ser substituído**: é
  `core/role-cards.md`. Reusá-lo evita criar segunda fonte de verdade — a mesma
  disciplina que `core/roles-assignment-spec.md:54-56` exige dos guards ("nunca
  uma tabela paralela"). A PARTE A já é a read-list canônica reduzida da
  retomada (`core/role-cards.md:3-12`), espelhando os 5 itens do
  `core/relay-spec.md:116-134`.
- [PROPOSTA] Acrescentar a `core/role-cards.md` UM elemento mínimo e estável:
  uma **PARTE C — TOKEN DE CONTRATO**, com uma única linha legível por humano e
  por máquina, p.ex.:

  ```
  ## PARTE C - TOKEN DE CONTRATO
  HBN-Frontdoor-Contract: v1
  Ao assumir o bastão, antes do 1º write, ecoe este token e a read-list lida.
  ```

  O token NÃO é segredo (ao contrário do baton-token de
  `guards/assert-baton-token.sh:16-20`): é um **versionador do contrato**. Seu
  papel é provar *qual versão da porta* a IA reconheceu. Quando a porta muda de
  forma materialmente relevante, bump `v1→v2`; ecos `v1` deixam de valer — o
  mesmo princípio de rotação do baton (`assert-baton-token.sh:20-21`), mas
  público e por-conteúdo, não por-posse.
- [PROPOSTA] O token derivado, mais forte (opcional, fase 2): em vez de `v1`
  literal, usar `sha256(core/role-cards.md)[:8]` como fingerprint do contrato —
  exatamente o padrão fingerprint público de `assert-baton-token.sh:115,145-156`
  (`HBN-Token-FP` = 8 primeiros hex). Assim o eco prova que a IA leu **o
  conteúdo vigente**, não uma versão velha decorada. Custo: o fingerprint muda a
  cada edição da porta (até de espaço), o que pode ser ruído; daí começar com
  `v1` manual e migrar para hash-de-conteúdo só se a porta estabilizar.

## 2. Como a IA "reconhece" — eco verificável e fail-closed

- [CONCLUSÃO] O repo já tem DOIS padrões mecânicos prontos para "provar que li/
  possuo X antes de commitar", e o front-door deve reusá-los em vez de inventar
  um terceiro:
  1. **Trailer de commit conferido contra um campo do STATE** —
     `assert-baton-token.sh:145-156` lê `HBN-Token-FP:` do commit-msg e compara
     com `bastao_token_sha256` do STATE staged.
  2. **Front-matter de artefato conferido contra readback ativo + token + STATE**
     — `assert-dispatch-integrity.sh:168-200` exige `readback_id`/`token_fp`/
     `human_authorization` e cruza cada um com o STATE.

- [PROPOSTA] **Mecânica do reconhecimento (G-FDACK).** A IA, ao assumir o
  bastão, deposita UM artefato de reconhecimento e o referencia no commit:

  - Artefato: `.hbn/frontdoor/<carimbo>-<agente>-ack.md` (carimbo
    `AAAAMMDD-HHMMSS`, agente = apelido de perfil `.hbn/models/`), com
    front-matter mínimo:
    ```yaml
    ---
    contract_token: v1                 # == PARTE C de core/role-cards.md
    agente: <apelido>                  # perfil .hbn/models/<apelido>.json existe
    readlist_lida:                     # ecoa os itens da PARTE A que leu
      - .hbn/relay/STATE.md
      - <readback ativo apontado no STATE>
      - core/role-cards.md
      - .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
      - .hbn/knowledge/0002-entrega-operacional-minimalista.md
      - .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md
    created_at: "<ISO8601 com offset>"
    ---
    ```
  - Trailer no 1º commit substantivo: `HBN-Frontdoor-Ack: <basename do ack>`
    (mesma família de trailer de `assert-baton-token.sh:146` e dos campos de
    `assert-dispatch-integrity.sh:168`).

- [PROPOSTA] **O que G-FDACK verifica (fail-closed, no estilo dos guards
  existentes).** Gatilho: o diff staged toca QUALQUER path governado fora de
  `.hbn/frontdoor/**` (i.e., qualquer "write substantivo"). Então:

  1. **BLOQUEADOR**: `core/role-cards.md` ausente/ilegível no índice/HEAD →
     falha fechado. (Reusa a leitura de blob staged de
     `assert-frontdoor.sh:39-54`; sem a porta, nada de reconhecer.)
  2. **BLOQUEADOR**: nenhum ack staged no MESMO diff E nenhum ack pré-existente
     referenciado pelo trailer `HBN-Frontdoor-Ack:` do commit em curso → o 1º
     write não honrou o contrato.
  3. **BLOQUEADOR**: `contract_token` do ack ≠ PARTE C de `core/role-cards.md`
     no índice/HEAD (eco de versão velha; comparação por igualdade exata, como o
     token exato de `core/start-rite-spec.md:108-112` evita prefixo).
  4. **BLOQUEADOR**: `agente` do ack sem perfil em `.hbn/models/<agente>.json`
     (mesma exigência de `core/roles-assignment-spec.md:38-39`).
  5. **BLOQUEADOR**: `readlist_lida` não cobre os itens da PARTE A de
     `core/role-cards.md` resolvida no índice/HEAD (incluindo o readback ativo
     real apontado pelo STATE — derreferência igual à de
     `assert-zona-livre.sh:61-63`). Cobertura parcial = não leu.
  6. **BLOQUEADOR** (fail-closed): STATE ausente/ilegível, ou `python3` ausente
     para validar o JSON/YAML → bloqueia (idêntico a
     `assert-zona-livre.sh:56-59,101-104`).

- [CONCLUSÃO] Isto é **fail-closed por construção e satisfaz C-FCLOSE**
  (`core/exuvia-fitness-criteria.md:83`): faltando a porta, o ack, o STATE ou o
  interpretador, o guard sai ≠0. "Falhar aberto" (liberar no escuro) está
  vedado pela própria definição em `exuvia-fitness-criteria.md:52`.

## 3. Dogfood — o mecanismo passa pelo próprio guard

- [PROPOSTA] **A onda que cria G-FDACK é a primeira a depositar um ack.** O
  commit que introduz `guards/assert-frontdoor-ack.sh` + a PARTE C de
  `core/role-cards.md` toca paths governados → dispara o próprio G-FDACK → exige
  um `.hbn/frontdoor/<...>-ack.md` no mesmo pacote, com `contract_token` igual à
  PARTE C recém-escrita e a read-list ecoada. Sem grandfathering. É exatamente o
  dogfood que `core/exuvia-fitness-criteria.md:51,82` define ("o despacho que
  criou a regra de despacho foi o primeiro a passar pela regra"), e que S2 já
  praticou (`assert-dispatch-integrity.sh` cabeçalho; placar
  `exuvia-fitness-criteria.md:106`).
- [CONCLUSÃO] O dogfood resolve um paradoxo de bootstrap honestamente: o
  `contract_token` da PARTE C precisa existir no índice ANTES de o ack poder
  ecoá-lo. Como ambos entram no MESMO commit staged, o guard lê os dois do
  índice (`:path`, padrão de `assert-frontdoor.sh:30,80-84`) — coerência sem
  necessidade de dois commits.

## 4. Integração com STATE×LOG, quente/frio e os 8 critérios

- [CONCLUSÃO] **STATE×LOG.** A read-list ecoada no ack É a read-list canônica de
  5 itens do `core/relay-spec.md:116-134`, materializada na PARTE A de
  `core/role-cards.md:3-12`. O ack não duplica o STATE: ele **aponta** para
  `.hbn/relay/STATE.md` e para o readback ativo que o STATE declara (campo
  `readback_ativo`, derreferenciado como em `assert-zona-livre.sh:61-63`). O LOG
  frio (`relay-archive/`, `relay-spec.md:60-66`) **nunca** entra na read-list
  nem no ack — continua consulta sob demanda.
- [PROPOSTA] **Quente/frio.** O ack é um artefato **quente-efêmero**: vale para
  a janela/onda corrente e esfria assim que o bastão roda. Sugiro a mesma
  disciplina de envelhecimento que o próprio brainstorm pediu para não virar
  pântano (`exuvia-evolucao-conceitual.md:48`): acks de ondas fechadas migram
  para frio (ou são purgados) na faxina periódica. O `contract_token` (PARTE C)
  é o único pedaço **sempre-quente** do mecanismo — e só ele —, qualificando-se
  pela regra de invariante sempre-quente de `relay-spec.md:136-141` (crítico de
  entrada E ainda não coberto por outro guard executável). Quando G-FDACK estiver
  selado e verde, o *ato de ler* deixa de depender de memória e passa a ser
  garantido por guard — exatamente a transição que `relay-spec.md:138-141`
  descreve ("quando um guard executável passar a cobri-lo, ele sai da read-list").
- [PROPOSTA] **Os 8 critérios de exúvia** (`core/exuvia-fitness-criteria.md:77-86`),
  aplicados a G-FDACK como alvo de sobrevivência ao molt:
  - C-TEST: casos positivo+negativo na suíte (§5 abaixo) — `exuvia-...:79`.
  - C-ADV: uma burla documentada e bloqueada (ack com token velho; ack de outra
    janela "emprestado") vira linha Bxx em `guards/tests/adversarial-battery.sh`
    — `exuvia-...:80`.
  - C-XAUDIT: ≥2 famílias ≠ Anthropic (Codex/Gemini) aprovam — `exuvia-...:81`;
    obrigatório aqui porque o autor é Anthropic (`exuvia-evolucao-...:133`).
  - C-DOG: §3 acima — `exuvia-...:82`.
  - C-FCLOSE: §2 BLOQUEADOR 6 — `exuvia-...:83`.
  - C-NOREG: G-FDACK **não toca** `G-FRONTDOOR` nem nenhum guard do runner
    (`hbn-guards-runner.sh:49-72`); entra como item NOVO, suíte inteira verde —
    `exuvia-...:84`.
  - C-TRACE: readback + autorização humana + REGISTRY na onda de selagem —
    `exuvia-...:85`.
  - C-DEBT: dívidas conhecidas registradas (ver §6) — `exuvia-...:86`.
- [PROPOSTA] **Ordem no runner.** G-FDACK deve rodar **logo após**
  `assert-frontdoor.sh` em `hbn-guards-runner.sh:66` (a placa antes do eco da
  placa), e ANTES dos guards de conteúdo. É um item novo na lista
  `hbn-guards-runner.sh:49-72`, sem reordenar os demais (C-NOREG).

## 5. Casos de teste (estilo `guards/tests/run-guard-tests.sh`)

- [PROPOSTA] Seção `G-FDACK` na suíte (fixtures herméticas em repo git
  descartável, como a suíte já faz — `run-guard-tests.sh:9-11`):

  ```
  check "fdack: write substantivo COM ack válido + token vigente"        pass
  check "fdack: write substantivo SEM ack e SEM trailer"                 block
  check "fdack: ack com contract_token velho (v0 vs v1 da PARTE C)"      block
  check "fdack: ack de agente sem perfil em .hbn/models/"                block
  check "fdack: readlist_lida incompleta (faltou o readback ativo)"      block
  check "fdack: core/role-cards.md ausente no índice (fail-closed)"      block
  check "fdack: STATE ausente/ilegível (fail-closed)"                    block
  check "fdack: commit só dentro de .hbn/frontdoor/** (não exige ack)"   pass
  check "fdack: dogfood — commit que cria o guard traz seu próprio ack"  pass
  check "fdack: token EXATO — 'v1' não casa como prefixo de 'v10'"       block
  ```

  Saldo: 10 checks (7 block, 3 pass). O caso "token exato" herda o cuidado
  anti-prefixo de `core/start-rite-spec.md:108-112,133`.

- [PROPOSTA] Caso de compatibilidade dedicado (risco de regressão do
  `G-FRONTDOOR`): provar que adicionar a PARTE C **não** estoura os tetos de
  `assert-frontdoor.sh:20-21` (140 linhas / 8192 bytes) nem quebra o parser da
  PARTE A (`assert-frontdoor.sh:62-74`, que delimita por `## PARTE A` … `## PARTE
  B`). A PARTE C entra DEPOIS da PARTE B, fora do bloco lido pela read-list.

## 6. Riscos honestos e o que NÃO é viável agora

- [PERGUNTA ABERTA] **O eco prova leitura?** Não. Um ack provado por trailer
  prova que *alguém escreveu o token certo*, não que a IA *compreendeu* o
  contrato — a mesma honestidade que `assert-baton-token.sh:22-24` declara
  ("NÃO prova posse exclusiva nem identidade"). G-FDACK eleva o **custo de
  pular** o contrato (precisa ecoar token vigente + read-list real + ter perfil)
  e cria **rastro auditável** de quem entrou sem reconhecer; não garante
  cognição. Honestidade ≥ teatro (`exuvia-evolucao-...:127-128`).
- [PERGUNTA ABERTA] **Bootstrap do "1º write".** Em sandbox/chat sem git-commit
  imediato (o caso que originou a falha), o guard só morde no commit. A IA pode
  alucinar livremente no chat antes de qualquer commit. Mitigação parcial:
  tornar o ack o PRIMEIRO artefato que a IA deposita (ritual conversacional do
  `core/start-rite-spec.md:1-28`, que "termina IMPRIMINDO; o humano comita").
  G-FDACK fecha a porta do **disco**, não a da **conversa** — limitação real,
  igual à de qualquer guard git-native.
- [PERGUNTA ABERTA] **Ack "emprestado".** Uma IA poderia copiar um ack válido de
  outra janela e ecoar o trailer. O `agente` do ack e o perfil mitigam a
  rastreabilidade, mas sem ligação ao baton-token (`assert-baton-token.sh`) não
  há prova de posse. Decisão de design a submeter: G-FDACK exige também
  `HBN-Token-FP` coerente (acoplar ao baton) ou fica deliberadamente mais barato
  e só-rastreável? Acoplar aumenta segurança e custo de bootstrap.
- [CONCLUSÃO] **Não-viável agora / fora de escopo:** (a) qualquer execução por
  CLI — `usehbn start` é rito conversacional, não comando
  (`core/start-rite-spec.md:18-22`); orquestração por CLI é VISÃO
  (`exuvia-evolucao-...:95`). (b) Editar `core/role-cards.md`, criar o guard,
  alterar o runner ou a suíte: isto é trabalho de ONDA formal com readback +
  cross-audit ≠-família + hearback (`AGENTS.md:104-105`;
  `exuvia-evolucao-...:106`), não de análise de fronteira. (c) Promoção a `core/`
  exige leitura cross-family ≠ Anthropic e trailer de proveniência apontando a
  esta entrada (`exuvia-evolucao-...:46`).
- [CONCLUSÃO] **Segunda fonte de verdade — risco controlado.** G-FDACK NÃO
  reescreve a read-list: ele a LÊ de `core/role-cards.md` PARTE A e do STATE, as
  fontes que já existem (`roles-assignment-spec.md:54-56` proíbe tabela
  paralela). O único dado novo é o `contract_token` da PARTE C — e ele vive num
  só lugar.

## 7. Síntese para o orquestrador

- [CONCLUSÃO] O front-door **já tem a placa** (`core/role-cards.md` +
  `G-FRONTDOOR`); falta o **eco verificável da placa antes do 1º write**.
- [PROPOSTA] Adicionar (em onda formal, não aqui): PARTE C com `contract_token`
  em `core/role-cards.md`; guard `G-FDACK` (`assert-frontdoor-ack.sh`) que, ao
  ver write substantivo staged, exige um `.hbn/frontdoor/<...>-ack.md` ecoando
  token vigente + read-list real + agente com perfil, fail-closed; trailer
  `HBN-Frontdoor-Ack:` no commit; entrada no runner após `G-FRONTDOOR`.
- [PROPOSTA] Reusar 100% dos padrões existentes (trailer×STATE de
  `assert-baton-token.sh`; front-matter×readback de `assert-dispatch-integrity.sh`;
  derreferência de readback ativo de `assert-zona-livre.sh`) → custo de
  implementação baixo, superfície de regressão pequena.
- [PERGUNTA ABERTA] Acoplar G-FDACK ao baton-token (prova de posse) ou mantê-lo
  barato e só-rastreável? — decisão para a auditoria adversarial Codex/Gemini.
