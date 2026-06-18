# Proposta — Esteira de Pré-Transição (gate de subagentes temáticos antes do freeze e da exúvia)

NÃO-NORMATIVO (fronteira). Proposta do orquestrador (opus-4-8), 2026-06-17.
Gate que ela mesma nomeia: aprovação humana (Maurício) → cross-audit ≠-família →
decisão do orquestrador → onda(s) de implementação. Candidata a promover para
`core/esteira-pre-transicao.md` em onda própria. Não altera guard/core/roadmap por si só.

/ Origem: na rodada de 2026-06-16/17, uma maratona de subagentes de análise profunda
encontrou DOIS bugs reais de perda/duplicação de estado que o ciclo normal de
cross-audit (3 famílias) e o orquestrador deixaram passar. O método provou valor
objetivo e o Maurício pediu para torná-lo um passo formal do protocolo. /

---

## 1. O que é

A **Esteira de Pré-Transição** é um passo objetivo do protocolo: antes de dois marcos
críticos — o **freeze** (tag de versão estável) e a **exúvia** (muda para um novo
exoesqueleto) — o orquestrador dispara **ondas de grupos de subagentes temáticos**,
cada uma com um tema específico, todas **read-only** e sob **Truth Barrier**, que
**documentam seus achados no próprio sistema** (pasta datada e legível, nada solto na
raiz) para que outros agentes os leiam.

Não substitui o cross-audit de família distinta (que valida uma onda específica). É
complementar: o cross-audit pergunta "esta mudança está correta?"; a esteira pergunta
"o sistema inteiro está pronto para congelar / para mudar de casca?". A diferença de
ângulo é o que pega o que o cross-audit, focado na onda, não vê — provado nesta rodada.

## 2. Por que (evidência)

Nesta esteira, o cross-audit ≠-família pegou o 1º bug (duplicação de estado), mas o 2º
bug (perda de validation/consent no merge, porque o engine grava 3 decisions por
execution_id) só apareceu na **análise profunda paralela**, porque todos os auditores
ancoraram na mesma fixture irreal. Uma frota de subagentes com mandatos temáticos
distintos quebra essa convergência: cada um ataca de um ângulo e documenta a evidência.

## 3. Regras da esteira (invioláveis)

- **Read-only:** os subagentes só LEEM o que existe e ESCREVEM apenas seu próprio
  relatório novo. NÃO commitam, NÃO tocam main, NÃO usam --no-verify/`git add`, NÃO
  modificam arquivo rastreado.
- **Truth Barrier:** todo achado cita arquivo:linha OU comando+saída.
- **Documentação no sistema:** cada onda escreve numa pasta datada
  `docs/brainstorm/rodada-AAAA-MM-DD/analise-pre-transicao/NN-tema.md`, com cabeçalho
  padrão (título, NÃO-NORMATIVO, autor, data, resumo de 3 linhas) e um `00-INDICE.md`.
  Zona livre/untracked até curadoria humana (knowledge 0024) — NÃO entra em commit sem
  aprovação por arquivo.
- **Saída acionável:** cada relatório classifica recomendações em **LEVE** (entra antes
  do freeze) vs **EXÚVIA** (fica para a muda), sempre com o princípio de leveza (P11):
  "existe forma mais simples/eficaz?".
- **Diversidade:** rodar temas em paralelo com mandatos distintos para não convergir.

## 4. Pontos mínimos (temas) — versão inicial, aberta a evolução

a) **Auditoria profunda** — runtime (src/), guards + bateria adversarial, e
   meta-validação do fluxo (o protocolo funcionou na última onda?). [feito em 06-16/17]
b) **Estrutura de pastas + documentação** — arquitetura alvo com o livro-razão
   (REGISTRY) central, nada solto na raiz, lógica de pastas legível por humanos.
c) **Mapa de migração / genoma auto-contido** — inventariar todo documento e classificar
   transferir/melhorar/atualizar/aposentar; o novo sistema nasce contendo as próprias
   regras, sem apontar/depender dos antigos; os antigos ficam na pasta original para
   auditoria.
d) **Qualidade da descrição e documentação do software** — README, AGENTS, docstrings,
   help do CLI, glossário canônico.
e) **Padronização geral** — nomenclatura, ids, datas, formato de linhas do REGISTRY,
   convenções de pasta.
f) **Prontidão GitHub para transição segura** — o que um clone novo vê; CI (guards +
   pytest + adversarial), branch protection documentada, CODEOWNERS/templates, tags,
   segredos, paths absolutos.
g) **Protocolos de teste + novos testes** — documentar a estratégia de teste (3 camadas)
   e propor testes mais simples e efetivos (fixtures engine-reais, property-based, gate
   de honestidade de contagem) que validem melhor os pontos cobertos.

**Esta lista é um mínimo, não um teto.** Temas podem ser adicionados, fundidos ou
removidos pelo processo normal de melhoria e evolução do protocolo (mesmo gate: aprovação
humana → cross-audit → decisão). Candidatos futuros: segurança/superfície de ataque,
desempenho, acessibilidade da informação para humanos não-técnicos, internacionalização.

## 5. Onde encaixa no ciclo de vida

```
... ondas de hardening ...
   → ESTEIRA DE PRÉ-TRANSIÇÃO (freeze)  → criar checklist de freeze → rodar freeze-gate → tag v1-estável
        → (uso real / Ponte) ...
   → ESTEIRA DE PRÉ-TRANSIÇÃO (exúvia)  → genoma auto-contido → muda → novo exoesqueleto
```

A esteira roda **duas vezes** com focos distintos: antes do **freeze** (estabilizar o
incumbente) e antes da **exúvia** (preparar um genoma limpo). Os relatórios da esteira
alimentam diretamente (i) o checklist de freeze e (ii) o mapa de migração da exúvia.

## 6. Produto da esteira

Um **dossiê de pré-transição** (a pasta `analise-pre-transicao/` com índice) que vira
insumo curado: cada recomendação LEVE aprovada pelo humano vira uma micro-onda
implementada+cross-auditada+selada antes do marco; cada recomendação EXÚVIA entra no
mapa de migração. Nada da esteira é implementado sem passar pelo rito normal (readback,
escopo, cross-audit, hearback, selagem).

## 7. Força de regra (obrigatória, não opcional)

Depois de promovida, a Esteira é **gate bloqueante** — não um convite. As regras que a
tornam vinculante (candidatas a virar guard, no espírito "só gate enforçado vincula"):

- **R-PT1. Sem dossiê, sem freeze.** O `freeze-gate` NÃO pode ser rodado para uma tag de
  versão estável enquanto não existir um dossiê de pré-transição completo: um relatório
  por tema mínimo (a–g) + `00-INDICE.md`, na pasta datada. Candidato a critério no
  `schemas/freeze-checklist.schema.json` (campo `pre_transition_dossier: <path>`), checado
  por `guards/freeze-gate.sh`.
- **R-PT2. Sem dossiê de exúvia, sem muda.** O Fitness Gate da exúvia exige um dossiê de
  pré-transição focado em genoma auto-contido (tema c) antes de cortar a casca nova.
- **R-PT3. Curadoria humana explícita.** Cada recomendação LEVE só vira onda de
  implementação após aceno humano por item (knowledge 0024); nenhuma recomendação é
  auto-implementada. O dossiê fica zona-livre/untracked até a curadoria.
- **R-PT4. Rastreabilidade.** A conclusão de cada esteira gera uma linha no REGISTRY
  (evento `esteira-pre-transicao concluída`, com o path do dossiê e o marco — freeze ou
  exúvia), para o livro-razão registrar que o gate foi cumprido.
- **R-PT5. Cobertura mínima auditável.** Os temas a–g são piso obrigatório; ausência de
  qualquer um é bloqueio. Adição/remoção de tema é mudança de processo e passa pelo gate
  normal (aprovação humana → cross-audit → decisão).

A lista de temas é viva; a **obrigatoriedade do gate** é fixa: nenhum freeze e nenhuma
exúvia sem a esteira cumprida e curada.

## 8. Como promover esta proposta

Onda própria (readback dedicado): cross-audit ≠-família desta proposta → se aprovada,
promover para `core/esteira-pre-transicao.md` (spec curta com as regras R-PT1..R-PT5) +
acrescentar o campo `pre_transition_dossier` ao `schemas/freeze-checklist.schema.json` e
a checagem em `guards/freeze-gate.sh` (onda de implementação separada). Registrar no
REGISTRY. Enquanto não promovida, é fronteira (não-vinculante).
