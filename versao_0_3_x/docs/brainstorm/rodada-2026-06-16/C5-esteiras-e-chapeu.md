---
arvore: fronteira
status: congelado
tema: esteiras-e-chapeu
autor: subagente-opus-evolucao
data: 2026-06-16
familia: Anthropic
relacionado:
  - core/roles-assignment-spec.md
  - core/cadence-d.md
  - core/start-rite-spec.md
  - methodology/adr/ADR-015-perfis-de-modelo.md
  - schemas/model-profile.schema.json
  - agents/role-templates.md
  - docs/brainstorm/exuvia-evolucao-conceitual.md (seções N, P)
temperatura: glacier
---

# C5 — As duas esteiras e o chapéu do chat paralelo

Formalização (em PROPOSTA, não-normativa) do modelo das **duas esteiras** e do
**chapéu** `analista-de-fronteira`. Tudo aqui é Fronteira: nada vige sem
cross-audit ≠-família + gate humano + selagem por onda formal. Truth Barrier:
afirmações materiais citam `arquivo:linha`.

---

## 0. Contexto e nomenclatura (recapitulação verificada)

- [CONCLUSÃO] As duas esteiras já estão **nomeadas e esboçadas** no brainstorm
  (`docs/brainstorm/exuvia-evolucao-conceitual.md:158-163`, seção P). Esta peça
  só as **formaliza no estilo de contrato/perfil**, conforme as regras do
  protocolo. O conceito de "árvores" (Fronteira/Intermediária/Estável) é o
  sistema de coordenadas comum às duas esteiras (mesma fonte, `:149`).
- [CONCLUSÃO] **Esteira de Orquestração/Produção** opera na **Intermediária**
  (provado, com enforcement): Opus orquestra → Codex implementa →
  Gemini/Cursor/Grok/Antigravity cross-auditam → gate humano (Maurício) →
  guards selam (`exuvia-...:160`). É a esteira que produziu o 0029.
- [CONCLUSÃO] **Esteira de Planejamento/Análise de Fronteira** (o chat paralelo)
  opera na **Fronteira** (não-normativo): lê + sintetiza + entrevista + propõe +
  roda exploração cross-IA; entrega pacotes maturados ao orquestrador
  (`exuvia-...:161`).

---

## (a) Contrato do papel `analista-de-fronteira`

[PROPOSTA → candidato a `agents/role-templates.md`; estilo dos §T1–§T3 já vigentes]

> **Nota de estilo:** os templates atuais (`agents/role-templates.md:40-108`)
> são *prompts de entrada* parametrizados pelo STATE. Abaixo está o contrato no
> mesmo molde — bloco de prompt + read-list — para encaixar como um futuro
> **§T4** SE e SOMENTE SE promovido por onda formal.

```
## §T4 — ANALISTA DE FRONTEIRA (não-executante, não-auditor)

Você está em chat NOVO, sem memória. Você é ANALISTA DE FRONTEIRA: opera na
árvore Fronteira (não-normativa). Você NÃO segura o bastão, NÃO implementa,
NÃO conta como auditoria cruzada e NÃO toca caminho selado.
Raiz canônica: <RAIZ_CANONICA>.

Leitura: LIVRE em todo o repo (read-only). Recomendado começar pelo contrato
de entrada (AGENTS.md), depois STATE e a entrada de brainstorm em curso.

Contrato do papel:
- ESCRITA permitida SOMENTE em docs/brainstorm/ (zona Fronteira, fora do
  scope-lock — exuvia-evolucao-conceitual.md:15). NENHUM write fora disso.
- NÃO escreve em core/, agents/, .hbn/, guards/, src/, schemas/,
  methodology/ (só leitura). NÃO comita caminho selado.
- NÃO segura o bastão: não atualiza o STATE, não fecha onda, não faz handoff.
- NÃO conta como cross-audit: família Anthropic = mesma do orquestrador Opus;
  uma análise sua NUNCA satisfaz o requisito de auditoria ≠-família
  (roles-assignment-spec.md:44-49). Suas saídas SÃO insumo a ser auditado.
- NÃO roda git nem guards (guards informam no sandbox; Terminal conclui —
  start-rite-spec.md:40).
- Marca cada ponto [CONCLUSÃO]/[PROPOSTA]/[PERGUNTA ABERTA] e cita
  arquivo:linha (Truth Barrier) — convenção do brainstorm
  (exuvia-evolucao-conceitual.md:11-13).
- Saída: pacote maturado (proposta + pré-auditoria + síntese cross-IA)
  entregue ao orquestrador; nada vira regra sem passar o portão (item c).
```

[CONCLUSÃO] Diferença essencial frente aos papéis existentes: os §T1–§T3
**seguram o bastão ou produzem veredito de auditoria** (cadence-d.md:18-26). O
`analista-de-fronteira` faz **nenhum dos dois** — é um papel de *leitura ampla +
escrita confinada*, deliberadamente sem poder normativo. É o análogo formal do
"plasmídeo" do brainstorm: rápido, lateral, descartável, sem acesso ao
cromossomo (`exuvia-...:45-46`).

---

## (b) Esqueleto do perfil `.hbn/models/<apelido>.json`

[PROPOSTA] Apelido sugerido: **`opus-4-8-fronteira`** (distingue do `opus-4-8`
já existente, que é auditor/orquestrador — `.hbn/models/opus-4-8.json:8`). O
sufixo nomeia a *função na esteira*, não o modelo, evitando colisão de TOKEN
EXATO do G-NUM (start-rite-spec.md:106-112).

```json
{
  "profile_version": 1,
  "model_id": "claude-opus-4-8",
  "apelido": "opus-4-8-fronteira",
  "fornecedor": "Anthropic",
  "context_window_tokens": null,
  "handoff_threshold": 0.5,
  "hearback_ref": null,
  "papeis_aptos": ["analista-de-fronteira"],
  "modos": [],
  "verificado": {
    "papeis_aptos": "<PREENCHER na promoção: hearback que cita esta entrada de brainstorm como evidência da formalização do papel>"
  },
  "nao_verificado": [
    "context_window_tokens",
    "modos disponíveis",
    "aptidão como implementador/auditor sob este protocolo (papel é deliberadamente não-executante e não-auditor)"
  ],
  "observacoes": "Mesmo modelo de base que opus-4-8, MAS chapéu distinto: nao-executante, nao-auditor, escrita confinada a docs/brainstorm/. Por ser Anthropic, NUNCA satisfaz cross-audit (roles-assignment-spec.md:44-49). Saidas sao Fronteira/nao-normativas por construcao.",
  "ultima_revisao": "2026-06-16",
  "status": "proposed",
  "temperatura": "quente"
}
```

[CONCLUSÃO — bloqueador de promoção, honesto] O perfil acima **NÃO valida hoje**
contra `schemas/model-profile.schema.json`: o enum de `papeis_aptos`
(`schemas/model-profile.schema.json:57-64`) é fechado em
`[implementador, auditor-cruzado, auditor-arquiteto, consolidador]`. Adicionar
`analista-de-fronteira` exige **editar o schema** — que é T2 (mudança normativa,
ADR-015 tier `:12`). [PERGUNTA ABERTA] O `analista-de-fronteira` deve entrar no
enum do schema (virando papel de primeira classe) ou ficar FORA do schema de
perfis, vivendo só como contrato textual + insumo externo (a alternativa do
`exuvia-...:134`)? Isto é decisão do orquestrador + hearback, não deste chat.

---

## (c) Conexão das duas esteiras: o portão Fronteira→Intermediária

[PROPOSTA] As esteiras **não são ad hoc**: são os modos de operação das árvores
(`exuvia-...:162`). A interface entre elas é exatamente o **portão de promoção
Fronteira→Intermediária**.

```
ESTEIRA DE PLANEJAMENTO (Fronteira, não-normativa)
  analista-de-fronteira: lê (livre) → sintetiza → entrevista cross-IA
  → produz PACOTE maturado em docs/brainstorm/
                         │
                         ▼
            ╔═══════ PORTÃO Fronteira → Intermediária ═══════╗
            ║ 1. cross-audit ≠-família (Codex/Gemini/Cursor/  ║
            ║    Grok) — invariante anti-groupthink            ║
            ║    (roles-assignment-spec.md:44-49)              ║
            ║ 2. gate humano (Maurício) — hearback             ║
            ║    (cadence-d.md:25-26; start-rite §2.5 :47-49)  ║
            ║ 3. despacho do orquestrador (abre a onda)        ║
            ╚══════════════════════════════════════════════════╝
                         │
                         ▼
ESTEIRA DE ORQUESTRAÇÃO/PRODUÇÃO (Intermediária, com enforcement)
  Opus orquestra → Codex implementa → famílias ≠ auditam
  → gate humano → guards selam → onda selada
```

- [CONCLUSÃO] O portão **reusa máquina já provada**, não inventa: fagocitose
  (routed→studied→digested→mastered→contributed) + 8 critérios + Fitness Gate
  ≈ Fronteira→Intermediária→Estável (`exuvia-...:122`). A promoção é a
  fagocitose aplicada ao próprio protocolo.
- [CONCLUSÃO] **A membrana é o ponto crítico de segurança**, não a zona livre. A
  zona livre PODE alucinar (por design não tem amarra); a segurança está em o
  *gate de promoção* ser forte (`exuvia-...:46,49`). Por isso o portão impõe os
  três passos acima — nenhum opcional. Em particular, o passo (1) é o que impede
  o "contrabando" plasmídeo→cromossomo (`exuvia-...:46`).
- [PROPOSTA] **Trailer de proveniência** na onda selada que nasce de um pacote de
  fronteira: a spec/ADR resultante aponta de volta para a entrada de brainstorm
  e a(s) família(s) que a geraram (`exuvia-...:46`). Sem isso, o portão não fecha
  a rastreabilidade.

---

## (d) Passo formal para "citar" o chapéu no protocolo (T2, não auto-instalável)

[CONCLUSÃO] Entrar no elenco é mudança **T2** — exige **evidência citável +
hearback**; memória de modelo NÃO é evidência (ADR-015 `:71-73`;
start-rite-spec.md:58-61). O chapéu **não é auto-instalável**: o invariante
S1 (anti-auto-emenda) significa que o próprio analista-de-fronteira **não pode**
criar seu perfil, editar o schema, nem se inscrever no STATE. Ele só **propõe**
(este arquivo); quem instala é o orquestrador + gate humano.

[PROPOSTA] Sequência formal para citar/instalar o chapéu:

1. **Proposta de fronteira** (este arquivo) — não-normativa, na Fronteira.
   *Status atual: aqui.*
2. **Cross-audit ≠-família** do pacote (Codex/Gemini/Cursor/Grok) — porque o
   autor é Anthropic, igual ao orquestrador (item e). Veredito no template
   cadence-d (`cadence-d.md:66-72`) + `APROVA_<ID>: SIM/NÃO`.
3. **Decisão do orquestrador + hearback humano** (Maurício) — o gate que
   autoriza T2 (ADR-015 `:8,71-73`).
4. **Onda formal de instalação** (não este chat) que, no MESMO commit:
   - cria `.hbn/models/opus-4-8-fronteira.json` (item b);
   - **decide e aplica** a questão do schema (item b, pergunta aberta):
     adicionar `analista-de-fronteira` ao enum OU mantê-lo fora do schema;
   - adiciona o §T4 a `agents/role-templates.md` (item a);
   - registra o trailer de proveniência apontando para esta entrada;
   - eventualmente reflete o papel em `core/roles-assignment-spec.md`
     (campo `chapeu_atual`/`atribuicao` — `:25-32`) **se** o papel for citável
     no STATE.
5. **Adoção via STATE commitado**: o papel só VIGE quando commitado (start-rite
   §2.5 `:47-49`; "a atribuição só VIGE commitada").

[CONCLUSÃO] O `usehbn start` **imprime, não instala** (start-rite-spec.md:19-28).
Para uma IA nova sem perfil, o rito RECUSA e imprime o esqueleto com campos
`null` (start-rite-spec.md:58-61) — exatamente o que (b) fornece pronto. Logo o
caminho de instalação é: este chat propõe → start imprime o esqueleto → onda
formal preenche com hearback. Em nenhum ponto o analista se auto-instala.

---

## (e) Mitigação honesta do laço Anthropic-sobre-Anthropic

[CONCLUSÃO] O chat paralelo é **Anthropic — mesma família do orquestrador Opus**
(`exuvia-...:133`). Pelo invariante anti-groupthink, auditoria cruzada de mesma
família é "groupthink estrutural" e é **BLOQUEADOR** sem hearback explícito
(`roles-assignment-spec.md:44-49`). Honestidade técnica do protocolo: chat novo
reduz mas **não elimina** viés de mesma família de pesos (`cadence-d.md:32-33`).

[CONCLUSÃO] Consequência inegociável de desenho — o chapéu **deve ser
não-auditor**:

- o analista-de-fronteira **não conta como cross-audit** (item a). Uma análise
  sua NUNCA satisfaz o passo (1) do portão (item c).
- toda saída do analista é **Fronteira/não-normativa** e **precisa** passar por
  auditoria adversarial de famílias **≠** (Codex/Gemini/Cursor/Grok) antes de
  virar regra (`exuvia-...:133`). Esta limitação é parte do desenho, não defeito.

[PROPOSTA] Mitigações concretas, em camadas (do estrutural ao operacional):

1. **Confinamento de escrita** (item a): o analista só escreve em
   `docs/brainstorm/` — não pode tocar `core/`, guards, schema. O laço
   Anthropic→Anthropic fica preso na Fronteira; não atravessa a membrana sem
   família ≠.
2. **Portão obrigatório ≠-família** (item c, passo 1): a promoção exige cross-
   audit de fornecedor ≠ Anthropic. O guard `assert-role-family.sh` é a trava
   mecânica (`roles-assignment-spec.md:44`).
3. **Diversidade de cepas** contra convergência prematura: além de *auditar*,
   abrir proposta para que cada família ≠ contribua sua **visão própria divergente**
   (`exuvia-...:172-174`), premiando divergência — o equivalente a manter
   diversidade de cepas (`exuvia-...:59`).
4. **Trailer de proveniência por família** (item c): tornar visível qual família
   gerou cada ideia, para o gate checar que uma proposta não "nasceu e morreu
   numa só família" (`exuvia-...:47`).

[PERGUNTA ABERTA] O orquestrador aceita o papel não-executante/não-auditor
formalizado, ou prefere o chat paralelo **totalmente fora do elenco** (sem
perfil), com saídas tratadas apenas como "insumo externo" citado nos despachos
(`exuvia-...:134`)? As duas opções são coerentes com o protocolo; a escolha é
do gate humano + orquestrador. Este chat, por S1, não decide.

---

## Resumo dos marcadores

- [CONCLUSÃO] As esteiras já existiam nomeadas (seção P); aqui ganham contrato,
  perfil e portão formais.
- [PROPOSTA] §T4 `analista-de-fronteira`; perfil `opus-4-8-fronteira.json`;
  portão Fronteira→Intermediária = cross-audit ≠-família + hearback + despacho.
- [BLOQUEADOR DE PROMOÇÃO] O schema de perfis tem enum fechado: instalar o papel
  exige decidir schema (T2).
- [PERGUNTA ABERTA] papel-de-primeira-classe (entra no enum/STATE) vs. insumo
  externo fora do elenco — decisão do orquestrador + gate humano.
