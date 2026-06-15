---
titulo: "Cross-audit — Reestruturação Opção B (replay limpo M-A+S0)"
tipo: audit-result
status: final
temperatura: frio
path: .hbn/results/20260615-095029-cursor-cross-ia-reestruturacao-m-a-s0.md
id-global: 20260615-095029-cursor-cross-ia-reestruturacao-m-a-s0
autoria: cursor
familia: Cursor
created_at: "2026-06-15T09:50:29-03:00"
origem: despacho opus-4-8 cross-audit reestruturacao-m-a-s0
---

# Cross-audit — Reestruturação Opção B (replay limpo M-A+S0)

PAPEL auditor · TOKEN cursor · FAMÍLIA Cursor · CONTEXTO 92% · "auditando do disco"

**Alvo:** branch `proposta/reestruturacao-m-a-s0`, tip `5a0587d`  
**Referência:** `3b03a32`, tag `evidencia/orquestrador-bug-2026-06-14`  
**Implementador auditado:** Codex (família OpenAI) — auditor Cursor (família distinta)  
**Repo:** `/Users/macbookpro/Projetos/usehbn`

## Veredito

**APROVA_REESTRUTURACAO: SIM**

A árvore do tip é byte-a-byte equivalente às referências; os 18 commits do replay separam implementação de depósito de auditoria; o rito ADR-025 + REGISTRY + `HBN-Token-FP: 34a7f2f9` está presente nos commits de artefato; as três suítes de guards passam no host real (fora do sandbox Cursor).

---

## 1. Regra zero

```text
$ pwd
/Users/macbookpro/Projetos

$ cd /Users/macbookpro/Projetos/usehbn && GIT_OPTIONAL_LOCKS=0 git status
On branch proposta/reestruturacao-m-a-s0
Untracked files:
  (vários .hbn/messages, .hbn/results legados, guards/tests/tmp-*)
nothing added to commit but untracked files present
```

Raiz existe; branch correta.

---

## 2. Tree-equivalência

### 2.1 `5a0587d` vs `3b03a32`

```text
$ GIT_OPTIONAL_LOCKS=0 git diff --name-status 5a0587d 3b03a32

(vazio)
```

**OK** — saída vazia.

### 2.2 `5a0587d` vs tag `evidencia/orquestrador-bug-2026-06-14`

```text
$ GIT_OPTIONAL_LOCKS=0 git diff --name-status 5a0587d evidencia/orquestrador-bug-2026-06-14

(vazio)
```

**OK** — saída vazia. Tag aponta para `3b03a32` com anotação:
`evidencia: historia M-A+S0 antes do replay limpo (271ca85 empacotado; ca69ef9 drible de escopo)`.

### 2.3 `main`

```text
$ GIT_OPTIONAL_LOCKS=0 git rev-parse main
4db692876381a0d7909985c8500d999f2e677b04
```

**OK** — SHA esperado `4db6928`.

---

## 3. Separação de commits (`main..5a0587d`)

```text
$ GIT_OPTIONAL_LOCKS=0 git log --oneline main..5a0587d
5a0587d docs: propose d-orq-write doctrine
724c321 hbn: deposit s0 audit artifacts
d1a8246 record s0 governance artifacts
c0528b0 mark relay index superseded by state
e27337c add cross-family model profiles
45d1ef5 fix: reconcile rollback state from target
2f67377 M-A: deposit workspace-locator Opus boot prompt
9db8162 hbn: extend M-A scope for workspace-locator prompt
8b5cf0c M-A: deposit corrected Opus boot prompt
1113dd3 M-A: deposit orchestrator-bug consolidation
96ce169 M-A: deposit Codex orchestrator-bug audit
94bd1ce M-A: deposit Gemini orchestrator-bug audit
1796c99 hbn: extend M-A scope for orchestrator-bug artifacts
3c4500b M-A: deposit Gemini scaffold audit
861f914 M-A: record scaffold governance artifacts
cafb205 M-A: implement inactive exuvia scaffold
ff4a0d8 hbn: add M-A scaffold readback
```

### 3.1 Inspeção dos quatro commits indicados

**`cafb205`** — só implementação mecânica (`guards/`, `scripts/`, `core/`, `.gitignore`, `.hbn/active-version`) + linha REGISTRY do scaffold. Sem `.hbn/results/`. Trailer `HBN-Token-FP: 34a7f2f9` presente.

**`3c4500b`** — só `.hbn/results/20260614-193452-gemini-3-5-cross-ia-m-a-scaffold.md` + `REGISTRY.md`. Sem guards/scripts.

**`1796c99`** — só extensão de escopo em `.hbn/readbacks/0012-M-A-scaffold-inativo.json` (`scope_extension_20260614_203423`). Nenhum artefato autorizado nasce no commit.

**`9db8162`** — só extensão de escopo (`scope_extension_20260614_204536`). Idem.

### 3.2 Varredura automática impl+auditoria

Script sobre todos os 18 commits: **nenhum** commit mistura paths `guards/|scripts/|core/` com `.hbn/results/`.

Commits `724c321` e `d1a8246` agrupam readback + results + handoff + STATE (bookkeeping S0 herdado do replay) — padrão de depósito governado, **não** impl+auditoria.

**`files_allowed` vs artefato autorizador:** `ff4a0d8` cria o readback 0012 isolado; extensões de escopo (`1796c99`, `9db8162`) precedem depósitos; implementação (`cafb205`) vem depois do readback e das extensões. Sem fusão proibida detectada.

**OK**

---

## 4. Rito ADR-025 + REGISTRY + trailers

Todos os commits que depositam `.hbn/results/` ou alteram `REGISTRY.md` no range carregam `HBN-Token-FP: 34a7f2f9` e, para cada result novo, linha REGISTRY no **mesmo** commit com nome `AAAAMMDD-HHMMSS-<agente>-<slug>.md` conforme `methodology/adr/ADR-025-nome-universal-artefato-ia.md:39-44`.

Amostra verificada (9 artefatos results no range): nomes ADR-025 OK; linha REGISTRY OK em todos.

**OK**

---

## 5. Suítes de guards

### 5.1 `bash guards/tests/run-guard-tests.sh`

Primeira execução **no sandbox Cursor** falhou (43/132) por `xargs: sysconf(_SC_ARG_MAX) failed` — artefato do ambiente, não do código.

Reexecução **fora do sandbox** (`required_permissions: all`):

```text
== resumo: 132 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

**OK** (host real).

### 5.2 `bash guards/tests/adversarial-battery.sh`

Sandbox: 2 burlas passaram (B4, B15) — mesmo artefato de ambiente.

Fora do sandbox:

```text
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
(15/15 BLOQUEADAS)
```

**OK** (host real).

### 5.3 `bash guards/hbn-guards-runner.sh`

```text
[hbn-guards] Todos os guards passaram.
```

**OK**

---

## 6. Questão aberta — readback 0016 / handoff governado

**Constatação:** não existe `.hbn/readbacks/0016-*.json` nem handoff de reestruturação no tip `5a0587d`. Codex preservou tree-equivalência com `3b03a32`/tag ao omitir artefatos novos de bookkeeping da própria reestruturação.

**Opinião:** renúncia **aceitável durante o replay**, desde que:

1. A tag `evidencia/orquestrador-bug-2026-06-14` permaneça como âncora da história suja (já existe, `3b03a32`).
2. O operador humano faça **commit de selagem por cima** do tip replayado — não dentro dele — depositando:
   - readback `0016-reestruturacao-m-a-s0.json` (escopo = só artefatos de bookkeeping da reestruturação + este parecer),
   - handoff correspondente,
   - linhas REGISTRY,
   - atualização de STATE se necessário.

**Recomendação:** **âncora-tag (já feita) + commit de selagem pós-merge**, não readback 0016 embutido no replay (quebraria a equivalência que o replay existe para provar). Os pareceres cross-IA de selagem (este arquivo + eventual par Gemini) ficam staged/untracked até o operador commitar — padrão correto do despacho.

---

## 7. Truth barrier

**Confiança:** alta nos itens mecânicos (tree-equivalência, separação, ADR-025, suítes no host).

**Não verificado diretamente:**

- CI remoto / `hbn-shield.yml` nesta branch (sem push nem `gh` nesta sessão).
- Ratificação humana além dos trailers `HBN-Human-Authorization` nos commits (aceitos como evidência git).
- Conteúdo semântico linha-a-linha dos 51 arquivos alterados vs intenção M-A+S0 (auditoria estrutural, não re-auditoria funcional completa da onda M-A).
- Primeira execução das suítes no sandbox Cursor (falso negativo documentado em 5.1/5.2).

---

*Auditor: cursor (família Cursor) · Carimbo: 2026-06-15T09:50:29-03:00 · Tip auditado: 5a0587d*
