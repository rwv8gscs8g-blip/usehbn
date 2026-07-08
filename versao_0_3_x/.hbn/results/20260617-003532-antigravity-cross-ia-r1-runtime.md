---
titulo: "Parecer R1 — Cross-IA da Onda R1 (Runtime e Honestidade)"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260617-003532-antigravity-cross-ia-r1-runtime.md
id-global: 20260617-003532-antigravity-cross-ia-r1-runtime
autoria: antigravity
familia: Google
created_at: "2026-06-17T00:35:32-03:00"
---

SOU: antigravity · familia Google · papel auditor

# Parecer de Auditoria Cruzada da Onda R1 — Runtime e Honestidade (Readback 0038)

## Veredito Geral
APROVA_0038: NAO (bloqueador em [store.py:104-105](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/state/store.py#L104-L105))

### Bloqueadores
- **[Bloqueador] Duplicação e Inchaço Exponencial de Estado** em [store.py:104-105](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/state/store.py#L104-L105):
  Na unificação do diretório de estado (`.hbn`), a função `load_state_document` carrega os arquivos do diretório canônico e dos legados (`.usehbn` e `state/`). Ela executa uma concatenação direta sem deduplicação para as chaves `decisions` e `context_history`:
  ```python
  "decisions": [item for document in documents for item in document["decisions"]],
  "context_history": [item for document in documents for item in document["context_history"]],
  ```
  Se o arquivo legado continuar no disco (o que é o caso da migração tolerante read-only), toda vez que um novo registro de execução ou resultado for gravado, a função lê o arquivo canônico (que já contém a história migrada na gravação anterior) e o concatena de novo com o arquivo legado. Na gravação seguinte, essa lista duplicada é persistida de volta no arquivo canônico. Isso gera um loop de feedback com duplicação acumulada e crescimento quadrático/exponencial do arquivo `hbn-state.json`. A suíte de testes existente falhou em detectar este bug porque a fixture de teste em [test_state_dual_read.py:110](file:///Users/macbookpro/Projetos/usehbn/tests/test_state_dual_read.py#L110) mocka os documentos com listas `decisions` e `context_history` vazias (`[]`), onde a concatenação resulta em listas vazias sem efeitos colaterais visíveis.

---

## Sumário da Auditoria

### A1. Golden Tests dos 17 Subcomandos
- **Status**: Verde.
- **Localização**: Os testes estão implementados em [test_cli_golden_contract.py:365-780](file:///Users/macbookpro/Projetos/usehbn/tests/test_cli_golden_contract.py#L365-L780).
- **Evidência**: A lista `CLI_JSON_CASES` cobre as 18 variações de chamada dos subcomandos (run, translate, connector inspect/ensure, init, version, inspect, doctor, quickstart, install, attention, notify, readback, hearback, result, refresh, relay status, handoff) e valida de forma determinística que a saída JSON e o contrato externo da CLI permanecem inalterados.

### A2. Exit Codes Honestos
- **Status**: Verde.
- **Evidência**:
  - Subcomandos desconhecidos ou erros sintáticos de argumentos retornam `exit 2` via `argparse`.
  - Subcomandos aninhados sem comandos válidos retornam `exit 2` e a payload contendo `"error"`.
  - Violações de protocolo (como tentar gerar um ERP resultado para um readback pendente de hearback) lançam `HbnProtocolViolation` ([result.py:88](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/protocol/result.py#L88)) que é capturada e resulta em `exit 3` ([cli.py:1820](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py#L1820)).
  - Sucesso de execução retorna `exit 0` (ex: `hbn version`).
  Provado mecanicamente via execução no terminal:
  ```bash
  $ PYTHONPATH=src .venv/bin/python -m usehbn.cli connector; echo "EXIT_CODE=$?"
  {
    "error": "Unknown connector subcommand. Use: hbn connector inspect|ensure"
  }
  EXIT_CODE=2
  ```
  ```bash
  $ PYTHONPATH=src .venv/bin/python -m usehbn.cli version; echo "EXIT_CODE=$?"
  {
    "project": "HBN — Human Brain Net",
    "package_version": "0.3.0",
    "protocol_version": "0.3.0",
    "cli": "hbn"
  }
  EXIT_CODE=0
  ```

### A3. Estado Unificado e Duplo-Write
- **Status**: Parcialmente verde (leitura correta com dedup de execuções/resultados, mas com o bug crítico de bloqueio descrito acima para as outras chaves).
- **Ausência de duplo-write na origem**: Provado. Apenas o caminho canônico `.hbn/state/hbn-state.json` é escrito via `append_execution_state` ([store.py:136-137](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/state/store.py#L136-L137)) e `append_result_state` ([store.py:152-153](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/state/store.py#L152-L153)). Os caminhos legados são mantidos estritamente read-only.

### A4. Honestidade e Contagem de Testes
- **Status**: Verde.
- **pytest independente**: Execução física resultou em **211/211 testes passados** (Suíte Verde).
- **Alinhamento Documental**:
  - [AGENTS.md:57](file:///Users/macbookpro/Projetos/usehbn/AGENTS.md#L57): `- **Tests:** pytest (tests/, currently 211/211 passing).`
  - [README.md:5](file:///Users/macbookpro/Projetos/usehbn/README.md#L5): `License: Apache 2.0 + DCO. Tests: 211/211.`
  - [README.md:7](file:///Users/macbookpro/Projetos/usehbn/README.md#L7): `Tests-211%2F211-brightgreen`
  - [MATURITY-MATRIX.md:79](file:///Users/macbookpro/Projetos/usehbn/methodology/MATURITY-MATRIX.md#L79): `Suite verde 211/211`
  Todos os arquivos trazem coerentemente o número `211`.
- **Autoevolve**: Declarado corretamente como `Scaffold` / `Parcial` na matriz de maturidade em [MATURITY-MATRIX.md:73-75](file:///Users/macbookpro/Projetos/usehbn/methodology/MATURITY-MATRIX.md#L73-L75).
- **Ponteiro AGENTS.md:17**: Aponta corretamente para `methodology/MATURITY-MATRIX.md`.
- **Resolução de L4**: Resolvido em [README.md:559](file:///Users/macbookpro/Projetos/usehbn/README.md#L559), removendo a afirmação infundada de "solid L4" e descrevendo honestamente os estados de cada componente de v0.3.0.

### A5. Sem Regressão
- **Status**: Verde.
- **Baterias**:
  - `bash guards/tests/run-guard-tests.sh` passou com **178/178 checks**.
  - `bash guards/tests/adversarial-battery.sh` passou com **BATERIA VERDE (34/34 burlas bloqueadas)**, incluindo a nova burla B33 (brainstorm sem curadoria).
- **Arquivos modificados**: `git diff --name-only da75a2b..0692d15` confirma que apenas os arquivos listados na allowlist do readback 0038 foram tocados. Nenhum core/guard/schema foi modificado.
- **Tip da main**: `4db6928` (tip verificado).

### A6. Trailers dos Commits
- **Status**: Falha menor de formatação/policiamento.
- **Evidência**:
  O commit `0692d15` possui trailers contíguos ideais. No entanto, os outros 5 commits (`0cc616f`, `5620972`, `686cbbd`, `6505b6b`, `9241524`) possuem linhas em branco separando os trailers:
  ```text
  HBN-Readback: 0038
  
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  
  HBN-Token-FP: 34a7f2f9
  ```
  Isso tecnicamente quebra a contiguidade convencional do bloco de trailers. O guard `assert-exception-traceable.sh` não bloqueou esses commits porque `atribuicao.implementador` no `STATE.md` permaneceu configurado como `null` durante a onda executada por Codex, o que fez o guard G-EXC sair prematuramente sem validar os trailers.

### A7. Leveza e Via Mais Simples (P-CAND-01)
A unificação de estado sob `.hbn/` é conceitualmente a via mais simples e racional, limpando a confusão de múltiplos diretórios ocultos no root (`.usehbn/` e `.hbn/`). No entanto, o design falhou na robustez técnica ao esquecer de deduplicar as chaves `decisions` e `context_history` (risco grave de inchaço do JSON do STATE).

---

## Evidência Mecânica (Truth Barrier)

### 1. pytest real
```text
$ .venv/bin/pytest
============================= 211 passed in 0.75s ==============================
```

### 2. Execução dos Guards e Bateria Adversarial
```text
$ bash guards/tests/run-guard-tests.sh && bash guards/tests/adversarial-battery.sh
...
== resumo: 178 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
...
B33 docs/brainstorm sem curadoria                    | G-ZONA   | BLOQUEADA ✓
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

### 3. Exemplo de Histórico de Commits e Trailers não-contíguos
```text
$ git log da75a2b..0692d15
commit 0cc616ffe84b076ca03ac0bad2b070f996197f2b
Author: claude-fable-5 (Cowork) <mauriciozanin@gmail.com>
Date:   Wed Jun 17 00:19:44 2026 -0300

    r1: honestidade (docs alinhados + autoevolve declarado)
    
    HBN-Readback: 0038
    
    HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
    
    HBN-Token-FP: 34a7f2f9
```

---

## Truth Barrier e Limitações
- **Nível de Confiança**: 100/100.
- **Identificação**: antigravity · família Google · 2026-06-17
