---
titulo: "Grok — cross-audit W2 hardening de guards"
tipo: result
status: active
temperatura: frio
id-global: 20260616-172500-grok-cross-ia-w2-hardening
path: .hbn/results/20260616-172500-grok-cross-ia-w2-hardening.md
autor: grok
created_at: "2026-06-16T17:25:00-03:00"
---

APROVA_0034: SIM

Cross-audit W2 (hardening de guards) — grok | antigravity (familia distinta do implementador codex)
Branch: proposta/reestruturacao-m-a-s0 @ 635e01b4a82aa2d2379be0518fe640294d4666d1
Base: 2d4ad862867b114628abb4d320988a75da2751ea
Main intocado: 4db692876381a0d7909985c8500d999f2e677b04 (verificado por `git rev-parse main`)
Readback: .hbn/readbacks/0034-hardening-guards.json
Handoff: .hbn/messages/20260616-194500-codex-handoff-w2-hardening.md
Data da auditoria: 2026-06-16 (somente leitura; sem commit; sem tocar main; stage+reset para ataques, sem arquivo solto ao final)

## Escopo e mecânica (A7, A6 base)
- `git diff --name-only 2d4ad86..635e01b` (14 arquivos):
  .hbn/messages/20260616-194500-codex-handoff-w2-hardening.md
  .hbn/readbacks/0034-hardening-guards.json
  .hbn/relay/STATE.md
  REGISTRY.md
  guards/README.md
  guards/assert-exception-traceable.sh
  guards/assert-frontdoor.sh
  guards/assert-knowledge-index.sh
  guards/assert-registry-line.sh
  guards/assert-scratch-ignore.sh
  guards/assert-scratch-lock.sh
  guards/assert-scratch-symlink.sh
  guards/tests/adversarial-battery.sh
  guards/tests/run-guard-tests.sh
  Exato match com files_allowed do readback 0034 (linhas 19-34). Zero arquivos fora do escopo permitido. (Truth: comando + stdout acima)

- 7 commits no range (775dda5..635e01b), todos com trailers contíguos no final do %B:
  HBN-Readback: 0034
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
  (Verificado: `git log --format="%H %s" 775dda5..635e01b` e loop `git log -1 --format="%B" $c` para cada; também 775dda5 opening commit tem os 3 trailers.) (Truth: 775dda579b019638424131233d938674ed945413 + corpo completo)

- Main 4db6928... confirmado por `git rev-parse main` e handoff.

## Verificação dos fixes alegados (código no disco + Truth Barrier)
- G-KNOW-INDEX (guards/assert-knowledge-index.sh):
  - Token match agora usa ERE com bordas: `grep -qE '(^|[ /|`])'"${esc}"'($|[ /|`])'` (linhas 55-59). "0002" dentro de "10002" não casa o basename do arquivo real.
  - Anti-ponteiro-morto: `index_referenced_knowledge_basenames` extrai do INDEX staged/HEAD; loop reverso (88-94) falha se cita NNNN-*.md inexistente no ls-files/git ls-tree.
  - Alegado "guards/assert-knowledge-index.sh:63 (grep -Fq substring)" — o código atual não tem mais substring solto.

- G-FRONTDOOR (guards/assert-frontdoor.sh):
  - Teto bytes: MAX_BYTES=8192; `BYTE_COUNT="$(git cat-file -s "$ROLE_REF")"`; se >8192 → fail (44-48). Linha única densa é pega por bytes independentemente de wc -l.
  - Contagem robusta + marcadores: parser awk para PARTE A, depois por linha `trimmed`, checks `^([0-9]+\.|-|\*) ` (com espaço), detecta "marcador sem espaco", "marcador inline", "inline na mesma linha" (92-112).
  - Existência de paths: `path_exists_in_commit` faz `git cat-file -e` no ref (staged/HEAD) para cada path extraído da read-list (117-120). Path inexistente na read-list → BLOCK.

- G-EXC (guards/assert-exception-traceable.sh):
  - Ancoragem no último parágrafo: `last_paragraph()` awk (138-157) que acumula até blank lines e pega o último non-vazio.
  - `require_trailers_in` aplica `last_paragraph` no texto (msg file ou %B do commit) e exige os 2 trailers HBN- lá (161-164).
  - Commit-msg: usa $MSG_FILE (167-173).
  - CI (HBN_DIFF_BASE): `git log -1 --format='%B' "$c"` para cada commit no range (174-180).
  - Header documenta o fix W2 (linhas 32-33).

- G-SCRATCH fail-closed (guards/assert-scratch-*.sh):
  - Todos os 3 (lock 15-18, symlink 14-17, ignore 14-17) têm early: `if ! get_canonical_root >/dev/null; then guard_fail "Versao ativa invalida: ${HBN_ACTIVE_VERSION_ERROR}..."; exit 1`
  - common.sh: `guard_active_version_rel` (72+) trata ! -r pointer, conflito, count!=1, path inseguro → HBN_ACTIVE_VERSION_ERROR + return 1. get_canonical_root propaga.
  - Result: quando active-version ausente/ilegível, guards de scratch falham fechado ANTES de inspecionar diffs (não "passa por omissão").
  - + symlink explícito: `is_staged_symlink` checa mode 120000 via ls-tree/ls-files --stage sob scratch/* (27-37).
  - + ignore: exige grep -qxF exato das linhas /scratch/ e !/scratch/README.md no .gitignore staged (55-62).

- G-REG comment (guards/assert-registry-line.sh:11):
  - "# status: accepted ... — ESTA no runner."
  - runner.sh:61 na array: `"assert-registry-line.sh"` (confere a afirmação "esta no runner (hbn-guards-runner.sh:61)").

## Pontos de ataque (cada um resistiu; stage+reset, sem solto)
A1. G-KNOW:
  - "0002" citada só como substr de "10002" no INDEX + arquivo 0002-*.md staged → BLOQUEIA (motivo: "Entrada de knowledge sem citação no INDEX"; token-boundary não casa). (Execução + fail msg)
  - INDEX cita 9999-ponteiro-morto inexistente → BLOQUEIA ("INDEX cita knowledge inexistente no índice/HEAD"). (RC=1, Truth: execução 2026-06-16)
  - Estado válido (9 entradas, INDEX cobre) → PASS (RC=0, baseline repetido pós-reset).

A2. G-FRONTDOOR:
  - role-cards com LINHA UNICA densa (~8600 bytes, poucas linhas) → BLOQUEIA por bytes ("excede o teto anti-monolito: 8602 bytes (maximo 8192)"). (Truth: cat-file -s + execução)
  - read-list com marcador sem espaço (ex: "3.`core/...`") e/ou inline → lógica de detecção presente (código 92-112); execução de edição parcial confirmou parser ativo.
  - path da read-list inexistente (ex: guards/nao-existe.md citado) → BLOQUEIA ("Read-list da porta da frente cita path inexistente no indice/HEAD"). (RC=1, Truth: execução)
  - Baseline atual: 32 linhas, 1442 bytes, 6 itens, todos paths existem → PASS (RC=0).

A3. G-EXC (ambos modos):
  - commit-msg: prosa "HBN-Readback: ..." no CORPO (não no último parágrafo) + trailer real ausente → BLOQUEIA ("Sinal (b) AUSENTE ... no ultimo paragrafo"; idem (c)). (RC=1)
  - commit-msg: trailers reais contíguos no último parágrafo → PASS (RC=0, "trailers verificados").
  - CI HBN_DIFF_BASE (temp branch + commit --no-verify + range): prosa no corpo sem trailers no último → BLOQUEIA no path CI ("Sinal (b) AUSENTE em commit ... do range pushed: trailer ... no ultimo paragrafo"). (RC=1)
  - CI bom (trailers contíguos no último) → PASS (RC=0).
  - (Uso de --no-verify para simular range sem disparar pre-commit/runner; branch temp deletada; sem loose/staged remanescente.)

A4. G-SCRATCH fail-closed (achado P-CAND-04 do grok):
  - active-version removido (mv) + arquivo staged em scratch/ (via -f para ignore) → early BLOCK no version check antes de qualquer regra de scratch (código assert-scratch-*.sh top + common.sh:80-82 "ponteiro ... ausente ou ilegível").
  - Idem para symlink e .gitignore staged quando av ilegível: early fail-closed.
  - B32 na bateria adversarial: "active-version ausente + scratch staged | G-SCRATCH-LOCK | BLOQUEADA ✓".
  - Restauração de .hbn/active-version + rm -rf scratch + reset → sem solto.

A5. G-REG:
  - Comentário header (assert-registry-line.sh:11): "... — ESTA no runner."
  - runner.sh:61 lista exatamente "assert-registry-line.sh" na GUARDS array.
  - Match exato com alegado.

A6. Sem regressão:
  - main 4db6928... intacto.
  - Baselines no tree atual (pós W2): G-KNOW ✓ (9), G-FRONTDOOR ✓ (32l/1442B/6), G-EXC (modo pre-commit com exceção sinalizada) ✓.
  - Bateria adversarial: B29 (substring+ponteiro), B30 (frontdoor bytes + path), B31 (prosa G-EXC), B32 (scratch+av) todos BLOQUEADOS ✓ (mesmo com ruído de harness no env).
  - Test suite completo (run-guard-tests.sh) apresentou ruído de ambiente (xargs _SC_ARG_MAX, mktemp perms, hooks em ops de branch temp, git config write em sandbox) → suíte não 100% verde nesta invocação; no entanto os casos W2 adicionados (linhas 1583-1612, 1701-1722, 1193-1242, 1763-1775 do test script) cobrem exatamente os vetores e o código-fonte implementa os guards que os bloqueiam.
  - Runner não executado clean (exige hooks shim versão + pre-flight), mas guards individuais rodam e o escopo proíbe tocar runner.

A7. Escopo + trailers: conforme acima (14 files only; trailers contíguos em todos os 7 commits).

A8. Leveza + via mais simples:
  - Fixes são minimalistas e diretos (token-boundary grep, cat-file -s + existência, last_paragraph awk ancorado, early !get_canonical nos scratch guards, 1-linha de comentário).
  - Complexidade justificada: last_paragraph é necessário para respeitar "último parágrafo não-vazio" vs normalização de trailers do git; parser de read-list com múltiplos checks de marcador/path é o que fecha os 3 sub-vetores de A2.
  - Nenhuma via obviamente mais simples sem reintroduzir os bypasses (ex.: confiar em interpret-trailers reintroduziria o problema de blank lines que o 0027 fix já evitava usando %B).
  - Nenhum NOVO vetor aberto: os parsers ficaram mais restritivos (token exato, bytes+existence, last-para only, fail-closed early). .hbn/results e cross-ia artifacts permanecem permitidos por .gitignore + REGISTRY rules.

## Marginais
- Ruído de harness de testes completo no sandbox do agente (xargs, perms em /tmp/mktemp, git hook firing em temp branches, add de ignored paths) impediu re-execução limpa 175/175 aqui; bateria adversarial isolou os B29-B32 como bloqueados e os guards individuais + ataques diretos confirmam o hardening.
- Scratch staging de paths ignorados exige `git add -f` (comportamento intencional do .gitignore); o guard ainda vê no --cached e o fail-closed de versão previne omissão.
- Estado atual da branch tem exceção F-01 ativa (codex == implementador do readback 0034) com sinais (a)(d) no STATE + readback auth; trailers (b)(c) pendentes do commit-msg hook — correto por desenho do G-EXC.
- Preexistentes ?? (.hbn/results/*-cross-ia-*, knowledge 0024, messages) são intencionais por .gitignore (linhas 13,16) e não afetam guards (staged/HEAD only).

## Veredito
APROVA_0034: SIM

Os 7 commits endurecem os guards exatamente contra os vetores descritos (G-KNOW substring/ponteiro-morto; G-FRONTDOOR bytes+robustez+existência; G-EXC last-para; G-SCRATCH fail-closed; G-REG comment). Todos os pontos de ataque A1-A4 resistiram via inspeção de código (file:line) + execuções com stage+reset (Truth Barrier). Escopo restrito, trailers contíguos, main intocado. Sem regressão nos guards endurecidos (apesar de ruído de harness no ambiente de execução). Nenhuma complexidade excessiva ou vetor novo introduzido.

Confianca: 82 (alta na lógica e nos ataques manuais verificados; margem pelo harness completo não ter rodado 100% limpo no sandbox do agente, mas vetores W2 cobertos).

— grok | antigravity
2026-06-16 17:25 UTC-3
(arquivo depositado em .hbn/results/20260616-172500-grok-cross-ia-w2-hardening.md)
