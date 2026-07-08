# Handoff do Orquestrador + significado real dos ciclos (anti-teatro)

NÃO-NORMATIVO (fronteira), mas CRÍTICO para continuidade. Orquestrador (opus-4-8),
2026-06-17. Para o PRÓXIMO orquestrador ler ao assumir o bastão numa nova janela de
contexto. Complementa o Cartão de Entrada e `core/role-cards.md`.

---

## PARTE A — Manual de operação do orquestrador (siga isto)

### A.1 Postura inegociável
- **Truth Barrier:** NUNCA confie em relato (humano ou IA). Confira TUDO no disco
  (arquivo:linha OU comando+saída). O relato do chat pode estar errado/desatualizado —
  já aconteceu (paste de parecer trocado; parecer-fantasma que não existia no disco).
- **Deny-by-default:** nada entra no registro governado sem escopo aprovado. O humano
  aprova a `files_allowed` exata.
- **main NUNCA é tocada** (está em `4db6928`). Sem merge, sem `--no-verify`, sem `git add .`.
- **Uma onda, uma preocupação** (leveza/P11). Débito é aceitável se REGISTRADO (C-DEBT).
- **O que vincula é o gate enforçado, não o texto.** Instrução escrita não segura IA.

### A.2 O loop (rito de cada onda)
orquestrador desenha → **codex implementa** → **cross-audit ≠-família** (≥2 famílias
distintas do implementador) → **hearback humano** (Maurício) → **selagem** (micro-onda
que torna tracked os pareceres + atualiza STATE/REGISTRY).

### A.3 Convenções operacionais (aprendidas nesta sessão)
- **Despacho executável SEMPRE no chat**, como bloco copiável. O documento guarda o
  design/rationale; o chat carrega o bloco (a automação lê o chat). NÃO mande dispatch só
  no arquivo.
- **Pareceres: leia no disco.** O humano pode dizer só "leia o parecer do X no disco";
  NÃO exija paste (o disco é mais confiável). Sempre verifique que o arquivo EXISTE.
- Todo despacho ao codex: `implementador=codex` + sinal `🔴 G-EXC PROPOSED` no STATE
  **desde o C1**; trailers CONTÍGUOS no último parágrafo:
  `HBN-Readback: <NNNN>` / `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)` /
  `HBN-Token-FP: 34a7f2f9`.
- `files_allowed` exata; novas linhas de REGISTRY = **7 colunas** com `arvore=fronteira`.
- Se o codex detectar conflito de escopo (ex.: outro guard quebra), ele PARA e pede
  aditamento — o orquestrador expande o `files_allowed` (B16: auto-emenda é proibida).

### A.4 Gates enforçados hoje (honre todos; o runner roda antes de cada commit)
G-SCOPE (scope-lock), G-EXC (exceção F-01), **G-TRAILERS** (contiguidade de trailers em
todo commit governado, independe do implementador), **G-AUDITOR-ID** (parecer precisa de
`SOU: <apelido> · familia <X> · papel auditor` canônico + família do mapa
`guards/data/auditor-families.txt`), **G-DIVERSITY** (selagem exige ≥2 famílias distintas
≠-implementador com APROVA SIM), **G-ARVORE-LABEL** (árvore intermediaria/estavel exige
evento de promoção append-only; estavel⇒quente), G-REG (linha no REGISTRY p/ artefato
novo; coluna arvore; column-aware), G-ZONA-LIVRE (deny da zona livre sem curadoria),
G-KNOW-INDEX, G-FRONTDOOR, G-SCRATCH-*, G-HRB (assinatura SSH do hearback — PENDENTE de
chave do operador), G-NUM. Bateria adversarial B1–B40 verde. run-guard-tests 195. pytest 213.

### A.5 Estado selado (branch proposta/reestruturacao-m-a-s0)
R1/R1-fix/R1-fix-2 (runtime honesto + 2 bugs de estado) · Esteira de Pré-Transição (core)
· Curadoria P0 (AGENTS honesto + GLOSSARY + matriz dedup) · G-AUDITOR-ID · R2 árvores ·
R3a G-TRAILERS. **R3b G-DIVERSITY entregue, aguardando cross-audit/hearback/selagem.**

### A.6 Dívidas registradas (C-DEBT)
- **R3c G-REG-M geral** (M de metadado de ciclo em front-matter) — aceita p/ freeze.
- **`zona_livre_curada` auto-declarado** — banir brainstorm de `files_allowed` exceto onda
  de curadoria dedicada.
- 4 pareceres `batch1-fronteira` untracked precisam de `SOU:` canônico antes de selar
  (G-AUDITOR-ID os barra hoje).

### A.7 Gates humanos pendentes (Maurício)
Gerar `.hbn/operators/<nome>.pub` (ativa G-HRB) · rodar `guards/freeze-gate.sh` no Terminal
· conectar GitHub/Jules. Branch protection biométrica na main já armada.

### A.8 Onde está a inteligência desta sessão
`docs/brainstorm/rodada-2026-06-17/`: `SINTESE-PROFUNDA-pre-freeze.md`,
`analise-pre-transicao/00-INDICE.md` (+05 relatórios temáticos),
`R2-arvores-design-e-despacho.md`, `G-AUDITOR-ID-design.md`,
`ROADMAP-cadencia-ate-v207.md`, e este arquivo.

---

## PARTE B — O significado REAL de cada ciclo (não simplificar; dogfooding de verdade)

> Regra-mãe (ponto 5 do Maurício): cada passo só está "feito" quando corresponde ao **uso
> real** — o protocolo sendo usado no projeto e entregando resultado real. Declarar não é
> validar. Mock não é dogfooding. Se um gate "passa" sem ser exercido no uso real, é teatro.

### B.1 Estabilização → FREEZE (tag v1-estável)
**Significado real:** "estável" = o núcleo tem, com EVIDÊNCIA no disco: teste positivo E
negativo; resistência adversarial (B1–B40); cross-audit de ≥2 famílias distintas;
fail-closed; sem regressão; rastreabilidade (readback+hearback+token+REGISTRY); e as
brechas conhecidas FECHADAS ou aceitas como C-DEBT registrada.
**O ato real do freeze** = criar `.hbn/freeze/<id>-freeze-v1.json`, preencher cada critério
com evidência, e o HUMANO rodar `guards/freeze-gate.sh` no Terminal — o **exit code** dele é
o freeze, não uma frase. Depois: tag `v1-estavel`.
**Anti-teatro:** não taggear sem o gate verde com evidência real; não "marcar feito" item de
checklist sem o artefato/comando que o prova.

### B.2 PONTE v206 (protocolo governando o produto real)
**Significado real (ponto 3):** a Ponte NÃO é cópia de arquivos. É criar o **mecanismo de
uso** pelo qual o desenvolvimento do **Credenciamento v206** passa a seguir as MESMAS
regras, indicadores e limitações do protocolo (guards, readbacks, cross-audit ≠-família,
sinais HBN, deny-by-default) — para garantir a segurança da evolução do produto.
**Validação tela a tela:** cada tela/feature do v206 é finalizada e validada SOB os gates do
protocolo, até **congelar a versão final** do produto. É aqui que o protocolo deixa de ser
auto-referente e entrega **resultado real** — o dogfooding verdadeiro.
**Pré-requisitos:** resolver os 4 bloqueadores do VETO 0034/0035 (pré-uso-real, não
pré-freeze): aritmética de contagem; path absoluto no guard de snapshot; colisão
R8×forbidden-paths; split do firewall 0022. Consumir o snapshot do protocolo `v1-estavel`.
**Anti-teatro:** a Ponte só está "feita" quando uma tela real do v206 foi evoluída e
barrada/aprovada pelos gates do protocolo de verdade — não quando o snapshot é só copiado.

### B.3 EXÚVIA do protocolo useHBN (genoma limpo)
**Significado real (ponto 4):** a muda produz um **novo exoesqueleto auto-contido** — docs,
pastas e REGISTRY **nascendo limpos**, com a **nova numeração** (`g1.cNN.wMM-slug`), SEM
ponteiros para o legado; o antigo é preservado **read-only** para auditoria (G-LEG +
`.hbn/forbidden-paths.txt` + tag anti-GC `hbn-exuvia/protocol-0.3.x`); a **bateria
adversarial é transferida INTEGRALMENTE** como CRISPR/memória imunológica.
**O que decide o que sobrevive:** o **Fitness Gate** + os **8 critérios** de
`core/exuvia-fitness-criteria.md` (C-TEST..C-TRACE obrigatórios + C-DEBT registrada).
**Para quê:** o protocolo exuviado/limpo é usado no **refatoramento profundo do V207**.
**Anti-teatro:** exúvia não é renomear pasta. É só legítima se o genoma novo for de fato
auto-contido (passa no teste de auto-contenção) e se o que migrou passou pelo placar de 8
colunas com evidência. O que não sobrevive ao placar NÃO entra na casca nova.

### B.4 V207 + ponto de decisão (exúvia do próprio sistema?)
**Significado real (ponto 4):** com o protocolo limpo, evolui-se o **V207** do Credenciamento.
Neste ponto decide-se: (a) **seguir com o projeto anterior** sobre o protocolo exuviado; ou
(b) fazer a **Exúvia do PRÓPRIO sistema** no V207 — um refatoramento profundo que corrige o
legado do produto, com melhorias estruturais e de performance. São DUAS exúvias possíveis: a
do protocolo (já planejada) e a do sistema (decisão em V207).
**Anti-teatro:** a decisão (a)/(b) deve ser tomada com dados reais de uso do v206 (o que o
legado custou de verdade), não por preferência estética.

### B.5 Checklist de honestidade para QUALQUER passo (cole no rito)
1. Existe ARTEFATO no disco que prova o passo (comando+saída / arquivo:linha)?
2. O gate relevante foi EXERCIDO no uso real, ou só "passou" vazio?
3. As dívidas estão REGISTRADAS (C-DEBT), não escondidas?
4. Algum número/afirmação foi declarado sem evidência? (se sim, é teatro — pare.)
5. Isso entrega resultado real ao projeto, ou só ao protocolo? (Ponte/V207 exigem o real.)
