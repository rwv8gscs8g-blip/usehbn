# Auditoria cruzada — batch1-fronteira — por gpt-5

SOU: OpenAI · GPT-5 · apelido: gpt-5

Carimbo: `TZ=America/Sao_Paulo date '+%Y%m%d-%H%M%S'` -> `20260616-231038`.
Escopo lido: os cinco deliverables A1/A2/A3/B1/B2 e PF-ARVORES-AGORA se declaram Fronteira/nao-normativos em `docs/brainstorm/rodada-2026-06-16/INDEX.md:3-7`, `docs/brainstorm/rodada-2026-06-16/A1-front-door-verificavel.md:11-15`, `docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md:20-23`, `docs/brainstorm/rodada-2026-06-16/A3-compilador-md-enforcement.md:11-14`, `docs/brainstorm/rodada-2026-06-16/B1-code-review-cli-runtime.md:13-16`, `docs/brainstorm/rodada-2026-06-16/B2-honestidade-maturity-matrix.md:14-17` e `docs/brainstorm/PROPOSTA-arvores-agora.md:3-5`.

## 1 Veredito

BLOQUEAR promocao/freeze imediato. O pacote e util como Fronteira, mas ha quatro bloqueios antes de virar regra ou base de freeze: a fonte de verdade de `arvore` diverge entre front-matter e REGISTRY, `cli.py main()` retorna sucesso mesmo com erro logico, o estado ainda tem tres convencoes de diretorio, e `autoevolve` tem superficie publica sem linha na matriz canonica; evidencias em `docs/brainstorm/PROPOSTA-arvores-agora.md:9-10`, `.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:126-128`, `src/usehbn/cli.py:1732`, `src/usehbn/cli.py:1759`, `src/usehbn/cli.py:1771-1772`, `src/usehbn/utils/config.py:12-14`, `src/usehbn/cli.py:1564-1595` e comando `rg -n "autoevolve|microdelta|sanitiza" methodology/MATURITY-MATRIX.md` -> codigo 1, sem linhas.

## 2 BLOQUEADORES

B-01 — PF/A2: `arvore` ainda nao tem fonte unica. PF-ARVORES-AGORA propoe `campo arvore: no front-matter` em `docs/brainstorm/PROPOSTA-arvores-agora.md:9-10` e A2 diz que a verdade mora no front-matter em `docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md:93-107`; o estado posterior no disco diz que a decisao foi `registry-centric leve` com coluna `arvore` no REGISTRY, sem campo front-matter e sem G-ARVORE, em `.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:126-128`, `.hbn/messages/20260616-230100-codex-handoff-selagem-w3.md:31-32` e `.hbn/relay/STATE.md:14`. O REGISTRY atual ainda tem cabecalho sem coluna `arvore` em `REGISTRY.md:878-880`. Remediacao: decidir um unico dono (`REGISTRY` ou front-matter), reescrever PF/A2 para essa decisao, e adicionar teste/guard que impeça dupla declaracao divergente.

B-02 — A1: o ack proposto melhora rastro, mas nao prova leitura e permite ack emprestado se nao for ligado a posse da janela. A1 reconhece que o ack prova apenas que alguem escreveu o token em `docs/brainstorm/rodada-2026-06-16/A1-front-door-verificavel.md:225-231` e reconhece copia de ack de outra janela em `docs/brainstorm/rodada-2026-06-16/A1-front-door-verificavel.md:239-244`; o runner atual lista `assert-frontdoor.sh`, mas nao lista `assert-frontdoor-ack.sh`, em `guards/hbn-guards-runner.sh:49-72`. Remediacao: G-FDACK deve exigir `HBN-Token-FP`/baton coerente ou nonce de janela, e deve ter caso adversarial "ack copiado" antes de promocao.

B-03 — B1: o CLI retorna exit 0 em erro logico. `main()` cria `{"error": ...}` para subcomando connector desconhecido em `src/usehbn/cli.py:1732` e relay desconhecido em `src/usehbn/cli.py:1759`, serializa o resultado em `src/usehbn/cli.py:1771` e retorna `0` em `src/usehbn/cli.py:1772`. Remediacao: `main()` deve retornar codigo !=0 para erro de uso/violacao, com fronteira `try/except` e contrato JSON preservado.

B-04 — B1: tres diretorios de estado coexistem. `hbn init` cria `.hbn/readbacks` e `.hbn/results` em `src/usehbn/cli.py:1019-1021`; `default_state_dir` e `.usehbn` em `src/usehbn/utils/config.py:12` e escreve criando diretorio em `src/usehbn/utils/config.py:25-29`; `inspect_target` le `.usehbn/hbn-state.json` com fallback `state/hbn-state.json` em `src/usehbn/runtime.py:376-379`; `_find_pending_readbacks` precisou ler `.hbn/readbacks` e `.usehbn/readbacks` em `src/usehbn/cli.py:1564-1595`. Remediacao: escolher fonte canonica unica, manter leitura legacy read-only e migrar escritores/fixtures antes do freeze.

B-05 — B2: `autoevolve` excede a matriz canonica e parte do comportamento e scaffold/stub. O comando `rg -n "autoevolve|microdelta|sanitiza" methodology/MATURITY-MATRIX.md` saiu com codigo 1 e sem linhas; o CLI raiz delega `hbn autoevolve` em `src/usehbn/cli.py:1716-1718`; `worker.py` declara que o `apply` e no-op em `src/usehbn/autoevolve/worker.py:1-6`; `orchestrator.py` declara que as edicoes reais sao feitas pela IA fora do modulo em `src/usehbn/autoevolve/orchestrator.py:1-6`; o CLI de autoevolve expõe `status/audit/approve/rollback` em `src/usehbn/autoevolve/cli.py:97-115`; o gate de diff compara campos que nascem `0` em `src/usehbn/autoevolve/approval.py:22-29` e `src/usehbn/autoevolve/contract.py:42-51`. Remediacao: inserir autoevolve na MATURITY-MATRIX como `audit/report = Parcial` e `orchestrator/worker/approval = Scaffold`, ou implementar worker/diff/loop acionavel antes de qualquer texto publico com verbo operacional.

## 3 FORTES

F-01 — A3: o bloco `enforcement:` pode virar segunda fonte de verdade se for tratado como fidelidade semantica. A3 propoe `enforcement:` em front-matter em `docs/brainstorm/rodada-2026-06-16/A3-compilador-md-enforcement.md:65-71` e admite que `prosa_ref` nao verifica semanticamente a fidelidade em `docs/brainstorm/rodada-2026-06-16/A3-compilador-md-enforcement.md:250-255`. Incorporacao: G-PROV deve checar cobertura/ponteiros, mas a frase "impressao fiel" deve depender de auditoria humana + cross-family enquanto nao houver DSL semantica.

F-02 — A2: etiquetar guards pelo REGISTRY so e robusto se houver granularidade e schema para isso. O REGISTRY atual agrupa `guards/` como pacote em `REGISTRY.md:60` e tem linhas posteriores por alguns guards em `REGISTRY.md:95-107` e `REGISTRY.md:165-167`; A2 pergunta se a etiqueta de guard fica no REGISTRY ou comentario em `docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md:231-247` e prefere REGISTRY em `docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md:293-297`. Incorporacao: se a decisao for registry-centric, todo guard governado precisa de linha propria ou regra de heranca explicita do pacote `guards/`.

F-03 — B2: README/AGENTS estao majoritariamente honestos sobre Truth Barrier/Guardian, mas ainda ha escala paralela e ponteiro antigo. README diz que Truth Barrier e Guardian nao bloqueiam hoje em `README.md:47-48` e `README.md:543-555`; README usa "solid L4" fora dos cinco estados oficiais em `README.md:559` contra estados oficiais em `methodology/MATURITY-MATRIX.md:21-29`; AGENTS aponta `docs/MATURITY-MATRIX.md` como fonte de maturidade em `AGENTS.md:17`, mas esse arquivo se declara superseded e manda usar `methodology/MATURITY-MATRIX.md` em `docs/MATURITY-MATRIX.md:3-11` e `methodology/MATURITY-MATRIX.md:42-48`. Incorporacao: remover/definir L4 e corrigir o ponteiro de AGENTS.

F-04 — O site de autoevolve esta mais assertivo que README/AGENTS. `site/autoevolve.html` diz que o HBN executa ciclos de microdeltas em `site/autoevolve.html:60-62`, exibe sucesso percentual e testes verdes em `site/autoevolve.html:107-109`, e diz que o ciclo aplica microdeltas em `site/autoevolve.html:113-117`; isso colide com o no-op declarado em `src/usehbn/autoevolve/worker.py:1-6` e com a ausencia do componente na matriz por `rg -n "autoevolve|microdelta|sanitiza" methodology/MATURITY-MATRIX.md` -> codigo 1, sem linhas. Incorporacao: trocar por "vitrine/audit trail de microdeltas humano-no-loop" ate a matriz cobrir o componente.

## 4 MARGINAIS

M-01 — `docs/PHAGOCYTOSIS.md` ainda aponta maturidade para `docs/MATURITY-MATRIX.md` em `docs/PHAGOCYTOSIS.md:30-33`, enquanto o redirect diz que a fonte vigente e `methodology/MATURITY-MATRIX.md` em `docs/MATURITY-MATRIX.md:3-11`. Remediacao: ajustar ponteiro quando a proxima onda tocar fagocitose.

M-02 — A2 usa analogia fagocitose->arvores com honestidade em `docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md:145-151`; como `docs/PHAGOCYTOSIS.md:185-198` proibe saltar estagios e avancar sem PR/Hearback, o portao de arvores precisa manter PR/Hearback explicito em cada promocao.

M-03 — O comando `wc -l src/usehbn/cli.py src/usehbn/runtime.py src/usehbn/execution/engine.py src/usehbn/autoevolve/*.py` retornou `1776 src/usehbn/cli.py`, `441 src/usehbn/runtime.py` e `229 src/usehbn/execution/engine.py`; a refatoracao do god-object e forte, mas os bloqueadores de exit-code e estado devem vir antes da decomposicao ampla.

## 5 Convergencias

C-01 — A1 acerta que a "placa" da porta existe: `core/role-cards.md` contem read-list em `core/role-cards.md:3-12`, `guards/assert-frontdoor.sh` falha se o arquivo esta ausente/ilegivel ou grande demais em `guards/assert-frontdoor.sh:39-59`, e o runner chama `assert-frontdoor.sh` em `guards/hbn-guards-runner.sh:66`.

C-02 — A2 acerta que `temperatura` e eixo de vigencia: ADR-011 define `quente | frio | ultrapassado` em `methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md:88-105`; a matriz define cinco estados de maturidade publica em `methodology/MATURITY-MATRIX.md:21-29`; `roles-assignment-spec` proibe tabela paralela em `core/roles-assignment-spec.md:54-55`.

C-03 — A3 acerta o tripé dispatch como embrião do compilador: `core/dispatch-spec.md` aponta `schemas/dispatch.schema.json` em `core/dispatch-spec.md:29-31`; o schema se declara projecao do front matter em `schemas/dispatch.schema.json:1-4`; `assert-dispatch-integrity.sh` confere `readback_id`, `token_fp` e `human_authorization` em `guards/assert-dispatch-integrity.sh:168-199`.

C-04 — B1 esta confirmado nos pontos principais: `cli.py` tem 1776 linhas pelo comando `wc -l ...`; `main()` retorna `0` em `src/usehbn/cli.py:1771-1772`; os diretorios `.hbn`, `.usehbn` e `state` aparecem em `src/usehbn/cli.py:1019-1021`, `src/usehbn/utils/config.py:12-14` e `src/usehbn/runtime.py:376-379`.

C-05 — B2 esta confirmado nos pontos principais: Truth Barrier retorna `warn/clear` e warnings em `src/usehbn/protocol/truth_barrier.py:71-74`; Guardian retorna `warn/clear` em `src/usehbn/protocol/guardian.py:58-63`; o engine registra que os warnings nao sao enforced em `src/usehbn/execution/engine.py:81-88` e segue o fluxo em `src/usehbn/execution/engine.py:161-187`.

## 6 Divergencias

D-01 — Minha divergencia principal contra PF/A2 e priorizar "um dono agora" acima de "campo rapido agora". PF fala em front-matter em `docs/brainstorm/PROPOSTA-arvores-agora.md:9-10`; a decisao posterior fala em REGISTRY sem front-matter em `.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:126-128`; essa colisao deve ser resolvida antes de qualquer etiqueta.

D-02 — Minha divergencia contra A1 e que G-FDACK sem ligacao ao baton-token nao fecha a classe "ack emprestado". O proprio baton-token declara que o fingerprint sozinho rastreia token sem revelar em `guards/assert-baton-token.sh:14-20` e que o mecanismo nao prova identidade em `guards/assert-baton-token.sh:22-24`; A1 deve herdar essa honestidade e testar replay de ack.

D-03 — Minha divergencia contra A3 e que "compilador" no curto prazo deve ser chamado de "verificador de proveniencia e cobertura", nao gerador nem prova semantica. A3 diz que C1-C3 nao geram codigo em `docs/brainstorm/rodada-2026-06-16/A3-compilador-md-enforcement.md:201-215` e diz que gerar guard a partir de spec e longo prazo em `docs/brainstorm/rodada-2026-06-16/A3-compilador-md-enforcement.md:226-240`.

## 7 Riscos nao cobertos

R-01 — Adicionar coluna `arvore` ao REGISTRY sem atualizar contrato de tabela e testes pode deixar a etiqueta invisivel para guards. `assert-registry-line.sh` hoje confere apenas que o path aparece como coluna exata em `guards/assert-registry-line.sh:117-135`, e o REGISTRY atual nao tem coluna `arvore` em `REGISTRY.md:878-880`.

R-02 — A matriz de maturidade e a arvore de prova podem virar duas escalas publicas se nao houver regra de precedencia. A matriz declara ser fonte unica para capacidade publica em `methodology/MATURITY-MATRIX.md:5-6` e define estados oficiais em `methodology/MATURITY-MATRIX.md:21-29`; PF introduz `arvore` como endereco de prova em `docs/brainstorm/PROPOSTA-arvores-agora.md:16-21`.

R-03 — A proxima acao no STATE ja pressupoe arvores registry-centric em `.hbn/relay/STATE.md:14` e `.hbn/relay/STATE.md:95-96`; os deliverables A2/PF ainda documentam front-matter em `docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md:93-107` e `docs/brainstorm/PROPOSTA-arvores-agora.md:9-10`. Se o orquestrador usar os deliverables sem consolidacao, a onda nasce com contrato ambíguo.

## 8 Proxima acao

1. Antes do freeze: consolidar A2/PF numa decisao unica `registry-centric` ou `front-matter`, com teste negativo de divergencia e atualizacao de REGISTRY/schema/guard; evidencias do conflito estao em `docs/brainstorm/PROPOSTA-arvores-agora.md:9-10`, `.hbn/messages/20260616-180000-opus-4-8-proposta-arvores-leve-e-fechamento-mvp.md:126-128` e `REGISTRY.md:878-880`.
2. Antes do freeze: corrigir `main()` para exit-code !=0 em erro logico e unificar diretorio canonico de estado; evidencias em `src/usehbn/cli.py:1732`, `src/usehbn/cli.py:1759`, `src/usehbn/cli.py:1771-1772`, `src/usehbn/cli.py:1564-1595` e `src/usehbn/runtime.py:376-379`.
3. Antes do freeze publico: inserir `autoevolve` na matriz e rebaixar copy publica para scaffold/humano-no-loop; evidencias em `src/usehbn/autoevolve/worker.py:1-6`, `src/usehbn/autoevolve/orchestrator.py:1-6`, `site/autoevolve.html:60-67` e comando `rg -n "autoevolve|microdelta|sanitiza" methodology/MATURITY-MATRIX.md` -> codigo 1, sem linhas.
4. Depois dos P0: transformar A1 em onda propria com G-FDACK acoplado a baton/nonce e bateria de replay; evidencias da lacuna em `docs/brainstorm/rodada-2026-06-16/A1-front-door-verificavel.md:225-244` e `guards/hbn-guards-runner.sh:49-72`.

APROVA_A1: NAO · Conf 82/100 · aprovaria como onda propria se ack copiado/replay for bloqueado por baton/nonce e testes adversariais.
APROVA_A2: NAO · Conf 88/100 · a ortogonalidade e boa, mas a fonte de verdade `front-matter` versus `REGISTRY` esta divergente no disco.
APROVA_A3: SIM · Conf 78/100 · aprovado como verificador de proveniencia/cobertura, com FORTE incorporado contra claim de fidelidade semantica mecanica.
APROVA_B1: SIM · Conf 95/100 · achados de exit-code, diretorios de estado e god-object foram confirmados no codigo.
APROVA_B2: SIM · Conf 93/100 · achados de autoevolve ausente da matriz e scaffold/stub foram confirmados; acrescentei site/autoevolve como risco publico.
APROVA_PF-ARVORES-AGORA: NAO · Conf 90/100 · bloquear como escrito porque propoe front-matter enquanto o estado posterior decidiu registry-centric.

Assinado: gpt-5 · 2026-06-16T23:10:38-03:00
