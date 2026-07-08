---
path: .hbn/results/20260619-120000-antigravity-cross-ia-g-copy-0064.md
id-global: 20260619-120000-antigravity-cross-ia-g-copy-0064
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0064: SIM"
arvore: fronteira
created_at: "2026-06-19T12:00:00-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

## Verificações no Disco e Execuções Reais

Este parecer de auditoria cruzada foi realizado de forma independente e direta sobre o estado físico do disco no branch `proposta/reestruturacao-m-a-s0` no commit `0b3b924beb496f44fec3e4560c31c364c9dc204c`.

### 1. Integridade da Main e do HEAD
- **Main Commit**: `git rev-parse main`
  - Saída: `4db692876381a0d7909985c8500d999f2e677b04` (Conforme exigido)
- **HEAD Commit**: `git rev-parse HEAD`
  - Saída: `0b3b924beb496f44fec3e4560c31c364c9dc204c`
- **Trailers do Commit 0b3b924**:
  - Comando: `git log -1 0b3b924`
  - Verificação: Os trailers `HBN-Readback: 0064`, `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)` e `HBN-Token-FP: 34a7f2f9` estão presentes e são contíguos no último parágrafo do commit.

### 2. Escopo do Readback 0064 e Files Allowed
- **Readback File**: [0064-w-copy-g-copy.json](file:///Users/macbookpro/Projetos/usehbn/.hbn/readbacks/0064-w-copy-g-copy.json)
  - `status` é `"implemented_pending_cross_audit"` (não vigente).
- **Files Allowed**: O diff entre `main` (`4db6928`) e `HEAD` (`0b3b924`) contém exatamente os 9 arquivos descritos no readback:
  1. `guards/assert-copy-block.sh`
  2. `guards/hbn-guards-runner.sh`
  3. `guards/tests/run-guard-tests.sh`
  4. `guards/tests/adversarial-battery.sh`
  5. `.hbn/messages/20260618-214500-opus-4-8-despacho-g-copy.md`
  6. `.hbn/readbacks/0064-w-copy-g-copy.json`
  7. `.hbn/relay/STATE.md`
  8. `REGISTRY.md`
  9. `.hbn/attestations/34a7f2f9-orq-entrada.json`

### 3. Mecanismo G-COPY (assert-copy-block.sh)
- O guard [assert-copy-block.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-copy-block.sh) foi verificado linha por linha:
  - Exige **exatamente um** bloco delimitado por `⟦HBN-COPY dest=...⟧ BEGIN` e `⟦HBN-COPY END⟧` em novos despachos/prompts adicionados.
  - O destino `dest` é validado contra os apelidos de [auditor-families.txt](file:///Users/macbookpro/Projetos/usehbn/guards/data/auditor-families.txt) união `{codex, human}`.
  - O payload entre `BEGIN` e `END` não pode ser vazio.
  - A validação lê o blob staged (`git show :path` ou `HEAD:path` em CI), e nunca a working tree (evitando falsos negativos causados por skews de staged/working tree).
  - Legados já rastreados não são retroavaliados.
  - Não há colisão com o token `⟦HBN⟧` de G-PTR (visto que `⟦HBN-COPY` contém o caractere `-` logo após `N`, enquanto G-PTR exige o caractere `⟧` adjacente a `N`).

### 4. Bateria de Testes Automatizados (run-guard-tests.sh)
- Comando executado: `bash guards/tests/run-guard-tests.sh`
- Saída: `== resumo: 227 passaram, 0 falharam ==`
- Verificação: A suíte de testes passou na sua totalidade (227 checks de governança executados e verdes, cobrindo todos os casos negativos e positivos para G-COPY e os demais guards).

### 5. Bateria Adversarial (adversarial-battery.sh)
- Comando executado: `bash guards/tests/adversarial-battery.sh`
- Saída: `BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.`
- Verificação: Todos os 62 casos de teste de burla adversariais (B1 a B62) foram corretamente bloqueados, incluindo a bateria específica para o G-COPY (B55 a B62).

### 6. Execução do Guards Runner
- Comando executado: `bash guards/hbn-guards-runner.sh`
- Saída: `[hbn-guards] Todos os guards passaram.`

## Veredito

APROVA_0064: SIM
