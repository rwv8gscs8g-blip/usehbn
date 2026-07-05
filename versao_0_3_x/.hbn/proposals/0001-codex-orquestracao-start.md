---
tipo: proposta
status: congelado
data: 2026-06-10
autor: Codex (OpenAI)
path: .hbn/proposals/0001-codex-orquestracao-start.md
escopo: usehbn start + perfil do orquestrador + Ponteiro HBN + relato de estado
modo: audit-propose-only
relacionado:
  - methodology/adr/ADR-015-perfis-de-modelo.md
  - methodology/adr/ADR-018-papeis-chapeus-anti-groupthink.md
  - methodology/adr/ADR-021-documentos-auto-localizaveis.md
  - methodology/adr/ADR-022-saida-de-auditoria-legivel.md
  - core/relay-spec.md
  - core/roles-assignment-spec.md
  - .hbn/relay/STATE.md
temperatura: glacier
---

# Proposta 0001 — `usehbn start`, orquestrador reinicializável e Ponteiro HBN

## Identidade da proposta

Você é | Codex (OpenAI) |

Esta proposta não implementa comando, guard, runner, schema ou adoção. Ela
desenha uma evolução possível para reduzir fadiga do orquestrador
conversacional em orquestrações multi-IA, sem enfraquecer o gate humano nem
empilhar decisões em estado `proposed`.

O diagnóstico é simples: trabalhadores e auditores nascem em janela limpa,
mas o orquestrador que fala com o humano acumula contexto, julgamento,
preparação de prompts e auditoria de coerência. Quando essa janela satura,
a colagem manual de conteúdo tenta substituir o repositório como memória e
falha por truncamento. O antídoto deve ser compatível com Bastão 2.0: o chat
carrega ponteiros curtos; o disco carrega o contrato completo.

## Princípios usados

1) O humano continua como raiz de confiança ;
2) O STATE declara o presente, não o histórico ;
3) Perfil de modelo vem de `.hbn/models/*.json`, não de memória ;
4) Auditoria cruzada exige família diferente do implementador, salvo
   exceção explícita por hearback ;
5) O orquestrador pode ser reiniciado, mas não pode virar adotador automático ;
6) Toda entrega ao humano deve ser curta, acionável e apontar para o artefato
   completo no disco.

## 1) Comando `usehbn start`

### Desenho

`usehbn start` seria um comando declarativo de abertura de ciclo. Ele não
executaria trabalho de produto e não ativaria guard novo. Seu papel seria
preencher, validar e gravar a fotografia inicial da orquestração:

1) `elenco`: lista de IAs disponíveis no ciclo, por apelido de perfil
   ADR-015. Exemplo conceitual: `codex`, `fable-5`, `opus-4-8`,
   `gemini-3-5`, `jules` ;
2) `atribuicao`: bloco no STATE com `chapeu_atual`,
   `orquestrador_conversacional`, `desenvolvedores`, `auditores`,
   `consolidador`, `gravada_em` e `hearback_ref` quando houver exceção ;
3) `familias`: derivadas dos perfis, para validar que auditor de uma mudança
   não é da mesma família do desenvolvedor ;
4) `aptidao`: cada IA só pode receber chapéu listado em `papeis_aptos`.
   Atribuição fora de perfil exige `hearback_ref`, nunca passa silenciosa ;
5) `confirmacao_state`: o comando mostra ao humano a atribuição proposta em
   linguagem curta e grava no STATE somente após confirmação explícita ;
6) `proxima_acao`: uma ação atômica no STATE, já no formato de bastão.

O formato de gravação ficaria perto do que o STATE já contém, mas com o
orquestrador explícito:

```yaml
atribuicao:
  chapeu_atual: orquestrador-conversacional
  orquestrador_conversacional: codex
  desenvolvedores: [fable-5]
  auditores: [codex, gemini-3-5]
  consolidador: codex
  gravada_em: "2026-06-10T00:00:00-03:00"
  hearback_ref: null
```

Esse exemplo não é uma recomendação fixa de elenco; é só forma. Na prática,
o comando recusaria combinações incoerentes. Se `codex` for desenvolvedor,
um auditor OpenAI não pode auditar esse trabalho sem exceção humana. Se
`fable-5` for desenvolvedor, `opus-4-8` não deve entrar como auditor
mecânico sem `hearback_ref`, porque ambos são Anthropic.

Para adicionar IAs novas, como Jules, o caminho seria conservador:

1) criar `.hbn/models/jules.json` com `fornecedor`, `model_id`,
   `context_window_tokens` quando verificável, `handoff_threshold`,
   `papeis_aptos`, `modos`, `verificado` e `nao_verificado` ;
2) validar o perfil contra o schema de ADR-015 ;
3) só então permitir `usehbn start --add jules` ou equivalente ;
4) enquanto a aptidão não existir no perfil, Jules pode constar no elenco como
   `observador` ou `candidato`, mas não recebe chapéu operacional.

### Por que funciona

Funciona porque transforma a conversa inicial em estado verificável. O humano
continua decidindo, mas a decisão vira dado no STATE, e os perfis impedem que
o orquestrador invente capacidade de modelo no calor da sessão. O comando
também reduz divergência entre "papéis em prosa" e `atribuicao`, usando o
mesmo eixo já aceito por ADR-018 e `core/roles-assignment-spec.md`.

### Risco

O risco é o comando parecer mais autoritativo do que é. Se `usehbn start`
gravar demais, ele pode virar uma adoção disfarçada de proposta ou iniciar
uma onda antes do hearback. Por isso ele deve declarar escopo, elenco e
próxima ação, mas não rodar implementação, não abrir PR, não ativar runner e
não transformar `proposed` em `accepted`.

### Alternativa

A alternativa mínima é não criar comando e usar um template manual de
abertura de ciclo em `.hbn/messages/`. Isso preserva simplicidade agora, mas
mantém dependência de preenchimento humano/IA e deixa a validação de família
mais fácil de esquecer.

## 2) Perfil do orquestrador

### Desenho

Criar um artefato curto, versionado e reinicializável para o papel
`orquestrador-conversacional`. Ele seria um pré-prompt de retomada, não uma
memória infinita. O conteúdo não deveria narrar toda a história; deveria
dizer como a nova janela se comporta.

Nome possível:

`agents/orquestrador-conversacional.md`

Conteúdo proposto em termos humanos:

1) abrir com sinal HBN e declarar o chapéu atual ;
2) ler o STATE antes de julgar ou escrever ;
3) verificar no disco, não confiar em colagem de chat ;
4) quando houver auditoria, buscar divergência real, não convergência
   confortável ;
5) aplicar anti-groupthink por família antes de aceitar parecer ;
6) separar proposta, hearback e adoção ;
7) nunca empilhar item `proposed` sobre item `proposed` como se fosse base
   estável ;
8) preparar prompts curtos com Ponteiro HBN para os artefatos completos ;
9) entregar ao humano uma instrução operacional curta, com expectativa e
   fallback, seguindo L28 ;
10) se o contexto saturar, produzir relato de estado e passar o bastão para
    uma nova janela do mesmo papel.

Esse pré-prompt também deveria conter uma regra explícita de humildade
operacional: o orquestrador não "resolve" a decisão humana; ele organiza
evidência, aponta riscos e preserva reversibilidade.

### Por que funciona

Funciona porque desloca a continuidade do orquestrador para um contrato de
papel estável. Uma janela nova não precisa receber o histórico inteiro por
colagem; ela lê o perfil do papel, o STATE e os ponteiros dos artefatos
atuais. Isso preserva capacidade de contexto para julgamento, não para
arqueologia.

### Risco

O risco é o pré-prompt crescer até virar outro monólito. Se ele acumular
história, exceções e relatos de onda, reproduz o problema do relay antigo.
O arquivo deve conter comportamento permanente do papel, não o estado da
semana. Estado vive no STATE; histórico vive no archive; evidência vive nos
artefatos apontados.

### Alternativa

A alternativa é embutir esse contrato diretamente em `AGENTS.md`. Isso dá
visibilidade máxima, mas mistura regra geral do repositório com regra de um
chapéu específico. Eu prefiro arquivo próprio em `agents/`, referenciado pelo
STATE quando `chapeu_atual` for `orquestrador-conversacional`.

## 3) Ponteiro HBN

### Desenho

O Ponteiro HBN seria uma linha curta de handoff entre janelas. Ele não
substitui o artefato; ele leva a nova janela até o artefato completo no
disco, com link clicável em IDE e chat.

Formato proposto:

```markdown
🔗 HBN → [<titulo curto>](<path>) · path: <path> · sinal: <sinal HBN> · ação: <verbo curto>
```

Exemplo:

```markdown
🔗 HBN → [STATE atual](.hbn/relay/STATE.md) · path: .hbn/relay/STATE.md · sinal: 🔵 HBN HANDOFF READY · ação: ler antes de responder
```

Para ambientes que exigem caminho absoluto em link local, o emissor pode
usar:

```markdown
🔗 HBN → [STATE atual](/Users/macbookpro/Projetos/usehbn/.hbn/relay/STATE.md) · path: .hbn/relay/STATE.md · sinal: 🔵 HBN HANDOFF READY · ação: ler antes de responder
```

Regras:

1) o símbolo `🔗 HBN` identifica que a linha é ponteiro, não resumo ;
2) o link aponta para o arquivo completo no disco ;
3) `path:` repete o caminho canônico do artefato, alinhado ao espírito da
   ADR-021 ;
4) `sinal:` preserva o estado operacional sem explicar tudo ;
5) `ação:` diz o próximo gesto esperado, no espírito de L28 ;
6) o Ponteiro HBN pode aparecer em chat, handoff, prompt de auditoria ou
   relato de estado, mas não deve carregar conteúdo longo.

Como extensão da ADR-022, o Ponteiro HBN fecha o ciclo de legibilidade: o
parecer completo continua em markdown humano, e a passagem entre janelas usa
uma linha curta para chegar até ele. Como extensão de L28, ele evita o
anti-padrão "leia estes 7 documentos": a entrega vira um apontamento
acionável, com expectativa clara.

### Por que funciona

Funciona porque reduz tokens sem esconder evidência. A janela nova recebe o
menor texto possível e ainda assim consegue verificar a fonte no disco. Isso
combate truncamento de colagem e mantém a Truth Barrier: a prova não está no
resumo; está no artefato clicável.

### Risco

O risco é o ponteiro virar desculpa para não resumir nada. Uma linha de
ponteiro sem `ação:` pode transferir esforço demais para o receptor. Por isso
o formato precisa dizer o gesto esperado e o sinal operacional, não apenas o
arquivo.

### Alternativa

A alternativa é usar só `path:` no front-matter dos documentos e listar
caminhos ao final dos ciclos, como ADR-021/ADR-022 já propõem. Isso já ajuda,
mas não resolve a passagem curta entre janelas em chat, onde uma linha
clicável e autocontida economiza mais contexto.

## 4) Relato de estado antes de passar o bastão

### Desenho

Toda IA que passa o bastão deveria emitir um relato de estado em quatro
blocos curtos, preferencialmente no próprio handoff e em versão compacta no
chat:

1) `STATE lido`: data/hora do STATE, `proprietario_bastao`,
   `chapeu_atual`, `proxima_acao` e `handoff_mais_recente` ;
2) `Sinais`: lista curta dos sinais HBN ainda abertos, sem recontar a
   história ;
3) `Decisão pendente`: o que está `proposed`, o que está aceito e o que
   depende de hearback humano ;
4) `Próxima ação`: uma ação atômica, com Ponteiro HBN para o artefato que a
   próxima janela deve abrir primeiro.

Modelo compacto:

```markdown
🔵 HBN HANDOFF READY
STATE: .hbn/relay/STATE.md lido em <timestamp>; chapeu_atual=<papel>; proxima_acao="<frase curta>".
Sinais: <sinal 1>; <sinal 2>; <sinal 3>.
Pendente: <hearback/auditoria/decisão>, sem adoção automática.
Próxima ação: 🔗 HBN → [<artefato principal>](<path>) · path: <path> · sinal: <sinal> · ação: <verbo curto>
```

O relato não deve incluir código de produto nem copiar documentos longos.
Ele é um índice operacional, não o repositório em miniatura.

### Por que funciona

Funciona porque obriga a IA que está cansando a externalizar exatamente o que
uma janela limpa precisa saber: estado atual, sinais, pendência e próximo
gesto. A nova janela não depende de uma colagem longa nem de confiança no
resumo; ela começa lendo o arquivo indicado.

### Risco

O risco é o relato virar cerimonial repetitivo e perder precisão. Para evitar
isso, ele deve ser pequeno, limitado ao presente, e qualquer afirmação de
evidência deve apontar para arquivo ou comando. Se a IA não leu o STATE, ela
não pode dizer que está passando bastão limpo.

### Alternativa

A alternativa é exigir apenas atualização do STATE, sem relato no chat. Isso
é mecanicamente mais simples, mas piora a ergonomia do humano: o operador
perde a visão curta de por que o bastão está mudando e qual arquivo abrir.

## Fechamento proposto

Minha recomendação é tratar esta evolução em duas camadas:

1) camada documental primeiro: perfil do orquestrador, formato do Ponteiro
   HBN e template de relato de estado ;
2) camada mecânica depois: `usehbn start` gravando e validando `atribuicao`,
   com suporte a novos perfis como Jules.

Essa ordem preserva P1/P2/P10: primeiro torna o contrato legível e auditável;
depois automatiza a parte repetitiva. O ponto essencial é não confundir
reinicialização de janela com perda de responsabilidade. A janela nova pode
nascer limpa, mas o papel que ela veste precisa estar escrito, verificável e
limitado pelo humano.

## Resumo em 5 linhas

`usehbn start` deve declarar elenco, chapéus, aptidão e família no STATE, com confirmação humana.
O orquestrador precisa de pré-prompt reinicializável, curto e focado em comportamento, não em histórico.
O Ponteiro HBN leva uma janela limpa ao artefato completo no disco com uma linha clicável e acionável.
Toda passagem de bastão deve relatar STATE, sinais, pendência e próxima ação antes de sair.
Nada disso deve adotar automaticamente proposta, ativar guard ou substituir hearback humano.
