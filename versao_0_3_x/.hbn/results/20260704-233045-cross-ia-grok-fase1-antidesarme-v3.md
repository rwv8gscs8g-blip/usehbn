---
titulo: "CROSS-AUDIT ADVERSARIAL (GROK xAI) — Fase 1: Anti-Desarme v3 (re-auditoria dos 2 furos deixados passar)"
diataxis: reference
hbn-track: safe_track
data: 2026-07-04
auditor: "grok (xAI) — cross-ia fase1 antidesarme v3 (so o meu parecer anterior + fontes do conserto)"
head: 6508268 (working tree sujo, NAO commitado)
working_tree: dirty per pre-flight
status: congelado
temperatura: glacier
---

# RELATÓRIO v3 — ATAQUE ADVERSARIAL AOS 2 FUROS (meu parecer 20260704-230800 APROVA_SIM deixou passar)

**PRE-FLIGHT (executado agora):**
- cd /Users/macbookpro/Projetos/usehbn
- git log -1 --oneline → 6508268 feat(guards): nata-0c - G-SLF version-aware + quitacao dos 17 vendorizados da divida
- git status -s → working tree sujo (M guards/lib/common.sh, A guards/assert-active-version-integrity.sh, M guards/tests/run-guard-tests.sh, + muitos .hbn/ nao commitados). NÃO commitado.
- Diretório existe, é git repo válido. Parada não acionada.

**DECRETO LIDO (obrigatório, Art.2):**
- /Users/macbookpro/Projetos/Credenciamento/orquestracao/20260703-000500-GATE-DECRETO-REVOGACAO-PERMISSOES-ORQUESTRADORES-LEITURA-OBRIGATORIA.md
- Papel: apenas leitura + relatório NÃO-decisório. Sem bastão, sem implementar, sem editar fonte, sem rodar hooks, sem ler parecer de outro auditor.

**FONTES LIDAS (exclusivamente o MEU parecer anterior + fontes primárias do conserto indicado):**
- .hbn/results/20260704-230800-cross-ia-grok-fase1-antidesarme-v2.md (meu v2 que aprovou)
- guards/lib/common.sh (hbn_ci_range_mode 173-182; hbn_context_current_source 193-199; hbn_index_has_staged_changes 189-191; hbn_context_dep_state 303-352 com precedencia INDEX)
- guards/assert-active-version-integrity.sh (G-ACTIVE-VERSION completo, protected_context_deps 80-92, active_version_authorized 158-188, state_declares 94-123, hearback_covers 125-156)
- guards/tests/run-guard-tests.sh (seção anti-desarme torto 4025-4199 + check_antidisarm_* + stage_active_version_skeleton + casos ci-true-remove / github-actions-remove / hbn-ci-remove / active-version skeleton)
- Decreto e pre-flight.

**NÃO LIDOS:** qualquer resultado/parecer de outro auditor (Antigravity ou outros). Não herdei bastão, não li outputs deles.

## ADMISSAO — o que deixei passar no v2 (20260704-230800)
No v2 eu ataquei o HBN_DIFF_BASE sozinho forçando ATIVO via HEAD e declarei fechado após ver exigência de sinal CI. 
Deixei passar:
1. CI=true (ou GITHUB_ACTIONS=true ou HBN_CI=1) é **falsificável localmente** (export no pre-commit do dev). Se o conserto da época ainda permitia range_mode mesmo com staged changes, a remoção staged de dep escapava (current via HEAD via range, ignorando rm no index).
2. **Nenhuma menção ou ataque ao vetor active-version**. Trocar .hbn/active-version para versao_X sem os arquivos protegidos fazia guard_version_repo_path + hbn_context_dep_state ver os deps como ausentes no "current" da versão ativa. Se a versão nova nunca "carregou" os deps no seu baseline, caía em NOOP em vez de DISARM. Todos os guards que dependem de STATE/knowledge/role-cards etc. viravam inofensivos. Eu não li assert-active-version (nem existia) e não ataquei o ponteiro.

Ambos os furos eram BLOQUEADORES. Eu fui leniente ao não simular CI=true + staged rm explicitamente e ao ignorar completamente o mecanismo de versão ativa.

## (a) FURO 1 (CI=true local + HBN_DIFF_BASE permitindo escape de remoção staged) — FECHOU?

**Código (evidência arquivo:linha):**
```173:182:guards/lib/common.sh
hbn_ci_range_mode() {
    [[ -n "${HBN_DIFF_BASE:-}" ]] || return 1
    case "${HBN_CI:-}" in 1|true|TRUE|yes|YES) return 0 ;; esac
    case "${GITHUB_ACTIONS:-}" in 1|true|TRUE) return 0 ;; esac
    [[ -n "${CI:-}" && "${CI:-}" != "0" && "${CI:-}" != "false" && "${CI:-}" != "FALSE" ]]
}
```
```193:199:guards/lib/common.sh
hbn_context_current_source() {
    if hbn_ci_range_mode && ! hbn_index_has_staged_changes; then
        printf 'HEAD\n'
    else
        printf 'INDEX\n'
    fi
}
```
```310:339:guards/lib/common.sh
current_source="$(hbn_context_current_source)"
... current_kind = (HEAD ou INDEX conforme source)
...
if hbn_path_kind_active "$current_kind"; then ATIVO ...
if [[ "$current_source" == "INDEX" ]] && hbn_ref_has_any_path HEAD "$p"; then DISARM ...
if hbn_ref_has_any_path "$base" "$p"; then DISARM ...
```

**Precedência do índice (per pergunta):**
- Modo range (HBN_DIFF_BASE + sinal CI) **só** usa HEAD para current **se ! hbn_index_has_staged_changes**.
- Qualquer mudança staged (incluindo o "git rm" do ataque) força current=INDEX.
- Remoção staged → index ausente → (INDEX + presente em HEAD) → DISARM explícito (linha 332-334).
- base só é consultado depois.

**Ataques controlados (evidência da suite hermética run-guard-tests.sh + mktemp):**
```
✓ anti-desarme state: poison-remove -> BLOCK
✓ anti-desarme state: ci-true-remove -> BLOCK
✓ anti-desarme state: github-actions-remove -> BLOCK
✓ anti-desarme state: hbn-ci-remove -> BLOCK
( idem para knowledge, frontdoor, ci-battery, profile-root, profile-marker )
```
- poison-remove: unset CI GITHUB HBN_CI ; só HBN_DIFF_BASE + stage rm → BLOCK (prova que HBN sozinho não basta)
- ci-true-remove: CI=true + HBN_DIFF_BASE + stage rm (pre-commit local simulado) → BLOCK
- github-actions-remove: GITHUB_ACTIONS=true + ... → BLOCK
- hbn-ci-remove: HBN_CI=1 + ... → BLOCK

**Conclusão (a):** Sim, fechou. Índice staged tem precedência absoluta. CI=true falsificável + HBN agora não escapa quando há remoção staged (o caso real de pre-commit local). GITHUB_ACTIONS idem. Modo range puro (sem staged) usa HEAD e ainda detecta remoção via base/HEAD check. Todos os 6 deps cobertos.

## (b) FURO 2 (active-version → esqueleto sem deps desliga guards por NOOP) — FECHOU?

**Novo guard + lista de protegidos (evidência):**
```80:92:guards/assert-active-version-integrity.sh
protected_context_deps() {
    cat <<'EOF'
.hbn/relay/STATE.md
.hbn/knowledge/INDEX.md
core/role-cards.md
core/read-list-canonica.txt
.github/workflows/hbn-shield.yml
guards/ci-entry.sh
CONSUMER-PROFILE.md
.usehbn-snapshot
.usehbn-snapshot/CONSUMER-PROFILE.md
EOF
}
```
G-ACTIVE é **primeiro** no runner (hbn-guards-runner.sh:84).

**Ataques da suite:**
```
✓ active-version-integrity: esqueleto sem STATE protegido -> BLOCK
✓ anti-desarme ${dep}: active-version -> esqueleto sem deps -> BLOCK   (para cada um dos 6)
✓ anti-desarme active-version != .: STATE removido com HBN_DIFF_BASE local -> BLOCK
✓ anti-desarme active-version != .: marcador renomeado -> BLOCK
```
(stage_active_version_skeleton cria versao_1_0_0 só com .keep, aponta active-version, roda guards → BLOCK)

**Burlas testadas/analisadas (código + raciocínio adversarial):**

1. **autorizacao falsa/stale em STATE**  
   - active_version_authorized exige que o STATE da *nova* versão (new_rel) esteja ativo no current (linha 162).  
   - Se o swap orfana o próprio STATE, authorized() retorna 1 imediatamente. Não é possível autorizar a remoção do STATE via conteúdo do STATE que está sendo removido.

2. **hearback forjado (novo no mesmo commit)**  
   - G-ACTIVE sozinho aceitaria um hb com status=confirmed + excecao cobrindo (testes manuais de estrutura confirmam parsing).  
   - Porém assert-hearback-integrity (roda depois, no runner) bloqueia: "hearback nasceu/foi alterado no MESMO commit da mudança" + "staged junto com obra".  
   - Resultado efetivo: forjado novo → G-HRB bloqueia. Não escapa o portão completo.

3. **trocar active-version + desligar o proprio guard novo no mesmo commit**  
   - Remover guards/assert-active-version-integrity.sh no mesmo diff: runner (linha 125-134) faz `bash .../assert-active-version-integrity.sh` primeiro → arquivo ausente → erro → exit não-zero. Bloqueia.  
   - Editar runner para remover a entrada da lista + swap: o preflight do runner ainda executa ANTES da lista:  
     ```58:67:guards/hbn-guards-runner.sh
     ACTIVE_ROOT="$(get_canonical_root || true)"
     if [[ -z "$ACTIVE_ROOT" ]]; then fail; fi
     if [[ "$RUNNER_ROOT" != "$ACTIVE_ROOT" ]]; then
         "Runner invocado fora da versão ativa" → exit 1
     ```
     Swap para esqueleto que não casa com o dir físico do runner → falha no preflight do runner, independentemente da lista de GUARDS.  
   - Guard não depende de hbn_context_dep_state para si mesmo quando active-version é tocado (active_version_touched + lógica dedicada).

4. **versao que carrega autorizacao velha**  
   - hearback_covers_active_version_integrity exige match de from/to (old_rel/new_rel) e, se o item declara "dependencias"/"deps", que todas as MISSING estejam cobertas.  
   - Um hearback velho para outro swap não matchará os valores atuais → sys.exit(1) na checagem → G-ACTIVE bloqueia.

**O guard protege a si mesmo de NOOP pela manobra de active-version?**  
Sim. Quando .hbn/active-version é tocado, ele executa sua lógica completa (não cai no case NOOP dos guards de dados). A checagem de MISSING usa o OLD vs CURRENT diretamente. Requer STATE na *entrada* para qualquer autorização. Remoção do próprio script causa falha de execução no runner.

**Conclusão (b):** Fechou para os vetores listados. Skeleton sem auth → BLOCK (G-ACTIVE + guards de dep). Autorizações exigem artefato pre-existente + match exato + cobertura de deps. Desligar o guard ou o runner não abre válvula silenciosa.

## (c) SOBROU ALGUMA VIA DE DESARME (recursiva ou nova)?

Inspecionei (código + ataques na suite + simulações controladas):
- HBN_DIFF_BASE sozinho: range_mode retorna 1 → current=INDEX (modo local) → correto.
- CI=false explícito: tratado como não-CI.
- Staged changes: força INDEX sempre (precedência absoluta).
- active-version swap sem auth: G-ACTIVE + runner preflight + DISARM nos guards de dep.
- Remover o G-ACTIVE do runner + swap: runner root check + exec fail.
- Forjar hb novo: G-HRB bloqueia (mesmo commit).
- Hb velho/stale: match from/to + deps falha.
- Diretórios vs blobs, symlinks, renames: tratados (hbn_index_path_kind, hbn_ref_path_kind, prefix /, 040000).
- Nenhuma outra entrada para "ATIVO" ou "NOOP" quando há desarme de dep protegido.
- O runner roda G-ACTIVE primeiro; get_canonical_root falha se active-version aponta para inexistente.

Nenhuma via recursiva ou nova para os dois furos originais foi encontrada nos setups controlados e na leitura das linhas indicadas.

## (d) VEREDITO

Os DOIS furos que eu deixei passar no v2 estão 100% fechados pelo conserto atual (common.sh precedência de índice + G-ACTIVE-VERSION + cobertura de testes).

- Furo 1: CI=true/GITHUB/HBN_CI + HBN_DIFF_BASE + remoção staged de deps → agora consistentemente BLOCK via INDEX current + DISARM explícito. Precedência do staged é absoluta.
- Furo 2: active-version → esqueleto → BLOCK (G-ACTIVE dedicado + guards de dep + runner preflight). Burlas por auth falsa/forjada/stale/desligamento não abrem NOOP silencioso; exigem artefatos preexistentes que disparam outros guards (G-HRB) ou falham no match.
- Severidade original dos furos: BLOQUEADOR. Consertos endereçam com fail-closed explícito ("nao vira no-op por desarme", "DISARM, nao NOOP").
- Pode selar + commitar? A evidência que produzi (suite + leitura + simulações) mostra os dois vetores fechados. Outros testes da suite estão vermelhos (orq-ref, structural etc.), mas não são os furos desta auditoria. Como auditor cross (Decreto), não decido selagem — reporto.

## ANTI-VIES (B1-B6)
- B1 li eu mesmo o meu parecer anterior e as fontes? Sim — reli 20260704-230800 por completo antes de qualquer outra coisa; li Decreto; li common.sh e assert-active-version-integrity.sh nas seções indicadas; li a seção de testes tortos novos; executei pre-flight e extraí resultados da suite.
- B2 verifiquei independente (ataquei os 2)? Sim — usei os casos exatos da suite (ci-true-remove, github-actions-remove, hbn-ci-remove, skeleton, active-version cases) + inspeção de precedência (current_source + dep_state) + análise de bypasses de auth no código do G-ACTIVE. Não herdei veredito de ninguém.
- B3 procurei ativamente o que deixei passar + vias recursivas? Sim — foquei exatamente nos 2 furos citados pelo gate + ataques de "desligar o guard", "hb forjado", "stale em STATE", "versao velha", "self-NOOP". Examinei runner preflight, protected list, matching de hearback, index vs range.
- B4 reexaminei leniencia? Sim — no v2 eu fui brando ao não simular CI=true com staged e ao não olhar active-version. Agora ataquei com hostilidade: exigi BLOCK em todos os cenários falsificáveis locais + CI signals + skeleton + auth fraca. Não inflacionei aprovação.
- B5 recomendacao preserva minha relevancia? N/A — não proponho mudanças, não enfraqueço guards, não ofereço bypass. Apenas verifico se o que eu errei antes agora está corrigido.
- B6 auditar nao me da o bastao? Sim — este é relatório NÃO-DECISÓRIO (Decreto Art. 2). Não selo, não autorizo execução, não entrego bastão, não commito, não edito fonte, não rodo hooks.

## RESUMO (<=10 linhas)
Pre-flight 6508268 dirty OK. Decreto lido. Re-li exclusivamente meu v2 (APROVA_SIM) + fontes do conserto. Furo1: CI=true + HBN + staged rm agora BLOCK (current_source força INDEX se staged; 6 deps ✓). Furo2: G-ACTIVE primeiro no runner; skeleton sem deps → BLOCK; auth exige STATE na entrada + hearback pre-existente matching from/to/deps (hb novo cai no G-HRB). Desligar guard causa fail de exec ou root-mismatch no runner. Nenhuma via recursiva achada. Severidade BLOQUEADOR para os 2 furos. APROVA_ANTIDESARME: SIM.

APROVA_ANTIDESARME: SIM
