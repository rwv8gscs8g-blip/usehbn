---
titulo: "Parecer ADR-020/022 — Cross-IA do S1 (Endurecimento do assert-scope-lock)"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260615-112714-gemini-3-5-cross-ia-s1-scope-lock.md
id-global: 20260615-112714-gemini-3-5-cross-ia-s1-scope-lock
autoria: gemini-3-5
familia: Google
created_at: "2026-06-15T11:27:14-03:00"
---

PAPEL auditor · TOKEN gemini-3-5 · FAMÍLIA Google · CONTEXTO {99%} · "auditando do disco"

# Parecer de Auditoria Cruzada do S1 — Endurecimento do Scope Lock (ADR-022)

## Identidade
- **AUDITOR**: gemini-3-5
- **FAMÍLIA**: Google
- **ESTADO**: "auditando do disco"
- **CONFIRMAÇÃO**: Confirmo que pertenço à família Google (Gemini) e realizei a auditoria de forma independente sobre o workspace `/Users/macbookpro/Projetos/usehbn`.

---

## Veredito Geral
**APROVA_S1**: SIM
**FUROS ENCONTRADOS**: 
- **B17 candidato (Smuggling via Meta-paths)**: Qualquer arquivo arbitrário adicionado/renomeado sob caminhos de coordenação (`.hbn/messages/**`, `.hbn/bypasses/**`) é tolerado pelo `assert-scope-lock.sh` (via `META_ALWAYS_ALLOWED`) e ignorado por `assert-registry-line.sh` (não sendo classificado como artefato numerado nem orfão na raiz ou docs/).

---

## Sumário da Auditoria

### 1. Separação + Trailers
- **Comando**: `git log --oneline aa9bd3e..53b966f`
- **Comando de verificação detalhada**: `git show --stat d19f563 8b810f1 e72c56b 7d50454 53b966f`
- **Trailers**: Todos os 5 commits possuem corretamente as linhas:
  - `HBN-Readback: 0017`
  - `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)`
  - `HBN-Token-FP: 34a7f2f9`
- **Separação**: Nenhum commit mistura código/guarda com depósito de parecer ou artefatos. A branch `main` (`4db6928`) está intocada.

### 2. Readback 0017
- **Comando**: `python3 -m json.tool .hbn/readbacks/0017-endurecer-assert-scope-lock-scope-extension.json`
- **Campos verificados**:
  - `scope.files_allowed` cobre adequadamente: `.hbn/readbacks/0017-endurecer-assert-scope-lock-scope-extension.json` (ele mesmo), `REGISTRY.md`, `.hbn/relay/STATE.md`, o parecer Gemini `.hbn/results/20260615-103431-gemini-3-5-cross-ia-selagem-reestruturacao-m-a-s0.md`, `core/readback-spec.md` (spec), `guards/assert-scope-lock.sh` (guard), e os testes `guards/tests/run-guard-tests.sh` e `guards/tests/adversarial-battery.sh`.
  - `track` e `human_status` estão coerentes (`safe_track` e `confirmed` respectivamente).
  - Sem auto-emenda escondida: as regras para scope_extension estão claramente formalizadas.

### 3. Suítes de Testes
- ** run-guard-tests**: `bash guards/tests/run-guard-tests.sh` passou com 135/135 checks corretos.
- ** adversarial-battery**: `bash guards/tests/adversarial-battery.sh` passou com 16 burlas bloqueadas (B1 a B16). B16 (auto-emenda de files_allowed + uso bloqueada) verificada com sucesso.
- ** hbn-guards-runner**: `bash guards/hbn-guards-runner.sh` passou com sucesso (exit code 0).

### 4. Não-Regressão (Readback Novo)
- Em `guards/assert-scope-lock.sh` (linha ~134):
  `added = [p for p in allowed if p not in old_allowed] if base_available == "1" else []`
- Quando não há readback base no HEAD (`base_available = 0`), a lista de `added` é avaliada como vazia (`[]`), o que previne que a abertura de uma nova onda seja erroneamente tratada como extensão (evitando o bloqueio de commits com novos escopos iniciais).

### 5. Coerência da Spec
- O arquivo `core/readback-spec.md` descreve precisamente a regra de `scope_extension` (exigência de `human`, `evidence`, `created_at`, `allowed_delta`, e bloqueio de emenda+uso no mesmo commit), em perfeita simetria com a implementação do guard.

### 6. Tarefa Adversarial (Bateria Complementar Gemini)
Executada via script de testes isolado `guards/tests/adversarial-extra-gemini.sh` com os seguintes resultados:
- **Cenário A (allowed_delta incompleto)**: BLOQUEADA ✓ (G-SCO barrou alteração de files_allowed com delta divergente).
- **Cenário B (campos obrigatórios ausentes)**: BLOQUEADA ✓ (G-SCO barrou falta do campo `human`).
- **Cenário C.1 (uso de arquivo antes de estender)**: BLOQUEADA ✓ (G-SCO barrou modificação fora de escopo).
- **Cenário C.2/C.3 (uso dividido)**: PASSOU ✓ (Comitagem da extensão isolada seguida por depósito do arquivo em commit subsequente funcionou perfeitamente).
- **Cenário D (Smuggling por meta-paths)**: PASSOU ✗ (Tanto G-SCO quanto G-REG ignoram scripts ou arquivos arbitrários criados dentro de `.hbn/messages/` ou `.hbn/bypasses/`). Trata-se do candidato **B17**.
- **Cenário E (Abertura de onda nova)**: PASSOU ✓ (Readback inédito + arquivos permitidos no mesmo commit passaram normalmente).

---

## Detalhe de Execução (Evidência Mecânica)

### 1. Histórico de Commits e Trailers
```
$ git log aa9bd3e..53b966f --oneline
53b966f onda-s1: atualiza state e handoff
7d50454 onda-s1: cobre auto-emenda de scope lock
e72c56b onda-s1: endurece scope lock contra auto-emenda
8b810f1 onda-s1: registra parecer gemini de selagem
d19f563 onda-s1: abre readback 0017
```

Exemplo de trailers (commit `e72c56b`):
```
$ git show -s e72c56b
commit e72c56b79fbaa90c2de3c5dca055f26880ab8708
Author: claude-fable-5 (Cowork) <mauriciozanin@gmail.com>
Date:   Mon Jun 15 11:07:21 2026 -0300

    onda-s1: endurece scope lock contra auto-emenda
    
    HBN-Readback: 0017
    
    HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
    
    HBN-Token-FP: 34a7f2f9
```

### 2. Resultados da Bateria Extra Gemini
```
$ bash guards/tests/adversarial-extra-gemini.sh

BURLA ADVERSARIAL EXTRA (GEMINI)                         | GUARD    | RESULTADO
--------------------------------------------------------------------------------
Cenário A: allowed_delta incompleto (falta docs/outro/**) | G-SCO    | BLOQUEADA ✓
Cenário B: campo 'human' ausente no scope_extension     | G-SCO    | BLOQUEADA ✓
Cenário C.1: uso de arquivo ANTES de commitar a extensão | G-SCO    | BLOQUEADA ✓
Cenário C.2: extensão isolada e formalizada (Commit 1) | G-SCO    | PASSOU ✓
Cenário C.3: depósito de arquivos sob escopo já estendido | G-SCO    | PASSOU ✓
Cenário D.1: assert-scope-lock tolera arquivo arbitrário em meta-path | G-SCO    | PASSOU ✓
Cenário D.2: assert-registry-line tolera arquivo arbitrário em meta-path | G-REG    | PASSOU ✓
Cenário E: abertura de onda nova (base_available = 0) + arquivos | G-SCO    | PASSOU ✓

BATERIA EXTRA VERDE — todos os testes negativos/positivos se comportaram como esperado.
```

---

## Truth Barrier
- **Nível de Confiança**: 100/100.
- **Não verificado**: Execução em ambiente CI remoto. Todo o escopo de análise foi realizado localmente e os guards validaram a especificação de forma estrita.
