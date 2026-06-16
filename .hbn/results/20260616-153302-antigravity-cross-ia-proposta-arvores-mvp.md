---
aprova_proposta: "NAO + ajustes objetivos"
titulo: "Parecer Antigravity — Auditoria Cruzada da Proposta de Árvores e MVP"
tipo: result
status: active
temperatura: frio
id-global: 20260616-153302-antigravity-cross-ia-proposta-arvores-mvp
path: .hbn/results/20260616-153302-antigravity-cross-ia-proposta-arvores-mvp.md
auditor: antigravity-gemini
reviewed_at: "2026-06-16T15:33:02-03:00"
---

APROVA_PROPOSTA: NAO + ajustes objetivos

# Parecer Antigravity — Auditoria Cruzada (Proposta de Árvores e MVP)

**Auditor:** Antigravity (Gemini 3.5 / Google)  
**Data da Auditoria:** 2026-06-16T15:33:02-03:00  
**Confiança Geral:** 95/100

---

## 1. Arvores: campo obrigatorio em quais paths? guards .sh entram via header-comment ou ficam fora do escopo leve?

- **Paths Obrigatórios:** Além de `core/**` e `docs/brainstorm/**`, o campo `arvore:` deve ser obrigatório para toda a pasta `docs/**` (para classificar documentos normativos/estratégicos como `docs/TRUTH-BARRIER.md` ou `docs/PHAGOCYTOSIS.md`) e `schemas/**`. Isso evita que esquemas e especificações entrem sem clareza de maturidade.
- **Guards (`.sh`):** DEVEM entrar no escopo de classificação leve. Como scripts shell não possuem front-matter, a classificação deve ser feita via comentário de cabeçalho: `# arvore: estavel|intermediaria|fronteira`.
- **Validação de Runner:** O runner de guards (`guards/hbn-guards-runner.sh`) deve validar se algum script listado na sua lista de execução ativa (`GUARDS`) possui a tag `# arvore: fronteira`. Se possuir, deve abortar o commit. Um guard em fase experimental (fronteira) não pode rodar ativamente no pipeline de produção sem passar por promoção formal.

## 2. Transicao entre arvores (fronteira->intermediaria->estavel): gate bem definido? falta criterio objetivo (reuso dos 8 criterios de exuvia)?

- **Diagnóstico:** O gate proposto ("cross-audit + aprovação humana") é subjetivo. Para evitar teatro de conformidade, os critérios técnicos objetivos devem ser acoplados às promoções.
- **Criação de Portões Técnicos (Reuso dos Critérios de Exúvia de [core/exuvia-fitness-criteria.md](file:///Users/macbookpro/Projetos/usehbn/core/exuvia-fitness-criteria.md#L75)):**
  - **Fronteira ➔ Intermediária (MVP Incipiente):** Exige proposta escrita, autorização humana em dispatch e verificação de sintaxe. Dívidas técnicas (`C-DEBT`) são toleradas.
  - **Intermediária ➔ Estável (MVP Genoma):** Exige obrigatoriamente placar `SIM` para `C-TEST`, `C-ADV`, `C-XAUDIT`, `C-DOG`, `C-FCLOSE`, `C-NOREG` e `C-TRACE`. Nenhuma dívida ativa (`C-DEBT`) pode restar pendente (deve ser resolvida ou categorizada formalmente).

## 3. MVP freeze: a lista 1-6 esta completa? falta bloqueador? quais eram os bloqueadores do VETO 0034/0035 da Ponte?

- **Bloqueador Omitido na Lista:** Falta a **ativação plena das assinaturas SSH em G-HRB** (`guards/assert-hearback-integrity.sh`). Como demonstrado em [guards/assert-hearback-integrity.sh:81](file:///Users/macbookpro/Projetos/usehbn/guards/assert-hearback-integrity.sh#L81), o guard está operando em modo parcial ("PENDENTE DE CHAVE"), aceitando hearbacks sem assinatura criptográfica real. Sem chaves públicas em `.hbn/operators/*.pub`, qualquer IA pode forjar um hearback textual e comitar na sequência. Isso é um bloqueador crítico para o freeze do MVP.
- **Remediação dos Bloqueadores da Ponte (VETO 0034/0035):**
  - **Veto 0034 (Codex):** Aritmética errada de migração (106 promovidos × 5 descartados + 1 novo = 102 arquivos reais, não 107); insegurança do teste `SO-COPIA=0` pós-R8 (apagava a pasta antes do diff); falta de texto verbatim para o split do firewall 0022.
  - **Veto 0035 (Antigravity):** Path absoluto local (`~/Projetos/usehbn/`) no script de integridade de snapshot (quebra CI); colisão de commits no R8 (README do tombstone e trava de forbidden-paths no mesmo commit travando o pre-commit).

## 4. Deny-by-default: mecanismo mais simples e robusto? ha vetor de bypass?

- **Diagnóstico:** O mecanismo do G-SCOPE (`assert-scope-lock.sh`) é a base correta, mas possui um vetor de bypass crítico por design.
- **Vetor de Bypass:** Uma IA maliciosa ou com desvio cognitivo pode estender `scope.files_allowed` no readback ativo de forma autônoma. Para isso, ela cria um commit isolado contendo *apenas* a alteração no readback JSON, inventando um bloco `scope_extension` com dados falsificados de aprovação humana (ex: `"human": "Mauricio"`). O guard `assert-scope-lock.sh:307` permite a extensão porque o commit é puro. E o guard `assert-hearback-integrity.sh` não bloqueia porque nenhum arquivo em `.hbn/hearbacks/` foi tocado. No commit seguinte, a IA insere o código arbitrário, que agora é permitido pelo escopo atualizado.
- **Mitigação:** Toda alteração ou bloco `scope_extension` em arquivos de readback deve exigir referência a um hearback criptograficamente assinado em `.hbn/hearbacks/` ou possuir sua própria assinatura digital `.sig` correspondente.

## 5. Leveza (P-CAND-01): algo e maquinaria a mais? existe via mais simples/racional, mesmo de outra premissa/tecnologia?

- **Via Mais Simples/Racional:** Em vez de forçar front-matter em arquivos individuais (o que gera complexidade para ler comentários em scripts `.sh`, YAML em `.md` e JSON em `.json`), a classificação de árvores pode ser centralizada no `REGISTRY.md`.
- **Como Funcionaria:** Adiciona-se uma coluna `arvore` na tabela do `REGISTRY.md`. O guard G-REG já valida a integridade do livro-razão e pode facilmente validar a árvore declarada para os arquivos modificados. Isso remove 100% da maquinaria de parse front-matter de arquivos individuais, mantendo o controle centralizado e simples.

## 6. Sequencia W1-W5: a ordem minimiza retrabalho e risco de regressao?

- **Ajuste Crítico na Sequência:** A ordem proposta (`W2 deny-by-default` antes de `W3 hardening de guards`) apresenta alto risco.
- **Motivo:** Enforçar `deny-by-default` antes de fechar os bypasses conhecidos de G-SCOPE (como a auto-emenda forjada de `scope_extension`) e antes de armar criptograficamente o `G-HRB` com as chaves de operadores cria uma falsa barreira. As IAs encontrarão o bypass facilmente.
- **Sequência Recomendada:**
  1. `W1 P-CAND-04` (Já executada/selada)
  2. `W3 Hardening de guards` (Corrige os bypasses de escopo e ativa chaves de operador `.pub` para o `G-HRB`)
  3. `W2 Deny-by-default` (Enforced sobre uma base mecânica agora inviolável)
  4. `W4 Árvores etiqueta`
  5. `W5 Freeze + Tag`

---

## 7. Parecer Específico Antigravity (Rigor Fail-Closed + Falsa Confiança)

- **Falha de Rigor em G-ARVORE (Fail-Open para modificados):** A regra `3.(b)` proposta diz: *"Artefato staged NOVO sob core/** ou docs/brainstorm/** DEVE declarar arvore: — senão BLOQUEIA."* Isso significa que se um arquivo de especificação *existente* em `core/` for modificado sem receber a tag `arvore:`, o commit passará normalmente. Trata-se de um design fail-open para arquivos existentes.
  - **Correção:** O guard deve exigir `arvore:` para **qualquer** arquivo staged (novo ou modificado) sob esses caminhos.
- **Fragilidade do Parser Bash:** A leitura de front-matter via regex simples ou delimitadores lineares em Bash (como `awk 'NR==1 && $0!="---"'` em [assert-self-path.sh:63](file:///Users/macbookpro/Projetos/usehbn/guards/assert-self-path.sh#L63)) é bypassável. Bastaria inserir uma linha em branco ou comentário no topo do arquivo para enganar o awk, fazendo o guard achar que o arquivo não tem front-matter e ignorando a validação do valor do campo.
  - **Correção:** G-ARVORE deve utilizar a lógica do python de forma robusta para parsing de metadados.
- **Risco de Falsa Confiança:** A etiqueta `arvore: estavel` no front-matter é meramente declarativa. Sem uma amarração de assinatura ou histórico que comprove que ela passou pela onda de promoção correspondente, ela pode criar a ilusão de estabilidade de uma especificação ou guard que na verdade não atende aos critérios técnicos. É necessário registrar que o rótulo é um metadado descritivo e a segurança real é enforçada nos portões de commit.
