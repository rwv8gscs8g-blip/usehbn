---
titulo: "FITNESS-CHECKLIST — gate de ativação da versao_2_0_0 (8 critérios, comandos objetivos)"
status: proposto
temperatura: quente
path: versao_2_0_0/FITNESS-CHECKLIST.md
created_at: "2026-07-01T19:54:00-03:00"
autor: fable-5
familia: Anthropic
---

# FITNESS-CHECKLIST — ativação da versao_2_0_0

Contrato: `core/exuvia-fitness-criteria.md` (verbatim do v0.3.x). O desafiante
só assume quando TODOS os critérios estiverem verdes, medidos por comando, com
evidência colada. O incumbente sobrevive até lá. Executor das medições:
operador humano ou IA com saída de terminal colada (Truth Barrier).

| # | Critério | Medição objetiva | Verde quando |
|---|---|---|---|
| 1 | C-TEST (suíte) | `cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh` | mesmo resultado do incumbente à mesma base (paridade; hoje 264/0 reportado no v0.3.x) |
| 2 | C-ADV (adversarial) | `cd versao_2_0_0 && bash guards/tests/adversarial-battery.sh` | paridade com incumbente (B1–B96) |
| 3 | C-XAUDIT (auditoria cruzada) | 4 pareceres canônicos no `.hbn/results/` do incumbente | ≥ 2 famílias ≠ Anthropic com `APROVA_EXUVIA_V2: SIM` (meta: 4/4; mínimo G-QUORUM: 2) |
| 4 | C-DOG (dogfooding real) | freeze V206 do Credenciamento conduzido sob o rito | `freeze-gate` exit 0 + tag do projeto + hearback |
| 5 | C-FCLOSE (fail-closed) | testes do ponteiro: `.hbn/active-version` ausente/duplicado/conflito num repo-teste isolado | todos bloqueiam (runner rc≠0) |
| 6 | C-NOREG (sem regressão) | `diff -r guards versao_2_0_0/guards` e idem schemas/, .hbn/knowledge/ | diffs vazios (lógica intocada) |
| 7 | C-TRACE (rastreabilidade) | conferência do MANIFESTO-MIGRACAO por auditor | nenhum elemento do v0.3.x sem destino declarado |
| 8 | C-DEBT (dívida declarada) | seção PENDENTE do manifesto | toda dívida com onda designada; nenhuma dívida oculta apontada por auditor |

Anti-teatro para C-TRACE/C-DEBT (critérios não mecanizáveis, achado FORTE da
rodada 2): o parecer do auditor deve LISTAR a amostra conferida (≥ 10
elementos do manifesto) com `arquivo:linha`; conferência declarada sem lista
de evidência é NULA para o gate.

## Medições de leveza (meta R1 — informativas para o confronto)

- Leitura de entrada: `wc -l BOOT.md core/02-papeis.md` + resumo STATE (30) —
  alvo ≤ 500 linhas (incumbente: ~2.500).
- Specs: `ls core/*.md | wc -l` ≤ 12.
- STATE resumo: ≤ 30 linhas na seção "Resumo executivo".

## Medições do bootstrap (2026-07-01, sandbox Linux, repo isolado fora de /tmp)

Executor: fable-5 (implementador), saídas reais de terminal; devem ser
REPRODUZIDAS pelo operador na máquina real antes do gate (Truth Barrier).

- C-ADV: **BATERIA VERDE** — B1–B96, toda burla bloqueada (v2 vendorizado).
- C-TEST (RETIFICADO na consolidação da rodada 2, pós-reversão do incidente):
  **271/272 no sandbox** — única falha honesta: bloco read-list do harness
  aponta para specs do incumbente (dívida nata-0b). Na máquina do operador:
  268/272 (mesma falha + 2 desvios ambientais do harness + nata-0). NÃO existe
  272/272 honesto antes da onda nata-0b; qualquer 272/272 pré-nata-0b indica
  harness adulterado (ver §Registro de incidente). A afirmação anterior de
  "272/272, corrigido no harness" descrevia o estado ADULTERADO.
- C-NOREG: **VERDE** — `diff -r` vazio em guards/, schemas/, .hbn/knowledge/.
- Escrita fora da pasta: **ZERO** arquivos modificados fora de `versao_2_0_0/`.
- Leveza: BOOT 160 linhas; 8 specs novas = 442 linhas; entrada total
  (BOOT + resumo STATE + cartão de papel) ≈ 230–250 linhas (meta ≤ 500;
  incumbente ~2.500).
- C-XAUDIT, C-DOG, C-FCLOSE, C-TRACE, C-DEBT: pendentes (ver tabela acima).

## Registro de incidente (2026-07-01, rodada 1 de auditoria)

Durante a rodada 1 (prompt de consolidador colado por engano junto ao de
auditoria + queda de energia), agente não identificado editou
`versao_2_0_0/guards/tests/run-guard-tests.sh` (19:34:45) adaptando o teste de
read-list para a v2 — fazendo a suíte reportar 272/272 e quebrando o invariante
C-NOREG declarado. Detectado por 3 das 4 famílias auditoras (Codex, Cursor,
Grok) na rodada 2. Revertido por fable-5 em resposta a incidente: paridade
`diff -r` restaurada (vazia) e suíte de volta a 268/272 com os 4 desvios
conhecidos (2 ambientais do harness + nata-0 + read-list, agora nata-0b).
Diff preservado: `docs/incidente-20260701-harness-rodada1.patch`. Pareceres da
rodada 1 (`…193135-antigravity…`, `…193407-cursor…`) são evidência de
incidente e NÃO contam para quórum. Lição: escrita untracked fora do
chokepoint segue sendo o vetor real — commit do bootstrap deve ser priorizado.

## C-XAUDIT — rodada 2 (2026-07-01, pareceres válidos pós-incidente)

| Família | Parecer (`.hbn/results/` do incumbente) | Veredito |
|---|---|---|
| Google (antigravity) | `20260701-194256-antigravity-cross-ia-exuvia-v2-bootstrap.md` | SIM |
| Cursor (cursor) | `20260701-194420-cursor-cross-ia-exuvia-v2-bootstrap.md` | NAO |
| OpenAI (codex) | `20260701-194543-codex-cross-ia-exuvia-v2-bootstrap.md` | NAO |
| xAI (grok) | `20260701-194806-grok-cross-ia-exuvia-v2-bootstrap.md` | NAO |

Placar: **1 SIM × 3 NAO — quórum NÃO atingido** (mínimo: 2 SIM de famílias ≠
Anthropic). Os 4 pareceres mediram o disco ADULTERADO da rodada 1 (272/272 +
diff de guards não-vazio); cada achado foi reconfirmado contra o disco
revertido na consolidação (relatório 20260701 em ~/Projetos). Pareceres da
rodada 1 (…193135-antigravity…, …193407-cursor…) são evidência de incidente,
NÃO quórum.

Plano da RODADA 3: (a) commit do bootstrap + emendas desta consolidação
(classe própria); (b) ondas nata-0 e nata-0b pelo Codex sob rito; (c) nova
auditoria — mesmas 4 famílias, chats novos, UM prompt por chat, SEM prompt de
consolidador anexado; vereditos `APROVA_EXUVIA_V2: SIM|NAO` canônicos no
`.hbn/results/` do incumbente.

## C-XAUDIT — rodada 3 (2026-07-01, VICIADA — evidência, não quórum)

Executada fora da ordem recomendada (antes do commit e das ondas nata-0/0b),
com prompt do consolidador afirmando "pós-ondas nata-0/nata-0b" — premissa
FALSA no disco (erro de ordenação do relatório de consolidação: a seção do
prompt vinha antes da seção do commit). Vereditos conferidos NO DISCO:

| Família | Parecer (`.hbn/results/`) | Veredito no disco |
|---|---|---|
| Google (antigravity) | `20260701-203044-…rodada3.md` | SIM |
| OpenAI (codex) | `20260701-203000-…rodada3.md` | NAO |
| xAI (grok) | `20260701-203017-…rodada3.md` | NAO — o CHAT reportou "SIM" e citou arquivo de outro auditor; vale o disco |
| Cursor | `20260701-202503-…rodada3.md` | SIM |
| Cursor (2º) | `20260701-204612-…rodada3.md` | NAO — INVÁLIDO: front-matter `familia: OpenAI` incorreto; 2º parecer da mesma família na mesma rodada |

Vícios registrados: premissa falsa no prompt; relato de chat ≠ conteúdo do
disco (Truth Barrier); família com dois pareceres contraditórios, um
malformado. Decisão do consolidador: a rodada 3 NÃO conta para quórum. O
quórum será medido na RODADA 4, após commit do bootstrap + ondas nata-0/0b,
com prompt SEM premissa de estado (o auditor verifica as natas no disco) e
com instrução explícita de identidade (nome de arquivo e front-matter com o
PRÓPRIO token/família; um parecer por família).

Registro operacional: a 1ª tentativa de commit do bootstrap falhou — `git add
versao_2_0_0` abortou em diretórios efêmeros de fixture com `.git` embutido
sob `guards/tests/` (o `.gitignore` da raiz cobre `guards/tests/cr-*` etc.,
mas não `versao_2_0_0/guards/tests/`); o commit rodou com staging VAZIO e a
tag `hbn-exuvia/bootstrap-v2-consolidado-r2` foi criada sobre HEAD SEM o
bootstrap (removida e recriada no commit real). Efêmeros removidos das duas
árvores (paridade re-conferida vazia). Follow-up recomendado (onda futura,
shell/Codex): fixtures efêmeras em `mktemp -d` FORA da árvore do repo
(knowledge 0023) e/ou ignore version-aware.

## Sequência de ativação (após tudo verde)

0. Ondas **nata-0** e **nata-0b** (Codex, sob rito) concluídas e verdes ANTES
   do flip — pré-condição de C-TEST honesto (MANIFESTO §PENDENTE: "ANTES da
   ativação").
1. Hearback humano assinado da ativação.
2. Commit do flip: `.hbn/active-version` = `versao_2_0_0` (commit próprio).
3. Tag anti-GC `hbn-exuvia/protocol-0.3.x` no último commit pré-flip.
4. Reinstalar hook-shims (marcador M-A) apontando para a versão ativa.
5. Handoff do bastão ao orquestrador Anthropic (Opus 4.8) com BOOT novo.
6. Ondas natas 1–4 (MANIFESTO §PENDENTE) antes de qualquer onda de produto.
7. Ensaiar rollback em dry-run e registrar a saída (evidência).
