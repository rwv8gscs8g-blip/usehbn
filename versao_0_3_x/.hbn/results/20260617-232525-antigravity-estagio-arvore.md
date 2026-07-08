SOU: Google · Gemini 3.5 Flash · apelido: antigravity · papel auditor

# PARECER DE DESIGN DE PROTOCOLO: EVOLUÇÃO DE ESTÁGIOS DE ÁRVORE (useHBN)

- **Autor**: antigravity (Família Google)
- **Papel**: Auditor Independente / Designer de Protocolo
- **Data/Hora**: 2026-06-17T23:25:25-03:00
- **Contexto**: Eixo de Evolução de Estágios de Árvore (Fronteira → Intermediária → Estável)
- **Documentos Lidos no Disco**:
  - [NUMERACAO-decisao-consolidada.md](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-17/NUMERACAO-decisao-consolidada.md#L67-L109) (Seção 6 — O eixo de árvore)
  - [arvores-spec.md](file:///Users/macbookpro/Projetos/usehbn/core/arvores-spec.md) (R2 especificação de árvores)
  - [assert-arvore-label.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-arvore-label.sh) (Guarda G-ARVORE-LABEL)
  - [exuvia-fitness-criteria.md](file:///Users/macbookpro/Projetos/usehbn/core/exuvia-fitness-criteria.md) (Critérios objetivos de exúvia)
  - [A2-arvores-portao-promocao.md](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md) (Reconciliação e portões de promoção)

---

## 1. TRANSPARÊNCIA E EVITAÇÃO DE TEATRO: REGISTRY APPEND-ONLY VS. ESTÁGIO CORRENTE RESOLVÍVEL

**Análise do Dilema:**
A especificação `core/arvores-spec.md:29` estabelece o `REGISTRY` como a **fonte única** para a definição de árvore de cada artefato. As promoções de árvore ocorrem estritamente como eventos *append-only* (`tipo=arvore-promocao` [core/arvores-spec.md:44-46](file:///Users/macbookpro/Projetos/usehbn/core/arvores-spec.md#L44-L46)), proibindo a edição *in-place* do registro de nascimento. O guard G-ARVORE-LABEL implementado em `guards/assert-arvore-label.sh:130-140` bloqueia qualquer tentativa de rotular um artefato como `intermediaria` ou `estavel` sem que haja um evento de promoção correlacionado e um readback válido.

A transparência contra o "teatro de maturidade" é totalmente garantida pelo modelo *append-only* porque os guards do lado do cliente validam o histórico de transições no commit. No entanto, depender **exclusivamente** da varredura linear do `REGISTRY.md` a cada validação apresenta desafios práticos:

1. **Custo de Resolução (Query Cost):** Determinar o estágio vigente de 100+ artefatos exige que os scripts analisem o `REGISTRY.md` de ponta a ponta para identificar o estado mais recente.
2. **Teatro de Omissão:** Se o estágio de um arquivo é promovido no `REGISTRY.md`, mas o arquivo em si é alterado posteriormente sem um novo ciclo de testes, o sistema pode incorrer em falsa confiança (o arquivo é tratado como `estavel` embora seus novos bytes nunca tenham sido auditados).

**Parecer de Design:**
*   **Identidade Imutável:** O estágio de árvore **não** deve constar no ID do artefato para evitar a quebra de referências ([NUMERACAO-decisao-consolidada.md:77-82](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-17/NUMERACAO-decisao-consolidada.md#L77-L82)).
*   **Sem Metadados Redundantes nos Arquivos:** Não deve haver um cabeçalho mutável `arvore:` dentro dos próprios arquivos ([core/arvores-spec.md:39](file:///Users/macbookpro/Projetos/usehbn/core/arvores-spec.md#L39)), evitando inconsistências (duplo dono da verdade).
*   **Recomendação de Índice Resolvível:** Os guards locais e o runner de CI devem trabalhar sobre um **cache de estado compilado** (ex. um sumário JSON ou no próprio `.hbn/relay/STATE.md`). Esse índice aponta o estágio corrente de cada arquivo. No entanto, este índice é um subproduto de leitura derivado do `REGISTRY.md`. Qualquer alteração manual no índice sem o respectivo evento no `REGISTRY.md` é interceptada e bloqueada pelos guards, eliminando o risco de teatro.

---

## 2. RECONSTRUÇÃO DA TRAJETÓRIA COMPLETA DE UM ARTEFATO

**Mecanismo de Resolução Barata e Não-Amígua:**
Pelas regras fundamentais do livro-razão (`REGISTRY.md:7`), operações de `rename` e `delete` de artefatos são terminantemente proibidas. Isso significa que o caminho físico do arquivo (path) funciona como uma **chave primária imutável**.

Para reconstruir a trajetória de um artefato (ex.: `nasceu fronteira -> promovido intermediária -> despromovido` conforme [A2-arvores-portao-promocao.md:202-204](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md#L202-L204)):

1. **Grep Filtrado por Coluna:** Como o path está isolado na coluna 2 ([core/arvores-spec.md:33](file:///Users/macbookpro/Projetos/usehbn/core/arvores-spec.md#L33)), executa-se um filtro exato de string no ledger:
   ```bash
   # Exemplo conceitual de extração cronológica
   awk -F'|' -v path="core/relay-spec.md" 'gsub(/^[ \t]+|[ \t]+$/, "", $3) == path { print $2, $4, $6 }' REGISTRY.md
   ```
2. **Event Sourcing Linear:** A ordem em que os eventos aparecem no `REGISTRY.md` (de cima para baixo) reflete fielmente a linha do tempo das transições. O último estado registrado para aquele path define a maturidade corrente.
3. **Despromoções/Reversões:** O registro de despromoção segue a exata mesma mecânica de promoção: um evento append-only de tipo `arvore-despromocao` ou alteração explícita da coluna `arvore` para `fronteira`, exigindo um readback associado para registrar a justificativa técnica e a falha de conformidade que forçou a reversão.

---

## 3. TRAVESSIA DE EXÚVIA (GENOMA g1 → g2): RE-PROVA VS. HERANÇA

A travessia de exúvia (molt estrutural) é a janela onde o protocolo se renova.
[NUMERACAO-decisao-consolidada.md:96-99](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-17/NUMERACAO-decisao-consolidada.md#L96-L99) defende que o estágio não migra automaticamente e que o Fitness Gate deve re-avaliar o artefato.

### Análise Comparativa de Riscos:

| Opção | Funcionamento | Riscos | Vantagens |
| :--- | :--- | :--- | :--- |
| **A. Re-provação Estrita (Fitness Gate)** | Todos os artefatos perdem a classificação `estavel` ou `intermediaria` e voltam ao estado `fronteira` no genoma `g2`, precisando de novos pareceres e aprovação humana. | 1. **Paralisia Operacional:** Bloqueia o desenvolvimento diário devido ao gargalo de re-auditar dezenas de arquivos.<br>2. **Evitação do Molt:** A equipe tende a evitar evoluções de genoma para fugir da burocracia de re-homologação. | 1. **Garantia Anti-Teatro:** Impede a importação de premissas inválidas de `g1` que conflitam com as regras e novos guards de `g2`. |
| **B. Herança com Evidência (Grandfathering)** | O estágio de maturidade é herdado automaticamente baseando-se nas auditorias históricas de `g1`. | 1. **Decaimento de Segurança:** Incompatibilidades estruturais passam silenciosamente como "estáveis", minando a imunidade do novo genoma. | 1. **Fricção Zero:** Transição rápida e imediata preservação do baseline produtivo. |

**Recomendação de Consenso:**
Adotar um **mecanismo híbrido condicionado por impacto**:
*   Se o artefato **ou** seus guards de governança associados sofreram qualquer modificação durante o processo de exúvia, a re-provação é **obrigatória**.
*   Se o artefato permaneceu intocado e sua lógica de validação é idêntica, ele pode herdar o estágio de `g1` de forma automática **se e somente se** passar pela suíte automatizada CRISPR ([core/exuvia-fitness-criteria.md:80](file:///Users/macbookpro/Projetos/usehbn/core/exuvia-fitness-criteria.md#L80) e [A2-arvores-portao-promocao.md:188](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md#L188)). Os testes adversariais devem rodar no novo ambiente de `g2` para certificar que os invariantes continuam íntegros sem intervenção humana redundante.

---

## 4. ANÁLISE DE OVER-ENGINEERING E SUBCONJUNTO MÍNIMO (P11)

### Componentes com risco de rejeição por desenvolvedores autônomos:
1.  **Re-implementação Obrigatória em Rust para Estável:** [A2-arvores-portao-promocao.md:190](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md#L190) propõe portar specs/guards para Rust no nível `estavel`. Em projetos baseados em Python/Bash, isso introduz redundância de linguagem e exige conhecimentos específicos, gerando fricção injustificada.
2.  **Inexistência de Identificador Visual Local:** Não permitir nenhuma indicação visual da árvore dentro do arquivo de especificação obriga o desenvolvedor a constantemente realizar greps no `REGISTRY.md`.
3.  **Cross-audits Humanos para Pequenas Alterações:** Exigir pareceres formais de duas famílias diferentes para promover arquivos simples de testes ou scripts utilitários.

### Subconjunto Mínimo Recomendado (P11):
1.  **Apenas a Coluna no REGISTRY.md:** A coluna `arvore` no ledger centralizado é suficiente como fonte única.
2.  **Rótulo Visual não-normativo (Comentários):** Permitir a indicação da árvore em linhas de comentário ou metadados de documentação (como `# hbn-arvore: intermediaria` em [A2-arvores-portao-promocao.md:240](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md#L240)), atuando meramente como documentação secundária validada pelo G-REG contra a verdade do REGISTRY.
3.  **Promoção por Impacto:**
    *   Arquivos de código (`src/*` e `guards/*` locais) ganham promoção à `intermediaria` automaticamente se a suíte de testes passar.
    *   Apenas documentos centrais do protocolo (`spec-core`) e políticas normativas passam pelo rito manual rígido de readback + aprovação humana + cross-audit para alcançar o estágio `estavel`.
4.  **Eliminação do critério Rust:** A árvore `estavel` deve indicar a maturidade lógica e temporal (ex.: 30 dias sem falhas ou regressões, conforme [A2-arvores-portao-promocao.md:187](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md#L187)), e não o acoplamento tecnológico à linguagem Rust.
