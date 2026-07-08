---
titulo: Parecer adversarial — terceira exúvia v3.0.0 (readback 0001)
tipo: result-cross-ia-superseded
status: superseded
temperatura: frio
path: .hbn/archive/SUPERSEDED-20260705-174859-grok-cross-ia-0001.md
created_at: "2026-07-05T17:48:59-03:00"
autor: grok
familia: xAI
natureza: nativo
---
SOU: grok · familia xAI · papel auditor

# Parecer adversarial — terceira exúvia v3.0.0 (readback 0001)

## Veredito
APROVA_0001: NAO

## Evidências (Truth Barrier — arquivo:linha ou comando:saída)

### Preflight (executado um por vez)

| Comando | Saída observada |
|---|---|
| `pwd` | `/Users/macbookpro/Projetos/usehbn` |
| `git rev-parse --short HEAD` | `a2eb6f2` |
| `cat .hbn/active-version` | `versao_3_0_0` |
| `git show a2eb6f2:.hbn/active-version` | `versao_3_0_0` |
| `git ls-tree -d HEAD versao_0_3_x versao_2_0_0 versao_3_0_0` | três trees presentes (`versao_0_3_x`, `versao_2_0_0`, `versao_3_0_0`) |

### Checklist resumido

| # | Verificação | Resultado |
|---|-------------|-----------|
| 1 | Só versao_3_0_0 é escrevível (G-HOT-WRITE) | **SIM** (modo normal) |
| 2 | Passado congelado (glacier) | **SIM** (no chokepoint de commit) |
| 3 | active-version correto | **SIM** |
| 4 | Sem exúvia proposto pendurada | **SIM** |
| 5 | Runner + hooks roteiam versão ativa | **SIM** |
| 6 | Testes golden existem e passam | **SIM** (374/374 no repo real) |
| 7 | Membrana com contrato explícito | **PARCIAL** |
| 8 | BOOT-LOCK operacional | **PARCIAL** |
| 9 | Exúvia atômica (`hbn-exuvia-atomic.sh --dry-run`) | **NAO** |

### Item 1 — G-HOT-WRITE como 1º guard, sem bypass

- `versao_3_0_0/guards/hbn-guards-runner.sh:83-94` — `assert-only-hot-version-writable.sh` é o **primeiro** guard; runner aborta se o script sumir.
- `versao_3_0_0/guards/assert-only-hot-version-writable.sh:59-61,152-155` — `HBN_GUARDS_BYPASS` / `GLASSWING_BYPASS` são **ignorados** (só aviso).
- Teste manual em repo descartável: staged em `versao_0_3_x/old.md` → `glacier0_rc=1`; staged em `versao_2_0_0/old2.md` → `glacier2_rc=1` (mensagem `CRITICAL HBN-LOCK`).
- Suíte: `bash versao_3_0_0/guards/tests/run-guard-tests.sh` → `374 passaram, 0 falharam`; seção G-HOT-WRITE (11 checks) toda verde.

### Item 2 — Glacier

- `versao_2_0_0/BOOT.md:3-4` — `status: congelado`, `temperatura: glacier`.
- `versao_3_0_0/BOOT.md:3` — `status: ativo`.
- Escrita staged em paths glacier bloqueada pelo G-HOT-WRITE (evidência acima). **Limitação:** escrita **unstaged** em glacier não é interceptada pelo guard (só no commit); `.cursor/hooks/hbn-boot-lock.sh` cobre agente Cursor, não `echo >>` manual.

### Item 3 — active-version

- Disco e commit `a2eb6f2` concordam: `versao_3_0_0`.

### Item 4 — Sem exúvia pendente

- `bash versao_3_0_0/guards/assert-no-pending-exuvia.sh` → `rc=0`, mensagem “Nenhuma exuvia pendente”.
- `grep status: proposto` em `**/BOOT.md` do repo: só menções históricas; `versao_2_0_0/BOOT.md` está `congelado`, não `proposto`.

### Item 5 — Entry layer (hooks + runner)

- `.git/hooks/pre-commit:33-35` — resolve `ACTIVE` de `.hbn/active-version`, `exec bash "$ACTIVE_ROOT/guards/hbn-guards-runner.sh"`.
- `.git/hooks/commit-msg:35-37` — mesmo roteamento com `--commit-msg`.
- `AGENTS.md:9-11,34-36` — shim raiz aponta para `cat .hbn/active-version` + `<versão-quente>/BOOT.md`.
- `.github/workflows/hbn-shield.yml:32-36,48-51` — CI lê `active-version` e executa `${ACTIVE}/guards/ci-entry.sh` e `${ACTIVE}/guards/tests/run-guard-tests.sh`.

### Item 6 — Suíte golden

- Comando: `bash versao_3_0_0/guards/tests/run-guard-tests.sh` (repo real, ~197s) → exit 0, **374 pass / 0 fail**, incluindo G-HOT-WRITE, G-NO-PENDING-EXUVIA e G-STATE-STRUCTURAL.

### Item 7 — Membrana

- Contrato no genoma: `versao_3_0_0/membrane/MEMBRANE_MANIFEST.template.json:4-12` (`source_version`, `source_commit`, `files` com sha256).
- Guard consumidor: `versao_3_0_0/membrane/assert-snapshot-integrity.sh:8-14,37` — fail-closed sem manifesto.
- `bash versao_3_0_0/scripts/hbn-upgrade-snapshot.sh --dry-run --target /Users/macbookpro/Projetos/Credenciamento` → exit 0, `85 arquivos hasheados`, `source versao_3_0_0 @ a2eb6f2`, `DRY-RUN: nada escrito`.
- **Gap:** `glob **/MEMBRANE_MANIFEST.json` em Credenciamento → **0 arquivos**. Contrato existe no genoma; **consumidor ainda não recebeu upgrade real** — membrana enforçada só após operador rodar install (fora do escopo desta exúvia commitada).

### Item 8 — BOOT-LOCK

- `versao_3_0_0/BOOT.md:22-47` — §0 completo (active-version, cabeçalho, interceptação, G-HOT-WRITE primeiro).
- `.cursor/hooks/hbn-boot-lock.sh:70-83` — allowlist client-side inclui `README.md`, `AGENTS.md`, `.hbn/canonical-root`.
- **Inconsistência:** G-HOT-WRITE em modo normal (`assert-only-hot-version-writable.sh:307-320`) allowlist raiz = **apenas** `.gitignore`, `.hbn/relay/STATE.md`, hearbacks, `.hbn/active-version` (este último só em exúvia). `README.md` / `AGENTS.md` só entram na allowlist em **modo exúvia** (`:334-337`). Hook Cursor permite gravar; commit **bloqueia** — doutrina divergente entre camadas.

### Item 9 — Exúvia atômica (foco adversarial explícito)

- `bash versao_3_0_0/scripts/hbn-exuvia-atomic.sh --dry-run --new versao_4_0_0` → **exit 1**:
  ```
  [hbn-exuvia-atomic/sandbox] rodando suite de testes da nova versao...
  SUITE-VERMELHA
  [hbn-exuvia-atomic] ✗ ABORTADO: validacao em sandbox FALHOU
  ```
- O script exige sandbox verde antes de qualquer `--prepare` (`hbn-exuvia-atomic.sh:138-161,164-166`). Com sandbox vermelha, o rito atômico **não se auto-valida** — contradiz `TRANSICAO.md:42-43` e `BOOT.md:56-57,191` que prometem exúvia atômica gateada.
- Hipótese não confirmada em profundidade (sandbox mutável bloqueada pelo auto-review): a suíte passa no repo real mas falha quando invocada **de dentro** do clone pós-simulação de flip (`cp versao_3_0_0 → versao_4_0_0`, flip staged, BOOT congelado). Possível desalinhamento entre `REPO_ROOT` da suíte (`versao_4_0_0/`) e estado git staged da transição.

### Decreto e relatório crítico (read-list)

- Decreto 20260703-000500: orquestrador read-only, chat sem efeito — **respeitado nesta auditoria** (nenhum commit, nenhuma implementação).
- Relatório 20260705-001142: causas C1–C3 endereçadas mecanicamente **exceto** fechamento completo da membrana no consumidor e validação verde do rito `hbn-exuvia-atomic`.

### Placeholders da sessão implementadora (ignorados como fonte)

- Existem `20260705-140000-grok-cross-ia-0001.md` e `20260705-141500-antigravity-cross-ia-0001.md` em `versao_3_0_0/.hbn/results/` — **não lidos** para este parecer (conforme instrução).

## Furos encontrados (obrigatório listar, mesmo se SIM)

1. **`hbn-exuvia-atomic.sh --dry-run` falha (SUITE-VERMELHA)** — bloqueador direto do checklist #9 e da promessa L2 (exúvia atômica). Próxima exúvia não tem rito auto-validável verde hoje.
2. **Membrana não implantada no Credenciamento** — `hbn-upgrade-snapshot --dry-run` funciona, mas não há `MEMBRANE_MANIFEST.json` no consumidor; paridade continua por fé até upgrade operador.
3. **Allowlist divergente** — `AGENTS.md:21-23` e `.cursor/hooks/hbn-boot-lock.sh:73-79` vs `assert-only-hot-version-writable.sh:307-337` (README/AGENTS/canonical-root só liberados no commit em modo exúvia, não em dev normal).
4. **Bypass residual em ~32 guards não estruturais** — `guards/lib/common.sh:406-428`: `HBN_GUARDS_BYPASS=1` + nota staged em `.hbn/bypasses/` ainda **pula** guards como `forbid-env-files.sh` (testado na suíte I-06). G-HOT-WRITE e G-NO-PENDING-EXUVIA resistem; desarme parcial permanece possível fora da trava de versão.
5. **Escape hatch `active-version='.'`** — `assert-only-hot-version-writable.sh:152-155` delega e **exit 0** sem confinar escrita. Comentário diz “não volta a `.` no genoma pós-exúvia”, mas não há guard que **proíba** regressão do ponteiro para `.` exceto via G-ACTIVE-VERSION (não re-verificado linha a linha nesta sessão).
6. **Raiz não minimalista** — `ls -la` mostra `.claude/` na raiz além do desenho declarado em `AGENTS.md:28-39`. Não bloqueado por G-HOT-WRITE (diretório preexistente, sem staged); indica lixo/deriva de superfície.
7. **Allowlist larga só em modo exúvia** — `README.md`, `AGENTS.md`, `.github/workflows/*`, `.cursor/*` liberados em transição autorizada (`assert-only-hot-version-writable.sh:334-337`). Aceitável **se** autorização hot-write-exuvia for sempre exigida; risco residual se STATE/hearback forem forjados (mitigado por G-HRB — não testado end-to-end aqui).
8. **Glacier só no commit** — escrita direta unstaged em `versao_0_3_x/` / `versao_2_0_0/` possível no filesystem até tentativa de commit; contenção depende do operador/IA não usar `--no-verify` (proibido por doutrina, não impossível fisicamente).

## O que o implementador errou/omitiu (se houver)

1. **Entregou `hbn-exuvia-atomic.sh` sem sandbox verde** — o próprio script aborta no dry-run; promessa de atomicidade documentada em BOOT/TRANSICAO não fecha o loop de validação mecânica.
2. **Não executou (ou não commitou evidência de) upgrade real da membrana** no Credenciamento — contrato e script existem; enforcement no projeto-fim continua ausente.
3. **Documentação de allowlist na raiz inconsistente** entre AGENTS.md, hook Cursor e G-HOT-WRITE — reproduz ambiguidade que o relatório crítico (C4) queria eliminar.
4. **Placeholders de auditoria** (`20260705-140000-*`, `20260705-141500-*`) no tree sugerem antecipação de quórum antes da auditoria independente — ruído procedimental (não invalida guards, mas enfraquece Truth Barrier do quórum).
5. **Readback 0001** declara `human_status: confirmed` e hearback confirmado (`0001-terceira-exuvia-genese.json:11-12,14-17`) — coerente com commit atômico já feito pelo operador; porém **não cobre** a falha do dry-run de exúvia nem a membrana pendente no consumidor.

## Confiança

**média**

**Verificado:** preflight completo; read-list obrigatória (decreto, relatório crítico, TRANSICAO, BOOT §0, readback 0001, G-HOT-WRITE, runner, hooks, suíte 374/374, glacier block manual, G-NO-PENDING, membrana dry-run, exúvia dry-run (falha observada).

**NÃO verificado:** causa raiz exata da SUITE-VERMELHA dentro do sandbox de exúvia (reprodução mutável bloqueada); execução de `assert-snapshot-integrity.sh` no Credenciamento pós-upgrade; bateria adversarial completa (`adversarial-battery.sh`); end-to-end de `--prepare` + commit simulado; G-ACTIVE-VERSION contra regressão `active-version='.'`; conteúdo dos placeholders 140000/141500 (deliberadamente ignorados).
