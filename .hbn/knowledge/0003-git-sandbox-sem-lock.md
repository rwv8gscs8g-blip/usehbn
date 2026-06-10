---
knowledge: 0003
titulo: IA em sandbox consulta git do canônico SEM tomar lock (GIT_OPTIONAL_LOCKS=0)
status: proposed
temperatura: quente
data: 2026-06-10
id-global: 20260610-28
autoria: claude-fable-5 (arquiteto useHBN, corrente C6/C7)
tier: T2 (knowledge — readback+hearback; lote C6/C7)
evidencia: |
  Incidente 2026-06-10 ~06:56: `git status` rodado pela IA no sandbox criou
  `.git/index.lock` no repo do operador e NÃO conseguiu removê-lo ("unable to
  unlink: Operation not permitted"). O lock órfão (0 bytes) bloqueou o commit
  do checkpoint C6/C7 no Terminal do operador ("fatal: Unable to create
  index.lock: File exists") até remoção manual (`rm -f .git/index.lock`,
  resolvido no commit 8eb51de).
---

# Knowledge 0003 — git em sandbox: só leitura, sem lock

**Regra**: IA operando em sandbox montado sobre o repo do operador prefixa
TODA consulta git com `GIT_OPTIONAL_LOCKS=0` (ou usa só comandos plumbing:
`git log`, `git ls-tree`, `git show`, `git diff --no-index`). Motivo: até
`git status` faz refresh do index e toma `index.lock`; o sandbox CRIA o lock
mas não tem permissão para desfazê-lo — deixando uma mina para o próximo
commit humano.

**Forma canônica**:

```bash
GIT_OPTIONAL_LOCKS=0 git status --short
```

**Sintoma e antídoto** (lado do operador): `fatal: Unable to create
'.git/index.lock': File exists` com lock de 0 bytes e nenhum git rodando →
`rm -f .git/index.lock` e seguir.

Escrever no git (add/commit) NUNCA é do sandbox — isso já era doutrina
(knowledge 0021 do Credenciamento: guard informativo em sandbox, conclusivo
no Terminal); esta knowledge cobre o caso novo: até a LEITURA precisa ser
lock-free.
