---
titulo: "PROPOSTA: revogar HBN_GUARDS_BYPASS nos guards não estruturais (rota única G-EXC)"
tipo: knowledge
status: proposto
temperatura: quente
path: .hbn/knowledge/0034-proposta-revogacao-bypass-guards-nao-estruturais.md
created_at: "2026-07-05T20:24:51-03:00"
autor: fable-5
familia: Anthropic
natureza: nativo
gate: "\"NÃO IMPLEMENTAR sem hearback humano (readback 0002 T6.2 — proposta, não decisão)\""
---
# PROPOSTA — revogar o bypass residual dos guards não estruturais

## O fato (parecer grok 20260705-174859, furo 4)

`guards/lib/common.sh` (`guard_check_bypass`) ainda aceita
`HBN_GUARDS_BYPASS=1` + nota staged em `.hbn/bypasses/` para **pular** ~32
guards não estruturais (ex.: `forbid-env-files.sh`; caso I-06 da suíte).
G-HOT-WRITE, G-NO-PENDING-EXUVIA e o runner ignoram bypass por desenho, mas o
desarme parcial do perímetro segue possível fora da trava de versão.

## Por que revogar (contexto missão crítica)

Causa mecânica 4 do BOOT §4: "todo escape hatch documentado será usado". Em
sistemas de missão crítica, um canal de exceção legítimo já existe e é
rastreável, assinado e humano: **G-EXC**. Dois canais de exceção = regra
concorrente (causa mecânica 1).

## Proposta (para decisão do gate, onda própria)

1. `guard_check_bypass` passa a retornar sempre "sem bypass" (ou é removido);
   a nota em `.hbn/bypasses/` deixa de ter efeito.
2. Toda exceção passa exclusivamente pela rota G-EXC (exceção assinada,
   rastreável, com hearback humano).
3. Suíte: os checks I-06 invertem — env com nota staged passa a **BLOQUEAR**
   (teste negativo da revogação, no mesmo commit — R2 do BOOT §9).
4. Migração: inventariar `.hbn/bypasses/` vivos antes; cada um vira G-EXC ou
   morre.

## Risco de NÃO revogar

Auditoria externa (grok) já classificou o bypass residual como furo. Adotantes
de missão crítica herdam o canal pelo snapshot da membrana (guards descem ao
consumidor).

## Status

`proposto` — aguarda hearback do gate. Nenhuma mudança de guard foi feita por
esta knowledge.
