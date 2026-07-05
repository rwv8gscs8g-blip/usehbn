# useHBN — Glossário canônico

Definições curtas (1-3 linhas) dos termos centrais do protocolo, cada uma com
ponteiro para onde o termo é especificado. Fonte de verdade para vocabulário;
para estado de componentes, ver `methodology/MATURITY-MATRIX.md`.

## Termos

- **Exúvia (molt / muda)** — Momento em que o protocolo abandona a "carapaça"
  (exoesqueleto/versão) que o limita, atravessa uma janela de vulnerabilidade e
  constrói uma nova, maior, que volta a protegê-lo — sem perder a função
  protetora. Analogia dos artrópodes/lagostas. → `core/exuvia-fitness-criteria.md`,
  `core/hbn-exuvia-scaffold.md`.

- **Árvores (Fronteira / Intermediária / Estável)** — Etiqueta de maturidade por
  artefato (campo `arvore:` no front-matter) que dá um "endereço de prova":
  Fronteira (`.md` sem enforcement, experimental), Intermediária (enforcement em
  Python/bash, provado), Estável (substrato mínimo, só princípios). Proposta de
  Fronteira, ainda não-normativa. → `docs/brainstorm/PROPOSTA-arvores-agora.md`.

- **Fronteira** — Zona experimental/não-normativa do repositório
  (`docs/brainstorm/**`): rascunhos e propostas que **não** são regra até serem
  promovidos a `core/` + ADR por uma onda formal (readback, cross-audit
  ≠-família, selagem). Também a árvore de menor maturidade. → `docs/brainstorm/`,
  `core/exuvia-fitness-criteria.md`.

- **Livro-razão / REGISTRY** — Ledger append-only (`REGISTRY.md`) que registra,
  uma linha por evento, o nascimento e a mudança de temperatura de cada artefato.
  Regras: nunca rename, nunca delete; a linha mais recente do path vence. → `REGISTRY.md`
  (ADR-011, `methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md`).

- **Readback** — Confirmação estruturada do escopo de uma onda (objetivo,
  `scope.files_allowed`, critérios) registrada em `.hbn/readbacks/NNNN-*.json`.
  É o contrato ativo que os guards leem para travar o escopo. → `core/readback-spec.md`,
  `.hbn/readbacks/`.

- **Hearback** — A confirmação **humana** que fecha o readback. Enquanto
  `hearback_status` não for `confirmed`, o readback permanece incompleto e a
  criação de ERP deve falhar com violação explícita de protocolo. → `core/readback-spec.md:58-66`.

- **Guard** — Script bash que **bloqueia** um commit (fail-closed) quando uma
  regra é violada — o "fiscal" automático. Ex.: `guards/assert-scope-lock.sh`
  recusa commit com arquivo staged fora do escopo do readback ativo. → `guards/`,
  `core/exuvia-fitness-criteria.md:48`.

- **Truth Barrier** — Regra de que toda afirmação cita `arquivo:linha` OU
  `comando+saída`; nada de "confie em mim". Proíbe absolutos como "100%",
  "sempre", "garantido". Confere-se no disco, não em relato. → `core/protocol.md`
  (truth barrier warnings), cartão de entrada `.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md:49-50`.

- **Fagocitose (phagocytosis)** — Doutrina de incorporação progressiva de
  tecnologia: o HBN engloba uma tecnologia, a digere em estágios
  (routed→studied→digested→mastered→contributed) e passa a operar com ela como
  sua, sem deixar de ser ela mesma (P7). → `docs/PHAGOCYTOSIS.md`.

- **Esteira de pré-transição** — Gate antes do FREEZE e da EXÚVIA: o orquestrador
  dispara ondas de subagentes temáticos, read-only e sob Truth Barrier, que
  documentam achados em `docs/brainstorm/rodada-AAAA-MM-DD/analise-pre-transicao/`.
  Sem dossiê curado, não há freeze nem muda. → `core/esteira-pre-transicao.md`.

- **Scope-lock** — Trava de escopo: o guard `assert-scope-lock.sh` extrai
  `scope.files_allowed` do readback ativo e recusa commit se algum arquivo staged
  ficar fora. Converte o "O Que NÃO Será Feito" do markdown em verificação
  automatizada. → `guards/assert-scope-lock.sh:1-15`.

- **Zona livre** — `docs/brainstorm/**` e rascunhos não-normativos. Pode e deve
  ficar viva/untracked até curadoria humana — é rascunho em andamento, não lixo.
  Não entra em commit/selagem sem listagem por arquivo + aceno humano explícito.
  → `.hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md`.

- **Cross-audit ≠-família** — Auditoria por **duas IAs de famílias diferentes**
  da que implementou, cada uma conferindo no disco de forma independente, com
  veredito depositado em `.hbn/results/`. Evita que o autor valide o próprio
  trabalho. → `core/exuvia-fitness-criteria.md:50,81` (critério C-XAUDIT).

- **Fitness Gate** — Portão que decide se a **versão inteira** muda na exúvia:
  baseline funcional + Ponte verde + confronto incumbente×desafiante. Complementa
  os 8 critérios de exúvia (que decidem mecanismo a mecanismo). Ativação da exúvia
  fica bloqueada por ele. → `core/exuvia-fitness-criteria.md:70-71`, `core/hbn-exuvia-scaffold.md:13,81`.

- **CRISPR / memória imunológica** — `guards/tests/adversarial-battery.sh` é o
  locus CRISPR-Cas do useHBN: biblioteca de assinaturas de burlas já vistas
  (cada linha `Bxx` é um *spacer*, o registro de um invasor passado e o guard que
  aprende a bloqueá-lo). Carry-forward obrigatório através da exúvia. →
  `guards/tests/adversarial-battery.sh`, `docs/brainstorm/rodada-2026-06-16/C2-memoria-imunologica-crispr.md`.

- **Bastão / baton** — O "passar o bastão": handoff do trabalho entre atores
  (IAs/humano). Quem assume o bastão lê a read-list da porta da frente
  (STATE → readback ativo → role-cards → knowledge) antes de agir. Componente
  com estado próprio na matriz de maturidade. → `core/role-cards.md:5`,
  `methodology/MATURITY-MATRIX.md` (componente Baton).

