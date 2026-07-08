---
titulo: "CROSS-AUDIT ADVERSARIAL (GROK xAI) — Fase 1: Classe Anti-Desarme v2 (re-auditoria do furo)"
diataxis: reference
hbn-track: safe_track
data: 2026-07-04
auditor: "grok (xAI) — cross-ia fase1 anti-desarme v2 (so o meu parecer anterior)"
head: 6508268 (working tree sujo, NAO commitado)
working_tree: dirty per pre-flight
status: congelado
temperatura: glacier
---

# RELATÓRIO v2 — PROVA DE FECHAMENTO DO FURO ANTI-DESARME (meu parecer 20260704-221500)

**PRE-FLIGHT (executado agora):**
- cd /Users/macbookpro/Projetos/usehbn
- git log -1 --oneline → 6508268 feat(guards): nata-0c ...
- git status -s → working tree com modificações (NÃO commitado)
- Diretório existe e é git repo. Parada não acionada.

**DECRETO LIDO (obrigatório):**
- /Users/macbookpro/Projetos/Credenciamento/orquestracao/20260703-000500-GATE-DECRETO-REVOGACAO-PERMISSOES-ORQUESTRADORES-LEITURA-OBRIGATORIA.md (Art. 2: apenas leitura + relatório NÃO-decisório; sem bastão, sem commit, sem editar fonte, sem rodar hooks, sem ler outros auditores).

**FONTES LIDAS (apenas o meu parecer anterior + fontes primárias):**
- .hbn/results/20260704-221500-cross-ia-grok-fase1-classe-anti-desarme.md (o furo que eu achei: HBN_DIFF_BASE presente força ATIVO via HEAD no helper, ignora staged rm)
- guards/lib/common.sh (hbn_ci_range_mode 173-182; hbn_context_current_ref 189-196; hbn_index_path_kind 198-213 + dir prefix 207; hbn_ref_path_kind 215-226; hbn_context_dep_state 258-287)
- Os 6 guards da classe: assert-profile-authorized.sh (52-67 DISARM), assert-frontdoor.sh (45-56), assert-knowledge-index.sh (73-84), assert-ci-battery.sh (47-58), assert-exception-traceable.sh (67-78), assert-role-family.sh (58-69)
- guards/tests/run-guard-tests.sh (seção anti-desarme torto ~4025-4144: make_antidisarm_dep_repo, stage_*_remove/rename/symlink, check_antidisarm_case, loop 6 deps × 3 variants + active-version != . cases)

**NÃO LIDOS:** qualquer resultado/parecer de outro auditor.

## (a) O FURO PRINCIPAL FECHOU?

Furo original (meu parecer): 
```
if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
    if hbn_ref_has_path HEAD "$p"; then printf 'ATIVO\n'; return 0; fi
    ...
```
Com HBN set (mesmo lixo/residual) em pre-commit local: current via HEAD (ainda tem o arquivo) → ATIVO. Staged rm ignorado. Desarme escapava.

**Fix no helper (leitura + execução):**
- hbn_ci_range_mode (173-182) AGORA exige:
  1. HBN_DIFF_BASE não-vazio, E
  2. HBN_CI em (1|true|..) OU GITHUB_ACTIONS=true OU CI truthy (não 0/false/FALSE).
- hbn_context_dep_state (265) e current_ref (191) só usam modo CI se hbn_ci_range_mode retornar 0.
- Sem sinal real → cai no else: current = hbn_index_path_kind (staged), base=HEAD.

**Reprodução do meu ataque (evidência própria):**
- Suite hermética executada: bash guards/tests/run-guard-tests.sh (mktemp, sem tocar repo real, sem hooks).
- Todos os 6 deps atacados com "poison-remove":
  - unset CI GITHUB_ACTIONS HBN_CI; export HBN_DIFF_BASE="$base"; stage rm; run guard.
  - Resultado na suite (log): 
    ✓ anti-desarme state: poison-remove -> BLOCK
    ✓ anti-desarme knowledge: poison-remove -> BLOCK
    ✓ anti-desarme frontdoor: poison-remove -> BLOCK
    ✓ anti-desarme ci: poison-remove -> BLOCK
    ✓ anti-desarme profile-root: poison-remove -> BLOCK
    ✓ anti-desarme profile-marker: poison-remove -> BLOCK
- Execução direta da função (sem suite):
  ```
  ( unset HBN_CI CI GITHUB_ACTIONS; HBN_DIFF_BASE=foo; hbn_ci_range_mode; echo "ret=$?" ) → ret=1
  ( HBN_DIFF_BASE=foo HBN_CI=1; ... ) → ret=0
  ( HBN_DIFF_BASE=foo CI=true; ... ) → ret=0
  ( HBN_DIFF_BASE=foo CI=false; ... ) → ret=1
  ```
- Conclusão (a): o furo **FECHOU**. HBN sozinho não ativa modo CI. Remoção staged agora vê current ausente no index → cai no check base → DISARM → guards bloqueiam.

## (b) OS OUTROS VETORES AGORA BLOQUEIAM? TESTES EXISTEM?

Vetores do meu parecer anterior + cobertura nova:

1. **rename (git mv)**: old path sai do index → hbn_index_has_path false; base HEAD tem → DISARM.
   - Teste na suite: check_antidisarm_case rename para os 6.
   - ✓ anti-desarme frontdoor: rename -> BLOCK (e todos os outros).
   - Evidência: stage_antidisarm_rename 4095 (git mv); check 4125.

2. **symlink 120000 no lugar do dep**:
   - hbn_index_path_kind (204): mode 120000 → 'symlink'
   - hbn_path_kind_active(symlink) = false (só file|dir)
   - hbn_path_kind_present(symlink) = true → 'DISARM' (277)
   - Guard cai no if DISARM → block.
   - Suite: ✓ anti-desarme * : symlink -> BLOCK para todos os 6 (incluindo profile-marker).
   - stage_antidisarm_symlink 4102 faz git rm + ln -s + git add.

3. **dir marcador via rename (profile-marker .usehbn-snapshot)**:
   - Tratamento dir: hbn_index_path_kind 207 (ls-files --cached -- "${p}/" prefix → 'dir' se filhos)
   - hbn_ref_path_kind 220 (040000 → 'dir')
   - Remoção staged de dir → prefix ausente → current=absent → base check → DISARM.
   - Suite cobre explicitamente profile-marker rename + poison-remove + symlink.
   - ✓ BLOCK.

4. **active-version torta (versao_X != .)**:
   - Suite tem seção dedicada: "anti-desarme active-version != .: STATE removido com HBN_DIFF_BASE local -> BLOCK"
   - ✓ anti-desarme active-version != .: ... -> BLOCK
   - Evidência: make_versioned_antidisarm_state_repo + poison com HBN local.

**Cobertura por teste (run-guard-tests.sh):**
- 6 deps × (poison-remove, rename, symlink) = 18 checks anti-desarme tortos explícitos + casos active-version.
- Todos com ✓ BLOCK (esperado: block) na execução da suite.

## (c) SOBROU ALGUMA VIA DE DESARME?

Inspecionei (código + ataques):
- Novo ponto de captura? Não. Toda decisão de ATIVO/DISARM/NOOP passa por hbn_context_dep_state.
- dir vs blob: tratado explicitamente com kind (file/dir/sym/gitlink). Dirs usam prefix ls / 040000. Remoção de .usehbn-snapshot (dir) dispara DISARM corretamente.
- Env poisoning: somente HBN_DIFF_BASE sem sinal real → ret=1 no hbn_ci_range_mode. Modo local (index) é usado. Sem bypass da checagem.
- HBN_CI=1 sem HBN_DIFF_BASE: range_mode exige os dois (173).
- CI=false explícito: tratado como não-CI.
- current_ref em CI usa "HEAD:" (após range), em local ":" (index). Remoção no range aparece como ausente em HEAD(tip).
- Nenhuma outra entrada para "ATIVO via HEAD" quando rm staged.

Ataques controlados adicionais (via suite + leitura) não revelaram escape remanescente para os 6 deps.

## (d) VEREDITO

A brecha que eu identifiquei (HBN_DIFF_BASE residual/local forçando ATIVO via HEAD, ignorando remoção staged) **está fechada**.

- Helper agora exige sinal real de CI além de HBN_DIFF_BASE (173).
- Modo local sempre usa index para current (269).
- Todos os 6 guards checam explicitamente DISARM e falham com "nao vira no-op por desarme".
- Testes tortos novos cobrem: poison HBN local, rename, symlink, dir-marker, active-version torta — todos BLOCK.
- Dir vs blob e env poisoning sem sinal real não abrem válvula.

**Severidade: BLOQUEADOR** (para a classe anti-desarme nos modos local/CI/env envenenado testados).

Pode selar + commitar? Sim, com base na evidência que produzi (meu ataque reproduzido + suite + leitura de linhas). Nada escapa nas vias que eu ataquei antes.

## ANTI-VIES (B1-B6)

- B1 li eu mesmo o meu parecer anterior e as fontes? Sim — reli 20260704-221500 por completo; li Decreto; li common.sh linhas específicas; li os 6 guards; li a seção de testes tortos; executei pre-flight e suite.
- B2 verifiquei independente (ataquei)? Sim — rodei hbn_ci_range_mode sob todas as combinações de env; a suite executou os 18+ ataques "tortos" (poison/rename/symlink nos 6); produzi evidência própria sem herdar output de outros.
- B3 procurei ativamente vias remanescentes? Sim — testei/inspecionei: HBN sozinho, CI falsy, dir prefix, symlink present-not-active, active-version !=., remoção sem stage (correto não desarmar), range CI correto.
- B4 reexaminei leniencia? Sim — a lógica agora é hermética no ponto de captura; cobertura de testes para os vetores que antes faltavam; não inflacionei.
- B5 recomendacao preserva minha relevancia? N/A — não proponho, não implemento, não enfraqueço. Apenas verifico se o furo que eu achei fechou.
- B6 auditar nao me da o bastao? Sim — este é relatório NÃO-DECISÓRIO (Decreto Art. 2). Não selo, não aprovo execução, não entrego bastão, não commito, não edito, não rodo hooks.

## RESUMO (<=10 linhas)

Pre-flight 6508268 dirty OK. Decreto lido. Re-li exclusivamente meu parecer anterior (furo HBN→ATIVO via HEAD). common.sh agora exige sinal real CI (173) para entrar em modo range; local = index. 6 guards bloqueiam explicitamente em DISARM. Suite + ataques próprios: poison-remove/rename/symlink nos 6 + active-version torta = todos ✓ BLOCK. Dir handling (prefix/040000) correto. Sem via remanescente encontrada nos vetores listados. Severidade BLOQUEADOR. APROVA_ANTIDESARME: SIM.

APROVA_ANTIDESARME: SIM
