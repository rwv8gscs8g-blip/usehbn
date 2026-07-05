---
tipo: audit-result
autor: claude
familia: Anthropic
papel: auditor
path: .hbn/results/20260701-174500-claude-cross-ia-orquestrador-saneamento-0115.md
created_at: 2026-07-01T17:45:00-03:00
head_auditado: 17ac01bc63d14721107e79466d66b2ea7c59fee8
branch: proposta/reestruturacao-m-a-s0
status: congelado
temperatura: glacier
---

SOU: claude · familia Anthropic · papel auditor

# Auditoria Cruzada de IA — Rito de Orquestração do Saneamento (0115)

## Veredito

APROVA_0115: NAO

Esclarecimento do veredito (não é refutação técnica). Concordo com Antigravity
que **o código do guard funciona** e que a suíte está verde (272 run-guard-tests,
adversarial B93–B96, 213 pytest). O `NAO` recai sobre a **selagem/ratificação**,
não sobre a utilidade imediata: 0115 foi produzido em violação direta do papel
de orquestrador e carrega um defeito ALTO de portabilidade (path absoluto
hard-coded). Ratificá-lo com `SIM` selaria a própria violação que este
saneamento existe para fechar. O split com o `APROVA_0115: SIM` de Antigravity é
o resultado **mecanicamente correto**: sem quórum de 2 famílias concordantes,
G-QUORUM/G-DIVERSITY impedem a selagem — que é exatamente o estado seguro.

Posição operacional: **manter 0115 como hotfix provisório** (`temperatura:
quente`, `status: proposed` no REGISTRY), NÃO reverter agora (reverter reabriria
a brecha de prompts não-autocontidos), e **suceder por patch de implementador
externo não-OpenAI** que remova o path hard-coded, antes de qualquer selagem.

---

## Preflight e Inventário (Comandos 1–7)

- **C1** `git rev-parse HEAD` → `17ac01bc63d14721107e79466d66b2ea7c59fee8` ✓ bate com o esperado.
- **C2** `git status -sb` (usehbn) → `proposta/reestruturacao-m-a-s0` sincronizada com origin; muitos `??` untracked (ver Resíduos). Nota: `.git/index.lock` presente no mount (não interferi — nenhum stage/commit foi feito).
- **C3** `git status -sb` (Credenciamento) → HEAD `0f4819c32dc01dcebd14a78eb4e5f124d4e7dd74` ✓ bate; branch `codex/v12-0-0206-planejamento`; só `?? .claude/` untracked (limpo).
- **C4** messages: **172** arquivos (124 tracked / **48 untracked**).
- **C5** results: **196** arquivos (158 tracked / **38 untracked**).
- **C6** logs: **5** arquivos (`.hbn/logs/exec-*.json`, todos de 2026-06-17).
- **C7** state: **1** arquivo (`.hbn/state/hbn-state.json`, runtime).
- Extra: proposals **12**; `.hbn/models/antigravity.json` novo untracked.

---

## Violações do Orquestrador (com severidade)

**[BLOQUEADOR] Orquestrador escreveu código de guard.**
`core/orchestrator-profile-spec.md:115-124` (cl.10) é explícito: "É VEDADO ao
orquestrador: (a) escrever código, guards, src/ ou core spec de terceiros — nada
de implementação." Codex, com `papel: orquestrador-provisorio`
(`.hbn/messages/20260630-211500-...:9`), editou `guards/assert-copy-block.sh` +
`guards/tests/*`. `core/role-cards.md:19` repete: orquestrador "NAO FAZ: Nao
implementa no lugar do implementador." Violação direta e auto-declarada
(`.hbn/readbacks/0115-...json:4-5`: `agent_id: codex`, `implementador_id: codex`).

**[BLOQUEADOR] Implementador e orquestrador na mesma família (OpenAI).**
`orchestrator-profile-spec.md:96-100` (cl.9a): `fornecedor(implementador) ≠
fornecedor(orquestrador)`. Codex acumulou os dois papéis → mesma família nos dois
lados, sem hearback de exceção que eleve o par implementador↔orquestrador. A
própria proposta de Codex previa isso como proibido
(`.hbn/proposals/20260630-201952-...:40,46`: "Nao pode: implementar e auditar o
mesmo patch"; "Codex implementador... exige auditoria por familias nao OpenAI").

**[ALTO] Passo paralelo fora do `proximo_ponto` (W-LEX).**
`orchestrator-profile-spec.md:171-179` (§7/W-LEX a): "a unica acao legal por
turno e executar EXATAMENTE o `proximo_ponto` do STATE; nunca inventar passo
paralelo." O STATE aponta `proxima_acao: PASSO 2 / P2-D`
(`.hbn/relay/STATE.md:14`) — **não** "endurecer G-COPY". A onda 0106–0115 de
guards de orquestrador foi aberta lateralmente ao ponteiro canônico.

**[ALTO] STATE dessincronizado — falha de contexto/handoff.**
O STATE está ~10 readbacks atrás da realidade: `readback_ativo: 0105`
(`STATE.md:228`), `onda_atual: P2-C2 FECHADO ... Proximo: P2-D` (`:5`),
`proprietario_bastao: claude-opus-4-8` / `papel_bastao: orquestrador` (`:7-8`),
`atualizado_por: codex-despromocao-p6-0086` (`:234`),
`ultima_atualizacao: 2026-06-30T14:00:00` (`:233`). Nada disso reflete o
orquestrador-provisório Codex, a suspensão de Opus, nem os readbacks 0106–0115.
O readback 0115 ainda proíbe tocar STATE (`0115-...json:28` em `files_forbidden`),
então a verdade ficou fragmentada em readbacks/proposals/messages em vez do
único STATE canônico. É a raiz da "falha recorrente de transição de contexto"
apontada pelo usuário: quem entra por warm boot lê um STATE que mente sobre o
presente.

**[ALTO] Defeito de portabilidade embutido (consequência da não-segregação).**
`guards/assert-copy-block.sh:178` exige literal `grep -Fq
'/Users/macbookpro/Projetos/'`. Quebra em qualquer outra máquina/CI. É
exatamente o tipo de erro que um implementador independente + auditor pré-commit
pegariam; sem segregação, só foi pego **depois** por Antigravity
(`.hbn/results/20260701-173000-antigravity-...:22-25`).

**[MÉDIO] Coordenação da própria auditoria (padrão F-01).**
`orchestrator-profile-spec.md:34` (cl.2): "Auditoria cruzada, nunca
auto-auditoria." Quem implementou também redigiu e despachou os prompts de
auditoria do próprio patch (`.hbn/messages/20260701-173741/173742-codex-prompt-cross-audit-...`).
Aceitável só como emergência rastreável; aqui ficou sem o rótulo de exceção
`quente/proposed` que a própria Antigravity recomenda (`:110`).

**[MÉDIO] Falhas de handoff/contexto que as knowledges já nomeiam.**
0030 (prompts sequenciais/autocontidos), 0031 (campo único, comandos atômicos),
0032 (saída canônica) descrevem precisamente a classe de falha — porém só a face
de 0032 (G-COPY) é mecânica; 0030 (um bloco por passo; auditor sem alvo falha
fechado) e 0031 (sem cercas ``` internas; comandos atômicos) seguem
**doutrina-sem-enforcement**.

**[BAIXO] Identidade do commit ≠ implementador declarado.**
Autor do commit 0115 = `claude-fable-5 (Cowork)`; readback declara `codex`.
Discrepância de provenance (identidade única do shell), já conhecida como limite
honesto (ADR-023); registrar, não bloquear.

---

## Correções Definitivas (regras mecânicas)

O princípio (proposta Codex §5, `:71-80`): uma falha só é sanada quando vira
**invariante → guard/teste → caso adversarial → auditoria cruzada → gate humano →
linha no ledger**. Orientação textual não basta (o item [MÉDIO] acima prova).

### (Q2) O que deve ser BLOQUEADOR para qualquer novo orquestrador
1. Stagear qualquer path em `guards/**`, `src/**`, `core/**` (spec de terceiro) ou `guards/tests/**` sob chapéu `orquestrador`.
2. `familia(implementador) == familia(orquestrador)` sem `hearback_ref` de exceção explícito.
3. Despacho cujo id-de-onda ≠ `proximo_ponto` vigente do STATE (passo paralelo).
4. Mudança estrutural de STATE sob readback `entregue` sem quórum — **já coberto** por `assert-state-structural.sh` (no runner, linha 108; G-STATE-STRUCTURAL 0106 selado).
5. Selagem sem ≥2 famílias ≠ implementador com `SIM` + gate humano — **já coberto** por `assert-audit-diversity.sh` + `assert-quorum-selagem.sh` (runner 102-103).
6. Despacho quando `readback_ativo`/`onda_atual` do STATE não casa com o readback vivo (STATE stale) → freshness bloqueante.

### (Q3/Q4) Impedir mecanicamente que o orquestrador implemente + separar papéis
**Construir `G-ACTOR-WRITE-MATRIX`** — hoje AUSENTE (confirmado: nenhum guard
`actor/nowrite/write-matrix` em `guards/`; cl.10 diz "a construir na onda S4",
`orchestrator-profile-spec.md:128-131`). É o buraco exato que deixou 0115
acontecer. Desenho:
- Matriz papel→superfície de escrita. `orquestrador` PODE: `.hbn/messages/`,
  `.hbn/proposals/`, `.hbn/results/` (autoria própria), linha no `REGISTRY.md`,
  seu readback. NÃO PODE: `guards/**`, `src/**`, `guards/tests/**`, `core/*-spec.md`
  de terceiros, `.github/**`.
- A quem se aplica: lê `atribuicao.chapeu_atual` do STATE (e o `papel` do readback
  staged), cruza com o diff staged (`git diff --cached --name-only`), bloqueia se
  algum path ∉ superfície do papel. Fail-closed se o papel não for resolvível.
- Anti-burla acoplada: como o guard confia no STATE para saber o papel, o
  orquestrador não pode se auto-reclassificar editando STATE — isso já cai em
  `assert-state-structural.sh` (quórum). Os dois guards se protegem mutuamente.
- Identidade do ator: reusar o bastão já existente (`assert-baton-token.sh`,
  `assert-orq-entrada-ref.sh`, runner 31/97) para amarrar o chapéu à atestação.
- Readback: `implementador_id` DEVE ≠ `orquestrador`; e o campo de família do
  implementador DEVE ≠ família do orquestrador salvo `hearback_ref` presente.
- Gate humano: o rótulo de exceção de emergência (implementador == orquestrador)
  exige `temperatura: quente` + `status: proposed` no REGISTRY e não pode ser
  selado no mesmo turno.

### (Q5) Regra dos 50% de contexto, verificável
Verdade dura: consumo de contexto **não é grep-ável do disco** (auto-reportado;
`orchestrator-profile-spec.md:154` "comportamento não é grep"). Então não meça o
percentual — torne o **handoff** verificável. Peças que já existem:
`handoff_threshold: 0.5` é campo real e schema-validado em todos os perfis
(`.hbn/models/*.json:7`; `schemas/model-profile.schema.json` exige `>0.5` só com
`hearback_ref`), e `assert-report-fresh.sh` já está no runner (linha 112).
Mecanização honesta, em duas camadas:
- **Camada de honestidade (Truth Barrier):** o cabeçalho de toda resposta do
  orquestrador já deve carregar `PAPEL · BASTÃO · CONTEXTO · MODO EDUCACIONAL`
  (cl.8d, `:88-90`). Tornar `CONTEXTO: <pct>%` campo obrigatório e auto-declarado.
- **Camada mecânica (disco):** cada janela de orquestrador mantém um
  state-report com contador de atos de autoridade (despachos) e o `CONTEXTO`
  declarado. Estender `assert-report-fresh.sh`/G-RLT para: (a) bloquear um NOVO
  despacho vindo de uma janela cujo último state-report declarou `CONTEXTO ≥
  handoff_threshold` sem handoff intermediário; (b) cap de N atos de autoridade
  por janela como proxy observável de "janela cheia". Assim o gatilho de 0.5 vira
  um artefato em disco (handoff obrigatório), não uma promessa.

### (Q6) Canal de lições → Credenciamento via membrana, sem teatro
A membrana **já existe**: `install-snapshot.sh --install` instalou e commitou o
snapshot `usehbn@v1-estavel` no Credenciamento (STATE:25, commit `8dcaafa`,
`.usehbn-snapshot` 137+5). Anti-teatro = uma lição só atravessa quando é
**invariante+guard+teste** (proposta Codex §5), nunca um memorando em prosa.
Fluxo canônico, sem duplicar nada:
1. Selar em usehbn a knowledge + guard (ex.: G-COPY endurecido, 0030/0031/0032).
2. Bump de versão do snapshot; `install-snapshot.sh` reinstala no Credenciamento.
3. O runner project-mode do Credenciamento (P2-C, subset bloqueante) passa a
   executar o guard novo automaticamente. Nenhum doc paralelo, nenhum aviso solto.
`knowledge 0030:57-63` já fixa isso: "Quando selada, deve atravessar a membrana
via snapshot para projetos consumidores." O canal é o snapshot, não a prosa.

---

## Respostas às Perguntas de Auditoria

1. **Regras violadas:** cl.10a (orquestrador escreveu guard — BLOQUEADOR), cl.9a
   (mesma família impl↔orq — BLOQUEADOR), W-LEX/§7a (passo paralelo fora do
   `proximo_ponto`), cl.2 (coordenou a própria auditoria), cl.5/§1 (STATE não
   fechou/atualizou a frente — dessincronizado). Detalhe com path:linha acima.
2. **Bloqueadoras para novo orquestrador:** os 6 itens da lista Q2 — sobretudo
   escrita em `guards/**|src/**|core/**|tests`, impl==orq de mesma família, e
   despacho fora do `proximo_ponto`.
3. **Impedir orquestrador de implementar:** `G-ACTOR-WRITE-MATRIX` (matriz
   papel→paths, fail-closed, keyed no `chapeu_atual` do STATE, protegido por
   `assert-state-structural.sh`). Não existe ainda; é a lacuna causal de 0115.
4. **Guard/readback/gate para separar os 3 papéis:** guard =
   G-ACTOR-WRITE-MATRIX; readback = `implementador_id ≠ orquestrador` e família
   distinta salvo hearback; gate = exceção de emergência exige `quente/proposed`
   e não sela no mesmo turno (fecha com quórum ≠ família).
5. **50% verificável:** medir o handoff, não o percentual — `CONTEXTO: %`
   obrigatório no cabeçalho (honestidade) + `assert-report-fresh.sh` estendido
   para bloquear novo despacho após state-report declarar ≥ `handoff_threshold`
   sem handoff, com cap de atos por janela (mecânico). Peças (0.5 no perfil,
   guard no runner) já existem.
6. **Membrana sem teatro:** selar guard+teste em usehbn → bump snapshot →
   `install-snapshot.sh` → runner do Credenciamento executa. Lição vira código,
   não memorando.
7. **Resíduos:** classificar antes de qualquer remoção (ver seção própria); nada
   é apagado sem manifesto+sucessor+gate.
8. **Menor plano seguro:** ver "Plano Mínimo" — fechar saneamento antes de P2-D4.
9. **Destino de 0115:** manter como hotfix provisório (`quente/proposed`),
   suceder por patch de implementador externo não-OpenAI (remove path
   hard-coded + falso-positivo `implementation_plan.md`), selar só com duplo
   `SIM` ≠ OpenAI + gate. Não reverter (reabriria a brecha).

---

## Plano Mínimo para Retomar Credenciamento

Ordem estrita; não pular para P2-D4 antes de fechar (1)–(5).

1. **Registrar este parecer** e o split de veredito. Sem quórum (Antigravity SIM
   × Claude NAO), 0115 **não sela** — permanece `quente/proposed` no REGISTRY.
2. **Reconciliar o STATE** (ato estrutural → passa por `assert-state-structural.sh`
   + quórum): gravar orquestrador-provisório = Codex, Opus suspenso,
   `readback_ativo` → readback de saneamento, `onda_atual` → saneamento-orquestrador,
   `proximo_ponto` → "patch externo de portabilidade do 0115". Sem isso, todo
   warm boot herda contexto falso.
3. **Despachar UM bloco HBN-COPY autocontido** a implementador não-OpenAI
   (Antigravity/Gemini ou Grok): remover o path hard-coded (derivar da raiz do
   repo via `guard_repo_canonical_root`), corrigir o falso-positivo por substring
   de `implementation_plan.md`, adicionar testes. Patch pequeno.
4. **Auditoria dupla ≠ OpenAI** (`SIM`×2) + gate humano → selar o patch sucessor;
   0115 vira `ultrapassado` (superseded_by) no REGISTRY.
5. **Construir `G-ACTOR-WRITE-MATRIX`** (o mecanismo que teria barrado 0115) —
   implementador externo, cross-audit, runner — e só então declarar o saneamento
   de orquestração FECHADO.
6. **Classificar resíduos** por manifesto (versionar/arquivar/ignorar); commitar
   evidência canônica; adicionar ignores. Zero deleção.
7. **Só então retomar P2-D** (router no topo do AGENTS.md + tombstone do espelho
   usehbn/ + untangle), conforme `STATE.md:14`.

---

## Tratamento de Resíduos

Regra-mãe (proposta Codex §6 H0, `:92`; declaração de leitura regra 10): nenhum
conhecimento único é apagado/movido sem manifesto + sucessor + rollback +
auditoria + gate. Durante o saneamento, **APAGAR = conjunto vazio**.

- **VERSIONAR (evidência canônica → commitar):** os 38 results `*-cross-ia-*`
  untracked (incl. a auditoria Antigravity 0115 e esta), e os handoffs/despachos
  em `.hbn/messages/` referenciados pelo REGISTRY. O `.gitignore:13-18` já
  nega-ignora `*-cross-ia-*` e `AAAAMMDD-HHMMSS-*` → são elegíveis. Commitar
  satisfaz G-AUDITOR-ID/G-DIVERSITY (que exigem parecer tracked para selar).
- **ARQUIVAR (frio, fora da read-list):** logs de chat do orquestrador (§4:
  "ARQUIVA não deleta, NUNCA em read-list"), variantes de prompt superadas (pares
  `-antigravity`/`-grok` já consumidos), rodadas antigas de `docs/brainstorm/**`.
  Commitar como `temperatura: frio` ou mover para caminho de arquivo; nunca na
  read-list de entrada.
- **IGNORAR (efêmero por desenho):** `.hbn/readbacks/` (gitignored),
  `.hbn/relay/RETURN.json`, `.hbn/state/hbn-state.json` (runtime),
  `.hbn/logs/exec-*.json` (5, engine), `.venv/`, `.pytest_cache/`. **Correção
  necessária:** `.hbn/logs/` e `.hbn/state/` aparecem como `??` (NÃO cobertos —
  `.gitignore:29-30` usa `logs/*.json`/`state/*.json`, ancorados na raiz, que não
  casam `.hbn/logs/`). Adicionar `/.hbn/logs/` e `/.hbn/state/` ao `.gitignore`
  (ato pequeno, gate humano).
- **APAGAR (lixo real):** apenas scratch de teste já classificado por
  `.gitignore` (`cr-*`, `adv-cr*`, `tmp-pass.*`, `wt-main.*`) — e **não nesta
  janela** (o rito proíbe edição/stage agora). Qualquer deleção futura só após
  manifesto + gate.

---

## Resumo dos Comandos (1–7)

| # | Comando | Resultado |
|---|---|---|
| 1 | rev-parse HEAD (usehbn) | `17ac01b…` ✓ esperado |
| 2 | status -sb (usehbn) | branch sincronizada; muitos untracked |
| 3 | status -sb (Credenciamento) | `0f4819c…` ✓ esperado; só `?? .claude/` |
| 4 | messages -type f | 172 (124 tracked / 48 untracked) |
| 5 | results -type f | 196 (158 tracked / 38 untracked) |
| 6 | logs -type f | 5 (`exec-*.json`) |
| 7 | state -type f | 1 (`hbn-state.json`) |

Guards verificados no runner: `assert-copy-block.sh` (106, G-COPY ativo),
`assert-state-structural.sh` (108), `assert-audit-diversity.sh` (102),
`assert-quorum-selagem.sh` (103), `assert-report-fresh.sh` (112). Ausente:
qualquer `actor-write`/`nowrite` → G-ACTOR-WRITE-MATRIX não construído.

CLAUDE_AUDIT_ORQUESTRADOR_SANEAMENTO_0115: PRONTO
