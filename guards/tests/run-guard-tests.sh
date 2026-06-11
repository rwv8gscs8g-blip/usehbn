#!/usr/bin/env bash
# =============================================================================
# guards/tests/run-guard-tests.sh
# path: guards/tests/run-guard-tests.sh · id-global: 20260610-65
# Suíte anti-teatro (ADR-020 Decisão 2): por guard, ≥1 caso-bom (passa) e
# ≥1 caso-ruim (BLOQUEIA). Guard sem teste negativo verde = proibido de ativar.
# Os casos-ruins incluem os 3 bugs provados pela auditoria cruzada 0021/0022:
#   F-03 hearback_ref inexistente · F-02 substring de path · F-01 na-sem-hearback.
# Hermética: perfis de modelo sintéticos em fixtures/models (HBN_MODELS_DIR);
# G-REG/G-SLF/G-HRB rodam em repo git descartável (mktemp). Não toca o repo real.
# Uso: bash guards/tests/run-guard-tests.sh   (exit 0 = suíte verde)
# status: accepted (corrente E 50%, hearback humano no readback 0002);
#   seções do FECHAMENTO da corrente E (G-REG novos casos, G-SLF, G-HRB):
#   accepted no readback 0003 — cobrem E-RE-01 (0025), F-01/F-02/F-04 (0026), ADR-021, ADR-023.
#   FIX staged-skew (re-auditoria 0027, E-FECH-01/02): casos de skew
#   index×worktree — staged ruim + worktree boa DEVE bloquear (e o espelho:
#   staged boa + worktree ruim DEVE passar, provando que o guard lê o índice).
#   Seções G-STR/G-NUM/G-PTR/G-RLT (metade 2 da onda orquestração-start,
#   ADR-024): status accepted pelo readback 0004 — casos das specs core/start-rite-spec.md §4-§5,
#   core/pointer-spec.md §3, core/state-report-spec.md §4, incluindo skew
#   E-FECH-01/02 e o caso de compatibilidade G-REG×created_at (risco R5).
#   CONTAGEM HONESTA (FIX cross-audit 0030 F-03): a seção ADR-024 soma
#   30 checks, dos quais 20 são negativos de bloqueio (block); os demais
#   são casos-bons, compatibilidade G-REG e pass-com-aviso (o aviso em si
#   não é assertado — só o rc). Antes do FIX 0030/0031: 26 checks, 17
#   negativos de bloqueio — NÃO "26 testes negativos".
#   SEÇÃO GUARDS LEGADOS (2026-06-11, readback 0005): 12 checks (8 block,
#   4 pass) para G-CR/G-TMP/G-ENV/G-LEG/G-SCO — paga a pré-condição do
#   STATE para ativar os guards novos no runner.
#   SEÇÃO G-STRAY (2026-06-11, readback 0005): 4 checks (2 block, 2 pass)
#   para o .hbn órfão (incidente opus-4-8). Total da suíte: 79.
#   SEÇÃO READ-LIST VIVA (onda 0006 I-01, readback 0006): 2 checks
#   (1 pass, 1 block) — F-08: path citado em template/spec deve existir.
#   Total da suíte após I-01: 81.
#   I-03 (ADR-025, onda 0006): +4 checks G-NUM (serial novo em results,
#   agente desconhecido em ciclo serial, created_at UTC → 3 block; legado
#   serial modificado → 1 pass) e o caso "serial fora de paralelo passa"
#   foi CONVERTIDO de pass→block (a condicionalidade D5.1 morreu).
#   Total da suíte após I-03: 85.
#   I-05 (F-05, onda 0006): +4 checks G-CR (CI=true local block; CI real
#   pass; alt-root autorizada pass; alt-roots vazio block). Total: 89.
#   I-06 (F-10, onda 0006): +3 checks bypass (2 env sem nota → block;
#   env com nota staged → pass). Total: 92.
#   FIX cross-audits 0030/0031 (3 FORTE + marginais): G-NUM token exato
#   (0030 F-01 / 0031 F-05) + data de id serial (0031 F-01); G-RLT heading
#   exato da cápsula (0030 F-02) + parser do chapéu por campo (0031 F-03);
#   G-PTR ignora ⟦HBN⟧ em code-fence (0031 F-02).
# =============================================================================
set -uo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARDS_DIR="$(dirname "$TESTS_DIR")"
REPO_ROOT="$(cd "$GUARDS_DIR/.." && pwd)"
FIX="$TESTS_DIR/fixtures"
unset HBN_GUARDS_BYPASS GLASSWING_BYPASS HBN_DIFF_BASE 2>/dev/null || true

PASS=0; FAIL=0; FALHAS=()

check() { # <nome> <esperado: pass|block> <rc>
    local nome="$1" esperado="$2" rc="$3"
    if { [[ "$esperado" == "pass" ]] && [[ "$rc" -eq 0 ]]; } || \
       { [[ "$esperado" == "block" ]] && [[ "$rc" -ne 0 ]]; }; then
        echo "  ✓ ${nome} (esperado: ${esperado})"
        PASS=$((PASS + 1))
    else
        echo "  ✗ ${nome} — esperado ${esperado}, obtido rc=${rc}"
        FAIL=$((FAIL + 1)); FALHAS+=("$nome")
    fi
}

# --- G-FAM: assert-role-family ----------------------------------------------
echo "== assert-role-family (G-FAM) =="
run_fam() {
    ( cd "$REPO_ROOT" && HBN_MODELS_DIR="$FIX/models" \
        bash "$GUARDS_DIR/assert-role-family.sh" "$1" >/dev/null 2>&1 )
    echo $?
}
check "fam: famílias cruzadas, papéis aptos"            pass  "$(run_fam "$FIX/atribuicoes/good-cross.json")"
check "fam: groupthink sem hearback"                    block "$(run_fam "$FIX/atribuicoes/bad-groupthink.json")"
check "fam: hearback_ref INEXISTENTE (bug F-03)"        block "$(run_fam "$FIX/atribuicoes/bad-hearback-inexistente.json")"
check "fam: hearback existe mas status=pendente"        block "$(run_fam "$FIX/atribuicoes/bad-hearback-pendente.json")"
check "fam: hearback confirmado SEM a exceção"          block "$(run_fam "$FIX/atribuicoes/bad-hearback-sem-excecao.json")"
check "fam: hearback confirmado COBRINDO a exceção"     pass  "$(run_fam "$FIX/atribuicoes/good-hearback-cobre.json")"

# --- G-FRZ: freeze-gate ------------------------------------------------------
echo "== freeze-gate (G-FRZ) =="
run_frz() {
    ( cd "$REPO_ROOT" && bash "$GUARDS_DIR/freeze-gate.sh" "$1" >/dev/null 2>&1 )
    echo $?
}
check "frz: tudo ok com evidência"                      pass  "$(run_frz "$FIX/freeze/good-all-ok.json")"
check "frz: na obrigatório COM hearback verificável"    pass  "$(run_frz "$FIX/freeze/good-na-com-hearback.json")"
check "frz: na obrigatório SEM hearback (bug F-01)"     block "$(run_frz "$FIX/freeze/bad-na-sem-hearback.json")"
check "frz: ok sem evidência (Truth Barrier)"           block "$(run_frz "$FIX/freeze/bad-ok-sem-evidencia.json")"
check "frz: bloqueador aberto"                          block "$(run_frz "$FIX/freeze/bad-bloqueador.json")"

# --- G-REG: assert-registry-line (repo git descartável por caso) -------------
echo "== assert-registry-line (G-REG) =="
make_repo() {
    local d; d="$(mktemp -d)"
    (
        cd "$d"
        git init -q
        git config user.email "tests@hbn.local"
        git config user.name "hbn-guard-tests"
        mkdir -p methodology/adr core docs/prompts reports \
            .hbn/models .hbn/hearbacks .github/workflows guards/sub
        cat > REGISTRY.md <<'EOF'
| id | artefato (path) | tipo | temperatura | superseded_by |
|---|---|---|---|---|
| 20260101-01 | methodology/adr/ADR-011-exemplo.md | adr | quente | — |
EOF
        echo "exemplo" > methodology/adr/ADR-011-exemplo.md
        git add -A
        git commit -qm "init"
    ) >/dev/null 2>&1
    echo "$d"
}
run_reg() {
    ( cd "$1" && bash "$GUARDS_DIR/assert-registry-line.sh" >/dev/null 2>&1 )
    echo $?
}

# caso-ruim F-02: path substring de linha existente (ADR-01 ⊂ ADR-011-exemplo.md)
d="$(make_repo)"
( cd "$d" && echo "novo" > "methodology/adr/ADR-01" && echo "" >> REGISTRY.md && git add -A ) >/dev/null 2>&1
check "reg: substring de path registrado (bug F-02)"    block "$(run_reg "$d")"
rm -rf "$d"

# caso-ruim F-01: spec core novo sem linha no REGISTRY
d="$(make_repo)"
( cd "$d" && echo "spec" > core/nova-fn-spec.md && echo "" >> REGISTRY.md && git add -A ) >/dev/null 2>&1
check "reg: core/*.md novo sem REGISTRY (bug F-01)"     block "$(run_reg "$d")"
rm -rf "$d"

# caso-ruim marginal 0022/F-04: prompt órfão em docs/prompts/
d="$(make_repo)"
( cd "$d" && echo "p" > docs/prompts/prompt-solto.md && git add -A ) >/dev/null 2>&1
check "reg: prompt órfão em docs/prompts/"              block "$(run_reg "$d")"
rm -rf "$d"

# caso-bom: artefato novo com linha exata de coluna no REGISTRY
d="$(make_repo)"
(
    cd "$d"
    echo "r" > reports/20260101-02-report-teste.md
    echo "| 20260101-02 | reports/20260101-02-report-teste.md | report | frio | — |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "reg: depósito correto com linha exata"           pass  "$(run_reg "$d")"
rm -rf "$d"

# --- G-REG: casos do fechamento da corrente E (E-RE-01 + 0026 F-01/F-02/F-04) -
# caso-ruim E-RE-01: .hbn/models/*.json novo sem linha exata no REGISTRY
d="$(make_repo)"
( cd "$d" && echo '{}' > .hbn/models/novo-modelo.json && echo "" >> REGISTRY.md && git add -A ) >/dev/null 2>&1
check "reg: .hbn/models/*.json sem REGISTRY (E-RE-01)"  block "$(run_reg "$d")"
rm -rf "$d"

# caso-ruim E-RE-01: .github/workflows/* novo sem linha exata no REGISTRY
d="$(make_repo)"
( cd "$d" && echo 'on: push' > .github/workflows/ci.yml && echo "" >> REGISTRY.md && git add -A ) >/dev/null 2>&1
check "reg: .github/workflows/* sem REGISTRY (E-RE-01)" block "$(run_reg "$d")"
rm -rf "$d"

# caso-ruim 0026/F-01: RENAME de artefato numerado sem nova linha (diff-filter=AR)
d="$(make_repo)"
( cd "$d" && git mv methodology/adr/ADR-011-exemplo.md methodology/adr/ADR-012-renomeado.md ) >/dev/null 2>&1
check "reg: rename sem nova linha no REGISTRY (0026/F-01)" block "$(run_reg "$d")"
rm -rf "$d"

# caso-ruim 0026/F-02: guard ANINHADO sem REGISTRY (prova que guards/*.sh cruza /)
d="$(make_repo)"
( cd "$d" && echo '#!/bin/bash' > guards/sub/novo-util.sh && echo "" >> REGISTRY.md && git add -A ) >/dev/null 2>&1
check "reg: guard aninhado guards/sub/*.sh sem REGISTRY (0026/F-02)" block "$(run_reg "$d")"
rm -rf "$d"

# caso-ruim 0026/F-04: doc órfão em docs/ (fora de docs/prompts/), sem id nem REGISTRY
d="$(make_repo)"
( cd "$d" && echo "solto" > docs/nota-solta.md && git add -A ) >/dev/null 2>&1
check "reg: doc órfão em docs/ sem id nem REGISTRY (0026/F-04)" block "$(run_reg "$d")"
rm -rf "$d"

# caso-bom: nome estável em methodology/ REGISTRADO ao nascer (linha exata)
d="$(make_repo)"
(
    cd "$d"
    echo "pratica" > methodology/pratica-nova.md
    echo "| 20260101-03 | methodology/pratica-nova.md | spec | quente | — |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "reg: doc estável em methodology/ com linha exata" pass "$(run_reg "$d")"
rm -rf "$d"

# --- G-REG: skew index×worktree (E-FECH-02, re-auditoria 0027) ----------------
# caso-ruim: REGISTRY staged SEM a linha; linha exata só na working tree
# (unstaged). O commit sairia sem a linha — DEVE bloquear.
d="$(make_repo)"
(
    cd "$d"
    echo "r" > reports/20260101-04-skew.md
    echo "" >> REGISTRY.md
    git add -A
    echo "| 20260101-04 | reports/20260101-04-skew.md | report | frio | — |" >> REGISTRY.md
) >/dev/null 2>&1
check "reg: linha só na working tree, staged sem (E-FECH-02)" block "$(run_reg "$d")"
rm -rf "$d"

# espelho-bom: linha exata STAGED; working tree depois perde a linha.
# O commit sairia COM a linha — deve passar (prova que o guard lê o índice).
d="$(make_repo)"
(
    cd "$d"
    echo "r" > reports/20260101-05-skew-ok.md
    echo "| 20260101-05 | reports/20260101-05-skew-ok.md | report | frio | — |" >> REGISTRY.md
    git add -A
    grep -v "20260101-05" REGISTRY.md > REGISTRY.tmp && mv REGISTRY.tmp REGISTRY.md
) >/dev/null 2>&1
check "reg: linha staged, working tree sem (espelho E-FECH-02)" pass "$(run_reg "$d")"
rm -rf "$d"

# --- G-SLF: assert-self-path (ADR-021 — repo git descartável por caso) -------
echo "== assert-self-path (G-SLF) =="
run_slf() {
    ( cd "$1" && bash "$GUARDS_DIR/assert-self-path.sh" >/dev/null 2>&1 )
    echo $?
}

# caso-bom: artefato declara path: idêntico ao caminho real
d="$(make_repo)"
( cd "$d" && printf -- '---\npath: methodology/adr/ADR-099-teste.md\n---\ncorpo\n' > methodology/adr/ADR-099-teste.md && git add -A ) >/dev/null 2>&1
check "slf: path: declarado == caminho real"            pass  "$(run_slf "$d")"
rm -rf "$d"

# caso-ruim canônico ADR-021: path: declarado ≠ caminho real
d="$(make_repo)"
( cd "$d" && printf -- '---\npath: docs/outro-lugar.md\n---\ncorpo\n' > methodology/adr/ADR-099-teste.md && git add -A ) >/dev/null 2>&1
check "slf: path: declarado ≠ real (auto-localização mentirosa)" block "$(run_slf "$d")"
rm -rf "$d"

# caso-ruim: artefato governado novo SEM path: no front-matter
d="$(make_repo)"
( cd "$d" && printf -- '---\ntitulo: sem path\n---\ncorpo\n' > methodology/adr/ADR-099-teste.md && git add -A ) >/dev/null 2>&1
check "slf: artefato governado sem path: declarado"     block "$(run_slf "$d")"
rm -rf "$d"

# caso-ruim: hearback .json novo sem chave "path"
d="$(make_repo)"
( cd "$d" && echo '{"status":"pendente"}' > .hbn/hearbacks/0009-sem-path.json && git add -A ) >/dev/null 2>&1
check "slf: hearback .json sem campo path"              block "$(run_slf "$d")"
rm -rf "$d"

# --- G-SLF: skew index×worktree (E-FECH-01, re-auditoria 0027) ----------------
# caso-ruim: artefato STAGED com path: mentiroso; working tree corrigida
# depois, sem re-stage. O commit levaria a mentira — DEVE bloquear.
d="$(make_repo)"
(
    cd "$d"
    printf -- '---\npath: docs/outro-lugar.md\n---\ncorpo\n' > methodology/adr/ADR-099-teste.md
    git add -A
    printf -- '---\npath: methodology/adr/ADR-099-teste.md\n---\ncorpo\n' > methodology/adr/ADR-099-teste.md
) >/dev/null 2>&1
check "slf: staged mente, working tree corrigida (E-FECH-01)" block "$(run_slf "$d")"
rm -rf "$d"

# espelho-bom: STAGED correto; working tree quebrada depois, sem re-stage.
# O commit levaria o conteúdo certo — deve passar (prova leitura do índice).
d="$(make_repo)"
(
    cd "$d"
    printf -- '---\npath: methodology/adr/ADR-099-teste.md\n---\ncorpo\n' > methodology/adr/ADR-099-teste.md
    git add -A
    printf -- '---\npath: docs/outro-lugar.md\n---\ncorpo\n' > methodology/adr/ADR-099-teste.md
) >/dev/null 2>&1
check "slf: staged correto, working tree mente (espelho E-FECH-01)" pass "$(run_slf "$d")"
rm -rf "$d"

# --- G-HRB: assert-hearback-integrity (ADR-023 — anti-auto-assinatura F-05) --
echo "== assert-hearback-integrity (G-HRB) =="
make_hrb_repo() {
    local d; d="$(mktemp -d)"
    (
        cd "$d"
        git init -q
        git config user.email "tests@hbn.local"
        git config user.name "hbn-guard-tests"
        mkdir -p .hbn/hearbacks docs
        echo base > docs/base.md
        git add -A
        git commit -qm "init"
    ) >/dev/null 2>&1
    echo "$d"
}
run_hrb() { # <repo> <hearback> [change=HEAD]
    ( cd "$1" && bash "$GUARDS_DIR/assert-hearback-integrity.sh" "$2" "${3:-HEAD}" >/dev/null 2>&1 )
    echo $?
}

# caso-bom: hearback em commit PURO anterior; mudança em commit posterior
d="$(make_hrb_repo)"
( cd "$d" && echo '{"status":"confirmed","path":".hbn/hearbacks/0009-ok.json"}' > .hbn/hearbacks/0009-ok.json \
    && git add -A && git commit -qm "hearback puro do humano" \
    && echo mudou >> docs/base.md && git add -A && git commit -qm "mudanca autorizada" ) >/dev/null 2>&1
check "hrb: commit puro anterior à mudança"             pass  "$(run_hrb "$d" ".hbn/hearbacks/0009-ok.json")"
rm -rf "$d"

# caso-ruim canônico F-05: hearback nasce no MESMO commit da mudança
d="$(make_hrb_repo)"
( cd "$d" && echo '{"status":"confirmed","signed_by":"Mauricio"}' > .hbn/hearbacks/0009-fake.json \
    && echo mudou >> docs/base.md && git add -A && git commit -qm "obra + autorizacao juntas" ) >/dev/null 2>&1
check "hrb: hearback no MESMO commit da mudança (0026/F-05)" block "$(run_hrb "$d" ".hbn/hearbacks/0009-fake.json")"
rm -rf "$d"

# caso-ruim: commit do hearback IMPURO (mistura obra com autorização)
d="$(make_hrb_repo)"
( cd "$d" && echo '{"status":"confirmed"}' > .hbn/hearbacks/0009-mix.json \
    && echo outra > docs/outra.md && git add -A && git commit -qm "hearback misturado" \
    && echo mudou >> docs/base.md && git add -A && git commit -qm "mudanca" ) >/dev/null 2>&1
check "hrb: commit do hearback impuro (mistura obra)"   block "$(run_hrb "$d" ".hbn/hearbacks/0009-mix.json")"
rm -rf "$d"

# caso-ruim: hearback apenas staged — não pré-existe à mudança
d="$(make_hrb_repo)"
( cd "$d" && echo '{"status":"confirmed"}' > .hbn/hearbacks/0009-staged.json && git add -A ) >/dev/null 2>&1
check "hrb: hearback staged/untracked (não commitado)"  block "$(run_hrb "$d" ".hbn/hearbacks/0009-staged.json")"
rm -rf "$d"

# --- G-STR: assert-start-cast (ADR-024 D1 / start-rite-spec §4) --------------
echo "== assert-start-cast (G-STR) =="
run_str() {
    ( cd "$REPO_ROOT" && HBN_MODELS_DIR="$FIX/models" \
        bash "$GUARDS_DIR/assert-start-cast.sh" "$1" >/dev/null 2>&1 )
    echo $?
}
check "str: elenco cruzado válido, ciclo serial"          pass  "$(run_str "$FIX/atribuicoes/good-cast-serial.json")"
check "str: groupthink sem hearback (delegação G-FAM)"    block "$(run_str "$FIX/atribuicoes/bad-groupthink.json")"
check "str: orquestrador sem papel apto e sem exceção"    block "$(run_str "$FIX/atribuicoes/bad-orq-sem-aptidao.json")"
check "str: escrita_paralela com apelido fora do elenco"  block "$(run_str "$FIX/atribuicoes/bad-paralelo-forasteiro.json")"
check "str: bypass liveness com hearback confirmado"      pass  "$(run_str "$FIX/atribuicoes/good-hearback-cobre.json")"

# --- G-NUM: assert-parallel-id (ADR-024 D5 / start-rite-spec §5) --------------
echo "== assert-parallel-id (G-NUM) =="
# Repo descartável com STATE (escrita_paralela parametrizável) + REGISTRY de
# 6 colunas — o G-NUM lê AMBOS do staged (E-FECH-01/02).
make_num_repo() { # $1 = conteúdo inline de escrita_paralela, ex: "[alpha-1, beta-1]"
    local d; d="$(mktemp -d)"
    (
        cd "$d"
        git init -q
        git config user.email "tests@hbn.local"
        git config user.name "hbn-guard-tests"
        mkdir -p .hbn/relay .hbn/messages .hbn/proposals reports docs/prompts docs
        cat > .hbn/relay/STATE.md <<EOF
---
proxima_acao: "auditar os guards da orquestracao-start"
ultima_atualizacao: "2026-06-10T21:00:00-03:00"
atribuicao:
  chapeu_atual: conversacional-orquestrador
  implementador: alpha-1
  auditores: [beta-1]
  escrita_paralela: ${1}
---
EOF
        cat > REGISTRY.md <<'EOF'
| id | artefato (path) | tipo | temperatura | superseded_by |
|---|---|---|---|---|
| 20260101-01 | docs/base.md | doc | frio | — |

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
EOF
        echo base > docs/base.md
        git add -A
        git commit -qm "init"
    ) >/dev/null 2>&1
    echo "$d"
}
run_num() {
    ( cd "$1" && bash "$GUARDS_DIR/assert-parallel-id.sh" >/dev/null 2>&1 )
    echo $?
}

# caso-bom: paralelo com AAAAMMDD-HHMMSS-<agente> + created_at coerente
d="$(make_num_repo "[alpha-1, beta-1]")"
(
    cd "$d"
    echo "ideia" > .hbn/proposals/20260610-101010-alpha-1-ideia.md
    echo "| 20260610-101010-alpha-1-ideia | .hbn/proposals/20260610-101010-alpha-1-ideia.md | proposal | quente | — | 2026-06-10T10:10:10-03:00 |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: paralelo com HHMMSS-agente válido + created_at" pass "$(run_num "$d")"
rm -rf "$d"

# caso-ruim: formato serial AAAAMMDD-NN em ciclo paralelo (colisão 0001×0001)
d="$(make_num_repo "[alpha-1, beta-1]")"
(
    cd "$d"
    echo "ideia" > .hbn/proposals/20260610-01-ideia.md
    echo "| 20260610-01 | .hbn/proposals/20260610-01-ideia.md | proposal | quente | — | 2026-06-10T10:10:10-03:00 |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: paralelo com AAAAMMDD-NN antigo (colisão 0001×0001)" block "$(run_num "$d")"
rm -rf "$d"

# caso-ruim: agente do nome fora de escrita_paralela
d="$(make_num_repo "[alpha-1, beta-1]")"
(
    cd "$d"
    echo "ideia" > .hbn/proposals/20260610-101010-delta-9-ideia.md
    echo "| 20260610-101010-delta-9-ideia | .hbn/proposals/20260610-101010-delta-9-ideia.md | proposal | quente | — | 2026-06-10T10:10:10-03:00 |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: agente do nome fora de escrita_paralela"          block "$(run_num "$d")"
rm -rf "$d"

# caso-ruim 0030/F-01 · 0031/F-05: colisão de PREFIXO — escrita_paralela
# declara só `alpha`; arquivo de `alpha-1` (apelido conhecido: é o
# implementador do STATE) NÃO pode passar como agente alpha + slug "1-…".
d="$(make_num_repo "[alpha]")"
(
    cd "$d"
    echo "ideia" > .hbn/proposals/20260610-101010-alpha-1-ideia.md
    echo "| 20260610-101010-alpha-1-ideia | .hbn/proposals/20260610-101010-alpha-1-ideia.md | proposal | quente | — | 2026-06-10T10:10:10-03:00 |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: prefixo de apelido (alpha-1 vs alpha) NÃO passa como slug (0030/F-01·0031/F-05)" block "$(run_num "$d")"
rm -rf "$d"

# caso-ruim: linha nova do REGISTRY sem coluna created_at (5 colunas)
d="$(make_num_repo "[alpha-1, beta-1]")"
(
    cd "$d"
    echo "ideia" > .hbn/proposals/20260610-101010-alpha-1-ideia.md
    echo "| 20260610-101010-alpha-1-ideia | .hbn/proposals/20260610-101010-alpha-1-ideia.md | proposal | quente | — |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: linha REGISTRY nova sem created_at"               block "$(run_num "$d")"
rm -rf "$d"

# caso-ruim: created_at diverge do HHMMSS do id (um dos dois é de memória)
d="$(make_num_repo "[alpha-1, beta-1]")"
(
    cd "$d"
    echo "ideia" > .hbn/proposals/20260610-101010-alpha-1-ideia.md
    echo "| 20260610-101010-alpha-1-ideia | .hbn/proposals/20260610-101010-alpha-1-ideia.md | proposal | quente | — | 2026-06-10T10:20:30-03:00 |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: created_at diverge do HHMMSS do id"               block "$(run_num "$d")"
rm -rf "$d"

# caso-ruim (ADR-025, onda 0006 I-03 — antes era caso-bom): serial AAAAMMDD-NN
# NOVO em série de evento é BLOQUEADO mesmo fora de ciclo paralelo (F-03).
d="$(make_num_repo "[]")"
(
    cd "$d"
    echo "r" > reports/20260101-07-relatorio.md
    echo "| 20260101-07 | reports/20260101-07-relatorio.md | report | frio | — | 2026-01-01T09:00:00-03:00 |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: serial NOVO em série de evento → BLOCK (ADR-025 F-03)" block "$(run_num "$d")"
rm -rf "$d"

# caso-ruim (ADR-025): serial NNNN novo em .hbn/results/ (o caso 0036/0037)
d="$(make_num_repo "[]")"
(
    cd "$d"
    mkdir -p .hbn/results
    echo "parecer" > .hbn/results/0099-parecer-novo.md
    git add -A
) >/dev/null 2>&1
check "num: serial NNNN novo em results → BLOCK (caso 0036/0037)"  block "$(run_num "$d")"
rm -rf "$d"

# caso-ruim (ADR-025): agente desconhecido em ciclo SERIAL
d="$(make_num_repo "[]")"
(
    cd "$d"
    mkdir -p .hbn/results
    echo "parecer" > .hbn/results/20260611-101010-zeta-9-parecer.md
    git add -A
) >/dev/null 2>&1
check "num: agente desconhecido em série de evento → BLOCK"        block "$(run_num "$d")"
rm -rf "$d"

# caso-ruim (ADR-025 D2.2): created_at em UTC na linha nova do REGISTRY
d="$(make_num_repo "[]")"
(
    cd "$d"
    echo "x" > docs/20260611-101010-alpha-1-nota.md
    echo "| 20260611-101010-alpha-1-nota | docs/20260611-101010-alpha-1-nota.md | doc | frio | — | 2026-06-11T10:10:10Z |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: created_at UTC (sufixo Z) → BLOCK (ADR-025/F-02)"      block "$(run_num "$d")"
rm -rf "$d"

# caso-bom (ADR-025): legado serial MODIFICADO (não-adicionado) é só-leitura
d="$(make_num_repo "[]")"
(
    cd "$d"
    mkdir -p .hbn/results
    echo "legado" > .hbn/results/0001-legado.md
    git add -A && git commit -qm "legado"
    echo "anotacao nova" >> .hbn/results/0001-legado.md
    git add -A
) >/dev/null 2>&1
check "num: legado serial modificado (M) segue passando"           pass  "$(run_num "$d")"
rm -rf "$d"

# caso-ruim 0031/F-01: id SERIAL com data divergente do created_at (linha do
# REGISTRY; arquivo fora de série de evento para isolar a regra 2)
d="$(make_num_repo "[]")"
(
    cd "$d"
    echo "r" > docs/20260101-08-data-errada.md
    echo "| 20260101-08 | docs/20260101-08-data-errada.md | doc | frio | — | 2026-06-10T09:00:00-03:00 |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: id serial com data ≠ created_at (0031/F-01)"      block "$(run_num "$d")"
rm -rf "$d"

# caso-ruim skew (herda E-FECH-02): created_at só na working tree; staged sem
d="$(make_num_repo "[alpha-1, beta-1]")"
(
    cd "$d"
    echo "ideia" > .hbn/proposals/20260610-101010-alpha-1-ideia.md
    echo "| 20260610-101010-alpha-1-ideia | .hbn/proposals/20260610-101010-alpha-1-ideia.md | proposal | quente | — |" >> REGISTRY.md
    git add -A
    # conserta a working tree SEM re-stage — o commit sairia sem created_at
    sed -i.bak 's/| quente | — |$/| quente | — | 2026-06-10T10:10:10-03:00 |/' REGISTRY.md && rm -f REGISTRY.md.bak
) >/dev/null 2>&1
check "num: REGISTRY staged sem created_at; working tree com (skew)" block "$(run_num "$d")"
rm -rf "$d"

# compatibilidade G-REG × created_at (ADR-024 risco R5): linha de 6 colunas
# continua casando o grep de coluna exata do assert-registry-line.
d="$(make_repo)"
(
    cd "$d"
    echo "r" > reports/20260101-06-compat.md
    echo "| 20260101-06 | reports/20260101-06-compat.md | report | frio | — | 2026-01-01T09:00:00-03:00 |" >> REGISTRY.md
    git add -A
) >/dev/null 2>&1
check "num: linha de 6 colunas com created_at passa no G-REG (R5)" pass "$(run_reg "$d")"
rm -rf "$d"

# --- G-PTR: assert-pointer-honest (ADR-024 D3 / pointer-spec §3) --------------
echo "== assert-pointer-honest (G-PTR) =="
# Repo descartável com destino íntegro (front-matter path: == caminho real).
make_ptr_repo() {
    local d; d="$(mktemp -d)"
    (
        cd "$d"
        git init -q
        git config user.email "tests@hbn.local"
        git config user.name "hbn-guard-tests"
        mkdir -p .hbn/messages docs/prompts core
        printf -- '---\npath: core/alvo-spec.md\n---\ncorpo\n' > core/alvo-spec.md
        printf -- '---\npath: docs/outro-lugar.md\n---\ncorpo\n' > core/mentiroso.md
        git add -A
        git commit -qm "init"
    ) >/dev/null 2>&1
    echo "$d"
}
run_ptr() {
    ( cd "$1" && bash "$GUARDS_DIR/assert-pointer-honest.sh" >/dev/null 2>&1 )
    echo $?
}

# caso-bom: ponteiro íntegro (path existe no staged, == front-matter, com ação)
d="$(make_ptr_repo)"
( cd "$d" && printf -- '⟦HBN⟧ [core/alvo-spec.md](file:///x/core/alvo-spec.md) · sinal: 🔵 · ação: ler a spec\n' > .hbn/messages/20260610-90-h.md && git add -A ) >/dev/null 2>&1
check "ptr: ponteiro íntegro (path existe, == front-matter, com ação)"  pass  "$(run_ptr "$d")"
rm -rf "$d"

# caso-ruim: path inexistente no staged
d="$(make_ptr_repo)"
( cd "$d" && printf -- '⟦HBN⟧ [core/nao-existe.md](file:///x/core/nao-existe.md) · sinal: 🔵 · ação: ler\n' > .hbn/messages/20260610-90-h.md && git add -A ) >/dev/null 2>&1
check "ptr: path inexistente no staged"                                 block "$(run_ptr "$d")"
rm -rf "$d"

# caso-ruim: destino existe mas front-matter declara outro path:
d="$(make_ptr_repo)"
( cd "$d" && printf -- '⟦HBN⟧ [core/mentiroso.md](file:///x/core/mentiroso.md) · sinal: 🔵 · ação: ler\n' > .hbn/messages/20260610-90-h.md && git add -A ) >/dev/null 2>&1
check "ptr: path existe mas front-matter declara outro path:"           block "$(run_ptr "$d")"
rm -rf "$d"

# caso-ruim: linha ⟦HBN⟧ sem ação:
d="$(make_ptr_repo)"
( cd "$d" && printf -- '⟦HBN⟧ [core/alvo-spec.md](file:///x/core/alvo-spec.md) · sinal: 🔵\n' > .hbn/messages/20260610-90-h.md && git add -A ) >/dev/null 2>&1
check "ptr: linha sem ação:"                                            block "$(run_ptr "$d")"
rm -rf "$d"

# pass-com-aviso: href cuja cauda não termina no path relativo (só AVISO)
d="$(make_ptr_repo)"
( cd "$d" && printf -- '⟦HBN⟧ [core/alvo-spec.md](file:///tmp/outra-coisa.md) · sinal: 🔵 · ação: ler\n' > .hbn/messages/20260610-90-h.md && git add -A ) >/dev/null 2>&1
check "ptr: href divergente do path relativo (pass-com-aviso)"          pass  "$(run_ptr "$d")"
rm -rf "$d"

# caso-bom 0031/F-02: exemplo de ⟦HBN⟧ dentro de code-fence é IGNORADO
# (path fictício de template não vira falso-positivo de ponteiro mentiroso)
d="$(make_ptr_repo)"
(
    cd "$d"
    {
        printf -- '⟦HBN⟧ [core/alvo-spec.md](file:///x/core/alvo-spec.md) · sinal: 🔵 · ação: ler a spec\n'
        printf -- '```\n⟦HBN⟧ [caminho/falso-exemplo.md](file:///x/caminho/falso-exemplo.md) · sinal: 🔵 · ação: exemplo de template\n```\n'
    } > .hbn/messages/20260610-90-h.md
    git add -A
) >/dev/null 2>&1
check "ptr: exemplo ⟦HBN⟧ em code-fence ignorado (0031/F-02)"           pass  "$(run_ptr "$d")"
rm -rf "$d"

# caso-ruim skew (herda E-FECH-01/02): destino bom só na working tree
d="$(make_ptr_repo)"
(
    cd "$d"
    printf -- '⟦HBN⟧ [core/so-na-worktree.md](file:///x/core/so-na-worktree.md) · sinal: 🔵 · ação: ler\n' > .hbn/messages/20260610-90-h.md
    git add -A
    printf -- '---\npath: core/so-na-worktree.md\n---\ncorpo\n' > core/so-na-worktree.md
) >/dev/null 2>&1
check "ptr: destino bom só na working tree, ausente do staged (skew)"   block "$(run_ptr "$d")"
rm -rf "$d"

# --- G-RLT: assert-report-fresh (ADR-024 D4+D6 / state-report-spec §4) --------
echo "== assert-report-fresh (G-RLT) =="
# Repo descartável com STATE; handoff parametrizável por heredoc nos casos.
make_rlt_repo() { # $1 = proxima_acao do STATE  $2 = ultima_atualizacao do STATE
    local d; d="$(mktemp -d)"
    (
        cd "$d"
        git init -q
        git config user.email "tests@hbn.local"
        git config user.name "hbn-guard-tests"
        mkdir -p .hbn/relay .hbn/messages docs
        cat > .hbn/relay/STATE.md <<EOF
---
proxima_acao: "${1}"
ultima_atualizacao: "${2}"
---
EOF
        echo base > docs/base.md
        git add -A
        git commit -qm "init"
    ) >/dev/null 2>&1
    echo "$d"
}
run_rlt() {
    ( cd "$1" && bash "$GUARDS_DIR/assert-report-fresh.sh" >/dev/null 2>&1 )
    echo $?
}
# relato canônico: $1=proxima_acao citada  $2=ultima_atualizacao citada  $3=capsula? (s/n)  $4..=linhas extra de SINAIS
write_handoff() { # imprime em stdout
    local pa="$1" ua="$2" capsula="$3"; shift 3
    echo "RELATO DE ESTADO — alpha-1 · conversacional-orquestrador · ${ua}"
    echo "STATE: ultima_atualizacao=${ua} · bastão → beta-1 · contexto ~40% do threshold"
    echo "SINAIS: nenhum novo"
    for extra in "$@"; do echo "SINAIS: ${extra}"; done
    echo "FEITO: guards implementados"
    echo "PENDENTE: cross-audit"
    echo "PONTEIROS: ⟦HBN⟧ docs/base.md · sinal: 🔵 · ação: auditar"
    echo "PRÓXIMA AÇÃO: ${pa}"
    echo "PARA O HUMANO: rodar a suíte e revisar o diff"
    echo ""
    if [[ "$capsula" == "s" ]]; then
        echo "## Decisões informais (cápsula)"
        echo "nenhuma"
    fi
}

PA="auditar os guards da orquestracao-start"
UA="2026-06-10T21:00:00-03:00"

# caso-bom: relato íntegro, proxima_acao idêntica, cápsula presente
d="$(make_rlt_repo "$PA" "$UA")"
( cd "$d" && write_handoff "$PA" "$UA" s > .hbn/messages/20260610-91-h.md && git add -A ) >/dev/null 2>&1
check "rlt: relato íntegro, proxima_acao idêntica, cápsula presente"   pass  "$(run_rlt "$d")"
rm -rf "$d"

# caso-ruim: handoff sem bloco RELATO DE ESTADO
d="$(make_rlt_repo "$PA" "$UA")"
( cd "$d" && echo "handoff sem relato nenhum" > .hbn/messages/20260610-91-h.md && git add -A ) >/dev/null 2>&1
check "rlt: handoff sem bloco RELATO DE ESTADO"                        block "$(run_rlt "$d")"
rm -rf "$d"

# caso-ruim: proxima_acao parafraseada (≠ string exata do STATE)
d="$(make_rlt_repo "$PA" "$UA")"
( cd "$d" && write_handoff "auditar guards" "$UA" s > .hbn/messages/20260610-91-h.md && git add -A ) >/dev/null 2>&1
check "rlt: proxima_acao parafraseada (≠ string do STATE)"             block "$(run_rlt "$d")"
rm -rf "$d"

# caso-ruim: ultima_atualizacao de memória (≠ STATE staged)
d="$(make_rlt_repo "$PA" "$UA")"
( cd "$d" && write_handoff "$PA" "2026-06-10T20:00:00-03:00" s > .hbn/messages/20260610-91-h.md && git add -A ) >/dev/null 2>&1
check "rlt: ultima_atualizacao de memória (≠ STATE staged)"            block "$(run_rlt "$d")"
rm -rf "$d"

# caso-ruim: chapéu orquestrador sem seção de cápsula
d="$(make_rlt_repo "$PA" "$UA")"
( cd "$d" && write_handoff "$PA" "$UA" n > .hbn/messages/20260610-91-h.md && git add -A ) >/dev/null 2>&1
check "rlt: orquestrador sem seção cápsula"                            block "$(run_rlt "$d")"
rm -rf "$d"

# caso-ruim 0030/F-02: palavra "(cápsula)" solta fora do heading exato é
# teatro de cápsula — não satisfaz a Decisão 6 do ADR-024.
d="$(make_rlt_repo "$PA" "$UA")"
(
    cd "$d"
    {
        write_handoff "$PA" "$UA" n
        echo "NOTA: a seção de (cápsula) ainda não existe neste handoff"
    } > .hbn/messages/20260610-91-h.md
    git add -A
) >/dev/null 2>&1
check "rlt: '(cápsula)' fora do heading exato (teatro) (0030/F-02)"    block "$(run_rlt "$d")"
rm -rf "$d"

# caso-ruim skew (E-FECH-02): STATE bom só na working tree; staged velho
d="$(make_rlt_repo "acao antiga que ficou no staged" "2026-06-10T19:00:00-03:00")"
(
    cd "$d"
    write_handoff "$PA" "$UA" s > .hbn/messages/20260610-91-h.md
    git add -A
    # atualiza o STATE na working tree SEM re-stage — o commit levaria o velho
    cat > .hbn/relay/STATE.md <<EOF
---
proxima_acao: "${PA}"
ultima_atualizacao: "${UA}"
---
EOF
) >/dev/null 2>&1
check "rlt: STATE bom só na working tree; staged velho (skew)"         block "$(run_rlt "$d")"
rm -rf "$d"

# pass-com-aviso: relato de 12 linhas (só AVISO de inflação)
d="$(make_rlt_repo "$PA" "$UA")"
( cd "$d" && write_handoff "$PA" "$UA" s "extra 1" "extra 2" "extra 3" "extra 4" > .hbn/messages/20260610-91-h.md && git add -A ) >/dev/null 2>&1
check "rlt: relato de 12 linhas (pass-com-aviso)"                      pass  "$(run_rlt "$d")"
rm -rf "$d"

# --- Guards LEGADOS: testes negativos (pré-condição do STATE para ativar os
# guards novos no runner — sinal 🟡 de 2026-06-10; pagos em 2026-06-11,
# readback 0005). Cada legado ganha ≥1 caso-ruim (block) + 1 caso-bom (pass).
# G-CR e G-TMP usam repo FORA de /tmp (mktemp -p $TESTS_DIR) no caso-bom,
# porque ambos recusam /tmp por construção. -----------------------------------
echo "== guards legados (G-CR/G-TMP/G-ENV/G-LEG/G-SCO) =="

# G-ENV: forbid-env-files
d="$(make_repo)"
( cd "$d" && echo "SECRET=x" > .env && git add .env ) >/dev/null 2>&1
check "env: .env staged"                                block "$( ( cd "$d" && bash "$GUARDS_DIR/forbid-env-files.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"
d="$(make_repo)"
( cd "$d" && echo "ok" > nota-comum.txt && git add nota-comum.txt ) >/dev/null 2>&1
check "env: arquivo comum passa"                        pass  "$( ( cd "$d" && bash "$GUARDS_DIR/forbid-env-files.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# G-LEG: forbid-legacy-paths (lista em .hbn/forbidden-paths.txt)
d="$(make_repo)"
( cd "$d" && mkdir -p .hbn legacy && printf 'legacy/*\n' > .hbn/forbidden-paths.txt && echo x > legacy/velho.md && git add -A ) >/dev/null 2>&1
check "leg: arquivo em path proibido staged"            block "$( ( cd "$d" && bash "$GUARDS_DIR/forbid-legacy-paths.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"
d="$(make_repo)"
( cd "$d" && mkdir -p .hbn && printf 'legacy/*\n' > .hbn/forbidden-paths.txt && echo ok > core/livre.md && git add -A ) >/dev/null 2>&1
check "leg: lista presente, nada casa"                  pass  "$( ( cd "$d" && bash "$GUARDS_DIR/forbid-legacy-paths.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# G-SCO: assert-scope-lock (readback ativo governa o staged)
make_sco_repo() { # $1=track $2=human_status $3=allowed (JSON array)
    local d; d="$(make_repo)"
    ( cd "$d" && mkdir -p .hbn/readbacks && cat > .hbn/readbacks/0001-t.json <<EOF
{"readback_id":"0001-t","track":"${1}","human_status":"${2}","scope":{"files_allowed":${3},"files_forbidden":[]}}
EOF
    ) >/dev/null 2>&1
    echo "$d"
}
run_sco() { ( cd "$1" && bash "$GUARDS_DIR/assert-scope-lock.sh" >/dev/null 2>&1 ); echo $?; }
d="$(make_sco_repo safe_track confirmed '["docs/**"]')"
( cd "$d" && echo fora > core/fora-do-escopo.md && git add core/fora-do-escopo.md ) >/dev/null 2>&1
check "sco: staged FORA do files_allowed"               block "$(run_sco "$d")"
rm -rf "$d"
d="$(make_sco_repo safe_track pendente '["docs/**"]')"
( cd "$d" && echo x > docs/dentro.md && git add docs/dentro.md ) >/dev/null 2>&1
check "sco: safe_track sem human_status=confirmed"      block "$(run_sco "$d")"
rm -rf "$d"
d="$(make_sco_repo safe_track confirmed '[]')"
( cd "$d" && echo x > docs/dentro.md && git add docs/dentro.md ) >/dev/null 2>&1
check "sco: files_allowed VAZIO é inválido (caso 0004)" block "$(run_sco "$d")"
rm -rf "$d"
d="$(make_sco_repo safe_track confirmed '["docs/**"]')"
( cd "$d" && echo x > docs/dentro.md && git add docs/dentro.md ) >/dev/null 2>&1
check "sco: staged dentro do files_allowed"             pass  "$(run_sco "$d")"
rm -rf "$d"

# G-CR: assert-canonical-root
d="$(mktemp -d)"
( cd "$d" && git init -q && mkdir .hbn && echo "/outro/lugar/canonico" > .hbn/canonical-root ) >/dev/null 2>&1
check "cr: toplevel ≠ canonical-root (e em /tmp)"       block "$( ( cd "$d" && bash "$GUARDS_DIR/assert-canonical-root.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"
d="$(mktemp -d -p "$TESTS_DIR" cr-pass.XXXXXX)"
( cd "$d" && git init -q && mkdir .hbn && pwd -P > .hbn/canonical-root ) >/dev/null 2>&1
check "cr: toplevel == canonical-root (fora de /tmp)"   pass  "$( ( cd "$d" && bash "$GUARDS_DIR/assert-canonical-root.sh" >/dev/null 2>&1 ); echo $? )"
# I-05 (F-05): CI=true SOLTO em ambiente local é bypass → BLOCK, mesmo com raiz certa
check "cr: CI=true local (sem GITHUB_ACTIONS+HBN_DIFF_BASE) → BLOCK (F-05)" block "$( ( cd "$d" && CI=true bash "$GUARDS_DIR/assert-canonical-root.sh" >/dev/null 2>&1 ); echo $? )"
# I-05: skip de CI REAL (provedor + range) continua funcionando
check "cr: CI real (GITHUB_ACTIONS=true + HBN_DIFF_BASE) → skip legítimo" pass "$( ( cd "$d" && GITHUB_ACTIONS=true HBN_DIFF_BASE=abc123 CI=true bash "$GUARDS_DIR/assert-canonical-root.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"
# I-05: raiz divergente AUTORIZADA por .hbn/alt-roots (glob) → PASS
d="$(mktemp -d -p "$TESTS_DIR" cr-alt.XXXXXX)"
(
    cd "$d" && git init -q && mkdir .hbn
    echo "/outro/lugar/canonico" > .hbn/canonical-root
    printf '# raizes alternativas de teste\n%s\n' "$(pwd -P)" > .hbn/alt-roots
) >/dev/null 2>&1
check "cr: raiz divergente em .hbn/alt-roots → PASS (rastreável)" pass "$( ( cd "$d" && bash "$GUARDS_DIR/assert-canonical-root.sh" >/dev/null 2>&1 ); echo $? )"
# I-05: alt-roots VAZIO (só comentário) + raiz divergente → BLOCK (fail-closed)
( cd "$d" && printf '# vazio de proposito\n' > .hbn/alt-roots ) >/dev/null 2>&1
check "cr: alt-roots vazio + raiz divergente → BLOCK"   block "$( ( cd "$d" && bash "$GUARDS_DIR/assert-canonical-root.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# G-TMP: forbid-tmp-worktree — caso-ruim FORÇA /tmp literal (mktemp honra
# TMPDIR e pode cair fora de /tmp — ex.: sandbox/macOS), o guard cobre
# /tmp/* e /private/tmp/* (symlink macOS).
d="/tmp/hbn-tmp-worktree-test.$$"
( mkdir -p "$d" && cd "$d" && git init -q && git config user.email t@h && git config user.name t && git commit -q --allow-empty -m i ) >/dev/null 2>&1
check "tmp: worktree principal em /tmp"                 block "$( ( cd "$d" && bash "$GUARDS_DIR/forbid-tmp-worktree.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"
d="$(mktemp -d -p "$TESTS_DIR" tmp-pass.XXXXXX)"
( cd "$d" && git init -q && git config user.email t@h && git config user.name t && git commit -q --allow-empty -m i ) >/dev/null 2>&1
check "tmp: worktree fora de áreas voláteis"            pass  "$( ( cd "$d" && bash "$GUARDS_DIR/forbid-tmp-worktree.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# --- Bypass com nota staged (onda 0006 I-06 — F-10) --------------------------
echo "== bypass env só com nota staged (F-10) =="
# env=1 SEM nota: o caso-ruim continua BLOQUEADO (bypass ignorado)
d="$(make_repo)"
( cd "$d" && echo "SECRET=x" > .env && git add .env ) >/dev/null 2>&1
check "byp: HBN_GUARDS_BYPASS=1 sem nota → caso-ruim ainda BLOCK" block "$( ( cd "$d" && HBN_GUARDS_BYPASS=1 bash "$GUARDS_DIR/forbid-env-files.sh" >/dev/null 2>&1 ); echo $? )"
check "byp: GLASSWING_BYPASS=1 sem nota → caso-ruim ainda BLOCK"  block "$( ( cd "$d" && GLASSWING_BYPASS=1 bash "$GUARDS_DIR/forbid-env-files.sh" >/dev/null 2>&1 ); echo $? )"
# env=1 COM nota ADICIONADA no diff staged: bypass vale (com aviso)
( cd "$d" && mkdir -p .hbn/bypasses && echo "motivo: teste" > .hbn/bypasses/20260611-120000-tester-motivo-teste.md && git add .hbn/bypasses/20260611-120000-tester-motivo-teste.md ) >/dev/null 2>&1
check "byp: HBN_GUARDS_BYPASS=1 com nota staged → skip com aviso" pass  "$( ( cd "$d" && HBN_GUARDS_BYPASS=1 bash "$GUARDS_DIR/forbid-env-files.sh" >/dev/null 2>&1 ); echo $? )"
rm -rf "$d"

# --- G-STRAY: assert-no-stray-hbn (árvore sintética via HBN_SCAN_ROOT) -------
echo "== assert-no-stray-hbn (G-STRAY) =="
run_stray() { ( HBN_SCAN_ROOT="$1" bash "$GUARDS_DIR/assert-no-stray-hbn.sh" >/dev/null 2>&1 ); echo $?; }
# caso-bom: .hbn dentro de raiz de repo git
r="$(mktemp -d)"
( mkdir -p "$r/repoA/.git" "$r/repoA/.hbn" ) >/dev/null 2>&1
check "stray: .hbn em raiz de repo git"                 pass  "$(run_stray "$r")"
# caso-ruim: .hbn órfão direto na raiz varrida (o incidente opus-4-8)
( mkdir -p "$r/.hbn/results" ) >/dev/null 2>&1
check "stray: .hbn órfão na raiz varrida"               block "$(run_stray "$r")"
rm -rf "$r"
# caso-ruim: .hbn órfão em subpasta que não é repo
r="$(mktemp -d)"
( mkdir -p "$r/projetos/soltinho/.hbn" ) >/dev/null 2>&1
check "stray: .hbn órfão em subpasta sem .git"          block "$(run_stray "$r")"
# caso-bom: .hbn sob backups/ é cópia fria, não órfão operacional (poda)
rm -rf "$r"; r="$(mktemp -d)"
( mkdir -p "$r/backups/copia-antiga/.hbn" "$r/repoB/.git" "$r/repoB/.hbn" ) >/dev/null 2>&1
check "stray: .hbn sob backups/ é podado (cópia fria)"  pass  "$(run_stray "$r")"
rm -rf "$r"

# --- Read-list viva (onda 0006 I-01 — F-08 dos cross-audits 0036/0037) -------
# Todo path .hbn/ | core/ | guards/ | schemas/ CITADO em agents/role-templates.md
# e nos 4 specs core do rito deve EXISTIR no disco. A "referência quebrada"
# (knowledge 0019/0022 citadas sem existir) vira classe de erro permanente.
echo "== read-list viva (referência citada deve existir) =="
readlist_scan() { # <arquivo...> ; rc=0 se todos os paths citados existem
    local missing=0 f p
    for f in "$@"; do
        [[ -f "$f" ]] || { echo "    arquivo da read-list ausente: $f"; missing=1; continue; }
        while IFS= read -r p; do
            [[ -z "$p" ]] && continue
            p="${p%.}"          # pontuação final de frase
            [[ "$p" == *NNNN* || "$p" == *AAAAMMDD* || "$p" == *\<* ]] && continue
            if compgen -G "$REPO_ROOT/${p}*" >/dev/null; then continue; fi
            echo "    referência quebrada: ${p} (citada em $(basename "$f"))"
            missing=1
        done < <(grep -ohE '(\.hbn/[A-Za-z0-9_./-]+|core/[A-Za-z0-9_./-]+|guards/[A-Za-z0-9_./-]+|schemas/[A-Za-z0-9_./-]+)' "$f" 2>/dev/null | sort -u)
    done
    return $missing
}
run_readlist() { ( readlist_scan "$@" >/dev/null 2>&1 ); echo $?; }
check "readlist: templates+4 specs core sem referência quebrada" pass "$(run_readlist \
    "$REPO_ROOT/agents/role-templates.md" \
    "$REPO_ROOT/core/start-rite-spec.md" \
    "$REPO_ROOT/core/orchestrator-profile-spec.md" \
    "$REPO_ROOT/core/pointer-spec.md" \
    "$REPO_ROOT/core/state-report-spec.md")"
# caso-ruim (ADR-020): citação de path inexistente DEVE reprovar
r="$(mktemp -d)"
printf 'leia .hbn/knowledge/9999-inexistente.md antes de tudo\n' > "$r/template-quebrado.md"
check "readlist: referência quebrada é detectada (F-08)"        block "$(run_readlist "$r/template-quebrado.md")"
rm -rf "$r"

# --- Resumo humano (Bloco 4 dogfood) -----------------------------------------
echo ""
echo "== resumo: ${PASS} passaram, ${FAIL} falharam =="
if [[ "$FAIL" -ne 0 ]]; then
    for f in "${FALHAS[@]}"; do echo "  ✗ $f"; done
    echo "SUÍTE VERMELHA — nenhum guard pode ser ativado no runner (ADR-020 Decisão 2)."
    exit 1
fi
echo "SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam."
exit 0
