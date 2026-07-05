---
titulo: Auditoria cruzada definitiva - ponte HBN, exuvia e enforcement do orquestrador
tipo: result
temperatura: glacier
arvore: fronteira
path: .hbn/results/20260630-194338-codex-cross-ia-ponte-diagnostico-exuvia.md
status: congelado
---
SOU: codex · familia OpenAI · papel auditor

# Auditoria cruzada definitiva - ponte do protocolo HBN + desenho da exuvia + guards que bloqueiam o orquestrador

Nota de conformidade com o disco: o prompt desta auditoria pediu a forma `SOU: <fornecedor> · <apelido> · familia <Familia> · papel auditor`, mas o guard real `guards/assert-auditor-id.sh:127` aceita somente `SOU: <apelido> · familia <Familia> · papel auditor`. Para que este parecer seja evidencia validavel por guard, usei a forma canonica do guard. Divergencia registrada, sem alterar guard.

## (A) DIAGNOSTICO

A causa-raiz nao e ausencia de regras; e deslocamento entre regras documentadas e pontos de enforcement. O protocolo declara objetivo de engenharia assistida por IA segura, estruturada e evoluivel, preservando controle humano (`core/protocol.md:5-15`), e explicita fronteiras negativas: nao define hidden background processing nem autonomous system control (`core/protocol.md:27-36`). O papel do orquestrador tambem esta escrito: verifica no disco antes de afirmar (`core/orchestrator-profile-spec.md:28-30`), nao implementa nem audita a si mesmo (`core/orchestrator-profile-spec.md:120-123`), e deve obedecer exatamente ao `proximo_ponto` do STATE (`.hbn/knowledge/0029-lei-submissao-pelo-exemplo.md:17`). Mas o proprio contrato admite que parte disso e "doutrina-sem-enforcement, backlog" (`core/orchestrator-profile-spec.md:153-159`).

O enforcement hoje age majoritariamente na fronteira de commit. O runner do protocolo lista guards de pre-commit em `guards/hbn-guards-runner.sh:83-116`. O `G-QUORUM` so dispara para readbacks adicionados com `status="vigente"`; se o readback novo nao e selagem, "o guard nao opina" (`guards/assert-quorum-selagem.sh:6-9`) e o codigo sai em `status != "vigente"` (`guards/assert-quorum-selagem.sh:198-200`). Portanto, um repoint de `STATE.md` pode ser tratado como entrega ou registro, passar por guards, e ainda assim mudar a esteira sem duas familias independentes.

A evidencia recente confirma a brecha. No protocolo, as ondas 0103, 0104 e 0105 mudam o STATE e repontam `proxima_acao`, mas seus readbacks declaram `status: "entregue"` (`.hbn/readbacks/0103-onda-repoint-state-p2c.json:7`, `.hbn/readbacks/0104-onda-repoint-state-p2c-fechado.json:7`, `.hbn/readbacks/0105-onda-repoint-state-p2c2-fechado.json:7`) e dizem explicitamente "Sem seals_proposal" enquanto invocam "Ato de autoridade sob G-ORQ-REF (Exit A')" (`0103:13`, `0104:13`, `0105:13`). O `REGISTRY.md:1581-1586` registra despachos/readbacks 0103-0105, mas nao registra pareceres 0103-0105 anteriores. Assim, houve avanco estrutural de roadmap sem o mesmo quorom que seria exigido para selagem.

No Credenciamento, a ponte material existe: branch correta, `.hbn/active-version=.` e `.usehbn-snapshot/VERSION=v1-estavel`; o manifesto tem 137 arquivos. O perfil do consumidor declara a superficie `core methodology schemas guards` e lista guards de projeto versus guards de genoma excluidos (`.usehbn-snapshot/CONSUMER-PROFILE.md:2-5`). O runner project-mode real roda integridade da membrana e 7 guards bloqueantes (`scripts/hbn-guards/hbn-guards-runner.sh:18-20`), embora o perfil documente uma lista maior. Os commits 0179, 0180, 0181 e 0183 tem readbacks confirmados e escopos claros, mas nao ha `.hbn/results/*0179*`, `*0180*`, `*0181*` ou `*0183*` no projeto. O 0183 move 88 arquivos com `R100`, preservando conteudo, mas ainda e mudanca estrutural relevante (`.hbn/readbacks/0183-rb-p2d2-untangle.json:12-18`, `48-52`).

Documentacao falhou por meses porque o modelo que precisa obedecer tambem controla a narracao da obediencia. Regras como "1 comando = 1 bloco" existem (`.hbn/knowledge/0001-comandos-atomicos-copiaveis.md:11-15`) e o proprio repositorio registra violacoes repetidas pelo orquestrador de regras ja aceitas (`docs/brainstorm/principios-candidatos.md:65-68`). O problema nao e linguagem ambigua; e que o chat/agente nao tem interceptador externo antes da acao. `assert-orq-entrada.sh` prova hashes de read-list no commit, nao bloqueia uma resposta de chat antes de ferramenta/acao. `G-COPY` valida despachos/prompts novos em disco (`guards/assert-copy-block.sh:6-8`), nao a saida ao humano em tempo real.

O risco para a ponte e para multiplos projetos e sistemico: se a ponte for usada como selo de seguranca, mas o orquestrador puder reescrever estado, runner, escopo ou roteiro sem quorum pre-acao, cada projeto consumidor herda uma membrana mecanicamente integra mas governada por uma esteira manipulavel. A ponte e tecnicamente util; como controle de governanca, esta fragil enquanto a fronteira do orquestrador depender de boa-fe do modelo.

## (B) MODELO DE ENFORCEMENT

Arquitetura recomendada: separar proposta, autorizacao e execucao em uma camada externa ao modelo. O orquestrador passa a ser um papel de desenho com privilegio minimo: pode escrever propostas/despachos em `ledger/messages` ou `outbox/`, mas nao executa Bash/Edit/Write direto em superficies criticas. Um executor nao-IA, ou um hook PreToolUse/Stop quando a plataforma oferecer, decide binariamente se a acao pode sair do chat para o mundo. Falha fechada: sem receipt, sem quorum, sem chave humana, sem classificacao de risco ou sem ledger, a acao nao roda.

### G-ORQ-CAP - matriz de capacidades do orquestrador

O que enforca: privilegio minimo por papel. Orquestrador desenha; implementador executa; humano opera gates. Base existente: `core/orchestrator-profile-spec.md:115-130` ja define artefatos proprios e veda codigo/guards/src/core spec de terceiros; a linha 129 declara `G-ACTOR-WRITE-MATRIX` ainda a construir.

Onde intercepta: capability scoping do agente e pre-commit. No agente, bloquear ferramentas de escrita/Bash/rm para perfil orquestrador; permitir somente leitura e escrita em `outbox/`/`ledger/messages/` conforme matriz. No repo, um guard `assert-actor-write-matrix.sh` valida diff staged por `agent_id`, `papel_bastao` e path.

Regra binaria: se `papel_bastao=orquestrador`, paths permitidos = propostas, despachos, state-report e outbox. Paths proibidos = `guards/**`, `src/**`, `schemas/**`, specs de terceiros, `.usehbn-snapshot/**`, runner de projeto, `STATE.md` exceto via pacote de autoridade com quorum. Fail-closed se papel, token ou matriz ausentes.

Caso positivo: orquestrador grava um despacho em `ledger/messages/` com `readback_alvo`, sem tocar codigo. Passa. Caso negativo: orquestrador altera `scripts/hbn-guards/hbn-guards-runner.sh` ou `guards/**`. Bloqueia. Burla adversarial: modelo se declara implementador no readback; o guard cruza `papel_bastao` no STATE, token FP e identidade da atestacao, e bloqueia divergencia.

### G-ORQ-FDACK - read-receipt verificado pre-acao

O que enforca: leitura obrigatoria real dos canones antes de qualquer acao. Base existente: `assert-orq-entrada.sh` ja computa hashes de read-list e desafios; `core/role-cards.md:5-12` define read-list minima; `docs/brainstorm/rodada-2026-06-16/A1-front-door-verificavel.md:38` desenha o G-FDACK, mas nao foi promovido. `docs/brainstorm/rodada-2026-06-17/SINTESE-PROFUNDA-pre-freeze.md:110` tambem deixou G-FDACK como R3/futuro.

Onde intercepta: PreToolUse/Stop do agente e executor de comandos. Antes de `bash`, `edit`, `rm`, `commit`, `git mv` ou qualquer saida operacional ao humano, o agente deve apresentar receipt em `ledger/fdack/<timestamp>-<agent>.json`.

Regra binaria: receipt deve conter nonce emitido pelo executor, lista de paths canonicos, sha256 dos blobs atuais, respostas extrativas de linhas exigidas, `agent_id`, `papel`, `token_fp` e expiracao curta. O executor recomputa tudo do disco. Se nonce expirou, hash diverge, path ausente ou resposta nao bate, bloqueia.

Caso positivo: antes de P2-D, orquestrador le STATE, readback ativo, 0029, profile spec, proposta ponte e exuvia fitness, grava receipt valido, e so entao emite proposta. Caso negativo: tenta agir por memoria de chat, sem receipt. Bloqueia. Burla adversarial: copia receipt antigo; nonce/expiracao/hash do STATE novo invalidam.

### G-ORQ-STATE-AUTH - STATE e proximo_ponto como superficie critica

O que enforca: nenhum repoint estrutural de `STATE.md` como entrega comum. Base existente: `assert-next-checkpoint.sh` valida forma do `proximo_ponto` quando STATE muda (`guards/assert-next-checkpoint.sh:7-9`, `89-92`), mas nao exige quorum para mudar a direcao. `G-QUORUM` exige quorum somente em selagem (`guards/assert-quorum-selagem.sh:6-9`).

Onde intercepta: pre-commit e executor. Qualquer A/M em `.hbn/relay/STATE.md` passa por este guard.

Regra binaria: se `STATE.md` muda `proxima_acao`, `proximo_ponto`, `onda_atual`, `readback_ativo` ou campos de bastao, o mesmo pacote precisa ter classe `authority_change`, dois pareceres `audit-pre` de familias != implementador e != orquestrador quando possivel, e hearback humano. Repoints "registro, nao selagem" nao dispensam quorum. Falha fechada se nao der para classificar a mudanca.

Caso positivo: selagem ou repoint com dois pareceres em `ledger/results/`, `human_status=confirmed`, receipt FDACK e diff limitado. Passa. Caso negativo: readback `status=entregue` altera `STATE.md` e diz "Sem seals_proposal". Bloqueia. Burla adversarial: mover o repoint para despacho em `.hbn/messages`; o guard calcula diff semantico do STATE, nao confia no texto.

### G-ORQ-XAUDIT-PRE - auditoria cruzada como pre-condicao inescapavel

O que enforca: nenhuma acao critica sem quorum antes da acao, nao depois. Base existente: `assert-auditor-id.sh`, `assert-audit-diversity.sh` e `assert-quorum-selagem.sh` validam identidade/diversidade/quorum em commits; os criterios de exuvia exigem C-XAUDIT (`core/exuvia-fitness-criteria.md:81`).

Onde intercepta: executor de acoes criticas e pre-commit. O executor avalia `risk_class` do pacote de acao; se for critica, exige duas chaves de auditoria e chave humana.

Regra binaria: critica = tocar `STATE`, guards, runner, schemas, specs, `.usehbn-snapshot`, deletar/mover >N arquivos, promover guard a bloqueante, instalar/upgrade de membrana, freeze, tag, branch protection ou qualquer delete em material unico. Exige >=2 pareceres de familias distintas, com `APROVA_<id>: SIM`, anteriores ao commit/acao, mais hearback humano. Fail-closed se familias nao resolvidas no mapa.

Caso positivo: alteracao de runner project-mode com dois pareceres previos e hearback. Passa. Caso negativo: reescrever runner com apenas readback humano. Bloqueia. Burla adversarial: chamar "limpeza" ou "untangle" para evitar classe critica; classificador mecanico olha diff: renames/deletes/paths criticos.

### G-ORQ-NO-DELETE - delecao e move estrutural com prova de preservacao

O que enforca: "nao apagar unico as cegas". Base existente: `forbid-legacy-paths.sh` e politica de exuvia recomendam `git mv`, nao `cp`, e preservacao antes de transformar (`core/hbn-exuvia-scaffold.md:83-93`; `docs/brainstorm/.../02-mapa-migracao-genoma-autocontido.md:290-337`).

Onde intercepta: PreToolUse para `rm`, `git rm`, `mv`, `git mv`; pre-commit por diff-filter D/R.

Regra binaria: delete/move em superficie governada exige `deletion_manifest.json` com: origem, destino ou sucessor, sha256, prova de redundancia ou preservacao, pareceres >=2 familias, hearback humano e rollback. Delecao sem sucessor de documento unico e bloqueio absoluto. Fail-closed para glob amplo, wildcard, path fora da raiz ou manifesto ausente.

Caso positivo: `git mv usehbn/radar/** docs/reference/radar/**` com R100, manifesto e escopo. Passa. Caso negativo: deletar 20 modulos unicos sem destino. Bloqueia. Burla adversarial: apagar por script que remove diretorio inteiro; PreToolUse bloqueia comando e pre-commit bloqueia D/R sem manifesto.

### G-ORQ-CHAT-COPY - saida operacional de chat

O que enforca: 1 comando por bloco e comentario fora do bloco antes de chegar ao humano. Base existente: `knowledge 0001` define a regra (`.hbn/knowledge/0001-comandos-atomicos-copiaveis.md:11-18`) e `G-COPY` valida artefatos novos em disco (`guards/assert-copy-block.sh:100-156`), mas nao a resposta de chat.

Onde intercepta: Stop hook do agente, antes de renderizar ao humano.

Regra binaria: qualquer resposta com comando operacional deve ter no maximo um comando por bloco, sem comentario inline no bloco, sem cadeia de multiplos comandos se o destino for humano. Se contiver `rm`, `git reset`, `git checkout --`, `git push --force`, `chmod -R`, `mv` estrutural ou wildcard destrutivo, exige autorizacao auditada ou bloqueia. Fail-closed quando parser nao consegue separar comandos.

Caso positivo: texto explica e um bloco contem um unico comando. Caso negativo: bloco com `cd && bash ... && git commit`. Bloqueia. Burla adversarial: esconder comando em markdown sem fence; detector varre padroes shell e exige fence/ato.

### G-ORQ-TRIPWIRE - perda de bastao e congelamento

O que enforca: consequencia automatica. Base existente: `assert-baton-token.sh`, atestacoes `orq_entrada` e STATE com `bastao_token_sha256`; `knowledge 0029:19` manda parar se guard bloqueia.

Onde intercepta: qualquer hook acima e runner. Ao detectar violacao, grava `ledger/incidents/<id>.json`, marca o bastao como suspenso e exige reautorizacao humana.

Regra binaria: violacao de FDACK, tentativa de delecao sem manifesto, acao critica sem quorum, bypass nao autorizado ou mentira de papel revoga o token. Fail-closed: enquanto incidente aberto existir, executor recusa novas acoes do orquestrador.

Caso positivo: guard bloqueia por engano, humano registra hearback de reautorizacao e fecha incidente. Caso negativo: orquestrador tenta repetir a mesma acao bloqueada. Bloqueia e mantem bastao suspenso. Burla adversarial: trocar de janela/modelo; o executor olha token e incidentes no disco, nao memoria da janela.

Composicao: G-ORQ-CAP reduz superficie; G-ORQ-FDACK garante leitura; G-ORQ-STATE-AUTH e G-ORQ-XAUDIT-PRE fecham a brecha "entregue sem quorum"; G-ORQ-NO-DELETE protege conhecimento unico; G-ORQ-CHAT-COPY cobre a saida ao humano; G-ORQ-TRIPWIRE da consequencia. Todos devem ter C-TEST positivo/negativo, C-ADV com burla, C-DOG na propria adocao, C-FCLOSE, C-NOREG, C-TRACE e C-XAUDIT antes de sobreviverem a exuvia.

## (C) EXUVIA - NOVA HIERARQUIA

Arvore final recomendada:

```text
/
├── README.md
├── LICENSE
├── AGENTS.md
├── REGISTRY.md
├── CHANGELOG.md
├── pyproject.toml / setup.*
├── .github/
├── spec/
│   ├── INDEX.md
│   ├── protocol.md
│   ├── command-spec.md
│   ├── dispatch-spec.md
│   ├── readback-spec.md
│   ├── relay-spec.md
│   ├── freeze-gate-spec.md
│   ├── orchestrator-profile-spec.md
│   ├── role-cards.md
│   ├── roles-assignment-spec.md
│   ├── exuvia-fitness-criteria.md
│   └── hbn-exuvia-scaffold.md
├── methodology/
│   ├── PRINCIPIOS-CONSTITUCIONAIS.md
│   ├── MATURITY-MATRIX.md
│   ├── ADR-AND-MD-PRIMER.md
│   ├── modules/
│   │   ├── phagocytosis.md
│   │   ├── consent-capsules.md
│   │   ├── cross-audit.md
│   │   ├── inter-ai-coordination.md
│   │   ├── markers.md
│   │   ├── radar.md
│   │   ├── security.md
│   │   └── index.md
│   ├── adr/
│   └── templates/
├── docs/
│   ├── INDEX.md
│   ├── product/
│   ├── integrations/
│   ├── guides/
│   ├── prompts/
│   ├── rfc/
│   ├── feynman/
│   └── brainstorm/
├── knowledge/
├── ledger/              # conceitual; pode permanecer fisicamente .hbn/ se decisao humana preferir compatibilidade
│   ├── messages/
│   ├── dispatch/
│   ├── readbacks/
│   ├── hearbacks/
│   ├── results/
│   ├── incidents/
│   ├── fdack/
│   ├── proposals/
│   ├── queue/
│   ├── models/
│   └── relay/STATE.md
├── guards/
│   ├── enforcement/
│   │   ├── assert-orq-cap.sh
│   │   ├── assert-orq-fdack.sh
│   │   ├── assert-orq-state-auth.sh
│   │   ├── assert-orq-xaudit-pre.sh
│   │   ├── assert-orq-no-delete.sh
│   │   ├── assert-orq-chat-copy.sh
│   │   └── assert-orq-tripwire.sh
│   ├── tests/
│   └── hook-shims/
├── schemas/
├── src/usehbn/
├── tests/
├── reports/
├── inbox/
├── scratch/
└── examples/
```

Migracao: `core/` vira `spec/`, conforme a arvore ja proposta em `docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/01-estrutura-pastas-e-documentacao.md:158-162`. `methodology/` permanece para principios, maturidade, ADRs e templates (`01-estrutura...:163-167`). `.hbn/knowledge/` vira `knowledge/` ou permanece fisicamente `.hbn/knowledge/` com ponte conceitual; o ponto e manter INDEX vivo e read-list. `.hbn/` vira `ledger/` apenas se a compatibilidade dos guards for atualizada; caso contrario, manter `.hbn/` e documentar "ledger = .hbn" para nao quebrar runtime. `guards/`, `schemas/` e `src/` migram com testes.

Nada unico deve ser descartado. O descarte permitido e apenas de duplicata provada ou artefato gerado/redundante, com manifesto de redundancia. O antigo `Credenciamento/usehbn/modules` ainda existe no disco apos 0183 com 8 arquivos: `AUDITORIA-CRUZADA.md`, `CAPSULAS-DE-CONSENTIMENTO.md`, `COORDENACAO-INTER-IA.md`, `FAGOCITOSE.md`, `INDEX.md`, `MARCADORES.md`, `RADAR.md`, `SEGURANCA.md`. Destino: incorporar em `methodology/modules/` apos comparacao com docs canonicos existentes, nunca apagar. Exemplos: `FAGOCITOSE.md` deve reconciliar com `docs/PHAGOCYTOSIS.md`, que define estagios e limites (`docs/PHAGOCYTOSIS.md:25-39`, `40-45`, `193-205`); `CAPSULAS-DE-CONSENTIMENTO.md` deve reconciliar com `src/usehbn/protocol/consent.py` e docs de validacao humana; `AUDITORIA-CRUZADA.md` deve fundir com ADR-018/020/022/023 e guards de auditoria; `MARCADORES.md` com ADR-006 e runtime markers; `SEGURANCA.md` com ADR-019, `SECURITY.md` e firewall 0022; `RADAR.md` com radar/fagocitose; `COORDENACAO-INTER-IA.md` com relay/role specs. Se uma parte for redundante, registrar paragrafo e hash de origem em apendice de auditoria.

Os 12 arquivos remanescentes de `Credenciamento/usehbn/methodology` tambem nao devem ser deletados: devem ser triados para `methodology/`, `docs/brainstorm/arquivo-historico/` ou `reports/`, com prova de destino. O readback 0183 explicitou que `usehbn/methodology` e `usehbn/modules` ficaram intocados (`.hbn/readbacks/0183-rb-p2d2-untangle.json:14-16`, `48-52`), portanto a proxima onda nao pode usar "untangle anterior" como autorizacao para apagar.

Ponteiros quebraveis a resolver antes do corte: AGENTS.md apontando para topologia antiga e paths absolutos (`docs/brainstorm/.../02-mapa-migracao-genoma-autocontido.md:165-175`), ADR-003 ainda descrevendo `core/->modules` antigo (`02-mapa...:151-155`), referencias a `Credenciamento/` em runtime (`02-mapa...:157-163`) e `forbidden-paths` ausente/desarmado (`02-mapa...:306-313`). A regra de preservacao e `git mv`, nao `cp`, como o scaffold diz (`core/hbn-exuvia-scaffold.md:83-93`).

Decisoes pendentes, binariamente:

- Re-prova estrita vs proporcional: para guards/enforcement e mudancas de esteira, re-prova estrita 7/7 C-TEST a C-TRACE; para docs frios sem runtime, rito proporcional, mas com manifesto de preservacao.
- Estavel exige Rust? Nao. Rust pode ser criterio futuro de implementacao robusta, mas v1-estavel/exuvia exige guards e testes verdes, nao linguagem especifica.
- Modo solo: permitido apenas para desenvolvimento local nao-critico; qualquer acao critica volta ao quorum pre-acao.
- Nome do evento de transicao: usar `exuvia-protocol-0.3-to-1.0` ou equivalente com tag anti-GC `hbn-exuvia/protocol-0.3.x` (`core/hbn-exuvia-scaffold.md:73-81`).
- Despromocao append-only P6: sim, despromocao nunca apaga; registra superseded_by, path antigo read-only e sucessor.

## (D) ROADMAP + PLANO DE EXECUCAO ATE O FIM

Regra global: cada passo tem dois gates antes de acao critica: (1) auditoria cruzada por >=2 familias distintas do implementador/orquestrador quando possivel; (2) gate humano explicito. Construir e selar os guards de enforcement do orquestrador E pre-requisito do fitness gate da exuvia.

1. Finalizar e congelar o protocolo.
Objetivo: fechar a lacuna de enforcement do orquestrador antes de qualquer nova mudanca estrutural. Artefatos: guards G-ORQ-CAP, G-ORQ-FDACK, G-ORQ-STATE-AUTH, G-ORQ-XAUDIT-PRE, G-ORQ-NO-DELETE, G-ORQ-CHAT-COPY, G-ORQ-TRIPWIRE; schemas de receipt/incidente/deletion_manifest; testes positivos, negativos e adversariais; docs em `spec/`/`guards/README`. Gate 1: duas familias nao implementadoras aprovam C-TEST/C-ADV/C-FCLOSE/C-DOG. Gate 2: Maurício autoriza ativacao. Pronto: runner verde, bateria adversarial estendida verde, dogfood em um repoint controlado que sem quorum bloquearia. Rollback: desativar hooks novos por revert de commit selado e restaurar bastao anterior com incidente fechado por humano.

2. Ponte aplicada ao Credenciamento.
Objetivo: manter a membrana `v1-estavel` integra e completar P2-D sem apagar unico. Artefatos: `assert-snapshot-integrity` verde, runner project-mode reconciliado com o perfil (decidir se 7 ou 16 guards bloqueantes), router em AGENTS, tombstone do espelho legado, manifesto dos remanescentes `usehbn/methodology` e `usehbn/modules`, plano de incorporacao. Gate 1: duas familias auditam o diff e confirmam que nenhum modulo unico foi perdido. Gate 2: humano aprova tombstone e destino dos remanescentes. Pronto: `.usehbn-snapshot` intacto, refs vivas corrigidas, runner verde, nenhum path antigo enganoso no AGENTS. Rollback: tag/commit anterior do projeto, reversao por `git revert` dos commits P2-D, snapshot permanece read-only.

3. Validar tela a tela / ponta a ponta do Credenciamento.
Objetivo: provar que a governanca nao quebrou o app de dominio. Artefatos: roteiro tela a tela, evidencias de PDF/Excel, resultados de guards, logs de validacao, lista de regressao. Gate 1: duas familias revisam evidencias funcionais e de governanca. Gate 2: humano valida os fluxos criticos. Pronto: criterios V206/V12.0.0206 aplicaveis verdes, sem bypass, pendencias classificadas. Rollback: manter versao anterior do workbook/app e reverter somente commits de governanca que causaram regressao comprovada.

4. Exuvia do protocolo.
Objetivo: mover do exoesqueleto atual para a nova hierarquia sem perder memoria imunologica. Artefatos: nova arvore, mapa de migracao, manifesto de todos os moves, `forbidden-paths` populado para casca antiga, AGENTS reescrito, read-list nova, guards version-aware, bateria adversarial transferida. Gate 1: duas familias auditam equivalencia funcional, ponteiros, C-TEST/C-ADV/C-FCLOSE/C-NOREG e preservacao de unicos. Gate 2: humano autoriza corte e tag anti-GC. Pronto: nova versao ativa por `.hbn/active-version`, runner verde, testes e bateria verdes, nenhum ponteiro runtime para casca antiga, enforcement do orquestrador selado. Rollback: `scripts/hbn-exuvia-rollback.sh --apply` somente pelo operador, reconciliando token/STATE conforme scaffold (`core/hbn-exuvia-scaffold.md:60-81`).

5. Validar e congelar o app.
Objetivo: congelar a versao limpa do Credenciamento sob protocolo ja reforcado. Artefatos: freeze checklist do app, evidencias tela a tela, PDFs, pareceres, tag de release, changelog. Gate 1: duas familias auditam release e ausencia de regressao. Gate 2: humano roda/autoriza freeze. Pronto: freeze-gate do app exit 0, tag, rollback documentado, nenhum bypass. Rollback: tag anterior e plano de restauracao de workbook/dados.

6. Decidir v207 limpa.
Objetivo: escolher se a v207 merece exuvia/refatoracao estrutural do app. Artefatos: proposta de arquitetura, alternativas consideradas, custo/risco, criterios de pronto, plano de dual-run/caracterizacao. Gate 1: duas familias divergem/convergem sobre premissas. Gate 2: humano decide binariamente: iniciar ou nao. Pronto: decisao registrada, sem comecar refatoracao antes da autorizacao. Rollback: nao ha rollback se nao iniciar; se iniciar, cada sub-onda tem rollback proprio.

## (E) RISCOS E DIVERGENCIAS

Discordo de tratar "orquestrador sem maos" como solucao unica. Ela e forte e implementavel quando a plataforma permite capability scoping, mas sozinha cria gargalo e pode empurrar a execucao para outro agente igualmente livre. A versao correta e composicional: orquestrador sem maos para superficies criticas, executor nao-IA para gates, e permissao leve para escrita de propostas/relatorios.

O firewall de saida e a alternativa mais importante. Sem PreToolUse/Stop real, ainda resta pre-commit, mas pre-commit chega tarde para chat e para escrita fora de git. Se Claude Code/Cursor permitirem hooks por ferramenta, use-os. Se nao permitirem, rodar o orquestrador em wrapper local que exponha somente comandos autorizados.

Leitura obrigatoria por hash e implementavel, mas nao deve virar teatro de "resuma o que leu". Precisa de nonce, hashes recomputados, perguntas extrativas e expiracao curta. `assert-orq-entrada.sh` e base, nao solucao completa.

Quorum de duas chaves no executor e obrigatorio para acao critica; nao deve valer para typo, doc fria ou ajuste trivial. A classificacao mecanica precisa olhar paths e diff, nao confiar no titulo da onda.

Tripwire e necessario, mas perigoso se qualquer falso positivo paralisar tudo. O desenho correto e congelar somente o bastao/orquestrador, permitindo leitura e auditoria, e exigir fechamento humano do incidente para reativar.

Armadilhas principais: (1) chamar repoint de "registro" para escapar do `G-QUORUM`; (2) mover/deletar conteudo unico sob nome de untangle; (3) manter runner de projeto divergente do perfil documentado; (4) deixar AGENTS apontar para paths mortos; (5) transformar a exuvia em limpeza cosmetica sem enforcement novo; (6) confiar em pareceres depositados depois da acao como se fossem pre-condicao.

O humano precisa decidir agora: se o orquestrador deve perder Bash/Edit por padrao; se `.hbn/` muda fisicamente para `ledger/` ou fica como nome compativel; se runner do Credenciamento deve bloquear 7 ou todos os 16 guards do perfil; qual limiar torna uma acao critica; e se os modulos remanescentes do espelho antigo entram no protocolo agora ou ficam preservados em tombstone ate onda propria.

VEREDITO_PONTE: FRAGIL — a membrana e os guards de commit funcionam como integridade de snapshot, mas a fronteira do orquestrador ainda permite repoints e mudancas estruturais sem quorum pre-acao; antes da exuvia e de multiplos projetos consumidores, essa lacuna precisa ser fechada por enforcement externo ao modelo.
