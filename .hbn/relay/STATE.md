---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (modelo versão=pasta; M-A scaffold inativo; B19/S2/faxina 0027/S3.1/S3.2/P-CAND-04/W2 selados; grande selagem 0035 concluida; W3 deny-zona-livre ratificado e selado; R1 runtime+honestidade entregue; R1-fix dedup estado entregue; R1+R1-fix selados; R1-fix-2 entregue; selagem R1-fix-2 concluida; Esteira de Pre-Transicao promovida para core; Esteira de Pre-Transicao selada e vigente; Curadoria P0 docs entregue)"
onda_atual: "Curadoria P0 docs ENTREGUE operacionalmente; readback 0045 segue ativo aguardando cross-audit ≠-familia + selagem; bastao retorna ao orquestrador"
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: claude-opus-4-8
papel_bastao: "orquestrador"
modo_educacional: "intermediário"
papeis:
  arquiteto: "claude-opus-4-8 — orquestrador/desenho do mecanismo M-A; distinto do implementador codex"
  auditores_validadores: "gemini-3-5 + cursor + grok + antigravity — historico: S1/B17/B18/B19/S2/faxina/S3.1/S3.2 aprovados; P-CAND-04 ratificado por Cursor APROVA_0033 SIM e Grok NAO resolvido pelo W2; W2 ratificado por Grok+Antigravity APROVA_0034 SIM; W3 ratificado por Grok, Antigravity 100 e Cursor 92 com APROVA_0036 SIM"
  gate_humano: "Maurício — aprovou a reestruturação em 2026-06-15; autorizou S1/B17/B18/B19/S2/faxina/S3.1/S3.2/P-CAND-04/W2; em 2026-06-16 autorizou grande selagem 0035, hardening->deny->freeze, selagem W3, cartao de entrada e branch protection biometrica na main"
proxima_acao: "Cross-audit ≠-familia + selagem da Curadoria P0; depois R2 arvores registry-centric."
sinais_abertos:
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0045 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; entrega concluida, excecao permanece proposta ate cross-audit ≠-familia + hearback/selagem."
  - "🟢 CURADORIA P0 DOCS ENTREGUE — AGENTS.md corrigido verbatim, docs/GLOSSARY.md criado, docs/MATURITY-MATRIX.md reduzido a stub de redirect e REGISTRY atualizado."
  - "🟢 TESTES 0045 VERDES — `.venv/bin/pytest -q` fechou 213 passed in 0.75s; `bash guards/tests/adversarial-battery.sh` bloqueou B1-B33."
  - "🔴 G-EXC PROPOSED_UNTIL_CROSS_AUDIT VISIVEL — readback 0044 safe_track, implementador=codex, autorização humana Mauricio e trailers contiguos; selagem encerrada com duplo APROVA_0043 + hearback."
  - "🟢 ESTEIRA PRE-TRANSICAO SELADA E VIGENTE — `core/esteira-pre-transicao.md` esta `status: accepted` e sem front-matter `arvore:`; corpo preservado."
  - "🟢 PARECERES ESTEIRA TRACKED — .hbn/results/20260617-102800-antigravity-cross-ia-esteira-0043.md e .hbn/results/20260617-104500-grok-build-0.1-cross-ia-esteira-0043.md versionados com linhas G-REG."
  - "🟢 TESTES 0044 VERDES — `.venv/bin/pytest -q` fechou 213 passed in 0.76s; `bash guards/tests/adversarial-battery.sh` bloqueou B1-B33."
  - "🟢 R1-FIX-2 SELADO — readback 0041 ratificado por Grok/xAI e Antigravity/Google com APROVA_0041 SIM; ambos trouxeram prova engine-real ANTES/DEPOIS."
  - "🟢 PARECERES TRACKED — .hbn/results/20260617-085700-antigravity-cross-ia-r1-fix2.md e .hbn/results/20260617-091000-grok-build-0.1-cross-ia-r1-fix2.md versionados com linhas G-REG."
  - "🟢 TESTES SELAGEM R1-FIX-2 VERDES — `.venv/bin/pytest -q` fechou 213 passed in 0.78s; `bash guards/tests/adversarial-battery.sh` bloqueou B1-B33."
  - "🟢 R1-FIX-2 ENTREGUE — store.py preserva decisions/context_history distintos que compartilham execution_id; teste engine-real cobre activation/validation/consent."
  - "🟢 TESTES R1-FIX-2 VERDES — `.venv/bin/pytest -q` fechou 213 passed in 0.74s; AGENTS, README e MATURITY-MATRIX sincronizados."
  - "🟢 ADVERSARIAL B1-B33 VERDE — guards/tests/adversarial-battery.sh bloqueou todas as burlas documentadas."
  - "🟢 G-EXC 0041 COBERTO POR CROSS-AUDIT — readback 0041 recebeu duplo APROVA_0041 nao-OpenAI; selagem 0042 mantém exceção proposta visível ate fechamento."
  - "🟢 READBACK 0042 ENCERRADO OPERACIONALMENTE — C1-C3 concluiram readback, dois pareceres tracked, STATE e handoff; bastao volta ao orquestrador."
  - "🟡 PRÓXIMA AÇÃO — promover Esteira de Pre-Transicao para core, curar dossie e seguir R2 arvores registry-centric."
  - "🟢 R1+R1-FIX SELADO — readbacks 0038 e 0039 ratificados por Antigravity/Google, Grok/xAI e Cursor/OpenAI; cinco pareceres versionados na selagem 0040."
  - "🟢 TESTES 212/212 VERDES — `.venv/bin/pytest -q` fechou 212 passed in 0.75s; AGENTS, README e MATURITY-MATRIX sincronizados."
  - "🟢 ADVERSARIAL B1-B33 VERDE — guards/tests/adversarial-battery.sh bloqueou todas as burlas documentadas."
  - "🔴 EXCEÇÃO G-EXC DOCUMENTADA — implementador=codex coincide com agent_id do readback 0040; PROPOSED_UNTIL_CROSS_AUDIT satisfeito por cross-audit R1+R1-fix e mantido visivel enquanto 0040 for o readback ativo."
  - "🟢 READBACK 0040 ENCERRADO OPERACIONALMENTE — selagem concluida em C1-C4; handoff final devolve bastao ao orquestrador."
  - "🟡 PRÓXIMA AÇÃO — R2 arvores registry-centric (G-REG M + anti-mislabel)."
  - "🟢 R1 ENTREGUE — readback 0038 implementado em seis commits: golden tests dos subcomandos, exit codes honestos, estado canonico em .hbn/, docs alinhados e handoff final."
  - "🟢 TESTES R1 VERDES — pytest fechou 211/211 antes do handoff C6."
  - "🟢 GUARDS R1 VERDES — guards/hbn-guards-runner.sh passou antes de cada commit R1."
  - "🟡 PRÓXIMA AÇÃO — cross-audit R1 por familia nao-OpenAI; depois R2 arvores registry-centric (G-REG M + anti-mislabel)."
  - "🟢 W3 RATIFICADO E SELADO — readback 0036 ratificado por Grok, Antigravity 100 e Cursor 92 com APROVA_0036: SIM; G-ZONA-LIVRE ativo; deny-by-default da zona livre por construcao."
  - "🟢 BRANCH PROTECTION BIOMETRICA ARMADA — main com ruleset Active: require PR, restrict deletions, block force pushes; passkey Touch ID como gate do boundary."
  - "🟢 CARTAO DE ENTRADA UNIVERSAL DEPOSITADO — .hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md versionado como candidato a core/cartao-entrada.md."
  - "🟡 DIVIDA RASTREADA — marcador zona_livre_curada auto-declarado; hardening futuro: banir docs/brainstorm/** de todo files_allowed exceto onda de curadoria dedicada."
  - "🟡 PRÓXIMA AÇÃO — arvores registry-centric (coluna arvore no REGISTRY), depois freeze + tag v1-estavel."
  - "🟢 W3 ENTREGUE — G-ZONA-LIVRE ativo no runner; docs/brainstorm/** exige zona_livre_curada: true + zona_livre_nota nao-vazio no readback ativo."
  - "🟢 TESTES W3 VERDES — run-guard-tests fechou 178/178; adversarial-battery bloqueou B1-B33, incluindo B33 docs/brainstorm sem curadoria."
  - "🟢 CROSS-AUDIT W3 CONCLUIDO — quatro pareceres depositados: Grok 20:36, Grok 21:08, Antigravity 100 e Cursor 92."
  - "🟢 GRANDE SELAGEM 0035 CONCLUIDA — readback 0035, knowledge 0024/0025, proposta arvores+MVP, oito pareceres cross-audit, STATE e handoff selados."
  - "🟢 P-CAND-04 RATIFICADO E SELADO — Cursor registrou APROVA_0033: SIM; Grok registrou APROVA_0033: NAO, resolvido pelo W2 fail-closed de G-SCRATCH."
  - "🟢 W2 RATIFICADO E SELADO — Grok+Antigravity registraram APROVA_0034: SIM; cinco bypasses fechados: G-KNOW token-match/anti-ponteiro-morto, G-FRONTDOOR bytes/contagem/existencia, G-EXC ultimo-paragrafo, G-SCRATCH fail-closed, comentario G-REG."
  - "🟢 COMMIT-POLLUTION REMOVIDA — cfe9c33 (fixture --no-verify de auditor) foi removido por reset humano para 635e01b antes desta selagem."
  - "🟢 KNOWLEDGE 0024/0025 INDEXADAS — zona livre exige aprovacao humana explicita; auditor cruzado e read-only e nao usa --no-verify na branch de trabalho."
  - "🟡 PLANO MVP — arvores registry-centric leve; sequencia hardening->deny->freeze; W3 = deny-by-default (G-ZONA-LIVRE) sobre base endurecida."
  - "🟢 GATE DO BOUNDARY ARMADO — branch protection biometrico ativo na main; futura chave G-HRB continua pendente."
  - "🟢 W2 SELADO — hardening dos guards concluido e ratificado: G-KNOW-INDEX token inteiro + anti-ponteiro-morto; G-FRONTDOOR teto bytes + read-list robusta + existencia; G-EXC trailers no ultimo paragrafo; G-SCRATCH fail-closed sem active-version; comentario G-REG corrigido."
  - "🟢 TESTES W2 VERDES — run-guard-tests fechou 175/175; adversarial-battery bloqueou B1-B32, incluindo B29, B30, B31 e B32."
  - "🟢 P-CAND-04 SELADO — area temporaria /scratch/ foi ratificada e selada junto com W2 na grande selagem 0035."
  - "🟡 PRÓXIMA AÇÃO — W3 deny-by-default (G-ZONA-LIVRE) sobre base endurecida."
  - "🟢 P-CAND-04 RATIFICADO — area temporaria /scratch/ ativa: .gitignore ignora /scratch/ e versiona somente scratch/README.md como contrato de uso."
  - "🟢 G-SCRATCH ATIVOS — guards/assert-scratch-lock.sh, guards/assert-scratch-symlink.sh e guards/assert-scratch-ignore.sh entraram bloqueantes no runner."
  - "🟢 TESTES P-CAND-04 VERDES — run-guard-tests fechou 165/165; adversarial-battery bloqueou B1-B28, incluindo B26 arquivo em scratch/, B27 symlink em scratch/ e B28 .gitignore sem /scratch/."
  - "🟡 PRÓXIMA AÇÃO HISTÓRICA PAGA — cross-audit P-CAND-04 concluido; agora W3 deny-by-default da zona livre."
  - "🟢 S3.2 SELADA — porta da frente ativa: core/role-cards.md + G-FRONTDOOR; Cursor registrou APROVA_0031: SIM com confiança 90/100 e Gemini/Antigravity registrou APROVA_0031: SIM com confiança 100/100."
  - "🟢 DÍVIDA HARDENING PAGA — W2 fechou G-KNOW-INDEX substring/ponteiro-morto, G-FRONTDOOR bytes/contagem/existencia, G-EXC ultimo-paragrafo, G-SCRATCH fail-closed e comentario G-REG."
  - "🟢 P-CAND-04 EXECUTADA — a antiga proxima acao de implementar area temporaria foi entregue nesta onda."
  - "🟢 S3.2 ENTREGUE — porta da frente ativa em core/role-cards.md: read-list de 6 itens + tres cartoes curtos por papel, apontando para specs sem duplicar."
  - "🟢 G-FRONTDOOR ATIVO — guards/assert-frontdoor.sh entrou bloqueante no runner; falha fechado se core/role-cards.md ausente/ilegivel, >140 linhas ou read-list >6."
  - "🟢 TESTES S3.2 VERDES — run-guard-tests fechou 160/160; adversarial-battery bloqueou B1-B25, incluindo B25 role-cards inflado/read-list estourada."
  - "🟢 S3.1 SELADA — G-KNOW-INDEX segue ativo no runner; knowledge 0023 foi indexada e selada; pareceres Gemini/Cursor, despacho e brainstorm foram versionados."
  - "🟢 INDEX VIVO DA KNOWLEDGE — qualquer .hbn/knowledge/*.md, exceto INDEX.md, precisa aparecer citado pelo basename no INDEX; ausencia/ilegibilidade do INDEX falha fechado; estado atual: 11 entradas."
  - "🟢 DÍVIDA G-KNOW-INDEX PAGA — W2 trocou substring por token inteiro e bloqueou ponteiro-morto INDEX->arquivo."
  - "🟡 DECISÃO AREA TEMPORARIA — P-CAND-04 convergiu no cross-audit: tmp do ambiente primeiro; scratch/ no repo so em onda propria com gitignore + guards anti-stage/symlink/ignore."
  - "🟡 NOTA DE CONTINUIDADE — proximo orquestrador deve ler STATE + handoff + core/role-cards.md e seguir a read-list da porta da frente."
  - "🟢 S2 + FAXINA 0027 FECHADOS — S2 foi ratificada e selada; faxina 0027 foi ratificada por Cursor e Gemini/Antigravity com APROVA_0027: SIM e selada na micro-onda 0028."
  - "🟢 S2 RATIFICADA E SELADA — Gemini registrou APROVA_S2: SIM com confiança 100/100; Cursor registrou APROVA_S2: SIM com confiança 90/100; pareceres e despachos foram depositados nesta micro-onda."
  - "🟢 FAXINA 0027 RATIFICADA E SELADA — pareceres Cursor/Gemini depositados, tres despachos do orquestrador selados, brainstorm versionado e fixes lixo-zero aplicados sem mudar logica de guard."
  - "🟢 DÍVIDA H RESOLVIDA — G-EXC em CI agora le mensagem bruta (%B), igual ao commit-msg local; run-guard-tests fechou 154/154 e adversarial-battery bloqueou B1-B23."
  - "🟢 D2 RESOLVIDA — scratch de guards/tests coberto por .gitignore (cr-*, adv-cr*, tmp-pass.*, wt-main.*) e diretorios remanescentes removidos best-effort."
  - "🟡 DÍVIDA RASTREADA PARA HARDENING — G-EXC ainda aceita prosa iniciada por 'HBN-...:' no corpo porque valida %B inteiro; destino: restringir a busca ao ultimo paragrafo/trailer block em onda propria."
  - "🟡 CONVENÇÃO RASTREADA — todo handoff de onda deve estar no files_allowed do readback; o lapso do handoff 0027 fica registrado e a 0028 incluiu seu handoff no escopo."
  - "🟢 B19 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B19: SIM e CLASSE FECHADA: SIM; classe symlink/meta-path FECHADA apos B17+B18+B19; hardlink = non-issue (git 100644); proxima onda: S2 (dispatch schema)."
  - "🟢 B18 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B18: SIM; symlink staged sob .hbn/** segue bloqueado por modo git 120000 antes da dispensa de meta-path; run-guard-tests 141/141 e adversarial-battery B1-B18 verdes."
  - "🟢 B17 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B17: SIM; meta-paths em guards/assert-scope-lock.sh auto-permitem somente .json/.md com basename ADR-025, hearback do readback ativo ou nome-endereco conhecido."
  - "🟢 S1 RATIFICADO E SELADO — assert-scope-lock endurecido contra auto-emenda de files_allowed; cross-audit Gemini+Cursor registrou APROVA_S1: SIM."
  - "🟢 REESTRUTURAÇÃO M-A+S0 SELADA — linha limpa proposta/reestruturacao-m-a-s0 @ 5a0587d; tree 61fa290e ancorada por tag."
  - "🟢 CROSS-AUDIT SIM — Cursor e Gemini 3.5 registraram APROVA_REESTRUTURACAO: SIM para o Modelo B."
  - "🟢 EXCEÇÃO F-01 ENCERRADA NESTA SELAGEM — C5 devolve o bastao ao orquestrador e nao deixa implementador ativo igual ao agente do readback."
  - "🔴 PONTE VETADA — 0034 Codex e 0035 Antigravity retornaram VETO_ADOCAO: SIM; corrigir bloqueadores antes de descongelar."
  - "🔴 ATIVAÇÃO DA EXÚVIA BLOQUEADA — Fitness Gate pendente: baseline funcional + Ponte verde + confronto incumbente×desafiante."
  - "🟡 D-ORQ-WRITE NÃO HABILITADA — doutrina no replay; escrita do orquestrador e G-ACTOR-WRITE-MATRIX seguem para rito futuro."
  - "🟡 G-HRB assinatura PENDENTE DE CHAVE — Maurício gera/registra .hbn/operators/<nome>.pub para ativar ssh-keygen -Y verify."
  - "🟡 F-02 (0035 UTC×REGISTRY) NÃO corrigido — formato da linha superseded_by segue decisão humana."
  - "🟢 branch protection no GitHub: ruleset Active na main (require PR, restrict deletions, block force pushes); passkey Touch ID no boundary."
  - "🟡 backlog preservado — bump 0.3.1, hearback 0002, inbox/credenciamento e versionamento de readbacks ficam para ondas futuras."
readback_ativo: ".hbn/readbacks/0045-curadoria-p0-docs.json"
handoff_mais_recente: ".hbn/messages/20260617-113500-codex-handoff-curadoria-p0.md"
ancora_rollback: "evidencia/reestruturacao-m-a-s0-tree-equivalent -> 5a0587d (tree 61fa290e; rollback da selagem ao replay limpo)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "Readback 0045 entregue operacionalmente; aguardando cross-audit ≠-familia + selagem; bastao retorna ao orquestrador."
ultima_atualizacao: "2026-06-17T11:35:00-03:00"
atualizado_por: codex-implementador-handoff-curadoria-p0
atribuicao:
  chapeu_atual: orquestrador
  implementador: codex
  auditores: []
  gravada_em: "2026-06-17T11:35:00-03:00"
  hearback_ref: "Mauricio 2026-06-17: escolheu Curadoria P0 (docs) primeiro e aprovou aplicar AGENTS.md corrigido + glossario + dedup da matriz"
---

Nota Curadoria P0 docs / readback 0045: entregue em
2026-06-17T11:35:00-03:00. A onda corrigiu `AGENTS.md` com o bloco aprovado
verbatim, criou `docs/GLOSSARY.md` como glossario canonico e reduziu
`docs/MATURITY-MATRIX.md` a stub de redirect para a fonte unica
`methodology/MATURITY-MATRIX.md`. REGISTRY recebeu linhas para readback,
STATE, glossario, redirect da matriz e handoff. Evidencia mecanica local:
`.venv/bin/pytest -q` fechou `213 passed in 0.75s`; `bash
guards/tests/adversarial-battery.sh` fechou `BATERIA VERDE`; links markdown
de `AGENTS.md` fecharam `checked=20, missing=NONE`; `main` permaneceu em
`4db692876381a0d7909985c8500d999f2e677b04`. Escopo preservado: `main`,
`guards/**`, `schemas/**`, `src/**`, `core/**`, `methodology/**`, outros
`docs/**` e `docs/brainstorm/**` nao foram alterados. Proxima acao:
cross-audit ≠-familia + selagem da Curadoria P0; depois R2 arvores
registry-centric.

Nota Curadoria P0 docs / readback 0045: aberta em
2026-06-17T11:30:00-03:00. A onda corrige a porta de entrada e docs canonicos:
substituir `AGENTS.md` pelo texto aprovado da proposta, criar
`docs/GLOSSARY.md`, reduzir `docs/MATURITY-MATRIX.md` a redirect e registrar
o necessario no REGISTRY. Excecao G-EXC segue proposta e visivel porque
implementador=codex coincide com o agente do readback 0045 autorizado por
Mauricio. Fora de escopo preservado: `main`, `guards/**`, `schemas/**`,
`src/**`, `core/**`, `methodology/**`, outros `docs/**` e
`docs/brainstorm/**`. Proxima acao: C2 aplicar `AGENTS.md` verbatim da
proposta; depois C3 glossario, C4 stub da matriz, C5 STATE/handoff.

Nota selagem Esteira / readback 0044: concluida em
2026-06-17T11:15:00-03:00. A Esteira de Pre-Transicao fica SELADA e vigente:
`core/esteira-pre-transicao.md` esta `status: accepted`, sem linha
`arvore:`, e o corpo da spec foi preservado. Os dois pareceres cross-audit
ficaram tracked e registrados no REGISTRY: antigravity/Google
`APROVA_0043: SIM` conf 100 e grok-build-0.1/xAI `APROVA_0043: SIM` conf 88.
Evidencia mecanica local: `.venv/bin/pytest -q` fechou `213 passed in 0.76s`;
`bash guards/tests/adversarial-battery.sh` fechou `BATERIA VERDE`; `main`
permaneceu em `4db692876381a0d7909985c8500d999f2e677b04`. Escopo preservado:
`main`, `guards/**`, `schemas/**`, `src/**`, outras specs de `core/` e
`docs/brainstorm/**` nao foram alterados. Proxima acao: curar dossie
pre-transicao + R2 arvores registry-centric.

Nota selagem Esteira / readback 0044: aberta em
2026-06-17T11:00:00-03:00. A onda sela a promocao da Esteira de
Pre-Transicao apos duplo APROVA_0043 nao-OpenAI: antigravity/Google registrou
`APROVA_0043: SIM` com confianca 100 e grok-build-0.1/xAI registrou
`APROVA_0043: SIM` com confianca 88 e marginal sobre `arvore: intermediaria`.
Escopo restrito: readback 0044, `core/esteira-pre-transicao.md` apenas para
os 2 ajustes autorizados, dois pareceres em `.hbn/results/`, REGISTRY, STATE
e handoff. Excecao G-EXC segue proposta e visivel porque implementador=codex
coincide com o agente do readback 0044 autorizado por Mauricio. Proxima acao:
C2 ratificar a spec (`status: accepted` e remocao de `arvore:`), C3 tornar os
pareceres tracked, C4 encerrar STATE/handoff e devolver o bastao ao
orquestrador.

Nota promocao Esteira de Pre-Transicao / readback 0043: concluida
operacionalmente em 2026-06-17T10:35:00-03:00. A spec
`core/esteira-pre-transicao.md` foi criada em status `proposed` com o conteudo
aprovado por Maurício, registrada no REGISTRY como `spec-core`, e nao altera
freeze-gate, schemas, guards, src, outras specs de core ou
`docs/brainstorm/**`. Evidencia local: `.venv/bin/pytest -q` fechou
`213 passed in 0.77s`; `bash guards/tests/adversarial-battery.sh` fechou
`BATERIA VERDE`. A proxima acao obrigatoria e cross-audit ≠-familia da spec;
so depois vem selagem 0043, curadoria do dossie de pre-transicao e R2.

Nota Esteira de Pre-Transicao / readback 0043: aberta em
2026-06-17T10:30:00-03:00. A onda promove a proposta de esteira para
`core/esteira-pre-transicao.md` como `spec-core` em status `proposed`, sem
alterar freeze-gate, schema, guards, src, outras specs de core ou
`docs/brainstorm/**`. O escopo autorizado fica restrito a readback 0043,
`core/esteira-pre-transicao.md`, REGISTRY, STATE e handoff. Excecao G-EXC segue
proposta e visivel porque implementador=codex coincide com o agente do
readback 0043 autorizado por Maurício. Proxima acao: criar a spec verbatim e
registrar no REGISTRY; depois atualizar STATE/handoff e devolver o bastao para
cross-audit ≠-familia.

Nota selagem R1-fix-2 / readback 0042: concluida em
2026-06-17T10:05:00-03:00. A micro-onda selou R1-fix-2 (readback 0041) apos
duplo APROVA_0041 nao-OpenAI: Grok/xAI registrou `APROVA_0041: SIM` com
confiança 95 e Antigravity/Google registrou `APROVA_0041: SIM` com confiança
100, ambos com prova engine-real ANTES/DEPOIS. Os dois pareceres foram
versionados em `.hbn/results/` e registrados no REGISTRY. Evidencia mecanica
local desta selagem: `.venv/bin/pytest -q` fechou `213 passed in 0.78s`;
`bash guards/tests/adversarial-battery.sh` fechou `BATERIA VERDE`; `main`
permaneceu em `4db692876381a0d7909985c8500d999f2e677b04`. Escopo preservado:
`main`, `src/**`, `guards/**`, `core/**`, `schemas/**` e `docs/brainstorm/**`
nao foram alterados. Excecao G-EXC segue proposta e visivel porque
implementador=codex coincide com o agente do readback 0042 autorizado por
Maurício. Proxima acao: promover Esteira de Pre-Transicao para core, curar o
dossie de pre-transicao e seguir R2 arvores registry-centric.

Nota R1-fix-2 / readback 0041: entregue em 2026-06-17. A onda corrigiu o
bloqueador provado apos a selagem R1-fix: `load_state_document` agora mantem
`executions`/`results` deduplicados por `execution_id`, mas deduplica
`decisions` por `(execution_id, category)` quando ha categoria e cai para
conteudo deterministico quando necessario, preservando registros distintos de
`context_history`. O teste engine-real cobre as tres decisions gravadas pelo
engine para uma execucao (`activation`, `validation`, `consent`) e falharia no
codigo pre-C2, que retornava apenas `activation`. Evidencia local:
`.venv/bin/pytest -q` fechou `213 passed in 0.74s`; `bash guards/tests/adversarial-battery.sh`
fechou `BATERIA VERDE`. Excecao G-EXC segue proposta e visivel porque
implementador=codex coincide com o agente do readback 0041 autorizado por
Maurício. Proxima acao: cross-audit nao-OpenAI + hearback + selagem; depois R2.

Nota selagem R1+R1-fix / readback 0040: concluida em 2026-06-17. A onda
selou os cinco pareceres de cross-audit R1/R1-fix em `.hbn/results/`,
registrou cada parecer no REGISTRY, sincronizou a contagem real da suite para
212/212 em `AGENTS.md`, `README.md` e `methodology/MATURITY-MATRIX.md`, e
devolve o bastao ao orquestrador. Evidencia mecanica local: `.venv/bin/pytest
-q` fechou `212 passed in 0.75s`; `bash guards/tests/adversarial-battery.sh`
fechou `BATERIA VERDE`; `main` permaneceu em
`4db692876381a0d7909985c8500d999f2e677b04`. Proxima acao: R2 arvores
registry-centric (G-REG M + anti-mislabel).

Nota R1-fix / readback 0039: entregue em 2026-06-17. A onda corrigiu o
bloqueador achado no cross-audit R1: `load_state_document` agora deduplica
`decisions` e `context_history` pela mesma identidade estavel de `executions`
e `results` (`traceability.execution_id`/`execution_id` quando presente; caso
contrario conteudo JSON deterministico), preservando a ordem canonico ->
`.usehbn/` -> `state/` e a regra canonico-vence. `tests/test_state_dual_read.py`
passou a usar fixtures nao-vazias e cobre item sem id por dedup de conteudo.
Evidencia mecanica: `.venv/bin/pytest -q` fechou 212/212; `bash
guards/tests/adversarial-battery.sh` bloqueou B1-B33. Proxima acao:
re-cross-audit R1+R1-fix nao-OpenAI, depois selagem R1.

Nota R1 / readback 0038: entregue em 2026-06-16. A onda fechou runtime e
honestidade pre-freeze em seis commits: readback 0038 depositado, golden tests
dos subcomandos, exit codes honestos, unificacao de estado em `.hbn/`, docs e
matriz de maturidade alinhadas, e este STATE + handoff final. A suite pytest
fechou 211/211; o guard runner ficou verde antes de cada commit R1. Escopo
preservado: `main`, `core/**`, `guards/**`, `schemas/**` e `docs/brainstorm/**`
nao foram alterados; `docs/brainstorm/**` foi apenas lido como contexto.
Proxima acao: cross-audit R1 por familia nao-OpenAI; depois R2 arvores
registry-centric (G-REG M + anti-mislabel).

Nota selagem W3 / readback 0037: concluida em 2026-06-16. W3 (readback
0036) fica RATIFICADO e SELADO: Grok, Antigravity 100 e Cursor 92 registraram
`APROVA_0036: SIM` nos quatro pareceres depositados. `G-ZONA-LIVRE` segue
ativo no runner e o deny-by-default da zona livre fica selado por construcao.
A branch protection biometrica da main esta armada (ruleset Active: require PR,
restrict deletions, block force pushes; passkey Touch ID). O cartao de entrada
universal foi depositado como candidato a `core/cartao-entrada.md`. Divida
rastreada: o marcador `zona_livre_curada` ainda e auto-declarado; hardening
futuro deve banir `docs/brainstorm/**` de todo `files_allowed`, exceto onda de
curadoria dedicada. Proxima acao: arvores registry-centric (coluna `arvore` no
REGISTRY), depois freeze + tag `v1-estavel`.

Nota W3 / readback 0036: entregue em 2026-06-16. `guards/assert-zona-livre.sh`
entrou bloqueante no runner como G-ZONA-LIVRE: qualquer path staged sob
`docs/brainstorm/**` exige que o readback ativo apontado por
`.hbn/relay/STATE.md` contenha `"zona_livre_curada": true` e
`"zona_livre_nota"` com texto nao-vazio. O guard falha fechado se STATE,
readback ativo ou JSON estiver ausente/ilegivel. `run-guard-tests` fechou
178/178, cobrindo caso positivo, caso sem marcador e readback ilegivel;
`adversarial-battery` bloqueou B1-B33, incluindo B33 docs/brainstorm sem
curadoria. Proxima acao: cross-audit W3; depois arvores registry-centric.

Nota grande selagem 0035: concluida em 2026-06-16. P-CAND-04 (readback 0033)
fica RATIFICADO e SELADO: Cursor registrou `APROVA_0033: SIM`; o `NAO` do
Grok foi resolvido pelo hardening W2, que tornou G-SCRATCH fail-closed quando
`active-version` nao resolve. W2 (readback 0034) fica RATIFICADO e SELADO por
Grok+Antigravity com `APROVA_0034: SIM`, fechando cinco bypasses: G-KNOW
token-match/anti-ponteiro-morto, G-FRONTDOOR bytes/contagem/existencia,
G-EXC ultimo-paragrafo, G-SCRATCH fail-closed e comentario G-REG. A pollution
`cfe9c33` (fixture `--no-verify` de auditor) foi removida por reset humano para
`635e01b`. As licoes 0024 e 0025 foram indexadas. Plano MVP preservado:
arvores registry-centric leve; sequencia hardening->deny->freeze; proxima acao
W3 deny-by-default (G-ZONA-LIVRE) sobre base endurecida; gates humanos =
branch protection biometrico + futura chave G-HRB.

Nota W2 / readback 0034: entregue em 2026-06-16. A onda fechou os bypasses
apontados nas auditorias: B29 (G-KNOW-INDEX substring e ponteiro morto), B30
(G-FRONTDOOR linha unica densa e path inexistente), B31 (G-EXC prosa no corpo
sem trailers finais) e B32 (G-SCRATCH-LOCK sem active-version). `run-guard-tests`
fechou 175/175 e `adversarial-battery` bloqueou B1-B32. O comentario stale do
G-REG foi corrigido sem mudanca de logica. P-CAND-04 sera selado junto na
proxima selagem; o bastao volta ao orquestrador para cross-audit W2.

Nota M-A: esta onda construiu a máquina da muda sem disparar a muda. O
ponteiro ativo permanece em `.`; hooks e guards falham fechado quando o
ponteiro está ausente, conflitado ou aponta para versão inexistente. A tag
`hbn-exuvia/protocol-0.3.x` e qualquer `git mv` ficam para M-C, depois do
Fitness Gate. O script de rollback foi testado apenas em dry-run.

Nota S0: esta onda corrigiu somente itens aditivos/corretivos pós-M-A. O bug D3
do rollback foi corrigido com teste de `--apply`; perfis `grok` e `cursor`
foram adicionados como `proposed`; o INDEX foi marcado como superseded pelo
STATE; e as fixtures untracked indicadas foram removidas. Nenhuma lógica de
guard foi alterada.

Nota depósito S0: Gemini (Google) aprovou S0 com confiança 100/100; Cursor
aprovou S0 com duas marginais não-bloqueadoras; opus-4-8 consolidou como OK,
ratificável e sem bloqueador. O marginal `cursor.json` model_id vs runtime fica
rastreado para a promoção futura do perfil a `accepted`.

Nota D-ORQ-WRITE: a cláusula 10 de `core/orchestrator-profile-spec.md` está na
linha limpa ratificada pela reestruturação M-A+S0, mas esta selagem não habilita
escrita operacional do orquestrador. O guard G-ACTOR-WRITE-MATRIX fica reservado
para rito futuro.

Nota reestruturação M-A+S0: o Modelo B foi ratificado por Maurício em
2026-06-15 após cross-audit Cursor+Gemini com `APROVA_REESTRUTURACAO: SIM`.
A linha limpa é `proposta/reestruturacao-m-a-s0` no tip `5a0587d`; a prova
mecânica fica congelada pela tag `evidencia/reestruturacao-m-a-s0-tree-equivalent`
com tree `61fa290e83b075983b9c6961a06c6e229cad1fd4`. Esta selagem adiciona
governança nova por cima do replay e não habilita escrita operacional do
orquestrador.

Nota selagem S1: Gemini (`.hbn/results/20260615-112714-gemini-3-5-cross-ia-s1-scope-lock.md`)
e Cursor (`.hbn/results/20260615-113115-cursor-cross-ia-s1-scope-lock.md`)
registraram `APROVA_S1: SIM`. B16 (auto-emenda de `scope.files_allowed` + uso
no mesmo commit) permanece bloqueado pela bateria S1. B17, a brecha
preexistente de meta-paths sempre permitidos em `guards/assert-scope-lock.sh:207-214`,
foi tratado e selado em 2026-06-15; B18 segue como proxima onda antes do S2.

Nota B17: a brecha preexistente de smuggling por meta-path foi implementada em
2026-06-15 com recorte tipo+nome. `guards/assert-scope-lock.sh` agora aceita
automaticamente apenas `.json`/`.md` de evento ADR-025 em `.hbn/messages/` e
`.hbn/bypasses/`, hearback `NNNN-*.{json,md}` do readback ativo e
`.hbn/relay/INDEX.md`; scripts, binarios e nomes arbitrarios nesses caminhos
precisam estar em `scope.files_allowed`. `run-guard-tests` passou com 140/140 e
`adversarial-battery` bloqueou B1-B17; cross-audit independente aprovado em
2026-06-15.

Nota selagem B17: Gemini
(`.hbn/results/20260615-213855-gemini-3-5-cross-ia-b17-meta-path.md`) e Cursor
(`.hbn/results/20260615-213850-cursor-cross-ia-b17-meta-path.md`) registraram
`APROVA_B17: SIM`. Cursor documentou B18: symlink com basename ADR-025 em
`.hbn/messages/20260615-120000-codex-handoff-x.md` apontando para
`../../src/payload.sh` passa porque `is_meta_auto_allowed` valida somente o
path string (`guards/assert-scope-lock.sh:236-249`). Decisão humana:
B18 e a próxima onda antes do S2.

Nota B18: implementado em 2026-06-15. `guards/assert-scope-lock.sh` agora
recusa qualquer entrada staged sob `.hbn/**` com modo git `120000`, antes de
avaliar `scope.files_allowed` ou meta-path ADR-025. A mensagem de bloqueio e
`symlink não permitido em path de coordenação governado: <path>`. Arquivos
regulares de handoff `.md`, hearback `NNNN-*.json` e nota de bypass `.md`
continuam passando. Cross-audit independente aprovado na selagem B18.

Nota selagem B18: Gemini
(`.hbn/results/20260615-223941-gemini-3-5-cross-ia-b18-symlink.md`) e Cursor
(`.hbn/results/20260615-224921-cursor-cross-ia-b18-symlink.md`) registraram
`APROVA_B18: SIM`. B19a fica aberto porque `is_governed_hbn_symlink` limita a
checagem a `.hbn/*` em `guards/assert-scope-lock.sh:256`; a próxima onda deve
generalizar o bloqueio de symlink para todo path governado. hardlink =
non-issue (git 100644): o Git grava hardlink como arquivo regular, sem
semantica de link no objeto versionado.

Nota B19: implementado em 2026-06-15. `guards/assert-scope-lock.sh` agora
recusa qualquer entrada staged avaliada pelo guard com modo git `120000`,
resolvendo o path de versao ativa para o path real do repo antes de consultar
`git ls-files --stage` localmente ou `git ls-tree HEAD` em CI. B18 segue coberto
e o bloqueio agora inclui paths governados como `.hbn/`, `guards/`, `core/` e
`src/`. `run-guard-tests` passou com 145/145; `adversarial-battery` bloqueou
B1-B19. Cross-audit depositado na selagem B19; ver nota seguinte.

Nota selagem B19: Gemini
(`.hbn/results/20260615-234638-gemini-3-5-cross-ia-b19-symlink-geral.md`) e
Cursor (`.hbn/results/20260615-234641-cursor-cross-ia-b19-symlink-geral.md`)
registraram `APROVA_B19: SIM` e `CLASSE FECHADA: SIM`. A classe
symlink/meta-path fica FECHADA apos B17+B18+B19. Hardlink permanece
non-issue/won't-fix: o Git materializa como arquivo regular `100644`, sem
semantica de link no objeto versionado. Proxima onda do roadmap: S2 (dispatch
schema).

Nota S2: implementada em 2026-06-16. O despacho passa a ser artefato
auto-declarante em `.hbn/dispatch/NNNN-*.md`, validado por
`schemas/dispatch.schema.json` e pela spec `core/dispatch-spec.md`.
`guards/validate-dispatch.sh` (G-DSP-FMT) bloqueia forma inválida, token_fp mal
formado e corpo colável com linha iniciada por `#`; `guards/assert-dispatch-integrity.sh`
(G-DSP-INT) bloqueia readback inexistente/não-ativo, token_fp divergente do
STATE e autorização humana vazia. Ambos entraram no runner sem rampa.
`guards/tests/run-guard-tests.sh` fechou 151/151 e
`guards/tests/adversarial-battery.sh` bloqueou B1-B22. O primeiro dispatch,
`.hbn/dispatch/0025-s2-dispatch-auto-declarante.md`, foi validado como dogfood.
Próximo passo: cross-audit Gemini+Cursor; selagem de S2 é micro-onda própria
com readback 0026, não feita aqui.

Nota selagem S2: concluida em 2026-06-16. Gemini
(`.hbn/results/20260616-010326-gemini-3-5-cross-ia-s2-dispatch.md`) registrou
`APROVA_S2: SIM` com confiança 100/100; Cursor
(`.hbn/results/20260616-010221-cursor-cross-ia-s2-dispatch.md`) registrou
`APROVA_S2: SIM` com confiança 90/100. Os despachos do orquestrador de abertura
S2 e cross-audit S2 foram depositados no historico. O marginal H (trailers
historicos nao-contiguos para parser nativo) e os marginais EXTRA do Cursor
(dispatch-like fora de `.hbn/dispatch/` e relacao `dispatch_id` x
`readback_id`) ficaram documentados para triagem na faxina 0027, junto com os
untracked antigos e os criterios/triagem de exuvia; esta selagem nao alterou
logica de guard.

Nota faxina 0027: implementada em 2026-06-16. O G-EXC passou a validar trailers
em CI sobre a mensagem bruta do commit (`%B`), igual ao modo commit-msg, cobrindo
o falso-positivo do parser nativo `%(trailers)`. `run-guard-tests` fechou
154/154 e `adversarial-battery` bloqueou B1-B23. Os seis artefatos historicos
antigos foram selados, com carimbos de deposito nos handoffs legados para
compatibilidade com G-RLT/G-PTR. `.gitignore` passou a cobrir scratch das suites
e os diretorios remanescentes foram removidos best-effort. A triagem e o
documento-fonte de criterios de exuvia foram selados, e
`core/exuvia-fitness-criteria.md` virou a referencia normativa. Os
endurecimentos EXTRA-1/EXTRA-2 do Cursor seguem fora desta onda e devem ser
tratados em S3.

Nota selagem da faxina 0027 / readback 0028: concluida em 2026-06-16. Cursor
(`.hbn/results/20260616-023446-cursor-cross-ia-faxina-0027.md`) e Gemini
(`.hbn/results/20260616-024241-gemini-3-5-cross-ia-faxina-0027.md`) registraram
`APROVA_0027: SIM`. A selagem depositou os pareceres, tres despachos do
orquestrador e dois docs de brainstorm como zona-livre versionada. O lixo-zero
sem mudanca de logica ficou aplicado em `.gitignore` (`adv-cr*`) e no
front-matter do doc-fonte de criterios (`status: superseded` +
`superseded_by: core/exuvia-fitness-criteria.md`). Ficam rastreadas para S3 /
hardening: (1) prosa-trailer do G-EXC, pois `%B` inteiro ainda aceita linhas de
corpo iniciadas por `HBN-...:`; (2) convencao de incluir o handoff da onda no
`files_allowed` do readback.

Nota S3.1 / readback 0029: entregue em 2026-06-16. O INDEX da knowledge deixou
de ser amostra estatica e passou a listar as 8 entradas atuais:
`0001-comandos-atomicos-copiaveis.md`,
`0002-entrega-operacional-minimalista.md`,
`0003-git-sandbox-sem-lock.md`, `0019-severidades-veto.md`,
`0022-firewall-workflow-fast-track.md`, `distribution-model.md`,
`relay-protocol.md` e `runtime-command-model.md`. O novo G-KNOW-INDEX entrou
bloqueante em `guards/hbn-guards-runner.sh`, falhando fechado se o INDEX estiver
ausente/ilegivel ou se qualquer `.hbn/knowledge/*.md` nao for citado pelo
basename. `run-guard-tests` fechou 156/156 e `adversarial-battery` bloqueou
B1-B24, incluindo B24 (knowledge nova ausente do INDEX).

Nota selagem S3.1 / readback 0030: concluida em 2026-06-16. Gemini/Antigravity
(`.hbn/results/20260616-121025-gemini-3-5-cross-ia-s3-1.md`) e Cursor
(`.hbn/results/20260616-124526-cursor-cross-ia-s3-1.md`) registraram
`APROVA_0029: SIM`. A selagem depositou os dois pareceres, o despacho de
cross-audit do orquestrador, a knowledge 0023, o INDEX atualizado, tres docs de
brainstorm e este handoff, sem alterar logica de guard. Dividas rastreadas para
hardening: (1) G-KNOW-INDEX usa `grep -Fq "$base"` e pode aceitar substring em
`guards/assert-knowledge-index.sh:63`; (2) o INDEX pode citar arquivo inexistente
sem o guard reclamar (ponteiro-morto). Decisao de design rastreada: P-CAND-04
convergiu para tmp do ambiente primeiro; `/scratch/` no repo, se adotado, deve
ter onda propria com gitignore + guards anti-stage/symlink/ignore. Continuidade:
o proximo orquestrador deve ler STATE + handoff + `.hbn/knowledge/0001`,
`.hbn/knowledge/0002` e `.hbn/knowledge/0023` ao assumir o bastao.

Nota selagem S3.2 / readback 0032: concluida em 2026-06-16. Cursor
(`.hbn/results/20260616-132743-cursor-cross-ia-s3-2.md`) registrou
`APROVA_0031: SIM` com confiança 90/100; Gemini/Antigravity
(`.hbn/results/20260616-132813-gemini-3-5-cross-ia-s3-2.md`) registrou
`APROVA_0031: SIM` com confiança 100/100. A selagem depositou os dois
pareceres e versionou os tres docs de brainstorm de Fronteira
(`docs/brainstorm/exuvia-evolucao-conceitual.md`,
`docs/brainstorm/PROMPTS-PF-ARVORES-AGORA-DRAFT.md` e
`docs/brainstorm/PROPOSTA-arvores-agora.md`), sem alterar logica de guard.
Divida rastreada agrupada para hardening de guards: G-KNOW-INDEX ainda aceita
substring no `grep -Fq` e ponteiro morto no INDEX; G-FRONTDOOR tem teto por
linhas, nao por bytes, conta itens por marcador/espaco conhecido e nao verifica
existencia dos paths da read-list. Proxima acao: implementar area temporaria
P-CAND-04 (`/scratch/` + guards G-SCRATCH-LOCK/SYMLINK/IGNORE).
