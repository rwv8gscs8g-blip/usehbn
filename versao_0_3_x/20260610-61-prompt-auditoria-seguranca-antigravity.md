---
titulo: Prompt de auditoria adversarial+segurança — Antigravity-Gemini (Google), chat limpo
id: 20260610-61
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding)
status: congelado
temperatura: glacier
saida-esperada: usehbn/.hbn/results/0023-cross-ia-antigravity-seguranca.md (frio ao nascer)
---

# PROMPT — copie tudo abaixo para uma janela LIMPA do Antigravity-Gemini

Você é auditor adversarial EXTERNO (família Google, sem histórico com este
ecossistema). Auditoria DEFENSIVA dos sistemas do próprio dono (Maurício):
achar e corrigir, nunca explorar. NÃO escreva exploit; NUNCA transcreva
valor de segredo — cite arquivo:linha e natureza.

## Alvo 1 — Desafiar o diagnóstico Claude de 2026-06-10

Leia `usehbn/reports/20260610-63-decisao-seguranca-onboarding-2026-06-10.md`
e os itens `usehbn/inbox/*/20260610-5[3-9]-*.md`. Para CADA achado marcado
crítico/alto: (a) confirme por evidência própria (abra o arquivo:linha) ou
DESMINTA; (b) procure o que o Claude NÃO viu — vieses esperados de família:
confiança excessiva em verificação por grep, subavaliação de cadeias de
exploração entre projetos (mesma conta Neon/R2/Vercel compartilhada?),
LGPD/exposição jurídica.

## Alvo 2 — Os 3 top-risco, com olhos frescos

1. timelessphoto.art — EM PRODUÇÃO: confirme remoção/risco do WordPress em
   public/ (wp-config.php tracked), cadeia certificados A1 ↔ better-auth ↔
   usuários mágicos via env, rotas /api sem validação.
2. MAURICIOZANIN-HUB — RBAC dos 186+ endpoints (amostre 15 por
   criticidade), TOTP sem rate limit (confirme ou desminta), deploy-info.
3. maiscompralocal-core — isolamento multi-tenant de ponta a ponta
   (middleware → presigned URL → queries Drizzle com tenant_id?).

## Regras de saída

Formato por achado: `arquivo:linha | severidade | confirmado/desmentido/novo
| correção (1 frase)`. Declare explicitamente o que não verificou. Grave o
relatório em `usehbn/.hbn/results/0023-cross-ia-antigravity-seguranca.md`
com front-matter `temperatura: frio`. NÃO edite nenhum outro arquivo, NÃO
commite, NÃO rode ferramenta de ataque.
