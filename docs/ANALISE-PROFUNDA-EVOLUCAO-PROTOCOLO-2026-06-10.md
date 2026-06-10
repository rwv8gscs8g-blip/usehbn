---
titulo: Análise profunda fundacional — evolução do protocolo useHBN
diataxis: explanation
hbn-track: knowledge
hbn-status: proposed
audiencia: humano (Mauricio) + IAs orquestradoras (Opus/Cowork)
data: 2026-06-10
autor: Claude Fable 5 (janela limpa, reconstrução por Read)
gatilho: onda 0177 do Credenciamento — Codex pausou e passou o bastão para melhoria do protocolo
escopo: PLANO PROTOCOLO somente — nenhum projeto consumidor foi editado
---

# Análise profunda — como evoluir o useHBN sem perder o que ele já conquistou

> Tudo o que está afirmado aqui foi reconstruído por leitura direta de arquivo
> nesta sessão (2026-06-10). Onde a evidência não existe no repositório, está
> marcado como **hipótese, não verificado**. Números de linha citados são da
> leitura desta data.

---

## 1. Como o protocolo realmente funciona hoje — a história, do intent ao commit

### 1.1 O desenho no papel

O useHBN canônico (`~/Projetos/usehbn`) descreve um pipeline de 9 etapas —
ativação → intent → truth barrier → guardian → classificação de track →
readback → hearback → execução → ERP (`README.md:333-347`) — sustentado por
13 princípios constitucionais (`methodology/PRINCIPIOS-CONSTITUCIONAIS.md`),
10 ADRs (`methodology/adr/INDEX.md`), 8 schemas JSON (`schemas/`), um runtime
Python com 182 testes verdes (CHANGELOG `Unreleased 2026-05-13`) e uma matriz
de maturidade brutalmente honesta (`methodology/MATURITY-MATRIX.md`) que
proíbe qualquer doc público de prometer acima do implementado.

### 1.2 Como uma onda vive de verdade (evidência: Credenciamento, onda 0177)

A prática real acontece no Credenciamento, e ela é mais sofisticada do que o
canônico descreve. A onda 0177 (2026-06-10, 01:10) é o retrato perfeito:

1. O Codex implementou a onda 38.2.43 (avisos em duas linhas nos relatórios),
   registrou readback `0177-rb-*.json`, hearback confirmado, ERP `0177-exec-*.json`.
2. Ao atingir o gatilho de transferência, escreveu um handoff de **16 seções**
   (`Credenciamento/.hbn/messages/20260610-0110-handoff-fim-sessao-codex-bastao-codex-para-opus.md`),
   incluindo checklist anti-viés de bastão (§15: "Auto-indicacao: nao"),
   prompt de entrada do sucessor (§16) e comando único de validação (§11).
3. Atualizou `.hbn/relay/INDEX.md` e depositou uma proposta de evolução do
   protocolo (`.hbn/protocol-evolutions/20260610-usehbn-passagem-bastao-documentacao-cross-audit.md`).
4. O pre-commit com guards executáveis (`scripts/hbn-guards/` — 11 scripts:
   raiz canônica, proibição de /tmp, scope-lock, validação de readback por
   schema) validou tudo mecanicamente; desde a onda 0116 existe CI de
   governança em modo ratchet (`AGENTS.md:146-149`).

**Onde ele brilha.** Os dois incidentes P0 de "pasta errada" (02/05 e 24/05,
documentados em `auditoria/00_status/32_*` e `98_*`, citados em
`ANALISE_FLUXO_IA_2026-05-24.md:11-14`) não se repetiram depois da Onda 36 —
a regra textual virou guard que recusa o commit. O handoff 0177 é um artefato
de orquestração entre IAs que poucas equipes humanas produzem. A cultura de
honestidade (Maturity Matrix, Truth Barrier) impede a inflação de promessa
que a revisão de abril (`HBN-ARCHITECTURAL-REVIEW-2026-04.md`, F-01/F-02)
apontou como risco de colapso de credibilidade. As regressões caíram porque o
protocolo trocou checklist por airbag (`ANALISE_FLUXO_IA:259`).

**Onde ele sangra.** Quatro hemorragias, todas mensuráveis:

- **Retomada cara.** O `AGENTS.md` do Credenciamento exige ler 16 itens antes
  de tocar qualquer coisa (`AGENTS.md:100-123`). Só o `.hbn/relay/INDEX.md`
  tem **2.162 linhas / ~178 KB** (medido). A read-list completa soma
  ~250-300 KB. A knowledge 0017 manda entregar o bastão aos 50% da janela com
  orçamento 50/30/20 (`0017:24-36`) — mas a retomada consome uma fatia grande
  da primeira metade antes de qualquer trabalho substantivo. O bastão é rico
  na entrega e caríssimo na recepção.
- **O canônico congelou.** Último commit do `usehbn`: **2026-05-13** (git log,
  medido). O relay interno do `usehbn` está parado em **2026-04-29**
  (`usehbn/.hbn/relay/INDEX.md:4-5`). Enquanto isso o protocolo real evoluiu
  *dentro do Credenciamento*: knowledges 0013-0022, guards, CI, e os schemas
  `hearback.schema.json`, `audit-pre.schema.json`, `audit-post.schema.json`
  existem em `Credenciamento/.hbn/schemas/` e **não existem** em
  `usehbn/schemas/` (medido, ls de ambos). A doutrina viva mora no consumidor.
- **Documentação sem faxina.** `auditoria/` do Credenciamento: **407 .md /
  37 MB** (medido hoje; a contagem flutua perto dos ~471 relatados).
  CHANGELOG: **1.727 linhas / ~105 KB** (medido). Colisão `0014×0014` na
  knowledge base confirmada (dois arquivos `0014-protocolo-fim-de-sessao.md`
  e `0014-protocolo-reprovacao-onda.md`), pendente desde que virou item F4 do
  backlog do arquiteto (`PROMPT_ARQUITETO:174`).
- **A própria onda 0177 diagnostica:** "o relay concentra muito estado
  historico e fica dificil distinguir 'proxima acao' de 'memoria antiga';
  prompts de auditoria cruzada sao preparados de forma ad hoc"
  (`protocol-evolutions/20260610-usehbn-*.md:15-19`).

### 1.3 As quatro casas do protocolo (o estado real da fronteira)

Hoje o protocolo mora em **quatro lugares simultâneos**:

| Casa | Estado | Evidência |
|---|---|---|
| `~/Projetos/usehbn` (canônico) | Congelado desde 2026-05-13; runtime Python + 8 schemas; sem os schemas novos | git log; `schemas/` |
| `Credenciamento/.hbn` + `scripts/hbn-guards/` | **Vivo** — onde o protocolo de fato evolui (0013-0022, guards, CI, 3 schemas a mais) | `.hbn/knowledge/`, `.hbn/schemas/` |
| `~/Projetos/PROMPT_ARQUITETO_USEHBN_AUTONOMO.md` | v1.6, 829 linhas, **fora de qualquer repositório git** | path raiz de Projetos |
| `Credenciamento/usehbn/` (cópia divergente) | Congelada em 2026-05-24; contém `radar/`, `study-plans/`, `modules/` que **não existem no canônico**; pasta normal, não submódulo | ls medido; sem `.gitmodules` |

O ADR-002 (tipologia founding/consuming) e o ADR-008 (snapshot read-only)
previram exatamente a separação — mas o ADR-008 está **NÃO_RATIFICAR,
bloqueado "até v204 final"** (`methodology/adr/INDEX.md:28`). A v204 acabou
há muito: a V205 é a release oficial congelada desde 2026-05-23
(`Credenciamento/AGENTS.md:139-141`) e a V206 está em validação. O gatilho
apodreceu e ninguém tinha a responsabilidade de reabrir a decisão.

---

## 2. Diagnóstico de causa-raiz — os 7 problemas

### P1 — Orquestração / passagem de bastão: por que ainda perde contexto

O sintoma é retomada cara e sobreposição. A causa-raiz é que **o bastão
transfere narrativa, não estado tipado mínimo**. O relay INDEX é
simultaneamente log histórico (44 ondas registradas) e ponteiro de "próxima
ação" — 178 KB onde deveriam bastar 80 linhas. O handoff 0177 tem 16 seções
excelentes, mas não tem schema executável (a própria evolução 0177 pede
`handoff.schema.json` como "validacao futura desejavel" —
`protocol-evolutions/20260610:90-93`). E a read-list do `AGENTS.md` cresceu
por acreção: cada knowledge nova virou item obrigatório de leitura, sem nunca
remover nada. Resultado: o sucessor paga ~300 KB para reconstruir o que um
snapshot de estado de 30 KB carregaria. A sobreposição (Codex querendo
corrigir antes de consolidar pareceres — `protocol-evolutions/20260610:20`)
nasce do mesmo defeito: sem um arquivo de estado único e curto declarando
"quem faz o quê agora", cada IA infere o próprio papel a partir do histórico.

### P2 — Inchaço documental: onde a informação se aloja e se perde

Causa-raiz: **o protocolo tem doutrina de preservação (P1, P7 append-only)
mas não tem doutrina de temperatura**. Tudo o que já foi escrito permanece no
mesmo plano de visibilidade que o que está vigente. Não existe distinção
executável entre *vivo* (regra de negócio, segurança, estado atual) e *frio*
(histórico de releases fechadas, auditorias consumidas, ondas arquivadas).
As consequências: 407 .md em `auditoria/`, CHANGELOG de 105 KB que nenhuma IA
consegue ler inteiro com proveito, duas vaults Obsidian ("um cemitério com
fachada de dashboard" — `ANALISE_FLUXO_IA:55`), e um RAG recomendado na
análise de 24/05 (`ANALISE_FLUXO_IA:200`) do qual **não encontrei nenhuma
implementação nos repositórios** (a falha do RAG é relato do operador;
hipótese, não verificado em arquivo). Preservar história não exige mantê-la
no campo de visão: o timelessphoto resolve isso com
`cleanup-and-version.sh`, que move docs antigos para `docs/archive/old-docs/`
a cada versão (medido na varredura A3).

### P3 — Fronteira protocolo × projeto: por que a separação decidida não aconteceu

Três causas encadeadas. Primeira: **o gatilho do ADR-008 era um evento
externo sem dono** ("v204 final") — quando o evento passou, ninguém reabriu;
decisões bloqueadas não têm trigger de reavaliação no protocolo. Segunda:
**promover ao canônico custa mais do que evoluir localmente** — a Trilha E do
arquiteto (E1: migrar schemas; E2: migrar guards) está pendente desde a v1.0
do prompt (2026-05-24), porque cada promoção exige onda + readback + hearback
no repo canônico, enquanto escrever uma knowledge no Credenciamento é
imediato. A água corre para onde a fricção é menor. Terceira: o canônico
carrega **fricção própria desnecessária** — um runtime Python de 17
subcomandos cujo uso nas ondas reais do Credenciamento não deixou rastro
(os readbacks/ERPs do Credenciamento são arquivos escritos diretamente pelas
IAs conforme schema, validados por guards bash; **forte indício, não prova,
de que o CLI `hbn` não participa do fluxo real**). O protocolo-como-produto
(Python) e o protocolo-como-prática (markdown + schemas + guards) divergiram,
e a prática venceu.

### P4 — O arquiteto autônomo: por que acumula intenção em vez de gerar melhoria

O prompt v1.6 é um monólito de 829 linhas que mistura quatro coisas que
deveriam estar separadas: identidade/regras (estável), backlog (estado
mutável — trilhas A-G, `§4`), lições L27/L28 (knowledge) e a Cadência D
(§12, doutrina de orquestração). Causas-raiz concretas:

1. **O backlog vive dentro do prompt** — atualizar estado exige editar o
   próprio prompt (passo 7 do §3), o que exige onda com hearback, o que faz o
   estado apodrecer (A2 ficou marcada "pendente" por ciclos depois de
   entregue — corrigido só na v1.6, changelog do prompt).
2. **O ciclo de 6h produz readbacks, não deltas.** O desenho "propõe → pausa
   → espera hearback → próximo ciclo executa" (§5) significa que cada item
   custa no mínimo 12h de relógio e uma intervenção humana. Para mudanças
   normativas isso é correto; para faxina (F4, colisão 0014×0014, pendente há
   semanas) é cerimônia que não paga o custo.
3. **Ele opera na casa errada.** O pré-flight (§2) começa com
   `cd Credenciamento`; o sandbox Cowork não pode commitar conclusivamente
   (knowledge 0021), então o motor que deveria evoluir o protocolo trabalha
   no único lugar onde ele não tem mãos. Os resultados confirmam: trilhas B
   (4 itens), C (5), D (2), E (3) — **zero entregas**; entregas reais (A1-A3,
   G1) saíram de sessões manuais com Mauricio.
4. Em contraste, o **ciclo autoevolve de 2026-05-13 no canônico** entregou 16
   microdeltas commitados, testados e auditados em JSONL numa única janela
   (`.hbn/autoevolve/cycle-2026-05-13.jsonl`, ADR-010) — e nunca mais rodou
   (arquivo único; último commit do repo é o fechamento desse ciclo). O motor
   que funciona existe e está parado; o motor que roda a cada 6h não entrega.

### P5 — Controle humano + simplicidade + guard rails: onde a cerimônia não paga

A cerimônia hoje é **uniforme, não proporcional ao risco**. Uma onda
safe_track gera ≥7 artefatos (readback, hearback, ERP, doc técnico, relay
update, handoff, protocol-evolution). Existe severidade para *achados*
(BLOQUEADOR/FORTE/MARGINAL, §12.5) mas não para a *cerimônia em si* — o
fast_track existe, porém o firewall 0022 (correto!) só distingue
leitura×escrita, não escala o rito pelo risco da escrita. A própria proposta
0177 admite: "Risco: transformar cada microcorrecao em excesso de documento"
(`protocol-evolutions/20260610:97-99`). O ponto crucial: **as grades que
funcionam são as executáveis** (guards, schema validation, CI ratchet); a
cerimônia documental adicional protege pouco e custa muito. Endurecer = mais
guard executável; simplificar = menos artefato obrigatório por mudança de
baixo risco. As duas coisas não competem — são o mesmo movimento.

### P6 — O protocolo e a evolução das próprias IAs

Os números do modelo estão **hard-coded na doutrina**: "50% é o gatilho duro"
(0017:15-16), "contagem de turnos > 30" (0017:44), os 7 adapters são strings
de ~250 linhas (`MATURITY-MATRIX:67`). Quando chega um modelo com janela de
1M (esta sessão) ou um modo novo, a doutrina inteira fica descalibrada e a
única correção possível é editar N documentos. Causa-raiz: ausência de um
**perfil de capacidade por modelo** — um lugar único, paramétrico, que a
doutrina referencia ("handoff em `handoff_threshold` do perfil ativo") em vez
de embutir constantes.

### P7 — De intenção a software real

O que o timelessphoto prova (21 testes Playwright como portão de release,
medido na varredura) e a Onda 36 confirmou (guards) é que **regra que não
roda, não existe** (`ANALISE_FLUXO_IA:61-63`). O canônico ainda carrega o
desequilíbrio inverso apontado em abril (Risk 2, "scope expansion before
foundation hardening" — `HBN-ARCHITECTURAL-REVIEW:296-297`): Truth Barrier e
Guardian seguem advisory (`MATURITY-MATRIX:57-58`), enquanto a parte
executável que de fato protege (guards, schemas novos, CI) nasceu no
consumidor e nunca foi promovida. O caminho para "software de verdade" não é
terminar o Universal Translator — é **adotar como núcleo do produto
exatamente o que o Credenciamento já provou em produção**.

---

## 3. Insights de evolução — as 5 mudanças de maior alavancagem

### I1 — Cravar a fronteira: snapshot read-only + caixa de entrada por projeto

**O que muda.** Executar a separação já decidida (ADR-002/ADR-008),
atualizada: (a) re-depositar ADR-008 v2 com gatilho novo e datado; (b) a
máquina do protocolo sai do consumidor — `Credenciamento/usehbn/` vira
`.usehbn-snapshot/` read-only com checksum, após auditoria de diff da cópia
divergente (a matriz origem→destino MD-K já existe em
`usehbn/auditoria/00_status/08_MD_K_*`); (c) nasce no canônico a **caixa de
feedback por projeto**: `usehbn/inbox/<projeto>/AAAAMMDD-<slug>.md`, com ID
namespaced por projeto+data — o que elimina por construção colisões da
família `0014×0014` e permite N projetos alimentarem o protocolo sem disputar
numeração. O fluxo `.hbn/protocol-evolutions/` dos projetos passa a ter
destino: cada consolidação do arquiteto move (não copia) a proposta para o
inbox canônico.
**Por que destrava.** Mata a cópia divergente (vício 5 da análise de 24/05),
dá endereço único para a doutrina e transforma "promover ao canônico" de onda
cara em `git mv` barato.
**Risco e mitigação.** Perda de história da pasta legada → migração via
commit dedicado preservando hash, README de uma linha apontando o canônico
(exatamente o desenho do ADR-008 §2). Conteúdo do `radar/` é decisão parada
(Fagocitose) — migra como está, sem redesenho.

### I2 — Bastão 2.0: estado tipado mínimo, separado do log

**O que muda.** Três artefatos no canônico: (a) `core/relay-spec.md` v2
define `STATE` (arquivo único, ≤80 linhas, schema-validado: bastão, onda,
papel de cada IA, próxima ação, sinais abertos — nada de histórico) separado
de `LOG` (relay-archive, append-only, frio); (b) `schemas/handoff.schema.json`
formalizando os 16 itens que o 0014 + onda 0177 já praticam; (c) read-list de
retomada canônica de **4 itens**: STATE + handoff mais recente + readback
ativo + contrato do papel. Guard novo: handoff sem STATE atualizado é
recusado (o pedido literal da evolução 0177: "guard que recuse relay sem
proxima-acao atualizada").
**Por que destrava.** Retomada cai de ~300 KB para ~30 KB; o orçamento 50/30/20
da 0017 volta a fechar; sobreposição morre porque papéis estão declarados em
um único lugar vigente.
**Que fricção morre.** Os "prompts ad hoc" por papel: os prompts de entrada
§12.B1-B3 viram templates que leem o STATE — param de ser redigidos à mão a
cada bastão.
**Risco e mitigação.** STATE desatualizado vira mentira perigosa → é
exatamente por isso que o guard acopla handoff a STATE; e o STATE é curto
justamente para que atualizá-lo custe um parágrafo.

### I3 — Arquiteto autônomo 2.0: de acumulador de intenção a motor de deltas

**O que muda.** O prompt é refatorado em quatro peças, todas dentro do
canônico (versionadas, auditáveis): identidade+regras (curto, estável, em
`agents/architect-autonomous.md`), backlog como fila de arquivos
(`.hbn/queue/NNN-<tema>.json` com status próprio — estado sai do prompt),
knowledge (L27/L28 viram knowledges normais) e doutrina de orquestração
(Cadência D vai para `core/`). E o motor ganha **duas classes de mudança**:
- **Classe A — deltas pré-autorizados** (faxina, índices, renumeração,
  consolidação de inbox, arquivamento frio): executados e commitados *no
  próprio ciclo*, com trilha JSONL e orçamento de diff — é reusar a máquina
  autoevolve do ADR-010 que já provou funcionar em 13/05. Hearback humano
  **em lote** (revisão semanal com rollback fácil por commit atômico).
- **Classe B — mudanças normativas** (ADR, schema, princípio, guard):
  mantêm o rito atual — readback individual + hearback antes de executar.

Regra de ouro nova: **todo ciclo termina com exatamente 1 commit atômico ou
um no-op declarado** ("nada elegível na fila"). Acúmulo de intenção sem
entrega vira falha de protocolo mensurável.
**Por que destrava.** É o coração da auto-evolução: o ciclo de 6h passa a
produzir protocolo melhor de fato, e a faxina (F4 e afins) finalmente
acontece porque deixou de custar uma onda com hearback cada.
**Risco e mitigação.** "Aprovação automática enquanto o humano dorme" — já
mitigado no desenho do ADR-010: `HUMAN_GATE` por arquivo bloqueia a classe A
inteira a qualquer momento; classe B nunca executa sem hearback; nada de
domínio/VBA jamais (firewall 0022 intacto, restrições §8 mantidas).

### I4 — Cerimônia proporcional ao risco (tiers T0-T3)

**O que muda.** ADR novo define 4 tiers de mudança com rito mínimo por tier,
enforçado por guard de path: **T0** leitura/análise — nenhum artefato além do
output; **T1** doc não-normativo / protocolo frio — commit + 1 linha de
audit; **T2** normativo (schema, guard, ADR, knowledge) — readback + hearback;
**T3** código de domínio (VBA etc.) — cerimônia plena atual, firewall 0022,
humano aplica. Os guards já sabem distinguir paths (scope-lock); o tier é uma
tabela path→rito.
**Por que destrava.** Resolve a tensão do problema 5 sem afrouxar nada: T3
fica *mais* duro (nenhuma mudança), T0/T1 ficam radicalmente mais baratos. O
humano passa a ser chamado onde a decisão importa, e só ali — o que aumenta,
não diminui, o controle real.
**Risco e mitigação.** Classificação errada de tier → guard decide por path e
na dúvida promove para o tier acima; auditoria semanal da classe A revisa.

### I5 — Perfil de capacidade por modelo: a doutrina vira paramétrica

**O que muda.** `schemas/model-profile.schema.json` + `.hbn/models/<id>.json`
(janela de contexto, `handoff_threshold`, papéis aptos, modos disponíveis).
A knowledge 0017 e o §7 passam a referenciar o perfil ativo em vez de "50%";
adapters são gerados a partir do perfil (resolve também F-11 da revisão de
abril — o corpo monolítico de 250 linhas).
**Por que destrava.** É a resposta estrutural ao problema 6: quando chegar o
próximo modelo (janela maior, modo novo), incorpora-se 1 arquivo JSON, não
uma reescrita de doutrina. O threshold de 50% continua sendo o *default
conservador* — perfis só relaxam com hearback.
**Risco e mitigação.** Perfil otimista demais derruba a qualidade do handoff
→ mudança de perfil é tier T2 (hearback obrigatório) e os gatilhos
secundários da 0017 (turnos, sinais subjetivos) permanecem como rede.

---

## 4. O que aprender com o timelessphoto.art

O timelessphoto funciona com **1 arquivo de regras de 45 linhas**
(`docs/AI_RULES.md`, fonte única — não há AGENTS.md nem CLAUDE.md), **21
testes Playwright como portão de release** (`tests/e2e/shield/`, 5
categorias) e **2 scripts de ciclo de vida** (`create-release.sh`,
`scripts/cleanup-and-version.sh` — que versiona *e* faz faxina no mesmo ato:
move .md antigos para `docs/archive/old-docs/`, atualiza build-info, taggeia).
A retomada de uma IA ali custa ~2 KB de regras, não ~300 KB. (Honestidade:
a análise de 24/05 também encontrou 180+ scripts redundantes, ausência de
hooks/CI e dumps de `.env` na raiz — `ANALISE_FLUXO_IA:26`; o timelessphoto é
exemplo de *leveza*, não de *enforcement*.)

Três transferências diretas:

1. **Portões que testam o produto, não o processo.** O Shield valida regressão
   real de ponta a ponta. Transferível ao protocolo: a suite pytest do
   canônico + guards rodando em CI são o "Shield do protocolo" — todo delta
   da classe A passa por eles, e o gate é binário. Transferível ao
   Credenciamento (depois, no plano projeto): TV2 + import M|F|err|skip já
   cumprem esse papel; a lição é mantê-los como *o* gate, e não adicionar
   camadas documentais por cima.
2. **Fonte única de regras, curta e imperativa.** O AGENTS.md do
   Credenciamento deve convergir para o formato AI_RULES: regras invioláveis
   + ponteiro para STATE + 3-4 knowledges vigentes — e *remover* itens da
   read-list quando viram guard executável (a regra que virou hook não
   precisa mais ser lida, só obedecida mecanicamente).
3. **Faxina acoplada ao release.** O equivalente HBN do
   `cleanup-and-version.sh`: ao fechar release/onda, mover automaticamente a
   auditoria consumida para o frio. Faxina deixa de ser projeto pendente
   (F4 há semanas no backlog) e vira efeito colateral do fluxo normal.

---

## 5. ROADMAP DE CICLOS — a sequência para os próximos loops

Ordenado por alavancagem e dependência. Um ciclo por loop do Opus/Cowork;
cada um cabe numa sessão com folga de contexto. Escrita sempre e somente no
canônico `~/Projetos/usehbn` (ciclos que afetam o Credenciamento produzem
*proposta* para aplicação posterior no plano projeto).

**C1 — Bastão 2.0 (spec + schemas).**
Objetivo: matar a retomada cara. Entregável: `core/relay-spec.md` v2
(STATE×LOG), `schemas/handoff.schema.json`, `schemas/state.schema.json`,
template de STATE e os 3 prompts de papel (§12.B) reescritos para ler STATE.
Escreve em: `core/`, `schemas/`, `agents/`. Pronto quando: retomada simulada
(dry-run nesta máquina) lê ≤5 arquivos / ≤40 KB e reconstrói a onda 0177.
Gate humano: aprovar spec antes de propor adoção no Credenciamento.

**C2 — Fronteira (ADR-008 v2 + inbox por projeto).**
Objetivo: dar endereço único à doutrina e canal sem colisão para feedback.
Entregável: ADR-008 v2 re-depositado (gatilho datado), `inbox/README.md` +
convenção de ID namespaced, plano de migração da cópia divergente usando a
matriz MD-K existente. Escreve em: `methodology/adr/`, `inbox/`. Pronto
quando: ADR-008 v2 ACCEPTED por hearback + inbox documentado. Gate humano:
ratificação do ADR (cross-IA ≥2 conforme INDEX de ADRs).

**C3 — Sincronizar o canônico com o protocolo vivo.**
Objetivo: o canônico volta a ser fonte. Entregável: importar de
`Credenciamento/.hbn/schemas/` os schemas hearback/audit-pre/audit-post e de
`scripts/hbn-guards/` os guards (como `usehbn/guards/`), com testes e CI no
canônico (Trilha E1/E2, pendente desde 24/05). Escreve em: `schemas/`,
`guards/`, `tests/`, CHANGELOG. Pronto quando: guards rodam verdes em CI do
canônico e versão bumpada. Gate humano: hearback do bump (decidir 0.3.1 vs
promover a 0.4.0 junto com a pendência do ADR-010/PROPOSAL-V0.4.0).
Depende de: C2 (para o destino estar definido).

**C4 — Arquiteto autônomo 2.0.**
Objetivo: cada ciclo entrega 1 delta atômico ou no-op declarado. Entregável:
`agents/architect-autonomous.md` (prompt curto, no repo), `.hbn/queue/` como
fila de estado, ADR-011 definindo classes A/B e hearback em lote, religação
da máquina autoevolve (ADR-010) como executor da classe A. Escreve em:
`agents/`, `methodology/adr/`, `.hbn/queue/`. Pronto quando: 3 ciclos
consecutivos cumprem a regra "1 commit ou no-op declarado". Gate humano:
aprovar ADR-011 (é a decisão Q2 abaixo) e promover ADR-010 a ACCEPTED.
Depende de: C1, C3.

**C5 — Política vivo/frio + faxina com história preservada.**
Objetivo: matar o inchaço sem apagar história. Entregável: ADR-012
(temperatura documental: vivo/frio/arquivado, nada deletado, tudo movido),
script `hbn-archive` (modelo cleanup-and-version: relay INDEX→STATE+archive,
auditoria de release fechada→frio), saneamento da colisão 0014×0014 como
primeiro delta classe A. Escreve em: `methodology/adr/`, `guards/`/scripts,
`inbox/credenciamento/` (proposta de aplicação). Pronto quando: read-list
canônica proposta ≤6 itens e zero arquivos deletados no plano. Gate humano:
aprovar a lista do que é "vivo" (regra de negócio e segurança nunca esfriam).
Depende de: C4 (é a classe A operando).

**C6 — Cerimônia proporcional (tiers T0-T3).**
Objetivo: humano decidindo onde importa, rito barato onde não. Entregável:
ADR-013 com a tabela tier×rito×path e guard de tier; firewall 0022 e cerimônia
T3 declarados imutáveis. Escreve em: `methodology/adr/`, `guards/`. Pronto
quando: guard de tier verde em CI + tabela ratificada. Gate humano:
ratificação do ADR-013. Depende de: C3.

**C7 — Perfis de modelo.**
Objetivo: o protocolo absorve modelos novos por configuração. Entregável:
`schemas/model-profile.schema.json`, perfis iniciais (fable-5, opus-4.8,
codex, gemini-3.5), revisão da 0017/§7 para referência paramétrica (via
inbox, como proposta ao Credenciamento). Escreve em: `schemas/`,
`.hbn/models/`, `inbox/`. Pronto quando: 0017 paramétrica aprovada como
proposta. Gate humano: aprovar thresholds por perfil. Depende de: C1.

**C8 — Métricas de saúde do bastão (fecha o laço do ADR-007).**
Objetivo: provar que a evolução pagou. Entregável: 3 KPIs medidos e
publicados em `reports/`: KB lidos por retomada, tempo intent→ERP, taxa de
"1 commit/ciclo" do arquiteto; baseline retroativo da onda 0177. Pronto
quando: 2 semanas de medição publicadas. Gate humano: leitura quinzenal (já
prevista na Trilha F1). Depende de: C4.

Sequência mínima de maior alavancagem se for preciso escolher: **C1 → C2 →
C3 → C4**; C5-C8 colhem os frutos.

---

## 6. Perguntas abertas para Mauricio (antes do primeiro ciclo)

1. **Onde o arquiteto autônomo trabalha daqui em diante?** Recomendo: dentro
   do canônico `usehbn` (prompt versionado no repo, deltas commitados lá), e
   o Credenciamento só recebe *propostas* via inbox. Isso inverte o §2 atual
   do prompt (pré-flight no Credenciamento). Confirma?
2. **Hearback em lote para a classe A?** Hoje a regra é "nunca executa sem
   hearback explícito" (§5 do prompt). A proposta C4 mantém isso para tudo
   que é normativo (classe B), mas permite faxina/índice/arquivamento serem
   commitados no ciclo com sua revisão semanal em lote + rollback por commit.
   Aceita essa flexibilização, ou prefere `HUMAN_GATE` ligado por default?
3. **Destino do runtime Python do canônico.** Mantê-lo como implementação de
   referência (e assumir que o fluxo real é markdown+schemas+guards), ou
   investir para que as ondas reais passem a usar o CLI `hbn`? A resposta
   muda o escopo de C3 (só guards/schemas vs. integração CLI).
4. **Gatilho do ADR-008 v2.** Amarrar a execução da migração
   `Credenciamento/usehbn/` → `.usehbn-snapshot/` ao freeze da V206, ou a uma
   data fixa independente do projeto (para o gatilho não apodrecer de novo)?

---

## 7. Fontes principais desta análise

Protocolo: `usehbn/AGENTS.md`, `README.md`, `CHANGELOG.md`,
`methodology/PRINCIPIOS-CONSTITUCIONAIS.md`, `methodology/adr/INDEX.md` +
ADR-002/008/010, `methodology/MATURITY-MATRIX.md`, `docs/EVOLUTION-POLICY.md`,
`docs/TRUTH-BARRIER.md`, `docs/HUMAN-INTERFACE-AUTOEVOLVE.md`,
`HBN-ARCHITECTURAL-REVIEW-2026-04.md`, `.hbn/relay/INDEX.md`,
`.hbn/autoevolve/cycle-2026-05-13.jsonl`, `schemas/` (ls), git log.
Projetos (somente leitura): `Credenciamento/AGENTS.md`, `CLAUDE.md`,
`.hbn/relay/INDEX.md`, `.hbn/knowledge/0017` e índice 0001-0022,
`.hbn/messages/20260610-0110-*`, `.hbn/protocol-evolutions/20260610-*`,
`.hbn/schemas/` (ls), `scripts/hbn-guards/` (ls), `auditoria/` (contagens),
`Credenciamento/usehbn/` (ls); `timelessphoto.art/docs/AI_RULES.md`,
`tests/e2e/shield/`, `scripts/cleanup-and-version.sh`.
Análises anteriores: `~/Projetos/ANALISE_FLUXO_IA_2026-05-24.md`;
`~/Projetos/PROMPT_ARQUITETO_USEHBN_AUTONOMO.md` v1.6.
Contagens marcadas "(medido)" foram executadas nesta sessão em 2026-06-10.
