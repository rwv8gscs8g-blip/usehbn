---
path: .hbn/results/20260621-010000-antigravity-cross-ia-w-orq-4a-0074.md
id-global: 20260621-010000-antigravity-cross-ia-w-orq-4a-0074
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0074: SIM"
arvore: fronteira
created_at: "2026-06-21T01:00:00-03:00"
---

SOU: antigravity · familia Google · papel auditor

### Bateria de Verificações do Auditor

#### 1. Verificação da Integridade da Branch `main`
* **Comando executado**: `git rev-parse main`
* **Saída obtida**: `4db692876381a0d7909985c8500d999f2e677b04`
* **Parecer**: A branch `main` permanece intocada e coerente com a verdade do repositório.

#### 2. Análise de Linhas em `guards/assert-readlist-rite.sh`
* **Gatilho de modificação**:
  * Linha 22: `READLIST_PATH="core/read-list-canonica.txt"`
  * Linhas 29-35:
    ```bash
    diff_am_files() {
        if [[ -n "${HBN_DIFF_BASE:-}" ]]; then
            git diff --name-only --diff-filter=AM "${HBN_DIFF_BASE}...HEAD" 2>/dev/null || true
        else
            git diff --cached --name-only --diff-filter=AM 2>/dev/null || true
        fi | guard_paths_to_version_paths
    }
    ```
  * Linhas 48-60: Filtra se `core/read-list-canonica.txt` foi adicionado ou modificado.
* **Exigência de rito (readback staged com read_list_rite não-vazio e human_status confirmed)**:
  * Linhas 75-87: Filtra arquivos no formato `.hbn/readbacks/*.json` no diff staged.
  * Linhas 94-149: Validação através de script python3 embarcado. Em especial, linhas 131-133:
    ```python
            rite = data.get("read_list_rite")
            human_status = data.get("human_status")
            if isinstance(rite, str) and rite.strip() and human_status == "confirmed":
    ```
* **Fail-Closed**:
  * Em qualquer falha de validação ou erro de leitura do JSON, o guard bloqueia e encerra com código `1` ou `2`. Linhas 64, 91, 139, 148 e 152.
* **Guard Bypass Check**:
  * Linhas 18-20:
    ```bash
    if guard_check_bypass; then
        exit 0
    fi
    ```

#### 3. Integração no Runner (`guards/hbn-guards-runner.sh`)
* **Comando executado**: `grep -n assert-readlist-rite guards/hbn-guards-runner.sh`
* **Saída obtida**: `93:    "assert-readlist-rite.sh"`
* **Parecer**: O guard está devidamente integrado no runner na linha 93.

#### 4. Execução do Runner
* **Comando executado**: `bash guards/hbn-guards-runner.sh`
* **Saída obtida**:
  ```
  [hbn-guards] Iniciando bateria de guards de governança…
  ---
  ...
  [hbn-guards/assert-readlist-rite] ✓ Read-list canonica nao foi adicionada/modificada neste diff — G-READLIST-RITE nao opina.
  ...
  [hbn-guards] Todos os guards passaram.
  ```

#### 5. Execução da Suíte de Testes dos Guards
* **Comando executado**: `bash guards/tests/run-guard-tests.sh`
* **Saída obtida**:
  ```
  == assert-readlist-rite (G-READLIST-RITE) ==
    ✓ readlist-rite: read-list A/M com rito confirmed passa (esperado: pass)
    ✓ readlist-rite: read-list A/M sem readback staged → BLOCK (esperado: block)
    ✓ readlist-rite: readback staged sem read_list_rite → BLOCK (esperado: block)
    ✓ readlist-rite: read_list_rite com human_status != confirmed → BLOCK (esperado: block)
    ✓ readlist-rite: diff neutro sem read-list passa (esperado: pass)
  ...
  == resumo: 244 passaram, 0 falharam ==
  SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
  ```

#### 6. Execução da Bateria Adversarial
* **Comando executado**: `bash guards/tests/adversarial-battery.sh`
* **Saída obtida**:
  ```
  B76 read-list A/M sem readback staged                | G-READ   | BLOQUEADA ✓
  B77 readback sem read_list_rite                      | G-READ   | BLOQUEADA ✓
  B78 human_status != confirmed                        | G-READ   | BLOQUEADA ✓

  BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
  ```
* **Parecer**: As burlas B76, B77 e B78 estão cobertas e bloqueadas perfeitamente. O caso neutro (commit sem tocar a read-list passa) é validado com sucesso pela suíte de testes.

#### 7. Validação do Readback 0074
* **Arquivo lido**: `.hbn/readbacks/0074-w-orq-4a-readlist-rite.json`
* **Parecer**:
  * `status` é exatamente `"implemented_pending_cross_audit"` (linha 7).
  * `activation_status` é exatamente `"PROPOSED_UNTIL_CROSS_AUDIT"` (linha 8).
  * `scope` de `files_allowed` (linhas 21-31) e `files_forbidden` (linhas 32-33) foram estritamente respeitados pelo commit `985302a`.
  * O commit `985302a` **não** modificou `core/read-list-canonica.txt` nem `guards/data/**`.

#### 8. Investigação de Burlar / Red-Team
* **Bypass de Renomeação ou Remoção**: Se um invasor tentar renomear ou deletar `core/read-list-canonica.txt` para evitar o gatilho `diff-filter=AM`, o guard `assert-orq-entrada.sh` falhará imediatamente fechado no runner (pois necessita ler a read-list e exige que a lista retorne exatamente 13 caminhos existentes sob a versão ativa).
* **Drift de Histórico**: O guard valida apenas o diff staged ou o range de commits na PR (via `HBN_DIFF_BASE`), evitando falsos bloqueios sobre commits passados.

APROVA_0074: SIM
