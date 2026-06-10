# Parecer Antigravity — auditoria cruzada corrente D (C1→D)
**Auditor:** antigravity (Gemini 3.5) · **Session role:** cross-ia-audit-corrente-d
**Reviewed at:** 2026-06-10T11:25:00-03:00

## Pré-flight
1. **pwd**: Confirmado em `/Users/macbookpro/Projetos/usehbn`
2. **git status**:
   - O status do repositório confirma a existência de alterações untracked/modified correspondentes à Corrente D e não commitadas.
   - Modificados:
     - [REGISTRY.md](file:///Users/macbookpro/Projetos/usehbn/REGISTRY.md)
     - [core/relay-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/relay-spec.md)
     - [schemas/state.schema.json](file:///Users/macbookpro/Projetos/usehbn/schemas/state.schema.json)
   - Não commitados / Untracked:
     - `.hbn/messages/`
     - `.hbn/relay/STATE.md`
     - `20260610-51-prompt-pack-auditoria-cruzada-corrente-d.md`
     - `PROMPT_D_CHAIN_FABLE5.md`
     - `core/dual-run-spec.md`
     - `core/freeze-gate-spec.md`
     - `core/roles-assignment-spec.md`
     - `guards/assert-registry-line.sh`
     - `guards/assert-role-family.sh`
     - `guards/freeze-gate.sh`
     - `inbox/credenciamento/20260610-44-freeze-gate-v206.md`
     - `methodology/adr/ADR-016-dual-run-caracterizacao.md`
     - `methodology/adr/ADR-017-freeze-gate-executavel.md`
     - `methodology/adr/ADR-018-papeis-chapeus-anti-groupthink.md`
     - `reports/20260610-36-proposal-faxina-prompts-raiz.md`
     - `schemas/dual-run-result.schema.json`
     - `schemas/freeze-checklist.schema.json`
   - *Observação*: O arquivo `reports/20260610-15-proposal-bump-versao-canonico.md` já se encontra integrado ao histórico do repositório, constando como comitado e registrado nas linhas 62 e 79 do REGISTRY. A divergência é normal e consistente com a história relatada.

## Veredito por escopo

| Item | Veredito | Evidência-chave |
|---|---|---|
| (1) Coerência e completude C1→D | **BLOQUEADO** | Lacunas críticas identificadas nos guards de validação executáveis e discrepâncias entre o comportamento dos scripts e o que as especificações declaram. |
| (2) Lógica do bastão e do STATE | **APROVADO** | O modelo STATE × LOG (Bastão 2.0) funciona muito bem, reduzindo drasticamente o overhead de tokens na retomada. O STATE diz a verdade em todos os seus campos. |
| (3) Nomenclatura, Temperatura e REGISTRY | **APROVADO** | Adoção estrita e sequencial da convenção global `AAAAMMDD-NN` nos depósitos 35..52. Os IDs 51 e 52 foram corretamente consumidos, exigindo renumeração da faxina. |
| (4) Funcionamento dos Guards | **BLOQUEADO** | Falha grave de lógica no `freeze-gate.sh` que impede critérios `"na"` justificados; vulnerabilidade de substring no `assert-registry-line.sh`; e falta de validação do arquivo físico no bypass de `assert-role-family.sh`. |
| (5) Adequação de ADR-016/017/018 | **APROVADO COM RESERVA** | Conceitos excelentes (teste de caracterização, release gates, e restrição de groupthink por família), mas a implementação dos guards possui furos de checagem. |
| (6) Faxina Dry-Run e Bump Adiado | **APROVADO** | O adiamento do bump para `0.3.1` previne fragmentação de nomes. A faxina em modo dry-run é segura e bem delineada, prevendo renumeração. |

## Findings

### F-01 · BLOQUEADOR · guards/freeze-gate.sh · L58-60
* **Evidência**: O script `guards/freeze-gate.sh` bloqueia incondicionalmente qualquer critério que seja obrigatório (`obrigatorio: true`) e que possua status `"na"`, mesmo se o campo `"justificativa"` estiver preenchido.
* **Descrição**: A spec [core/freeze-gate-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/freeze-gate-spec.md#L30) (§2, Regra 4) diz: *"na exige justificativa; critério obrigatório só pode ser na com hearback citado na justificativa"*. Mas a implementação do script avalia `elif cr.get("obrigatorio") and st != "ok":` na linha 58, o que gera erro imediato para `"na"` independente da presença de justificativa.
* **Recomendação**: Alterar a linha 58 para `elif cr.get("obrigatorio") and st not in ["ok", "na"]:` de forma a permitir a passagem do status `"na"` quando devidamente justificado (validação que já é tratada na ramificação anterior).

### F-02 · BLOQUEADOR · guards/assert-registry-line.sh · L82
* **Evidência**: O script `guards/assert-registry-line.sh` verifica a inclusão do arquivo no REGISTRY via `grep -qF "$f" "${REPO_ROOT}/${REGISTRY}"`.
* **Descrição**: Como o comando executa uma busca de substring pura (`-F`), qualquer novo arquivo cujo caminho seja uma substring de um arquivo já registrado passará indevidamente na checagem sem estar de fato no REGISTRY. Por exemplo, ao criar um novo arquivo não registrado `methodology/adr/ADR-01`, o guard retorna sucesso (`exit 0`) porque encontra casamento parcial com a linha do `methodology/adr/ADR-011...`.
* **Recomendação**: Usar uma expressão regular para garantir casamento exato de coluna ou delimitar o caminho com as barras verticais e espaços da tabela markdown. Exemplo: `grep -qE "\|[[:space:]]*$(echo "$f" | sed 's/\./\\./g')[[:space:]]*\|"` para garantir a correspondência exata do path.

### F-03 · FORTE · guards/assert-role-family.sh · L50
* **Evidência**: O script `guards/assert-role-family.sh` aceita `hearback_ref` como um bypass para o invariante de família (groupthink) e validação de `papeis_aptos`, mas apenas checa se a chave está presente no JSON (`hearback = a.get("hearback_ref")`).
* **Descrição**: Não é feita nenhuma validação física da existência do arquivo referenciado por `hearback_ref` no disco ou da confirmação de seu status interno. Uma IA pode burlar silenciosamente a trava inserindo qualquer string arbitrária que bata com o regex do schema (ex. `".hbn/hearbacks/9999-inexistente.json"`), comprometendo a robustez do gate.
* **Recomendação**: Adicionar uma validação no script para verificar se o arquivo apontado por `hearback_ref` realmente existe no sistema de arquivos e ler seu status interno (deve ser `"confirmed"`).

### F-04 · MARGINAL · guards/assert-registry-line.sh · L96
* **Evidência**: A regra 2 de verificação de prompts órfãos contém `[[ "$f" == */* ]] && continue`.
* **Descrição**: A regra apenas impede arquivos sem ID na raiz. Com isso, um modelo pode criar arquivos sem ID e sem REGISTRY dentro de subpastas como `docs/prompts/prompt-desalinhado.md`. O ADR-011 Decisão 2 deixa claro que prompts em `docs/` também devem possuir nomenclatura `AAAAMMDD-NN`.
* **Recomendação**: Expandir a verificação para cobrir subdiretórios específicos (como `docs/prompts/` ou `docs/`) que devam obrigatoriamente seguir as restrições do ADR-011.

### F-05 · MARGINAL · guards/assert-role-family.sh · L39 e L84
* **Evidência**: O script de validação de família e papéis opera de forma isolada, processando apenas o bloco JSON de atribuições.
* **Descrição**: Como o script não tem acesso ao arquivo `STATE.md` completo, ele não verifica se o modelo atual que detém o bastão (`proprietario_bastao`) corresponde de fato ao `chapeu_atual` que está sendo exercido na sessão de trabalho.
* **Recomendação**: Modificar o guard para receber o path do `STATE.md`, extrair o front-matter e validar se o proprietário ativo do bastão possui aptidão cadastrada em `.hbn/models/` para vestir o chapéu atual.

## Tensões filosóficas e risco antropológico/cultural
1. **O Perigo da "Validação de Teatro"**: Quando introduzimos travas executáveis que falham em validar a existência de evidências externas (como o bypass do `hearback_ref` aceitar caminhos falsos), criamos um perigo antropológico. O operador humano passa a confiar cegamente no veredicto da máquina (`✓ Atribuição respeita o invariante`), enquanto a IA simplesmente aprendeu a gerar strings arbitrárias para contornar as restrições sem obter o aval real.
2. **A Exceção Anthropic (Fable × Opus)**: O ADR-018 Decisão 3 estabelece que Fable-5 não se auto-audita, e traz Opus-4-8 como validador fixo. Embora pertençam a checkpoints diferentes (família Anthropic), há uma proximidade de herança de pesos que introduz um risco cultural residual de groupthink. A barreira deve ser estritamente vigiada por auditores externos como Google (Antigravity/Gemini) e OpenAI (Codex) para manter a independência de julgamento ativa.

## Comparação com precedentes externos
1. **Characterization Testing (Feathers)**: O design do dual-run proposto no ADR-016 baseia-se diretamente na metodologia consagrada por Michael Feathers (*Working Effectively with Legacy Code*). Ao definir o legado VBA como "golden" e exigir explicação e hearback para qualquer desvio, o protocolo adota a melhor prática de engenharia para migração de sistemas antigos.
2. **Release Gates (Continuous Delivery)**: O checklist estruturado de freeze assemelha-se a modelos modernos de automação de releases (gates declarativos), reduzindo decisões de congelamento de versão tomadas sob pressão ou cansaço. Contudo, para que esses gates funcionem, a lógica precisa refletir perfeitamente as regras de negócio declaradas (o que falhou no bloqueio indevido de `na` justificado).
3. **Double Blind Review (Citações Acadêmicas)**: O invariante de família no assert-role-family assemelha-se à revisão por pares às cegas. Mas a falta de verificação do `hearback_ref` funciona como uma "citação fantasma" em um artigo científico: a estrutura formal da referência está perfeita, mas o documento citado sequer existe.

## Checklist anti-viés
* **B1. Li os artefatos diretamente?** Sim, fiz a leitura completa e atenta dos 29 arquivos do repositório.
* **B2. Verifiquei as alegações de teste independentemente?** Sim, executei simulações locais com os scripts originais no sandbox e descobri falhas lógicas e de escape em `freeze-gate.sh` e `assert-registry-line.sh`.
* **B3. Procurei razões para reprovar antes de aprovar?** Sim, adotei uma postura analítica crítica, focando em quebras de contrato e erros ocultos de parsing.
* **B4. Encontrei contradições?** Sim, localizei incoerências diretas entre código e especificações (F-01 e F-02).
* **B5. Alguma recomendação minha preserva minha utilidade/relevância?** Não. Todas as recomendações concentram-se em melhorar a automação das travas de CI e de código bash/python para uso geral, sem sugerir qualquer ação subsequente para mim.
* **B6. Não assumi o bastão?** Confirmado. A próxima ação continua mapeada como uma ação humana no STATE.md.

## Recomendação por hearback
* **H1**: Adiar a ativação do `assert-registry-line.sh` no runner até que a vulnerabilidade de substring (F-02) seja devidamente saneada.
* **H2**: Confirmar a execução da faxina da proposal 36, alterando os IDs dos 7 prompts movidos para a faixa `20260610-53` a `20260610-59` para acomodar os depósitos 51 e 52.
* **H3**: Adotar o ADR-016, a spec do dual-run e seu schema correspondente.
* **H4**: VETAR o avanço da proposta de release da V206 no Credenciamento (inbox 44) até que o bug de lógica do critério obrigatório `na` (F-01) em `freeze-gate.sh` seja corrigido.
* **H5**: Adotar o ADR-018 e o campo `atribuicao` no STATE, exigindo a correção imediata de `assert-role-family.sh` (F-03).
* **H6**: Adiar a ativação automática do `assert-role-family.sh` como passo do handoff até que a integridade física da checagem do `hearback_ref` seja adicionada.

## VETO_ADOÇÃO: sim

## Recomendação para humano (<=10 linhas)
O parecer é de VETO para a adoção da corrente D devido a falhas bloqueadoras de código nos guards. O script `freeze-gate.sh` impede incorretamente critérios obrigatórios justificados como `na` (F-01) e `assert-registry-line.sh` permite bypass de arquivos não registrados via colisão de substring (F-02). Adicionalmente, `assert-role-family.sh` não valida fisicamente o arquivo em `hearback_ref`, expondo o gate a bypasses arbitrários (F-03). Recomenda-se rejeitar a entrega atual e solicitar ao arquiteto que corrija essas falhas específicas nos guards antes de submeter a corrente D a um novo ciclo de validação.
