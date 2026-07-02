---
titulo: "TRANSICAO — o único documento de passagem do v0.3.x para o v2 (decisão travada 2026-06-15 §4.2)"
status: proposto
temperatura: quente
path: versao_2_0_0/TRANSICAO.md
created_at: "2026-07-01T19:50:00-03:00"
autor: fable-5
familia: Anthropic
---

# TRANSICAO — v0.3.x → v2

## Por que houve exúvia

O v0.3.x ("Honest Foundation") venceu a batalha do enforcement: 30+ guards
mecânicos, 95+ casos de teste, bateria adversarial, quórum de famílias, CI.
Mas perdeu a batalha do contexto: ~2.500 linhas de leitura obrigatória de
entrada, 22 specs + 27 ADRs + 19 knowledge + STATE com campo de milhares de
caracteres. IAs colapsavam de coerência antes de agir; ~50% da janela era
consumida no rito de entrada; a proporção governança/código chegou a ~3:1.
Diagnóstico completo: `~/Projetos/20260701-183000-fable-5-diagnostico-
definitivo-e-plano-execucao.md` (seções 3–4).

Em 2026-07-01 Maurício declarou **corte crítico por incapacidade operacional**
e autorizou o bootstrap desta versão em passada única por fable-5, com
auditoria cruzada de 4 famílias como contrapeso.

## O que mudou

| Dimensão | v0.3.x | v2 |
|---|---|---|
| Leitura de entrada | ~2.500 linhas dispersas | BOOT (~150) + STATE resumo (≤30) + cartão (~40) |
| Specs normativas | 22 arquivos + 27 ADRs entrelaçados | 8 consolidadas + 3 contratos verbatim |
| STATE | campo `protocolo` com histórico inteiro numa linha | resumo executivo ≤30 linhas; histórico fica no git/REGISTRY |
| Regra nova | doutrina acumulativa | só com guard + teste (R2); orçamento duro (R1) |
| Guards | 30+3 no runner | os MESMOS, sem alteração (vendorizados) |
| Evolução | ondas de emenda infinitas | loops com orçamento + muda por exúvia (core/08) |

## O que NÃO mudou (invariantes preservados)

Princípios P1–P13 · separação de papéis e famílias · quórum de 2 famílias +
hearback humano · Truth Barrier fail-closed · chokepoint de commit · nome
universal por carimbo · REGISTRY append-only · temperatura · membrana de
projetos · fingerprint do bastão `34a7f2f9` · todos os guards e testes.

## Onde ficou o passado

O exoesqueleto v0.3.x permanece INTEIRO na raiz do repo (história git
imutável, REGISTRY antigo, ADRs, 115 readbacks). Nada foi apagado. Consulta
histórica é livre; citação como regra vigente é proibida (temperatura fria).
Mapeamento elemento a elemento: `MANIFESTO-MIGRACAO.md`.

## Como esta versão entra em vigor

Cross-audit 4 famílias → consolidação pelo arquiteto → Fitness Gate
(`FITNESS-CHECKLIST.md`, inclui V206 real) → hearback humano → flip de
`.hbn/active-version` para `versao_2_0_0` em commit próprio → tag anti-GC
`hbn-exuvia/protocol-0.3.x`. Rollback: `scripts/hbn-exuvia-rollback.sh`
(dry-run; `--apply` só humano), reconciliando token×STATE conforme scaffold M-A.
