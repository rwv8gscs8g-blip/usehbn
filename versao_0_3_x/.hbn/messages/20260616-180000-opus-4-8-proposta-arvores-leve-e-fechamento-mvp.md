---
titulo: "Proposta — Etiqueta de árvores (leve) + Escopo de fechamento do MVP"
tipo: proposta
status: congelado
temperatura: glacier
path: .hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md
id-global: 20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp
autor: claude-opus-4-8 (orquestrador/arquiteto)
gate: "aprovacao humana (Mauricio) -> cross-audit profundo (antigravity, cursor, codex, grok) -> decisao do orquestrador -> ondas de implementacao"
created_at: "2026-06-16T18:00:00-03:00"
---

RELATO DE ESTADO — opus-4-8 · documento · 2026-06-16T18:00:00-03:00
STATE: ultima_atualizacao=2026-06-16T19:45:00-03:00 deposito na grande selagem
SINAIS: proposta arvores+MVP sera selada como artefato acumulado; nao altera guard/core por si so
PRÓXIMA AÇÃO: Cross-audit W2; P-CAND-04 sera selado junto na proxima selagem; depois avaliar deny-by-default/freeze.

# Proposta — Etiqueta de árvores (leve) + Fechamento do MVP

NÃO-NORMATIVO. Nada aqui é implementado sem sua aprovação e cross-audit profundo.
Esta proposta não altera guard, core, nem roadmap por si só.

## Parte 0 — Por que agora

Falta um **fim de linha** para o protocolo. A etiqueta de árvores (leve) desenha a
**fronteira do MVP** (o que é lei provada × experimental × runtime) e resolve a
confusão recorrente protocolo×sistema. A maquinaria pesada (compilador .md→Rust,
partição física de pastas) é trabalho da **1ª exúvia**, não de agora.

## Parte 1 — Árvores: etiqueta leve (implementação completa)

### 1.1 Conceito (3 árvores)

- **estavel** — lei do protocolo provada: specs ratificadas + guards com cross-audit. Entra no MVP/genoma.
- **intermediaria** — enforcement existe mas ainda evolui (guards novos, specs recém-promovidas). Entra no MVP, marcada para lapidação na exúvia.
- **fronteira** — experimental/não-normativo (brainstorm, propostas, rascunhos). FORA do MVP.

### 1.2 O que é LEVE (entra agora) vs PESADO (exúvia)

- AGORA (leve): um campo `arvore:` no front-matter + uma spec curta + um guard de validação. Custo baixo, reversível.
- EXÚVIA (fora): compilador de gradiente de prova, partição física `versao_x/`, geração de Rust. Não nesta proposta.

### 1.3 Design de implementação (proposto)

1. **Campo** `arvore:` no front-matter YAML, valores: `fronteira` | `intermediaria` | `estavel`.
2. **Spec** `core/arvores-spec.md` (1 página): define os 3 valores, a semântica, e a regra de que **promoção entre árvores só por onda com gate** (fronteira→intermediaria→estavel exige cross-audit + aprovação humana). A etiqueta não muda comportamento de runtime — só rotula e é validada.
3. **Guard** `G-ARVORE` (`guards/assert-arvore.sh`), fail-closed e bloqueante:
   - (a) Quando um artefato staged tem campo `arvore:`, o valor deve ser um dos três — senão BLOQUEIA.
   - (b) Artefato staged NOVO sob `core/**` ou `docs/brainstorm/**` DEVE declarar `arvore:` — senão BLOQUEIA. (migração leve, só no que é tocado; sem big-bang.)
   - `docs/brainstorm/**` que não declarar assume `fronteira` por padrão documentado.
4. **Migração**: nula no big-bang. O guard só exige nos arquivos efetivamente staged em core/brainstorm. Os existentes ganham a etiqueta quando forem tocados, ou numa passada dedicada futura.
5. **Testes** (run-guard-tests): positivo (artefato com `arvore: estavel` válido passa); negativos (valor inválido bloqueia; novo core sem `arvore:` bloqueia).
6. **Burla** adversarial (próximo número livre): artefato com `arvore: experimental` (valor não-mapeado) tenta entrar → G-ARVORE BLOQUEIA.

### 1.4 Onda proposta

Uma onda safe_track própria (readback dedicado), 5 commits no padrão: abre readback
→ spec+campo → guard G-ARVORE no runner → testes+burla → STATE+handoff. Sem tocar
src/, schemas/, outros guards.

## Parte 2 — Escopo de fechamento do MVP (freeze v1)

### 2.1 "Estável" =

Protocolo cujo núcleo (estavel+intermediaria) tem: cobertura de teste positivo/negativo,
resistência adversarial, cross-audit de família distinta, fail-closed, sem regressão,
rastreabilidade — e cujas brechas conhecidas estão fechadas ou aceitas com dívida registrada.

### 2.2 Checklist de freeze (ordenado)

1. **P-CAND-04** (área temporária `/scratch/` + guards G-SCRATCH-*) — selado. [despacho já entregue]
2. **Deny-by-default / bloqueio total** — selado: a IA não faz nada fora do escopo declarado; você aprova a `files_allowed` exata; selagem nunca toca `docs/brainstorm/**`; guard que bloqueia zona livre em escopo sem marcador de curadoria. (knowledge 0024)
3. **Hardening das marginais conhecidas** — selado ou aceito won't-fix: G-KNOW (substring no grep -Fq; ponteiro-morto INDEX→arquivo), G-FRONTDOOR (teto por bytes, não só linhas; contagem de itens robusta; existência dos paths da read-list), G-EXC (prosa-trailer → ancorar no último parágrafo).
4. **Árvores etiqueta leve** (Parte 1) — selado.
5. **Tag de versão estável** + suíte/adversarial verdes + `main` revisada; STATE/REGISTRY marcam `v1-estavel`.
6. **Ponte**: revisar os bloqueadores do VETO antigo (0034 Codex + 0035 Antigravity) e decidir descongelamento.

### 2.3 Sequência de ondas até o freeze

W1 P-CAND-04 → W2 deny-by-default → W3 hardening de guards (agrupado) → W4 árvores etiqueta → W5 freeze+tag → Ponte → uso real no v206.

### 2.4 Pronto para a Ponte quando

Checklist 1–5 verdes + bloqueadores da Ponte (item 6) endereçados.

## Parte 3 — Papéis das IAs (quem aprova/ajuda o quê)

| Ator | Família | Papel | Ajuda em |
|---|---|---|---|
| Maurício | humano | gate | aprova esta proposta + cada onda + decisão de freeze |
| Opus 4.8 | Anthropic | orquestrador/arquiteto | desenho, despachos, verificação no disco, consolidação |
| Codex | OpenAI | implementador | executa as ondas (não audita a própria implementação) |
| Antigravity/Gemini | Google | auditor cruzado | cross-audit (rotacionar) |
| Cursor | — | auditor cruzado | cross-audit + vetor fino |
| Grok | xAI | auditor cruzado | cross-audit + via mais simples |

Regra de diversidade (anti-convergência): cada onda usa ≥2 auditores de famílias
distintas do implementador; rotacionar entre Antigravity/Cursor/Grok para não
convergir numa só família.

## Parte 4 — Perguntas para a auditoria profunda decidir

1. Árvores: o campo deve ser obrigatório em quais paths além de core/ e brainstorm? Os guards `.sh` (sem front-matter) entram via comentário-header `# arvore:` ou ficam fora do escopo leve?
2. Transição entre árvores: o gate de promoção (fronteira→intermediaria→estavel) está bem definido? Falta critério objetivo (reuso dos 8 critérios de exúvia)?
3. MVP freeze: a lista 1–6 está completa? Falta algum bloqueador real? Quais eram exatamente os bloqueadores do VETO 0034/0035 da Ponte?
4. Deny-by-default: qual o mecanismo mais simples e robusto (você aprova files_allowed exata + guard anti-zona-livre)? Há vetor de bypass?
5. Leveza (P-CAND-01): algo nesta proposta é maquinaria a mais? Existe via mais simples/racional, mesmo de outra premissa/tecnologia?
6. Sequência W1–W5: a ordem minimiza retrabalho e risco de regressão?

VEREDITO esperado de cada auditor: `APROVA_PROPOSTA: SIM` (ou `NÃO` + ajustes), com
recomendação objetiva por pergunta 1–6, e confiança 0–100. Depositar em
`.hbn/results/`.

---

## ADENDO — consenso da auditoria profunda (2026-06-16; substitui partes acima)

Quatro auditorias (antigravity, cursor, codex, grok) corrigiram esta proposta.
Decisões do Maurício após o consenso:

CORREÇÕES DE FATO (erros do autor): no checklist 2.2 acima, P-CAND-04, deny-by-default
e hardening foram marcados "selado" — ERRADO. Estado real: P-CAND-04 ENTREGUE (readback
0033) mas NÃO cross-auditado; deny-by-default e hardening são FUTURO; knowledge 0023/0024
estão UNTRACKED e fora do INDEX. A linha do tempo correta está abaixo.

ÁRVORES: decidido **registry-centric leve** — uma coluna `arvore` no REGISTRY.md (sem
campo de front-matter, sem parser YAML novo, sem G-ARVORE). Promoção reusa os 8 critérios
de `core/exuvia-fitness-criteria.md`. A maquinaria pesada fica para a exúvia.

SEQUÊNCIA REVISADA (hardening ANTES do deny, unânime):
- W1: cross-audit + selagem do P-CAND-04 (+ selar knowledge 0023/0024 no INDEX, proposta e os 4 pareceres).
- W2: hardening de guards — G-KNOW (substring/ponteiro-morto), G-FRONTDOOR (byte/contagem/existência), G-EXC (prosa-trailer último-parágrafo), bypass de `scope_extension` forjada (binding a hearback assinado), e corrigir o comentário desatualizado do header de `assert-registry-line.sh` (G-REG ESTÁ no runner: hbn-guards-runner.sh:61).
- W3: deny-by-default sobre base endurecida — G-ZONA-LIVRE (bloqueia `docs/brainstorm/**` em files_allowed sem marcador de curadoria humana) + você aprova a files_allowed exata.
- W3.5: árvores registry-centric (coluna no REGISTRY).
- W4: freeze + tag v1-estável; suíte/adversarial verdes.
- Gates humanos em paralelo: G-HRB (registrar `.hbn/operators/<nome>.pub`), branch protection no GitHub.
- Ponte: corrigir bloqueadores do VETO 0034/0035 (aritmética da contagem, path absoluto no guard de snapshot, colisão R8×forbidden-paths, split firewall 0022) antes do uso real no v206.
