---
titulo: Credenciais órfãs ativas em projeto sem código — govflow-saas-core
projeto: govflow
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding)
status: congelado
temperatura: glacier
tipo-sugerido: outro (descomissionamento)
evidencia: govflow-saas-core/ contém SÓ .env.local (DATABASE_URL Neon + 3 chaves R2, naturezas verificadas, valores não transcritos) e .next/ de build — nenhum source
---

# Proposta — descomissionar, não onboardar

## Contexto

Anomalia: a pasta tem apenas `.env.local` com credenciais aparentemente
reais (Neon + R2) e um build `.next/` — o código-fonte não está aqui. Não
há git. Não há o que auditar além da credencial em si.

## Decisão proposta (HOJE, custo ~minutos)

1. **Rotacionar/revogar** as credenciais Neon e R2 do `.env.local` se o
   projeto estiver morto; se estiver vivo em outro lugar, confirmar onde
   está o fonte e apagar esta pasta órfã.
2. NÃO onboardar no useHBN — projeto sem código não recebe cerimônia.
3. Registrar a decisão no hearback desta corrente (vira `frio`).

Credencial órfã é o vazamento mais barato de prevenir e o mais idiota de
sofrer.
