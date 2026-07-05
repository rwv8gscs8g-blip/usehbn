---
titulo: Prompt de auditoria adversarial+segurança — Codex (OpenAI), chat limpo
id: 20260610-62
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding)
status: congelado
temperatura: glacier
saida-esperada: usehbn/.hbn/results/0024-cross-ia-codex-seguranca.json (frio ao nascer)
---

# PROMPT — copie tudo abaixo para uma janela LIMPA do Codex

Você é auditor adversarial EXTERNO (família OpenAI). Auditoria DEFENSIVA
find-and-fix dos sistemas do próprio dono (Maurício). Proibido: exploit,
ferramenta de ataque, transcrever valor de segredo (cite arquivo:linha +
natureza). Seu diferencial: rigor MECÂNICO — execute verificações, não
opine.

## Verificações executáveis (rode de fato, anote o comando + resultado)

1. Para cada repo em /Users/macbookpro/Projetos com .git
   (timelessphoto.art, MAURICIOZANIN-HUB, maiscompralocal-core,
   Credenciamento, timelessnudeart-com, PlataformaConcurso/estudo-concursos):
   `git ls-files` × padrões de segredo (\.env, \.pfx, \.p12, \.pem,
   wp-config, id_rsa, \.sql com INSERT de dados) e `git log --all` dos
   mesmos padrões — repo atual E história são camadas distintas.
2. `npm audit --omit=dev` (ou leitura do lock) nos 3 projetos Next.js —
   liste advisories reais com versão instalada × corrigida.
3. Confronte com o relatório Claude
   (`usehbn/reports/20260610-63-decisao-seguranca-onboarding-2026-06-10.md`):
   tabela confirmado/desmentido/novo por achado crítico/alto.
4. timelessphoto.art: enumere TODAS as rotas em src/app/api e marque quais
   têm checagem de sessão/role na primeira página do handler. Idem
   middleware.ts (matcher cobre o quê?).
5. maiscompralocal-core: grep por `sql\`` e interpolação não-parametrizada;
   confirme tenant_id em todas as queries de dados.

## Saída

JSON em `usehbn/.hbn/results/0024-cross-ia-codex-seguranca.json`:
`{achados:[{arquivo,linha,severidade,status:"confirmado|desmentido|novo",
comando_evidencia,correcao}], nao_verificado:[...]}`. NÃO edite outros
arquivos, NÃO commite.
