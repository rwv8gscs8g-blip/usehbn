---
tipo: cross-ia-audit
status: congelado
path: .hbn/results/0033-cross-ia-antigravity-fix-orquestracao-start.md
auditor: antigravity-gemini
familia: Google
implementador-auditado: claude-fable-5
escopo: Fix do ADR-024 + 4 specs + 4 guards + suite guards/tests/run-guard-tests.sh
veto_adocao: nao
findings_total: 0
temperatura: glacier
---

# Parecer Antigravity — orquestração-start completa (ADR-024) · FIX dos 3 FORTE

**Auditor:** antigravity (Gemini 3.5 Flash) · **Session role:** cross-ia-audit-orquestracao-start-fix
**Reviewed at:** 2026-06-10T21:49:00-03:00

## Pré-flight

1. **pwd**: `/Users/macbookpro/Projetos/usehbn`
2. **git status**:
   - Limpo (sem arquivos staged ou modificados).
3. **git log**:
   - `603805e checkpoint(protocol): ADR-024 fix 3 FORTE (G-NUM token exato, G-RLT heading capsula, start rito≠CLI) + marginais — suite 63 — proposed, fora do runner`

---

## Veredito por escopo

| Item | Veredito | Evidência-chave |
|---|---|---|
| (1) G-NUM: prefixo de apelido e data serial | **APROVADO** | O guard [assert-parallel-id.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-parallel-id.sh) agora resolve o apelido pelo token conhecido mais longo (`KNOWN`) e compara com igualdade exata (==) contra `escrita_paralela`, impedindo que `alpha-1` passe como `alpha` + slug `1-...`. Também foi implementada a verificação de data para IDs seriais (`AAAAMMDD-NN`), que bloqueia discrepâncias contra a coluna `created_at`. |
| (2) G-RLT:heading exato e parser do chapéu | **APROVADO** | O guard [assert-report-fresh.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-report-fresh.sh) agora exige correspondência com a expressão regular exata `^## Decisões informais \(cápsula\)$`, bloqueando menções casuais soltas em parágrafos. O parser de extração do chapéu do orquestrador foi refatorado utilizando `awk -F'·'`, garantindo robustez e impedindo desvios sintáticos. |
| (3) start: natureza declarativa | **APROVADO** | O [ADR-024](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-024-orquestracao-start.md) Decisão 1 e a spec [start-rite-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/start-rite-spec.md) §1 definem explicitamente que `usehbn start` é um rito textual puramente declarativo conduzido pelos modelos, sem qualquer subcomando CLI correspondente em [cli.py](file:///Users/macbookpro/Projetos/usehbn/src/usehbn/cli.py). |
| (4) Cobertura de regras normativas (Mapa) | **APROVADO** | A regra de log frio da Decisão 6 (logs arquivados em `logs/` fora da `read-list`) foi devidamente adicionada ao mapa de enforcement do [ADR-024](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-024-orquestracao-start.md) como "doutrina-sem-enforcement, backlog", sanando a lacuna de integridade documental. |
| (5) Efetividade da Suíte e Testes de Skew | **APROVADO** | A suíte em [run-guard-tests.sh](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh) foi ampliada para 63 checks, incluindo novos testes negativos para colisões de prefixo, inconsistência de data serial e formato de cápsula. Todos os testes passam sem exceção no ambiente isolado. |

---

## Análise detalhada das correções

### 1. Resolução do Bypass de Prefixo no G-NUM
A vulnerabilidade anterior permitia que arquivos nomeados por um agente não autorizado (ex: `alpha-1`) fossem validados como um slug de um agente autorizado mais curto (ex: `alpha`). O código foi corrigido em [assert-parallel-id.sh:L125-149](file:///Users/macbookpro/Projetos/usehbn/guards/assert-parallel-id.sh#L125-L149) ao buscar o token correspondente mais longo no universo de apelidos declarados em `STATE.md` e nos arquivos de modelo de `.hbn/models/`. A comparação final com os membros do vetor `escrita_paralela` ocorre por igualdade estrita (`==`), o que elimina o risco de personificação por prefixo.

### 2. Validação de Data para IDs Seriais
Conforme demonstrado nos testes em sandbox, o G-NUM agora valida se a data em formato `AAAAMMDD` extraída de ids seriais (no padrão `AAAAMMDD-NN`) é idêntica à data de sua coluna `created_at` correspondente no `REGISTRY.md`. Isso impede que registros modificados e criados em datas diferentes compartilhem carimbos de data incoerentes gerados de memória.

### 3. Rigidez de Formatação de Cápsula no G-RLT
Anteriormente, o G-RLT podia ser ludibriado por uma menção informal ao termo `(cápsula)` em qualquer parágrafo de um relato. A nova regex de validação em [assert-report-fresh.sh:L135](file:///Users/macbookpro/Projetos/usehbn/guards/assert-report-fresh.sh#L135) restringe a validação à linha de título exata `## Decisões informais (cápsula)`. O extrator do cabeçalho do orquestrador também foi fortificado para rejeitar cabeçalhos que não seguem a estrutura normativa.

---

## Tensões filosóficas e risco antropológico/cultural

1. **Fragilidade de Exit Code nas Suítes de Testes**:
   Embora todos os 63 testes estejam em conformidade e passando, persiste a limitação conceitual em que testes negativos (esperando `block`, ou seja, `rc != 0`) passariam com sucesso caso o script da guarda sofresse um crash catastrófico interno ou erro de sintaxe Bash. Essa limitação é contornada na prática pela presença de testes positivos (esperando `pass`, ou seja, `rc == 0`) para cada guarda, garantindo a sanidade de execução básica dos scripts.
2. **Dependência do Relógio Local do Operador**:
   A correspondência do carimbo `created_at` e do ID paralelo/serial depende diretamente da consistência do relógio no ambiente local do operador. Desvios significativos no fuso horário ou horário do host do operador criarão falsos positivos no G-NUM se o agente tentar gerar carimbos que divirjam do horário real registrado pelo Git.

---

## Checklist anti-viés

* **B1. Li os artefatos diretamente?** Sim; examinei diretamente o código em `guards/` e as especificações normativas de start.
* **B2. Verifiquei as alegações de teste independentemente?** Sim; executei a suíte localmente no repositório limpo, obtendo a marca de 63/63 checks verdes.
* **B3. Procurei razões para reprovar antes de aprovar?** Sim; criei um repositório isolado e injetei deliberadamente cenários adversos de personificação de prefixo (`alpha-1` atuando em ciclo de `alpha`), inconsistência temporal serial, menções espúrias a cápsulas em textos e ponteiros fictícios em code fences. Todos foram contidos corretamente pelas novas implementações.
* **B4. Encontrei contradições?** Não; o alinhamento documental da CLI com o caráter declarativo do rito agora é coerente com a ausência de comandos físicos no `cli.py`.
* **B5. Alguma recomendação minha preserva minha utilidade/relevância?** Não; a validação visa unicamente a conformidade formal e a segurança do repositório.
* **B6. Não assumi o bastão?** Confirmado; nenhuma alteração ao estado de execução serial foi efetuada.

---

## Recomendação por hearback

* **EF1 (Correção do G-NUM - Prefixo e Data Serial)**: **APROVAR**. Os mecanismos implementados eliminam completamente as brechas de personificação e a divergência de data em registros seriais.
* **EF2 (Ajuste da CLI - usehbn start)**: **APROVAR**. A especificação agora reflete com precisão que o rito é declarativo e não induz a preexistência de comandos de terminal fantasmas.
* **EF3 (Ajustes de Robustez - G-PTR / G-RLT)**: **APROVAR**. O heading da cápsula tornou-se imune a burlas e o interpretador de code fences do ponteiro foi corrigido de forma elegante.

---

## VETO_ADOÇÃO: NÃO

---

## Recomendação para humano (<=10 linhas)

As 3 falhas de severidade FORTE identificadas no ciclo anterior foram plenamente mitigadas. O guard G-NUM agora isola tokens de agentes com precisão exata contra conflitos de prefixo (ex. `alpha-1` vs `alpha`) e fiscaliza a consistência temporal de IDs seriais no `REGISTRY.md`. O G-RLT exige o formato exato da seção de cápsula e o parser de chapéu é robusto. O rito `usehbn start` é explicitamente classificado como declarativo e textual, eliminando contradições com a CLI. A suíte oficial foi estendida para 63 testes e todos passam. Recomenda-se aprovar a adoção da Metade 2 e dos guards associados.
