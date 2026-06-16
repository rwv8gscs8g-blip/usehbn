---
titulo: "Cursor — cross-audit P-CAND-04 área temporária"
tipo: result
status: active
temperatura: frio
id-global: 20260616-155716-cursor-cross-ia-p-cand-04
path: .hbn/results/20260616-155716-cursor-cross-ia-p-cand-04.md
autor: cursor
created_at: "2026-06-16T15:57:16-03:00"
---

APROVA_0033: SIM

# Cross-audit P-CAND-04 — área temporária `/scratch/` + guards G-SCRATCH-*

**Auditor:** cursor (janela cursor | grok)  
**Orquestrador:** claude-opus-4-8  
**Data:** 2026-06-16T15:57:16-03:00  
**Repo:** usehbn @ branch `proposta/reestruturacao-m-a-s0`  
**HEAD:** `2d4ad862867b114628abb4d320988a75da2751ea`  
**Modo:** somente leitura; sem commit; main não tocada

---

## Pré-condições alegadas (verificação independente)

| Alegação | Veredito | Evidência |
|----------|----------|-----------|
| 5 commits P-CAND-04 (c4af7bf…2d4ad86) | **SIM** | `git rev-list --count ae5f4c4..2d4ad86` → `5`; parent de c4af7bf = ae5f4c4 (não 4857081 direto) |
| Base 4857081 | **SIM (merge-base)** | `git merge-base 4857081 2d4ad86` → `4857081d6856a4cc17700ff4e1482b3df205e159` (= `4857081 s3-2: atualiza state e handoff`) |
| Readback 0033 | **SIM** | `.hbn/readbacks/0033-area-temporaria-scratch.json:2` `readback_id` |
| `/scratch/` gitignored + exceção README | **SIM** | `.gitignore:42-43` `/scratch/` e `!/scratch/README.md`; `git check-ignore -v scratch/segredo.txt` → linha 42; `git check-ignore scratch/README.md` → exit 1 (não ignorado) |
| 3 guards bloqueantes no runner | **SIM** | `guards/hbn-guards-runner.sh:54-56` |
| B26–B28 | **SIM** | `bash guards/tests/adversarial-battery.sh` → B26/B27/B28 BLOQUEADA ✓ |
| Suite 165/165 | **SIM** | `bash guards/tests/run-guard-tests.sh` → `165 passaram, 0 falharam` |
| Runner verde (índice limpo) | **SIM** | `bash guards/hbn-guards-runner.sh` → `[hbn-guards] Todos os guards passaram.` |
| main = 4db6928 | **SIM** | `git rev-parse main` → `4db692876381a0d7909985c8500d999f2e677b04` |

---

## Pontos de ataque

### A1. G-SCRATCH-LOCK

**scratch/segredo.txt staged → BLOQUEIA.** Stage via cacheinfo (sem arquivo solto, knowledge 0023):

```
git update-index --add --cacheinfo 100644,<blob>,scratch/segredo.txt
bash guards/assert-scratch-lock.sh
→ exit=1; motivo: Path staged proibido sob scratch/: scratch/segredo.txt
```

**scratch/README.md staged → PASSA.** `git add -f scratch/README.md` (negation exige `-f`):

```
bash guards/assert-scratch-lock.sh → exit=0; ✓ Nenhum path proibido staged sob scratch/.
```

Implementação: `guards/assert-scratch-lock.sh:26-31` — case exato `scratch/README.md` vs `scratch/*`.

### A2. G-SCRATCH-SYMLINK

**Symlink mode 120000 staged → BLOQUEIA.**

```
ln -sf ../core scratch/audit-link && git add -f scratch/audit-link
git ls-files --stage scratch/audit-link → 120000 ...
bash guards/assert-scratch-symlink.sh → exit=1; Symlink staged proibido sob scratch/: scratch/audit-link.
```

Implementação: `guards/assert-scratch-symlink.sh:22-31,38-41`.

### A3. G-SCRATCH-IGNORE

**.gitignore staged sem `/scratch/` → BLOQUEIA** (exit=1; perdeu linha `/scratch/`).

**.gitignore staged com `/scratch/` mas sem `!/scratch/README.md` → BLOQUEIA** (exit=1; perdeu exceção).

**.gitignore não staged → PASSA** (`guards/assert-scratch-ignore.sh:31-33` early exit).

Comportamento sem exceção: impede commit que removeria a negation; README deixaria de ser versionável — correto fail-closed.

### A4. Exceção README — abuso?

| Vetor | Resultado |
|-------|-----------|
| `scratch/readme.md` (case) | BLOQUEIA |
| `scratch/README.MD` | BLOQUEIA |
| `scratch/README.md.evil` | BLOQUEIA |
| `scratch/sub/README.md` | BLOQUEIA |
| Conteúdo arbitrário em README | **Permitido por desenho** — único path versionável; risco = texto no histórico, não vazamento de paths/segredos via stage. README atual proíbe symlinks/segredos (`scratch/README.md:5-8`). |

Nenhum path alternativo casa o padrão `scratch/README.md` exato do lock guard.

### A5. Fail-closed

| Cenário | Resultado |
|---------|-----------|
| `.gitignore` staged blob vazio | BLOQUEIA (faltam `/scratch/` e `!/scratch/README.md`) — `assert-scratch-ignore.sh:44-56` |
| Índice vazio / sem scratch staged | lock e symlink PASSAM (exit=0) |
| active-version inválida + .gitignore staged | BLOQUEIA em `assert-scratch-ignore.sh:16-18` |

### A6. Escopo vs readback 0033 `files_allowed`

**Interpretação correta (onda P-CAND-04):** `git diff --name-only ae5f4c4..2d4ad86` → 13 paths, todos ⊆ `files_allowed` do readback (incl. handoff `20260616-170500-codex-handoff-p-cand-04.md`).

**Marginal:** `git diff --name-only 4857081..2d4ad86` → **20 paths** — inclui artefatos selagem-s3-2 (`0032`, pareceres, brainstorm) **fora** do escopo 0033. A alegação “5 commits sobre 4857081” usa merge-base, não parent direto; os 5 commits P-CAND estão sobre `ae5f4c4`, não sobre `4857081`.

### A7. Sem regressão

- Suite: **165/165** (`run-guard-tests.sh` resumo final).
- Bateria: **B1–B28 verde** (`adversarial-battery.sh`).
- Runner: **verde** com índice limpo pós-auditoria.

Nota: sandbox Cursor falha em `mk_repo`/xargs (`sysconf(_SC_ARG_MAX)`); com permissões completas os testes passam — ambiente do auditor, não defeito do repo.

### A8. Trailers contíguos

Nos 5 commits c4af7bf, 5da7e52, 428b30f, fa86b6a, 2d4ad86:

```
HBN-Readback: 0033
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```

Três linhas adjacentes, sem linha em branco entre elas (`git log -1 --format="%B" c4af7bf`).

### A9. LEVEZA (P-CAND-01)

Três scripts (~40–65 LOC cada) com `scratch_diff_files()` triplicada (`assert-scratch-lock.sh:15-21`, symlink e ignore análogos). **Responsabilidades distintas** (lock / 120000 / proteção ignore) — alinhado ao design convergido (`docs/brainstorm/principios-candidatos.md:101-104`).

**Via mais simples possível?** Um guard combinado lock+symlink+ignore seria menor em LOC, porém menos legível e mais difícil de mapear burla→guard (B26/B27/B28). **Redundância baixa** entre guards; **duplicação de helper** é marginal técnica.

Fragilidade futura: `case scratch/*` opera em paths pós-`guard_paths_to_version_paths`; com `active-version` ≠ `.` paths poderiam não casar — hoje `.hbn/active-version` = `.` (sem efeito).

---

## EXTRA — symlink runtime (não staged)

```
ln -sf ../core scratch/runtime-link   # worktree only
bash guards/assert-scratch-lock.sh    → exit=0
bash guards/assert-scratch-symlink.sh → exit=0
bash guards/hbn-guards-runner.sh      → Todos os guards passaram
```

**Nenhum guard pega symlink runtime.** Risco real para leitura/escrita local via `../core`, `.env`, etc., mas **fora do vetor VC/origin** que a onda fecha. Readback 0033 declara explícito out_of_scope: “Bloqueio total deny-by-default da zona livre (proxima onda)” (`.hbn/readbacks/0033-area-temporaria-scratch.json:62`).

**Recomendação:** aceitar nesta onda; próxima onda considerar (1) documentar `$TMPDIR` externo como preferência (knowledge 0023), (2) guard runtime opcional ou hook pre-commit que varre worktree `scratch/` por symlinks 120000, (3) nunca colocar segredos em `scratch/` mesmo localmente.

---

## Marginais (não bloqueadores)

1. **A6 wording:** diff `4857081..2d4ad86` mistura selagem-s3-2; escopo 0033 limpo só em `ae5f4c4..2d4ad86`.
2. **A9 DRY:** triplicação de `scratch_diff_files()` — candidato a helper compartilhado em onda de hardening.
3. **active-version prefix:** guards assumem paths `scratch/*` após remap; untested se versão ≠ raiz.
4. **README conteúdo livre:** by design; mitigado por política textual no README.
5. **Runtime symlink:** gap consciente, próxima onda.

---

## Confiança

**94/100** — evidência live (stage+reset), suites executadas no disco, commits e trailers verificados. −6 por marginais A6/A9/active-version e vetor runtime não coberto (aceito por escopo).

---

**Assinatura:** cursor (auditor cross-IA, janela cursor | grok)  
**Data:** 2026-06-16
