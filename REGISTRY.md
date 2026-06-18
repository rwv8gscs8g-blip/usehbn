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
| 20260611-155220-fable5-knowledge-0019-severidades-veto | .hbn/knowledge/0019-severidades-veto.md | knowledge | quente | — | 2026-06-11T15:52:20-03:00 |
| 20260611-155221-fable5-knowledge-0022-firewall | .hbn/knowledge/0022-firewall-workflow-fast-track.md | knowledge | quente | — | 2026-06-11T15:52:21-03:00 |
| 20260611-155515-fable5-adr-nome-universal | methodology/adr/ADR-025-nome-universal-artefato-ia.md | adr | quente | — | 2026-06-11T15:55:15-03:00 |
| 20260611-110642-codex-cross-ia-ativacao-enforcement | .hbn/results/20260611-110642-codex-cross-ia-ativacao-enforcement.md | audit-result | frio | — | 2026-06-11T11:06:42-03:00 |
| 20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement | .hbn/results/20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement.md | audit-result | frio | — | 2026-06-11T12:58:09-03:00 |
| 20260611-160318-fable5-alt-roots | .hbn/alt-roots | config-guard | quente | — | 2026-06-11T16:03:18-03:00 |
| 20260611-160745-fable5-stray-allowlist | .hbn/stray-allowlist | config-guard | quente | — | 2026-06-11T16:07:45-03:00 |
| 20260611-161405-fable5-guard-exception-traceable | guards/assert-exception-traceable.sh | guard | quente | — | 2026-06-11T16:14:05-03:00 |
| 20260611-161804-fable5-guard-baton-token | guards/assert-baton-token.sh | guard | quente | — | 2026-06-11T16:18:04-03:00 |
| 20260611-162102-fable5-bateria-adversarial | guards/tests/adversarial-battery.sh | guard-test | quente | — | 2026-06-11T16:21:02-03:00 |

## Onda 0007 (2026-06-13) — regularização mínima pós-adoção da onda 0006 (Path A) — status: in_execution, readback 0007

Depósito arquival dos 6 pareceres de cross-audit/re-auditoria da onda 0006
(nascem `frio`; eram untracked em `.hbn/results/` — entram no livro-razão ao
serem commitados), do readback 0007 e do handoff da onda. A onda NÃO toca
guards/domínio (firewall 0022); B1/B2/B3 ficam para a fase-2 planejada.
A linha do handoff é exigida pelo G-REG (messages-case, `assert-registry-line.sh:91`)
e segue a convenção: todo handoff em `.hbn/messages/` tem linha no REGISTRY.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260611-170633-codex-cross-ia-onda-0006 | .hbn/results/20260611-170633-codex-cross-ia-onda-0006.md | audit-result | frio | — | 2026-06-11T17:06:33-03:00 |
| 20260611-172049-gemini-3-5-cross-ia-onda-0006 | .hbn/results/20260611-172049-gemini-3-5-cross-ia-onda-0006.md | audit-result | frio | — | 2026-06-11T17:20:49-03:00 |
| 20260612-121318-codex-cross-ia-reaudit-onda-0006-v2 | .hbn/results/20260612-121318-codex-cross-ia-reaudit-onda-0006-v2.md | audit-result | frio | — | 2026-06-12T12:13:18-03:00 |
| 20260612-121713-gemini-3-5-cross-ia-reaudit-onda-0006-v2 | .hbn/results/20260612-121713-gemini-3-5-cross-ia-reaudit-onda-0006-v2.md | audit-result | frio | — | 2026-06-12T12:17:13-03:00 |
| 20260613-105957-codex-reaudit-onda-0006-v3 | .hbn/results/20260613-105957-codex-reaudit-onda-0006-v3.md | audit-result | frio | — | 2026-06-13T10:59:57-03:00 |
| 20260613-111317-gemini-3-5-reaudit-onda-0006-v3 | .hbn/results/20260613-111317-gemini-3-5-reaudit-onda-0006-v3.md | audit-result | frio | — | 2026-06-13T11:13:17-03:00 |
| 20260613-125502-fable-5-readback-onda-regularizacao-minima | .hbn/readbacks/0007-onda-regularizacao-minima.json | readback | quente | — | 2026-06-13T12:55:02-03:00 |
| 20260613-125502-fable-5-handoff-onda-regularizacao-minima | .hbn/messages/20260613-125502-fable-5-handoff-onda-regularizacao-minima.md | handoff | quente | — | 2026-06-13T12:55:02-03:00 |

## Onda 0008 (2026-06-13) — proposta de doutrina do orquestrador (tempo 1) — status: in_execution, readback 0008

Tempo 1 de uma mudança de doutrina aprovada pelo gate humano: escreve a
PROPOSTA (cl.7 abstração, cl.8 modo educativo com níveis, cl.9 roteamento de
modelo, refino cl.4) e NÃO edita `core/orchestrator-profile-spec.md` — a
emenda real é o tempo 3, após cross-audit Codex+Gemini. Desenho = orquestrador
(Opus 4.8); implementação = Fable (token fable-5): famílias distintas
(anti-F-01, ADR-018). Onda doutrina-sem-enforcement: nenhum guard novo.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260613-212723-fable-5-readback-doutrina-orquestrador | .hbn/readbacks/0008-doutrina-orquestrador.json | readback | quente | — | 2026-06-13T21:27:23-03:00 |
| 20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento | .hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md | proposal | quente | — | 2026-06-13T21:28:13-03:00 |
| 20260613-212913-fable-5-handoff-onda-0008-doutrina | .hbn/messages/20260613-212913-fable-5-handoff-onda-0008-doutrina.md | handoff | quente | — | 2026-06-13T21:29:13-03:00 |

## Onda 0009 (2026-06-13) — emenda da doutrina do orquestrador (tempo 3) — status: in_execution, readback 0009

Aplicação humano-confirmada da emenda em `core/orchestrator-profile-spec.md`:
cláusula 7 (camada de abstração para o humano), cláusula 8 (`MODO
EDUCACIONAL` em 5 níveis), cláusula 9 (roteamento de modelo com família =
fornecedor) e refino da cláusula 4. A redação corrige os achados da onda 0008:
ambiguidade de família (Codex F-01), `MODO` fora do G-RLT (Codex M-01),
verdade mecânica preservada em todos os níveis (Codex M-02/Gemini F2),
exclusão dinâmica do fornecedor do implementador no cross-audit (Gemini F1) e
distinção warm boot/reboot (Gemini R3). Não cria hearback numerado nesta onda:
formalização ADR-023 fica adiada para fase-2 por B2 (`G-REG x G-HRB`).

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260613-225152-codex-emenda-orchestrator-profile-spec | core/orchestrator-profile-spec.md | spec-core | quente | — | 2026-06-13T22:51:52-03:00 |
| 20260613-221518-codex-cross-ia-onda-0008-doutrina | .hbn/results/20260613-221518-codex-cross-ia-onda-0008-doutrina.md | audit-result | frio | — | 2026-06-13T22:15:18-03:00 |
| 20260613-221433-gemini-3-5-cross-ia-onda-0008-doutrina | .hbn/results/20260613-221433-gemini-3-5-cross-ia-onda-0008-doutrina.md | audit-result | frio | — | 2026-06-13T22:14:33-03:00 |
| 20260613-225152-codex-readback-emenda-doutrina-orquestrador | .hbn/readbacks/0009-emenda-doutrina-orquestrador.json | readback | quente | — | 2026-06-13T22:51:52-03:00 |
| 20260613-225152-codex-handoff-onda-0009-emenda-doutrina | .hbn/messages/20260613-225152-codex-handoff-onda-0009-emenda-doutrina.md | handoff | quente | — | 2026-06-13T22:51:52-03:00 |
| 20260613-225152-codex-state-onda-0009-emenda-doutrina | .hbn/relay/STATE.md | state | quente | — | 2026-06-13T22:51:52-03:00 |

## Onda 0010 (2026-06-14) — onda prévia Exúvia: protocolo de transição e plano da 1a muda — status: in_execution, readback 0010

Design-only: escreve a proposta do protocolo reutilizável Exúvia e o plano da
primeira muda `0.3.x -> 1.0.0`. Não executa congelamento, renascimento, baixa
de F-01, hearback formal, guard, src ou movimentação estrutural. O parecer
Gemini 0009 que estava untracked entra como registro frio no mesmo escopo; os
dois handoffs históricos untracked continuam fora por B1 e entram no plano da
casca/inventário.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260613-234731-gemini-3-5-cross-ia-onda-0009-confirma-emenda | .hbn/results/20260613-234731-gemini-3-5-cross-ia-onda-0009-confirma-emenda.md | audit-result | frio | — | 2026-06-13T23:47:31-03:00 |
| 20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda | .hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md | proposal | quente | 20260614-030748-codex-exuvia-plano-v2 | 2026-06-14T00:14:21-03:00 |
| 20260614-001421-codex-readback-onda-previa-exuvia | .hbn/readbacks/0010-onda-previa-exuvia.json | readback | quente | — | 2026-06-14T00:14:21-03:00 |
| 20260614-001421-codex-handoff-onda-previa-exuvia | .hbn/messages/20260614-001421-codex-handoff-onda-previa-exuvia.md | handoff | quente | — | 2026-06-14T00:14:21-03:00 |
| 20260614-001421-codex-state-onda-previa-exuvia | .hbn/relay/STATE.md | state | quente | — | 2026-06-14T00:14:21-03:00 |

## Onda 0011 (2026-06-14) — emenda do plano hbn-exuvia v2 — status: in_execution, readback 0011

Design-only: supersede a proposta 0010 via `superseded_by` no REGISTRY e
incorpora parecer Gemini 0010, requisitos humanos e RADAR. Nao executa a muda:
sem congelamento, tag, renascimento, painel, logs, guard, src, dominio ou
movimentacao de ledger. Proxima acao: cross-audit Gemini do plano v2; depois
ratificacao e M2 (execucao do corte).

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia | .hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md | audit-result | frio | — | 2026-06-14T02:16:41-03:00 |
| 20260614-030748-codex-exuvia-plano-v2 | .hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md | proposal | quente | — | 2026-06-14T03:07:48-03:00 |
| 20260614-030748-codex-readback-emenda-plano-exuvia-v2 | .hbn/readbacks/0011-emenda-plano-exuvia-v2.json | readback | quente | — | 2026-06-14T03:07:48-03:00 |
| 20260614-030748-codex-handoff-emenda-plano-exuvia-v2 | .hbn/messages/20260614-030748-codex-handoff-emenda-plano-exuvia-v2.md | handoff | quente | — | 2026-06-14T03:07:48-03:00 |
| 20260614-030748-codex-state-emenda-plano-exuvia-v2 | .hbn/relay/STATE.md | state | quente | — | 2026-06-14T03:07:48-03:00 |

## Onda M-A (2026-06-14) — scaffold inativo da hbn-exuvia — status: implemented, readback 0012

Estabilização mecânica sem exúvia real: `.hbn/active-version` aponta para
`.`; hooks locais são shims fail-closed; guards passam a operar relativos à
versão ativa; rollback token×STATE fica preparado em dry-run; STATE é
sincronizado ao roadmap M-A → M-B → M-C → Credenciamento. Sem `git mv`, sem
`versao_1_0_0/`, sem repontamento de ativação e sem escrita de domínio/src.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260614-183746-codex-active-version-pointer | .hbn/active-version | control | quente | — | 2026-06-14T18:37:46-03:00 |
| 20260614-183746-codex-hbn-exuvia-scaffold | core/hbn-exuvia-scaffold.md | spec-core | quente | — | 2026-06-14T18:37:46-03:00 |
| 20260614-183746-codex-hbn-exuvia-rollback-script | scripts/hbn-exuvia-rollback.sh | script | quente | — | 2026-06-14T18:37:46-03:00 |
| 20260614-183746-codex-hook-shim-pre-commit | guards/hook-shims/pre-commit | hook-template | quente | — | 2026-06-14T18:37:46-03:00 |
| 20260614-183746-codex-hook-shim-commit-msg | guards/hook-shims/commit-msg | hook-template | quente | — | 2026-06-14T18:37:46-03:00 |
| 20260614-183746-codex-readback-m-a-scaffold-inativo | .hbn/readbacks/0012-M-A-scaffold-inativo.json | readback | quente | — | 2026-06-14T18:37:46-03:00 |
| 20260614-183746-codex-handoff-m-a-scaffold-inativo | .hbn/messages/20260614-183746-codex-handoff-m-a-scaffold-inativo.md | handoff | quente | — | 2026-06-14T18:37:46-03:00 |
| 20260614-183746-codex-m-a-scaffold-inativo | .hbn/results/20260614-183746-codex-m-a-scaffold-inativo.md | result | frio | — | 2026-06-14T18:37:46-03:00 |
| 20260614-183746-codex-state-m-a-scaffold-inativo | .hbn/relay/STATE.md | state | quente | — | 2026-06-14T18:37:46-03:00 |
| 20260614-193452-gemini-3-5-cross-ia-m-a-scaffold | .hbn/results/20260614-193452-gemini-3-5-cross-ia-m-a-scaffold.md | audit-result | frio | — | 2026-06-14T19:34:52-03:00 |
| 20260614-200829-gemini-3-5-cross-ia-orquestrador-bug | .hbn/results/20260614-200829-gemini-3-5-cross-ia-orquestrador-bug.md | audit-result | frio | — | 2026-06-14T20:08:29-03:00 |
| 20260614-200849-codex-cross-ia-orquestrador-bug | .hbn/results/20260614-200849-codex-cross-ia-orquestrador-bug.md | audit-result | frio | — | 2026-06-14T20:08:49-03:00 |
| 20260614-203423-codex-orquestrador-bug-consolidacao | .hbn/results/20260614-203423-codex-orquestrador-bug-consolidacao.md | audit-result | frio | — | 2026-06-14T20:34:23-03:00 |
| 20260614-203424-codex-prompt-opus-orquestrador-boot-corrigido | .hbn/results/20260614-203424-codex-prompt-opus-orquestrador-boot-corrigido.md | prompt | frio | — | 2026-06-14T20:34:24-03:00 |
| 20260614-204536-codex-prompt-opus-orquestrador-boot-localizador | .hbn/results/20260614-204536-codex-prompt-opus-orquestrador-boot-localizador.md | prompt | frio | — | 2026-06-14T20:45:36-03:00 |

## Onda S0 (2026-06-14) — rollback, perfis e INDEX — status: completed, readback 0013

Correcoes aditivas/corretivas pos-M-A sem mudanca de logica de guard: bug D3
do rollback, perfis cross-family adicionais, INDEX reconciliado com STATE e
bookkeeping da onda S0.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260614-222329-codex-grok-profile | .hbn/models/grok.json | profile | quente | — | 2026-06-14T22:23:29-03:00 |
| 20260614-222329-codex-cursor-profile | .hbn/models/cursor.json | profile | quente | — | 2026-06-14T22:23:29-03:00 |
| 20260614-222107-codex-readback-s0-rollback-perfis-index | .hbn/readbacks/0013-s0-rollback-perfis-index.json | readback | quente | — | 2026-06-14T22:21:07-03:00 |
| 20260614-222107-codex-handoff-s0 | .hbn/messages/20260614-222107-codex-handoff-s0.md | handoff | quente | — | 2026-06-14T22:21:07-03:00 |
| 20260614-222107-codex-s0-rollback-perfis-index | .hbn/results/20260614-222107-codex-s0-rollback-perfis-index.md | result | frio | — | 2026-06-14T22:21:07-03:00 |
| 20260614-222107-codex-state-s0-rollback-perfis-index | .hbn/relay/STATE.md | state | quente | — | 2026-06-14T22:21:07-03:00 |

## Depósito S0 (2026-06-15) — auditorias e consolidação — status: completed, readback 0014

Depósito frio dos pareceres Gemini e Cursor e da consolidação opus-4-8 da onda
S0. O hearback humano de Maurício em 2026-06-14 ratifica S0 e autoriza o
depósito. Cursor preserva duas marginais não-bloqueadoras; `cursor.json`
model_id vs runtime permanece rastreado para correção futura ao promover o
perfil.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-000857-gemini-3-5-cross-ia-s0 | .hbn/results/20260615-000857-gemini-3-5-cross-ia-s0.md | audit-result | frio | — | 2026-06-15T00:08:57-03:00 |
| 20260615-000857-cursor-cross-ia-s0 | .hbn/results/20260615-000857-cursor-cross-ia-s0.md | audit-result | frio | — | 2026-06-15T00:08:57-03:00 |
| 20260615-000857-opus-4-8-consolidacao-s0 | .hbn/results/20260615-000857-opus-4-8-consolidacao-s0.md | audit-result | frio | — | 2026-06-15T00:08:57-03:00 |
| 20260615-000857-codex-readback-s0-deposito-auditorias | .hbn/readbacks/0014-s0-deposito-auditorias.json | readback | quente | — | 2026-06-15T00:08:57-03:00 |
| 20260615-000857-codex-handoff-s0-deposito | .hbn/messages/20260615-000857-codex-handoff-s0-deposito.md | handoff | quente | — | 2026-06-15T00:08:57-03:00 |
| 20260615-000857-codex-state-s0-deposito-auditorias | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T00:08:57-03:00 |

## Emenda D-ORQ-WRITE (2026-06-15) — doutrina proposta — status: pending, readback 0015

Proposta de cláusula 10 no `core/orchestrator-profile-spec.md`: o orquestrador
poderá autorar os próprios artefatos sob o mesmo rito, mas a emenda permanece
pendente de cross-audit por família diferente de Anthropic e OpenAI, além de
ratificação humana. Não cria nem habilita G-ACTOR-WRITE-MATRIX nesta onda.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-001218-codex-orchestrator-profile-spec-d-orq-write | core/orchestrator-profile-spec.md | spec-core | quente | — | 2026-06-15T00:12:18-03:00 |
| 20260615-001218-codex-readback-d-orq-write-doutrina | .hbn/readbacks/0015-d-orq-write-doutrina.json | readback | quente | — | 2026-06-15T00:12:18-03:00 |
| 20260615-001218-codex-handoff-d-orq-write | .hbn/messages/20260615-001218-codex-handoff-d-orq-write.md | handoff | quente | — | 2026-06-15T00:12:18-03:00 |
| 20260615-001218-codex-state-d-orq-write-doutrina | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T00:12:18-03:00 |

## Cross-audit Reestruturação M-A+S0 (2026-06-15) — replay limpo Opção B — status: frio, selagem pendente

Parecer Cursor (família distinta de Codex implementador) sobre tree-equivalência do
replay `proposta/reestruturacao-m-a-s0` vs `3b03a32` e tag
`evidencia/orquestrador-bug-2026-06-14`. Veredito: APROVA_REESTRUTURACAO SIM.
Depósito staged pelo auditor; commit de selagem é ato do operador (readback 0016
recomendado por cima do tip, não no replay).

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-095029-cursor-cross-ia-reestruturacao-m-a-s0 | .hbn/results/20260615-095029-cursor-cross-ia-reestruturacao-m-a-s0.md | audit-result | frio | — | 2026-06-15T09:50:29-03:00 |

## Auditoria Cruzada da Reestruturação (2026-06-15) — status: proposed, readback 0016 pendente

Parecer de auditoria cruzada da reestruturação Opção B (replay limpo M-A+S0) executado por gemini-3-5.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-095229-gemini-3-5-cross-ia-reestruturacao-m-a-s0 | .hbn/results/20260615-095229-gemini-3-5-cross-ia-reestruturacao-m-a-s0.md | audit-result | frio | — | 2026-06-15T09:52:29-03:00 |

## Selagem Reestruturação M-A+S0 (2026-06-15) — Modelo B ratificado, próxima onda S1

Selagem de governança por cima do tip limpo `5a0587d`. A equivalência mecânica
do replay permanece provada pela tag
`evidencia/reestruturacao-m-a-s0-tree-equivalent`; esta seção registra apenas
governança nova: readback 0016, handoff de selagem e STATE pós-selagem.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-100217-codex-readback-reestruturacao-m-a-s0 | .hbn/readbacks/0016-reestruturacao-m-a-s0.json | readback | quente | — | 2026-06-15T10:02:17-03:00 |
| 20260615-100217-codex-handoff-selagem-reestruturacao-m-a-s0 | .hbn/messages/20260615-100217-codex-handoff-selagem-reestruturacao-m-a-s0.md | handoff | quente | — | 2026-06-15T10:02:17-03:00 |
| 20260615-100217-codex-state-selagem-reestruturacao-m-a-s0 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T10:02:17-03:00 |
| 20260615-103431-gemini-3-5-cross-ia-selagem-reestruturacao-m-a-s0 | .hbn/results/20260615-103431-gemini-3-5-cross-ia-selagem-reestruturacao-m-a-s0.md | audit-result | frio | — | 2026-06-15T10:34:31-03:00 |

## Onda S1 (2026-06-15) — scope_extension isolado no assert-scope-lock — status: in_progress, readback 0017

Endurecimento do G-SCOPE contra auto-emenda de `scope.files_allowed` no mesmo
commit que deposita artefato dependente da emenda. A extensao legitima passa a
ser commit isolado do JSON do readback existente, com `scope_extension`
justificado no proprio readback.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-104309-codex-readback-s1-scope-extension | .hbn/readbacks/0017-endurecer-assert-scope-lock-scope-extension.json | readback | quente | — | 2026-06-15T10:43:09-03:00 |
| 20260615-110757-codex-state-s1 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T11:07:57-03:00 |
| 20260615-110757-codex-handoff-s1 | .hbn/messages/20260615-110757-codex-handoff-s1.md | handoff | quente | — | 2026-06-15T11:07:57-03:00 |

## Selagem S1 (2026-06-15) — cross-audit Gemini+Cursor aprovado, B17 para próxima onda

S1 foi ratificado por cross-audit independente Gemini+Cursor com `APROVA_S1:
SIM`. O achado B17 sobre smuggling por meta-paths `.hbn/messages/**` e
`.hbn/bypasses/**` e pre-existente e nao bloqueia a selagem; fica como proxima
onda antes do S2.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-113920-codex-readback-selagem-s1-cross-audit | .hbn/readbacks/0018-selagem-s1-cross-audit.json | readback | quente | — | 2026-06-15T11:39:20-03:00 |
| 20260615-112714-gemini-3-5-cross-ia-s1-scope-lock | .hbn/results/20260615-112714-gemini-3-5-cross-ia-s1-scope-lock.md | audit-result | frio | — | 2026-06-15T11:27:14-03:00 |
| 20260615-113115-cursor-cross-ia-s1-scope-lock | .hbn/results/20260615-113115-cursor-cross-ia-s1-scope-lock.md | audit-result | frio | — | 2026-06-15T11:31:15-03:00 |
| 20260615-113920-codex-state-selagem-s1 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T11:39:20-03:00 |
| 20260615-113920-codex-handoff-selagem-s1 | .hbn/messages/20260615-113920-codex-handoff-selagem-s1.md | handoff | quente | — | 2026-06-15T11:39:20-03:00 |

## Onda B17 (2026-06-15) — anti-smuggling meta-path tipo+nome — status: in_progress, readback 0019

Endurecimento do `assert-scope-lock` contra smuggling em meta-paths: arquivos
sob `.hbn/messages/` e `.hbn/bypasses/` deixam de ser auto-permitidos por
diretorio amplo. A dispensa de `scope.files_allowed` fica restrita a `.json` ou
`.md` com basename de evento ADR-025, ou a nomes-endereco conhecidos.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-115415-codex-readback-b17-anti-smuggling-meta-path | .hbn/readbacks/0019-b17-anti-smuggling-meta-path.json | readback | quente | — | 2026-06-15T11:54:15-03:00 |
| 20260615-120038-codex-state-b17 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T12:00:38-03:00 |
| 20260615-120038-codex-handoff-b17 | .hbn/messages/20260615-120038-codex-handoff-b17.md | handoff | quente | — | 2026-06-15T12:00:38-03:00 |

## Selagem B17 (2026-06-15) — cross-audit Gemini+Cursor aprovado, B18 para próxima onda

B17 foi ratificado por cross-audit independente Gemini+Cursor com
`APROVA_B17: SIM`. O achado B18 sobre symlink em meta-path com basename
ADR-025 valido e pre-existente ao recorte tipo+nome; nao bloqueia a selagem
B17 e fica como proxima onda antes do S2.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-214934-codex-readback-selagem-b17-cross-audit | .hbn/readbacks/0020-selagem-b17-cross-audit.json | readback | quente | — | 2026-06-15T21:49:34-03:00 |
| 20260615-213855-gemini-3-5-cross-ia-b17-meta-path | .hbn/results/20260615-213855-gemini-3-5-cross-ia-b17-meta-path.md | audit-result | frio | — | 2026-06-15T21:38:55-03:00 |
| 20260615-213850-cursor-cross-ia-b17-meta-path | .hbn/results/20260615-213850-cursor-cross-ia-b17-meta-path.md | audit-result | frio | — | 2026-06-15T21:38:50-03:00 |
| 20260615-215312-codex-state-selagem-b17 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T21:53:12-03:00 |
| 20260615-215312-codex-handoff-selagem-b17 | .hbn/messages/20260615-215312-codex-handoff-selagem-b17.md | handoff | quente | — | 2026-06-15T21:53:12-03:00 |

## Onda B18 (2026-06-15) — bloquear symlink em meta-path governado — status: in_progress, readback 0021

Endurecimento do `assert-scope-lock` contra smuggling por symlink em paths de
coordenacao governados: qualquer arquivo staged sob `.hbn/**` com modo git
`120000` deve ser bloqueado antes da dispensa por meta-path. Arquivos regulares
legitimamente nomeados de handoff, hearback e nota de bypass seguem permitidos.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-220621-codex-readback-b18-block-symlink-meta-path | .hbn/readbacks/0021-b18-block-symlink-meta-path.json | readback | quente | — | 2026-06-15T22:06:21-03:00 |
| 20260615-221034-codex-state-b18 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T22:10:34-03:00 |
| 20260615-221034-codex-handoff-b18 | .hbn/messages/20260615-221034-codex-handoff-b18.md | handoff | quente | — | 2026-06-15T22:10:34-03:00 |

## Selagem B18 (2026-06-15) — cross-audit Gemini+Cursor aprovado, B19a para próxima onda

B18 foi ratificado por cross-audit independente Gemini+Cursor com
`APROVA_B18: SIM`. O achado B19a sobre symlink em path governado fora de
`.hbn/**` e real e estreito; fica como proxima onda antes do S2. O vetor
hardlink fica registrado como non-issue/won't-fix: o Git trata hardlink como
arquivo regular `100644`, sem semantica de link no objeto versionado.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-225952-codex-readback-selagem-b18-cross-audit | .hbn/readbacks/0022-selagem-b18-cross-audit.json | readback | quente | — | 2026-06-15T22:59:52-03:00 |
| 20260615-223941-gemini-3-5-cross-ia-b18-symlink | .hbn/results/20260615-223941-gemini-3-5-cross-ia-b18-symlink.md | audit-result | frio | — | 2026-06-15T22:39:41-03:00 |
| 20260615-224921-cursor-cross-ia-b18-symlink | .hbn/results/20260615-224921-cursor-cross-ia-b18-symlink.md | audit-result | frio | — | 2026-06-15T22:49:21-03:00 |
| 20260615-230143-codex-state-selagem-b18 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T23:01:43-03:00 |
| 20260615-230143-codex-handoff-selagem-b18 | .hbn/messages/20260615-230143-codex-handoff-selagem-b18.md | handoff | quente | — | 2026-06-15T23:01:43-03:00 |

## Onda B19 (2026-06-15) — bloquear symlink em qualquer path governado — status: in_progress, readback 0023

B19 generaliza o bloqueio de symlink do B18: qualquer arquivo staged avaliado
pelo `assert-scope-lock` com modo git `120000` deve ser bloqueado, inclusive em
`guards/`, `core/`, `src/`, `methodology/` e afins quando cobertos por
`scope.files_allowed`. Hardlink permanece non-issue: no Git entra como arquivo
regular `100644`, sem semantica de link no objeto versionado.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-231847-codex-readback-b19-symlink-governado-geral | .hbn/readbacks/0023-b19-symlink-governado-geral.json | readback | quente | — | 2026-06-15T23:18:47-03:00 |
| 20260615-232431-codex-state-b19 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T23:24:31-03:00 |
| 20260615-232431-codex-handoff-b19 | .hbn/messages/20260615-232431-codex-handoff-b19.md | handoff | quente | — | 2026-06-15T23:24:31-03:00 |

## Selagem B19 (2026-06-15) — cross-audit Gemini+Cursor aprovado, classe symlink/meta-path fechada

B19 foi ratificado por cross-audit independente Gemini+Cursor com
`APROVA_B19: SIM` e `CLASSE FECHADA: SIM`. A classe symlink/meta-path fica
FECHADA apos B17+B18+B19. O vetor hardlink permanece non-issue/won't-fix: o
Git trata hardlink como arquivo regular `100644`, sem semantica de link no
objeto versionado. A proxima onda do roadmap e S2 (dispatch schema).

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260615-235600-codex-readback-selagem-b19-cross-audit | .hbn/readbacks/0024-selagem-b19-cross-audit.json | readback | quente | — | 2026-06-15T23:56:00-03:00 |
| 20260615-234638-gemini-3-5-cross-ia-b19-symlink-geral | .hbn/results/20260615-234638-gemini-3-5-cross-ia-b19-symlink-geral.md | audit-result | frio | — | 2026-06-15T23:46:38-03:00 |
| 20260615-234641-cursor-cross-ia-b19-symlink-geral | .hbn/results/20260615-234641-cursor-cross-ia-b19-symlink-geral.md | audit-result | frio | — | 2026-06-15T23:46:41-03:00 |
| 20260616-000450-codex-state-selagem-b19 | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T00:04:50-03:00 |
| 20260616-000450-codex-handoff-selagem-b19 | .hbn/messages/20260616-000450-codex-handoff-selagem-b19.md | handoff | quente | — | 2026-06-16T00:04:50-03:00 |

## Onda S2 (2026-06-16) — despacho auto-declarante — status: in_progress, readback 0025

S2 formaliza o despacho como artefato versionado auto-declarante em
`.hbn/dispatch/NNNN-*.md`, validado por schema e por dois guards bloqueantes:
G-DSP-FMT para forma e invariante zsh-safe, e G-DSP-INT para coerencia com
readback ativo, token do STATE e autorizacao humana.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-002331-codex-readback-s2-dispatch-auto-declarante | .hbn/readbacks/0025-s2-dispatch-auto-declarante.json | readback | quente | — | 2026-06-16T00:23:31-03:00 |
| 20260616-003203-codex-dispatch-schema | schemas/dispatch.schema.json | schema | quente | — | 2026-06-16T00:32:03-03:00 |
| 20260616-003203-codex-dispatch-spec | core/dispatch-spec.md | spec-core | quente | — | 2026-06-16T00:32:03-03:00 |
| 20260616-003424-codex-validate-dispatch | guards/validate-dispatch.sh | guard | quente | — | 2026-06-16T00:34:24-03:00 |
| 20260616-003424-codex-assert-dispatch-integrity | guards/assert-dispatch-integrity.sh | guard | quente | — | 2026-06-16T00:34:24-03:00 |
| 20260616-004223-codex-dispatch-s2-dogfood | .hbn/dispatch/0025-s2-dispatch-auto-declarante.md | dispatch | quente | — | 2026-06-16T00:42:23-03:00 |
| 20260616-004342-codex-state-s2 | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T00:43:42-03:00 |
| 20260616-004342-codex-handoff-s2 | .hbn/messages/20260616-004342-codex-handoff-s2.md | handoff | quente | — | 2026-06-16T00:43:42-03:00 |

## Selagem S2 (2026-06-16) — cross-audit Gemini+Cursor aprovado — status: in_progress, readback 0026

S2 foi aprovada por cross-audit independente de Gemini 3.5 e Cursor, ambos com
`APROVA_S2: SIM`. Esta micro-onda sela os pareceres e despachos, atualiza o
STATE para S2 selada e aponta a faxina 0027 como proxima acao, sem alterar
logica de guard.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-011004-codex-readback-selagem-s2-cross-audit | .hbn/readbacks/0026-selagem-s2-cross-audit.json | readback | quente | — | 2026-06-16T01:10:04-03:00 |
| 20260616-010326-gemini-3-5-cross-ia-s2-dispatch | .hbn/results/20260616-010326-gemini-3-5-cross-ia-s2-dispatch.md | audit-result | frio | — | 2026-06-16T01:03:26-03:00 |
| 20260616-010221-cursor-cross-ia-s2-dispatch | .hbn/results/20260616-010221-cursor-cross-ia-s2-dispatch.md | audit-result | frio | — | 2026-06-16T01:02:21-03:00 |
| 20260616-002331-opus-4-8-despacho-s2-dispatch-auto-declarante | .hbn/messages/20260616-002331-opus-4-8-despacho-s2-dispatch-auto-declarante.md | despacho | quente | — | 2026-06-16T00:23:31-03:00 |
| 20260616-005144-opus-4-8-despacho-cross-audit-s2 | .hbn/messages/20260616-005144-opus-4-8-despacho-cross-audit-s2.md | despacho | quente | — | 2026-06-16T00:51:44-03:00 |
| 20260616-012452-codex-state-selagem-s2 | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T01:24:52-03:00 |
| 20260616-012452-codex-handoff-selagem-s2 | .hbn/messages/20260616-012452-codex-handoff-selagem-s2.md | handoff | quente | — | 2026-06-16T01:24:52-03:00 |

## Faxina 0027 (2026-06-16) — pendências pós-S2 — status: in_progress, readback 0027

Faxina pós-S2 para corrigir a dívida H do parser CI de trailers no G-EXC,
selar artefatos históricos antigos, promover os critérios de exúvia e cobrir
scratch das suítes, sem tocar outros guards nem habilitar D-ORQ-WRITE.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-011004-codex-readback-faxina-pendencias | .hbn/readbacks/0027-faxina-pendencias.json | readback | quente | — | 2026-06-16T01:10:04-03:00 |
| 20260612-122102-fable5-handoff-orquestracao-pos-onda-0006 | .hbn/messages/20260612-122102-fable5-handoff-orquestracao-pos-onda-0006.md | handoff | quente | — | 2026-06-12T12:21:02-03:00 |
| 20260613-112502-fable5-handoff-orquestracao-pos-adocao-onda-0006 | .hbn/messages/20260613-112502-fable5-handoff-orquestracao-pos-adocao-onda-0006.md | handoff | quente | — | 2026-06-13T11:25:02-03:00 |
| 20260614-032800-gemini-3-5-cross-ia-onda-0011-plano-v2 | .hbn/results/20260614-032800-gemini-3-5-cross-ia-onda-0011-plano-v2.md | audit-result | frio | — | 2026-06-14T03:28:00-03:00 |
| 20260614-043647-antigravity-cross-ia-exuvia-impl | .hbn/results/20260614-043647-antigravity-cross-ia-exuvia-impl.md | audit-result | frio | — | 2026-06-14T04:36:47-03:00 |
| 20260614-043826-codex-cross-ia-exuvia-impl | .hbn/results/20260614-043826-codex-cross-ia-exuvia-impl.md | result | frio | — | 2026-06-14T04:38:26-03:00 |
| 20260614-044555-opus-4-8-consolidacao-cross-audit-exuvia-impl | .hbn/results/20260614-044555-opus-4-8-consolidacao-cross-audit-exuvia-impl.md | audit-consolidation | frio | — | 2026-06-14T04:45:55-03:00 |
| 20260616-005144-opus-4-8-triagem-pendencias | .hbn/messages/20260616-005144-opus-4-8-triagem-pendencias.md | analise | quente | — | 2026-06-16T00:51:44-03:00 |
| 20260616-011004-opus-4-8-criterios-exuvia | .hbn/messages/20260616-011004-opus-4-8-criterios-exuvia.md | spec-proposta | quente | core/exuvia-fitness-criteria.md | 2026-06-16T01:10:04-03:00 |
| 20260616-011004-codex-exuvia-fitness-criteria | core/exuvia-fitness-criteria.md | spec-core | quente | — | 2026-06-16T01:10:04-03:00 |
| 20260616-020135-codex-state-faxina | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T02:01:35-03:00 |
| 20260616-020135-codex-handoff-faxina | .hbn/messages/20260616-020135-codex-handoff-faxina.md | handoff | quente | — | 2026-06-16T02:01:35-03:00 |

## Selagem da Faxina 0027 (2026-06-16) — lixo-zero — status: in_progress, readback 0028

Faxina 0027 ratificada por Cursor e Gemini/Antigravity com `APROVA_0027: SIM`.
Esta micro-onda sela pareceres, despachos e brainstorm; aplica ajustes de
higiene sem alterar logica de guard; e registra dividas rastreadas para S3 /
hardening.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-024603-codex-readback-selagem-faxina-lixo-zero | .hbn/readbacks/0028-selagem-faxina-lixo-zero.json | readback | quente | — | 2026-06-16T02:46:03-03:00 |
| 20260616-023446-cursor-cross-ia-faxina-0027 | .hbn/results/20260616-023446-cursor-cross-ia-faxina-0027.md | audit-result | frio | — | 2026-06-16T02:34:46-03:00 |
| 20260616-024241-gemini-3-5-cross-ia-faxina-0027 | .hbn/results/20260616-024241-gemini-3-5-cross-ia-faxina-0027.md | audit-result | frio | — | 2026-06-16T02:42:41-03:00 |
| 20260616-011004-opus-4-8-despacho-faxina-0027 | .hbn/messages/20260616-011004-opus-4-8-despacho-faxina-0027.md | despacho | quente | — | 2026-06-16T01:10:04-03:00 |
| 20260616-011004-opus-4-8-despacho-selagem-s2 | .hbn/messages/20260616-011004-opus-4-8-despacho-selagem-s2.md | despacho | quente | — | 2026-06-16T01:10:04-03:00 |
| 20260616-021934-opus-4-8-despacho-cross-audit-faxina-0027 | .hbn/messages/20260616-021934-opus-4-8-despacho-cross-audit-faxina-0027.md | despacho | quente | — | 2026-06-16T02:19:34-03:00 |
| 20260616-024603-codex-brainstorm-exuvia-evolucao-conceitual | docs/brainstorm/exuvia-evolucao-conceitual.md | brainstorm-zona-livre | frio | — | 2026-06-16T02:46:03-03:00 |
| 20260616-024603-codex-brainstorm-principios-candidatos | docs/brainstorm/principios-candidatos.md | brainstorm-zona-livre | frio | — | 2026-06-16T02:46:03-03:00 |
| 20260616-032113-codex-state-selagem-faxina | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T03:21:13-03:00 |
| 20260616-032113-codex-handoff-selagem-faxina | .hbn/messages/20260616-032113-codex-handoff-selagem-faxina.md | handoff | quente | — | 2026-06-16T03:21:13-03:00 |

## S3.1 (2026-06-16) — INDEX vivo da knowledge — status: in_progress, readback 0029

S3.1 torna o índice da knowledge base verificável: o `INDEX.md` passa a listar
todas as entradas atuais e o guard G-KNOW-INDEX bloqueia qualquer knowledge
nova ou existente que não esteja citada no índice.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-113239-codex-readback-knowledge-index-vivo | .hbn/readbacks/0029-knowledge-index-vivo.json | readback | quente | — | 2026-06-16T11:32:39-03:00 |
| 20260616-113601-codex-assert-knowledge-index | guards/assert-knowledge-index.sh | guard | quente | — | 2026-06-16T11:36:01-03:00 |
| 20260616-113920-codex-knowledge-index-vivo | .hbn/knowledge/INDEX.md | knowledge-index | quente | — | 2026-06-16T11:39:20-03:00 |
| 20260616-113920-codex-runner-g-know-index | guards/hbn-guards-runner.sh | guard-runner | quente | — | 2026-06-16T11:39:20-03:00 |
| 20260616-113920-codex-guards-readme-g-know-index | guards/README.md | docs-guard | quente | — | 2026-06-16T11:39:20-03:00 |
| 20260616-113920-codex-run-guard-tests-g-know-index | guards/tests/run-guard-tests.sh | test-suite | quente | — | 2026-06-16T11:39:20-03:00 |
| 20260616-113920-codex-adversarial-b24 | guards/tests/adversarial-battery.sh | adversarial-test | quente | — | 2026-06-16T11:39:20-03:00 |
| 20260616-113920-codex-state-s3-1 | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T11:39:20-03:00 |
| 20260616-113920-codex-handoff-s3-1 | .hbn/messages/20260616-113920-codex-handoff-s3-1.md | handoff | quente | — | 2026-06-16T11:39:20-03:00 |

## Selagem S3.1 (2026-06-16) — lixo-zero — status: in_progress, readback 0030

S3.1 foi ratificada por cross-audit independente de Gemini/Antigravity e
Cursor, ambos com `APROVA_0029: SIM`. Esta micro-onda sela os pareceres, o
despacho do orquestrador, a knowledge 0023, o brainstorm de fronteira e o
handoff, sem alterar logica de guard.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-153000-codex-readback-selagem-s3-1 | .hbn/readbacks/0030-selagem-s3-1.json | readback | quente | — | 2026-06-16T15:30:00-03:00 |
| 20260616-121025-gemini-3-5-cross-ia-s3-1 | .hbn/results/20260616-121025-gemini-3-5-cross-ia-s3-1.md | audit-result | frio | — | 2026-06-16T12:10:25-03:00 |
| 20260616-124526-cursor-cross-ia-s3-1 | .hbn/results/20260616-124526-cursor-cross-ia-s3-1.md | audit-result | frio | — | 2026-06-16T12:45:26-03:00 |
| 20260616-150000-opus-4-8-despacho-cross-audit-s3-1 | .hbn/messages/20260616-150000-opus-4-8-despacho-cross-audit-s3-1.md | despacho | quente | — | 2026-06-16T15:00:00-03:00 |
| 20260616-153000-codex-knowledge-0023-area-temporaria | .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md | knowledge | quente | — | 2026-06-16T15:30:00-03:00 |
| 20260616-153000-codex-knowledge-index-0023 | .hbn/knowledge/INDEX.md | knowledge-index | quente | — | 2026-06-16T15:30:00-03:00 |
| 20260616-153000-codex-brainstorm-exuvia-evolucao-conceitual-s3-1 | docs/brainstorm/exuvia-evolucao-conceitual.md | brainstorm-zona-livre | frio | — | 2026-06-16T15:30:00-03:00 |
| 20260616-153000-codex-brainstorm-principios-candidatos-s3-1 | docs/brainstorm/principios-candidatos.md | brainstorm-zona-livre | frio | — | 2026-06-16T15:30:00-03:00 |
| 20260616-153000-codex-brainstorm-explicacao-publica-usehbn-draft | docs/brainstorm/EXPLICACAO-PUBLICA-usehbn-DRAFT.md | brainstorm-zona-livre | frio | — | 2026-06-16T15:30:00-03:00 |
| 20260616-153000-codex-state-selagem-s3-1 | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T15:30:00-03:00 |
| 20260616-153000-codex-handoff-selagem-s3-1 | .hbn/messages/20260616-153000-codex-handoff-selagem-s3-1.md | handoff | quente | — | 2026-06-16T15:30:00-03:00 |

## S3.2 (2026-06-16) — porta da frente: cartoes de papel + read-list — status: in_progress, readback 0031

S3.2 cria uma porta da frente minima para qualquer IA que assuma o bastao:
read-list limitada, cartoes curtos por papel e guard bloqueante contra
inflacao/monolito.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-160000-codex-readback-porta-da-frente-cartoes | .hbn/readbacks/0031-porta-da-frente-cartoes.json | readback | quente | — | 2026-06-16T16:00:00-03:00 |
| 20260616-160100-codex-role-cards | core/role-cards.md | spec-core | quente | — | 2026-06-16T16:01:00-03:00 |
| 20260616-160200-codex-assert-frontdoor | guards/assert-frontdoor.sh | guard | quente | — | 2026-06-16T16:02:00-03:00 |
| 20260616-160200-codex-runner-g-frontdoor | guards/hbn-guards-runner.sh | guard-runner | quente | — | 2026-06-16T16:02:00-03:00 |
| 20260616-160200-codex-guards-readme-g-frontdoor | guards/README.md | docs-guard | quente | — | 2026-06-16T16:02:00-03:00 |
| 20260616-160300-codex-run-guard-tests-g-frontdoor | guards/tests/run-guard-tests.sh | test-suite | quente | — | 2026-06-16T16:03:00-03:00 |
| 20260616-160300-codex-adversarial-b25 | guards/tests/adversarial-battery.sh | adversarial-test | quente | — | 2026-06-16T16:03:00-03:00 |
| 20260616-160400-codex-state-s3-2 | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T16:04:00-03:00 |
| 20260616-160400-codex-handoff-s3-2 | .hbn/messages/20260616-160400-codex-handoff-s3-2.md | handoff | quente | — | 2026-06-16T16:04:00-03:00 |

## Selagem S3.2 (2026-06-16) — lixo-zero — status: in_progress, readback 0032

S3.2 foi ratificada por cross-audit independente de Cursor e
Gemini/Antigravity, ambos com `APROVA_0031: SIM`. Esta micro-onda sela os
pareceres, versiona os brainstorms de Fronteira, registra a divida agrupada de
hardening de guards e aponta P-CAND-04 como proxima onda, sem alterar logica de
guard.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-164000-codex-readback-selagem-s3-2 | .hbn/readbacks/0032-selagem-s3-2.json | readback | quente | — | 2026-06-16T16:40:00-03:00 |
| 20260616-132743-cursor-cross-ia-s3-2 | .hbn/results/20260616-132743-cursor-cross-ia-s3-2.md | audit-result | frio | — | 2026-06-16T13:27:43-03:00 |
| 20260616-132813-gemini-3-5-cross-ia-s3-2 | .hbn/results/20260616-132813-gemini-3-5-cross-ia-s3-2.md | audit-result | frio | — | 2026-06-16T13:28:13-03:00 |
| 20260616-164000-codex-brainstorm-exuvia-evolucao-conceitual-s3-2 | docs/brainstorm/exuvia-evolucao-conceitual.md | brainstorm-zona-livre | frio | — | 2026-06-16T16:40:00-03:00 |
| 20260616-164000-codex-brainstorm-prompts-pf-arvores-agora-draft | docs/brainstorm/PROMPTS-PF-ARVORES-AGORA-DRAFT.md | brainstorm-zona-livre | frio | — | 2026-06-16T16:40:00-03:00 |
| 20260616-164000-codex-brainstorm-proposta-arvores-agora | docs/brainstorm/PROPOSTA-arvores-agora.md | brainstorm-zona-livre | frio | — | 2026-06-16T16:40:00-03:00 |
| 20260616-164000-codex-state-selagem-s3-2 | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T16:40:00-03:00 |
| 20260616-164000-codex-handoff-selagem-s3-2 | .hbn/messages/20260616-164000-codex-handoff-selagem-s3-2.md | handoff | quente | — | 2026-06-16T16:40:00-03:00 |

## P-CAND-04 (2026-06-16) — area temporaria /scratch/ + guards — status: in_progress, readback 0033

P-CAND-04 cria a area temporaria `/scratch/` na raiz, ignorada pelo Git com
excecao para `scratch/README.md`, e adiciona tres guards bloqueantes
fail-closed: G-SCRATCH-LOCK, G-SCRATCH-SYMLINK e G-SCRATCH-IGNORE.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-170000-codex-readback-area-temporaria-scratch | .hbn/readbacks/0033-area-temporaria-scratch.json | readback | quente | — | 2026-06-16T17:00:00-03:00 |
| 20260616-170100-codex-assert-scratch-lock | guards/assert-scratch-lock.sh | guard | quente | — | 2026-06-16T17:01:00-03:00 |
| 20260616-170100-codex-assert-scratch-symlink | guards/assert-scratch-symlink.sh | guard | quente | — | 2026-06-16T17:01:00-03:00 |
| 20260616-170100-codex-assert-scratch-ignore | guards/assert-scratch-ignore.sh | guard | quente | — | 2026-06-16T17:01:00-03:00 |
| 20260616-170500-codex-state-p-cand-04 | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T17:05:00-03:00 |
| 20260616-170500-codex-handoff-p-cand-04 | .hbn/messages/20260616-170500-codex-handoff-p-cand-04.md | handoff | quente | — | 2026-06-16T17:05:00-03:00 |

## W2 (2026-06-16) — hardening dos guards — status: in_progress, readback 0034

W2 fecha bypasses achados nas auditorias: G-KNOW-INDEX token-match e
anti-ponteiro-morto, G-FRONTDOOR com teto por bytes e read-list robusta,
G-EXC ancorado no ultimo paragrafo, G-SCRATCH fail-closed sem active-version e
comentario stale do G-REG.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-193000-codex-readback-hardening-guards | .hbn/readbacks/0034-hardening-guards.json | readback | quente | — | 2026-06-16T19:30:00-03:00 |
| 20260616-193100-codex-assert-knowledge-index-w2 | guards/assert-knowledge-index.sh | guard | quente | — | 2026-06-16T19:31:00-03:00 |
| 20260616-193200-codex-assert-frontdoor-w2 | guards/assert-frontdoor.sh | guard | quente | — | 2026-06-16T19:32:00-03:00 |
| 20260616-193300-codex-assert-exception-traceable-w2 | guards/assert-exception-traceable.sh | guard | quente | — | 2026-06-16T19:33:00-03:00 |
| 20260616-193400-codex-assert-scratch-lock-w2 | guards/assert-scratch-lock.sh | guard | quente | — | 2026-06-16T19:34:00-03:00 |
| 20260616-193400-codex-assert-scratch-symlink-w2 | guards/assert-scratch-symlink.sh | guard | quente | — | 2026-06-16T19:34:00-03:00 |
| 20260616-193400-codex-assert-scratch-ignore-w2 | guards/assert-scratch-ignore.sh | guard | quente | — | 2026-06-16T19:34:00-03:00 |
| 20260616-193500-codex-assert-registry-line-comment-w2 | guards/assert-registry-line.sh | guard-comment | quente | — | 2026-06-16T19:35:00-03:00 |
| 20260616-193600-codex-guards-readme-w2 | guards/README.md | docs-guard | quente | — | 2026-06-16T19:36:00-03:00 |
| 20260616-193700-codex-run-guard-tests-w2 | guards/tests/run-guard-tests.sh | test-suite | quente | — | 2026-06-16T19:37:00-03:00 |
| 20260616-193800-codex-adversarial-b29-b32 | guards/tests/adversarial-battery.sh | adversarial-test | quente | — | 2026-06-16T19:38:00-03:00 |
| 20260616-194500-codex-state-w2-hardening | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T19:45:00-03:00 |
| 20260616-194500-codex-handoff-w2-hardening | .hbn/messages/20260616-194500-codex-handoff-w2-hardening.md | handoff | quente | — | 2026-06-16T19:45:00-03:00 |

## Grande Selagem (2026-06-16) — P-CAND-04 + W2 + pendencias — status: in_progress, readback 0035

Selagem dos artefatos acumulados apos P-CAND-04 e W2 ratificados por
cross-audit: readback 0035, knowledges 0024/0025, proposta arvores+MVP, oito
pareceres cross-audit, STATE e handoff. Sem alterar logica de guard.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-203000-codex-readback-grande-selagem | .hbn/readbacks/0035-grande-selagem.json | readback | quente | — | 2026-06-16T20:30:00-03:00 |
| 20260616-203100-codex-knowledge-0024-zona-livre | .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md | knowledge | quente | — | 2026-06-16T20:31:00-03:00 |
| 20260616-203100-codex-knowledge-0025-auditor-read-only | .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md | knowledge | quente | — | 2026-06-16T20:31:00-03:00 |
| 20260616-203100-codex-knowledge-index-0024-0025 | .hbn/knowledge/INDEX.md | knowledge-index | quente | — | 2026-06-16T20:31:00-03:00 |
| 20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp | .hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md | proposta | quente | — | 2026-06-16T18:00:00-03:00 |
| 20260616-153302-antigravity-cross-ia-proposta-arvores-mvp | .hbn/results/20260616-153302-antigravity-cross-ia-proposta-arvores-mvp.md | audit-result | frio | — | 2026-06-16T15:33:02-03:00 |
| 20260616-153723-codex-cross-ia-proposta-arvores-mvp | .hbn/results/20260616-153723-codex-cross-ia-proposta-arvores-mvp.md | audit-result | frio | — | 2026-06-16T15:37:23-03:00 |
| 20260616-154200-cursor-cross-ia-proposta-arvores-mvp | .hbn/results/20260616-154200-cursor-cross-ia-proposta-arvores-mvp.md | audit-result | frio | — | 2026-06-16T15:42:00-03:00 |
| 20260616-155716-cursor-cross-ia-p-cand-04 | .hbn/results/20260616-155716-cursor-cross-ia-p-cand-04.md | audit-result | frio | — | 2026-06-16T15:57:16-03:00 |
| 20260616-172500-grok-cross-ia-w2-hardening | .hbn/results/20260616-172500-grok-cross-ia-w2-hardening.md | audit-result | frio | — | 2026-06-16T17:25:00-03:00 |
| 20260616-173000-antigravity-cross-ia-w2-hardening | .hbn/results/20260616-173000-antigravity-cross-ia-w2-hardening.md | audit-result | frio | — | 2026-06-16T17:30:00-03:00 |
| 20260616-184500-grok-cross-ia-proposta-arvores-mvp | .hbn/results/20260616-184500-grok-cross-ia-proposta-arvores-mvp.md | audit-result | frio | — | 2026-06-16T18:45:00-03:00 |
| 20260616-204530-grok-cross-ia-p-cand-04 | .hbn/results/20260616-204530-grok-cross-ia-p-cand-04.md | audit-result | frio | — | 2026-06-16T20:45:30-03:00 |
| 20260616-203400-codex-state-auditores-grande-selagem | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T20:34:00-03:00 |
| 20260616-203500-codex-state-grande-selagem | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T20:35:00-03:00 |
| 20260616-203500-codex-handoff-grande-selagem | .hbn/messages/20260616-203500-codex-handoff-grande-selagem.md | handoff | quente | — | 2026-06-16T20:35:00-03:00 |

## W3 (2026-06-16) — deny-by-default da zona livre — status: in_progress, readback 0036

W3 fecha a zona livre por padrao: qualquer arquivo staged sob
`docs/brainstorm/**` passa a exigir curadoria humana explicita no readback
ativo.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-213000-codex-readback-deny-zona-livre | .hbn/readbacks/0036-deny-zona-livre.json | readback | quente | — | 2026-06-16T21:30:00-03:00 |
| 20260616-213100-codex-assert-zona-livre | guards/assert-zona-livre.sh | guard | quente | — | 2026-06-16T21:31:00-03:00 |
| 20260616-213500-codex-state-w3-deny-zona-livre | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T21:35:00-03:00 |
| 20260616-213600-codex-handoff-w3-deny-zona-livre | .hbn/messages/20260616-213600-codex-handoff-w3-deny-zona-livre.md | handoff | quente | — | 2026-06-16T21:36:00-03:00 |

## Selagem W3 (2026-06-16) — G-ZONA-LIVRE ratificado — status: in_progress, readback 0037

W3 foi ratificado por quatro pareceres cross-audit (Grok, Antigravity e
Cursor) com `APROVA_0036: SIM`. Esta micro-onda sela os pareceres, deposita o
cartao de entrada universal como candidato a `core/cartao-entrada.md`, registra
branch protection biometrica armada na main e devolve o bastao ao orquestrador
para arvores registry-centric.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-230000-codex-readback-selagem-w3 | .hbn/readbacks/0037-selagem-w3.json | readback | quente | — | 2026-06-16T23:00:00-03:00 |
| 20260616-203624-grok-cross-ia-w3-deny-zona-livre | .hbn/results/20260616-203624-grok-cross-ia-w3-deny-zona-livre.md | audit-result | frio | — | 2026-06-16T20:36:24-03:00 |
| 20260616-210800-grok-cross-ia-w3-deny-zona-livre | .hbn/results/20260616-210800-grok-cross-ia-w3-deny-zona-livre.md | audit-result | frio | — | 2026-06-16T21:08:00-03:00 |
| 20260616-225300-antigravity-cross-ia-w3-deny-zona-livre | .hbn/results/20260616-225300-antigravity-cross-ia-w3-deny-zona-livre.md | audit-result | frio | — | 2026-06-16T22:53:00-03:00 |
| 20260616-225600-cursor-cross-ia-w3-deny-zona-livre | .hbn/results/20260616-225600-cursor-cross-ia-w3-deny-zona-livre.md | audit-result | frio | — | 2026-06-16T22:56:00-03:00 |
| 20260616-220000-opus-4-8-cartao-entrada-universal-ia | .hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md | proposta | quente | core/cartao-entrada.md | 2026-06-16T22:00:00-03:00 |
| 20260616-230100-codex-state-selagem-w3 | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T23:01:00-03:00 |
| 20260616-230100-codex-handoff-selagem-w3 | .hbn/messages/20260616-230100-codex-handoff-selagem-w3.md | handoff | quente | — | 2026-06-16T23:01:00-03:00 |

## R1 (2026-06-16) — runtime + honestidade — status: in_progress, readback 0038

R1 corrige runtime Python e honestidade documental antes do freeze/Ponte:
golden tests dos subcomandos, exit codes honestos, diretorio de estado canonico
`.hbn/`, classificacao honesta do autoevolve e handoff final ao orquestrador.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260616-234000-codex-readback-r1-runtime-honestidade | .hbn/readbacks/0038-r1-runtime-honestidade.json | readback | quente | — | 2026-06-16T23:40:00-03:00 |
| 20260616-235900-codex-state-r1-runtime-honestidade | .hbn/relay/STATE.md | state | quente | — | 2026-06-16T23:59:00-03:00 |
| 20260616-235900-codex-handoff-r1-runtime-honestidade | .hbn/messages/20260616-235900-codex-handoff-r1.md | handoff | quente | — | 2026-06-16T23:59:00-03:00 |

## R1-fix (2026-06-17) — dedup estado dual-read — status: in_progress, readback 0039

R1-fix corrige o bloqueador achado no cross-audit R1: `decisions` e
`context_history` nao podem duplicar entradas ao mesclar estado canonico e
legado.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-010000-codex-readback-r1-fix-dedup-estado | .hbn/readbacks/0039-r1-fix-dedup-estado.json | readback | quente | — | 2026-06-17T01:00:00-03:00 |
| 20260617-010500-codex-state-r1-fix-dedup-estado | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T01:05:00-03:00 |
| 20260617-010500-codex-handoff-r1-fix-dedup-estado | .hbn/messages/20260617-010500-codex-handoff-r1-fix.md | handoff | quente | — | 2026-06-17T01:05:00-03:00 |

## Selagem R1+R1-fix (2026-06-17) — triplo APROVA_R1 — status: in_progress, readback 0040

R1 (0038) e R1-fix (0039) foram ratificados por pareceres cross-audit de
Antigravity/Google, Grok/xAI e Cursor/OpenAI. Esta selagem torna tracked os
pareceres R1, sincroniza a contagem real da suite para 212/212 nos documentos
publicos permitidos e devolve o bastao ao orquestrador para R2 arvores
registry-centric.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-080000-codex-readback-selagem-r1 | .hbn/readbacks/0040-selagem-r1.json | readback | quente | — | 2026-06-17T08:00:00-03:00 |
| 20260617-003532-antigravity-cross-ia-r1-runtime | .hbn/results/20260617-003532-antigravity-cross-ia-r1-runtime.md | audit-result; autor=antigravity; familia=Google; veredito=APROVA_0038:NAO; onda=R1-runtime | frio | — | 2026-06-17T00:35:32-03:00 |
| 20260617-033849-cursor-composer-cross-ia-r1-runtime | .hbn/results/20260617-033849-cursor-composer-cross-ia-r1-runtime.md | audit-result; autor=cursor-composer; familia=Cursor/Antigravity; veredito=APROVA_0038:SIM; onda=R1-runtime | frio | — | 2026-06-17T03:38:49-03:00 |
| 20260617-060212-cursor-cross-ia-r1-mais-fix | .hbn/results/20260617-060212-cursor-cross-ia-r1-mais-fix.md | audit-result; autor=cursor-gpt52; familia=OpenAI; veredito=APROVA_R1:SIM; onda=R1+R1-fix | frio | — | 2026-06-17T06:02:12-03:00 |
| 20260617-072143-antigravity-cross-ia-r1-mais-fix | .hbn/results/20260617-072143-antigravity-cross-ia-r1-mais-fix.md | audit-result; autor=antigravity; familia=Google; veredito=APROVA_R1:SIM; onda=R1+R1-fix | frio | — | 2026-06-17T07:21:43-03:00 |
| 20260617-072901-grok-cross-ia-r1-mais-fix | .hbn/results/20260617-072901-grok-cross-ia-r1-mais-fix.md | audit-result; autor=grok; familia=xAI; veredito=APROVA_R1:SIM; onda=R1+R1-fix | frio | — | 2026-06-17T07:29:01-03:00 |
| 20260617-081500-codex-state-selagem-r1 | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T08:15:00-03:00 |
| 20260617-081500-codex-handoff-selagem-r1 | .hbn/messages/20260617-081500-codex-handoff-selagem-r1.md | handoff | quente | — | 2026-06-17T08:15:00-03:00 |

## R1-fix-2 (2026-06-17) — dedup decisions/context_history engine-real — status: in_progress, readback 0041

R1-fix-2 corrige a perda de `decisions` e `context_history` distintos que
compartilham `execution_id` no merge canonico+legado, preservando
`executions`/`results` deduplicados por execucao.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-090000-codex-readback-r1-fix2-dedup-decisions | .hbn/readbacks/0041-r1-fix2-dedup-decisions.json | readback | quente | — | 2026-06-17T09:00:00-03:00 |
| 20260617-093000-codex-state-r1-fix2-dedup-decisions | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T09:30:00-03:00 |
| 20260617-093000-codex-handoff-r1-fix2 | .hbn/messages/20260617-093000-codex-handoff-r1-fix2.md | handoff | quente | — | 2026-06-17T09:30:00-03:00 |

## Selagem R1-fix-2 (2026-06-17) — duplo APROVA_0041 — status: in_progress, readback 0042

R1-fix-2 (readback 0041) foi ratificado por dois pareceres cross-audit de
familias distintas de OpenAI, ambos com prova engine-real ANTES/DEPOIS:
Antigravity/Google e Grok/xAI registraram `APROVA_0041: SIM`. Esta selagem
torna tracked os pareceres, registra o placar e devolve o bastao ao
orquestrador para a promocao da Esteira de Pre-Transicao, curadoria do dossie e
R2 arvores registry-centric.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-100000-codex-readback-selagem-r1-fix2 | .hbn/readbacks/0042-selagem-r1-fix2.json | readback | quente | — | 2026-06-17T10:00:00-03:00 |
| 20260617-085700-antigravity-cross-ia-r1-fix2 | .hbn/results/20260617-085700-antigravity-cross-ia-r1-fix2.md | audit-result; autor=antigravity; familia=Google; veredito=APROVA_0041:SIM; onda=r1-fix2 | frio | — | 2026-06-17T08:57:00-03:00 |
| 20260617-091000-grok-build-0.1-cross-ia-r1-fix2 | .hbn/results/20260617-091000-grok-build-0.1-cross-ia-r1-fix2.md | audit-result; autor=grok-build-0.1; familia=xAI; veredito=APROVA_0041:SIM; onda=r1-fix2 | frio | — | 2026-06-17T09:10:00-03:00 |
| 20260617-100500-codex-state-selagem-r1-fix2 | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T10:05:00-03:00 |
| 20260617-100500-codex-handoff-selagem-r1-fix2 | .hbn/messages/20260617-100500-codex-handoff-selagem-r1-fix2.md | handoff | quente | — | 2026-06-17T10:05:00-03:00 |

## Esteira de Pre-Transicao (2026-06-17) — promocao para core — status: in_progress, readback 0043

A Esteira de Pre-Transicao formaliza ondas read-only de subagentes tematicos
antes do freeze e da exuvia, com regras vinculantes R-PT1..R-PT5. Esta onda
promove a proposta para `core/esteira-pre-transicao.md` como spec-core
`proposed`, aguardando cross-audit ≠-familia antes de selagem.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-103000-codex-readback-promove-esteira-pre-transicao | .hbn/readbacks/0043-promove-esteira-pre-transicao.json | readback | quente | — | 2026-06-17T10:30:00-03:00 |
| 20260617-103000-codex-esteira-pre-transicao-core | core/esteira-pre-transicao.md | spec-core | quente | — | 2026-06-17T10:30:00-03:00 |
| 20260617-103500-codex-state-promove-esteira | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T10:35:00-03:00 |
| 20260617-103500-codex-handoff-promove-esteira | .hbn/messages/20260617-103500-codex-handoff-promove-esteira.md | handoff | quente | — | 2026-06-17T10:35:00-03:00 |

## Selagem Esteira de Pre-Transicao (2026-06-17) — duplo APROVA_0043 — status: in_progress, readback 0044

A Esteira de Pre-Transicao (readback 0043) foi ratificada por dois pareceres
cross-audit de familias distintas de OpenAI: Antigravity/Google e
Grok-build-0.1/xAI registraram `APROVA_0043: SIM`. Esta selagem resolve a
marginal de arvore removendo o rotulo prematuro do front-matter, ratifica a
spec como accepted, torna tracked os pareceres e devolve o bastao ao
orquestrador para curadoria do dossie pre-transicao e R2 arvores
registry-centric.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-110000-codex-readback-selagem-esteira | .hbn/readbacks/0044-selagem-esteira.json | readback | quente | — | 2026-06-17T11:00:00-03:00 |
| 20260617-102800-antigravity-cross-ia-esteira-0043 | .hbn/results/20260617-102800-antigravity-cross-ia-esteira-0043.md | audit-result; autor=antigravity; familia=Google; veredito=APROVA_0043:SIM; onda=esteira | frio | — | 2026-06-17T10:28:00-03:00 |
| 20260617-104500-grok-build-0.1-cross-ia-esteira-0043 | .hbn/results/20260617-104500-grok-build-0.1-cross-ia-esteira-0043.md | audit-result; autor=grok-build-0.1; familia=xAI; veredito=APROVA_0043:SIM; onda=esteira | frio | — | 2026-06-17T10:45:00-03:00 |
| 20260617-111500-codex-state-selagem-esteira | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T11:15:00-03:00 |
| 20260617-111500-codex-handoff-selagem-esteira | .hbn/messages/20260617-111500-codex-handoff-selagem-esteira.md | handoff | quente | — | 2026-06-17T11:15:00-03:00 |

## Curadoria P0 docs (2026-06-17) — honestidade da porta de entrada e docs canonicos — status: in_progress, readback 0045

A Curadoria P0 corrige a porta de entrada (`AGENTS.md`), cria o glossario
canonico em `docs/GLOSSARY.md` e reduz a copia superseded
`docs/MATURITY-MATRIX.md` a redirect, sem tocar `core/**`, `methodology/**`,
`guards/**`, `schemas/**`, `src/**` ou `docs/brainstorm/**`.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-113000-codex-readback-curadoria-p0-docs | .hbn/readbacks/0045-curadoria-p0-docs.json | readback | quente | — | 2026-06-17T11:30:00-03:00 |
| 20260617-113000-codex-state-curadoria-p0-abertura | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T11:30:00-03:00 |
| 20260617-113100-codex-glossario-canonico | docs/GLOSSARY.md | doc | quente | — | 2026-06-17T11:31:00-03:00 |
| 20260617-113200-codex-maturity-matrix-redirect | docs/MATURITY-MATRIX.md | doc-redirect | frio | methodology/MATURITY-MATRIX.md | 2026-06-17T11:32:00-03:00 |
| 20260617-113500-codex-state-handoff-curadoria-p0 | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T11:35:00-03:00 |
| 20260617-113500-codex-handoff-curadoria-p0 | .hbn/messages/20260617-113500-codex-handoff-curadoria-p0.md | handoff | quente | — | 2026-06-17T11:35:00-03:00 |

## Selagem Curadoria P0 (2026-06-17) — duplo APROVA_0045 — status: in_progress, readback 0046

A Curadoria P0 (readback 0045) foi ratificada por dois pareceres cross-audit
de familias distintas de OpenAI: Antigravity/Google e Grok/xAI registraram
`APROVA_0045: SIM`. Esta selagem torna tracked os pareceres, registra o placar
e devolve o bastao ao orquestrador para a onda G-AUDITOR-ID; depois R2 arvores
registry-centric.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-130000-codex-readback-selagem-curadoria-p0 | .hbn/readbacks/0046-selagem-curadoria-p0.json | readback | quente | — | 2026-06-17T13:00:00-03:00 |
| 20260617-130000-codex-state-selagem-curadoria-p0-abertura | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T13:00:00-03:00 |
| 20260617-124513-antigravity-cross-ia-curadoria-p0-0045 | .hbn/results/20260617-124513-antigravity-cross-ia-curadoria-p0-0045.md | audit-result; autor=antigravity; familia=Google; veredito=APROVA_0045:SIM; onda=curadoria-p0 | frio | — | 2026-06-17T12:45:13-03:00 |
| 20260617-125600-grok-cross-ia-curadoria-p0-0045 | .hbn/results/20260617-125600-grok-cross-ia-curadoria-p0-0045.md | audit-result; autor=grok; familia=xAI; veredito=APROVA_0045:SIM; onda=curadoria-p0 | frio | — | 2026-06-17T12:56:00-03:00 |
| 20260617-151103-codex-state-selagem-curadoria-p0 | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T15:11:03-03:00 |
| 20260617-151103-codex-handoff-selagem-curadoria-p0 | .hbn/messages/20260617-151103-codex-handoff-selagem-curadoria-p0.md | handoff | quente | — | 2026-06-17T15:11:03-03:00 |

## G-AUDITOR-ID (2026-06-17) — auto-ID do auditor como gate enforcado — status: in_progress, readback 0047

G-AUDITOR-ID transforma a autoidentificacao do auditor em guard fail-closed
para `.hbn/results/*.md` adicionados: nome, linha `SOU:`, apelido e familia
canonica precisam bater com o mapa curado. Esta onda cobre a Camada 1; a
contagem de diversidade fica para fast-follow.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-133000-codex-readback-g-auditor-id | .hbn/readbacks/0047-g-auditor-id.json | readback | quente | — | 2026-06-17T13:30:00-03:00 |
| 20260617-152822-codex-state-g-auditor-id-abertura | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T15:28:22-03:00 |
| 20260617-153000-codex-guard-auditor-id | guards/assert-auditor-id.sh | guard | quente | — | 2026-06-17T15:30:00-03:00 |
| 20260617-153913-codex-knowledge-0026-auto-id-auditor | .hbn/knowledge/0026-auto-id-auditor-gate-enforcado.md | knowledge | quente | — | 2026-06-17T15:39:13-03:00 |
| 20260617-154109-codex-state-g-auditor-id-handoff | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T15:41:09-03:00 |
| 20260617-154109-codex-handoff-g-auditor-id | .hbn/messages/20260617-154109-codex-handoff-g-auditor-id.md | handoff | quente | — | 2026-06-17T15:41:09-03:00 |

## Selagem G-AUDITOR-ID (2026-06-17) — duplo APROVA_0047 — status: in_progress, readback 0048

O G-AUDITOR-ID (readback 0047) foi ratificado por dois pareceres cross-audit
de familias distintas de OpenAI: Antigravity/Google registrou
`APROVA_0047: SIM` com confiança 100/100 e Grok/xAI registrou
`APROVA_0047: SIM` com confiança 95/100. Esta selagem torna tracked os
pareceres e valida os dois pelo proprio G-AUDITOR-ID.

| id | artefato (path) | tipo | temperatura | superseded_by | created_at |
|---|---|---|---|---|---|
| 20260617-140000-codex-readback-selagem-g-auditor-id | .hbn/readbacks/0048-selagem-g-auditor-id.json | readback | quente | — | 2026-06-17T14:00:00-03:00 |
| 20260617-161200-codex-state-selagem-g-auditor-id-abertura | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T16:12:00-03:00 |
| 20260617-160500-antigravity-cross-ia-g-auditor-id-0047 | .hbn/results/20260617-160500-antigravity-cross-ia-g-auditor-id-0047.md | audit-result; autor=antigravity; familia=Google; veredito=APROVA_0047:SIM; onda=g-auditor-id | frio | — | 2026-06-17T16:05:00-03:00 |
| 20260617-160546-grok-cross-ia-g-auditor-id-0047 | .hbn/results/20260617-160546-grok-cross-ia-g-auditor-id-0047.md | audit-result; autor=grok; familia=xAI; veredito=APROVA_0047:SIM; onda=g-auditor-id | frio | — | 2026-06-17T16:05:46-03:00 |
| 20260617-161730-codex-state-selagem-g-auditor-id | .hbn/relay/STATE.md | state | quente | — | 2026-06-17T16:17:30-03:00 |
| 20260617-161730-codex-handoff-selagem-g-auditor-id | .hbn/messages/20260617-161730-codex-handoff-selagem-g-auditor-id.md | handoff | quente | — | 2026-06-17T16:17:30-03:00 |

## R2 arvores registry-centric (2026-06-17) — mecanismo registry-centric — status: in_progress, readback 0049

R2 introduz o mecanismo de arvores como fonte unica no REGISTRY. A partir deste
bloco, linhas going-forward usam 7 colunas na ordem fixa:
`id`, `artefato (path)`, `tipo`, `temperatura`, `arvore`, `superseded_by`,
`created_at`.

| id | artefato (path) | tipo | temperatura | arvore | superseded_by | created_at |
|---|---|---|---|---|---|---|
| 20260617-184000-codex-readback-arvores-registry-centric | .hbn/readbacks/0049-arvores-registry-centric.json | readback | quente | fronteira | — | 2026-06-17T18:40:00-03:00 |
| 20260617-184001-codex-state-r2-arvores-abertura | .hbn/relay/STATE.md | state | quente | fronteira | — | 2026-06-17T18:40:01-03:00 |
| 20260617-184002-codex-parallel-id-created-at-column-aware | guards/assert-parallel-id.sh | guard | quente | fronteira | — | 2026-06-17T18:40:02-03:00 |
| 20260617-184100-codex-arvores-spec-core | core/arvores-spec.md | spec-core | quente | fronteira | — | 2026-06-17T18:41:00-03:00 |
| 20260617-184200-codex-registry-line-arvore-column-aware | guards/assert-registry-line.sh | guard | quente | fronteira | — | 2026-06-17T18:42:00-03:00 |
| 20260617-184201-codex-guard-tests-arvore-registry | guards/tests/run-guard-tests.sh | guard-test | quente | fronteira | — | 2026-06-17T18:42:01-03:00 |
| 20260617-184300-codex-guard-arvore-label | guards/assert-arvore-label.sh | guard | quente | fronteira | — | 2026-06-17T18:43:00-03:00 |
| 20260617-184301-codex-runner-arvore-label | guards/hbn-guards-runner.sh | guard-runner | quente | fronteira | — | 2026-06-17T18:43:01-03:00 |
| 20260617-184400-codex-guard-tests-arvore-label | guards/tests/run-guard-tests.sh | guard-test | quente | fronteira | — | 2026-06-17T18:44:00-03:00 |
| 20260617-184401-codex-adversarial-b38-arvore-label | guards/tests/adversarial-battery.sh | guard-test | quente | fronteira | — | 2026-06-17T18:44:01-03:00 |
| 20260617-184501-codex-state-r2-arvores-handoff | .hbn/relay/STATE.md | state | quente | fronteira | — | 2026-06-17T18:45:01-03:00 |
| 20260617-184500-codex-handoff-arvores | .hbn/messages/20260617-184500-codex-handoff-arvores.md | handoff | quente | fronteira | — | 2026-06-17T18:45:00-03:00 |

## Selagem R2 arvores (2026-06-17) — duplo APROVA_0049 — status: in_progress, readback 0050

R2 arvores registry-centric (readback 0049) foi ratificada por dois pareceres
cross-audit de familias distintas de OpenAI: Grok/xAI registrou
`APROVA_0049: SIM` com confianca 93/100 e Antigravity/Google registrou
`APROVA_0049: SIM` com confianca 100/100. Esta selagem ratifica a spec como
accepted, torna tracked os pareceres e deixa a promocao para intermediaria em
onda propria.

| id | artefato (path) | tipo | temperatura | arvore | superseded_by | created_at |
|---|---|---|---|---|---|---|
| 20260617-193000-codex-readback-selagem-arvores | .hbn/readbacks/0050-selagem-arvores.json | readback | quente | fronteira | — | 2026-06-17T19:30:00-03:00 |
| 20260617-192141-grok-cross-ia-arvores-0049 | .hbn/results/20260617-192141-grok-cross-ia-arvores-0049.md | audit-result; autor=grok; familia=xAI; veredito=APROVA_0049:SIM; onda=arvores-0049 | frio | fronteira | — | 2026-06-17T19:21:41-03:00 |
| 20260617-192729-antigravity-cross-ia-arvores-0049 | .hbn/results/20260617-192729-antigravity-cross-ia-arvores-0049.md | audit-result; autor=antigravity; familia=Google; veredito=APROVA_0049:SIM; onda=arvores-0049 | frio | fronteira | — | 2026-06-17T19:27:29-03:00 |
| 20260617-193300-codex-handoff-selagem-arvores | .hbn/messages/20260617-193300-codex-handoff-selagem-arvores.md | handoff | quente | fronteira | — | 2026-06-17T19:33:00-03:00 |

## R3a G-TRAILERS (2026-06-17) — contiguidade de trailers independente da excecao — status: in_progress, readback 0051

R3a adiciona um guard aditivo para exigir os 3 trailers HBN contiguos no ultimo
paragrafo de todo commit governado, independente do campo `implementador` no
STATE. Fecha a divida da R1 em que o G-EXC ficava inativo com
`implementador=null` e trailers nao-contiguos passavam.

| id | artefato (path) | tipo | temperatura | arvore | superseded_by | created_at |
|---|---|---|---|---|---|---|
| 20260617-205800-codex-readback-g-trailers | .hbn/readbacks/0051-g-trailers.json | readback | quente | fronteira | — | 2026-06-17T20:58:00-03:00 |
| 20260617-205801-codex-state-g-trailers-abertura | .hbn/relay/STATE.md | state | quente | fronteira | — | 2026-06-17T20:58:01-03:00 |
| 20260617-210200-codex-guard-trailers-contiguous | guards/assert-trailers-contiguous.sh | guard | quente | fronteira | — | 2026-06-17T21:02:00-03:00 |
| 20260617-210201-codex-runner-g-trailers | guards/hbn-guards-runner.sh | guard-runner | quente | fronteira | — | 2026-06-17T21:02:01-03:00 |
