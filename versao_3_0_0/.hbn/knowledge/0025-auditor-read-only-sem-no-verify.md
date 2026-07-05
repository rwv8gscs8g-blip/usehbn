---
knowledge-id: 0025
titulo: Auditor cruzado e estritamente read-only; nada de --no-verify na branch de trabalho
status: accepted
temperatura: quente
path: versao_3_0_0/.hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
data: 2026-06-16
origem: cross-audit W2 (readback 0034) — um agente (claude-fable-5 + Cursor) criou um commit vazio "ci bad prose b31" com --no-verify para testar a burla B31 e o deixou vazar no topo da branch proposta; o orquestrador pegou no disco e o humano removeu por reset.
revisar-em: 2026-12-16
---

# 0025 — auditor read-only; --no-verify so em branch descartavel

O auditor cruzado NAO commita, NAO faz staging, NAO toca a branch de trabalho.
Quando um teste exigir criar commit (ex.: provar que um guard bloqueia uma
mensagem ruim), faca-o SOMENTE em branch descartavel/temporaria que o auditor
APAGA ao terminar. Nunca na branch de trabalho.

--no-verify bypassa TODOS os guards locais por design. Um commit assim, sem
trailers validos, pode vazar para a branch e so e pego por conferencia no disco
(o orquestrador confere o HEAD real, nao o relato). A defesa estrutural e
branch protection + CI re-rodando os guards no range (range-check), que barra
--no-verify no boundary (origin/main).

Vale para QUALQUER IA auditora. Anti-padrao proibido: "git commit --no-verify"
de fixture de teste na branch de trabalho, sem limpar.
