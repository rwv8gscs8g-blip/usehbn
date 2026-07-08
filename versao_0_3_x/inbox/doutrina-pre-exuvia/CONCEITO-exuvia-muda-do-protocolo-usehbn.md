# Conceito — Exúvia: o modelo de muda (molt) do protocolo useHBN

Status: PRÉ-PROPOSTA (brainstorm validado pelo gate humano 2026-06-13).
Vira proposta formal com cross-audit numa onda futura, pós-estabilização.
Origem: ideia de Maurício; orquestrador Opus-4-8 destilou e validou em 4 perguntas.

## A metáfora
Artrópodes crescem mudando de exoesqueleto: largam a **exúvia** (a casca vazia,
que guarda a forma EXATA do que eram) e emergem maiores e novos. A casca rígida
protege, mas a certa altura impede o crescimento — a muda é o único jeito de
crescer sem perder a proteção. O rastro deixado é objetivo e auditável.

## O mapeamento
Orquestrar IAs de famílias diferentes é anômalo e exige um molde rígido de
proteção: o useHBN (guards, cerimônias, travas). Essa rigidez protege, mas
acreta entulho (REGISTRY na raiz, STATE inchado, deadlocks B1/B2/B3 que a edição
incremental não resolve). A muda reenquadra o "breaking change" do protocolo como
evento natural de crescimento — o "corte com o passado", feito com rastro.

## Decisões validadas (gate humano, 2026-06-13)
1. **Escopo:** aplica-se ao PROTOCOLO e a cada PROJETO gerido, em cadências
   distintas (cada um na sua linha de versão).
2. **Gatilho:** só na virada de versão MAIOR (ADR-004 semver). O acúmulo entre
   versões segue até a próxima muda. (A poda do livro-razão por volume — ideia
   das ~50 arquivos — é mecanismo SEPARADO, não é a muda.)
3. **Curadoria do que migra:** o cross-audit das IAs propõe a lista do que é
   "quente/válido" (regras consolidadas); o gate humano ratifica.
4. **Modelo multi-projeto** (useHBN governa irmãos sob a pasta-pai, um ativo por
   vez): ONDA PRÓPRIA, pós-estabilização (hoje o guard de raiz canônica fixa um
   repo só).

## Mecânica proposta (a detalhar na onda formal)
- Na virada `vN → vN+1`: congela a forma inteira atual numa pasta-exúvia `vN/`
  (imutável, perfeitamente auditável — a casca completa).
- Renasce `vN+1/` limpo: livre para reorganizar nomes, pastas e a lógica de
  operação, carregando só o curado como "quente".
- **Manifesto da muda**: documento que indexa o que foi carregado/renomeado/
  deixado, e linka de volta à exúvia anterior — auditabilidade não se perde.
- Duas exúvias acumuladas → a mais antiga vira candidata natural a **glacier**.

## Relação com o que já existe
- `quente/frio` + `glacier` operam por ARTEFATO; a exúvia opera por ÉPOCA/VERSÃO
  (granularidade maior). São complementares.
- Gatilho casado com o semver do protocolo (ADR-004) e dos projetos.
- Inspiração da natureza (muda, metamorfose): transição de estado permanente que
  deixa rastro objetivo e abre renovação radical sem perder o legado.

## Perguntas em aberto para a onda formal
- Layout exato da pasta-exúvia e schema do manifesto.
- Como `assert-canonical-root` e os demais guards se comportam atravessando a
  muda (a forma nova pode ter outra árvore).
- Como o commit de "carry-forward" evita re-disparar os guards (lições B1/B2/B3).
- Interação com a onda do multi-projeto (a muda por projeto depende dela).

## Próximo passo
Entra no roadmap como onda de DESENHO (proposta + cross-audit) depois de fechada
a estabilização atual e antes/junto da reestruturação do livro-razão.
