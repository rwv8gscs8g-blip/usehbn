SOU: Google · Gemini 3.5 · apelido: antigravity

# Auditoria cruzada — GATE-BATCH1-FRONTEIRA — por antigravity (chat novo)

## 1 Veredito
**BLOQUEAR** a promoção e o freeze dos pacotes de Fronteira devido à presença de falhas estruturais críticas no runtime Python (exit codes inadequados, fragmentação de diretórios de estado) e vulnerabilidades de bypass de segurança nos portões de maturidade (auto-aprovação por falta de criptografia, e falhas de monitoramento no G-REG).

---

## 2 BLOQUEADORES

### Bloqueador 1: CLI Python retorna Exit Code 0 em falhas lógicas e violações do protocolo
* **Descrição**: A CLI principal (`src/usehbn/cli.py`) captura e trata erros de consistência lógica do protocolo (como falha no handoff com readbacks pendentes ou subcomandos desconhecidos) e emite mensagens JSON contendo `"error"`, mas retorna `0` (sucesso) no encerramento de `main()`. Isso invalida scripts de automação e CI/CD, que dependem do código de saída para interromper execuções inseguras.
* **Evidência**:
  * [src/usehbn/cli.py:1732](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1732) (`result = {"error": "Unknown connector subcommand..."}`) seguido de `return 0` em [L1772](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1772).
  * [src/usehbn/cli.py:1759](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1759) (`result = {"error": "Unknown relay subcommand..."}`) seguido de `return 0` em [L1772](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1772).
  * [src/usehbn/cli.py:1607](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1607) (`return {"error": ".hbn/ does not exist..."}`) em `run_handoff`.
  * [src/usehbn/cli.py:1613-1618](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1613-L1618) (`return {"error": "Cannot handoff...", ...}`) em `run_handoff` com readbacks pendentes.
* **Remediação**: Adicionar uma hierarquia de exceções de protocolo (ex: `HbnProtocolViolation`) e reescrever `main()` para garantir que qualquer erro de fluxo ou violação de invariante saia com um código de retorno diferente de zero (ex: `sys.exit(2)` para erros de CLI, `sys.exit(3)` para violação de protocolo).

### Bloqueador 2: Portões de promoção vulneráveis a falsificação por ausência de chaves criptográficas (G-HRB)
* **Descrição**: Os portões propostos na A2 e os acks propostos na A1 dependem de autorização humana no disco e de relatórios de auditoria cruzada (`.hbn/results/*`) assinados por outras famílias de IA. No entanto, por estar a assinatura do G-HRB marcada como "PENDENTE DE CHAVE", não há validação criptográfica real. Qualquer IA pode falsificar os acks, as auditorias de outras famílias e a autorização do operador humano Mauricio escrevendo arquivos simples em texto plano.
* **Evidência**:
  * [.hbn/relay/STATE.md:62](file:///Users/macbookpro/Projetos/usehbn/.hbn/relay/STATE.md#L62) (`G-HRB assinatura PENDENTE DE CHAVE — Maurício gera/registra...`).
  * [guards/assert-dispatch-integrity.sh:201-204](file:///Users/macbookpro/Projetos/usehbn/guards/assert-dispatch-integrity.sh#L201-L204) (`if [[ -z "$human_authorization" ]]` - valida apenas que o campo não está vazio, sem verificar chaves ou assinaturas).
* **Remediação**: Ativar obrigatoriamente a verificação de assinaturas digitais por chave pública/privada (via `ssh-keygen -Y verify` ou GPG) para hearbacks humanos e pareceres de auditoria cruzada antes de permitir a promoção de qualquer artefato a `intermediaria` ou `estavel`.

### Bloqueador 3: Inconsistência de topologia e fragmentação em 3 diretórios de estado concorrentes
* **Descrição**: O protocolo coexiste com três diretórios de estado que duplicam e misturam responsabilidades: `.hbn/` (gerido pelo CLI para templates, knowledge e relay), `.usehbn/` (onde o runtime do protocolo salva `readbacks`, `results` e o arquivo canônico `hbn-state.json`), e a pasta `state/` (usada como fallback do estado legado). Esse drift exige correções e remendos em runtime para tentar sincronizar os dois locais ativos.
* **Evidência**:
  * [src/usehbn/utils/config.py:12](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/utils/config.py#L12) (`STATE_DIRNAME = ".usehbn"`) vs [src/usehbn/cli.py:752-753](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L752-L753) (`_hbn_dir` retorna `.hbn`).
  * [src/usehbn/cli.py:1564-1572](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1564-L1572) (comentário documentando o "path-mismatch fix" que busca dados nas duas pastas ao mesmo tempo).
  * [src/usehbn/runtime.py:376-379](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/runtime.py#L376-L379) (fallback de leitura de estado de `.usehbn` e `state`).
* **Remediação**: Consolidar a arquitetura de persistência. O runtime deve utilizar uma única pasta base unificada e consistente (preferencialmente `.hbn/` para dados estruturados frios de governança e um subdiretório de estado explícito para arquivos de execução), eliminando `.usehbn/` e `state/` legados.

### Bloqueador 4: G-REG (`assert-registry-line.sh`) ignora modificações (M), permitindo promoção silenciosa
* **Descrição**: O guard G-REG (`assert-registry-line.sh`) só é disparado quando arquivos são adicionados ou renomeados (`diff-filter=AR`). Como a promoção de árvore de um arquivo existente (ex: de `fronteira` para `intermediaria`) ocorre apenas por edição de front-matter (modificação, `M`), o guard não força nem checa se a correspondente linha de evento de promoção foi adicionada ao `REGISTRY.md` no mesmo commit.
* **Evidência**:
  * [guards/assert-registry-line.sh:16-19](file:///Users/macbookpro/Projetos/usehbn/guards/assert-registry-line.sh#L16-L19) (`Escopo: arquivos ADICIONADOS ou RENOMEADOS (diff-filter=AR...); Tocar arquivo legado existente (M) não dispara`).
  * [guards/assert-registry-line.sh:70-74](file:///Users/macbookpro/Projetos/usehbn/guards/assert-registry-line.sh#L70-L74) (diff-filter limitado a AR).
* **Remediação**: Estender a lógica do G-REG para monitorar edições (`diff-filter=M`) que modifiquem metadados de ciclo de vida do protocolo (como a tag `arvore:` ou `temperatura:` no front-matter) e exigir a inserção da correspondente linha de histórico em `REGISTRY.md` no mesmo commit.

### Bloqueador 5: Componente autoevolve é teatro de automação e omitido da MATURITY-MATRIX
* **Descrição**: O módulo `src/usehbn/autoevolve` possui lógica que simula uma execução e validação autônomas de microdeltas. Porém, o worker é um stub sem comportamento de escrita real (`no-op`), os contadores de diff do resultado são mockados como `0` por padrão (burlando a verificação de orçamento de diff) e o CLI expõe comandos inoperantes. A omissão desse componente na `MATURITY-MATRIX.md` canônica mascara a inexistência da funcionalidade autônoma.
* **Evidência**:
  * [src/usehbn/autoevolve/worker.py:3-5](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/autoevolve/worker.py#L3-L5) (worker admite ser um no-op stub e que o assistente atua fora dele).
  * [src/usehbn/autoevolve/contract.py:49-50](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/autoevolve/contract.py#L49-L50) (`diff_added: int = 0`, `diff_removed: int = 0`).
  * [src/usehbn/autoevolve/approval.py:27](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/autoevolve/approval.py#L27) (orçamento sempre passa porque os valores de diff no resultado são sempre 0).
  * [methodology/MATURITY-MATRIX.md:52-79](file:///Users/macbookpro/Projetos/usehbn/methodology/MATURITY-MATRIX.md#L52-L79) (ausência total de "autoevolve" na tabela oficial).
* **Remediação**: Registrar `autoevolve` na Maturity Matrix com status de "Scaffold" para o agregador de auditoria e "Stub" para o orchestrator/worker. Ajustar os textos públicos do CLI para deixar explícito que o comando não realiza evolução autônoma de código em v0.3.0.

---

## 3 FORTES

### Forte 1: Desalinhamento estatístico de testes ativos
* **Descrição**: Há uma divergência tripla nos números de teste divulgados nos contratos do repositório: `93/93` no `AGENTS.md`, `114/114` no `MATURITY-MATRIX.md`/`README.md`, enquanto o pytest real executa `182` testes com sucesso. A documentação estatística de progresso precisa ser atualizada para não minar a credibilidade da fundação honesta do useHBN.
* **Evidência**:
  * [AGENTS.md:57](file:///Users/macbookpro/Projetos/usehbn/AGENTS.md#L57) (`currently 93/93 passing`).
  * [README.md:5](file:///Users/macbookpro/Projetos/usehbn/README.md#L5) e [methodology/MATURITY-MATRIX.md:76](file:///Users/macbookpro/Projetos/usehbn/methodology/MATURITY-MATRIX.md#L76) (`Suite verde 114/114`).
  * Saída do comando pytest local (182 testes executados e passados).

### Forte 2: Falta de acoplamento do ack ao Baton Token
* **Descrição**: A proposta G-FDACK permite referenciar um ack pré-existente sem que este esteja vinculado ao baton token em uso (`HBN-Token-FP`). Isso viabiliza que uma IA reaproveite ou "tome emprestado" um ack antigo ou de outra sessão para commitar sem que tenha lido os contratos no reinício do chat corrente.
* **Evidência**: [docs/brainstorm/rodada-2026-06-16/A1-front-door-verificavel.md:239-244](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-16/A1-front-door-verificavel.md#L239-L244) (identificado como pergunta aberta, mas deve ser tratado como requisito forte para evitar reuso).

### Forte 3: Divergência semântica do compilador `.md` -> `enforcement:`
* **Descrição**: A proposta A3 introduz um bloco estruturado de metadados em YAML `enforcement:` que é paralelo à prosa descrita no Markdown. Se as descrições divergirem, o parser aplicará a lógica do bloco YAML e o humano esperará a prosa. Como a "fidelidade" não pode ser semanticamente validada de forma automatizada, o risco de introduzir uma segunda fonte de verdade contraditória é elevado.
* **Evidência**: [docs/brainstorm/rodada-2026-06-16/A3-compilador-md-enforcement.md:249-255](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-16/A3-compilador-md-enforcement.md#L249-L255) (pergunta aberta reconhecendo o risco de segunda fonte de verdade).

---

## 4 MARGINAIS

### Marginal 1: Penteados e acoplamento no CLI Python
* **Descrição**: O god-object `cli.py` contém imports tardios locais para evitar dependências cíclicas e acoplamento nos subparsers de connector e init, onde os métodos simulam namespaces fabricados manualmente. A decomposição proposta é válida, mas deve simplificar a assinatura para funções puras e agnósticas a argparse.
* **Evidência**: [src/usehbn/cli.py:1381, 1573](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1381) (imports locais) e [L1221-1226](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1221-L1226) (handler fabricando namespace).

### Marginal 2: Escala semântica L4 sem definição canônica
* **Descrição**: O README.md adjetiva o useHBN no nível "solid L4", porém este nível não possui descrição ou correspondência mapeada na escala oficial de maturidade (que possui apenas 5 estados).
* **Evidência**: [README.md:559](file:///Users/macbookpro/Projetos/usehbn/README.md#L559) ("HBN is now at a solid L4 level") vs [methodology/MATURITY-MATRIX.md:21-29](file:///Users/macbookpro/Projetos/usehbn/methodology/MATURITY-MATRIX.md#L21-L29).

### Marginal 3: Pointers obsoletos para a matriz de maturidade
* **Descrição**: O arquivo `AGENTS.md` ainda aponta para o redirecionador obsoleto `docs/MATURITY-MATRIX.md` em vez de apontar diretamente para a fonte unificada.
* **Evidência**: [AGENTS.md:17](file:///Users/macbookpro/Projetos/usehbn/AGENTS.md#L17) (`docs/MATURITY-MATRIX.md`).

---

## 5 Convergências
* **Ortogonalidade de Metadados**: Concordamos integralmente com o argumento da A2 de que `temperatura:` (tempo), `hbn-track:` (rito/processo) e `arvore:` (nível de prova) cobrem dimensões distintas e ortogonais, não configurando tabelas duplicadas.
* **Critérios de Aptidão (Fitness criteria)**: A validação em 8 eixos (C-TEST a C-DEBT) para decidir a sobrevivência dos guards ao molt é altamente rigorosa e conceitualmente correta.
* **Curadoria da Zona Livre**: O guard `G-ZONA-LIVRE` (W3) atua de forma robusta e fail-closed para impedir smuggling e vazamentos sob a pasta `docs/brainstorm/` sem a aprovação explícita no readback ativo.

---

## 6 Divergências
* **Partição física de diretórios (Divergência Crítica)**: Divergimos da recomendação de mover fisicamente os arquivos de especificação e código para diretórios baseados em árvores (ex: `/fronteira`, `/intermediaria`, `/estavel`) na próxima exúvia. Nossa avaliação é de que a movimentação física quebra caminhos de versionamento, invalida o git log nativo e cria churn desnecessário de referências. O modelo *registry-centric* (onde a árvore é mapeada unicamente no front-matter e no REGISTRY, mantendo o arquivo estável em sua localização lógica canônica) é mais limpo, portável e sustentável.
* **Escopo de Geração Automática de Guards**: Divergimos da viabilidade prática de um "gerador de código de guards a partir de prosa" a curto ou médio prazo. Esse esforço deve ser mantido como pesquisa na Fronteira sem rampa de promoção executável, priorizando-se o desenvolvimento de analisadores de consistência estática de ponteiros (guards de metadados como `G-PROV`).

---

## 7 Riscos não cobertos
* **Modificação maliciosa de perfis de modelo**: O guard `G-FAM` impede que o implementador atue como auditor validando se o seu `model_id` consta nos auditores do STATE. Contudo, como os perfis de modelo em `.hbn/models/*.json` são JSONs em texto plano e sem assinatura, uma IA pode editar o arquivo de perfil do seu concorrente (ou o próprio) no mesmo commit para contornar a restrição de família.
* **Fraude de timestamp em Acks**: O campo `created_at` em YAML dos acks não é validado contra o relógio do sistema ou comitagem git, abrindo brecha para que IAs insiram datas retroativas ou futuras para camuflar atrasos de expiração do bastão.

---

## 8 Próxima ação
* **Passagem de Bastão**: Recomendamos passar o bastão para o agente da família OpenAI (Codex).
* **Racional**: A correção estrutural do CLI Python (tratamento de erros, exit codes e unificação de diretórios de estado `.hbn`/`.usehbn`) exige familiaridade com a arquitetura base do runtime implementado originalmente. A intervenção direta de um agente Codex sob a supervisão e hearback manual de Maurício é a via mais limpa.
* **Viés declarado**: Como agente da família Google/Gemini, priorizamos integridade estática de metadados, minimização de refatorações de caminho git físicos, e eliminação rigorosa de teatro de automação (autoevolve). Reconhecemos que nossa insistência em consistência conceitual pura pode adiar entregas de novas features, mas protege a segurança do protocolo.

---

APROVA_A1: NÃO · Conf 95/100
APROVA_A2: NÃO · Conf 95/100
APROVA_A3: NÃO · Conf 90/100
APROVA_B1: NÃO · Conf 100/100
APROVA_B2: NÃO · Conf 100/100
APROVA_PF-ARVORES-AGORA: NÃO · Conf 95/100

Assinado por: antigravity, 2026-06-16.
