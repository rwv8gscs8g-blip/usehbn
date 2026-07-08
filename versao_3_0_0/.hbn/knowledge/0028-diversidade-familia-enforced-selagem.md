---
titulo: Diversidade de familia enforced na selagem
tipo: knowledge
status: accepted
temperatura: quente
path: .hbn/knowledge/0028-diversidade-familia-enforced-selagem.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: v0.3.x
id_original: 0028
created_at_original: 2026-06-17T00:00:00-03:00
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
knowledge-id: 0028
data: 2026-06-17
origem: incidente 0045 + design G-AUDITOR-ID
revisar-em: 2026-12-17
---
# 0028 — diversidade de familia enforced na selagem

A diversidade de familia (>=2 distintas != implementador) era verificada a
mao pelo orquestrador. Isso deixava a Camada 2 do desenho do G-AUDITOR-ID
dependente de disciplina humana no momento da selagem.

G-DIVERSITY torna essa regra um gate enforcado na selagem: results
cross-audit com menos de duas familias distintas, ambas diferentes da familia
do implementador, e com `APROVA_<NNNN>: SIM` nao selam o readback auditado.

O guard deriva:

- o readback auditado a partir de `APROVA_<NNNN>`;
- a familia do implementador a partir de `implementador_id` no readback JSON;
- a familia de cada auditor a partir da linha `SOU:` validada contra
  `guards/data/auditor-families.txt`.

Isso fecha a Camada 2 do design do G-AUDITOR-ID: auto-ID canonico identifica
quem audita, e G-DIVERSITY impede que a selagem conte diversidade insuficiente
ou auditores da mesma familia do implementador como quorum.
