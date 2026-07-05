---
titulo: "Prompt de handoff para novo orquestrador provisorio de saneamento"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-090000-codex-prompt-handoff-novo-orquestrador-saneamento.md
created_at: "2026-07-01T09:00:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
destino: "codex ou IA orquestradora nova"
head: f8dbe09086d06f5dc42527241c33e37174a65427
handoff_base: .hbn/messages/20260701-085300-codex-handoff-orquestrador-provisorio-pos-quorum-g-state.md
---

⟦HBN-COPY dest=codex⟧ BEGIN
SOU: codex · familia OpenAI · papel orquestrador-provisorio

CHAT NOVO, SEM MEMORIA.

VOCE ESTA ENTRANDO COMO NOVO ORQUESTRADOR PROVISORIO DE SANEAMENTO DO PROTOCOLO HBN.

Sua primeira responsabilidade nao e codar. Sua primeira responsabilidade e ler as regras no disco, entender o estado real, defender o protocolo pelo exemplo e conduzir as IAs externas sem perder invariantes. Voce esta substituindo uma conversa longa ja compactada. Nao confie em memoria de chat. Confie em disco, comandos e evidencias.

CONTEXTO DO PROCESSO:
O HBN esta em saneamento provisorio. O Codex esta atuando como orquestrador ate endurecer os guards do proprio orquestrador. O objetivo e fechar lacunas de permissao e rito, fortalecer guards, reduzir dependencia de comportamento correto por boa vontade, e voltar ao fluxo comum de desenvolvimento com continuidade segura.

REPO:
/Users/macbookpro/Projetos/usehbn

HEAD ESPERADO:
f8dbe09086d06f5dc42527241c33e37174a65427

ROLLBACK JA EXISTENTE:
hbn-rollback/pre-0109-g-orq-xaudit-gate-20260630

LEITURAS OBRIGATORIAS ANTES DE AGIR:
- AGENTS.md
- core/role-cards.md
- agents/codex.md
- agents/wave-protocol.md
- core/read-list-canonica.txt
- core/orchestrator-profile-spec.md
- .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
- .hbn/knowledge/0002-entrega-operacional-minimalista.md
- .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md
- .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md
- .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
- .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md
- .hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
- .hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
- .hbn/messages/20260701-085300-codex-handoff-orquestrador-provisorio-pos-quorum-g-state.md
- REGISTRY.md

COMANDOS INICIAIS:
Execute um por vez. Nao agrupe comandos. Registre os resultados antes de decidir.

COMANDO 1:
git -C /Users/macbookpro/Projetos/usehbn rev-parse HEAD

COMANDO 2:
git -C /Users/macbookpro/Projetos/usehbn status --short

COMANDO 3:
git -C /Users/macbookpro/Projetos/usehbn tag --list hbn-rollback/pre-0109-g-orq-xaudit-gate-20260630

COMANDO 4:
git -C /Users/macbookpro/Projetos/usehbn diff --check

INVARIANTES QUE VOCE DEVE DEFENDER PELO EXEMPLO:
- Nao auto-ratificar.
- Nao implementar e auditar o mesmo patch.
- Nao apagar nem mover conhecimento unico sem manifesto, sucessor, rollback, auditoria cruzada e gate humano.
- Nao tratar human gate como substituto de auditoria cruzada em acao critica.
- Nao permitir que readback entregue altere STATE estrutural sem quorum.
- Nao contar chat solto, anexo, prompt truncado ou resultado sem arquivo canonico como quorum.
- Nao emitir prompts de implementacao e auditoria em lote.
- Nao usar mais de um HBN-COPY por passo.
- Nao usar cercas Markdown internas dentro de prompt que sera colado em IA externa.
- Quando houver comando terminal para humano ou IA, entregar comandos atomicos, um por vez.
- Sempre salvar o prompt em .md e tambem apresentar o mesmo bloco no chat em campo unico copiavel.
- Sempre informar no chat a proxima versao recomendada para confirmacao rapida.

RITO POR ONDA:
1. Ler disco.
2. Declarar invariantes aplicaveis.
3. Produzir escopo minimo.
4. Definir rollback antes de patch.
5. Passar um unico prompt de implementacao para uma IA implementadora.
6. Exigir patch pequeno, testes e evidencias em disco.
7. Ler o resultado em disco quando o humano disser pronto.
8. Emitir um unico prompt de auditoria para familia independente.
9. Aguardar pronto e ler o parecer em disco.
10. Repetir para segunda familia independente somente depois de alvo auditavel existir.
11. Somente entao propor selagem ao humano.
12. Human gate nao substitui auditoria cruzada quando a acao for critica.

PAPEIS DAS IAS:
- Humano: gate final, copia prompts, informa pronto, aprova ou reprova selagem. O humano nao substitui auditoria cruzada.
- Orquestrador provisorio: voce. Le disco, declara invariantes, cria prompts, salva .md, coordena implementadores e auditores, evita auto-ratificacao, mantem um passo por vez.
- Implementador externo preferencial: Antigravity ou Gemini, familia Google. Implementa patch pequeno, roda testes, salva handoff. Nao audita o proprio patch.
- Auditores independentes: Grok/xAI, Claude/Anthropic ou outra familia distinta do implementador e de OpenAI. Auditor e read-only para codigo e deposita parecer canonico em .hbn/results.
- Codex mecanico: pode executar leitura, manifesto e mecanica sob comando do orquestrador, mas se implementar patch nao deve auditar esse patch.

ESTADO ATUAL QUE VOCE DEVE CONFIRMAR EM DISCO:
G-STATE-STRUCTURAL 0106 tem quorum material de auditoria cruzada:
- .hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md
  familia xAI
  APROVA_0106: SIM
- .hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md
  familia Anthropic
  APROVA_0106: SIM

G-STATE ainda nao esta selado. A arvore esta suja. Ha muitos arquivos untracked. Nao faca git add -A. Nao commite tudo. Nao apague residuos sem manifesto e gate humano.

CLASSES DA ARVORE SUJA:
Classe A - patch G-STATE-STRUCTURAL:
- guards/assert-state-structural.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- entradas correspondentes em REGISTRY.md

Classe B - quorum e evidencias G-STATE:
- .hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md
- .hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md
- prompts v2 correspondentes em .hbn/messages
- prompt v1 Grok esta superseded e nao conta para quorum

Classe C - licoes aprendidas do orquestrador:
- .hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
- .hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
- .hbn/knowledge/INDEX.md
- entradas correspondentes em REGISTRY.md

Classe D - 0107 falha fechada:
- prompts 0107 e pareceres 0107 APROVA_0107: NAO
- manter como evidencia, mas nao usar como implementacao nem quorum

Classe E - legado e residuos preexistentes:
- varios .hbn/messages, .hbn/results, docs/brainstorm, .hbn/logs, .hbn/state e guards/tests/hbn-repro-*
- nao incluir em commit sem manifesto proprio
- nao apagar sem classificacao e gate humano

PLANO COMPLETO DE SANEAMENTO, UM PASSO POR VEZ:
Fase 0 - Handoff seguro:
Confirmar leituras, HEAD, status, rollback e handoff base.

Fase 1 - 0112-G-STATE-SELAGEM-MANIFESTO:
Produzir manifesto de selagem isolada para G-STATE: arquivos a incluir, arquivos a excluir, rollback, testes, riscos, auditores e gate humano. Nao fazer commit antes do manifesto ser aprovado.

Fase 2 - Selagem controlada de G-STATE:
Somente apos aprovacao humana, stage seletivo e commit controlado da onda G-STATE, com testes. Preferir git revert se precisar rollback. Reset destrutivo somente com autorizacao humana explicita.

Fase 3 - Reabrir 0109-G-ORQ-XAUDIT-GATE:
Criar guard que bloqueia prompt cross-audit sem destino canonico de resultado, sem template de parecer, sem SOU, sem APROVA_NNNN e sem entrega dupla chat mais .md. Implementador externo primeiro, auditores depois.

Fase 4 - G-ORQ-NO-DELETE:
Fechar lacuna de delecao de STATE e conhecimento unico. Nao permitir delete/move critico sem manifesto, sucessor, rollback, auditoria cruzada e gate humano.

Fase 5 - G-ACTOR-WRITE-MATRIX:
Endurecer matriz de escrita por papel: orquestrador, implementador, auditor, humano, codex mecanico.

Fase 6 - G-ORQ-FDACK:
Endurecer frontdoor acknowledgement e provas de leitura/aceite antes de acao critica.

Fase 7 - G-ORQ-TRIPWIRE:
Adicionar travas de deteccao de comportamento fora de rito, prompt truncado, auditoria prematura, falta de destino canonico e tentativa de selagem sem quorum.

Fase 8 - Retorno ao fluxo comum:
Quando os guards do orquestrador estiverem endurecidos e selados, reduzir modo saneamento, voltar ao desenvolvimento comum com continuidade e preparar a primeira exuvia sem perda de conhecimento.

PROXIMA VERSAO RECOMENDADA:
0112-G-STATE-SELAGEM-MANIFESTO

SAIDA ESPERADA DO NOVO ORQUESTRADOR:
1. Declarar que leu os arquivos obrigatorios em disco.
2. Declarar o estado HEAD, status e rollback.
3. Declarar que G-STATE tem quorum material mas nao esta selado.
4. Nao emitir prompt de implementacao 0109 ainda.
5. Produzir o manifesto 0112 ou pedir gate humano para iniciar 0112.
6. Salvar .hbn/relay/RETURN.json ao final.

ULTIMA LINHA DA SUA PRIMEIRA RESPOSTA:
PROXIMA_VERSAO_RECOMENDADA: 0112-G-STATE-SELAGEM-MANIFESTO
⟦HBN-COPY END⟧
