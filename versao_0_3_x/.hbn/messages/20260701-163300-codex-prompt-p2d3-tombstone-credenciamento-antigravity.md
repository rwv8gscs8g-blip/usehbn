---
titulo: "Prompt de implementacao - P2-D3 tombstone do espelho usehbn - Credenciamento - Antigravity"
tipo: prompt
status: congelado
temperatura: glacier
path: .hbn/messages/20260701-163300-codex-prompt-p2d3-tombstone-credenciamento-antigravity.md
created_at: "2026-07-01T16:33:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
destino: antigravity
resultado_esperado: /Users/macbookpro/Projetos/Credenciamento/.hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md
---

⟦HBN-COPY dest=antigravity⟧ BEGIN
SOU: antigravity · familia Google · papel implementador

CHAT NOVO, SEM MEMORIA.

OBJETIVO:
Preparar a sub-onda P2-D3 no repo Credenciamento: tombstone controlado do antigo espelho versionado usehbn/ apos P2-D1 router e P2-D2 untangle. O resultado esperado e um patch preparado, validado e documentado, sem commit e sem push.

REPO ALVO:
/Users/macbookpro/Projetos/Credenciamento

BRANCH ESPERADA:
codex/v12-0-0206-planejamento

HEAD ESPERADO:
eb3f2850b8beb03aa50ddbe9143e4f00341d051e

CONTEXTO CANONICO:
- usehbn G-STATE foi selado no repo do protocolo em dc68cd1dafa5cbecdea97e9b459e05c0b1868d67.
- O STATE canonico do protocolo aponta a retomada do PASSO 2 / P2-D.
- No Credenciamento, P2-D1 ja esta feito: router no topo do AGENTS.md.
- No Credenciamento, P2-D2 ja esta feito: artefatos de dominio foram movidos para docs/reference/**.
- O readback 0183 declara explicitamente que P2-D3 e o tombstone do espelho usehbn/ restante.

PAPEL:
Voce e implementador externo preferencial, familia Google. Voce prepara o patch e salva handoff. Voce nao audita o proprio trabalho.

NAO FAZER:
- Nao commite.
- Nao push.
- Nao use --no-verify.
- Nao use git add -A.
- Nao use HBN_GUARDS_BYPASS.
- Nao toque /Users/macbookpro/Projetos/usehbn.
- Nao edite .usehbn-snapshot/**.
- Nao edite AGENTS.md.
- Nao faca P2-D4 limpeza de referencias.
- Nao faca P2-D5 selagem.
- Nao toque src/**, local-ai/**, backups/**, formularios, .frm, .frx, workbook, scripts de dominio, VBA ou artefatos operacionais.
- Nao remova docs/reference/**.
- Nao remova arquivos ignorados como .DS_Store; eles nao devem entrar no diff.

LEIA ANTES DE AGIR:
- /Users/macbookpro/Projetos/Credenciamento/AGENTS.md
- /Users/macbookpro/Projetos/Credenciamento/.hbn/readbacks/0182-rb-p2d1-router-agents.json
- /Users/macbookpro/Projetos/Credenciamento/.hbn/readbacks/0183-rb-p2d2-untangle.json
- /Users/macbookpro/Projetos/Credenciamento/scripts/hbn-guards/README.md
- /Users/macbookpro/Projetos/Credenciamento/scripts/hbn-guards/assert-scope-lock.sh
- /Users/macbookpro/Projetos/Credenciamento/scripts/hbn-guards/hbn-guards-runner.sh
- /Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md

PREFLIGHT, UM COMANDO POR VEZ:
COMANDO 1: git -C /Users/macbookpro/Projetos/Credenciamento rev-parse --abbrev-ref HEAD
COMANDO 2: git -C /Users/macbookpro/Projetos/Credenciamento rev-parse HEAD
COMANDO 3: git -C /Users/macbookpro/Projetos/Credenciamento status --short --branch
COMANDO 4: git -C /Users/macbookpro/Projetos/Credenciamento ls-files usehbn
COMANDO 5: find /Users/macbookpro/Projetos/Credenciamento/docs/reference -maxdepth 2 -type d | sort

SE O PREFLIGHT MOSTRAR BRANCH OU HEAD DIFERENTE, OU WORKTREE DIRTY:
Pare. Salve handoff bloqueado no destino abaixo. Nao tente corrigir por conta propria.

ALVO DE CONTEUDO:
Depois da sub-onda, o unico arquivo versionado sob usehbn/ deve ser:
- usehbn/TOMBSTONE.md

CONTEUDO MINIMO DO TOMBSTONE:
# TOMBSTONE - usehbn legacy mirror

Este diretorio nao e fonte ativa do protocolo nem do projeto.

Nao leia, edite ou use arquivos historicos deste espelho como fonte de verdade. O genoma HBN vigente do projeto vive em .usehbn-snapshot/ e e somente leitura. Artefatos de dominio migrados vivem em docs/reference/.

Para evoluir o protocolo, use o repo canonico /Users/macbookpro/Projetos/usehbn e a rota definida pelo orquestrador vigente.

Estado: P2-D3 tombstone controlado. Apenas este TOMBSTONE.md deve permanecer versionado sob usehbn/.

ARQUIVOS PERMITIDOS NO PATCH:
- .hbn/readbacks/0184-rb-p2d3-tombstone-usehbn.json
- usehbn/TOMBSTONE.md
- usehbn/methodology/**
- usehbn/modules/**
- .hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md

ARQUIVOS PROIBIDOS:
- .usehbn-snapshot/**
- AGENTS.md
- docs/reference/**
- src/**
- local-ai/**
- backups/**
- *.frm
- *.frx
- scripts/**
- auditoria/**
- /Users/macbookpro/Projetos/usehbn/**

IMPLEMENTACAO:
1. Criar .hbn/readbacks/0184-rb-p2d3-tombstone-usehbn.json.
2. O readback 0184 deve ter track safe_track, human_status confirmed, hearback_status confirmed, canonical_root /Users/macbookpro/Projetos/Credenciamento, branch codex/v12-0-0206-planejamento, predecessor_readback_id 0183-rb-p2d2-untangle.
3. Em intent.objective, declarar: P2-D3 tombstone controlado do espelho usehbn/ restante, apos untangle P2-D2.
4. Em intent.non_goals, declarar: nao P2-D4, nao P2-D5, nao .usehbn-snapshot, nao AGENTS, nao codigo de dominio, nao VBA.
5. Em scope.files_allowed, declarar exatamente os arquivos/padroes permitidos listados acima.
6. Em scope.files_forbidden, declarar os proibidos listados acima.
7. Em decision.human_approval, registrar que Mauricio pediu em 2026-07-01 a continuidade do ciclo P2-D para fechar o fortalecimento e retomar o plano aprovado, com P2-D3 como proxima sub-onda identificada pelo readback 0183.
8. Criar usehbn/TOMBSTONE.md com o conteudo minimo acima.
9. Remover do Git, via git rm escopado, os arquivos versionados restantes sob:
   - usehbn/methodology/**
   - usehbn/modules/**
10. Nao tocar .DS_Store. Se existir no filesystem, ignore; ele nao deve aparecer em git status.
11. Stagear somente:
   - .hbn/readbacks/0184-rb-p2d3-tombstone-usehbn.json
   - usehbn/TOMBSTONE.md
   - remocoes de usehbn/methodology/**
   - remocoes de usehbn/modules/**
   - .hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md, depois de criado

VALIDACAO, UM COMANDO POR VEZ:
COMANDO 6: git -C /Users/macbookpro/Projetos/Credenciamento diff --cached --name-status
COMANDO 7: git -C /Users/macbookpro/Projetos/Credenciamento diff --cached --check
COMANDO 8: git -C /Users/macbookpro/Projetos/Credenciamento ls-files usehbn
COMANDO 9: bash /Users/macbookpro/Projetos/Credenciamento/scripts/hbn-guards/validate-readback.sh /Users/macbookpro/Projetos/Credenciamento/.hbn/readbacks/0184-rb-p2d3-tombstone-usehbn.json
COMANDO 10: cd /Users/macbookpro/Projetos/Credenciamento && bash scripts/hbn-guards/hbn-guards-runner.sh
COMANDO 11: git -C /Users/macbookpro/Projetos/Credenciamento status --short

CRITERIO DE PRONTO:
- Worktree inicial estava limpo no HEAD esperado.
- 0184 existe e e o ultimo readback numerico.
- Scope do 0184 cobre exatamente o patch.
- usehbn/TOMBSTONE.md existe.
- git ls-files usehbn mostra somente usehbn/TOMBSTONE.md.
- Nenhum arquivo em .usehbn-snapshot/** foi modificado.
- Nenhum arquivo de dominio foi modificado.
- P2-D4 e P2-D5 nao foram iniciados.
- validate-readback verde.
- hbn-guards-runner verde ou bloqueio explicado sem bypass.
- Nenhum commit foi criado.

DESTINO DO HANDOFF:
Salve em:
/Users/macbookpro/Projetos/Credenciamento/.hbn/messages/20260701-163300-antigravity-handoff-p2d3-tombstone-usehbn.md

FORMATO DO HANDOFF:
- Front matter com tipo: handoff, autor: antigravity, familia: Google, path correto, created_at local.
- Linha SOU.
- Resumo do que foi preparado.
- Lista exata de arquivos tocados.
- Saida resumida dos comandos 1 a 11.
- Resultado de git diff --cached --name-status.
- Confirmacao explicita: commit nao criado, push nao feito, P2-D4 nao iniciado, P2-D5 nao iniciado.
- Se algo bloqueou, explique o bloqueio e pare.
- Ultima linha:
ANTIGRAVITY_P2D3_TOMBSTONE_USEHBN: PRONTO
⟦HBN-COPY END⟧
