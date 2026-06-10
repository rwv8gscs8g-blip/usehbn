---
id: 20260610-15
titulo: Proposta de bump de versão do protocolo canônico — 0.3.1 vs 0.4.0
tipo: proposal
status: proposed
temperatura: quente
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente C3)
requer-hearback: Maurício — ESCOLHA BINÁRIA abaixo
relacionado: [ADR-004 (SemVer do protocolo), ADR-012 (naming), ADR-010 (autoevolve), docs PROPOSAL-V0.4.0 do ciclo 2026-05-13]
---

# Bump de versão do canônico — a escolha

A corrente C3 sincroniza o canônico com a doutrina viva do Credenciamento:
3 schemas (hearback, audit-pre, audit-post), o conjunto de guards e o Shield
de CI. Pergunta única: isso é PATCH ou MINOR?

## Opção A — 0.3.1 (recomendada)

Tese: C3 não muda contrato — **promove ao canônico o que já era praticado**
(schemas batidos em campo no Credenciamento, guards que já rodam no
pre-commit de lá). Nenhum consumidor quebra; nenhuma interface nova é
exigida. Pelo ADR-004, sync sem mudança de contrato = PATCH.

Vantagem operacional: desacopla este lote do destino do ADR-010/PROPOSAL-V0.4.0
(autoevolve), que merece avaliação própria e não deveria pegar carona.

## Opção B — 0.4.0

Tese: se Maurício decidir, NO MESMO hearback, promover também a pendência
do ciclo 2026-05-13 (ADR-010 → ACCEPTED + PROPOSAL-V0.4.0, motor autoevolve
como parte oficial do protocolo — ver corrente C4/ADR-013, que o reusa como
executor da classe A), então o lote agregado tem capacidade nova de protocolo
e justifica MINOR direto, evitando dois bumps na mesma semana.

## Decisão pedida (hearback)

- [ ] **A — 0.3.1**: só o sync C3 agora; ADR-010/V0.4.0 segue em avaliação.
- [ ] **B — 0.4.0**: sync C3 + ADR-010 ACCEPTED + autoevolve oficial, num lote só.

Recomendação do arquiteto: **A**, salvo se o hearback da C4 já aprovar a
classe A com motor autoevolve — nesse caso B economiza um ciclo.
