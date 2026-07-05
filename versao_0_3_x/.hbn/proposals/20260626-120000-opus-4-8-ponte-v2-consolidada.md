---
titulo: "Proposta-ponte v2 — membrana protocolo(v1-estável)⇄Credenciamento (passo 2)"
tipo: proposal
status: congelado
temperatura: glacier
path: .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md
created_at: "2026-06-26T12:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
direcao_humana: "Mauricio (Luis Mauricio Junqueira Zanin), 2026-06-26"
consultas:
  - .hbn/results/20260626-021000-antigravity-consulta-ponte-design.md
  - .hbn/results/20260626-021500-grok-consulta-ponte-design.md
  - .hbn/results/20260626-031000-codex-auditoria-executiva-ponte.md
supersedes: .hbn/proposals/20260610-233218-fable5-ponte-consolidada.md
---

# Proposta-ponte v2 — "duas camadas, uma membrana"

## 0. Objetivo (direção de Mauricio)
Dar ao PROJETO (Credenciamento) uma forma de evoluir **respeitando os fluxos de segurança/garantia
do PROTOCOLO** (selado em v1-estável), com **três garantias inegociáveis**:
1. **Sem confusão** protocolo × projeto — nenhuma IA pode confundir "o que é o PROTOCOLO" com "o que é
   o PROJETO executado sob as guardas do protocolo".
2. **Respeitar os fluxos** — o projeto RODA guards+ritos do protocolo nos próprios commits (não só lê docs).
3. **Contribuição de volta** — o projeto contribui lições aprendidas ao protocolo com fluidez, sem confusão.
Supersede a proposta de 2026-06-10 (que assumia `methodology/+modules/`; `modules/` não existe no v1-estável).

## 1. Desenho — duas camadas, uma membrana
- **Camada 1 — PROTOCOLO (genoma):** vive só em `~/Projetos/usehbn`, congelado na tag `v1-estável`
  (commit `a67e8049…`). Read-only para o projeto.
- **Camada 2 — PROJETO (Credenciamento):** app de domínio (VBA/Excel); evolui SOB os fluxos do protocolo.
- **Membrana — `.usehbn-snapshot/` no projeto:** cópia read-only, versionada e checada da **superfície
  aplicável** do protocolo. Gerada da TREE do tag, com manifesto determinístico + checksum. O projeto
  NUNCA edita; só consome.

## 2. Escopo do snapshot = B-subset (consenso das 3 IAs)
Entra (gerado por `git archive v1-estavel -- core methodology schemas guards`; PoC do codex = 137 arquivos):
`core/` + `methodology/` (seletivo) + `schemas/` + `guards/` (com `lib/`).
NÃO entram: `src/`, `tests/`, `.hbn/` do genoma, `docs/brainstorm/`, `scratch/`, histórico de ADRs internos.

**Subconjunto de guards que o PROJETO roda sobre si** (consenso antigravity+grok+codex):
`assert-canonical-root`, `forbid-tmp-worktree`, `forbid-env-files`, `forbid-legacy-paths`,
`assert-scratch-lock/symlink/ignore`, `assert-zona-livre`, `assert-scope-lock`, `assert-hearback-integrity`,
`assert-no-stray-hbn`, `assert-self-path`, `assert-trailers-contiguous`, `assert-report-fresh`,
`assert-readlist-rite`, `assert-knowledge-index` (faseado: warning→bloqueante após higiene).
**Guards internos do genoma (NÃO vão / doc-only):** `assert-orq-entrada(-ref)`, `validate-dispatch`,
`assert-dispatch-integrity`, `assert-registry-line`, `assert-pointer-honest`, `assert-arvore-label`,
`assert-auditor-id`, `assert-audit-diversity`, `assert-quorum-selagem`, `assert-parallel-id`,
`freeze-gate`, `assert-baton-token`.
Declarado em `CONSUMER-PROFILE.md` (gerado no snapshot: subset ativo + excluídos).

## 3. Compatibilidade (achado crítico do codex — protocolo fica congelado)
Os guards do protocolo são *version-aware* (`guards/lib/common.sh` exige `.hbn/active-version`); o projeto
não tem. **Solução que mantém o protocolo INTACTO:** o PROJETO fornece `.hbn/active-version` = `.`
(semântica de consumidor). Nada no genoma v1-estável muda. (Evolução futura opcional: `--project-mode`
no `common.sh` numa versão futura do protocolo — fora do escopo do passo 2.)

## 4. Integridade — `assert-snapshot-integrity.sh` (LOCAL no projeto)
Vive em `scripts/hbn-guards/` (FORA do snapshot — senão editar o snapshot editaria o próprio guard).
- `PROTOCOL_MANIFEST.sha256`: linhas `mode sha256 path`, `LC_ALL=C`, LF-normalizado, paths relativos.
- `PROTOCOL_SHA256.txt`: hash do manifesto + metadados (`tag`, `commit`, `generated_at`, `surface`).
- `USEHBN-HEADER.txt`: "ISTO É O PROTOCOLO (usehbn@v1-estável) — read-only — NÃO EDITAR".
- Checks: toplevel == Credenciamento; sem `.git` no snapshot; sem symlink; modos git (`100644/100755`);
  `git diff --cached -- .usehbn-snapshot` vazio no modo normal; lê **blob staged**, não só working tree.
- Modos: `--install` / `--upgrade` (com OLD/NEW sha no readback) — fora deles, fail-closed.

## 5. Runner project-mode (opção c — shims locais)
`scripts/hbn-guards/hbn-guards-runner.sh` do projeto = entrypoint; roda 1º `assert-snapshot-integrity`,
depois enumera o subset e chama os guards de `.usehbn-snapshot/guards/` individualmente (NÃO o runner
completo do protocolo). Subset bloqueante inicial: canonical-root, tmp-worktree, env-files, legacy-paths,
scope-lock, hearback-integrity; `assert-knowledge-index` como warning até a higiene dos 7 itens do INDEX.

## 6. Sem confusão — router + tombstone + untangle
- **Router OBRIGATÓRIO no topo do `AGENTS.md` do projeto** (antes de "Identidade do projeto"):
  "regra do protocolo → `.usehbn-snapshot/` (read-only) · trabalho do projeto → raiz · melhorar o
  protocolo → `inbox/credenciamento/` (nunca edite o protocolo direto) · editar `.usehbn-snapshot/` = bloqueio."
- **Tombstone:** o espelho `usehbn/` vira `usehbn/TOMBSTONE.md` curto ("não leia/edite/use; veja
  `.usehbn-snapshot/`"); a árvore antiga sai.
- **Untangle (D2 aprovado):** artefatos de domínio que estavam em `usehbn/` (`radar/`, `study-plans/`,
  `audits/`, `docs/`, `site/`) migram para o espaço do projeto (`docs/reference/`, `auditoria/`).
- **Limpeza de refs (humano-gated):** 649 refs textuais a `usehbn/` (402 fora do espelho). Script gera
  patch candidato + relatório; humano aceita/ajusta caso a caso; arqueologia em `auditoria/` preservada.
- **D4 (renomear `.hbn/`→`.hbn-local/`): ADIADO para P3 próprio** (1597 refs, 553 arquivos) — mitigado por router+header.

## 7. Contribuição de volta (canal já seguro + melhorias)
Canal: `inbox/credenciamento/<AAAAMMDD-NN>-<slug>.md` no protocolo (o projeto deposita; o arquiteto
consolida; hearback de Mauricio). Projeto JAMAIS edita o genoma direto (`inbox/README.md:13,59`).
Melhorias: front-matter com `snapshot-version`/`snapshot-sha`; `feedback.schema.json`;
`inbox/credenciamento/INDEX.md`; mini cross-audit leve dos itens.

## 8. Critério de pronto (T1–T4; T3 = cross-audit técnico puro)
- **T1 consumo:** instalador gera `.usehbn-snapshot/`; `assert-snapshot-integrity` exit 0; sem refs vivas ao espelho fora do tombstone.
- **T2 drift mecânico:** mutar 1 byte → integrity exit≠0; `git add` da mutação → guard bloqueia; reverter → verde.
- **T3 cognição (cross-audit técnico puro):** 2 IAs ≠OpenAI, janela limpa, lendo só o `AGENTS.md` do projeto,
  acertam 3/3 (onde leio a regra / onde edito / o que é o tombstone). Pronto = ratificado; sem hearback de arbítrio.
- **T4 ponta-a-ponta:** `protocol_sha256` macOS == Linux; manifesto regenerável; `VERSION` coerente com `v1-estável`; relatórios arquivados.

## 9. Sequência de ondas (cada uma confirma no disco antes da próxima)
- **P2-A — tooling + dry-run (script, não toca o projeto):** `install-snapshot.sh --dry-run` gera manifesto+sha,
  lista os 137 arquivos, produz o relatório do subset de guards. Humano valida tag/commit/hash.
- **P2-B — instalar a membrana (script + hearback):** cria `.usehbn-snapshot/` (header/VERSION/manifesto/sha),
  `assert-snapshot-integrity` local, `.hbn/active-version`=`.`; integrity `--install` + runner informativo.
- **P2-C — runner project-mode + subset bloqueante (+ pré-higiene do INDEX).**
- **P2-D — router + tombstone + limpeza controlada (humano-gated) + selagem do passo 2.**

## 10. Rito de adoção desta proposta
1. Trackear esta proposta no protocolo (`.hbn/proposals/…ponte-v2-consolidada.md`) — onda própria.
2. Cross-audit de RATIFICAÇÃO por ≥2 famílias ≠OpenAI (antigravity/Google + grok/xAI) → APROVA.
3. Hearback de Mauricio.
4. Só então: prompt de implementação de P2-A (dry-run), e assim por diante.
Firewall 0022 permanece: escrita de domínio (safe_track) no Credenciamento é humano-aplicada.

— FIM DA PROPOSTA v2 —
