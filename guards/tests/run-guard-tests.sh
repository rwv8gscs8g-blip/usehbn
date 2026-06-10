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
#   proposed — cobrem E-RE-01 (0025), F-01/F-02/F-04 (0026), ADR-021, ADR-023.
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
