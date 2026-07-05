---
titulo: "TRANSICAO — por que a terceira exúvia (v3.0.0) existe"
status: ativo
temperatura: quente
path: versao_3_0_0/TRANSICAO.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
---

# TRANSICAO — a terceira exúvia

## O fato

Entre 2026-07-01 e 2026-07-05 o genoma operou com **três superfícies
concorrentes**: a raiz (v0.3.x, `active-version = "."`), a `versao_2_0_0/`
(primeira exúvia, **nunca ativada** — ficou 4 dias em `status: proposto`) e
o trabalho novo desta sessão, que nasceu **na raiz** — a versão errada.

Prova documental (leitura obrigatória, fora do genoma):

1. Relatório crítico — `~/Projetos/Credenciamento/orquestracao/20260705-001142-claude-opus-4-8-relatorio-critico-versao-errada-e-terceira-exuvia.md`
2. Parecer antigravity — `.../20260705-002500-cross-ia-antigravity-analise-versao-terceira-exuvia.md`
3. Parecer grok (adversarial) — `.../20260705-014500-cross-ia-grok-analise-versao-terceira-exuvia.md`
4. GATE-DECRETO (vinculante) — `.../20260703-000500-GATE-DECRETO-REVOGACAO-PERMISSOES-ORQUESTRADORES-LEITURA-OBRIGATORIA.md`

## As causas mecânicas (não morais)

- **C1 / L2**: a exúvia v2 parou no meio — `proposto` pendurado sem Fitness
  Gate, sem flip, sem congelamento. Nenhum guard bloqueava esse estado.
- **C2 / L3**: nada impedia fisicamente a escrita fora da versão quente. As
  IAs escreveram onde o contexto herdado apontava (raiz), não onde a regra
  mandava. Doutrina sem guard é recomendação.
- **C3**: a membrana com o consumidor (Credenciamento) não declarava
  `source_version`/`source_commit` — paridade por fé, não por contrato.

## A resposta do v3.0.0 (cada causa fecha com guard)

| Causa | Mecanismo novo | Arquivo |
|---|---|---|
| C2/L3 escrita na versão errada | G-HOT-WRITE (1º guard, sem bypass, auto-protegido) | `guards/assert-only-hot-version-writable.sh` |
| C1/L2 `proposto` pendurado | G-NO-PENDING-EXUVIA + rito atômico | `guards/assert-no-pending-exuvia.sh` + `scripts/hbn-exuvia-atomic.sh` |
| C3 membrana por fé | Contrato explícito sha256 + upgrade atômico | `membrane/` + `scripts/hbn-upgrade-snapshot.sh` |
| Contexto herdado vence o disco | BOOT-LOCK (cabeçalho obrigatório + interceptação de escrita) | `BOOT.md` §0 + `AGENTS.md` (raiz) + `.cursor/hooks/` |

## O que foi preservado

- `versao_0_3_x/` — todo o exoesqueleto v0.3.x da raiz (Honest Foundation),
  movido inteiro, congelado (`status: congelado`, `temperatura: glacier`).
  Inclui os artefatos de sessão não-commitados (`.hbn/` operacional), para
  auditoria — nada foi apagado.
- `versao_2_0_0/` — a primeira exúvia, congelada como história (nunca
  ativada; a especificação consolidada dela foi IMPORTADA para cá).
- O conteúdo desta versão = especificação do v2.0.0 + guards estruturais
  endurecidos na sessão de 2026-07-04 (43 guards, suíte de 371 checks).

## O que muda para quem chega

Leia `BOOT.md` — e SÓ ele — para entrar. O §0 (BOOT-LOCK) é vinculante:
`cat .hbn/active-version` primeiro, cabeçalho estruturado em toda mensagem,
escrita apenas sob a versão quente. O roteiro de retomada da operação está
em `ROADMAP.md`.
