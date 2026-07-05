# R2 — Árvores registry-centric: design fechado + despacho ao codex

NÃO-NORMATIVO (fronteira). Orquestrador (opus-4-8), 2026-06-17. Insumo durável (persiste
no disco para não depender do contexto da sessão). Gate: aprovação humana → cross-audit
≠-família → selagem.

/ Base: docs/brainstorm/rodada-2026-06-17/SINTESE-PROFUNDA-pre-freeze.md (seção 5),
o ADENDO em .hbn/messages/20260616-180000-...proposta-arvores...md, e os insumos
docs/brainstorm/rodada-2026-06-16/{SUGESTAO-fronteira-pos-R1,CONSOLIDACAO-batch1-cross-audit,A2-arvores-portao-promocao}.md /

---

## 1. Decisões de design (fechadas pelo arquiteto)

1. **Escopo = MECANISMO de árvore.** A R2 entrega: spec curta + coluna no REGISTRY +
   guard anti-mislabel + extensão mínima do G-REG + testes. NÃO sela os 4 batch1-fronteira
   (precisam de curadoria de `SOU:` canônico antes — onda própria) e NÃO faz a extensão
   geral do G-REG para M (risco no parser; fica para R3).
2. **Fonte única = REGISTRY (registry-centric).** Confirmado pelo ADENDO. SEM front-matter
   `arvore:`, SEM parser YAML, SEM `G-ARVORE` pesado. (Mata o duplo-dono-da-verdade.)
3. **Coluna `arvore` no REGISTRY going-forward.** Padroniza-se o header canônico para 7
   colunas, em ordem fixa:
   `| id | artefato (path) | tipo | temperatura | arvore | superseded_by | created_at |`
   Valores: `fronteira | intermediaria | estavel`. Artefato novo declara no nascimento
   (default `fronteira` para zona livre). Linhas antigas NÃO são reescritas (sem big-bang);
   ficam legadas/sem-coluna até serem tocadas.
4. **Promoção = evento append-only.** Promover (fronteira→intermediaria→estavel) é
   **acrescentar uma nova linha-evento** no REGISTRY (`tipo: arvore-promocao`) que
   referencia o readback/cross-audit que autorizou — NUNCA editar em-lugar a linha original.
   Mantém o livro-razão append-only (P1). Reusa os 8 critérios de `core/exuvia-fitness-criteria.md`.
5. **Invariante:** `arvore: estavel` ⇒ `temperatura: quente` (lei provada é quente).

## 2. O que cada guard faz

**G-REG (estender `guards/assert-registry-line.sh`, mínimo):**
- Para artefato NOVO (linha Added no REGISTRY), exigir a coluna `arvore` presente e com
  valor válido (`fronteira|intermediaria|estavel`); senão BLOQUEIA.
- Manter o casamento de path **column-aware**: localizar o path na coluna 2 mesmo com a
  nova coluna; tolerar linhas legadas sem `arvore`.
- NÃO estender para M geral (fica para R3).

**G-ARVORE-LABEL (novo `guards/assert-arvore-label.sh`, fail-closed):**
- Em commit que toca `REGISTRY.md`: qualquer artefato cuja `arvore` seja `intermediaria`
  ou `estavel` (em linha nova OU em evento de promoção) DEVE ter um **evento de promoção
  rastreável** (linha `arvore-promocao`) que referencie um readback selado. Nascer
  `intermediaria|estavel` sem promoção → BLOQUEIA.
- Invariante `estavel ⇒ quente` → BLOQUEIA se violado.
- Entra no runner; fail-closed (REGISTRY/STATE ausente → bloqueia).

## 3. core/arvores-spec.md (conteúdo curto, registry-centric)
Define: as 3 árvores e a semântica (eixo de PROVA, ortogonal a temperatura/tempo e
hbn-track/processo); a coluna `arvore` do REGISTRY como **fonte única**; promoção só por
onda com gate (reusa os 8 critérios de exúvia; fronteira→intermediaria→estavel exige
cross-audit ≠-família + aprovação humana) registrada como evento append-only; o invariante
`estavel ⇒ quente`; e que a etiqueta NÃO muda runtime — só rotula e é validada por guard.
Explicitamente FORA: front-matter `arvore:`, parser YAML, compilador .md→Rust, partição
física (exúvia).

## 4. Testes + burla
- run-guard-tests: positivo (artefato novo `arvore: fronteira` válido passa); negativos
  (valor inválido `arvore: experimental` bloqueia; nascer `estavel` sem promoção bloqueia;
  `estavel` com `temperatura: fria` bloqueia).
- adversarial-battery (B38+): mislabel — promover para `estavel` sem evento de promoção →
  BLOQUEADA.

## 5. Fora da R2 (ondas próprias)
- Curadoria + selagem dos 4 batch1-fronteira (com `SOU:` canônico — senão G-AUDITOR-ID barra).
- Extensão geral do G-REG para M (temperatura/status em front-matter de specs) — R3.
- Camada 2 do G-AUDITOR-ID (contagem de diversidade) — fast-follow.
- Compilador, partição física, enforcement block, assinatura cripto — exúvia/R3.

## 6. Riscos e mitigação
- **Parser do REGISTRY (R-01):** adicionar coluna pode quebrar `registry_has_exact`.
  Mitigação: tornar o matcher column-aware (split por `|`, comparar a coluna do path) e
  testar os dois lados ANTES de selar. Há deriva de colunas legada (5 vs 6) — padronizar
  só o going-forward; não reescrever o legado.
- **Motivação do G-REG-M:** some no modelo append-only; por isso a R2 usa evento de
  promoção + anti-mislabel em vez de M-watching geral. Correto e mais leve.

---

## 7. DESPACHO AO CODEX (colar; readback 0049)

```
PARA: codex (implementador)
DE: claude-opus-4-8 (orquestrador)
ONDA: R2 — arvores registry-centric (mecanismo) — readback 0049 (safe_track)

SECAO 0 — INVARIANTES
- ANTES DE COMECAR: confirme indice limpo (git status: sem .tmp-audit-g/ staged). Se houver, rode: git reset -- .tmp-audit-g/  (apenas unstage; nao commitar esse lixo).
- NAO tocar main; NAO merge; NAO --no-verify; NAO "git add ." (somente paths exatos).
- NAO tocar src/; NAO selar os 4 results batch1-fronteira (ficam untracked); NAO estender G-REG para M geral.
- implementador=codex e 🔴 G-EXC PROPOSED no STATE desde C1. Trailers CONTIGUOS no ultimo paragrafo:
  HBN-Readback: 0049
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
- Antes de CADA commit: runner + run-guard-tests + adversarial-battery VERDES; pytest 213 inalterado.
- Promocao = evento append-only no REGISTRY; NUNCA editar em-lugar a linha original de um artefato.

SECAO 1 — ESCOPO (files_allowed)
- .hbn/readbacks/0049-arvores-registry-centric.json
- core/arvores-spec.md
- REGISTRY.md
- guards/assert-registry-line.sh
- guards/assert-arvore-label.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/relay/STATE.md
- .hbn/messages/20260617-HHMMSS-codex-handoff-arvores.md

SECAO 2 — FORA DE ESCOPO
- main; src/**; outras specs de core/; methodology/**; schemas/**; docs/brainstorm/**.
- Selagem dos 4 batch1-fronteira; extensao geral do G-REG para M; Camada 2 do G-AUDITOR-ID; exuvia.

SECAO 3 — DESIGN (implementar conforme docs/brainstorm/rodada-2026-06-17/R2-arvores-design-e-despacho.md secoes 1-4)
- Header going-forward do REGISTRY padronizado para 7 colunas:
  | id | artefato (path) | tipo | temperatura | arvore | superseded_by | created_at |
  (so going-forward; nao reescrever linhas legadas).
- G-REG: exigir coluna arvore valida (fronteira|intermediaria|estavel) em artefato NOVO; matcher de path column-aware; tolerar legado sem arvore.
- G-ARVORE-LABEL (novo): em commit que toca REGISTRY.md, label intermediaria|estavel exige evento de promocao rastreavel (linha tipo=arvore-promocao referenciando readback selado); nascer intermediaria|estavel sem promocao -> BLOQUEIA; invariante estavel=>quente -> BLOQUEIA. Entrar no runner, fail-closed.
- core/arvores-spec.md: spec curta registry-centric (secao 3 do design).

SECAO 4 — PLANO (commits separados; trailers contiguos; impl=codex e 🔴 desde C1)
C1: abre readback 0049 + STATE(impl=codex, 🔴) + linha no REGISTRY (com a coluna arvore=intermediaria para o proprio readback? use fronteira/intermediaria conforme spec; defina e seja coerente).
C2: core/arvores-spec.md + linha no REGISTRY (tipo=spec-core, arvore=intermediaria via evento? NAO — spec nasce como artefato; se intermediaria, precisa evento de promocao. Para evitar circularidade, a spec nasce arvore=fronteira OU registre o evento de promocao no mesmo commit referenciando este readback 0049 + o cross-audit pendente; escolha o caminho que passe nos guards e documente no handoff).
C3: estender guards/assert-registry-line.sh (coluna arvore para novos; matcher column-aware) + padronizar header do REGISTRY.
C4: guards/assert-arvore-label.sh + chamada no runner.
C5: run-guard-tests (1 positivo + 3 negativos) + adversarial-battery (B38 mislabel->estavel sem promocao).
C6: STATE (R2 entregue; proxima_acao = cross-audit ≠-OpenAI + hearback + selagem; depois curadoria dos 4 batch1-fronteira; depois R3/freeze) + handoff com placar.
Depois de C6: bastao volta ao orquestrador.

SECAO 5 — DEFINICAO DE PRONTO
- runner verde (incl. G-REG estendido + G-ARVORE-LABEL); run-guard-tests verde com os casos novos; adversarial B1-B38 verde; pytest 213 inalterado.
- Matcher de path do G-REG funciona com a coluna nova (provar nos testes os dois lados).
- nenhum src/methodology/schema/outra-core tocado; 4 batch1-fronteira seguem untracked; main 4db6928; trailers contiguos; handoff no files_allowed.

SECAO 6 — READBACK 0049 VERBATIM (criar em C1)
{
  "readback_id": "0049-arvores-registry-centric",
  "execution_id": "arvores-registry-centric-2026-06-17",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "in_progress",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0049-arvores-registry-centric.json",
  "understanding": "Implementar o mecanismo de arvores registry-centric: coluna arvore no REGISTRY going-forward (fronteira|intermediaria|estavel), spec curta core/arvores-spec.md (REGISTRY = fonte unica; promocao = evento append-only reusando os 8 criterios de exuvia; invariante estavel=>quente), extensao minima do G-REG (exigir arvore em artefato novo; matcher column-aware) e novo guard G-ARVORE-LABEL anti-mislabel (label intermediaria|estavel exige evento de promocao rastreavel; estavel=>quente), com testes e burla B38. NAO selar os 4 batch1-fronteira (faltam SOU canonico; curadoria propria). NAO estender G-REG para M geral (R3). Sem tocar src, methodology, schemas, outras specs de core.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Mauricio em 2026-06-17: 'quero exaurir o R2 (arvores) com urgencia'.",
    "created_at": "2026-06-17T14:30:00-03:00",
    "note": "Autorizacao humana para safe_track. Nao autoriza tocar main, merge, --no-verify, git add ., src, methodology, schemas, outras specs de core, brainstorm, habilitar D-ORQ-WRITE."
  },
  "scope": {
    "files_allowed": [
      ".hbn/readbacks/0049-arvores-registry-centric.json",
      "core/arvores-spec.md",
      "REGISTRY.md",
      "guards/assert-registry-line.sh",
      "guards/assert-arvore-label.sh",
      "guards/hbn-guards-runner.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/relay/STATE.md",
      ".hbn/messages/20260617-HHMMSS-codex-handoff-arvores.md"
    ],
    "files_forbidden": ["main","src/**","methodology/**","schemas/**","docs/brainstorm/**"]
  },
  "action_plan": [
    "C1: abre readback 0049 + STATE(impl=codex, 🔴).",
    "C2: core/arvores-spec.md.",
    "C3: G-REG coluna arvore + matcher column-aware + header.",
    "C4: G-ARVORE-LABEL + runner.",
    "C5: testes + burla B38.",
    "C6: STATE + handoff."
  ],
  "invariants_to_preserve": [
    "Nao tocar main, src, methodology, schemas, outras specs de core, brainstorm.",
    "Promocao = evento append-only; nunca editar em-lugar a linha original.",
    "Nao selar os 4 batch1-fronteira; nao estender G-REG para M geral.",
    "Matcher de path column-aware; legado sem arvore tolerado.",
    "Nao usar git add .; somente paths exatos.",
    "implementador=codex e 🔴 G-EXC PROPOSED no STATE desde C1; trailers CONTIGUOS.",
    "Antes de cada commit: runner + run-guard-tests + adversarial verdes; pytest 213.",
    "Trailers: HBN-Readback: 0049, HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin), HBN-Token-FP: 34a7f2f9."
  ],
  "out_of_scope": [
    "Selagem dos 4 batch1-fronteira (curadoria propria).",
    "Extensao geral do G-REG para M (R3).",
    "Camada 2 do G-AUDITOR-ID; exuvia; freeze."
  ],
  "read_evidence": [
    "docs/brainstorm/rodada-2026-06-17/R2-arvores-design-e-despacho.md (design fechado)",
    ".hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md (ADENDO: registry-centric)",
    "core/exuvia-fitness-criteria.md (8 criterios para o gate de promocao)"
  ],
  "mechanical_evidence": [
    "git rev-parse HEAD -> e2fab42 (tip selagem g-auditor-id)",
    "git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04",
    "REGISTRY header going-forward atual = 5 colunas (sem arvore); core/arvores-spec.md inexistente"
  ],
  "created_at": "2026-06-17T14:30:00-03:00",
  "protocol_version": "0.3.0"
}
```
