---
path: .hbn/results/20260618-151334-antigravity-cross-ia-w-orq-3b-0062.md
id-global: 20260618-151334-antigravity-cross-ia-w-orq-3b-0062
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0062: SIM"
arvore: fronteira
created_at: "2026-06-18T15:13:34-03:00"
---

SOU: antigravity · familia Google · papel auditor

APROVA_0062: SIM

# PARECER DE AUDITORIA CRUZADA — W-ORQ-3b / DEADLOCK EXITS (READBACK 0062)

- **Auditor**: antigravity (Família Google)
- **Papel**: Auditor Independente
- **Data/Hora**: 2026-06-18T15:13:34-03:00
- **Fase**: W-ORQ-3b (Readback 0062)
- **Branch**: `proposta/reestruturacao-m-a-s0`
- **HEAD Auditado / Commit**: `426fdd76f7d56c177e0709737a97e844b008abeb`

---

## 1. Verificação de Invariantes e Requisitos de Auditoria

### 1.1. `main` Intacta
- **Evidência no disco:** Executamos `git rev-parse main` e obtivemos a seguinte saída:
  ```
  4db692876381a0d7909985c8500d999f2e677b04
  ```
  O HEAD de `main` permaneceu intacto e imutável.

### 1.2. Escopo de Arquivos Modificados
- **Evidência no disco:** O commit `426fdd7` altera exclusivamente os seguintes caminhos autorizados em `scope.files_allowed` de `.hbn/readbacks/0062-w-orq-3b.json`:
  - `.hbn/attestations/34a7f2f9-orq-entrada.json`
  - `.hbn/messages/20260618-134916-opus-4-8-despacho-w-orq-3b.md`
  - `.hbn/messages/20260618-153000-codex-handoff-w-orq-3b.md`
  - `.hbn/readbacks/0062-w-orq-3b.json`
  - `.hbn/relay/STATE.md`
  - `REGISTRY.md`
  - `guards/assert-orq-entrada-ref.sh`
  - `guards/assert-orq-entrada.sh`
  - `guards/tests/adversarial-battery.sh`
  - `guards/tests/run-guard-tests.sh`
  Nenhum arquivo fora da allowlist foi modificado.

### 1.3. Trailers Contíguos
- **Evidência no disco:** `git show --no-patch --format=%B 426fdd7` confirma os trailers contíguos no último parágrafo:
  ```
  HBN-Readback: 0062
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
  ```

### 1.4. Resolução do Deadlock (Dogfood P1 e Casos N1-N6)
Executamos as suítes de teste locais de ponta a ponta:
- **`bash guards/tests/run-guard-tests.sh`**: Finalizou reportando `== resumo: 217 passaram, 0 falharam ==` (exit 0).
  - O caso **P1** (`orq-ref P1: selagem real same-fp passa G-ORQ + G-ORQ-REF`) passou com sucesso. Isso prova de forma inequívoca que a selagem com regeneração legítima da atestacao de mesmo fingerprint (mesmo token de bastão) contendo um `manifest_sha256` atualizado passa. O deadlock de auto-repin ampla está resolvido.
- **`bash guards/tests/adversarial-battery.sh`**: Finalizou com **BATERIA VERDE** (exit 0).
  - Todas as burlas de B48 a B54 foram bloqueadas com sucesso, garantindo o comportamento fail-closed.

---

## 2. Análise de Fail-Closed Real (N1-N6) e Simetria

A implementação de `assert-orq-entrada-ref.sh` em `426fdd7` garante:

1. **N1 (Selagem sem regeneração real):** Se a atestação não for atualizada, o guard bloqueia a selagem no `assert-orq-entrada.sh` porque a prova de linhas dinâmicas de leitura de arquivos mudou (com o STATE apontando para o novo readback).
2. **N2 (Atestação decorativa):** Se a atestação apenas mudar de formato ou notas sem atualizar o `manifest_sha256`, `assert-orq-entrada-ref.sh` bloqueia (pois `old_manifest == new_manifest`).
3. **N3 (Fingerprint JSON trocado):** Bloqueia se o `bastao_token_fp` da atestação divergir do esperado pelo STATE.
4. **N4 (Atestação extra):** Se qualquer outra atestação de bastão for enviada no commit, o guard bloqueia (`len(attestation_entries) != 1`).
5. **N5 (Troca completa de bastão com mesmo FP):** Bloqueia se o `bastao_token_sha256` completo do STATE for trocado (mesmo contendo o mesmo FP de 8 caracteres).
6. **N6 (Identidade divergente):** Bloqueia se `proprietario_bastao` ou `identidade` da atestação diferirem da base.
7. **Simetria Local/CI:** Em ambiente local, compara a working tree/índice com `HEAD`; em CI, lê as revisões no range `HBN_DIFF_BASE..HEAD` e compara `commit^:path` com `commit:path`, garantindo simetria absoluta e semântica equivalente.
8. **Reuso de assert-orq-entrada.sh:** O script principal `assert-orq-entrada-ref.sh` delega a validação mecânica e extrativa final invocando diretamente `bash assert-orq-entrada.sh`, com a variável de ambiente `HBN_ORQ_ENTRADA_GIT_REF` apontando para a referência do commit de autoridade correspondente.

---

## 3. Registro no Ledger (Linha REGISTRY)

REGISTRY: | 20260618-151334-antigravity-cross-ia-w-orq-3b-0062 | .hbn/results/20260618-151334-antigravity-cross-ia-w-orq-3b-0062.md | audit-result | frio | fronteira | — | 2026-06-18T15:13:34-03:00 |
