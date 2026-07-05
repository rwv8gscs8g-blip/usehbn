---
titulo: "Parecer Cross-IA M-A — scaffold inativo da hbn-exuvia"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260614-193452-gemini-3-5-cross-ia-m-a-scaffold.md
id-global: 20260614-193452-gemini-3-5-cross-ia-m-a-scaffold
autoria: gemini-3-5
created_at: "2026-06-14T19:34:52-03:00"
---

# Parecer Cross-IA M-A — Scaffold Inativo da hbn-exuvia

**Auditor:** Gemini 3.5 (Google — auditor cruzado de 2ª família, independente)  
**Reviewed at:** 2026-06-14T19:34:52-03:00  

---

## Veredito
**VETO_ATIVACAO:** NÃO  
*(O scaffold é mecanicamente seguro de existir na raiz do repositório em modo inativo. Não há ativação de versão nesta onda).*

---

## Resumo para o Humano
A implementação do scaffold inativo para a máquina de transição `hbn-exuvia` na onda M-A foi auditada de forma independente. O mecanismo atinge os objetivos de segurança ao falhar fechado em todas as situações anômalas do ponteiro de versão ativa. Contudo, **identificamos uma falha crítica de projeto no script de rollback** (`scripts/hbn-exuvia-rollback.sh`) que impede ou corrompe a transição de rollback caso ela cruze fronteiras de versões ativas diferentes. Recomendamos a correção deste script antes de prosseguirmos para a onda M-C (corte real).

---

## Análise de Segurança e Ataque

### (1) Fail-Closed Real
O mecanismo de fail-closed foi comprovado. Tanto os templates de hooks (`guards/hook-shims/pre-commit` e `guards/hook-shims/commit-msg`) quanto as funções da biblioteca comum (`guards/lib/common.sh`) validam de maneira autônoma o arquivo `.hbn/active-version`. Os commits são bloqueados se:
- O arquivo `.hbn/active-version` estiver ausente ou ilegível;
- Conter conflitos de merge (marcadores `<<<<<<<`, `=======`, `>>>>>>>`);
- Conter múltiplos caminhos (mais de uma linha ativa);
- Apresentar caminhos inválidos ou inseguros (com espaços, quebras, caracteres de escape, etc.);
- Apresentar diretórios de versão inexistentes no disco.

### (2) Regressão Zero com ponteiro = "."
Quando o arquivo `.hbn/active-version` aponta para `.`, a função `get_canonical_root()` resolve com sucesso para a raiz do repositório canônico (`/Users/macbookpro/Projetos/usehbn`), preservando a compatibilidade completa dos guards legados. Os testes locais (132/132 verdes) e o runner real (14/14 guards aprovados) comprovam a ausência de regressões na raiz canônica.

### (3) Resolução de Raiz e Tratamento de Sub-versões
- **get_canonical_root**: É impossível resolver caminhos fora da raiz do repositório canônico porque a string lida do ponteiro é higienizada e validada contra o regex restrito `^versao_[0-9]+_[0-9]+_[A-Za-z0-9]+$` (além de `.`), bloqueando qualquer tentativa de travessia de diretório (`..` ou `/` absolutos). Adicionalmente, `assert-canonical-root.sh` valida que a raiz ativa resolvida está contida em `TOPLEVEL_REAL`.
- **G-STRAY**: A lógica em `is_valid_hbn_home` aceita pastas `.hbn` sob diretórios contendo o padrão de nome de versão `versao_X_Y_Z` cujo avô possua `.git` e `.hbn/active-version`. Isso evita falsos positivos para versões inativas arquivadas na raiz.
- **G-REG**: A função `guard_paths_to_version_paths` remove o prefixo `versao_*` dos caminhos staged antes da verificação contra o `REGISTRY.md`. Isso permite que o `REGISTRY.md` da versão mantenha mapeamentos limpos e independentes da pasta física da versão, eliminando falsos positivos e a necessidade de reescrever o livro-razão a cada transição.

### (4) Reconciliação Token × STATE no Rollback
- **Mecanismo**: O token de posse local reside em `.git/hbn-baton-token` (não rastreado pelo git). Um `git reset --hard <ref>` não apaga este arquivo. O script de rollback recalçalha o sha256 do token preservado e tenta reescrevê-lo na propriedade `bastao_token_sha256` do `STATE.md` ativo.
- **FALHA CRÍTICA DE PROJETO DETECTADA**: O script `scripts/hbn-exuvia-rollback.sh` calcula o caminho `$state_path` do `STATE.md` a ser atualizado *antes* de executar o `git reset --hard "$TARGET"`, usando a versão ativa *atual* do workspace. Se realizarmos um rollback que altere o ponteiro `.hbn/active-version` (por exemplo, de `versao_1_0_0` voltando para `.`), o local real do `STATE.md` após o reset mudará para `.hbn/relay/STATE.md`. No entanto, o script tentará atualizar o arquivo no caminho antigo (`versao_1_0_0/.hbn/relay/STATE.md`). Como essa pasta não existirá ou estará limpa após o reset, o script falhará com erro (`ERRO: STATE ativo não encontrado após rollback`) ou, na pior hipótese, modificará um arquivo órfão/incorreto.
- **Recomendação**: A variável `state_path` deve ser resolvida **após** a execução do reset, ou extraída diretamente do target commit via `git show "${TARGET}:.hbn/active-version"`.

### (5) Janela de Enforcement e Hooks Órfãos
- **Hook Órfão**: Como a pasta `.git/hooks` local não é versionada, novos clones ou remoções manuais de hooks contornam as verificações locais de commit. O pre-flight de hooks no runner impede commits locais apenas se o runner for acionado, mas não força a execução em clones órfãos.
- **Backstop Real**: O backstop real de enforcement é o CI de borda ("Shield" rodando no push), que obrigatoriamente valida o range `HBN_DIFF_BASE...HEAD` contra o runner de guards.

### (6) Conflito de Merge no Ponteiro
O uso de `grep -qE '^(<<<<<<<|=======|>>>>>>>)'` no arquivo `.hbn/active-version` garante que qualquer conflito no ponteiro bloqueie imediatamente qualquer commit, forçando a resolução determinística humana.

### (7) Congelamento por `git mv`
A política de congelamento utilizando `git mv` (e não `git cp`) preserva o histórico de revisões dos arquivos de forma limpa e previne a duplicação física de objetos Git, mitigando o inchaço do repositório. O plano de glacier para arquivar versões frias após o acúmulo de duas exúvias é adequado.

---

## Perguntas do Codex

1. **G-STRAY permite toda `versao_*` ou só a ativa?**  
   Permite todas as pastas de versão (`versao_X_Y_Z`) legítimas que estejam no mesmo repositório do ponteiro. Isto é correto, pois versões inativas/congeladas precisam coexistir fisicamente na árvore.
2. **Pre-flight de hooks basta?**  
   Não. Serve apenas como segurança local pós-onboarding. O enforcement definitivo contra commits burlados exige validação centralizada no CI/Shield durante o push.
3. **Semântica de G-REG (paths sem prefixo `versao_*`)?**  
   Está correta. A remoção do prefixo evita reescrita massiva de caminhos no `REGISTRY.md` e facilita a auditoria independente do conteúdo de cada versão.
4. **Revisar rollback --apply antes de M-C?**  
   Sim, conforme apontado no item (4) da seção de ataque, o script possui um bug de resolução pré-reset que impede o rollback correto entre versões ativas distintas.
5. **Validar plano de glacier?**  
   Validado. O arquivamento calendarizado sob índice frio é o caminho correto contra o inchaço do repositório.

---

## Truth Barrier (Declaração de Confiança)
- **Confiança**: Alta na lógica estática do código, na suite de testes unitários executada (132/132 passados) e na bateria adversarial (15/15 burlas bloqueadas).
- **O que NÃO foi verificado**: Não foi testada a execução real do reset com alterações físicas destrutivas no workspace local (mantendo o rollback script em dry-run conforme as especificações de M-A). A integridade das assinaturas de commits por chaves criptográficas (GPG/SSH) dos operadores não pôde ser validada devido à ausência de chaves de teste na máquina local.

---

## Recomendações e Correções

* **R-01 (Rollback Script):** Modificar `scripts/hbn-exuvia-rollback.sh` para calcular o caminho de destino do `STATE.md` somente após o reset físico ou lendo o ponteiro do target commit:
  ```bash
  # Exemplo de correção:
  active_rel="."
  if git cat-file -e "${TARGET}:.hbn/active-version" 2>/dev/null; then
      active_rel="$(git show "${TARGET}:.hbn/active-version" | grep -v '^[[:space:]]*#' | grep -v '^[[:space:]]*$' | head -1 || true)"
      active_rel="$(printf '%s' "$active_rel" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
      [[ -z "$active_rel" ]] && active_rel="."
  fi
  ```
