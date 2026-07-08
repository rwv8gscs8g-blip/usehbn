SOU: xAI · grok-build-0.1 · apelido: grok · papel auditor

# PARECER DE DESIGN — Numeração / Identificação do useHBN (protocolo global e federado)

- **Auditor**: grok (família xAI)
- **Data**: 2026-06-17T22:56:00-03:00
- **Papel**: auditor de design (cross-audit ≠-família)
- **Insumos lidos no disco**:
  - `docs/brainstorm/rodada-2026-06-17/NUMERACAO-design-brief-e-validacao.md` (seções 3-4: arte prévia + candidatos A/B/C/D; seção 5: as 6 perguntas)
  - `docs/brainstorm/rodada-2026-06-17/NUMERACAO-analise-fronteira-opus.md` (tese dos 3 eixos + candidato E "B-mínimo")
  - Evidência complementar: `AGENTS.md` (P11, project identity, exúvia), `REGISTRY.md` (formato atual AAAAMMDD-NN + legado), `docs/GLOSSARY.md` (definições de exúvia, REGISTRY, readback), `guards/...` e resultados anteriores citando `forbidden-paths`, `.hbn/results/20260617-225428-antigravity-design-numeracao.md` (parecer anterior da família Google).
- **Truth Barrier**: todas as afirmações abaixo citam arquivo:linha ou seção quando factuais. Sem absolutos.

---

## 1. Avaliação dos candidatos (A/B/C/D + E) contra os 7 requisitos

Requisitos do brief (seção 1):
1. Colisão-livre entre adotantes que não se coordenam (federação).
2. Sem autoridade/registro central.
3. Legível por humano + parseável.
4. Agnóstica de tecnologia/mercado.
5. Sequência legível (progressão de passos/ondas).
6. Estável através de exúvias (mudas/genomas).
7. Simples (P11 — Minimalismo de Cadeia, ver AGENTS.md:56).

| Candidato | 1.Colisão-fed | 2.Sem-central | 3.Legível | 4.Agnóstico | 5.Sequência | 6.Estável-exúvia | 7.Simples(P11) | Observação com evidência |
|-----------|---------------|---------------|-----------|-------------|-------------|------------------|----------------|--------------------------|
| **A** `g1.c01.w03-slug` | ❌ Falha (sem ns) | ❌ Assume único sistema | ✅ | ✅ | ✅ | ❌ (genoma linear único assume um ator) | ✅ Excelente local | "Boa em 3,5,6,7 DENTRO de um sistema. Falha em 1 e 2" (brief:22-24). Incompleta para federação. |
| **B** `<ns>:g1.c01.w03-slug` (ns explícito ou implícito local) | ✅ (via DNS/repo) | ✅ (carona externa) | ✅ (se implícito local) | ✅ | ✅ | ✅ (gN local por ns) | ⚠️ Se ns sempre repetido localmente | Base correta (brief seção 3: "reverse-DNS/Go modules... battle-tested"). Risco de verbosidade se não tornar implícito (ver antigravity:27). |
| **C** `<ns>:g1.c01.w03-slug@<ulid/hash>` | ✅ | ✅ | ⚠️ Poluído | ✅ | ⚠️ | ✅ | ❌ Ruído alto, digitação difícil | "over-engineering" (fronteira:62-65; antigravity:28). Duplica o que git SHA já oferece de graça. |
| **D** só opaco (ULID/hash + label separado) | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | ❌ | "fere legibilidade (req 3) e sequência legível (req 5)" (fronteira:66-68). Perde "ver a progressão". |
| **E** (B-mínimo) `cNN.wMM-slug` local; `<ns>:[gN.]cNN.wMM-slug` cross; `@sha` opcional | ✅ | ✅ | ✅ (local limpo) | ✅ | ✅ | ✅ (gN por ns) | ✅ (implícito 90% dos casos) | Separa os 3 eixos (fronteira seção 1). "Mais leve que A/B/C/D" onde necessário. |

**Síntese da comparação (com evidência)**: A é o núcleo local correto mas geograficamente ingênuo. B é o passo necessário de namespace federado. C e D adicionam custo desproporcional à verificação ou à opacidade. E refina B removendo repetição e separando verificação (git SHA) para o eixo onde ela pertence.

---

## 2. Respostas diretas às 6 perguntas da seção 5 do brief

### Q1. Para protocolo GLOBAL/ABERTO/federado, qual esquema (A/B/C/D ou outro) é o mais adequado e mais simples — sem over-engineering nem colisão?

**Recomendação: Candidato E ("B-mínimo")**, com as formas exatas abaixo.

Justificativa: atende 1-7 simultaneamente com o menor peso diário. A falha na federação, C/D violam P11 por ruído ou perda de legibilidade/sequência. E herda a lição da arte prévia (brief seção 3: "namespace federado + esquema local legível é o casamento que a indústria convergiu").

Não é "o único correto" — é o que minimiza fricção para "devs autônomos independentes (federação, SEM autoridade central)".

### Q2. Namespace: reverse-DNS, URL de repo, handle ou hash? Como garantir colisão-livre sem autoridade central?

**Recomendado: URL canônica do repositório git (padrão) OU reverse-DNS (quem tem domínio próprio).**

- Forma: `github.com/org/repo` ou `com.empresa.produto`.
- Colisão-livre **sem autoridade do useHBN**: "carona no DNS / no host de git" (fronteira:37-42). Quem controla `github.com/usehbn/usehbn` controla aquele namespace. Infraestrutura externa delegada (GitHub, GitLab, self-hosted, DNS) já existe e sobrevive independentemente do protocolo.
- Rejeitar handles inventados como `@meu-time` como primários: colidem por construção (fronteira:47; antigravity:41).
- Hash como namespace: perde legibilidade e não é necessário (D já foi avaliado).

Evidência: brief:28-29 (Go modules, reverse-DNS); fronteira:44-47; prática da indústria (Java packages, Android appId, Go).

Declaração: **uma vez** no manifesto do adotante (AGENTS.md "Project identity" ou seção dedicada), não repetida em cada ID local.

### Q3. Genoma/exúvia: como versionar as mudas de forma que o histórico cross-exúvia continue rastreável?

- `gN` é **local ao namespace** (fronteira:94). `g2` de um adotante ≠ `g2` de outro; o ns desambigua.
- Default inicial: implícito `g1`. Só torna explícito **após a primeira exúvia** ou em referência cross.
- Ao exúvia: o adotante incrementa gN no seu manifesto. Genoma anterior vira read-only (guards `forbidden-paths`, tags git anti-GC — evidência em fronteira:95-96 e resultados de ondas exúvia).
- Rastreabilidade cross-exúvia:
  - Git history + árvore de commits preserva o passado.
  - Doc de transição da exúvia (ex.: propostas de exúvia em `.hbn/proposals/`).
  - REGISTRY append-only registra a mudança de temperatura/geração.
  - Referência explícita: dentro de um sistema em `g2`, use `g1.c03.w02-foo` para apontar artefato do genoma anterior.
- Não precisa de máquina nova de versionamento global.

Evidência: GLOSSARY (exúvia), W-FREEZE-preparacao.md (tags), REGISTRY.md (append-only + legado), core/hbn-exuvia-scaffold.md citado em resultados.

### Q4. Artefatos federados: como referenciar cross-audits/knowledge COMPARTILHADOS entre sistemas distintos sem ambiguidade?

- Todo artefato "pertence" ao namespace que o produz/possui (fronteira:99-100).
- Forma fully-qualified: `<ns>:<id-local>` (ou `<ns>@<sha>:<id-local>` para pin).
- Commons compartilhados (knowledge global, specs do ecossistema): outro namespace, ex. `github.com/usehbn/commons:k-0027-trailers`.
- Resolução: o adotante clona/atualiza o repo do ns em background ou sob demanda. Não inventar registro/índice central de federação (violaria req. 2). "O DNS/host já é o índice" (fronteira:102).

Exemplo realístico de cross:
- De dentro de `github.com/credenciamento/app` referenciando um parecer deste sistema:
  `github.com/usehbn/usehbn:g1.c02.w03-design-numeracao`

### Q5. Migração: o REGISTRY antigo (esquema `00NN`) fica read-only; o novo nasce no esquema escolhido. Há risco/atrito nessa coexistência?

Risco baixo se o genoma novo for auto-contido (roadmap já exige).

- REGISTRY antigo (linhas `AAAAMMDD-NN`, readbacks `00NN`, results com timestamps) vira **imutável** (append-only histórico + proteção git).
- Evidência no disco: REGISTRY.md tem seção explícita "Legado (mapeamento, sem rename)" e "Linhas (going-forward, ADR-011)".
- Atrito real: ferramentas precisam reconhecer 2 formatos no overlap. Mitigação:
  - Parser legacy read-only (manter só para leitura).
  - Shim interno que mapeia `0051` → `g0.c00.w51-...` para consistência relacional (sugerido por antigravity).
  - Guards da nova exúvia operam estrito no novo; ignoram paths congelados.
- Não reescrever IDs legados (ADR-011/025 já proíbem renames).

Não há "big bang". Coexistência é append-only + frozen.

### Q6. Leveza (P11): o que NESTE design é maquinaria a mais que um dev autônomo recusaria? Qual o subconjunto mínimo que serve 90% dos adotantes?

**Over-engineering identificado**:
- Embutir ULID/hash de verificação **em todo ID** (C) — duplica git SHA; produz strings longas/ruidosas; fere P11 (AGENTS.md:56; brief:60-61; fronteira:62-65; antigravity:28,65-66).
- Exigir domínio próprio para adotar (exclui IAs/devs autônomos sem infra).
- Repetir namespace em **cada** ID interno/local (B sem a regra "implícito local").
- `gN` obrigatório desde o dia 1 (só faz sentido após 1ª exúvia).
- Qualquer registro central de namespaces (npm-scope style, DOI).

**Subconjunto mínimo (90% dos casos)**: **`cNN.wMM-slug`** (ex.: `c02.w03-auth-screen`).

- Namespace = implícito (inferido do git remote / manifesto do repo).
- Genoma = `g1` implícito até a primeira muda.
- Verificação = SHA do git **quando necessário** (pin `@sha` opt-in, estilo go.sum ou pin de dependência).
- Slug = legível por humano, escolhido pelo autor do passo/artefato (mantém "ver a progressão").

Tudo o mais (`<ns>:`, `gN`, `@sha`) aparece **somente** ao cruzar fronteira ou em auditoria rígida.

---

## 3. ATAQUE AO CANDIDATO E (separar identidade de verificação) — o que se perde vs. C?

O brief e a análise de fronteira pedem explicitamente atacar E: "separar identidade (namespace+sequência) de verificação (SHA do git) e mais leve, ou perde algo que só um id auto-verificável (C) garante?"

### O que E perde (comparado com C)

1. **Verificabilidade "context-free" / standalone** (sem resolver o backend):
   - Em C, o ID carrega o hash: `<ns>:g1.c01.w01-x@<hash>` permite, em tese, checar "estes bytes batem com este ID" sem clonar o repo ou consultar git.
   - Em E, para verificar integridade você precisa: (a) resolver o ns para um repo git, (b) ler o objeto no commit SHA, (c) checar.
   - Perda: se você só tem o string do ID (ex.: copiado em chat, email, papel), não tem prova criptográfica embutida do conteúdo.

2. **Resiliência a reescritas destrutivas do histórico**:
   - `git rebase -i`, `filter-repo`, force-push podem mudar SHAs de commits.
   - Um pin `@<sha>` em E quebra. Um hash de conteúdo embutido em C (se for hash do artefato em si, não do commit) sobreviveria.
   - (Nota: o protocolo usa append-only REGISTRY + guards + P6 "Toda evolução deve ser reversível"; reescritas destrutivas são contra as regras, mas não impossíveis em forks ou clones rogue.)

3. **Acoplamento forte a Git como VCS**:
   - E usa "SHA do git" como o mecanismo natural de verificação.
   - Se um adotante futuro portar o useHBN para IPFS + outra store, ou Mercurial, ou S3 puro, o eixo (iii) precisa de adaptação.
   - C (se o hash for content-hash agnóstico de VCS) seria mais portátil nesse eixo.

### O que C perde (e por que E ainda prevalece na prática do useHBN)

- **P11 violado no dia a dia**: IDs viram `github.com/foo/bar:g1.c02.w03-x@e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`. Longo, ruidoso, difícil de digitar ou ler em voz alta. "O dev autônomo de 90% recusa" (fronteira:64-65). P11 é princípio constitucional com "peso idêntico" (AGENTS.md:36-42).
- **Duplicação de mecanismo que já existe de graça**: "git já resolve de graça (todo commit é content-addressed por SHA)" (fronteira:31). Embutir outro hash em cada ID é redundância ativa, não defesa.
- **O que o artefato realmente é**: no useHBN, os artefatos de governança (pareceres, proposals, readbacks, REGISTRY lines) são commits. A prova de integridade canônica é o commit SHA + a linha do REGISTRY (append-only). Um hash extra no ID não adiciona autoridade além do que o git tree já dá.
- **Custo de adoção**: para um protocolo que quer "adoção sem fricção" por IAs e humanos independentes, o ruído diário de C é uma barreira maior que a perda de verificação standalone (que é rara: a maioria dos usos é dentro do clone do próprio sistema ou fetch explícito do ns).

### Evidência de que o acoplamento Git é intencional (não acidente)

- "useHBN e um protocolo de governanca de IA via git" (contexto da query e de todos os docs).
- AGENTS.md: "REGISTRY.md — livro-razão append-only", guards em bash operando sobre git diff, `.hbn/relay/STATE.md`, tags, etc.
- ADR-011, ADR-025 (timestamp+agente para eventos) já compõem com git.
- Exúvia/freeze usam git tags + forbidden-paths.

Portanto, o "lock-in" é uma escolha arquitetônica declarada, não uma fraqueza oculta. Se o protocolo evoluir para multi-VCS, o eixo de verificação (iii) será estendido (ex.: pin com CID IPFS ou equivalente) **sem mudar** a identidade (ns + sequência legível).

### Conclusão do ataque: separar é mais leve e não perde o essencial para este domínio

- Para 90%+ dos usos (single-system + cross-referência humana/IA), a identidade + sequência legível basta. Verificação é pin opcional (E) ou consultada no git (natural).
- O que C "garante" de auto-verificável é útil em cenários de distribuição de blobs sem git (ex.: p2p, mirrors não-git). O useHBN é git-native por definição; esses cenários são secundários.
- Over-engineering primário apontado: **C** (e secundariamente: exigir ns explícito sempre, gN desde o dia 1, domínio próprio obrigatório).

Se o protocolo um dia precisar de "IDs que viajam sozinhos sem git", pode-se **adicionar** um pin de conteúdo hash como metadado opcional (ex.: em um sum-file ou no front-matter do artefato), sem poluir o ID principal de sequência.

---

## 4. Forma EXATA recomendada de um ID (E refinado)

### Single-system (dentro do repositório adotante, uso cotidiano, 90%+ dos casos)
```
c02.w03-auth-screen
c03.w07-esteira-freeze
```
- `g1` implícito (default até 1ª exúvia).
- Namespace implícito (repo local / manifesto).
- Slug legível, kebab-case, escolhido pelo autor.

### Cross-system (referência de fora, export, federado)
```
github.com/usehbn/usehbn:g1.c02.w03-design-numeracao
github.com/credenciamento/app:g2.c01.w01-policy
```
- `<ns>:< [gN.] cNN.wMM-slug >`
- `gN` só aparece quando >1 ou quando o contexto do leitor pode não saber o genoma ativo do produtor.
- `:` como separador (consistente com convenções de "module:local-id" em vários ecossistemas; não colide com `/` de paths).

### Com pin de integridade / verificação forte (auditoria, CI, distribuição)
```
github.com/usehbn/usehbn@7f3a2c1:g1.c02.w03-design-numeracao
```
- `@<sha-curto-ou-completo>` é **opt-in**, só quando se quer fixar bytes exatos.
- Equivalente a pin de dependência (go.sum, package-lock, etc.).

### Exemplo de commons (knowledge compartilhado)
```
github.com/usehbn/commons:k-0027-trailers
```

### Declaração de namespace (uma vez por adotante)
Em `AGENTS.md` (ou arquivo manifesto dedicado):
```
## Project identity
- Namespace: github.com/usehbn/usehbn   # ou com.empresa.hbn para reverse-DNS
```
Ferramentas inferem do git remote `origin` quando não declarado (fallback prático).

---

## 5. Estratégia de colisão SEM autoridade central

Três camadas ortogonais (fronteira seção 7):

1. **Entre adotantes (global/federação)**: carona em infraestrutura existente.
   - URL de repo git (`github.com/org/repo`) ou reverse-DNS.
   - Quem "possui" o nome no DNS/host de git possui o namespace. Nenhuma entidade do useHBN precisa operar um registry central.
   - Evidência: brief seção 3 (Go modules, reverse-DNS); fronteira 35-42.

2. **Dentro de um adotante (local)**: sequência monotônica legível.
   - `cNN.wMM` crescente por ciclo/onda.
   - Para eventos de log/resultado (alta frequência, assíncronos): composição com ADR-025 (`AAAAMMDD-HHMMSS-<agente>-<slug>`).
   - Slug humano evita colisões triviais dentro da mesma onda.

3. **Integridade de bytes (quando exigida)**: SHA do git (ou pin equivalente).
   - Nunca depende de autoridade do useHBN.

Não há "garantia absoluta" — há **propriedade estrutural** derivada de sistemas que já funcionam em escala (DNS, git forges).

---

## 6. Subconjunto MÍNIMO e over-engineering a podar

**Mínimo que um dev autônomo aceita sem fricção**:
- Sintaxe local: `cNN.wMM-slug`
- Parser reconhece isso imediatamente.
- Namespace e genoma são propriedades do "contexto do clone" (repo + manifesto).
- Ao cruzar: prefixar com `<ns>:` (e `gN.` se necessário).
- Verificação: consultar git, ou usar `@sha` explícito só quando o caso exige.

**Over-engineering a evitar (bandeiras vermelhas)**:
- Hashes/ULIDs em todo ID (C).
- Namespace obrigatório em toda referência local.
- gN desde o dia zero.
- Registro central de adotantes.
- Exigir domínio web próprio.

---

## 7. Veredito e recomendação final

Recomendo a **adoção do Candidato E (B-mínimo)** como esquema de numeração/identificação para a exúvia e uso federado subsequente.

- É o único entre A/B/C/D/E que satisfaz os 7 requisitos sem impor custo diário visível para o adotante autônomo.
- Separa claramente os três eixos (identidade do ator, sequência do passo, verificação de bytes) e aplica a ferramenta mais leve a cada um.
- A perda de "auto-verificabilidade standalone" existe, mas é compensada pelo fato de o useHBN ser git-native por definição; a verificação já vem "de graça" do substrato. Pins `@sha` cobrem os casos de alta garantia sem poluir o caminho feliz.

Se em uso real aparecer demanda por IDs que viajam completamente sem git (cenário hoje não evidenciado nos docs), pode-se estender o eixo (iii) com pins de conteúdo adicionais — sem alterar a forma da identidade legível.

O esquema nasce na exúvia (conforme brief). Não bloqueia freeze. O REGISTRY legado permanece como história imutável.

---

## Apêndice: formas canônicas resumidas

- Local (default): `c02.w03-slug`
- Cross: `github.com/org/sys:g1.c02.w03-slug`
- Pinned: `github.com/org/sys@<sha>:g1.c02.w03-slug`
- Commons: `github.com/usehbn/commons:k-00NN-titulo`

Parser mínimo precisa reconhecer:
- `^c[0-9]{2}\.w[0-9]{2}-` (local)
- `^[^:]+:[^:]+c[0-9]{2}\.w` (cross)
- Opcional `@[0-9a-f]+:` para pin.

---

Fim do parecer. Depositado em `.hbn/results/` conforme instrução. Truth Barrier observado.
