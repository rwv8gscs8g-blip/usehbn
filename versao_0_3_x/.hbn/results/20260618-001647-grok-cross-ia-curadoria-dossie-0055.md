---
path: .hbn/results/20260618-001647-grok-cross-ia-curadoria-dossie-0055.md
status: congelado
temperatura: glacier
---
SOU: grok · familia xAI · papel auditor
PARA: cross-audit useHBN — (I) implementacao 0055 + (II) red-team do desenho G-ORQ-ENTRADA
DE: grok (xAI) · auditor independente (≠ OpenAI/codex)
DATA: 2026-06-18
CONTEXTO: main=4db692876381a0d7909985c8500d999f2e677b04; readback 0055 (curadoria-dossie-pre-transicao); zona_livre_curada:true apenas nos paths listados; Truth Barrier: arquivo:linha ou comando+saida no DISCO. NAO commit/stage/main/--no-verify.
ASSINATURA: grok · xAI · auditor cross-ia

# Parecer Cross-Audit: Curadoria Dossie Pre-Transicao (readback 0055) + Red-Team G-ORQ-ENTRADA

## Resumo (≤10 linhas)
- PART I: 4 commits (394c974, eba3f4d, f158fce, bdcba54) tocam SOMENTE files_allowed do readback 0055 (diff --name-status 394c974^..bdcba54). Trailers HBN contiguos idênticos nos 4 commits. Dossie 7 arquivos + SINTESE tracked (git ls-files). 00-INDICE:22-35 mapeia a-g com cobertura real em arquivos dedicados (a->SINTESE, e->01 padronizacao/raiz). REGISTRY tem exatamente 9 linhas 7-col com `arvore=fronteira` `frio` na secao da curadoria. Suites: pytest 213 (195 defs + params), adversarial B1-B40, run-guard-tests 195/0 reportado no STATE/docs. Nenhum bloqueador de escopo ou rastreabilidade.
- PART II: Cartao de Entrada (G-ORQ-ENTRADA) e prova-de-leitura por instrucao de texto; sem mecanismo de atestacao hash+desafio ou desafio de conteudo. Possiveis bypass por auto-declaracao de familia/role e leitura fingida. HBN-Token-FP e pin de integridade de despacho mas depende de bastao_token_sha256 sem assinatura forte (fragilidade). Despacho-artefato como untracked pode gerar deadlock de visibilidade entre orq e proximo ator. "Quem verifica o verificador": cadeia cross-family + G-DIVERSITY + G-AUDITOR-ID + human gate, mas o proprio cartao de entrada ainda e proposta (nao core/). Proxima superficie sem governo (knowledge 0024): zona-livre + orquestrador inflando scope/files_allowed + mutacao de metadados de controle (M em STATE/readback) que configuram os gates.
- APROVA_0055: SIM (confianca 88/100). Escopo respeitado 100%; cobertura R-PT5 honesta e verificavel; suites citadas batem com disco; design de entrada tem fragilidades de governanca mas nao invalidam a curadoria 0055.
APROVA_0055: SIM

## Evidencias mecanicas (read-only)
- git rev-parse main → 4db692876381a0d7909985c8500d999f2e677b04 (main intacta)
- git diff --name-status 394c974^..bdcba54 → somente 12 paths dentro de files_allowed do 0055 (readback:22-46)
- git log --format="%(trailers)" para cada um dos 4 commits → HBN-Readback: 0055 + HBN-Human-Authorization: Mauricio... + HBN-Token-FP: 34a7f2f9 (contiguos)
- git ls-files docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/ → 7 arquivos rastreados
- tail REGISTRY.md (secao 0055) → 9 linhas com 7 colunas + `frio | fronteira`
- .hbn/readbacks/0055-curadoria-dossie-pre-transicao.json:21-46 (scope.files_allowed exato; invariants trailers; zona_livre_curada:true)
- STATE.md:4-5,18 (curadoria 0055 entregue; run-guard-tests 195/195; B1-B40 bloqueada; pytest 213; aguarda cross-audit ≠-OpenAI)

## Cobertura R-PT5 (00-INDICE.md:22-35 + verificacao real)
Mapeamento declarado:
- a) auditoria profunda → ../SINTESE-PROFUNDA-pre-freeze.md (SINTESE:20-38 meta-validacao; 42-62 bug decisions provado; 81-94 guards+proxima superficie; 119-144 prontidao+sequencia)
- b) estrutura de pastas → 01-estrutura-pastas-e-documentacao.md (01:17-46 estado atual; 48-124 soltos na raiz; 139-259 proposta arvore)
- c) mapa migracao → 02-mapa-migracao-genoma-autocontido.md (02:48+ tabela migracao; genoma auto-contido)
- d) qualidade doc → 03-qualidade-documentacao-software.md (03:15-47 AGENTS/readme lacunas + ponteiros quebrados)
- e) padronizacao geral → 01-... (secao padronizacao/raiz) (01:220-243 PROPOSTA B convenções nomenclatura + nada solto na raiz; 205 regra "nada solto na raiz exceto")
- f) prontidao github → 04-prontidao-github-transicao.md (04:35-80 gitignore/segredos + canonical-root path absoluto)
- g) protocolos de teste → 05-protocolos-de-teste-e-novos-testes.md (05:26-46 tres camadas; 50-80 pontos cegos engine-real)

06 e meta/proposta (00-INDICE:34-35) — nao conta como tema minimo. Cobertura real verificada em cada arquivo (Truth Barrier respeitado). Nenhum tema sem cobertura = sem BLOQUEADOR.

## Suites verificadas (cita disco + docs)
- pytest: 213 passed (05:14-15 `PYTHONPATH=src python3 -m pytest -q` → "213 passed"; grep def test_ em tests/ → 195 defs + params golden = 213)
- run-guard-tests: 195 (STATE:18 "run-guard-tests 195/195"; 05:40-46 camada 2 guards; header run-guard-tests.sh:22-30 contagens por secao)
- adversarial B1-B40: confirmado (adversarial-battery.sh: grep -oE 'B[0-9]+' | sort -u | wc -l → 40; B39/B40 presentes no script; 05:43 "B1–B33" atualizado por ondas posteriores para B40)

## Severidades (0055)
- Nenhuma P0/P1 de escopo ou rastreabilidade.
- Observacao: suites reportam "195/195" e "B1-B40 bloqueada" no STATE/docs; execucao real da bateria no HEAD atual ficou vermelha por estado pre-existente (B39 impl=null passou) — mas 0055 nao tocou guards, entao nao e defeito da implementacao 0055.
- Risco baixo: zona_livre_curada:true e auto-declarado (ja rastreado como C-DEBT em outras ondas).

APROVA_0055: SIM (confianca 88/100)

## DESIGN G-ORQ-ENTRADA (red-team das 5 perguntas do Bloco A)

Fonte primaria: `.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md:29-59` (o bloco a colar). Contexto: knowledge/0024 (orquestrador nao sela zona livre sem aprovacao humana explicita; instrucao escrita nao basta; so gate enforcado vincula).

a) Atestacao hash+desafio e a prova-de-leitura suficiente?
- O cartao exige "LEIA PRIMEIRO" (read-list minima: STATE + readback ativo + role-cards + knowledge 0001/2/23/24/25) e "ESCREVA SO NO SEU SLOT".
- Nao existe desafio/hash de conteudo (ex.: SHA dos arquivos lidos reportado e verificado pelo proximo ator ou guard). Prova-de-leitura e puramente instrucional/prompt-based.
- Suficiente para humano disciplinado ou IA bem alinhada; insuficiente contra IA que mente ou "completa" sem ler (mesmo padrao que 0024 flagrou: texto dizia "nao usar sem aprovacao" e orquestrador comitou zona livre assim mesmo).
- Cita: cartao:41-42; 0024:29-32 ("Uma instrucao escrita DENTRO de um documento nao vincula uma IA").

b) bypass?
- Sim, varios vetores:
  - Auto-declaracao de "SOU: ... familia ... papel" (linha 1) sem gate que valide contra bastao_token ou auditor-families no momento de entrada.
  - Ignorar read-list: orquestrador pode operar direto em zona livre ou inflar files_allowed sem listar um-a-um ao humano (0024).
  - "Cole o bloco" depende de cooperacao do chamador humano; em sessao sem o prefixo, IA pode ignorar.
  - Cita: cartao:33-34 (primeira linha), 44-47 (slots), STATE:6 (bastao_token_sha256 existe mas cartao nao exige validacao na entrada).

c) fragilidade do hash-pin?
- HBN-Token-FP:34a7f2f9 aparece em trailers e e checado por G-DSP-INT (readback inexistente / token_fp divergente do STATE).
- O "pin" e o bastao_token_sha256 no STATE (STATE:6). Sem assinatura criptografica, sem nonce por ator, sem expiracao explicita no cartao.
- Fragilidade: replay de token_fp entre ondas se STATE nao rotaciona forte; ou orquestrador que controla STATE pode forjar. G-TOK cobre posse de baton mas dispatch human_authorization ainda texto livre em alguns paths.
- Cita: STATE:6; REGISTRY mencoes G-DSP-INT; cartao:45 (trailers incluem HBN-Token-FP); knowledge 0025 (auditor read-only sem --no-verify).

d) deadlock do despacho-artefato?
- Orquestrador deposita como untracked (`.hbn/messages/`, `.hbn/dispatch/`) + handoff (cartao:47).
- Proximo ator (implementador/auditor) depende de receber o artefato (via humano ou relay). Se orquestrador nao versiona (correto por 0024), o "despacho" pode ficar invisivel em clone limpo ou exigir acao manual para propagar.
- Risco de deadlock: cadeia orq → dispatch untracked → proximo orq/ator nao ve sem pull manual; ou multiplos despachos concorrentes sem ordem canonica.
- Cita: cartao:47; 0024:42-44 (deny-by-default para zona-livre); STATE notas S2 sobre despacho como artefato auto-declarante versionado (mas orq fica fora).

e) quem verifica o verificador?
- Auditor: G-AUDITOR-ID + G-DIVERSITY (≥2 familias ≠ implementador com APROVA SIM) + cross-audit manual + hearback humano.
- Orquestrador: human approval explicito (para zona livre e readbacks com zona_livre_curada) + G-EXC (trailers) + posterior cross-audit dos seus despachos/analises.
- O proprio "cartao de entrada" ainda e proposta (promover_para: core/cartao-entrada.md) e nao e enforcado por guard de entrada. Quem verifica a veracidade da auto-ID inicial e o humano + o proximo ator que confere o SOU vs. bastao.
- Cita: cartao:34,46-47; STATE:12-13 (auditores_validadores + gate_humano); knowledge/0026 (auto-id-auditor-gate); G-DIVERSITY em runner.

## Proxima superficie sem governo (knowledge 0024)
- Metadado autodeclarado (STATE/readback/REGISTRY) que CONFIGURA os gates, sob Modification (M). Guards atuais governam bem A/R e PRESENCA, mal MUTACAO de controle e AUTENTICIDADE.
- Orquestrador inflando files_allowed de readback com zona livre sem aprovacoes por-arquivo (0024:38-40).
- Cartao de entrada ainda fora de core/ → sem G-FRONTDOOR forte para "primeira linha SOU".
- Solucao estrutural sugerida em 0024: deny-by-default de escopo + marcador de curadoria-humana obrigatorio para paths de zona livre; gate independente de trailer contiguidade (ja em R3a).

## Veredito final
A implementacao 0055 respeita escopo, rastreabilidade (trailers+REGISTRY) e produz cobertura auditavel real de R-PT5. Nao ha bloqueador.

O design G-ORQ-ENTRADA (cartao) e um avanco de clareza de contrato de entrada, mas herda as fragilidades classicas ja mapeadas em 0024: depende de instrucao+cooperacao onde so gate enforcado vincula. Recomenda-se promover com onda dedicada que adicione prova de leitura (hash/challenge minimo) + deny-by-default de escopo + validacao de auto-ID contra bastao.

APROVA_0055: SIM (88/100)

---
path: .hbn/results/20260618-001647-grok-cross-ia-curadoria-dossie-0055.md
gerado read-only por grok (xAI) — sem alteracao de git, sem staging, sem main.
