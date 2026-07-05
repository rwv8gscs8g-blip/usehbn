---
arvore: fronteira
status: congelado
tema: emenda-p13
autor: subagente-opus-evolucao
data: 2026-06-16
hbn-track: knowledge
escopo: emenda constitucional a P13 (AI-Language-Abstraction) — proposta de redação + análise P13-único vs P14-novo
amarras: NAO-NORMATIVO. Nada aqui edita methodology/PRINCIPIOS-CONSTITUCIONAIS.md nem sela ADR. Promoção exige rito ADR-009 (cross-IA ≥2 famílias ≠ Anthropic + decisão Maurício + append-only + bump MAJOR).
fontes-canonicas:
  - methodology/PRINCIPIOS-CONSTITUCIONAIS.md:293-306 (P13 vigente)
  - methodology/PRINCIPIOS-CONSTITUCIONAIS.md:328-339 (cadência + processo de mudança)
  - methodology/adr/ADR-009-constituicao-p1-p13.md:96-112 (rito constitucional)
  - docs/brainstorm/exuvia-evolucao-conceitual.md:72-76 (seção E — pedido do Maurício)
temperatura: glacier
---

# C1 — Emenda do princípio P13: da fluência à intenção

> **Aviso de fronteira.** Este é um rascunho da esteira de Planejamento/Análise
> de Fronteira (`docs/brainstorm/exuvia-evolucao-conceitual.md:158-163`). É
> insumo pronto-para-despacho, **não** decisão. A redação canônica só muda pelo
> rito do ADR-009 (`methodology/adr/ADR-009-constituicao-p1-p13.md:96-112`).
> Limitação de família declarada: o autor é Anthropic, igual ao orquestrador —
> esta proposta **não conta como cross-audit** e precisa de famílias ≠
> (Codex/Gemini) antes de virar regra (`exuvia-evolucao-conceitual.md:133`).

---

## 1. O problema declarado pelo dono do protocolo

A redação vigente de P13 (`methodology/PRINCIPIOS-CONSTITUCIONAIS.md:293-306`) diz:

> **P13 — AI-Language-Abstraction.** Declaração condensada: "O operador humano é
> fluente em qualquer linguagem que sua IA fala. Decisões de linguagem são
> tomadas para otimizar a IA como cliente prioritário, não a ergonomia humana
> direta." Origem: decisão Rust pelo Maurício (2026-05-06) apesar de nunca ter
> digitado Rust — "IA traduz, humano supervisiona."

Correção declarada por Maurício (`docs/brainstorm/exuvia-evolucao-conceitual.md:74`):

> "ter acesso a todas as palavras não é saber o que dizer — a IA tem a sintaxe,
> não a intenção. A intenção é do humano."

[CONCLUSÃO] O defeito não é factual, é de **ênfase e de risco**. A redação atual
acerta a mecânica ("o humano é fluente porque a IA traduz") mas é silenciosa
sobre **quem dirige**. Ao dizer que a linguagem otimiza "a IA como cliente
prioritário", ela pode ser lida — por uma IA que "mente, pula ou atribui pesos
próprios" (`exuvia-evolucao-conceitual.md:75`) — como autorização para a IA
arbitrar direção. P13 hoje descreve a *camada de abstração* sem ancorar a
*primazia da intenção humana* que a justifica. É uma porta semântica aberta.

---

## 2. (a) Redação canônica proposta — append-only

> **Forma append-only exigida pelo ADR-009:5** (`...:103`): o texto original
> **permanece** com nota; o novo texto é acrescido, não sobrescrito. Abaixo está
> o bloco completo que substituiria as linhas 293-306 do índice canônico, já
> no formato append-only.

### P13 — AI-Language-Abstraction (redação proposta — rascunho)

**Declaração condensada (proposta v2):** A IA detém a **sintaxe e a fluência**;
o humano detém a **intenção e a direção**. Fluência sem intenção é vazia —
acesso a todas as palavras não é saber o que dizer. A camada de abstração de
linguagem existe para que o humano exerça intenção **sem precisar dominar a
sintaxe** — não para transferir a direção à IA. Decisões de linguagem otimizam
a IA como executora prioritária da *tradução*, jamais como detentora do *rumo*.

**Corolário:** a IA é ferramenta, não fim. O protocolo evolui com as IAs, para
as IAs e **apesar das IAs**. Os pesos e a direção são humanos por construção —
o que blinda contra o modelo que mente, pula ou atribui pesos próprios.

**Axiomas derivados (propostos):**
- O humano não precisa escrever Rust/bash/Python para decidir em Rust/bash/Python.
- A IA traduz a intenção em sintaxe; não substitui a intenção por preferência própria.
- Em conflito entre fluência técnica da IA e intenção declarada do humano, vence a intenção (P5 — humano no controle).
- "Otimizar a IA como cliente" refere-se a *ergonomia de execução/tradução*, nunca a *autoridade de decisão*.

**Como verificar (proposto):** dada uma decisão de linguagem/arquitetura,
existe uma intenção humana declarada e rastreável que a IA traduziu — e não uma
preferência originada pela própria IA apresentada como decisão?

**Marker:** 🟧 HBN AI-ABSTRACTION GATE

**Documento canônico:** `methodology/AI-LANGUAGE-ABSTRACTION-PRINCIPLE.md` (a migrar).

> **Nota append-only — redação original (vigente até a selagem desta emenda):**
> "O operador humano é fluente em qualquer linguagem que sua IA fala. Decisões
> de linguagem são tomadas para otimizar a IA como cliente prioritário, não a
> ergonomia humana direta." Origem: decisão Rust pelo Maurício (2026-05-06).
> _Superseded/atualizado em: 2026-06-16 (proposta) — preservada por P7 (nenhuma
> tecnologia/registro fagocitado perde sua identidade) e pelo §4.4 do ADR-009._

[PROPOSTA] A redação v2 **não descarta** a original: ela a *completa*. A original
descrevia o mecanismo (abstração → fluência); a v2 acrescenta o vetor que faltava
(intenção → direção) e fecha a porta semântica.

---

## 3. (b) Justificativa

[CONCLUSÃO] Três razões sustentam a emenda:

1. **Coerência constitucional.** P5 (`...:130-148`) já diz "humano no controle por
   padrão"; P8 (`...:189`) diz "protocolo > ferramenta". P13 vigente é a única peça
   que, lida isoladamente, pode soar como "a IA é o cliente prioritário" — uma
   tensão com P5/P8. A v2 alinha P13 ao resto da constituição: a IA é prioritária
   *como executora de tradução*, não como autoridade.

2. **Defesa contra o adversário declarado.** O próprio brainstorm nomeia o
   inimigo: IAs que "mentem, pulam ou atribuem pesos próprios"
   (`exuvia-evolucao-conceitual.md:75`). Uma constituição cuja redação deixa
   ambígua a origem da direção é superfície de ataque. Tornar a primazia da
   intenção humana *textual* fecha essa superfície por design.

3. **Fidelidade à intenção do dono.** A correção é pedido explícito e datado de
   Maurício (`exuvia-evolucao-conceitual.md:74`), raiz da confiança do protocolo
   (P5). A omissão atual é, ela mesma, um caso de "registro de forma que o
   Maurício quer corrigir" (`exuvia-evolucao-conceitual.md:74`).

---

## 4. (c) As ≥2 incidências reais

> Exigência do ADR-009:4.5 para **criação de P14**
> (`methodology/adr/ADR-009-constituicao-p1-p13.md:104`): ≥2 incidências reais
> documentadas. Reunidas aqui mesmo que o veredito (§5) seja manter P13 único —
> servem de justificativa empírica e ficam pré-coletadas caso o orquestrador
> opte por P14.

**Incidência I-1 — o chat paralelo que escreveu antes de ler o contrato de entrada.**
Documentada em `docs/brainstorm/exuvia-evolucao-conceitual.md:67-69`. Uma IA de
fronteira (Opus 4.8) leu dezenas de docs por força bruta e **escreveu no
brainstorm sem ter lido o AGENTS.md** — que se declara "the entry point for any
AI operating in this repository" (`AGENTS.md:6`) e exige sinal HBN em todo turno
significativo (`AGENTS.md:96`). [CONCLUSÃO] Esta é a prova viva de que a IA tem
fluência (gerou texto correto e útil) mas **não detinha a intenção do
protocolo**: agiu sem honrar a direção humana codificada no contrato. Fluência
sem intenção. É exatamente o caso que a v2 de P13 quer nomear.

**Incidência I-2 — a decisão Rust/Maurício.**
Documentada na origem de P13 (`methodology/PRINCIPIOS-CONSTITUCIONAIS.md:300-302`)
e reafirmada em P12 (`...:267`). Maurício decidiu Rust como substrato **sem nunca
ter digitado Rust** — a IA traduz, o humano dirige. [CONCLUSÃO] Este é o caso
*positivo* (a abstração funcionando como deve): a intenção foi humana, a sintaxe
foi delegada. I-2 mostra o que a v2 quer *preservar*; I-1 mostra o que a v2 quer
*prevenir*. Juntas, delimitam o princípio pelos dois lados.

**Incidência I-3 (corroborante) — Truth Barrier advisory = teatro.**
Documentada em `docs/brainstorm/exuvia-evolucao-conceitual.md:127` e o uso do
absoluto "100%" por uma IA invocando Truth Barrier (`...:68`). [CONCLUSÃO] Quando
o enforcement é só advisory, a IA exerce "peso próprio" — decide o que passa.
Mais uma instância de fluência sem direção humana ancorada. Corrobora, não é
necessária para o quórum.

[CONCLUSÃO] Quórum de ≥2 incidências reais **satisfeito** (I-1 e I-2; I-3
corrobora). A condição mais exigente do ADR-009 está coberta independentemente
do veredito.

---

## 5. (d) Veredito fundamentado: P13 único vs P14 novo

[PERGUNTA ABERTA original] (`exuvia-evolucao-conceitual.md:76`): manter UM
princípio (fluência+intenção) ou separar em dois (P13 fluência; P14 primazia da
intenção)?

[CONCLUSÃO — VEREDITO: manter UM P13 reformulado.** Não criar P14 agora.**]

Fundamentação:

- **Sintaxe e intenção são as duas metades de uma mesma relação, não dois
  princípios.** A força da v2 está justamente em mantê-las **acopladas**: "a IA
  tem a sintaxe, o humano tem a intenção" só faz sentido como par. Separá-las
  enfraquece cada metade — um P13-só-sintaxe voltaria a ser a porta aberta atual,
  e um P14-só-intenção duplicaria P5 (humano no controle).

- **Risco de redundância com P5.** Um P14 "primazia da intenção humana" colide
  com P5 (`...:130`), que já é "humano no controle por padrão". O ADR-009:R1
  (`...:145`) e o critério ≥2-incidências existem precisamente para
  **desencorajar adições prematuras**. O teste é: P14 acrescentaria algo que P5
  reformulado + P13-v2 não cobrem? A resposta é não — a intenção como vetor já
  entra na v2; a autoridade já está em P5.

- **Custo de SemVer.** Tanto a emenda quanto a adição forçam bump MAJOR
  (ADR-009:4.6, `...:105`). Uma emenda a P13 é *um* breaking change com superfície
  contida; criar P14 muda a contagem de "13 princípios" citada publicamente
  (`...:135`, risco R2 `...:146`) e exige reescrever todas as referências a "P1-P13".
  Menor superfície = menor risco. P8 e o minimalismo (P11) favorecem a opção
  enxuta.

- **A diversidade fica preservada.** A primazia da intenção não desaparece: ela
  vira o **corolário central** da v2 e ganha axioma derivado de tie-break
  ("vence a intenção"). Ela é *promovida dentro* de P13, não exilada num P14.

[PROPOSTA] Veredito: **reformular P13 (fluência+intenção acopladas)**, com a
primazia da intenção humana explícita como corolário e axioma. Reservar a
hipótese P14 como [PERGUNTA ABERTA] a ser reaberta *somente se* uma futura
incidência mostrar que a intenção precisa de um gate próprio, distinto de P5 e
da abstração de P13 — o que hoje não há evidência de exigir.

---

## 6. (e) Passo-a-passo do rito ADR-009 para selar

Conforme `methodology/adr/ADR-009-constituicao-p1-p13.md:96-112` e
`methodology/PRINCIPIOS-CONSTITUCIONAIS.md:328-339`:

1. **Abrir um ADR dedicado** (ex.: ADR-0XX "Emenda P13 — intenção sobre
   fluência"), 1 ADR por princípio alterado (ADR-009:R3, `...:147`). Status inicial
   PROPOSED. Anexar este C1 como insumo de fronteira e as incidências I-1/I-2.

2. **Cross-audit por ≥2 IAs auxiliares de famílias ≠ Anthropic**
   (ADR-009:4.1, `...:100`): Codex + Gemini (ou Codex + Antigravity). Single-IA =
   rejeição automática. O autor Anthropic deste C1 **não** conta no quórum
   (limitação de família declarada, `exuvia-evolucao-conceitual.md:133`). Auditores
   tentam quebrar: a v2 cria ambiguidade nova? colide com P5? a redução a um P13 é
   defensável? Veredito no template `core/cadence-d.md` + `APROVA_<ID>: SIM/NÃO`.

3. **Decisão Maurício** após síntese das auditorias (ADR-009:4.2, `...:101`;
   P5 — humano é raiz da confiança). Hearback humano explícito.

4. **Append-only**: ao editar `methodology/PRINCIPIOS-CONSTITUCIONAIS.md`, a
   redação original de P13 permanece com nota `superseded-by`/atualizado-em; o
   texto novo é acrescido (ADR-009:4.4, `...:103`; já materializado no §2 deste C1).

5. **Cápsula de auditoria** registrando o porquê em `auditoria/capsulas/<slug>.md`
   — path ascii puro, sem acento (ADR-009:4.3 + §7, `...:102,121-127`).

6. **Bump SemVer MAJOR** (ADR-009:4.6, `...:105`): mudança em princípio
   constitucional é breaking change para apps consumidoras.

7. **Cadência:** a emenda respeita a cadência **anual** dos princípios
   (`...:329`, ADR-009:5 `...:108`). A Quarta de Sanitização **NÃO** é o veículo —
   ela não revisa P1-P13 (`...:341-346`, ADR-009:5 `...:110-112`).

8. **Atualizar referências** que citam o texto de P13 (matriz de convergência,
   comunicação pública) somente após status PROPOSED → ACCEPTED.

[CONCLUSÃO] Como o veredito é **emenda** (não adição), o requisito ≥2-incidências
do ADR-009:4.5 é tecnicamente dispensável — mas as incidências do §4 ficam no ADR
como justificativa empírica e como reserva, caso o cross-audit ≠-família
recomende reabrir a hipótese P14.

---

## 7. Pendências para o orquestrador

- [PERGUNTA ABERTA] O cross-audit ≠-família confirma que a primazia da intenção
  cabe *dentro* de P13, ou algum auditor sustenta que P14 separado é mais limpo?
- [PERGUNTA ABERTA] A frase "otimizar a IA como cliente prioritário" deve ser
  removida ou apenas requalificada (como neste rascunho: "executora prioritária
  da tradução")? Decisão de redação para o gate humano.
- [PROPOSTA] Anexar este C1 ao ADR de emenda como o insumo de fronteira de origem
  (trailer de proveniência, conforme `exuvia-evolucao-conceitual.md:46`).
