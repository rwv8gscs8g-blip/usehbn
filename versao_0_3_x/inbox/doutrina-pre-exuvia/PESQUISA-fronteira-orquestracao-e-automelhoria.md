RELATÓRIO DE FRONTEIRA — orquestração de múltiplas IAs + automelhoria de protocolos
Cole este mesmo texto em CADA IA consultada (responder de forma INDEPENDENTE): Gemini, Codex e uma terceira (sugestão: Perplexity, pela força em referências citáveis; alternativa: Grok).

## Contexto mínimo (para você situar a comparação)
Estou desenvolvendo um protocolo aberto chamado **useHBN** para orquestrar **várias IAs de famílias diferentes** (Anthropic, OpenAI, Google) colaborando em desenvolvimento de software, com **o humano sempre no gate de aprovação**. Características do useHBN hoje:
- Não usa subagentes nem memória compartilhada automática. Em vez disso, usa **"abrir janela nova + colar"**: cada tarefa vai para uma janela limpa de uma IA, com contexto máximo e isolado.
- **Travas mecânicas (guards em hooks de git)** bloqueiam commits que violem regras (escopo, identidade, rastreabilidade, separação de famílias entre implementador e auditores).
- **Auditoria cruzada** obrigatória por IAs de famílias diferentes da que implementou; humano ratifica.
- Tudo versionado em git, com livro-razão e arquivo de estado; nada se apaga (história sagrada).
- Trajetória: ganhar CLI e, no futuro, **memória** e **"dream"** (consolidação reflexiva), e automações de loop (arquiteto autônomo).

## O que preciso de você (relatório com referências)

### Parte 1 — 10 melhores alternativas de orquestração de múltiplas IAs
Liste e compare as 10 abordagens/arquiteturas mais relevantes hoje, cobrindo tanto o **paradigma "tipo HBN"** (regras rígidas + auditoria cruzada + gate humano + estado em arquivo) quanto o **paradigma de subagentes** (orquestrador que cria subagentes, memória/contexto compartilhado, frameworks de multi-agente). Para cada uma:
- nome e o que é (1–2 linhas);
- forças e fraquezas;
- como se compara ao useHBN (o que o HBN ganharia ou perderia adotando);
- **referência** (paper, repositório, doc oficial — com link/identificação).
Inclua, se pertinentes: LangGraph, AutoGen, CrewAI, OpenAI Agents SDK/Swarm, Anthropic subagents/Claude Code, MetaGPT, Microsoft Magentic-One, blackboard systems, e quaisquer outros que você julgue de fronteira em 2026.

### Parte 2 — 3 modelos de AUTOMELHORIA de protocolos/agentes
Descreva 3 modelos de auto-evolução / auto-correção de agentes ou protocolos (ex.: arquiteturas de reflexão, memória de longo prazo, "dream"/consolidação, autocrítica constitucional, currículos auto-gerados). Para cada: o que é, como funciona, o que o useHBN poderia incorporar, e **referência**.

### Formato da resposta
- Seja concreto e citável; priorize fontes verificáveis (2024–2026).
- Ao final, dê sua **recomendação top 3** do que o useHBN deveria estudar primeiro e por quê.
- Declare honestamente o que é especulação vs. o que tem fonte.

(Não precisa escrever em disco; cole a resposta no chat para o orquestrador consolidar. O orquestrador vai cruzar as três respostas, marcar convergências/divergências, e separar "incorporar agora" de "lição/referência para versões futuras".)
