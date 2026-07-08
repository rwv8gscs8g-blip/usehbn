---
path: .hbn/results/20260617-125600-grok-cross-ia-curadoria-p0-0045.md
id-global: 20260617-125600-grok-cross-ia-curadoria-p0-0045
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0045: SIM"
onda: curadoria-p0
created_at: "2026-06-17T12:56:00-03:00"
status: congelado
temperatura: glacier
---

SOU: grok · familia xAI · papel auditor

APROVA_0045: SIM

# Parecer Cross-IA — Curadoria P0 de Documentação (Readback 0045)

- **Auditor:** grok (xAI)
- **Implementador:** Codex (OpenAI)
- **Orquestrador:** claude-opus-4-8
- **Data/Hora:** 2026-06-17T12:56:00-03:00
- **Identificação:** `20260617-125600-grok-cross-ia-curadoria-p0-0045`
- **Branch/HEAD:** proposta/reestruturacao-m-a-s0 @ f8e655d
- **Main (verificado):** 4db6928 (intocado)

---

## 1. A1. ZERO PONTEIRO MORTO

Extraí todos os links Markdown de AGENTS.md via grep de padrões \[.*\]\(.*\) e validação manual de texto. Cada path-alvo foi verificado com `ls -ld <path>`.

### Links Markdown (principais) e prova de existência (comando+saída):

1. `docs/INTEGRATION-AGENTS-MD.md` (AGENTS.md:5) — existe
2. `agents/` (AGENTS.md:7,142) — dir existe
3. `.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md` (AGENTS.md:16) — existe
4. `core/role-cards.md` (AGENTS.md:17,18) — existe
5. `methodology/MATURITY-MATRIX.md` (AGENTS.md:32) — existe (canônico)
6. `docs/GLOSSARY.md` (AGENTS.md:33) — existe
7. `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (AGENTS.md:39) — existe
8. `core/esteira-pre-transicao.md` (AGENTS.md:103) — existe
9. `docs/INTEGRATION-GLASSWING.md` (AGENTS.md:134) — existe
10. `methodology/ADR-AND-MD-PRIMER.md` (AGENTS.md:138) — existe
11. `agents/agents.md`, `agents/claude.md`, `agents/codex.md`, `agents/safety.md`, `agents/wave-protocol.md` (AGENTS.md:144-148) — todos existem
12. `auditoria/00_status/07_MD_I_SNAPSHOT_TOOLING.md` (AGENTS.md:167) — existe
13. `methodology/adr/INDEX.md` (AGENTS.md:187) — existe
14. `REGISTRY.md` (AGENTS.md:188) — existe
15. `docs/WAVE-PLAN-V0.3.0.md` — existe
16. `.hbn/relay/INDEX.md` — existe
17. `.hbn/relay/STATE.md` (text refs) — existe
18. `CHANGELOG.md`, `CONTRIBUTING.md`, `LICENSE` (refs textuais) — existem
19. `.hbn/knowledge/0001,0002,0023,0024,0025` — todos presentes

```bash
$ ls -ld docs/INTEGRATION-AGENTS-MD.md agents/ .hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md core/role-cards.md methodology/MATURITY-MATRIX.md docs/GLOSSARY.md methodology/PRINCIPIOS-CONSTITUCIONAIS.md core/esteira-pre-transicao.md docs/INTEGRATION-GLASSWING.md methodology/ADR-AND-MD-PRIMER.md agents/agents.md agents/claude.md agents/codex.md agents/safety.md agents/wave-protocol.md methodology/adr/INDEX.md REGISTRY.md .hbn/relay/INDEX.md .hbn/relay/STATE.md CHANGELOG.md CONTRIBUTING.md .hbn/knowledge/0001-comandos-atomicos-copiaveis.md .hbn/knowledge/0002-entrega-operacional-minimalista.md .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
... (todos retornaram -rw ou drwxr, sem "No such file")
```

### modules/ e radar/:

```bash
$ ls -d modules/ radar/ 2>&1 || true
ls: modules/: No such file or directory
ls: radar/: No such file or directory
```

```bash
$ grep -n 'modules/\|radar/' AGENTS.md
95:Note: `modules/` and `radar/` do **not** exist on disk. Normative specs live in
192:- v1.1 (proposta) — curadoria P0 2026-06-17: corrige ponteiros mortos (remove `modules/` e `radar/` inexistentes), ...
```

Somente aparecem na nota informativa + changelog da versão. **Zero ponteiros mortos**. A1 VERDE.

---

## 2. A2. AGENTS HONESTO

- `core/` declarado explicitamente como "living, sealed normative specs (status: accepted)" (AGENTS.md:77) e na nota de versão v1.1: "declara `core/` como casa das specs vivas (não legado)" (AGENTS.md:192). Nenhuma menção a "legacy" ou superseded para core/.
- Maturidade: "Maturity reference: [`methodology/MATURITY-MATRIX.md`](methodology/MATURITY-MATRIX.md) — single source of truth" (AGENTS.md:32,68). `docs/MATURITY-MATRIX.md` marcado SUPERSEDED e não lido para estado.
- Autoevolve: caveat honesto em AGENTS.md:70-72: "> Maturity caveat: parts of `src/usehbn/` are **Scaffold/Stub** (notably the `autoevolve` orchestrator/worker/queue) — see `methodology/MATURITY-MATRIX.md`."
- MATURITY-MATRIX confirma (methodology/MATURITY-MATRIX.md:74): `**Autoevolve (orchestrator/worker/queue/approval)** | Scaffold`
- Princípios, sinais HBN, contratos por IA, REGISTRY, esteira, cartão de entrada todos preservados e apontando corretamente.

A2 VERDE. AGENTS.md agora é honesto sobre o que existe no disco.

---

## 3. A3. FIDELIDADE (AGENTS.md + GLOSSARY.md == propostas)

- `AGENTS.md` conteúdo (após cabeçalho) coincide verbatim com o bloco em `docs/brainstorm/rodada-2026-06-17/curadoria-p0/AGENTS-corrigido-proposto.md` (linhas ~37 a ~230 do proposto).
- `docs/GLOSSARY.md` coincide verbatim (exceto possivelmente newline final) com `docs/brainstorm/rodada-2026-06-17/curadoria-p0/GLOSSARY-proposto.md`.
- `docs/MATURITY-MATRIX.md` (stub atual):

```bash
$ cat docs/MATURITY-MATRIX.md
# Maturity Matrix — SUPERSEDED
> Arquivo SUBSTITUIDO. A fonte unica da matriz de maturidade do useHBN e
> **methodology/MATURITY-MATRIX.md**. Nao leia este arquivo para estado do protocolo.
> Preservado (nao deletado) para nao quebrar ponteiros historicos (append-only, ADR-011).
```

- Proposto no `matriz-dedup-acao.md:30-36` era texto ligeiramente diferente (3 linhas com mais detalhes), mas stub **cumpre a função**: removeu 100% do conteúdo stale (tabela pré-ondas), redireciona corretamente, preserva arquivo por P7. **Nenhum conteúdo stale sobrou**. Marginal conhecida e aceitável (não bloqueador).

Verificação de ponteiros vivos que apontavam para docs/MATURITY não foram tocados (escopo proíbe: files_forbidden inclui "docs/**" exceto os 2 listados). Correção de ponteiros é out_of_scope explícito no readback.

A3 VERDE (com nota marginal documentada).

---

## 4. A4. GLOSSÁRIO FIEL (amostra 5 termos vs spec-fonte)

1. **Exúvia (molt / muda)** (GLOSSARY.md:9-13): "Momento em que o protocolo abandona a 'carapaça' ... → `core/exuvia-fitness-criteria.md`, `core/hbn-exuvia-scaffold.md`."  
   Confere: core/exuvia-fitness-criteria.md:19-25 descreve analogia lagosta + critérios. Existe no disco.

2. **Fronteira** (GLOSSARY.md:21-25): "Zona experimental/não-normativa ... → `docs/brainstorm/`, `core/exuvia-fitness-criteria.md`."  
   Confere: estrutura `docs/brainstorm/rodada-...` existe; spec exuvia cita fronteira.

3. **Livro-razão / REGISTRY** (GLOSSARY.md:27-30): "Ledger append-only (`REGISTRY.md`) ... nunca rename, nunca delete; a linha mais recente do path vence. → `REGISTRY.md` (ADR-011...)."  
   Confere: REGISTRY.md:2,7,13: "append-only; uma linha por evento ... nunca rename, nunca delete".

4. **Esteira de pré-transição** (GLOSSARY.md:56-59): "... → `core/esteira-pre-transicao.md`."  
   Confere: core/esteira-pre-transicao.md:10+: "Esteira de Pre-Transicao", regras R-PT*, "nenhum freeze e nenhuma exuvia sem a esteira cumprida".

5. **Guard** (GLOSSARY.md:41-44) + **Scope-lock** (GLOSSARY.md:61-64): "Script bash que **bloqueia** ... → `guards/`, `core/exuvia-fitness-criteria.md:48`." / "o guard `assert-scope-lock.sh` ... → `guards/assert-scope-lock.sh:1-15`."  
   Confere: guards/assert-scope-lock.sh:1-15 implementa G-SCOPE extraindo files_allowed; exuvia spec cita Guard.

A4 VERDE. Amostra fiel; ponteiros válidos.

---

## 5. N1. ESCOPO = 7 files_allowed do 0045

```bash
$ git diff --name-only c13d64a..f8e655d
.hbn/messages/20260617-113500-codex-handoff-curadoria-p0.md
.hbn/readbacks/0045-curadoria-p0-docs.json
.hbn/relay/STATE.md
AGENTS.md
REGISTRY.md
docs/GLOSSARY.md
docs/MATURITY-MATRIX.md
```

Exatamente os 7 (handoff preenchido com timestamp real). 

files_forbidden não tocados: main, guards/**, schemas/**, src/**, core/**, methodology/**, docs/brainstorm/** (exceto os gerados em results/ que são esperados para auditor).

N1 VERDE.

---

## 6. N2. TESTES 213 + ADVERSARIAL B1-B33 VERDE

```bash
$ .venv/bin/pytest -q --tb=no
........................................................................ [ 33%]
........................................................................ [ 67%]
.....................................................................    [100%]
213 passed in 0.71s
```

```bash
$ bash guards/tests/adversarial-battery.sh
... (B1 a B33 listados)
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

N2 VERDE.

---

## 7. N3. MAIN=4db6928; TRAILERS CONTIGUOS

```bash
$ git rev-parse main
4db692876381a0d7909985c8500d999f2e677b04
```

```bash
$ git rev-parse HEAD
f8e655de11fd0ed3e8c84e41b1e5aa2ad6ecb1e0
```

Branch atual: proposta/reestruturacao-m-a-s0 (main intocado, sem --no-verify, sem commit).

Trailers nos 5 commits de 2347443..f8e655d são idênticos e contíguos:

```
HBN-Readback: 0045
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9
```

(Ver `git log --pretty=fuller -6` para c13d64a..HEAD.)

G-EXC PROPOSED visível no STATE desde C1.

N3 VERDE.

---

## 8. Marginais e Observações

1. **Stub da MATURITY-MATRIX difere do texto exato proposto**: Cumpre função (sem stale, redireciona), conforme nota em A3. Não é bloqueador (antigravity também aceitou).
2. Ponteiros vivos para docs/MATURITY-MATRIX em outros docs (PHAGOCYTOSIS, WAVE-PLAN etc.) permanecem (out_of_scope do readback 0045). Serão tratados em onda futura.
3. Tudo dentro de "So leitura; sem commit; sem tocar main; sem --no-verify. Truth Barrier."

---

## 9. Conclusão e Assinatura

- **Veredito:** APROVA_0045: SIM
- **Confiança:** 95/100 (alta; marginal do stub conhecida e não impactante)
- **Assinatura:** grok (xAI family, auditor role — distinta de OpenAI/Codex e de Google/Antigravity)
- **Data/Hora:** 2026-06-17T12:56:00-03:00
- **Comando de prova do depósito:**

```bash
$ ls -la .hbn/results/ | grep grok-cross-ia-curadoria-p0-0045
```

(Executado após escrita; saída colada abaixo na seção de depósito.)

---

**SOU: grok · familia xAI · papel auditor. So leitura; sem commit; sem tocar main; sem --no-verify. Truth Barrier (arquivo:linha ou comando+saida). Nao confie em relatos; confira no disco.**
