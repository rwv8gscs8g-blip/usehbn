# Relatório de Auditoria Cruzada Adversarial — Anti-Desarme v2 (Fase 1)

**Identificador**: 20260704-225020-cross-ia-antigravity-fase1-antidesarme-v2
**Agente**: Antigravity (família Google)
**Papel**: Auditor Cruzado Adversarial
**Alvo**: Genoma useHBN (Fase 1)
**Data**: 2026-07-04T22:50:20-03:00

---

### ADMISSÃO DE FALHA ANTERIOR (O QUE FOI DEIXADO PASSAR)
No parecer anterior (`20260704-220700-cross-ia-antigravity-fase1-classe-anti-desarme.md`), aprovei a classe anti-desarme com `APROVA_CLASSE: SIM`. Deixei passar um furo estrutural crítico: a validação em modo CI/range (`hbn_ci_range_mode`) consulta o estado da dependência em `HEAD` em vez do índice staged quando rodado localmente com o ambiente envenenado (`CI=true` e `HBN_DIFF_BASE` setado). O helper erroneamente classificava a remoção staged como `ATIVO` devido à presença do arquivo em `HEAD`, permitindo que o commit de remoção passasse sem bloqueio. Fui leniente ao assumir que o chaveamento entre local e CI estava blindado.

---

### (a) O Furo do HBN_DIFF_BASE e Envenenamento de Env
O furo estrutural permanece aberto sob condições adversariais de ambiente envenenado.
- **Caso 1: Local sem variáveis de CI (`unset CI GITHUB_ACTIONS HBN_CI`) e `HBN_DIFF_BASE` setado**: Funciona corretamente. O helper `hbn_ci_range_mode` retorna falso, chaveando para verificação de índice (`hbn_index_path_kind`). A remoção staged retorna `absent` no índice e `present` em `HEAD` (baseline), classificando o estado como `DISARM` e bloqueando o commit.
- **Caso 2: Local com variáveis de CI (`export CI=true` ou similar) e `HBN_DIFF_BASE=HEAD` (Poisoned Env)**: **A remoção staged escapa do bloqueio**.
  - Evidência em [guards/lib/common.sh:265-276](file:///Users/macbookpro/Projetos/usehbn/guards/lib/common.sh#L265-L276):
    ```bash
    if hbn_ci_range_mode; then
        current_kind="$(hbn_ref_path_kind HEAD "$p")"
        base="$HBN_DIFF_BASE"
    ```
    Se `hbn_ci_range_mode` é forçado a retornar verdadeiro localmente, o helper resolve `current_kind` usando o commit `HEAD` atual. Como a remoção da dependência está apenas staged no índice (não commitada ainda), o arquivo ainda existe no commit `HEAD`.
    Portanto, `current_kind` é resolvido como `file` ou `dir`, e a função retorna `ATIVO` em vez de `DISARM` (ou seja, não bloqueia).
    O guard correspondente então executa a validação usando a referência do arquivo em `HEAD` (que é válida) e retorna sucesso (exit 0), permitindo o commit da remoção.
- **Detecção em CI real**: O modo CI real só liga com sinal real (HBN_CI, GITHUB_ACTIONS ou CI != 0/false). Contudo, a facilidade de simular esse ambiente localmente invalida a garantia absoluta do anti-desarme no pré-commit.

---

### (b) Ataque Adversarial ao Anti-Desarme por Outras Vias
1. **Bypass por Renomeação (`git mv`)**: **BLOQUEADO**.
   - Ao mover o arquivo, a dependência no caminho antigo é removida do índice. O helper resolve o caminho antigo como `absent` no índice e `present` em `HEAD` (baseline), marcando como `DISARM` e abortando. Coberto por testes de regressão.
2. **Bypass por Symlink (tipo `120000`)**: **BLOQUEADO**.
   - Se o arquivo de dependência for substituído por um link simbólico, `hbn_index_path_kind` retorna `symlink`.
   - `hbn_path_kind_active` retorna falso para symlink, mas `hbn_path_kind_present` retorna verdadeiro.
   - O helper cai na condicional que retorna `DISARM`, bloqueando a modificação.
3. **Bypass por Diretório Marcador (como `.usehbn-snapshot`)**: **BLOQUEADO**.
   - Se a pasta for esvaziada ou deletada, o Git rastreia a ausência de seus arquivos. `hbn_index_path_kind` retorna `absent` para o caminho, enquanto `HEAD` contém os arquivos (tipo `dir` ou `file`). O helper retorna `DISARM` e bloqueia.
4. **Bypass por Active-Version Torta / Version-Switching**: **LOOPOHOLE ATIVO**.
   - Se o desenvolvedor altera `.hbn/active-version` apontando para um novo diretório de versão (ex: `versao_1_0_0`) que contém apenas uma cópia do runner e do helper, mas **não contém** os arquivos de dependência protegidos (como `versao_1_0_0/core/role-cards.md`).
   - A validação de caminhos resolve os alvos para `versao_1_0_0/core/role-cards.md`.
   - Como esse caminho nunca existiu em `HEAD` nem no índice, `hbn_context_dep_state` retorna `NOOP` para todos os guards.
   - Os guards silenciosamente passam com `NOOP` (sucesso), desligando completamente o anti-desarme e permitindo commits arbitrários sem governança.
5. **Env Poisoning**: Provado no item (a).

---

### (c) Completude da Classe de Guards
Além dos 6 guards principais que implementam a verificação de 3 estados (ATIVO/NOOP/DISARM), outros componentes da exúvia foram auditados:
- **`assert-no-stray-hbn.sh`** e **`assert-scratch-lock.sh`**: Não usam `hbn_context_dep_state` diretamente, mas possuem mecanismos fail-closed baseados no estado do ponteiro de versão ativa.
- **`assert-registry-line.sh`** e **`assert-arvore-label.sh`**: Lidam com o histórico do genoma de forma estática, mas não possuem proteção anti-desarme robusta contra deleção se forem modificados os diff-filters globais.
- **Controle do Runner**: Se `guards/hbn-guards-runner.sh` for deletado, os shims de commit abortam o rito (falha fechada). Contudo, a falta de proteção anti-desarme explícita no próprio runner permite que um desenvolvedor malicioso modifique o runner localmente para ignorar guards específicos se eles conseguirem commitar a alteração (o que pode ser bloqueado por outras validações, mas expõe a fragilidade da dependência de infraestrutura).

---

### (d) Veredito e Recomendações
A brecha **NÃO** está 100% fechada em todos os modos. O anti-desarme possui vulnerabilidades severas a manipulações locais de ambiente (`CI=true` com `HBN_DIFF_BASE`) e evasão por chaveamento de versão de gênese fictícia.

- **Pode selar + commitar?** **NÃO**.
- **Severidade**: **FORTE** / **BLOQUEADOR** (pois compromete a integridade do rito de governança humana local no pré-commit).
- **Diretiva de Correção Recomendada**:
  1. No helper `hbn_context_dep_state`, se a execução for local (detectada pela presença de `.git` no diretório de trabalho e chamada de hooks locais), o índice staged DEVE ter precedência absoluta sobre o commit de referência, independentemente de variáveis de ambiente de CI estarem setadas.
  2. Implementar verificação de que, ao chavear para uma nova versão em `.hbn/active-version`, a gênese não pode desativar incondicionalmente a presença das dependências da versão anterior sem autorização explícita registrada em STATE.md.

---

### Auto-Viés (B1-B6)
- **B1 (Leitura do Parecer e Fontes)**: Confirmado. Reanalisei meu parecer anterior e verifiquei as regras de detecção de CI e tratamento de caminhos no arquivo `guards/lib/common.sh`.
- **B2 (Verificação Independente)**: Confirmado. Criei um repositório temporário de testes e comprovei localmente que a remoção de dependências staged escapa do `DISARM` quando o ambiente é injetado com `CI=true` e `HBN_DIFF_BASE=HEAD`.
- **B3 (Busca Ativa por Outros Furos)**: Confirmado. Identifiquei o furo de Version-Switching para diretórios de versão novos/vazios que burlam os guards por `NOOP` generalizado.
- **B4 (Reexame de Leniência)**: Confirmado. Adotei postura estritamente adversarial e reverti a aprovação da rodada anterior.
- **B5 (Relevância da Recomendação)**: Confirmado. O parecer preserva as restrições e rito de auditoria sem tentar contornar a governança humana.
- **B6 (Não-assunção de Bastão)**: Confirmado. Apenas auditei e relatei, sem realizar edições de código ou commits.

### RESUMO
- A classe anti-desarme não está 100% segura contra evasão adversarial.
- Detectou-se um furo de escape quando `HBN_DIFF_BASE` e `CI=true` são injetados localmente.
- O helper avalia `HEAD` em vez do índice staged sob essas variáveis, liberando a remoção staged.
- Há também bypass por `active-version` apontando para esqueleto sem dependências (`NOOP` geral).
- Remocação, Symlinks e Diretórios Marcadores normais estão devidamente bloqueados.
- Bateria de testes original possui 327 checks e todos passam, mas não cobre esses vetores de burla.
- Recomenda-se precedência do índice na detecção local e validação inter-versões de active-version.

APROVA_ANTIDESARME: NAO
