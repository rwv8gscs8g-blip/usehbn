---
knowledge-id: 0030
titulo: Chat novo sem memoria exige prompt autocontido, sequencial e com preflight fail-closed
status: accepted
temperatura: quente
path: versao_3_0_0/.hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
data: 2026-06-30
origem: onda 0107-KNOW-PROMPT-CHAIN — o orquestrador entregou prompts de implementacao e auditoria em lote; auditores em chat novo auditaram o disco antes de existir implementacao e reprovaram corretamente.
revisar-em: 2026-12-30
---

# 0030 — prompts externos sao sequenciais, autocontidos e fail-closed

## A regra

Toda IA externa acionada pelo orquestrador deve ser tratada como **chat novo,
sem memoria**. O prompt precisa ser autocontido: papel, familia, repo, alvo,
preflight, escopo permitido/proibido, condicao de parada, forma de entrega e
arquivos esperados em disco.

O orquestrador entrega **um unico bloco HBN-COPY por passo**. Nao envie a fila
inteira de implementacao + auditoria + selagem no mesmo turno. O proximo bloco
so e emitido depois de conferir no disco o resultado do anterior.

## Sequencia obrigatoria

1. Implementador recebe um unico bloco de implementacao.
2. Orquestrador aguarda `pronto` humano ou retorno do implementador.
3. Orquestrador le o disco e verifica que o alvo existe: handoff do
   implementador, arquivos tocados, testes e evidencias.
4. Somente entao emite um unico bloco de auditoria para uma familia
   independente.
5. Segundo auditor so recebe prompt depois de existir alvo auditavel ou depois
   de decisao humana explicita para auditoria paralela read-only.

Auditor que receber prompt sem alvo em disco deve falhar fechado: salvar parecer
`APROVA_NNNN: NAO` por alvo ausente, sem inventar patch nem presumir entrega
futura.

## Forma do prompt

Todo prompt para IA externa deve declarar:

- `SOU:` esperado na primeira linha da resposta.
- `CHAT NOVO, SEM MEMORIA`.
- Repo e branch/HEAD esperados.
- Arquivos a ler antes de agir.
- Preflight fail-closed com arquivos que DEVEM existir antes de prosseguir.
- Escopo permitido e proibido.
- Condicao exata de entrega.
- Caminho de arquivo onde o resultado deve ser salvo, quando aplicavel.
- Ultima linha/veredito esperado.

O bloco colavel mostrado no chat deve ser o mesmo conteudo salvo em `.md`.
Resumo ou reescrita curta no chat nao substitui o bloco integral.

## Membrana

Esta regra e conhecimento de protocolo, nao preferencia local. Quando selada,
deve atravessar a membrana via snapshot para projetos consumidores. O guard
posterior deve melhorar o desenvolvimento em todos os projetos: prompts de
auditoria e implementacao gerados dentro do protocolo devem ser verificaveis por
disco antes de virarem rito reutilizavel.

## Anti-padroes proibidos

- Entregar tres blocos HBN-COPY numa resposta e esperar que cada IA saiba a
  ordem global por contexto de chat.
- Mandar auditor auditar "o patch entregue" sem handoff, arquivo alvo ou saida
  de teste em disco.
- Dizer "pronto para auditoria" sem conferir `git status`, arquivo alvo e
  evidencias.
- Emitir prompt de auditoria para chat novo sem preflight fail-closed.
- Colar no chat uma versao resumida diferente do `.md` salvo.

## Proxima mecanizacao

Esta knowledge deve alimentar guard futuro: `G-ORQ-XAUDIT-GATE` /
`G-ORQ-CHAT-COPY`. O guard deve bloquear prompt cross-audit novo sem destino de
resultado, sem preflight de alvo existente ou sem bloco HBN-COPY autocontido.
