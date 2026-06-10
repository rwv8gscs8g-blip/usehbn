---
titulo: Onboarding useHBN + correção de exposição crítica em produção — timelessphoto.art
projeto: timelessphoto
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding)
status: proposed
temperatura: quente
tipo-sugerido: adr + guard
evidencia: public/timeless-site/suporte/wp-config.php:23-29,51 (tracked; `git ls-files` 2026-06-10); 8.026 arquivos WP versionados em public/; .env.local:37-44
---

# Proposta — timelessphoto.art entra no protocolo COM gate de segurança

## Contexto (1 parágrafo)

Next.js + Prisma + better-auth + R2 + Resend, **em produção** (Vercel,
V1.1.041). Não usa useHBN hoje (sem `.hbn/`). O diagnóstico defensivo de
2026-06-10 (reports/20260610-63) achou exposição ativa: credenciais reais do
WordPress legado versionadas e servidas estaticamente, segredos de produção
em plaintext no disco e certificados A1 (PFX) com pastas nomeadas por
CPF/CNPJ fora do git mas dentro da árvore do projeto.

## O que entra PRIMEIRO (proporcional ao risco — máximo aqui)

1. **forbid-env (guard)** — bloqueia depósito/commit de `.env*`, `*.pfx`,
   `*.p12`, `wp-config*.php` e dumps `.sql` com dado real. Motivação direta:
   wp-config.php versionado; `.env.production.pulled` e
   `.env.local:37-44` (SUPERADMIN_*/ARQUITETO_*) em plaintext.
2. **scope-lock** — ondas declaram escopo; mexer em `public/`,
   `certificates/` ou auth exige onda própria com readback.
3. **raiz canônica + `.hbn/`** — STATE/handoff/readbacks padrão ADR-011,
   para as retomadas pararem de depender de memória.
4. **readback→hearback** — nenhuma mudança em auth/certificados sem
   confirmação de Maurício.

## Pré-condição de onboarding (decidir HOJE, antes de qualquer onda)

- Remover `public/timeless-site/` do repo e do deploy; rotacionar senha do
  banco WP e AUTH_KEYs (wp-config.php:23-29,51 — natureza: credencial de
  MySQL + salts; valores NÃO transcritos); avaliar reescrita de histórico
  (BFG) e visibilidade do remoto GitHub (org rwv8gscs8g-blip).
- Tirar `certificates/` (PFX reais, pastas CPF/CNPJ) e os `.env*` de
  produção da árvore do projeto → keychain/secret manager. Confirmado por
  evidência: PFX **nunca** esteve no git (só certificates/superadmin/README.md);
  o risco é de disco/backup, não de histórico.
- Desligar tokens de teste em produção (R2_RESET_ENABLED, scripts
  magic-token — scripts/test-magic-token-all-environments.sh).

Item segue quente até consolidação pelo arquiteto + hearback.
