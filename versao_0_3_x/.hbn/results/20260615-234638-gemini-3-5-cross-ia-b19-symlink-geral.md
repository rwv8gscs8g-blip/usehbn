---
titulo: "Parecer ADR-020/025 — Cross-IA do B19 (Bloqueio de symlink generalizado para todo path governado)"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260615-234638-gemini-3-5-cross-ia-b19-symlink-geral.md
id-global: 20260615-234638-gemini-3-5-cross-ia-b19-symlink-geral
agente: gemini-3-5
familia: Google
created_at: "2026-06-15T23:46:38-03:00"
---

PAPEL auditor · TOKEN gemini-3-5 · FAMÍLIA Google · CONTEXTO {99%} · "auditando do disco"

# Parecer de Auditoria Cruzada do B19 — Bloqueio de Symlink Geral (ADR-025)

## Identidade
- **AUDITOR**: gemini-3-5
- **FAMÍLIA**: Google
- **ESTADO**: "auditando do disco"
- **CONFIRMAÇÃO**: Confirmo que pertenço à família Google (Gemini) e realizei a auditoria de forma independente sobre o workspace `/Users/macbookpro/Projetos/usehbn`.

---

## Veredito Geral
**APROVA_B19**: SIM
**FUROS ENCONTRADOS**: nenhum
**CLASSE FECHADA**: SIM

---

## Sumário da Auditoria

### 1. Separação + Trailers
- **Comando de verificação detalhada**: `git show --stat ca5204d 8b35c40 84abc42 3f62bbd`
- **Trailers**: Todos os 4 commits possuem corretamente as linhas:
  - `HBN-Readback: 0023`
  - `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)`
  - `HBN-Token-FP: 34a7f2f9`
- **Separação**: Cada commit separa as tarefas logicamente:
  - `ca5204d`: Abertura de readback e registro no REGISTRY.md.
  - `8b35c40`: Código de implementação do guard em `guards/assert-scope-lock.sh` e `guards/README.md`.
  - `84abc42`: Modificações nas suítes de testes.
  - `3f62bbd`: STATE.md atualizado, handoff em `.hbn/messages/` e registro das linhas no REGISTRY.md.
- **Main**: A branch `main` (`4db6928`) está intocada.
- **ADR-025**: A estrutura e nomeação de arquivos conformam-se à convenção ADR-025.
- **Linhas REGISTRY dos numerados**:
  - `| 20260615-231847-codex-readback-b19-symlink-governado-geral | .hbn/readbacks/0023-b19-symlink-governado-geral.json | readback | quente | — | 2026-06-15T23:18:47-03:00 |`
  - `| 20260615-232431-codex-state-b19 | .hbn/relay/STATE.md | state | quente | — | 2026-06-15T23:24:31-03:00 |`
  - `| 20260615-232431-codex-handoff-b19 | .hbn/messages/20260615-232431-codex-handoff-b19.md | handoff | quente | — | 2026-06-15T23:24:31-03:00 |`

### 2. Readback 0023 Coerente
- **Caminho**: `.hbn/readbacks/0023-b19-symlink-governado-geral.json`
- **Campos verificados**:
  - `scope.files_allowed` cobre adequadamente todos os arquivos editados sob o escopo de B19.
  - `track` definido como `safe_track`.
  - `human_status` e `hearback_status` definidos como `confirmed`.
  - Sem auto-emenda oculta.

### 3. Suítes de Testes
- **run-guard-tests**: `bash guards/tests/run-guard-tests.sh` passou com 145/145 checks corretos.
- **adversarial-battery**: `bash guards/tests/adversarial-battery.sh` passou com 19 burlas bloqueadas (B1 a B19). A burla B19 (symlink em guards/ permitido por escopo) foi bloqueada com sucesso.
- **hbn-guards-runner**: `bash guards/hbn-guards-runner.sh` passou com sucesso (exit code 0).

### 4. Diff 8b35c40 e README
- A detecção de symlinks em `guards/assert-scope-lock.sh` foi generalizada para qualquer arquivo staged (no pre-commit local) ou HEAD (em CI) avaliado pelo guard.
- O predicado `is_governed_symlink` utiliza `guard_version_repo_path` para resolver corretamente caminhos em subdiretórios de versão ativa (`versao_*`).
- Cobre com sucesso: `guards/`, `core/`, `src/`, `methodology/`, `.hbn/`, `REGISTRY.md` e caminhos version-rooted (`versao_*`).
- O README em `guards/README.md` documenta apropriadamente sob a seção §Meta-paths o bloqueio de symlink e o comportamento do hardlink como non-issue.

---

## Detalhe de Execução (Evidência Mecânica)

### 1. Histórico de Commits
```
commit 3f62bbde0fd9554c284157afb350c9c4962e850e
Author: claude-fable-5 (Cowork) <mauriciozanin@gmail.com>
Date:   Mon Jun 15 23:26:33 2026 -0300

    chore(hbn): hand off B19 for cross-audit

commit 84abc42e9bb4edeb25358fd94bd6bcf92d20c512
Author: claude-fable-5 (Cowork) <mauriciozanin@gmail.com>
Date:   Mon Jun 15 23:24:16 2026 -0300

    test(guards): cover B19 governed symlink block

commit 8b35c40a1be52df0345de62de3958e84fb2288c1
Author: claude-fable-5 (Cowork) <mauriciozanin@gmail.com>
Date:   Mon Jun 15 23:21:22 2026 -0300

    fix(guards): block symlinks in all governed paths

commit ca5204d2769d3a8ed140e5949d076be9db6d3dda
Author: claude-fable-5 (Cowork) <mauriciozanin@gmail.com>
Date:   Mon Jun 15 23:20:15 2026 -0300

    chore(hbn): open B19 symlink-governed wave
```

### 2. Execução da Bateria Adversarial
```
BURLA                                                | GUARD    | RESULTADO
--------------------------------------------------------------------------------
B1 nome serial novo em .hbn/results/                 | G-NUM    | BLOQUEADA ✓
B2 created_at UTC (Z) no REGISTRY                    | G-NUM    | BLOQUEADA ✓
B3 CI=true local (sem CI real)                       | G-CR     | BLOQUEADA ✓
B4 bypass env sem nota em .hbn/bypasses/             | comuns   | BLOQUEADA ✓
B5 .hbn órfão a 5 níveis de profundidade          | G-STRAY  | BLOQUEADA ✓
B6 symlink .hbn órfão                              | G-STRAY  | BLOQUEADA ✓
B7 .hbn escondido sob backups2/                      | G-STRAY  | BLOQUEADA ✓
B8 HBN_SCAN_ROOT apontando para o nada               | G-STRAY  | BLOQUEADA ✓
B9 scope vazio em safe_track                         | G-SCO    | BLOQUEADA ✓
B10 implementador == auditor (groupthink)            | G-FAM    | BLOQUEADA ✓
B11 hearback sem assinatura (chave registrada)       | G-HRB    | BLOQUEADA ✓
B12 hearback no mesmo commit da obra                 | G-HRB    | BLOQUEADA ✓
B13 exceção impl==agente sem os 4 sinais           | G-EXC    | BLOQUEADA ✓
B14 arquivo de token local ERRADO + FP do log        | G-TOK    | BLOQUEADA ✓
B15 active-version com conflito de merge             | G-CR     | BLOQUEADA ✓
B16 auto-emenda files_allowed + uso                  | G-SCO    | BLOQUEADA ✓
B17 smuggling meta-path tipo/nome arbitrario         | G-SCO    | BLOQUEADA ✓
B18 symlink ADR-025 em meta-path governado           | G-SCO    | BLOQUEADA ✓
B19 symlink em guards/ permitido por escopo          | G-SCO    | BLOQUEADA ✓
```

---

## Tarefa Adversarial (Bateria Adicional Gemini)

Executados testes adversariais adicionais em repositório isolado cobrindo os cenários requisitados:
- **Cenário A (symlink em `.hbn/`, `guards/` e `core/`)**: BLOQUEADA ✓ (Exit code 1; rejeitou corretamente os três caminhos).
- **Cenário B (symlink em path version-rooted `versao_1_0_0/guards/...`)**: BLOQUEADA ✓ (Exit code 1; resolvedor mapeou o caminho ao path real no repositório e bloqueou).
- **Cenário C (symlink em path governado não listado explicitamente, ex: `src/sym.py`, `methodology/sym.md`, `REGISTRY.md`)**: BLOQUEADA ✓ (Exit code 1; todas as tentativas foram rejeitadas pelo guard).
- **Cenário D (hardlink)**: PASSOU ✓ (Exit code 0; Git o materializa como arquivo regular `100644`, não possuindo semântica de symlink no objeto Git commitado).
- **Cenário E (não-regressão: arquivos regulares em todos os paths)**: PASSOU ✓ (Exit code 0; arquivos regulares permitidos nos padrões de escopo passam com sucesso).

---

## Veredito de Fechamento (F)

**A classe symlink/meta-path está FECHADA? SIM.**

**Justificativa:**
A partir do conjunto B17 + B18 + B19:
1. **B17** removeu a brecha de caminhos em `.hbn/messages/` ou `.hbn/bypasses/` aceitarem payloads arbitrários, limitando os meta-paths auto-permitidos apenas aos arquivos protocolares `.json` e `.md` estritamente definidos pelo ADR-025 e hearbacks ativos.
2. **B18** bloqueou qualquer symlink de coordenação staged sob `.hbn/**` (mesmo se o nome do arquivo imitasse um formato protocolar como ADR-025).
3. **B19** generalizou esse bloqueio para **todos os paths governados** avaliados pelo guard, cobrindo todo o escopo de arquivos controlados (código, testes, specs, etc.), mesmo que constem como permitidos em `scope.files_allowed`. Como os symlinks são processados de forma prioritária em `assert-scope-lock.sh` antes de qualquer verificação de escopo, nenhum symlink com modo `120000` em um arquivo de diff/staged consegue ser adicionado ao repositório.
Portanto, a classe de ataque por contrabando (smuggling) via symlinks em áreas sob governança está completamente vedada.

---

## Truth Barrier
- **Nível de Confiança**: 100/100.
- **Não verificado**: Execução em ambiente CI remoto. Todo o escopo de análise foi realizado localmente e os guards validaram a especificação de forma estrita.
