---
path: .hbn/messages/20260618-153000-codex-handoff-w-orq-3b.md
readback_id: 0062-w-orq-3b
agent_id: codex
familia: OpenAI
created_at: 2026-06-18T15:30:00-03:00
---

# Handoff W-ORQ-3b

SOU: codex · familia OpenAI · papel implementador

## RELATO DE ESTADO — codex · implementador · 2026-06-18T15:30:00-03:00
SOU: codex · familia OpenAI · papel implementador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-18T15:30:00-03:00
PRÓXIMA AÇÃO: Cross-audit W-ORQ-3b por grok/xAI e antigravity/Google exigindo dogfood P1; depois hearback humano de Mauricio e selagem 0063 antes do W-FREEZE.
SITUACAO: W-ORQ-3b entregue; Exit A' implementado; guards verdes; dogfood P1 demonstrado; aguardando cross-audit.
BASTAO: segue sob orquestrador para cross-audit e gate humano.

## Entrega

Implementei a saida Exit A' para o deadlock do G-ORQ-REF. Em ato de autoridade,
`guards/assert-orq-entrada-ref.sh` agora permite alterar somente a atestacao esperada
`.hbn/attestations/<fp>-orq-entrada.json` quando a mudanca e uma regeneracao real
same-fp: fp do nome, JSON antigo, JSON novo e STATE novo coincidem; `manifest_sha256`
muda; `bastao_token_sha256` completo do STATE permanece igual; `proprietario_bastao`
e `identidade` preservam a proveniencia do HEAD/base; qualquer ambiguidade bloqueia.

Tambem adicionei suporte de validacao por commit ao `assert-orq-entrada.sh` para o
modo CI do G-ORQ-REF, e uma checagem aditiva de `proprietario_bastao` contra o STATE.
Nao alterei `core/**`, `schemas/**`, `src/**`, `methodology/**`, `.hbn/freeze/**` ou
`main`.

## Evidencia Mecanica

```text
$ bash guards/tests/run-guard-tests.sh
  ✓ orq-ref P1: selagem real same-fp passa G-ORQ + G-ORQ-REF (esperado: pass)
  ✓ orq-ref N1: selagem sem regenerar atestacao → BLOCK (esperado: block)
  ✓ orq-ref N2: atestacao decorativa sem manifest novo → BLOCK (esperado: block)
  ✓ orq-ref N3: atestacao esperada com fp JSON trocado → BLOCK (esperado: block)
  ✓ orq-ref N4: atestacao extra staged junto → BLOCK (esperado: block)
  ✓ orq-ref N5: bastao_token_sha256 completo trocado com mesmo fp → BLOCK (esperado: block)
  ✓ orq-ref N6: identidade divergente do HEAD/base → BLOCK (esperado: block)
  ✓ orq-ref CI: selagem same-fp passa no range (esperado: pass)
  ✓ orq-ref CI: fp trocado bloqueia no range (esperado: block)

== resumo: 217 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

```text
$ bash guards/tests/adversarial-battery.sh
B48 despacho com orq_entrada_ref omitido             | G-ORQREF | BLOQUEADA ✓
B49 orq_entrada_ref dangling/ausente                 | G-ORQREF | BLOQUEADA ✓
B50 orq_entrada_ref com fp trocado                   | G-ORQREF | BLOQUEADA ✓
B51 auto-repin sem regeneracao real                  | G-ORQREF | BLOQUEADA ✓
B52 atestacao esperada com fp JSON trocado           | G-ORQREF | BLOQUEADA ✓
B53 full-SHA do bastao trocado com mesmo fp          | G-ORQREF | BLOQUEADA ✓
B54 atestacao extra staged junto ao ato              | G-ORQREF | BLOQUEADA ✓

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

Cross-audit W-ORQ-3b por pelo menos duas familias nao-OpenAI: grok/xAI e
antigravity/Google. Cada parecer deve verificar explicitamente o dogfood P1
("selagem real same-fp passa") e conter uma linha isolada `APROVA_0062: SIM`
com front matter `path:` real. Depois: hearback humano de Mauricio e selagem
0063 antes do W-FREEZE.

## Fora De Escopo Preservado

Sem merge; sem `--no-verify`; sem `git add .`; sem tocar `main`, `core/**`,
`schemas/**`, `src/**`, `methodology/**`, `docs/brainstorm/**` ou
`.hbn/freeze/**`.

## Trailers Obrigatorios

```text
HBN-Readback: 0062
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```
