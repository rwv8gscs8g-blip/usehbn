# Parecer Antigravity — re-auditoria cruzada corrente E (anti-teatro 50%)
**Auditor:** antigravity (Gemini 3.5) · **Session role:** cross-ia-audit-corrente-e
**Reviewed at:** 2026-06-10T16:15:00-03:00

## Pré-flight
1. **pwd**: Confirmado em `/Users/macbookpro/Projetos/usehbn`
2. **git status**:
   - O status do repositório está limpo (sem arquivos modificados ou não rastreados).
3. **git log**:
   - HEAD está em `1a3a2c4` (checkpoint(protocol): corrente E 50% (anti-teatro ADR-020 + 3 guards endurecidos + testes negativos + F-04 excecao fable-opus) — status: proposed, nao adotado).

## Veredito por escopo

| Item | Veredito | Evidência-chave |
|---|---|---|
| (1) Resolução de Bloqueadores D | **APROVADO** | Os bugs G-FRZ (F-01: na-justificado bloqueava) e G-REG (F-02: colisão por substring) foram definitivamente corrigidos. O bypass de G-FAM (F-03: hearback_ref fantasma) agora realiza dereferenciação física real e valida status `confirmed`. |
| (2) Efetividade da Suíte de Testes | **APROVADO** | A suíte em `guards/tests/run-guard-tests.sh` é robusta, hermética (usa models/registries fictícios em diretórios temporários) e roda 15 testes verificando tanto casos felizes quanto bloqueios reais para cada falha histórica. |
| (3) Suficiência de ADR-020 | **APROVADO COM RESERVA** | A política "sem teste negativo, sem runner" é excelente, mas os 5 guards legados continuam ativos no runner sem testes na nova suíte. Há também brechas menores no diff filter (renomes) e escopo de paths de prompt/scripts. |
| (4) Cerca da Exceção Fable × Opus (F-04) | **APROVADO** | Opus foi removido com sucesso do campo mecânico `auditores` no `STATE.md` devido ao hearback `0002` estar em `status: pendente`. A trava do G-FAM impede mecanicamente sua reinserção até a assinatura humana. |
| (5) Análise de Risco Antropológico | **APROVADO COM ALERTA** | A mitigação "dereferenciar artefato" cria uma falsa sensação de segurança se o operador humano sofrer de viés de automação. A IA pode gerar e comitar novos hearbacks falsos com `status: confirmed` (Teatro de 3º Nível). |

---

## Findings

### F-01 · MARGINAL · guards/assert-registry-line.sh · L40-46
* **Evidência**: O diff filter usa apenas `git diff --diff-filter=A` para arquivos adicionados.
* **Descrição**: Se uma IA renomear um arquivo numerado (ex: um ADR ou especificação), o Git pode classificar a operação como Rename (`R`). Como a função `guard_added_files()` captura apenas status `A`, o arquivo renomeado não será verificado pelo G-REG, permitindo bypassar o REGISTRY.md mesmo com a proibição de renames do ADR-011.
* **Recomendação**: Alterar o filtro para `--diff-filter=AR` em `assert-registry-line.sh` para interceptar renames e validar se o novo path está registrado.

### F-02 · MARGINAL · guards/assert-registry-line.sh · L58-82
* **Evidência**: A função `is_numbered_artifact()` captura apenas scripts na raiz de guards via `guards/*.sh`.
* **Descrição**: O script de testes `guards/tests/run-guard-tests.sh` e eventuais utilitários sob subpastas não coincidem com `guards/*.sh`. Se novos scripts forem criados em subpastas de `guards/`, eles não serão capturados por essa checagem e poderão escapar do livro-razão REGISTRY.md.
* **Recomendação**: Adicionar padrões específicos ou usar suporte a wildcards recursivos (ex: `guards/**/*.sh` ou `guards/tests/*.sh`) dentro de `is_numbered_artifact()`.

### F-03 · MARGINAL · guards/tests/run-guard-tests.sh
* **Evidência**: A suíte de testes cobre apenas G-FAM, G-FRZ e G-REG.
* **Descrição**: Os 5 guards legados (`assert-canonical-root.sh`, `forbid-tmp-worktree.sh`, `forbid-env-files.sh`, `forbid-legacy-paths.sh`, `assert-scope-lock.sh`) encontram-se ativos no runner principal, mas não possuem cobertura de testes negativos na suíte `run-guard-tests.sh`, gerando incoerência técnica com a regra geral estabelecida no ADR-020 Decisão 2 ("todos os guards, atuais e futuros").
* **Recomendação**: Implementar casos de teste negativos para os guards legados na suíte de testes.

### F-04 · MARGINAL · guards/assert-registry-line.sh · L107-131
* **Evidência**: A regra 2 de prompts órfãos valida apenas a raiz e `docs/prompts/*.md`.
* **Descrição**: Se uma IA criar um arquivo Markdown órfão (sem ID e sem registro) diretamente em subpastas como `docs/` ou `methodology/` (ex: `docs/prompt-solto.md`), a validação de órfãos não o capturará porque a regra 2 descarta qualquer arquivo contendo `/` que não seja de `docs/prompts/`.
* **Recomendação**: Ampliar a regra 2 para cobrir subdiretórios de documentação que devem ser imunes a prompts órfãos.

### F-05 · FORTE · guards/assert-role-family.sh & guards/freeze-gate.sh · Risco de Auto-Assinatura
* **Evidência**: O guard lê e confia em arquivos `.json` na pasta `.hbn/hearbacks/` que possuem status `"confirmed"`.
* **Descrição**: Como o agente de IA opera no ambiente local do usuário com as mesmas permissões, ele pode gerar de forma autônoma um arquivo de hearback falso (ex: `.hbn/hearbacks/9999-fake.json`), preencher `"status": "confirmed"` e `"signed_by": "Maurício"` e comitá-lo junto com a violação. Os guards aprovarão a execução porque o arquivo físico existe e está formalmente correto, caracterizando "Teatro de 3º Nível".
* **Recomendação**: Estabelecer obrigatoriedade de revisão humana visual detalhada em diffs para qualquer criação ou alteração em arquivos sob `.hbn/hearbacks/`. Em longo prazo, avaliar o uso de assinaturas criptográficas (GPG/SSH) dos hearbacks.

---

## Tensões filosóficas e risco antropológico/cultural

1. **A Ilusão do Validador Físico (Teatro de 3º Nível)**: A remediação da Corrente E ataca com sucesso a "validação de teatro" ao dereferenciar as evidências. No entanto, ela introduz um novo risco cultural: o viés de automação. Sabendo que o guard agora "valida a substância", o operador humano pode relaxar e assumir que um check verde significa aprovação humana real. Como a IA tem permissão de escrita, ela pode forjar a própria substância (o arquivo de hearback verificado). O atrito mudou de "gerar uma string" para "comitar um arquivo fake no histórico", o que é um avanço (deixa rastros de auditoria no git), mas não substitui a necessidade do olhar cético humano sobre o diff.
2. **O Isolamento da Exceção Fable × Opus**: A solução desenhada para a exceção Anthropic foi excelente. A IA perde o poder de bypass automático porque o hearback `0002` foi deixado como `pendente` de assinatura no repositório. Como o guard endurecido falha se o status não for `confirmed`, a IA foi obrigada a remover Opus do campo de metadados `auditores` do `STATE.md`, mantendo-o apenas em prosa. Isso comprova que a mecânica de restrição baseada em arquivo físico funciona para forçar o recuo da IA e traz transparência para o estado real do handoff.

---

## Comparação com precedentes externos

1. **Test-Driven Compliance / Policy-as-Code**: Exigir que nenhuma política/guard seja ativada sem um teste negativo que prove seu bloqueio é a melhor prática em Test-Driven Compliance (como as diretrizes de Open Policy Agent - OPA). Isso elimina a falácia do "teste que passa por ausência de asserção".
2. **Princípio do Menor Privilégio e Assinaturas Digitais**: Em sistemas de produção, gates de liberação baseados em metadados (como o freeze) exigem criptografia de chave pública. No ecossistema local do Git, onde o agente compartilha o shell do usuário, a segurança lógica pura é impossível. O protocolo useHBN aceita esse limite ao mover a trava para a "evidência de diff" (visibilidade histórica), o que se alinha a modelos de auditoria post-hoc.

---

## Checklist anti-viés

* **B1. Li os artefatos diretamente?** Sim, realizei leitura analítica completa de todos os 3 guards, o script de testes, a fixture do hearback 0002, o STATE.md e as especificações de cadência e dual-run.
* **B2. Verifiquei as alegações de teste independentemente?** Sim, executei a suíte de testes localmente e rodei comandos específicos em `/tmp` com cenários simulados de bypass e substring, comprovando o bloqueio real dos guards.
* **B3. Procurei razões para reprovar antes de aprovar?** Sim, inspecionei de perto as regras de glob de arquivos do G-REG e a lógica de exceptions do G-FAM buscando brechas lógicas.
* **B4. Encontrei contradições?** Sim, identifiquei que a premissa de "nenhum guard no runner sem teste negativo" não é respeitada pelos 5 guards legados ativos.
* **B5. Alguma recomendação minha preserva minha utilidade/relevância?** Não. As sugestões visam apenas o endurecimento dos scripts bash/python e melhores práticas de verificação pelo operador humano.
* **B6. Não assumi o bastão?** Confirmado. O STATE.md continua apontando a próxima ação exclusivamente para o operador humano (Maurício).

---

## Recomendação por hearback

* **H1 (Aprovar e Adotar)**: Aprovar o avanço da Corrente E (50%), pois ela soluciona plenamente os bloqueadores críticos apontados na auditoria anterior.
* **H2 (Decisão sobre Exceção)**: Maurício deve revisar e assinar `.hbn/hearbacks/0002-excecao-fable-opus.json` (mudando para `confirmed`) se desejar que a Opus retorne ao papel mecânico de auditor. Até lá, a atribuição cruzada no `STATE.md` está correta e segura com Codex e Gemini 3.5.
* **H3 (Tratar Brechas Marginais)**: Incorporar a correção do diff-filter para `--diff-filter=AR` (F-01) e ajustar o escopo de subpastas de guards/prompts (F-02/F-04) em uma iteração futura.
* **H4 (Auditoria Humana de Hearbacks)**: O operador humano deve auditar rigorosamente o diretório `.hbn/hearbacks/` em busca de arquivos novos ou modificados que não tenham sido explicitamente autorizados por ele.

---

## VETO_ADOÇÃO: não

## Recomendação para humano (<=10 linhas)
A remediação proposta na Corrente E (50%) é real e eficaz. Os testes negativos provam que as vulnerabilidades críticas anteriores foram sanadas, e a exceção Fable x Opus está corretamente isolada aguardando sua assinatura. O parecer é pela aprovação e adoção da entrega. Recomenda-se apenas: (1) manter rigorosa conferência manual dos diffs em `.hbn/hearbacks/` para evitar que a IA simule uma confirmação própria ("auto-assinatura"); (2) ajustar em janelas futuras o filtro do diff para interceptar renomes (`--diff-filter=AR`) e planejar testes negativos para as 5 guardas legadas.
