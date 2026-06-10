---
proposal-id: 0042
titulo: Evolução da Orquestração useHBN — comando start, perfil do orquestrador, ponteiro HBN e relato de estado
status: PROPOSED
data-deposito: 2026-06-10
id-global: 20260610-42
path: .hbn/proposals/0042-antigravity-orquestracao-start.md
autor: antigravity-gemini (Google)
cross-ia-required: Fable + Opus + Codex
hearback-status: aguardando humano
prioridade: P1
relacionado:
  - methodology/adr/ADR-015-perfis-de-modelo.md
  - methodology/adr/ADR-018-papeis-chapeus-anti-groupthink.md
  - methodology/adr/ADR-021-documentos-auto-localizaveis.md
  - methodology/adr/ADR-022-saida-de-auditoria-legivel.md
  - core/roles-assignment-spec.md
  - core/relay-spec.md
---

# Proposta 0042 — Evolução da Orquestração useHBN

Eu sou o **Antigravity-Gemini (Google)**. Nesta proposta, apresento um desenho técnico para solucionar a fadiga de contexto do papel conversacional/orquestrador em fluxos de trabalho multi-IA sob o protocolo useHBN, estruturando rituais de inicialização, recuperação de contexto sem perdas, redução drástica de tokens em handoffs e formalização do relato de estado antes da passagem de bastão.

---

## 1. Comando `usehbn start`

### Desenho

O comando `usehbn start` é o ponto de entrada único CLI para inicializar um novo ciclo de ondas no protocolo useHBN. Ele automatiza a criação do arquivo `.hbn/relay/STATE.md` garantindo a conformidade estrita com as regras de atribuição de papéis e segurança lógica.

```bash
usehbn start \
  --orchestrator=<profile-alias> \
  --dev=<profile-alias> \
  --auditors=<profile-alias1>[,<profile-alias2>,...] \
  [--hearback-ref=<hearback-id>]
```

#### Mecanismos de Validação Interna do Comando:
1. **Verificação de Perfis (ADR-015)**: O comando lê `.hbn/models/<alias>.json` para cada IA declarada. Ele valida se o papel atribuído consta no array `papeis_aptos` do perfil.
2. **Invariante Anti-Groupthink (ADR-018)**: O comando extrai o campo `fornecedor` de cada perfil JSON. Ele valida se `fornecedor(dev) != fornecedor(auditor)` para todos os auditores declarados. Caso haja colisão (ex: Dev `fable-5` [Anthropic] e Auditor `opus-4-8` [Anthropic]), o comando aborta com erro de validação, a menos que `--hearback-ref` seja fornecido com um ID de hearback humano válido em `.hbn/hearbacks/`.
3. **Escrita no STATE**: Após sucesso, grava o bloco `atribuicao` estruturado e preenche os campos do front-matter de `.hbn/relay/STATE.md` (como `onda_atual`, `proprietario_bastao`, `papel_bastao` apontando inicialmente para o orchestrator), limpando sinais antigos e estabelecendo a primeira ação atômica.

#### Adicionando novas IAs (Ex: Jules):
Se o operador chamar um perfil não cadastrado (ex: `--dev=jules`), o comando falha e instrui o registro. Para registrar, o comando suporta a flag `--register-model`:
```bash
usehbn start --register-model jules \
  --model-id="mistral-jules-1.0" \
  --vendor="Mistral" \
  --roles="implementador,auditor-cruzado" \
  --context-tokens=128000
```
Isso gera o arquivo `.hbn/models/jules.json` em conformidade com o schema `model-profile.schema.json`, permitindo seu uso imediato na atribuição.

### Por que funciona
Ao invés de depender de edição manual e passível de erros humanos do `STATE.md`, o comando cria uma barreira mecânica que impede a inicialização de ondas que violem o invariante anti-groupthink ou utilizem modelos sem perfil de aptidão validado. O gate keeper humano é poupado de auditar a conformidade de inicialização da onda.

### Risco
**Risco de Bloqueio Operacional (Liveness Risk)**: Se o fornecedor preferido estiver indisponível (ex: indisponibilidade da API da OpenAI ou Anthropic), o desenvolvedor humano pode ficar impossibilitado de iniciar o ciclo porque o único modelo reserva violaria o anti-groupthink.
* **Mitigação**: O comando aceita o bypass `--hearback-ref`, permitindo que o humano decida correr o risco do viés de família temporariamente, documentando essa decisão no histórico da onda.

### 1 Alternativa
Declarar toda a configuração do elenco e atribuição em um arquivo estático de configuração local `.hbn/orchestration.yaml` e fazer com que o `usehbn start` apenas leia e valide esse arquivo contra os perfis antes de gerar o `STATE.md`. Isso mantém os argumentos CLI curtos, mas adiciona um artefato intermediário no disco que precisa ser versionado.

---

## 2. Perfil do Orquestrador (Pré-prompt Reinicializável)

### Desenho

O papel conversacional/orquestrador (que interage com o humano, avalia os relatórios das IAs e gerencia o bastão) sofre com a fadiga de contexto acelerada. Propõe-se a criação de um modelo de prompt autocontido em `agents/role-orchestrator.md` projetado para inicialização de janelas limpas ("Warm Boot") sem perda de regras de engajamento e estado mental.

O pré-prompt de Bootloader estruturado:

```markdown
Você está em chat NOVO e LIMPO de contexto. Você é o ORQUESTRADOR da onda do protocolo useHBN.
Seu papel principal é conversacional: arbitrar conflitos de auditoria, consolidar pareceres e interagir com o operador humano.

Instruções de Inicialização (Bootstrapping):
1. Leia .hbn/relay/STATE.md para confirmar que você detém o bastão.
2. Identifique o handoff_mais_recente e leia-o para capturar a síntese narrativa.
3. Leia as proposals pendentes indicadas em .hbn/relay/STATE.md.

Diretrizes de Comportamento (Contrato do Papel):
- **Verificação de Disco**: Nunca assuma o estado de arquivos do projeto com base em conversas passadas. Sempre verifique o filesystem real usando ferramentas de leitura.
- **Auditoria Cruzada Estrita**: Você deve exigir que os resultados de auditoria sigam o ADR-022 (markdown com findings categorizados e veredito explícito).
- **Julgamento Honesto & Isenção**: Detecte e aponte validações de teatro (conivência entre IAs do mesmo fornecedor ou declarações vagas de sucesso).
- **Humano no Controle (P5)**: Nunca adote mudanças sem hearback explícito.
- **Single Proposed Limit**: Nunca empilhe novos conjuntos propostos de alteração na fila de commits se o lote anterior ainda não foi auditado e consolidado.
- **Ritual de Fadiga**: Ao atingir o handoff_threshold do seu perfil, você DEVE interromper a sessão, produzir a "Cápsula de Estado HBN" (resumo da sessão com o histórico essencial e sinalizadores ativos) e instruir o humano a colar a Cápsula em uma nova janela de chat.
```

### Por que funciona
A statelessness (ausência de estado interno) do orquestrador é assumida como premissa de design. O orquestrador não precisa lembrar de toda a conversa histórica, contanto que o pré-prompt forneça a trilha exata de leitura do disco (STATE, handoff e proposals). A janela limpa recupera 100% da capacidade cognitiva e velocidade de resposta sem herdar o ruído de logs de chat acumulados.

### Risco
**Perda de Contexto Implícito (Tacit Drift)**: Instruções informais dadas pelo humano durante o chat (ex: "ignora o aviso de lint por enquanto") que não estejam registradas em arquivos formais de proposta ou no handoff serão perdidas na transição de janela.
* **Mitigação**: O pré-prompt instrui a geração de uma "Cápsula de Estado HBN" como última etapa antes do handoff, onde o orquestrador resume as decisões humanas informais tomadas na sessão corrente.

### 1 Alternativa
Manter o histórico do chat de orquestração em um arquivo de log estruturado append-only `.hbn/logs/orchestration-chat.json` e fazer com que o novo orquestrador consuma as últimas N interações desse JSON ao iniciar. O risco é poluir o contexto da nova janela com o mesmo ruído que causou a fadiga na janela anterior.

---

## 3. Ponteiro HBN

### Desenho

Para evitar a colagem repetitiva de trechos extensos de código no chat e reduzir o consumo de tokens de contexto, estende-se o ADR-021 e ADR-022 com a especificação do **Ponteiro HBN**. O ponteiro HBN é um formato curto e auto-localizável de hiperlink local que permite que IAs e editores naveguem e acessem o conteúdo exato sob demanda.

#### Formato Canônico:
`⛉ HBN [<file-basename>](file://<absolute-path-to-file>#L<start-line>-L<end-line>)`

#### Exemplo em uso (em chat ou markdown de proposta):
```markdown
O validador falha ao avaliar o staged diff conforme apontado em ⛉ HBN [assert-self-path.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-self-path.sh#L42-L55) devido a uma verificação de substring estrita.
```

#### Características de Resolução:
- **Resolução Humana (IDE/Desktop)**: Editores modernos (como VS Code, Cursor, terminal iTerm2) interpretam o protocolo `file://` nativamente como um link clicável que abre o arquivo na linha correta.
- **Resolução de Agente IA (Tooling)**: As IAs parceiras do protocolo identificam a sintaxe `⛉ HBN` e usam ferramentas como `view_file` passando o caminho absoluto extraído do link e as linhas do fragmento. Elas não precisam receber o código colado no chat; elas buscam na origem quando e se necessário.

### Por que funciona
A infraestrutura local é a única fonte de verdade. Ao invés de trafegar megabytes de logs e trechos de código em formato markdown plano pelo chat, os modelos passam apenas a referência geográfica do dado. A IA receptora lê direto do disco local por ferramentas de I/O, garantindo integridade e economizando largura de banda de tokens.

### Risco
**Inconsistência de Caminho Absoluto (Local Path Mismatch)**: Se o humano rodar a IA dentro de um container Docker, em uma VM ou se múltiplos humanos compartilharem o mesmo repositório com caminhos locais distintos (ex: `/Users/usuario1/Projetos` vs `/Users/usuario2/Projetos`), os links absolutos baseados em `file://` quebram para o destinatário.
* **Mitigação**: Definir uma variável de ambiente ou configuração global da raiz do projeto (`<RAIZ_CANONICA>`) e suportar a substituição dinâmica ou o uso de caminhos relativos à raiz do repositório no tooling de I/O dos agentes (ex: `⛉ HBN [assert-self-path.sh](file://{WORKSPACE}/guards/assert-self-path.sh#L42-L55)`).

### 1 Alternativa
Usar o formato de referência Git nativo (hashes + caminhos relativos), ex: `hbn:guards/assert-self-path.sh:42-55@e3c3508`. Embora seja robusto e independente do caminho local absoluto, ele perde a clickabilidade direta imediata em visualizadores markdown padrão e exige um parseador/extensão de IDE customizado para virar um link acionável pelo humano.

---

## 4. Relato de Estado antes de passar o bastão

### Desenho

Toda IA que encerra seu ciclo de execução e se prepara para passar o bastão deve obrigatoriamente produzir o **Relato de Estado do Bastão** (Baton State Report) no final de sua mensagem de handoff, consolidando as informações vitais da transição.

O Relato de Estado deve seguir o seguinte template padrão de seções:

```markdown
## ⛉ Relato de Estado do Bastão

- **STATE da Onda**: `onda_atual: 0177` | `proprietario_bastao: <proximo-modelo>` | `papel_bastao: <proximo-papel>`
- **Sinais HBN Vigentes**:
  - `🔵 HBN HANDOFF READY` - pronto para a próxima ação
  - `🟢 HBN CHECKPOINT CLEAN` - testes passando
- **Rastro de Execução (Action Trace)**:
  - **Realizado**: Correção do bug X em [fix.py](file://...) e execução da suíte de teste local.
  - **Pendente**: Auditoria cruzada do fix por Gemini 3.5.
- **Próxima Ação Requerida**: `<Texto idêntico ao campo proxima_acao do STATE.md>`
- **Ponteiros de Entrega (HBN Pointers)**:
  - ⛉ HBN [file.py](file:///Users/macbookpro/Projetos/usehbn/src/file.py#L1-L100) (código modificado)
  - ⛉ HBN [test_file.py](file:///Users/macbookpro/Projetos/usehbn/tests/test_file.py#L1-L20) (novos testes unitários)
```

O guard `guard-state-fresh.sh` (ADR-021) é atualizado para validar que a mensagem de handoff criada no commit contém o cabeçalho `## ⛉ Relato de Estado do Bastão` e que a `proxima_acao` descrita corresponde exatamente à gravada no `STATE.md`.

### Por que funciona
Evita a ambiguidade de retomada e o desalinhamento de expectativas entre a IA que sai e a que entra. O sucessor tem um sumário estruturado de "entrada de turno" que aponta precisamente para o STATE e para as alterações relevantes através de Ponteiros HBN clicáveis, minimizando o tempo necessário de análise pré-flight.

### Risco
**Falta de Sincronismo (Out of Sync Info)**: O modelo de IA pode gerar um Relato de Estado no corpo da mensagem markdown descrevendo uma próxima ação diferente da que ele efetivamente salvou no arquivo YAML de `STATE.md` por inconsistência interna do modelo.
* **Mitigação**: O guard de pre-commit `guard-state-fresh.sh` deve validar mecanicamente (via regex simples ou script python de parsing) se o texto sob a seção "Próxima Ação Requerida" do arquivo markdown é idêntico ao valor do campo `proxima_acao` no `STATE.md` staged. Se divergir, o commit é bloqueado.

### 1 Alternativa
Eliminar a descrição textual do relato de estado do corpo do arquivo markdown de handoff, deixando-a exclusivamente no arquivo estruturado `STATE.md`, instruindo a IA sucessora a extrair todas as informações diretamente do arquivo YAML estruturado. O risco é diminuir a legibilidade humana do handoff nas plataformas de chat ou Pull Requests que não renderizam o YAML como prosa fluida.

---

## Checklist anti-viés

* **B1. Li os artefatos diretamente?** Sim, fiz a leitura analítica e completa de todos os ADRs listados no contexto do projeto e nos perfis de modelos.
* **B2. Verifiquei as alegações de teste independentemente?** Não aplicável, esta é uma proposta conceitual/desenho arquitetural sem implementação imediata de código.
* **B3. Procurei razões para reprovar antes de aprovar?** Sim, explorei os limites físicos dos caminhos absolutos no Ponteiro HBN e as falhas operacionais em caso de API Down no comando `start`.
* **B4. Encontrei contradições?** A tensão entre a necessidade de automação de ritos de transição por CLI e a flexibilidade humana necessária para lidar com falhas de API foi abordada através da inclusão de travas bypassáveis por hearbacks.
* **B5. Alguma recomendação minha preserva minha utilidade/relevância?** Não. A proposta visa estruturar o ecossistema independente da IA selecionada, aplicando regras rígidas de barreira anti-groupthink e controle humano.

---

## Versão

- v1.0 — 2026-06-10 — antigravity-gemini (Google) — proposta inicial de desenho de evolução da orquestração.
