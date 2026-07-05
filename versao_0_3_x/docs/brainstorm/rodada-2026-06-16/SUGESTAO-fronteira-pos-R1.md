# Sugestão de Fronteira ao orquestrador — pós-R1

> NATUREZA: SUGESTÃO não-normativa da esteira de Planejamento/Fronteira (chat
> paralelo, família Anthropic — NÃO é o orquestrador, NÃO conta como cross-audit,
> NÃO é despacho). O orquestrador lê, avalia, ajusta e — se concordar — transforma
> no próprio despacho sob o rito formal. Tudo aqui é proposta a confirmar no disco.

## 1. Pré-checagem da R1 (advisory — a cross-audit formal é do orquestrador, ≠-OpenAI)

Conferi no disco o resultado do Codex (commit `0692d15`; 6 commits `9241524..0692d15`):

- **Exit codes corrigidos de verdade:** hierarquia `HbnProtocolViolation`/`HbnCliError`
  + `_result_exit_code` (`src/usehbn/cli.py:1713-1718,1812`); `main()` retorna ≠0 em
  erro/violação (`cli.py:1815-1828`). O `return 0` cego saiu.
- **Estado unificado:** `STATE_DIRNAME = ".hbn"` com `.usehbn` como legado read-only
  (`src/usehbn/utils/config.py:12-13`).
- **Honestidade:** AGENTS e README em 211/211; `autoevolve` entrou na MATURITY-MATRIX
  como 3 linhas honestas (audit=Parcial, orchestrator/worker=Scaffold, CLI=Parcial),
  com "teatro de automação" declarado; ponteiro `AGENTS.md:17` corrigido; "L4" removido.
- **`main` intacta** em `4db6928`.

Dois pontos não-bloqueadores para os auditores ≠-OpenAI confirmarem:
1. `src/usehbn/runtime.py:378` ainda lê `.usehbn/hbn-state.json` — confirmar que é só o
   caminho legado read-only do dual-read, não uma terceira escrita ativa.
2. Reconfirmar `pytest 211/211` de forma independente (não reproduzi a venv no sandbox
   do chat paralelo).

Sugestão: aceitar a R1 para cross-audit ≠-OpenAI (Gemini+Cursor) + hearback + selagem.

## 2. Sequência sugerida (o orquestrador decide)

R1 selada → R2 (árvores registry-centric, fundida com o complemento) → freeze + tag
v1-estável → Ponte do Credenciamento / V206. R3 e assinatura como ondas próprias.

## 3. Sugestão de escopo para a R2 (a árvores fundida) — para o orquestrador adotar e despachar

Funde a onda de árvores que o orquestrador já planejava com o complemento de Fronteira
(A2 + achados do cross-audit). SEM partição física de diretórios (unânime entre
auditores: preserva git log/paths). Conteúdo sugerido:

- **Spec `core/arvore-spec.md`:** campo `arvore:` (fronteira|intermediaria|estavel) como
  eixo ORTOGONAL a `temperatura:` (tempo) e `hbn-track:` (rito); portão de promoção com
  critérios SIM/NÃO por salto (reusando fagocitose + 8 critérios + Fitness Gate).
  Guards (bash sem YAML) recebem etiqueta via REGISTRY/comentário canônico.
- **G-REG estendido (`guards/assert-registry-line.sh`):** disparar também em
  `diff-filter=M` quando o commit altera `arvore:`/`temperatura:` no front-matter,
  exigindo linha no REGISTRY no mesmo commit (hoje só `AR`, `:71,73` — promover por
  edição passa silenciosa).
- **Guard anti-mislabel (`guards/assert-arvore-label.sh`):** `arvore: intermediaria|estavel`
  exige registro de promoção referenciável; etiqueta sem registro = BLOQUEIA; fail-closed.
- **Etiquetar conjunto inicial** registry-centric + caso positivo/negativo + nova burla
  na `adversarial-battery` (mislabel para `estavel` sem promoção → BLOQUEADA).
- **Selar junto** os 4 pareceres `.hbn/results/*cross-ia-batch1-fronteira*` (saem de untracked).

## 4. Fora da R2 (ondas próprias / decisão humana)

- R3: trailer `HBN-Spec-Source` (proveniência dos guards) + G-FDACK com `HBN-Token-FP`.
- Assinatura: já via passkey/GitHub — falta confirmar branch protection da `main`
  exigindo commit assinado + check `hbn-shield` (push direto bloqueado) e registrar os
  signatários autorizados (chave → identidade).
- Governança (emenda P13 em C1, regra CRISPR em C2, escopo da exúvia em C3,
  esteiras/chapéu em C5): via ADR/onda própria, fora do runtime.
