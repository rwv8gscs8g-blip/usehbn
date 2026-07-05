---
knowledge-id: 0032
titulo: Prompts autocontidos com saida canonica
status: congelado
temperatura: glacier
path: .hbn/knowledge/0032-prompts-autocontidos-output-canonico.md
data: 2026-07-01
origem: dogfooding P2-D3 Credenciamento - prompt incremental dependia de contexto anterior e gerou plano apenas na UI do Antigravity, fora do disco canonico.
revisar-em: 2027-01-01
---

# 0032 - prompts autocontidos com saida canonica

## Regra

Todo prompt enviado para uma IA externa deve funcionar em janela nova, sem
memoria e sem acesso a mensagens anteriores. O bloco `HBN-COPY` precisa conter
o contexto minimo, o repo alvo, o HEAD esperado quando aplicavel, os paths
canonicos de entrada e saida e o criterio de pronto.

Nao use instrucoes como "continue a partir do prompt anterior", "use o plano
original" ou "siga do seu plano". Se a acao depende de uma decisao anterior,
reescreva a decisao dentro do novo prompt.

## Saida em disco

Todo plano, handoff, resultado ou auditoria pedido a outra IA deve ter path
canonico explicito, por exemplo:

- `.hbn/messages/AAAAMMDD-HHMMSS-agente-plan-escopo.md`
- `.hbn/messages/AAAAMMDD-HHMMSS-agente-handoff-escopo.md`
- `.hbn/results/AAAAMMDD-HHMMSS-agente-cross-ia-escopo.md`

Artefatos soltos como `implementation_plan.md`, criados apenas pela UI da
ferramenta, nao contam como evidencia canonica e nao devem ser stageados.

## Consequencia de falha

Se o prompt nao for autocontido ou nao indicar saida canonica, o resultado da
IA externa nao e confiavel para quorum, selagem, handoff ou commit. O
orquestrador deve reemitir um prompt v2 autocontido antes de usar o resultado.

## Guard vigente

`G-COPY` bloqueia prompts novos que:

- nao declaram `CHAT NOVO` e `SEM MEMORIA` no payload colavel;
- nao trazem path absoluto sob `/Users/macbookpro/Projetos/`;
- nao declaram destino canonico de saida;
- dependem de prompt/plano/mensagem anterior;
- citam `implementation_plan.md` como artefato de trabalho.
