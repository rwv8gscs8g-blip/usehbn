---
knowledge-id: 0002
titulo: Entrega operacional ao humano é minimalista (ex-L28)
status: accepted
temperatura: quente
data: 2026-06-10
origem: PROMPT_ARQUITETO v1.6 §7.2; sessão Opus×Maurício×Codex 2026-05-24, pós-Onda 37.2 (procedimento de 53 linhas burocratizou execução de 1 linha)
revisar-em: 2026-12-10
path: .hbn/knowledge/0002-entrega-operacional-minimalista.md
---

# 0002 — Audit trail no repo; ao humano, uma instrução acionável

Audit trail completo (procedimento .md, ERP, técnico) vive DENTRO do
repositório. A entrega ao operador no chat é:

1. **Comando único** (macro, linha de bash, clique específico).
2. **1 frase de expectativa** ("vai retornar X" / "compile passa limpo").
3. **1 frase de fallback** ("se aparecer Y, pare e me relate").

Anti-padrão proibido: "Leia PROCEDIMENTO.md e siga os 7 passos."

Regra específica do Credenciamento preservada: importação de módulos VBA no
Excel é SEMPRE via Importador V3 (macro `ImportarPacoteV3_Aplicar` ou
equivalente declarado no procedimento canônico), nunca VBE → File → Import
manual (Regra de Ouro 0002 do projeto).
