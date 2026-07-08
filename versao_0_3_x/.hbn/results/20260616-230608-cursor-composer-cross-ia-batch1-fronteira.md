# Auditoria cruzada — BATCH-1-FRONTEIRA — por Cursor Composer (chat novo)

---
fornecedor: Cursor
modelo: Composer
apelido: cursor-composer
data: 2026-06-16T23:06:08-03:00
escopo: docs/brainstorm/rodada-2026-06-16/{A1,A2,A3,B1,B2} + PROPOSTA-arvores-agora.md
familia: Cursor (≠ Anthropic do autor Opus)
---

## 1 Veredito

**APROVAR com FORTES incorporados** — o batch de Fronteira é honesto, bem ancorado no disco e útil para despacho; **não** está pronto para promoção normativa sem remediar os bloqueadores abaixo (runtime pré-exúvia, teatro de ack, etiqueta declarativa sem guard).

## 2 BLOQUEADORES

| # | Descrição | Evidência | Remediação |
|---|---|---|---|
| B1 | `main()` retorna exit 0 mesmo em violação de protocolo — shell/CI não detecta falha | `src/usehbn/cli.py:1732,1759,1772` — ramos com `{"error": ...}` e `return 0` incondicional | Mapear erros para exit ≠0 antes do freeze (`B1:98-104`); golden tests |
| B2 | Três convenções de estado coexistem (`.hbn/`, `.usehbn/`, `state/`) | `cli.py:752-753` (`_hbn_dir`→`.hbn`); `config.py:12` (`STATE_DIRNAME=".usehbn"`); `runtime.py:377-379` (dual-read canônico+legacy) | Unificar fonte única pré-exúvia (`B1:313-317`, `C3` pré-condição) |
| B3 | `autoevolve` ausente da MATURITY-MATRIX + teatro de automação | `grep autoevolve methodology/MATURITY-MATRIX.md` → zero; `worker.py:4-6` (apply no-op); `approval.py:27` sobre `diff_added+diff_removed` sempre 0 (`contract.py:49-50`); `Orchestrator` só em `tests/test_autoevolve.py:103`, não em `src/` | Linha na matriz + renomear/marcar scaffold (`B2:145-153`) |
| B4 | G-FDACK (eco de leitura) ainda **não existe** no disco — proposta apenas | `glob assert-frontdoor*.sh` → só `assert-frontdoor.sh`; sem `assert-frontdoor-ack.sh` | Implementar em onda formal com dogfood; até lá, front-door continua meia-porta |
| B5 | Ack emprestado/copiado sem prova de posse | `A1-front-door-verificavel.md:239-244`; analogia `assert-baton-token.sh:22-24` ("NÃO prova posse exclusiva") | Decisão: acoplar `HBN-Token-FP` ao ack OU aceitar limite explícito no spec |
| B6 | `arvore:` declarativo sem guard — burla por auto-etiqueta `estavel`/`intermediaria` | `grep arvore: core/` → zero em specs core; só brainstorm (`A2:271-278`) | Guard fail-closed `estavel⇒quente` + evidência de portão antes do Credenciamento |
| B7 | Docs públicos divergem da matriz canônica | `AGENTS.md:57` (93/93) vs `methodology/MATURITY-MATRIX.md:76` e `README.md:5` (114/114); `AGENTS.md:17` aponta `docs/MATURITY-MATRIX.md` SUPERSEDED (`docs/MATURITY-MATRIX.md:3-11`); `README.md:559` usa "L4" fora dos 5 estados (`methodology/MATURITY-MATRIX.md:21-29`) | Correções P0/P1 de `B2:260-270`, `C4` |

## 3 FORTES

- **A1** reconhece honestamente que eco ≠ cognição (`A1:225-231`), alinhado a `assert-baton-token.sh:22-24` e `exuvia-fitness-criteria.md:52` (fail-closed).
- **A1** reusa padrões existentes (trailer×STATE, front-matter×readback) sem reinventar — custo de implementação baixo quando vier a onda.
- **A2** demonstra ortogonalidade real dos três eixos (tabela `A2:73-77`); `temperatura:`/`hbn-track:` já têm vocabulário fechado no disco (`ADR-011`, `core/exuvia-fitness-criteria.md:5`).
- **A2** portão G1 compõe máquinas provadas (8 critérios `exuvia-fitness-criteria.md:75-96`, fagocitose `PHAGOCYTOSIS.md:43`) — não inventa ritual paralelo.
- **A2** recomenda REGISTRY para guards bash sem YAML (`A2:293-297`) — mais robusto que parser de comentário (P11).
- **A3** linha de base verificada: 10/26 guards citam spec/ADR no cabeçalho (comando `for g in guards/*.sh; do head -25...`); embrião real em `dispatch-spec.md`→`dispatch.schema.json`.
- **A3** admite risco de `enforcement:` divergir da prosa (`A3:250-255`) — honestidade epistêmica correta.
- **B1/B2** audits factuais confirmados no código: TB/Guardian advisory (`truth_barrier.py:71-74`, `guardian.py:58-59`, `engine.py:88`), engine não bloqueia (`engine.py:161-187` persiste após warnings).
- **PF-ARVORES-AGORA** separa etiquetar agora de particionar na exúvia (`PROPOSTA:79-80`) — escopo modesto coerente com P10.

## 4 MARGINAIS

- A1 PARTE C com `v1` manual vs hash-de-conteúdo (`A1:66-72`) — começar com `v1` reduz ruído; migrar para fingerprint só após estabilizar porta.
- A2 append de promoção no REGISTRY vs só front-matter (`A2:108-113`) — preferir append para eventos raros.
- B1 decomposição em `cli/commands/*` (`B1:193-218`) — válida mas **depois** de exit codes + unificação de estado.
- B2 plano advisory→enforce com flag (`B2:178-184`) — correto para não quebrar v0.3.0; não é pré-freeze obrigatório se README mantém honestidade (`README.md:555`).

## 5 Convergências

- Eco de leitura é **teatro útil** (custo+rastro), não prova de compreensão — A1, baton-token e esta auditoria concordam.
- `arvore:`×`temperatura:`×`hbn-track:` são eixos distintos **se** invariantes forem guardados — A2 e PF-ARVORES-AGORA.
- Compilador = proveniência verificável (C1–C3) antes de geração (L1) — A3.
- Pré-exúvia exige: exit codes, diretório de estado único, matriz honesta — B1, B2, C3 (lidos no INDEX).
- Truth Barrier/Guardian Python são advisory; fail-closed real está nos guards bash — matriz e código alinhados.

## 6 Divergências (visão Cursor)

1. **Prioridade pré-freeze:** esta família coloca **B1 runtime (exit 0 + estado)** **antes** de G-FDACK e antes de etiquetar massivamente `arvore:`. Motivo: os bugs B1 são **ativos hoje** (`cli.py:1772`); G-FDACK ainda não existe. Congelar exúvia com exit sempre-zero petrifica contradição com P10 (`PRINCIPIOS-CONSTITUCIONAIS.md:228-232`).
2. **Compilador — ordem:** implementar **só trailers `HBN-Spec-Source`** (A3 C1) na 1ª onda; **adiar** bloco `enforcement:` (A3 C2) até `G-PROV` existir. Reduz janela de segunda fonte de verdade que A3 já nomeia (`A3:250-255`).
3. **G-FDACK + baton:** recomendo **acoplar** `HBN-Token-FP` no ack na promoção. Sem isso, ack emprestado permanece burla trivial (copiar `.hbn/frontdoor/*-ack.md` + trailer). Custo de bootstrap aceitável dado que baton já existe (`assert-baton-token.sh`).
4. **Portão G1.1 (entrada RADAR):** é o elo mais subjetivo (`PROPOSTA-arvores-agora.md:48-50`). Exigir schema mínimo de linha na CONVERGENCE-MATRIX com campos obrigatórios, não só "linha existe".
5. **Gradiente de prova:** PF-ARVORES-AGORA propõe etiquetar `cli.py` como `fronteira` (`A2:260-265`) — concordo; mas a MATURITY-MATRIX ainda diz CLI "Implementado" (`methodology/MATURITY-MATRIX.md:54`) sem coluna `arvore:`. Até haver coluna ou nota de rodapé, há **dupla semântica** (matriz × árvore).

## 7 Riscos não cobertos

- G-FDACK não morde chat sem commit (`A1:232-238`) — limite estrutural de guards git-native; mitigação conversacional insuficiente sem hook de IDE.
- `enforcement.clausulas[*].regra` em YAML pode divergir semanticamente da prosa — G-PROV verifica ponteiros, não semântica (`A3:253-255`).
- Portão G1.6 (C-XAUDIT) verificável por `.hbn/results/*` pode ser satisfeito com pareceres de baixa qualidade — falta critério de profundidade mínima no template `cadence-d.md:68-72`.
- Invariante "Estável governa" (`PROPOSTA:63-67`) sem enforcement no Credenciamento (ainda Visão, `methodology/MATURITY-MATRIX.md:79`) — risco de consumir regra de Fronteira por engano.
- Guards sem proveniência (`assert-scope-lock.sh:1-15` não nomeia `.md` de origem) permanecem órfãos até C1 — metade do runner.

## 8 Próxima ação

1. Onda correções rápidas pré-freeze: estado único + exit codes + alinhar AGENTS/README/matriz (`B1` Fase A, `B2` P0-P1).
2. Decisão humana: G-FDACK acoplado ao baton? (recomendação Cursor: sim).
3. Promover PF-ARVORES-AGORA como spec de Fronteira com guard anti-mislabel antes de Credenciamento.
4. Onda C1 trailers de proveniência nos guards órfãos; **não** bloco `enforcement:` completo ainda.
5. Implementar G-FDACK em onda separada após runtime honesto.

---

## Parte A — Auditoria adversarial por deliverable

### A1 (front-door / G-FDACK)

| Pergunta | Veredito | Evidência |
|---|---|---|
| Eco prova leitura ou é teatro? | **Teatro útil** — prova que alguém escreveu token+readlist, não compreensão | `A1:225-231`; `assert-baton-token.sh:22-24` |
| Burla ack emprestado/copiado? | **Sim, hoje na proposta** — sem vínculo baton | `A1:239-244` |
| Fail-closed STATE/readback ausente? | **Proposta correta**, padrão já existe em `assert-zona-livre.sh:56-59,101-104` | G-FDACK ainda não implementado (sem `assert-frontdoor-ack.sh`) |

### A2 (árvores / portão)

| Pergunta | Veredito | Evidência |
|---|---|---|
| `arvore:` segunda fonte vs `temperatura:`/`hbn-track:`? | **Não**, se ortogonalidade + anti-tabela paralela (`roles-assignment-spec.md:53-55`) forem guardados | `A2:68-84` |
| Burla no portão? | **Sim** — auto-etiqueta sem G1..G11; G1.1 mais fraco | `A2:271-278`; nenhum guard `arvore` no disco |
| REGISTRY para guards bash? | **Mais robusto** que comentário `# hbn-arvore:` | `A2:293-297` |

### A3 (compilador)

| Pergunta | Veredito | Evidência |
|---|---|---|
| `enforcement:` segunda fonte se divergir? | **Risco real** se promovido antes de G-PROV | `A3:250-255` |
| Verificação fiel suficiente? | **Insuficiente sozinha** — cobre ponteiros/cobertura, não semântica prosa↔guard | `A3:145-171`; 16/26 guards sem citação machine-consumível (comando disco) |

### B1 (code review)

| Afirmação | Veredito | Evidência |
|---|---|---|
| `main()` exit 0 em violação | **CONFIRMADO** | `cli.py:1772` |
| Três dirs de estado | **CONFIRMADO** | `cli.py:752-753`; `config.py:12`; `runtime.py:377-379`; remendo `cli.py:1564-1595` |
| Decomposição preserva contrato? | **Condicional** — só com golden tests (`B1:232-235`); proposta sólida, não executada | |

### B2 (honestidade)

| Afirmação | Veredito | Evidência |
|---|---|---|
| autoevolve teatro | **CONFIRMADO** | `worker.py:4-6`; `approval.py:27`; `contract.py:49-50` |
| Fora da MATURITY-MATRIX | **CONFIRMADO** | zero matches `autoevolve` em `methodology/MATURITY-MATRIX.md` |
| README/AGENTS excede matriz? | **Parcial** — 93/93, L4, ponteiro superseded; não as 3 frases proibidas | `AGENTS.md:57,17`; `README.md:559`; `MATURITY-MATRIX.md:99-102` |

### TRANSVERSAL (P1–P13 / MATURITY-MATRIX)

- **P10** (`PRINCIPIOS-CONSTITUCIONAIS.md:228-232`): tensão entre doutrina fail-closed e runtime Python advisory — documentada, não resolvida (`engine.py:88`).
- **P11**: G-PROV + micro-guard `arvore` em bash — avaliar custo antes de cadeia nova (`A2:293-297`).
- **P5**: portões G1.11/G2.6 exigem hearback — coerente.
- Nenhum deliverable viola P1/P6/P7 diretamente; todos respeitam isolamento da rodada (`INDEX.md:9-16`).

---

APROVA_A1: SIM · Conf 72/100
APROVA_A2: SIM · Conf 78/100
APROVA_A3: SIM · Conf 75/100
APROVA_B1: SIM · Conf 92/100
APROVA_B2: SIM · Conf 90/100
APROVA_PF-ARVORES-AGORA: SIM · Conf 70/100

— cursor-composer · 2026-06-16T23:06:08-03:00
