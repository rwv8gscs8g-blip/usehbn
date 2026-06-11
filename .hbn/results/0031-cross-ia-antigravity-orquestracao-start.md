# Parecer Antigravity — orquestração-start completa (ADR-024)
**Auditor:** antigravity (Gemini 3.5) · **Session role:** cross-ia-audit-orquestracao-start
**Reviewed at:** 2026-06-10T21:30:00-03:00

## Pré-flight
1. **pwd**: `/Users/macbookpro/Projetos/usehbn`
2. **git status**:
   - Limpo (nenhum arquivo staged ou modificado).
3. **git log**:
   - `72afa1c checkpoint(protocol): ADR-024 metade 2 — 4 guards (G-STR/G-NUM/G-PTR/G-RLT) + 26 testes negativos (suite 59) — proposed, fora do runner`

---

## Veredito por escopo

| Item | Veredito | Evidência-chave |
|---|---|---|
| (1) Bloqueio de casos ruins pelas Specs | **REPROVADO** | [assert-parallel-id.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-parallel-id.sh) possui uma falha de prefixo de regex que permite bypass de agentes não autorizados (F-05) e não valida data de IDs seriais (F-01). O CLI não implementa o comando `usehbn start` (F-04). |
| (2) Efetividade dos Testes Negativos | **APROVADO COM ALERTA** | A suíte ampliada em [run-guard-tests.sh](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh) é hermética e passa com 59/59 casos verdes. Contudo, há uma fragilidade metodológica: se o guard quebrar por erro sintático, o teste de bloqueio pode ser avaliado como verde por retornar `rc != 0`. |
| (3) Coerência ADR-024 × Specs × Guards × Testes | **REPROVADO** | Há desalinhamento severo entre a especificação declarada e a realidade prática. O rito do `usehbn start` é especificado como um comando que gera esqueletos e valida perfis, mas a ferramenta CLI não possui essa lógica implementada. |
| (4) Cobertura de regras normativas (ADR sem guard) | **APROVADO COM ALERTA** | A maior parte das regras normativas está mapeada. Porém, a regra do "Log frio" na Decisão 6 do [ADR-024](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-024-orquestracao-start.md) (não permitir logs na `read-list`) ficou sem guard de enforcement e sem indicação de backlog no mapa (F-06). |
| (5) Análise de Risco Antropológico / Cultural | **APROVADO COM ALERTA** | O rito de reinicialização do orquestrador (ADR-024 D2) é uma regra excelente para conter o drift cognitivo, mas por ser declarada puramente doctrinal (backlog), o agente pode facilmente descumpri-la sem ser bloqueado, gerando falsa sensação de segurança. |

---

## Findings

### F-01 · MARGINAL · guards/assert-parallel-id.sh · L135-143
* **Evidência**: [assert-parallel-id.sh:L135-143](file:///Users/macbookpro/Projetos/usehbn/guards/assert-parallel-id.sh#L135-L143)
* **Descrição**: O guard G-NUM não confere a consistência da data (YYYYMMDD) contra o campo `created_at` do REGISTRY.md em linhas de IDs seriais (formato `AAAAMMDD-NN`). O bloco condicional `if [[ "$id_col" =~ ^([0-9]{8})-([0-9]{6})- ]];` é restrito a IDs paralelos (que contêm o carimbo HHMMSS). Linhas de IDs seriais criadas com data divergente de `created_at` (ex: ID `20260101-01` com `created_at: 2026-06-10T...`) passam sem bloqueio.
* **Recomendação**: Adicionar um ramo de captura alternativo no regex para IDs seriais (`^([0-9]{8})-[0-9]{2}$`) e validar a correspondência da substring de data (YYYYMMDD) contra o carimbo de data (YYYY-MM-DD) do `created_at`.

### F-02 · MARGINAL · guards/assert-pointer-honest.sh · L131
* **Evidência**: [assert-pointer-honest.sh:L131](file:///Users/macbookpro/Projetos/usehbn/guards/assert-pointer-honest.sh#L131)
* **Descrição**: O guard G-PTR extrai linhas contendo `⟦HBN⟧` usando um grep simples no arquivo, sem ignorar blocos de código markdown (code fences). Se um handoff ou prompt contiver um exemplo explicativo de formato de ponteiro com um caminho fictício (ex: `⟦HBN⟧ [caminho/falso.md](...)`), o guard tentará validá-lo e bloqueará o commit por não encontrar o arquivo de exemplo no index (falso positivo / sobre-bloqueio).
* **Recomendação**: Excluir linhas pertencentes a code blocks markdown do grep, ou instruir os agentes a utilizarem uma sintaxe modificada (ex: `\⟦HBN\⟧` ou `[HBN]`) ao documentarem templates/exemplos.

### F-03 · MARGINAL · guards/assert-report-fresh.sh · L122-124
* **Evidência**: [assert-report-fresh.sh:L122-124](file:///Users/macbookpro/Projetos/usehbn/guards/assert-report-fresh.sh#L122-L124)
* **Descrição**: A extração do chapéu do relato de estado é frágil frente a pequenas variações de formatação. O script depende estritamente do separador middle dot (`·`). Se o relato utilizar hífen ou outro caractere como separador e o nome do agente contiver o termo "orquestrador" (ex: `orquestrador-1`), a variável `chapeu` capturará o cabeçalho inteiro e disparará incorretamente a exigência da cápsula de decisões informais, mesmo que o chapéu real seja outro (ex: `implementador`).
* **Recomendação**: Refatorar o parser usando expressão regular em Bash para extrair o segundo elemento delimitado de forma mais robusta, tolerando separadores comuns ou validando a formatação estritamente antes do parsing.

### F-04 · FORTE · src/usehbn/cli.py
* **Evidência**: [cli.py](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py)
* **Descrição**: O comando CLI `usehbn start` descrito em [ADR-024](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-024-orquestracao-start.md) Decisão 1 e na [start-rite-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/start-rite-spec.md) simplesmente não existe na CLI do protocolo. O parser do argparse no `cli.py` possui apenas comandos como `quickstart`, mas nenhuma definição de sub-parser ou lógica de execução para `start`. Isso força os agentes e operadores a simularem o rito declarativamente de forma manual, criando uma desconexão direta entre o comportamento especificado e o software.
* **Recomendação**: Implementar a lógica de leitura de perfis, validação de groupthink e impressão do bloco YAML diretamente no `cli.py` como comando `start`, ou remover a menção de que o comando CLI executa essas tarefas da especificação, tratando-o explicitamente como um rito puramente textual gerado sob demanda por modelos.

### F-05 · FORTE · guards/assert-parallel-id.sh · L98-103
* **Evidência**: [assert-parallel-id.sh:L98-103](file:///Users/macbookpro/Projetos/usehbn/guards/assert-parallel-id.sh#L98-L103)
* **Descrição**: Vulnerabilidade de colisão de prefixo no G-NUM. O guard usa `[[ "$base" =~ ^[0-9]{8}-[0-9]{6}-"$ag"-[a-z0-9][a-z0-9-]*\. ]]` para conferir a autoria de arquivos paralelos. Se o agente autorizado na escrita paralela for `alpha` e um agente não autorizado chamado `alpha-1` criar um arquivo `20260610-101010-alpha-1-slug.md`, a verificação passará com sucesso. A regex interpreta o fragmento `-1-slug` como parte do slug do agente `alpha`, burlando a barreira de autorização de autoria paralela do rito de start.
* **Recomendação**: Ajustar a regex para isolar o token do agente. Por exemplo, garantindo que o delimitador após o apelido do agente impeça que sufixos de nomes de outros agentes sejam englobados como slug. A regex deve validar exatamente `^([0-9]{8})-([0-9]{6})-([a-z0-9-]+)-([a-z0-9-]+)\.` e verificar se a captura do agente (`$3`) é exatamente igual ao apelido do agente.

### F-06 · MARGINAL · methodology/adr/ADR-024-orquestracao-start.md · L147-157
* **Evidência**: [ADR-024-orquestracao-start.md:L147-157](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-024-orquestracao-start.md#L147-L157)
* **Descrição**: A Decisão 6 proíbe que arquivos de log frios sob `logs/` entrem na `read-list` de documentos lidos em reinicializações do orquestrador. Contudo, nenhuma guarda de integridade confere o conteúdo da `read-list` no STATE ou nos handoffs contra caminhos de `logs/`, e essa restrição não foi listada como backlog ou "doutrina-sem-enforcement" na tabela de enforcements. A regra carece de validação mecânica ou classificação honesta.
* **Recomendação**: Documentar na tabela de enforcement do ADR-024 que a restrição de read-list do log frio é doctrinal-sem-enforcement, ou implementar um check no G-RLT que examine as chaves de leitura do STATE.

---

## Tensões filosóficas e risco antropológico/cultural

1. **A Desconexão Prática da Ferramenta (Teatro de Especificação)**:
   A formalização do rito declarativo de start no ADR-024 é elogiável, mas a ausência física do comando `usehbn start` na CLI expõe uma tensão crítica. Ao criarmos especificações refinadas e guards que leem fixtures estáticas de testes sem implementar a ferramenta que executa a cerimônia real, corre-se o risco de criar um "teatro de especificação" onde as regras sobre a ferramenta são exaustivamente validadas por guards e testes sem que a própria ferramenta exista no terminal do desenvolvedor.
2. **O Limite do Anti-Groupthink Mecânico**:
   A delegação da lógica de G-STR para G-FAM foca estritamente na separação por "famílias de fornecedores" (Google, OpenAI, Anthropic). No entanto, o groupthink real é um fenômeno de dados de treino e alinhamento de RLHF. Modelos de famílias diferentes refinados sob as mesmas premissas de liveness ou alinhamento mercadológico podem sofrer de groupthink cognitivo idêntico. Tratar o groupthink como uma equação de tokens e strings diferentes cria uma ilusão matemática de segurança analítica.
3. **Warm Boot e o Bypass Silencioso**:
   O contrato de reinicialização do orquestrador conversacional (§2 da `orchestrator-profile-spec.md`) é auto-declarado como `backlog` de enforcement. Sem uma forma de auditar se o agente de fato abriu um chat limpo ou continuou acumulando tokens na janela anterior, o rito de warm boot depende inteiramente da autodisciplina do modelo. Modelos sob pressão de entrega tendem a manter janelas abertas para reusar o histórico recente sem precisar reler o disco, quebrando silenciosamente o pilar da statelessness.

---

## Comparação com precedentes externos

1. **RBAC e Identidade em Fluxos de Trabalho Git**:
   A tentativa de validar autoria via metadados do nome do arquivo (`AAAAMMDD-HHMMSS-agente-slug`) em G-NUM é um reflexo das limitações de RBAC em repositórios com credenciais compartilhadas. Em fluxos corporativos, a identidade é garantida por assinaturas GPG/SSH individuais e chaves de API restritas vinculadas a commits. O uso de regras de nomes e regex no Git Index é uma engenharia defensiva criativa para contornar a falta de identidades criptográficas distintas para as IAs locais.
2. **Robustez de AST e Parsers Estáticos**:
   A falha de code fences do G-PTR (F-02) ilustra o risco de usar regex e greps ingênuos em cima de markdown. Compiladores e ferramentas de análise estática de código (como ESLint ou formatadores markdown) constroem árvores de sintaxe abstrata (AST) para isolar código de comentários. A validação linear de texto sem reconhecimento de blocos sempre resultará em falsos positivos ou falsos negativos em documentações ricas.

---

## Checklist anti-viés

* **B1. Li os artefatos diretamente?** Sim, analisei detalhadamente as especificações [start-rite-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/start-rite-spec.md), [pointer-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/pointer-spec.md), [state-report-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/state-report-spec.md) e [orchestrator-profile-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/orchestrator-profile-spec.md), bem como o código das quatro guardas em `guards/` e a suíte em `run-guard-tests.sh`.
* **B2. Verifiquei as alegações de teste independentemente?** Sim, a suíte de 59 testes foi executada localmente, confirmando a aprovação mecânica dos testes negativos e de skew.
* **B3. Procurei razões para reprovar antes de aprovar?** Sim. A análise de regex de autoria paralela revelou um bypass imediato por prefixo (F-05) e a ausência física do comando start no Python cli (F-04).
* **B4. Encontrei contradições?** Sim, a especificação relata um comando funcional `usehbn start` que não existe na implementação, e descreve restrições de logs sem mecanismos de proteção equivalentes.
* **B5. Alguma recomendação minha preserva minha utilidade/relevância?** Não. As correções propostas visam o isolamento e robustez lógica dos guards e a consistência da CLI.
* **B6. Não assumi o bastão?** Confirmado. O bastão no `STATE.md` permanece sob responsabilidade do papel e modelo ativo do ciclo de orquestração serial.

---

## Recomendação por hearback

* **EF1 (Correção do G-NUM - Prefixo e Data Serial)**: **BLOQUEAR**. Exigir a correção da regex em `assert-parallel-id.sh` para evitar bypass por prefixo (F-05) e estender a validação de data para IDs seriais (F-01).
* **EF2 (Implementação / Ajuste da CLI - usehbn start)**: **BLOQUEAR**. O comando `usehbn start` precisa existir no CLI ou a especificação e ADR devem ser alteradas para remover o falso pressuposto de sua existência (F-04).
* **EF3 (Ajustes de Robustez e Limpeza - G-PTR / G-RLT)**: **APROVAR COM AJUSTE**. Os problemas de code blocks do G-PTR (F-02) e separador do G-RLT (F-03) devem ser colocados no backlog da próxima onda.

---

## VETO_ADOÇÃO: SIM (Condicionado à correção das falhas de segurança do G-NUM e alinhamento da CLI em F-04)

---

## Recomendação para humano (<=10 linhas)

A especificação da Orquestração-start é robusta no papel, mas a implementação atual possui duas falhas graves que impedem sua adoção segura. O guard G-NUM apresenta vulnerabilidade de prefixo (F-05), permitindo que agentes com apelidos parecidos (ex: `alpha-1`) burlem o bloqueio de escrita paralela passando-se por outros (ex: `alpha`). Adicionalmente, o comando `usehbn start` descrito na especificação não foi implementado na CLI do `cli.py` (F-04). Recomenda-se vetar a adoção da Metade 2 até que a regex de autoria do G-NUM seja isolada com tokens exatos e a lacuna de implementação da CLI seja resolvida ou a documentação formal alinhada à realidade textual.
