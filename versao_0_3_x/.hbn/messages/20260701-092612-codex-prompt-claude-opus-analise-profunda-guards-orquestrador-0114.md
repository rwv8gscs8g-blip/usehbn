---
titulo: "Prompt Claude Opus - analise profunda dos guards do orquestrador 0114"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-092612-codex-prompt-claude-opus-analise-profunda-guards-orquestrador-0114.md
created_at: "2026-07-01T09:26:12-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
destino: claude-opus
resultado_esperado: .hbn/results/20260701-092612-claude-opus-analise-profunda-guards-orquestrador-0114.md
---

⟦HBN-COPY dest=claude⟧ BEGIN
SOU: claude-opus · familia Anthropic · papel auditor-arquiteto-read-only

CHAT NOVO, SEM MEMORIA.

VOCE ESTA RECEBENDO UMA JANELA DE ATE DUAS HORAS PARA ANALISE PROFUNDA DO useHBN.

OBJETIVO:
Fazer uma analise avancada dos guards do orquestrador e dos pontos pendentes que travam a evolucao da plataforma, com workflow dinamico e loops de ataque/validacao. Voce deve produzir um parecer tecnico canonico, acionavel, que ajude o Codex/orquestrador a implementar os proximos guards sem perder invariantes.

REPO:
/Users/macbookpro/Projetos/usehbn

HEAD ESPERADO:
f8dbe09086d06f5dc42527241c33e37174a65427

PAPEL E LIMITES:
- Voce e auditor-arquiteto read-only.
- Nao altere codigo.
- Nao faca staging.
- Nao commite.
- Nao use --no-verify.
- Se nao conseguir escrever no disco, responda com o conteudo integral do arquivo de resultado e declare NAO SALVEI NO DISCO.

CONTEXTO CRITICO:
O repo esta em saneamento provisorio. G-STATE-STRUCTURAL 0106 tem quorum material por Grok/xAI e Claude/Anthropic, mas a selagem controlada bateu corretamente em G-SCOPE porque o readback ativo 0105 proibe guards/** e nao autoriza essa selagem. O objetivo agora e acelerar a melhoria dos guards do orquestrador sem bypass: identificar o rito correto e os patches futuros de maior impacto.

LEIA ANTES DE ANALISAR:
- AGENTS.md
- core/role-cards.md
- agents/codex.md
- agents/wave-protocol.md
- core/read-list-canonica.txt
- core/orchestrator-profile-spec.md
- core/relay-return-spec.md
- .hbn/relay/STATE.md
- .hbn/readbacks/0105-onda-repoint-state-p2c2-fechado.json
- .hbn/messages/20260701-091112-codex-manifesto-selagem-g-state-0112.md
- .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
- .hbn/knowledge/0002-entrega-operacional-minimalista.md
- .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md
- .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md
- .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
- .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md
- .hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
- .hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
- guards/assert-scope-lock.sh
- guards/assert-state-structural.sh
- guards/assert-copy-block.sh
- guards/assert-orq-entrada-ref.sh
- guards/assert-quorum-selagem.sh
- guards/assert-audit-diversity.sh
- guards/assert-zona-livre.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- guards/hbn-guards-runner.sh
- REGISTRY.md

COMANDOS DE PREFLIGHT, UM POR VEZ:
COMANDO 1: git -C /Users/macbookpro/Projetos/usehbn rev-parse HEAD
COMANDO 2: git -C /Users/macbookpro/Projetos/usehbn status --short
COMANDO 3: git -C /Users/macbookpro/Projetos/usehbn diff --cached --name-only
COMANDO 4: git -C /Users/macbookpro/Projetos/usehbn diff --check

SE QUALQUER PREFLIGHT CONTRADISSER O CONTEXTO:
Falhe fechado, explique a divergencia e ainda produza recomendacao segura de proximo passo.

WORKFLOW DINAMICO OBRIGATORIO:
Loop 1 - Mapa de superficies:
Liste todos os pontos onde o orquestrador exerce autoridade ou consegue causar mudanca estrutural. Inclua prompt, despacho, readback, STATE, REGISTRY, RETURN, .hbn/results, .hbn/messages, guards, zona livre, staging seletivo e commit.

Loop 2 - Invariantes e gates:
Para cada superficie, diga qual guard ou regra hoje cobre, qual arquivo implementa, qual teste cobre e qual lacuna permanece. Use arquivo:linha sempre que possivel.

Loop 3 - Ataques adversariais:
Crie pelo menos 20 tentativas concretas de burla contra o rito do orquestrador. Para cada uma, diga se hoje bloqueia, passa ou e incerto, e qual teste deveria existir.

Loop 4 - Sequenciamento de patches:
Proponha a menor sequencia segura de ondas para avancar a partir do estado atual. Deve incluir:
1. rito corrigido para selar G-STATE sem bypass;
2. G-ORQ-XAUDIT-GATE;
3. G-ORQ-NO-DELETE;
4. G-ACTOR-WRITE-MATRIX;
5. G-ORQ-FDACK;
6. G-ORQ-TRIPWIRE.

Loop 5 - Especificacao de cada guard:
Para cada guard futuro, entregue:
- objetivo;
- arquivos provaveis a tocar;
- entradas/saidas;
- regra fail-closed;
- falsos positivos aceitaveis;
- falsos negativos inaceitaveis;
- testes positivos;
- testes negativos;
- impacto no runner;
- risco de deadlock com guards atuais.

Loop 6 - Plano de implementacao para Codex:
Escreva micro-despachos em ordem, um por onda, sem implementar codigo. Cada micro-despacho deve ter escopo minimo, files_allowed sugerido, files_forbidden, testes, criterio de pronto e rollback. Nao emita prompts de auditoria antes de existir alvo auditavel.

PONTOS ESPECIFICOS A VALIDAR:
- Como corrigir o bloqueio atual de G-SCOPE sem bypass e sem auto-emenda indevida.
- Se criar readback 0113 de selagem G-STATE e alterar STATE para aponta-lo e rito aceitavel ou se isso exige duas etapas.
- Se o manifesto 0112 precisa ser revisado para incluir readback proprio antes da selagem.
- Se G-STATE-STRUCTURAL deve bloquear delete/move de STATE ou se isso deve ficar totalmente em G-ORQ-NO-DELETE.
- Como impedir prompt cross-audit sem destino canonico, sem template de parecer, sem SOU, sem APROVA_NNNN e sem dupla entrega chat+.md.
- Como impedir que auditoria prematura seja emitida antes de alvo auditavel existir.
- Como tratar REGISTRY.md quando o worktree contem linhas de multiplas classes e a selagem exige hunk seletivo.
- Como impedir que RETURN.json ou chat solto sejam tratados como fonte de quorum.
- Como reduzir dependencia de comportamento correto do orquestrador por boa vontade.

COMANDOS DE VALIDACAO, SE O TEMPO PERMITIR, UM POR VEZ:
COMANDO 5: bash guards/hbn-guards-runner.sh
COMANDO 6: bash guards/tests/run-guard-tests.sh
COMANDO 7: bash guards/tests/adversarial-battery.sh
COMANDO 8: .venv/bin/pytest -q

DESTINO CANONICO DO RESULTADO:
Salve em:
.hbn/results/20260701-092612-claude-opus-analise-profunda-guards-orquestrador-0114.md

FORMATO DO RESULTADO:
- Front matter com tipo: audit-result, autor: claude-opus, familia: Anthropic, path igual ao destino, arvore: fronteira, created_at local.
- Linha SOU igual a primeira linha deste prompt.
- Resumo executivo em ate 12 linhas.
- Secoes Loop 1 a Loop 6.
- Secao "Achados priorizados" com severidade BLOQUEADOR, FORTE, MARGINAL.
- Secao "Sequencia recomendada" com ondas numeradas.
- Secao "Micro-despachos para Codex".
- Secao "O que nao fazer".
- Ultima linha exatamente:
ANALISE_0114_CONCLUIDA: SIM

CRITERIO DE QUALIDADE:
Prefira analise menos extensa e mais precisa a catalogo generico. Cada recomendacao deve apontar arquivo, guard, teste ou lacuna verificavel. Se houver incerteza, marque INCERTO e diga como provar.
⟦HBN-COPY END⟧
