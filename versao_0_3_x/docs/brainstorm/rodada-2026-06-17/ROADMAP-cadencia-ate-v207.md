# Roadmap & cadência — de onde estamos até a Exúvia e o v207

NÃO-NORMATIVO (fronteira). Orquestrador (opus-4-8), 2026-06-17. Insumo durável para o
próximo orquestrador. Branch de trabalho: proposta/reestruturacao-m-a-s0. main intocada em
4db6928. Nenhuma tag v1 ainda.

---

## 1. Onde estamos (selado nesta sessão)

Tudo na branch de trabalho, ratificado por cross-audit ≠-família + hearback + selagem:
- **R1 / R1-fix / R1-fix-2** — runtime honesto (exit codes, estado unificado, docs=213) e
  DOIS bugs de perda/duplicação de estado achados e corrigidos.
- **Esteira de Pré-Transição** — `core/esteira-pre-transicao.md` (accepted): ondas de
  subagentes temáticos read-only antes de freeze/exúvia; gate obrigatório (R-PT1..R-PT5).
- **Curadoria P0** — AGENTS.md honesto (sem ponteiros mortos), `docs/GLOSSARY.md`, matriz
  dedupada.
- **G-AUDITOR-ID** — auto-ID do auditor é gate enforçado (família canônica; sem SOU não sela).
- **R2 árvores** — coluna `arvore` no REGISTRY (registry-centric), `core/arvores-spec.md`,
  guard anti-mislabel, promoção append-only.
- **R3a G-TRAILERS** — contiguidade dos 3 trailers HBN exigida em todo commit governado,
  independente do `implementador` (fecha o buraco do G-EXC null).

## 2. Por que pareceu lento — e por que acelera agora

O que foi feito não é "devagar": foi fechar **fundamentos load-bearing**. Congelar antes
disso teria carimbado no genoma da exúvia: dois bugs silenciosos de estado, identidade de
auditor forjável, e trailers sem enforce. Cada um, uma vez no exoesqueleto, viria junto na
muda. Agora a base é sólida e verificável. **O restante é mais mecânico e pode acelerar** —
e a Exúvia, ao nascer limpa, elimina a herança e destrava velocidade.

## 3. Cadência até fechar os ciclos (fases + orçamento de ondas)

### FASE A — Fechar hardening (1–2 ondas)
- **R3b** — Camada 2 do G-AUDITOR-ID: exigir, na selagem, ≥2 famílias DISTINTAS ≠-implementador
  com APROVA. Fecha mecanicamente a garantia de diversidade (hoje verificada à mão pelo
  orquestrador). Alto valor.
- **R3c** — G-REG-M geral (M de metadado de ciclo em front-matter de specs). OPCIONAL antes
  do freeze: o caso de árvore já está coberto pelo append-only; o gap geral é menor. Decisão:
  fazer agora OU registrar como dívida (C-DEBT) e seguir. Recomendo R3b agora; R3c como dívida
  aceita se quisermos acelerar para o freeze.

> **Atualização 2026-06-18 (orquestrador entrante, família Anthropic, bastão 34a7f2f9).**
> - **R3b — SELADO E VIGENTE** (readback 0053; duplo APROVA). Diversidade agora é gate.
> - **G-ORQ-ENTRADA v2 — SELADO E VIGENTE** (readback 0060; `guards/assert-orq-entrada.sh`):
>   bastão de orquestrador só pratica ato governado com atestação de entrada extrativa válida
>   (`.hbn/attestations/<fp>-orq-entrada.json`), recomputada do disco, sem gabarito físico. O
>   zelador é o primeiro submetido à barreira que mantém. **Esta linha fechava a lacuna (a) do
>   handoff: o G-ORQ-ENTRADA não constava da Fase A.**
> - **Decisão de gate (Maurício, 2026-06-18): endurecer TODA a meta-superfície antes do freeze**
>   — nenhuma das pendências é fail-open, mas optou-se pela base mais sólida. A Fase A passa a
>   carregar, em ondas próprias (codex implementa, cross-audit ≠-família, gate, selagem):
>   - **W-ORQ-3** [FORTE] — exigir `orq_entrada_ref` em despacho/selagem/freeze; gatear SÓ atos
>     de autoridade (P11); re-pin só sob rito (nova atestação; nunca editar a antiga; nunca
>     auto-repin). Resolve a fricção "todo commit que edita o STATE invalida a atestação".
>   - **W-ORQ-4** [META] — endurecer a meta-superfície (`orq_entrada_ref` omitido, read-list
>     editada sem rito, atestação no mesmo commit, freeze marcando `orq_entrada_ok` sem
>     dereferenciar) + integrar a bateria adversarial B1–B47 ao CI (`hbn-shield.yml`).
>   - **Despromoção-P6** — `assert-arvore-label.sh` só cobre promoção; criar
>     `tipo=arvore-despromocao` (motivo + `reverte_evento`), append-only.
> - **R3c** segue como C-DEBT registrada (não fail-open), candidata à Exúvia.

### FASE B — W-FREEZE: fechar a versão (2–3 ondas + 2 ações suas)
1. Curadoria final do dossiê (a Esteira exige): decidir quais P0/P1 restantes entram antes do
   freeze (estrutura de pastas/raiz, G-LEG/forbidden-paths, paths absolutos, atomicidade de
   escrita) vs ficam para a exúvia.
2. **Ação sua:** gerar/registrar `.hbn/operators/<nome>.pub` → ativa **G-HRB** (assinatura
   criptográfica do hearback). Branch protection biométrica já armada.
3. Criar `.hbn/freeze/<id>-freeze-v1.json`, preencher cada critério com evidência, **rodar
   `guards/freeze-gate.sh` no seu Terminal** (gate humano), colar o exit code no handoff;
   suíte/adversarial verdes; revisar main; **tag `v1-estavel`**; STATE/REGISTRY marcam v1.

### FASE C — GitHub pronto + Jules (2–3 ondas + ações suas)
- CI: ativar o workflow (hoje `hbn-shield.yml` está `proposed`) rodando guards +
  run-guard-tests + **adversarial-battery** + pytest em cada PR; matriz de Python (3.9–3.12).
- CODEOWNERS, templates PR/issue, dependabot, enforcement de DCO; documentar a branch
  protection no repo.
- **Habilitar o Jules (Google)** conectado ao repositório para **auditoria direto no código**:
  um auditor ≠-família trabalhando in-repo (não via paste) — mais um passo para te tirar de
  carteiro. Requer o repo público/pronto + a conexão. Jules vira um canal de cross-audit Google
  paralelo ao Antigravity.

### FASE D — Ponte v206 (2–3 ondas)
- Resolver os 4 bloqueadores do VETO 0034/0035 (pré-uso-real, NÃO pré-freeze): aritmética de
  contagem; path absoluto no guard de snapshot; colisão R8×forbidden-paths; split do firewall
  0022.
- Produzir o snapshot do protocolo `v1-estavel` consumido pelo Credenciamento **v206**.

> **Atualização 2026-06-18 — lacuna (b) do handoff: a Ponte é GENÉRICA, não só do v206.**
> A v206 é o PRIMEIRO consumidor e PROVA a ponte; não é a ponte. O problema que a ponte resolve
> — "as IAs se perdem entre o Protocolo (useHBN) e o Projeto (qualquer app de domínio)" — vale
> para TODO projeto que adote o protocolo. O snapshot `v1-estavel` é a interface estável que
> qualquer projeto consome. Elevar a itens de DESIGN da Fase D (vãos reais para produção):
> - **Camada 1 — matriz de permissão por papel = toolset.** Hoje `papel→paths` é enforçado por
>   guards (G-SCOPE, G-ACTOR-WRITE-MATRIX a construir). Falta a generalização para
>   `papel→ferramentas/superfícies` por projeto: cada papel (orquestrador/implementador/auditor)
>   recebe um toolset declarado e gateado, não só um conjunto de paths. Design de Fase D.
> - **Camada 4 — máquina de estados do bastão em código.** Hoje o ciclo do bastão
>   (entrada→atestação→despacho→implementação→cross-audit→hearback→selagem→handoff) vive em
>   doutrina + guards pontuais. Codificá-lo como máquina de estados explícita (transições
>   válidas, atos de autoridade gateados — base do W-ORQ-3) torna a ponte reutilizável e
>   auditável entre projetos. Design de Fase D.
> (As camadas 2 e 3 — diversidade de auditoria e trilha de provenance — já estão materializadas
> por G-DIVERSITY/G-AUDITOR-ID e pelo REGISTRY/readbacks.)

### FASE E — Primeira Exúvia: genoma limpo (fase maior; 4–6 ondas + design dedicado)
- Aplicar o **mapa de migração** (já no dossiê `02-mapa-migracao-genoma-autocontido.md`): novo
  exoesqueleto **auto-contido** (sem ponteiros para os antigos), antigos preservados read-only
  para auditoria (G-LEG + `.hbn/forbidden-paths.txt` + tag anti-GC `hbn-exuvia/protocol-0.3.x`).
- **Nova numeração** (seção 4), docs/pastas/REGISTRY **nascendo limpos**.
- Bateria adversarial transferida **integralmente** como CRISPR/memória imunológica.
- Fitness Gate + os 8 critérios decidem o que sobrevive ao molt.

### FASE F — v207 (produto)
- Avançar o Credenciamento **v207** sobre o protocolo exuviado/limpo, sem herança.

> **Atualização 2026-06-18 — lacuna (c) do handoff: fork pós-exúvia (decisão futura do gate).**
> Concluída a Exúvia do PROTOCOLO (Fase E), abre-se um fork sobre o PROJETO (Credenciamento):
> - **Opção 1 — v207 direto:** avançar o Credenciamento v207 sobre o protocolo já exuviado,
>   sem mexer no genoma do projeto. Mais rápido; o projeto herda sua própria história.
> - **Opção 2 — exúvia também do projeto:** aplicar ao Credenciamento o mesmo molt (genoma de
>   projeto limpo, auto-contido, antigos read-only), e só então o v207. Mais caro; entrega o
>   projeto tão limpo quanto o protocolo, mas dobra o esforço de migração.
> Não decidir agora: é insumo durável. A escolha depende de quanto débito o genoma do projeto
> acumulou no momento da Fase F e é decisão do gate humano com cross-audit ≠-família.

## 4. Nova numeração (esboço — finalizada no design da Exúvia, via gate)

Problema atual: readbacks `00NN` são opacos (não dizem o que são); ondas têm nomes ad hoc
(S2, W3, R1, R1-fix, R2, R3a); resultados por timestamp. Não há leitura clara da SEQUÊNCIA.

Proposta (born na exúvia):
- **Genoma**: a muda produz `g1` (1ª exúvia) = exoesqueleto/SemVer do protocolo.
- **Ciclo**: fase temática numerada e nomeada — `c01-estabilizacao`, `c02-ponte`, `c03-...`.
- **Onda**: dentro do ciclo — `w01`, `w02`… com slug. **ID completo da onda = readback**:
  `g1.c01.w03-g-auditor-id` (substitui o `00NN` opaco; 1:1 com o readback).
- **Parecer**: `<timestamp>-<apelido>-<onda-id>.md` (mantém unicidade + referência clara).
- **Knowledge**: `k-NNNN-slug` monotônico com INDEX vivo.
- **REGISTRY**: o livro-razão going-forward **recomeça limpo** no genoma novo (7-col + arvore);
  o REGISTRY antigo fica preservado read-only no legado para auditoria.
- **Guards/specs**: mantêm nomes semânticos (G-SCOPE, G-AUDITOR-ID…) — já são legíveis.

Resultado: qualquer id diz **genoma → ciclo → onda → slug**. Legível, ordenável, evolutivo.
(Esta proposta é insumo; a numeração final é decidida no design da Exúvia, com cross-audit.)

## 5. Gates humanos que eu preciso de você (para destravar fases)
- **Chave do operador** (`.hbn/operators/<nome>.pub`) → ativa G-HRB (Fase B).
- **Rodar o `freeze-gate.sh`** no seu Terminal (Fase B) — é gate humano por design.
- **GitHub/Jules**: confirmar o repo público e conectar o Jules (Fase C).
- **Ordem das fases**: A→B→C→D→E→F é a recomendada; você pode priorizar (ex.: antecipar Jules
  para a Fase C entrar mais cedo, ou aceitar R3c como dívida para acelerar B).

## 6. Recomendação de aceleração (honesta)
Para sair do "lento": fazer **R3b** (fecha a diversidade), **aceitar R3c como dívida registrada**,
e ir direto para a **Fase B (freeze)** com uma curadoria mínima do dossiê. GitHub+Jules (C) e
Ponte (D) podem correr em paralelo com a preparação da Exúvia (E). A Exúvia é o multiplicador:
depois dela, cada onda nasce mais leve.
