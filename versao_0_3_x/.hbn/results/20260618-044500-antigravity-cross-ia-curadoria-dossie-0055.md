---
path: .hbn/results/20260618-044500-antigravity-cross-ia-curadoria-dossie-0055.md
status: congelado
temperatura: glacier
---
SOU: antigravity · familia Google · papel auditor

# PARECER DE AUDITORIA CRUZADA (READBACK 0055) & RED-TEAM G-ORQ-ENTRADA

## Resumo Executivo
1. **Status Geral:** Aprovado sem bloqueadores materiais na implementação. `main` preservada em `4db692876381a0d7909985c8500d999f2e677b04`.
2. **Escopo:** A faixa de commits `394c974^..bdcba54` toca exclusivamente os arquivos listados em `scope.files_allowed` de `.hbn/readbacks/0055-curadoria-dossie-pre-transicao.json`.
3. **Trailers HBN:** Estão presentes e contíguos nos 4 commits auditados (`394c974`, `eba3f4d`, `f158fce`, `bdcba54`).
4. **Dossiê Tracked:** Confirmada a presença no Git dos 7 relatórios temáticos e da leitura mestra `SINTESE-PROFUNDA-pre-freeze.md`.
5. **R-PT5 Cobertura:** Confirmada cobertura real e profunda dos temas minimos `a` a `g` em `00-INDICE.md:22-32` cruzando com os relatórios.
6. **REGISTRY.md:** 7 colunas ativas. Há uma divergência marginal: foram adicionadas 10 novas linhas em vez de 9 (1 readback, 8 dossiê, 1 handoff).
7. **Suítes de Teste:** Pytest 213/213 passed. O runner local executou 200 testes (não 195) e a adversarial battery bloqueou B1-B44 (não B1-B40), incluindo o novo gate de orquestrador.
8. **Veredito:** `APROVA_0055: SIM` com Confiança 100/100.
APROVA_0055: SIM
9. **G-ORQ-ENTRADA:** Identificados bypasses por comando shell e leitura de gabarito público; desenhada estratégia de re-pin e ordem segura de escrita.

---

## Achados de Auditoria (Parte I)

### [MARGINAL] N-01: Divergência na contagem de linhas adicionadas no REGISTRY.md
- **Arquivo:Linha:** `REGISTRY.md:1162-1172` (`git diff 394c974^..bdcba54 REGISTRY.md`)
- **Descrição:** O prompt cita a inserção de "9 linhas novas", mas o commit de entrega adicionou 10 linhas sob o cabeçalho `## Curadoria Dossie de Pre-Transicao`: 1 linha de readback (`0055`), 7 relatórios da pasta `analise-pre-transicao/` (00-06), 1 relatório master (`SINTESE-PROFUNDA-pre-freeze.md`) e 1 linha de handoff. Todas possuem 7 colunas e marcação `arvore=fronteira`.
- **Impacto:** Apenas divergência documental nominal. A integridade estrutural e semântica das colunas está 100% correta.

### [MARGINAL] N-02: Incremento na contagem da suíte de testes locais e adversarial
- **Comando+Saída:** `bash guards/tests/run-guard-tests.sh` -> `resumo: 200 passaram, 0 falharam`; `bash guards/tests/adversarial-battery.sh` -> `B1-B44 bloqueadas`.
- **Descrição:** A suíte de guards evoluiu de 195 para 200 casos de teste locais no disco, e a bateria adversarial cobre até o caso B44 (bloqueando tentativas de burlar o novo gate de entrada do orquestrador). O prompt citava os números nominais "195/0" e "B1-B40".
- **Impacto:** Positivo. Mostra que o implementador (Codex) expandiu a cobertura de testes no mesmo commit para acompanhar os novos gates (G-ORQ-ENTRADA).

---

## Verificação de Invariantes (Parte I)

### 1. `main` intacta
- **Comando+Saída:** `git rev-parse main` -> `4db692876381a0d7909985c8500d999f2e677b04` (conforme invariante do readback).

### 2. Escopo restrito
- **Comando+Saída:** `git diff --name-status 394c974^..bdcba54`
- **Evidência:** O diff contém exatamente os 12 caminhos autorizados em `scope.files_allowed` de `.hbn/readbacks/0055-curadoria-dossie-pre-transicao.json`. Nenhum arquivo fora do escopo foi modificado.

### 3. Trailers HBN contíguos
- **Comando+Saída:** `git log -n 4 --pretty=fuller bdcba54`
- **Evidência:** Todos os 4 commits terminam de forma contígua com o bloco:
  ```
  HBN-Readback: 0055
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
  ```

### 4. Dossiê Tracked no Git
- **Comando+Saída:** `git ls-files docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/`
- **Evidência:** Lista os 7 arquivos do dossiê (`00-INDICE.md` a `06-esteira-pre-transicao-proposta.md`). O arquivo `SINTESE-PROFUNDA-pre-freeze.md` também está rastreado.

### 5. Cobertura Real R-PT5 em 00-INDICE.md
Cada tema listado em `00-INDICE.md:26-32` possui cobertura verificada no disco:
- **a) auditoria profunda:** `docs/brainstorm/rodada-2026-06-17/SINTESE-PROFUNDA-pre-freeze.md` (cobre runtime e guards em detalhe; ver §3 e §4).
- **b) estrutura de pastas:** `docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/01-estrutura-pastas-e-documentacao.md` (PROPOSTA A em `:139-218`).
- **c) mapa migracao:** `docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/02-mapa-migracao-genoma-autocontido.md` (tabela de migração em `:48-123`).
- **d) qualidade doc:** `docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/03-qualidade-documentacao-software.md` (README em `:15-31`, AGENTS em `:32-48`).
- **e) padronizacao geral:** `docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/01-estrutura-pastas-e-documentacao.md` (seções B e C em `:220-266`).
- **f) prontidao github:** `docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/04-prontidao-github-transicao.md` (CI e segredos em `:35-97`).
- **g) protocolos de teste:** `docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/05-protocolos-de-teste-e-novos-testes.md` (estratégia e novos testes em `:26-145`).

---

## Veredito da Onda 0055

**APROVA_0055:** SIM
**Confiança:** 100/100

---

## DESIGN G-ORQ-ENTRADA: Red-Team & Recomendações

### a. Bypass da atestação e endurecimento
- **Bypasses Identificados:**
  1. *Bypass de Leitura:* O guard `guards/assert-orq-entrada.sh:197-212` valida os arquivos comparando o `blob_hash` com `git hash-object -- <path>`. Uma IA pode calcular e preencher o JSON da atestação executando o comando shell ou lendo metadados sem de fato abrir e compreender semanticamente o conteúdo dos arquivos.
  2. *Auto-resposta de Desafios:* O arquivo de gabarito `guards/data/orq-entrada-desafios.txt` é aberto e versionado no mesmo diretório. Uma IA pode ler os padrões regex (`gate.*fechad`, `humano`, `\b80\b`) e programar respostas sintéticas que casam com o padrão sem de fato ter lido os textos de referência.
- **Como endurecer:**
  1. *Remover o Gabarito Físico:* O arquivo `orq-entrada-desafios.txt` não deve ser exposto de forma limpa/versionada no repositório. Deve ser armazenado apenas no ambiente privado do operador humano ou cryptografado/assinado.
  2. *Desafios Dinâmicos de Handoff:* O agente anterior (orquestrador ou humano) gera perguntas dinâmicas e armazena a assinatura ou o hash SHA-256 da resposta exata no STATE. O orquestrador entrante deve computar a resposta correspondente.
  3. *Verificação Humana no Gate:* O pre-commit/CI apenas garante a existência estrutural do JSON; o hearback humano (assinatura SSH em G-HRB) avalia qualitativamente a coerência das respostas da atestação.

### b. Estratégia contra fragilidade do Hash-pinning
- **Risco:** Quando specs legítimas (ex. `core/relay-spec.md`) mudam, seus hashes mudam, quebrando o gate para os próximos orquestradores que utilizarem a lista canônica.
- **Estratégia Recomendada (Re-pin sob Rito Enforçado):**
  1. O guard do REGISTRY deve enforçar que qualquer modificação (M) em arquivos listados em `core/read-list-canonica.txt` exige a atualização correspondente do hash daquela linha no mesmo commit.
  2. A alteração de specs normativas deve ser tratada como alteração T2, obrigando o re-pin do hash na lista canônica durante a onda de design. O orquestrador sempre lê a versão correspondente à do worktree de trabalho.
  3. *Versão do Readback:* Não utilizar hashes históricos do commit do readback para validação local no worktree, pois permitiria à IA atestar uma spec "limpa" do commit histórico enquanto ignora mutações locais maliciosas staged no momento do commit. A validação contra o disco local (staged) continua necessária para manter a segurança do worktree.

### c. Despacho-como-artefato (D3) e ordem segura para evitar Deadlock
- O despacho como artefato não cria deadlock desde que a criação do C1 respeite a ordem de preparação em disco antes do staging.
- **Ordem Segura de Ações:**
  1. **Humano** deposita o despacho `.hbn/dispatch/<id>.md` no disco e configura o `STATE.md` local (com novo token).
  2. **IA (Orquestrador)** lê o despacho, realiza a leitura da read-list, gera a atestação `.hbn/attestations/<fp>-orq-entrada.json` e escreve a proposta de readback `.hbn/readbacks/<id>.json`.
  3. **IA** atualiza o `STATE.md` para apontar `readback_ativo` e o status do baton.
  4. **IA** realiza o staging de todos os arquivos (`git add`) e executa o commit C1.
  5. O guard `assert-orq-entrada.sh` executa contra o `STATE.md` staged e a atestação no disco, valida e aprova o commit local.
  6. **Humano** ratifica a proposta de readback gerando o hearback correspondente.

### d. O papel do verificador (05) e quem o verifica
- O subagente verificador (`05-` de testes) é uma IA QA executando análise read-only.
- **Quem verifica o verificador:**
  1. *Truth Barrier:* O relatório do subagente cita obrigatoriamente `arquivo:linha`, permitindo validação mecânica ou visual rápida das claims.
  2. *Auditoria Cruzada:* Outros auditores de famílias distintas confrontam as claims do relatório e validam sua veracidade.
  3. *CRISPR (Bateria Adversarial):* A suíte adversarial de bypasses (`B1-B44`) atua como teste unitário sobre os guards que o verificador relata.
- **Vale a pena?** Sim. A IA QA atua como filtro de ruído e mapeador de pontos cegos complexos (como a concorrência e a atomicidade do logger identificadas em `05-`). A verificação humana/cruzada de um relatório estruturado com referências é ordens de grandeza mais barata do que a busca manual dos mesmos gaps no código.

### e. Próxima superfície sem governo pós G-ORQ-ENTRADA
- Segundo o meta-padrão do K-0024, após fechar a porta de entrada com atestação, as próximas superfícies vulneráveis são:
  1. **Modificação (M) de Metadados de Controle:** Edição direta de campos reguladores em `STATE.md` ou `REGISTRY.md` (mudar temperatura, apagar linhas de promoção ou status de readbacks sob staged sem gerar novas linhas de evento).
  2. **Auto-emenda via `zona_livre_curada`:** O uso excessivo ou desonesto do bypass `zona_livre_curada: true` nos readbacks para commitar arquivos não curados na raiz/brainstorm.
  3. **Bypass local de Hooks:** A ausência de execução da adversarial battery (`B1-B44`) no CI (`hbn-shield.yml`) deixa o sistema vulnerável a um push local que tenha de alguma forma evitado os shims locais (ex.: manipulação de git config local, variáveis de ambiente).
- **Mitigação:** Expandir o `G-REG` para escutar modificações (M) e integrar a adversarial battery e a validação de shims diretamente na pipeline de CI.
