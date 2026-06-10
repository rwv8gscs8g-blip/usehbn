---
knowledge-id: 0001
titulo: Comandos para humano são atômicos e copiáveis (ex-L27)
status: proposed
temperatura: quente
data: 2026-06-10
origem: PROMPT_ARQUITETO v1.6 §7.1; sessão Opus×Maurício 2026-05-24 (prática real de copy/paste no Cowork)
revisar-em: 2026-12-10
---

# 0001 — 1 comando = 1 bloco, comentário fora do bloco

Toda instrução que o operador copia para o terminal: um único comando por
bloco de código, com a explicação SEMPRE fora do bloco. Comentário inline
(`# faz X`) entra no clipboard junto e cria fricção/erro.

Anti-padrão proibido: bloco com `# Posicionar:` + `cd ...` + `# Validar:` +
`bash ...` misturados. Padrão obrigatório:

Posicionar no projeto:

```
cd /Users/macbookpro/Projetos/usehbn
```

Validar:

```
bash guards/hbn-guards-runner.sh
```

Vale para QUALQUER IA (Opus, Codex, Gemini, Cursor) emitindo instruções
operacionais em chat ou markdown.
