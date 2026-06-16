---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (modelo versão=pasta; M-A scaffold inativo; B19/S2/faxina 0027/S3.1/S3.2 selados; P-CAND-04 entregue; W2 hardening entregue)"
onda_atual: "W2 ENTREGUE: hardening dos guards fechou B29-B32; P-CAND-04 sera selado junto na proxima selagem"
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: claude-opus-4-8
papel_bastao: "orquestrador"
modo_educacional: "intermediário"
papeis:
  arquiteto: "claude-opus-4-8 — orquestrador/desenho do mecanismo M-A; distinto do implementador codex"
  auditores_validadores: "gemini-3-5 + cursor — cross-audit S1 concluiu APROVA_S1: SIM; cross-audit B17 concluiu APROVA_B17: SIM; cross-audit B18 concluiu APROVA_B18: SIM; cross-audit B19 concluiu APROVA_B19: SIM e classe FECHADA: SIM; cross-audit S2 concluiu APROVA_S2: SIM; cross-audit faxina 0027 concluiu APROVA_0027: SIM; cross-audit S3.1 concluiu APROVA_0029: SIM; cross-audit S3.2 concluiu APROVA_0031: SIM"
  gate_humano: "Maurício — aprovou a reestruturação em 2026-06-15, autorizou a selagem S1, decidiu tratar B17 antes do S2, autorizou B18, ratificou a selagem B18 com B19a como próxima onda, autorizou B19 antes do S2, autorizou a selagem B19 após cross-audit, autorizou S2 com guards bloqueantes sem rampa, autorizou a selagem S2 apos duplo APROVA_S2 SIM, autorizou lixo-zero na selagem da faxina 0027, autorizou S3 incremental com INDEX vivo da knowledge em S3.1, autorizou a selagem S3.1 lixo-zero, autorizou a selagem S3.2 lixo-zero com hardening de guards em onda propria e autorizou P-CAND-04 em 2026-06-16"
proxima_acao: "Cross-audit W2; P-CAND-04 sera selado junto na proxima selagem; depois avaliar deny-by-default/freeze."
sinais_abertos:
  - "🟢 W2 ENTREGUE — hardening dos guards concluido: G-KNOW-INDEX token inteiro + anti-ponteiro-morto; G-FRONTDOOR teto bytes + read-list robusta + existencia; G-EXC trailers no ultimo paragrafo; G-SCRATCH fail-closed sem active-version; comentario G-REG corrigido."
  - "🟢 TESTES W2 VERDES — run-guard-tests fechou 175/175; adversarial-battery bloqueou B1-B32, incluindo B29, B30, B31 e B32."
  - "🟡 P-CAND-04 SERA SELADO JUNTO — area temporaria /scratch/ ja foi entregue; a proxima selagem deve cobrir P-CAND-04 junto com W2."
  - "🟡 PRÓXIMA AÇÃO — Cross-audit W2; P-CAND-04 sera selado junto na proxima selagem; depois avaliar deny-by-default/freeze."
  - "🟢 P-CAND-04 ENTREGUE — area temporaria /scratch/ ativa: .gitignore ignora /scratch/ e versiona somente scratch/README.md como contrato de uso."
  - "🟢 G-SCRATCH ATIVOS — guards/assert-scratch-lock.sh, guards/assert-scratch-symlink.sh e guards/assert-scratch-ignore.sh entraram bloqueantes no runner."
  - "🟢 TESTES P-CAND-04 VERDES — run-guard-tests fechou 165/165; adversarial-battery bloqueou B1-B28, incluindo B26 arquivo em scratch/, B27 symlink em scratch/ e B28 .gitignore sem /scratch/."
  - "🟡 PRÓXIMA AÇÃO — Cross-audit P-CAND-04; depois bloqueio total deny-by-default da zona livre."
  - "🟢 S3.2 SELADA — porta da frente ativa: core/role-cards.md + G-FRONTDOOR; Cursor registrou APROVA_0031: SIM com confiança 90/100 e Gemini/Antigravity registrou APROVA_0031: SIM com confiança 100/100."
  - "🟡 DÍVIDA RASTREADA — hardening de guards em onda propria: G-KNOW-INDEX usa substring no grep -Fq e permite ponteiro-morto INDEX->arquivo; G-FRONTDOOR conta linhas e nao bytes, conta itens por marcador com espaco/formatos mapeados e nao verifica existencia dos paths da read-list."
  - "🟢 P-CAND-04 EXECUTADA — a antiga proxima acao de implementar area temporaria foi entregue nesta onda."
  - "🟢 S3.2 ENTREGUE — porta da frente ativa em core/role-cards.md: read-list de 6 itens + tres cartoes curtos por papel, apontando para specs sem duplicar."
  - "🟢 G-FRONTDOOR ATIVO — guards/assert-frontdoor.sh entrou bloqueante no runner; falha fechado se core/role-cards.md ausente/ilegivel, >140 linhas ou read-list >6."
  - "🟢 TESTES S3.2 VERDES — run-guard-tests fechou 160/160; adversarial-battery bloqueou B1-B25, incluindo B25 role-cards inflado/read-list estourada."
  - "🟢 S3.1 SELADA — G-KNOW-INDEX segue ativo no runner; knowledge 0023 foi indexada e selada; pareceres Gemini/Cursor, despacho e brainstorm foram versionados."
  - "🟢 INDEX VIVO DA KNOWLEDGE — qualquer .hbn/knowledge/*.md, exceto INDEX.md, precisa aparecer citado pelo basename no INDEX; ausencia/ilegibilidade do INDEX falha fechado; estado atual: 9 entradas."
  - "🟡 DÍVIDA RASTREADA G-KNOW-INDEX — substring por grep -Fq do basename em guards/assert-knowledge-index.sh:63 e ponteiro-morto quando INDEX cita arquivo inexistente; destino: onda de hardening propria."
  - "🟡 DECISÃO AREA TEMPORARIA — P-CAND-04 convergiu no cross-audit: tmp do ambiente primeiro; scratch/ no repo so em onda propria com gitignore + guards anti-stage/symlink/ignore."
  - "🟡 NOTA DE CONTINUIDADE — proximo orquestrador deve ler STATE + handoff + core/role-cards.md e seguir a read-list da porta da frente."
  - "🟢 S2 + FAXINA 0027 FECHADOS — S2 foi ratificada e selada; faxina 0027 foi ratificada por Cursor e Gemini/Antigravity com APROVA_0027: SIM e selada na micro-onda 0028."
  - "🟢 S2 RATIFICADA E SELADA — Gemini registrou APROVA_S2: SIM com confiança 100/100; Cursor registrou APROVA_S2: SIM com confiança 90/100; pareceres e despachos foram depositados nesta micro-onda."
  - "🟢 FAXINA 0027 RATIFICADA E SELADA — pareceres Cursor/Gemini depositados, tres despachos do orquestrador selados, brainstorm versionado e fixes lixo-zero aplicados sem mudar logica de guard."
  - "🟢 DÍVIDA H RESOLVIDA — G-EXC em CI agora le mensagem bruta (%B), igual ao commit-msg local; run-guard-tests fechou 154/154 e adversarial-battery bloqueou B1-B23."
  - "🟢 D2 RESOLVIDA — scratch de guards/tests coberto por .gitignore (cr-*, adv-cr*, tmp-pass.*, wt-main.*) e diretorios remanescentes removidos best-effort."
  - "🟡 DÍVIDA RASTREADA PARA HARDENING — G-EXC ainda aceita prosa iniciada por 'HBN-...:' no corpo porque valida %B inteiro; destino: restringir a busca ao ultimo paragrafo/trailer block em onda propria."
  - "🟡 CONVENÇÃO RASTREADA — todo handoff de onda deve estar no files_allowed do readback; o lapso do handoff 0027 fica registrado e a 0028 incluiu seu handoff no escopo."
  - "🟢 B19 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B19: SIM e CLASSE FECHADA: SIM; classe symlink/meta-path FECHADA apos B17+B18+B19; hardlink = non-issue (git 100644); proxima onda: S2 (dispatch schema)."
  - "🟢 B18 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B18: SIM; symlink staged sob .hbn/** segue bloqueado por modo git 120000 antes da dispensa de meta-path; run-guard-tests 141/141 e adversarial-battery B1-B18 verdes."
  - "🟢 B17 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B17: SIM; meta-paths em guards/assert-scope-lock.sh auto-permitem somente .json/.md com basename ADR-025, hearback do readback ativo ou nome-endereco conhecido."
  - "🟢 S1 RATIFICADO E SELADO — assert-scope-lock endurecido contra auto-emenda de files_allowed; cross-audit Gemini+Cursor registrou APROVA_S1: SIM."
  - "🟢 REESTRUTURAÇÃO M-A+S0 SELADA — linha limpa proposta/reestruturacao-m-a-s0 @ 5a0587d; tree 61fa290e ancorada por tag."
  - "🟢 CROSS-AUDIT SIM — Cursor e Gemini 3.5 registraram APROVA_REESTRUTURACAO: SIM para o Modelo B."
  - "🔴 EXCEÇÃO F-01 ATIVA — implementador == agente do readback ativo (codex) nesta selagem; PROPOSED_UNTIL_CROSS_AUDIT."
  - "🔴 PONTE VETADA — 0034 Codex e 0035 Antigravity retornaram VETO_ADOCAO: SIM; corrigir bloqueadores antes de descongelar."
  - "🔴 ATIVAÇÃO DA EXÚVIA BLOQUEADA — Fitness Gate pendente: baseline funcional + Ponte verde + confronto incumbente×desafiante."
  - "🟡 D-ORQ-WRITE NÃO HABILITADA — doutrina no replay; escrita do orquestrador e G-ACTOR-WRITE-MATRIX seguem para rito futuro."
  - "🟡 G-HRB assinatura PENDENTE DE CHAVE — Maurício gera/registra .hbn/operators/<nome>.pub para ativar ssh-keygen -Y verify."
  - "🟡 F-02 (0035 UTC×REGISTRY) NÃO corrigido — formato da linha superseded_by segue decisão humana."
  - "🟡 branch protection no GitHub (hbn-shield obrigatório no push) = ação humana pendente."
  - "🟡 backlog preservado — bump 0.3.1, hearback 0002, inbox/credenciamento e versionamento de readbacks ficam para ondas futuras."
readback_ativo: ".hbn/readbacks/0034-hardening-guards.json"
handoff_mais_recente: ".hbn/messages/20260616-194500-codex-handoff-w2-hardening.md"
ancora_rollback: "evidencia/reestruturacao-m-a-s0-tree-equivalent -> 5a0587d (tree 61fa290e; rollback da selagem ao replay limpo)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "W2 hardening de guards entregue; bastao volta ao orquestrador para cross-audit W2. P-CAND-04 sera selado junto na proxima selagem."
ultima_atualizacao: "2026-06-16T19:45:00-03:00"
atualizado_por: codex-implementador-w2-hardening
atribuicao:
  chapeu_atual: orquestrador
  implementador: codex
  auditores: [gemini-3-5, cursor, antigravity]
  gravada_em: "2026-06-16T19:45:00-03:00"
  hearback_ref: null
---

Nota W2 / readback 0034: entregue em 2026-06-16. A onda fechou os bypasses
apontados nas auditorias: B29 (G-KNOW-INDEX substring e ponteiro morto), B30
(G-FRONTDOOR linha unica densa e path inexistente), B31 (G-EXC prosa no corpo
sem trailers finais) e B32 (G-SCRATCH-LOCK sem active-version). `run-guard-tests`
fechou 175/175 e `adversarial-battery` bloqueou B1-B32. O comentario stale do
G-REG foi corrigido sem mudanca de logica. P-CAND-04 sera selado junto na
proxima selagem; o bastao volta ao orquestrador para cross-audit W2.

Nota M-A: esta onda construiu a máquina da muda sem disparar a muda. O
ponteiro ativo permanece em `.`; hooks e guards falham fechado quando o
ponteiro está ausente, conflitado ou aponta para versão inexistente. A tag
`hbn-exuvia/protocol-0.3.x` e qualquer `git mv` ficam para M-C, depois do
Fitness Gate. O script de rollback foi testado apenas em dry-run.

Nota S0: esta onda corrigiu somente itens aditivos/corretivos pós-M-A. O bug D3
do rollback foi corrigido com teste de `--apply`; perfis `grok` e `cursor`
foram adicionados como `proposed`; o INDEX foi marcado como superseded pelo
STATE; e as fixtures untracked indicadas foram removidas. Nenhuma lógica de
guard foi alterada.

Nota depósito S0: Gemini (Google) aprovou S0 com confiança 100/100; Cursor
aprovou S0 com duas marginais não-bloqueadoras; opus-4-8 consolidou como OK,
ratificável e sem bloqueador. O marginal `cursor.json` model_id vs runtime fica
rastreado para a promoção futura do perfil a `accepted`.

Nota D-ORQ-WRITE: a cláusula 10 de `core/orchestrator-profile-spec.md` está na
linha limpa ratificada pela reestruturação M-A+S0, mas esta selagem não habilita
escrita operacional do orquestrador. O guard G-ACTOR-WRITE-MATRIX fica reservado
para rito futuro.

Nota reestruturação M-A+S0: o Modelo B foi ratificado por Maurício em
2026-06-15 após cross-audit Cursor+Gemini com `APROVA_REESTRUTURACAO: SIM`.
A linha limpa é `proposta/reestruturacao-m-a-s0` no tip `5a0587d`; a prova
mecânica fica congelada pela tag `evidencia/reestruturacao-m-a-s0-tree-equivalent`
com tree `61fa290e83b075983b9c6961a06c6e229cad1fd4`. Esta selagem adiciona
governança nova por cima do replay e não habilita escrita operacional do
orquestrador.

Nota selagem S1: Gemini (`.hbn/results/20260615-112714-gemini-3-5-cross-ia-s1-scope-lock.md`)
e Cursor (`.hbn/results/20260615-113115-cursor-cross-ia-s1-scope-lock.md`)
registraram `APROVA_S1: SIM`. B16 (auto-emenda de `scope.files_allowed` + uso
no mesmo commit) permanece bloqueado pela bateria S1. B17, a brecha
preexistente de meta-paths sempre permitidos em `guards/assert-scope-lock.sh:207-214`,
foi tratado e selado em 2026-06-15; B18 segue como proxima onda antes do S2.

Nota B17: a brecha preexistente de smuggling por meta-path foi implementada em
2026-06-15 com recorte tipo+nome. `guards/assert-scope-lock.sh` agora aceita
automaticamente apenas `.json`/`.md` de evento ADR-025 em `.hbn/messages/` e
`.hbn/bypasses/`, hearback `NNNN-*.{json,md}` do readback ativo e
`.hbn/relay/INDEX.md`; scripts, binarios e nomes arbitrarios nesses caminhos
precisam estar em `scope.files_allowed`. `run-guard-tests` passou com 140/140 e
`adversarial-battery` bloqueou B1-B17; cross-audit independente aprovado em
2026-06-15.

Nota selagem B17: Gemini
(`.hbn/results/20260615-213855-gemini-3-5-cross-ia-b17-meta-path.md`) e Cursor
(`.hbn/results/20260615-213850-cursor-cross-ia-b17-meta-path.md`) registraram
`APROVA_B17: SIM`. Cursor documentou B18: symlink com basename ADR-025 em
`.hbn/messages/20260615-120000-codex-handoff-x.md` apontando para
`../../src/payload.sh` passa porque `is_meta_auto_allowed` valida somente o
path string (`guards/assert-scope-lock.sh:236-249`). Decisão humana:
B18 e a próxima onda antes do S2.

Nota B18: implementado em 2026-06-15. `guards/assert-scope-lock.sh` agora
recusa qualquer entrada staged sob `.hbn/**` com modo git `120000`, antes de
avaliar `scope.files_allowed` ou meta-path ADR-025. A mensagem de bloqueio e
`symlink não permitido em path de coordenação governado: <path>`. Arquivos
regulares de handoff `.md`, hearback `NNNN-*.json` e nota de bypass `.md`
continuam passando. Cross-audit independente aprovado na selagem B18.

Nota selagem B18: Gemini
(`.hbn/results/20260615-223941-gemini-3-5-cross-ia-b18-symlink.md`) e Cursor
(`.hbn/results/20260615-224921-cursor-cross-ia-b18-symlink.md`) registraram
`APROVA_B18: SIM`. B19a fica aberto porque `is_governed_hbn_symlink` limita a
checagem a `.hbn/*` em `guards/assert-scope-lock.sh:256`; a próxima onda deve
generalizar o bloqueio de symlink para todo path governado. hardlink =
non-issue (git 100644): o Git grava hardlink como arquivo regular, sem
semantica de link no objeto versionado.

Nota B19: implementado em 2026-06-15. `guards/assert-scope-lock.sh` agora
recusa qualquer entrada staged avaliada pelo guard com modo git `120000`,
resolvendo o path de versao ativa para o path real do repo antes de consultar
`git ls-files --stage` localmente ou `git ls-tree HEAD` em CI. B18 segue coberto
e o bloqueio agora inclui paths governados como `.hbn/`, `guards/`, `core/` e
`src/`. `run-guard-tests` passou com 145/145; `adversarial-battery` bloqueou
B1-B19. Cross-audit depositado na selagem B19; ver nota seguinte.

Nota selagem B19: Gemini
(`.hbn/results/20260615-234638-gemini-3-5-cross-ia-b19-symlink-geral.md`) e
Cursor (`.hbn/results/20260615-234641-cursor-cross-ia-b19-symlink-geral.md`)
registraram `APROVA_B19: SIM` e `CLASSE FECHADA: SIM`. A classe
symlink/meta-path fica FECHADA apos B17+B18+B19. Hardlink permanece
non-issue/won't-fix: o Git materializa como arquivo regular `100644`, sem
semantica de link no objeto versionado. Proxima onda do roadmap: S2 (dispatch
schema).

Nota S2: implementada em 2026-06-16. O despacho passa a ser artefato
auto-declarante em `.hbn/dispatch/NNNN-*.md`, validado por
`schemas/dispatch.schema.json` e pela spec `core/dispatch-spec.md`.
`guards/validate-dispatch.sh` (G-DSP-FMT) bloqueia forma inválida, token_fp mal
formado e corpo colável com linha iniciada por `#`; `guards/assert-dispatch-integrity.sh`
(G-DSP-INT) bloqueia readback inexistente/não-ativo, token_fp divergente do
STATE e autorização humana vazia. Ambos entraram no runner sem rampa.
`guards/tests/run-guard-tests.sh` fechou 151/151 e
`guards/tests/adversarial-battery.sh` bloqueou B1-B22. O primeiro dispatch,
`.hbn/dispatch/0025-s2-dispatch-auto-declarante.md`, foi validado como dogfood.
Próximo passo: cross-audit Gemini+Cursor; selagem de S2 é micro-onda própria
com readback 0026, não feita aqui.

Nota selagem S2: concluida em 2026-06-16. Gemini
(`.hbn/results/20260616-010326-gemini-3-5-cross-ia-s2-dispatch.md`) registrou
`APROVA_S2: SIM` com confiança 100/100; Cursor
(`.hbn/results/20260616-010221-cursor-cross-ia-s2-dispatch.md`) registrou
`APROVA_S2: SIM` com confiança 90/100. Os despachos do orquestrador de abertura
S2 e cross-audit S2 foram depositados no historico. O marginal H (trailers
historicos nao-contiguos para parser nativo) e os marginais EXTRA do Cursor
(dispatch-like fora de `.hbn/dispatch/` e relacao `dispatch_id` x
`readback_id`) ficaram documentados para triagem na faxina 0027, junto com os
untracked antigos e os criterios/triagem de exuvia; esta selagem nao alterou
logica de guard.

Nota faxina 0027: implementada em 2026-06-16. O G-EXC passou a validar trailers
em CI sobre a mensagem bruta do commit (`%B`), igual ao modo commit-msg, cobrindo
o falso-positivo do parser nativo `%(trailers)`. `run-guard-tests` fechou
154/154 e `adversarial-battery` bloqueou B1-B23. Os seis artefatos historicos
antigos foram selados, com carimbos de deposito nos handoffs legados para
compatibilidade com G-RLT/G-PTR. `.gitignore` passou a cobrir scratch das suites
e os diretorios remanescentes foram removidos best-effort. A triagem e o
documento-fonte de criterios de exuvia foram selados, e
`core/exuvia-fitness-criteria.md` virou a referencia normativa. Os
endurecimentos EXTRA-1/EXTRA-2 do Cursor seguem fora desta onda e devem ser
tratados em S3.

Nota selagem da faxina 0027 / readback 0028: concluida em 2026-06-16. Cursor
(`.hbn/results/20260616-023446-cursor-cross-ia-faxina-0027.md`) e Gemini
(`.hbn/results/20260616-024241-gemini-3-5-cross-ia-faxina-0027.md`) registraram
`APROVA_0027: SIM`. A selagem depositou os pareceres, tres despachos do
orquestrador e dois docs de brainstorm como zona-livre versionada. O lixo-zero
sem mudanca de logica ficou aplicado em `.gitignore` (`adv-cr*`) e no
front-matter do doc-fonte de criterios (`status: superseded` +
`superseded_by: core/exuvia-fitness-criteria.md`). Ficam rastreadas para S3 /
hardening: (1) prosa-trailer do G-EXC, pois `%B` inteiro ainda aceita linhas de
corpo iniciadas por `HBN-...:`; (2) convencao de incluir o handoff da onda no
`files_allowed` do readback.

Nota S3.1 / readback 0029: entregue em 2026-06-16. O INDEX da knowledge deixou
de ser amostra estatica e passou a listar as 8 entradas atuais:
`0001-comandos-atomicos-copiaveis.md`,
`0002-entrega-operacional-minimalista.md`,
`0003-git-sandbox-sem-lock.md`, `0019-severidades-veto.md`,
`0022-firewall-workflow-fast-track.md`, `distribution-model.md`,
`relay-protocol.md` e `runtime-command-model.md`. O novo G-KNOW-INDEX entrou
bloqueante em `guards/hbn-guards-runner.sh`, falhando fechado se o INDEX estiver
ausente/ilegivel ou se qualquer `.hbn/knowledge/*.md` nao for citado pelo
basename. `run-guard-tests` fechou 156/156 e `adversarial-battery` bloqueou
B1-B24, incluindo B24 (knowledge nova ausente do INDEX).

Nota selagem S3.1 / readback 0030: concluida em 2026-06-16. Gemini/Antigravity
(`.hbn/results/20260616-121025-gemini-3-5-cross-ia-s3-1.md`) e Cursor
(`.hbn/results/20260616-124526-cursor-cross-ia-s3-1.md`) registraram
`APROVA_0029: SIM`. A selagem depositou os dois pareceres, o despacho de
cross-audit do orquestrador, a knowledge 0023, o INDEX atualizado, tres docs de
brainstorm e este handoff, sem alterar logica de guard. Dividas rastreadas para
hardening: (1) G-KNOW-INDEX usa `grep -Fq "$base"` e pode aceitar substring em
`guards/assert-knowledge-index.sh:63`; (2) o INDEX pode citar arquivo inexistente
sem o guard reclamar (ponteiro-morto). Decisao de design rastreada: P-CAND-04
convergiu para tmp do ambiente primeiro; `/scratch/` no repo, se adotado, deve
ter onda propria com gitignore + guards anti-stage/symlink/ignore. Continuidade:
o proximo orquestrador deve ler STATE + handoff + `.hbn/knowledge/0001`,
`.hbn/knowledge/0002` e `.hbn/knowledge/0023` ao assumir o bastao.

Nota selagem S3.2 / readback 0032: concluida em 2026-06-16. Cursor
(`.hbn/results/20260616-132743-cursor-cross-ia-s3-2.md`) registrou
`APROVA_0031: SIM` com confiança 90/100; Gemini/Antigravity
(`.hbn/results/20260616-132813-gemini-3-5-cross-ia-s3-2.md`) registrou
`APROVA_0031: SIM` com confiança 100/100. A selagem depositou os dois
pareceres e versionou os tres docs de brainstorm de Fronteira
(`docs/brainstorm/exuvia-evolucao-conceitual.md`,
`docs/brainstorm/PROMPTS-PF-ARVORES-AGORA-DRAFT.md` e
`docs/brainstorm/PROPOSTA-arvores-agora.md`), sem alterar logica de guard.
Divida rastreada agrupada para hardening de guards: G-KNOW-INDEX ainda aceita
substring no `grep -Fq` e ponteiro morto no INDEX; G-FRONTDOOR tem teto por
linhas, nao por bytes, conta itens por marcador/espaco conhecido e nao verifica
existencia dos paths da read-list. Proxima acao: implementar area temporaria
P-CAND-04 (`/scratch/` + guards G-SCRATCH-LOCK/SYMLINK/IGNORE).
