# Visão — useHBN como camada de governança epistêmica automatizada

Documento de VISÃO/estratégia (lição/futuro; vira ADR-visão quando entrar em onda formal).
Pergunta: como o HBN evolui para rodar SOBRE Omnigent/Claude Code/Codex, automatizando a
mensageria entre IAs, de modo que o humano interaja só num chat "orquestrador"?

## 1. A reframulação central
Hoje o humano faz três papéis: **carteiro** (cola dispatch nas IAs), **carteiro de volta** (cola
pareceres) e **gate** (aprova e roda a cerimônia). A automação **elimina os dois primeiros e
preserva o terceiro**. O humano vira *só o gate*, num único chat. Nada nos princípios muda:
janela limpa, auditoria cross-family, guards fail-closed, história sagrada e gate humano continuam.

## 2. As camadas (separação de responsabilidades)
- **Humano** — um único chat orquestrador. Vê o painel/estado; decide nos gates. Não transporta nada.
- **Camada de GOVERNANÇA EPISTÊMICA = useHBN** (o que estamos construindo): a constituição (P1–P13),
  os guards, o livro-razão, readback/hearback, a regra cross-family, a doutrina do orquestrador, a
  Exúvia. Responde "**o que é uma onda válida e como sabemos que é verdade**".
- **Camada de ORQUESTRAÇÃO/AUTOMAÇÃO** (substrato): um runner que abre sessões limpas, roteia
  mensagens e aplica sandbox/policies. Candidatos: **Omnigent** (meta-harness pronto, com runner
  uniforme + aprovação-humana-antes-do-push + sandbox), ou um runner próprio leve (estilo LangGraph,
  como grafo de estados com checkpoints).
- **Camada de EXECUÇÃO** (as IAs): Codex/Gemini/Claude invocadas em **janela limpa** via suas
  CLIs/harnesses. Transporte entre famílias = **A2A** (padrão aberto, v1.0, multi-vendor).
- **Camada de VERDADE** = git + guards: o livro-razão imutável e o enforcement mecânico. Continua
  sendo a fonte da verdade e o backstop fail-closed — mesmo que a automação falhe.

O HBN é a camada **de cima** (governança); Omnigent/Claude Code/Codex/A2A são o **substrato** (execução
e transporte). O HBN pode trocar de substrato (Fagocitose) sem mudar os princípios — isso é a "parte dura".

## 3. O loop automatizado de uma onda (o que a automação faz por você)
1. **Você** descreve a intenção no chat orquestrador (ou aprova uma onda proposta).
2. **Orquestrador (IA)** desenha a onda e emite um **dispatch estruturado** (declaração: papel, escopo,
   readback, leituras obrigatórias, critérios). Já é o que faço hoje — só que legível por máquina.
3. **Runner** abre uma **sessão limpa do implementador** (ex.: Codex headless), injeta o dispatch e a
   *warm-boot pela leitura do disco* (não por colagem), captura a saída e grava na árvore.
4. **Runner** abre **duas sessões limpas de auditores cross-family** (ex.: Gemini + um terceiro ≠
   implementador), coleta os pareceres no `.hbn/results/`.
5. **Orquestrador** consolida em prosa (cláusula 7/8) e apresenta **um único ponto de decisão** a você:
   o que muda, por quê, vereditos da auditoria, risco — e pede o gate.
6. **Você aprova** → o runner roda a cerimônia (commit humano-aplicado com token), os guards validam
   fail-closed. **Você reprova** → volta ao passo 2 com seu motivo.
7. O painel e a **trilha de aprendizagem** (logs frios) registram tudo; o "dream" consolida offline depois.

Resultado: a mensageria "vai e volta" sozinha; você só entra nos passos 1 e 6.

## 4. Roadmap em fases (cada fase passa pela cerimônia do próprio protocolo — dogfooding)
- **Fase 0 (hoje):** 100% manual. Humano é carteiro + gate. (Funciona, mas cansa.)
- **Fase 1 (MVP):** dispatch estruturado + runner fino que automatiza **um salto** (ex.: chamar o Codex
  headless e devolver a saída ao chat orquestrador). Humano ainda gateia o commit. Reduz metade da cola.
- **Fase 2:** loop completo de uma onda automatizado (implementador → 2 auditores → consolidação →
  **um** gate humano → cerimônia). Transporte por CLI-piping ou A2A.
- **Fase 3:** substrato meta-harness (**Omnigent**): troca o runner próprio pelo API uniforme + sandbox
  + policies; HBN cavalga por cima. Cross-vendor via A2A.
- **Fase 4:** orquestrador-maestro: você conversa só com o orquestrador; ele planeja ondas, dispara,
  monitora, e só te interrompe nos gates. Memory/Dream consolidam a trilha offline e propõem melhorias
  (sempre auditadas, nunca autoaplicadas).

## 5. Como cada invariante é preservado sob automação
- **Janela limpa** — *mais fácil* automatizada: cada chamada é uma sessão nova semeada só pelo disco.
- **Cross-family** — o runner escolhe auditores ≠ fornecedor do implementador (cláusula 9, programática).
- **Gate humano** — a automação **pausa** nos pontos de gate (commit/push, adoção de exceção, muda) e
  exige aprovação. Omnigent já faz "aprovação humana antes do push".
- **Guards fail-closed** — continuam nos hooks de git: se a automação errar, o commit é barrado.
- **Auditabilidade/reversibilidade** — git + tags de Exúvia + manifesto; checkpoints estilo LangGraph.
- **Anti-teatro de validação (ADR-020)** — o gate só vale se for **informado**: o orquestrador entrega
  resumo honesto em prosa para você decidir, não um "OK?" cego. Automação que vira carimbo é falha.

## 6. Riscos e mitigações (honesto)
- **Perda de consciência situacional** do humano → painel + trilha + resumos de gate em prosa.
- **Conluio/groupthink entre IAs** → regra cross-family + guards mecânicos permanecem.
- **Bug na automação burlando um gate** → guards de git + token (G-TOK) + commit humano-aplicado são o
  backstop; a automação **propõe**, o git **dispõe**.
- **Vendor lock / instabilidade de API** → desenho family-agnostic + A2A; substrato é fagocitável.
- **Custo/tokens** → policies de orçamento (estilo Omnigent).
- **Latência** (ex.: guard semântico por IA no hook) → manter o caro fora do caminho crítico do commit.

## 7. O que já temos que encaixa
- **Cláusula 9** (roteamento de modelo + cross-family) = a regra que o runner automatiza.
- **Painel** + **trilha de aprendizagem** = a consciência situacional do humano no modo automatizado.
- **Exúvia** = o substrato também muda de forma sem perder legado (inclui trocar de runner).
- **A2A / Omnigent / LangGraph** = substrato pronto e verificado (2026) — não precisamos inventar.

## 8. Próximo passo proposto (quando chegar a hora)
Não agora (estamos estabilizando). Quando entrar: **Fase 1 MVP** como onda formal — desenhar o formato
do *dispatch estruturado* + um runner fino que automatize um salto (Codex headless), preservando todos
os invariantes, com proposta → cross-audit → ratificação. É a primeira Fagocitose de automação.
