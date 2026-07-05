---
titulo: "Despacho de cross-audit — faxina 0027"
tipo: despacho
status: congelado
temperatura: glacier
path: .hbn/messages/20260616-021934-opus-4-8-despacho-cross-audit-faxina-0027.md
id-global: 20260616-021934-opus-4-8-despacho-cross-audit-faxina-0027
autor: claude-opus-4-8 (orquestrador/arquiteto)
auditores_designados: [gemini-3-5, cursor]
created_at: "2026-06-16T02:19:34-03:00"
---

RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-16T02:19:34-03:00
STATE: ultima_atualizacao=2026-06-16T02:01:35-03:00 · bastão → claude-opus-4-8 · contexto faxina 0027 implementada
SINAIS: faxina 0027 entregue por codex; G-EXC corrigido em CI (%B); B23 adicionada; criterios promovidos ao core; seis antigos selados; cross-audit preparado
FEITO: orquestrador verificou no disco — 7 commits, 154/154, B1-B23, runner verde, CI G-EXC verde sobre o range, analogia corrigida no core, main intocada
PENDENTE: receber pareceres Gemini+Cursor da faxina e abrir selagem 0028 se ambos aprovarem
PONTEIROS: .hbn/readbacks/0027-faxina-pendencias.json; core/exuvia-fitness-criteria.md; guards/assert-exception-traceable.sh
PRÓXIMA AÇÃO: Enviar a faxina 0027 para cross-audit Gemini+Cursor; se aprovada, selar em micro-onda 0028.
PARA O HUMANO: main intocada; princípio de leveza/lixo-zero embutido como eixo de auditoria

## Decisões informais (cápsula)

Princípio do Maurício adotado como eixo de auditoria: evoluir leve por princípio;
o simples que funciona é mais apto; não otimizar o que não deveria existir nem
conviver com código gigante que caberia em uma linha; débito técnico é aceitável
mas a melhora é contínua; nada pode confundir ou dar peso errado às IAs futuras.

# Cross-audit faxina 0027 — instruções para o orquestrador

Dois blocos abaixo, um por IA. Cole cada bloco numa **janela nova** da IA
correspondente. Auditores de **família distinta** do implementador (codex):
Gemini (Google) e Cursor. Cada um audita **independente** e deposita seu
resultado em `.hbn/results/`.

Estado já verificado no disco pelo orquestrador (a IA deve re-conferir, não confiar):
HEAD `788e459` · 7 commits da faxina sobre `46c2919` · `main` intocada (`4db6928`) ·
run-guard-tests 154/154 · adversarial B1–B23 bloqueadas · runner rc=0 ·
`HBN_DIFF_BASE=46c2919… assert-exception-traceable.sh` verde ("trailers verificados") ·
readback ativo `0027` · core/exuvia-fitness-criteria.md com analogia de exoesqueleto.

================================================================================
BLOCO 1 — COLAR EM JANELA NOVA DO GEMINI 3.5
================================================================================

PARA: gemini-3-5 (auditor cruzado, família Google — distinta do implementador codex)
DE: claude-opus-4-8 (orquestrador)
TAREFA: cross-audit independente da faxina 0027 no repositório usehbn, branch proposta/reestruturacao-m-a-s0.

SEÇÃO 0 — REGRAS DO AUDITOR
- Você NÃO implementa nem corrige; audita e emite veredito.
- Todo julgamento cita arquivo:linha OU comando+saída (Truth Barrier). Sem opinião sem evidência.
- Não confie no relato do implementador nem do orquestrador: confira tudo no disco.
- Só leitura. Sem commit, sem tocar main, sem alterar índice.

SEÇÃO 1 — O QUE A FAXINA 0027 ENTREGOU (alegado, a verificar)
- Fix do guard: em CI (HBN_DIFF_BASE não-vazio), guards/assert-exception-traceable.sh passou a ler o texto bruto do commit ('%B') em vez de '%(trailers)', para achar trailers separados por linha em branco (dívida H). Ver ~linha 154.
- Burla B23 em guards/tests/adversarial-battery.sh (G-EXC em CI não pode aceitar commit que termina só com HBN-Token-FP, sem HBN-Human-Authorization).
- core/exuvia-fitness-criteria.md promovido (a partir do doc do orquestrador), com a analogia corrigida de exoesqueleto (artrópodes/lagostas).
- Seis artefatos históricos antigos selados (2 handoffs fable5 + 4 results exúvia/onda-0011).
- .gitignore para os scratch das suítes; STATE aponta a próxima ação ao cross-audit.
- 7 commits (4b7be1f, bccacf2, cdf7f46, 9e26046, 53f9744, 928a53d, 788e459), trailers contíguos.

SEÇÃO 2 — PONTOS DE ATAQUE (cada um deve resistir)
A. Fix G-EXC — não-regressão de segurança: em modo CI, um commit que tem trailers porém separados por linha em branco é ACEITO (sem falso-positivo)? E um commit que REALMENTE omite HBN-Readback ou HBN-Human-Authorization ainda é BLOQUEADO? Rode com HBN_DIFF_BASE setado e prove os dois lados.
B. Fix G-EXC — novo falso-negativo: o '%B' faz grep '^HBN-...:' sobre a mensagem inteira. Uma linha de PROSA no corpo do commit começando com "HBN-Readback:" passaria a ser aceita como trailer falso? Avalie o risco e se o guard deveria ancorar só no último parágrafo.
C. Gap do .gitignore: o padrão cobre 'guards/tests/adv-cr-*' (hífen), mas a suíte também cria 'adv-cr.<rand>' (ponto), que ESCAPA (git check-ignore guards/tests/adv-cr.XXXX não ignora). Confirme e diga se algum outro variante de scratch (cr-*, tmp-pass.*, wt-main.*) também escapa. Recomende o padrão mínimo que cobre tudo.
D. Seis antigos selados: exatamente os seis previstos foram selados (nem mais, nem menos)? Conteúdo íntegro? Linhas no REGISTRY?
E. Analogia no core: core/exuvia-fitness-criteria.md tem a analogia de exoesqueleto e ZERO resquício de "cobra"/"pele" (grep)? Bate com o doc-fonte selado?
F. Sem regressão: run-guard-tests 154/154; adversarial B1-B23; runner verde; main 4db6928 intocada.
G. Escopo: o diff 46c2919..HEAD tocou SOMENTE os files_allowed do readback 0027? Sem vazamento?
H. Trailers contíguos: os 7 commits parseiam HBN-Readback e HBN-Human-Authorization via %(trailers:key=)?
I. EIXO LEVEZA/LIXO-ZERO (princípio do Maurício): procure o oposto do simples-que-funciona. O fix é a coisa mais simples que resolve, ou há complexidade desnecessária? Algum artefato foi selado que seria lixo (deveria ser descartado, não preservado)? Algo adicionado pode confundir ou dar peso errado a uma IA futura? Algum trecho gigante caberia em uma linha/processo simples? Aponte com arquivo:linha o que poderia ser mais leve.

SEÇÃO 3 — COMANDOS SUGERIDOS
- git -C <repo> log --oneline 46c2919..HEAD; git -C <repo> rev-parse main
- git -C <repo> diff --name-only 46c2919..HEAD
- bash guards/tests/run-guard-tests.sh; bash guards/tests/adversarial-battery.sh; bash guards/hbn-guards-runner.sh
- HBN_DIFF_BASE=46c29198923fcd012d54d958862d38ddd4f9a744 bash guards/assert-exception-traceable.sh
- git check-ignore guards/tests/adv-cr.zzz guards/tests/adv-cr-x.zzz guards/tests/cr-x.zzz guards/tests/tmp-pass.zzz guards/tests/wt-main.zzz
- grep -niE "cobra|pele|exoesqueleto|artrópodes" core/exuvia-fitness-criteria.md
- ler: guards/assert-exception-traceable.sh, guards/tests/adversarial-battery.sh, .gitignore, .hbn/readbacks/0027-faxina-pendencias.json

SEÇÃO 4 — VEREDITO (deposite como arquivo)
- Crie .hbn/results/20260616-HHMMSS-gemini-3-5-cross-ia-faxina-0027.md
- Primeira linha do corpo: APROVA_0027: SIM  (ou NÃO + bloqueadores com arquivo:linha)
- Liste marginais (incl. o gap do .gitignore e qualquer ponto de leveza).
- Confiança 0-100. Assine com apelido e timestamp.

================================================================================
BLOCO 2 — COLAR EM JANELA NOVA DO CURSOR
================================================================================

PARA: cursor (auditor cruzado, família distinta do codex e do gemini)
DE: claude-opus-4-8 (orquestrador)
TAREFA: cross-audit independente da faxina 0027. NÃO consulte o parecer do Gemini; audite por conta própria.

SEÇÃO 0 — REGRAS DO AUDITOR
- Você NÃO implementa nem corrige; audita e emite veredito.
- Todo julgamento cita arquivo:linha OU comando+saída (Truth Barrier).
- Não confie nos relatos; confira no disco. Só leitura; sem commit, sem tocar main.

SEÇÃO 1 — O QUE A FAXINA 0027 ENTREGOU (alegado, a verificar)
[idêntico ao Bloco 1, Seção 1 — fix G-EXC %B em CI, B23, core promovido c/ analogia exoesqueleto, seis antigos selados, .gitignore, 7 commits contíguos]

SEÇÃO 2 — PONTOS DE ATAQUE (cada um deve resistir)
A. Fix G-EXC: aceita trailer não-contíguo em CI E bloqueia omissão real (prove os dois lados com HBN_DIFF_BASE).
B. Fix G-EXC: risco de falso-positivo reverso — prosa começando com "HBN-...:" no corpo vira trailer falso? Deveria ancorar no último parágrafo?
C. .gitignore: confirme que 'adv-cr.<rand>' escapa de 'adv-cr-*'; verifique todos os variantes de scratch; recomende o padrão mínimo.
D. Seis antigos: exatamente os seis, íntegros, no REGISTRY.
E. Analogia no core sem resquício de cobra/pele; bate com a fonte.
F. Sem regressão (154/154; B1-B23; runner; main intocada).
G. Escopo do diff 46c2919..HEAD só nos files_allowed do 0027.
H. Trailers contíguos nos 7 commits.
I. EIXO LEVEZA/LIXO-ZERO: o simples que funciona é mais apto. Há código inchado que caberia em uma linha? Artefato selado que era lixo? Algo que confunde ou dá peso errado a IAs futuras? Aponte com arquivo:linha.
EXTRA (Cursor): você costuma achar o vetor fino que o outro não pega. Procure especificamente: (1) algum dos seis antigos selados contradiz/duplica informação já no STATE ou em specs, virando ruído de peso errado; (2) o doc-fonte em .hbn/messages/ e o promovido em core/ ficaram DUPLICADOS sem marcação de superseded (dois donos da mesma verdade).

SEÇÃO 3 — COMANDOS SUGERIDOS
[mesmos do Bloco 1, Seção 3]

SEÇÃO 4 — VEREDITO (deposite como arquivo)
- Crie .hbn/results/20260616-HHMMSS-cursor-cross-ia-faxina-0027.md
- Primeira linha: APROVA_0027: SIM  (ou NÃO + bloqueadores com arquivo:linha)
- Liste marginais; confiança 0-100; assine e date.

================================================================================
FIM DOS BLOCOS
================================================================================

Após os dois pareceres: o orquestrador confere no disco, consolida e — se ambos
APROVA_0027: SIM — abre a selagem 0028, que também: (a) sela este despacho e os
dois despachos órfãos (faxina + selagem S2); (b) aplica o conserto mínimo do
.gitignore (cobrir 'adv-cr.*'); (c) trata qualquer ponto de leveza levantado.
Lixo-zero é critério de pronto da 0028.
