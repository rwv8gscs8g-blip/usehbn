---
titulo: "Codex orquestrador provisorio - saneamento, ponte e primeira exuvia"
tipo: proposal
status: congelado
temperatura: glacier
arvore: fronteira
path: .hbn/proposals/20260630-201952-codex-orquestrador-provisorio-saneamento-exuvia.md
created_at: "2026-06-30T20:19:52-03:00"
autoria: "codex (OpenAI) - orquestrador provisorio aprovado por Mauricio"
direcao_humana: "APROVO A PROPOSTA COM CODEX ORQUESTRADOR PROVISORIO"
---

# Codex orquestrador provisorio - saneamento, ponte e primeira exuvia

## 1. Decisao operacional

Mauricio aprovou usar o Codex como orquestrador provisorio de saneamento. A decisao vale para organizar a correcao da ponte, fechar a lacuna do orquestrador e preparar a primeira exuvia. Nao transforma o Codex em autoridade absoluta, auditor de si mesmo ou dono permanente do bastao.

Regra central: o problema corrigido aqui e o papel orquestrador com permissao excessiva, nao uma familia de IA isolada. Claude Opus fica suspenso do bastao enquanto a janela atual estiver degradada. Pode voltar como critico, auditor ou implementador curto, mas sem direito de repoint, delete, runner, STATE ou guards sem gates.

## 2. Posicao sobre Antigravity/Gemini como implementador

Usar Antigravity com Gemini como implementador e uma boa escolha para esta fase, por tres motivos:

1. Sai da familia OpenAI, reduzindo dependencia de Codex/Cursor para implementacao.
2. Permite que Codex entregue especificacoes, invariantes, testes esperados e pacote de rollback, enquanto outra familia materializa o patch.
3. Facilita auditoria cruzada real: se Gemini implementa, Codex pode revisar tecnicamente, mas a ratificacao formal deve vir de outra familia independente, preferencialmente xAI/Grok e/ou Anthropic/Claude em janela limpa.

Condicao: Gemini/Antigravity deve operar como implementador, nao como orquestrador livre. O output esperado e patch pequeno, testavel, com evidencias de comando e sem reescrever escopo. Implementador nao decide sozinho promover, deletar, mover modulo unico, alterar STATE ou selar.

Cursor pode implementar se for a via mais rapida, mas Cursor e Codex compartilham familia OpenAI para fins de independencia. Portanto, Cursor nao conta como auditor independente de Codex.

Jules pode ser incorporado quando houver fluxo GitHub/PR: papel recomendado = implementador/testador de PR, executor de CI e gerador de evidencias. Jules nao deve substituir gate humano nem auditoria de familia independente.

## 3. Matriz de papeis provisoria

| Papel | Ator preferencial | Pode fazer | Nao pode fazer |
|---|---|---|---|
| Humano gate | Mauricio | Aprovar escopo, resetar bastao, aceitar rollback, decidir corte de exuvia | Delegar gate critico implicito a uma IA |
| Orquestrador provisorio | Codex | Ler disco, consolidar auditorias, escrever proposta/prompt, ordenar ondas, definir invariantes e testes | Auto-ratificar, implementar e auditar o mesmo patch, apagar legado, pular gate |
| Implementador externo | Antigravity/Gemini | Aplicar patch especificado, adicionar testes, rodar verificacoes, devolver diff e evidencias | Mudar escopo, reclassificar risco, selar, repoint estrutural |
| Implementador rapido alternativo | Codex em janela separada ou Cursor | Implementar patch pequeno quando velocidade for critica | Contar como auditor independente de Codex |
| Auditor adversarial | Grok/xAI, Antigravity/Google se nao implementou, Claude em janela limpa | Tentar quebrar proposta, validar familias, checar rollback e guards | Corrigir proprio parecer sem registro |
| Testador GitHub | Jules | Abrir/atualizar PR, rodar CI, testar patch, comentar evidencias | Decidir governanca do protocolo |

Se Codex for tambem implementador, isso deve ocorrer em outra janela/acao, com contexto reduzido e prompt de implementador. O patch gerado passa a ser "implementacao OpenAI" e exige auditoria por familias nao OpenAI antes de selagem.

## 4. Tipo de raciocinio por papel

Orquestrador Codex:

- Modo: raciocinio alto / maximo, frio, adversarial, orientado a invariantes.
- Saida: decisoes, evidencias, comandos, limites e testes; nao expor raciocinio interno extenso.
- Pergunta permanente: "que acao perigosa ainda esta permitida mecanicamente?"
- Criterio de qualidade: reduzir ambiguidade para o implementador e tornar o rollback obvio.

Implementador Gemini/Antigravity:

- Modo: raciocinio alto para desenho do patch; precisao alta na edicao.
- Saida: patch pequeno, testes positivos/negativos, comandos rodados, arquivos tocados.
- Restricao: nao improvisar arquitetura; se o plano estiver insuficiente, parar e devolver lacuna.

Auditor Grok/Antigravity/Claude:

- Modo: raciocinio alto, adversarial, "procurar a burla".
- Saida: APROVA/REPROVA por criterio, com path:linha, familia declarada e divergencias.
- Restricao: nao confiar em texto de chat; ler disco.

## 5. Mecanismo de autocorrecao do protocolo

Autocorrecao aqui nao significa uma IA corrigir a regra que a bloqueia e se absolver. O protocolo se autocorrige quando uma falha vira:

1. Invariante explicito.
2. Guard ou teste executavel.
3. Caso adversarial que reproduz a falha.
4. Auditoria cruzada independente.
5. Gate humano.
6. Registro append-only no ledger.

O primeiro saneamento deve dogfoodar esse principio: os novos guards de orquestrador precisam bloquear exatamente a classe de falha vista nas ondas 0103-0105 e 0179-0183.

## 6. Sequencia segura e rapida

### H0 - Ponto de rollback e congelamento operacional

Antes de implementar qualquer guard:

- Capturar `git rev-parse HEAD` e `git status --short` em `usehbn` e `Credenciamento`.
- Criar tag de rollback nos commits atuais, por exemplo:
  - `hbn-rollback/pre-orq-saneamento-20260630`
  - `cred-rollback/pre-orq-saneamento-20260630`
- Registrar que tag protege somente conteudo commitado. Artefatos untracked relevantes devem ser commitados, rastreados em proposta, ou arquivados antes de qualquer exuvia.
- Rollback preferido: `git revert` dos commits da onda. `reset --hard` so com comando humano explicito.

### H1 - Selar o pacote de saneamento

Artefato: esta proposta + consolidacao das auditorias recentes.

Pronto quando:

- REGISTRY aponta para este artefato.
- Human gate confirma Codex como orquestrador provisorio.
- Auditores externos recebem prompt de validacao do desenho.

### H2 - Implementar nucleo minimo de guards do orquestrador

Ordem recomendada:

1. `G-STATE-STRUCTURAL`: qualquer mudanca estrutural de STATE exige quorum, mesmo com readback `entregue`.
2. `G-ORQ-XAUDIT-GATE`: acoes criticas exigem pareceres previos em disco.
3. `G-ORQ-NO-DELETE`: delete/move estrutural exige manifesto, sucessor, rollback e gate.
4. `G-ACTOR-WRITE-MATRIX`: papel define superficie de escrita.
5. `G-ORQ-FDACK`: receipt de leitura por hash antes de acao.
6. `G-ORQ-TRIPWIRE`: violacao suspende bastao ate reautorizacao humana.

Implementacao preferencial: Antigravity/Gemini.

### H3 - Auditoria retroativa da ponte

Escopo:

- usehbn: 0103, 0104, 0105.
- Credenciamento: 0179, 0180, 0181, 0183.

Resultado esperado:

- APROVA/REPROVA por onda.
- Separar "conteudo tecnicamente correto" de "rito insuficiente".
- Se uma onda for tecnicamente correta, ratificar retroativamente com ressalva.
- Se uma onda tiver perda de conhecimento ou ponteiro quebrado, abrir patch corretivo.

### H4 - Organizar a ponte Credenciamento

Objetivo:

- Preservar `.usehbn-snapshot/`.
- Reconciliar runner real com `CONSUMER-PROFILE.md`.
- Corrigir ponteiros vivos no `AGENTS.md`.
- Transformar `Credenciamento/usehbn/modules` e `Credenciamento/usehbn/methodology` em fonte de incorporacao ao protocolo, nunca em lixo.

### H5 - Primeira exuvia

Objetivo:

- Criar topologia limpa para o protocolo.
- Migrar por `git mv` e manifesto.
- Preservar conhecimento unico.
- Deixar `.hbn/active-version` e rollback claros.

Corte definitivo so depois de H2 e H3.

## 7. Prompt do orquestrador Codex provisorio

```text
Voce e o Codex atuando como ORQUESTRADOR PROVISORIO DE SANEAMENTO do protocolo HBN.

Modo: raciocinio alto, frio, adversarial, orientado a invariantes e evidencias em disco.

Missao:
1. Fechar a lacuna de permissao do orquestrador.
2. Organizar a ponte com o Credenciamento.
3. Preparar a primeira exuvia sem perda de conhecimento.
4. Coordenar implementadores externos, preferencialmente Antigravity/Gemini, e auditores independentes.

Limites:
- Nao auto-ratificar.
- Nao implementar e auditar o mesmo patch.
- Nao apagar ou mover conhecimento unico sem manifesto, sucessor, rollback, auditoria cruzada e gate humano.
- Nao tratar human gate como substituto de auditoria cruzada quando a acao for critica.
- Nao permitir que readback `entregue` altere STATE estrutural sem quorum.

Rito por onda:
1. Ler disco.
2. Declarar invariantes.
3. Produzir escopo minimo.
4. Definir rollback antes do patch.
5. Passar prompt de implementacao para uma IA implementadora.
6. Exigir patch pequeno + testes + evidencias.
7. Submeter a auditoria cruzada por familia independente.
8. Somente entao propor selagem ao humano.

Prioridade de implementacao:
1. G-STATE-STRUCTURAL.
2. G-ORQ-XAUDIT-GATE.
3. G-ORQ-NO-DELETE.
4. G-ACTOR-WRITE-MATRIX.
5. G-ORQ-FDACK.
6. G-ORQ-TRIPWIRE.

Rollback:
- Antes de qualquer implementacao, registrar HEAD e status.
- Criar tag de rollback nos repos afetados.
- Preferir git revert por onda.
- Reset destrutivo somente com autorizacao humana explicita.
```

## 8. Prompt para Antigravity/Gemini implementador

```text
Voce e Antigravity/Gemini atuando como IMPLEMENTADOR EXTERNO do saneamento HBN.

Familia: Google.
Papel: implementador, nao orquestrador, nao auditor final.
Modo: raciocinio alto, implementacao precisa, patch pequeno.

Leia primeiro:
- .hbn/proposals/20260630-201952-codex-orquestrador-provisorio-saneamento-exuvia.md
- .hbn/results/20260630-183809-antigravity-cross-ia-ponte-diagnostico-exuvia.md
- .hbn/results/20260630-193923-grok-cross-ia-ponte-diagnostico-exuvia.md
- .hbn/results/20260630-194338-codex-cross-ia-ponte-diagnostico-exuvia.md
- .hbn/results/20260630-194640-cursor-cross-ia-ponte-diagnostico-exuvia.md
- guards/hbn-guards-runner.sh
- guards/assert-quorum-selagem.sh
- guards/assert-orq-entrada-ref.sh
- guards/assert-auditor-id.sh
- core/orchestrator-profile-spec.md
- .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md

Tarefa inicial:
Implementar o menor patch possivel para bloquear a falha 0103-0105:
- criar guard G-STATE-STRUCTURAL ou equivalente;
- detectar mudancas estruturais em .hbn/relay/STATE.md;
- exigir evidencias de auditoria cruzada previa quando campos como proxima_acao, proximo_ponto, onda_atual, readback_ativo ou bastao forem alterados;
- adicionar testes positivos, negativos e adversariais;
- integrar ao runner sem alterar escopo nao relacionado.

Nao faca:
- nao mexa em Credenciamento nesta primeira tarefa;
- nao implemente todos os guards de uma vez;
- nao altere REGISTRY salvo se o rito local exigir para novo artefato;
- nao apague arquivos;
- nao mude STATE para fazer o teste passar.

Entrega esperada:
- lista de arquivos modificados;
- resumo do comportamento;
- comandos de teste rodados;
- casos que passam e casos que bloqueiam;
- lacunas ou duvidas bloqueantes.
```

## 9. Prompt para Jules/GitHub testador

```text
Voce e Jules atuando como implementador/testador vinculado ao GitHub.

Papel: criar PR ou validar PR de saneamento HBN.
Foco: testes, CI, evidencias e regressao.

Nao decidir governanca, nao selar, nao substituir auditoria cruzada e nao fazer merge sem gate humano.

Tarefa:
1. Rodar a suite de guards.
2. Rodar bateria adversarial existente.
3. Validar que o novo guard bloqueia repoint estrutural de STATE sem auditoria.
4. Validar que uma mudanca nao estrutural continua passando.
5. Publicar logs e conclusao no PR.
```

## 10. Criterio para seguir em ritmo avancado

Pode acelerar quando a onda for pequena, reversivel e testada. Nao pode acelerar quando envolver:

- STATE estrutural.
- runner de guards.
- delete ou move de massa.
- Credenciamento consumindo snapshot.
- exuvia/corte de arvore.
- selagem, freeze, tag ou rollback.

Para esses casos, velocidade vem de escopo pequeno e prompts precisos, nao de pular gate.
