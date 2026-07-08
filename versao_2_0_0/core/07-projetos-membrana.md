---
titulo: "07 — Projetos e membrana: como o protocolo governa software real"
status: congelado
temperatura: glacier
path: versao_2_0_0/core/07-projetos-membrana.md
created_at: "2026-07-01T19:44:00-03:00"
autor: fable-5
familia: Anthropic
---

# 07 — Projetos e membrana

Consolida a proposta-ponte v2 (selada via 0097 no v0.3.x) e o aprendizado do
Passo 2 com o Credenciamento — a primeira instalação real.

## Membrana (snapshot determinístico)

Um projeto NÃO espelha o repo do protocolo. Ele recebe uma **membrana**:
`install-snapshot.sh` (herdado, `scripts/` do incumbente) gera
`.usehbn-snapshot/` no projeto a partir de uma TAG do protocolo, com manifesto
determinístico (contagem de arquivos + sha256 do conjunto). Integridade
conferível a qualquer momento (`assert-snapshot-integrity`). Projeto commita a
membrana sob o rito DELE (readback de projeto + firewall próprio).

## Runner project-mode

O projeto instala shims finos que chamam `. usehbn-snapshot/guards/` após
verificação de integridade; subset bloqueante no pre-commit do projeto.
O projeto tem seu próprio `.hbn/` (readbacks, results, messages) e seu próprio
livro-razão — números de artefato do projeto NUNCA se misturam com os do
protocolo.

## Regras de fronteira

- Protocolo nunca escreve no espaço de domínio do projeto; projeto nunca
  escreve no repo do protocolo. Comunicação = artefatos em `inbox/` (protocolo)
  e `.hbn/messages/` (projeto).
- Espelho legado do protocolo dentro de projeto (ex.: pasta `usehbn/` antiga
  no Credenciamento) recebe TOMBSTONE e é removido do git (P2-D do v0.3.x).
- Atualização da membrana = nova tag do protocolo + reinstalação por
  snapshot — nunca edição in-place.

## Dogfooding como prova

A validação suprema do protocolo é credenciar release real de projeto real
(critério C-DOG do Fitness Gate). Primeiro caso: V206 do Credenciamento —
validação tela-a-tela com evidência por tela, sob runner project-mode.
