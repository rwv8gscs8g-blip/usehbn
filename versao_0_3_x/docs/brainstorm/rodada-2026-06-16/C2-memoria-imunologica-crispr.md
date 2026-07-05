---
arvore: fronteira
status: congelado
tema: memoria-imunologica
autor: subagente-opus-evolucao
data: 2026-06-16
temperatura: glacier
---

# C2 — Memória imunológica: o carry-forward obrigatório do locus CRISPR através da exúvia

_Análise de fronteira, exploratória e **não-normativa**. Nada aqui é regra até
ser promovido a `core/` + ADR por uma onda formal (readback, cross-audit
≠-família, selagem). Escrita restrita à zona Fronteira (`docs/brainstorm/`)._

## Premissa (a analogia, já ancorada no disco)

A entrada B do brainstorm já estabeleceu a analogia central:
`guards/tests/adversarial-battery.sh` é o **locus CRISPR-Cas** do useHBN — uma
biblioteca de assinaturas de patógenos (burlas) já vistos, gravada no genoma
(`docs/brainstorm/exuvia-evolucao-conceitual.md:53`). Cada linha `Bxx` do script
é um *spacer*: o registro de um invasor passado (o falso negativo do `maxdepth 4`
em B5; o symlink invisível ao `find -type d` em B6/B18; o smuggling de meta-path
em B17; a auto-emenda de escopo em B16) e o guard que aprende a reconhecê-lo.

O cabeçalho do próprio script declara essa função de memória de forma explícita:
ele tenta "CADA burla documentada" e "EXIGE que o guard correspondente BLOQUEIE",
sendo "a semente da auditoria Glasswing periódica… toda burla nova achada vira
linha permanente AQUI" (`guards/tests/adversarial-battery.sh:5-12`). Hoje a
bateria carrega B1–B33 (`guards/tests/adversarial-battery.sh:47,578`).

[CONCLUSÃO] A bateria adversarial é a única estrutura do genoma cujo valor é
**estritamente cumulativo e irreversível**: perder uma linha `Bxx` não é
simplificar — é reabrir uma superfície de ataque que já custou uma onda para
fechar (B17→rb0019, B18→rb0021, B19→rb0023, em
`core/exuvia-fitness-criteria.md:103-105`). Imunidade que esquece reexpõe o
organismo a burlas resolvidas.

## (a) A emenda concreta — onde e o texto proposto

[PROPOSTA] A emenda pertence a **`core/exuvia-fitness-criteria.md`**, não ao
scaffold. Razão: o scaffold (`core/hbn-exuvia-scaffold.md`) descreve a *mecânica
de transporte* (ponteiro, hooks, glacier, rollback); os critérios de fitness
descrevem **o que sobrevive ao molt e por quê** — e o carry-forward da memória
imunológica é exatamente uma regra de sobrevivência. Ela se encaixa ao lado da
"Regra de sobrevivência" (`core/exuvia-fitness-criteria.md:88-96`), como um
invariante de nível superior: enquanto a regra de sobrevivência decide *mecanismo
a mecanismo*, este invariante decide sobre **o conjunto inteiro de spacers**.

Texto proposto para uma nova seção em `core/exuvia-fitness-criteria.md`, após a
"Regra de sobrevivência":

> ### Invariante imunológico (carry-forward do locus CRISPR)
>
> A bateria adversarial (`guards/tests/adversarial-battery.sh`) é a memória
> imunológica do protocolo. Na muda (exúvia), todo *spacer* `Bxx` e o racional do
> guard que o bloqueia transferem **integralmente** para o genoma da versão nova
> (a pasta `versao_X_Y_Z` da carapaça nova). Nenhum `Bxx` desce ao glacier nem é
> deixado para trás como "consultável no frio".
>
> - A lapidação da exúvia **pode** reorganizar, renomear, fundir ou reescrever
>   qualquer guard — desde que cada burla `Bxx` da versão antiga **exista e
>   bloqueie** na versão nova (mesma `Bxx` ou uma sucessora que cubra a mesma
>   superfície de ataque, com nota de equivalência rastreável).
> - A lapidação **não pode** remover um `Bxx` sem uma das duas justificativas
>   registradas: (i) a superfície de ataque deixou de existir no genoma novo
>   (o mecanismo atacado foi removido), ou (ii) um `Bxx` sucessor a subsome,
>   com prova de cobertura. Qualquer remoção sem isso é **regressão de segurança**
>   e reprova a exúvia.
> - O carry-forward é **verificável mecanicamente**, não consultável por memória:
>   roda-se a checagem de continuidade imunológica (abaixo) como pré-condição do
>   Fitness Gate quando a exúvia for ativada.

## (b) O invariante, em uma frase

[PROPOSTA] **Na muda, a bateria adversarial inteira (cada `Bxx`) e o racional de
cada guard transferem integralmente para o genoma da versão nova, NUNCA ao
glacier.** O glacier recebe casca fria (código abandonado, história congelada via
`git mv` — `core/hbn-exuvia-scaffold.md:84-93`); a memória imunológica é a única
parte que sobe verticalmente intacta a cada salto, porque é a única cujo
esquecimento é uma regressão e não uma simplificação.

[CONCLUSÃO] Isto distingue dois fluxos no molt que hoje o scaffold não separa:
- **Casca fria → glacier**: permitido, calendarizado, com hearback humano e
  cross-audit (`core/hbn-exuvia-scaffold.md:87-93`).
- **Memória imunológica → genoma novo**: obrigatório, não-glacierável,
  verificável. O glacier é amnésia controlada para *corpo*; nunca para
  *imunidade*.

## (c) Como VERIFICAR mecanicamente o carry-forward

[PROPOSTA] A bateria já é auto-descritiva: cada burla emite uma linha
`BURLA × GUARD × RESULTADO` e o script sai `0` somente se "toda burla documentada
foi BLOQUEADA" (`guards/tests/adversarial-battery.sh:581-592`). Isso dá o
material para uma checagem de **continuidade** entre versão antiga e nova. Esboço
(não-normativo; nome de trabalho `assert-immune-carryforward`):

1. **Extrair o conjunto de spacers da versão antiga.** Listar todos os
   identificadores `Bxx` da bateria da casca que vai ser congelada — por exemplo
   `grep -oE 'B[0-9]+' guards/tests/adversarial-battery.sh | sort -u`. Resultado:
   o "alfabeto imune" antigo (hoje B1–B33).
2. **Extrair o conjunto de spacers da versão nova.** Mesma extração sobre
   `versao_X_Y_Z/guards/tests/adversarial-battery.sh`.
3. **Diferença obrigatória = vazio (módulo equivalências).** Todo `Bxx` antigo
   tem de estar presente no novo, OU constar de um mapa de equivalência
   declarado (ex.: `B17 → B17b` com nota "mesma superfície, guard refatorado").
   Qualquer `Bxx` que suma sem equivalência → **bloqueia a exúvia**.
4. **Prova de bloqueio efetivo, não só de presença.** Rodar a bateria nova
   (`bash versao_X_Y_Z/guards/tests/adversarial-battery.sh`) e exigir
   exit `0` = bateria verde. Presença textual de `Bxx` sem bloqueio real seria
   spacer morto (teatro de imunidade).
5. **Fail-closed.** Se a bateria nova não rodar, se a extração falhar, ou se o
   mapa de equivalência referenciar um `Bxx` que não bloqueia → exit ≠ 0. O
   default é bloquear, coerente com C-FCLOSE (`core/exuvia-fitness-criteria.md:83`).

[CONCLUSÃO] A checagem é barata e dogfoodável: ela é, ela mesma, um guard
fail-closed que pode ganhar sua própria linha `Bxx` (uma burla que tenta passar a
exúvia com um spacer faltando deve ser BLOQUEADA). Isso a faz cumprir C-ADV sobre
si própria.

[PERGUNTA ABERTA] O "mapa de equivalência" (passo 3) é o ponto frágil: ele é o
lugar onde uma IA poderia declarar falsamente "B18 subsumido por B-novo" e
contrabandear o esquecimento. Mitigação candidata: equivalência exige cross-audit
≠-família + prova de que o `B-novo` falha quando o ataque do `B18` é reintroduzido
no genoma novo (teste de cobertura, não declaração).

## (d) Relação com C-ADV, C-NOREG e o modelo de árvores

[CONCLUSÃO] **C-ADV** (`core/exuvia-fitness-criteria.md:80`) é a porta de entrada
do spacer: nenhum mecanismo sobrevive ao molt sem uma "burla adversarial
documentada e bloqueada" — uma linha `Bxx → BLOQUEADA`. O invariante imunológico
é o **dever de retenção** correspondente: C-ADV cria o spacer; o carry-forward
proíbe perdê-lo. Sem o invariante, C-ADV seria satisfeito por versão e perderia a
propriedade cumulativa — cada exúvia poderia "passar C-ADV" com uma bateria nova e
menor, e ainda assim regredir.

[CONCLUSÃO] **C-NOREG** (`core/exuvia-fitness-criteria.md:84`) hoje exige
"adversarial completas verdes; main intocada" — mas avalia *dentro* de uma versão.
O carry-forward é C-NOREG **estendido através da muda**: a não-regressão tem de
valer não só commit-a-commit, mas casca-velha → casca-nova. O invariante
imunológico é, em essência, "C-NOREG não tem amnésia no salto de versão".

[CONCLUSÃO] No **modelo de árvores** (seções I, L, O do brainstorm —
`docs/brainstorm/exuvia-evolucao-conceitual.md:99-156`), a memória imunológica é o
que a **Estável** mais conserva. As árvores são um gradiente de prova: Fronteira =
`.md` não provado; Intermediária = enforcement em bash/Python; Estável =
reimpresso em Rust mínimo, "só princípios, P12 mudança mínima"
(`docs/brainstorm/exuvia-evolucao-conceitual.md:121`). À primeira vista a Estável
descarta quase tudo — mas a bateria adversarial é o contraexemplo: ela é o ativo
que **sobe** de árvore sem perder massa. A promoção entre árvores é fagocitose
(`docs/brainstorm/exuvia-evolucao-conceitual.md:122`); a imunidade é o que a
fagocitose nunca digere. Em termos do modelo compilador (seção K): a *redação* dos
guards é saída impressa, substituível por linguagem; o conjunto de spacers é a
*fonte* que tem de ser reimpressa fielmente em qualquer alvo.

[PROPOSTA] Corolário para a 1ª exúvia: quando `versao_1_0_0/` nascer na
Intermediária (`docs/brainstorm/exuvia-evolucao-conceitual.md:123`), a checagem de
carry-forward deve ser uma das pré-condições do Fitness Gate, ao lado do placar de
8 colunas (`core/exuvia-fitness-criteria.md:122-123`).

## (e) Riscos honestos

[PERGUNTA ABERTA] **Spacer obsoleto vs. spacer abandonado.** Se a exúvia remove o
mecanismo que um `Bxx` protegia (ex.: o god-object `cli.py` for fagocitado —
`docs/brainstorm/exuvia-evolucao-conceitual.md:97`), reter a `Bxx` que ataca um
alvo inexistente vira ruído. O invariante precisa distinguir "superfície extinta"
(remoção legítima) de "imunidade esquecida" (regressão) — e esse julgamento é
falível. Sem critério mecânico, vira a brecha exata que a regra quer fechar.

[PERGUNTA ABERTA] **Crescimento monotônico da bateria.** Se a bateria só cresce,
em algum horizonte o custo de rodá-la a cada commit pesa, e surge pressão para
"limpar". Essa pressão é o vetor de regressão. Tensão real entre P12 (mudança
mínima / Estável enxuta) e a natureza acumulativa da imunidade — não resolvida
aqui.

[PERGUNTA ABERTA] **Confiança no mapa de equivalência.** Refatorar guards na
lapidação é desejável (a redação é descartável); mas toda renomeação `Bxx → Byy`
abre espaço para declarar equivalência falsa. A verificação por *reintrodução do
ataque* (passo 4) mitiga, mas exige que cada ataque antigo seja reproduzível
isoladamente — o que nem toda `Bxx` garante hoje (algumas montam fixtures
complexas, ex. B14 com token/FP em `guards/tests/adversarial-battery.sh:138-149`).

[PERGUNTA ABERTA] **Família da própria proposta.** Esta análise é Anthropic
(subagente Opus), igual ao orquestrador — laço Anthropic-sobre-Anthropic já
reconhecido como limite de desenho (`docs/brainstorm/exuvia-evolucao-conceitual.md:133`).
O invariante imunológico só deve virar regra após auditoria adversarial de
famílias ≠ (Codex/Gemini/Cursor), que tentem quebrar precisamente o mapa de
equivalência e a distinção "superfície extinta × imunidade esquecida".
