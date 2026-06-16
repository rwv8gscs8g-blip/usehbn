---
aprova_proposta: "SIM + ajustes objetivos (incluindo via mais simples para Q5/EXTRA)"
titulo: "Parecer Grok — Auditoria Cruzada (família xAI) da Proposta de Árvores Leve + Fechamento MVP"
tipo: result
status: active
temperatura: frio
id-global: 20260616-184500-grok-cross-ia-proposta-arvores-mvp
path: .hbn/results/20260616-184500-grok-cross-ia-proposta-arvores-mvp.md
auditor: grok (xAI) — janela distinta, sem bastão, sem memória de conversa com orquestrador além do que está no disco
reviewed_at: "2026-06-16T18:45:00-03:00"
confianca_geral: 80/100
---

APROVA_PROPOSTA: SIM + ajustes objetivos (ver recomendações por pergunta; em especial Q5/EXTRA propõe caminho radical com menos peças para fechar o MVP)

# Parecer Grok — Cross-Audit Proposta Árvores (leve) + MVP Freeze
**Auditor:** grok (xAI) — família distinta (Truth Barrier: verifiquei tudo no disco via ferramentas de leitura; não confiei no relato do orquestrador nem no parecer antigravity anterior; re-executei buscas, reads e comandos)
**Data:** 2026-06-16T18:45:00-03:00 (aprox; sistema local)
**Branch sob auditoria (somente leitura):** proposta/reestruturacao-m-a-s0 @ tip 2d4ad86 (git rev-parse HEAD: 2d4ad86 (HEAD -> proposta/reestruturacao-m-a-s0) p-cand-04: atualiza state e handoff)
**Main tip verificado:** 4db692876381a0d7909985c8500d999f2e677b04 (git rev-parse main) — docs: emenda plano hbn-exuvia v2
**Contexto selado verificado (STATE + readbacks + log):**
- git log --oneline -5 (no branch): 2d4ad86 p-cand-04..., fa86b6a p-cand-04..., 428b30f p-cand-04..., c4af7bf p-cand-04: abre readback 0033, ae5f4c4 selagem-s3-2...
- .hbn/relay/STATE.md:4: "protocolo: \"HBN 0.3.0 (modelo versão=pasta; M-A scaffold inativo; B19/S2/faxina 0027/S3.1/S3.2 selados; P-CAND-04 entregue)\""
- .hbn/relay/STATE.md:5: "onda_atual: \"P-CAND-04 ENTREGUE...\""
- .hbn/relay/STATE.md:52: readback_ativo: ".hbn/readbacks/0033-area-temporaria-scratch.json"
- .hbn/readbacks/0033-area-temporaria-scratch.json:2: "readback_id": "0033-area-temporaria-scratch" (165/165 tests, B26-B28 cobertos, 3 guards scratch no runner; out_of_scope explícito: "Bloqueio total deny-by-default da zona livre (proxima onda)")
- Ondas seladas confirmadas via STATE.md:51- (sinais): S1 (scope-lock), B17/B18/B19 (meta-path/symlink), S2 (dispatch), faxina 0027, S3.1 (INDEX knowledge), S3.2 (role-cards + G-FRONTDOOR), P-CAND-04.
- .hbn/readbacks/0032-selagem-s3-2.json:11 confirma selagem S3.2 com cross Cursor/Gemini APROVA_0031: SIM.
- Ponte vetada explícita: STATE.md:45: "🔴 PONTE VETADA — 0034 Codex e 0035 Antigravity retornaram VETO_ADOCAO: SIM; corrigir bloqueadores antes de descongelar."
- .hbn/knowledge/0024-... (zona livre): criado em contexto de selagem S3.2; regra: orquestrador/IA NÃO comita docs/brainstorm/** sem listagem explícita + aceno humano por arquivo; "Só um gate enforçado (guard que falha fechado) vincula."

Todos os julgamentos abaixo citam arquivo:linha ou `comando | saída` (verificados com Read/Glob/Grep/Shell no disco; branch atual, sem checkout, sem add, sem commit, sem alterar índice).

## Respostas às 6 Perguntas da Parte 4

### 1. Árvores: campo obrigatório em quais paths? guards .sh entram via header-comment ou ficam fora do escopo leve?

**Evidência no disco:**
- Proposta (`.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:44`): "Artefato staged NOVO sob `core/**` ou `docs/brainstorm/**` DEVE declarar `arvore:` — senão BLOQUEIA." + "docs/brainstorm/** que não declarar assume `fronteira` por padrão documentado."
- Core specs usam front-matter YAML padrão (ex: `core/relay-spec.md:1-11` começa com `---\ntitulo: ... status: accepted...`); `core/role-cards.md:1` NÃO tem front-matter (começa direto com `# Porta Da Frente...` — é artefato normativo em core/ mas sem FM).
- Guards/README.md:1-9 TEM front-matter; guards/hbn-guards-runner.sh:49-71 tem lista HARDCODED `GUARDS=( "assert-..." ... )` — NENHUM parsing de arvore hoje.
- Busca `arvore:|árvore:` (Grep): aparece SOMENTE em brainstorm drafts (docs/brainstorm/PROPOSTA-arvores-agora.md, PROMPTS-PF-ARVORES-AGORA-DRAFT.md), na proposta em si, e no parecer antigravity anterior. Zero em artefatos committed do canônico ou guards/.sh. Confirma "não implementado".
- `.hbn/readbacks/0032-selagem-s3-2.json:23-25`: selagem S3.2 explicitamente incluiu 3 arquivos de `docs/brainstorm/**` no files_allowed (com autorização humana listada), para "versionar" — exatamente o caso que gerou knowledge 0024.
- `.hbn/readbacks/0033-....json:61-62`: out_of_scope inclui "Bloqueio total deny-by-default da zona livre (proxima onda)."

**Julgamento + citação:**
- Paths obrigatórios: além de `core/**` (mas note que nem todo core/ tem FM hoje — role-cards é contra-exemplo) e `docs/brainstorm/**`, o campo (ou equivalente) deve cobrir pelo menos: `schemas/**`, `guards/*.sh` (ativos no runner), `.hbn/knowledge/**` (normativos, indexados), `methodology/**`, `core/role-cards.md` e docs normativos fora brainstorm (ex: se existirem em docs/ não-brainstorm). Proposta é estreita demais; risk de "fronteira bleed" em specs de schemas/guards que são runtime-critical.
- Guards .sh: DEVEM entrar no escopo leve (são o enforcement do MVP; runner os carrega em produção). Como não têm YAML front-matter, usar header-comment padronizado no topo: `# arvore: estavel` (ou intermediaria/fronteira). 
  - Runner (`guards/hbn-guards-runner.sh:74-84`) deve, ANTES de executar cada g, checar se o script listado contém `# arvore: fronteira` (ou valor inválido) → abortar o pre-commit. Guard experimental não pode estar ativo no pipeline do MVP.
  - Alternativa radical (ver Q5): não etiquetar .sh individualmente; a edição da lista GUARDS=() no runner (que é ele próprio um artefato governado) + a onda que aprova o commit do runner implicitamente promove o guard. Menos peças.
- Citação Truth: `guards/hbn-guards-runner.sh:60` (assert-self-path.sh está na lista; seu parser awk é usado por outros guards); `guards/assert-self-path.sh:63`: `awk 'NR==1 && $0!="---"{exit} NR>1 && $0=="---"{exit} NR>1{print}' | grep -E '^path:' ...` (parser frágil idêntico em assert-pointer-honest.sh:52 etc.).
- Recomendação: expander escopo obrigatório para "todo artefato que pode afetar enforcement ou specs do genoma MVP (core/** + schemas/** + guards/** + .hbn/knowledge/** não-brainstorm + docs/ não-brainstorm que são porta da frente)". Para .sh: header # arvore: + validação no runner. (Ou caminho registry-centric abaixo.)

### 2. Transição entre árvores (fronteira->intermediaria->estavel): gate bem definido? falta critério objetivo (reuso dos 8 critérios de exúvia)?

**Evidência:**
- Proposta:44: "promoção entre árvores só por onda com gate (fronteira→intermediaria→estavel exige cross-audit + aprovação humana)".
- `core/exuvia-fitness-criteria.md:75-87` (lido): define os 8 critérios mensuráveis:
  | C-TEST | C-ADV | C-XAUDIT | C-DOG | C-FCLOSE | C-NOREG | C-TRACE | C-DEBT |
  Medição: "grep do caso em guards/tests/...; suíte verde", "dois .hbn/results/* com APROVA_*: SIM, famílias ≠", "artefato do próprio mecanismo passa o próprio guard", "fail-closed: falta de insumo BLOQUEIA", etc.
- `core/exuvia-fitness-criteria.md:98-109`: placar retroativo mostra S1/B17/B18/B19/S2 com "SOBREVIVE" usando exatamente esses critérios + readback refs (rb0017 etc).
- `.hbn/relay/STATE.md:102` (sinais): lista C-XAUDIT de famílias distintas (Gem+Cur), C-TEST 165/165 etc para as ondas recentes.
- Proposta não menciona os 8 critérios nem propõe arvores-spec.md com mapeamento (o arquivo core/arvores-spec.md ainda não existe no disco — `find core -name '*arvore*' | cat` retorna vazio).

**Julgamento + citação:**
- Gate alto-nível ("cross-audit + aprovação humana") está "definido" na proposta, mas subjetivo e sem checklist objetivo — risco de "teatro de conformidade" (mesmo problema que antigravity flagrou).
- Falta reuso explícito dos 8 critérios: para **intermediaria → estavel** (entra no genoma/MVP) exigir placar completo C-TEST a C-TRACE = SIM + C-DEBT registrada (exatamente como a regra de sobrevivência em exuvia-fitness-criteria.md:90: "SOBREVIVE ao molt se e somente se C-TEST a C-TRACE = SIM (os sete são obrigatórios) e C-DEBT..."). Para fronteira → intermediaria: gate mais leve (proposta escrita + dispatch humano + testes básicos + 1 cross-audit).
- Citação: `core/exuvia-fitness-criteria.md:90-92` e STATE placares.
- Recomendação: incluir na futura core/arvores-spec.md (ou emendando a proposta) o mapeamento explícito dos 8 critérios para os dois gates de promoção. Usar os mesmos placares que já são produzidos nas ondas. Sem isso, o gate não é "objetivo".

### 3. MVP freeze: a lista 1-6 está completa? falta bloqueador? quais eram os bloqueadores do VETO 0034/0035 da Ponte?

**Evidência:**
- Proposta:66-71 (Parte 2.2): lista 1.P-CAND-04 (selado), 2.Deny-by-default (selado: ...), 3.Hardening marginais (selado ou won't-fix), 4.Árvores, 5.Tag v1-estavel + suite + main revisada; STATE/REGISTRY marcam v1-estavel, 6.Ponte: revisar bloqueadores VETO 0034/0035.
- `.hbn/relay/STATE.md:4-5,45,48`: P-CAND-04 ENTREGUE; "🔴 PONTE VETADA — 0034/0035"; "🟡 G-HRB assinatura PENDENTE DE CHAVE — Maurício gera/registra .hbn/operators/<nome>.pub"; "🟡 DÍVIDA RASTREADA — hardening de guards em onda propria: G-KNOW ... G-FRONTDOOR ... G-EXC".
- `.hbn/readbacks/0033-....json:61-64`: out_of_scope inclui hardening e deny-by-default como "proxima onda".
- VETO 0034 (Codex): `.hbn/results/0034-cross-ia-codex-ponte.md:26` ("106 uteis -5 +1 =102, nao 107"); :27 ("SO-COPIA=0 inseguro se rodado depois do R8, porque o git rm -r usehbn/ apaga"); :84-89 (split 0022 sem corpo verbatim); :95-99 (T3 ambíguo); :109-115 (R8 não materializa README tombstone + rollback subespecificado).
- VETO 0035 (Antigravity): `.hbn/results/0035-cross-ia-antigravity-ponte.md:47` (BLOQUEADOR: path abs "~/Projetos/usehbn/bin/..." no guard snapshot quebra CI); :52-54 (F-03: colisão R8 — forbidden-paths + README tombstone no mesmo commit → pre-commit block); :103-105 (matemática 107 errada; real ~103).
- `.hbn/knowledge/0024-....md:29-31`: "só gate enforçado vincula"; incidente real de commit de zona livre sem aprovação explícita.
- `.hbn/operators/`: não existe (ls .hbn/operators/ → "no operators dir or empty") → confirma PENDENTE DE CHAVE em `guards/assert-hearback-integrity.sh:81`: "Assinatura de hearback PENDENTE DE CHAVE: nenhum .pub em ${OPS_DIR} — G-HRB segue com as travas de histórico ... até o humano registrar a chave".

**Julgamento + citação:**
- Lista 1-6 **não está completa** como "selado": item 2 (deny) e 3 (hardening) são "próximas" per STATE/readback 0033 e 0032 (não selados ainda); item 6 (Ponte) lista "revisar bloqueadores" mas os bloqueadores exatos de 0034/0035 ainda não foram endereçados no disco (nenhum commit pós-veto os corrige nesta branch; main está em 4db6928 que é pre-ponte).
- Bloqueadores omitidos na lista 1-6: (a) ativação plena G-HRB (chaves .pub + remoção do modo "PENDENTE DE CHAVE" — `guards/assert-hearback-integrity.sh:80-82` e STATE:48); (b) hardening das marginais conhecidas (G-KNOW/G-FRONTDOOR/G-EXC) **antes** de armar deny-by-default (ver Q4/Q6); (c) ativação real do assert-registry-line.sh no runner (hoje "NÃO está no runner" per `guards/assert-registry-line.sh:11`).
- Bloqueadores exatos do VETO 0034/0035 (da Ponte): ver acima (aritmética 102≠107; SO-COPIA inseguro pós-rm; split 0022 sem verbatim; path abs no snapshot; colisão R8 pre-commit; contagem 107 errada). Citações diretas dos .md de results/0034 e 0035.
- Recomendação: emendar a checklist do freeze para incluir explicitamente "G-HRB chaves registradas + G-HRB full armada (não pendente)" + "hardening + deny-by-default validados em sequência" + "G-REG ativo no runner". Ponte só após 1-5 + esses + correção dos 5-6 pontos de 0034/0035.

### 4. Deny-by-default: mecanismo mais simples e robusto? há vetor de bypass?

**Evidência:**
- Proposta:67: "Deny-by-default / bloqueio total — selado: a IA não faz nada fora do escopo declarado; você aprova a `files_allowed` exata; selagem nunca toca `docs/brainstorm/**`; guard que bloqueia zona livre em escopo sem marcador de curadoria. (knowledge 0024)"
- `guards/assert-scope-lock.sh:349`: `if ! scope_allows "$f" "${ALLOWED_PATTERNS[@]}"; then OUT_SCOPE+=... FAIL=1`
- `guards/assert-scope-lock.sh:284-326`: lógica de EXTENSION: se READBACK_CHANGED && ADDED_ALLOWED_COUNT>0 → exige EXTENSION_VALID=="1" **E** `if [[ ${#OTHER_STAGED[@]} -gt 0 ]]; then guard_fail " ... estendido no mesmo commit com outros arquivos"` (commit deve ser isolado no readback).
- `guards/assert-scope-lock.sh:296-297`: "scope.files_allowed do readback ativo foi estendido sem scope_extension valido (human, evidence, created_at, allowed_delta...)"
- `guards/assert-hearback-integrity.sh:96-99`: em modo runner, se hearback tocado junto com obra → BLOCK (anti auto-assinatura).
- `.hbn/knowledge/0024-....md:37-44`: "Direção estrutural (candidata...): Deny-by-default: nada entra ... sem autorização explícita do escopo — e o humano aprova a `files_allowed` **exata**...; Selagem **nunca** inclui `docs/brainstorm/**`; Candidato a guard: sinalizar/bloquear quando a `files_allowed` de um readback contém path de zona livre sem um marcador de curadoria-humana."
- `.hbn/readbacks/0033-....json:34-43`: files_forbidden inclui core etc.; files_allowed é lista exata + handoff; sem brainstorm.
- `.hbn/operators/` vazio + G-HRB pendente de chave.

**Julgamento + citação:**
- Mecanismo atual (scope-lock + meta-paths B17-19 + files_allowed exata no readback + human_status confirmed + 0024 rule) é **base sólida**, mas **não é ainda "bloqueio total deny-by-default"** (deferido explicitamente).
- Vetor de bypass **existe e é real** (confirmo a análise antigravity com leitura independente do código):
  - Uma IA pode: (1) escrever readback com bloco scope_extension forjado (human:"Mauricio", allowed_delta cobrindo brainstorm ou outro path), commit **isolado** só do JSON do readback (OTHER_STAGED vazio → passa o check de 307); (2) G-HRB não toca (nenhum .hbn/hearbacks/ alterado); (3) commit seguinte stageia o que agora está "allowed" pelo escopo expandido. 
  - EXTENSION_VALID="1" é derivado de parse textual do readback (não de hearback assinado). Sem chaves .pub, sem binding cripto, é forgeável.
  - Citação: `assert-scope-lock.sh:307` (o "commit isolado" permite a expansão); `assert-hearback-integrity.sh:81` (PENDENTE DE CHAVE); knowledge 0024:31 ("só gate enforçado vincula" — o incidente 0024 prova que texto/instrução não basta).
- Mais simples/robusto: (a) endurecer o guard para **rejeitar** qualquer files_allowed contendo `docs/brainstorm/**` ou paths de zona livre **a menos que** haja marcador explícito de curadoria (ex: "curadoria_human: true" + lista de paths no authorization.evidence do readback, ou referência a hearback assinado); (b) armar G-HRB (chaves) + exigir que extensões de scope refiram hearback cripto ou .sig; (c) selagem nunca lista brainstorm (já praticado em 0033). O "guard que bloqueia zona livre em escopo sem marcador" é exatamente o candidato de 0024 — deve ser implementado na onda de deny.
- Recomendação: o mecanismo proposto na Parte 2 é direção correta, mas incomplete sem o guard anti-zona-livre explícito + binding forte de extensões. Adicione como pré-requisito para W2.

### 5. Leveza (P-CAND-01): algo é maquinaria a mais? existe via mais simples/racional, mesmo de outra premissa/tecnologia?

**Evidência:**
- Proposta:35: "AGORA (leve): um campo `arvore:` no front-matter + uma spec curta + um guard de validação. Custo baixo, reversível." "EXÚVIA (fora): compilador... partição física..."
- Parsers existentes (frágeis): `guards/assert-self-path.sh:63` (awk para --- / path:), idêntico em assert-pointer-honest.sh:52, assert-report-fresh.sh etc. Python parsers só em dispatch guards.
- REGISTRY.md:13-19 (ADR-011): "Livro-razão append-only... Quem deposita artefato novo appenda a linha no mesmo commit... Mudança de temperatura = nova linha..."
- `guards/assert-registry-line.sh:1-38`: G-REG existe, cobre add/rename de artefatos numerados + core/*.md + docs/** + methodology/** + guards/** etc; **NÃO está no runner** hoje ("ativação futura = onda própria"); usa git show :REGISTRY.md (staged/HEAD, nunca worktree).
- Nenhum core/arvores-spec.md existe; brainstorm tem rascunhos de PF-arvores (mas zona livre).
- Estrutura: core/ tem 15+ *-spec.md (todos com FM YAML); guards/ são .sh + README com FM; alguns artefatos normativos sem FM (role-cards).

**Julgamento + citação:**
- Sim, há **maquinaria a mais** na proposta para o objetivo "fechar MVP leve":
  - Novo campo por arquivo + novo parser em G-ARVORE (duplica awk frágil já presente em ≥4 guards; bypassável por blank line ou comentário no topo — antigravity acertou; eu confirmei o awk idêntico).
  - Nova spec (core/arvores-spec.md) + novo guard + novos testes/burlas + updates no runner.
  - Migração "leve" ainda exige tocar N arquivos existentes quando editados; risco de inconsistência (arquivo modificado sem tag passa, per antigravity Q1).
  - Duplicação conceitual: temperatura/status no FM + REGISTRY já rastreiam "maturidade"; trees adiciona terceira dimensão sem amarra forte.
- **Via mais simples/racional (mesmo de outra premissa):** **Centralizar no REGISTRY** (já é o livro-razão de todos os artefatos governados; append-only; G-REG existe e quase pronto).
  - Adicionar coluna `arvore` (fronteira|intermediaria|estavel) nas linhas going-forward do REGISTRY.
  - Na deposição de artefato novo (que já exige linha no REGISTRY por G-REG rules), declarar a árvore no nascimento.
  - Promoção = nova linha no REGISTRY (append) com arvore atualizado + ref da onda/cross-audit que autorizou (superseded_by ou coluna extra).
  - Guard: estender assert-registry-line.sh (ou thin wrapper) para validar a árvore declarada em mudanças; ou checar no runner que artefatos staged têm linha REGISTRY consistente com árvore permitida.
  - Para .sh/guards: a linha no REGISTRY para "guards/ (runner + ...)" ou a edição da array no runner carrega a declaração de árvore do guard (sem precisar de # header em cada .sh).
  - Para brainstorm: curadoria promove via linha REGISTRY com arvore=intermediaria/estavel + remoção de "brainstorm/" path (ou marcação).
  - Benefícios: 0 novo parser YAML/awk; 1 fonte de verdade (REGISTRY) já auditada em ondas anteriores; G-REG já lida com "novo artefato" vs legacy; menos superfície de código novo para o freeze; alinhado com "P-CAND-01 leve".
  - Citação: `REGISTRY.md:46-` (tabela going-forward com id|artefato|tipo|temperatura|superseded_by); `guards/assert-registry-line.sh:11,35-37` (escopo inclui guards/**, docs/**, methodology/**; "linha exata no REGISTRY STAGED").
- Alternativa ainda mais radical (ver EXTRA): pular a etiqueta explícita para o MVP freeze. Definir "MVP genoma" proceduralmente via placar exuvia + ondas seladas + REGISTRY quente + deny-by-default + 0024. A etiqueta pode vir na exúvia (quando a partição física acontece de qualquer forma).
- Recomendação: se insistir em etiqueta por-arquivo, ok como "leve", mas prefira registry-centric (menos peças, mais robusto). Avalie a via radical para minimizar risco de regressão no caminho ao freeze.

### 6. Sequência W1-W5: a ordem minimiza retrabalho e risco de regressão?

**Evidência:**
- Proposta:75: "W1 P-CAND-04 → W2 deny-by-default → W3 hardening de guards (agrupado) → W4 árvores etiqueta → W5 freeze+tag → Ponte"
- STATE:14: "proxima_acao: \"Cross-audit P-CAND-04; depois bloqueio total deny-by-default da zona livre.\""
- STATE:21,28,36: dívidas rastreadas de hardening (G-KNOW substring/ponteiro-morto; G-FRONTDOOR bytes vs linhas; G-EXC trailer) "destino: onda de hardening propria".
- Antigravity cross (anterior, mas verifiquei o código): propõe reordenar W3 hardening antes de W2 deny.
- `guards/assert-scope-lock.sh:284-326` + `assert-hearback-integrity.sh:80-82`: vetores de extensão + PENDENTE DE CHAVE ainda abertos.
- P-CAND-04 readback 0033: hardening e deny são "out_of_scope" / "proxima".

**Julgamento + citação:**
- A ordem **não minimiza** risco: colocar W2 (enforce deny-by-default estrito) **antes** de W3 (fechar bypasses conhecidos de scope ext + armar G-HRB + hardening G-KNOW/FRONT/EXC) cria **falsa barreira**. As IAs (orquestrador ou outra) encontrarão o vetor de extensão forjada ou zona livre via readback expandido, exatamente como no incidente que gerou 0024.
- Citação: STATE:21 ("🟡 DÍVIDA RASTREADA — hardening de guards em onda propria"); scope-lock:307; hearback:81; knowledge 0024:39 ("Blacklist infinita de guards perde a corrida").
- Ordem que minimiza retrabalho/regressão: W1 (feito) → W3 hardening (fixar os vetores + ativar G-REG no runner + preparar G-HRB para chaves) → W2 deny-by-default (agora sobre base endurecida, com guard anti-zona-livre + binding de extensão) → W4 (ou pular, ver Q5) → W5 freeze+tag (com suíte 100% + todos C- gates + G-HRB armed + deny provado) → Ponte (após correções 0034/0035 + blockers omitidos).
- Recomendação: emendar a sequência na proposta. Manter deny "quente" como prioridade, mas executá-lo sobre guards já hardened. O risco de regressão ao descobrir bypass depois de "freeze" é alto.

## EXTRA por família (grok — via mais simples/radical)

**Pergunta:** a via mais simples/radical — daria para fechar o MVP com menos peças?

**Resposta:** **SIM, daria — e eu recomendo fortemente considerar para o freeze.**

- O objetivo do MVP freeze (per Parte 2) é: "Protocolo cujo núcleo (estavel+intermediaria) tem: cobertura de teste positivo/negativo, resistência adversarial, cross-audit de família distinta, fail-closed, sem regressão, rastreabilidade — e cujas brechas conhecidas estão fechadas ou aceitas com dívida registrada."
- A etiqueta `arvore:` é **declarativa** (não muda runtime, não é amarrada por assinatura/histórico de promoção no gate — ver antigravity ponto sobre "falsa confiança"). O enforcement real vem dos guards (scope, registry-line quando ativo, frontdoor, hearback, scratch, etc.), das ondas cross-auditadas, do human gate no readback, do deny-by-default, e do 0024.
- **Caminho com menos peças (radical simplicity):**
  1. Pular G-ARVORE, core/arvores-spec.md e extensão de front-matter para trees nesta fase.
  2. Definir "núcleo MVP" **proceduralmente**:
     - Artefatos com linha no REGISTRY (quando G-REG ativado), temperatura/status aceito, que passaram por ondas seladas com placar C-TEST/C-ADV/C-XAUDIT/etc (usando os 8 critérios já existentes).
     - Nada de `docs/brainstorm/**` entra no núcleo (enforçado por deny + guard anti-zona-livre + 0024 + human listagem explícita no files_allowed de cada readback).
  3. Focar o "fechamento" em: hardening + ativação G-HRB (chaves) + deny-by-default com guard específico para zona livre + G-REG no runner + suíte/adversarial + tag v1-estavel + correção dos blockers da Ponte.
  4. A etiqueta explícita + ritual de promoção (fronteira→intermediaria→estavel) vira **trabalho da exúvia** (1ª muda), quando a partição física de pastas/versões e o compilador de gradiente de prova de qualquer forma vão existir. Ou pode ser adicionada post-freeze sem bloquear o v1-estavel.
- Benefícios: menos código novo (0 parser duplicado, 0 spec, 0 guard novo, 0 testes de burla para arvore), menos risco de regressão por parser frágil, superfície de ataque menor no caminho crítico ao freeze, "leveza" verdadeira (P-CAND-01), dogfood do espírito do protocolo (só gate enforçado, não rótulo declarativo).
- Custo da via radical: perde a "fronteira do MVP desenhada explicitamente" que a proposta quer. Mas a fronteira já existe de fato via o que foi selado nas ondas + o que o deny permite no scope + o que o REGISTRY registra.
- Citação de apoio: knowledge 0024:29 ("Uma instrução escrita **dentro** de um documento ... não vincula uma IA — ... Só um gate enforçado (guard que falha fechado) vincula."); exuvia-fitness-criteria.md:90 (a regra de sobrevivência já é o placar objetivo); REGISTRY + assert-registry-line (fonte única append-only).

Se o humano/orquestrador quiser a etiqueta **agora** por clareza narrativa, faça via registry-centric (Q5) + expanda paths + reordene sequência + adicione blockers omitidos. Mas para "fechar o MVP com menos peças", a via radical é viável e mais alinhada com o que já está no disco (placares, REGISTRY, deny deferido, 0024).

## Veredito Final e Recomendações por Pergunta (confiança por item 0-100)

1. **Q1 (paths + .sh):** Expandir obrigatoriedade para schemas/guards/knowledge não-brainstorm + docs normativos; .sh via # header + validação runner (ou implicit via registry line do runner). Confiança: 85. Ajuste obrigatório.
2. **Q2 (gate transição):** Gate atual subjetivo; reuso explícito dos 8 critérios C-TEST..C-TRACE para intermediaria→estavel (e versão leve para fronteira→inter). Incluir no spec. Confiança: 90. Ajuste obrigatório.
3. **Q3 (freeze 1-6 + Ponte):** Lista incompleta; adicionar G-HRB full + hardening pré-deny + G-REG runner. Bloqueadores 0034/0035 são exatamente os de results/0034 e 0035 (aritmética, verbatim, CI path, colisão R8 etc). Confiança: 95. Ajuste obrigatório.
4. **Q4 (deny):** Mecanismo base (scope + exact files_allowed + 0024) é bom, mas incompleto e com vetor de bypass (scope_extension forjada em commit isolado + G-HRB desarmado). Adicionar guard anti-zona-livre + binding cripto de extensões. Confiança: 80. Ajuste obrigatório.
5. **Q5 (leveza):** Há maquinaria a mais (novo parser duplicando awk frágil). Via registry-centric é mais simples/racional (1 fonte de verdade, G-REG já existe, 0 novo parse). Confiança: 75.
6. **Q6 (sequência):** Ordem atual aumenta risco (deny antes de hardening). Reordenar: W1 → W3 hardening → W2 deny → W4/W5. Confiança: 85. Ajuste obrigatório.

**APROVA_PROPOSTA: SIM + ajustes objetivos** (não é veto; a direção de "etiqueta leve + freeze explícito" é correta e necessária para fim de linha do protocolo; mas os 6 pontos acima devem ser endereçados antes de despachar as ondas W. Prefiro a variante registry-centric ou a via radical "menos peças" para o MVP.)

Se o orquestrador quiser seguir com o design atual de front-matter por arquivo, as correções de rigor (fail-closed para modificados também, parser robusto em python não awk, obrigatoriedade expandida, gate com 8 critérios) são mandatórias.

---

**Assinatura do auditor (grok, família xAI, janela distinta):**  
grok — 2026-06-16  
(Truth Barrier: este parecer foi gerado após reads completos de proposta, STATE, readbacks 0032/0033, results 0034/0035, knowledge 0024, exuvia-criteria, runner, scope-lock, hearback-integrity, registry, guards README, core specs, brainstorm drafts, antigravity result, e múltiplos greps/shell verifies no branch proposta/reestruturacao-m-a-s0 @ 2d4ad86. Nenhum commit, nenhum touch em main, nenhum git add. Tudo citável no disco.)

(Depósito: .hbn/results/20260616-184500-grok-cross-ia-proposta-arvores-mvp.md — análogo aos anteriores cross-ia-*.md)
