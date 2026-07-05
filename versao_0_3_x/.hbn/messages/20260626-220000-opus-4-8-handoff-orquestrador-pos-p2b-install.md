---
titulo: "Handoff do orquestrador — entrada da proxima janela (pos P2-B install da ponte)"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260626-220000-opus-4-8-handoff-orquestrador-pos-p2b-install.md
created_at: "2026-06-26T22:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
para: "proximo Claude Opus orquestrador (Anthropic)"
relacionado:
  - .hbn/relay/STATE.md
  - docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md
  - .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md
---
## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-27T02:30:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador (zelador das regras pelo exemplo — k-0029).
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-27T02:30:00-03:00 readback_ativo=.hbn/readbacks/0102-onda-state-p2b-parte2.json; main intocada 4db6928; HEAD 6e57339.
PRÓXIMA AÇÃO: PASSO 2 / commit da membrana no Credenciamento sob rito do projeto + firewall 0022 (git add scoped: .usehbn-snapshot/, scripts/hbn-snapshot/assert-snapshot-integrity.sh, .hbn/active-version); depois P2-C (runner project-mode + subset bloqueante)
BASTÃO: opus-4-8 (Anthropic), atestacao v2 valida (34a7f2f9). Ato de autoridade sob G-ORQ-REF (Exit A').

## Decisões informais (cápsula)
- P2-B parte 2 concluida no disco do Credenciamento; membrana instalada e verificada; commit da membrana fica para o rito do projeto.
- Este handoff foi recebido como contexto de entrada e agora fica trackeado como handoff_mais_recente do STATE.

# Handoff — voce e o novo orquestrador. Leia isto inteiro antes de agir.
## QUEM VOCE E
Voce e o novo **Claude Opus orquestrador (Anthropic)**, bastao token_fp **34a7f2f9**,
zelador das regras PELO EXEMPLO (W-LEX, k-0029; orchestrator-profile-spec §7). Sua
autoridade vem de OBEDECER ao rito, nunca de contorna-lo. Avanca o plano aprovado
um passo por vez, confirmando tudo no DISCO (Truth Barrier).
## REGRAS INEGOCIAVEIS
1. Obedeca o `proximo_ponto` do STATE EXATAMENTE.
2. Entregue cada passo como UM bloco copiavel `⟦HBN-COPY dest=codex⟧` COMPLETO E LITERAL
   **no CHAT** (o app NAO e IDE; nada de "ver arquivo"; knowledge 0001 = comandos atomicos
   copiaveis; o documento a colar tem que estar inteiro no chat — exigencia de Mauricio).
3. Mecanica vai para o codex; o humano (Mauricio) so opera GATES.
4. Guard bloqueou: PARE e reporte. Nunca --no-verify, nunca burla, nunca toca a main.
5. main INTOCADA = 4db692876381a0d7909985c8500d999f2e677b04.
6. Ratificacao = >=2 familias != OpenAI (G-QUORUM/G-DIVERSITY) + gate humano.
7. Cada ato de autoridade (despacho/selagem/freeze) carrega `orq_entrada_ref`
   (.hbn/attestations/34a7f2f9-orq-entrada.json; regenere same-fp com /tmp/gen_orq.py).
8. Truth Barrier: NUNCA confie no RETURN do codex; confirme por arquivo:linha / comando+saida.
## ONDE O PLANO ESTA
docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md (5 passos:
1 freeze do PROTOCOLO [FEITO] → 2 ponte com Programa de Credenciamento [EM CURSO] →
3 exuvia do protocolo → 4 validar+congelar V206 → 5 decisao conjunta sobre v207).
Desenho da ponte (ratificado): .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md.
## ESTADO DE DISCO NO HANDOFF (confirme voce mesmo)
- Protocolo ~/Projetos/usehbn, branch proposta/reestruturacao-m-a-s0; HEAD = 6e57339;
  main = 4db6928 INTOCADA; tag v1-estavel = a67e8049ed6fd4f81423ee60194a2f5896f25af0.
- PASSO 1 (freeze do PROTOCOLO) CONCLUIDO: tag v1-estavel; freeze-gate exit 0 (hearback
  .hbn/hearbacks/freeze-protocolo-v1-estavel.json confirmado). Ondas 0090→0095.
- PASSO 2 / desenho RATIFICADO: proposta-ponte v2 selada 0096 via 0097 (duplo APROVA antigravity+grok).
- P2-A (scripts/hbn-snapshot/install-snapshot.sh + dry-run) selado 0098 via 0099.
- P2-B (modo --install do install-snapshot.sh) selado 0100 via 0101.
- P2-B PARTE 2 (install humano) **FEITO no disco do Credenciamento** (verificado):
  ~/Projetos/Credenciamento/.usehbn-snapshot/ = 137 arquivos de protocolo + 5 meta
  (protocol_sha256 8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1,
  tag v1-estavel); scripts/hbn-snapshot/assert-snapshot-integrity.sh; .hbn/active-version=.
  assert-snapshot-integrity rodado = ✓ 137 arquivos. ESTAS COISAS ESTAO **UNTRACKED** no
  Credenciamento (falta o commit la, sob os guards + firewall 0022 do PROJETO).
- readback_ativo = .hbn/readbacks/0101-selagem-p2b.json. ATENCAO: o STATE.proxima_acao
  AINDA diz "P2-B parte 2 — Mauricio roda --install" — isso JA FOI FEITO; atualize.
## SEU PROXIMO PONTO (em ordem)
1. **Atualizar o STATE** (onda no protocolo): registrar que P2-B parte 2 esta concluida
   (membrana instalada e verificada no Credenciamento); proxima_acao → "commit da membrana
   no Credenciamento + P2-C".
2. **Commit da membrana NO REPO Credenciamento** (NAO e o protocolo; e o projeto, sob os
   guards dele + firewall 0022): `git add .usehbn-snapshot/ scripts/hbn-snapshot/assert-snapshot-integrity.sh .hbn/active-version`
   e commit. Coordene com Mauricio; o lado do projeto tem governanca propria (readback/rito do projeto).
   Cuidado: .usehbn-snapshot/ esta chmod read-only (a-w) — `git add` funciona; para futuras
   trocas use install-snapshot.sh --upgrade (ainda nao implementado, P2-C+; lembrar de chmod u+w antes).
3. **P2-C**: runner project-mode + subset bloqueante no Credenciamento (shims locais chamando
   .usehbn-snapshot/guards/ apos assert-snapshot-integrity); pre-higiene do INDEX da knowledge
   do projeto (7 entradas faltando, ver auditoria executiva do codex). Ver proposta v2 §5 + §2 (subset).
4. **P2-D**: router OBRIGATORIO no topo do AGENTS.md do Credenciamento; tombstone do espelho
   antigo usehbn/ (108 arquivos, layout antigo); untangle (radar/study-plans/audits saem de usehbn/);
   limpeza das ~649 refs a usehbn/ (humano-gated, patch candidato + revisao); selagem do passo 2.
5. Depois do passo 2: passo 3 (EXUVIA do protocolo — muda do exoesqueleto, pasta nova; NAO e
   cosmetico), passo 4 (V206), passo 5 (v207). Ver o roadmap.
## DESIGN DE REFERENCIA E DECISOES JA TOMADAS
- Membrana "duas camadas": protocolo (genoma, v1-estavel, read-only) ⇄ projeto consome
  .usehbn-snapshot/ (gerado por git archive do tag + manifesto determinístico + checksum).
- Escopo = B-subset (core+methodology+schemas+guards = 137; subset de guards de projeto roda
  no Credenciamento via shims; guards internos do genoma NAO vao). Lista no CONSUMER-PROFILE.md do snapshot.
- Compat: o PROJETO fornece .hbn/active-version=. (mantem o protocolo v1-estavel CONGELADO/intocado).
- 3 garantias de Mauricio: (1) sem confusao protocolo×projeto; (2) projeto respeita os fluxos
  (roda guards+ritos); (3) contribuicao de volta via inbox/credenciamento/ (projeto nunca edita o genoma).
- D4 (renomear .hbn/ do projeto → .hbn-local/) ADIADO para um P3 proprio (1597 refs; arriscado).
- Canal de feedback ja seguro (inbox/README.md); melhorias sugeridas: snapshot-sha no front-matter, schema, INDEX.
## LICOES OPERACIONAIS (evite os tropecos que ja pagamos)
- O codex PARAFRASEIA o relato → trava G-RLT (assert-report-fresh). O bloco "## RELATO DE ESTADO"
  precisa: linha `PRÓXIMA AÇÃO:` IDENTICA ao proxima_acao do STATE; token `ultima_atualizacao=<exato>`;
  heading EXATO `## Decisões informais (cápsula)` (com acentos). Mande SALVAR VERBATIM.
- readbacks estao gitignored → `git add -f .hbn/readbacks/<n>.json`.
- Todo readback safe_track precisa `human_status: confirmed` E `hearback_status: confirmed`
  (senao assert-scope-lock sai silencioso sob set -e e o runner bloqueia).
- Cross-audit: veredito na ULTIMA linha EXATA `APROVA_NNNN: SIM`/`NAO`, sem texto depois (G-DIVERSITY).
- Selagem: readback `status: vigente` + `seals_proposal: NNNN`; G-QUORUM exige 2 results
  APROVA_NNNN SIM de familias != OpenAI trackeados no mesmo commit.
- Hearback numerado novo cai em deadlock G-REG×G-HRB → use nome NAO-numerado ou um readback que
  autorize o escopo (.hbn/active-version semantics).
- Selagem/atestacao: rode /tmp/gen_orq.py para regenerar a atestacao same-fp ANTES do commit; depois
  `bash guards/assert-orq-entrada.sh` deve ficar verde.
- O documento a colar deve estar INTEIRO no chat (Mauricio cobra isso).
## PRIMEIRO ATO RECOMENDADO
Confirme o disco (HEAD 6e57339; main 4db6928; tag v1-estavel; membrana em ~/Projetos/Credenciamento/.usehbn-snapshot/
com 137 + integridade ✓). Depois despache a onda que ATUALIZA o STATE (P2-B parte 2 concluida) e
COORDENA o commit da membrana no Credenciamento. Trackear ESTE handoff como handoff_mais_recente nessa onda.
— FIM DO HANDOFF —
