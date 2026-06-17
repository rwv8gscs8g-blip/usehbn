---
titulo: "Parecer R1+R1-fix — Cross-IA Cursor"
tipo: audit-result
status: final
temperatura: frio
path: .hbn/results/20260617-060212-cursor-cross-ia-r1-mais-fix.md
id-global: 20260617-060212-cursor-cross-ia-r1-mais-fix
autoria: cursor-gpt52
familia: OpenAI
created_at: "2026-06-17T06:02:12-03:00"
---

SOU: cursor-gpt52 · familia OpenAI · papel auditor.

VEREDITO

- APROVA_R1: SIM (cobre readback 0038 + 0039; commits 9241524..0692d15 e aeaf692..16eabd9).
- Confianca: 87/100.
- Marginais: unica pendencia de honestidade e deriva de docs (H2: 211 -> 212).
- Data: 2026-06-17 (UTC-3).

ESCOPO E ALVO (Truth Barrier)

- Repo: `/Users/macbookpro/Projetos/usehbn`
- Branch: `proposta/reestruturacao-m-a-s0`
- HEAD: `16eabd96575fba16c4e58d094dd25b8dd1782d26`
- main (hash informado): `4db692876381a0d7909985c8500d999f2e677b04`

Comandos+saidas:

```bash
cd /Users/macbookpro/Projetos/usehbn && git status -sb && git rev-parse HEAD && git branch --show-current
```

Saida:

```
## proposta/reestruturacao-m-a-s0
16eabd96575fba16c4e58d094dd25b8dd1782d26
proposta/reestruturacao-m-a-s0
```

```bash
cd /Users/macbookpro/Projetos/usehbn && git show -s --oneline 4db692876381a0d7909985c8500d999f2e677b04
```

Saida:

```
4db6928 docs: emenda plano hbn-exuvia v2
```

R1-fix (0039) — PONTOS PRIORITARIOS

F1) Bloqueador fechou (dedup de `decisions` e `context_history`)

- Implementacao: `src/usehbn/state/store.py:62-120` agora usa `_merged_with_dedup()` em *todas* as listas (`executions/decisions/context_history/results`). Identidade = `execution_id` quando presente, senao chave deterministica de conteudo JSON (`json.dumps(sort_keys=True, separators=(",", ":"), ensure_ascii=False)`).

Prova ANTES/DEPOIS com o teste novo (`tests/test_state_dual_read.py`) aplicado ao pre-fix:

ANTES (pre-fix = `aeaf692` via worktree; teste do HEAD copiado sem commit):

```bash
cd /Users/macbookpro/Projetos/usehbn && git worktree add -d /tmp/usehbn-pre-fix aeaf692
cp tests/test_state_dual_read.py /tmp/usehbn-pre-fix/tests/test_state_dual_read.py
/Users/macbookpro/Projetos/usehbn/.venv/bin/pytest -q /tmp/usehbn-pre-fix/tests/test_state_dual_read.py -q
```

Saida (FALHA):

```
....FF.                                                                  [100%]
FAILED ...::test_load_state_document_merges_dedup_when_both_exist
FAILED ...::test_load_state_document_dedups_idless_items_by_content
```

Detalhe (primeira falha mostra duplicacao de `exec-shared` em `decisions/context_history`):

```
Left contains one more item: 'exec-shared'
```

DEPOIS (HEAD = `16eabd9`):

```bash
cd /Users/macbookpro/Projetos/usehbn && .venv/bin/pytest -q tests/test_state_dual_read.py
```

Saida (PASSA):

```
.......                                                                  [100%]
7 passed in 0.03s
```

F2) Dedup nao mescla demais

- O teste `tests/test_state_dual_read.py:196-255` valida dedup por conteudo para itens sem `execution_id`: conteudo identico colapsa; conteudo diferente permanece (asserts de count==1 e len==3).
- Confirmacao por execucao (incluida acima no “7 passed” em HEAD) + falha pre-fix (acima) mostrando o caso identico duplicando antes do fix.

F3) Canonico vence quando `execution_id` e compartilhado

- O teste `tests/test_state_dual_read.py:126-194` checa explicitamente:
  - `shared["action_taken"] == "from-canonical"` para `results` (linha ~178-179).
  - `shared["source"] == "from-canonical"` para `decisions` e `context_history` (linha ~189-193).
- Confirmacao por execucao (incluida acima no “7 passed” em HEAD).

F4) Regressao do append (sem duplo-write)

- `append_execution_state()` escreve apenas no canônico: `src/usehbn/state/store.py:138-151` usa `path = state_file_path(base_dir)` e `write_json(path, document)`; nao toca `_legacy_*`.
- `append_result_state()` idem: `src/usehbn/state/store.py:154-167`.
- Teste cobrindo write-only canônico para resultados: `tests/test_state_dual_read.py:257-271` (`test_append_result_state_writes_only_to_canonical_dir`).

R1 (0038) — RECONFIRMAR

A1) Golden tests dos “17 subcomandos”

```bash
cd /Users/macbookpro/Projetos/usehbn && .venv/bin/pytest -q tests/test_cli_golden_contract.py
```

Saida:

```
25 passed in 0.18s
```

A2) Exit codes (provas com `echo $?`)

- Subcomando desconhecido (exemplo: `connector` subcommand invalido) -> 2:

```bash
cd /Users/macbookpro/Projetos/usehbn && .venv/bin/hbn connector nope ; echo EXIT:$?
```

Saida:

```
__main__.py connector: error: argument connector_command: invalid choice: 'nope' (choose from 'inspect', 'ensure')
EXIT:2
```

- Violacao de protocolo (hearback pendente bloqueia handoff) -> 3:

```bash
cd /Users/macbookpro/Projetos/usehbn && tmpdir=$(mktemp -d) && .venv/bin/hbn init --target "$tmpdir" --runtime auto >/dev/null && .venv/bin/hbn readback exec-pending-001 --agent-id test-agent --intent-json '{"objective":"x","constraints":[],"risks":[],"validation_requirements":[]}' --understanding 'u' --invariant 'i1' --plan-step 'p1' --storage-dir "$tmpdir" >/dev/null && .venv/bin/hbn handoff --to auditor --summary 'try handoff' --target "$tmpdir" ; echo EXIT:$?
```

Saida:

```
{
  "error": "Cannot handoff: pending readbacks require hearback confirmation.",
  "pending_readbacks": ["exec-pending-001"]
}
EXIT:3
```

- Sucesso -> 0:

```bash
cd /Users/macbookpro/Projetos/usehbn && .venv/bin/hbn version ; echo EXIT:$?
```

Saida:

```
{ "package_version": "0.3.0", "protocol_version": "0.3.0", "cli": "hbn" }
EXIT:0
```

A3) Estado unificado: escrita so em `.hbn/`

- Caminho canônico documentado e implementado: `src/usehbn/state/store.py:28-35` (`.hbn/state/hbn-state.json`).
- Leitura/merge legado read-only: `src/usehbn/state/store.py:42-49` + `load_state_document():62-120`.
- Escrita: apenas `state_file_path()` em `append_execution_state()` e `append_result_state()` (ver F4 acima).

HONESTIDADE (CRITICO)

H1) Pytest — contagem REAL

```bash
cd /Users/macbookpro/Projetos/usehbn && .venv/bin/pytest -q
```

Saida:

```
212 passed in 0.70s
```

H2) Deriva conhecida (docs ainda dizem 211)

- `AGENTS.md:57` -> “currently 211/211 passing”.
- `README.md:5-7` -> “Tests: 211/211” e badge “Tests-211/211”.
- `methodology/MATURITY-MATRIX.md:79` -> “Suite verde 211/211”.

Confirmado por leitura no disco (trechos observados):
- `AGENTS.md` linha 57: `Tests: pytest (tests/, currently 211/211 passing).`
- `README.md` linha 5: `Tests: 211/211.`
- `methodology/MATURITY-MATRIX.md` linha 79: `Suite verde 211/211 (...)`.

Status: **pendencia de freeze (docs)** — precisa sincronizar 211 -> 212 antes do v1-estavel. Nao ha bloqueador de codigo.

H3) Autoevolve declarado Parcial/Scaffold na matriz; AGENTS aponta para a matriz; README “L4” resolvido

- Ponteiro: `AGENTS.md:17` aponta `methodology/MATURITY-MATRIX.md` como fonte unica de maturidade.
- `README.md:63` declara: “Autoevolve | Parcial / Scaffold”.
- Matriz: `methodology/MATURITY-MATRIX.md:73-75` separa autoevolve (audit/report) Parcial e (orchestrator/worker/queue/approval) Scaffold.

NAO-REGRESSAO

N1) adversarial-battery B1-B33 verde

```bash
cd /Users/macbookpro/Projetos/usehbn && bash guards/tests/adversarial-battery.sh
```

Saida (resumo final):

```
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

N2) Ranges alteram apenas files_allowed (sem guard/core/schema)

0039:

```bash
cd /Users/macbookpro/Projetos/usehbn && git diff --name-only 16eabd9~4 16eabd9
```

Saida:

```
.hbn/messages/20260617-010500-codex-handoff-r1-fix.md
.hbn/readbacks/0039-r1-fix-dedup-estado.json
.hbn/relay/STATE.md
REGISTRY.md
src/usehbn/state/store.py
tests/test_state_dual_read.py
```

0038:

```bash
cd /Users/macbookpro/Projetos/usehbn && git diff --name-only da75a2b..0692d15
```

Saida (lista completa):

```
.hbn/messages/20260616-235900-codex-handoff-r1.md
.hbn/readbacks/0038-r1-runtime-honestidade.json
.hbn/relay/STATE.md
AGENTS.md
README.md
REGISTRY.md
methodology/MATURITY-MATRIX.md
src/usehbn/cli.py
src/usehbn/protocol/result.py
src/usehbn/runtime.py
src/usehbn/state/store.py
src/usehbn/utils/config.py
tests/test_cli_autoevolve_help.py
tests/test_cli_golden_contract.py
tests/test_relay.py
tests/test_result_protocol.py
tests/test_state_dual_read.py
```

N3) main conforme N3

- Ver “ESCOPO E ALVO” acima (git show hash).

N4) Trailers contiguos (0038=6 commits; 0039=4 commits; G-EXC ativo; implementador=Codex)

```bash
cd /Users/macbookpro/Projetos/usehbn && git log --format=fuller --reverse 9241524..0692d15
cd /Users/macbookpro/Projetos/usehbn && git log --format=fuller --reverse aeaf692~1..16eabd9
```

Saida (amostra de trailer padrao em ambos os ranges):

```
HBN-Readback: 0038|0039
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```
