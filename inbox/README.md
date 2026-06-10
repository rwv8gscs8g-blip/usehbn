---
titulo: Inbox — porta única de entrada de feedback dos projetos para o protocolo
status: accepted
temperatura: quente
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente C2)
origem: ADR-008 v2 §Decisão 2 + decisão Q1 de Maurício (projetos só propõem)
hearback-status: confirmado 2026-06-10 (readback 0001 / hearback 0001)
---

# Inbox — como um projeto fala com o protocolo

Projetos consumidores (Credenciamento, timelessphoto, futuros) **não editam
o canônico**. Quando uma onda revela necessidade de evolução do protocolo
(regra nova, dor de retomada, proposta de guard), o projeto deposita um
arquivo AQUI e segue trabalhando — o protocolo responde no ciclo do
arquiteto, não no calor da onda.

## Endereço e nome

```
inbox/<projeto>/<AAAAMMDD-NN>-<slug>.md
```

- `<projeto>`: pasta fixa em kebab-case (`credenciamento`, `timelessphoto`).
- `<AAAAMMDD-NN>`: id do ADR-011 (data do depósito + sequência do dia DENTRO
  da pasta do projeto). O namespace por pasta garante: dois projetos nunca
  colidem; duas frentes do mesmo projeto só coordenam o NN do dia corrente.
- `<slug>`: 3–6 palavras kebab-case do tema.

Ex.: `inbox/credenciamento/20260610-01-guard-state-fresh-pedido.md`.

## Front-matter mínimo do item

```yaml
titulo: <uma frase>
projeto: credenciamento
data: AAAA-MM-DD
autoria: <ia ou humano> (onda <NNNN>, se houver)
temperatura: quente          # vira frio quando consolidado/recusado/adiado
tipo-sugerido: adr | knowledge | core-spec | guard | outro
evidencia: <path ou medição que motivou — Truth Barrier>
```

## Ciclo de consolidação (papel do arquiteto)

A cada ciclo o arquiteto lê todos os itens `quente` e decide, por item:

1. **Consolida** → vira ADR/knowledge/spec `proposed` no canônico, com
   `origem:` apontando o item; OU
2. **Recusa** → appenda justificativa de 1 parágrafo no próprio item; OU
3. **Adia** → appenda `gatilho: <data>` + `dono: <pessoa>` (meta-regra do
   ADR-008 v2: nada bloqueia em evento sem dono).

Em todos os casos o item vira `temperatura: frio` com link para o destino.
**Nada é deletado; nada do inbox governa o protocolo por si** — adoção real
sempre passa por proposta no canônico + hearback de Maurício.

## Regras duras

- Item de inbox não edita nada fora da própria pasta (é proposta, não patch).
- Escrita de IA de projeto no canônico = SÓ aqui. O resto do repo é do
  arquiteto (firewall 0022 e Q1 permanecem intactos).
- Pasta nova de projeto: criada pelo arquiteto no primeiro depósito.
