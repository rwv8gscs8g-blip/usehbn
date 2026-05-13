# O que é, afinal, este `usehbn`?

*Uma explicação no estilo Feynman — honesta, simples, e capaz de admitir quando não sabe.*

Cycle de auto-evolução: 2026-05-13 — Versão de protocolo: 0.3.0

---

## Capítulo 1 — Comece pelo fenômeno

Imagine que você está num laboratório e abre uma janela de terminal. Você digita uma frase em português, em inglês, ou em qualquer mistura, e dentro dela aparece a expressão `usehbn` (ou `use hbn`). A partir desse instante, algo muda. O computador não fica mais "respondendo o que parecer útil". Ele entra num **modo conversacional ritualizado**: pergunta o que você quer, repete de volta o que entendeu, marca o que vai fazer, registra o que fez, e dá um sinal claro de fim.

É só isso? Não. Mas é por aqui que se começa. Tudo o que o repositório `usehbn` constrói é desdobramento dessa ideia simples: **um gatilho semântico que organiza a conversa entre humano e máquina em camadas auditáveis**.

> "Não importa quão bonita seja sua teoria; se ela discorda do experimento, está errada." — Feynman, no espírito.

Daí a primeira regra deste documento: cada vez que eu disser "o HBN faz X", terá que haver, em algum lugar do repositório, um arquivo `.py` ou um teste que execute X. Onde o código não fizer, eu vou dizer **promessa de futuro** — e ponto. Sem maquiagem.

---

## Capítulo 2 — Os cinco gestos do protocolo

O HBN é um protocolo com cinco gestos básicos. Cada gesto tem um arquivo de código e ao menos um teste:

1) **Activation (gatilho)** — o código procura `use hbn` na frase. Se acha, liga; se não acha, fica dormindo. Está em [src/usehbn/trigger.py](src/usehbn/trigger.py) e é uma expressão regular de uma linha. Funcional. Testado.

2) **Intent (intenção estruturada)** — assim que liga, o sistema pega a frase crua e a transforma num objeto com campos: objetivo, restrições, riscos, validações esperadas. Está em [src/usehbn/protocol/intent.py](src/usehbn/protocol/intent.py). É **parcial**: extrai por padrões; falha em frases longas com várias cláusulas ou em domínios fora do inglês. Para o que faz, faz bem.

3) **Consent (consentimento explícito)** — antes de fazer qualquer coisa que pareça uma "contribuição" ao mundo, o HBN pergunta. A resposta vira um registro JSON local, com timestamp. Está em [src/usehbn/protocol/consent.py](src/usehbn/protocol/consent.py). Funcional, testado. Sem revogação automática — promessa de futuro.

4) **Truth Barrier (barreira da verdade)** — varre o texto produzido procurando sinais de excesso de confiança ("garanto", "certamente", "100% seguro") em contextos arriscados. **Não bloqueia**; apenas avisa. Está em [src/usehbn/protocol/truth_barrier.py](src/usehbn/protocol/truth_barrier.py). Parcial e *advisory*. A versão que bloqueia é tema da `RFC-0001 enforce mode`.

5) **Guardian (vigia)** — coleta os avisos da Barrier e de outros pontos do fluxo, grava em log local, sugere validação humana. Mesmo estado da Barrier: parcial, advisory.

Esse é o miolo. O resto do repositório, e este é o ponto, **gira em torno desses cinco gestos**.

---

## Capítulo 3 — A cebola: as camadas em volta

Para que esses cinco gestos sejam úteis fora de um terminal de brincadeira, o repositório cresceu várias cascas. Vou descrever cada uma com honestidade brutal sobre o estado real:

### 3.1 Readback / Hearback / ERP — o ciclo de feedback

Quando o HBN entende um pedido, ele escreve um **Readback**: "isto foi o que entendi". Em arquivos JSON, com schema validado em [schemas/readback.schema.json](schemas/readback.schema.json). Estado: **funcional**.

O humano lê e responde com um **Hearback**: "sim, é isso" ou "não, ajuste". Estado: **funcional**, bloqueia o próximo passo se não estiver confirmado.

Depois da execução, o sistema escreve um **ERP** (Execution Result Protocol). Estado: **funcional**. Schema em [schemas/result.schema.json](schemas/result.schema.json).

Por que isto importa? Porque sem esses três artefatos, o que aconteceu no diálogo desaparece. Com eles, qualquer auditor pode reler depois e julgar.

### 3.2 Relay / Baton / Handoff — a corrida de revezamento

Várias IAs (Claude, Codex, ChatGPT, Gemini…) podem trabalhar no mesmo repositório. Para evitar que duas escrevam ao mesmo tempo, há um **bastão** (`baton`) que só uma segura por vez. O **Relay** registra quem está com ele; o **Handoff** passa adiante com um sumário.

Estado: **funcional** (Onda 3 do v0.3.0). O bastão pode ficar "velho" (`baton_stale`) — o sistema apenas reporta; **não alerta automaticamente**. Promessa de futuro: alarme.

### 3.3 Connectors — quem traduz para "fora"

Existem conectores para tecnologias legadas: VBA, COBOL, Java, C#. Eles produzem **arquivos de scaffold**: `.bas`, `.cbl`, `.java`, `.cs` com cabeçalho "HBN bridge scaffold" e **nenhuma lógica funcional dentro**. Estado: **stub**. Os arquivos servem como ponto de partida para um humano preencher, não como bridge executável.

O `Universal Translator` em [src/usehbn/translation/universal.py](src/usehbn/translation/universal.py) é, hoje, um **roteador honesto**: detecta o ambiente (qual IDE, qual sistema operacional, qual idioma humano), escolhe o adapter certo, e devolve um contrato JSON. **Não traduz semanticamente** entre línguas humanas nem entre tecnologias. Estado: **scaffold**.

Aqui vale a regra Feynman: o nome promete o universo; o código entrega um mapa de fronteira. O documento [docs/PHAGOCYTOSIS.md](docs/PHAGOCYTOSIS.md) descreve o caminho de evolução. Hoje, **visão**.

### 3.4 State / Storage — a memória do sistema

O HBN guarda estado em `.usehbn/hbn-state.json` (canônico) e, por compatibilidade, ainda lê `state/hbn-state.json` (legado, read-only). Funcional. Sem compactação periódica — o arquivo cresce sem limite por design honesto. Promessa de futuro em v1.0.0.

### 3.5 Methodology / ADRs / Constitutional Principles

Em [methodology/](methodology/) vivem:

- **PRINCIPIOS-CONSTITUCIONAIS.md** — 13 princípios canônicos (P1–P13) que regem todo o protocolo;
- **MATURITY-MATRIX.md** — a tabela que diz qual componente é Implementado / Parcial / Scaffold / Stub / Visão. É a **fonte única de verdade** para qualquer afirmação pública sobre o que o HBN faz;
- **adr/** — Architecture Decision Records (atualmente 8 ACCEPTED, 2 NÃO_RATIFICAR).

Estado: **vivo e governando**. Cada release tem que reauditar a matriz; sem isso, não sai.

---

## Capítulo 4 — Formas de operação

Como uma pessoa de verdade usa este repositório? Há três modos. Não invente um quarto:

### 4.1 Modo terminal direto

1) Você instala via `pip install -e .` ou pelo bootstrap `./get-hbn`;
2) Roda `hbn run "use hbn para criar X"`;
3) O CLI dispara o ciclo: trigger → intent → consent → truth barrier → guardian → ERP;
4) Sai um JSON na tela. Você lê.

### 4.2 Modo adapter dentro de IDE/IA

1) Você roda `hbn init --runtime auto` num projeto;
2) O HBN detecta se você está em Claude Code, Codex, Cursor, Gemini, Antigravity, Copilot, ChatGPT — sete runtimes;
3) Instala um adapter para aquele runtime;
4) Daí em diante, qualquer interação que inclua "use hbn" passa pelo protocolo.

### 4.3 Modo orquestrado (multi-IA, com relay)

1) Várias IAs operam no mesmo repositório em janelas separadas;
2) O `hbn relay status` mostra quem tem o bastão;
3) `hbn handoff --to <agente> --summary "..."` passa o bastão;
4) Cada troca produz registro auditável em `.hbn/relay-archive/`.

**E o que não existe?** Computação distribuída real, agentes de fundo escondidos, deploy autônomo, verificação formal, garantia de privacidade absoluta. Todos esses são, hoje, **promessa de futuro** — e isto está escrito, sem disfarce, no `docs/ARCHITECTURE.md` na seção "Current Non-Goals".

---

## Capítulo 5 — O que é "software funcional testado", o que é "promessa de futuro"

Vou ser brutal e usar uma tabela. A fonte oficial é a Maturity Matrix; aqui está o resumo Feynman-style:

| Componente | Funcional? | Comentário em uma frase |
|---|---|---|
| Trigger (`use hbn`) | **SIM** | Regex de uma linha; funciona. |
| Intent | **PARCIAL** | Funciona em inglês simples; falha em frases longas / PT |
| Consent | **SIM** | Grava JSON; sem revogação automática |
| Readback / Hearback / ERP | **SIM** | Três schemas validados; ciclo fecha |
| Truth Barrier / Guardian | **PARCIAL (advisory)** | Avisa, não bloqueia |
| Relay / Baton / Handoff | **SIM** | Funciona em multi-repo; alarme de baton-stale é promessa |
| State (`.usehbn/`) | **SIM** | Cresce sem limite por design honesto |
| Schemas | **SIM** | Validador próprio simples |
| CLI (`hbn` ~17 comandos) | **SIM** | É um único arquivo de ~1700 linhas; refatorar é dívida assumida |
| Runtime Adapters (7 IAs) | **SIM** | Strings monolíticas geram corpo do adapter |
| Universal Translator | **SCAFFOLD** | Roteador, não tradutor |
| Connector resolver | **PARCIAL** | "Ativo" = arquivo presente |
| Connector lifecycle FSM | **SCAFFOLD** | 6 estados registrados; sem FSM |
| Connector verify | **STUB** | Não existe |
| Bridge generation (VBA, COBOL, Java, C#) | **STUB** | Gera scaffold sem lógica |
| Privacy Contract | **PARCIAL (declarativo)** | Filtra payload remoto; resto é promessa |
| Phagocytosis | **VISÃO** | Doutrina; sem código |
| Distribuição em PyPI | **PARCIAL** | Build local OK; PyPI ainda não |

Total: **124 testes verdes** (após Iter 0 do ciclo 2026-05-13). Era 114 antes.

---

## Capítulo 6 — Para que serve, na vida real?

A pergunta mais difícil. Eu diria assim, no espírito Feynman: **o `usehbn` é uma vacina contra o entusiasmo automatizado**. As IAs atuais respondem com confiança o que não sabem. O HBN força a aparecer, no diálogo, **três artefatos teimosos** — Intent, Readback, ERP — que tornam *visível* a parte do raciocínio que normalmente fica subentendida.

Daí três usos honestos hoje:

1) **Engenharia assistida com auditoria** — um time pequeno usa HBN para registrar o que pediu, o que a IA entendeu, e o que de fato saiu. Quando algo dá errado, há rastreamento;

2) **Coordenação multi-IA com bastão explícito** — projetos onde Claude, Codex, ChatGPT trabalham na mesma base. O relay/handoff evita pisar no pé;

3) **Conexão com sistemas legados como ponte humana** — os connectors VBA/COBOL/Java/C# são scaffolds para acelerar **conversas** com especialistas legados, não para gerar produção.

E três usos que **ainda não** servem (apesar do que algumas linhas otimistas de README possam sugerir em outras versões):

1) Tradução universal entre tecnologias;
2) Geração executável de bridges legados;
3) Garantia contratual de privacidade.

---

## Capítulo 7 — A correlação entre os braços

Por que catorze módulos? Porque o protocolo precisa **tocar a borda**. Cada gesto central tem braços, e cada braço encosta no mundo num lugar diferente:

```
       Activation
            │
            ▼
   ┌────  Intent  ────┐
   │        │         │
Consent   Truth      Guardian
   │     Barrier        │
   └────────┼───────────┘
            ▼
       Readback ───► Hearback ───► ERP
                                    │
                  ┌─────────────────┼─────────────────┐
                  ▼                 ▼                 ▼
              Relay/Baton     Connectors        State Store
                  │                 │                 │
              Handoff       Translation        Schemas
                                    │
                                  Site/Docs
```

O **Methodology** e os **ADRs** são o esqueleto governando tudo isto. O **Audit/Tooling** é o que olha para trás. E o novíssimo **Autoevolve** (este ciclo) é o que olha para a frente: orquestra microdeltas que aperfeiçoam cada braço sem desorganizar o resto.

---

## Capítulo 8 — A vitrine do software livre

Este repositório quer ser, antes de tudo, uma **vitrine honesta**. Software livre acumulou anos de promessa demais e entrega de menos. O HBN reage com uma postura: **toda capacidade afirmada precisa de evidência verificável no código.** A Maturity Matrix é o instrumento dessa postura. Se você puder ler este documento, abrir o repositório, rodar `pytest -q`, e confirmar tudo o que afirmei, então a vitrine funciona.

Se não puder, abra um *issue* e me diga onde menti. Eu corrijo. Esta é a única promessa firme.

---

*Documento gerado no Iter 1 do ciclo autoevolve 2026-05-13.*
*Fonte versionada: `docs/feynman/USEHBN-EXPLICADO.md`.*
*Saída final Word: `docs/feynman/USEHBN-EXPLICADO.docx`.*
