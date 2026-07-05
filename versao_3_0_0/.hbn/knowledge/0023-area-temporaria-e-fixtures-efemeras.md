---
knowledge-id: 0023
titulo: Fixtures efêmeras fora de paths governados; área temporária segura
status: accepted
temperatura: quente
path: versao_3_0_0/.hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md
data: 2026-06-16
origem: onda S3.1 (readback 0029) — o orquestrador criou uma knowledge-fantasma para provar o G-KNOW-INDEX e não conseguiu apagá-la (sandbox não faz unlink no mount)
revisar-em: 2026-12-16
---

# 0023 — não crie descartável em path governado

Toda IA que precise de arquivo **efêmero** (fixture de teste, prova de
conceito, rascunho de verificação) deve criá-lo no **espaço próprio do seu
ambiente** (sandbox/tmp da sessão), **fora** do repositório versionado. Nunca
em paths governados (`.hbn/**`, `guards/**`, `core/**`, `schemas/**`).

Motivo concreto (evidência): o sandbox monta o repositório com permissão de
**criar/editar mas não apagar** (`rm` → "Operation not permitted"). Um
descartável criado em path governado vira **lixo que a própria IA não consegue
remover** — só o humano (disco real) ou o implementador numa onda. Isso é
proteção, não defeito: impede que uma IA suma com arquivos do repo.

Regra:
1. Efêmero vai para o tmp do ambiente da IA, fora do mount do repo.
2. Para provar que um guard bloqueia, prefira **stage temporário + unstage**
   (sem deixar arquivo no worktree) a criar arquivo solto.
3. Se um scratch no repo for inevitável, use SÓ a área temporária oficial
   (ver proposta em cross-audit / futura spec), que é gitignored e protegida
   por guard contra commit.

Vale para QUALQUER IA (Opus, Codex, Gemini, Cursor). Anti-padrão proibido:
`printf ... > .hbn/knowledge/9999-teste.md` para "testar rápido".
