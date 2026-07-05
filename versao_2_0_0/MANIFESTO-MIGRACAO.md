---
titulo: "MANIFESTO-MIGRACAO — destino de cada elemento do v0.3.x (critério C-TRACE)"
status: congelado
temperatura: glacier
path: versao_2_0_0/MANIFESTO-MIGRACAO.md
created_at: "2026-07-01T19:52:00-03:00"
autor: fable-5
familia: Anthropic
---

# MANIFESTO-MIGRACAO — v0.3.x → v2

Destinos possíveis: **VENDORIZADO** (copiado sem alteração) · **CONSOLIDADO**
(conteúdo reescrito/fundido em spec nova) · **HISTORICO** (permanece no
incumbente; consulta livre, citação como regra proibida) · **PENDENTE** (dívida
declarada, com onda designada). Nada foi deletado.

## Maquinaria (VENDORIZADO, sem alteração de lógica)

| Origem (v0.3.x) | Destino (v2) |
|---|---|
| `guards/` completo: 33 assert-*.sh + hbn-guards-runner.sh + ci-entry.sh + freeze-gate.sh + lib/common.sh + hook-shims/ + tests/ (run-guard-tests, adversarial-battery, fixtures) | `versao_2_0_0/guards/` |
| `schemas/` (17 JSON) | `versao_2_0_0/schemas/` |
| `.hbn/knowledge/` completo (0001–0032 + INDEX + distribution/relay/runtime) | `versao_2_0_0/.hbn/knowledge/` |
| `core/exuvia-fitness-criteria.md`, `core/freeze-gate-spec.md`, `core/dual-run-spec.md` | `versao_2_0_0/core/` (verbatim) |
| `scripts/hbn-exuvia-rollback.sh` | `versao_2_0_0/scripts/` |
| `LICENSE` (Apache-2.0) | `versao_2_0_0/LICENSE` |

## Normativa (CONSOLIDADO — 22 specs + AGENTS.md + doutrinas → 8 specs + BOOT)

| Origem | Consolidado em |
|---|---|
| AGENTS.md (cartão de entrada, identidade, princípios-ponte) | `BOOT.md` |
| orchestrator-profile-spec.md, role-cards.md, roles-assignment-spec.md, agents/*.md (contratos por IA), ADR-018 (anti-groupthink), ADR-015 (perfis de modelo) | `core/02-papeis.md` |
| relay-spec.md, readback-spec.md, dispatch-spec.md, cadence-d.md, start-rite-spec.md, state-report-spec.md, relay-return-spec.md, command-spec.md, ADR-014 (cerimônia proporcional), ADR-023 (hearback), doutrina de saneamento (rito 12 passos) | `core/03-rito-da-onda.md` |
| ADR-011, ADR-024, ADR-025 (nomes/numeração/temperatura), arvores-spec.md, pointer-spec.md, convenções do REGISTRY | `core/04-artefatos.md` |
| ADR-020 (anti-teatro), VERIFICACAO_TERMINAL_ENFORCEMENT, doutrina de chokepoints, semantic-layer.md, validation-rules.md | `core/05-guards.md` |
| hbn-exuvia-scaffold.md, esteira-pre-transicao.md, MODELO/MECANISMO/CONCEITO-exuvia (~/Projetos) | `core/06-freeze-fitness-exuvia.md` |
| proposta-ponte v2 (0096/0097), install-snapshot, project-mode, firewall 0022 (princípio) | `core/07-projetos-membrana.md` |
| PESQUISA-fronteira-orquestracao, mecanismos de automelhoria, protocol.md | `core/08-evolucao.md` |
| Consolidação 20260611-131310 (4 causas mecânicas), PRINCIPIOS P1–P13 (ponteiro) | `core/01-principios.md` |
| Diagnóstico fable-5 20260701 (R1–R5) | `BOOT.md §9` (constituição de orçamento) |

## HISTORICO (permanece no incumbente; NÃO migra)

27 ADRs (decisões continuam válidas; conteúdo normativo já absorvido acima) ·
REGISTRY.md antigo · STATE.md antigo · 115 readbacks · results/messages/
handoffs · MATURITY-MATRIX · GLOSSARY · docs/ · auditoria/ · inbox/ ·
methodology/ · site/, src/, local-ai/, examples/ (código de suporte — avaliação
de migração é onda própria pós-ativação, não requisito do Fitness Gate) ·
documentos de planejamento em ~/Projetos (arquivados em backups/).

## PENDENTE (dívida declarada — ondas natas do desafiante, ordem fixa)

| # | Dívida | Onda |
|---|---|---|
| 0 | Lacuna version-aware descoberta na validação do bootstrap: `assert-role-family.sh:105` resolve `hearback_ref` contra o toplevel do git em vez da raiz da versão ativa (`ACTIVE_ROOT` é calculado na linha 80 mas não usado na dereferência); caso análogo no teste "str: bypass liveness". Comportamento atual é FAIL-CLOSED (bloqueia; não abre brecha). Correção por Codex sob rito, com teste | nata-0 (Codex, ANTES da ativação) |
| 0b | Adaptação version-aware do harness de testes (bloco "read-list viva" de `guards/tests/run-guard-tests.sh` deve apontar para BOOT.md + specs v2 + read-list-canonica, com skip do ponteiro `.hbn/active-version` no repo pai). Uma versão dessa adaptação foi introduzida SEM rito por agente não identificado na rodada 1 de auditoria (2026-07-01 19:34:45) e REVERTIDA por fable-5 para restaurar C-NOREG; o diff está preservado em `docs/incidente-20260701-harness-rodada1.patch` como referência de conteúdo. Reimplementar por Codex sob rito, com teste | nata-0b (Codex, ANTES da ativação) |
| 0c | G-SLF × vendorizados com `path:` no referencial v2 — CLASSE AMPLIADA no commit real do bootstrap (2026-07-02): além das 3 fixtures de hearback (`confirmado-com-excecao`, `confirmado-sem-excecao`, `pendente`), o G-SLF bloqueou os twins de paridade `guards/tests/fixtures/hearbacks/active-root-confirmado.json`, 12 knowledge (`0019`, `0022`–`0032`) e `core/exuvia-fitness-criteria.md` (vendor verbatim). Corrigir o front-matter nas cópias v2 quebraria C-NOREG (knowledge/guards byte-idênticos ao incumbente) ou o claim verbatim (core). TODOS ficam FORA do commit (untracked, presentes no disco; paridade `diff -r` intacta) até dereferência version-aware do G-SLF, por Codex sob rito. Exceção: a message de bootstrap `20260701-193000` é autorada (sem twin) e teve o `path:` corrigido para o caminho real pelo consolidador. QUITADA nesta onda nata-0c (Codex, readback 0118, 2026-07-02): G-SLF aceita, sob `versao_X_Y_Z/`, tanto o caminho real completo quanto o `path:` relativo à raiz da versão; os 17 vendorizados entram no commit sem alteração de conteúdo | nata-0c — QUITADA |
| 1 | G-ACTOR-WRITE-MATRIX (enforcement da matriz declarativa) | nata-1 (Codex) |
| 2 | G-ORQ-NO-DELETE | nata-2 (Codex) |
| 3 | Rehash de `core/read-list-canonica.txt` (marcadores PENDENTE_REHASH) | nata-3 |
| 3b | Coluna `arvore` no formato de linha do REGISTRY v2 (realinhamento com G-ARVORE-LABEL e arvores-spec registry-centric; front-matter `arvore:` é espelho sem autoridade — ver core/04-artefatos.md §Árvores). Até lá, promoção/despromoção de árvore vedada no v2 | nata-3b (junto a nata-3) |
| 4 | Tiers do runner (15 pre-commit / completo no CI) — sem deletar guard | nata-4 |
| 5 | `.github/workflows/hbn-shield.yml` apontando para a versão ativa | junto ao push GitHub |
| 6 | Avaliar migração de src/, site/, get-hbn, examples | pós-ativação |

## Verificação (C-TRACE)

Qualquer auditor pode conferir: (a) `diff -r guards/ versao_2_0_0/guards/`
vazio; (b) idem knowledge/ e schemas/; (c) cada spec nova cita suas origens;
(d) `git status` mostra que NENHUM arquivo fora de `versao_2_0_0/` foi tocado
pelo bootstrap.
