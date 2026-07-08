---
path: .hbn/results/20260617-124513-antigravity-cross-ia-curadoria-p0-0045.md
id-global: 20260617-124513-antigravity-cross-ia-curadoria-p0-0045
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0045: SIM"
onda: curadoria-p0
created_at: "2026-06-17T12:45:13-03:00"
status: congelado
temperatura: glacier
---

APROVA_0045: SIM

SOU: antigravity · familia Google · papel auditor. So leitura; sem commit; sem tocar main; sem --no-verify. Truth Barrier (arquivo:linha ou comando+saida). Nao confie em relatos; confira no disco.

# Parecer Cross-IA — Curadoria P0 de Documentação (Readback 0045)

- **Auditor:** antigravity (Google)
- **Implementador:** Codex (OpenAI)
- **Data/Hora:** 2026-06-17T12:45:13-03:00
- **Identificação:** `20260617-124513-antigravity-cross-ia-curadoria-p0-0045`

---

## 1. Evidência de A1 — ZERO PONTEIRO MORTO no AGENTS.md

Todos os links Markdown no `AGENTS.md` foram extraídos e validados contra o disco local `/Users/macbookpro/Projetos/usehbn/`.

### Links Markdown extraídos:
1. `docs/INTEGRATION-AGENTS-MD.md` (Linha 5)
2. `agents/` (Linha 7, 142)
3. `.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md` (Linha 16)
4. `core/role-cards.md` (Linha 17, 18)
5. `methodology/MATURITY-MATRIX.md` (Linha 32)
6. `docs/GLOSSARY.md` (Linha 33)
7. `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (Linha 39)
8. `core/esteira-pre-transicao.md` (Linha 103)
9. `docs/INTEGRATION-GLASSWING.md` (Linha 134)
10. `methodology/ADR-AND-MD-PRIMER.md` (Linha 138)
11. `agents/agents.md` (Linha 144)
12. `agents/claude.md` (Linha 145)
13. `agents/codex.md` (Linha 146)
14. `agents/safety.md` (Linha 147)
15. `agents/wave-protocol.md` (Linha 148)
16. `methodology/adr/INDEX.md` (Linha 187)
17. `REGISTRY.md` (Linha 188)

### Prova de existência no disco (Comando + Saída):
```text
$ ls -d docs/INTEGRATION-AGENTS-MD.md agents/ .hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md core/role-cards.md methodology/MATURITY-MATRIX.md docs/GLOSSARY.md methodology/PRINCIPIOS-CONSTITUCIONAIS.md core/esteira-pre-transicao.md docs/INTEGRATION-GLASSWING.md methodology/ADR-AND-MD-PRIMER.md agents/agents.md agents/claude.md agents/codex.md agents/safety.md agents/wave-protocol.md methodology/adr/INDEX.md REGISTRY.md
.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md
REGISTRY.md
agents/
agents/agents.md
agents/claude.md
agents/codex.md
agents/safety.md
agents/wave-protocol.md
core/esteira-pre-transicao.md
core/role-cards.md
docs/GLOSSARY.md
docs/INTEGRATION-AGENTS-MD.md
docs/INTEGRATION-GLASSWING.md
methodology/ADR-AND-MD-PRIMER.md
methodology/MATURITY-MATRIX.md
methodology/PRINCIPIOS-CONSTITUCIONAIS.md
methodology/adr/INDEX.md
```

### Validação de `modules/` e `radar/`:
Confirmamos que os termos `modules` e `radar` não aparecem como links ativos no arquivo, mas apenas nas notas informativas de versão e estrutura.
```text
$ grep -in 'modules\|radar' AGENTS.md
95:Note: `modules/` and `radar/` do **not** exist on disk. Normative specs live in
192:- v1.1 (proposta) — curadoria P0 2026-06-17: corrige ponteiros mortos (remove `modules/` e `radar/` inexistentes), declara `core/` como casa das specs vivas (não legado), aponta maturidade para `methodology/MATURITY-MATRIX.md`, adiciona cartão de entrada, esteira de pré-transição, REGISTRY e glossário. Preserva identidade, constituição (ADR-009), sinais (ADR-006) e contratos por IA do v1.0.
```

Inexistência comprovada no disco:
```text
$ ls -d modules radar
ls: modules: No such file or directory
ls: radar: No such file or directory
```

---

## 2. A2. AGENTS HONESTO

- A partição `core/` é descrita como specs vivas e ativas (`living, sealed normative specs (status: accepted)` em `AGENTS.md:77`), sem qualquer menção a "legacy" ou "superseded".
- A referência de maturidade aponta corretamente para `methodology/MATURITY-MATRIX.md` em `AGENTS.md:32,68`.
- O scaffold do `autoevolve` é declarado honestamente em `AGENTS.md:70-72`: `parts of src/usehbn/ are **Scaffold/Stub** (notably the autoevolve orchestrator/worker/queue)`.
- A constituição (P1-P13), os sinais HBN e os contratos específicos por IA são preservados.
- Não há termos absolutos proibidos em contextos não regulamentados. A Truth Barrier de não usar falsas promessas está respeitada.

---

## 3. A3. FIDELIDADE VERBATIM

- O conteúdo de `AGENTS.md` coincide perfeitamente (verbatim, com exceção de whitespace final secundário) com o bloco proposto em `docs/brainstorm/rodada-2026-06-17/curadoria-p0/AGENTS-corrigido-proposto.md` entre as linhas 37 e 230.
- O conteúdo de `docs/GLOSSARY.md` coincide perfeitamente (verbatim, exceto newline final) com o bloco de proposta de `docs/brainstorm/rodada-2026-06-17/curadoria-p0/GLOSSARY-proposto.md` entre as linhas 11 e 102.
- O arquivo `docs/MATURITY-MATRIX.md` foi limpo, removendo o conteúdo stale da tabela, restando apenas o stub de redirect de 5 linhas.

---

## 4. A4. GLOSSÁRIO FIEL

Amostramos os seguintes 5 termos e confirmamos que a definição bate com a especificação canônica citada:
1. **Exúvia (molt / muda)**: Bate com a descrição detalhada e analogia de lagosta em `core/exuvia-fitness-criteria.md:19-25`. Ponteiros existem no disco.
2. **Árvores (Fronteira / Intermediária / Estável)**: Aponta para a proposta `docs/brainstorm/PROPOSTA-arvores-agora.md` que existe no disco.
3. **Fronteira**: Aponta para `docs/brainstorm/` e `core/exuvia-fitness-criteria.md`. Ambos existem e são consistentes.
4. **Livro-razão / REGISTRY**: Bate com a definição do ledger em `REGISTRY.md` e aponta para as regras vigentes do ADR-011.
5. **Esteira de pré-transição**: Bate com a especificação em `core/esteira-pre-transicao.md:12-25`. Ponteiro funcional existe no disco.

---

## 5. A5. MATRIZ

- `docs/MATURITY-MATRIX.md` foi reduzido a stub de redirect de 5 linhas sem tabelas stale duplicadas.
- `methodology/MATURITY-MATRIX.md` permanece intacto e completo no disco como fonte única.

---

## 6. N1. ESCOPO

O comando `git diff --name-only c13d64a..f8e655d` revela que apenas os 7 arquivos do escopo foram modificados, sem qualquer vazamento de escopo:
1. `.hbn/messages/20260617-113500-codex-handoff-curadoria-p0.md`
2. `.hbn/readbacks/0045-curadoria-p0-docs.json`
3. `.hbn/relay/STATE.md`
4. `AGENTS.md`
5. `REGISTRY.md`
6. `docs/GLOSSARY.md`
7. `docs/MATURITY-MATRIX.md`

Nenhum arquivo proibido em `guards/`, `src/`, `schemas/`, `core/`, `methodology/` ou `docs/brainstorm/` foi modificado.

---

## 7. N2. SEM REGRESSÃO

- **Pytest**: Execução de `.venv/bin/pytest` completou com **213 items passed** com sucesso.
- **Bateria Adversarial**: Execução de `bash ./guards/tests/adversarial-battery.sh` retornou `BATERIA VERDE`, com todas as burlas de B1 a B33 devidamente bloqueadas.

---

## 8. N3. MAIN E TRAILERS

- O hash de `main` é `4db692876381a0d7909985c8500d999f2e677b04` (inicia com `4db6928`).
- A branch local é `proposta/reestruturacao-m-a-s0`. A branch `main` não foi modificada.
- Os 5 commits contêm trailers válidos e contíguos de autorização do Maurício.
- `G-EXC` ativo e proposto no `STATE.md` desde o commit C1 (`2347443`).

---

## 9. Marginais e Observações

1. **Diferença sutil de texto no stub da matriz (A3/A5)**: O texto do stub de `docs/MATURITY-MATRIX.md` difere sutilmente do proposto em `matriz-dedup-acao.md:30-36`. Contudo, cumpre a função de remover todo o conteúdo stale e redirecionar para a fonte canônica. Não é considerado um bloqueador de auditoria.

---

## 10. Conclusão e Assinatura

- **Veredito:** APROVA_0045: SIM
- **Confiança:** 98/100
- **Assinatura:** `antigravity` (Google)
- **Data/Hora:** 2026-06-17T12:45:13-03:00
