SOU: Google · Gemini 3.5 Flash · apelido: antigravity · papel auditor

# PARECER DE DESIGN DE NUMERAÇÃO DE PROTOCOLO (useHBN)

- **Autor**: antigravity (Família Google)
- **Papel**: Auditor Independente / Designer de Protocolo
- **Data/Hora**: 2026-06-17T22:54:28-03:00
- **Contexto**: Rodada de Brainstorm 2026-06-17 (Identificação global e federada livre de colisão)
- **Documento de Referência**: [NUMERACAO-design-brief-e-validacao.md](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-17/NUMERACAO-design-brief-e-validacao.md) e [NUMERACAO-analise-fronteira-opus.md](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-17/NUMERACAO-analise-fronteira-opus.md)

---

## 1. AVALIAÇÃO COMPARATIVA DOS CANDIDATOS (A/B/C/D E CANDIDATO E)

| Critério / Requisito | A. Linear Único | B. Namespaced Federado | C. Híbrido + ULID/Hash | D. Só Global-Opaco | E. B-Mínimo (Recomendado) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1. Colisão-livre (Federação)** | ❌ Falha (Colide globalmente) |  Aprovado |  Aprovado |  Aprovado |  Aprovado |
| **2. Sem autoridade central** | ❌ Assume registro único |  Aprovado (via DNS/Repo) |  Aprovado (via DNS/Repo) |  Aprovado (via Hash) |  Aprovado (via DNS/Repo) |
| **3. Legível por humano** |  Aprovado |  Aprovado | ⚠️ Poluído | ❌ Reprovado |  Excelente |
| **4. Agnóstico de tecnologia** |  Aprovado |  Aprovado |  Aprovado |  Aprovado |  Aprovado |
| **5. Sequência legível** |  Aprovado |  Aprovado | ⚠️ Ruído visual | ❌ Reprovado |  Excelente |
| **6. Estável pós-exúvia** | ❌ Falha |  Aprovado |  Aprovado |  Aprovado |  Aprovado |
| **7. Simplicidade (P11)** |  Excelente | ⚠️ Verboso localmente | ❌ Complexidade alta | ❌ Complexidade alta |  Excelente (implícito local) |

### Análise Crítica dos Candidatos:
- **Candidato A (`g1.c01.w03-slug`)**: Simples e limpo, porém geograficamente ingênuo. Pressupõe um repositório central único. Na governança federada de múltiplos agentes e mercados descentralizados, gerará colisões inevitáveis no dia um.
- **Candidato B (`<ns>:g1.c01.w03-slug`)**: Um avanço significativo ao introduzir o namespace. No entanto, sua verbosidade é um problema se exigir que o desenvolvedor repita o prefixo do namespace em referências internas no mesmo projeto.
- **Candidato C (`<ns>:g1.c01.w03-slug@<ulid/hash>`)**: Apresenta forte super-engenharia (*over-engineering*). Tentar resolver identidade e integridade no mesmo string resulta em identificadores extremamente longos, de difícil digitação manual e alto ruído visual, violando o P11.
- **Candidato D (`ULID / Hash`)**: Prioriza a máquina em detrimento do humano. A perda da ordem cronológica visual (linha do tempo de ondas/ciclos) dificulta diagnósticos rápidos e auditorias manuais.
- **Candidato E ("B-mínimo")**: **O design vencedor.** Ao separar identidade local de verificação de integridade e tornar os contextos de namespace e genoma implícitos no uso local cotidiano, ele resolve todas as dores da federação sem sobrecarregar o desenvolvedor autônomo.

---

## 2. RESPOSTAS DIRETAS ÀS 6 PERGUNTAS DO BRIEF (SEÇÃO 5)

### Q1. Qual esquema é o mais adequado e simples?
O **Candidato E ("B-mínimo")** é o mais adequado e simples. Ele atende perfeitamente aos requisitos de colisão-zero e descentralização sem impor complexidade desnecessária ao fluxo de desenvolvimento diário local.

### Q2. Namespace: DNS, URL, Handle ou Hash? Como garantir colisão-livre sem autoridade central?
- **Recomendação**: O namespace padrão deve ser a **URL canônica do repositório Git** (ex.: `github.com/usuario/repo`), permitindo-se **reverse-DNS** (ex.: `com.organizacao.projeto`) para entidades com infraestrutura de domínios corporativos.
- **Estratégia sem autoridade central**: Pegar carona na infraestrutura mundial de DNS e no registro de domínios/contas de Git (provedores como GitHub, GitLab, servidores auto-hospedados). O proprietário do domínio ou do repositório Git detém a autoridade delegada e exclusiva sobre seu namespace, impossibilitando colisões globais sem a necessidade de o useHBN gerenciar um servidor central de nomes. Handles puramente inventados (como `@financeiro`) devem ser restritos ao escopo local, sob pena de colisão na federação.

### Q3. Genoma/Exúvia: como versionar mudas de forma rastreável?
- O prefixo `gN` (sendo `N` o número do genoma, e.g., `g1`, `g2`) indica a versão estrutural do protocolo para aquele repositório.
- O genoma ativo é definido centralmente no manifesto global do sistema (ex.: `.hbn/relay/STATE.md` ou `.hbn/manifest.json`). 
- Em uso diário local no mesmo repositório, o prefixo do genoma é omitido (sendo inferido o genoma ativo do manifesto).
- Quando o sistema passa por uma exúvia (ex. de `g1` para `g2`):
  1. O manifesto do repositório incrementa o indicador para `g2`.
  2. Todos os caminhos e arquivos legados de `g1` são declarados read-only no Git (usando a proteção nativa do useHBN por meio de guards como `forbidden-paths`).
  3. Quaisquer referências feitas a partir do novo genoma (`g2`) a elementos antigos usam explicitamente o prefixo do genoma arquivado (`g1.cNN.wMM-slug`). A própria árvore de commits do Git cuida do rastreamento temporal da mudança.

### Q4. Artefatos federados: como referenciar cross-audits/knowledge compartilhados?
- Usa-se a especificação completa do FQID (Fully Qualified ID) no formato: `<namespace>:<id-local>`.
- **Exemplo**: `github.com/empresa/auth:c02.w04-policy-assert`.
- Para conhecimento comum e especificações globais do ecossistema, estabelece-se um namespace comunitário compartilhado (ex.: `github.com/usehbn/commons:k-0027-trailers`). Ferramentas locais clonam ou atualizam o repositório comum em background para resolver o link, sem a necessidade de APIs de busca dinâmicas centralizadas.

### Q5. Migração: riscos e atrito na coexistência com o REGISTRY antigo (`00NN`)
- **Risco**: Ferramental legou e hooks antigos não reconhecerem o novo formato.
- **Mitigação**: 
  1. O REGISTRY antigo e suas respectivas pastas de resultados (`00NN`) tornam-se imutáveis e protegidos contra modificações.
  2. Cria-se um mapeamento estático (shim) no runner de governança que converte os identificadores legados para o novo padrão logicamente (ex.: o readback `0051` passa a ser lido internamente pela engine como `g0.c00.w51-g-trailers` para fins de consistência relacional).
  3. Os hooks e guards da nova exúvia operam de forma estrita para os novos arquivos, ignorando os arquivos do diretório legado que já estão congelados pelo Git.

### Q6. Leveza (P11): o que é over-engineering e qual o subconjunto mínimo?
- **Over-engineering a evitar**: 
  1. Embutir hashes de arquivos ou ULIDs obrigatórios dentro do string de ID (ex. Candidato C).
  2. Obrigatoriedade de registrar um domínio próprio na web para atuar como adotante.
  3. Escrever namespaces ou tags de genoma de forma explícita nas referências internas cotidianas.
- **Subconjunto Mínimo**:
  - Para 90% dos casos locais, o formato deve ser apenas: **`cNN.wMM-slug`** (ex.: `c02.w03-auth-screen`). O namespace, o genoma ativo e a integridade de commit são implícitos e manipulados pela ferramenta de background.

---

## 3. ATAQUE CRÍTICO AO CANDIDATO E: O DILEMA DE VERIFICAÇÃO

A proposta de Opus de **separar identidade (namespace + sequência) de verificação (Git SHA)** é indiscutivelmente mais leve, mas requer atenção honesta quanto às suas perdas em comparação com o ID auto-verificável (C).

### O que se PERDE ao adotar o Candidato E?
1. **Autenticidade Independente de Contexto (Context-Free Integrity)**: No Candidato C, o ID traz em si a prova criptográfica do seu conteúdo (a assinatura/hash). Se você possui o ID `<ns>:c01.w01-slug@hash`, você consegue verificar se os bytes de um arquivo local batem exatamente com a referência sem precisar consultar o histórico do repositório Git ou acessar bancos de dados. No Candidato E, a verificação obriga a ferramenta a conhecer o backend (Git), ler o banco de objetos local e checar o commit correspondente.
2. **Resiliência a Rewrites de Histórico do Git**: Se um desenvolvedor realizar operações destrutivas ou de limpeza no repositório (ex.: `git rebase -i`, `squash` na consolidação de branches, ou `git filter-repo` para remover arquivos pesados), os hashes de commits (SHAs) mudam. No Candidato E, referências baseadas em `<ns>@<sha>` quebrarão imediatamente. No Candidato C, como o hash está ligado ao conteúdo do artefato (ou gerado na origem independentemente do Git SHA), o identificador do artefato e a capacidade de validá-lo permanecem inalterados.
3. **Independência Estrita de VCS**: O uso de Git SHA acopla o protocolo de forma vitalícia ao ecossistema Git. Se no futuro um adotante migrar seu repositório para outro VCS descentralizado ou um armazenamento em nuvem puro (como S3/IPFS), a especificação do commit SHA perde sua função natural de rastreabilidade.

### Por que, apesar dessas perdas, o Candidato E ainda é Superior para o useHBN?
- **useHBN é Git-nativo**: A premissa de que o useHBN é "um protocolo de governança de IA via git" é central. O acoplamento com o Git não é uma fragilidade, mas sim uma decisão arquitetônica estabelecida.
- **Evitação do Ruído Clicável**: A poluição visual de hashes longos nos logs de commits e arquivos reduz o apelo humano do protocolo. Forçar humanos e IAs autônomas a gerarem e colarem hashes hexadecimais a cada commit traria fricção impeditiva à adoção de larga escala (violando o P11).
- **Abordagem de Lockfile (Padrão Go/npm)**: A verificação de integridade não precisa estar no ID principal. Ela pertence a uma camada secundária. O uso opcional do Git SHA (`<ns>@<sha>:<path>`) em ferramentas de auditoria automatizada (CI) e o uso de sum-files para dependências federadas resolvem a verificação sem perturbar a elegância visual do protocolo.

---

## 4. ESPECIFICAÇÃO RECOMENDADA DO ID DO PROTOCOLO

Propomos a adoção do **Candidato E ("B-mínimo")** com as regras formais abaixo:

### A. Forma Exata do ID de Exemplo
- **Single-system (Uso local cotidiano)**: 
  ```text
  c02.w03-auth-screen
  ```
  *(Genoma implicitamente `g1` e namespace inferido a partir da configuração do repositório).*

- **Cross-system (Referência externa)**: 
  ```text
  github.com/owner/repo:g1.c02.w03-auth-screen
  ```
  *(O genoma `g1` passa a ser explícito e o namespace é prefixado com dois-pontos).*

- **Com Pin de Integridade (Auditoria/CI)**:
  ```text
  github.com/owner/repo@a8b9c1d:g1.c02.w03-auth-screen
  ```
  *(O Git SHA de 7 a 40 caracteres é adicionado após a arroba para auditorias rígidas).*

### B. Estratégia de Colisão sem Autoridade Central
1. **Entre Adotantes (Global)**: Baseado estritamente na URL canônica do repositório Git ou reverse-DNS. Garante colisão-zero delegando a resolução à hierarquia existente de nomes da Internet e serviços Git.
2. **Dentro do Adotante (Local)**: A progressão cronológica do ciclo e onda (`cNN.wMM`) garante a sequência linear. Em caso de paralelismo extremo em eventos assíncronos (como pareceres e logs de auditoria), o useHBN continuará utilizando a estratégia de composição estabelecida pelo `ADR-025` (`AAAAMMDD-HHMMSS-<agente>-<slug>`).

### C. Versionamento de Exúvias (Mudas)
A transição estrutural ocorre incrementando o genoma (`gN`). Os logs históricos são congelados em diretórios específicos arquivados pelo Git, e as referências inter-genomas utilizam a notação qualificada explícita (e.g. `g1.c02.w01-slug` dentro de um repositório operando em `g2`).

### D. Subconjunto Mínimo (P11)
A sintaxe local básica e única: **`cNN.wMM-slug`**. É o menor bloco possível que resolve o ordenamento legível e a identificação do passo.
