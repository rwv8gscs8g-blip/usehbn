---
titulo: Handoff — FIX staged-skew (E-FECH-01/02) em G-SLF e G-REG (status proposed; re-auditoria curta pendente)
id-global: 20260610-85
path: .hbn/messages/20260610-05-fix-staged-skew-fable5.md
de: claude-fable-5 (arquiteto-implementador, corrente E — fix pós-veto 0027)
para: "Maurício (gate) + auditores cruzados (Codex, Antigravity) para re-auditoria curta dos 2 guards"
data: 2026-06-10
temperatura: glacier
status: congelado
relacionado: [.hbn/results/0027-cross-ia-codex-corrente-e-fechamento.md, guards/assert-self-path.sh, guards/assert-registry-line.sh, guards/tests/run-guard-tests.sh, .hbn/relay/STATE.md]
---

# FIX staged-skew — E-FECH-01/02 (veto da re-auditoria 0027)

## Resumo para humano (≤10 linhas)

O Codex provou na 0027 que os próprios guards anti-teatro cometiam teatro:
G-SLF e G-REG validavam a WORKING TREE, mas o commit leva o STAGED — o
verde do guard não provava o que seria commitado. Fix cirúrgico: G-SLF
agora lê o blob staged (`git show :path`; `HEAD:path` em CI) e G-REG grepa
o REGISTRY staged (`git show :REGISTRY.md`). Suíte ampliada 29 → 33 com os
2 negativos de skew exigidos (staged ruim + worktree corrigida → BLOQUEIA)
e 2 espelhos-bons que provam a direção da leitura (staged bom + worktree
quebrada → passa). 33/33 verde em /tmp (informativa; conclusiva no
Terminal). E-FECH-03 (mesmo autor) NÃO entra: o ADR-023 acertou em deixar
como aviso + revisão humana + GPG futuro. Tudo proposed; nada no runner.

## O que mudou (diffs cirúrgicos)

1. `guards/assert-self-path.sh` (E-FECH-01): `blob_ref()` resolve `:path`
   (índice) localmente ou `HEAD:path` em CI; `fm_declared_path` e
   `json_declared_path` agora leem stdin alimentado por `git show`;
   existência checada com `git cat-file -e`, não `[[ -f ]]` na worktree.
2. `guards/assert-registry-line.sh` (E-FECH-02): `registry_content()` lê
   `git show :REGISTRY.md` (ou `HEAD:` em CI); `registry_has_exact` grepa
   esse conteúdo, nunca `${REPO_ROOT}/REGISTRY.md`.
3. `guards/tests/run-guard-tests.sh`: +4 casos de skew index×worktree
   (2 negativos E-FECH-01/02 + 2 espelhos-bons). Suíte 33/33 verde.

## Dogfood

Os guards corrigidos rodaram contra o diff STAGED deste próprio fix em
cópia /tmp do canônico (git add proibido no canônico em sandbox —
knowledge 0003; incidente do index.lock não se repete). Resultado no
STATE e no parágrafo de entrega.

## Próximos passos

1. Maurício: revisar diff, rodar `bash guards/tests/run-guard-tests.sh`
   conclusivo no Terminal, commit do checkpoint do fix.
2. Re-auditoria curta (Codex) só dos 2 guards + casos de skew.
3. Hearback do lote EF1-EF4 destravado se a re-auditoria limpar o veto.
