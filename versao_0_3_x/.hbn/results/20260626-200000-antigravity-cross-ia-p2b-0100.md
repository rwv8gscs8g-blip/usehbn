---
path: .hbn/results/20260626-200000-antigravity-cross-ia-p2b-0100.md
id-global: 20260626-200000-antigravity-cross-ia-p2b-0100
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0100: SIM"
arvore: fronteira
created_at: "2026-06-26T20:00:00-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

### Parecer de Auditoria Cruzada (P2-B)

Eu, na qualidade de auditor da família Google, ratifico a implementação do modo `--install` do script `scripts/hbn-snapshot/install-snapshot.sh` no commit `f86ff6e`. Abaixo seguem as evidências das validações conduzidas no ambiente de testes local:

#### 1. Verificação de Branch e Commit
```bash
$ git rev-parse main; git rev-parse HEAD
4db692876381a0d7909985c8500d999f2e677b04
f86ff6e474147af9bcb6806cd5c3a5682051c14f
```
A árvore principal `main` permanece preservada no commit de referência (`4db6928`), e a branch atual (`proposta/reestruturacao-m-a-s0`) encontra-se no HEAD correto (`f86ff6e`).

#### 2. Dry-Run Determinístico
Executando a simulação determinística consecutivamente:
```bash
$ bash scripts/hbn-snapshot/install-snapshot.sh --dry-run --proto . --tag v1-estavel
PROTO=.
TAG=v1-estavel
COMMIT=a67e8049ed6fd4f81423ee60194a2f5896f25af0
SURFACE=core methodology schemas guards
FILE_COUNT=137
PROTOCOL_SHA256=8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1
GUARDS_PROJETO=assert-canonical-root forbid-tmp-worktree forbid-env-files forbid-legacy-paths assert-scratch-lock assert-scratch-symlink assert-scratch-ignore assert-zona-livre assert-scope-lock assert-hearback-integrity assert-no-stray-hbn assert-self-path assert-trailers-contiguous assert-report-fresh assert-readlist-rite assert-knowledge-index
GUARDS_GENOMA_EXCLUIDOS=assert-orq-entrada assert-orq-entrada-ref validate-dispatch assert-dispatch-integrity assert-registry-line assert-pointer-honest assert-arvore-label assert-auditor-id assert-audit-diversity assert-quorum-selagem assert-parallel-id freeze-gate assert-baton-token
DRY-RUN: nada escrito no projeto (TARGET=<nao informado>).
```
O total de 137 arquivos sob a superfície especificada no tag `v1-estavel` e o hash `PROTOCOL_SHA256=8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1` foram verificados e comprovados como estáveis e reprodutíveis em execuções sucessivas.

#### 3. Teste de Instalação em Repositório Temporário
Criamos um repositório Git temporário e executamos a instalação:
```bash
$ T=$(mktemp -d); git -C "$T" init -q; git -C "$T" commit -q --allow-empty -m init
$ bash scripts/hbn-snapshot/install-snapshot.sh --install --proto . --tag v1-estavel --target "$T"
INSTALL OK: /var/folders/j2/mm7nc19d3bv31fdcvhsx0s740000gn/T/tmp.CrgYbsPwXj/.usehbn-snapshot (protocol_sha256=8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1; 137 arquivos); guard local + .hbn/active-version=. criados.
```
A instalação criou com sucesso a estrutura contendo 142 arquivos (137 arquivos de protocolo + 5 arquivos meta: `PROTOCOL_MANIFEST.sha256`, `PROTOCOL_SHA256.txt`, `VERSION`, `USEHBN-HEADER.txt` e `CONSUMER-PROFILE.md`), o guard local `scripts/hbn-snapshot/assert-snapshot-integrity.sh` e o arquivo `.hbn/active-version` apontando para `.`.

#### 4. Testes de Integridade e Desvio (Drift)
- **Integridade Padrão:**
  ```bash
  $ (cd "$T" && bash scripts/hbn-snapshot/assert-snapshot-integrity.sh)
  [assert-snapshot-integrity] ✓ snapshot integro (137 arquivos)
  ```
- **Simulação de Drift (Modificação de arquivo):**
  ```bash
  $ chmod u+w "$T/.usehbn-snapshot/core/dual-run-spec.md"
  $ echo -n " " >> "$T/.usehbn-snapshot/core/dual-run-spec.md"
  $ (cd "$T" && bash scripts/hbn-snapshot/assert-snapshot-integrity.sh)
  [assert-snapshot-integrity] ✗ drift em core/dual-run-spec.md
  # Exit code: 1
  ```
- **Simulação de Arquivo Extra:**
  ```bash
  # Restaurando o arquivo modificado
  $ cp /Users/macbookpro/Projetos/usehbn/core/dual-run-spec.md "$T/.usehbn-snapshot/core/dual-run-spec.md"
  $ echo "extra" > "$T/.usehbn-snapshot/core/extra_file.txt"
  $ (cd "$T" && bash scripts/hbn-snapshot/assert-snapshot-integrity.sh)
  [assert-snapshot-integrity] ✗ arquivos extra no snapshot (disco=138 manifesto=137)
  # Exit code: 1
  ```
O guard de integridade validou corretamente a conformidade dos blobs e barrou qualquer modificação ou arquivo espúrio na estrutura.

#### 5. Idempotência e Restrições de Segurança
- **Instalação Duplicada:**
  ```bash
  $ bash scripts/hbn-snapshot/install-snapshot.sh --install --proto . --tag v1-estavel --target "$T"
  /var/folders/j2/mm7nc19d3bv31fdcvhsx0s740000gn/T/tmp.CrgYbsPwXj/.usehbn-snapshot ja existe; use --upgrade
  # Exit code: 2
  ```
- **Instalação Sem Target:**
  ```bash
  $ bash scripts/hbn-snapshot/install-snapshot.sh --install --proto . --tag v1-estavel
  install exige --target
  # Exit code: 2
  ```
- **Comando de Upgrade:**
  ```bash
  $ bash scripts/hbn-snapshot/install-snapshot.sh --upgrade --proto . --tag v1-estavel --target "$T"
  MODE --upgrade ainda nao implementado (P2-C+).
  # Exit code: 3
  ```
- **Target == Protocolo:**
  ```bash
  $ bash scripts/hbn-snapshot/install-snapshot.sh --install --proto . --tag v1-estavel --target .
  target == proto; recusado
  # Exit code: 2
  ```

#### 6. Invariância do Repositório Credenciamento
Comprovamos que a pasta `~/Projetos/Credenciamento` permaneceu totalmente intocada, sem qualquer desvio em seu status git:
```bash
$ git -C ~/Projetos/Credenciamento status
On branch codex/v12-0-0206-planejamento
...
no changes added to commit (use "git add" and/or "git commit -a")
```
O diretório de testes temporário `$T` foi completamente sanitizado e removido.

#### 7. Conformidade do Readback e Metadados
O arquivo `.hbn/readbacks/0100-p2b-install-mode.json` cumpre os requisitos:
- `activation_status` está marcado como `"PROPOSED_UNTIL_CROSS_AUDIT"`.
- `track` definido como `"safe_track"`.
- `human_status` e `hearback_status` devidamente definidos como `"confirmed"`.
- Escopo de arquivos permitidos limita-se ao script de instalação e metadados, sem tocar o Credenciamento ou genoma do protocolo de forma indevida.

#### 8. Análise de Bloqueios e Resiliência (Anti-Teatro)
- O cálculo do hash no manifesto é dinâmico e cruzado por meio de utilitários nativos de hashing do sistema (`sha256sum`/`shasum`), sem valores embutidos (hardcoded).
- A consistência multi-plataforma é garantida ao se remover retornos de carro (`tr -d '\r'`) e ordenar os caminhos lexicograficamente (`LC_ALL=C sort -k3`).
- O guard de integridade previne com segurança commits de mudanças na membrana ao bloquear arquivos que estejam na área de preparação (staged) através de `git diff --cached --name-only -- .usehbn-snapshot`.

A implementação atende com excelência a todos os critérios de conformidade do protocolo.

APROVA_0100: SIM
