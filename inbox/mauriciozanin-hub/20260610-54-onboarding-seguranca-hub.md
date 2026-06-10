---
titulo: Onboarding useHBN formal + higiene de segredos em disco — MAURICIOZANIN-HUB
projeto: mauriciozanin-hub
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding)
status: proposed
temperatura: quente
tipo-sugerido: guard + knowledge
evidencia: .certs/e-CPF-15030004866.pfx (disco, NÃO versionado — git log vazio p/ *.pfx, 2026-06-10); src/lib/session.ts:6-10; src/app/api/deploy-info/route.ts:56-107
---

# Proposta — HUB formaliza o protocolo que já usa pela metade

## Contexto

Next.js + Prisma + bcrypt/jose/otplib + node-forge, deploy Vercel, remoto
GitHub. Já tem `.hbn/` e `.usehbn/` mas sem cerimônia ativa. Postura de
segurança acima da média dos irmãos (RBAC amplo, rate limit em rotas
críticas, throw se AUTH_SECRET faltar em produção em session.ts:6-8, rota de
certificado que REJEITA shared-secret vazio em
src/app/api/auth/certificate/route.ts:18 — verificado, não é bypass).

## O que entra PRIMEIRO

1. **forbid-env (guard)** — `.env`, `.env.build`, `.env.local*` com
   credenciais reais (Neon/R2 — natureza, não valores) e
   `.certs/e-CPF-*.pfx` (e-CPF REAL) vivem na árvore do projeto. Nunca
   foram versionados (verificado no histórico), mas um `git add -A`
   descuidado ou um backup da pasta vaza tudo. Guard bloqueia por padrão.
2. **scope-lock** — auth (session/jwt/mfa/certificate) só muda em onda
   dedicada com readback.
3. **readback/hearback + STATE** — ativar a cerimônia nos diretórios `.hbn/`
   que já existem.

## Correções a propor na primeira onda (sem desenvolver aqui)

- `/api/deploy-info` sem auth expõe metadados de ambiente/governança
  (route.ts:56-107) → exigir sessão ou remover de produção. MÉDIA.
- `/api/debug/clients` (route.ts:7-8) é rota de debug em produção → remover
  do build de produção. MÉDIA.
- Rate limit explícito na verificação TOTP (otplib) — não confirmado a
  fundo; marcar para verificação, não como achado. 
- Mover `.certs/` para fora do working tree. ALTA (disco, não repo).

Item segue quente até consolidação + hearback.
