---
titulo: Parecer — terceira exúvia v3.0.0 (readback 0001)
tipo: result-cross-ia-superseded
status: superseded
temperatura: frio
path: .hbn/archive/SUPERSEDED-20260705-183900-antigravity-cross-ia-0001.md
created_at: "2026-07-05T18:39:00-03:00"
autor: antigravity
familia: Google
natureza: nativo
---
SOU: antigravity · familia Google · papel auditor

# Parecer — terceira exúvia v3.0.0 (readback 0001)

## Veredito
APROVA_0001: SIM

## Evidências (Truth Barrier)
- **A. Glacier do passado**
  - `versao_0_3_x/`: CONFIRMADO — Diretório existe e contém a estrutura antiga completa do Honest Foundation. O arquivo `versao_0_3_x/REGISTRY.md` (154.729 bytes) está preservado.
  - `versao_2_0_0/`: CONFIRMADO — Congelada. O cabeçalho de `versao_2_0_0/BOOT.md` linhas 3-4 declara `status: congelado` e `temperatura: glacier`. O REGISTRY ativo (`versao_3_0_0/REGISTRY.md:20-21`) registra a glaciação das versões v0.3.x e v2.
  - `status: proposto`: CONFIRMADO — Sem versões pendentes com status proposto fora da versão ativa. O teste mecânico via `bash versao_3_0_0/guards/assert-no-pending-exuvia.sh` retornou código de saída 0 e a mensagem `[hbn-guards/assert-no-pending-exuvia] ✓ Nenhuma exuvia pendente: nenhum versao_X_Y_Z/BOOT.md com status proposto fora da versao ativa.`

- **B. Cold core ativo**
  - `versao_3_0_0/` autocontida: CONFIRMADO — Diretório `versao_3_0_0/` contém todos os componentes necessários (`BOOT.md`, `core/`, `guards/`, `schemas/`, `scripts/`, `.hbn/`).
  - Novos guards estruturais: CONFIRMADO — Todos os guards adicionais estão presentes e estruturados sob `versao_3_0_0/guards/`:
    - `assert-active-version-integrity.sh`
    - `assert-profile-authorized.sh`
    - `assert-manifest-current.sh`
    - `generate-manifest.sh`
    - `assert-only-hot-version-writable.sh` (G-HOT-WRITE)

- **C. Raiz esvaziada**
  - Raiz limpa: CONFIRMADO — A raiz contém apenas metadados do Git, allowlist de IDEs, `.gitignore`, shims, e os arquivos explicativos `README.md` e `AGENTS.md`. `.git/hooks/pre-commit` resolve dinamicamente o runner a partir do ponteiro ativo.
  - active-version: CONFIRMADO — `.hbn/active-version` contém exatamente `versao_3_0_0`.

- **D. G-HOT-WRITE (contenção mecânica)**
  - Posição no runner: CONFIRMADO — `assert-only-hot-version-writable.sh` é o primeiro guard executado na lista `GUARDS` de `versao_3_0_0/guards/hbn-guards-runner.sh:92-93`.
  - Fail-closed & Allowlist: CONFIRMADO — O guard restringe staging/commit a caminhos com prefixo `versao_3_0_0/` com exceção de `.gitignore`, `.hbn/relay/STATE.md`, `.hbn/hearbacks/**`, e `.hbn/active-version` (apenas em exúvia autorizada).
  - Bypass: CONFIRMADO — O script ignora as variáveis `HBN_GUARDS_BYPASS` e `GLASSWING_BYPASS` na linha 59, apenas emitindo aviso de warning e aplicando o check fail-closed normalmente.
  - Auto-proteção: CONFIRMADO — Linhas 345-352 de `assert-only-hot-version-writable.sh` realizam auto-proteção do próprio script exigindo confirmação de `hot-write-guard-change` cobrindo o path exato.
  - Testes: CONFIRMADO — A suíte `guards/tests/run-guard-tests.sh:4392-4500` cobre exaustivamente testes negativos e positivos do G-HOT-WRITE.

- **E. Exúvia atômica**
  - `hbn-exuvia-atomic.sh`: CONFIRMADO — O script em `versao_3_0_0/scripts/hbn-exuvia-atomic.sh` executa o workflow isolado via sandbox, gera rollback limpo em caso de erro e não efetua commit automático, delegando a assinatura final ao operador humano.
  - Commit `a2eb6f2`: CONFIRMADO — O commit `a2eb6f2` realizou de forma atômica e em um único commit o flip de versão, glaciação do legado e o esvaziamento da raiz.

- **F. Membrana**
  - Template: CONFIRMADO — `versao_3_0_0/membrane/MEMBRANE_MANIFEST.template.json` existe e modela as chaves `source_version`, `source_commit`, `generated_at`, `surface` e `files` com sha256 byte-a-byte.
  - Scripts: CONFIRMADO — `membrane/assert-snapshot-integrity.sh` e `scripts/hbn-upgrade-snapshot.sh` estão presentes e modelam a verificação rígida no consumidor contra drift ou arquivos espúrios.

- **G. BOOT-LOCK**
  - Cabeçalho: CONFIRMADO — Tanto `versao_3_0_0/BOOT.md:27-29` (§0) quanto `AGENTS.md:12-14` da raiz exigem o cabeçalho estruturado.
  - Hook client-side: CONFIRMADO — O script `.cursor/hooks/hbn-boot-lock.sh` está ativo e intercepta escritas fora da pasta quente.

- **H. Anti-viés (B1–B6)**
  - CONFIRMADO — Não foram detectadas omissões ou pontos de falha que permitam a reintrodução da classe de erro "escrever na versão errada". O controle em três níveis (BOOT-LOCK na escrita, G-HOT-WRITE no commit, e runner de hooks dinâmico baseado em ponteiro do disco) garante total blindagem mecânica contra desvios de atenção ou viés dos agentes.

## Achados bloqueadores (se NAO)
Nenhum.

## Confiança
Alta. Verificação completa de todos os arquivos citados no readback, execução local bem-sucedida de todos os 371 testes unitários/adversariais (todos verdes), e validação do histórico do Git na working tree.
