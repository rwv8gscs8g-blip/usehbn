---
titulo: "Parecer cross-IA — exuvia v2 rodada 4"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260702-092415-grok-cross-ia-exuvia-v2-rodada4.md
created_at: "2026-07-02T09:24:15-03:00"
autor: grok
familia: xAI
papel: auditor
alvo: versao_2_0_0
rodada: 4
---

SOU: grok · família xAI · papel auditor READ-ONLY adversarial do useHBN (gate humano Mauricio).

# Parecer adversarial — bootstrap exuvia v2, rodada 4 (APÓS natas 0/0b; rounds 1-3 anuladas)

**Identidade vinculante (conforme prompt):** este parecer usa token "grok" no nome do arquivo e "grok"/"xAI" no front-matter. Um parecer por família. Parecer com identidade alheia é NULO — medições no DISCO, não em relatos prévios. Rodadas 1-3 anuladas por incidente/quórum/vício de premissa (ver versao_2_0_0/FITNESS-CHECKLIST.md §C-XAUDIT). Todas as verificações abaixo foram executadas do zero via comandos no disco.

Escopo: aprovo ou veto o bootstrap `versao_2_0_0` como exuvia pós-natas 0/0b. NÃO autoriza flip de `.hbn/active-version`; ativação condicionada a Fitness Gate completo + hearback humano + rito.

## V0 — Estado (git + tag + natas)

- `git log --oneline -5`:
  c3723ec feat(guards): nata-0b - bloco read-list do harness version-aware (sob rito, pos-incidente)
  8e80461 feat(guards): nata-0 - dereferencia version-aware do hearback_ref no G-FAM + teste negativo R2
  de87a37 feat(exuvia): bootstrap versao_2_0_0 (INATIVA) + emendas da consolidacao rodada 2
- Tag `hbn-exuvia/bootstrap-v2-consolidado-r2` -> de87a3796d6ebeacc4c7fa745c6eeeaa9e1fa181
- `git show --stat hbn-exuvia/bootstrap-v2-consolidado-r2 | head -20`: inclui `versao_2_0_0/BOOT.md`, `versao_2_0_0/FITNESS-CHECKLIST.md`, `versao_2_0_0/.hbn/knowledge/*`, `versao_2_0_0/guards/...` (commit CONTÉM versao_2_0_0).
- `git show-ref --tags | grep bootstrap-v2-consolidado-r2`: presente.
- Nata-0/0b aplicadas: verificado **no CÓDIGO** (não relatos):
  - `guards/assert-role-family.sh:110-145`: deref version-aware de `hearback_ref` via `active_root` + `get_canonical_root` + `_inside` checks (ADR-020).
  - `guards/lib/common.sh:141-152`: `guard_version_repo_path`, `get_canonical_root`, `guard_active_version_rel`.
  - `guards/tests/run-guard-tests.sh:157`: "NATA-0/R2: +2 checks G-FAM version-aware... Total: 266."
  - `run-guard-tests.sh:236`: `check "fam: hearback_ref relativo à versão ativa" pass`
  - `run-guard-tests.sh:245`: `check "fam: hearback_ref só fora da versão ativa (R2)" block`
  - Bloco read-list version-aware em testes (REPO_ROOT dinâmico + targets BOOT/core v2) presente e exercitado quando rodado de `versao_2_0_0/`.
- Evidência de aplicação: suítes 274/274 verdes nos DOIS contextos (ver V3).

## V1 — C-NOREG (diff -r)

- `diff -r --brief guards/ versao_2_0_0/guards/`: (sem saída, exit 0) — paridade.
- `diff -r --brief schemas/ versao_2_0_0/schemas/`: (sem saída).
- `diff -r --brief .hbn/knowledge/ versao_2_0_0/.hbn/knowledge/`: (sem saída) — mas veja dívida 0c abaixo.
- `git ls-files .hbn/knowledge/ | wc -l`: 19 (rastreáveis na raiz).
- `git ls-files versao_2_0_0/.hbn/knowledge/ | wc -l`: 7 (apenas os commitados no bootstrap).
- Twins untracked no disco v2 (12 knowledge 0019/0022-0032 + 1 fixture active-root + core/exuvia-fitness-criteria.md) **existem e são idênticos** aos da raiz:
  - `diff -q core/exuvia-fitness-criteria.md versao_2_0_0/core/exuvia-fitness-criteria.md`: IDENTICAL
  - `git status --short | grep 'versao_2_0_0/.hbn/knowledge/00'` lista os ?? .
- Explicação sob rito (MANIFESTO §PENDENTE 0c): vendorizados untracked para **não quebrar C-NOREG** (alterar front-matter nas cópias v2 criaria diff ou violaria "verbatim"). Paridade de conteúdo no disco mantida. Dívida declarada, não oculta. `diff -r` intencionalmente limpo para tracked.
- `git status --short | grep '^[ MADRC]'`: nenhum (ver V2).

## V2 — Escrita confinada

- `git status --short` (executado múltiplas vezes): **somente `??` untracked** (mensagens, logs, state temporário, brainstorm, vendor untracked em versao_2_0_0/ conforme dívida 0c). Nenhum `M`, `D`, `R`, `C`, `A` inesperado.
- Evidência: "NO modified/deleted/renamed/copied — only untracked or clean".
- Nenhuma escrita fora de versao_2_0_0/ no commit do bootstrap (conforme MANIFESTO verificação C-TRACE).

## V3 — Suítes nos DOIS contextos + baterias + F-08

- Contagem de `check ` no script: 274 (root e v2 idênticos; +2 da nata-0 confirmados).
- Raiz: `bash guards/tests/run-guard-tests.sh` → `== resumo: 274 passaram, 0 falharam ==` / SUÍTE VERDE.
- Contexto v2: `cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh` → `== resumo: 274 passaram, 0 falharam ==` / SUÍTE VERDE.
- `bash guards/tests/adversarial-battery.sh` (root): BATERIA VERDE (B1–B96 todas BLOQUEADAS).
- `cd versao_2_0_0 && bash .../adversarial-battery.sh`: BATERIA VERDE.
- F-08: `check "readlist: referência quebrada é detectada (F-08)" block` — executado e BLOQUEOU em ambos contextos (conforme exigido).
- Divergência da contagem esperada: **nenhuma** (274/274 pós-natas 0/0b).

## V4 — Consolidação fiel (amostra ≥5)

- **G-FRONTDOOR × core/role-cards.md**:
  - `versao_2_0_0/core/role-cards.md:15-19`: "satisfaz o contrato mecânico do guard herdado `guards/assert-frontdoor.sh` (G-FRONTDOOR: presença, teto anti-monolito, read-list ≤6 itens com paths existentes)".
  - `versao_2_0_0/guards/assert-frontdoor.sh:19-100`: usa `guard_version_repo_path`, teto 140 linhas/8192 bytes, PARTE A read-list obrigatória, paths version-aware.
  - Testes cobrem: read-list 7 itens → BLOCK; >8192 bytes → BLOCK; marcador sem espaço → BLOCK; path inexistente na read-list → BLOCK.

- **I-10 × core/03-rito-da-onda.md**:
  - `versao_2_0_0/core/03-rito-da-onda.md:71-77`: "## Relato de Leitura (I-10 — prova de entrada...) Handoff de entrada ... exige o heading EXATO `## RELATO DE LEITURA` ... Enforcement herdado: `guards/assert-report-fresh.sh` (regra 6, onda 0006 I-10)".

- **P1–P13 × core/01-principios.md**:
  - `versao_2_0_0/core/01-principios.md:13-19`: "## P1–P13 (inalterados) ... Fonte canônica (não migrada...): `../../methodology/PRINCIPIOS-CONSTITUCIONAIS.md` ... Mudança ... exige cross-IA ≥ 2 famílias + hearback".
  - Amostra de fonte: `methodology/PRINCIPIOS-CONSTITUCIONAIS.md:54` (P1), `73` (P2), `92` (P3) ... até P13 — texto preservado, não duplicado.

- **Árvores × core/04-artefatos.md §Árvores**:
  - `versao_2_0_0/core/04-artefatos.md:46-56`: "`fronteira` → `intermediaria` → `estavel`. **Fonte única da árvore: o REGISTRY** (decisão registry-centric ... G-ARVORE-LABEL valida a coluna `arvore` de linhas novas do REGISTRY, não front-matter). ... Dívida declarada: ... coluna `arvore` no REGISTRY v2 (nata-3b); até lá, promoção/despromoção VEDADA".

- **Quórum × core/02-papeis.md e 03-rito-da-onda.md**:
  - `versao_2_0_0/core/02-papeis.md:19`: "quórum de selagem = 2 pareceres SIM de famílias distintas entre si E do implementador".
  - `versao_2_0_0/core/03-rito-da-onda.md` e `guards/assert-quorum-selagem.sh`: testes G-QUORUM cobrem (selagem +2 famílias != OpenAI + APROVA SIM → pass; 1 parecer / mesma família / OpenAI / sem APROVA → block).
  - G-QUORUM executado verde na suíte.

Consolidação é fiel: specs são ponteiros finos + contratos herdados intactos (C-NOREG). Nenhuma duplicação indevida.

## V5 — Orçamento

- `wc -l versao_2_0_0/BOOT.md`: 161 (≤300 OK).
- `ls versao_2_0_0/core/*.md | wc -l`: 12 (NO TETO conforme prompt; inclui 3 verbatim + role-cards + 8 specs).
- STATE resumo executivo: 6 bullets principais (linhas ~1-6 do resumo), total arquivo 52 linhas, seção "Resumo executivo" <<30. OK.
- Leveza meta R1 respeitada para bootstrap (incumbente ~2500 linhas; v2 entrada ~BOOT+STATE+cartão ~230).

## V6 — Brechas novas (tentativas concretas)

Tentei burlar (usando temp dirs + fixtures + invocações diretas dos guards; sem escrita no repo):

1. Groupthink mesma família sem hearback cobrindo (bad-hearback-sem-excecao.json via G-FAM): BLOQUEADO. Saída: "GROUPTHINK: ... nenhum hearback confirmado declara a exceção" + "NÃO existe no disco (anti-teatro, ADR-020)". RC=1.
2. Oversized role-cards (>8192 bytes, 9000 x's): BLOQUEADO por G-FRONTDOOR (byte count > MAX_BYTES). RC=1.
3. Referência quebrada na read-list (F-08): BLOQUEADO explicitamente ("referência quebrada é detectada (F-08)").
4. active-version ausente + arquivo em scratch/: BLOCK (G-SCRATCH-LOCK etc, coberto na suíte).
5. CI=true local sem nota (bypass G-CR): BLOCK (F-05).
6. Tentativa de hearback_ref escapando da active-root (path ../ fora da versão): BLOCK (falha de _inside + ADR-020).
7. Diff neutro sem read-list no G-READLIST-RITE: passa (como esperado); com read-list A/M sem readback: BLOCK.

Nenhuma burla nova passou. Bateria adversarial B1-B96 (incluindo novas de G-COPY, G-CI, G-STATE, G-ARVORE) toda BLOQUEADA em ambos contextos. Nenhuma brecha aberta detectada além das dívidas já declaradas (0c etc).

## V7 — Fitness (8 critérios objetivos)

Medições diretas no disco (comandos + saídas):

1. **C-TEST**: `cd versao_2_0_0 && bash guards/tests/run-guard-tests.sh` → 274/274 pass, 0 fail (SUÍTE VERDE). Idem na raiz. Paridade pós-natas. (Evidência: resumo final das execuções.)
2. **C-ADV**: `bash guards/tests/adversarial-battery.sh` (ambos contextos) → BATERIA VERDE (B1–B96 todas BLOQUEADAS). (Evidência: tail das execuções com B96 + "BATERIA VERDE".)
3. **C-XAUDIT**: Rodada 4 em andamento. No disco no momento da medição: antigravity SIM, cursor SIM, codex SIM (3 pareceres família ≠ Anthropic). Este parecer grok/xAI completa. Quórum mínimo 2 SIM ≠ Anthropic pode ser atingido. (Evidência: ls .hbn/results/*rodada4*.md + tail dos vereditos.)
4. **C-DOG**: NÃO executado nesta sessão (exige freeze V206 real do projeto Credenciamento externo + tag + hearback). Não verificado. (Ver O que não verifiquei.)
5. **C-FCLOSE**: Testes cobrem: active-version ausente → BLOCK; conflito merge → BLOCK; duplicado → estado inválido. Suítes + testes de active-version em G-CR/G-STRAY/G-SCRATCH etc. passam bloqueando. (Evidência: checks "cr: active-version ausente → BLOCK", "scratch-lock: active-version ausente → BLOCK".)
6. **C-NOREG**: diff -r vazio nos 3 alvos; git status sem M/D; paridade de conteúdo dos vendor untracked verificada (IDENTICAL). (Evidência: comandos de diff/ls-files/status acima.)
7. **C-TRACE**: Manifesto declara destinos (VENDORIZADO/CONSOLIDADO/HISTORICO/PENDENTE). Amostra ≥10 com arquivo:linha (anti-teatro cumprido):
   - 1. `versao_2_0_0/MANIFESTO-MIGRACAO.md:22` guards/ completo -> versao_2_0_0/guards/
   - 2. `versao_2_0_0/MANIFESTO-MIGRACAO.md:23` schemas/ -> versao_2_0_0/schemas/
   - 3. `versao_2_0_0/MANIFESTO-MIGRACAO.md:24` .hbn/knowledge/ -> versao_2_0_0/.hbn/knowledge/
   - 4. `versao_2_0_0/MANIFESTO-MIGRACAO.md:25` core/exuvia-fitness-criteria.md -> versao_2_0_0/core/
   - 5. `versao_2_0_0/MANIFESTO-MIGRACAO.md:33` AGENTS.md -> BOOT.md
   - 6. `versao_2_0_0/MANIFESTO-MIGRACAO.md:41` P1–P13 -> core/01-principios.md
   - 7. `versao_2_0_0/MANIFESTO-MIGRACAO.md:59` 0c vendorizados 12 knowledge + core/exuvia... (dívida)
   - 8. `versao_2_0_0/core/01-principios.md:17` referencia a methodology/PRINCIPIOS-CONSTITUCIONAIS.md
   - 9. `versao_2_0_0/core/04-artefatos.md:49` §Árvores (fonte única REGISTRY)
   - 10. `versao_2_0_0/core/03-rito-da-onda.md:71` I-10 Relato de Leitura
   - 11. `versao_2_0_0/core/role-cards.md:16` G-FRONTDOOR
   - 12. `versao_2_0_0/FITNESS-CHECKLIST.md:25` C-NOREG medição
   - 13. `guards/assert-role-family.sh:169` GROUPTHINK + cobre_familia (ADR-018/020)
   - 14. `guards/tests/run-guard-tests.sh:157` NATA-0/R2 +2 checks
   - 15. `versao_2_0_0/BOOT.md:141` referencia a MANIFESTO-MIGRACAO.md
   Nenhum elemento sem destino declarado.
8. **C-DEBT**: Seção PENDENTE (0 a 6) existe com onda designada para cada. Nenhuma dívida oculta apontada. 0/0b aplicadas no código (V0); 0c declarada e visível no git status + ls-files. (Evidência: MANIFESTO-MIGRACAO.md:53-66 + comandos.)

## Achados (severidade + evidência)

| ID | Severidade | Achado | Evidência |
|----|------------|--------|-----------|
| A1 | MARGINAL | Dívida nata-0c permanece (vendor untracked em v2 com paridade de conteúdo). Declarada, não oculta; impede "limpeza" sem quebrar C-NOREG. | `versao_2_0_0/MANIFESTO-MIGRACAO.md:59`; `git status --short` (?? versao_2_0_0/.hbn/knowledge/0019... + core/exuvia...); `diff -q ... IDENTICAL`; `git ls-files` (root 19, v2 7). |
| A2 | MARGINAL | Tag bootstrap-r2 no commit do bootstrap (de87a37), não no HEAD pós-natas (c3723ec). Requisito "contém versao_2_0_0" satisfeito; natas posteriores no incumbente. | `git show --stat hbn-exuvia/bootstrap-v2-consolidado-r2`; `git rev-list --count ...r2..HEAD` = 2. |
| A3 | MARGINAL | MANIFESTO ainda lista nata-0/0b em PENDENTE (ledger desatualizado), mas código + suítes confirmam aplicação. | `versao_2_0_0/MANIFESTO-MIGRACAO.md:57-58`; `git log -2 --oneline` (8e80461, c3723ec); 274/274 em execuções. |
| A4 | MARGINAL | Orçamento no teto: 12/12 core/*.md. Qualquer adição exige remoção/consolidação. | `ls versao_2_0_0/core/*.md | wc -l`; `versao_2_0_0/BOOT.md:115-116`. |
| A5 | FORTE | C-DOG (freeze V206 Credenciamento) e flip/ativação não verificados nesta auditoria (escopo do prompt é bootstrap da exúvia). | FITNESS-CHECKLIST §4; ausência de tag/projeto externo no disco local. |
| A6 | MARGINAL | Muitos ?? untracked no root (.hbn/messages/, logs/, state/, brainstorm/) — esperados no workflow, não tocam versao_2_0_0/. | `git status --short | grep '^\?\?' | head`. |
| A7 | BLOQUEADOR | Nenhum (todas as tentativas de burla e checks de fail-closed bloquearam). | V3 + V6 execuções (RCs !=0 onde esperado). |

## Nível de confiança

Alta (V0 estado/tag, V1 C-NOREG diffs + paridade disco, V2 status, V3 suítes 274/274 + F-08, V5 orçamento, V6 brechas) — todos medidos por comandos/saídas reproduzíveis.

Média (V4 consolidação) — amostra ≥5 regras com evidência arquivo:linha + inspeção guards.

Baixa para C-DOG/C-XAUDIT completo (depende de execuções externas + pareceres das outras famílias; este é o de xAI).

## O que NÃO verifiquei

- Freeze V206 completo do Credenciamento (C-DOG), tag do projeto, hearback humano associado e dry-run de rollback.
- Flip de `.hbn/active-version` para versao_2_0_0 + reinstalação de hooks + ativação real.
- Pareceres de todas as famílias na rodada 4 (medi apenas os existentes no disco no momento; produzo o grok).
- Verificação exaustiva de todas as 22+ specs vs 27 ADRs históricos (fiz amostra dirigida + C-TRACE com 15+ itens).
- CI remoto, GitHub workflows, rede, ou estado em outros clones.
- Semântica completa de todo knowledge numerado (foco em fronteira de guarda e rito).

## Veredito em linha única final

APROVA_EXUVIA_V2: SIM
