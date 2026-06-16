---
titulo: "Consolidação do orquestrador — cross-audit de IMPLEMENTAÇÃO da hbn-exuvia (modelo versão=pasta)"
tipo: audit-consolidation
status: final
temperatura: frio
path: .hbn/results/20260614-044555-opus-4-8-consolidacao-cross-audit-exuvia-impl.md
id-global: 20260614-044555-opus-4-8-consolidacao-cross-audit-exuvia-impl
autoria: claude-opus-4-8 (orquestrador)
consolida: antigravity(gemini) + codex + grok
created_at: "2026-06-14T04:45:55-03:00"
---

# Consolidação — cross-audit de implementação da hbn-exuvia

Artefato FRIO para a próxima IA consultar. Consolida 3 pareceres independentes sobre COMO implementar
com segurança o modelo "versão = pasta com o sistema inteiro". A FORMA já foi decidida; isto é o COMO.

## Veredito-síntese
**NÃO liberar o corte real agora** (convergência das 3). O mecanismo está bem desenhado e teve dry-run
validado (Codex rodou `run-guard-tests.sh` = 125/125 e o runner real verde). O corte real fica gated
pelo **Fitness Gate**: baseline funcional + Ponte do Credenciamento + confronto incumbente×desafiante.

## Fontes e confiança (Truth Barrier)
- **Codex** (`.hbn/results/20260614-043826-codex-...`): MAIS ATERRADO — rodou a suíte e o runner reais.
  Achados concretos: G-STRAY incompatível com `.hbn` dentro de pasta de versão; rollback x token
  compartilhado em `.git` vs STATE congelado; hooks órfãos/tolerantes.
- **Antigravity/Gemini** (`.hbn/results/20260614-043647-antigravity-...`): sequência de 3 commits +
  `.hbn/active-version` + `get_canonical_root` dinâmico via BASH_SOURCE; especulou shim/common.sh.
- **Grok** (colado, SEM acesso a arquivos no sandbox, ~60% confiança): lógica de pointer `CURRENT`,
  guards com `get_canonical_root`, riscos de bloat/janela de enforcement/get_canonical_root falho.

## Convergências (as 3 concordam)
1. **Não cortar agora**; o corte real exige o Fitness Gate (baseline provado).
2. **Ponteiro de versão ativa** = fonte única (`.hbn/active-version` / `CURRENT`). Repontar = editar 1 arquivo.
3. **Hooks = shim fino no nível do repo** que lê o ponteiro e delega ao runner da versão vigente; fail-closed.
4. **Guards version-aware via `common.sh`**: resolver a raiz canônica dinamicamente; prefixar paths;
   remover o prefixo da versão para validar contra o `REGISTRY.md` local da versão.
5. **Tag anti-GC** `hbn-exuvia/protocol-0.3.x` no commit de congelamento.
6. **Reversibilidade (P6)**: `git reset --hard <tag>` / revert do commit de nascimento; token em `.git/` sobrevive.
7. **IA lê só a vigente**: `.gitignore`/`.rgignore` ignoram pastas de versão inativas; read-list = vigente.
8. **Bootstrap em ~3 commits** (prep → congelar → nascer), com checkpoints.

## Divergências / nuances a decidir
- **Congelar por `git mv` (Gemini) vs `cp -a` (Grok):** recomendo **`git mv`** (move o atual → `versao_0_3_x/`,
  history segue, NÃO duplica o antigo). O novo `versao_1_0_0/` nasce com o carry-forward lapidado.
- **Bypass do rename massivo (Gemini) vs guards-first (Codex):** recomendo **guards version-aware ANTES**
  do congelamento (ordem do Codex) para minimizar/eliminar bypass e não abrir janela sem enforcement (P10).
- **Challenger inativo (Codex):** nascer `versao_1_0_0/` como **desafiante INATIVO**; só ativar (repontar
  o ponteiro) DEPOIS de o Fitness Gate passar. Esta é a melhor expressão do darwinismo na mecânica — adotar.

## Achados concretos a tratar antes de construir o mecanismo
1. **G-STRAY version-aware** (Codex): `assert-no-stray-hbn.sh` hoje espera `.hbn` na raiz do repo; com
   `.hbn` dentro de `versao_X/`, dá falso-positivo. Tornar consciente da versão.
2. **Continuidade token/STATE entre versões** (Codex): o token vive em `.git/` (compartilhado); o STATE é
   por versão. Definir que o STATE da versão ATIVA governa, e como o rollback reconcilia token×STATE.
3. **Hooks órfãos** (Gemini/Grok): clones sem onboarding rodam sem hooks → pre-flight check no runtime.
4. **Conflito de merge no `.hbn/active-version`** (Gemini): política para branches paralelas.
5. **Bloat do repo** (3): `git mv` (não `cp`) no antigo; `.gitignore` agressivo (build/dist); glacier calendarizado.

## Mecanismo consolidado (spec emergente para a fase de construção)
- `.hbn/active-version` (ponteiro) → hooks shim fail-closed → `versao_<ativa>/guards/runner`.
- `common.sh::get_canonical_root()` resolve a versão ativa; guards prefixam paths; G-REG remove prefixo.
- Tornar version-aware: assert-canonical-root, assert-registry-line (G-REG), assert-no-stray-hbn (G-STRAY)
  e qualquer guard que assuma raiz.
- Bootstrap (fail-closed, sem janela): C1 ponteiro + guards/hooks version-aware → C2 `git mv` → `versao_0_3_x/`
  + tag → C3 `versao_1_0_0/` como **desafiante inativo** → (pós Fitness Gate) ativar repontando o ponteiro.
- Reversibilidade: tag-âncora + script de rollback que reconcilia token×STATE.
- Glacier + isolamento de leitura conforme convergências 6–7.

## Proposta de avanço
1. Registrar esta consolidação (feito — este arquivo, frio).
2. NÃO construir o corte agora. A construção do MECANISMO (guards version-aware + ponteiro + shim) é uma
   onda de ESTABILIZAÇÃO (M-A), entregue como **scaffold inativo** — ativação só pós Fitness Gate.
3. Resolver os 5 achados concretos como parte do desenho do mecanismo (cross-audit do scaffold antes de ativar).
4. Seguir o roadmap: estabilizar → provar via Credenciamento (Fitness Gate) → 1ª exúvia real.
5. **Jules**: adiado — o GitHub está desatualizado e confundiria a análise; entra no dogfooding após o M-D (publicação).
