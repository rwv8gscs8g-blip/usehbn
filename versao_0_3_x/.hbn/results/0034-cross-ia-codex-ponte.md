---
titulo: "0034 — Cross-IA Codex — auditoria da ponte consolidada usehbn ⇄ Credenciamento"
tipo: result
path: .hbn/results/0034-cross-ia-codex-ponte.md
id-global: 20260611-002529-codex-audit-ponte
temperatura: glacier
auditor: codex-openai
alvo: "usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md"
veredito: VETO_ADOCAO
veto_adocao: sim
anexo_maquina: ".hbn/results/0034-cross-ia-codex-ponte.json"
status: congelado
---

# 0034 — Cross-IA Codex — ponte usehbn ⇄ Credenciamento

## Veredito

**VETO_ADOCAO: SIM.**

Recomendação de hearback: **não confirmar a adoção nesta versão**. Devolver para correção do alvo com (1) manifesto fechado por arquivo antes do R8, (2) conta corrigida dos artefatos que entram, (3) corpo exato do split do firewall 0022, (4) T3 refeito contra a falha cognitiva real e (5) runbook ajustado para não mascarar perda após o `git rm`.

## Resumo (<=10 linhas)

1. Reexecutei o diff 5-estados: os números brutos batem (`IGUAL=0`, `DIVERGE=1`, `SO-COPIA=109`, sendo 106 uteis + 3 fora-da-matriz; `SO-CANONICO=30`).
2. A adjudicação de `PRINCIPIOS-CONSTITUCIONAIS.md` e defensavel: a copia esta pre-MD-F/MD-J e o canonico tem a evolucao correta.
3. A ponte falha na aritmetica de migracao: 106 uteis - 5 prompts descartados + 1 firewall novo = 102, nao 107.
4. O criterio pos-migracao `SO-COPIA=0` e inseguro se rodado depois do R8, porque o `git rm -r usehbn/` apaga a fonte de comparacao.
5. O split do firewall 0022 nao e auditavel como "verbatim": o alvo nao traz o corpo exato do novo arquivo nem o patch do binding local.
6. O T3 ainda permite teatro: a pergunta sobre "P7" conflita com a regra de severidade que hoje esta no knowledge 0019 do Credenciamento.
7. O guard de snapshot le blob staged e cobre rename/delete internamente, mas nao prova "mudou so via fetch" se alguem recomputar manifest/checksum manualmente.
8. O runbook nao toca dominio/VBA/workbook, mas precisa de comandos/manifesto mais fechados antes de hearback.

## Reexecucao do diff 5-estados

Resultado independente, a partir do bloco do §0:

| Medida | Resultado Codex | Veredito |
|---|---:|---|
| Arquivos na copia `Credenciamento/usehbn/` | 110 | OK |
| `IGUAL` | 0 | OK |
| `DIVERGE` | 1 | OK |
| `SO-COPIA` mecanico | 109 | OK |
| `FORA-DA-MATRIZ` | 3 (`.DS_Store`, `study-plans/.DS_Store`, `radar/_per-technology/.gitkeep`) | OK |
| `SO-COPIA` util | 106 | OK |
| `SO-CANONICO` em `usehbn/methodology/` | 30 | OK |

O diff integral de `PRINCIPIOS-CONSTITUCIONAIS.md` confirmou 70 insercoes / 71 remocoes, 363 linhas na copia e 362 no canonico. A copia ainda tem `data: 2026-05-09`, `licenca-target: usehbn (AGPLv3)` e cabecalho pre-migracao; o canonico tem `data-migracao`, origem MD-F, nota de isonomia P1-P13 e nota P12/Python. Evidencia: [proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:61), [copia PRINCIPIOS](/Users/macbookpro/Projetos/Credenciamento/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md:7), [canonico PRINCIPIOS](/Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md:7), [nota P12](/Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md:282).

## Veredito por secao do alvo

| Secao | Severidade | Veredito |
|---|---|---|
| §0 Diff 5-estados | OK | Numeros brutos batem; `PRINCIPIOS` canonicamente vence. |
| §1 Propriedade / 0022 | BLOQUEADOR | Direcao correta, mas split nao tem corpo exato auditavel. |
| §2 Completar canonico | BLOQUEADOR | Conta "107 entram" nao fecha e pode mascarar descarte. |
| §3 Scripts MD-I | FORTE | Manifest deterministico esta plausivel; guard staged e bom, mas claim "so fetch" e forte demais. |
| §4 Snapshot | OK | Conteudo `methodology/` + `modules/` esta alinhado a MD-K, condicionado a §2 corrigido. |
| §5 Tombstone/read-list | FORTE | Ideia correta; R8 precisa criar README explicitamente e nao ser usado como prova de zero perda. |
| §6 Router/travas | FORTE | Router e util, mas T3 nao prova compreensao suficiente. |
| §7 Validacao | FORTE | T2 parcial; T3 ambiguo e fraco contra teatro. |
| §8 Gatilho/firewall | OK | Desacoplado da V206 e sem escrita de dominio/VBA/workbook. |
| §9 Runbook | FORTE | Sequencia geral boa, mas R2/R8/R10 precisam manifesto e rollback mais preciso. |
| §10 STATE proposto | MARGINAL | Repete numeros/estado dependentes das correcoes acima. |

## BLOQUEADOR

### B-01 — A conta "107 entram" nao fecha e o `SO-COPIA=0` pos-R8 pode mascarar perda

O alvo declara `audits/` com 3 relatorios + 6 prompts, dos quais 1 vira template e 5 sao descartados com registro ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:179)). A mesma decisao ja estava na MD-K: 1 template mantido e 5 prompts removidos com registro ([MD-K](/Users/macbookpro/Projetos/usehbn/auditoria/00_status/08_MD_K_MATRIZ_ORIGEM_DESTINO.md:152)).

Com a reexecucao:

- `SO-COPIA` util = 106.
- prompts em `audits/` = 6; relatorios = 3.
- se 5 prompts nao entram, os artefatos derivados/copias que entram sao `106 - 5 + 1 firewall novo = 102`.

Isso contradiz a linha "Total que ENTRA no canonico: 107 arquivos" ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:186)) e o commit R2 que promete "106 SO-COPIA promovidos" enquanto o proprio runbook manda nao copiar 5 prompts ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:543)).

O criterio de verificacao tambem e inseguro: o alvo manda rerodar o diff para `SO-COPIA=0` ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:197)), mas R8 executa `git rm -r usehbn/` antes de R10 rodar T1-T4 ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:561), [proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:565)). Depois disso, `SO-COPIA=0` pode significar apenas "a origem foi apagada", nao "todo conteudo valioso foi promovido".

Recomendacao: antes de hearback, substituir a contagem agregada por um manifesto fechado `origem -> destino -> acao -> hash`, produzido antes do R8. O R10 deve comparar o manifesto contra o canonico e contra a lista pre-R8, nao contra uma copia ja tombstoned. A mensagem do R2 deve dizer a conta real e listar nominalmente os 5 prompts descartados.

### B-02 — O split do firewall 0022 nao e verificavel como "verbatim"

O alvo diz que o novo `FIREWALL-ORQUESTRACAO.md` deve ser o estrato generico do 0022 e que o binding local apontara para o snapshot ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:122), [proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:125)). Tambem afirma que o corpo proposto reusa o texto do 0022 verbatim ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:152)).

Mas o alvo nao traz o corpo exato do arquivo novo nem o patch exato do 0022 local; so traz a instrucao "corpo = 0022 atual..." ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:182)) e um comentario no R3 ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:549)). Isso impede confirmar equivalencia semantica. O 0022 atual mistura regra geral com dominio local em secoes continuas: regra geral e safe-track humano ([0022](/Users/macbookpro/Projetos/Credenciamento/.hbn/knowledge/0022-firewall-workflow-fast-track.md:15)), exemplos locais de `src/vba/`, Importador/Excel ([0022](/Users/macbookpro/Projetos/Credenciamento/.hbn/knowledge/0022-firewall-workflow-fast-track.md:22)), e consequencias praticas que alternam generico e Credenciamento ([0022](/Users/macbookpro/Projetos/Credenciamento/.hbn/knowledge/0022-firewall-workflow-fast-track.md:42)).

Recomendacao: incluir no alvo, antes de hearback, o texto integral proposto de `usehbn/methodology/FIREWALL-ORQUESTRACAO.md` e o patch integral do `Credenciamento/.hbn/knowledge/0022...`. A auditoria deve comparar linha a linha o trecho generico preservado, e o binding local deve ter read-list resolvivel para `.usehbn-snapshot/methodology/FIREWALL-ORQUESTRACAO.md`.

## FORTE

### F-01 — T3 e ambiguo e fraco contra teatro de teste

O T3 pergunta a uma IA fria "onde leio a regra P7?" e espera `.usehbn-snapshot/methodology/...` ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:488)). Mas a regra de severidade que este proprio parecer teve de usar esta no knowledge 0019 do Credenciamento, sob "Severidade de auditoria e veto (P7)" ([0019](/Users/macbookpro/Projetos/Credenciamento/.hbn/knowledge/0019-cadencia-d-estendida-passagem-bastao.md:60)). O alvo reconhece que 0019 e candidato protocolo-generico futuro, via inbox, nao parte da ponte atual ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:132)).

Isso torna o gabarito fechado arriscado: ele recompensa repetir o router, mas nao prova que a IA entendeu a fronteira real entre snapshot, knowledge local e inbox. Tambem nao testa decisao sob conflito, que foi a classe de regressao.

Recomendacao: reescrever T3 com alvos nao ambiguos e exigir justificativa com path + modo de escrita. Exemplo: "onde leio P7 constitucional?", "onde leio severidade de auditoria enquanto 0019 ainda nao foi fagocitado?", "como proponho promover 0019 ao protocolo?", "posso editar `.usehbn-snapshot/` para corrigir isso?". O verde deve exigir resposta operacional, nao so 3 strings.

### F-02 — O guard de snapshot le o staged blob, mas nao prova "mudou so via fetch"

O desenho acerta ao ler `git show :path` e nao a worktree ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:313)); o `diff-filter=ACMRD` cobre adicao, copia, modificacao, rename e delete para disparar o gate ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:327)); a lista de blobs staged alimenta o verify ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:329)).

O problema e a afirmacao "checksum regeneraveis so por fetch" ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:316)). O verify proposto valida consistencia interna do snapshot; se alguem editar um arquivo e recomputar manifest/checksum manualmente, a estrutura pode passar. O T2 so testa mutacao sem regerar manifest ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:487)).

Recomendacao: ou reduzir a alegacao para "bloqueia drift interno nao regenerado", ou adicionar prova contra o canonico/tag de origem. Se a regra for "so via fetch", T2 precisa de caso negativo: "mutar arquivo + recomputar manifest/checksum manualmente" deve falhar por divergencia contra a tag/source manifest.

### F-03 — R8 nao materializa o README do tombstone e o rollback esta subespecificado

O desenho do tombstone exige um `README.md` de uma linha ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:401)), mas o R8 executavel faz `git rm -r usehbn/ && mkdir usehbn` e nao cria o README ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:561)). Como Git nao rastreia diretorio vazio, o commit pode terminar sem tombstone se o humano seguir literalmente o bloco.

O rollback tambem precisa ser mais preciso: ha tag no Credenciamento ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:524)) e `git revert` por commit no canonico ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:570)), mas R3/R4/R5/R6 ja fazem edicoes antes do R8 ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:549)). Para um runbook humano, isso deve ser comando fechado por repo, nao orientacao geral.

Recomendacao: escrever o README explicitamente no R8, separar rollback por repo e por etapa, e definir ponto de parada caso R2/R3/R7 falhem antes de remover a copia.

## MARGINAL

### M-01 — Caminhos de leitura indicados nao batem integralmente com o disco atual

O knowledge 0019 solicitado no caminho canonico nao existe; a regra de severidade/anti-vies esta em `Credenciamento/.hbn/knowledge/0019...` ([0019](/Users/macbookpro/Projetos/Credenciamento/.hbn/knowledge/0019-cadencia-d-estendida-passagem-bastao.md:54)). A matriz `08_MD_K_*` tambem nao esta em `Credenciamento/auditoria/00_status`; a copia efetiva lida esta em `usehbn/auditoria/00_status/08_MD_K_MATRIZ_ORIGEM_DESTINO.md` ([MD-K](/Users/macbookpro/Projetos/usehbn/auditoria/00_status/08_MD_K_MATRIZ_ORIGEM_DESTINO.md:1)).

Recomendacao: corrigir os caminhos no proximo handoff/STATE para evitar que a proxima auditoria leia artefato errado ou marque ausencia falsa.

### M-02 — `forbidden-paths` congelando o README e aceitavel, mas deve ficar explicito no R8

O alvo reconhece que os globs bloqueiam o README do tombstone ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:614)). Isso e aceitavel como congelamento pos-R8, mas so depois de o README existir e ser commitado.

Recomendacao: manter a escolha, mas ordenar o R8 como: remover copia, criar README, commit, depois adicionar globs de congelamento em commit separado ou no mesmo commit apos `git add` do README.

## OK

- §0: os numeros mecanicos batem, inclusive `SO-CANONICO=30` na particao `methodology/` ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:61)).
- §0 achado 1: `PRINCIPIOS` canonico vence; a copia esta pre-migracao e sem as notas MD-J ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:77)).
- §3.1/3.2: o manifest exclui `generated_at` do checksum e calcula hash de conteudo; o caso `.docx` binario nao e normalizado pelo fetch porque a normalizacao limita `*.md/*.json/*.txt` ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:205)).
- §3.3: como guard de consistencia interna, a leitura staged/HEAD e correta e cobre delete/rename pelo conjunto `ACMRD` ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:327)).
- §8/§9: nao encontrei passo que escreva `src/vba/`, workbook ou dominio; o alvo declara desacoplamento da V206 e firewall humano-aplicado ([proposta](/Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md:503)).

## Checklist anti-vies B1-B6

| Item | Resultado |
|---|---|
| B1 — Janela nova / sem memoria operacional | Cumprido: parti dos arquivos indicados e do diff reexecutado. |
| B2 — Independencia de parecer alheio | Cumprido: nao li parecer da Antigravity; reexecutei o diff. |
| B3 — Procurar reprovacao antes de aprovacao | Cumprido: ataquei primeiro os pontos A-F e a aritmetica de perda. |
| B4 — Evidencia objetiva acima de intuicao | Cumprido: findings citam arquivo:linha e resultado mecanico do diff. |
| B5 — Reconhecer vies do auditor | Risco: Codex auditando proposta Anthropic pode tender a divergencia. Mitigacao: classifiquei §0 e partes do guard como OK quando a evidencia sustentou. |
| B6 — Limites declarados | O caminho canonico do 0019 e o caminho Credenciamento da MD-K nao existem no disco atual; usei os homonimos efetivos e registrei a anomalia. |

## Anexo de maquina

Arquivo JSON: `.hbn/results/0034-cross-ia-codex-ponte.json`.
