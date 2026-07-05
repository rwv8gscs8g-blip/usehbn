# Numeração federada do useHBN — análise crítica de Fronteira (Opus)

> NÃO-NORMATIVO (zona livre, untracked). Análise independente do chat paralelo de
> Fronteira (Claude Opus 4.8, Anthropic) sobre o brief
> `NUMERACAO-design-brief-e-validacao.md`. Insumo para a decisão de Exúvia; a numeração
> só nasce na muda, com cross-audit ≠-família + hearback. Truth Barrier: fatos do disco
> citados.

## 0. Tese em uma linha

O brief acerta no diagnóstico (precisa de namespace federado) mas embute **dois
problemas distintos num mesmo id** e por isso pesa mais do que precisa. Separando-os, a
resposta fica mais leve que A/B/C/D — proponho um **candidato E (B-mínimo)**.

## 1. O insight que destrava: são DUAS perguntas, não uma

O brief trata "identificação" como um problema só. São dois, ortogonais:

- **(i) Identidade do adotante (namespace):** "de qual sistema/ator é isto?" — precisa de
  federação sem autoridade central.
- **(ii) Identidade do passo interno (sequência):** "qual passo dentro do sistema?" —
  precisa ser legível, ordenável, estável através de exúvias.

E há um terceiro eixo que o brief CONFUNDE com (ii) no candidato C:

- **(iii) Verificação de integridade:** "estes são exatamente os bytes deste artefato?" —
  precisa de hash/content-addressing.

A consequência prática: **colisão global só precisa valer no eixo (i).** Dentro de um
namespace, o adotante controla a própria sequência (ii) — colisão interna é trivial e
local. E (iii) o **git já resolve de graça** (todo commit é content-addressed por SHA).
Logo o problema da federação reduz-se a UMA pergunta: *como um adotante escolhe um
namespace livre de colisão sem autoridade central?* O resto A já resolvia.

## 2. A colisão-zero sem autoridade central já tem resposta battle-tested

Reverse-DNS / module-path (Java packages, Go modules, Android appId) é colisão-livre
**porque pega carona no DNS / no host de git** — uma hierarquia global com autoridade
**delegada e externa ao protocolo**. Quem possui `example.com` possui `com.example.*`;
quem possui `github.com/org/sys` possui aquele path. **Nenhum registro central do useHBN
precisa existir ou sobreviver** (req. 2 satisfeito), porque a infraestrutura de nomes que
o adotante já usa É o registro.

Crítica honesta: reverse-DNS assume domínio próprio — muitos devs autônomos (e IAs) não
têm. Go resolve isso usando a **URL do repositório** (`github.com/user/repo`), que todo
adotante que usa git já tem. Então o namespace deve ser **a localização canônica do repo**
(ou reverse-DNS para quem tem domínio), não um handle inventado (handles colidem).

Reconciliação com o disco: o `ADR-025` já define nome de artefato de evento como
`AAAAMMDD-HHMMSS-<agente>-<slug>` (`methodology/adr/ADR-025...`), e o `<agente>` vem de
`.hbn/models/*.json`. Ou seja, **eventos já têm anticolisão por timestamp+agente**; o
namespace federado é a camada que falta para cruzar fronteiras de sistema. Os dois se
compõem; não se substituem.

## 3. Crítica dos candidatos A/B/C/D

- **A (linear único):** correto DENTRO de um sistema; falha só na federação por não ter
  namespace. Não é "errado" — é **incompleto**. É o núcleo de (ii).
- **B (namespaced federado, implícito local):** certo. O movimento-chave é "implícito no
  repo, explícito ao cruzar fronteira" (modelo Go: `./pkg` local, `github.com/org/repo/pkg`
  cross-module). É a base da minha recomendação.
- **C (B + ULID/hash anexo em todo id):** **over-engineering.** O hash em CADA id duplica o
  que o git SHA já dá. Verificação de integridade é o eixo (iii) — pertence a um **pin
  opcional separado** (estilo `go.sum`), não embutido em todo identificador. Carrega peso
  que o dev autônomo de 90% recusa.
- **D (só opaco global):** **rejeitar como primário** — fere legibilidade (req 3) e
  sequência legível (req 5), que são metade do propósito ("ver a progressão", o "fio da
  meada"). Opaco só onde já existe de graça (SHA do git), para verificação.

## 4. Candidato E — "B-mínimo" (recomendado)

Separar os três eixos e dar a cada um a ferramenta mais leve:

- **Namespace (i):** declarado UMA vez num manifesto (estilo `module` do go.mod), no
  `AGENTS.md`/manifesto do adotante: `namespace: github.com/org/sys` (ou reverse-DNS). NÃO
  se repete em cada id; só é prefixado **ao exportar/referenciar cross-sistema**.
- **Id local (ii):** `[gN.]cNN.wMM-slug` — `gN` (genoma) **opcional**, default `g1`, só
  aparece explícito **depois da 1ª exúvia**; `cNN` ciclo, `wMM` onda, `slug` humano. É a
  sequência legível e estável.
- **Verificação (iii):** quando preciso fixar bytes exatos, usar o **SHA do git**:
  `<ns>@<sha>:<path>` — NÃO um ULID novo. Separado e opcional, como `go.sum`.

Forma exata de um id:
- **Single-system (90% dos casos):** `c02.w03-auth-screen` (namespace e genoma implícitos).
- **Cross-system (ao referenciar de fora):** `github.com/org/credenciamento:g1.c02.w03-auth-screen`
- **Com pin de integridade (raro):** `github.com/org/credenciamento@<sha>:g1.c02.w03-auth-screen`

## 5. Respostas diretas às 6 perguntas do brief

1. **Esquema:** E (B-mínimo) — B refinado, separando identidade/verificação e tornando
   namespace+genoma implícitos. Mais simples que C/D, completo onde A falha.
2. **Namespace:** URL do repo (default, todo mundo tem) OU reverse-DNS (quem tem domínio).
   Colisão-livre por carona no DNS/host de git — autoridade delegada e externa, não central.
3. **Genoma/exúvia:** `gN` é **local ao namespace** (o `g2` de um adotante ≠ `g2` de outro;
   o namespace desambigua). Cada exúvia incrementa `gN`; o genoma antigo fica **read-only**
   (já no roadmap: tag anti-GC + `forbidden-paths`), então `g1.c03.w02` permanece resolvível
   para sempre. Rastreabilidade cross-exúvia = o doc de transição (de-onde-para-onde) +
   genoma preservado. Não precisa de máquina nova.
4. **Artefatos federados:** um artefato pertence ao namespace que o **produz/possui**;
   referência cross-namespace usa o id totalmente qualificado `<ns>:<id-local>`. Um
   "commons" compartilhado (ex.: knowledge comum) é só **outro namespace**
   (`github.com/usehbn/commons:k-0007-...`). **Não inventar um registro de federação** — o
   DNS/host já é o índice.
5. **Migração:** baixo risco se o genoma novo for auto-contido (o roadmap já exige). Antigo
   `00NN` read-only; referências novas→antigas resolvem no genoma congelado. Atrito real:
   ferramentas/humanos precisam parsear DOIS formatos no overlap — manter o parser antigo
   só-leitura. Sem reescrever ids legados (ADR-011/025 já proíbem).
6. **Leveza (o subconjunto mínimo):** **`cNN.wMM-slug`**. Namespace = URL do repo (grátis,
   implícito); genoma = `g1` implícito até a 1ª muda; verificação = SHA do git quando
   precisar. Tudo o mais (namespace explícito, `gN`, cross-ref, pin) é **opt-in, aparece só
   quando cruza fronteira**. É o que um dev autônomo aceita sem fricção.

## 6. Over-engineering a evitar (bandeiras)

- ULID/hash em todo id (C) — git SHA já faz; é o eixo (iii) num pin opcional.
- Qualquer registro/índice central de namespaces (npm-scope/DOI) — fere req. 2.
- Exigir domínio próprio — exclui devs sem domínio; aceitar URL de repo.
- `gN` obrigatório desde o dia 1 — só faz sentido após a 1ª exúvia; default implícito.
- Repetir o namespace em cada id interno — declarar uma vez no manifesto.

## 7. Estratégia de colisão (resumo)

Estrutural, não enforçada por autoridade do useHBN: (a) **entre adotantes** — carona no
DNS/host de git (namespace único por construção); (b) **dentro do adotante** — sequência
monotônica local (`cNN.wMM`) + timestamp+agente do ADR-025 para eventos; (c) **integridade**
— SHA do git. Três camadas, cada uma com a ferramenta que já existe.

## 8. Para a validação ≠-família

Apresentar A/B/C/D **e** este candidato E, pedindo que ataquem E também (anti-groupthink;
sou Anthropic, mesma família do orquestrador). Pergunta crítica a fazer a eles: *separar
identidade (namespace+sequência) de verificação (SHA) é mais leve, ou perde algo que só um
id auto-verificável (C) garante?*
