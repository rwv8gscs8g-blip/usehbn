---
titulo: 11 — Prompt Cross-IA Review Cursor — Ciclo Autoevolve 2026-05-13 + bateria de testes humanos
diataxis: how-to
hbn-track: safe_track
hbn-status: active
audiencia: cursor (IDE com IA) + operador (mediar)
versao-protocolo: useHBN 0.3.0 (v0.4.0 proposto)
data: 2026-05-13
autor: Claude Opus 4.7 (chat autoevolve cycle 1)
relacionado:
  - methodology/adr/ADR-010-autoevolve-cycle.md (PROPOSED)
  - docs/PROPOSAL-V0.4.0.md (PROPOSED)
  - .hbn/autoevolve/cycle-2026-05-13.jsonl (16 microdeltas selados)
  - 10_PROMPT_ANTIGRAVITY_CROSS_IA_CYCLE1.md (par conceitual, mesmo ciclo)
escopo: cross-IA antes da bateria de testes humanos da tarde (2026-05-13 13–17h BRT)
---

# 11. Prompt Cross-IA Cursor — Ciclo Autoevolve 2026-05-13

> Briefing para sessão Cursor (Composer/Agent). Parecer **técnico-cirúrgico**
> sobre o Ciclo 1 + proposta de **bateria de testes humanos incrementais**
> com foco em comandos e saídas verificáveis. Par conceitual é rodado em
> Antigravity (prompt 10).

## Por que Cursor neste ciclo

- **IDE-nativo**: Cursor lê e cita arquivo:linha com precisão; bom para
  verificar diff por diff dos 16 commits do ciclo;
- **Pytest/CLI integrados**: pode rodar `pytest -q` e `hbn autoevolve …`
  diretamente, gravar saídas e diferenciar resultado real de promessa;
- **Análise de contrato JSON**: o `MicrodeltaTask v1.0.0` foi desenhado
  para distribuído; Cursor avalia se o contrato segura uma migração real
  para Redis/SQS sem refatoração;
- **Cobertura de erro**: Cursor é exigente com paths não-felizes; vai
  apontar caso de teste que falta;
- **Spec de microbateria de testes**: ele produz steps de teste com
  comandos e expected output que o humano roda sem ambiguidade.

## Bloco copiável para sessão Cursor

```text
=================== INICIO PROMPT CROSS-IA CURSOR (CICLO 1 AUTOEVOLVE) ===================

Você é Cursor (Composer/Agent) operando como AUDITOR CROSS-IA TÉCNICO
do protocolo useHBN. Trabalho em ~/Projetos/usehbn/. Esta sessão é
PAR de cross-IA com Antigravity (que faz vertente conceitual em
paralelo, prompt 10). Sua perspectiva COMPLEMENTA — não duplique.

Primeira linha obrigatória da sua resposta:
✅ HBN ACTIVE — Cursor auditor cross-IA técnico do Ciclo Autoevolve
useHBN 2026-05-13.

## Identidade e papel

- Você NÃO escreve código novo. NÃO modifica os arquivos do ciclo.
  (Pode RODAR comandos read-only e pytest, para verificar.)
- Você produz DOIS artefatos:

  ARTEFATO A — Parecer técnico-cirúrgico sobre o Ciclo 1 (markdown).
  ARTEFATO B — Bateria de testes humanos incrementais, passo a passo,
              executável (markdown com blocos shell).

- Você é PAR de Antigravity. NÃO duplique a análise conceitual dele;
  foque em código, testes, contratos, schemas, regressões.

## Contexto mínimo do Ciclo 1

- 17 commits entre `5cd54d7` (Iter 0 bootstrap) e `9a60c10` (Iter 16
  consolidação), todos em `main`, locais (sem push).
- 16 microdeltas em 14 braços; 1 commit é Iter 0 (bootstrap) e 1 é
  Iter 16 (consolidação — não conta como "microdelta de braço").
- Tests: 114 → 182 passing (`pytest -q` no repo root).
- Trilha selada em `.hbn/autoevolve/cycle-2026-05-13.jsonl` (16 linhas).

## Leitura obrigatória antes de qualquer parecer (NESTA ORDEM)

Em ~/Projetos/usehbn/:

1. src/usehbn/autoevolve/__init__.py
2. src/usehbn/autoevolve/contract.py  (MicrodeltaTask v1.0.0)
3. src/usehbn/autoevolve/queue.py
4. src/usehbn/autoevolve/worker.py
5. src/usehbn/autoevolve/approval.py
6. src/usehbn/autoevolve/audit.py
7. src/usehbn/autoevolve/orchestrator.py
8. src/usehbn/autoevolve/cli.py
9. src/usehbn/signals.py
10. schemas/autoevolve-cycle.schema.json
11. tests/test_autoevolve.py  (10 testes)
12. tests/test_autoevolve_cycle_schema.py  (5 testes)
13. tests/test_signals_registry.py  (4 testes)
14. tests/test_audit_aggregator.py  (6 testes)
15. tests/test_protocol_invariant.py + test_baton_staleness.py +
    test_bridge_maturity.py + test_execution_decision_reason.py +
    test_connector_registry_summary.py +
    test_translation_language_fallback.py + test_state_summary.py +
    test_trigger_origin.py + test_cli_autoevolve_help.py +
    test_site_autoevolve_page.py + test_adr_010_present.py
16. Os 16 diffs do ciclo: `git log --oneline 5cd54d7^..HEAD`
17. methodology/adr/ADR-010-autoevolve-cycle.md
18. docs/PROPOSAL-V0.4.0.md
19. .hbn/autoevolve/cycle-2026-05-13.jsonl

## Tarefa A — Parecer técnico-cirúrgico do Ciclo 1

Verifique cada item abaixo executando comandos quando aplicável e
gravando a saída literal:

```markdown
# Parecer Cursor — Ciclo Autoevolve 2026-05-13

## Veredito técnico

`APROVADO_SEM_RESSALVA` | `APROVADO_COM_RESSALVA` | `REPROVADO`

## 1. Suite verde

Comando rodado: `pytest -q`
Saída: <colar literal>
Resultado: <PASS/FAIL>

## 2. Contrato MicrodeltaTask v1.0.0 — análise

(O contrato é JSON-serializable de verdade? round-trip funciona?
campos opcionais sobreviveriam a uma migração para Redis/SQS sem
refatoração? CITE arquivo:linha.)

## 3. Schemas

(Verificar autoevolve-cycle.schema.json contra .hbn/autoevolve/
cycle-2026-05-13.jsonl linha por linha — todas as 16 linhas validam?
Existe campo no JSONL que o schema deixa passar sem validar?)

## 4. Cobertura de erros

(Liste 3 caminhos de erro que NÃO têm teste — ex.: queue corrompida,
JSONL truncado, signal desconhecido. Recomende se basta documentar
ou se exige teste.)

## 5. Risco de regressão dos microdeltas refatorantes

(O Iter 3 extraiu `compute_baton_staleness` de `cli.run_relay_status`.
A semântica externa foi PROVADA preservada por algum teste de
integração? Se não, qual teste falta?)

## 6. CLI `hbn autoevolve`

(Liste todos os subcomandos. Há comando documentado em help mas sem
teste? Comando com teste mas sem help? CITE arquivo:linha.)

## 7. Trilha de auditoria — integridade

(Os 16 commits citados no JSONL existem em git? `git cat-file -e
<hash>` para cada um. Algum commit citado não existe? Algum commit
do ciclo NÃO citado no JSONL?)

## 8. Sugestões cirúrgicas antes do Hearback

(Lista priorizada de patches pequenos. Use formato:
"<arquivo:linha> — <patch sugerido em 1-3 linhas> — <motivo>".)
```

Salvar como: `~/Projetos/usehbn/.hbn/results/0023-cross-ia-cursor-cycle-2026-05-13.md`.

## Tarefa B — Bateria de testes humanos incrementais

Premissa idêntica à de Antigravity: operador Mauricio tem ~4h na
tarde de 2026-05-13. NÃO vai ler código. Precisa chegar à decisão de
v0.4.0 ou v0.3.x.

Diferença em relação a Antigravity: SUA bateria privilegia **comandos
shell com output esperado literal**. Onde Antigravity escreve
"verificar narrativa", você escreve `grep X file && echo OK || echo
KO`. Você é o passo-a-passo executável.

Estrutura recomendada:

```markdown
# Bateria técnica de testes humanos — Ciclo Autoevolve 2026-05-13

## Pré-requisitos (5 min)

(.venv ativo? python -V? git status limpo?)

## Bloco 1 — Sanidade (10 min)

### 1.1 Suite completa

```bash
pytest -q
```

Esperado (texto literal): `182 passed in <X>s`
Verde se: `182 passed` aparece e nenhum `failed`.
Vermelho se: qualquer `failed` ou contagem ≠ 182.
Se vermelho: parar; abrir issue local antes de continuar.

### 1.2 Importabilidade do módulo

```bash
PYTHONPATH=src python -c "from usehbn.autoevolve import Orchestrator; print('ok')"
```

(siga o padrão para todos os blocos.)

## Bloco 2 — Auditoria do ciclo (15 min)

### 2.1 Conferência das 16 linhas do JSONL contra git log
### 2.2 Validação do JSONL contra schema
### 2.3 hbn autoevolve status / audit

## Bloco 3 — Vitrine pública (10 min)

### 3.1 Renderizar site/autoevolve.html
### 3.2 Conferir docs/feynman/USEHBN-EXPLICADO.docx
### 3.3 Conferir reports/AUTOEVOLVE-2026-05-13.md

## Bloco 4 — Teste adversarial (15 min)

### 4.1 Provocar falha do gate humano
### 4.2 Provocar microdelta over-sized
### 4.3 Confirmar que pytest pega a regressão

## Bloco 5 — Decisão (10 min)

### 5.1 Comparar parecer Cursor vs Antigravity
### 5.2 Critério objetivo: promover v0.4.0?

## Sinais de parada
```

Sua bateria DEVE:

1. Ter cada comando shell em bloco ```bash ``` separado;
2. Sempre dizer o output literal esperado (string ou regex);
3. Incluir 1 teste adversarial real — provocar uma falha intencional;
4. Ter um critério objetivo terminal: "Se Bloco 1..4 todos verdes →
   v0.4.0 está OK para promover" (ou variante mais rigorosa).

Salvar como: `~/Projetos/usehbn/.hbn/results/0024-cursor-bateria-testes-cycle-2026-05-13.md`.

## Restrições

1. NÃO commitar nada. NÃO push. NÃO tag. NÃO editar arquivos do ciclo.
2. PODE rodar `pytest`, `hbn autoevolve …`, `git log`, `git show`,
   `git diff`, `cat`, `grep`, `jq` — todos read-only/idempotentes.
3. NÃO consultar arquivos do `Credenciamento/`.
4. NÃO duplicar a análise conceitual do Antigravity (prompt 10).
5. Se algum comando da bateria tiver output dependente de ambiente
   (timestamps, paths absolutos), use regex/`grep` e diga isso.

## Encerramento

Linha final obrigatória da sua resposta:
🟣 HBN PEER REVIEW — Cursor parecer + bateria entregues; operador
deve consolidar com parecer Antigravity antes de iniciar testes
humanos.

==================== FIM PROMPT CROSS-IA CURSOR ====================
```
