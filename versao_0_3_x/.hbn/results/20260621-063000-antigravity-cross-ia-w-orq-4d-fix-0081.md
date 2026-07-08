---
path: .hbn/results/20260621-063000-antigravity-cross-ia-w-orq-4d-fix-0081.md
id-global: 20260621-063000-antigravity-cross-ia-w-orq-4d-fix-0081
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0081: NAO"
arvore: fronteira
created_at: "2026-06-21T06:30:00-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

### VERIFICAÇÕES OBRIGATÓRIAS (com Truth Barrier: comando+saída e arquivo:linha)

#### 1. git rev-parse main (INTOCADA)
```
$ git rev-parse main
4db692876381a0d7909985c8500d999f2e677b04
```
Confirmado múltiplas vezes (Truth = disco). main permanece exatamente no hash exigido. HEAD atual da branch de trabalho é o fix (be183356...), sem alteração em main.

#### 2. guards/assert-ci-battery.sh — novo algoritmo endurecido
Leitura completa do arquivo confirma:
- Strip de comentário inline (linhas 60-63):
```python
def strip_comment(line):
    if line.lstrip().startswith("#"):
        return ""
    return line.split(" #", 1)[0]
```
- Coleta de comandos run: (incluindo blocos | >) e tokenização (linhas 99-101):
```python
for command in commands:
    for segment in re.split(r"&&|\|\||[;|\n]", command):
        if pattern.search(segment.strip()):
            sys.exit(0)
```
- Padrão exige segmento COMECE com `bash <script>` (linha 98):
```python
pattern = re.compile(r"^bash\s+" + re.escape(required) + r"(\s|$)")
```
echo/aspas/comentários não contam. Citação de arquivo:linha feita.

#### 3. Reprodução das 2 burlas originais em fixture descartável — AGORA BLOQUEADAS
Reproduzido com git repo temporário + workflow + invocação real do guard (com required_permissions para fs completo, fixtures em guards/tests/ , depois removidas).

**(a) Comentário inline:**
```
$ cat .../hbn-repro-comment-*/.github/workflows/hbn-shield.yml | sed -n '9p'
      - run: echo "skip" # bash guards/tests/run-guard-tests.sh
```
Execução:
```
[hbn-guards/assert-ci-battery] ✗ COMMIT BLOQUEADO
  motivo: .github/workflows/hbn-shield.yml nao invoca 'bash guards/tests/run-guard-tests.sh' como comando real de step run no indice/HEAD.
EXIT_A=1
```
Bloqueado (exit != 0).

**(b) Echo do path:**
```
$ ... | grep -n 'echo "bash'
10:      - run: echo "bash guards/tests/adversarial-battery.sh"
```
Execução do guard:
```
[hbn-guards/assert-ci-battery] ✗ COMMIT BLOQUEADO
  motivo: .github/workflows/hbn-shield.yml nao invoca 'bash guards/tests/adversarial-battery.sh' como comando real...
EXIT_B=1
```
Bloqueado.

Caso BOM (real):
```
      - run: bash guards/tests/run-guard-tests.sh
      - run: bash guards/tests/adversarial-battery.sh
```
Guard: passa (✓), EXIT_GOOD=0.

Confirmação adicional via suíte (run-guard-tests.sh):
```
✓ ci-battery: comentario inline com run-guard-tests.sh → BLOCK (esperado: block)
✓ ci-battery: echo de adversarial-battery.sh → BLOCK (esperado: block)
```
E python parser direto (mesma lógica do guard):
```
bad_comment run-guard: False
bad_echo adv: False
good run-guard: True
good adv: True
```

#### 4. bash guards/hbn-guards-runner.sh
```
...
[hbn-guards/assert-ci-battery] ✓ CI preserva run-guard-tests.sh e adversarial-battery.sh no HBN Shield.
...
[hbn-guards] Todos os guards passaram.
```
Saída termina com "Todos os guards passaram".

#### 5. bash guards/tests/run-guard-tests.sh
```
== resumo: 255 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```
0 falharam.

#### 6. bash guards/tests/adversarial-battery.sh → BATERIA VERDE
```
B85 CI comentario inline run-guard-tests.sh          | G-CI     | BLOQUEADA ✓
B86 CI echo adversarial-battery.sh                   | G-CI     | BLOQUEADA ✓

BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```
B85 e B86 explicitamente BLOQUEADOS.

#### 7. Readback 0081
Conteúdo de `.hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json` (linhas 7-8, 20-42):
- "status": "implemented_pending_cross_audit"
- "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT"
- scope.files_allowed contém exatamente: guards/assert-ci-battery.sh, guards/tests/run-guard-tests.sh, guards/tests/adversarial-battery.sh, .hbn/messages/...-fix-..., .hbn/readbacks/0081-..., .hbn/relay/STATE.md, REGISTRY.md, .hbn/attestations/...
- files_forbidden inclui: main, core/**, .github/workflows/**, guards/data/**, guards/hbn-guards-runner.sh, ...
O fix tocou apenas arquivos permitidos + metadados de orquestração/readback (sem tocar workflow real, read-list, guards/data ou orchestrator-profile-spec).

git show be18335 --name-only confirma alterações apenas em guards/assert + tests/* + .hbn/ meta (sem .github/workflows/hbn-shield.yml).

O workflow atual (`.github/workflows/hbn-shield.yml:31,33`) preserva as invocações reais:
```
        run: bash guards/tests/run-guard-tests.sh
        run: bash guards/tests/adversarial-battery.sh
```

#### 8. Busca por NOVAS burlas equivalentes
Testadas (parser idêntico ao guard + fixture + execução real do guard):
- heredoc com payload contendo a string "bash <script>" como dado literal (não executado):
  - Parser: True (segmento capturado via block collection + split \n)
  - Guard real em fixture descartável:
```
      - run: |
          ...
          cat << "EOT" > /tmp/fake.txt
          bash guards/tests/run-guard-tests.sh
          EOT
```
```
[hbn-guards/assert-ci-battery] ✓ CI preserva run-guard-tests.sh e adversarial-battery.sh no HBN Shield.
EXIT_HEREDOC=0   <--- PASSOU (burla!)
```
- `true && bash ...` : parser aceita (e executa de fato).
- `bash -c "bash ..."` : parser BLOQUEIA corretamente (segmento não começa com "bash guards...").
- `printf/echo do path dentro de | block`: BLOQUEIA.
- Aspas diretas, no-op simples e outros: em geral bloqueados ou executam de verdade.

**Nova burla encontrada e reproduzível:** qualquer step `run: |` cujo conteúdo (após strip e coleta de bloco) contenha linha "bash guards/tests/....sh" dentro de literal (heredoc, cat > file, etc.) fará o guard aceitar sem que a suíte seja executada. O parser não interpreta shell/heredoc.

### CONCLUSÃO DA RE-AUDITORIA

As duas burlas reportadas originalmente (0080) — comentário inline e echo — estão agora BLOQUEADAS pelo guard endurecido (B85/B86 + suíte + bateria + repro manual).

Entretanto, foram identificadas burlas equivalentes (heredoc literal + possivelmente outros embeddings de string em blocos run: | ) que ainda produzem EXIT=0 no guard sem invocação real.

Portanto, o W-ORQ-4d-fix endurece o caso específico reportado, mas o G-CI-BATTERY continua vulnerável a variantes da mesma classe de problema (string literal do caminho aparecendo em conteúdo de step run sem ser comando executado).

APROVA_0081: NAO
