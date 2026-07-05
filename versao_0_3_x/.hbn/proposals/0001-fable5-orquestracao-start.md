---
titulo: "Proposta — usehbn start, perfil do orquestrador, Ponteiro HBN e relato de estado"
tipo: proposal
status: congelado
path: .hbn/proposals/0001-fable5-orquestracao-start.md
data: 2026-06-10
autoria: claude-fable-5 (Anthropic — janela limpa, propose-only)
hearback-status: pendente (nada aqui é adotado; nenhum guard, runner ou doc canônico foi tocado)
relacionado: [ADR-015, ADR-018, ADR-021, ADR-022, core/relay-spec.md, core/roles-assignment-spec.md, .hbn/knowledge/0002 (ex-L28), .hbn/models/*.json]
evidencia-motivadora: |
  O STATE atual (corrente E) mostra o padrão: trabalhadores e auditores nascem
  em janela limpa, mas a janela conversacional acumula leitura de disco,
  julgamento, consolidação e preparação de prompts — e é a única sem rito de
  reinicialização. A passagem por colagem trunca (baseline 0177: 238–393 KB
  para extrair ~20 linhas de presente). O relay-spec já resolveu isso para
  PROJETOS (STATE × LOG); falta resolver para o PAPEL orquestrador.
temperatura: glacier
---

# Proposta Fable-5 — orquestração que sobrevive à própria janela

## Tese da minha família

A corrente E provou duas coisas: (1) contrato checável vence memória de chat
(campo `atribuicao`, guards anti-teatro); (2) o que salvou cada retomada não
foi janela grande — foi o disco como fonte de verdade. Minha janela de 1M
tokens é exatamente o que NÃO deve virar arquitetura: se o desenho depende
de uma janela longa, ele quebra no primeiro modelo de janela curta (a lição
do ADR-015). Proponho, portanto, tratar o orquestrador como o relay-spec
tratou o INDEX: separar o que é CONTRATO (reinicializável, ≤1 página) do que
é HISTÓRICO (fica no disco, consulta sob demanda). Janela cheia deixa de ser
fadiga e vira handoff ordinário.

---

## 1. Comando `usehbn start` — o rito de elenco

### Desenho

`usehbn start` é um rito DECLARATIVO (fast_track de leitura + 1 artefato
proposed), não um orquestrador CLI — a orquestração por CLI permanece FUTURA
por decisão expressa (roles-assignment-spec §5). O que ele faz:

1. **Lê** `.hbn/models/*.json` e lista o elenco disponível com `fornecedor`
   e `papeis_aptos` (ADR-015).
2. **Recebe a atribuição** da sessão: quem veste conversacional/orquestrador,
   desenvolvedor(es), auditor(es) — só aceita apelido com perfil existente e
   papel constante em `papeis_aptos`; fora disso, exige `hearback_ref`.
3. **Valida o invariante anti-groupthink** localmente (mesma regra do
   `guards/assert-role-family.sh`, spec ADR-018): família(auditor) ≠
   família(implementador) é BLOQUEADOR; auditores homogêneos entre si é
   AVISO. O start NÃO edita o guard — aplica a mesma regra em modo
   informativo (knowledge 0021: sandbox informa, Terminal conclui).
4. **Grava a proposta de atribuição**: imprime o bloco `atribuicao` pronto
   (YAML do roles-assignment-spec §2) + a linha de papel novo
   `conversacional-orquestrador` para o STATE, e deposita um registro do
   elenco em `.hbn/relay/CAST-<data>.md` (proposed). **Quem comita é o
   humano** (knowledge 0003 — IA não dá `git add` no canônico).
5. **Confirmação no STATE**: a atribuição só VIGE quando o humano comita o
   STATE atualizado — o start produz, o hearback adota. Mesmo rito do
   relay-spec ("quem fecha onda atualiza o STATE no mesmo commit").

**IA nova (ex.: Jules/Google):** o start recusa apelido sem perfil e imprime
o esqueleto de `.hbn/models/jules.json` com tudo `null` + `nao_verificado`
preenchido — entrar no elenco é mudança T2 (perfil é normativo, ADR-015):
exige evidência citável + hearback. Memória de modelo não é evidência.
Jules entraria com `fornecedor: Google` — o que, aliás, IMEDIATAMENTE o
habilita como auditor de implementadores Anthropic/OpenAI pelo invariante.

### Por que funciona
Reusa três contratos já aceitos (perfil ADR-015, `atribuicao` ADR-018/spec
§2, rito de commit do relay-spec) em vez de criar fonte de verdade nova. O
start é só a CERIMÔNIA DE ENTRADA que hoje vive em prosa de chat.

### Risco
Scope creep: start virar orquestrador (disparar IAs, atribuir ondas) —
exatamente o que a spec §5 proíbe sem ADR próprio. Mitigação: o start
termina IMPRIMINDO; nunca executa nem comita.

### Alternativa
`cast.yaml` separado do STATE, referenciado por ele. Rejeito como principal:
segunda fonte de verdade para o mesmo dado (o §3 do roles-assignment-spec já
recusou tabela paralela pelo mesmo motivo).

---

## 2. Perfil do orquestrador — contrato reinicializável

### Desenho

Novo template em `agents/role-templates.md` (ou arquivo irmão
`agents/orchestrator-profile.md`), ≤1 página, que captura o papel
`conversacional-orquestrador` como CONTRATO, no padrão dos papéis
existentes. Cláusulas:

1. **Verificar no disco antes de afirmar** — Truth Barrier: nenhum veredito
   por memória de chat; todo julgamento cita arquivo:linha ou comando+saída.
2. **Auditoria cruzada, nunca auto-auditoria** — respeita ADR-018; o
   orquestrador prepara prompts de auditoria mas não audita a própria
   família sem `hearback_ref`.
3. **Julgamento honesto** — vereditos no vocabulário da cadência D
   (BLOQUEADOR/FORTE/MARGINAL), formato ADR-022 (markdown legível, resumo
   ≤10 linhas), incluindo contra o próprio trabalho.
4. **Humano no controle** — toda adoção passa por hearback commitado
   (ADR-023); entrega operacional minimalista (knowledge 0002/ex-L28):
   comando único + expectativa + fallback.
5. **Nunca empilhar proposed** — antes de abrir frente nova, fechar (ou
   declarar explicitamente pendente no STATE) a anterior; o STATE lista
   sinais abertos, não esconde.
6. **Cláusula de mortalidade** — ao atingir o `handoff_threshold` do perfil
   ativo (ADR-015) ou sinais da knowledge 0017: parar, executar o Relato de
   Estado (§4 desta proposta) e passar o bastão. Continuar degradado é
   violação de contrato, não dedicação.

**Reinicialização**: janela nova lê, nesta ordem: (1) este perfil; (2) a
read-list canônica do relay-spec (STATE → handoff → readback → template do
papel → 0022-firewall). O perfil entra como item 4-bis quando
`chapeu_atual: conversacional-orquestrador`. Custo: ~1 página além dos
21,6 KB já especificados.

### Por que funciona
É o mesmo movimento STATE × LOG aplicado ao papel: o contrato é pequeno e
estável (referencia a doutrina, não a copia — evita drift); o histórico fica
no relay/archive. A janela deixa de ser o ativo; o disco é o ativo.

### Risco
Perfil que COPIA doutrina envelhece e mente. Mitigação: cláusulas só por
referência (ADR-x, knowledge-x); o perfil tem `revisar-em` como as
knowledges.

### Alternativa
Rotação preventiva por contagem de ondas (orquestrador troca a cada N
ondas, cheio ou não). Mais simples, porém desperdiça janela boa e não
resolve a retomada — o perfil continua necessário; a rotação pode ser
política complementar, não substituta.

---

## 3. Ponteiro HBN — handoff curto com link clicável

### Desenho

Formato de 3 linhas para QUALQUER passagem de conteúdo entre janelas (chat,
IDE, prompt), substituindo colagem de artefato inteiro:

```
⟦HBN⟧ proposal 0001 · orquestracao-start · PROPOSED
path: .hbn/proposals/0001-fable5-orquestracao-start.md
↳ [abrir](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/0001-fable5-orquestracao-start.md) — 1 frase do que é e o que se espera do leitor.
```

Regras: (a) linha 1 = símbolo `⟦HBN⟧` + tipo + número + temperatura/status —
grepável; (b) linha 2 = `path:` canônico relativo à raiz (a MESMA string do
front-matter ADR-021 — verificável por diff, e o G-SLF já vigia esse campo);
(c) linha 3 = link absoluto `file://` (clicável em IDE e na maioria dos
chats desktop) + 1 frase acionável (knowledge 0002: instrução única,
expectativa embutida). O ponteiro é GERADO lendo o disco DEPOIS de escrever
o arquivo — nunca digitado de memória.

### Por que funciona
Colagem trunca; ponteiro não. O destinatário em janela limpa lê o artefato
INTEIRO do disco (capacidade máxima dele) em vez de receber o que coube na
colagem (capacidade residual de quem cola). Três linhas custam ~50 tokens
contra KBs; e a dupla declaração (path relativo + link absoluto) cobre os
dois mundos: o relativo é canônico e portável, o absoluto é clicável.

### Risco
Ponteiro errado é pior que colagem (ADR-021: path errado manda o leitor com
confiança ao lugar errado). Mitigação: regra "gerado do disco, nunca de
memória" + o path da linha 2 ser idêntico ao `path:` do front-matter do
destino (checagem trivial de guard futuro, sem tocar nos atuais).

### Alternativa
Ponteiro só-ID (`⟦HBN⟧ 0001`) resolvido via grep no REGISTRY. Mais curto e
imune a path absoluto de máquina, porém exige um passo de resolução e não é
clicável — serve como forma degradada quando o absoluto não se aplica
(ex.: handoff entre máquinas diferentes).

---

## 4. Relato de Estado — o que toda IA imprime antes do bastão

### Desenho

Bloco final obrigatório de TODA sessão (qualquer chapéu), ≤10 linhas
(ADR-022), impresso no chat E refletido no STATE no mesmo movimento:

```
RELATO DE ESTADO — <apelido> · <chapeu_atual> · <data-hora>
STATE: <onda_atual> · bastão → <próximo dono> · contexto ~<n>% do threshold
SINAIS: <abertos novos/fechados nesta sessão; os demais permanecem no STATE>
FEITO: <1 linha — o entregável da sessão, com status proposed/adotado>
PATHS: <1 linha por caminho criado/alterado, formato Ponteiro HBN (§3)>
PRÓXIMA AÇÃO: <atômica, executável por quem recebe — vai para proxima_acao>
PARA O HUMANO: <comando único + expectativa + fallback (knowledge 0002)>
```

Cada linha deriva de LER o STATE recém-atualizado do disco (dogfood) — não
da memória da sessão. O `guard-state-fresh.sh` (spec do relay-spec) já
recusa handoff sem `proxima_acao` nova; o Relato é a face humana do mesmo
contrato.

### Por que funciona
Hoje o fim de sessão bom existe (handoffs da corrente E terminam listando
caminhos — ADR-022 Decisão 3), mas é prática, não forma fixa. Forma fixa
de 7 linhas torna a omissão VISÍVEL (faltou linha = relato incompleto) e dá
ao guard e ao humano o mesmo objeto para conferir.

### Risco
Virar teatro: copiar o template sem ler o disco. Mitigação: a linha STATE
deve citar valor que SÓ existe no arquivo pós-atualização (ex.: o
`ultima_atualizacao` exato) — divergência denuncia relato de memória.

### Alternativa
Só o readback JSON, sem relato humano. Rejeito: inverte o ADR-022 (humano
vira parser); o JSON pode existir como anexo derivado, nunca como entrega.

---

## Resumo para humano (≤10 linhas, ADR-022)

1. `usehbn start` = cerimônia de entrada: lê perfis, valida anti-groupthink,
   IMPRIME o bloco `atribuicao` + CAST proposed; humano comita. Não orquestra.
2. IA nova (Jules) entra por perfil T2 com evidência — o start só recusa e
   imprime o esqueleto.
3. Orquestrador vira papel com contrato de 1 página, reinicializável pela
   read-list canônica + cláusula de mortalidade (threshold ADR-015).
4. Ponteiro HBN: 3 linhas (símbolo+id / path canônico / link file:// + 1
   frase), gerado do disco — colagem de artefato vira exceção.
5. Relato de Estado: 7 linhas fixas antes de todo bastão, derivadas do STATE
   pós-atualização. Tudo aqui é PROPOSED; nada foi adotado nem tocado.
