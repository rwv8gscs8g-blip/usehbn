---
path: .hbn/results/20260621-103000-antigravity-cross-ia-despromocao-p6-0086.md
id-global: 20260621-103000-antigravity-cross-ia-despromocao-p6-0086
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0086: SIM"
arvore: fronteira
created_at: "2026-06-21T10:30:00-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

## Verificações Realizadas

### 1. Integridade do Branch `main`
Comando: `git rev-parse main`
Saída obtida:
```
4db692876381a0d7909985c8500d999f2e677b04
```
A revisão do branch main está intocada e preservada em conformidade com as diretrizes.

### 2. Análise de Linhas em `guards/assert-arvore-label.sh`
No arquivo [assert-arvore-label.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-arvore-label.sh), foram identificadas as seguintes seções de código:
- **Ordem de classificação das árvores (fronteira < intermediaria < estavel)**:
  - Definida na função `arvore_rank` nas linhas 104 a 111.
- **Lookup da árvore anterior no REGISTRY base**:
  - Definida na função `previous_arvore_for_path` nas linhas 113 a 129, que realiza a consulta sobre o `base_blob_ref` e ignora linhas com menos de 7 colunas (desconsiderando as added e legadas de 5/6 colunas).
- **Exigência de tipo `arvore-despromocao` e readback versionado**:
  - Definida nas linhas 172 a 183. Se a árvore nova possuir um rank menor que a árvore anterior (`rank_novo < rank_anterior`), exige-se que a linha seja do tipo `arvore-despromocao` e contenha um link de readback válido.
- **Preservação da lógica de promoção e invariante `estavel => quente`**:
  - Invariante `estavel => quente` verificado nas linhas 167 a 170.
  - Lógica de promoção (exigência de `arvore-promocao` + readback para transições que não sejam de despromoção) mantida nas linhas 185 a 195.

### 3. Confirmação dos Casos de Teste (Bloqueios e Permissões)
Os seguintes casos de teste foram verificados no arquivo [run-guard-tests.sh](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh):
- **Passa**: Despromoção com `arvore-despromocao` + readback: linhas 901-908.
- **Bloqueia**: Rebaixamento de estável para fronteira sem evento correspondente: linhas 912-918.
- **Bloqueia**: Rebaixamento de intermediária para fronteira sem evento correspondente: linhas 921-928.
- **Bloqueia**: Despromoção sem referência a readback: linhas 931-938.

E na bateria adversarial do arquivo [adversarial-battery.sh](file:///Users/macbookpro/Projetos/usehbn/guards/tests/adversarial-battery.sh):
- **B88**: Despromoção `estavel->fronteira` sem evento é bloqueada (linhas 1632-1634).
- **B89**: Despromoção `intermediaria->fronteira` sem evento é bloqueada (linhas 1636-1638).
- **B90**: Despromoção sem readback versionado é bloqueada (linhas 1640-1642).

### 4. Execuções de Verificação Realizadas
- `bash guards/hbn-guards-runner.sh`:
  Retornou: `"Todos os guards passaram."`
- `bash guards/tests/run-guard-tests.sh`:
  Retornou exit code `0` com `PASS=234` e `FAIL=0` (nenhum teste falhou).
- `bash guards/tests/adversarial-battery.sh`:
  Retornou exit code `0` e status `"BATERIA VERDE"`.

### 5. Validação do Readback 0086
No arquivo [.hbn/readbacks/0086-despromocao-p6.json](file:///Users/macbookpro/Projetos/usehbn/.hbn/readbacks/0086-despromocao-p6.json):
- Linha 7: `"status": "implemented_pending_cross_audit"`
- Linha 8: `"activation_status": "PROPOSED_UNTIL_CROSS_AUDIT"`
- Escopo respeitado: Todos os arquivos modificados no último commit do branch estão cobertos pelo `files_allowed` (linhas 21-30).
- Os arquivos governamentais `read-list` ([read-list-canonica.txt](file:///Users/macbookpro/Projetos/usehbn/core/read-list-canonica.txt)), `guards/data/` ([auditor-families.txt](file:///Users/macbookpro/Projetos/usehbn/guards/data/auditor-families.txt)), `orchestrator-profile-spec` ([orchestrator-profile-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/orchestrator-profile-spec.md)) e o script do runner ([hbn-guards-runner.sh](file:///Users/macbookpro/Projetos/usehbn/guards/hbn-guards-runner.sh)) não foram alterados de forma alguma.

### 6. Busca de Burlas / Regressões
Foi realizada uma análise minuciosa no script `guards/assert-arvore-label.sh`:
- A lógica de recuperação da árvore anterior garante que modificações múltiplas ou sequenciais no mesmo arquivo sejam confrontadas contra o estado base anterior, impossibilitando bypass de rebaixamento via multiplas linhas no mesmo commit.
- A exclusão de linhas com número de colunas menor que 7 filtra adequadamente as linhas legadas do registry histórico.
- Não existem falsos-verdes ou regressões que permitam despromoções silenciosas.

APROVA_0086: SIM
