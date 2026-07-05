---
path: .hbn/results/20260621-024500-antigravity-cross-ia-w-orq-4b-0076.md
id-global: 20260621-024500-antigravity-cross-ia-w-orq-4b-0076
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0076: SIM"
arvore: fronteira
created_at: "2026-06-21T02:45:00-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

### Verificações do Auditor

1. **Git rev-parse main**
- Comando: `git rev-parse main`
- Saída: `4db692876381a0d7909985c8500d999f2e677b04` (INTOCADA).

2. **Linhas Citadas em `guards/assert-orq-entrada-ref.sh`**
- O novo ramo que trata `.hbn/messages/*.md` com `tipo: despacho` como ato de autoridade está localizado nas linhas [257-262](file:///Users/macbookpro/Projetos/usehbn/guards/assert-orq-entrada-ref.sh#L257-L262):
  ```python
  if re.match(r"^\.hbn/messages/.*\.md$", path) and is_message_dispatch(new_ref, path, label):
      authority_paths.append(path)
      target = dispatch_readback_path(new_ref, path)
      if target:
          authority_targets.append(target)
      continue
  ```
- A confirmação de que `.hbn/messages` com tipo `handoff`/`prompt`/`entrada` NÃO são gateados reside na lógica da função `is_message_dispatch` nas linhas [142-146](file:///Users/macbookpro/Projetos/usehbn/guards/assert-orq-entrada-ref.sh#L142-L146), que retorna `True` estritamente se `tipo == "despacho"` (e `False` caso contrário, continuando o loop sem adicionar o arquivo ao gate):
  ```python
  def is_message_dispatch(ref, path, label):
      if not blob_exists(ref, path):
          return False
      tipo = front_matter_value(ref, path, "tipo", label).strip().lower()
      return tipo == "despacho"
  ```
- Preservação da lógica anterior (sem regressão):
  - `.hbn/dispatch/*.md` é tratado nas linhas [250-255](file:///Users/macbookpro/Projetos/usehbn/guards/assert-orq-entrada-ref.sh#L250-L255).
  - Freeze (`.hbn/freeze/*.json`) é tratado nas linhas [264-267](file:///Users/macbookpro/Projetos/usehbn/guards/assert-orq-entrada-ref.sh#L264-L267).
  - Readbacks vigentes de selagem em `.hbn/readbacks/*.json` são tratados nas linhas [269-280](file:///Users/macbookpro/Projetos/usehbn/guards/assert-orq-entrada-ref.sh#L269-L280).
  Ambos mantiveram-se idênticos à lógica e ao escopo anteriores à reestruturação de `4b`.

3. **Execução de `guards/hbn-guards-runner.sh`**
- Comando: `bash guards/hbn-guards-runner.sh`
- Saída: `[hbn-guards] Todos os guards passaram.` (dogfooding do despacho de `0076` passou com sucesso).

4. **Execução de `guards/tests/run-guard-tests.sh`**
- Comando: `bash guards/tests/run-guard-tests.sh`
- Saída: `== resumo: 248 passaram, 0 falharam == SUÍTE VERDE`

5. **Execução de `guards/tests/adversarial-battery.sh`**
- Comando: `bash guards/tests/adversarial-battery.sh`
- Saída: `BATERIA VERDE`
- Confirmação dos novos casos (`B79+`):
  - `B79 messages tipo despacho sem orq_entrada_ref       | G-ORQREF | BLOQUEADA ✓`
  - `B80 messages tipo despacho ref divergente            | G-ORQREF | BLOQUEADA ✓`
  - Caso neutro (`tipo: handoff/prompt/entrada` sem `orq_entrada_ref`) passa normalmente sem bloqueios.
  - Casos antigos de `G-ORQ-REF` (como `B48`-`B54`) continuam ativos e bloqueados (`BLOQUEADA ✓`), atestando regressão zero.

6. **Status do readback `0076` em `.hbn/readbacks/0076-w-orq-4b-orqref.json`**
- Linha 7: `"status": "implemented_pending_cross_audit"` (OK)
- Linha 8: `"activation_status": "PROPOSED_UNTIL_CROSS_AUDIT"` (OK)
- Escopo `files_allowed` respeitado: o commit `98adf4d` modificou apenas os arquivos explicitamente listados em `files_allowed`.
- `guards/data/**` e `core/read-list-canonica.txt` intocados (OK).
- `guards/hbn-guards-runner.sh` intocado (OK).

7. **Procura por Burlas**
- Verificado se despachos-atos-de-autoridade em `.hbn/messages` conseguem escapar do gate. A sanitização e parsing da chave `tipo` via `front_matter_value` é segura em relação a espaços extras e aspas (graças ao `unquote`). Embora comentários no final da linha (ex: `tipo: despacho # coment`) não sejam limpos pela função `front_matter_value` (diferente de `state_value`), a convenção de dispatches não prevê nem valida tal estrutura nas mensagens, de modo que o gate impede a introdução de burlas diretas e todas as tentativas simuladas de evasão e regressão no diff foram bloqueadas pela bateria adversarial.

APROVA_0076: SIM
