---
path: .hbn/results/20260621-090000-antigravity-cross-ia-w-orq-4d-fix2-0082.md
id-global: 20260621-090000-antigravity-cross-ia-w-orq-4d-fix2-0082
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0082: SIM"
arvore: fronteira
created_at: "2026-06-21T09:00:00-03:00"
---

SOU: antigravity · familia Google · papel auditor

### Relatório de Auditoria Cruzada - W-ORQ-4d-fix-2 (Readback 0082)

Realizei a auditoria detalhada no repositório `~/Projetos/usehbn`, branch `proposta/reestruturacao-m-a-s0`, para ratificar o redesenho da integração CI por igualdade exata (Readback 0082). Seguem os resultados das verificações obrigatórias:

#### 1. Verificação do commit da branch `main`
Executado `git rev-parse main` com a seguinte saída:
```
4db692876381a0d7909985c8500d999f2e677b04
```
A branch `main` está intocada conforme esperado.

#### 2. Análise de `guards/ci-entry.sh`
O arquivo [guards/ci-entry.sh](file:///Users/macbookpro/Projetos/usehbn/guards/ci-entry.sh) contém:
```bash
#!/usr/bin/env bash
set -euo pipefail
bash guards/hbn-guards-runner.sh
bash guards/tests/run-guard-tests.sh
bash guards/tests/adversarial-battery.sh
```
*   Habilita `set -euo pipefail` (linha 2).
*   Invoca de forma real e direta os três scripts:
    *   `bash guards/hbn-guards-runner.sh` (linha 3)
    *   `bash guards/tests/run-guard-tests.sh` (linha 4)
    *   `bash guards/tests/adversarial-battery.sh` (linha 5)

#### 3. Análise de `.github/workflows/hbn-shield.yml`
O workflow [hbn-shield.yml](file:///Users/macbookpro/Projetos/usehbn/.github/workflows/hbn-shield.yml) foi analisado e validado.
O step de guards possui:
```yaml
      - name: hbn-ci-entry (modo CI — diff range, raiz canônica delegada ao local)
        env:
          HBN_DIFF_BASE: ${{ github.event.pull_request.base.sha || github.event.before }}
        run: bash guards/ci-entry.sh
```
*   Contém um único step `run: bash guards/ci-entry.sh` (linha 29).
*   Não há passos rodando os scripts de guarda soltos por fora.

#### 4. Análise de `guards/assert-ci-battery.sh`
O script de validação [guards/assert-ci-battery.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-ci-battery.sh) garante a segurança da esteira.
*   **Igualdade Exata**: A função `workflow_has_exact_entrypoint` (linhas 66-122) analisa o workflow e normaliza o comando do step comparando com `bash guards/ci-entry.sh`.
*   **Heredoc-Aware & Real Invocations**: A função `entrypoint_has_real_invocations` (linhas 124-193) valida que `guards/ci-entry.sh` contém `set -e` e invoca os scripts correspondentes fora de blocos heredoc (controlados pelo `skip_marker`), comentários ou echos.

#### 5. Execução dos Ataques de Burlas na Igualdade Exata
A suite de testes e a bateria adversarial testaram as burlas com sucesso, bloqueando todas as tentativas inválidas:
*   Workflow com `run: echo "bash guards/ci-entry.sh"` -> **BLOQUEADA** (B86)
*   Heredoc `run: | ... bash guards/ci-entry.sh ...` -> **BLOQUEADA** (B87)
*   Comentário inline `run: echo skip # bash guards/ci-entry.sh` -> **BLOQUEADA** (B85)
*   Workflow sem o step exato -> **BLOQUEADA** (B83)
*   Invocação fingida / modificada no `ci-entry.sh` -> **BLOQUEADA** (B84)
*   Caso bom (step exato + `ci-entry.sh` real) -> **PASSA** (ci-battery: workflow com entrypoint exato passa)

#### 6. Execução Local dos Testes e Baterias
*   `bash guards/hbn-guards-runner.sh`:
    ```
    [hbn-guards] Todos os guards passaram.
    ```
*   `bash guards/tests/run-guard-tests.sh`:
    ```
    == resumo: 257 passaram, 0 falharam ==
    SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
    ```
*   `bash guards/tests/adversarial-battery.sh`:
    ```
    BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
    ```

#### 7. Conformidade com Readback 0082 e Escopo
*   O status do readback em [0082-w-orq-4d-fix2-ci-entry.json](file:///Users/macbookpro/Projetos/usehbn/.hbn/readbacks/0082-w-orq-4d-fix2-ci-entry.json) está como `implemented_pending_cross_audit` (linha 7) e ativação `PROPOSED_UNTIL_CROSS_AUDIT` (linha 8).
*   Os arquivos proibidos (`guards/data/**`, `guards/hbn-guards-runner.sh`, `orchestrator-profile-spec.md`, `read-list-canonica.txt`) não foram modificados. O escopo de `files_allowed` foi estritamente respeitado.

#### 8. Investigação de Novas Burlas
Nenhuma burla adicional foi encontrada que permita desviar-se do entrypoint canônico sem disparar a suite completa. O design de igualdade exata normalizado com o parser em Python é à prova de evasão por herestring, heredoc ou comentários.

APROVA_0082: SIM
