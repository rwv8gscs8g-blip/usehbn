---
titulo: "CROSS-AUDIT ADVERSARIAL (GROK xAI) — Fase 1: Classe Anti-Desarme (hbn_context_dep_state + 6 guards)"
diataxis: reference
hbn-track: safe_track
data: 2026-07-04
auditor: "grok (xAI) — cross-ia fase1 anti-desarme"
head: 6508268949c9f2c65b773edfc5168be858987ee3
working_tree: sujo (M/A/?? per pre-flight; NAO commitado)
status: congelado
temperatura: glacier
---

# RELATÓRIO DE AUDITORIA CRUZADA ADVERSARIAL — CLASSE ANTI-DESARME

**PRE-FLIGHT (executado):**
- cd /Users/macbookpro/Projetos/usehbn
- git log -1 --oneline → 6508268 feat(guards): nata-0c ...
- git status -s → working tree com modificações (NÃO commitado)
- git rev-parse --is-inside-work-tree → true
- Diretório existe e é git repo válido. Parada NÃO acionada.

**DECRETO E MAPA LIDOS (independente):**
- /Users/macbookpro/Projetos/Credenciamento/orquestracao/20260703-000500-GATE-DECRETO-REVOGACAO-PERMISSOES-ORQUESTRADORES-LEITURA-OBRIGATORIA.md
- /Users/macbookpro/Projetos/Credenciamento/orquestracao/20260703-170223-fable-5-mapa-definitivo-exuvia-consolidacao-final.md (foco §5.2 matriz total via assert-profile-authorized; §4.3-4.4; §5.5 falha instrutiva; Fase 1 genesis-aware)

**GUARDS E HELPER LIDOS (6 da classe):**
- guards/lib/common.sh (hbn_context_dep_state:200-226)
- guards/assert-profile-authorized.sh (MARKER/ROOT/SNAPSHOT; 52-67)
- guards/assert-frontdoor.sh (role-cards; 45-56)
- guards/assert-knowledge-index.sh (INDEX; 73-84)
- guards/assert-ci-battery.sh (workflow; 47-58)
- guards/assert-exception-traceable.sh (STATE; 67-78)
- guards/assert-role-family.sh (STATE; 58-69)
- guards/tests/run-guard-tests.sh (seções anti-desarme + make_* + suite)

**NÃO LIDOS:** quaisquer .hbn/results/*cross-ia* ou mensagens de outros auditores (conforme "trabalhe independente; nao leia parecer de outro auditor").

## (a) O ANTI-DESARME REALMENTE FECHA A VÁLVULA?

Vias testadas em setups controlados (fake GIT_INDEX_FILE + exec de guards + inspeção de common.sh:200; suite hermética run-guard-tests.sh executada, 307/0 verde; simulações de index/HEAD sem tocar repo real além de temp index /tmp).

1. **Remover dep no working tree SEM stagear a remoção**
   - Local (sem HBN): hbn_index_has_path via index → ATIVO (working tree não é lido). Commit não inclui remoção → sem desarme efetivo.
   - Evidência: common.sh:214 (if index_has → ATIVO); debug sim: NO_STAGE_RM_WT → ATIVO.
   - Resultado: **BLOQUEIA** (não há remoção no commit para desarmar).

2. **Remover via rename (git mv / rename staged)**
   - git mv: remove old path do index + add new.
   - Para o path checado (ex.: CONSUMER-PROFILE.md ou core/role-cards.md): index lacks old → base HEAD (tem) → DISARM → block.
   - Evidência: sim vector3 + suite (git mv em outros guards).
   - Resultado para paths de anti-desarme: **BLOQUEIA**.

3. **Symlink apontando para vazio (mode 120000 no index)**
   - Entrada existe no index → hbn_index_has_path true (cat-file :p ou ls-files) → ATIVO.
   - Leitura posterior (git show) obtém o target do symlink (string curta) → falha de conteúdo/tamanho/parse → block em guards (profile, frontdoor, know etc.).
   - Evidência: sim attackD (symlink marker) RC=1; suite tem casos de symlink em scratch/sco (bloqueiam).
   - Resultado: **BLOQUEIA** (no dep_state ou no conteúdo).

4. **Remover o marcador mas deixar o profile (ou vice-versa)**
   - Testes dedicados na suite:
     - "profile: consumidor tenta apagar .usehbn-snapshot -> BLOCK anti-desarme" (✓)
     - "profile: consumidor tenta apagar CONSUMER-PROFILE -> BLOCK anti-desarme" (✓)
   - Sim com fake: rm só marker (profile presente) → RC=1 (block); rm só profile (marker presente) → RC=1 (block).
   - Evidência: run-guard-tests.sh:4012-4019; assert-profile-authorized.sh:56-67 (checa os 3 independentemente).
   - Resultado: **BLOQUEIA**.

5. **Baseline torto (HBN_DIFF_BASE ausente vs presente)**
   - Sem HBN (local normal): base=HEAD, index controla ATIVO → DISARM em remoção staged.
   - Com HBN_DIFF_BASE set (mesmo valor lixo): branch CI do helper (common.sh:207): if has in HEAD (ainda tem, pois HEAD não mudou) → imprime 'ATIVO' **antes** de olhar base. Remoção staged ignorada para detecção de desarme. current_ref usa "HEAD:" (velho) em vez de ":" (index).
   - Sim: export HBN_DIFF_BASE=... + rm cached → ATIVO (não DISARM).
   - Em CI real o shield seta HBN corretamente; em pre-commit local ou env residual → furo.
   - Resultado: **ESCAPA** (quando HBN presente).

6. **Consumidor cujo marcador NUNCA esteve em HEAD (snapshot recém-instalado no mesmo commit) — active-version/canonical torta**
   - Fresh add ao index (nunca no HEAD/base): hbn_index_has_path true → 'ATIVO' (não cai em DISARM path). Bom para gênese de consumidor.
   - Evidência: sim vector5 (fresh → ATIVO); suite "make_profile_consumer_repo + add sem commit prévio" + "genese integrada" (pass quando tudo presente).
   - active-version torta: guard_version_repo_path prepended ao p; se active-version aponta para subdir sem o marker (ou removido), o p resolvido é outro → states podem virar NOOP/ATIVO errado, pulando ou bloqueando indevidamente. Guards checam get_canonical_root antes e falham com "versao ativa invalida" (block instrutivo) em muitos casos.
   - Resultado: **BLOQUEIA ou instrutivo** (anti-desarme não é o gate aqui; gênese add é ATIVO correto). Fragilidade em canonical resolution existe (MARGINAL).

**Outros vetores executados:**
- rm sem commit + re-run guard: matriz/profile não revalida remoção (correto, pois não committed).
- HBN unset explícito nos testes (run-guard-tests.sh:170) garante que suite roda no modo local index-based.

Resumo (a): a maioria das vias **BLOQUEIA**. Furo confirmado quando HBN_DIFF_BASE presente (local ou envenenado): desarme escapa da checagem de 3 estados.

## (b) O HELPER DE 3 ESTADOS TEM CAMINHO EM QUE DISARM DEVERIA DISPARAR MAS CAI EM NOOP?

Ponto exato de captura: `guards/lib/common.sh:200-226` (hbn_context_dep_state).

Caminhos problemáticos identificados:

```sh
# common.sh:207
if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
    if hbn_ref_has_path HEAD "$p"; then
        printf 'ATIVO\n'; return 0   # <--- se HBN set, HEAD (velho) ainda tem o arquivo → ATIVO, mesmo rm staged no index. Nunca chega no DISARM.
    fi
    base="$HBN_DIFF_BASE"
else
    if hbn_index_has_path "$p"; then ...
    base="HEAD"
fi
if hbn_ref_has_path "$base" "$p"; then 'DISARM' else 'NOOP'
```

- HBN presente (local): prioriza HEAD real (sempre "presente" até commit) → ATIVO forçado. DISARM suprimido. current_ref vira HEAD: (ignora staged). Furo de captura.
- Marcador dir (.usehbn-snapshot): hbn_index_has_path / hbn_ref_has_path dependem de cat-file ":dir" ou ls-files prefix. Diretórios não são blobs; detecção indireta (filhos). Em sim com base sem histórico do dir → NOOP em remoção (embora em repo consumidor real com commit prévio do marker o base HEAD tem → DISARM).
- p vazio: força 'DISARM' (linha 203) — callers (guards) checam vazio antes e falham com "versao ativa invalida", mas se caller falhar em passar p correto, desvia.
- active-version/canonical: p = guard_version_repo_path(...) pode mapear para path inexistente na versão ativa → states enganosos (antes da checagem de DISARM).

Ponto de captura **não é hermético** a env HBN_DIFF_BASE e a presença de dirs vs arquivos. DISARM deveria disparar em remoção staged de dep versionado em HEAD; com HBN set cai em ATIVO (ou NOOP para dirs em bases sem histórico).

## (c) RUN-GUARD-TESTS.SH — OS TESTES ANTI-DESARME PROVAM O BLOQUEIO EM TODAS AS VIAS CRÍTICAS? FALTA ALGUM VETOR SEM TESTE?

Executado: bash guards/tests/run-guard-tests.sh (hermético, mktemp, não toca repo real).

Resultado: **307 passaram, 0 falharam — SUÍTE VERDE**.

Cobertura anti-desarme explícita (grep + output):
- exc/fam (STATE): "remocao de STATE existente -> BLOCK anti-desarme" (✓)
- know: "remocao de INDEX existente -> BLOCK" (✓)
- frontdoor: "remocao de role-cards existente -> BLOCK" (✓)
- ci-battery: "remocao de workflow existente -> BLOCK" (✓)
- profile: "apagar .usehbn-snapshot -> BLOCK", "apagar CONSUMER-PROFILE -> BLOCK" (✓)
- genese integrada + matriz cobre 31 guards (✓)

**Vetores cobertos pela suite:** remoção staged individual de cada dep dos 6; NOOP em gênese/ausência prévia; block em omissão de guard na matriz.

**Faltam (sem teste explícito na suíte):**
- Remoção com HBN_DIFF_BASE set (local ou CI torto).
- Rename (git mv) do arquivo de dep exato dos 6 (suite tem git mv para REGISTRY, não para role-cards/INDEX/STATE/marker).
- Symlink 120000 no lugar do dep (suite cobre em scratch/sco, não nos 6).
- Remoção simultânea marker+ambos profiles (suite testa separado).
- active-version/canonical torta + impacto no dep_state dos 6.
- HBN_DIFF_BASE envenenado apontando para base anterior à introdução do dep (NOOP forçado).
- Execução com active-version != "." (subversão de versioned paths).

A suíte prova o bloqueio nas vias "óbvias" (git rm simples em repo consumidor limpo, env limpo). Faltam os vetores de "torto" (HBN, canonical, rename, symlink, simultâneo) que são exatamente os que o auditor adversário deve atacar.

## (d) VEREDITO

A brecha original ("apagar o marcador desarmava a matriz total") foi endereçada com o estado DISARM + blocos explícitos nos 6 guards. A suite anti-desarme é verde e cobre remoções básicas.

**Porém, caminhos remanescentes de desarme/escape:**
- HBN_DIFF_BASE presente (mesmo lixo) força ATIVO via HEAD e ignora index/staged (helper 207-210 + current_ref 175). Permite remoção sem disparar anti.
- Detecção de diretório marker (.usehbn-snapshot) é indireta; em contextos onde base não reflete o dir (ou has_path frágil) pode cair em NOOP.
- Vetores de rename/symlink/active-version não testados explicitamente nos guards da classe.
- Env poisoning ou canonical torta não contidos no ponto de captura.

**Severidade: FORTE** (não BLOQUEADOR total — a válvula não está 100% fechada para todos os modos de operação; MARGINAL para consumidores maduros com env limpo e remoção single-file).

A anti-desarme **melhora** a contenção vs rodada anterior, mas **não fecha completamente** a classe. Recomendação (sem implementar): endurecer o helper para ignorar HBN_DIFF_BASE em contexto local (pre-commit), ou exigir HBN_DIFF_BASE apenas com GITHUB_ACTIONS/CI signals; adicionar testes para os vetores tortos; tratar dirs explicitamente (tree vs blob).

## ANTI-VIES (B1-B6)

- B1 li eu mesmo? Sim — li Decreto, Mapa (seções relevantes), common.sh:200, os 6 guards completos, run-guard-tests.sh (seções + make), executei pre-flight + suite + simulações de index.
- B2 verifiquei independente (ataquei)? Sim — simulei remoções/renames/symlinks/fresh/HBN via fake index + exec direto de guards + leitura de estados; rodei suite completa; não herdei outputs de outros auditores.
- B3 procurei ativamente vias de desarme? Sim — foquei em "todas as vias" listadas (sem stage, rename, symlink, marker-vs-profile, baseline torto, never-in-HEAD, canonical); identifiquei o furo HBN+index.
- B4 reexaminei leniencia? Sim — re-li a lógica do helper após cada sim; notei que testes cobrem happy-path anti mas não os tortos; severidade FORTE (não inflada).
- B5 recomendacao preserva minha relevancia? N/A — não proponho fix, bypass, exclusão ou enfraquecimento. Apenas relato evidência + veredito. PROIBIDO propor.
- B6 auditar nao me da o bastao? Sim — este é relatório NÃO-DECISÓRIO (per Decreto Art. 2). Não selo, não aprovo, não entrego bastão, não commito, não edito fonte.

## RESUMO (<=10 linhas)

Pre-flight OK (6508268, dirty tree). Decreto + mapa + 6 guards + helper + suite lidos independentemente. Suite 307/0 verde; anti-desarme bloqueia git rm simples dos 6 (testes + sim). Furo: HBN_DIFF_BASE set força ATIVO via HEAD (common.sh:207), ignora staged removal e index — desarme escapa sem mensagem. Dir marker detecção indireta frágil. Rename/symlink/fresh/canonical tortos testados parcialmente; alguns bloqueiam, HBN não. Brecha parcialmente remanescente. Severidade FORTE. APROVA_CLASSE: PARCIAL.

APROVA_CLASSE: PARCIAL
