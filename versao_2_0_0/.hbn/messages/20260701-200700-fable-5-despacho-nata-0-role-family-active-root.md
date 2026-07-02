---
titulo: "Despacho nata-0 — dereferência version-aware do hearback_ref (G-FAM)"
tipo: despacho
status: proposto
temperatura: quente
path: versao_2_0_0/.hbn/messages/20260701-200700-fable-5-despacho-nata-0-role-family-active-root.md
created_at: "2026-07-01T20:07:00-03:00"
autor: fable-5
familia: Anthropic
arvore: fronteira
---

⟦HBN-COPY dest=codex⟧ BEGIN
SOU: fable-5 · família Anthropic · papel arquiteto-consolidador da exúvia (gate humano de Maurício) · CHAT NOVO
SEU PAPEL: implementador · tier ALTO (guards) · onda nata-0 · UMA onda, UM commit

CONTEXTO (leia no disco, não confie neste texto): MANIFESTO-MIGRACAO.md §PENDENTE item 0 (versao_2_0_0/MANIFESTO-MIGRACAO.md); dívida confirmada por 4 pareceres da rodada 2 (.hbn/results/ do incumbente, 20260701-1942xx..1948xx).

MISSÃO: tornar version-aware a dereferência de `hearback_ref` no guard G-FAM.
1. Em `guards/assert-role-family.sh` (~linha 105): a resolução `os.path.join(repo_root, hearback_ref)` deve usar a raiz da versão ativa (`ACTIVE_ROOT`, já calculada na ~linha 80 e hoje NÃO usada na dereferência). Comportamento atual é fail-closed (bloqueia legítimo); a correção NÃO pode abrir bypass: path absoluto continua proibido de escapar do repo; sob versão ativa `.`, comportamento idêntico ao atual.
2. Cobrir o caso análogo do teste "str: bypass liveness com hearback confirmado" (`guards/tests/run-guard-tests.sh:611`) se a fixture depender de resolução contra o toplevel.
3. Teste negativo NOVO no mesmo commit (R2): hearback_ref que só existe fora da raiz da versão ativa → BLOCK.

files_allowed (NADA além disto; as duas cópias IDÊNTICAS — invariante C-NOREG por paridade):
- guards/assert-role-family.sh
- versao_2_0_0/guards/assert-role-family.sh
- guards/tests/run-guard-tests.sh (apenas o teste novo + fixture)
- versao_2_0_0/guards/tests/run-guard-tests.sh (idem, espelhado byte a byte)
- guards/tests/fixtures/** e versao_2_0_0/guards/tests/fixtures/** (fixture nova, espelhada)

CRITÉRIOS DE ACEITE (cole saídas reais de terminal):
- `diff -rq guards versao_2_0_0/guards` → VAZIO após o patch.
- Suíte completa nos DOIS contextos (raiz e versao_2_0_0): nenhuma falha nova; teste novo BLOCK no caso ruim e pass no caso bom.
- Bateria adversarial: VERDE nos dois contextos.

ROLLBACK: antes do patch, `git tag hbn-rollback/nata-0` (proposto ao operador; tag é ato humano).

PROIBIÇÕES: não tocar outros guards; não alterar `files_allowed`; sem `--no-verify`; sem `git add -A`; staging seletivo e PARAR — commit é do operador. Sob qualquer ambiguidade, PARE e pergunte (Truth Barrier).
⟦HBN-COPY END⟧
