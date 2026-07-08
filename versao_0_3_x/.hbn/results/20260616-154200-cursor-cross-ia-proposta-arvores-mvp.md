---
titulo: "Cursor — cross-audit profundo da proposta árvores leve + fechamento MVP"
tipo: result
status: congelado
temperatura: glacier
id-global: 20260616-154200-cursor-cross-ia-proposta-arvores-mvp
path: .hbn/results/20260616-154200-cursor-cross-ia-proposta-arvores-mvp.md
auditor: cursor
familia: cursor
alvo: .hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md
branch_verificada: proposta/reestruturacao-m-a-s0
tip_verificado: 2d4ad86
main_verificado: 4db692876381a0d7909985c8500d999f2e677b04
reviewed_at: "2026-06-16T15:42:00-03:00"
---

APROVA_PROPOSTA: NAO + ajustes objetivos

# Cursor — cross-audit profundo (proposta árvores leve + MVP freeze)

**Auditor:** Cursor (família distinta)  
**Alvo:** `.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md`  
**Branch/tip conferidos:** `proposta/reestruturacao-m-a-s0` @ `2d4ad86` (`git log -1 --oneline`); `main` @ `4db6928` (`git rev-parse main`).  
**G-ARVORE:** `ls guards/assert-arvore.sh` → *No such file or directory* (proposta ainda não implementada, coerente com Parte 0).  
**Confiança geral:** 88/100

---

## 1. Árvores — paths obrigatórios e guards `.sh`

**Recomendação:** ampliar obrigatoriedade; guards `.sh` entram via `# arvore:` no cabeçalho; runner bloqueia `fronteira` ativo.

| Escopo | Veredito |
|---|---|
| `core/**` | Manter obrigatório — hoje **17/17** arquivos em `core/*.md` sem `arvore:` (ex.: `core/exuvia-fitness-criteria.md`, `core/dispatch-spec.md`; comando `head -20 … \| grep -q '^arvore:'`). |
| `docs/brainstorm/**` | Manter; corrigir **contradição interna** da proposta: §1.3.(b) exige campo em arquivo **novo**, mas §1.3.4 diz que brainstorm sem campo “assume `fronteira`” — o guard proposto não implementa default implícito, só bloqueia ausência em **novo** (`.hbn/messages/20260616-180000…:43-45`). |
| `methodology/**` | **Incluir.** ADRs e `PRINCIPIOS-CONSTITUCIONAIS.md` são lei do protocolo; hoje zero `arvore:` (amostra: `methodology/adr/ADR-025…` etc.). |
| `schemas/**` | **Incluir.** Enforcement depende de schemas; fora do escopo proposto ficam buracos. |
| `docs/**` (fora brainstorm) | **Incluir** documentos normativos (`docs/TRUTH-BARRIER.md`, `docs/PHAGOCYTOSIS.md` citados no brainstorm). |
| `.hbn/knowledge/**`, `.hbn/messages/**`, `guards/**` | **Não** obrigar `arvore:` no MVP leve — já têm semântica própria (`temperatura:`, `tipo:`, meta-path ADR-025). Forçar agora duplica eixo sem ganho proporcional (P-CAND-01). |
| Guards `.sh` | **Entram** via comentário nas primeiras ~15 linhas: `# arvore: estavel|intermediaria|fronteira`. Hoje **19** `guards/assert-*.sh` sem tag (`find guards -maxdepth 1 -name 'assert-*.sh' \| wc -l`; `head` não contém `arvore`). Regra adicional: se script está na lista ativa de `guards/hbn-guards-runner.sh` e tag = `fronteira` → **BLOCK** (guard experimental não pode ser bloqueante no pipeline). |

**Confiança:** 90/100

---

## 2. Transição entre árvores — gate de promoção

**Recomendação:** gate **parcialmente** definido; **falta** amarração objetiva aos 8 critérios de exúvia.

- A proposta diz promoção só por onda com cross-audit + aprovação humana (`.hbn/messages/20260616-180000…:41`) — suficiente como **processo**, insuficiente como **placar**.
- Os 8 critérios normativos já existem em `core/exuvia-fitness-criteria.md:78-89` (C-TEST … C-DEBT). A proposta **não** os referencia para `intermediaria→estavel`.
- Proposta de gate mínimo verificável:
  - `fronteira→intermediaria`: entrada RADAR + cross-audit ≥2 famílias + hearback humano (sem exigir C-DOG completo).
  - `intermediaria→estavel`: **placar 7/7** C-TEST…C-TRACE + C-DEBT registrada (reuso literal de `core/exuvia-fitness-criteria.md:91-99`).
- Sem isso, `arvore: estavel` é rótulo declarativo — risco de falsa confiança (brainstorm `docs/brainstorm/exuvia-evolucao-conceitual.md:155` já alerta colisão com `temperatura:`/`hbn-track:`; `core/roles-assignment-spec.md:54-55` proíbe tabela paralela — `arvore:` deve **complementar**, não competir).

**Confiança:** 85/100

---

## 3. MVP freeze — checklist 1–6 e bloqueadores VETO 0034/0035

**Recomendação:** lista **incompleta** e com **itens prematuramente marcados como selados**.

### Erros factuais no checklist da proposta (Parte 2.2)

| Item proposta | Estado real no disco |
|---|---|
| 1 P-CAND-04 selado | **Entregue** (`STATE.md:16-18`, readback `0033`, tip `2d4ad86`) mas **cross-audit pendente** (`STATE.md:14`, `readbacks/0033…:61-62`). |
| 2 Deny-by-default selado | **Falso.** É `proxima_acao` (`STATE.md:14`), candidato em `.hbn/knowledge/0024…:41-44` sem guard implementado; incidente S3.2 documentado em `0024:7-8`. |
| 3 Hardening marginais selado | **Parcial.** Dívidas abertas: G-KNOW substring (`STATE.md:28`, `assert-knowledge-index.sh:63`), G-FRONTDOOR linhas/bytes (`STATE.md:21`), G-EXC prosa-trailer (`STATE.md:36`). |
| 4 Árvores | Proposta — OK como placeholder. |
| 5 Tag v1 | Futuro — OK. |
| 6 Ponte | Correto como item separado. |

### Bloqueadores ausentes no checklist MVP

- `G-HRB` pendente de chave (`STATE.md:48`)
- Branch protection GitHub (`STATE.md:50`)
- Cross-audit P-CAND-04 antes de fechar W1
- Exúvia bloqueada (`STATE.md:46`) — fora do MVP imediato, mas deveria constar como pré-requisito pós-v1

### Bloqueadores exatos VETO 0034 (Codex)

Fonte: `.hbn/results/0034-cross-ia-codex-ponte.md`

| ID | Resumo |
|---|---|
| **B-01** | Conta “107 entram” não fecha (`106 - 5 + 1 = 102`); critério `SO-COPIA=0` pós-R8 mascara perda (`0034:67-81`). |
| **B-02** | Split firewall 0022 não auditável — corpo exato ausente (`0034:83-89`). |
| **F-01** | T3 cognitivo ambíguo / teatro (`0034:93-99`). |
| **F-02** | Claim “só via fetch” forte demais para checksum (`0034:101-107`). |
| **F-03** | R8 não materializa README tombstone; rollback subespecificado (`0034:109-115`). |

### Bloqueadores exatos VETO 0035 (Antigravity)

Fonte: `.hbn/results/0035-cross-ia-antigravity-ponte.md`

| ID | Resumo |
|---|---|
| **F-01 (BLOQUEADOR)** | Guard snapshot usa path absoluto `~/Projetos/usehbn/bin/usehbn-verify.sh` — quebra CI (`0035:47-49`, `83-87`). |
| **F-02 (FORTE)** | Split 0022 sem texto explícito — deriva semântica (`0035:36-39`, `89-93`). |
| **F-03 (FORTE)** | R8 colide com `forbid-legacy-paths` no mesmo commit (`0035:51-54`, `95-99`). |
| **F-04 (MARGINAL)** | Matemática 107 vs 103 arquivos (`0035:101-105`). |
| **F-05/F-06** | Manifest ausente / deleção total snapshot (`0035:107-117`). |

**Confiança:** 92/100

---

## 4. Deny-by-default — mecanismo simples e bypass

**Recomendação:** mecanismo mais simples = **G-SCOPE existente** + **novo G-ZONA-LIVRE** mínimo; há vetores de bypass hoje.

### Mecanismo proposto (mínimo robusto)

1. **Humano aprova `files_allowed` exata** por readback (já norma; `0024:42`).
2. **Novo guard `assert-zona-livre-curadoria.sh`:** se `scope.files_allowed` casa `docs/brainstorm/**` (ou outro path de zona livre listado em spec) **sem** marcador `curadoria_humana: true` + `authorization.human` no readback → BLOCK. Espelha candidato `0024:44`.
3. **Convenção de selagem:** readback de selagem **nunca** inclui `docs/brainstorm/**` exceto onda de curadoria dedicada (`0024:43`).

Não reinventar deny-by-default inteiro — `assert-scope-lock.sh` já converte escopo em bloqueio.

### Vetores de bypass verificados (Truth Barrier)

| Vetor | Evidência | Mitigação na proposta W2 |
|---|---|---|
| `track=fast_track` pula scope lock | `assert-scope-lock.sh:87-89` | Proibir fast_track para selagens; ou guard zona-livre independente de track |
| Meta-path `.hbn/messages/*` auto-permitido | `assert-scope-lock.sh:247-249` | Aceitável para coordenação; **não** cobre brainstorm |
| `scope_extension` no readback | `assert-scope-lock.sh:139`, `284-297` | Exige human+evidence — OK se G-ZONA-LIVRE validar delta |
| `files_allowed: ["**"]` | Teste em `run-guard-tests.sh:1124` | Hearback humano; não é bypass de zona livre sozinho |
| `HBN_GUARDS_BYPASS=1` sem nota | `guards/lib/common.sh:236-237` | Fail-closed (ignorado) — OK |
| Bypass **com** nota staged | `common.sh:232-234` | Superfície humana assumida — fora do escopo automático |
| Commit silencioso brainstorm (incidente 0024) | `0024:7-8` | **É o buraco real** — G-ZONA-LIVRE fecha |

**Confiança:** 88/100

---

## 5. Leveza (P-CAND-01) — maquinaria a mais?

**Recomendação:** proposta **é leve** no núcleo (campo + spec + 1 guard); **não** adicionar runner-check de `fronteira` nem parsing Python pesado no MVP.

- Três peças alinhadas a `docs/brainstorm/PROPOSTA-arvores-agora.md:40-41` — proporcional.
- **Maquinaria a mais se aceitar sugestões Antigravity** (validação runner + Python robusto) antes de provar o guard bash mínimo.
- **Via mais simples considerada (P-CAND-01):** inferir árvore só por path (`docs/brainstorm/` = fronteira, `core/` = intermediária) **sem campo** — zero migração, mas perde granularidade e não rotula guards `.sh`. Descartada para MVP porque não distingue `intermediaria` vs `estavel` dentro de `core/`.
- **Via alternativa radical:** estender `temperatura:`/`tipo:` existentes em vez de `arvore:` — rejeitada: semânticas diferentes (`quente/frio` ≠ maturidade de prova); aumenta ambiguidade (`exuvia-evolucao-conceitual.md:155`).

**Confiança:** 82/100

---

## 6. Sequência W1–W5 — retrabalho e regressão

**Recomendação:** ordem **subótima**; ajustar antes de executar.

| Onda proposta | Julgamento |
|---|---|
| W1 P-CAND-04 | OK, mas fechar **cross-audit** antes de marcar W1 verde (`STATE.md:14`). |
| W2 deny-by-default | **Antes** de W3 hardening = risco: marginais G-KNOW/G-FRONTDOOR/G-EXC ainda abertas (`STATE.md:21,28,36`). |
| W3 hardening | Deveria **preceder ou coincidir** com W2. |
| W4 árvores | Correto **depois** de zona-livre — evita selar etiquetas em arquivos que ainda podem entrar por buraco de escopo. |
| W5 freeze+tag | Só após checklist honesto (itens 2–3 reais). |

**Sequência sugerida:** W1 (cross-audit) → W3 hardening → W2 G-ZONA-LIVRE → W4 árvores → W5 freeze → Ponte (item 6).

**Confiança:** 86/100

---

## EXTRA Cursor — vetores finos / bypass

### Campo `arvore:`

1. **Fail-open em modificados:** §1.3.(b) só exige em arquivo **NOVO** — editar `core/dispatch-spec.md` sem `arvore:` passa (proposta `:44`).
2. **Buraco de path:** `methodology/**`, `schemas/**`, `docs/**` (não-brainstorm) — zero enforcement.
3. **Falso front-matter:** `arvore:` no corpo ou após `---` fechado — guard bash ingênuo com `grep` falha; exigir parsing YAML mínimo ou `validate-frontmatter.py` compartilhado.
4. **Valores homógrafos:** `estavel` vs `estável`, `ESTAVEL`, `estavel ` — precisam whitelist estrita (proposta cobre só `experimental` na burla `:48`).
5. **Default documentado vs guard:** brainstorm “assume fronteira” sem campo — só funciona se guard **inferir** default em novo arquivo; texto atual contradiz implementação.

### Guard G-ARVORE (quando existir)

6. **Fora do runner:** até entrar em `hbn-guards-runner.sh`, etiqueta é teatro.
7. **Guards sem tag:** 19 scripts sem `# arvore:` — classificação indefinida.
8. **`fronteira` no runner:** sem check proposto pelo Opus, guard experimental pode ser ativado.

### Deny-by-default / G-SCOPE

9. **Inflar `files_allowed` com `docs/brainstorm/**`:** B16 bloqueia auto-emenda no mesmo commit (`adversarial-battery.sh:161-198`), mas **readback novo** com brainstorm no escopo + hearback passa — sem G-ZONA-LIVRE.
10. **Meta-path messages:** selagem de brainstorm em onda S3.2 usou escopo explícito (`REGISTRY.md:788-790`) — prova que o buraco é **política de escopo**, não acidente técnico.
11. **fast_track:** bypass total de scope lock para ondas doc-only.

**Confiança vetores:** 91/100

---

## Ajustes objetivos (bloqueiam APROVA até incorporar)

1. Corrigir Parte 2.2: itens 2 e 3 **não** estão selados; adicionar itens 7–9 (cross-audit P-CAND-04, G-HRB, branch protection).
2. G-ARVORE: exigir `arvore:` em **qualquer** staged (novo **ou** modificado) sob `core/**`, `methodology/**`, `schemas/**`, `docs/**`; brainstorm novo sem campo → default `fronteira` **no guard**, não só no spec.
3. Guards `.sh`: `# arvore:` obrigatório + runner rejeita `fronteira` ativo.
4. `core/arvores-spec.md`: amarrar promoção `intermediaria→estavel` aos 8 critérios de `core/exuvia-fitness-criteria.md`.
5. W2: implementar G-ZONA-LIVRE conforme `0024:41-44` **antes** de declarar deny-by-default selado.
6. Reordenar: W3 hardening antes de W2; W4 árvores depois de W2.

---

## Assinatura

**Auditor:** Cursor  
**Família:** cursor (auditor cruzado — vetor fino)  
**Data:** 2026-06-16T15:42:00-03:00  
**Confiança geral:** 88/100
