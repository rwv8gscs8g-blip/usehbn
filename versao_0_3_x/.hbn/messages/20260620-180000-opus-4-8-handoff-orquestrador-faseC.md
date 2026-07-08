---
titulo: "Cartão de Entrada — Orquestrador Fase C (correção de disciplina + retomada da linha)"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260620-180000-opus-4-8-handoff-orquestrador-faseC.md
created_at: "2026-06-20T18:00:00-03:00"
autoria: "claude-opus-4-8 (orquestrador cessante · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "orquestrador entrante (Anthropic, claude-opus-4-8)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

Este é o SEED. A verdade está no DISCO. Nunca confie no relato — confirme por arquivo:linha ou comando+saída. Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0.

1. AUTOIDENTIFIQUE-SE (1ª linha, exata): SOU: <apelido> · familia Anthropic · papel orquestrador. Invariante §2.9a: fornecedor(orquestrador) ≠ fornecedor(implementador=codex/OpenAI). Você é o ZELADOR ENFORÇADO: submetido às barreiras PRIMEIRO, mantenedor delas DEPOIS. Auto-certificação é NULA; ratificação = ≥2 famílias ≠-implementador + gate humano. Se um guard bloquear: PARE e relate, nunca contorne.

2. ATESTAÇÃO DE ENTRADA. Bastão token_fp = 34a7f2f9 (sha completo 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf; proprietario = claude-opus-4-8). MESMA família (claude-opus-4-8/Anthropic) ⇒ WARM BOOT, sem re-pin. Família ≠ ⇒ re-pin sob rito W-ORQ-3, nova atestação em commit PRÓPRIO. Confirme verde: bash guards/assert-orq-entrada.sh. A read-list canônica resolve EXATAMENTE 13 itens (assert-orq-entrada.sh:140) — não a altere sem rito.

3. LEIA DO DISCO, nesta ordem (core/read-list-canonica.txt): .hbn/relay/STATE.md → handoff_mais_recente → readback_ativo → core/role-cards.md → core/orchestrator-profile-spec.md → core/relay-spec.md → agents/role-templates.md → agents/codex.md → .hbn/knowledge/0001,0002,0022,0023,0024,0025 → core/relay-return-spec.md (canal de retorno) → este cartão completo.

4. ESTADO (reconfirme no disco):
   * main INTOCADA em 4db692876381a0d7909985c8500d999f2e677b04. HEAD em bf62ecd.
   * SELADOS E VIGENTES: 0060 (G-ORQ-ENTRADA v2), 0063 (W-ORQ-3b/Exit A'), 0065 (G-COPY).
   * PROPOSED, NÃO selados: 0066 (G-NEXT — SEM cross-audit ainda) e 0067 (W-RET — cross-audit FEITO: pareceres canônicos no disco em .hbn/results/20260620-160000-antigravity-cross-ia-w-ret-0067.md e .hbn/results/20260620-163000-grok-cross-ia-w-ret-0067.md, ambos APROVA_0067: SIM, untracked).
   * proximo_ponto no disco = "cross-audit do W-RET (0067)" — esse passo JÁ ESTÁ FEITO no disco. Logo o passo VERDADEIRO agora é SELAR a 0067.

5. POR QUE HOUVE HANDOFF — A LEI QUE VOCÊ CUMPRE PELO EXEMPLO (inviolável):
   O orquestrador cessante furou a disciplina (não os guards — esses seguraram tudo; main intacta). Os erros, que você NÃO repete:
   a. OBEDEÇA o proximo_ponto do disco: a ÚNICA ação legal por turno é executar exatamente o proximo_ponto. NUNCA invente passo paralelo (o cessante inventou um "cross-audit do 0066" e "selagem combinada" que o disco nunca declarou).
   b. Um passo por vez, na ordem de decisão; UM bloco HBN-COPY por passo. Só libere o próximo após conferir no disco o resultado do anterior.
   c. Cada disparo a uma IA é um chat NOVO, sem memória: instrução autossuficiente, idempotente, ato atômico (prepare→stage→COMMIT num só shot). Só o orquestrador acumula contexto.
   d. Pré-cumpra TODOS os 28 guards. Em especial: G-RLT/assert-report-fresh exige que o RELATO DE ESTADO do seu despacho case EXATAMENTE o STATE staged (linha PRÓXIMA AÇÃO == proxima_acao; cite ultima_atualizacao= idêntico; heading exato "## Decisões informais (cápsula)"). Outros que o cessante tropeçou: G-AUDITOR-ID (apelido/SOU canônicos: grok/xAI, antigravity/Google — não "grok-xai"), G-KNOW-INDEX (knowledge novo exige citação em .hbn/knowledge/INDEX.md), G-SLF (path: real), read-list = 13.
   e. NUNCA fure guard; se bloquear, PARE e relate. O codex escreve o recibo .hbn/relay/RETURN.json (status ok|blocked|error + blockers) — LEIA o motivo DO DISCO, não do chat.
   f. Orquestrador DESENHA, codex IMPLEMENTA (§2.10). Mecânica de repo (editar/normalizar/git janitorial) → micro-despacho ao codex, NUNCA ao humano. Humano só faz atos de GATE (hearback, posse do bastão, freeze).
   g. main NUNCA tocada. Truth Barrier: arquivo:linha / comando+saída.

6. PENDENTE EM ORDEM (a linha de desenvolvimento a resgatar — NÃO improvise outra):
   A. BLINDAR O ORQUESTRADOR (prioridade atual do gate Mauricio):
      A1. SELAR 0067 (W-RET) — quórum já no disco. É o proximo_ponto real. Ato de autoridade (G-ORQ-REF/Exit A', regenera atestação same-fp). 3º dogfood.
      A2. Cross-audit (≥2 famílias ≠-OpenAI) + selar 0066 (G-NEXT).
      A3. G-QUORUM: guard que bloqueia qualquer SELAGEM cujo readback não tenha ≥2 pareceres ≠-OpenAI canônicos no disco (passando G-AUDITOR-ID/G-SLF) + tornar o vínculo orquestrador↔proximo_ponto mecânico onde possível.
      A4. W-LEX (Lei da Submissão pelo Exemplo) CORRIGIDO: registrar em .hbn/knowledge/0032 + citar no INDEX.md + cláusula vinculante em core/orchestrator-profile-spec.md (que já está na read-list → muda só o hash, NÃO a contagem 13). NÃO adicionar 0032 à read-list (evita virar 14). O despacho 20260619-150000-opus-4-8-despacho-w-lex.md está untracked mas FALHO (bloqueou em G-KNOW-INDEX e na contagem 13) — refaça por este caminho.
   B. ROADMAP DOCUMENTADO até o freeze: W-ORQ-4 (endurecer a meta-superfície: orq_entrada_ref omitido / read-list editada sem rito / freeze sem dereferenciar + integrar B1-B67 ao CI) → Despromoção-P6 (assert-arvore-label só cobre promoção) → W-FREEZE (freeze = exit 0 do freeze-gate.sh rodado pelo HUMANO; tag v1-estavel). Refs no disco: docs/brainstorm/rodada-2026-06-17/ROADMAP-cadencia-ate-v207.md, .../W-FREEZE-preparacao.md, .../SINTESE-PROFUNDA-pre-freeze.md.
   C. LINHA MAIOR (a ponte / exúvia / M-A scaffold, hoje INATIVO): docs/brainstorm/rodada-2026-06-17/NUMERACAO-dossie-entrada-design-exuvia.md + readbacks 0010/0011 (plano exúvia v2), 0012/0016 (M-A scaffold). Só após o freeze e com novo rito.

7. FERRAMENTAS JÁ VIGENTES (use, não reinvente):
   * G-ORQ-REF (Exit A'): atos de autoridade (despacho/selagem/freeze) exigem orq_entrada_ref; a selagem regenera a atestação MESMO-fp no mesmo commit (manifest muda; fp e bastao_token_sha256 completo inalterados).
   * G-COPY: todo despacho/prompt depositado carrega EXATAMENTE UM bloco ⟦HBN-COPY dest=<apelido>⟧ BEGIN … ⟦HBN-COPY END⟧; dest ∈ apelidos do mapa ∪ {codex,human}. Entregue o bloco no chat E depositado untracked.
   * G-NEXT: STATE.md carrega proximo_ponto bem-formado (passo/ato/destino/gate/bloco_ref/status). É a sua bússola — obedeça.
   * W-RET: o recibo .hbn/relay/RETURN.json (efêmero, gitignored) registra o desfecho de cada execução. "pronto" do gate = avance lendo o disco.

8. LIÇÕES (custaram erros reais; detalhe no STATE/knowledge): k-0026 (zelador confere o disco mesmo contra cross-audits aprovados); k-0027 (mecânica → codex, nunca ao humano); k-0028 (instrução imprecisa vira defeito a jusante — dê exemplos concretos, releia "o que uma IA copiaria por engano?"); k-0029 (prompt de cross-audit fixa apelido/SOU/nome canônicos do mapa); k-0030 (bloco copiável é contrato do artefato no disco, não da prosa); k-0031 (cada disparo é chat novo — autossuficiente/idempotente/atômico); k-NOVA (o orquestrador OBEDECE o proximo_ponto e nunca inventa passo paralelo — a causa deste handoff).

9. PRIMEIRA AÇÃO: autoidentifique-se (Anthropic, ≠ OpenAI) → valide a atestação (bash guards/assert-orq-entrada.sh verde; warm boot) → leia a read-list → leia o proximo_ponto do disco e EXECUTE EXATAMENTE ELE: como o cross-audit do 0067 já está no disco, o ato é preparar a SELAGEM 0067 (despacho cold-start ao codex; hearback do gate; commit). Depois siga §6 na ordem, um bloco por vez. Primeiro passo mecânico a despachar ao codex: apontar STATE.handoff_mais_recente para .hbn/messages/20260620-180000-opus-4-8-handoff-orquestrador-faseC.md, atualizar o proximo_ponto para "selagem do W-RET (0067)", e trackear este cartão sob rito. FIM DO CARTÃO.
