# Parecer Antigravity — ADR-008 Migração Snapshot Credenciamento

**Auditor:** antigravity (Gemini 3.1)
**Session role:** cross-ia-review-usehbn
**Reviewed at:** 2026-05-09

## Veredito conceitual

`APROVADO_SEM_RESSALVA`

## Coerência com P1-P13

| Princípio | Apoiado | Em tensão | Comentário |
|---|---|---|---|
| P1 (Preservar) | sim | não | Aborda migração de forma não destrutiva. |

## Comparação com precedentes externos

A decisão explícita contra *git submodules* (preferindo um snapshot populado via script) ecoa o padrão *Vendoring* em Go (`go mod vendor`). O *Vendoring* prioriza a simplicidade da build e reduz a fragilidade do tooling externo à custa de um pequeno peso no repositório final, o que favorece IAs.

## Tensões filosóficas detectadas

O uso explícito de um diretório `.usehbn-snapshot/` dentro do código consumidor cria um "corpo estranho" mantido por máquina, exigindo estrita disciplina (Nunca editar manualmente).

## Risco antropológico/cultural

O hábito do desenvolvedor. A IA/Humano operando no repositório Credenciamento precisará resistir ao instinto de corrigir um typo em `.usehbn-snapshot/methodology/...`. O README + `PROTOCOL_SHA256.txt` criam uma barreira forte contra essa mutação.

## Recomendação para humano

`RATIFICAR` (condicionado ao fechamento da v204).

## Comentário livre

Uma decisão puramente operacional que não fere doutrina. A rejeição de submódulos é sábia; submódulos introduzem muita complexidade no *state* das IAs durante as análises locais (CWD boundaries). Defiro a avaliação da segurança do script `usehbn-fetch.sh` ao Codex CLI.

> **Nota da consolidação cross-IA:** Codex REPROVOU este ADR — não pelo conceito (concorda com Antigravity) mas por **3 pilares técnicos ausentes**: (1) `bin/usehbn-fetch.sh` e `bin/usehbn-verify.sh` não existem; (2) algoritmo de checksum não é determinístico (sem manifest, ordenação, normalização de path); (3) `hbn doctor` não verifica snapshot nem mirror drift. Além disso, conteúdo do `Credenciamento/usehbn/` (modules/, radar/, audits/, methodology/ além do PRINCIPIOS já migrado) ainda não foi mapeado. ADR-008 mantém-se BLOQUEADO até estes pilares + matriz origem→destino existirem. Ver `0009-cross-ia-codex-ADR-008.json` e consolidação 05.
