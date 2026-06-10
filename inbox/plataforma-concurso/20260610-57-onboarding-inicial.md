---
titulo: Onboarding inicial + unificação dos dois sub-apps — PlataformaConcurso
projeto: plataforma-concurso
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding)
status: proposed
temperatura: quente
tipo-sugerido: adr
evidencia: tsconfig/ SEM git com .env real; estudo-concursos/prisma/seed.ts (senha demo hardcoded); LGPD_MANUAL.md
---

# Proposta — ordenar a casa antes de qualquer onda

## Contexto

Dois sub-apps desencontrados: `tsconfig/` (worker + Neon + xlsx, **sem
git**, com `.env` contendo DATABASE_URL real) e `estudo-concursos/`
(Next + next-auth + Prisma, com git). Plataforma de estudo para concursos
com manual LGPD declarado. Não usa useHBN. Diagnóstico INICIAL.

## O que entra PRIMEIRO

1. **Decisão estrutural** — ou `tsconfig/` ganha git + .gitignore + nome
   digno, ou é absorvido/aposentado. Pasta sem git com .env real é o pior
   dos dois mundos (sem histórico para auditar, sem ignore para proteger).
2. **forbid-env (guard)** desde o primeiro commit do que sobrar.
3. **raiz canônica `.hbn/`** mínima (STATE + readback) só quando o projeto
   reativar — esforço proporcional: está parado, não merece cerimônia cheia.

## Achados iniciais (corrigir quando reativar)

- Senhas demo hardcoded em seed (estudo-concursos/prisma/seed.ts, contas
  admin/editor/aluno) — natureza: credencial de demonstração; remover antes
  de qualquer deploy. MÉDIA.
- `.env` de tsconfig/ no disco com URL de banco real. MÉDIA (rotacionar se o
  banco ainda existir).

Não verificado a fundo: validação de input nas rotas do worker, roles do
next-auth, aderência real ao LGPD_MANUAL.md.

Item segue quente até consolidação + hearback.
