SOU: grok · familia xAI · papel consultor

# Parecer de Desenho — Ponte PROTOCOLO (usehbn@v1-estavel) × PROJETO (Credenciamento)
**Data (disco):** 2026-06-26  
**Contexto:** Passo 1 (freeze) concluído. Passo 2 = membrana/ponte. 3 garantias inegociáveis de Maurício.  
**Status desta consulta:** análise crítica + proposta de transição (NÃO ratificação, sem APROVA).  
**Árvore limpa verificada:** `git -C /Users/macbookpro/Projetos/usehbn status` e `git -C /Users/macbookpro/Projetos/Credenciamento status` executados antes de inspeções e escrita (ver seção Evidências). Untracked de dry-runs/relatórios anteriores ignorados para análise de estado tracked.

**Verdade = disco.** Todas as afirmações citam comando+saída ou arquivo:linha observados em `/Users/macbookpro/Projetos/...`.

---

## 1. CRÍTICA das 3 garantias — o desenho impede confusão protocolo×projeto?

### Garantia (1): NENHUMA IA pode confundir "PROTOCOLO" com "PROJETO executado sob as guardas do protocolo"

**Risco residual ALTO no estado atual (antes da membrana):**

- O espelho vivo `Credenciamento/usehbn/` (110 arquivos) ainda existe com layout ANTIGO:
  ```
  $ ls /Users/macbookpro/Projetos/Credenciamento/usehbn
  audits/ docs/ methodology/ modules/ radar/ study-plans/ site/
  ```
  (comando: `find /Users/macbookpro/Projetos/Credenciamento/usehbn -type f | wc -l` → 110; data dos dirs ~May 24).

- Referência concreta em `Credenciamento/AGENTS.md:123`:
  ```
  16. [`usehbn/docs/PHAGOCYTOSIS-VBA-PATTERNS.md`](usehbn/docs/PHAGOCYTOSIS-VBA-PATTERNS.md) — lições históricas sobre VBA
  ```
  Uma IA fria (sem contexto de chat anterior) que leia só o AGENTS.md do projeto pode raciocinar: "o protocolo está em usehbn/ aqui dentro, vou editar methodology/ ou modules/ para 'melhorar'".

- Em `Credenciamento/usehbn/modules/` e `usehbn/radar/` ainda há artefatos que misturam "protocolo antigo" com material de domínio do projeto. O espelho não é tombstone — é um clone vivo e editável.

- No PROTOCOLO (usehbn repo): `git -C /Users/macbookpro/Projetos/usehbn rev-parse v1-estavel` = `a67e8049ed6fd4f81423ee60194a2f5896f25af0`. HEAD atual é `78dd725` (post-freeze, "chore(w-freeze): registrar v1-estavel... e abrir o passo 2"). Se uma IA olhar só branch/HEAD sem checar tag explícita, confunde "o que está no disco agora" com "o genoma selado".

**O desenho da membrana mitiga, mas NÃO elimina sozinho:**

- `.usehbn-snapshot/` read-only + header "ISTO É O PROTOCOLO (usehbn@v1-estavel)" + `PROTOCOL_SHA256.txt` + guard `assert-snapshot-integrity` ajuda.
- Mas: (a) o snapshot ainda não existe no disco (busca `find ... -name '.usehbn-snapshot'` retornou 0 dirs relevantes); (b) o router no topo do AGENTS.md do projeto ainda não foi escrito; (c) referências legadas no AGENTS.md e em `.hbn/knowledge/*.md` do projeto apontam para o espelho antigo.
- Risco concreto pós-membrana: IA que faz RAG sobre todo o workspace (Cursor, Claude local, etc.) indexa tanto `Credenciamento/usehbn.TOMBSTONE/...` quanto `.usehbn-snapshot/core/...` e "escolhe o mais parecido" sem notar o header.

**Conclusão crítica (1):** o desenho é necessário mas insuficiente sem (i) tombstone agressivo + remoção de refs legadas, (ii) header + checksum verificado em todo carregamento, (iii) router obrigatório no topo de AGENTS.md do projeto (antes de qualquer outra seção). Sem isso, garantia (1) é aspiracional.

### Garantia (2): o projeto deve RESPEITAR os fluxos (rodar guards+ritos, não só ler docs)

Estado atual: o projeto **já roda alguns guards** (copiados manualmente):
- `Credenciamento/scripts/hbn-guards/assert-canonical-root.sh`, `forbid-legacy-paths.sh`, `scope-lock...` etc. (comando: `find /Users/macbookpro/Projetos/Credenciamento -path '*hbn-guards*' -type f`).

Mas:
- Não são os mesmos 41 .sh do protocolo (usehbn/guards/ tem `ls guards/*.sh | wc -l` efetivo ~41 scripts + lib/tests).
- Runner do projeto é parcial (ver `scripts/hbn-guards/` vs `usehbn/guards/hbn-guards-runner.sh`).
- Firewall 0022 existe e é citado (`Credenciamento/.hbn/knowledge/0022-firewall-workflow-fast-track.md:1-68`), mas enforcement é "documental + humano" — não há ainda `assert-snapshot-integrity` nem runner apontando para snapshot.

O desenho propõe rodar os guards vindos do snapshot nos commits do projeto. Isso atende (2) **se** o escopo do snapshot incluir a maquinaria executável (ver seção 2).

### Garantia (3): o projeto deve poder CONTRIBUIR de volta com fluidez e sem confusão

Já existe estrutura:
- `usehbn/inbox/README.md:13`: "Projetos consumidores (Credenciamento...) **não editam o canônico**. Quando ... deposita um arquivo AQUI".
- `usehbn/inbox/credenciamento/` já tem itens (ex.: `20260610-01-0017-parametrica.md`).
- Ciclo: inbox → arquiteto consolida → hearback Maurício.

Risco: se o projeto ainda tiver o espelho editável, alguém (IA ou humano) pode "contribuir" editando o espelho e dando push — confundindo contribuição com edição direta do genoma. O canal único (inbox) só é efetivo depois do tombstone + atualização de mental model em AGENTS.md.

**Síntese crítica das 3:** o desenho conceitual é alinhado com ADR-008-v2 (aceito). A implementação atual no disco é pré-membrana: o risco de confusão é **concreto e observável** via espelho + refs em AGENTS.md:123 e uso de paths relativos "usehbn/". A membrana resolve se vier com router obrigatório, header forte, assert-integrity e remoção do espelho.

---

## 2. ESCOPO do snapshot — (A) só normativo ou (B) normativo + guards aplicáveis?

**Recomendação: (B) normativo + maquinaria de guards aplicável ao projeto consumidor.**

**Justificativa ancorada na garantia (2):**
- "o projeto deve RESPEITAR os fluxos de seguranca/garantia do protocolo (rodar guards+ritos, nao so ler docs)".
- Ler docs (core/protocol.md, methodology/) é necessário mas não suficiente. O protocolo é "executable contracts" (ver `Credenciamento/AGENTS.md:42-65` que descreve pre-commit + scope-lock + readback/hearback).
- Se snapshot for só (A), o projeto continua rodando cópias manuais parciais de guards (drift garantido) ou ignora enforcement — violando (2).

**Custo de acoplar ~66 guards (realidade no disco: ~41 *.sh principais + lib/tests):**
- Baixo se selecionarmos **subset aplicável** (~22-28 guards). O runner completo do protocolo inclui orquestração interna (dispatch, orq-entrada) que não faz sentido num app VBA de domínio.
- Alto se copiarmos tudo indiscriminadamente (acoplamento desnecessário + manutenção de guards que só fazem sentido no genoma).

**Classificação (lendo diretamente `usehbn/guards/hbn-guards-runner.sh:83-116`):**

**GUARDS que o PROJETO (Credenciamento) deve rodar sobre si (vêm no snapshot):**
- `assert-canonical-root.sh` — raiz do projeto ≠ protocolo (garantia 1+2).
- `forbid-tmp-worktree.sh`, `forbid-env-files.sh`, `forbid-legacy-paths.sh` — higiene básica.
- `assert-scratch-lock.sh`, `assert-scratch-symlink.sh`, `assert-scratch-ignore.sh`, `assert-zona-livre.sh` — zona de rascunho.
- `assert-scope-lock.sh` — essencial para safe_track (já referenciado no AGENTS do projeto).
- `assert-readlist-rite.sh`, `assert-report-fresh.sh`, `assert-knowledge-index.sh` — ritos de retomada/estado.
- `assert-no-stray-hbn.sh`, `assert-role-family.sh` — anti-contaminação.
- `assert-hearback-integrity.sh`, `assert-exception-traceable.sh`, `assert-trailers-contiguous.sh` (condicional) — rastreabilidade.
- `assert-ci-battery.sh`, `assert-copy-block.sh` (se aplicável), `assert-self-path.sh` (adaptado).
- `assert-frontdoor.sh` (se o projeto expõe entrypoints).

**GUARDS internos ao desenvolvimento do próprio PROTOCOLO (NÃO vão no snapshot do projeto, ou vão em modo "doc-only"):**
- `assert-orq-entrada.sh`, `assert-orq-entrada-ref.sh`, `validate-dispatch.sh`, `assert-dispatch-integrity.sh` — orquestração de ondas/despacho interno ao genoma.
- `assert-registry-line.sh`, `assert-pointer-honest.sh`, `assert-arvore-label.sh` — numeração/árvores/registro do protocolo.
- `assert-auditor-id.sh`, `assert-audit-diversity.sh`, `assert-quorum-selagem.sh`, `assert-parallel-id.sh` — mecanismos de cross-audit/quorum específicos do processo de evolução do usehbn.
- `freeze-gate.sh` — específico do freeze do genoma.
- `assert-baton-token.sh` (commit-msg) — mais relevante em contexto de bastão do protocolo.

**Runner no snapshot:** deve ser uma versão "project-runner.sh" (ou o mesmo runner com flag `--project-mode`) que executa **apenas o subconjunto aplicável** + `assert-snapshot-integrity.sh` (novo, que falha se o snapshot foi editado ou o sha não bate com a tag declarada).

**Normativo que vai no snapshot (além dos guards):**
- `core/` (22 arquivos: protocol.md, role-cards.md, dispatch-spec.md, freeze-gate-spec.md, readback-spec.md, start-rite-spec.md, ...).
- `schemas/` (17) — para validação de readbacks/ERPs do projeto.
- `methodology/` seletivo: PRINCIPIOS-CONSTITUCIONAIS.md, MATURITY-MATRIX.md (referência), ADR relevantes para consumidores (ex.: ADR-008, ADR-004 semver, ADR-011), templates se o projeto for produzir ADRs locais. **Não** todo o adr/ (muitos são internos à evolução do protocolo).

**Não vai:** testes internos do protocolo, .hbn/ completo do genoma, docs/brainstorm/, scratch/, a maior parte de methodology/adr/ que é história de decisão do genoma.

---

## 3. TRANSICÃO — do espelho vivo de 110 arquivos misturado até a membrana limpa, sem quebrar o Credenciamento

**Ordem recomendada (humano-first por causa do firewall 0022):**

1. **Preparação (humano + orquestrador, fast_track, sem escrita de domínio):**
   - `git -C /Users/macbookpro/Projetos/usehbn checkout v1-estavel` (ou exportar tree em a67e804) para gerar o snapshot a partir do **genoma selado**, não do HEAD atual.
   - Executar `git -C /Users/macbookpro/Projetos/Credenciamento status` + auditoria diff manual entre espelho atual e tag (cross-audit leve).
   - Criar branch dedicada no projeto: `codex/ponte-usehbn-snapshot-202606xx`.

2. **Criação do snapshot (automatizável após protótipo, mas primeira execução com hearback):**
   - Criar `Credenciamento/.usehbn-snapshot/` (vazia).
   - Copiar seletivamente de tree do tag:
     - `core/`, `schemas/`, `guards/` (subset + lib/ + runner adaptado), metodologia mínima.
   - Adicionar arquivos de membrana:
     - `USEHBN-HEADER.txt` (EXATO: "ISTO É O PROTOCOLO (usehbn@v1-estavel)\ncommit: a67e8049ed6fd4f81423ee60194a2f5896f25af0\nsha256: ...\nNÃO EDITAR — read-only — violação = HBN SECURITY BLOCK").
     - `PROTOCOL_SHA256.txt` (checksum recursivo dos arquivos aplicáveis).
     - `VERSION` = "v1-estavel".
   - Adicionar `assert-snapshot-integrity.sh` (novo guard) que:
     - Confere que nenhum arquivo do snapshot foi modificado (mtime + sha).
     - Confere que o .git toplevel do projeto é Credenciamento (nunca usehbn).
     - Falha o pre-commit se violado.

3. **Tombstone do espelho + limpeza de layout antigo (humano, safe_track, hearback explícito):**
   - Mover/renomear `Credenciamento/usehbn/` → `Credenciamento/usehbn.TOMBSTONE-202606xx/` (ou deletar após confirmação de que nada de domínio depende dele além de docs históricos).
   - Atualizar **todas** as referências em:
     - `AGENTS.md` (remover ou prefixar com "LEGADO — ver .usehbn-snapshot/ para specs; usehbn.TOMBSTONE/ só para arqueologia").
     - `.hbn/knowledge/*.md` que citem `usehbn/`.
     - docs/, auditoria/, scripts/ que tenham paths relativos.
   - Mover artefatos de "domínio misturado" que estavam no espelho (se algum) para `auditoria/` ou `docs/` do projeto. (Na prática, radar/study-plans/audits/ dentro do usehbn/ do projeto eram legado do protocolo antigo; projeto já tem estrutura própria em auditoria/.)

4. **Ativação do router + guards no projeto (automatizável + humano valida):**
   - Inserir no **topo** do `AGENTS.md` (antes de "Identidade do projeto"):
     ```
     ## Router HBN — membrana (obrigatório)
     1. Leia .usehbn-snapshot/USEHBN-HEADER.txt (confirme sha).
     2. Regras/normativo/guards → .usehbn-snapshot/ (read-only).
     3. Trabalho de domínio (VBA, auditoria, import) → raiz do projeto.
     4. Lições aprendidas / proposta de evolução → usehbn/inbox/credenciamento/ (nunca edite o protocolo direto).
     5. Qualquer tentativa de escrita em .usehbn-snapshot/ = bloqueio por assert-snapshot-integrity.
     ```
   - Instalar/atualizar pre-commit do projeto para chamar o runner do snapshot (ou symlink/cópia controlada do runner + guards selecionados).
   - Rodar bateria completa em dry-run (HBN_GUARDS_BYPASS=1 temporário só para setup, com nota em bypasses/).

5. **Validação + estabilização:**
   - Cross-audit (pelo menos 2 IAs + humano) do diff do branch de transição.
   - Confirmar que pre-commit do projeto agora bloqueia edição do snapshot.
   - Confirmar que referências em llms.txt / llms-full.txt / auditoria/ foram atualizadas ou marcadas como legacy.
   - Hearback de Maurício + readback de fechamento da transição.

**Humano (firewall 0022) vs automatizável:**
- Passos 1 (decisão de data/dono), 3 (tombstone + remoção de refs), 5 (hearback final): **humano obrigatório** (escrita de domínio ou mudança estrutural de governança).
- Geração de checksum, cópia de árvore do tag, inserção de header, escrita do guard assert-integrity, atualização de scripts de CI: **automatizável** (script `scripts/hbn-snapshot/install-snapshot.sh` que o humano invoca uma vez).
- Nunca permitir que workflow automático faça o tombstone ou o commit da transição.

**Riscos principais (com mitigação):**
- Drift snapshot vs tag (mitigar: gerar snapshot a partir de tree-objeto do git tag, checksum + assert-integrity).
- Quebra de pre-commit durante cutover (mitigar: branch + bypass documentado + teste em clone separado).
- Refs quebradas em 100+ arquivos do projeto (mitigar: grep -r 'usehbn/' + sed controlado por humano).
- IA que ainda tem cache/index do espelho antigo (mitigar: header + nome .usehbn-snapshot explícito + instrução em AGENTS para limpar índice local).
- Custo de manter 2 cópias (genoma + snapshot por projeto) — aceitável; alternativa pior (submodule) foi rejeitada no ADR.

---

## 4. CANAL DE CONTRIBUIÇÃO project→protocolo — seguro?

**Sim, o canal atual é seguro por construção (não corrompe o genoma):**

- Evidência em disco: `usehbn/inbox/README.md:59-64`:
  - "Item de inbox não edita nada fora da própria pasta (é proposta, não patch)."
  - "Escrita de IA de projeto no canônico = SÓ aqui."
  - "Nada do inbox governa o protocolo por si — adoção real sempre passa por proposta no canônico + hearback de Maurício."

- Estrutura por projeto: `inbox/credenciamento/<AAAAMMDD-NN>-<slug>.md` (namespace evita colisão 0014×0014).
- Consolidação pelo arquiteto (papel distinto) + hearback humano.

**Melhorias recomendadas (sem complicar o genoma):**
- Adicionar ao front-matter do item de inbox: `snapshot-version: v1-estavel`, `snapshot-sha: a67e804...` (para correlacionar lição com versão exata do protocolo sob a qual foi observada).
- Exigir que itens de inbox passem por "mini cross-audit" leve (2 IAs diferentes) antes de consolidação — reduz ruído para o arquiteto.
- Adicionar `inbox/credenciamento/INDEX.md` gerado (ou manual) listando itens abertos/fechados por data.
- No lado do projeto: após depositar feedback, o AGENTS.md deve instruir "não espere resposta síncrona; continue na sua onda; o protocolo responde no ciclo do arquiteto".
- Anti-corrupção extra: CI no protocolo pode rodar um guard que falha se alguém tentar commitar dentro de `inbox/` exceto via PR controlado ou pelo arquiteto.

O desenho "canal único" + "projeto nunca edita direto" atende garantia (3) com boa fluidez.

---

## 5. ALTERNATIVA melhor, se houver

O desenho "duas camadas + membrana .usehbn-snapshot/" é **sólido para o contexto local + firewall humano + múltiplos projetos**.

Alternativas consideradas e por que não melhores aqui:

- **Git submodule** (ou subtree): rejeitado no ADR-008 v1/v2. Adiciona complexidade de update, histórico poluído, e não resolve "projeto nunca edita o genoma" sem hooks adicionais. Snapshot explícito + checksum é mais simples de auditar ("o que exatamente o projeto está consumindo?").
- **Shallow clone dentro de .usehbn-snapshot/usehbn-git/** com .git removido ou mounted read-only: mais frágil em Windows/VBA/Excel contextos; cópia de arquivos + sha é mais portátil e "Truth Barrier" explícita.
- **Pacote publicado (pip/tarball em release do usehbn)**: boa para futuro quando o protocolo for público, mas para Credenciamento local + governança HBN interna, o snapshot no fs é mais imediato e não depende de rede/release.
- **Monorepo único** (Credenciamento + usehbn side-by-side em um git): destrói a separação de identidade (garantia 1) e complica o "projeto é consumidor, não mantenedor do genoma".

**Melhoria incremental sobre o desenho proposto:**
- Fazer do snapshot um "pacote de superfície" com `manifest.json` (lista de paths + shas + versão) + script `usehbn-verify-snapshot.sh` invocável por CI e pre-commit.
- Versão do snapshot como "v1-estavel+<data-do-snapshot>" para permitir que projetos pinem uma revisão do snapshot mesmo após evolução do genoma (desde que compatível).
- Documentar em `core/` ou `schemas/` o "perfil de consumidor" (quais guards são obrigatórios para projetos vs internos).

Nenhuma alternativa é claramente superior; o proposto é adotável com as ressalvas de implementação abaixo.

---

## SÍNTESE (3-5 linhas)

O desenho de "duas camadas, uma membrana" é **adotável como base**. Ele materializa as 3 garantias quando implementado com: (a) snapshot gerado do commit exato do tag v1-estavel (a67e804), (b) header + checksum + assert-snapshot-integrity, (c) router obrigatório no topo do AGENTS.md do projeto, (d) tombstone do espelho `usehbn/` + limpeza de referências legadas (AGENTS.md:123 e .hbn/knowledge/), (e) subset de guards aplicáveis (não os  orq/dispatch internos). 

No disco atual (2026-06-26), a membrana **ainda não existe** e o risco de confusão IA-fria é **concreto** (espelho vivo de 110 arquivos + refs em AGENTS). A transição exige execução humano-gated (firewall 0022) por volta do gatilho ADR-008 (30-jun), com protótipo do tooling de snapshot/verify antes. Sem esses artefatos de membrana, o desenho fica só em papel.

Recomendação: prototipar snapshot + guard de integridade + atualização de AGENTS em branch isolado do Credenciamento, validar com cross-audit, então executar o corte no gatilho. O canal inbox já é seguro.

---

**Evidências de disco citadas (resumo):**
- `git -C /Users/macbookpro/Projetos/usehbn rev-parse v1-estavel` → a67e8049ed6fd4f81423ee60194a2f5896f25af0
- `git -C /Users/macbookpro/Projetos/usehbn/guards cat hbn-guards-runner.sh | sed -n '83,116p'` → lista exata de GUARDS
- `find /Users/macbookpro/Projetos/Credenciamento/usehbn -type f | wc -l` → 110
- `ls /Users/macbookpro/Projetos/Credenciamento/usehbn` → modules/ radar/ study-plans/ audits/...
- `Credenciamento/AGENTS.md:123` → referência usehbn/docs/
- `Credenciamento/.hbn/knowledge/0022-firewall-workflow-fast-track.md`
- `usehbn/inbox/README.md:13,59`
- `find ... -name '.usehbn-snapshot'` → nenhum (estado pré-membrana)
- `git -C /Users/macbookpro/Projetos/usehbn status` (executado 2026-06-26) → só untracked, branch proposta/reestruturacao-m-a-s0

Fim do parecer. (UNTRACKED — não comitado.)
