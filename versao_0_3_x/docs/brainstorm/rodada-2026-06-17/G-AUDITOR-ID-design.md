# Design — G-AUDITOR-ID (auto-identificação do auditor como gate enforçado)

NÃO-NORMATIVO (fronteira). Design do orquestrador (opus-4-8), 2026-06-17.
Gate da onda: aprovação humana → cross-audit ≠-família → decisão → implementação.

/ Origem (incidente provado no disco): no cross-audit do readback 0045, um parecer
relatado no chat como "Grok" (a) NÃO trazia a linha `SOU:`, (b) nomeou o próprio
arquivo como `...antigravity-cross-ia-...` sendo supostamente Grok, e (c) NÃO existia
no disco (`ls` só mostrava o parecer do Antigravity). Resultado: o 0045 ficou, por um
momento, com UMA família ≠-OpenAI verificável em vez de duas — a diversidade não estava
satisfeita, embora o relato dissesse que sim. O Maurício apontou: "deveria ser
IMPOSSÍVEL com as regras aprovadas." Está certo — e a razão é a tese do protocolo. /

---

## 1. O problema (a tese do useHBN provada de novo)

A **auto-identificação do auditor** (Cartão de Entrada: "a 1ª linha deve ser `SOU:
<apelido> · familia <X> · papel auditor`") é **instrução escrita**, não gate. E a
**família** declarada é **autodeclarada** e já se mostrou instável (o mesmo Cursor foi
`Cursor/Antigravity` numa rodada e `OpenAI` em outra). Nada falha fechado quando:
- um parecer não traz `SOU:`;
- a família declarada não é canônica ou não bate com o apelido;
- o apelido do arquivo difere do apelido do `SOU:`;
- o parecer simplesmente **não existe no disco**.

Isso é load-bearing: **toda a garantia de "≥2 famílias distintas auditaram" repousa
nessa autodeclaração não-verificada.** Pela tese (knowledge 0024/0025), só um gate
enforçado vincula. Logo, a identidade do auditor precisa virar gate.

## 2. O guard — G-AUDITOR-ID (Camada 1: identidade, must-have)

Dispara quando um arquivo `.hbn/results/*.md` é **adicionado** (staged, diff-filter=A) —
ou seja, no momento da **selagem**, que é quando o parecer entra no livro-razão. Para
cada result `R` adicionado, **falha fechado** se qualquer condição abaixo não valer:

- **C1 — Nome canônico:** o nome de `R` casa `AAAAMMDD-HHMMSS-<apelido>-cross-ia-<onda>.md`.
  Extrai `<apelido_arquivo>`.
- **C2 — Auto-ID presente:** `R` contém, nas primeiras ~12 linhas, uma linha
  `^SOU:\s*<apelido_sou>\s*·\s*familia\s+<fam>\s*·\s*papel\s+auditor`. (Permite a linha
  `APROVA_NNNN` e front-matter antes do `SOU:`.)
- **C3 — Apelido coerente:** `<apelido_sou>` == `<apelido_arquivo>`.
  (Pega o caso de hoje: "Grok" escrevendo arquivo nomeado `antigravity`.)
- **C4 — Família canônica e coerente:** `<fam>` ∈ mapa canônico **e**
  `mapa[<apelido>] == <fam>`. (Pega "cursor · familia Google" e famílias inventadas.)
- **Fail-closed:** mapa ausente/ilegível, `SOU:` ausente, ou qualquer divergência → BLOQUEIA
  com mensagem clara (`G-AUDITOR-ID: parecer <R> sem SOU canônico / família incoerente`).

### Mapa canônico de famílias
Arquivo de dados lido pelo guard, ex.: `guards/data/auditor-families.txt`, linhas
`apelido familia` (curado por humano; adicionar auditor novo = edição governada por
scope-lock + cross-audit, pois vive sob `guards/`):
```
opus        Anthropic
claude      Anthropic
codex       OpenAI
gpt-5       OpenAI
cursor      OpenAI
gemini      Google
antigravity Google
grok        xAI
```
(Lista inicial; estende-se por curadoria. Identidade criptográfica do auditor é
exúvia — aqui é normalização determinística, suficiente para fechar os furos vistos.)

## 3. Camada 2 — diversidade mínima na selagem (recomendada, mesma onda se simples)

A garantia que o Maurício realmente quer ("2 famílias distintas auditaram") exige, além
da identidade, **contar** as famílias. Proposta: quando os results de um readback `NNNN`
são selados, exigir **≥2 famílias distintas, ambas ≠ da família do implementador** de
`NNNN`, **com veredito `APROVA_NNNN: SIM`**. O implementador vem de
`implementador_id` do readback `NNNN` → mapa de famílias.

Pontos em aberto (por isso pode ir em onda própria, para não inflar a Camada 1):
- agrupar results por `NNNN` (parse de `APROVA_NNNN` no corpo);
- ignorar pareceres `NÃO` na contagem de aprovação;
- casos onde os pareceres de um readback são selados em commits diferentes.

Recomendação: **Camada 1 nesta onda** (resolve diretamente o incidente); **Camada 2 em
fast-follow** com os pontos acima resolvidos, para honrar a leveza (P11) e não construir
lógica frágil de uma vez.

## 4. Burlas adversariais a adicionar (B-novos)
- Result adicionado **sem** linha `SOU:` → BLOQUEADO.
- Result com `familia` fora do mapa canônico (ex.: `familia Klingon`) → BLOQUEADO.
- Result cujo apelido do nome ≠ apelido do `SOU:` (o caso de hoje) → BLOQUEADO.
- Result com apelido/família incoerentes (`cursor · familia Google`) → BLOQUEADO.
- Caso positivo: result bem-formado (`grok · familia xAI`, nome casando) → PASSA.

## 5. Testes (run-guard-tests) + runner
- Casos positivo e negativos acima em `guards/tests/run-guard-tests.sh`.
- Adicionar G-AUDITOR-ID ao `guards/hbn-guards-runner.sh` (fail-closed, no bloco com os
  demais guards de result/registro).
- Sem regressão: pytest e adversarial-battery seguem verdes.

## 6. Lição (knowledge 0026 a depositar na onda)
"Auto-ID e família do auditor são load-bearing para a diversidade ≠-família, mas eram
instrução escrita, não gate. Um parecer relatado no chat pode (i) não existir no disco,
(ii) não se autoidentificar, (iii) mislabelar a própria família. Antes de contar um
parecer para a diversidade, verifique o ARQUIVO no disco e o `SOU:` canônico. G-AUDITOR-ID
torna isso enforçado: sem `SOU:` canônico e família coerente, o parecer não entra no
livro-razão."

## 7. Onda proposta (escopo)
safe_track, readback dedicado, ~6 commits:
1. abre readback;
2. `guards/data/auditor-families.txt` (mapa canônico);
3. `guards/assert-auditor-id.sh` (G-AUDITOR-ID, Camada 1) + entrada no runner;
4. burlas na adversarial-battery + casos em run-guard-tests;
5. knowledge 0026 + INDEX;
6. STATE + handoff.
Cross-audit ≠-OpenAI (com o guard se aplicando aos próprios pareceres da onda — dogfood
imediato) → hearback → selagem. Camada 2 (diversidade) em fast-follow.
