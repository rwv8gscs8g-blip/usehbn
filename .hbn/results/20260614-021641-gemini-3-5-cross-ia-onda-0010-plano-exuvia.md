---
titulo: "Parecer de Auditoria Cruzada — Plano Exúvia (Onda 0010)"
tipo: audit-result
status: final
path: .hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md
id-global: 20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia
temperatura: frio
auditor: gemini-3-5
familia: Google
implementador-auditado: codex
commit_alvo: ad223fcfc624f368699ed7094b49b46d4bc68aa7
alvo: .hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md
created_at: "2026-06-14T02:16:41-03:00"
---

# Parecer de Auditoria Cruzada — Plano Exúvia (Onda 0010)

## Veredito

**APROVADO COM RESERVA (VETO_ADOCAO: NAO)**

Contagem de achados: **0 BLOQUEADOR; 3 FORTE; 1 MARGINAL**.

A proposta do protocolo "Exúvia" e o plano de transição para a versão 1.0.0 são conceitualmente sólidos e alinhados com as diretrizes constitucionais. No entanto, foram detectadas lacunas críticas de persistência no Git e compatibilidade de guards que exigem mitigação imediata antes da execução do corte. As adições do Gate Humano (Painel de Proteção e Trilha de Aprendizagem) são recomendadas e integradas a este parecer.

---

## Resumo Humano

1. O plano da onda 0010 é puramente conceitual e de design; não houve modificações de estrutura ou código ativo (escopo OK).
2. A transição de versão `0.3.x -> 1.0.0` está correta e alinhada com as regras de SemVer da [ADR-004:93](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-004-semver-protocolo.md#L93).
3. Identificado risco grave de perda silenciosa da casca-exúvia via Git Garbage Collection (GC) caso não seja criada uma tag formal para reter o commit congelado.
4. Identificado bug mecânico no guard G-REG caso o ledger seja movido para `.hbn/ledger/` usando link simbólico (symlink) na raiz, devido a limitações do `git show`.
5. O plano dissolve as dívidas históricas B1/B2/B3 de forma transparente, registrando-as como fatos históricos ou tratando-as no manifesto.
6. Aprovada a introdução do Painel de Proteção (`.hbn/relay/PAINEL.md`) no nível de arquivo como centralizador visual e referencial para todas as IAs.
7. Aprovada a expansão da Trilha de Aprendizagem com logs frios de janelas para todas as IAs do ciclo, indexados e referenciados no painel.

---

## Findings por Severidade

### 1. Achados de Severidade: FORTE

#### F-01: Risco de Perda Silenciosa de Legado via Git Garbage Collection (GC)
* **Citação:** [.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md:129-138](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md#L129-L138)
* **Análise:** A proposta prevê que a casca-exúvia seja preservada por meio de um snapshot de Git-tree apontado no manifesto. Contudo, se o commit de congelamento não estiver associado a nenhuma referência Git formal (tag ou branch), ele será classificado como órfão (unreachable). Em operações de rotina ou automáticas de limpeza do Git (`git gc --prune`), esse commit será excluído permanentemente do banco de dados de objetos, quebrando o princípio constitucional de preservação histórica [P1:54-70](file:///Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md#L54-L70) e a reversibilidade [P6:151-168](file:///Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md#L151-L168).
* **Correção Exigida:** O protocolo Exúvia deve incluir um passo obrigatório na Fase 2 (Congelamento) para gerar uma tag Git imutável (ex.: `exuvia-protocol-0.3.x` ou `exuvia/protocol-0.3.x`) apontando para o commit congelado, garantindo a sua permanência e a correta sincronização entre clones.

#### F-02: Incompatibilidade do Guard G-REG com Symlinks de Ledger na Raiz
* **Citação:** [guards/assert-registry-line.sh:50-58](file:///Users/macbookpro/Projetos/usehbn/guards/assert-registry-line.sh#L50-L58) e [.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md:292-294](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md#L292-L294)
* **Análise:** A proposta de manter um "ponteiro temporário" na raiz para compatibilidade do guard `G-REG` é inviável caso esse ponteiro seja implementado como link simbólico (symlink). No Git, o comando `git show :REGISTRY.md` em um symlink retorna apenas a string do caminho do target (ex.: `.hbn/ledger/REGISTRY.md`), não o conteúdo de texto da tabela. Isso fará com que o guard leia uma string vazia de registros e bloqueie todos os commits que adicionem artefatos novos.
* **Correção Exigida:** A transição deve descartar a ideia de symlink e prever a atualização direta e síncrona do script `guards/assert-registry-line.sh` no commit de renascimento, fazendo-o apontar e buscar dados diretamente em `.hbn/ledger/REGISTRY.md`.

#### F-03: Perda de Arquivos Untracked Históricos no Congelamento
* **Citação:** [.hbn/relay/STATE.md:269-273](file:///Users/macbookpro/Projetos/usehbn/.hbn/relay/STATE.md#L269-L273) e [.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md:298-299](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md#L298-L299)
* **Análise:** Se os arquivos atualmente catalogados como untracked forem apenas indexados textualmente no manifesto mas não adicionados de forma forçada ao histórico de commits da casca, eles serão descartados na limpeza pós-congelamento, violando o princípio [P1](file:///Users/macbookpro/Projetos/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md#L54-L70) ("nada se perde").
* **Correção Exigida:** O commit de congelamento deve incluir a adição forçada (`git add -f`) de todos os arquivos untracked que se deseja preservar no histórico da casca.

---

### 2. Achados de Severidade: MARGINAL

#### M-01: Alerta Prévio de Upgrade de Dependência para Apps Consumidoras
* **Citação:** [.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md:99-101](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260614-001421-codex-exuvia-protocolo-transicao-e-plano-1a-muda.md#L99-L101)
* **Análise:** Embora as apps consumidoras estejam isoladas por suas cópias locais `.usehbn-snapshot/` (conforme [ADR-004 §2](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-004-semver-protocolo.md#L103-L117)), a promoção de `protocol_version` a obrigatória representa um marco de impacto.
* **Recomendação:** A transição deve prever a publicação imediata do sinal `⛓️ HBN PROTOCOL DEP CHANGE` logo após a confirmação da muda, preparando formalmente os projetos para a futura onda de upgrade multi-projeto.

---

## Recomendações por Hearback

O Gate Humano deve deliberar sobre a ratificação do plano incorporando as seguintes recomendações:

1. **[Aprovar com Reserva / Incorporar]** Adicionar o passo de etiquetagem Git formal (`git tag`) na Fase 2 da transição Exúvia para reter permanentemente o commit de congelamento.
2. **[Aprovar com Reserva / Incorporar]** Alterar a Fase 3 e 4 para atualizar o guard `assert-registry-line.sh` síncronamente, eliminando a dependência de compatibilidade por symlinks.
3. **[Aprovar com Reserva / Incorporar]** Exigir a adição forçada (`git add -f`) dos arquivos untracked preservados no commit de congelamento da casca.
4. **[Aprovar com Reserva / Incorporar]** Inclusão da Adição Humana (i): Criação de `.hbn/relay/PAINEL.md` como denominador comum de visualização no nível de arquivo, consolidando o estado de guards, exceções (F-01) e tokens.
5. **[Aprovar com Reserva / Incorporar]** Inclusão da Adição Humana (ii): Requisitar que toda IA grave seu log frio de chat em `logs/<timestamp>-<agente>-log-janela.md` ao final de cada turno, indexando-o no painel de proteção.

---

## Caminhos Criados ou Modificados

* [.hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/results/20260614-021641-gemini-3-5-cross-ia-onda-0010-plano-exuvia.md) - Parecer oficial de auditoria cruzada do plano Exúvia.
