---
titulo: "Parecer de Auditoria Cruzada — Plano Exúvia v2 (Onda 0011)"
tipo: audit-result
status: congelado
path: .hbn/results/20260614-032800-gemini-3-5-cross-ia-onda-0011-plano-v2.md
id-global: 20260614-032800-gemini-3-5-cross-ia-onda-0011-plano-v2
temperatura: glacier
auditor: gemini-3-5
familia: Google
implementador-auditado: codex
alvo: .hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md
created_at: "2026-06-14T03:28:00-03:00"
---

# Parecer de Auditoria Cruzada — Plano Exúvia v2 (Onda 0011)

## Veredito

**APROVADO (VETO_ADOCAO: NAO)**

Contagem de achados: **0 BLOQUEADOR; 0 FORTE; 0 MARGINAL**.

---

## Resumo Humano

1. O plano v2 da onda 0011 é estritamente conceitual e de design (`safe_track`); não há nenhuma execução de código de domínio ou corte da muda.
2. As três reservas FORTE da onda 0010 foram completamente mitigadas por meio da tag git imutável anti-GC, da atualização síncrona/direta do guard de registros e do `git add -f` obrigatório de untracked no congelamento.
3. O alerta marginal M-01 foi devidamente endereçado com a previsão do sinal de dependência pós-corte.
4. As adições do gate humano e governança (Painel de Proteção comum, logs frios de janelas com retenção e limpeza automática por manutenção, loop do arquiteto configurável, nome `hbn-exuvia`, inventário de módulos e árvore-alvo) foram incorporadas de forma harmônica e estruturada.
5. O plano atinge prontidão plena para o corte (M2) com reversibilidade explícita (procedimento de rollback funcional) e guards sincronicamente calibrados para evitar bypass artificiais.

---

## Confirmações por Item

### 1. As 3 reservas FORTE Resolvidas

*   **F-01 (Tag Git Imutável anti-GC na fase de congelamento):**
    *   *Confirmação:* A proposta prevê a criação obrigatória da tag git `hbn-exuvia/protocol-0.3.x` apontando para o commit da casca durante a fase de congelamento.
    *   *Citações:* 
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:125-126](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L125-L126)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:137-139](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L137-L139) (Fase 4: tag na fase de congelamento)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:152-164](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L152-L164) (Detalhamento do passo `git tag`)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:379-380](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L379-L380) (Manifesto do congelamento)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:431](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L431) (Checklist de M2)

*   **F-02 (Guard `assert-registry-line.sh` atualizado direto, SEM symlink):**
    *   *Confirmação:* O plano abandona a ideia de link simbólico na raiz e define que o script `guards/assert-registry-line.sh` será editado diretamente para buscar o novo local do ledger.
    *   *Citações:* 
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:46-48](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L46-L48)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:106-108](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L106-L108) (Detecção do bug do symlink no Git show)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:141-143](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L141-L143) (Fase 5: atualização síncrona)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:165-176](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L165-L176) (Atualização explícita em M2)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:409-410](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L409-L410) (Parâmetros no manifesto)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:434](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L434) (Checklist de M2)

*   **F-03 (`git add -f` dos untracked preservados na casca):**
    *   *Confirmação:* O plano prevê o acréscimo forçado dos arquivos untracked históricos no commit de congelamento da casca.
    *   *Citações:* 
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:49-51](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L49-L51)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:136-137](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L136-L137) (Fase 4: git add -f)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:177-190](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L177-L190) (Listagem de arquivos untracked a indexar forçadamente)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:383](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L383) (Manifesto)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:430](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L430) (Checklist de M2)

---

### 2. M-01 Resolvido

*   **Sinal `⛓️ HBN PROTOCOL DEP CHANGE` previsto após a muda:**
    *   *Confirmação:* Previsto no plano publicar o sinal de dependência formal logo após a execução da muda.
    *   *Citações:* 
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:62-63](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L62-L63)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:192-203](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L192-L203) (Descrição detalhada da publicação do sinal)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:407](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L407) (Campo `signals_after_cut` no manifesto)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:440](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L440) (Checklist de M2)

---

### 3. Adições Humanas Presentes e Coerentes

*   **Painel `.hbn/relay/PAINEL.md`:**
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:207-218](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L207-L218), [:303](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L303), [:391](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L391), [:435](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L435)

*   **Trilha de logs `logs/<ts>-<agente>-log-janela.md`:**
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:220-227](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L220-L227), [:285](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L285), [:436](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L436)

*   **Ponte BIDIRECIONAL (último doc da casca ↔ primeiro da forma nova):**
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:144-148](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L144-L148), [:245-256](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L245-L256), [:384-387](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L384-L387), [:438](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L438)

*   **Retenção de 30 dias configurável + limpeza por manutenção:**
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:228-232](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L228-L232), [:400-402](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L400-L402), [:436](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L436)

*   **Política de loop (apaga/glacier configurável):**
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:233-244](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L233-L244), [:403-405](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L403-L405)

*   **Nome `hbn-exuvia`:**
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:112-118](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L112-L118), [:437](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L437)

*   **Inventário de módulos + árvore-alvo:**
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:271-291](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L271-L291) (Tabela de inventário) e [:292-358](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L292-L358) (Estrutura da árvore 1.0.0)

---

### 4. Prontidão para o Corte (M2)

*   **Plano executável passo a passo sem perda silenciosa (P1) e com reversibilidade (P6)?**
    *   *Confirmação:* Sim, a sequência das fases (4 a 7) descreve a separação segura da casca sem perda histórica de commits e untracked. O rollback está previsto formalmente nos metadados do manifesto.
    *   *Citações:* 
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:136-148](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L136-L148) (Passos de transição)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:415-418](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L415-L418) (Campos de rollback no manifesto)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:424-442](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L424-L442) (Checklist de M2)

*   **O rollback está descrito e é real?**
    *   *Confirmação:* Sim. O procedimento de rollback está documentado no manifesto e baseia-se em `git revert` ou checkout da âncora antes da muda, mantendo a tag da casca intacta para reusabilidade.
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:415-418](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L415-L418)

*   **Algo ainda faltando para autorizar a muda?**
    *   *Confirmação:* Tecnicamente, nada. O plano está pronto e maduro. A autorização formal depende estritamente do Gate Humano (ratificação de Maurício) conforme listado no fluxo.

---

### 5. Guards na Virada

*   **A sequência de congelar→renascer não re-dispara guards de forma que exija bypass:**
    *   *Confirmação:* Confirmado. A atualização direta e simultânea da constante de caminho no script de guard elimina a falha de leitura indexada (`git show`), garantindo que os guards permaneçam íntegros sem bypass ou falso-positivos na transição de commits.
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:141-143](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L141-L143), [:167-171](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L167-L171)

*   **O guard de registro é atualizado de forma honesta e síncrona:**
    *   *Confirmação:* Sim, a alteração no guard é síncrona e feita diretamente no mesmo commit de nascimento da estrutura 1.0.0.
    *   *Citação:* [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:141-143](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L141-L143), [:167-171](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L167-L171)

---

### 6. Escopo de Trabalho

*   **Confirmação de que esta onda é só PLANO (não executou a muda):**
    *   *Confirmação:* Confirmado. Nenhuma alteração ativa na árvore estrutural foi executada na onda 0011.
    *   *Citações:*
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:11-12](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L11-L12)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:29-32](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L29-L32)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:131-132](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L131-L132)
        *   [.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md:408-410](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md#L408-L410)

---

## Recomendação por Hearback

1. **[Aprovar]** Autorizar a transição para a Fase M2 (Corte) com base no checklist estruturado e mitigação completa dos riscos de segurança e persistência levantados nas auditorias anteriores.

---

## Caminhos Criados ou Modificados

*   [.hbn/results/20260614-032800-gemini-3-5-cross-ia-onda-0011-plano-v2.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/results/20260614-032800-gemini-3-5-cross-ia-onda-0011-plano-v2.md) - Este parecer oficial de auditoria do plano v2.
