---
titulo: Onboarding useHBN + gate pré-piloto — maiscompralocal-core
projeto: maiscompralocal
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding)
status: congelado
temperatura: glacier
tipo-sugerido: guard + adr
evidencia: src/app/api/auth/mock-sso/route.ts:52-54; src/infra/storage/r2client.ts:6-8,23-30; commits recentes (MVP ativo)
---

# Proposta — maiscompralocal entra no protocolo antes do piloto

## Contexto

Next.js + Drizzle + Neon + jose + R2, Vercel. MVP pré-produção com
movimento recente — candidato a piloto com prefeituras. Não usa useHBN
(sem `.hbn/`). Drizzle parametrizado por padrão (bom); sem raw SQL
observado.

## O que entra PRIMEIRO

1. **forbid-env (guard)** — `.env.local` e `.env.production` em plaintext na
   árvore (não versionados; risco de disco/backup).
2. **scope-lock + readback** — multi-tenant: qualquer mudança em
   middleware/tenant exige onda dedicada.
3. **raiz canônica `.hbn/`** — STATE + handoffs ADR-011.

## Gate pré-piloto (achados a corrigir, sem desenvolver aqui)

- `mock-sso` sem guard de NODE_ENV e cookie `secure:false`
  (src/app/api/auth/mock-sso/route.ts:52-54) → remover/condicionar a dev.
  MÉDIA-ALTA.
- Presigned URL sem validar tenantId do chamador vs header
  (src/infra/storage/r2client.ts:23-30) → cross-tenant read/write. MÉDIA-ALTA.
- Fallbacks mock de credencial R2 (r2client.ts:6-8) → falhar explícito. MÉDIA.
- `dangerouslySetInnerHTML` em mapas SVG (src/components/ui/MatoGrossoMap.tsx:89,
  BrazilStatesMap.tsx:48) sem sanitização e sem CSP no next.config.ts. MÉDIA.
- `audit_log.signature_hash` existe no schema (src/infra/db/schema.ts:220-244)
  mas nunca é preenchido → integridade de auditoria. MÉDIA.

Item segue quente até consolidação + hearback.
