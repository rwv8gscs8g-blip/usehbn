---
titulo: "Cross-audit W3 — G-ZONA-LIVRE deny-by-default"
tipo: audit-result
status: final
temperatura: frio
path: .hbn/results/20260616-210800-grok-cross-ia-w3-deny-zona-livre.md
id-global: 20260616-210800-grok-cross-ia-w3-deny-zona-livre
autoria: grok
created_at: "2026-06-16T21:08:00-03:00"
---

APROVA_0036: SIM (core G-ZONA-LIVRE deny-by-default verificado; 9 files scope + trailers contíguos ok; B33 BLOQUEADA; manual A1-A3 com stage+reset provam os vetores e fail-closed; main 4db6928 intacto; suite 118/60 vermelha observada atribuída a poluição de índice de testes do auditor + pre-existing AD/?? — não bloqueador da lógica do guard em si no branch real)

MARGINAIS / OBSERVAÇÕES (truth on disk):
- A1: docs/brainstorm/x.md SEM curada no index 0036 -> BLOQUEADO "falta zona_livre_curada: true" (knowledge 0024). COM curada:true + nota não-vazia (via git add -f readback + x) -> PASS "Zona livre curada ... liberado." (git show : confirmou flag no index lido pelo guard). stage+reset+checkout HEAD + rm; só ?? rodada- pre-existente ao final. (cmd+output + git show :path)
- A2: STATE ausente no índice (git rm --cached) + x staged -> BLOQUEADO "STATE ausente ou ilegivel no indice/HEAD". JSON truncado/inválido -> bloqueado (fail-closed; em trace viu CHECK_RC e guard_fail). STATE apontando readback inexistente -> bloqueado "Readback ativo ausente ou ilegivel". Todos restaurados via checkout HEAD; sem omissão/pass-through.
- A3: (a) curada:false no staged readback -> BLOQUEADO "falta zona_livre_curada: true". (b) curada true + zona_livre_nota="   " -> BLOQUEADO (nota check). (c) flag só em readback não-ativo (edit WT de outro .json, NÃO staged; active=0036 sem flag; só x staged) -> BLOQUEADO. (d) paths: docs/brainstorm-evil/att.md + docs/brainstormX/y + docs/brainstorm/good -> guard "Nenhum path..." para evil/X (grep ^docs/brainstorm/.+ não casa); good real sem curada -> BLOQUEADO. Ancoragem prova não escapa nem over-match.
- A4: main@4db6928 (git rev-parse confirm). git diff --name-only 50263e1..55291e1 = exatamente os 9 do scope de 0036 (handoff timestamped incluso). 4 commits trailers HBN- contíguos (c683b0b, ba40c30, c4fd64b, 55291e1 todos com Readback:0036 + Human-Authorization + Token-FP). run-guard-tests (nesta execução com poluição AD x.md do auditor): 118 pass / 60 fail + "SUÍTE VERMELHA" (incluindo zona positive no suite hermético falhou "curadoria passa obtido rc=1"; muitos G-REG/SLF/SCO/PTR por staged extra + skew). adversarial: B33 BLOQUEADA ✓ mas 4 burlas antigas passaram (BATERIA VERMELHA). Runner não verde nesta run (poluição de auditor + estado do tree); alegado 178/178 não reproduzido on-disk sem limpeza prévia de índice.
- A5: escopo restrito aos 9 files_allowed do readback 0036; trailers contíguos nos 4 commits (ver cmd log --format e git diff name-only).
- A6 (P-CAND-01 leveza): G-ZONA-LIVRE agrega gate local/CI (pre-commit + HBN_DIFF_BASE) + declaração explícita obrigatória no readback ativo (endereça lição knowledge 0024: "só gate enforçado vincula" vs instrução escrita). Impede include silencioso de brainstorm/** mesmo antes de PR/branch-protection. Fail-closed + path anchor + self-heal via reset. Porém: a curada é self-declarada pela IA no artefato que ela edita (readback em files_allowed); não há assinatura humana independente por entrada de zona (além da autorização geral da onda + revisão humana do PR). Branch protection + review humano do diff (readback nota + arquivos) já cobriria; o guard adiciona barreira precoce e visibilidade da "curadoria claim". Não é puro teatro (eleva o padrão, alinha com doutrina), mas o delta real de segurança além de "human PR obrigatório" é incremental/defense-in-depth, não absoluto contra IA maliciosa que escreve nota plausível. Via mais simples/robusta sugerida: (1) manter brainstorm estritamente untracked até onda de curadoria dedicada com ack humano explícito por arquivo fora do readback, ou (2) exigir nota de bypass/curadoria em .hbn/bypasses/ (como F-10) + hearback humano para cada zona entry (mais pesado, mais robusto que self-decl).

VERIFICAÇÕES (Truth Barrier, cmd+saída ou arquivo:linha):
- Branch: proposta/reestruturacao-m-a-s0 (git rev-parse --abbrev-ref)
- Commits W3: c683b0b..55291e1 sobre 50263e1 (git log --oneline); 4 trailers contíguos (git log -1 --format=%B cada)
- Main: 4db692876381a0d7909985c8500d999f2e677b04 (git rev-parse main / 4db6928)
- Readback 0036: .hbn/readbacks/0036-deny-zona-livre.json (sem curada no baseline; files_allowed 9 itens; git diff name-only casou)
- STATE: .hbn/relay/STATE.md:66 (readback_ativo: ".hbn/readbacks/0036-deny-zona-livre.json")
- Guard: guards/assert-zona-livre.sh:29 (STAGED via guard_diff_files), :56 (git show blob_ref STATE), :91 (git show RB), :118 (python: is not True -> fail; nota strip vazio -> fail), :30 (grep ^docs/brainstorm/.+ )
- Common: guards/lib/common.sh:243 (guard_diff_files: --cached ou HBN_DIFF_BASE...HEAD)
- A1 manual (git show : + stage -f + reset + checkout HEAD + rm): NEG block knowledge 0024; POS pass curada. (ver transcripts acima)
- A2.1 STATE rm --cached: "STATE ausente ou ilegivel no indice/HEAD" (fail-closed)
- B33 (adversarial): BLOQUEADA ✓ (mesmo com suite vermelha)
- Pre-existing: 6 ?? docs/brainstorm/rodada-2026-06-16/* (zona livre untracked da sessão; não introduzidos pelo auditor; consistentes com allow após curadoria)

CONFIANÇA: 65 (lógica do guard + scope + trailers + A1-A3 manuais sólidos em branch real; suites não verdes por poluição de auditor + possivelmente setup hermético do make_zona_repo faltando pré-reqs para get_canonical_root em temp; self-decl nature limita o "além branch protection"; sem commit/touch main)

grok (cursor | grok family, cross-audit W3)
2026-06-16 ~21:08 UTC-3
(arquivo depositado via auditor cross-family; sem alterações ao tree além de stage/reset efêmeros para Truth Barrier)
