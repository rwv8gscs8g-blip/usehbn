---
arvore: fronteira
status: congelado
tema: arvores-portao-promocao
autor: subagente-opus-evolucao
data: 2026-06-16
truth-barrier: toda afirmação cita arquivo:linha ou comando+saída
fontes-lidas:
  - docs/brainstorm/PROPOSTA-arvores-agora.md
  - docs/brainstorm/exuvia-evolucao-conceitual.md (I, L, O)
  - core/exuvia-fitness-criteria.md
  - docs/PHAGOCYTOSIS.md
  - methodology/PRINCIPIOS-CONSTITUCIONAIS.md (P12)
  - core/roles-assignment-spec.md (§3)
  - methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md (Decisão 3)
temperatura: glacier
---

# A2 — Árvores: reconciliação de campos + portão de promoção

> **Zona Fronteira / não-normativo / fora do scope-lock.** Insumo para auditoria
> adversarial cross-family + decisão do orquestrador. Nada aqui governa até passar
> o fluxo formal (readback + cross-audit ≠-família + selagem). Regra da rodada:
> `docs/brainstorm/rodada-2026-06-16/INDEX.md:9-16`.

Escopo deste arquivo: responde diretamente os itens (2) e (3) do gate humano que
ficaram **subespecificados** na proposta — a reconciliação de campos
(`exuvia-evolucao-conceitual.md:155` marca isso como [PERGUNTA ABERTA] e risco de
"segunda fonte de verdade") e o portão de promoção entre árvores
(`exuvia-evolucao-conceitual.md:101` pede "critérios objetivos de migração ...
reusar os 5 estágios da fagocitose + os 8 critérios + o Fitness Gate?").

---

## (a) Reconciliação dos três campos — sem segunda fonte de verdade

### O que cada campo significa HOJE (evidência no disco)

- **`temperatura:`** — *vigência* do artefato. Vocabulário fechado
  `quente | frio | ultrapassado` (`methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md:92`).
  Responde "isto ainda governa AGORA?": **quente** = vivo, governa, pode entrar em
  read-list; **frio** = histórico preservado, fora de read-list; **ultrapassado** =
  substituído, exige `superseded_by` (`ADR-011...md:96-101`). Transição é mudança de
  front-matter + linha no REGISTRY, nunca rename/delete (`ADR-011...md:104`).
  Uso real: 11 specs em `core/*` nascem `temperatura: quente`
  (`grep -rn "temperatura:" core/` → `core/exuvia-fitness-criteria.md:5`,
  `core/roles-assignment-spec.md:5`, `core/dispatch-spec.md:6`, etc.).

- **`hbn-track:`** — *trilha de cerimônia* do trabalho. Vocabulário observado
  `fast_track | safe_track | knowledge`
  (`grep -rhn "hbn-track:" .` → 14× `safe_track`, 3× `knowledge`, 2× `fast_track`).
  Responde "quanto rito o trabalho que mexe nisto exige?": `safe_track` exige
  readback + invariantes + plano antes de executar (`core/readback-spec.md:49-52`,
  `core/command-spec.md:71-73`); `fast_track` é leitura/auditoria de baixo risco
  (`core/roles-assignment-spec.md:65`, `core/start-rite-spec.md:24`). `Track` é
  conceito versionado do protocolo (`methodology/adr/ADR-004-semver-protocolo.md:136`).

- **`arvore:`** (PROPOSTO) — *nível de prova / maturidade* do artefato.
  Vocabulário `fronteira | intermediaria | estavel`
  (`docs/brainstorm/PROPOSTA-arvores-agora.md:9-12`,
  `exuvia-evolucao-conceitual.md:121`). Responde "este artefato é lei provada,
  protótipo de runtime, ou ideia experimental?": **fronteira** = `.md` ainda não
  provado, sem enforcement (brainstorm, radar, `autoevolve` embrionário);
  **intermediaria** = passou os 8 critérios e ganhou enforcement Python/bash;
  **estavel** = provou aptidão no tempo, reimpresso em Rust mínimo, só princípios
  (`exuvia-evolucao-conceitual.md:121`, alinhado a P12 como
  "linguagem-base da Árvore Estável" — `methodology/PRINCIPIOS-CONSTITUCIONAIS.md:267`).

### [CONCLUSÃO] Os três campos são ORTOGONAIS — eixos diferentes, não tabela paralela

A acusação de "segunda fonte de verdade" só se sustenta se dois campos respondessem
a **mesma pergunta**. Não respondem. Cada um é um eixo independente:

| Campo | Pergunta que responde | Eixo |
|---|---|---|
| `temperatura:` | Isto ainda governa AGORA? (vigência) | TEMPO |
| `hbn-track:` | Quanto rito o trabalho que toca isto exige? (cerimônia) | PROCESSO |
| `arvore:` | Qual o nível de prova deste artefato? (maturidade) | PROVA |

Um mesmo artefato porta os três sem redundância. Exemplo real:
`core/exuvia-fitness-criteria.md` é `temperatura: quente` (governa hoje, `:5`),
seria `arvore: intermediaria` (spec selada e accepted, `:4` `status: accepted`),
e seu trabalho de edição é `safe_track`. Saber a temperatura **não** deixa
inferir a árvore (um doc `frio` pode ter sido `estavel`; um `quente` pode ser
`fronteira`), e a trilha não diz nem vigência nem prova.

### [PROPOSTA] Regra anti-colisão (honra roles-assignment-spec §3)

`core/roles-assignment-spec.md:53-55` proíbe **tabela paralela**: o guard
anti-groupthink "lê os perfis (`fornecedor`, `papeis_aptos`) — nunca uma tabela
paralela, para não criar segunda fonte de verdade". O princípio é: **um fato, um
dono**. Aplicado a `arvore:`:

1. **`arvore:` é a ÚNICA fonte do nível-de-prova.** Não se deriva nem se duplica
   `temperatura:`/`hbn-track:`. Proibido criar um índice/tabela separado que
   re-liste "que árvore cada arquivo está" — isso seria a tabela paralela banida.
   A verdade mora no front-matter do próprio artefato (mesmo padrão de
   `path:`/`temperatura:` serem auto-localizáveis, ADR-021 citado em
   `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` via campo `path`).
2. **Invariante de coerência (não-redundância):** `arvore: estavel` **implica**
   `temperatura: quente` (algo que governa como lei provada não pode estar frio),
   mas a recíproca é falsa — logo não é duplicação, é restrição de integridade,
   verificável por guard futuro (fail-closed, P10).
3. **Default por nascimento:** artefato em `docs/brainstorm/` nasce
   `arvore: fronteira` (regra já praticada — `INDEX.md:15` "Tudo é
   `arvore: fronteira`"); spec selada em `core/` é `arvore: intermediaria`;
   `arvore: estavel` só por promoção explícita (portão abaixo).

[PERGUNTA ABERTA] O REGISTRY (`ADR-011...md:107-117`) já é livro-razão append-only
de temperatura. Promoção de árvore deve **appendar uma linha de evento de
promoção no REGISTRY** (reusando o mecanismo existente) ou ficar só no
front-matter? Appendar reusa máquina provada e dá auditoria O(1); o risco é
inchar o REGISTRY. Recomendação: appendar **só** o salto de árvore (evento raro),
não toda edição.

---

## (b) SPEC do portão de promoção entre árvores

### Princípio de reuso (não inventar maquinário)

O portão **não** cria mecanismo novo. Ele compõe três máquinas já provadas
(`exuvia-evolucao-conceitual.md:145`, `PROPOSTA-arvores-agora.md:24-25`):

1. **Fagocitose** — 5 estágios `routed → studied → digested → mastered → contributed`
   (`docs/PHAGOCYTOSIS.md:43`), com 3 regras invariantes: honestidade de estágio,
   controle humano em cada transição, reversibilidade (`PHAGOCYTOSIS.md:26-38`).
2. **8 critérios de exúvia** — C-TEST, C-ADV, C-XAUDIT, C-DOG, C-FCLOSE, C-NOREG,
   C-TRACE, C-DEBT, cada um SIM/NÃO verificável (`core/exuvia-fitness-criteria.md:75-87`).
   Regra de sobrevivência: C-TEST..C-TRACE = SIM (7 obrigatórios) + C-DEBT
   registrada (`core/exuvia-fitness-criteria.md:90-92`).
3. **Fitness Gate** — baseline funcional + Ponte verde + confronto
   incumbente×desafiante; "decide se a versão inteira muda" enquanto os 8 critérios
   decidem mecanismo a mecanismo (`core/exuvia-fitness-criteria.md:70-73`).

### [CONCLUSÃO] Mapeamento árvore ↔ fagocitose (alinhado a L)

`exuvia-evolucao-conceitual.md:122` propõe a equivalência. Refinada aqui:

| Árvore | Estágios de fagocitose cobertos | O que existe | Enforcement |
|---|---|---|---|
| **Fronteira** | routed + studied | `.md` explora/documenta, sem regra executável | nenhum (advisory tolerado e rotulado — `exuvia-evolucao-conceitual.md:128`) |
| **Intermediaria** | digested + mastered | regra codificada em guard/Python que bloqueia | fail-closed real (Python/bash) |
| **Estavel** | mastered estabilizado + (caminho a) contributed | princípio reimpresso em Rust mínimo | fail-closed, substrato estável (P12) |

Nota de honestidade (Truth Barrier): a equivalência é **analógica**, não
identidade — fagocitose governa *tecnologias externas* absorvidas
(`PHAGOCYTOSIS.md:173-175` distingue de protocolos), aqui aplicada ao *próprio
protocolo*. O portão herda o **método** (estágios + gates + controle humano), não
o objeto. Limites duros de fagocitose continuam valendo: "saltar estágios não é
permitido" (`PHAGOCYTOSIS.md:189`), "avançar exige PR + Hearback humano"
(`PHAGOCYTOSIS.md:32-34, 197`).

### [PROPOSTA] Salto 1 — Fronteira → Intermediária (a "membrana" crítica)

É a junção plasmídeo→cromossomo que `exuvia-evolucao-conceitual.md:46` identifica
como "a membrana que precisa de toda a amarra". Critérios objetivos SIM/NÃO —
**todos** obrigatórios:

| # | Critério (SIM/NÃO) | Como medir | Origem |
|---|---|---|---|
| G1.1 | Virou entrada estruturada de RADAR (linha da CONVERGENCE-MATRIX)? | linha candidato×maturidade×decisão existe | `PROPOSTA-arvores-agora.md:49-52` ("nenhuma ideia sai da Fronteira sem virar entrada de RADAR") |
| G1.2 | Tem enforcement executável (guard/regra), não só `.md`? | arquivo de guard/regra existe e roda | `exuvia-evolucao-conceitual.md:121` (Intermediária = ganhou enforcement) |
| G1.3 | C-TEST = SIM (caso positivo E negativo na suíte)? | grep em `guards/tests/run-guard-tests.sh`; suíte verde | `core/exuvia-fitness-criteria.md:79` |
| G1.4 | C-ADV = SIM (burla adversarial documentada e BLOQUEADA)? | linha Bxx em `guards/tests/adversarial-battery.sh` | `core/exuvia-fitness-criteria.md:80` |
| G1.5 | C-FCLOSE = SIM (fail-closed; falta de insumo bloqueia)? | teste com insumo ausente → exit ≠ 0 | `core/exuvia-fitness-criteria.md:83` |
| G1.6 | C-XAUDIT = SIM (≥2 famílias ≠ do autor aprovam)? | dois `.hbn/results/*` APROVA_*: SIM, famílias ≠ | `core/exuvia-fitness-criteria.md:81`; cross-family obrigatório `exuvia-evolucao-conceitual.md:46` |
| G1.7 | C-DOG = SIM (mecanismo passa o próprio guard, sem grandfathering)? | re-stagear o artefato → guard passa | `core/exuvia-fitness-criteria.md:82` |
| G1.8 | C-NOREG = SIM (suíte + adversarial inteiras verdes)? | runner completo verde; main intocada | `core/exuvia-fitness-criteria.md:84` |
| G1.9 | C-TRACE = SIM (readback + autorização humana + REGISTRY)? | trailers no commit; linha no REGISTRY | `core/exuvia-fitness-criteria.md:85` |
| G1.10 | Trailer de proveniência aponta de volta ao brainstorm + famílias? | trailer na spec selada | `exuvia-evolucao-conceitual.md:46` |
| G1.11 | Hearback humano explícito autorizou o salto? | hearback no disco | `PHAGOCYTOSIS.md:32-34, 197` (P5) |

**Promove para Intermediária se G1.1..G1.11 = SIM (todos) E C-DEBT registrada**
(`core/exuvia-fitness-criteria.md:90-92`). Qualquer NÃO em
G1.3/G1.4/G1.5/G1.8 → REFATORAR antes do salto; NÃO em G1.6/G1.9 → não-ratificado
(`core/exuvia-fitness-criteria.md:94-96`).

### [PROPOSTA] Salto 2 — Intermediária → Estável (custódia de longo prazo)

Mais conservador: a árvore Estável é Rust + princípios (P12,
`methodology/PRINCIPIOS-CONSTITUCIONAIS.md:267`), revisão constitucional anual
(`PRINCIPIOS-CONSTITUCIONAIS.md:329`). Pressupõe G1 já satisfeito + acrescenta:

| # | Critério (SIM/NÃO) | Como medir | Origem |
|---|---|---|---|
| G2.1 | Passou o Fitness Gate (baseline funcional + Ponte verde + confronto incumbente×desafiante)? | evidência do gate no STATE | `core/exuvia-fitness-criteria.md:70-73` |
| G2.2 | ≥ N dias sem regressão sob enforcement real? (sugestão N=30, espelhando F4→F5) | janela temporal sem falha no runner | `methodology/PRINCIPIOS-CONSTITUCIONAIS.md:243-245` ("F4→F5 exige ≥30 dias sem regressão") |
| G2.3 | Memória imunológica carregada por inteiro (bateria adversarial + racional de cada guard)? | carry-forward verificável, não consultável-no-frio | `exuvia-evolucao-conceitual.md:54` (regra CRISPR) |
| G2.4 | É princípio/invariante (não conveniência de ferramenta) — sobrevive à troca de linguagem? | passa o teste P8/P9 (`PRINCIPIOS...md:189-220`) | P12 "linguagem-base estável"; P8 protocolo>ferramenta |
| G2.5 | Reimpresso/portável a Rust mínimo sem perder enforcement? | prova-de-conceito de reimpressão (onda própria) | `exuvia-evolucao-conceitual.md:121` |
| G2.6 | Cross-audit ≥2 famílias ≠ + decisão humana (cadência constitucional)? | pareceres + hearback; cápsula de auditoria | `PRINCIPIOS...md:329-339` |

**Promove para Estável se G2.1..G2.6 = SIM.** P10 manda: "segurança e
não-regressão > velocidade" (`PRINCIPIOS...md:228-232`) — na dúvida, NÃO promove.

### [CONCLUSÃO] Invariante de governança (a selar antes do Credenciamento)

`PROPOSTA-arvores-agora.md:63-67`: o sistema obedece **sempre à árvore mais
validada** (Estável > Intermediária); regras de Fronteira são **não-vinculantes**.
"A exploração propõe; nunca governa." É fail-closed + P10/P5. O Credenciamento
consome **apenas** Intermediária/Estável (`PROPOSTA-arvores-agora.md:69-75`).
Despromoção (Estável→Intermediária→Fronteira) é caminho válido e reversível
(P6, `PRINCIPIOS...md:151-166`; `PHAGOCYTOSIS.md:36-38`) — uma regra que regrediu
volta a Fronteira em vez de ser apagada.

---

## (c) Exemplo concreto de front-matter etiquetado (3 artefatos reais)

> Não-normativo: NÃO edito os arquivos. Mostro o **bloco que seria adicionado**
> (campo `arvore:`) ao front-matter existente de cada um. Os demais campos são
> os reais já presentes no disco.

### Exemplo 1 — uma spec core selada (`core/exuvia-fitness-criteria.md`)

Front-matter real hoje (`core/exuvia-fitness-criteria.md:1-13`):
`status: accepted`, `temperatura: quente`. Etiqueta proposta:

```yaml
arvore: intermediaria   # spec accepted, com enforcement provado, passou C-XAUDIT
temperatura: quente     # (já existe) governa agora
hbn-track: safe_track   # (implícito) edição exige readback+cross-audit
status: accepted        # (já existe)
```

Racional: é regra provada com enforcement, mas é Python/bash, ainda não Rust →
Intermediária, não Estável.

### Exemplo 2 — um guard (`guards/assert-role-family.sh`)

[CONCLUSÃO] Guards são **bash com cabeçalho-comentário, não YAML**
(`head -12 guards/assert-role-family.sh` → `#!/usr/bin/env bash` + bloco `#`,
sem `---`). Logo a etiqueta de árvore de um guard **não** mora num front-matter
inexistente — mora (i) na linha do REGISTRY que registra o guard, ou (ii) numa
linha de comentário canônica no cabeçalho. Proposta de comentário canônico:

```bash
#!/usr/bin/env bash
# guards/assert-role-family.sh
# hbn-arvore: intermediaria   # G-FAM: accepted, no runner desde onda 0006, fail-closed
# status: accepted (correntes D/E, 2026-06-10)
```

Racional: o guard já está `accepted` e "ENTRA NO RUNNER na onda 0006"
(`guards/assert-role-family.sh:8-9`) com burla adversarial — qualidade
Intermediária. [PERGUNTA ABERTA] padronizar o token (`# hbn-arvore:` no shebang-bloco)
exigiria um micro-guard de leitura para guards; vale o custo? (ver risco abaixo).

### Exemplo 3 — um doc de brainstorm (este próprio arquivo / a proposta)

`docs/brainstorm/PROPOSTA-arvores-agora.md` é rascunho não-normativo
(`PROPOSTA-arvores-agora.md:3-5`). Etiqueta:

```yaml
arvore: fronteira       # exploratório, sem enforcement, pendente de cross-audit
temperatura: quente     # vivo na discussão atual
status: rascunho-nao-normativo
```

Contraexemplo útil de ortogonalidade: o `cli.py` god-object (~1.700 LOC, sem
C-ADV/C-XAUDIT — `exuvia-evolucao-conceitual.md:97`) está fisicamente em `src/`
(código de runtime "Implementado" na matriz) mas, **pelo nível de prova**, seria
`arvore: fronteira` até refatorar. Isso é exatamente o ganho de "quarentena
honesta" (`PROPOSTA-arvores-agora.md:31-35`): a árvore desmascara a falsa
confiança que a pasta `src/` cria.

---

## Riscos honestos e mitigações

- [PERGUNTA ABERTA] **Classificação prematura** (rotular `intermediaria`/`estavel`
  algo não provado). Risco real: `arvore:` é declarativo no front-matter — uma IA
  pode etiquetar `estavel` sem mérito (`exuvia-evolucao-conceitual.md:56` já
  alerta "rótulo declarativo = falsa confiança"). **Mitigação:** o portão é
  mecânico, não opinativo (8 critérios + cross-audit ≠-família, seção b);
  promoção exige hearback humano (P5) + linha no REGISTRY; invariante de coerência
  (a.2) permite guard fail-closed checar `estavel ⇒ quente` e exigir evidência de
  portão. Sem o portão, a etiqueta é só intenção — e intenção de Fronteira não
  governa (invariante b).

- [PERGUNTA ABERTA] **Segunda fonte de verdade** (`arvore:` colidir com os outros
  dois — `exuvia-evolucao-conceitual.md:155`). **Mitigação:** demonstrada
  ortogonalidade (seção a, três eixos distintos); regra "um fato, um dono"; proibição
  de tabela/índice paralelo (roles-spec §3, `roles-assignment-spec.md:53-55`).

- [PERGUNTA ABERTA] **Custo de manutenção / churn de etiqueta.** Etiquetar todos os
  artefatos é trabalho; manter sincronizado é dívida. **Mitigação:** seguir o
  padrão ADR-011 Decisão 5 (`ADR-011...md:126-134`) — "só daqui pra frente":
  artefato novo nasce etiquetado; legado ganha `arvore:` na primeira edição natural,
  sem onda de retrofit. Default por pasta (a.3) zera o esforço para o caso comum
  (`docs/brainstorm/` → fronteira; `core/` → intermediaria).

- [PERGUNTA ABERTA] **Guards sem front-matter** (Exemplo 2): forçar um token em
  bash pode exigir micro-guard novo = mais maquinário, contra P11 (Minimalismo de
  Cadeia, `PRINCIPIOS...md:248-257`). **Mitigação:** preferir registrar a árvore do
  guard **no REGISTRY** (mecanismo já existente) em vez de inventar parser de
  comentário — evita cadeia nova.

- [PERGUNTA ABERTA] **Particionar agora vs. depois.** A proposta separa
  "etiquetar agora" de "particionar diretórios na exúvia"
  (`PROPOSTA-arvores-agora.md:79`, `exuvia-evolucao-conceitual.md:156`). Risco de
  etiquetar sem nunca particionar = metadado órfão. **Mitigação:** o invariante de
  governança (b) já torna a etiqueta *operante* mesmo sem partição física (decide
  o que o Credenciamento consome), então a etiqueta tem valor antes da pasta existir.

## Próxima ação sugerida (handoff)

Submeter à auditoria adversarial ≠-família (Gemini/Codex/Cursor/Grok,
`exuvia-evolucao-conceitual.md:171-175`) com foco em: (1) a ortogonalidade
realmente elimina a colisão? (2) os critérios G1/G2 têm burla? (3) `estavel ⇒ quente`
é o único invariante de coerência ou faltam outros? Veredito no template
`core/cadence-d.md` + `APROVA_PF-ARVORES-AGORA: SIM/NÃO`.
