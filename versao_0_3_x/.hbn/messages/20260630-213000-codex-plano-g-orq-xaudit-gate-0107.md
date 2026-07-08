---
titulo: "Plano de onda 0107 — G-ORQ-XAUDIT-GATE"
tipo: state-report
status: congelado
temperatura: glacier
path: .hbn/messages/20260630-213000-codex-plano-g-orq-xaudit-gate-0107.md
created_at: "2026-06-30T21:30:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
rollback_tag: hbn-rollback/pre-g-orq-xaudit-gate-20260630-2115
rollback_head: f8dbe09086d06f5dc42527241c33e37174a65427
---

SOU: codex · familia OpenAI · papel orquestrador-provisorio

# Plano de onda 0107 — G-ORQ-XAUDIT-GATE

## Estado

Onda proposta. Nenhum patch implementado por Codex.

Rollback registrado:

- HEAD: `f8dbe09086d06f5dc42527241c33e37174a65427`
- tag: `hbn-rollback/pre-g-orq-xaudit-gate-20260630-2115`

## Invariantes

1. Orquestrador deve entregar cada despacho/prompt como bloco integral copiável
   no chat e como `.md` salvo.
2. Prompt de auditoria cruzada deve declarar onde o parecer será salvo:
   `.hbn/results/AAAAMMDD-HHMMSS-<apelido>-cross-ia-<tema>-NNNN.md`.
3. Parecer de auditoria só conta formalmente quando existe em `.hbn/results/`
   com frontmatter canônico, `SOU`, `APROVA_NNNN: SIM|NAO` e identidade de
   família validável.
4. Human gate não substitui auditoria cruzada quando a ação é crítica.
5. Codex/OpenAI não implementa nem audita esta onda.

## Escopo mínimo

Implementar guard novo `G-ORQ-XAUDIT-GATE` que bloqueia prompt cross-audit novo
sem contrato de entrega canônico.

Arquivos permitidos ao implementador:

- `guards/assert-orq-xaudit-gate.sh`
- `guards/hbn-guards-runner.sh`
- `guards/tests/run-guard-tests.sh`
- `guards/tests/adversarial-battery.sh`
- `REGISTRY.md`
- `.hbn/readbacks/0107-g-orq-xaudit-gate.json`
- `.hbn/messages/20260630-213100-antigravity-implementacao-g-orq-xaudit-gate-0107.md`

Arquivos proibidos:

- `.hbn/relay/STATE.md`
- `.hbn/results/**`
- `guards/assert-state-structural.sh`
- `core/**`
- `src/**`
- `schemas/**`
- `methodology/**`
- `docs/brainstorm/**`
- qualquer arquivo do repo Credenciamento

## Critério de pronto

1. Guard novo detecta prompts cross-audit adicionados em `.hbn/messages/*.md`
   e `docs/prompts/*.md`.
2. Para cada prompt cross-audit, exige:
   - exatamente um bloco `HBN-COPY`, já coberto por G-COPY ou revalidado;
   - instrução explícita de responder no chat com o parecer integral;
   - instrução explícita de salvar o mesmo parecer em `.hbn/results/...`;
   - path canônico contendo apelido do auditor e NNNN da onda auditada;
   - template de frontmatter com `tipo: audit-result`, `autor`, `familia`,
     `path`, `id-global`, `arvore` e `created_at`;
   - linha `SOU: <apelido> · familia <familia> · papel auditor`;
   - linha `APROVA_NNNN: SIM|NAO`.
3. Testes positivos e negativos na suíte.
4. Bateria adversarial adiciona burlas permanentes para:
   - auditoria só no chat, sem arquivo;
   - arquivo sem path canônico;
   - `SOU` ausente ou família errada;
   - `APROVA_NNNN` ausente ou com NNNN divergente.
5. Runner, suíte e bateria verdes.

## Auditoria

Após implementação por Antigravity/Google, auditar por duas famílias
independentes:

- Grok/xAI.
- Claude/Anthropic.

Sem selagem nesta onda até depósito canônico dos dois pareceres, novo check de
disco e gate humano.
