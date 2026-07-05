---
titulo: REGISTRY — livro-razão de artefatos do useHBN v3.0.0
status: ativo
temperatura: quente
path: versao_3_0_0/REGISTRY.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
regras: append-only; uma linha por evento (nascimento ou mudança de temperatura/árvore); nunca rename, nunca delete
evidencia: core/04-artefatos.md §REGISTRY
---

# REGISTRY do useHBN v3.0.0

Livro-razão append-only desta versão. Formato da linha (7 colunas, G-REG):
`| id | path | tipo | temperatura | arvore | superseded_by | created_at |`
Paths no referencial da versão (sem o prefixo `versao_3_0_0/`). Quem deposita
artefato governado appenda a linha no MESMO commit do depósito (G-REG).

Os livros-razão do passado permanecem congelados em `../versao_0_3_x/REGISTRY.md`
e `../versao_2_0_0/REGISTRY.md` (história imutável, glacier).

## Linhas

| id | path | tipo | temperatura | arvore | superseded_by | created_at |
|---|---|---|---|---|---|---|
| 20260705-001 | .github/workflows/hbn-shield.yml | workflow | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-002 | .hbn/knowledge/0001-comandos-atomicos-copiaveis.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-003 | .hbn/knowledge/0002-entrega-operacional-minimalista.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-004 | .hbn/knowledge/0003-git-sandbox-sem-lock.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-005 | .hbn/knowledge/0019-severidades-veto.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-006 | .hbn/knowledge/0022-firewall-workflow-fast-track.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-007 | .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-008 | .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-009 | .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-010 | .hbn/knowledge/0026-auto-id-auditor-gate-enforcado.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-011 | .hbn/knowledge/0027-trailers-contiguos-independente-de-excecao.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-012 | .hbn/knowledge/0028-diversidade-familia-enforced-selagem.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-013 | .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-014 | .hbn/knowledge/0030-chat-novo-prompts-sequenciais.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-015 | .hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-016 | .hbn/knowledge/0032-prompts-autocontidos-output-canonico.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-017 | .hbn/knowledge/INDEX.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-018 | .hbn/knowledge/distribution-model.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-019 | .hbn/knowledge/relay-protocol.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-020 | .hbn/knowledge/runtime-command-model.md | knowledge | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-021 | .hbn/models/codex.json | model-profile | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-022 | .hbn/models/cursor.json | model-profile | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-023 | .hbn/models/fable-5.json | model-profile | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-024 | .hbn/models/gemini-3-5.json | model-profile | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-025 | .hbn/models/grok.json | model-profile | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-026 | .hbn/models/opus-4-8.json | model-profile | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-027 | .hbn/operators/README.md | dado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-028 | .hbn/readbacks/0001-terceira-exuvia-genese.json | readback | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-029 | .hbn/relay/STATE.md | estado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-030 | .hbn/stray-allowlist | dado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-031 | BOOT.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-032 | LICENSE | licenca | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-033 | ROADMAP.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-034 | TRANSICAO.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-035 | core/01-principios.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-036 | core/02-papeis.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-037 | core/03-rito-da-onda.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-038 | core/04-artefatos.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-039 | core/05-guards.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-040 | core/06-freeze-fitness-exuvia.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-041 | core/07-projetos-membrana.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-042 | core/08-evolucao.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-043 | core/actor-write-matrix.txt | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-044 | core/dual-run-spec.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-045 | core/exuvia-fitness-criteria.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-046 | core/freeze-gate-spec.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-047 | core/read-list-canonica.txt | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-048 | core/role-cards.md | spec | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-049 | guards/MANIFEST.yaml | dado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-050 | guards/README.md | dado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-051 | guards/assert-active-version-integrity.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-052 | guards/assert-arvore-label.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-053 | guards/assert-audit-diversity.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-054 | guards/assert-auditor-id.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-055 | guards/assert-baton-token.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-056 | guards/assert-canonical-root.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-057 | guards/assert-ci-battery.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-058 | guards/assert-copy-block.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-059 | guards/assert-dispatch-integrity.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-060 | guards/assert-exception-traceable.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-061 | guards/assert-frontdoor.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-062 | guards/assert-hearback-integrity.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-063 | guards/assert-knowledge-index.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-064 | guards/assert-manifest-current.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-065 | guards/assert-next-checkpoint.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-066 | guards/assert-no-pending-exuvia.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-067 | guards/assert-no-stray-hbn.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-068 | guards/assert-only-hot-version-writable.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-069 | guards/assert-orq-entrada-ref.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-070 | guards/assert-orq-entrada.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-071 | guards/assert-parallel-id.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-072 | guards/assert-pointer-honest.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-073 | guards/assert-profile-authorized.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-074 | guards/assert-quorum-selagem.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-075 | guards/assert-readlist-rite.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-076 | guards/assert-registry-line.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-077 | guards/assert-report-fresh.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-078 | guards/assert-role-family.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-079 | guards/assert-scope-lock.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-080 | guards/assert-scratch-ignore.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-081 | guards/assert-scratch-lock.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-082 | guards/assert-scratch-symlink.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-083 | guards/assert-self-path.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-084 | guards/assert-start-cast.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-085 | guards/assert-state-structural.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-086 | guards/assert-trailers-contiguous.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-087 | guards/assert-zona-livre.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-088 | guards/ci-entry.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-089 | guards/data/auditor-families.txt | dado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-090 | guards/fixtures/registry-skeleton.md | dado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-091 | guards/fixtures/role-cards-consumer.md | dado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-092 | guards/forbid-env-files.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-093 | guards/forbid-legacy-paths.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-094 | guards/forbid-tmp-worktree.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-095 | guards/freeze-gate.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-096 | guards/generate-manifest.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-097 | guards/hbn-guards-runner.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-098 | guards/hook-shims/commit-msg | dado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-099 | guards/hook-shims/pre-commit | dado | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-100 | guards/lib/common.sh | lib | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-101 | guards/tests/adversarial-battery.sh | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-102 | guards/tests/fixtures/atribuicoes/bad-groupthink.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-103 | guards/tests/fixtures/atribuicoes/bad-hearback-inexistente.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-104 | guards/tests/fixtures/atribuicoes/bad-hearback-pendente.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-105 | guards/tests/fixtures/atribuicoes/bad-hearback-root-only.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-106 | guards/tests/fixtures/atribuicoes/bad-hearback-sem-excecao.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-107 | guards/tests/fixtures/atribuicoes/bad-orq-sem-aptidao.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-108 | guards/tests/fixtures/atribuicoes/bad-paralelo-forasteiro.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-109 | guards/tests/fixtures/atribuicoes/good-cast-serial.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-110 | guards/tests/fixtures/atribuicoes/good-cross.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-111 | guards/tests/fixtures/atribuicoes/good-hearback-active-root.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-112 | guards/tests/fixtures/atribuicoes/good-hearback-cobre.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-113 | guards/tests/fixtures/freeze/bad-bloqueador.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-114 | guards/tests/fixtures/freeze/bad-na-sem-hearback.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-115 | guards/tests/fixtures/freeze/bad-ok-sem-evidencia.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-116 | guards/tests/fixtures/freeze/good-all-ok.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-117 | guards/tests/fixtures/freeze/good-na-com-hearback.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-118 | guards/tests/fixtures/hearbacks/active-root-confirmado.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-119 | guards/tests/fixtures/hearbacks/confirmado-com-excecao.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-120 | guards/tests/fixtures/hearbacks/confirmado-sem-excecao.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-121 | guards/tests/fixtures/hearbacks/pendente.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-122 | guards/tests/fixtures/models/alpha-1.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-123 | guards/tests/fixtures/models/alpha-2.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-124 | guards/tests/fixtures/models/beta-1.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-125 | guards/tests/fixtures/models/gamma-1.json | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-126 | guards/tests/run-guard-tests.sh | teste | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-127 | guards/validate-dispatch.sh | guard | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-128 | membrane/MEMBRANE_MANIFEST.template.json | membrana | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-129 | membrane/assert-snapshot-integrity.sh | membrana | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-130 | schemas/audit-post.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-131 | schemas/audit-pre.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-132 | schemas/autoevolve-cycle.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-133 | schemas/connector-approval.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-134 | schemas/connector-contract.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-135 | schemas/consent.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-136 | schemas/dispatch.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-137 | schemas/dual-run-result.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-138 | schemas/freeze-checklist.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-139 | schemas/guard-requires.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-140 | schemas/guardian.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-141 | schemas/handoff.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-142 | schemas/hearback.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-143 | schemas/intent.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-144 | schemas/model-profile.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-145 | schemas/readback.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-146 | schemas/result.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-147 | schemas/state.schema.json | schema | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-148 | scripts/hbn-exuvia-atomic.sh | script | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-149 | scripts/hbn-exuvia-rollback.sh | script | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-150 | scripts/hbn-install-guard | script | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-151 | scripts/hbn-snapshot/install-snapshot.sh | script | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-152 | scripts/hbn-upgrade-snapshot.sh | script | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-153 | scripts/tests/test-hbn-exuvia-rollback.sh | script | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-155 | .cursor/hooks.json | boot-lock | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-156 | .cursor/hooks/hbn-boot-lock.sh | boot-lock | quente | fronteira |  | 2026-07-05T02:30:00-03:00 |
| 20260705-157 | .hbn/results/20260705-140000-grok-cross-ia-0001.md | result-cross-ia | quente | fronteira |  | 2026-07-05T14:00:00-03:00 |
| 20260705-158 | .hbn/results/20260705-141500-antigravity-cross-ia-0001.md | result-cross-ia | quente | fronteira |  | 2026-07-05T14:15:00-03:00 |
