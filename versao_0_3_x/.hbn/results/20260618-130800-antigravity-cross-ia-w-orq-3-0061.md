---
path: .hbn/results/20260618-130800-antigravity-cross-ia-w-orq-3-0061.md
id-global: 20260618-130800-antigravity-cross-ia-w-orq-3-0061
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0061: SIM"
arvore: fronteira
created_at: "2026-06-18T13:08:00-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

# PARECER DE AUDITORIA CRUZADA — W-ORQ-3 / G-ORQ-REF (READBACK 0061)

- **Auditor**: antigravity (Família Google)
- **Papel**: Auditor Cruzado
- **Data/Hora**: 2026-06-18T13:08:00-03:00
- **Fase**: W-ORQ-3 / G-ORQ-REF (Readback 0061)
- **Branch**: `proposta/reestruturacao-m-a-s0`
- **HEAD Auditado**: `3da43c42cdf6884594c818ef272840bd97498f4f`

---

## 1. Verificação de Invariantes e Requisitos de Auditoria

### 1.1. `main` Intacta
- Executamos `git rev-parse main` e confirmamos que a `main` permanece inalterada em:
  `4db692876381a0d7909985c8500d999f2e677b04`

### 1.2. Escopo do Commit
- O commit `3da43c4` modifica/adiciona exatamente os 9 arquivos descritos no escopo do readback `0061-w-orq-3.json`:
  1. `.hbn/attestations/34a7f2f9-orq-entrada.json`
  2. `.hbn/messages/20260618-121842-codex-handoff-w-orq-3.md`
  3. `.hbn/readbacks/0061-w-orq-3.json`
  4. `.hbn/relay/STATE.md`
  5. `REGISTRY.md`
  6. `guards/assert-orq-entrada-ref.sh`
  7. `guards/hbn-guards-runner.sh`
  8. `guards/tests/adversarial-battery.sh`
  9. `guards/tests/run-guard-tests.sh`

### 1.3. Contiguidade dos Trailers
- A mensagem do commit `3da43c4` encerra com os trailers corretos e contíguos no último parágrafo:
  ```
  HBN-Readback: 0061
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
  ```

---

## 2. Análise da Implementação do Guard G-ORQ-REF (`assert-orq-entrada-ref.sh`)

### 2.1. Comportamento Fail-Closed Real
O guard `assert-orq-entrada-ref.sh` implementa verificações robustas e fail-closed sobre atos de autoridade do orquestrador:
- **Detecção Restrita:** Identifica atos de autoridade via `.hbn/dispatch/*.md`, `.hbn/freeze/*.json` e readbacks em `.hbn/readbacks/*.json` que tenham status `"selado"`, `"sealed"`, `"vigente"` ou cuja nomenclatura indique selagem.
- **Validação de Referência:** Exige a presença de `orq_entrada_ref` e valida se o valor corresponde exatamente a `.hbn/attestations/<fp8>-orq-entrada.json`, onde `<fp8>` deriva dos primeiros 8 caracteres do `bastao_token_sha256` vigente em `STATE.md`.
- **Existência no Índice:** Verifica se a atestação realmente existe e está indexada (usando `git cat-file`).
- **Prevenção de Auto-Repin:** Bloqueia a alteração/adição da atestação no mesmo commit que realiza o ato de autoridade, prevenindo auto-repins.

### 2.2. Reuso de `assert-orq-entrada.sh`
O script evita duplicidade de lógica delegando a validação mecânica da atestação diretamente ao guard `assert-orq-entrada.sh` vigente:
```bash
if ! bash "${SCRIPT_DIR}/assert-orq-entrada.sh"; then
    guard_fail "Atestacao referenciada por orq_entrada_ref nao passa o assert-orq-entrada.sh vigente (${EXPECTED_REF})."
    exit 1
fi
```
Isto assegura que a prova extrativa v2 (manifest, nonempty lines, fields recomputados do index) seja integralmente respeitada.

---

## 3. Resultados das Suítes de Testes

### 3.1. Suíte Geral (`run-guard-tests.sh`)
- Execução bem-sucedida, com `208 passaram, 0 falharam`.
- Os checks de `assert-orq-entrada-ref` (sucesso com ref válida, falha com ref omitido, falha com dangling/ausente, falha com fp trocado, falha com auto-repin no mesmo commit e sucesso em entrega não-autoridade sem ref) estão totalmente verdes.

### 3.2. Bateria Adversarial (`adversarial-battery.sh`)
As tentativas de burla `B48-B51` foram 100% bloqueadas:
- **B48** (despacho com `orq_entrada_ref` omitido): BLOQUEADA ✓
- **B49** (atestação referenciada ausente): BLOQUEADA ✓
- **B50** (referência com token FP trocado): BLOQUEADA ✓
- **B51** (auto-repin no mesmo commit de autoridade): BLOQUEADA ✓

---

## 4. Registro no Ledger (Linha REGISTRY)

REGISTRY: | 20260618-130800-antigravity-cross-ia-w-orq-3-0061 | .hbn/results/20260618-130800-antigravity-cross-ia-w-orq-3-0061.md | audit-result | frio | fronteira | — | 2026-06-18T13:08:00-03:00 |

---

APROVA_0061: SIM
