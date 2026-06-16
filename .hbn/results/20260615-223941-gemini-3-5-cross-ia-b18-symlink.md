---
titulo: "Parecer ADR-020/022/025 — Cross-IA do B18 (Bloqueio de symlink em meta-path)"
tipo: audit-result
status: final
temperatura: frio
path: .hbn/results/20260615-223941-gemini-3-5-cross-ia-b18-symlink.md
id-global: 20260615-223941-gemini-3-5-cross-ia-b18-symlink
agente: gemini-3-5
autoria: gemini-3-5
familia: Google
created_at: "2026-06-15T22:39:41-03:00"
---

PAPEL auditor · TOKEN gemini-3-5 · FAMÍLIA Google · CONTEXTO {99%} · "auditando do disco"

# Parecer de Auditoria Cruzada do B18 — Bloqueio de symlink em meta-path governado (ADR-025)

## Identidade
- **AUDITOR**: gemini-3-5
- **FAMÍLIA**: Google
- **ESTADO**: "auditando do disco"
- **CONFIRMAÇÃO**: Confirmo que pertenço à família Google (Gemini) e realizei a auditoria de forma independente sobre o workspace `/Users/macbookpro/Projetos/usehbn`.

---

## Veredito Geral
**APROVA_B18**: SIM
**FUROS ENCONTRADOS**: 1 (symlink em path governado não-`.hbn` como `core/` ou `guards/` cujo nome case com `files_allowed` passa — provável candidato a B19).

---

## Sumário da Auditoria

### 1. Separação + Trailers
- **Comando**: `git log -n 4 --format=fuller`
- **Trailers**: Os 4 commits de B18 (`889fbbb`, `703051c`, `3160a53`, `41ea34f`) acima do tip de selagem anterior `4ed86cd` possuem corretamente os trailers separados por linhas em branco:
  - `HBN-Readback: 0021`
  - `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)`
  - `HBN-Token-FP: 34a7f2f9`
- **Isolamento**: A branch `main` (`4db6928`) está intocada.
- **Linhas REGISTRY**: As linhas do REGISTRY para os artefatos de B18 estão presentes e registradas a partir da linha 592 do `REGISTRY.md`.

### 2. Readback 0021
- **Coerência**: `.hbn/readbacks/0021-b18-block-symlink-meta-path.json` está totalmente coerente.
  - `track` = `safe_track`
  - `human_status` = `confirmed`
  - `scope.files_allowed` lista estritamente apenas os arquivos governados em alteração, com caminhos regulares devidamente definidos.

### 3. Suítes de Testes
- **run-guard-tests**: `bash guards/tests/run-guard-tests.sh` passou com sucesso com **141/141** testes verdes.
- **adversarial-battery**: `bash guards/tests/adversarial-battery.sh` retornou `BATERIA VERDE` com todos os 18 cenários (B1 a B18) bloqueados com sucesso.
- **hbn-guards-runner**: `bash guards/hbn-guards-runner.sh` retornou código de saída `rc=0` (sucesso).

### 4. Coerência da Spec e do Guard
- O diff de `703051c` introduziu com sucesso a detecção do modo git `120000` via `git ls-files --stage` (pré-commit local) e `git ls-tree` (CI via `HBN_DIFF_BASE`), barrando symlinks antes de qualquer regra de auto-permissão ou scope lock para `.hbn/**`.
- O documento `guards/README.md` §Meta-paths foi devidamente atualizado para refletir a nova regra.

---

## Tarefa Adversarial (Validação de Burlas e Furos)

Foi executada uma bateria de testes isolada para investigar as tentativas de furar ou desviar do bloqueio de link simbólico introduzido em B18. A seguir estão os resultados:

- **a) symlink ADR-025 .md em .hbn/messages/ e .hbn/bypasses/**:
  - **Comportamento**: **BLOQUEADO** ✓ (`rc=1`). O guard detectou corretamente o modo `120000` no índice e impediu o commit.

- **b) symlink para diretório, e symlink apontando para FORA do repo (ex.: /etc/passwd, ~/.ssh)**:
  - **Comportamento**: **BLOQUEADO** ✓ (`rc=1`). Todos foram devidamente barrados na raiz de coordenação governada `.hbn/**`.

- **c) symlink em path governado NÃO-.hbn (guards/, core/, src/) com nome em files_allowed**:
  - **Comportamento**: **PASSA** ✗ (`rc=0`). A função `is_governed_hbn_symlink` possui um filtro rígido: `[[ "$file" == .hbn/* ]] || return 1`. Portanto, se um link simbólico (como `core/my-link.md` apontando para `/etc/passwd`) for staged e seu caminho estiver liberado em `scope.files_allowed` (por exemplo, por um glob abrangente como `core/**`), o guard B18 **não** o bloqueia.
  - **Recomendação**: Este é um furo real de segurança (smuggling de symlinks em pastas governadas não-`.hbn`). Deve ser catalogado como candidato imediato para a onda **B19**.

- **d) hardlink (mode 100644) em meta-path**:
  - **Comportamento**: **PASSA** ✓ (`rc=0`). Links físicos no Git são indistinguíveis de arquivos normais (modo `100644`). Desde que seu nome atenda à convenção ADR-025 em `.hbn/messages/` ou `.hbn/bypasses/`, ele é liberado. Isso é coerente com o comportamento do Git.

- **e) symlink cujo alvo está DENTRO do escopo**:
  - **Comportamento**: **BLOQUEADO** ✓ (`rc=1`). O guard proíbe qualquer link simbólico (modo `120000`) sob `.hbn/**`, independentemente do destino apontar para um arquivo permitido (ex: `core/alvo.md`). Coerente.

- **f) não-regressão: handoff/hearback/nota-bypass regulares (.md/.json)**:
  - **Comportamento**: **PASSAM** ✓ (`rc=0`). Os arquivos de dados regulares seguem permitidos, garantindo o progresso normal do protocolo HBN.

---

## Truth Barrier
- **Nível de Confiança**: 100/100.
- **Evidências no terminal**:
  - `bash guards/tests/run-guard-tests.sh` -> `== resumo: 141 passaram, 0 falharam ==`
  - `bash guards/tests/adversarial-battery.sh` -> `BATERIA VERDE`
  - `bash guards/hbn-guards-runner.sh` -> `[hbn-guards] Todos os guards passaram.`
  - Testes da sandbox local reproduzindo os cenários a-f e confirmando o bypass em `c`.
