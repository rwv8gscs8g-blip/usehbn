---
path: .hbn/messages/20260618-121842-codex-handoff-w-orq-3.md
readback_id: 0061-w-orq-3
agent_id: codex
familia: OpenAI
created_at: 2026-06-18T12:18:42-03:00
---

# Handoff W-ORQ-3

SOU: codex · familia OpenAI · papel implementador

## RELATO DE ESTADO — codex · implementador · 2026-06-18T12:18:42-03:00
SOU: codex · familia OpenAI · papel implementador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-18T12:18:42-03:00
PRÓXIMA AÇÃO: Cross-audit W-ORQ-3 por grok/xAI e antigravity/Google com APROVA_0061: SIM; depois hearback humano de Mauricio e selagem em readback proprio 0062+ antes do W-FREEZE.
SITUACAO: W-ORQ-3 entregue; G-ORQ-REF ativo no runner; B48-B51 bloqueados.
BASTAO: segue sob orquestrador para cross-audit e gate humano.

## Entrega

Implementei `guards/assert-orq-entrada-ref.sh` como guard aditivo para atos de
autoridade do orquestrador:

- despacho: `.hbn/dispatch/*.md`, validando o readback declarado;
- selagem: `.hbn/readbacks/*.json` com `authority_act/ato_autoridade=selagem`,
  status `selado`/`vigente` ou nome contendo `selagem`;
- freeze: `.hbn/freeze/*.json`.

Para esses atos, o guard exige `orq_entrada_ref` no JSON em curso, compara com
`.hbn/attestations/<fp>-orq-entrada.json` derivado dos 8 hex iniciais de
`bastao_token_sha256` no STATE, verifica existencia no indice/HEAD e chama
`guards/assert-orq-entrada.sh` para a validacao vigente da atestacao. O guard
tambem bloqueia re-pin de `.hbn/attestations/<fp>-orq-entrada.json` no mesmo
commit de ato de autoridade.

Atos nao-autoridade continuam isentos: a suite inclui uma entrega
`.hbn/readbacks/0061-w-orq-3.json` sem `selagem` e sem `orq_entrada_ref` como
caso pass em fixture descartavel.

## Evidencia Mecanica

```text
$ bash guards/tests/run-guard-tests.sh
== resumo: 208 passaram, 0 falharam ==
SUITE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

```text
$ bash guards/tests/adversarial-battery.sh
B48 despacho com orq_entrada_ref omitido             | G-ORQREF | BLOQUEADA
B49 orq_entrada_ref dangling/ausente                 | G-ORQREF | BLOQUEADA
B50 orq_entrada_ref com fp trocado                   | G-ORQREF | BLOQUEADA
B51 auto-repin no ato de autoridade                  | G-ORQREF | BLOQUEADA
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

```text
$ git rev-parse main
4db692876381a0d7909985c8500d999f2e677b04
```

```text
$ bash guards/hbn-guards-runner.sh
[hbn-guards] Todos os guards passaram.
```

## Proxima Acao

Cross-audit W-ORQ-3 por pelo menos duas familias nao-OpenAI:
grok/xAI e antigravity/Google. Cada parecer deve conter uma linha isolada
exata `APROVA_0061: SIM` e front matter `path:` real. Depois disso, gate
humano de Mauricio antes da selagem em readback proprio 0062+.

## Trailers Obrigatorios

```text
HBN-Readback: 0061
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```
