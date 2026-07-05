---
path: .hbn/results/20260625-103000-antigravity-cross-ia-w-freeze-0092.md
id-global: 20260625-103000-antigravity-cross-ia-w-freeze-0092
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0092: SIM"
arvore: fronteira
created_at: "2026-06-25T10:30:00-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

### Verificações do Auditor

#### 1. Verificação de Revisões Git (rev-parse)
- `git rev-parse main` -> `4db692876381a0d7909985c8500d999f2e677b04` (intocada, base da ramificação).
- `git rev-parse HEAD` -> `4a3e8be6875c4211522977b0952a7ec8c474b215` (HEAD do readback 0092 proposto/reestruturação-m-a-s0).
- Estado da working tree: Árvore limpa em relação a arquivos versionados (apenas arquivos temporários/untracked resultantes de execuções anteriores).

```
$ git rev-parse main HEAD
4db692876381a0d7909985c8500d999f2e677b04
4a3e8be6875c4211522977b0952a7ec8c474b215
```

#### 2. Critérios do Checklist de Freeze do Protocolo
No arquivo [.hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json](file:///Users/macbookpro/Projetos/usehbn/.hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json):
- O checklist pertence ao escopo `useHBN PROTOCOLO v1-estavel` (não à V206).
- `bloqueadores_abertos` é `0`.
- Critérios obrigatórios com status `ok` possuem evidências correspondentes validadas em disco.
- Critérios com status `na` são específicos da V206 (domínio/rodízio) ou do operador sem chave, contendo justificativas coerentes que apontam para o hearback de homologação do protocolo `.hbn/hearbacks/freeze-protocolo-v1-estavel.json`.

#### 3. Evidência Conclusiva do Pytest Verde
A suíte do pytest foi executada no ambiente com sucesso:
```
$ .venv/bin/pytest -q
........................................................................ [ 33%]
........................................................................ [ 67%]
.....................................................................    [100%]
213 passed in 0.98s
```
Isso confirma que os testes passam integralmente (213 passed) no ambiente real. Não se trata de uma execução fictícia ("dry-run") do orquestrador.

#### 4. Evidência do Guard Runner e Bateria Adversarial
- Execução do script `run-guard-tests.sh`:
  ```
  $ bash guards/tests/run-guard-tests.sh
  ...
  == resumo: 264 passaram, 0 falharam ==
  SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
  ```
- Execução da bateria adversarial `adversarial-battery.sh`:
  ```
  $ bash guards/tests/adversarial-battery.sh
  ...
  BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
  ```
  (Cobre adequadamente todos os casos de B1-B90, incluindo correções recentes de `freeze-meta-deref` e `gexc-sigpipe`).
- Execução do `hbn-guards-runner.sh`:
  ```
  $ bash guards/hbn-guards-runner.sh
  ...
  [hbn-guards] Todos os guards passaram.
  ```

#### 5. Escopo e Limitação de Arquivos Tocados (Commit 4a3e8be)
Verificação do commit `4a3e8be` mostra que nenhuma alteração foi introduzida em arquivos proibidos (`guards/**`, `core/**`, `schemas/**`, `.hbn/hearbacks/**`, `.hbn/results/**`, `src/**`, etc.). Apenas os 6 arquivos permitidos foram alterados e estão devidamente registrados em `REGISTRY.md` e no escopo do readback:
- `.hbn/attestations/34a7f2f9-orq-entrada.json`
- `.hbn/freeze/20260624-01-freeze-protocolo-v1-estavel.json`
- `.hbn/messages/20260625-090000-opus-4-8-despacho-w-freeze-fix-checklist.md`
- `.hbn/readbacks/0092-w-freeze-fix-checklist.json`
- `.hbn/relay/STATE.md`
- `REGISTRY.md`

#### 6. Análise de Fraudes ou Burlas
Nenhuma burla identificada. Os critérios `na` são legítimos, as evidências batem exatamente com as execuções e os guards de governança estão operando em fail-closed.

APROVA_0092: SIM
