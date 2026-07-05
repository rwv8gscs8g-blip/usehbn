---
knowledge-id: 0026
titulo: Auto-ID do auditor como gate enforcado
status: accepted
temperatura: quente
path: versao_3_0_0/.hbn/knowledge/0026-auto-id-auditor-gate-enforcado.md
data: 2026-06-17
origem: incidente cross-audit 0045 — parecer relatado como Grok sem arquivo verificavel no disco, sem SOU canonico e com risco de mislabel de familia.
revisar-em: 2026-12-17
---

# 0026 — auto-ID do auditor como gate enforcado

Auto-ID e familia do auditor sao load-bearing para a diversidade
diferente-da-familia, mas eram instrucao escrita, nao gate. Um parecer
relatado no chat pode nao existir no disco, nao se autoidentificar ou
mislabelar a propria familia. Relato nao basta: antes de contar um parecer
para diversidade, verifique o arquivo no disco e o `SOU:` canonico.

G-AUDITOR-ID torna isso enforcado. Sem `SOU:` canonico, apelido coerente com
o nome do arquivo e familia canonica/coerente com o mapa curado, o parecer nao
entra no livro-razão.
