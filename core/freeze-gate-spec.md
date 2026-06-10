---
titulo: Freeze-gate spec — checklist executável de congelamento de versão
diataxis: reference
status: accepted
temperatura: quente
id-global: 20260610-41
versao: 0.1.0
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente D)
hearback-status: confirmado por Maurício (ajuste §2.2 adotado no readback 0003; ADR-017 segue pendente no lote D)
relacionado: [ADR-017, schemas/freeze-checklist.schema.json, guards/freeze-gate.sh, ADR-016 (dual-run pode ser critério), core/cadence-d.md (BLOQUEADOR = veto)]
---

# Freeze-gate spec

## §1 O contrato

"Versão X é congelável" deixa de ser frase de handoff e passa a ser o exit
code de `bash guards/freeze-gate.sh <checklist.json>`. O checklist
(`schemas/freeze-checklist.schema.json`) vive no projeto, em
`.hbn/freeze/<id>-freeze-<versao>.json`, e é atualizado a cada onda (flip de
status = T1, 1 commit + linha de audit).

## §2 Regras do veredicto

1. `bloqueadores_abertos > 0` → não congelável, sem exceção (veto da
   cadência D; nenhuma IA fecha BLOQUEADOR de outra).
2. Todo critério `obrigatorio: true` precisa `status: ok` — com UMA única
   exceção: `status: na` acompanhado de hearback VERIFICÁVEL citado na
   justificativa (regra 4 abaixo; ADR-020 Decisão 3). Não há terceira via.
   (Redação explicitada no fechamento da corrente E — E-RE-02 da 0025.)
3. `ok` sem `evidencia` NÃO conta — vale como falta (Truth Barrier).
4. `na` exige `justificativa`; critério obrigatório só pode ser `na` com
   hearback citado na justificativa (hearback verificável: arquivo existe,
   status confirmed — é o que `guards/freeze-gate.sh` dereferencia).
5. Saída sempre lista as faltas — o gate é também o relatório do que resta.

## §3 Critérios canônicos (perfil app de domínio — V206 é a instância)

| id | descrição | obrigatório |
|---|---|---|
| validacao-tela-a-tela | toda tela/fluxo validado visualmente nesta janela | sim |
| correcoes-com-teste-verde | cada correção da janela coberta por teste que passa | sim |
| idempotencia-provada | re-execução do pipeline sem efeito novo, com evidência | sim |
| pdfs-evidencia-rodizio | PDFs de evidência do rodízio gerados e arquivados | sim |
| zero-bloqueador | nenhum finding BLOQUEADOR aberto (espelha bloqueadores_abertos) | sim |
| pareceres-fechados | pareceres de auditoria cruzada da janela fechados (V206: 0034/0035/0036) | sim |

Projetos podem ADICIONAR critérios (ex.: `dual-run-corpus-verde` quando
ADR-016 estiver em uso); remover ou desobrigar critério canônico exige
hearback.

## §4 Quem faz o quê

IA preenche/propõe o checklist e aponta evidências; HUMANO confere e roda o
gate no Terminal (conclusivo — knowledge 0021); o resultado (saída do gate)
cola no handoff da onda. Aplicação à V206: `inbox/credenciamento/20260610-44`.
