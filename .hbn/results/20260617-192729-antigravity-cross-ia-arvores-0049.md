---
path: .hbn/results/20260617-192729-antigravity-cross-ia-arvores-0049.md
id-global: 20260617-192729-antigravity-cross-ia-arvores-0049
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0049: SIM"
onda: arvores-registry-centric / readback 0049
created_at: "2026-06-17T19:27:29-03:00"
---

SOU: antigravity · familia Google · papel auditor

# PARECER DE AUDITORIA CRUZADA — R2 ÁRVORES REGISTRY-CENTRIC (READBACK 0049)

- **Auditor**: antigravity (Família Google)
- **Papel**: Auditor Independente
- **Data/Hora**: 2026-06-17T19:27:29-03:00
- **Fase**: R2 (Mecanismo de Árvores Registry-Centric)
- **Readback Referenciado**: `0049-arvores-registry-centric`
- **Branch**: `proposta/reestruturacao-m-a-s0`
- **HEAD Auditado**: `9f35486` (R2 C6 registra handoff arvores)
- **Diferença de Commits**: `2809fb9..9f35486` (6 commits)

---

## 1. ANÁLISE DOS PONTOS DE ATAQUE

### A1. COLUMN-AWARE (Prove os dois lados)
- **Lado Legado (6 colunas)**: As linhas legadas com 6 colunas (id, path, tipo, temperatura, superseded_by, created_at) continuam plenamente válidas. O parser do guard `assert-registry-line.sh` ignora caminhos modificados (M) via `diff-filter=AR`, evitando regressão em arquivos já registrados. O guard `assert-parallel-id.sh` utiliza `idx=NF-1` no `awk` para ler a coluna `created_at` (a última coluna de dados), o que avalia com sucesso a 7ª coluna nas linhas legadas (NF=8).
- **Lado Novo (7 colunas)**: A nova coluna `arvore` na 5ª posição (6º campo lógica, NF=9) é obrigatória para nascimentos novos (Added/Renamed). `assert-registry-line.sh` exige a presença de uma coluna `arvore` válida (`fronteira`, `intermediaria` ou `estavel`) e bloqueia novos depósitos sem ela.
- **Evidência Mecânica**: Os testes da suíte (`run-guard-tests.sh`) cobrem ambos os lados:
  - `num: paralelo com HHMMSS-agente válido + created_at` (passa com 6 colunas)
  - `num: linha de 7 colunas com arvore+created_at passa no G-REG` (passa com 7 colunas)

### A2. G-ARVORE-LABEL
O guard `assert-arvore-label.sh` protege rigorosamente as transições e rótulos de árvore:
- **i. Bloqueio de nascimento em intermediária/estável sem promoção**: Se uma nova linha rotula um arquivo como `intermediaria` ou `estavel`, mas seu tipo não for `arvore-promocao`, o guard rejeita com falha explícita.
- **ii. Bloqueio de estável com temperatura != quente**: A invariante `estavel => quente` é enforcada explicitamente no guard (linha 125).
- **iii. Bloqueio de valor de árvore inválido**: O guard valida se a árvore pertence à allowlist `fronteira|intermediaria|estavel`, falhando com qualquer outra entrada.
- **iv. Liberação de fronteira válida**: A árvore `fronteira` não exige promoção e passa diretamente se a temperatura e estrutura estiverem corretas.
- **Evidência de burla B38**: A burla `B38 arvore estavel sem promocao` em `guards/tests/adversarial-battery.sh` tenta registrar um nascimento estável sem evento correspondente de promoção e foi bloqueada com sucesso.

### A3. PROMOÇÃO APPEND-ONLY
- **Design append-only**: A especificação `core/arvores-spec.md` (linhas 44-46) e o guard `guards/assert-arvore-label.sh` proíbem a edição em-lugar da linha original para alteração de árvore.
- **Bloqueio Mecânico**: Qualquer modificação em-lugar no arquivo `REGISTRY.md` gera um par `-` e `+` no diff git. O guard interpreta o `+` como uma nova linha adicionada. Uma vez que o tipo original da linha (por exemplo, `spec-core`) não é `arvore-promocao`, o guard bloqueia a operação, forçando o registro da promoção a ser feito exclusivamente por meio de uma nova linha de evento `arvore-promocao` que referencie o readback associado.

### A4. G-NUM (assert-parallel-id.sh)
- **Localização exata da leitura de `created_at`**: A função `registry_last_cell` está definida em [assert-parallel-id.sh:180-182](file:///Users/macbookpro/Projetos/usehbn/guards/assert-parallel-id.sh#L180-L182).
- **Implementação column-aware**: 
  ```bash
  registry_last_cell() {
      awk -F'|' '{ idx=NF-1; gsub(/^[ \t]+|[ \t]+$/,"",$idx); print $idx }' <<< "$1"
  }
  ```
  Isso resolve dinamicamente o campo com base no número total de campos (`NF`). Em blocos legados (NF=8), lê o campo 7. Em blocos de 7 colunas (NF=9), lê o campo 8. Ambos funcionam sem quebrar o legado.

### A5. SPEC
- A especificação em `core/arvores-spec.md` estabelece o REGISTRY como a única fonte da verdade (registry-centric).
- Não há definição de metadados de árvore no front-matter de arquivos, nem parser YAML ou compiladores complexos.
- Reutiliza corretamente os 8 critérios objetivos de exúvia definidos em `core/exuvia-fitness-criteria.md`.
- Garante o invariante `estavel` => `temperatura=quente`.
- Documenta de forma transparente e honesta os elementos adiados para R3 ou ondas futuras.

### A6. LEVEZA (P11)
- O modelo append-only no REGISTRY para a promoção é muito mais simples e seguro do que criar ou estender mechanisms de M-watching (metadados gerais no front-matter). Ele evita o overhead de parsing e possíveis brechas de segurança.
- Os itens adiados (selagem dos 4 batch1, G-REG-M geral, exúvia) estão corretamente listados fora do escopo no readback 0049 e no handoff.

---

## 2. VERIFICAÇÃO DOS LIMITES (N1, N2, N3)

### N1. ESCOPO
O diff de nomes executado via `git diff --name-only e2fab42..9f35486` revela que **apenas os 11 arquivos autorizados** no readback foram tocados:
- `.hbn/messages/20260617-184500-codex-handoff-arvores.md`
- `.hbn/readbacks/0049-arvores-registry-centric.json`
- `.hbn/relay/STATE.md`
- `REGISTRY.md`
- `core/arvores-spec.md`
- `guards/assert-arvore-label.sh`
- `guards/assert-parallel-id.sh`
- `guards/assert-registry-line.sh`
- `guards/hbn-guards-runner.sh`
- `guards/tests/adversarial-battery.sh`
- `guards/tests/run-guard-tests.sh`

Nenhum código sob `src/`, `methodology/`, `schemas/` ou outras specs de `core/` foi modificado.
Os 4 arquivos de resultados da fronteira batch1 continuam untracked:
- `.hbn/results/20260616-230608-cursor-composer-cross-ia-batch1-fronteira.md`
- `.hbn/results/20260616-230708-grok-build-0.1-cross-ia-batch1-fronteira.md`
- `.hbn/results/20260616-230838-antigravity-cross-ia-batch1-fronteira.md`
- `.hbn/results/20260616-231038-gpt-5-cross-ia-batch1-fronteira.md`

### N2. SUÍTE DE TESTES
- **run-guard-tests**: Executado localmente. Fechou **187 checks passed, 0 failed** com sucesso.
- **adversarial-battery**: Executado localmente. Fechou **BATERIA VERDE** com todas as 39 burlas (B1 a B38) bloqueadas.
- **pytest**: Executado via interpretador do ambiente virtual (`.venv/bin/pytest`). Fechou **213 passed**.

### N3. TRILHA DE COMMITS
- O tip da branch proposta está sob o commit `9f35486` e a main em `4db6928`.
- Todos os 6 commits possuem trailers contíguos obrigatórios informando readback, autorização humana de Maurício e token do bastão:
  - `HBN-Readback: 0049`
  - `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)`
  - `HBN-Token-FP: 34a7f2f9`
- O STATE.md registrou corretamente a exceção G-EXC como `PROPOSED_UNTIL_CROSS_AUDIT` desde o commit C1.

---

## VEREDITO DE AUDITORIA

**APROVA_0049: SIM**

- **Confiança**: 100/100
- **Assinatura**: antigravity (Família Google)
- **Data**: 2026-06-17
