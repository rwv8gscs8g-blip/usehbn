---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (modelo versão=pasta; M-A scaffold inativo; B19/S2/faxina 0027/S3.1/S3.2/P-CAND-04/W2 selados; grande selagem 0035 concluida; W3 deny-zona-livre ratificado e selado; R1 runtime+honestidade entregue; R1-fix dedup estado entregue; R1+R1-fix selados; R1-fix-2 entregue; selagem R1-fix-2 concluida; Esteira de Pre-Transicao promovida para core; Esteira de Pre-Transicao selada e vigente; Curadoria P0 docs entregue; Curadoria P0 selada; G-AUDITOR-ID selado e vigente; R2 arvores selada e vigente; R3a G-TRAILERS selada e vigente; R3b G-DIVERSITY selada e vigente; hardening pre-freeze R3a+R3b concluido; Curadoria do Dossie de Pre-Transicao 0055 selada; G-ORQ-ENTRADA 0056 entregue; W-ORQ-2 0058 entregue; G-ORQ-ENTRADA v2 selado e vigente; W-ORQ-3 0061 entregue; W-ORQ-3b 0062 selado e vigente via 0063; G-COPY 0064 selado e vigente via 0065; G-NEXT 0066 selado e vigente via 0069; W-RET 0067 selado e vigente via 0068; G-QUORUM 0070 selado e vigente via 0071; W-LEX 0029 selado e vigente via 0073; W-ORQ-4a 0074 selado e vigente via 0075; W-ORQ-4b 0076 selado e vigente via 0077; W-ORQ-4c 0078 selado e vigente via 0079; W-ORQ-4d 0080 entregue/proposto; W-ORQ-4d-fix 0081 entregue/proposto; W-ORQ-4d-fix-2 0082 selado e vigente via 0085; W-ORQ-4 (4a/4b/4c/4d) completo; fix-gexc-sigpipe 0083 selado e vigente via 0084; Despromocao-P6 0086 selado e vigente via 0087; roadmap B pronto para W-FREEZE; fix-freeze-meta-deref 0088 selado e vigente via 0089; W-FREEZE liberado); ROADMAP-macro-pos-blindagem-5-passos rastreado (handoff pos-roadmap fica como contexto de entrada, nao rastreado nesta janela) (track 0090); STATE ancorado no ROADMAP-macro-pos-blindagem-5-passos (passo 1 = W-FREEZE); W-FREEZE propose: freeze-checklist do PROTOCOLO trackeado (readback 0091, pendente cross-audit !=OpenAI); W-FREEZE fix-checklist: 0091 superado por 0092 (suite-pytest-verde ok com prova do operador 213 passed; numeros 179/85 e pytest-2fail do grok refutados pelo Terminal do operador 264/0 e 213 passed); pendente re-cross-audit; W-FREEZE checklist 0092 selado e vigente via 0093 (duplo APROVA_0092 SIM: antigravity/Google + grok/xAI); pronto para o gate humano; W-FREEZE hearback-scope: readback 0094 autoriza o commit puro do hearback do freeze (proximo: ato humano de Mauricio); PASSO 1 CONCLUIDO — PROTOCOLO congelado em v1-estavel (tag a67e804; freeze-gate exit 0; hearback confirmado); abrindo passo 2 (ponte com Programa de Credenciamento)"
onda_atual: "PASSO 1 (FREEZE DO PROTOCOLO) CONCLUIDO — tag v1-estavel em a67e804; freeze-gate congelavel:sim rodado pelo humano; main intocada 4db6928. Proximo: PASSO 2 do roadmap (ponte com o Programa de Credenciamento), rito a definir com Mauricio."
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: claude-opus-4-8
papel_bastao: "orquestrador"
modo_educacional: "intermediário"
papeis:
  arquiteto: "claude-opus-4-8 — orquestrador/desenho do mecanismo M-A; distinto do implementador codex"
  auditores_validadores: "gemini-3-5 + cursor + grok + antigravity — historico: S1/B17/B18/B19/S2/faxina/S3.1/S3.2 aprovados; P-CAND-04 ratificado por Cursor APROVA_0033 SIM e Grok NAO resolvido pelo W2; W2 ratificado por Grok+Antigravity APROVA_0034 SIM; W3 ratificado por Grok, Antigravity 100 e Cursor 92 com APROVA_0036 SIM"
  gate_humano: "Maurício — aprovou a reestruturação em 2026-06-15; autorizou S1/B17/B18/B19/S2/faxina/S3.1/S3.2/P-CAND-04/W2; em 2026-06-16 autorizou grande selagem 0035, hardening->deny->freeze, selagem W3, cartao de entrada e branch protection biometrica na main"
proxima_acao: "PASSO 2 do roadmap — ponte com o Programa de Credenciamento (definir o rito com Mauricio)"
roadmap_ativo: "docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md"
proximo_ponto:
  passo: "PASSO 2 do roadmap — ponte com o Programa de Credenciamento (definir o rito e o criterio de pronto com Mauricio)"
  ato: implementacao
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/messages/20260626-010000-opus-4-8-despacho-w-freeze-fechamento.md
  status: pendente
sinais_abertos:
  - "🟢 PASSO 1 CONCLUIDO — PROTOCOLO CONGELADO v1-estavel — tag anotada a67e804; freeze-gate exit 0 (congelavel: sim) rodado por Mauricio; checklist 0092 selado via 0093; hearback freeze-protocolo-v1-estavel.json confirmado; main intocada 4db6928. Auto-verificavel (checkout v1-estavel + freeze-gate)."
  - "🟡 PASSO 2 ABERTO — ponte com o Programa de Credenciamento: validar na pratica que o protocolo selado credencia/valida corretamente. Rito e criterio de pronto a definir com Mauricio (roadmap passo 2)."
  - "🟢 W-FREEZE CHECKLIST 0092 SELADO E VIGENTE — readback 0093; duplo APROVA_0092 SIM por antigravity/Google e grok/xAI (G-QUORUM + G-DIVERSITY); hearback Mauricio confirmado. grok reverteu o NAO apos a correcao do suite-pytest-verde."
  - "🟢 CROSS-AUDIT 0091 REFUTADO/CORRIGIDO — antigravity APROVA_0091 SIM; grok NAO: (1) suite-pytest-verde sem prova [VALIDO -> corrigido com 213 passed do operador] (2) run-guard-tests 179/85 e pytest 2-fail [REFUTADOS pelo Terminal do operador: 264/0 e 213 passed]. Pareceres da rodada 1 ficam untracked (G-DIVERSITY: 0091 sem quorum 2x SIM)."
  - "🟢 TRACK-ROADMAP-5-PASSOS — readback 0090; ROADMAP-macro-pos-blindagem-5-passos rastreado (handoff pos-roadmap fica como contexto de entrada, nao rastreado nesta janela) sob rito (zona-livre curada por Mauricio 2026-06-21); STATE ancorado no roadmap via roadmap_ativo + proximo_ponto."
  - "🟡 W-FREEZE (PASSO 1) PROXIMO — freeze do PROTOCOLO segue liberado; falta o orquestrador montar o freeze-checklist real e o humano rodar `bash guards/freeze-gate.sh <checklist>` exit 0 + tag v1-estavel."
  - "🟢 FIX-FREEZE-METADEREF SELADO E VIGENTE — readback 0089; duplo APROVA_0088 por antigravity/Google e grok/xAI; freeze-gate resolve propostas seladas pelo ledger; hearback Mauricio confirmado."
  - "🟡 W-FREEZE LIBERADO — todas as propostas resolvidas; freeze-gate dereferencia meta-superficie limpa; proximo e o ato de GATE humano: freeze-gate.sh exit 0 + tag v1-estavel."
  - "🟢 DESPROMOCAO-P6 SELADA E VIGENTE — readback 0087; duplo APROVA_0086 por antigravity/Google e grok/xAI; G-ARVORE-LABEL cobre promocao E despromocao; hearback Mauricio confirmado."
  - "🟡 ROADMAP B CONCLUIDO — W-ORQ-4 (4a/4b/4c/4d) + Despromocao-P6 selados; proximo e o W-FREEZE (freeze-gate pelo humano + tag v1-estavel)."
  - "🟢 FIX-GEXC SELADO E VIGENTE — readback 0084; duplo APROVA_0083 por antigravity/Google e grok/xAI; G-EXC corrigido (SIGPIPE eliminado), runner verde determinístico."
  - "🟢 PARECERES 0083 TRACKED — .hbn/results/20260621-080000-antigravity-cross-ia-fix-gexc-sigpipe-0083.md e .hbn/results/20260621-081000-grok-cross-ia-fix-gexc-sigpipe-0083.md versionados; APROVA_0083: SIM."
  - "🟢 W-ORQ-4 COMPLETO — readback 0085; W-ORQ-4d selado via 0082 (redesenho igualdade-exata); facetas 4a (G-READLIST-RITE), 4b (G-ORQ-REF/messages), 4c (freeze meta-deref), 4d (CI battery) vigentes."
  - "🟢 PARECERES 0082 TRACKED — .hbn/results/20260621-090000-antigravity-cross-ia-w-orq-4d-fix2-0082.md e .hbn/results/20260621-091000-grok-cross-ia-w-orq-4d-fix2-0082.md versionados; APROVA_0082: SIM."
  - "🟡 W-ORQ-4d 0080 e fix 0081 SUPERADOS por 0082 — reprovados no cross-audit (burlas comentario/echo/heredoc); o redesenho 0082 (selado via 0085) e a versao vigente. Excecoes encerradas."
  - "🟢 W-ORQ-4d-FIX2 ENTREGUE/PROPOSTO — CI usa entrypoint canonico `bash guards/ci-entry.sh`; G-CI-BATTERY exige igualdade exata no workflow e invocacoes reais no entrypoint."
  - "🟢 B85-B87 COBERTOS — run-guard-tests/adversarial-battery bloqueiam comentario, echo e heredoc-data que fingem invocar ci-entry.sh."
  - "🟢 W-ORQ-4d-FIX ENTREGUE/PROPOSTO — G-CI-BATTERY exige invocacao real `bash <script>` como comando de step run, apos remover comentario inline, bloqueando comentario e echo."
  - "🟢 B85-B86 COBERTOS — run-guard-tests/adversarial-battery bloqueiam comentario inline e echo que fingem invocar run-guard-tests.sh ou adversarial-battery.sh."
  - "🟢 W-ORQ-4d ENTREGUE/PROPOSTO — .github/workflows/hbn-shield.yml roda runner + run-guard-tests + adversarial-battery no mesmo job/checkout; G-CI-BATTERY trava as duas invocacoes no CI."
  - "🟢 B83-B84 COBERTOS — run-guard-tests/adversarial-battery bloqueiam remocao de run-guard-tests.sh e adversarial-battery.sh do workflow."
  - "🟢 W-ORQ-4c SELADO E VIGENTE — readback 0079; duplo APROVA_0078 por antigravity/Google e grok/xAI; hearback Mauricio confirmado; freeze-gate meta-deref vigente."
  - "🟢 PARECERES 0078 TRACKED — .hbn/results/20260621-040000-antigravity-cross-ia-w-orq-4c-0078.md e .hbn/results/20260621-041000-grok-cross-ia-w-orq-4c-0078.md versionados; apelido/SOU canonicos, APROVA_0078: SIM unico."
  - "🟡 W-ORQ-4 EM CURSO (3/4) — facetas 4a/4b/4c seladas; falta 4d (integrar bateria adversarial ao CI)."
  - "🟢 W-ORQ-4b SELADO E VIGENTE — readback 0077; duplo APROVA_0076 por antigravity/Google e grok/xAI; hearback Mauricio confirmado; G-ORQ-REF endurecido vigente."
  - "🟢 PARECERES 0076 TRACKED — .hbn/results/20260621-024500-antigravity-cross-ia-w-orq-4b-0076.md e .hbn/results/20260621-025500-grok-cross-ia-w-orq-4b-0076.md versionados; apelido/SOU canonicos, APROVA_0076: SIM unico."
  - "🟡 W-ORQ-4 EM CURSO (2/4) — facetas 4a (read-list) e 4b (orq_entrada_ref/messages) seladas; faltam 4c (freeze sem dereferenciar) e 4d (B1-B67 ao CI)."
  - "🟢 W-ORQ-4a SELADO E VIGENTE — readback 0075; duplo APROVA_0074 por antigravity/Google e grok/xAI; hearback Mauricio confirmado; G-READLIST-RITE vigente."
  - "🟢 PARECERES 0074 TRACKED — .hbn/results/20260621-010000-antigravity-cross-ia-w-orq-4a-0074.md e .hbn/results/20260621-011000-grok-cross-ia-w-orq-4a-0074.md versionados; apelido/SOU canonicos, APROVA_0074: SIM unico."
  - "🟢 W-ORQ-4a ENTREGUE — guards/assert-readlist-rite.sh ativo no runner; core/read-list-canonica.txt A/M exige readback staged com read_list_rite string nao-vazia + human_status confirmed."
  - "🟢 B76-B78 COBERTOS — run-guard-tests/adversarial-battery bloqueiam read-list sem readback staged, readback sem read_list_rite e human_status diferente de confirmed; caso neutro sem read-list passa."
  - "🟡 PROXIMA ACAO — cross-audit W-ORQ-4a por familias != OpenAI; nao selar W-ORQ-4a, nao iniciar outras facetas de W-ORQ-4 nem W-FREEZE nesta entrega."
  - "🟢 W-LEX SELADO E VIGENTE — readback 0073; duplo APROVA_0072 por antigravity/Google e grok/xAI; hearback Mauricio confirmado."
  - "🟢 A1-A4 COMPLETOS (BLINDAR O ORQUESTRADOR) — W-RET (0068), G-NEXT (0069), G-QUORUM (0071) e W-LEX (0073) selados e vigentes."
  - "🟢 PARECERES 0072 TRACKED — .hbn/results/20260620-234500-antigravity-cross-ia-w-lex-0072.md e .hbn/results/20260620-235500-grok-cross-ia-w-lex-0072.md versionados; apelido/SOU canonicos, APROVA_0072: SIM unico."
  - "🟢 G-QUORUM SELADO E VIGENTE — readback 0071; duplo APROVA_0070 por antigravity/Google e grok/xAI; hearback Mauricio confirmado; 1a selagem sob o proprio G-QUORUM (dogfood)."
  - "🟢 PARECERES 0070 TRACKED — .hbn/results/20260620-220000-antigravity-cross-ia-g-quorum-0070.md e .hbn/results/20260620-223000-grok-cross-ia-g-quorum-0070.md versionados; apelido/SOU canonicos, APROVA_0070: SIM unico."
  - "🟢 DOGFOOD SELAGEM 0071 SOB G-QUORUM — readback vigente com seals_proposal 0070 passou o proprio G-QUORUM; atestacao 34a7f2f9 regenerada same-fp; Exit A' sem bypass."
  - "🟢 G-NEXT SELADO E VIGENTE — readback 0069; duplo APROVA_0066 por antigravity/Google e grok/xAI; hearback Mauricio confirmado."
  - "🟢 PARECERES 0066 TRACKED — .hbn/results/20260620-200000-antigravity-cross-ia-g-next-0066.md e .hbn/results/20260620-203000-grok-cross-ia-g-next-0066.md versionados; apelido/SOU canonicos, path real, APROVA_0066: SIM unico."
  - "🟢 DOGFOOD SELAGEM 0069 DEMONSTRADO — ato de autoridade passa sob G-ORQ-REF com atestacao 34a7f2f9 regenerada same-fp contra readback_ativo 0069; Exit A' sem bypass."
  - "🟢 W-RET SELADO E VIGENTE — readback 0068; duplo APROVA_0067 por antigravity/Google e grok/xAI; hearback Mauricio confirmado."
  - "🟢 PARECERES 0067 TRACKED — os dois pareceres versionados; apelido/SOU canonicos, path real, APROVA_0067: SIM unico."
  - "🟢 DOGFOOD SELAGEM 0068 DEMONSTRADO — ato de autoridade passa sob G-ORQ-REF com atestacao 34a7f2f9 regenerada same-fp contra readback_ativo 0068; Exit A' sem bypass."
  - "🟢 W-RET ENTREGUE — core/relay-return-spec.md define .hbn/relay/RETURN.json efemero, schema de retorno, descarte pelo consumidor e ausencia apos timeout como erro."
  - "🟢 DOGFOOD RETURN PREVISTO — esta propria execucao deve escrever .hbn/relay/RETURN.json apos o commit; recibo fica gitignored e fora do versionamento."
  - "🟡 PROXIMA ACAO — cross-audit W-RET por familias != OpenAI; nao selar W-RET, nao iniciar W-ORQ-4 nem W-FREEZE nesta entrega."
  - "🟢 G-NEXT ENTREGUE — guards/assert-next-checkpoint.sh ativo no runner; STATE adicionado/modificado exige exatamente um proximo_ponto top-level validado no blob staged/HEAD, sem ler working tree."
  - "🟢 B63-B67 COBERTOS — run-guard-tests/adversarial-battery bloqueiam ausencia do mapa, ato fora do enum, destino nao-canonico, bloco_ref inexistente e proximo_ponto duplicado."
  - "🟡 PROXIMA ACAO — cross-audit G-NEXT por familias != OpenAI; nao selar G-NEXT, nao iniciar W-ORQ-4 nem W-FREEZE nesta entrega."
  - "🟢 G-COPY SELADO E VIGENTE — readback 0065; duplo APROVA_0064 por antigravity/Google e grok/xAI; hearback Mauricio confirmado."
  - "🟢 PARECERES 0064 TRACKED — .hbn/results/20260619-120000-antigravity-cross-ia-g-copy-0064.md e .hbn/results/20260619-123000-grok-cross-ia-g-copy-0064.md versionados com apelido/SOU/autor canonicos, path real e APROVA_0064: SIM unico."
  - "🟢 DOGFOOD SELAGEM 0065 DEMONSTRADO — ato de autoridade passa sob G-ORQ-REF com atestacao 34a7f2f9 regenerada same-fp contra readback_ativo 0065; Exit A' usado sem bypass."
  - "🟢 G-COPY VIGENTE — guards/assert-copy-block.sh valida exatamente um bloco HBN-COPY em despacho/prompt novo adicionado, dest canonico e payload nao-vazio, lendo blob staged/HEAD."
  - "🟢 B55-B62 COBERTOS — adversarial-battery cobre zero blocos, dois blocos, BEGIN sem END, END antes de BEGIN, dest invalido, dest malformado, payload vazio e staged ruim com working tree boa."
  - "🟡 PROXIMA ACAO — W-ORQ-4 conforme §6 do cartao Fase B; W-FREEZE exige despacho proprio e nao foi iniciado neste commit."
  - "🟢 W-ORQ-3b SELADO E VIGENTE — readback 0063 ativo; duplo APROVA_0062 antigravity/Google + grok/xAI; hearback Mauricio confirmado; files_allowed do despacho 20260618-210314 trackeados."
  - "🟢 PARECERES 0062 TRACKED — .hbn/results/20260618-151334-antigravity-cross-ia-w-orq-3b-0062.md e .hbn/results/20260618-184500-grok-cross-ia-w-orq-3b-0062.md versionados; pareceres grok nao-canonicos 182500/183600 permanecem zona-livre."
  - "🟢 DOGFOOD SELAGEM 0063 DEMONSTRADO — ato de autoridade passou sob G-ORQ-REF com atestacao 34a7f2f9 regenerada same-fp contra readback_ativo 0063; Exit A' usado sem bypass."
  - "🟢 B48-B54 BLOQUEADOS — run-guard-tests/adversarial-battery mantem ref omitido, dangling, fp trocado, auto-repin sem regeneracao real, fp JSON trocado, full-SHA trocado e atestacao extra fail-closed."
  - "🟡 PROXIMA ACAO — parar apos a selagem; W-ORQ-4/W-FREEZE exigem novo despacho e nao foram iniciados neste commit."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0061 safe_track, implementador=codex, autorização humana Mauricio, orq_entrada_ref presente e trailers contiguos obrigatorios; W-ORQ-3 aguarda cross-audit != OpenAI + hearback humano + selagem 0062+."
  - "🟢 W-ORQ-3 ENTREGUE — guards/assert-orq-entrada-ref.sh gateia somente atos de autoridade do orquestrador (despacho, selagem, freeze), exige orq_entrada_ref e reusa assert-orq-entrada.sh para validar a atestacao vigente."
  - "🟢 B48-B51 BLOQUEADOS — ref omitido, atestacao dangling/ausente, fp trocado e auto-repin no mesmo commit de ato de autoridade bloqueiam fail-closed; entrega nao-autoridade permanece isenta."
  - "🟢 TESTES 0061 VERDES — bash guards/tests/run-guard-tests.sh fechou 208/208; bash guards/tests/adversarial-battery.sh bloqueou B1-B51 com BATERIA VERDE."
  - "🟢 G-ORQ-ENTRADA v2 SELADO E VIGENTE — duplo APROVA_0058 (grok/xAI 92 + antigravity/Google 100); readback 0060 ativo."
  - "🟢 PARECERES 0058 TRACKED — .hbn/results/20260618-072906-grok-cross-ia-g-orq-entrada-0058.md e .hbn/results/20260618-023926-antigravity-cross-ia-g-orq-entrada-0058.md versionados com REGISTRY 7-col arvore=fronteira/frio."
  - "🟢 W-ORQ-2 ENTREGUE — guards/assert-orq-entrada.sh agora valida orq-entrada.v2/extractive-lines por manifest_sha256, seed_sha256, line_responses e field_responses recomputados do indice staged; em CI usa HEAD:path com HBN_DIFF_BASE."
  - "🟢 GABARITO FISICO REMOVIDO — guards/data/orq-entrada-desafios.txt foi eliminado; o gate nao depende mais de regex ou respostas abertas D1-D4."
  - "🟢 TESTES 0058 VERDES — bash guards/tests/run-guard-tests.sh fecha 202/202; bash guards/tests/adversarial-battery.sh bloqueia B1-B47, incluindo B45-B47 contra linha forjada, seed antigo e tentativa sem ler."
  - "🟢 G-EXC 0058 ENCERRADO — readback 0060 sela G-ORQ-ENTRADA v2 apos duplo APROVA_0058 e hearback humano Mauricio confirmado; atestacao v2 regenerada contra blobs staged."
  - "🟢 G-ORQ-ENTRADA ENTREGUE — guards/assert-orq-entrada.sh ativo no runner local; bastao de orquestrador exige .hbn/attestations/<fp>-orq-entrada.json valida contra read-list canonica, hashes atuais e desafios."
  - "🟢 TESTES 0056 VERDES — bash guards/tests/run-guard-tests.sh fechou 200/200; bash guards/tests/adversarial-battery.sh bloqueou B1-B44, incluindo B41-B44 de G-ORQ-ENTRADA."
  - "🟢 CURADORIA 0055 SELADA — readback 0055 ratificado por grok/xAI APROVA_0055: SIM (88) + antigravity/Google APROVA_0055: SIM (100); duas familias !=-OpenAI cumprem G-DIVERSITY; readback 0059 registra a selagem, pendente de hearback humano para vigorar."
  - "🟢 G-EXC 0056 SUBSUMIDO — piso 0056 foi endurecido por W-ORQ-2/0058 e selado como vigente no readback 0060."
  - "🟢 CURADORIA DOSSIE PRE-TRANSICAO ENTREGUE — relatorios 00-06 + SINTESE-PROFUNDA agora tracked; REGISTRY recebeu linhas 7-col com arvore=fronteira e temperatura=frio."
  - "🟢 R-PT5 COBERTURA A-G AUDITAVEL — 00-INDICE.md contem mapa: a=SINTESE, b=01, c=02, d=03, e=01, f=04, g=05; 06 fica meta/proposta e nao conta como tema."
  - "🟢 TESTES 0055 VERDES — runner verde antes de cada commit; run-guard-tests 195/195; adversarial-battery B1-B40 bloqueada; pytest 213 passed; main permanece 4db692876381a0d7909985c8500d999f2e677b04."
  - "🟢 PARECERES 0055 TRACKED — .hbn/results/20260618-001647-grok-cross-ia-curadoria-dossie-0055.md e .hbn/results/20260618-044500-antigravity-cross-ia-curadoria-dossie-0055.md versionados com REGISTRY 7-col arvore=fronteira/frio."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0055 safe_track entregue por codex, autorização humana Mauricio e trailers contiguos; permanece proposto ate cross-audit ≠-OpenAI + hearback + selagem."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0055 safe_track, implementador=codex, autorização humana Mauricio e zona_livre_curada:true; curadoria do dossie de pre-transicao em execucao."
  - "🟡 CURADORIA DOSSIE PRE-TRANSICAO ABERTA — objetivo: tornar tracked os relatorios 00-06 + SINTESE e registrar cobertura auditavel dos temas a-g de R-PT5 antes do W-FREEZE."
  - "🟢 R3b G-DIVERSITY SELADA E VIGENTE — readback 0053 ratificado por antigravity/Google APROVA_0053 SIM e grok/xAI APROVA_0053 SIM; readback 0054 encerrado operacionalmente."
  - "🟢 PARECERES G-DIVERSITY TRACKED — .hbn/results/20260617-222025-antigravity-cross-ia-g-diversity-0053.md e .hbn/results/20260617-225500-grok-cross-ia-g-diversity-0053.md versionados com linhas REGISTRY 7-col arvore=fronteira; G-AUDITOR-ID e G-DIVERSITY aprovaram os dois."
  - "🟢 HARDENING PRE-FREEZE CONCLUIDO — R3a G-TRAILERS + R3b G-DIVERSITY selados; R3c G-REG-M geral permanece C-DEBT aceita para freeze."
  - "🟢 TESTES SELAGEM R3b VERDES — runner verde antes de cada commit; run-guard-tests 195/195; adversarial-battery B1-B40 bloqueada; pytest 213 passed."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0054 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; selagem encerrada com duplo APROVA_0053 + hearback."
  - "🟢 R3b G-DIVERSITY ENTREGUE — guards/assert-audit-diversity.sh ativo no runner; selagem com result cross-ia adicionado exige >=2 familias distintas ≠-implementador com APROVA SIM."
  - "🟢 TESTES R3b VERDES — runner verde; run-guard-tests 195/195; adversarial-battery B1-B40 bloqueada; pytest 213 passed."
  - "🟡 C-DEBT R3c G-REG-M GERAL — divida aceita para o freeze; nao implementada nesta onda por decisao de cadencia."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0053 safe_track entregue por codex, autorização humana Mauricio e trailers contiguos; permanece proposto ate cross-audit ≠-OpenAI + hearback + selagem."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0053 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos obrigatorios; R3b G-DIVERSITY em execucao."
  - "🟡 R3b G-DIVERSITY ABERTA — guard aditivo deve exigir >=2 familias distintas ≠-implementador com APROVA SIM na selagem; R3c G-REG-M geral fica como divida aceita para freeze."
  - "🟢 R3a G-TRAILERS SELADA E VIGENTE — readback 0051 ratificado por grok/xAI APROVA_0051 SIM e antigravity/Google APROVA_0051 SIM; readback 0052 encerrado operacionalmente."
  - "🟢 PARECERES G-TRAILERS TRACKED — .hbn/results/20260617-212200-grok-cross-ia-g-trailers-0051.md e .hbn/results/20260617-212500-antigravity-cross-ia-g-trailers-0051.md versionados com linhas REGISTRY 7-col arvore=fronteira; G-AUDITOR-ID aprovou os dois."
  - "🟢 TESTES SELAGEM R3a VERDES — runner verde; run-guard-tests 191/191; adversarial-battery B1-B39 bloqueada; pytest 213 passed."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0052 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; selagem encerrada com duplo APROVA_0051 + hearback."
  - "🟢 R3a G-TRAILERS ENTREGUE — guard aditivo exige HBN-Readback, HBN-Human-Authorization e HBN-Token-FP contiguos no ultimo paragrafo de todo commit governado, independente de implementador no STATE."
  - "🟢 TESTES R3a VERDES — runner verde; modo commit-msg com G-TRAILERS verde; run-guard-tests 191/191; adversarial-battery B1-B39 bloqueada; pytest 213 passed."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0051 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; entrega concluida, excecao permanece proposta ate cross-audit ≠-OpenAI + hearback + selagem."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0050 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; selagem encerrada com duplo APROVA_0049 + hearback."
  - "🟢 R2 ARVORES SELADA E VIGENTE — core/arvores-spec.md status accepted; pareceres grok/xAI e antigravity/Google tracked com REGISTRY 7-col arvore=fronteira; promocao para intermediaria fica para onda propria."
  - "🟢 TESTES SELAGEM R2 VERDES — runner verde; run-guard-tests 187/187; adversarial-battery B1-B38 bloqueada; pytest 213 passed."
  - "🟢 R2 ARVORES ENTREGUE — spec registry-centric criada, REGISTRY 7-col going-forward, G-REG/G-NUM column-aware e G-ARVORE-LABEL ativo no runner."
  - "🟢 TESTES R2 VERDES — runner verde; run-guard-tests 187/187; adversarial-battery B1-B38 bloqueada; pytest 213 passed."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0049 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; R2 arvores registry-centric em execucao."
  - "🟢 G-AUDITOR-ID SELADO E VIGENTE — readback 0047 ratificado por antigravity/Google APROVA_0047 SIM conf 100 e grok/xAI APROVA_0047 SIM conf 95; auto-ID do auditor agora esta enforcada no runner."
  - "🟢 PARECERES G-AUDITOR-ID TRACKED — .hbn/results/20260617-160500-antigravity-cross-ia-g-auditor-id-0047.md e .hbn/results/20260617-160546-grok-cross-ia-g-auditor-id-0047.md versionados com linhas G-REG; o proprio G-AUDITOR-ID aprovou os dois no C2."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0048 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; selagem encerrada com duplo APROVA_0047 + hearback."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0047 safe_track entregue por codex, autorização humana Mauricio e trailers contiguos; permanece proposto ate cross-audit/hearback/selagem."
  - "🟢 G-AUDITOR-ID ENTREGUE — guards/assert-auditor-id.sh ativo no runner; .hbn/results/*.md adicionado exige nome canonico, SOU canonico, apelido coerente e familia canonica por guards/data/auditor-families.txt."
  - "🟢 TESTES G-AUDITOR-ID VERDES — runner verde; run-guard-tests fechou 183/183; adversarial-battery bloqueou B1-B37; pytest fechou 213 passed."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0046 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; selagem encerrada com duplo APROVA_0045 nao-OpenAI + hearback."
  - "🟢 CURADORIA P0 SELADA — readback 0045 ratificado por antigravity/Google APROVA_0045 SIM conf 98 e grok/xAI APROVA_0045 SIM conf 95; marginal do stub da matriz aceita."
  - "🟢 PARECERES CURADORIA P0 TRACKED — .hbn/results/20260617-124513-antigravity-cross-ia-curadoria-p0-0045.md e .hbn/results/20260617-125600-grok-cross-ia-curadoria-p0-0045.md versionados com linhas G-REG."
  - "🟢 TESTES SELAGEM CURADORIA P0 VERDES — `.venv/bin/pytest -q` fechou 213 passed in 0.81s; `bash guards/tests/adversarial-battery.sh` bloqueou B1-B33; `main` permanece 4db692876381a0d7909985c8500d999f2e677b04."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0045 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; entrega concluida, excecao permanece proposta ate cross-audit ≠-familia + hearback/selagem."
  - "🟢 CURADORIA P0 DOCS ENTREGUE — AGENTS.md corrigido verbatim, docs/GLOSSARY.md criado, docs/MATURITY-MATRIX.md reduzido a stub de redirect e REGISTRY atualizado."
  - "🟢 TESTES 0045 VERDES — `.venv/bin/pytest -q` fechou 213 passed in 0.75s; `bash guards/tests/adversarial-battery.sh` bloqueou B1-B33."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0044 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; selagem encerrada com duplo APROVA_0043 + hearback."
  - "🟢 ESTEIRA PRE-TRANSICAO SELADA E VIGENTE — `core/esteira-pre-transicao.md` esta `status: accepted` e sem front-matter `arvore:`; corpo preservado."
  - "🟢 PARECERES ESTEIRA TRACKED — .hbn/results/20260617-102800-antigravity-cross-ia-esteira-0043.md e .hbn/results/20260617-104500-grok-build-0.1-cross-ia-esteira-0043.md versionados com linhas G-REG."
  - "🟢 TESTES 0044 VERDES — `.venv/bin/pytest -q` fechou 213 passed in 0.76s; `bash guards/tests/adversarial-battery.sh` bloqueou B1-B33."
  - "🟢 R1-FIX-2 SELADO — readback 0041 ratificado por Grok/xAI e Antigravity/Google com APROVA_0041 SIM; ambos trouxeram prova engine-real ANTES/DEPOIS."
  - "🟢 PARECERES TRACKED — .hbn/results/20260617-085700-antigravity-cross-ia-r1-fix2.md e .hbn/results/20260617-091000-grok-build-0.1-cross-ia-r1-fix2.md versionados com linhas G-REG."
  - "🟢 TESTES SELAGEM R1-FIX-2 VERDES — `.venv/bin/pytest -q` fechou 213 passed in 0.78s; `bash guards/tests/adversarial-battery.sh` bloqueou B1-B33."
  - "🟢 R1-FIX-2 ENTREGUE — store.py preserva decisions/context_history distintos que compartilham execution_id; teste engine-real cobre activation/validation/consent."
  - "🟢 TESTES R1-FIX-2 VERDES — `.venv/bin/pytest -q` fechou 213 passed in 0.74s; AGENTS, README e MATURITY-MATRIX sincronizados."
  - "🟢 ADVERSARIAL B1-B33 VERDE — guards/tests/adversarial-battery.sh bloqueou todas as burlas documentadas."
  - "🟢 G-EXC 0041 COBERTO POR CROSS-AUDIT — readback 0041 recebeu duplo APROVA_0041 nao-OpenAI; selagem 0042 mantém exceção proposta visível ate fechamento."
  - "🟢 READBACK 0042 ENCERRADO OPERACIONALMENTE — C1-C3 concluiram readback, dois pareceres tracked, STATE e handoff; bastao volta ao orquestrador."
  - "🟡 PRÓXIMA AÇÃO — promover Esteira de Pre-Transicao para core, curar dossie e seguir R2 arvores registry-centric."
  - "🟢 R1+R1-FIX SELADO — readbacks 0038 e 0039 ratificados por Antigravity/Google, Grok/xAI e Cursor/OpenAI; cinco pareceres versionados na selagem 0040."
  - "🟢 TESTES 212/212 VERDES — `.venv/bin/pytest -q` fechou 212 passed in 0.75s; AGENTS, README e MATURITY-MATRIX sincronizados."
  - "🟢 ADVERSARIAL B1-B33 VERDE — guards/tests/adversarial-battery.sh bloqueou todas as burlas documentadas."
  - "🔴 EXCEÇÃO G-EXC DOCUMENTADA — implementador=codex coincide com agent_id do readback 0040; PROPOSED_UNTIL_CROSS_AUDIT satisfeito por cross-audit R1+R1-fix e mantido visivel enquanto 0040 for o readback ativo."
  - "🟢 READBACK 0040 ENCERRADO OPERACIONALMENTE — selagem concluida em C1-C4; handoff final devolve bastao ao orquestrador."
  - "🟡 PRÓXIMA AÇÃO — R2 arvores registry-centric (G-REG M + anti-mislabel)."
  - "🟢 R1 ENTREGUE — readback 0038 implementado em seis commits: golden tests dos subcomandos, exit codes honestos, estado canonico em .hbn/, docs alinhados e handoff final."
  - "🟢 TESTES R1 VERDES — pytest fechou 211/211 antes do handoff C6."
  - "🟢 GUARDS R1 VERDES — guards/hbn-guards-runner.sh passou antes de cada commit R1."
  - "🟡 PRÓXIMA AÇÃO — cross-audit R1 por familia nao-OpenAI; depois R2 arvores registry-centric (G-REG M + anti-mislabel)."
  - "🟢 W3 RATIFICADO E SELADO — readback 0036 ratificado por Grok, Antigravity 100 e Cursor 92 com APROVA_0036: SIM; G-ZONA-LIVRE ativo; deny-by-default da zona livre por construcao."
  - "🟢 BRANCH PROTECTION BIOMETRICA ARMADA — main com ruleset Active: require PR, restrict deletions, block force pushes; passkey Touch ID como gate do boundary."
  - "🟢 CARTAO DE ENTRADA UNIVERSAL DEPOSITADO — .hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md versionado como candidato a core/cartao-entrada.md."
  - "🟡 DIVIDA RASTREADA — marcador zona_livre_curada auto-declarado; hardening futuro: banir docs/brainstorm/** de todo files_allowed exceto onda de curadoria dedicada."
  - "🟡 PRÓXIMA AÇÃO — arvores registry-centric (coluna arvore no REGISTRY), depois freeze + tag v1-estavel."
  - "🟢 W3 ENTREGUE — G-ZONA-LIVRE ativo no runner; docs/brainstorm/** exige zona_livre_curada: true + zona_livre_nota nao-vazio no readback ativo."
  - "🟢 TESTES W3 VERDES — run-guard-tests fechou 178/178; adversarial-battery bloqueou B1-B33, incluindo B33 docs/brainstorm sem curadoria."
  - "🟢 CROSS-AUDIT W3 CONCLUIDO — quatro pareceres depositados: Grok 20:36, Grok 21:08, Antigravity 100 e Cursor 92."
  - "🟢 GRANDE SELAGEM 0035 CONCLUIDA — readback 0035, knowledge 0024/0025, proposta arvores+MVP, oito pareceres cross-audit, STATE e handoff selados."
  - "🟢 P-CAND-04 RATIFICADO E SELADO — Cursor registrou APROVA_0033: SIM; Grok registrou APROVA_0033: NAO, resolvido pelo W2 fail-closed de G-SCRATCH."
  - "🟢 W2 RATIFICADO E SELADO — Grok+Antigravity registraram APROVA_0034: SIM; cinco bypasses fechados: G-KNOW token-match/anti-ponteiro-morto, G-FRONTDOOR bytes/contagem/existencia, G-EXC ultimo-paragrafo, G-SCRATCH fail-closed, comentario G-REG."
  - "🟢 COMMIT-POLLUTION REMOVIDA — cfe9c33 (fixture --no-verify de auditor) foi removido por reset humano para 635e01b antes desta selagem."
  - "🟢 KNOWLEDGE 0024/0025 INDEXADAS — zona livre exige aprovacao humana explicita; auditor cruzado e read-only e nao usa --no-verify na branch de trabalho."
  - "🟡 PLANO MVP — arvores registry-centric leve; sequencia hardening->deny->freeze; W3 = deny-by-default (G-ZONA-LIVRE) sobre base endurecida."
  - "🟢 GATE DO BOUNDARY ARMADO — branch protection biometrico ativo na main; futura chave G-HRB continua pendente."
  - "🟢 W2 SELADO — hardening dos guards concluido e ratificado: G-KNOW-INDEX token inteiro + anti-ponteiro-morto; G-FRONTDOOR teto bytes + read-list robusta + existencia; G-EXC trailers no ultimo paragrafo; G-SCRATCH fail-closed sem active-version; comentario G-REG corrigido."
  - "🟢 TESTES W2 VERDES — run-guard-tests fechou 175/175; adversarial-battery bloqueou B1-B32, incluindo B29, B30, B31 e B32."
  - "🟢 P-CAND-04 SELADO — area temporaria /scratch/ foi ratificada e selada junto com W2 na grande selagem 0035."
  - "🟡 PRÓXIMA AÇÃO — W3 deny-by-default (G-ZONA-LIVRE) sobre base endurecida."
  - "🟢 P-CAND-04 RATIFICADO — area temporaria /scratch/ ativa: .gitignore ignora /scratch/ e versiona somente scratch/README.md como contrato de uso."
  - "🟢 G-SCRATCH ATIVOS — guards/assert-scratch-lock.sh, guards/assert-scratch-symlink.sh e guards/assert-scratch-ignore.sh entraram bloqueantes no runner."
  - "🟢 TESTES P-CAND-04 VERDES — run-guard-tests fechou 165/165; adversarial-battery bloqueou B1-B28, incluindo B26 arquivo em scratch/, B27 symlink em scratch/ e B28 .gitignore sem /scratch/."
  - "🟡 PRÓXIMA AÇÃO HISTÓRICA PAGA — cross-audit P-CAND-04 concluido; agora W3 deny-by-default da zona livre."
  - "🟢 S3.2 SELADA — porta da frente ativa: core/role-cards.md + G-FRONTDOOR; Cursor registrou APROVA_0031: SIM com confiança 90/100 e Gemini/Antigravity registrou APROVA_0031: SIM com confiança 100/100."
  - "🟢 DÍVIDA HARDENING PAGA — W2 fechou G-KNOW-INDEX substring/ponteiro-morto, G-FRONTDOOR bytes/contagem/existencia, G-EXC ultimo-paragrafo, G-SCRATCH fail-closed e comentario G-REG."
  - "🟢 P-CAND-04 EXECUTADA — a antiga proxima acao de implementar area temporaria foi entregue nesta onda."
  - "🟢 S3.2 ENTREGUE — porta da frente ativa em core/role-cards.md: read-list de 6 itens + tres cartoes curtos por papel, apontando para specs sem duplicar."
  - "🟢 G-FRONTDOOR ATIVO — guards/assert-frontdoor.sh entrou bloqueante no runner; falha fechado se core/role-cards.md ausente/ilegivel, >140 linhas ou read-list >6."
  - "🟢 TESTES S3.2 VERDES — run-guard-tests fechou 160/160; adversarial-battery bloqueou B1-B25, incluindo B25 role-cards inflado/read-list estourada."
  - "🟢 S3.1 SELADA — G-KNOW-INDEX segue ativo no runner; knowledge 0023 foi indexada e selada; pareceres Gemini/Cursor, despacho e brainstorm foram versionados."
  - "🟢 INDEX VIVO DA KNOWLEDGE — qualquer .hbn/knowledge/*.md, exceto INDEX.md, precisa aparecer citado pelo basename no INDEX; ausencia/ilegibilidade do INDEX falha fechado; estado atual: 11 entradas."
  - "🟢 DÍVIDA G-KNOW-INDEX PAGA — W2 trocou substring por token inteiro e bloqueou ponteiro-morto INDEX->arquivo."
  - "🟡 DECISÃO AREA TEMPORARIA — P-CAND-04 convergiu no cross-audit: tmp do ambiente primeiro; scratch/ no repo so em onda propria com gitignore + guards anti-stage/symlink/ignore."
  - "🟡 NOTA DE CONTINUIDADE — proximo orquestrador deve ler STATE + handoff + core/role-cards.md e seguir a read-list da porta da frente."
  - "🟢 S2 + FAXINA 0027 FECHADOS — S2 foi ratificada e selada; faxina 0027 foi ratificada por Cursor e Gemini/Antigravity com APROVA_0027: SIM e selada na micro-onda 0028."
  - "🟢 S2 RATIFICADA E SELADA — Gemini registrou APROVA_S2: SIM com confiança 100/100; Cursor registrou APROVA_S2: SIM com confiança 90/100; pareceres e despachos foram depositados nesta micro-onda."
  - "🟢 FAXINA 0027 RATIFICADA E SELADA — pareceres Cursor/Gemini depositados, tres despachos do orquestrador selados, brainstorm versionado e fixes lixo-zero aplicados sem mudar logica de guard."
  - "🟢 DÍVIDA H RESOLVIDA — G-EXC em CI agora le mensagem bruta (%B), igual ao commit-msg local; run-guard-tests fechou 154/154 e adversarial-battery bloqueou B1-B23."
  - "🟢 D2 RESOLVIDA — scratch de guards/tests coberto por .gitignore (cr-*, adv-cr*, tmp-pass.*, wt-main.*) e diretorios remanescentes removidos best-effort."
  - "🟡 DÍVIDA RASTREADA PARA HARDENING — G-EXC ainda aceita prosa iniciada por 'HBN-...:' no corpo porque valida %B inteiro; destino: restringir a busca ao ultimo paragrafo/trailer block em onda propria."
  - "🟡 CONVENÇÃO RASTREADA — todo handoff de onda deve estar no files_allowed do readback; o lapso do handoff 0027 fica registrado e a 0028 incluiu seu handoff no escopo."
  - "🟢 B19 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B19: SIM e CLASSE FECHADA: SIM; classe symlink/meta-path FECHADA apos B17+B18+B19; hardlink = non-issue (git 100644); proxima onda: S2 (dispatch schema)."
  - "🟢 B18 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B18: SIM; symlink staged sob .hbn/** segue bloqueado por modo git 120000 antes da dispensa de meta-path; run-guard-tests 141/141 e adversarial-battery B1-B18 verdes."
  - "🟢 B17 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B17: SIM; meta-paths em guards/assert-scope-lock.sh auto-permitem somente .json/.md com basename ADR-025, hearback do readback ativo ou nome-endereco conhecido."
  - "🟢 S1 RATIFICADO E SELADO — assert-scope-lock endurecido contra auto-emenda de files_allowed; cross-audit Gemini+Cursor registrou APROVA_S1: SIM."
  - "🟢 REESTRUTURAÇÃO M-A+S0 SELADA — linha limpa proposta/reestruturacao-m-a-s0 @ 5a0587d; tree 61fa290e ancorada por tag."
  - "🟢 CROSS-AUDIT SIM — Cursor e Gemini 3.5 registraram APROVA_REESTRUTURACAO: SIM para o Modelo B."
  - "🟢 EXCEÇÃO F-01 ENCERRADA NESTA SELAGEM — C5 devolve o bastao ao orquestrador e nao deixa implementador ativo igual ao agente do readback."
  - "🔴 PONTE VETADA — 0034 Codex e 0035 Antigravity retornaram VETO_ADOCAO: SIM; corrigir bloqueadores antes de descongelar."
  - "🔴 ATIVAÇÃO DA EXÚVIA BLOQUEADA — Fitness Gate pendente: baseline funcional + Ponte verde + confronto incumbente×desafiante."
  - "🟡 D-ORQ-WRITE NÃO HABILITADA — doutrina no replay; escrita do orquestrador e G-ACTOR-WRITE-MATRIX seguem para rito futuro."
  - "🟡 G-HRB assinatura PENDENTE DE CHAVE — Maurício gera/registra .hbn/operators/<nome>.pub para ativar ssh-keygen -Y verify."
  - "🟡 F-02 (0035 UTC×REGISTRY) NÃO corrigido — formato da linha superseded_by segue decisão humana."
  - "🟢 branch protection no GitHub: ruleset Active na main (require PR, restrict deletions, block force pushes); passkey Touch ID no boundary."
  - "🟡 backlog preservado — bump 0.3.1, hearback 0002, inbox/credenciamento e versionamento de readbacks ficam para ondas futuras."
readback_ativo: ".hbn/readbacks/0095-w-freeze-fechamento.json"
handoff_mais_recente: ".hbn/messages/20260626-010000-opus-4-8-despacho-w-freeze-fechamento.md"
ancora_rollback: "evidencia/reestruturacao-m-a-s0-tree-equivalent -> 5a0587d (tree 61fa290e; rollback da selagem ao replay limpo)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "W-RET PROPOSTO — readback 0067; canal de retorno A+C entregue; parar para cross-audit != OpenAI e hearback antes de selar."
ultima_atualizacao: "2026-06-26T01:00:00-03:00"
atualizado_por: codex-despromocao-p6-0086
atribuicao:
  chapeu_atual: orquestrador
  implementador: codex
  auditores: [grok, antigravity]
  gravada_em: "2026-06-20T10:00:00-03:00"
  hearback_ref: "Mauricio 2026-06-21T10:00:00-03:00: implementacao Despromocao-P6 autorizada sob token_fp 34a7f2f9; atualizar G-ARVORE-LABEL/testes/STATE/REGISTRY/readback, regenerar atestacao same-fp, escrever RETURN.json ao final, parar para cross-audit != OpenAI + hearback; nao selar, nao iniciar W-FREEZE."
---

Nota W-ORQ-4a / readback 0074: entregue em 2026-06-21T00:30:00-03:00.
G-READLIST-RITE adiciona `guards/assert-readlist-rite.sh` ao runner para
bloquear qualquer A/M em `core/read-list-canonica.txt` que nao traga, no mesmo
diff, readback staged com `read_list_rite` string nao-vazia e
`human_status: confirmed`. Proxima acao: cross-audit W-ORQ-4a por familias !=
OpenAI; nao selar e nao iniciar outras facetas de W-ORQ-4/W-FREEZE.

Nota W-RET / readback 0067: entregue em 2026-06-20T10:00:00-03:00.
W-RET documenta o canal de retorno A+C em `core/relay-return-spec.md`: todo
implementador escreve `.hbn/relay/RETURN.json` ao final de qualquer execucao,
o consumidor le e descarta/move o recibo, e ausencia de recibo novo apos
timeout T e erro do harness. `.gitignore` mantem o recibo e a inbox efemeros
fora do versionamento. Proxima acao: cross-audit W-RET; nao iniciar W-ORQ-4
nem W-FREEZE.

Nota G-NEXT / readback 0066: entregue em 2026-06-19T14:00:00-03:00.
G-NEXT adiciona `guards/assert-next-checkpoint.sh` e o ativa no runner para
exigir que todo commit com `.hbn/relay/STATE.md` adicionado/modificado carregue
exatamente um `proximo_ponto` top-level no front-matter, com campos canonicos,
destino canonico e `bloco_ref` existente no indice/HEAD. O guard e
PROPOSED_UNTIL_CROSS_AUDIT: exige suite verde, cross-audit >=2 familias !=
OpenAI e hearback humano antes de selagem posterior. Evidencia
mecanica: runner verde, `run-guard-tests.sh` 233/233 e
`adversarial-battery.sh` B1-B67 bloqueada, incluindo B63-B67. Proxima acao:
cross-audit G-NEXT; nao iniciar W-ORQ-4 nem W-FREEZE.

Nota selagem G-COPY / readback 0065: concluida em 2026-06-19T13:00:00-03:00.
G-COPY fica SELADO E VIGENTE por duplo APROVA_0064 de familias !=-OpenAI:
antigravity/Google e grok/xAI. Os dois pareceres canonicos foram tornados
tracked, o despacho de selagem 0065 foi depositado, e a atestacao
`.hbn/attestations/34a7f2f9-orq-entrada.json` foi regenerada same-fp contra os
blobs staged com `readback_ativo` resolvendo para 0065. Esta selagem dogfooda o
G-ORQ-REF corrigido (Exit A') sem bypass. Proxima acao: W-ORQ-4 conforme §6 do
cartao Fase B; W-FREEZE nao foi iniciado neste commit.

Nota G-COPY / readback 0064: entregue em 2026-06-18T21:45:00-03:00.
G-COPY adiciona `guards/assert-copy-block.sh` e o ativa no runner para exigir,
em despachos/prompts novos adicionados, exatamente um bloco `HBN-COPY` com
destino canonico e payload nao-vazio. O guard e PROPOSED_UNTIL_CROSS_AUDIT:
exige suite verde, cross-audit >=2 familias != OpenAI e hearback humano antes
da selagem em readback posterior. Evidencia mecanica: runner verde,
`run-guard-tests.sh` 227/227 e `adversarial-battery.sh` B1-B62 bloqueada,
incluindo B55-B62. Proxima acao: cross-audit G-COPY; nao iniciar W-ORQ-4 nem
W-FREEZE.

Nota selagem W-ORQ-3b / readback 0063: concluida em 2026-06-18T21:03:14-03:00.
W-ORQ-3b fica SELADO E VIGENTE por duplo APROVA_0062 de familias !=-OpenAI:
antigravity/Google e grok/xAI canonico via re-prompt. O parecer grok 184500
traz apelido canonico no nome/SOU/autor, `path:` real e uma linha isolada
`APROVA_0062: SIM`; os pareceres grok nao-canonicos 182500/183600 ficam
zona-livre. O parecer antigravity 151334 e o cartao de entrada Fase B foram
tornados tracked. Esta
selagem dogfooda o G-ORQ-REF corrigido: o ato de autoridade referencia
`.hbn/attestations/34a7f2f9-orq-entrada.json`, e a atestacao foi regenerada
same-fp contra os blobs staged com `readback_ativo` resolvendo para 0063.
Proxima acao: parar e aguardar novo despacho; W-ORQ-4/W-FREEZE nao foram
iniciados nesta selagem.

Nota W-ORQ-3 / readback 0061: entregue em 2026-06-18T12:18:42-03:00.
G-ORQ-REF foi criado em `guards/assert-orq-entrada-ref.sh` e registrado no
runner apos `assert-dispatch-integrity.sh`. O guard atua somente sobre atos de
autoridade do orquestrador: despacho (`.hbn/dispatch/*.md`), selagem
(readback com marcador/estado/nome de selagem) e freeze (`.hbn/freeze/*.json`).
Para esses atos, exige `orq_entrada_ref` no readback/freeze-json em curso,
compara com `.hbn/attestations/<fp>-orq-entrada.json` derivado do
`bastao_token_sha256` do STATE, verifica existencia no indice/HEAD e reusa
`guards/assert-orq-entrada.sh` para validar a atestacao vigente. Re-pin da
atestacao no mesmo commit de ato de autoridade bloqueia. Evidencia mecanica:
`bash guards/tests/run-guard-tests.sh` fechou `208 passaram, 0 falharam`;
`bash guards/tests/adversarial-battery.sh` bloqueou B1-B51, incluindo B48-B51
para ref omitido, dangling, fp trocado e auto-repin. A entrega nao sela o
guard: proxima acao e cross-audit >=2 familias != OpenAI com `APROVA_0061:
SIM`, hearback humano de Mauricio e selagem em readback proprio 0062+.

Nota selagem G-ORQ-ENTRADA v2 / readback 0060: concluida em
2026-06-18T08:27:36-03:00. G-ORQ-ENTRADA v2 fica SELADO E VIGENTE por duplo
APROVA_0058: grok/xAI 92 e antigravity/Google 100, com hearback humano
Mauricio confirmado. Os dois pareceres 0058 foram tornados tracked e
registrados no REGISTRY com 7 colunas, temperatura frio e arvore fronteira.
Readback ativo passa a ser `.hbn/readbacks/0060-selagem-g-orq-entrada-v2.json`;
handoff mais recente passa a ser
`.hbn/messages/20260618-082736-codex-handoff-selagem-g-orq-v2.md`; a
atestacao `.hbn/attestations/34a7f2f9-orq-entrada.json` deve refletir os
blobs staged deste fechamento. Proxima acao: W-FREEZE, com recomendacao de
handoff para novo orquestrador antes do freeze.

Nota W-ORQ-2 / readback 0058: entregue em
2026-06-18T01:58:00-03:00. O guard G-ORQ-ENTRADA deixou de aceitar desafio
aberto com regex e passou a recomputar `orq-entrada.v2/extractive-lines` a
partir dos blobs do indice staged (`:path`), usando `HEAD:path` em CI com
`HBN_DIFF_BASE`. A atestacao v2 contem `manifest_sha256`,
`challenge.seed_sha256`, `challenge.line_responses` e
`challenge.field_responses`; o bloco legado D1-D4 foi removido. O gabarito
fisico `guards/data/orq-entrada-desafios.txt` foi eliminado. Evidencia
mecanica: `bash guards/tests/run-guard-tests.sh` fechou
`202 passaram, 0 falharam`; `bash guards/tests/adversarial-battery.sh`
bloqueou B1-B47, incluindo B45-B47. Proxima acao: cross-audit >=2 familias
!= OpenAI com `APROVA_0058`, depois hearback humano e selagem; nao selar piso
nu.

Nota G-ORQ-ENTRADA / readback 0056: entregue em
2026-06-18T00:33:00-03:00. O runner local agora chama
`guards/assert-orq-entrada.sh`; sob bastao de orquestrador, o guard localiza a
atestacao por FP do `bastao_token_sha256`, exige todos os 13 itens resolvidos
de `core/read-list-canonica.txt`, compara cada `blob_hash` com
`git hash-object <path>` no disco e valida D1-D4 contra
`guards/data/orq-entrada-desafios.txt`. Evidencia mecanica:
`bash guards/tests/run-guard-tests.sh` fechou `200 passaram, 0 falharam` e
`bash guards/tests/adversarial-battery.sh` bloqueou B1-B44, incluindo B41-B44.
Curadoria 0055 fica PENDENTE por decisao humana, nao abandonada; G-ORQ-ENTRADA
teve prioridade.

Nota curadoria dossie pre-transicao / readback 0055: entregue em
2026-06-17T23:32:46-03:00. O dossie de pre-transicao ficou tracked nos
relatorios `00-06` e `../SINTESE-PROFUNDA-pre-freeze.md`; `00-INDICE.md`
passou a conter o mapa auditavel dos temas minimos a-g de R-PT5:
a=SINTESE, b=01, c=02, d=03, e=01, f=04, g=05; `06` e meta/proposta e nao
conta como tema. REGISTRY recebeu linhas 7-col com `arvore=fronteira` e
`temperatura=frio` para cada arquivo do dossie. Evidencia mecanica: runner
verde antes de cada commit; `bash guards/tests/run-guard-tests.sh` fechou
`195 passaram, 0 falharam`; `bash guards/tests/adversarial-battery.sh` fechou
B1-B40 bloqueadas; `.venv/bin/pytest -q` fechou `213 passed`; `main`
permanece em `4db692876381a0d7909985c8500d999f2e677b04`. Fora de escopo
preservado: `main`, `guards/**`, `src/**`, `core/**`, `methodology/**`,
`schemas/**`, `.hbn/freeze/**` e todo `docs/brainstorm/**` fora da lista.
Proxima acao: cross-audit ≠-OpenAI do readback 0055, depois hearback humano
+ selagem antes do W-FREEZE.

Nota curadoria dossie pre-transicao / readback 0055: aberta em
2026-06-17T23:22:30-03:00. A onda torna tracked o dossie de pre-transicao e
fecha R-PT5 com cobertura auditavel dos temas a-g no `00-INDICE.md`, antes do
W-FREEZE. Escopo restrito aos paths exatos do readback 0055; `docs/brainstorm/**`
esta liberado somente nesta curadoria, com `zona_livre_curada:true` e nota
explicita. A excecao G-EXC segue proposta e visivel porque
implementador=codex coincide com o agente do readback 0055 autorizado por
Mauricio. Fora de escopo preservado: `main`, `guards/**`, `src/**`, `core/**`,
`methodology/**`, `schemas/**`, `.hbn/freeze/**` e todo `docs/brainstorm/**`
fora da lista. Proxima acao: C2 adicionar o mapa R-PT5 no indice.

Nota selagem R3b G-DIVERSITY / readback 0054: concluida em
2026-06-17T23:15:00-03:00. R3b G-DIVERSITY fica SELADA e vigente: o readback
0053 foi ratificado por dois pareceres cross-audit de familias distintas de
OpenAI, antigravity/Google `APROVA_0053: SIM` com confianca 100/100 e
grok/xAI `APROVA_0053: SIM` com confianca 95. Os dois pareceres foram
versionados em `.hbn/results/` e registrados no REGISTRY com 7 colunas e
`arvore=fronteira`; G-AUDITOR-ID aprovou os dois e G-DIVERSITY validou a
diversidade Google+xAI != OpenAI. Evidencia mecanica: runner verde antes de
cada commit; `bash guards/tests/run-guard-tests.sh` fechou `195 passaram, 0
falharam`; `bash guards/tests/adversarial-battery.sh` fechou B1-B40
bloqueadas; `.venv/bin/pytest -q` fechou `213 passed`; `main` permanece em
`4db692876381a0d7909985c8500d999f2e677b04`. Hardening pre-freeze concluido
para R3a+R3b; R3c G-REG-M geral segue como C-DEBT aceita. Fora de escopo
preservado: `main`, `guards/**`, `src/**`, `core/**`, `methodology/**`,
`schemas/**` e `docs/brainstorm/**`. Proxima acao: W-FREEZE; recomendacao de
handoff para novo orquestrador antes do freeze.

Nota selagem R3b G-DIVERSITY / readback 0054: aberta em
2026-06-17T23:00:00-03:00. A onda sela a R3b G-DIVERSITY (readback 0053)
apos dois pareceres cross-audit de familias distintas de OpenAI verificados no
disco com SOU canonico: antigravity/Google `APROVA_0053: SIM` com confianca
100/100 e grok/xAI `APROVA_0053: SIM` com confianca 95. Escopo restrito:
readback 0054, os dois pareceres em `.hbn/results/`, REGISTRY 7-col com
`arvore=fronteira`, STATE e handoff. A excecao G-EXC segue proposta e visivel
porque implementador=codex coincide com o agente do readback 0054 autorizado
por Mauricio; os trailers HBN devem ficar contiguos em todos os commits desta
selagem. Fora de escopo preservado: `main`, `guards/**`, `src/**`, `core/**`,
`methodology/**`, `schemas/**` e `docs/brainstorm/**`. Proxima acao: C2 tornar
tracked os dois pareceres; C3 encerrar STATE/handoff e devolver o bastao ao
orquestrador.

Nota R3b G-DIVERSITY / readback 0053: entregue operacionalmente em
2026-06-17T22:35:01-03:00. Entregas: `guards/assert-audit-diversity.sh`
criado como guard fail-closed; runner integra G-DIVERSITY apos G-AUDITOR-ID;
`guards/tests/run-guard-tests.sh` subiu para `195 passaram, 0 falharam`; a
bateria adversarial ganhou B40 e bloqueia selagem com diversidade
insuficiente; knowledge 0028 foi depositada e indexada. Evidencia mecanica:
runner verde antes de cada commit; `bash guards/tests/run-guard-tests.sh`
fechou `195 passaram, 0 falharam`; `bash guards/tests/adversarial-battery.sh`
fechou B1-B40 bloqueadas; `.venv/bin/pytest -q` fechou `213 passed`; `main`
permanece em `4db692876381a0d7909985c8500d999f2e677b04`. R3c G-REG-M geral
fica registrada como C-DEBT aceita para freeze. Fora de escopo preservado:
`main`, `src/**`, `core/**`, `methodology/**`, `schemas/**`,
`guards/assert-auditor-id.sh`, `guards/assert-exception-traceable.sh` e
`docs/brainstorm/**`. Proxima acao: cross-audit ≠-OpenAI + hearback +
selagem; depois W-FREEZE.

Nota R3b G-DIVERSITY / readback 0053: aberta em
2026-06-17T22:30:01-03:00. A onda adiciona guard aditivo de diversidade de
familia na selagem: para cada readback auditado por result cross-ia adicionado,
devem existir pelo menos duas familias distintas de auditores, ambas
diferentes da familia do implementador, com `APROVA_<NNNN>: SIM`. O guard
reusa somente leitura de `guards/data/auditor-families.txt`, nao modifica
G-AUDITOR-ID nem G-EXC, e mantém R3c G-REG-M geral como divida aceita para o
freeze. Fora de escopo preservado: `main`, `src/**`, `core/**`,
`methodology/**`, `schemas/**`, `guards/assert-auditor-id.sh`,
`guards/assert-exception-traceable.sh` e `docs/brainstorm/**`. Proxima acao:
C2 implementar `guards/assert-audit-diversity.sh` e integrar no runner.

Nota selagem R3a G-TRAILERS / readback 0052: concluida em
2026-06-17T22:05:00-03:00. R3a G-TRAILERS fica SELADA e vigente: o readback
0051 foi ratificado por dois pareceres cross-audit de familias distintas de
OpenAI, grok/xAI `APROVA_0051: SIM` e antigravity/Google `APROVA_0051: SIM`,
ambos verificados no disco com SOU canonico nas 12 primeiras linhas. Os dois
pareceres foram versionados em `.hbn/results/` e registrados no REGISTRY com
7 colunas e `arvore=fronteira`; o G-AUDITOR-ID aprovou os dois no C2.
Evidencia mecanica: runner verde antes de cada commit; `bash
guards/tests/run-guard-tests.sh` fechou `191 passaram, 0 falharam`; `bash
guards/tests/adversarial-battery.sh` fechou B1-B39 bloqueadas; `.venv/bin/pytest -q`
fechou `213 passed`; `main` permanece em
`4db692876381a0d7909985c8500d999f2e677b04`. Fora de escopo preservado:
`main`, `guards/**`, `src/**`, `core/**`, `methodology/**`, `schemas/**` e
`docs/brainstorm/**`. Proxima acao: R3b Camada 2 do G-AUDITOR-ID.

Nota selagem R3a G-TRAILERS / readback 0052: aberta em
2026-06-17T22:00:00-03:00. A onda sela o readback 0051 apos dois pareceres
cross-audit de familias distintas de OpenAI verificados no disco com SOU
canonico: grok/xAI `APROVA_0051: SIM` e antigravity/Google
`APROVA_0051: SIM`. Escopo restrito: readback 0052, os dois pareceres em
`.hbn/results/`, REGISTRY 7-col com `arvore=fronteira`, STATE e handoff. A
excecao G-EXC segue proposta e visivel porque implementador=codex coincide
com o agente do readback 0052 autorizado por Mauricio; os trailers HBN devem
ficar contiguos em todos os commits desta selagem. Fora de escopo preservado:
`main`, `guards/**`, `src/**`, `core/**`, `methodology/**`, `schemas/**` e
`docs/brainstorm/**`. Proxima acao: C2 tornar tracked os dois pareceres.

Nota R3a G-TRAILERS / readback 0051: entregue operacionalmente em
2026-06-17T21:10:38-03:00. Entregas: `guards/assert-trailers-contiguous.sh`
criado como guard aditivo fail-closed para commits governados; runner ganhou
modo `--commit-msg` e acionamento de G-TRAILERS em CI com `HBN_DIFF_BASE`;
`guards/tests/run-guard-tests.sh` subiu para 191/191 com 4 casos novos; a
bateria adversarial ganhou B39 e bloqueia o gap `implementador=null` +
trailers nao-contiguos; knowledge 0027 foi depositada e indexada. Evidencia
mecanica local: runner verde antes de cada commit; modo `commit-msg` verde
desde C2 com G-TRAILERS; `bash guards/tests/run-guard-tests.sh` fechou
`191 passaram, 0 falharam`; `bash guards/tests/adversarial-battery.sh` fechou
B1-B39 bloqueadas; `.venv/bin/pytest -q` fechou `213 passed`; `main` permanece
em `4db692876381a0d7909985c8500d999f2e677b04`. Fora de escopo preservado:
`main`, `src/**`, `core/**`, `methodology/**`, `schemas/**`,
`guards/assert-exception-traceable.sh` e `docs/brainstorm/**`. Proxima acao:
cross-audit ≠-OpenAI do G-TRAILERS + hearback humano + selagem; depois R3b
Camada 2 do G-AUDITOR-ID.

Nota R3a G-TRAILERS / readback 0051: aberta em
2026-06-17T20:58:00-03:00. A onda adiciona um guard aditivo para exigir os
3 trailers HBN contiguos no ultimo paragrafo de todo commit que toca path
governado, independente do campo `implementador` no STATE. O objetivo e
fechar a divida observada na meta-validacao R1: com `implementador: null`, o
G-EXC ficava inativo e commits governados com trailers nao-contiguos passavam.
Fora de escopo preservado: `main`, `src/**`, `core/**`, `methodology/**`,
`schemas/**`, `guards/assert-exception-traceable.sh` e `docs/brainstorm/**`.
Proxima acao: C2 implementar `guards/assert-trailers-contiguous.sh` e a
integracao no ponto commit-msg/CI.

Nota selagem R2 arvores / readback 0050: concluida em
2026-06-17T19:33:00-03:00. R2 arvores registry-centric fica SELADA e vigente:
o readback 0049 foi ratificado por dois pareceres cross-audit de familias
distintas de OpenAI, grok/xAI `APROVA_0049: SIM` conf 93 e
antigravity/Google `APROVA_0049: SIM` conf 100, ambos verificados no disco com
SOU canonico. `core/arvores-spec.md` foi ratificada com `status: accepted`,
sem mexer no corpo nem na linha original de arvore do REGISTRY. Os dois
pareceres foram versionados em `.hbn/results/` e registrados no REGISTRY com
7 colunas e `arvore=fronteira`; o proprio G-AUDITOR-ID aprovou os dois no C3.
Evidencia mecanica: runner verde antes de cada commit; `bash
guards/tests/run-guard-tests.sh` fechou `187 passaram, 0 falharam`; `bash
guards/tests/adversarial-battery.sh` fechou `BATERIA VERDE` com B1-B38
bloqueadas; `.venv/bin/pytest -q` fechou `213 passed`; `main` permanece em
`4db692876381a0d7909985c8500d999f2e677b04`. Fora de escopo preservado:
`main`, `guards/**`, `src/**`, `methodology/**`, `schemas/**`, outras specs
de `core/**` e `docs/brainstorm/**`. Proxima acao: promocao demonstrativa dos
artefatos R2 para intermediaria OU curadoria dos 4 batch1 OU R3 — decisao do
orquestrador.

Nota selagem R2 arvores / readback 0050: aberta em
2026-06-17T19:30:00-03:00. A onda sela R2 arvores registry-centric (readback
0049) apos dois pareceres cross-audit de familias distintas de OpenAI
verificados no disco com SOU canonico: grok/xAI `APROVA_0049: SIM` conf 93 e
antigravity/Google `APROVA_0049: SIM` conf 100. Escopo restrito: readback
0050, `core/arvores-spec.md` somente para `status: proposed` ->
`status: accepted`, os dois pareceres em `.hbn/results/`, REGISTRY, STATE e
handoff. As linhas novas de REGISTRY desta selagem usam 7 colunas com
`arvore=fronteira`; promocao para `intermediaria` fica para onda propria.
Excecao G-EXC segue proposta e visivel porque implementador=codex coincide
com o agente do readback 0050 autorizado por Mauricio. Fora de escopo
preservado: `main`, `guards/**`, `src/**`, `methodology/**`, `schemas/**`,
outras specs de `core/**` e `docs/brainstorm/**`. Proxima acao: C2 ratificar
a spec; C3 tornar tracked os dois pareceres; C4 encerrar STATE/handoff.

Nota R2 arvores registry-centric / readback 0049: entregue operacionalmente em
2026-06-17T18:45:00-03:00. Entregas: `core/arvores-spec.md` registry-centric
sem front-matter `arvore:`, bloco REGISTRY going-forward com 7 colunas,
`guards/assert-registry-line.sh` column-aware e exigindo `arvore` valida para
nascimento novo, `guards/assert-parallel-id.sh` lendo `created_at` como ultima
coluna em blocos 6-col e 7-col, e `guards/assert-arvore-label.sh` ativo no
runner contra mislabel intermediaria/estavel e contra `estavel` nao-quente.
Evidencia mecanica local: runner verde; `bash guards/tests/run-guard-tests.sh`
fechou `187 passaram, 0 falharam`; `bash guards/tests/adversarial-battery.sh`
fechou `BATERIA VERDE` com B38 bloqueada; `.venv/bin/pytest -q` fechou
`213 passed`. Fora de escopo preservado: `main`, `src/**`, `methodology/**`,
`schemas/**`, outras specs de `core/**`, `docs/brainstorm/**`, selagem dos 4
batch1-fronteira, extensao G-REG para M geral, Camada 2 do G-AUDITOR-ID e
exuvia. Proxima acao: cross-audit ≠-OpenAI + hearback + selagem do R2; depois
curadoria dos 4 batch1-fronteira; depois R3/freeze.

Nota R2 arvores registry-centric / readback 0049: aberta em
2026-06-17T18:40:00-03:00. A onda implementa o mecanismo registry-centric de
arvores: coluna `arvore` no REGISTRY going-forward, spec curta
`core/arvores-spec.md`, G-REG column-aware com `arvore` obrigatoria para
artefato novo, G-NUM column-aware para `created_at` em blocos 6-col e 7-col, e
G-ARVORE-LABEL anti-mislabel. Excecao G-EXC segue proposta e visivel porque
implementador=codex coincide com o agente do readback 0049 autorizado por
Mauricio. Fora de escopo preservado: `main`, `src/**`, `methodology/**`,
`schemas/**`, outras specs de `core/**`, `docs/brainstorm/**`, selagem dos 4
batch1-fronteira, extensao G-REG para M geral, Camada 2 do G-AUDITOR-ID e
exuvia. Nota de bootstrap: `assert-parallel-id.sh` precisa ler `created_at`
como ultima coluna ja no C1; sem isso, a primeira linha 7-col do REGISTRY
ficaria bloqueada pelo G-NUM legado.

Nota selagem G-AUDITOR-ID / readback 0048: concluida em
2026-06-17T16:17:30-03:00. O G-AUDITOR-ID fica SELADO e vigente: o readback
0047 foi ratificado por dois pareceres cross-audit de familias distintas de
OpenAI, antigravity/Google `APROVA_0047: SIM` conf 100 e grok/xAI
`APROVA_0047: SIM` conf 95, ambos verificados no disco com SOU canonico. Os
dois pareceres foram versionados em `.hbn/results/` com front matter `path:`
e linhas G-REG; no C2, `guards/assert-auditor-id.sh` aprovou ambos como
primeiro dogfood real. Evidencia mecanica: runner C2 verde incluindo
`assert-auditor-id`; `bash guards/tests/run-guard-tests.sh` fechou
`183 passaram, 0 falharam`; `bash guards/tests/adversarial-battery.sh`
fechou `BATERIA VERDE` com B1-B37 bloqueadas; `.venv/bin/pytest -q` fechou
`213 passed in 0.98s`; `main` permanece em
`4db692876381a0d7909985c8500d999f2e677b04`. Fora de escopo preservado:
`main`, `guards/**`, `src/**`, `core/**`, `schemas/**`, `methodology/**` e
`docs/brainstorm/**`. Proxima acao: decisao do orquestrador entre Camada 2
(diversidade), R2 arvores registry-centric ou mais P0.

Nota selagem G-AUDITOR-ID / readback 0048: aberta em
2026-06-17T16:12:00-03:00. A onda sela o G-AUDITOR-ID (readback 0047) apos
dois pareceres cross-audit de familias distintas de OpenAI verificados no
disco com SOU canonico: antigravity/Google `APROVA_0047: SIM` conf 100 e
grok/xAI `APROVA_0047: SIM` conf 95. Escopo restrito: readback 0048, os dois
pareceres em `.hbn/results/`, REGISTRY, STATE e handoff. Excecao G-EXC segue
proposta e visivel porque implementador=codex coincide com o agente do
readback 0048 autorizado por Mauricio. Fora de escopo preservado: `main`,
`guards/**`, `src/**`, `core/**`, `schemas/**`, `methodology/**` e
`docs/brainstorm/**`. Proxima acao: C2 tornar os pareceres tracked e
registrar no REGISTRY; depois C3 encerrar STATE/handoff.

Nota G-AUDITOR-ID / readback 0047: entregue operacionalmente em
2026-06-17T15:41:09-03:00. A onda criou o mapa canonico
`guards/data/auditor-families.txt`, implementou `guards/assert-auditor-id.sh`
e ativou o guard no runner. O guard falha fechado para qualquer
`.hbn/results/*.md` adicionado sem nome canonico
`AAAAMMDD-HHMMSS-<apelido>-cross-ia-<onda>.md`, sem `SOU:` canonico nas
primeiras 12 linhas, com apelido divergente entre arquivo e `SOU:`, ou com
familia ausente/incoerente no mapa canonico. `guards/tests/run-guard-tests.sh`
ganhou 1 caso positivo + 4 negativos (183/183 verde) e
`guards/tests/adversarial-battery.sh` ganhou B34-B37 (B1-B37 verde). Knowledge
0026 foi depositada e indexada. Evidencia mecanica: `bash
guards/hbn-guards-runner.sh` verde; `bash guards/tests/run-guard-tests.sh` ->
`183 passaram, 0 falharam`; `bash guards/tests/adversarial-battery.sh` ->
`BATERIA VERDE`; `.venv/bin/pytest -q` -> `213 passed in 0.79s`; `main`
permanece em `4db692876381a0d7909985c8500d999f2e677b04`. Fora de escopo
preservado: `main`, `src/**`, `core/**`, `methodology/**`, `schemas/**`,
outros guards e `docs/brainstorm/**`. Proxima acao: cross-audit ≠-OpenAI do
G-AUDITOR-ID, depois hearback/selagem 0047, depois R2 arvores
registry-centric.

Nota G-AUDITOR-ID / readback 0047: aberta em
2026-06-17T15:28:22-03:00. A onda implementa a Camada 1 do G-AUDITOR-ID:
guard fail-closed para arquivos `.hbn/results/*.md` adicionados, exigindo
nome canonico, linha `SOU:` canonica nas primeiras 12 linhas, apelido coerente
entre arquivo e `SOU:` e familia canonica/coerente via
`guards/data/auditor-families.txt`. Camada 2 (contagem de diversidade) fica
fora de escopo. Excecao G-EXC segue proposta e visivel porque
implementador=codex coincide com o agente do readback 0047 autorizado por
Mauricio. Fora de escopo preservado: `main`, `src/**`, `core/**`,
`methodology/**`, `schemas/**`, outros guards e `docs/brainstorm/**`.
Proxima acao: C2 mapa de familias; depois C3 guard+runner, C4 testes, C5
knowledge 0026, C6 STATE/handoff.

Nota selagem Curadoria P0 / readback 0046: concluida em
2026-06-17T15:11:03-03:00. A Curadoria P0 fica SELADA: o readback 0045 foi
ratificado por dois pareceres cross-audit de familias distintas de OpenAI,
antigravity/Google `APROVA_0045: SIM` conf 98 e grok/xAI `APROVA_0045: SIM`
conf 95. A marginal aceita fica registrada: o texto do stub de
`docs/MATURITY-MATRIX.md` difere do proposto, mas remove conteudo stale e
redireciona para a fonte canonica. Os dois pareceres foram versionados em
`.hbn/results/` com front matter `path:` e linhas G-REG. Evidencia mecanica:
`.venv/bin/pytest -q` fechou `213 passed in 0.81s`; `bash
guards/tests/adversarial-battery.sh` fechou `BATERIA VERDE`; `main` permanece
em `4db692876381a0d7909985c8500d999f2e677b04`. Escopo preservado: `main`,
`guards/**`, `schemas/**`, `src/**`, `core/**`, `methodology/**`, outros docs
e `docs/brainstorm/**` nao foram alterados. Proxima acao: onda G-AUDITOR-ID;
depois R2 arvores registry-centric.

Nota selagem Curadoria P0 / readback 0046: aberta em
2026-06-17T13:00:00-03:00. A onda sela a Curadoria P0 (readback 0045) apos
dois pareceres cross-audit de familias distintas de OpenAI verificados no
disco: antigravity/Google `APROVA_0045: SIM` conf 98 e grok/xAI
`APROVA_0045: SIM` conf 95, ambos com linha SOU canonica. Escopo restrito:
readback 0046, os dois pareceres em `.hbn/results/`, REGISTRY, STATE e
handoff. Excecao G-EXC segue proposta e visivel porque implementador=codex
coincide com o agente do readback 0046 autorizado por Mauricio. Fora de escopo
preservado: `main`, `guards/**`, `schemas/**`, `src/**`, `core/**`,
`methodology/**`, outros docs e `docs/brainstorm/**`. Proxima acao: C2 tornar
os pareceres tracked e registrar no REGISTRY; depois C3 encerrar STATE/handoff.

Nota Curadoria P0 docs / readback 0045: entregue em
2026-06-17T11:35:00-03:00. A onda corrigiu `AGENTS.md` com o bloco aprovado
verbatim, criou `docs/GLOSSARY.md` como glossario canonico e reduziu
`docs/MATURITY-MATRIX.md` a stub de redirect para a fonte unica
`methodology/MATURITY-MATRIX.md`. REGISTRY recebeu linhas para readback,
STATE, glossario, redirect da matriz e handoff. Evidencia mecanica local:
`.venv/bin/pytest -q` fechou `213 passed in 0.75s`; `bash
guards/tests/adversarial-battery.sh` fechou `BATERIA VERDE`; links markdown
de `AGENTS.md` fecharam `checked=20, missing=NONE`; `main` permaneceu em
`4db692876381a0d7909985c8500d999f2e677b04`. Escopo preservado: `main`,
`guards/**`, `schemas/**`, `src/**`, `core/**`, `methodology/**`, outros
`docs/**` e `docs/brainstorm/**` nao foram alterados. Proxima acao:
cross-audit ≠-familia + selagem da Curadoria P0; depois R2 arvores
registry-centric.

Nota Curadoria P0 docs / readback 0045: aberta em
2026-06-17T11:30:00-03:00. A onda corrige a porta de entrada e docs canonicos:
substituir `AGENTS.md` pelo texto aprovado da proposta, criar
`docs/GLOSSARY.md`, reduzir `docs/MATURITY-MATRIX.md` a redirect e registrar
o necessario no REGISTRY. Excecao G-EXC segue proposta e visivel porque
implementador=codex coincide com o agente do readback 0045 autorizado por
Mauricio. Fora de escopo preservado: `main`, `guards/**`, `schemas/**`,
`src/**`, `core/**`, `methodology/**`, outros `docs/**` e
`docs/brainstorm/**`. Proxima acao: C2 aplicar `AGENTS.md` verbatim da
proposta; depois C3 glossario, C4 stub da matriz, C5 STATE/handoff.

Nota selagem Esteira / readback 0044: concluida em
2026-06-17T11:15:00-03:00. A Esteira de Pre-Transicao fica SELADA e vigente:
`core/esteira-pre-transicao.md` esta `status: accepted`, sem linha
`arvore:`, e o corpo da spec foi preservado. Os dois pareceres cross-audit
ficaram tracked e registrados no REGISTRY: antigravity/Google
`APROVA_0043: SIM` conf 100 e grok-build-0.1/xAI `APROVA_0043: SIM` conf 88.
Evidencia mecanica local: `.venv/bin/pytest -q` fechou `213 passed in 0.76s`;
`bash guards/tests/adversarial-battery.sh` fechou `BATERIA VERDE`; `main`
permaneceu em `4db692876381a0d7909985c8500d999f2e677b04`. Escopo preservado:
`main`, `guards/**`, `schemas/**`, `src/**`, outras specs de `core/` e
`docs/brainstorm/**` nao foram alterados. Proxima acao: curar dossie
pre-transicao + R2 arvores registry-centric.

Nota selagem Esteira / readback 0044: aberta em
2026-06-17T11:00:00-03:00. A onda sela a promocao da Esteira de
Pre-Transicao apos duplo APROVA_0043 nao-OpenAI: antigravity/Google registrou
`APROVA_0043: SIM` com confianca 100 e grok-build-0.1/xAI registrou
`APROVA_0043: SIM` com confianca 88 e marginal sobre `arvore: intermediaria`.
Escopo restrito: readback 0044, `core/esteira-pre-transicao.md` apenas para
os 2 ajustes autorizados, dois pareceres em `.hbn/results/`, REGISTRY, STATE
e handoff. Excecao G-EXC segue proposta e visivel porque implementador=codex
coincide com o agente do readback 0044 autorizado por Mauricio. Proxima acao:
C2 ratificar a spec (`status: accepted` e remocao de `arvore:`), C3 tornar os
pareceres tracked, C4 encerrar STATE/handoff e devolver o bastao ao
orquestrador.

Nota promocao Esteira de Pre-Transicao / readback 0043: concluida
operacionalmente em 2026-06-17T10:35:00-03:00. A spec
`core/esteira-pre-transicao.md` foi criada em status `proposed` com o conteudo
aprovado por Maurício, registrada no REGISTRY como `spec-core`, e nao altera
freeze-gate, schemas, guards, src, outras specs de core ou
`docs/brainstorm/**`. Evidencia local: `.venv/bin/pytest -q` fechou
`213 passed in 0.77s`; `bash guards/tests/adversarial-battery.sh` fechou
`BATERIA VERDE`. A proxima acao obrigatoria e cross-audit ≠-familia da spec;
so depois vem selagem 0043, curadoria do dossie de pre-transicao e R2.

Nota Esteira de Pre-Transicao / readback 0043: aberta em
2026-06-17T10:30:00-03:00. A onda promove a proposta de esteira para
`core/esteira-pre-transicao.md` como `spec-core` em status `proposed`, sem
alterar freeze-gate, schema, guards, src, outras specs de core ou
`docs/brainstorm/**`. O escopo autorizado fica restrito a readback 0043,
`core/esteira-pre-transicao.md`, REGISTRY, STATE e handoff. Excecao G-EXC segue
proposta e visivel porque implementador=codex coincide com o agente do
readback 0043 autorizado por Maurício. Proxima acao: criar a spec verbatim e
registrar no REGISTRY; depois atualizar STATE/handoff e devolver o bastao para
cross-audit ≠-familia.

Nota selagem R1-fix-2 / readback 0042: concluida em
2026-06-17T10:05:00-03:00. A micro-onda selou R1-fix-2 (readback 0041) apos
duplo APROVA_0041 nao-OpenAI: Grok/xAI registrou `APROVA_0041: SIM` com
confiança 95 e Antigravity/Google registrou `APROVA_0041: SIM` com confiança
100, ambos com prova engine-real ANTES/DEPOIS. Os dois pareceres foram
versionados em `.hbn/results/` e registrados no REGISTRY. Evidencia mecanica
local desta selagem: `.venv/bin/pytest -q` fechou `213 passed in 0.78s`;
`bash guards/tests/adversarial-battery.sh` fechou `BATERIA VERDE`; `main`
permaneceu em `4db692876381a0d7909985c8500d999f2e677b04`. Escopo preservado:
`main`, `src/**`, `guards/**`, `core/**`, `schemas/**` e `docs/brainstorm/**`
nao foram alterados. Excecao G-EXC segue proposta e visivel porque
implementador=codex coincide com o agente do readback 0042 autorizado por
Maurício. Proxima acao: promover Esteira de Pre-Transicao para core, curar o
dossie de pre-transicao e seguir R2 arvores registry-centric.

Nota R1-fix-2 / readback 0041: entregue em 2026-06-17. A onda corrigiu o
bloqueador provado apos a selagem R1-fix: `load_state_document` agora mantem
`executions`/`results` deduplicados por `execution_id`, mas deduplica
`decisions` por `(execution_id, category)` quando ha categoria e cai para
conteudo deterministico quando necessario, preservando registros distintos de
`context_history`. O teste engine-real cobre as tres decisions gravadas pelo
engine para uma execucao (`activation`, `validation`, `consent`) e falharia no
codigo pre-C2, que retornava apenas `activation`. Evidencia local:
`.venv/bin/pytest -q` fechou `213 passed in 0.74s`; `bash guards/tests/adversarial-battery.sh`
fechou `BATERIA VERDE`. Excecao G-EXC segue proposta e visivel porque
implementador=codex coincide com o agente do readback 0041 autorizado por
Maurício. Proxima acao: cross-audit nao-OpenAI + hearback + selagem; depois R2.

Nota selagem R1+R1-fix / readback 0040: concluida em 2026-06-17. A onda
selou os cinco pareceres de cross-audit R1/R1-fix em `.hbn/results/`,
registrou cada parecer no REGISTRY, sincronizou a contagem real da suite para
212/212 em `AGENTS.md`, `README.md` e `methodology/MATURITY-MATRIX.md`, e
devolve o bastao ao orquestrador. Evidencia mecanica local: `.venv/bin/pytest
-q` fechou `212 passed in 0.75s`; `bash guards/tests/adversarial-battery.sh`
fechou `BATERIA VERDE`; `main` permaneceu em
`4db692876381a0d7909985c8500d999f2e677b04`. Proxima acao: R2 arvores
registry-centric (G-REG M + anti-mislabel).

Nota R1-fix / readback 0039: entregue em 2026-06-17. A onda corrigiu o
bloqueador achado no cross-audit R1: `load_state_document` agora deduplica
`decisions` e `context_history` pela mesma identidade estavel de `executions`
e `results` (`traceability.execution_id`/`execution_id` quando presente; caso
contrario conteudo JSON deterministico), preservando a ordem canonico ->
`.usehbn/` -> `state/` e a regra canonico-vence. `tests/test_state_dual_read.py`
passou a usar fixtures nao-vazias e cobre item sem id por dedup de conteudo.
Evidencia mecanica: `.venv/bin/pytest -q` fechou 212/212; `bash
guards/tests/adversarial-battery.sh` bloqueou B1-B33. Proxima acao:
re-cross-audit R1+R1-fix nao-OpenAI, depois selagem R1.

Nota R1 / readback 0038: entregue em 2026-06-16. A onda fechou runtime e
honestidade pre-freeze em seis commits: readback 0038 depositado, golden tests
dos subcomandos, exit codes honestos, unificacao de estado em `.hbn/`, docs e
matriz de maturidade alinhadas, e este STATE + handoff final. A suite pytest
fechou 211/211; o guard runner ficou verde antes de cada commit R1. Escopo
preservado: `main`, `core/**`, `guards/**`, `schemas/**` e `docs/brainstorm/**`
nao foram alterados; `docs/brainstorm/**` foi apenas lido como contexto.
Proxima acao: cross-audit R1 por familia nao-OpenAI; depois R2 arvores
registry-centric (G-REG M + anti-mislabel).

Nota selagem W3 / readback 0037: concluida em 2026-06-16. W3 (readback
0036) fica RATIFICADO e SELADO: Grok, Antigravity 100 e Cursor 92 registraram
`APROVA_0036: SIM` nos quatro pareceres depositados. `G-ZONA-LIVRE` segue
ativo no runner e o deny-by-default da zona livre fica selado por construcao.
A branch protection biometrica da main esta armada (ruleset Active: require PR,
restrict deletions, block force pushes; passkey Touch ID). O cartao de entrada
universal foi depositado como candidato a `core/cartao-entrada.md`. Divida
rastreada: o marcador `zona_livre_curada` ainda e auto-declarado; hardening
futuro deve banir `docs/brainstorm/**` de todo `files_allowed`, exceto onda de
curadoria dedicada. Proxima acao: arvores registry-centric (coluna `arvore` no
REGISTRY), depois freeze + tag `v1-estavel`.

Nota W3 / readback 0036: entregue em 2026-06-16. `guards/assert-zona-livre.sh`
entrou bloqueante no runner como G-ZONA-LIVRE: qualquer path staged sob
`docs/brainstorm/**` exige que o readback ativo apontado por
`.hbn/relay/STATE.md` contenha `"zona_livre_curada": true` e
`"zona_livre_nota"` com texto nao-vazio. O guard falha fechado se STATE,
readback ativo ou JSON estiver ausente/ilegivel. `run-guard-tests` fechou
178/178, cobrindo caso positivo, caso sem marcador e readback ilegivel;
`adversarial-battery` bloqueou B1-B33, incluindo B33 docs/brainstorm sem
curadoria. Proxima acao: cross-audit W3; depois arvores registry-centric.

Nota grande selagem 0035: concluida em 2026-06-16. P-CAND-04 (readback 0033)
fica RATIFICADO e SELADO: Cursor registrou `APROVA_0033: SIM`; o `NAO` do
Grok foi resolvido pelo hardening W2, que tornou G-SCRATCH fail-closed quando
`active-version` nao resolve. W2 (readback 0034) fica RATIFICADO e SELADO por
Grok+Antigravity com `APROVA_0034: SIM`, fechando cinco bypasses: G-KNOW
token-match/anti-ponteiro-morto, G-FRONTDOOR bytes/contagem/existencia,
G-EXC ultimo-paragrafo, G-SCRATCH fail-closed e comentario G-REG. A pollution
`cfe9c33` (fixture `--no-verify` de auditor) foi removida por reset humano para
`635e01b`. As licoes 0024 e 0025 foram indexadas. Plano MVP preservado:
arvores registry-centric leve; sequencia hardening->deny->freeze; proxima acao
W3 deny-by-default (G-ZONA-LIVRE) sobre base endurecida; gates humanos =
branch protection biometrico + futura chave G-HRB.

Nota W2 / readback 0034: entregue em 2026-06-16. A onda fechou os bypasses
apontados nas auditorias: B29 (G-KNOW-INDEX substring e ponteiro morto), B30
(G-FRONTDOOR linha unica densa e path inexistente), B31 (G-EXC prosa no corpo
sem trailers finais) e B32 (G-SCRATCH-LOCK sem active-version). `run-guard-tests`
fechou 175/175 e `adversarial-battery` bloqueou B1-B32. O comentario stale do
G-REG foi corrigido sem mudanca de logica. P-CAND-04 sera selado junto na
proxima selagem; o bastao volta ao orquestrador para cross-audit W2.

Nota M-A: esta onda construiu a máquina da muda sem disparar a muda. O
ponteiro ativo permanece em `.`; hooks e guards falham fechado quando o
ponteiro está ausente, conflitado ou aponta para versão inexistente. A tag
`hbn-exuvia/protocol-0.3.x` e qualquer `git mv` ficam para M-C, depois do
Fitness Gate. O script de rollback foi testado apenas em dry-run.

Nota S0: esta onda corrigiu somente itens aditivos/corretivos pós-M-A. O bug D3
do rollback foi corrigido com teste de `--apply`; perfis `grok` e `cursor`
foram adicionados como `proposed`; o INDEX foi marcado como superseded pelo
STATE; e as fixtures untracked indicadas foram removidas. Nenhuma lógica de
guard foi alterada.

Nota depósito S0: Gemini (Google) aprovou S0 com confiança 100/100; Cursor
aprovou S0 com duas marginais não-bloqueadoras; opus-4-8 consolidou como OK,
ratificável e sem bloqueador. O marginal `cursor.json` model_id vs runtime fica
rastreado para a promoção futura do perfil a `accepted`.

Nota D-ORQ-WRITE: a cláusula 10 de `core/orchestrator-profile-spec.md` está na
linha limpa ratificada pela reestruturação M-A+S0, mas esta selagem não habilita
escrita operacional do orquestrador. O guard G-ACTOR-WRITE-MATRIX fica reservado
para rito futuro.

Nota reestruturação M-A+S0: o Modelo B foi ratificado por Maurício em
2026-06-15 após cross-audit Cursor+Gemini com `APROVA_REESTRUTURACAO: SIM`.
A linha limpa é `proposta/reestruturacao-m-a-s0` no tip `5a0587d`; a prova
mecânica fica congelada pela tag `evidencia/reestruturacao-m-a-s0-tree-equivalent`
com tree `61fa290e83b075983b9c6961a06c6e229cad1fd4`. Esta selagem adiciona
governança nova por cima do replay e não habilita escrita operacional do
orquestrador.

Nota selagem S1: Gemini (`.hbn/results/20260615-112714-gemini-3-5-cross-ia-s1-scope-lock.md`)
e Cursor (`.hbn/results/20260615-113115-cursor-cross-ia-s1-scope-lock.md`)
registraram `APROVA_S1: SIM`. B16 (auto-emenda de `scope.files_allowed` + uso
no mesmo commit) permanece bloqueado pela bateria S1. B17, a brecha
preexistente de meta-paths sempre permitidos em `guards/assert-scope-lock.sh:207-214`,
foi tratado e selado em 2026-06-15; B18 segue como proxima onda antes do S2.

Nota B17: a brecha preexistente de smuggling por meta-path foi implementada em
2026-06-15 com recorte tipo+nome. `guards/assert-scope-lock.sh` agora aceita
automaticamente apenas `.json`/`.md` de evento ADR-025 em `.hbn/messages/` e
`.hbn/bypasses/`, hearback `NNNN-*.{json,md}` do readback ativo e
`.hbn/relay/INDEX.md`; scripts, binarios e nomes arbitrarios nesses caminhos
precisam estar em `scope.files_allowed`. `run-guard-tests` passou com 140/140 e
`adversarial-battery` bloqueou B1-B17; cross-audit independente aprovado em
2026-06-15.

Nota selagem B17: Gemini
(`.hbn/results/20260615-213855-gemini-3-5-cross-ia-b17-meta-path.md`) e Cursor
(`.hbn/results/20260615-213850-cursor-cross-ia-b17-meta-path.md`) registraram
`APROVA_B17: SIM`. Cursor documentou B18: symlink com basename ADR-025 em
`.hbn/messages/20260615-120000-codex-handoff-x.md` apontando para
`../../src/payload.sh` passa porque `is_meta_auto_allowed` valida somente o
path string (`guards/assert-scope-lock.sh:236-249`). Decisão humana:
B18 e a próxima onda antes do S2.

Nota B18: implementado em 2026-06-15. `guards/assert-scope-lock.sh` agora
recusa qualquer entrada staged sob `.hbn/**` com modo git `120000`, antes de
avaliar `scope.files_allowed` ou meta-path ADR-025. A mensagem de bloqueio e
`symlink não permitido em path de coordenação governado: <path>`. Arquivos
regulares de handoff `.md`, hearback `NNNN-*.json` e nota de bypass `.md`
continuam passando. Cross-audit independente aprovado na selagem B18.

Nota selagem B18: Gemini
(`.hbn/results/20260615-223941-gemini-3-5-cross-ia-b18-symlink.md`) e Cursor
(`.hbn/results/20260615-224921-cursor-cross-ia-b18-symlink.md`) registraram
`APROVA_B18: SIM`. B19a fica aberto porque `is_governed_hbn_symlink` limita a
checagem a `.hbn/*` em `guards/assert-scope-lock.sh:256`; a próxima onda deve
generalizar o bloqueio de symlink para todo path governado. hardlink =
non-issue (git 100644): o Git grava hardlink como arquivo regular, sem
semantica de link no objeto versionado.

Nota B19: implementado em 2026-06-15. `guards/assert-scope-lock.sh` agora
recusa qualquer entrada staged avaliada pelo guard com modo git `120000`,
resolvendo o path de versao ativa para o path real do repo antes de consultar
`git ls-files --stage` localmente ou `git ls-tree HEAD` em CI. B18 segue coberto
e o bloqueio agora inclui paths governados como `.hbn/`, `guards/`, `core/` e
`src/`. `run-guard-tests` passou com 145/145; `adversarial-battery` bloqueou
B1-B19. Cross-audit depositado na selagem B19; ver nota seguinte.

Nota selagem B19: Gemini
(`.hbn/results/20260615-234638-gemini-3-5-cross-ia-b19-symlink-geral.md`) e
Cursor (`.hbn/results/20260615-234641-cursor-cross-ia-b19-symlink-geral.md`)
registraram `APROVA_B19: SIM` e `CLASSE FECHADA: SIM`. A classe
symlink/meta-path fica FECHADA apos B17+B18+B19. Hardlink permanece
non-issue/won't-fix: o Git materializa como arquivo regular `100644`, sem
semantica de link no objeto versionado. Proxima onda do roadmap: S2 (dispatch
schema).

Nota S2: implementada em 2026-06-16. O despacho passa a ser artefato
auto-declarante em `.hbn/dispatch/NNNN-*.md`, validado por
`schemas/dispatch.schema.json` e pela spec `core/dispatch-spec.md`.
`guards/validate-dispatch.sh` (G-DSP-FMT) bloqueia forma inválida, token_fp mal
formado e corpo colável com linha iniciada por `#`; `guards/assert-dispatch-integrity.sh`
(G-DSP-INT) bloqueia readback inexistente/não-ativo, token_fp divergente do
STATE e autorização humana vazia. Ambos entraram no runner sem rampa.
`guards/tests/run-guard-tests.sh` fechou 151/151 e
`guards/tests/adversarial-battery.sh` bloqueou B1-B22. O primeiro dispatch,
`.hbn/dispatch/0025-s2-dispatch-auto-declarante.md`, foi validado como dogfood.
Próximo passo: cross-audit Gemini+Cursor; selagem de S2 é micro-onda própria
com readback 0026, não feita aqui.

Nota selagem S2: concluida em 2026-06-16. Gemini
(`.hbn/results/20260616-010326-gemini-3-5-cross-ia-s2-dispatch.md`) registrou
`APROVA_S2: SIM` com confiança 100/100; Cursor
(`.hbn/results/20260616-010221-cursor-cross-ia-s2-dispatch.md`) registrou
`APROVA_S2: SIM` com confiança 90/100. Os despachos do orquestrador de abertura
S2 e cross-audit S2 foram depositados no historico. O marginal H (trailers
historicos nao-contiguos para parser nativo) e os marginais EXTRA do Cursor
(dispatch-like fora de `.hbn/dispatch/` e relacao `dispatch_id` x
`readback_id`) ficaram documentados para triagem na faxina 0027, junto com os
untracked antigos e os criterios/triagem de exuvia; esta selagem nao alterou
logica de guard.

Nota faxina 0027: implementada em 2026-06-16. O G-EXC passou a validar trailers
em CI sobre a mensagem bruta do commit (`%B`), igual ao modo commit-msg, cobrindo
o falso-positivo do parser nativo `%(trailers)`. `run-guard-tests` fechou
154/154 e `adversarial-battery` bloqueou B1-B23. Os seis artefatos historicos
antigos foram selados, com carimbos de deposito nos handoffs legados para
compatibilidade com G-RLT/G-PTR. `.gitignore` passou a cobrir scratch das suites
e os diretorios remanescentes foram removidos best-effort. A triagem e o
documento-fonte de criterios de exuvia foram selados, e
`core/exuvia-fitness-criteria.md` virou a referencia normativa. Os
endurecimentos EXTRA-1/EXTRA-2 do Cursor seguem fora desta onda e devem ser
tratados em S3.

Nota selagem da faxina 0027 / readback 0028: concluida em 2026-06-16. Cursor
(`.hbn/results/20260616-023446-cursor-cross-ia-faxina-0027.md`) e Gemini
(`.hbn/results/20260616-024241-gemini-3-5-cross-ia-faxina-0027.md`) registraram
`APROVA_0027: SIM`. A selagem depositou os pareceres, tres despachos do
orquestrador e dois docs de brainstorm como zona-livre versionada. O lixo-zero
sem mudanca de logica ficou aplicado em `.gitignore` (`adv-cr*`) e no
front-matter do doc-fonte de criterios (`status: superseded` +
`superseded_by: core/exuvia-fitness-criteria.md`). Ficam rastreadas para S3 /
hardening: (1) prosa-trailer do G-EXC, pois `%B` inteiro ainda aceita linhas de
corpo iniciadas por `HBN-...:`; (2) convencao de incluir o handoff da onda no
`files_allowed` do readback.

Nota S3.1 / readback 0029: entregue em 2026-06-16. O INDEX da knowledge deixou
de ser amostra estatica e passou a listar as 8 entradas atuais:
`0001-comandos-atomicos-copiaveis.md`,
`0002-entrega-operacional-minimalista.md`,
`0003-git-sandbox-sem-lock.md`, `0019-severidades-veto.md`,
`0022-firewall-workflow-fast-track.md`, `distribution-model.md`,
`relay-protocol.md` e `runtime-command-model.md`. O novo G-KNOW-INDEX entrou
bloqueante em `guards/hbn-guards-runner.sh`, falhando fechado se o INDEX estiver
ausente/ilegivel ou se qualquer `.hbn/knowledge/*.md` nao for citado pelo
basename. `run-guard-tests` fechou 156/156 e `adversarial-battery` bloqueou
B1-B24, incluindo B24 (knowledge nova ausente do INDEX).

Nota selagem S3.1 / readback 0030: concluida em 2026-06-16. Gemini/Antigravity
(`.hbn/results/20260616-121025-gemini-3-5-cross-ia-s3-1.md`) e Cursor
(`.hbn/results/20260616-124526-cursor-cross-ia-s3-1.md`) registraram
`APROVA_0029: SIM`. A selagem depositou os dois pareceres, o despacho de
cross-audit do orquestrador, a knowledge 0023, o INDEX atualizado, tres docs de
brainstorm e este handoff, sem alterar logica de guard. Dividas rastreadas para
hardening: (1) G-KNOW-INDEX usa `grep -Fq "$base"` e pode aceitar substring em
`guards/assert-knowledge-index.sh:63`; (2) o INDEX pode citar arquivo inexistente
sem o guard reclamar (ponteiro-morto). Decisao de design rastreada: P-CAND-04
convergiu para tmp do ambiente primeiro; `/scratch/` no repo, se adotado, deve
ter onda propria com gitignore + guards anti-stage/symlink/ignore. Continuidade:
o proximo orquestrador deve ler STATE + handoff + `.hbn/knowledge/0001`,
`.hbn/knowledge/0002` e `.hbn/knowledge/0023` ao assumir o bastao.

Nota selagem S3.2 / readback 0032: concluida em 2026-06-16. Cursor
(`.hbn/results/20260616-132743-cursor-cross-ia-s3-2.md`) registrou
`APROVA_0031: SIM` com confiança 90/100; Gemini/Antigravity
(`.hbn/results/20260616-132813-gemini-3-5-cross-ia-s3-2.md`) registrou
`APROVA_0031: SIM` com confiança 100/100. A selagem depositou os dois
pareceres e versionou os tres docs de brainstorm de Fronteira
(`docs/brainstorm/exuvia-evolucao-conceitual.md`,
`docs/brainstorm/PROMPTS-PF-ARVORES-AGORA-DRAFT.md` e
`docs/brainstorm/PROPOSTA-arvores-agora.md`), sem alterar logica de guard.
Divida rastreada agrupada para hardening de guards: G-KNOW-INDEX ainda aceita
substring no `grep -Fq` e ponteiro morto no INDEX; G-FRONTDOOR tem teto por
linhas, nao por bytes, conta itens por marcador/espaco conhecido e nao verifica
existencia dos paths da read-list. Proxima acao: implementar area temporaria
P-CAND-04 (`/scratch/` + guards G-SCRATCH-LOCK/SYMLINK/IGNORE).

Nota selagem Curadoria 0055 / readback 0059: concluida em 2026-06-18.
A Curadoria 0055 (dossie pre-transicao) fica SELADA: o readback 0055 foi
ratificado por dois pareceres cross-audit de familias distintas de OpenAI,
grok/xAI APROVA_0055: SIM conf 88 e antigravity/Google APROVA_0055: SIM conf
100. Os 2 pareceres foram tornados tracked (adicionados ao git + linhas
REGISTRY 7-col com arvore=fronteira/frio). Evidencia mecanica: main em
4db692876381a0d7909985c8500d999f2e677b04; bash guards/hbn-guards-runner.sh
passou (todos guards verdes); bash guards/tests/run-guard-tests.sh passou;
bash guards/tests/adversarial-battery.sh retornou BATERIA VERDE. Escopo exato respeitado. Selagem so vigora
apos hearback humano. Preconds todas satisfeitas antes do commit.
