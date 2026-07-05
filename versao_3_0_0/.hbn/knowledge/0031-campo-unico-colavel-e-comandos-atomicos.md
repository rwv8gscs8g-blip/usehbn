---
knowledge-id: 0031
titulo: Campo unico colavel e comandos atomicos para prompts externos
status: accepted
temperatura: quente
path: versao_3_0_0/.hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
data: 2026-06-30
origem: onda 0109-correcao-prompt-g-state - prompt externo com cercas de codigo internas foi colado incompleto no Grok, tornando o resultado nao confiavel para quorum.
revisar-em: 2026-12-30
---

# 0031 - campo unico colavel e comandos atomicos

## Regra

Todo prompt destinado a IA externa deve ser entregue ao humano em um unico campo
copiavel no chat, com o mesmo conteudo salvo em `.md`.

O conteudo do campo copiavel nao pode conter cercas Markdown de codigo
aninhadas, como tres crases. Cercas internas encerram o campo em muitos chats e
produzem prompt truncado. Se for necessario mostrar template ou comando dentro
do prompt, use linhas rotuladas, indentacao simples ou texto literal sem cercas.

## Comandos

Quando o prompt mandar uma IA ou humano executar terminal, cada comando deve
aparecer como item atomico e individual:

- COMANDO 1: `git rev-parse HEAD`
- COMANDO 2: `git status --short`

Nao agrupe varios comandos em um bloco unico. Nao use `&&`, `;`, pipes ou
substituicoes quando a finalidade for entrega operacional ao humano. Se a IA
externa puder executar comandos, ela deve executar um por vez e registrar a
saida de cada um.

## Consequencia de falha

Prompt colado de forma incompleta, truncada ou fora de campo unico nao gera
evidencia confiavel. Resultado produzido por esse prompt nao conta para quorum,
selagem ou auditoria cruzada ate ser reemitido em v2 valido e reexecutado.

## Forma minima

1. Um unico campo copiavel no chat.
2. Um unico bloco `HBN-COPY` dentro do arquivo `.md`.
3. Nenhuma cerca Markdown de tres crases dentro do bloco.
4. Comandos de terminal numerados um a um.
5. Caminho canonico de resultado quando houver entrega em disco.
6. Ultima linha/veredito esperado.

## Mecanizacao futura

Esta regra deve alimentar guard futuro `G-ORQ-CHAT-COPY`:

- bloquear prompts novos com cercas Markdown internas dentro de `HBN-COPY`;
- bloquear secao de comandos com multiplos comandos agrupados;
- exigir que prompt salvo em `.md` seja entregavel como campo unico em chat;
- marcar prompt superseded como nao apto para quorum.
