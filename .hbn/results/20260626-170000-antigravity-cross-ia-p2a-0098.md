---
path: .hbn/results/20260626-170000-antigravity-cross-ia-p2a-0098.md
id-global: 20260626-170000-antigravity-cross-ia-p2a-0098
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0098: SIM"
arvore: fronteira
created_at: "2026-06-26T17:00:00-03:00"
---

SOU: antigravity · familia Google · papel auditor

## Auditoria de Ratificação do Passo P2-A (install-snapshot.sh + dry-run)

Executamos a bateria completa de verificações solicitadas sobre o repositório de protocolo `usehbn` no commit `fff108e` e no projeto `Credenciamento`.

### 1. Estado do Repositório (git rev-parse)
- Comando: `git rev-parse HEAD && git rev-parse main`
- Saída:
```
fff108e16dc3cabe4d47568283a06a99ac3e279f
4db692876381a0d7909985c8500d999f2e677b04
```
*A main continua intocada no hash correto e o script + readback 0098 encontram-se no HEAD (fff108e).*

### 2. Determinismo do Snapshot
- Comando (executado duas vezes consecutivas):
```bash
bash scripts/hbn-snapshot/install-snapshot.sh --dry-run --proto . --tag v1-estavel
```
- Saída idêntica em ambas as rodadas:
```
PROTO=.
TAG=v1-estavel
COMMIT=a67e8049ed6fd4f81423ee60194a2f5896f25af0
SURFACE=core methodology schemas guards
FILE_COUNT=137
PROTOCOL_SHA256=8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1
GUARDS_PROJETO=assert-canonical-root forbid-tmp-worktree forbid-env-files forbid-legacy-paths assert-scratch-lock assert-scratch-symlink assert-scratch-ignore assert-zona-livre assert-scope-lock assert-hearback-integrity assert-no-stray-hbn assert-self-path assert-trailers-contiguous assert-report-fresh assert-readlist-rite assert-knowledge-index
GUARDS_GENOMA_EXCLUIDOS=assert-orq-entrada assert-orq-entrada-ref validate-dispatch assert-dispatch-integrity assert-registry-line assert-pointer-honest assert-arvore-label assert-auditor-id assert-audit-diversity assert-quorum-selagem assert-parallel-id freeze-gate assert-baton-token
DRY-RUN: nada escrito no projeto (TARGET=<nao informado>).
```
- Recomputação independente do manifesto (ls-tree do tag, sha256 LF-normalizado por blob, sort por path em LC_ALL=C):
```bash
INDEPENDENT_COUNT=137
INDEPENDENT_SHA256=8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1
```
*O determinismo está plenamente validado e recomputado.*

### 3. Garantia de que o Dry-Run não Altera Nada
- O diretório `.usehbn-snapshot/` não foi criado em nenhum dos dois repositórios.
- O `git status` em `usehbn` e em `Credenciamento` permanece limpo de modificações geradas pelo dry-run.

### 4. Verificação de Fail-Closed
- Comandos:
```bash
bash scripts/hbn-snapshot/install-snapshot.sh --install
bash scripts/hbn-snapshot/install-snapshot.sh --upgrade
```
- Saída e código de saída:
```
MODE --install bloqueado em P2-A; usar --dry-run/--verify-only (install/upgrade vem em P2-B sob hearback).
Exit: 3
MODE --upgrade bloqueado em P2-A; usar --dry-run/--verify-only (install/upgrade vem em P2-B sob hearback).
Exit: 3
```
*Ambos os modos falharam fechados com exit code 3.*

### 5. Análise de Superfície e Subconjuntos de Guards
- A superfície de 137 arquivos mapeia core+methodology+schemas+guards.
- O subconjunto reportado de `GUARDS_PROJETO` (16 guards) e `GUARDS_GENOMA_EXCLUIDOS` (13 guards) bate exatamente com a listagem aprovada na proposta-ponte v2. Não há vazamento ou inversão de guards de projeto/protocolo-interno.

### 6. Inspeção de Metadados do Readback 0098
- O arquivo `.hbn/readbacks/0098-p2a-install-snapshot-dryrun.json` está no estado `PROPOSED_UNTIL_CROSS_AUDIT`, na `safe_track` e com `human_status` e `hearback_status` devidamente declarados como `confirmed`. O escopo de modificações foi estritamente respeitado (somente o script + metadados na pasta de controle do protocolo).

### 7. Validação de Burlas / Teatro
- O script calcula de fato o SHA-256 e o manifesto baseados nos blobs reais do git na tag `v1-estavel`, usando a ordenação determinística `LC_ALL=C sort` e normalizando quebras de linha (`tr -d '\r'`), o que garante a neutralidade cross-OS. Não há artifícios hardcoded para forjar o hash.

### 8. Rodada de Testes de Governança
- Executamos os runners e as baterias adversariais locais no repositório de protocolo:
```
== resumo: 264 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```
*Tudo 100% verde.*

---

APROVA_0098: SIM
