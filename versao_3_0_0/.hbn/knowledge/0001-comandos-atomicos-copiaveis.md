---
titulo: Comandos para humano são atômicos e copiáveis (ex-L27)
tipo: knowledge
status: accepted
temperatura: quente
path: .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: v0.3.x
id_original: 0001
created_at_original: 2026-06-10T00:00:00-03:00
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
knowledge-id: 0001
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
