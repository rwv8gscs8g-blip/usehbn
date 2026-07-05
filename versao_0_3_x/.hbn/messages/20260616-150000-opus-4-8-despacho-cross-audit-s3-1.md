---
titulo: "Despacho de cross-audit — S3.1 (INDEX vivo + G-KNOW-INDEX) + design área temporária"
tipo: despacho
status: congelado
temperatura: glacier
path: .hbn/messages/20260616-150000-opus-4-8-despacho-cross-audit-s3-1.md
id-global: 20260616-150000-opus-4-8-despacho-cross-audit-s3-1
autor: claude-opus-4-8 (orquestrador/arquiteto)
auditores_designados: [gemini-3-5, cursor]
created_at: "2026-06-16T15:00:00-03:00"
---

RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-16T15:00:00-03:00
STATE: ultima_atualizacao=2026-06-16T11:39:20-03:00 contexto S3.1 implementada (readback 0029); bastão → claude-opus-4-8
SINAIS: S3.1 entregue (INDEX vivo + G-KNOW-INDEX); lição knowledge 0023 depositada (untracked); design de área temporária para cross-audit
PENDENTE: cross-audit de S3.1 + parecer de design da área temporária; depois selagem
PRÓXIMA AÇÃO: Cross-audit S3.1; depois S3.2.
PARA O HUMANO: main intocada; o guard G-KNOW-INDEX vai exigir que knowledge 0023 entre no INDEX na selagem

## Decisões informais (cápsula)
A inabilidade do sandbox de apagar no mount é propriedade de segurança (não-defeito).
A lição virou knowledge 0023. A área temporária precisa de desenho seguro, sem virar superfície de exposição.

================================================================================
BLOCO 1 — COLAR EM JANELA NOVA DO GEMINI 3.5
================================================================================

PARA: gemini-3-5 (auditor cruzado, família distinta do implementador codex)
DE: claude-opus-4-8 (orquestrador)
TAREFA: (Parte A) cross-audit da onda S3.1 no repo usehbn, branch proposta/reestruturacao-m-a-s0; (Parte B) parecer de design sobre uma area temporaria segura para IAs.

SECAO 0 — REGRAS
- So leitura no repo. Sem commit, sem tocar main, sem alterar indice.
- Todo julgamento cita arquivo:linha OU comando+saida (Truth Barrier).
- Nao confie nos relatos; confira no disco.

PARTE A — S3.1 (INDEX vivo + guard G-KNOW-INDEX)
Alegado (verificar): 5 commits (4a022a9, f2e7539, bd51e2d, 6224477, 23c42fe) sobre 04a0ceb; .hbn/knowledge/INDEX.md passou a listar as 8 entradas; guard guards/assert-knowledge-index.sh (G-KNOW-INDEX) bloqueante exige que toda .hbn/knowledge/*.md esteja citada no INDEX; burla B24; suite 156/156; runner verde; main 4db6928.
Pontos de ataque:
A1. Correcao: stage (no indice) uma knowledge nova NAO citada no INDEX -> G-KNOW-INDEX BLOQUEIA? E com a citacao adicionada no mesmo commit -> PASSA? Prove os dois lados.
A2. Fail-closed: INDEX ausente/ilegivel -> guard bloqueia (nao passa por omissao)?
A3. Idempotencia (P-CAND-02): rode o guard e a suite 3x num ambiente SEM lock de git; o veredito e o mesmo toda vez? (o orquestrador observou um rc 0->1 que atribuiu a lock transitorio do sandbox no git show :INDEX, caindo fail-closed; confirme que e ambiental e nao defeito de logica).
A4. Escopo: git diff --name-only 04a0ceb..HEAD toca SOMENTE os files_allowed do readback 0029? Sem vazamento?
A5. Sem regressao: run-guard-tests 156/156; adversarial B1-B24; runner verde; main intocada.
A6. Trailers contiguos nos 5 commits (via %(trailers:key=)).
A7. LEVEZA + via mais simples (P-CAND-01): o guard e a coisa mais simples que resolve? O INDEX e ponteiro (nao duplica conteudo das licoes)? Existe forma mais simples/robusta/racional de manter as licoes encontraveis — por exemplo GERAR o INDEX automaticamente em vez de um guard que so verifica — mesmo partindo de outra premissa/tecnologia? Aponte com arquivo:linha.
Nota: ha um arquivo untracked intencional .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md (licao desta onda, a ser indexada+selada). Nao e stray.

PARTE B — DESIGN: area temporaria segura para IAs (parecer, nao implementacao)
Problema: IAs precisam de espaco efemero (fixtures, rascunhos) para nao poluir paths governados. Mas esse espaco NAO pode ser superficie de exposicao de dados nem risco de seguranca.
Proposta do orquestrador (critique e melhore):
- Regra primaria: efemero vai para o tmp do PROPRIO ambiente da IA, FORA do repo versionado.
- Se for inevitavel no repo: uma unica pasta (ex.: scratch/ na raiz) que seja (1) totalmente gitignored — nunca entra na historia/origin; (2) protegida por um guard que FALHA se qualquer path sob ela for staged (defesa em profundidade contra vazamento via git); (3) documentada como efemera, sem segredos/PII; (4) limpavel.
Perguntas ao auditor:
B1. Esta e a forma mais segura? Qual o vetor de exposicao residual e como fechar?
B2. Alternativas melhores (ex.: so tmp do ambiente; TTL/limpeza automatica; guard anti-segredo; cifra)?
B3. gitignore + guard-anti-stage e suficiente para garantir que nada de scratch vaze para o origin?

VEREDITO (deposite como arquivo .hbn/results/20260616-HHMMSS-gemini-3-5-cross-ia-s3-1.md):
- Linha 1: APROVA_0029: SIM (ou NAO + bloqueadores com arquivo:linha)
- Secao DESIGN-AREA-TEMP: recomendacao objetiva (forma mais segura + guard sugerido).
- Marginais; confianca 0-100; assine e date.

================================================================================
BLOCO 2 — COLAR EM JANELA NOVA DO CURSOR
================================================================================

PARA: cursor (auditor cruzado, familia distinta do codex e do gemini)
DE: claude-opus-4-8 (orquestrador)
TAREFA: idem ao Bloco 1 (Parte A audita S3.1; Parte B parecer de design da area temporaria). NAO consulte o parecer do Gemini.

SECAO 0 — REGRAS
- So leitura; sem commit; sem tocar main. Truth Barrier em todo julgamento.

PARTE A — pontos de ataque (mesmos do Bloco 1: A1 correcao, A2 fail-closed, A3 idempotencia, A4 escopo, A5 sem regressao, A6 trailers, A7 leveza+via-mais-simples).
EXTRA (Cursor): procure o vetor fino — (1) o guard G-KNOW-INDEX usa grep -Fq do basename; um basename que e SUBSTRING de outro (ex.: "0002" casando dentro de "10002") gera falso-positivo/negativo? (2) o INDEX pode citar uma entrada que NAO existe mais (ponteiro morto) sem o guard reclamar?

PARTE B — DESIGN area temporaria (mesmas perguntas B1-B3 do Bloco 1). Como voce costuma achar o vetor de exposicao, foque: um scratch gitignored ainda pode vazar dado por (a) backup, (b) symlink para fora, (c) alguem removendo a linha do gitignore? Proponha o desenho que fecha esses.

VEREDITO (deposite .hbn/results/20260616-HHMMSS-cursor-cross-ia-s3-1.md):
- Linha 1: APROVA_0029: SIM (ou NAO + bloqueadores).
- Secao DESIGN-AREA-TEMP: recomendacao + guard sugerido.
- Marginais; confianca 0-100; assine e date.

================================================================================
FIM DOS BLOCOS
================================================================================
