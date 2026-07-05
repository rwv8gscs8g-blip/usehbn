---
tipo: audit-result
autor: claude-opus
familia: Anthropic
path: .hbn/results/20260701-092612-claude-opus-analise-profunda-guards-orquestrador-0114.md
arvore: fronteira
created_at: "2026-07-01T09:26:12-03:00"
status: congelado
temperatura: glacier
---

SOU: claude-opus · familia Anthropic · papel auditor-arquiteto-read-only
<!-- Linha SOU = primeira linha do prompt de entrada. Sentinela HBN-COPY omitida
     de proposito: este arquivo e audit-result, nao despacho/prompt; nao abrir
     bloco copiavel sem par END dentro de um result. -->

# Analise profunda dos guards do orquestrador — parecer 0114

## Resumo executivo (<=12 linhas)

1. Preflight confirma o contexto: HEAD `f8dbe09…`, indice vazio, `git diff --check` limpo; arvore suja = pacote G-STATE **nao selado** (`guards/assert-state-structural.sh` untracked; runner/tests/REGISTRY modificados).
2. Evidencia de disco: `run-guard-tests.sh` **268/0 verde**; `adversarial-battery.sh` verde e ja cobre G-STATE (B91 repoint-sem-readback, B92 quorum-insuficiente). `pytest` NAO rodou no meu ambiente (`.venv/bin/pytest` exit 127 — interpretador do venv nao resolve no sandbox Linux; limite de ambiente, nao do repo).
3. O bloqueio de **G-SCOPE esta CORRETO**: o readback ativo e o `tail -1` dos readbacks trackeados = **0105** (`assert-scope-lock.sh:41`), e 0105 proibe `guards/**` e `.hbn/results/**` (`0105-…json:27`). Nao ha bug; a barreira funcionou.
4. **BLOQUEADOR nao previsto pelo manifesto 0112**: a selagem adiciona 2 results `*cross-ia*-0106`, mas **nao existe `.hbn/readbacks/0106-*.json`** — logo `G-DIVERSITY` falha fechado por "readback auditado 0106 indeterminavel" (`assert-audit-diversity.sh:243-246`). O manifesto so previu G-SCOPE.
5. **Rito correto** (sem bypass, sem auto-emenda): criar `0106` (feature, implementador=antigravity) + `0113` (selagem `status:vigente`, `seals_proposal:"0106"`, `orq_entrada_ref` = `.hbn/attestations/34a7f2f9-orq-entrada.json`), **nao tocar STATE**, stage seletivo. O escopo de 0113 (que vira ativo por `tail -1`) libera `guards/**`.
6. **Repoint de STATE para 0113 no mesmo commit e inviavel** e nao deve ser tentado: `G-STATE-STRUCTURAL` exigiria `APROVA_0113` (inexistente) (`assert-state-structural.sh:324-390`). Isso confirma a invariante do manifesto (nao alterar STATE nesta selagem). Repoint fica para onda posterior — e mesmo la exige quorum.
7. **REGISTRY**: o diff de worktree adiciona **19** linhas `+|`, **10 no escopo** do manifesto e **9 fora**; nenhum guard barra linha-ledger sem artefato staged (`assert-registry-line.sh` so valida artefato→linha, `:176-189`, nunca o inverso). Hunk seletivo e hoje **so disciplina humana**.
8. **Dependencias de boa-vontade** a reduzir: (a) `scope-lock` deriva o ativo por `tail -1`, nao de `STATE.readback_ativo` (duas fontes de verdade divergiveis); (b) um readback `fast_track` como `tail -1` **neutraliza** o scope-lock (`assert-scope-lock.sh:88-91`).
9. Prioridade: **(A)** rito 0106/0113 → **(C)** G-ORQ-XAUDIT-GATE (0109) → G-ORQ-NO-DELETE → G-ACTOR-WRITE-MATRIX → G-ORQ-FDACK → G-ORQ-TRIPWIRE. Nao emitir prompt de auditoria antes de existir alvo em disco (knowledge 0030).

---

## Loop 1 — Mapa de superficies do orquestrador

Pontos onde o orquestrador exerce autoridade ou pode causar mudanca estrutural:

- **S1 Prompt / despacho** — `.hbn/messages/*.md` (`tipo: despacho|prompt`) e `.hbn/dispatch/*.md`. Ato de autoridade quando `tipo=despacho`.
- **S2 Readback feature** — `.hbn/readbacks/NNNN-<slug>.json` que abre onda/escopo (`scope.files_allowed`).
- **S3 Readback de selagem** — readback `status:vigente` + `seals_proposal` que sela uma proposta.
- **S4 STATE** — `.hbn/relay/STATE.md`, chaves estruturais (`proxima_acao`, `proximo_ponto`, `onda_atual`, `readback_ativo`, `bastao_token_sha256`, `proprietario_bastao`, `papel_bastao`).
- **S5 REGISTRY** — `REGISTRY.md`, ledger append-only (linha de nascimento/temperatura).
- **S6 Results / quorum** — `.hbn/results/*.md` (pareceres; unica fonte de quorum canonico).
- **S7 Atestacao de entrada** — `.hbn/attestations/<fp>-orq-entrada.json` (dereferenciada por `orq_entrada_ref`).
- **S8 Guards** — `guards/**` (o proprio mecanismo; auto-referencia).
- **S9 Zona livre** — `docs/brainstorm/**` (deny-by-default).
- **S10 Staging seletivo** — `git add -p`/index; decide o recorte do commit.
- **S11 Commit / commit-msg / CI** — pre-commit (runner), commit-msg (baton/exception/trailers), range CI (`HBN_DIFF_BASE`).
- **S12 Bastao / token** — `bastao_token_sha256`, `proprietario_bastao`, atestacao same-fp.
- **S13 Efemeros** — `.hbn/relay/RETURN.json` e `inbox/` (gitignored; nunca quorum).
- **S14 Versao ativa** — `.hbn/active-version` / raiz canonica (governa qual arvore os guards leem).

---

## Loop 2 — Invariantes e gates por superficie (guard · arquivo:linha · teste · lacuna)

- **S1 despacho** → `G-COPY` valida 1 bloco `⟦HBN-COPY⟧` e `dest` valido (`assert-copy-block.sh:143-154,117-120`); `G-ORQ-REF` gateia despacho por atestacao (`assert-orq-entrada-ref.sh:257-262,309-326`). **Lacuna:** conteudo do prompt cross-audit (destino canonico, SOU, `APROVA_NNNN`, template, dupla entrega, preflight de alvo) **nao** e verificado → G-ORQ-XAUDIT-GATE.
- **S2 readback feature** → `G-SCOPE` casa staged vs `files_allowed`/`files_forbidden` (`assert-scope-lock.sh:329-353`); `G-REG`/`G-NUM` exigem linha de nascimento (`assert-registry-line.sh:176-189`). **Lacuna:** ativo por `tail -1`, nao por `STATE.readback_ativo` (`:41`); `fast_track` dispensa scope (`:88-91`).
- **S3 selagem** → `G-QUORUM` exige `seals_proposal` != propria e >=2 familias !=OpenAI com `APROVA_NNNN: SIM` (`assert-quorum-selagem.sh:198-208,269-280`); `G-DIVERSITY` valida results `*cross-ia*` (`assert-audit-diversity.sh:214-287`). **Lacuna:** G-QUORUM nao exige que o readback auditado exista; G-DIVERSITY exige (divergencia — ver Achados).
- **S4 STATE** → `G-STATE-STRUCTURAL` exige readback no diff + quorum p/ chaves estruturais (`assert-state-structural.sh:226-256,380-390`); cobre so `A/M` (`:30-36`). **Lacuna:** `D`/rename de STATE nao coberto → G-ORQ-NO-DELETE.
- **S5 REGISTRY** → `G-REG` artefato→linha exata + arvore (`assert-registry-line.sh:126-189`). **Lacuna:** nao ha linha→artefato (linha-ledger sem artefato staged passa) → reverse-G-REG / G-ACTOR-WRITE-MATRIX.
- **S6 results** → lidos por G-QUORUM/G-DIVERSITY/G-STATE com SOU+familia casada ao mapa (`assert-audit-diversity.sh:195-209`; `assert-state-structural.sh:363-384`). **Lacuna:** identidade **nao autenticada** (sem assinatura obrigatoria) → freshness/binding → G-ORQ-FDACK.
- **S7 atestacao** → `G-ORQ-ENTRADA`/`G-ORQ-REF` validam hash de disco e same-fp (`assert-orq-entrada-ref.sh:357-378,457-459`). Cobertura boa.
- **S8 guards** → protegidos so por G-SCOPE (precisa readback que autorize `guards/**`) + gate humano. **Lacuna:** nenhuma matriz papel→path (orquestrador pode, mecanicamente, escrever guard) → G-ACTOR-WRITE-MATRIX.
- **S9 zona livre** → `G-ZONA-LIVRE` deny-by-default lendo `STATE.readback_ativo` + `zona_livre_curada` (`assert-zona-livre.sh:61-68,118-126`). Boa.
- **S10 staging** → nenhum guard "ve" o recorte alem de scope-lock por-arquivo. **Lacuna:** hunk seletivo do REGISTRY nao mecanizado.
- **S11 commit-msg/CI** → `assert-baton-token`/`assert-exception-traceable`/`assert-trailers-contiguous` (runner `--commit-msg`, `hbn-guards-runner.sh:30-52`); CI re-roda no range. **Lacuna estrutural:** `--no-verify` local so e pego por branch-protection+CI (knowledge 0025).
- **S13 RETURN.json** → **gitignored** (`.gitignore:10`); nenhum guard o le p/ quorum (verificado: `grep -rl RETURN.json guards` = vazio). Ja e nao-fonte de quorum; falta so tripwire p/ `git add -f`.

---

## Loop 3 — Bateria adversarial contra o rito do orquestrador (>=20)

Legenda: **B** bloqueia hoje · **P** passa hoje (lacuna) · **?** incerto.

1. Selar G-STATE com 0105 ativo (guards/** staged) — **B** `assert-scope-lock.sh:349`. Teste: existe (cobertura scope).
2. Add results `cross-ia-0106` sem `0106-*.json` — **B** `assert-audit-diversity.sh:243-246`. Teste: **falta** caso "cross-ia com NNNN sem readback"; adicionar.
3. Repoint STATE→0113 na propria selagem — **B** `assert-state-structural.sh:386` (sem APROVA_0113). Teste: B92.
4. Repoint STATE sem readback no diff — **B** `assert-state-structural.sh:254-256`. Teste: B91.
5. Selagem `vigente` com `seals_proposal` = a si mesma — **B** `assert-quorum-selagem.sh:207-208`.
6. Selagem `vigente` com 1 so familia !=OpenAI — **B** `assert-quorum-selagem.sh:275`.
7. RETURN.json como quorum — **B de fato** (nenhum guard le RETURN). Teste: **falta** tripwire p/ RETURN.json forcado.
8. Parecer **so no chat**, sem `.md` em results — **P** (nada exige a entrega em disco). → G-ORQ-XAUDIT-GATE / G-ORQ-FDACK.
9. Prompt cross-audit sem destino canonico / sem SOU / sem `APROVA_NNNN` — **P** (G-COPY so valida o bloco). → G-ORQ-XAUDIT-GATE.
10. Emitir prompt de auditoria **antes de existir alvo** — **P** (sem preflight de alvo). → G-ORQ-XAUDIT-GATE exige preflight fail-closed no texto.
11. Cercas ``` aninhadas no `HBN-COPY` (trunca no chat) — **P** (`assert-copy-block.sh` nao inspeciona cercas). → G-ORQ-CHAT-COPY (knowledge 0031).
12. Comandos agrupados com `&&`/`;` na entrega ao humano — **P**. → G-ORQ-CHAT-COPY.
13. **`fast_track` readback como `tail -1`** carregando `guards/**` — **P** (`assert-scope-lock.sh:88-91` sai 0). FORTE. Teste: **falta**.
14. Readback numerado alto (tail -1) com `files_allowed` amplo, divergente de `STATE.readback_ativo` — **P** (scope usa tail -1). FORTE. Teste: **falta**.
15. Stage do **REGISTRY inteiro** com 9 linhas fora-de-escopo — **P** (scope-lock ok; G-REG so forward). FORTE. Teste: **falta** (reverse-G-REG).
16. `git rm`/mover `STATE.md` (apagar estado) — **P** (`assert-state-structural.sh:30-36` so `A/M`). → G-ORQ-NO-DELETE.
17. Deletar readback/result/atestacao (apagar prova de quorum) — **P** (sem guard geral de delete). → G-ORQ-NO-DELETE.
18. Orquestrador escreve `guards/**` ele proprio (nao o implementador) — **P** mecanicamente (papel nao e checado por path); VEDADO por `orchestrator-profile-spec.md:120-131`. → G-ACTOR-WRITE-MATRIX.
19. Orquestrador forja result de auditor com apelido alheio (ex.: "grok/xAI") — **?** passa se front-matter+SOU casarem o mapa (`assert-audit-diversity.sh:201-209`); identidade nao e autenticada. FORTE. Teste: assinatura (G-HRB/SSH) opcional; provar com fixture sem chave.
20. `git commit --no-verify` na selagem — **P** local (bypassa tudo); so CI-range/branch-protection pega (knowledge 0025). Estrutural: exige CI.
21. `[bypass-hbn-guards]` + nota em `.hbn/bypasses/` — **?** legitimo p/ emergencia (`guard_check_bypass`); risco se abusado sem gate humano.
22. Inflar `files_allowed` do readback ativo no mesmo commit — **B** `assert-scope-lock.sh:296-326` (exige `scope_extension` isolado com human/evidence/allowed_delta).
23. Symlink em path governado na selagem — **B** `assert-scope-lock.sh:337` (B18/B19).
24. Smuggling de meta-path (payload arbitrario como hearback/message) — **B** `assert-scope-lock.sh:238-252` (B17: tipo+nome).
25. Selagem sem atestacao `orq_entrada` vigente — **B** `assert-orq-entrada-ref.sh:309-311,457-459`.
26. Empilhar dois "proposed" (abrir 0109 antes de selar G-STATE) — **P** mecanicamente; doutrina §2.5 e o proprio manifesto pedem nao empilhar. Comportamental → candidato a sinal, nao guard.

Cobertura: dos 26, **hoje bloqueiam 11**, **passam ~12**, **incertos 3**. As 5 lacunas de maior impacto (7,15,16,17,18) mapeiam 1:1 nos guards propostos.

---

## Loop 4 — Sequenciamento minimo e seguro

### 4.1 Como destravar G-SCOPE sem bypass e sem auto-emenda (rito 0106/0113)

A barreira G-SCOPE esta certa; a correcao **nao** e mexer no guard, e **introduzir um readback ativo com escopo que autorize a selagem** — isto e um readback novo, nao uma emenda de 0105 (portanto **nao** aciona a maquinaria de `scope_extension`). Passos:

1. Criar `.hbn/readbacks/0106-g-state-structural.json` (**feature**; `implementador_id:"antigravity"`; `track:"safe_track"`; `status:"entregue"`; `scope.files_allowed` = os 4 arquivos do patch G-STATE). Isto regulariza a **provenance faltante** que hoje quebra G-DIVERSITY.
2. Criar `.hbn/readbacks/0113-selagem-g-state.json` (**selagem**; `status:"vigente"`; `seals_proposal:"0106"`; `human_status:"confirmed"`; `orq_entrada_ref:".hbn/attestations/34a7f2f9-orq-entrada.json"`; `files_forbidden` **sem** `guards/**`; `files_allowed` = pacote completo abaixo).
3. `files_allowed` de 0113 (exato): os 2 readbacks (0106, 0113) · `guards/assert-state-structural.sh` · `guards/hbn-guards-runner.sh` · `guards/tests/run-guard-tests.sh` · `guards/tests/adversarial-battery.sh` · `.hbn/knowledge/0030-*.md` · `.hbn/knowledge/0031-*.md` · `.hbn/knowledge/INDEX.md` · os 2 prompts `*-0106-*-v2.md` · os 2 results `*cross-ia*-0106-v2.md` · `REGISTRY.md` · o manifesto `…-0112.md`.
4. Stage seletivo; **nao** tocar `STATE.md`, `RETURN.json`, `.hbn/logs/**`, `.hbn/state/**`, `.hbn/models/**`, `docs/brainstorm/**`, `guards/tests/hbn-repro-*`.
5. Rodar runner + suite + bateria; commit no gate humano.

Por que passa: `tail -1` = 0113 → scope governado por 0113 (libera `guards/**`); G-QUORUM ve 0113/`seals_proposal=0106` e acha `APROVA_0106: SIM` de xAI+Anthropic (`assert-quorum-selagem.sh:269-280`); G-DIVERSITY resolve `0106` (agora existe) com implementador Google e 2 familias distintas !=Google (`assert-audit-diversity.sh:280-283`); G-STATE nao opina (STATE intocado); G-ORQ-REF valida a atestacao `34a7f2f9` (ja verde no disco).

### 4.2 Respostas aos pontos especificos

- **Readback 0113 + repoint de STATE e rito aceitavel em uma etapa?** **NAO.** Sao duas etapas. Repointar chave estrutural exige quorem do numero apontado; a selagem 0113 nao tem `APROVA_0113`. Selagem primeiro (sem STATE); repoint depois, em onda propria.
- **O manifesto 0112 precisa de readback proprio antes da selagem?** **SIM**, e de **dois**: 0106 (feature, ausente hoje — BLOQUEADOR) e 0113 (selagem). O manifesto so listou G-SCOPE; sem 0106 a selagem cai em G-DIVERSITY. Amende tambem a lista de hunks do REGISTRY para incluir as linhas de nascimento de 0106 e 0113.
- **G-STATE deve bloquear delete/move de STATE?** **Nao** — deve ficar em **G-ORQ-NO-DELETE**. G-STATE opera sobre conteudo estrutural do blob `A/M` (`:30-36`); misturar delete alargaria seu escopo e o acoplaria a `git status` de path. Separacao limpa.
- **Como impedir prompt cross-audit sem destino/SOU/APROVA/dupla entrega?** G-ORQ-XAUDIT-GATE (Loop 5.1): grep fail-closed no `.md` do prompt exigindo destino canonico, template de front-matter, `SOU:`, `APROVA_NNNN:` e a instrucao de dupla entrega (chat integral + `.md`).
- **Como impedir auditoria prematura (sem alvo)?** O guard exige que o **texto** do prompt contenha um **preflight fail-closed** que nomeie o artefato-alvo e mande o auditor emitir `APROVA_NNNN: NAO` se o alvo nao existir (knowledge 0030). Mecaniza o prompt; a sequencia humana (um bloco por vez) continua comportamental.
- **REGISTRY com linhas de multiplas classes + hunk seletivo?** Hoje sem enforcement (verificado: 19 add, 10 no escopo, 9 fora). Curto prazo: `git add -p`/`git add -e` por hunk + revisao humana. Estrutural: reverse-G-REG (toda linha de REGISTRY **adicionada** no diff deve referenciar um path **staged no mesmo commit**), dobravel em G-ACTOR-WRITE-MATRIX.
- **RETURN.json / chat solto como quorum?** Ja excluidos por construcao: quorum le so `.hbn/results/*.md` com front-matter+SOU+`APROVA`. Endurecer com G-ORQ-TRIPWIRE (bloquear `RETURN.json`/`inbox/` forcados no index).
- **Reduzir dependencia de boa-vontade do orquestrador?** Tres alavancas: (a) reverse-G-REG (ledger honesto); (b) G-ACTOR-WRITE-MATRIX (papel→path); (c) reconciliar as duas fontes de "ativo" (`tail -1` vs `STATE.readback_ativo`) e proibir `fast_track` para commits que toquem `guards/**`/`core/**`.

### 4.3 Ordem das ondas

Onda A = rito 0106/0113 (destrava e sela G-STATE). Onda B (opcional) = repoint de STATE pos-selagem, com readback proprio + cross-audit se mudar chave estrutural. Onda C = G-ORQ-XAUDIT-GATE (0109). Onda D = G-ORQ-NO-DELETE. Onda E = G-ACTOR-WRITE-MATRIX (inclui reverse-G-REG). Onda F = G-ORQ-FDACK. Onda G = G-ORQ-TRIPWIRE.

---

## Loop 5 — Especificacao dos guards futuros

### 5.1 G-ORQ-XAUDIT-GATE (`guards/assert-orq-xaudit-gate.sh`)
- **Objetivo:** todo prompt cross-audit novo carrega contrato de entrega canonico e preflight fail-closed. Mecaniza knowledge 0030/0031 e o plano 0107.
- **Arquivos:** o guard; `hbn-guards-runner.sh`; `tests/run-guard-tests.sh`; `tests/adversarial-battery.sh`; `REGISTRY.md`; readback `0109-*.json`; handoff do implementador.
- **Entradas/saidas:** le blobs **added** em `.hbn/messages/*.md` e `docs/prompts/*.md` (`:path` local / `HEAD:` CI) com `tipo` prompt/despacho contendo `cross-audit`/`cross-ia`; saida exit 0/1 + motivo.
- **Fail-closed:** bloqueia se faltar qualquer um: destino `.hbn/results/AAAAMMDD-HHMMSS-<apelido>-cross-ia-<tema>-NNNN.md`; template com `tipo: audit-result`,`autor`,`familia`,`path`,`id-global`,`arvore`,`created_at`; linha `SOU: <apelido> · familia <familia> · papel auditor`; linha `APROVA_NNNN:`; instrucao de dupla entrega (chat integral + `.md` identico); preflight fail-closed nomeando o alvo. Sem `python3`/mapa → exit 2.
- **FP aceitaveis:** despacho de implementacao (nao-auditoria) marcado como cross-audit por engano e barrado (custo: renomear tema). Prompt legado (pre-guard, ja trackeado) nao e reavaliado (so `added`).
- **FN inaceitaveis:** prompt que peca parecer so no chat; sem `APROVA_NNNN`; com `NNNN` divergente do tema; com cerca ``` dentro do `HBN-COPY`.
- **Testes +:** prompt v2 completo (grok/claude 0106) passa. **Testes -:** faltando destino; faltando SOU; faltando APROVA; NNNN divergente; auditoria so-chat; cerca aninhada.
- **Runner:** apos `assert-copy-block.sh` (`hbn-guards-runner.sh:106`), reusando a validacao de bloco. **Deadlock:** baixo; escopo disjunto (le texto de prompt). Cuidar so para nao reprovar os proprios prompts de selagem (que nao sao cross-audit) — filtrar por marcador de tema.

### 5.2 G-ORQ-NO-DELETE (`guards/assert-orq-no-delete.sh`)
- **Objetivo:** proteger delete/rename de artefatos criticos (STATE, readbacks, results, attestations, REGISTRY) contra apagamento de estado/prova.
- **Arquivos:** o guard + runner + suites + REGISTRY + readback.
- **Entradas/saidas:** `git diff --diff-filter=DR` (local index / range CI) filtrado para os paths criticos.
- **Fail-closed:** qualquer `D`/`R` de `.hbn/relay/STATE.md`, `.hbn/readbacks/**`, `.hbn/results/**`, `.hbn/attestations/**`, `REGISTRY.md` bloqueia, salvo readback ativo com `authorized_deletes:[…]` humano-curado (espelha `scope_extension`).
- **FP aceitaveis:** faxina legitima exige onda dedicada humano-gated (por design — knowledge 0024).
- **FN inaceitaveis:** `git rm STATE.md`; rename de readback selado; delecao de result de quorum.
- **Testes +:** commit sem deletes passa; delete autorizado por readback passa. **Testes -:** delete de STATE; rename de result; delete de attestation.
- **Runner:** perto de `assert-state-structural.sh`. **Deadlock:** baixo; complementa G-STATE (cobre `D/R`, G-STATE cobre `A/M`).

### 5.3 G-ACTOR-WRITE-MATRIX (`guards/assert-actor-write-matrix.sh`)
- **Objetivo:** matriz papel→paths (reformula o antigo "G-ORQ-NOWRITE", `orchestrator-profile-spec.md:129`). Orquestrador nao escreve `guards/**`,`src/**`,`core/**` de terceiros nem result de auditor; **inclui reverse-G-REG**: toda linha de REGISTRY adicionada referencia path staged no mesmo commit.
- **Arquivos:** o guard + `guards/data/actor-write-matrix.txt` (novo, curado por humano) + runner + suites + REGISTRY + readback.
- **Entradas/saidas:** papel do ato lido do readback ativo/despacho; paths staged; linhas `+|` do REGISTRY vs set staged.
- **Fail-closed:** ato de papel `orquestrador` que stageia `guards/**`/`src/**`/`core/**` bloqueia (salvo readback co-assinado por implementador de outra familia); linha de ledger sem artefato staged bloqueia.
- **FP aceitaveis:** o orquestrador que precisar tocar guard delega ao implementador (custo: um micro-despacho — e o design).
- **FN inaceitaveis:** orquestrador comita guard sozinho; REGISTRY inteiro com 9 linhas fora-de-escopo (o caso medido nesta selagem).
- **Testes +:** selagem 0113 com REGISTRY hunk-limitado passa. **Testes -:** REGISTRY com linha orfa (sem artefato); orquestrador stageia `guards/x.sh` sem co-assinatura.
- **Runner:** apos `assert-registry-line.sh` (`:99`). **Deadlock:** MEDIO — precisa de fonte confiavel de "papel do ato"; comecar pela metade barata (reverse-G-REG) e so depois a matriz papel→path.

### 5.4 G-ORQ-FDACK (freshness/disk-ack) (`guards/assert-orq-fdack.sh`)
- **Objetivo:** ligar o parecer ao conteudo **exato** auditado (limite conhecido do manifesto, `…-0112.md:171-172`): evita parecer "fresco" ratificando patch que mudou depois.
- **Arquivos:** o guard + spec de result (campo novo `audited_sha256`/`audited_blob`) + runner + suites + REGISTRY + readback.
- **Entradas/saidas:** para cada result de quorum, le `audited_sha256` do front-matter e compara com `git hash-object` do blob do alvo staged.
- **Fail-closed:** result cujo `audited_sha256` nao casa o blob atual do alvo **nao conta** para quorum (equivale a parecer ausente).
- **FP aceitaveis:** reformatacao inocua do alvo invalida o parecer e exige re-auditoria (conservador de proposito).
- **FN inaceitaveis:** patch alterado apos APROVA; parecer reciclado de outra versao (v1→v2).
- **Testes +:** result com sha casando passa. **Testes -:** alvo modificado 1 byte apos APROVA; sha ausente; sha de outro blob.
- **Runner:** logico como pre-condicao de G-QUORUM/G-DIVERSITY/G-STATE (as tres passam a exigir freshness). **Deadlock:** MEDIO-ALTO — exige campo novo no formato de result; introduzir como **aviso** por 1 onda antes de bloquear, senao trava pareceres legados.

### 5.5 G-ORQ-TRIPWIRE (`guards/assert-orq-tripwire.sh`)
- **Objetivo:** fio-de-alarme barato para efemeros/lixo que nunca devem entrar no index: `RETURN.json`, `.hbn/relay/inbox/**`, `.hbn/logs/**`, `guards/tests/hbn-repro-*`, `*.bak`.
- **Arquivos:** o guard + runner + suites + REGISTRY + readback.
- **Entradas/saidas:** set staged; match contra denylist de efemeros.
- **Fail-closed:** qualquer efemero staged (mesmo via `git add -f`, que fura o `.gitignore`) bloqueia.
- **FP aceitaveis:** nenhum relevante (efemeros nunca sao commit legitimo).
- **FN inaceitaveis:** `RETURN.json` versionado; `hbn-repro-*` vazando na arvore (ja ha 3 no worktree).
- **Testes +:** commit limpo passa. **Testes -:** `git add -f RETURN.json`; `git add guards/tests/hbn-repro-xxx/`.
- **Runner:** cedo (perto de `forbid-tmp-worktree.sh`, `:85`). **Deadlock:** nenhum; guard puro de denylist.

---

## Loop 6 — Plano de implementacao para Codex (micro-despachos, um por onda)

Principio (knowledge 0030): **um bloco por passo**; auditoria so depois de alvo em disco. Nao emitir prompt de auditoria antes de existir o guard.

**MD-A (rito de selagem G-STATE) — implementador: antigravity/Google.**
- Escopo: criar `0106-g-state-structural.json` e `0113-selagem-g-state.json`; appendar linhas de nascimento de 0106/0113 no REGISTRY; stage seletivo do pacote; runner+suite+bateria; parar no gate humano.
- files_allowed: os 2 readbacks + os 4 guards do patch + `.hbn/knowledge/0030-*`,`0031-*`,`INDEX.md` + os 2 prompts `*-0106-*-v2.md` + os 2 results `*cross-ia*-0106-v2.md` + `REGISTRY.md` + `…-0112.md`.
- files_forbidden: `.hbn/relay/STATE.md`, `.hbn/results/**` fora dos 2 v2, `docs/brainstorm/**`, `.hbn/logs/**`, `.hbn/state/**`, `.hbn/models/**`, `guards/tests/hbn-repro-*`, `.hbn/relay/RETURN.json`, repo Credenciamento.
- Testes: `git diff --check`; `bash guards/hbn-guards-runner.sh`; `run-guard-tests.sh`; `adversarial-battery.sh`; `pytest -q` se venv ok.
- Pronto: 4 comandos verdes + indice contendo **exatamente** o pacote; STATE intocado. Rollback: nao stagear; pos-commit `git revert`.

**MD-B (opcional, repoint STATE) — so apos MD-A selado.** Escopo minimo: onda de repoint com readback proprio; se mudar chave estrutural, anexar quorum. Nao combinar com a selagem.

**MD-C (G-ORQ-XAUDIT-GATE / 0109) — implementador: antigravity.** files_allowed: `guards/assert-orq-xaudit-gate.sh`,`hbn-guards-runner.sh`,`tests/run-guard-tests.sh`,`tests/adversarial-battery.sh`,`REGISTRY.md`,`.hbn/readbacks/0109-*.json`, handoff. files_forbidden: `STATE.md`,`.hbn/results/**`,`assert-state-structural.sh`,`core/**`,`src/**`. Pronto: casos +/- (Loop 5.1) na suite; runner verde. Rollback: tag `pre-0109`. **Auditoria (emitir SO depois do handoff em disco):** grok/xAI + claude/Anthropic.

**MD-D (G-ORQ-NO-DELETE).** Analogo; auditar apos alvo. **MD-E (G-ACTOR-WRITE-MATRIX + reverse-G-REG).** Comecar pela metade barata (reverse-G-REG). **MD-F (G-ORQ-FDACK).** Introduzir como aviso 1 onda antes de bloquear. **MD-G (G-ORQ-TRIPWIRE).** Denylist pura.

---

## Achados priorizados

**BLOQUEADOR**
- **A1** Selagem conforme manifesto 0112 (adiciona 2 results `cross-ia-0106`) e barrada por **G-DIVERSITY** porque **nao existe `.hbn/readbacks/0106-*.json`** (`assert-audit-diversity.sh:243-246`; disco: `ls .hbn/readbacks | grep 0106` = vazio). Correcao: criar 0106 (MD-A). Sem isso, a selagem falha mesmo depois de resolver G-SCOPE.
- **A2** Manifesto 0112 sem readback de selagem proprio (0113) e sem as linhas de nascimento de 0106/0113 no hunk do REGISTRY. Precisa revisao antes da Fase 2.

**FORTE**
- **F1** `scope-lock` deriva o readback ativo por `tail -1` (`assert-scope-lock.sh:41`), divergente de `STATE.readback_ativo` (`STATE.md:228`). Duas fontes de verdade; um readback alto e permissivo silenciosamente governa.
- **F2** `fast_track` como `tail -1` **desliga** o scope-lock (`assert-scope-lock.sh:88-91`): vetor de bypass sem `--no-verify`.
- **F3** REGISTRY: nenhuma checagem linha→artefato; medido 9/19 linhas fora-de-escopo passariam (scope-lock ok; `assert-registry-line.sh` so faz artefato→linha, `:176-189`).
- **F4** Delete/rename de STATE/readback/result/attestation nao coberto (`assert-state-structural.sh:30-36` so `A/M`) — apagar prova de quorum passa.
- **F5** Identidade de auditor nao autenticada: SOU+familia casam o mapa por texto (`assert-audit-diversity.sh:201-209`), sem assinatura obrigatoria — forja possivel.

**MARGINAL**
- **M1** Prompt cross-audit sem contrato canonico passa (G-COPY so valida o bloco) — resolvido por G-ORQ-XAUDIT-GATE.
- **M2** `RETURN.json` forcavel via `git add -f` (gitignore nao e enforcement) — G-ORQ-TRIPWIRE.
- **M3** Freshness do parecer nao mecanizada (`…-0112.md:171`) — G-ORQ-FDACK (introduzir como aviso).
- **M4** `pytest` nao verificavel neste ambiente (venv exit 127); confiar na suite bash 268/0 ate rodar `pytest` no Terminal do operador.

---

## Sequencia recomendada

1. **Onda A — rito 0106/0113** (MD-A): destrava G-SCOPE via readback novo + regulariza 0106; sela G-STATE sem tocar STATE. Fecha A1/A2.
2. **Onda B — repoint STATE** (opcional, MD-B): so apos A; readback proprio; nunca combinada.
3. **Onda C — G-ORQ-XAUDIT-GATE / 0109** (MD-C): fecha M1; base para prompts confiaveis.
4. **Onda D — G-ORQ-NO-DELETE** (MD-D): fecha F4.
5. **Onda E — G-ACTOR-WRITE-MATRIX + reverse-G-REG** (MD-E): fecha F3 e reduz F-boa-vontade; comecar pela metade barata.
6. **Onda F — G-ORQ-FDACK** (MD-F): fecha M3/F5-parcial; aviso→bloqueio.
7. **Onda G — G-ORQ-TRIPWIRE** (MD-G): fecha M2.
8. **Transversal — reconciliar "ativo"**: em C ou E, ligar scope-lock a `STATE.readback_ativo` e proibir `fast_track` tocando `guards/**`/`core/**`. Fecha F1/F2.

---

## Micro-despachos para Codex (esqueletos, knowledge 0031: campo unico, comandos atomicos)

MD-A e o unico pronto para emitir agora (o alvo existe). Os demais so apos o alvo em disco.

MD-A — cabecalho: `CHAT NOVO, SEM MEMORIA · SOU: antigravity · familia Google · papel implementador · repo /Users/macbookpro/Projetos/usehbn · HEAD f8dbe09`.
- PREFLIGHT (um por vez): COMANDO 1: `git -C . rev-parse HEAD`; COMANDO 2: `git -C . status --short`; COMANDO 3: `test ! -e .hbn/readbacks/0106-g-state-structural.json && echo OK-CRIAR`.
- ACAO: criar os 2 readbacks (campos do Loop 4.1); appendar 2 linhas no REGISTRY (0106,0113) com arvore `fronteira`; `git add` **apenas** o pacote do Loop 4.1; rodar os 4 testes um a um; PARAR no gate humano `APROVO SELAGEM CONTROLADA DE G-STATE CONFORME MANIFESTO 0112` (revisado p/ 0106+0113).
- files_allowed / files_forbidden: ver MD-A no Loop 6.
- PRONTO: `git diff --cached --name-only` = exatamente o pacote; runner+suite+bateria exit 0; STATE fora do indice.
- ROLLBACK: antes do commit, `git restore --staged .`; depois, `git revert <sha>`.
- VEREDITO ESPERADO (auditores, onda posterior): `APROVA_0113: SIM|NAO`.

---

## O que nao fazer

- **Nao** editar nenhum guard para "encaixar" a selagem — a barreira G-SCOPE esta correta; corrige-se com readback, nao com patch de guard.
- **Nao** repointar `STATE.md` na selagem (G-STATE exigiria `APROVA_0113` inexistente; `assert-state-structural.sh:386`).
- **Nao** `git add REGISTRY.md` inteiro — 9 das 19 linhas estao fora do escopo; use `git add -p`/`-e`.
- **Nao** `git add -A`, **nao** `--no-verify`, **nao** stagear `RETURN.json`/`.hbn/logs/**`/`hbn-repro-*`.
- **Nao** emitir prompts de auditoria para C-G antes do handoff do implementador existir em disco (knowledge 0030); **nao** enviar fila implementacao+auditoria+selagem no mesmo turno.
- **Nao** tratar chat solto, `RETURN.json`, prompt v1 ou result v1 como quorum (knowledge 0031; manifesto `…-0112.md:106-109,175`).
- **Nao** usar `fast_track` para carregar `guards/**` enquanto F2 nao for fechado.
- **Nao** apagar residuos/zona livre "para limpar a arvore" sem onda de curadoria humana (knowledge 0024).

ANALISE_0114_CONCLUIDA: SIM
