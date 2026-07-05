---
titulo: "Despacho de cross-audit — S2 (despacho auto-declarante)"
tipo: despacho
status: congelado
temperatura: glacier
path: .hbn/messages/20260616-005144-opus-4-8-despacho-cross-audit-s2.md
id-global: 20260616-005144-opus-4-8-despacho-cross-audit-s2
autor: claude-opus-4-8 (orquestrador/arquiteto)
auditores_designados: [gemini-3-5, cursor]
created_at: "2026-06-16T00:51:44-03:00"
---

RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-16T00:51:44-03:00
STATE: ultima_atualizacao=2026-06-16T00:43:42-03:00 · bastão → claude-opus-4-8 · contexto S2 implementada
SINAIS: S2 implementada; despacho de cross-audit preparado para Gemini+Cursor
FEITO: depositar roteiro de auditoria independente S2
PENDENTE: receber pareceres Gemini+Cursor e abrir selagem propria se ambos aprovarem
PONTEIROS: .hbn/readbacks/0025-s2-dispatch-auto-declarante.json; .hbn/relay/STATE.md
PRÓXIMA AÇÃO: Submeter S2 (dispatch auto-declarante) ao cross-audit Gemini+Cursor antes de qualquer selagem.
PARA O HUMANO: main intocada; despacho historico selado sem alterar logica de guard

## Decisões informais (cápsula)

Nenhuma alem das decisoes humanas explicitadas no proprio despacho.

# Cross-audit S2 — instruções para o orquestrador

Dois blocos abaixo, um por IA. Cole cada bloco numa **janela nova** da IA
correspondente. Auditores são de **família distinta** do implementador (codex):
Gemini (Google) e Cursor. Cada um audita de forma **independente** (sem ver o
parecer do outro) e deposita seu resultado em `.hbn/results/`.

Estado verificado no disco (orquestrador, 2026-06-16):
HEAD `121fae1` · 6 commits S2 sobre `5d7c72f` · `main` intocada (`4db6928`) ·
run-guard-tests 151/151 · adversarial B1–B22 bloqueadas · runner rc=0 ·
readback ativo `0025` · dogfood `.hbn/dispatch/0025-*.md` coerente.

================================================================================
BLOCO 1 — COLAR EM JANELA NOVA DO GEMINI 3.5
================================================================================

PARA: gemini-3-5 (auditor cruzado, família Google — distinta do implementador codex)
DE: claude-opus-4-8 (orquestrador)
TAREFA: cross-audit independente da onda S2 (despacho auto-declarante) no repositório usehbn, branch proposta/reestruturacao-m-a-s0.

SEÇÃO 0 — REGRAS DO AUDITOR
- Você NÃO implementa nem corrige; você audita e emite veredito.
- Todo julgamento cita arquivo:linha OU comando+saída (Truth Barrier). Sem opinião sem evidência.
- Não confie no relato do implementador nem no do orquestrador: confira tudo no disco.
- Trabalhe só em leitura. Não faça commit, não toque em main, não altere índice.

SEÇÃO 1 — O QUE S2 ENTREGOU (alegado, a verificar)
- schemas/dispatch.schema.json + core/dispatch-spec.md (artefato de despacho versionado, auto-declarante).
- guards/validate-dispatch.sh (G-DSP-FMT: forma + invariante zsh-safe sem linhas iniciadas por '#' no corpo colável).
- guards/assert-dispatch-integrity.sh (G-DSP-INT: readback_id declarado = readback ativo do STATE; token_fp = prefixo de 8 hex de bastao_token_sha256 do STATE; human_authorization não-vazio).
- Ambos inseridos como BLOQUEANTES no array de guards/hbn-guards-runner.sh após assert-scope-lock.sh.
- Testes em guards/tests/run-guard-tests.sh + burlas B20-B22 em guards/tests/adversarial-battery.sh.
- Dogfood: .hbn/dispatch/0025-s2-dispatch-auto-declarante.md é o primeiro despacho validado.
- 6 commits separados (0781df9, ef5b67d, 9b1bb0e, 07a70da, 6844f6a, 121fae1), cada um com trailers HBN-Readback: 0025, HBN-Human-Authorization e HBN-Token-FP: 34a7f2f9.

SEÇÃO 2 — PONTOS DE ATAQUE (tente quebrar; cada um deve resistir)
A. Coerência G-DSP-INT: monte (em worktree descartável / fixture) um despacho que declare readback_id ≠ readback ativo, ou token_fp ≠ STATE, ou human_authorization vazio. O guard deve BLOQUEAR os três. B20/B21 cobrem variantes; tente uma nova (ex.: readback que existe como arquivo mas não é o ativo).
B. Forma G-DSP-FMT: despacho com linha iniciada por '#' no corpo colável; campo obrigatório ausente; token_fp fora de /^[0-9a-f]{8}$/. Deve BLOQUEAR.
C. Fail-closed: torne schemas/dispatch.schema.json ausente/ilegível e verifique se validate-dispatch falha fechado (não passa por omissão).
D. Regressão symlink/meta-path (B17-B19): um symlink modo 120000 ou meta-path arbitrário sob .hbn/dispatch/** ainda é bloqueado pela cadeia de guards?
E. Wiring do runner: confirme que AMBOS os guards são realmente invocados (não só presentes no arquivo). Um despacho consegue ser commitado sem passar por eles?
F. Dogfood real: .hbn/dispatch/0025-*.md passa de fato os dois guards quando re-staged, ou foi "grandfathered"?
G. Schema×guard: o schema constrange exatamente o que os guards afirmam validar? Há campo no schema que o guard ignora, ou vice-versa?
H. Marginal de trailers: os três trailers nos commits estão separados por linha em branco; os guards usam grep '^HBN-...:' (passa), mas git interpret-trailers/%(trailers:key=) só vê HBN-Token-FP. Avalie se isto deve virar exigência de bloco contíguo (dívida latente para CI por range) ou fica como won't-fix.
I. Invariantes: main intocada (4db6928)? Algum arquivo fora de files_allowed do readback 0025? Os seis untracked antigos seguem intocados?

SEÇÃO 3 — COMANDOS SUGERIDOS
- git -C <repo> log --oneline 5d7c72f..HEAD; git -C <repo> rev-parse main
- git -C <repo> diff --name-only 5d7c72f..HEAD
- bash guards/tests/run-guard-tests.sh; bash guards/tests/adversarial-battery.sh; bash guards/hbn-guards-runner.sh
- ler: schemas/dispatch.schema.json, core/dispatch-spec.md, guards/validate-dispatch.sh, guards/assert-dispatch-integrity.sh, guards/hbn-guards-runner.sh, .hbn/dispatch/0025-s2-dispatch-auto-declarante.md, .hbn/relay/STATE.md

SEÇÃO 4 — VEREDITO (deposite como arquivo)
- Crie .hbn/results/20260616-HHMMSS-gemini-3-5-cross-ia-s2-dispatch.md
- Primeira linha do corpo: APROVA_S2: SIM  (ou NÃO + bloqueadores enumerados com arquivo:linha)
- Liste marginais não-bloqueadoras (ex.: decisão sobre H).
- Confiança 0-100. Assine com seu apelido e timestamp.

================================================================================
BLOCO 2 — COLAR EM JANELA NOVA DO CURSOR
================================================================================

PARA: cursor (auditor cruzado, família distinta do implementador codex e do auditor gemini)
DE: claude-opus-4-8 (orquestrador)
TAREFA: cross-audit independente da onda S2 (despacho auto-declarante) no repositório usehbn, branch proposta/reestruturacao-m-a-s0. NÃO consulte o parecer do Gemini; audite por conta própria.

SEÇÃO 0 — REGRAS DO AUDITOR
- Você NÃO implementa nem corrige; audita e emite veredito.
- Todo julgamento cita arquivo:linha OU comando+saída (Truth Barrier).
- Não confie nos relatos; confira tudo no disco. Trabalhe só em leitura; sem commit, sem tocar main.

SEÇÃO 1 — O QUE S2 ENTREGOU (alegado, a verificar)
[idêntico ao Bloco 1, Seção 1 — schema/spec, G-DSP-FMT, G-DSP-INT, wiring bloqueante, testes B20-B22, dogfood, 6 commits com 3 trailers]

SEÇÃO 2 — PONTOS DE ATAQUE (tente quebrar; cada um deve resistir)
A. Coerência G-DSP-INT (readback não-ativo, token_fp divergente, auth vazia).
B. Forma G-DSP-FMT ('#' no corpo colável, campo ausente, token_fp mal-formado).
C. Fail-closed com schema ausente/ilegível.
D. Regressão symlink/meta-path (B17-B19) sob .hbn/dispatch/**.
E. Wiring: ambos os guards realmente invocados; despacho não comitável por fora.
F. Dogfood re-staged passa os dois guards de verdade.
G. Aderência schema×guard (campos exigidos vs validados).
H. Marginal de trailers (bloco não-contíguo; grep passa, parser nativo não). Recomende won't-fix ou exigência futura.
I. Invariantes: main 4db6928 intocada; nada fora de files_allowed; seis untracked antigos intactos.
EXTRA (Cursor): você documentou marginais finos em B17/B18 antes (model_id de perfil, meta-path). Procure o próximo vetor análogo em S2 que o Bloco do Gemini possa não pegar — ex.: caminho de despacho fora de .hbn/dispatch/** que o guard não cubra, ou dispatch_id ≠ readback_id sem checagem.

SEÇÃO 3 — COMANDOS SUGERIDOS
[mesmos do Bloco 1, Seção 3]

SEÇÃO 4 — VEREDITO (deposite como arquivo)
- Crie .hbn/results/20260616-HHMMSS-cursor-cross-ia-s2-dispatch.md
- Primeira linha: APROVA_S2: SIM  (ou NÃO + bloqueadores com arquivo:linha)
- Liste marginais; confiança 0-100; assine e date.

================================================================================
FIM DOS BLOCOS
================================================================================

Após os dois pareceres: o orquestrador confere ambos no disco, consolida e — se
ambos APROVA_S2: SIM — abre a micro-onda de selagem (readback 0026). Qualquer NÃO
reabre implementação por codex antes de nova auditoria.
