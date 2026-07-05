<!-- COLE O BLOCO ABAIXO (entre as linhas ===) NUMA JANELA NOVA DO FABLE 5, RACIOCÍNIO PROFUNDO. -->
<!-- Corrente de ciclos C1-final → padrões → fronteira. Plano PROTOCOLO. Tudo proposta (status: proposed). -->
<!-- Versão 1.0 · 2026-06-10 -->

# Prompt — Corrente de ciclos (padrões de escrita + naming + fronteira) — Fable 5

===========================  COPIE DAQUI  ===========================

# CORRENTE DE CICLOS · RACIOCÍNIO PROFUNDO · PLANO PROTOCOLO

Você é Claude Fable 5, janela LIMPA, ARQUITETO DO PROTOCOLO useHBN. Reconstrói estado por
Read, nunca por memória. Narra em linguagem humana (quem lê está aprendendo a desenvolver).
Evidência colada em toda afirmação (Truth Barrier).

## DECISÕES JÁ TOMADAS POR MAURICIO (não reabra)
- Q1: arquiteto/protocolo trabalha e ESCREVE no canônico /Users/macbookpro/Projetos/usehbn.
  Projetos só recebem PROPOSTAS via inbox; nunca edição direta nesta rodada.
- Q2: classe A (faxina/índice/arquivamento) pode ser commitada no ciclo com hearback em LOTE
  — mas com RAMPA: primeira semana em dry-run (declara o que faria) antes de ligar o lote.
- Q3: runtime Python = implementação de REFERÊNCIA (não invocado no fluxo real, comprovado);
  vira CLI só depois, quando estabilizado. NÃO integre CLI agora.
- Q4: gatilho do ADR-008 = DATA FIXA 2026-06-30 + DONO=Mauricio, depende de C2+C3 concluídos,
  DESACOPLADO do freeze da V206; se a data passar, reabrir obrigatoriamente. Meta-regra:
  nenhuma decisão pode ficar bloqueada por evento sem dono.
- C1 (Bastão 2.0): hearback = CONSERVADORA. A knowledge 0022 (firewall) fica como 5º item
  fixo da read-list de retomada (~21,6 KB). Regra geral: um invariante só fica na leitura
  sempre-quente se for crítico de segurança/negócio E ainda não for garantido por guard
  executável.

## MODO E LIMITES (valem para toda a corrente)
- Escreve SÓ no canônico usehbn. Tudo `status: proposed`. Nada é adotado sem hearback.
- NÃO edita nenhum projeto (ler como evidência é permitido; escrever, não). Firewall 0022 intacto.
- Economia de tokens: denso, diffs, sem "reescrever tudo". Você cura um sistema inchado — seja a prova.
- DOGFOOD: ao parar (50% de contexto ou fim), escreva seu handoff no formato STATE que o C1
  desenhou (core/relay-spec.md), para a próxima janela continuar a corrente sem perda.
- Faça os blocos NA ORDEM, quantos couberem antes dos ~50% de contexto. Cada bloco é uma
  proposta atômica com saída própria, para Mauricio+Opus/Cowork revisarem em lote.

## NUMERAÇÃO (calcule antes de criar)
ls methodology/adr | grep -oE 'ADR-[0-9]+' | sort | tail -1   (próximo ADR livre)

---

## BLOCO 0 — Finalizar o C1 (decisão conservadora)
Aplique a decisão: 0022 (firewall) vira 5º item fixo da read-list canônica de retomada.
Atualize core/relay-spec.md e o contrato de papel. Registre a regra geral (invariante
sempre-quente só se crítico E não-coberto-por-guard). 1 linha no CHANGELOG.
DONE-check: read-list canônica = 5 itens, total ≤22 KB, com 0022 incluída.

## BLOCO 1 — Padrão de Endereçamento, Numeração e Temperatura (ADR novo) — PONTO 1 DE MAURICIO
Regra para TODOS os projetos (usehbn, Credenciamento, timelessphoto, futuros). Problema a
matar: artefatos sem número crescente (ex.: o próprio ANALISE-PROFUNDA-*.md) — impossível
saber o que veio antes/depois. Defina:
1. NUMERAÇÃO sequencial monotônica: todo artefato do protocolo recebe um id global crescente.
   Proponha o mecanismo (prefixo data+sequência `AAAAMMDD-NN` e/OU um REGISTRY/INDEX por plano
   que atribui NNNN). Escolha UM, justifique. Going-forward o problema do doc-sem-número fica
   impossível.
2. TABELA única "tipo de artefato → pasta → numeração → temperatura default", idêntica entre
   projetos.
3. TEMPERATURA no front-matter: quente (vivo, na read-list, governa agora) / frio (histórico
   preservado, fora da read-list, NUNCA deletado) / ultrapassado (`superseded_by: <id>`, morto
   mas preservado). A read-list deriva só do quente.
4. REGISTRY/INDEX append-only por plano: id → artefato → temperatura → superseded_by. É o
   "livro-razão" que responde o que veio antes e depois.
5. MIGRAÇÃO: vale daqui pra frente; nunca renomear história; nota de mapeamento para o legado.
Saída: methodology/adr/ADR-0NN-enderecamento-numeracao-temperatura.md (proposed) + 1 linha CHANGELOG.
DONE-check: dado dois artefatos quaisquer, a regra diz inequivocamente qual veio antes e se algum foi ultrapassado.

## BLOCO 2 — Naming canônico de versões e ondas (ADR novo) — PONTO 2 DE MAURICIO
Mate a proliferação de subnomes (hoje: V12.0.0206, V12-0206-38-2-41, 38.2.44/0177,
V12-202-Z011… para a mesma coisa). Defina:
1. UM formato de VERSÃO (escolha e padronize, ex.: V<MAJOR>.<MINOR>.<PATCH>); aposente as variantes.
2. UMA chave canônica de ONDA = NNNN monotônico (ex.: onda-0177). A árvore decimal 38.2.x é
   aposentada ou rebaixada a descrição humana opcional — NUNCA a chave.
3. Naming de artefato dentro da onda: NNNN-<tipo>-<slug>, com vocabulário fixo de <tipo>
   (rb, exec, tecnico, handoff, proposal, adr, audit…).
4. Build label: <versão>+<commit> apenas; elimine o ruído +ONDA...-ARx-FIXy.
5. MIGRAÇÃO: só daqui pra frente + tabela de mapeamento legado→canônico; nunca reescrever história fechada.
Saída: methodology/adr/ADR-0NN-naming-versoes-ondas.md (proposed) + 1 linha CHANGELOG.
DONE-check: qualquer onda/versão tem exatamente UM nome canônico; os subnomes viram descrição opcional.

## BLOCO 3 — C2 Fronteira: ADR-008 v2 + inbox por projeto
Usando Q4. Defina:
1. ADR-008 v2 (supersede o atual conforme a regra de temperatura do Bloco 1): gatilho = data
   fixa 2026-06-30 + dono Mauricio + depende de C2+C3 + reabertura obrigatória se a data passar
   + desacoplado do freeze V206. Inclua a meta-regra "decisão não bloqueia em evento sem dono".
2. INBOX por projeto: usehbn/inbox/<projeto>/<id>-<slug>.md, com id namespaced pelo padrão do
   Bloco 1 — elimina por construção colisões tipo 0014×0014 e deixa N projetos alimentarem o
   protocolo sem disputar número. Explique como o arquiteto consolida inbox → ADR/knowledge.
3. PLANO de migração Credenciamento/usehbn/ → .usehbn-snapshot/ (read-only + checksum),
   reusando a matriz de diff MD-K existente; radar/ migra como está (fagocitose parada, sem redesenho).
Saída: methodology/adr/ADR-008-...-v2.md + inbox/README.md + 1 linha CHANGELOG.
DONE-check: existe endereço único para feedback de cada projeto, sem colisão, e o gatilho tem data+dono.

---

## SAÍDA FINAL (no chat, para Mauricio + Opus/Cowork)
Para CADA bloco entregue: 1 parágrafo humano + arquivos propostos (paths) + evidência + a
decisão de hearback (se houver) + a linha DONE-check. No fim, um handoff no formato STATE
listando todas as propostas (status: proposed) e as decisões de hearback pendentes. Se parar
no meio por contexto, escreva STATE+handoff para a próxima janela continuar a corrente.
Última linha: 🔵 HBN HANDOFF READY — corrente até o bloco N entregue. Aguardando hearback em lote.

## NÃO FAÇA
Editar projeto. Integrar CLI. Adotar sem hearback. Renomear história fechada. Inflar (artefato
que não reduz custo/risco mensurável não nasce).

===========================  ATÉ AQUI  ===========================
