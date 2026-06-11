---
titulo: REGISTRY — livro-razão de artefatos do protocolo (ADR-011 Decisão 4)
status: accepted
temperatura: quente
data-abertura: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente C3/C4)
regras: append-only; uma linha por evento (nascimento ou mudança de temperatura); nunca rename, nunca delete
evidencia: ADR-011 (methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md), Decisões 4 e 5
---

# REGISTRY do canônico useHBN

Livro-razão append-only. Dado qualquer par de artefatos, a ordem das linhas
(e o id `AAAAMMDD-NN`) diz o que veio antes; `temperatura` + `superseded_by`
dizem se algum foi ultrapassado — sem abrir arquivo nenhum.

Quem deposita artefato novo appenda a linha **no mesmo commit** do depósito.
Mudança de temperatura = nova linha (a antiga nunca é editada além da coluna
`superseded_by` permanecer vazia — a linha mais recente do path vence).

## Legado (mapeamento, sem rename)

Órfãos anteriores ao ADR-011, com data efetiva reconstruída do git/mtime.
Nenhum arquivo é renomeado — esta seção só costura o passado ao livro-razão.

| data efetiva | artefato (path) | tipo | temperatura | superseded_by | evidência da data |
|---|---|---|---|---|---|
| ~2026-04-03 | HBN-ARCHITECTURAL-REVIEW-2026-04.md | analise | frio | — | mtime 2026-04-03; 1º commit efd226b (2026-04-29, "baseline before onda 1") |
| 2026-04-29 | AUDITORIA_SUPERPOWERS.md | audit | frio | — | commit efd226b 2026-04-29 |
| 2026-06-10 04:58 | PROMPT_ANALISE_PROFUNDA_PROTOCOLO_FABLE5.md | prompt | frio | — | mtime (untracked; ciclo encerrado) |
| 2026-06-10 04:59 | PROMPT_EVOLUCAO_PROTOCOLO_FABLE5.md | prompt | frio | — | mtime (untracked; ciclo encerrado) |
| 2026-06-10 05:14 | docs/ANALISE-PROFUNDA-EVOLUCAO-PROTOCOLO-2026-06-10.md | analise | frio | — | mtime; frio ao entregar (ADR-011 Decisão 2) |
| 2026-06-10 05:37 | PROMPT_C1_BASTAO_FABLE5.md | prompt | frio | — | mtime; corrente C1 encerrada |
| 2026-06-10 05:49 | reports/BASELINE-RETOMADA-2026-06-10.md | baseline | frio | — | mtime; evidência histórica (medição 238–393 KB) |
| 2026-06-10 06:02 | PROMPT_C2_CHAIN_FABLE5.md | prompt | frio | — | mtime; corrente C2 encerrada |
| 2026-06-10 06:19 | PROMPT_C3_CHAIN_FABLE5.md | prompt | quente | — | mtime; ciclo C3/C4 em curso nesta janela |
| 2026-06-10 | PROMPT_C6C7_CHAIN_FABLE5.md | prompt | quente | — | ciclo C6/C7 em curso nesta janela (última corrente antes da consolidação) |
| 2026-06-10 | PROMPT_C1_BASTAO_FABLE5.md | prompt | frio | — | ratificação C1-C7; hearback 0001 confirmado 2026-06-10 |
| 2026-06-10 | PROMPT_C2_CHAIN_FABLE5.md | prompt | frio | — | ratificação C1-C7; hearback 0001 confirmado 2026-06-10 |
| 2026-06-10 | PROMPT_C3_CHAIN_FABLE5.md | prompt | frio | — | ratificação C1-C7; hearback 0001 confirmado 2026-06-10 |
| 2026-06-10 | PROMPT_C6C7_CHAIN_FABLE5.md | prompt | frio | — | ratificação C1-C7; hearback 0001 confirmado 2026-06-10 |
| 2026-06-10 | /Users/macbookpro/Projetos/PROMPT_ARQUITETO_USEHBN_AUTONOMO.md | prompt-legado | ultrapassado | agents/architect-autonomous.md (20260610-16) | ratificação C4; hearback 0001 confirmado 2026-06-10 |

## Linhas (going-forward, ADR-011)

| id | artefato (path) | tipo | temperatura | superseded_by |
|---|---|---|---|---|
| 20260610-01 | schemas/state.schema.json | schema | quente | — |
| 20260610-02 | schemas/handoff.schema.json | schema | quente | — |
| 20260610-03 | core/relay-spec.md | spec-core | quente | — |
| 20260610-04 | agents/role-templates.md | spec-core | quente | — |
| 20260610-05 | methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md | adr | quente | — |
| 20260610-06 | methodology/adr/ADR-012-naming-versoes-ondas.md | adr | quente | — |
| 20260610-07 | methodology/adr/ADR-008-migracao-snapshot-credenciamento-v2.md | adr | quente | — |
| 20260610-08 | methodology/adr/ADR-008-migracao-snapshot-credenciamento.md | adr | ultrapassado | ADR-008 v2 (20260610-07) |
| 20260610-09 | inbox/README.md | spec-core | quente | — |
| 20260610-10 | schemas/hearback.schema.json | schema | quente | — |
| 20260610-11 | schemas/audit-pre.schema.json | schema | quente | — |
| 20260610-12 | schemas/audit-post.schema.json | schema | quente | — |
| 20260610-13 | guards/ (runner + 5 guards + lib/common.sh + README) | guard | quente | — |
| 20260610-14 | .github/workflows/hbn-shield.yml | ci | quente | — |
| 20260610-15 | reports/20260610-15-proposal-bump-versao-canonico.md | proposal | quente | — |
| 20260610-16 | agents/architect-autonomous.md | spec-core | quente | — |
| 20260610-17 | methodology/adr/ADR-013-arquiteto-autonomo-classes-a-b.md | adr | quente | — |
| 20260610-18 | .hbn/queue/ (README + itens 001–019) | queue | quente | — |
| 20260610-19 | core/cadence-d.md | spec-core | quente | — |
| 20260610-20 | .hbn/knowledge/0001-comandos-atomicos-copiaveis.md | knowledge | quente | — |
| 20260610-21 | .hbn/knowledge/0002-entrega-operacional-minimalista.md | knowledge | quente | — |
| 20260610-22 | .hbn/autoevolve/cycle-2026-06-10.jsonl | exec | frio | — |
| 20260610-23 | methodology/adr/ADR-014-cerimonia-proporcional-tiers.md | adr | quente | — |
| 20260610-24 | methodology/adr/ADR-015-perfis-de-modelo.md | adr | quente | — |
| 20260610-25 | schemas/model-profile.schema.json | schema | quente | — |
| 20260610-26 | .hbn/models/ (4 perfis: fable-5, opus-4-8, codex, gemini-3-5) | profile | quente | — |
| 20260610-27 | inbox/credenciamento/20260610-01-0017-parametrica.md | inbox | quente | — |
| 20260610-28 | .hbn/knowledge/0003-git-sandbox-sem-lock.md | knowledge | quente | — |
| 20260610-29 | .hbn/readbacks/0001-consolidacao-c1-c7.json | readback | quente | — |
| 20260610-30 | .hbn/hearbacks/0001-consolidacao-c1-c7.json | hearback | frio | — |
| 20260610-31 | 20260610-31-prompt-consolidacao-codex.md | prompt | quente | — |
| 20260610-32 | reports/20260610-15-proposal-bump-versao-canonico.md | proposal | quente | — |
| 20260610-33 | 20260610-31-prompt-consolidacao-codex.md | prompt | frio | — |
| 20260610-34 | reports/20260610-15-proposal-bump-versao-canonico.md | nota | quente | — |

Nota de legado adicional: `/Users/macbookpro/Projetos/PROMPT_ARQUITETO_USEHBN_AUTONOMO.md`
(v1.6, FORA deste repo, sem git) — status efetivo `ultrapassado` registrado
na linha de legado pós-ratificação do lote C4.

Nota 20260610-34: bump `0.3.1` + auditoria `__version__` × `PROTOCOL_VERSION`
(`src/usehbn/runtime.py`, `src/usehbn/execution/engine.py`, grep completo) →
onda dedicada futura. Versão permanece `0.3.0` nesta consolidação.

## Corrente D (2026-06-10) — TUDO status: proposed, hearback em lote pendente

| id | artefato (path) | tipo | temperatura | superseded_by |
|---|---|---|---|---|
| 20260610-35 | guards/assert-registry-line.sh | guard | quente | — |
| 20260610-36 | reports/20260610-36-proposal-faxina-prompts-raiz.md | proposal | quente | — |
| 20260610-37 | methodology/adr/ADR-016-dual-run-caracterizacao.md | adr | quente | — |
| 20260610-38 | core/dual-run-spec.md | spec-core | quente | — |
| 20260610-39 | schemas/dual-run-result.schema.json | schema | quente | — |
| 20260610-40 | methodology/adr/ADR-017-freeze-gate-executavel.md | adr | quente | — |
| 20260610-41 | core/freeze-gate-spec.md | spec-core | quente | — |
| 20260610-42 | schemas/freeze-checklist.schema.json | schema | quente | — |
| 20260610-43 | guards/freeze-gate.sh | guard | quente | — |
| 20260610-44 | inbox/credenciamento/20260610-44-freeze-gate-v206.md | inbox | quente | — |
| 20260610-45 | methodology/adr/ADR-018-papeis-chapeus-anti-groupthink.md | adr | quente | — |
| 20260610-46 | core/roles-assignment-spec.md | spec-core | quente | — |
| 20260610-47 | guards/assert-role-family.sh | guard | quente | — |
| 20260610-48 | core/relay-spec.md + schemas/state.schema.json (campo `atribuicao`, ADR-018) | nota | quente | — |
| 20260610-49 | .hbn/messages/20260610-01-handoff-corrente-d-fable5.md | handoff | quente | — |
| 20260610-50 | .hbn/relay/STATE.md (Bastão 2.0 dogfood do canônico; INDEX.md antigo vira histórico sob demanda) | nota | quente | — |
| 20260610-51 | 20260610-51-prompt-pack-auditoria-cruzada-corrente-d.md | prompt | quente | — |
| 20260610-52 | .hbn/messages/20260610-02-handoff-auditoria-cruzada-corrente-d-fable5.md | handoff | quente | — |

Nota corrente D: guards 35/43/47 NÃO estão no runner — ativação é hearback
(H1/H6 do handoff 49). Faxina 36 é DRY-RUN (ids 51–57 reservados para a
execução). Tier dos depósitos: T2 (normativo, rito readback→hearback em
lote); a faxina, quando executada, é T1.

Nota auditoria cruzada: depósitos 51–52 consumiram ids da reserva da faxina;
na execução da faxina, renumerar para 53+ (caso previsto na própria proposal
36). Saídas esperadas dos auditores: .hbn/results/0021-cross-ia-codex-
corrente-d.json e 0022-cross-ia-antigravity-corrente-d.md (frios ao nascer,
série local NNNN — entram no REGISTRY quando depositados).

## Corrente Segurança+Onboarding (2026-06-10) — TUDO status: proposed, hearback pendente

| id | artefato (path) | tipo | temperatura | superseded_by |
|---|---|---|---|---|
| 20260610-53 | inbox/timelessphoto/20260610-53-onboarding-seguranca-timelessphoto.md | inbox | quente | — |
| 20260610-54 | inbox/mauriciozanin-hub/20260610-54-onboarding-seguranca-hub.md | inbox | quente | — |
| 20260610-55 | inbox/maiscompralocal/20260610-55-onboarding-seguranca-maiscompralocal.md | inbox | quente | — |
| 20260610-56 | inbox/credenciamento/20260610-56-complemento-seguranca-pii.md | inbox | quente | — |
| 20260610-57 | inbox/plataforma-concurso/20260610-57-onboarding-inicial.md | inbox | quente | — |
| 20260610-58 | inbox/govflow/20260610-58-credenciais-orfas-descomissionamento.md | inbox | quente | — |
| 20260610-59 | inbox/timelessnudeart/20260610-59-onboarding-minimo-estatico.md | inbox | quente | — |
| 20260610-60 | methodology/adr/ADR-019-diagnostico-seguranca-defensivo-obrigatorio.md | adr | quente | — |
| 20260610-61 | 20260610-61-prompt-auditoria-seguranca-antigravity.md | prompt | quente | — |
| 20260610-62 | 20260610-62-prompt-auditoria-seguranca-codex.md | prompt | quente | — |
| 20260610-63 | reports/20260610-63-decisao-seguranca-onboarding-2026-06-10.md | decisao | quente | — |

Nota corrente Segurança: ids 53–63 consumiram o resto da reserva da faxina
(36); na execução da faxina, usar próximos ids livres do dia/data corrente
(mesmo caso já previsto nas notas acima). Pastas novas de inbox
(timelessphoto, mauriciozanin-hub, maiscompralocal, plataforma-concurso,
govflow, timelessnudeart) criadas pelo arquiteto no primeiro depósito,
conforme inbox/README.md. Saídas esperadas dos auditores externos:
.hbn/results/0023-cross-ia-antigravity-seguranca.md e
0024-cross-ia-codex-seguranca.json (frios ao nascer; entram no REGISTRY
quando depositados). Nenhum valor de segredo transcrito em artefato algum
desta corrente (regra dura). Tier: T2, rito readback→hearback em lote.

## Corrente E (2026-06-10) — anti-teatro — status: accepted em 50%, hearback readback 0002

| id | artefato (path) | tipo | temperatura | superseded_by |
|---|---|---|---|---|
| 20260610-64 | methodology/adr/ADR-020-anti-validacao-de-teatro.md | adr | quente | — |
| 20260610-65 | guards/tests/run-guard-tests.sh | guard-test | quente | — |
| 20260610-66 | .hbn/hearbacks/0002-excecao-fable-opus.json | hearback | quente | — |
| 20260610-67 | .hbn/messages/20260610-03-handoff-corrente-e-50pct-fable5.md | handoff | quente | — |
| 20260610-68 | .hbn/results/0025-cross-ia-codex-corrente-e.json | audit-result | frio | — |
| 20260610-69 | .hbn/results/0025-cross-ia-codex-corrente-e.md | audit-result | frio | — |
| 20260610-70 | .hbn/results/0026-cross-ia-antigravity-corrente-e.md | audit-result | frio | — |
| 20260610-71 | .hbn/readbacks/0002-adocao-corrente-e.json | readback | frio | — |
| 20260610-72 | methodology/adr/ADR-020-anti-validacao-de-teatro.md | adr | quente | — |
| 20260610-73 | guards/assert-registry-line.sh | guard | quente | — |
| 20260610-74 | guards/freeze-gate.sh | guard | quente | — |
| 20260610-75 | guards/assert-role-family.sh | guard | quente | — |
| 20260610-76 | guards/tests/run-guard-tests.sh | guard-test | quente | — |
| 20260610-77 | core/relay-spec.md + schemas/state.schema.json (campo `atribuicao`) | nota | quente | — |
| 20260610-78 | core/roles-assignment-spec.md | spec-core | quente | — |

Nota corrente E: guards 35/43/47 ALTERADOS in loco (endurecidos por ADR-020
contra os bugs F-01/F-02/F-03 das auditorias 0021/0022); fixtures sintéticas
em guards/tests/fixtures/ (sem id próprio — cobertas pela linha 65). O
hearback 66 nasce QUENTE como exceção à regra "frio ao nascer": é DRAFT
status=pendente aguardando assinatura (vira frio ao ser confirmado/recusado).
Alterações menores: perfis fable-5/codex ganham papéis exercidos de fato
(proposed — o G-FAM endurecido expôs os perfis desatualizados);
core/dual-run-spec.md ganha nota "schema-válido ≠ gate-aprovado" (0021/F-06);
core/cadence-d.md troca "<50%" hard-coded por handoff_threshold do perfil
(0021/F-08); STATE corrigido no F-04 (opus-4-8 fora do campo mecânico
auditores até hearback 0002 confirmado). Suíte guards/tests 15/15 verde em
sandbox (informativa — rodada conclusiva no Terminal). NENHUM guard ativado
no runner (ADR-020 Decisão 2: ativação exige suíte verde + hearback).
Blocos 3-4 da corrente E (auto-localização `path:` em template ADR-011 +
guard leve; saída de auditoria legível por humano) ficam para a próxima
janela — handoff 67.

Nota adoção Corrente E 50%: linhas 68–70 versionam as re-auditorias
0025/0026 que autorizaram a adoção sem veto; linha 71 versiona o readback
confirmado para evitar referência fantasma apesar de `.hbn/readbacks/`
estar gitignored; linhas 72–78 registram a mudança de temperatura/estado dos
artefatos adotados. Os três guards endurecidos continuam fora do runner; a
ativação futura exige testes negativos de todos os guards, inclusive os 5
legados. Backlog explícito, sem correção nesta onda: decidir se
`.hbn/readbacks/` deve deixar de ser ignorado e resolver a colisão de série
local entre readback 0002 de adoção e hearback 0002 da exceção fable×opus.

| 20260610-79 | methodology/adr/ADR-021-documentos-auto-localizaveis.md | adr | quente | — |
| 20260610-80 | guards/assert-self-path.sh | guard | quente | — |
| 20260610-81 | methodology/adr/ADR-022-saida-de-auditoria-legivel.md | adr | quente | — |
| 20260610-82 | methodology/adr/ADR-023-integridade-de-hearback.md | adr | quente | — |
| 20260610-83 | guards/assert-hearback-integrity.sh | guard | quente | — |
| 20260610-84 | .hbn/messages/20260610-04-handoff-corrente-e-fechada-fable5.md | handoff | quente | — |
| 20260610-85 | .hbn/messages/20260610-05-fix-staged-skew-fable5.md | handoff | quente | — |

Nota fechamento corrente E (Blocos 3-6 — status: accepted pelo readback 0003):
ADR-021 (auto-localização `path:`), ADR-022 (saída de auditoria legível por
humano) e ADR-023 (integridade de hearback / anti-auto-assinatura, F-05 da
0026) depositados e depois promovidos a ACCEPTED; guards novos G-SLF (80) e G-HRB (83) nascem FORA
do runner (ADR-020 Decisão 2). Alterações in loco, sem id próprio:
methodology/templates/{ADR,MD}-TEMPLATE.md ganham id-global/path/temperatura
(ADR-021 Decisão 3); guards/assert-registry-line.sh endurecido
(diff-filter=AR p/ renames — 0026/F-01; órfãos também em docs/** e
methodology/** — 0026/F-04; nota provando cobertura de guards aninhados —
0026/F-02); core/freeze-gate-spec.md regra §2.2 explicitada (0025/E-RE-02);
guards/tests/run-guard-tests.sh ampliado de 15 para 29 casos (inclui os
negativos que faltavam de .hbn/models/ e .github/workflows/ — 0025/E-RE-01);
methodology/adr/INDEX.md atualizado (linhas ADR-016–023: depósitos novos +
reparo do drift 016–020 ausentes). Suíte 29/29 verde em sandbox
(informativa — substituída pelo fix staged-skew 33/33). Backlog explícito: assinatura
GPG/SSH de hearbacks (ADR-023 Decisão 4) e testes negativos dos 5 guards
legados ficam para a onda de ativação do runner.

Nota fix staged-skew (pós-veto 0027 — status: accepted pelo readback 0003): G-SLF e G-REG
corrigidos para validar o conteúdo STAGED (git show :path / :REGISTRY.md;
HEAD: em CI) em vez da working tree (E-FECH-01/02). Alterações in loco:
guards/assert-self-path.sh, guards/assert-registry-line.sh,
guards/tests/run-guard-tests.sh (29 → 33 casos: 2 negativos de skew + 2
espelhos-bons que provam a leitura do índice). Suíte 33/33 verde em /tmp.
E-FECH-03 não entra: critério "mesmo autor" permanece AVISO (ADR-023
Decisão 3 — limite honesto do shell de identidade única; GPG no backlog).

| 20260610-86 | .hbn/results/0029-cross-ia-codex-fix-staged-skew.json | audit-result | frio | — |
| 20260610-87 | .hbn/results/0029-cross-ia-codex-fix-staged-skew.md | audit-result | frio | — |
| 20260610-88 | .hbn/readbacks/0003-adocao-corrente-e-fechamento.json | readback | frio | — |
| 20260610-89 | methodology/adr/ADR-021-documentos-auto-localizaveis.md | adr | quente | — |
| 20260610-90 | guards/assert-self-path.sh | guard | quente | — |
| 20260610-91 | methodology/adr/ADR-022-saida-de-auditoria-legivel.md | adr | quente | — |
| 20260610-92 | methodology/adr/ADR-023-integridade-de-hearback.md | adr | quente | — |
| 20260610-93 | guards/assert-hearback-integrity.sh | guard | quente | — |
| 20260610-94 | guards/assert-registry-line.sh | guard | quente | — |
| 20260610-95 | guards/tests/run-guard-tests.sh | guard-test | quente | — |
| 20260610-96 | methodology/templates/ADR-TEMPLATE.md | template | quente | — |
| 20260610-97 | methodology/templates/MD-TEMPLATE.md | template | quente | — |
| 20260610-98 | core/freeze-gate-spec.md | spec-core | quente | — |
| 20260610-99 | .hbn/relay/STATE.md | state | quente | — |

Nota adoção fechamento Corrente E: readback 0003 confirmado por Maurício em
2026-06-10. ADR-021/022/023 passam a ACCEPTED; G-SLF/G-HRB e o hardening
G-REG staged-skew/AR/órfãos são adotados; suíte 33 passa a contrato aceito;
templates ADR/MD adotam id-global/path/temperatura; freeze-gate-spec §2.2
fica aceito para a regra de `obrigatorio=true` com `status=na` só mediante
hearback verificável. Nenhum guard entra no runner; ativação futura exige
testes negativos dos 5 guards legados. Hearback 0002 segue pendente e
opus-4-8 segue fora do campo mecânico `atribuicao.auditores`.

Nota onda orquestração-start (PROPOSED — nada adotado): a partir daqui as
linhas novas usam o bloco de 6 colunas com `created_at` ISO8601 (ADR-024
Decisão 5, dogfood proposto; as 5 primeiras colunas preservam a forma
grepada pelo G-REG). Evidência da regra: colisão 0001-fable5 × 0001-codex
(escrita paralela no mesmo dia) e saturação do NN de 2 dígitos
(20260610-99 atingido num único dia). Os 3 brainstorms abaixo mantêm o
NOME original (nunca renomear história); o id novo é só de registro, com
`created_at` reconstruído do mtime.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260610-160252-gemini-3-5-proposal-orquestracao-start | .hbn/proposals/0042-antigravity-orquestracao-start.md | proposal | quente | — | 2026-06-10T16:02:52-03:00 |
| 20260610-160333-fable-5-proposal-orquestracao-start | .hbn/proposals/0001-fable5-orquestracao-start.md | proposal | quente | — | 2026-06-10T16:03:33-03:00 |
| 20260610-160342-codex-proposal-orquestracao-start | .hbn/proposals/0001-codex-orquestracao-start.md | proposal | quente | — | 2026-06-10T16:03:42-03:00 |
| 20260610-202123-fable-5-adr-orquestracao-start | methodology/adr/ADR-024-orquestracao-start.md | adr | quente | — | 2026-06-10T20:21:23-03:00 |
| 20260610-202410-fable-5-spec-start-rite | core/start-rite-spec.md | spec-core | quente | — | 2026-06-10T20:24:10-03:00 |
| 20260610-202530-fable-5-spec-orchestrator-profile | core/orchestrator-profile-spec.md | spec-core | quente | — | 2026-06-10T20:25:30-03:00 |
| 20260610-202640-fable-5-spec-pointer | core/pointer-spec.md | spec-core | quente | — | 2026-06-10T20:26:40-03:00 |
| 20260610-202750-fable-5-spec-state-report | core/state-report-spec.md | spec-core | quente | — | 2026-06-10T20:27:50-03:00 |
| 20260610-205310-fable-5-guard-start-cast | guards/assert-start-cast.sh | guard | quente | — | 2026-06-10T20:53:10-03:00 |
| 20260610-205320-fable-5-guard-parallel-id | guards/assert-parallel-id.sh | guard | quente | — | 2026-06-10T20:53:20-03:00 |
| 20260610-205330-fable-5-guard-pointer-honest | guards/assert-pointer-honest.sh | guard | quente | — | 2026-06-10T20:53:30-03:00 |
| 20260610-205340-fable-5-guard-report-fresh | guards/assert-report-fresh.sh | guard | quente | — | 2026-06-10T20:53:40-03:00 |
| 20260610-205910-fable-5-handoff-guards-orquestracao-start | .hbn/messages/20260610-205910-fable-5-handoff-guards-orquestracao-start.md | handoff | quente | — | 2026-06-10T20:59:10-03:00 |

Nota adoção orquestração-start (ADR-024 + 4 specs + 4 guards + suíte 63 —
status: accepted pelo readback 0004): 0030/0031 foram vetos históricos
pré-fix; 0032/0033 reauditaram o fix e retornaram VETO_ADOCAO: NAO, sem
bloqueadores/fortes/marginais. ADR-024, specs core, guards G-STR/G-NUM/G-PTR/G-RLT
e a seção ADR-024 da suíte passam a accepted; a suíte permanece com contagem
honesta de 63 checks totais, 30 checks ADR-024 e 20 negativos de bloqueio. Os
4 guards continuam FORA de guards/hbn-guards-runner.sh; ativação é onda futura.

| 20260610-215757-codex-readback-adocao-orquestracao-start | .hbn/readbacks/0004-adocao-orquestracao-start.json | readback | frio | — | 2026-06-10T21:57:57-03:00 |
| 20260610-212004-codex-audit-orquestracao-start-md | .hbn/results/0030-cross-ia-codex-orquestracao-start.md | audit-result | frio | — | 2026-06-10T21:20:04-03:00 |
| 20260610-212004-codex-audit-orquestracao-start-json | .hbn/results/0030-cross-ia-codex-orquestracao-start.json | audit-result | frio | — | 2026-06-10T21:20:04-03:00 |
| 20260610-211406-gemini-3-5-audit-orquestracao-start | .hbn/results/0031-cross-ia-antigravity-orquestracao-start.md | audit-result | frio | — | 2026-06-10T21:14:06-03:00 |
| 20260610-215115-codex-audit-fix-orquestracao-start-md | .hbn/results/0032-cross-ia-codex-fix-orquestracao-start.md | audit-result | frio | — | 2026-06-10T21:51:15-03:00 |
| 20260610-215115-codex-audit-fix-orquestracao-start-json | .hbn/results/0032-cross-ia-codex-fix-orquestracao-start.json | audit-result | frio | — | 2026-06-10T21:51:15-03:00 |
| 20260610-214912-gemini-3-5-audit-fix-orquestracao-start-md | .hbn/results/0033-cross-ia-antigravity-fix-orquestracao-start.md | audit-result | frio | — | 2026-06-10T21:49:12-03:00 |
| 20260610-214918-gemini-3-5-audit-fix-orquestracao-start-json | .hbn/results/0033-cross-ia-antigravity-fix-orquestracao-start.json | audit-result | frio | — | 2026-06-10T21:49:18-03:00 |
| 20260610-230700-codex-adopt-adr-024 | methodology/adr/ADR-024-orquestracao-start.md | adr | quente | — | 2026-06-10T23:07:00-03:00 |
| 20260610-230701-codex-adopt-start-rite-spec | core/start-rite-spec.md | spec-core | quente | — | 2026-06-10T23:07:01-03:00 |
| 20260610-230702-codex-adopt-orchestrator-profile-spec | core/orchestrator-profile-spec.md | spec-core | quente | — | 2026-06-10T23:07:02-03:00 |
| 20260610-230703-codex-adopt-pointer-spec | core/pointer-spec.md | spec-core | quente | — | 2026-06-10T23:07:03-03:00 |
| 20260610-230704-codex-adopt-state-report-spec | core/state-report-spec.md | spec-core | quente | — | 2026-06-10T23:07:04-03:00 |
| 20260610-230705-codex-adopt-guard-start-cast | guards/assert-start-cast.sh | guard | quente | — | 2026-06-10T23:07:05-03:00 |
| 20260610-230706-codex-adopt-guard-parallel-id | guards/assert-parallel-id.sh | guard | quente | — | 2026-06-10T23:07:06-03:00 |
| 20260610-230707-codex-adopt-guard-pointer-honest | guards/assert-pointer-honest.sh | guard | quente | — | 2026-06-10T23:07:07-03:00 |
| 20260610-230708-codex-adopt-guard-report-fresh | guards/assert-report-fresh.sh | guard | quente | — | 2026-06-10T23:07:08-03:00 |
| 20260610-230709-codex-adopt-suite-63 | guards/tests/run-guard-tests.sh | guard-test | quente | — | 2026-06-10T23:07:09-03:00 |
| 20260610-230710-codex-state-orquestracao-start-adotada | .hbn/relay/STATE.md | state | quente | — | 2026-06-10T23:07:10-03:00 |
| 20260610-221455-antigravity-gemini-ponte-002-008 | .hbn/proposals/20260610-221455-antigravity-gemini-ponte-002-008.md | proposal | quente | — | 2026-06-10T22:14:55-03:00 |
| 20260610-221540-codex-ponte-002-008 | .hbn/proposals/20260610-221540-codex-ponte-002-008.md | proposal | quente | — | 2026-06-10T22:15:40-03:00 |
| 20260610-221607-fable5-ponte-002-008 | .hbn/proposals/20260610-221607-fable5-ponte-002-008.md | proposal | quente | — | 2026-06-10T22:16:07-03:00 |
| 20260610-233218-fable5-ponte-consolidada | .hbn/proposals/20260610-233218-fable5-ponte-consolidada.md | proposal | quente | — | 2026-06-10T23:32:18-03:00 |
| 20260610-235817-gemini-3-5-audit-ponte-json | .hbn/results/0035-cross-ia-antigravity-ponte.json | audit-result | frio | — | 2026-06-10T23:58:17-03:00 |
| 20260610-235830-gemini-3-5-audit-ponte-md | .hbn/results/0035-cross-ia-antigravity-ponte.md | audit-result | frio | — | 2026-06-10T23:58:30-03:00 |
| 20260611-002529-codex-audit-ponte-md | .hbn/results/0034-cross-ia-codex-ponte.md | audit-result | frio | — | 2026-06-11T00:25:29-03:00 |
| 20260611-002530-codex-audit-ponte-json | .hbn/results/0034-cross-ia-codex-ponte.json | audit-result | frio | — | 2026-06-11T00:25:30-03:00 |
| 20260611-014200-fable-5-readback-ativacao-enforcement | .hbn/readbacks/0005-ativacao-enforcement.json | readback | frio | — | 2026-06-11T01:42:00-03:00 |
| 20260611-101851-fable-5-guard-no-stray-hbn | guards/assert-no-stray-hbn.sh | guard | quente | — | 2026-06-11T10:18:51-03:00 |
| 20260611-142434-fable5-readback-onda-0006 | .hbn/readbacks/0006-onda-enforcement-sem-excecao.json | readback | quente | — | 2026-06-11T14:24:34-03:00 |
