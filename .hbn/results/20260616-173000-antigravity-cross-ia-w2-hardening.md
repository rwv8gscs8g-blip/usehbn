---
titulo: "Antigravity — cross-audit W2 hardening de guards"
tipo: result
status: active
temperatura: frio
id-global: 20260616-173000-antigravity-cross-ia-w2-hardening
path: .hbn/results/20260616-173000-antigravity-cross-ia-w2-hardening.md
autor: antigravity
created_at: "2026-06-16T17:30:00-03:00"
---

APROVA_0034: SIM

# Relatório de Cross-Audit: Onda W2 (Hardening de Guards)
- **Auditor**: Antigravity (família distinta do implementador `codex`)
- **Branch**: `proposta/reestruturacao-m-a-s0` @ `635e01b`
- **Base**: `2d4ad86`
- **Main**: `4db6928` (verificado)
- **Readback Ativo**: `0034-hardening-guards` (arquivo [.hbn/readbacks/0034-hardening-guards.json](file:///Users/macbookpro/Projetos/usehbn/.hbn/readbacks/0034-hardening-guards.json))
- **Handoff**: [.hbn/messages/20260616-194500-codex-handoff-w2-hardening.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/messages/20260616-194500-codex-handoff-w2-hardening.md)
- **Data da Auditoria**: 2026-06-16

---

## 1. Verificação de Escopo e Integridade (A7, A6)

- **Arquivos Modificados no Range (`2d4ad86..635e01b`)**:
  Fiz a checagem com `git diff --name-only` e constatei exatamente os 14 arquivos autorizados pelo readback 0034:
  1. `.hbn/messages/20260616-194500-codex-handoff-w2-hardening.md`
  2. `.hbn/readbacks/0034-hardening-guards.json`
  3. `.hbn/relay/STATE.md`
  4. `REGISTRY.md`
  5. `guards/README.md`
  6. `guards/assert-exception-traceable.sh`
  7. `guards/assert-frontdoor.sh`
  8. `guards/assert-knowledge-index.sh`
  9. `guards/assert-registry-line.sh`
  10. `guards/assert-scratch-ignore.sh`
  11. `guards/assert-scratch-lock.sh`
  12. `guards/assert-scratch-symlink.sh`
  13. `guards/tests/adversarial-battery.sh`
  14. `guards/tests/run-guard-tests.sh`
  
  Nenhum arquivo fora da lista `files_allowed` do readback foi modificado.

- **Trailers Contíguos nos 7 Commits**:
  Verifiquei as mensagens brutas com `git log` de `775dda5` a `635e01b`. Todos os 7 commits possuem os trailers obrigatórios de forma contígua no último parágrafo:
  ```text
  HBN-Readback: 0034
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
  ```

---

## 2. Auditoria e Resposta aos Pontos de Ataque

### A1. G-KNOW-INDEX ([guards/assert-knowledge-index.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-knowledge-index.sh))
- **Caso substring de "10002" para "0002"**: O guard agora usa limites estritos de token/pontuação `(^|[ /|`])basename($|[ /|`])` (linhas 55-59). O teste negativo da bateria e ataques manuais provam que citar apenas `"10002"` bloqueia se a entrada staged for `"0002"`. **BLOQUEIA.**
- **Ponteiro morto no INDEX**: O guard extrai basenames numerados citados na tabela do INDEX (via `index_referenced_knowledge_basenames`, linhas 61-67) e cruza contra arquivos físicos. Se referenciar um arquivo `NNNN-*.md` inexistente, **BLOQUEIA.**
- **Estado válido**: Passa normalmente.
- **Resultado de A1**: **Resistente.**

### A2. G-FRONTDOOR ([guards/assert-frontdoor.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-frontdoor.sh))
- **Linha única densa**: Adicionado teto de bytes `MAX_BYTES=8192` e verificação via `git cat-file -s` (linhas 44-48). Se houver poucos caracteres/linhas mas ultrapassar 8192 bytes, **BLOQUEIA por bytes.**
- **Marcadores sem espaço ou inline**: O parser de listagem foi reformulado (linhas 89-112). Um item com marcador colado (e.g. `-path`) ou marcadores inline duplicados na mesma linha serão interceptados por expressões regulares de negação de padrão. **BLOQUEIA.**
- **Caminho inexistente na read-list**: Cada path governado extraído da read-list passa por `git cat-file -e` (linhas 117-121). Se o arquivo referenciado não existir na árvore sob análise, **BLOQUEIA.**
- **Resultado de A2**: **Resistente.**

### A3. G-EXC ([guards/assert-exception-traceable.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-exception-traceable.sh))
- **Prosa no corpo x trailers finais**: A função `last_paragraph()` (linhas 138-157) isola o último parágrafo não-vazio do corpo da mensagem de commit (ou arquivo temporário). A checagem de trailers só é executada nesse bloco isolado. Prosa contendo falsos trailers no meio do corpo, sem a devida presença estrutural ao final, **BLOQUEIA.**
- **Trailers contíguos no último parágrafo**: É o único padrão que **PASSA**, tanto no modo hook `commit-msg` quanto em CI (`HBN_DIFF_BASE`).
- **Resultado de A3**: **Resistente.**

### A4. G-SCRATCH fail-closed ([guards/assert-scratch-*.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-scratch-*.sh))
- **Active-version ausente ou ilegível**: Os três guards de scratch (`assert-scratch-lock.sh`, `assert-scratch-symlink.sh` e `assert-scratch-ignore.sh`) efetuam chamada early a `get_canonical_root >/dev/null`. Se este retornar erro (versão ativa nula, conflito de merge, ou valor inválido), os guards exibem o erro do ponteiro e abortam imediatamente com status 1. **BLOQUEIA (fail-closed).**
- **Resultado de A4**: **Resistente.**

### A5. G-REG ([guards/assert-registry-line.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-registry-line.sh))
- **Comentário de status**: A linha 11 do header foi atualizada para `# status: accepted ... — ESTA no runner.`. Confirmei que o arquivo `guards/hbn-guards-runner.sh` na linha 61 de fato contém `"assert-registry-line.sh"` ativo no pipeline.
- **Resultado de A5**: **Verificado e conforme.**

### A6. Sem Regressão
- A suíte de testes (`run-guard-tests.sh`) executou com **175/175 casos passando com sucesso** (Verde completo).
- A bateria adversarial (`adversarial-battery.sh`) executou com sucesso e atesta bloqueio completo de todas as burlas de **B1 a B32**.
- O runner principal (`guards/hbn-guards-runner.sh`) está verde e passa no repositório limpo.
- `main` permanece em `4db6928`.
- **Resultado de A6**: **Verificado e conforme.**

### A8. Leveza e Vetores Novos
- Os patches são focados e minimalistas. Eles utilizam funcionalidades nativas de POSIX awk, sed e grep de forma robusta e eficiente.
- A ancoragem do último parágrafo e o parser de marcadores e caminhos da read-list de frontdoor representam implementações elegantes sem sobrecarga de runtime.
- Não foram abertos novos vetores de ataque decorrentes dessas modificações, pois todas aumentaram a restritividade dos guards.

---

## 3. Veredito e Marginais

- **Marginais**: 
  Nenhum. No nosso ambiente de testes, tanto a suíte inteira quanto a bateria adversarial rodaram em conformidade total de 175/175 e B1-B32 sem ruídos significativos ou falhas espúrias.
- **Confiança**: **100/100** (Verificação física completa baseada na Truth Barrier, com logs, diffs e execuções verificadas de ponta a ponta no workspace).

**Assinatura**: Antigravity
**Data**: 2026-06-16
