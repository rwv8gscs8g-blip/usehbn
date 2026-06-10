---
titulo: Documento de decisão — segurança defensiva + onboarding multi-projeto
id: 20260610-63
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding, chat limpo)
status: proposed
temperatura: quente (vira frio no hearback desta corrente)
tipo: decisao
metodo: triage 7 projetos → profundo nos 3 top-risco (subagentes + verificação direta por git/grep) → inicial nos demais
regra-de-ouro: nenhum valor de segredo transcrito; achados de subagente só entram CONFIRMADOS por evidência direta
relacionado: [ADR-019 (proposto), inbox 20260610-53..59, prompts 20260610-61/62]
---

# Decisão — Segurança e onboarding dos 7 projetos (2026-06-10)

## Resumo para humano (leia só isto se tiver 2 minutos)

**Uma coisa pega fogo HOJE:** o timelessphoto.art — que está NO AR — tem um
WordPress inteiro (8.026 arquivos) versionado dentro de `public/`, incluindo
`wp-config.php` com credenciais reais de banco e chaves de autenticação.
Tudo em `public/` no Next/Vercel é servido como arquivo estático: qualquer
pessoa com a URL baixa o arquivo com as credenciais. E o repo tem remoto no
GitHub. **Decisão de hoje: tirar do ar, rotacionar, depois discutir o resto.**
Duas decisões baratas no mesmo pacote: rotacionar as credenciais órfãs do
govflow (pasta com .env e nenhum código) e tirar o e-CPF (.pfx) da árvore do
HUB. O restante é plano, não incêndio: onboarding proporcional dos projetos
no useHBN (propostas no inbox) e o ADR-019 tornando este diagnóstico
obrigatório antes de qualquer projeto avançar. Boa notícia verificada: ao
contrário do que os subagentes alegaram, NENHUM `.env` ou `.pfx` está
versionado em git em nenhum projeto — o problema do tphoto é o WordPress, e
os demais segredos são risco de disco, não de histórico.

## Tabela de decisão por projeto

| Projeto | Risco | Prontidão de lançamento | Top-3 vulnerabilidades (verificadas) | Esforço onboarding | Recomendação |
|---|---|---|---|---|---|
| **timelessphoto.art** | 🔴 CRÍTICO | EM PRODUÇÃO com exposição ativa | 1. wp-config.php com credenciais reais, tracked e servido público (public/timeless-site/suporte/wp-config.php:23-29,51) — CRÍTICA. 2. Segredos prod em plaintext no disco: .env.production.pulled, .env.local:37-44 (SUPERADMIN_*, ARQUITETO_*) + certificados A1 .pfx em pastas CPF/CNPJ (certificates/) — ALTA. 3. Tokens/fluxos de teste em produção (R2_RESET_ENABLED, magic-token) + CSP com unsafe-inline/eval, sem HSTS — MÉDIA | Alto (inbox 53) | **AGIR HOJE** (ver bloco abaixo); onboarding completo na sequência |
| **MAURICIOZANIN-HUB** | 🟠 ALTO | Ao vivo; base de auth acima da média | 1. e-CPF real `.certs/e-CPF-15030004866.pfx` + .env com Neon/R2 na árvore (NUNCA versionados — verificado; risco de disco/backup) — ALTA. 2. /api/deploy-info sem auth expõe metadados (route.ts:56-107) — MÉDIA. 3. /api/debug/clients em produção; rate-limit de TOTP não confirmado — MÉDIA | Médio (inbox 54; .hbn/ já existe) | Mover segredos p/ fora da árvore esta semana; formalizar cerimônia |
| **maiscompralocal-core** | 🟠 MÉDIO-ALTO | MVP pré-piloto (prefeituras); NÃO pronto p/ público | 1. mock-sso sem guard de ambiente + cookie secure:false (mock-sso/route.ts:52-54) — MÉDIA-ALTA. 2. Presigned URL sem validação de tenant (r2client.ts:23-30) — MÉDIA-ALTA. 3. dangerouslySetInnerHTML em SVG sem CSP; audit_log sem integridade (schema.ts:220-244) — MÉDIA | Médio (inbox 55) | Gate de 5 itens antes do piloto; onboardar junto |
| **Credenciamento** | 🟡 MÉDIO | v12 estabilização; sem exposição web | 1. PII em 100+ .xlsm em backups na árvore — MÉDIA. 2. Manifesto TOKEN em vba_import (natureza não confirmada) — BAIXA-MÉDIA. 3. Macros não auditadas — NÃO VERIFICADO A FUNDO | Baixo (já usa useHBN; inbox 56) | Guard de PII; auditoria de macros em onda futura |
| **PlataformaConcurso** | 🟡 MÉDIO | Parado/MVP | 1. tsconfig/ SEM git com .env real — MÉDIA. 2. Senhas demo em seed (estudo-concursos/prisma/seed.ts) — MÉDIA. 3. Resto NÃO VERIFICADO A FUNDO | Baixo, adiado (inbox 57) | Decidir estrutura quando reativar; rotacionar DB se vivo |
| **govflow-saas-core** | 🟠 ALTO pontual | Não é projeto — é credencial órfã | 1. .env.local com Neon+R2 ativos e ZERO código — ALTA. 2/3. n/a | Nenhum (inbox 58) | **Rotacionar/descomissionar HOJE** (minutos) |
| **timelessnudeart-com** | 🟢 BAIXO | Estático no ar | Embeds sem SRI/forms (por analogia à cópia em tphoto/public) — BAIXA; repo em si NÃO VERIFICADO A FUNDO | Mínimo (inbox 59) | Checklist estático; sem cerimônia |

Mythos: **não existe em /Projetos** nesta data — nada a auditar; quando
nascer, ADR-019 aplica no onboarding.

## Decidir HOJE (independe de qualquer lançamento)

1. **tphoto**: remover `public/timeless-site/` do repo e do deploy Vercel;
   rotacionar credenciais do wp-config.php (banco + salts) no host do
   WordPress legado; verificar visibilidade do repo GitHub
   (rwv8gscs8g-blip/timelessphotoart-v1-0-000) e avaliar BFG no histórico.
2. **govflow**: rotacionar/revogar Neon + R2 do `.env.local` órfão; apagar a
   pasta ou localizar o fonte verdadeiro.
3. **HUB**: mover `.certs/` e `.env*` com valores reais para fora da árvore
   (keychain/secret manager).
4. **Hearback** dos depósitos desta corrente (53–63) — nada disso governa
   sem confirmação.

## Decidir QUANDO o projeto avançar (gates, sem desenvolver agora)

- **maiscompralocal → piloto**: os 5 itens do inbox 55.
- **tphoto → próxima versão**: onboarding completo (inbox 53) + segredos
  fora do disco + revisão de auth/certificados.
- **HUB → qualquer onda de auth**: scope-lock + correções do inbox 54.
- **PlataformaConcurso → reativação**: decisão estrutural do inbox 57.
- **Todos**: ADR-019 (diagnóstico obrigatório) — se aceito no hearback.

## Verificação cruzada pendente

Prompts preparados (NÃO executados): 20260610-61 (Antigravity-Gemini) e
20260610-62 (Codex), saídas esperadas em `.hbn/results/0023/0024`. Três
alegações de subagente foram desmentidas por evidência direta nesta
corrente (.env "versionado" no tphoto/HUB; bypass na rota de certificado do
HUB) — a auditoria cruzada existe exatamente para fazer isso comigo.

## O que esta corrente NÃO fez (sem inflar)

Não rodou npm audit real; não auditou rota a rota os 186+ endpoints do HUB
nem as macros VBA; não testou nada em runtime; não verificou visibilidade
dos repos GitHub; timelessnudeart e PlataformaConcurso tiveram só triage.
Tudo isso está endereçado nos prompts 61/62 e nas ondas propostas.
