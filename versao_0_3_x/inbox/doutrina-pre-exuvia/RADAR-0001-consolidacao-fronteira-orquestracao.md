# Radar 0001 — Consolidação de fronteira: orquestração multi-IA + automelhoria

Entrada de RADAR (dogfooding: segue as regras do protocolo — registrável, auditável).
Fontes: relatórios independentes Gemini + Codex + Grok (2026-06-14) + análise do orquestrador (Opus) com verificação web.
Objetivo: separar o que INCORPORAR agora (MVP) do que fica como LIÇÃO/futuro, alimentando Fagocitose e a 1ª Exúvia.

## 1. Convergências (as três IAs concordam)

1. **Não trocar o paradigma — importar peças.** O useHBN já é um *blackboard git-native* com governança mecânica + isolamento ("janela limpa") + auditoria cross-family + gate humano. As três alertam: adotar subagentes/memória compartilhada cedo demais **sacrifica o isolamento e a auditoria cross-family** — os dois pilares de segurança do HBN.
2. **LangGraph é a ponte nº1** para o futuro CLI/grafo: estado explícito, checkpoints, ciclos (implementar→auditar→corrigir) e human-in-the-loop, sem abandonar git/guards. (Top-tier nos três.)
3. **Task Ledger / Progress Ledger (Magentic-One)**: motor de orquestração interna de tarefas — útil, desde que sob gates mecânicos.
4. **Claude Code subagents/agent teams + worktrees** é o **paralelo mais próximo do HBN operacional** (isolamento por contexto/worktree, ferramentas restritas, revisão paralela).
5. **Automelhoria sempre como PROPOSTA auditada, nunca autoaplicada.** Convergência total: reflexão + consolidação offline ("dream") + autocrítica constitucional entram como PRs ratificados pelo humano. É dogfooding puro do HBN.
6. **ACI (SWE-agent)**: dar comandos de edição específicos ao implementador (em vez de `sed`/`cat` crus) reduz erro mecânico — exatamente os tropeços que vimos (`fable5`, locks, `cd` faltando).

## 2. Divergências / ênfases próprias

- **Gemini** prioriza **Constitutional AI em runtime**: converter `PRINCIPIOS-CONSTITUCIONAIS.md` em regras parseáveis + um auditor-IA leve no hook de commit. (Atraente, mas risco real de latência no hook — sinalizo como estudo, não MVP.)
- **Codex** prioriza **A2A + Google ADK** para o futuro multi-vendor (interop) — alinhado ao seu item 1 (três árvores/forks).
- **Grok** traz **Omnigent (Databricks)** — o parente mais direto do HBN no mercado.

## 3. Análise do orquestrador (fronteira verificada)

- **Omnigent é o achado mais relevante (verificado).** Meta-harness aberto que compõe agentes de várias famílias, com *policies de controle* (custo, permissões, **aprovação humana antes do push**) na camada do harness (não no prompt) e sandbox que intercepta rede/OS. Implicações: (a) **valida a tese do HBN** — o mercado convergiu para meta-harness + governança + gate humano; (b) o HBN **se diferencia** por ser aberto, **git-native com história sagrada/auditável** e **auditoria CROSS-FAMILY** + constituição — coisas que Omnigent (policy operacional) não enfatiza; (c) **oportunidade**: no futuro o HBN pode rodar *sobre* Omnigent/Claude Code/Codex como **camada de governança epistêmica** acima da camada de execução.
- **A2A (Linux Foundation, v1.0, 150+ orgs — verificado).** O padrão de interop multi-vendor já existe e é estável (Agent Cards assinados, SDKs em 5 linguagens). Conclusão para o item 1: **não inventar protocolo de transporte** entre árvores/forks — falar A2A no futuro, com o HBN como camada de *confiança/aprovação* acima do transporte.
- **Sleep/dream consolidation é linha real e quente (verificado, vários papers 2026).** Valida a direção Memory/Dream. MVP do "dream" no HBN = consolidação **offline** da trilha de aprendizagem (logs frios) em propostas de ADR/guard, sempre auditadas (nunca autoaplica).
- **AdaptOrch (arXiv 2602.16873)**: "orquestração task-adaptive na era da convergência de performance dos LLMs" — reforça que o **roteamento de modelo por tarefa** (cláusula 9) é fronteira ativa, não detalhe.
- **Truth Barrier aplicada às IAs**: a maioria das referências citadas pelas três IAs é verificável (LangGraph, AutoGen, CrewAI, OpenAI Agents SDK, Magentic-One, SWE-agent, OpenHands, MetaGPT, A2A, Reflexion, Voyager, Generative Agents, ADAS, Constitutional AI, Omnigent, papers de sleep). Tratar como **especulação** as propostas exatas de *como* integrar (ex.: `usehbn sleep`, guard semântico no hook) até virarem proposta + cross-audit.

## 4. Mapa para o useHBN (incorporar agora × lição/futuro)

**Incorporar agora (MVP, baixo risco, alinhado aos princípios):**
- **Exúvia MVP** = tag git imutável (`hbn-exuvia/protocol-vN`) + manifesto + ponte bidirecional. (Já nos requisitos v2.)
- **ACI leve**: convenções/checklist de edição para implementadores (reduz erro mecânico) — doutrina antes de virar comando de CLI.
- **Radar**: iniciar a `CONVERGENCE-MATRIX` com esta consolidação (este documento é a semente).
- **"Dream" MVP**: consolidação offline da trilha de aprendizagem → propostas auditadas (humano no gate).

**Estudar / observar (lição, próximas versões):**
- **LangGraph** como base do futuro CLI/grafo (quando sair do "colar" para CLI).
- **Omnigent**: avaliar HBN *sobre* Omnigent (governança acima da execução) e aprender com suas policies.
- **A2A**: interop entre árvores/forks quando publicar no GitHub.
- **Constitutional runtime guard** (Gemini): converter princípios em regras + auditor-IA no hook — cuidado com latência.

**Baixo encaixe agora (registrar como lição):**
- Frameworks que quebram isolamento/cross-family: AutoGen (conversa circular), CrewAI (roleplay sem evidência), OpenAI Agents SDK (vendor-lock).

## 5. Item 2 — Módulo `radar` (análise a fundo)

`radar/` já é partição standalone (ADR-003), ciclo semanal, alimenta Fagocitose (P7). O que deve conter:
1. **CONVERGENCE-MATRIX**: tecnologia × maturidade × decisão (incorporar / observar / descartar). Começa com a tabela da seção 4.
2. **Ciclo de radar**: varredura periódica (consulta multi-IA + busca do orquestrador) → parecer de convergência → decisão de Fagocitose → registro auditado.
3. **Separação de papéis**: radar **observa e propõe**; Fagocitose **absorve** (via ADR + Exúvia); **princípios não mudam**. Dogfooding: radar segue REGISTRY + readback + cross-audit.
4. **Radar alimenta o "dream"**: convergências + logs viram propostas auditadas.

**A "parte dura" que persiste nas exúvias** (sua observação, confirmada pelo P7/P12): os **princípios P1–P13** + os invariantes operacionais (isolamento, cross-family, gate humano, auditabilidade, reversibilidade). As **tecnologias** (Python→Rust, frameworks, transporte A2A) são fagocitáveis e trocáveis.

## 6. Item 1 — três árvores, Exúvia-como-fork, registro/interop

- **Três árvores** (já com base constitucional P12): **Estável** (Rust, futuro), **Intermediária** (runtime atual Python 0.3.x), **Experimental** (radar/protótipos).
- **Exúvia-como-fork (MVP simples)**: a casca = **tag git imutável** + (opcional) branch arquival; **fork real no GitHub só quando publicar** (hoje `origin` nunca teve push). Não precisa de fork agora — MVP = tag + manifesto + ponte.
- **Princípio de registro universal (candidato a regra de bootstrap)**: todo projeto novo nasce com **obrigação de registrar no livro-razão** (numeração do protocolo) + um **doc de hierarquia do protocolo** para interop. Interop futura entre árvores/forks = **A2A**, com HBN como camada de confiança.
- **MVP + dogfooding (ordem proposta)**: (1) fechar a estabilização do useHBN; (2) **Exúvia MVP no useHBN** (1ª muda); (3) **dogfood no Credenciamento** como estabilização; (4) evoluir versões e fazer **a 1ª Exúvia lá**.

## 7. Propostas de desenvolvimento (ondas, em ordem)

1. **Estabilização** (em curso): fechar doutrina/painel; emendar o plano Exúvia (requisitos v2).
2. **1ª Exúvia (MVP)** do useHBN: tag + manifesto + ponte + reorganização que dissolve B1/B2/B3; radar inicia a CONVERGENCE-MATRIX (com este doc).
3. **Dogfooding no Credenciamento**: aplicar o MVP do protocolo + a interface de confirmação.
4. **Dream MVP + ACI**: consolidação offline auditada + convenções de edição.
5. **Futuro (lição)**: CLI sobre LangGraph; avaliar Omnigent como substrato; A2A para interop multi-árvore.
