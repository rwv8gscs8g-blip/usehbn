# Mecanismo de aptidão (Fitness Gate) + darwinismo no useHBN

Consideração fundamental do gate humano (2026-06-14): a Exúvia só é possível para um modelo que
FUNCIONA, comprovado em testes reais. A muda é EARNED — como o artrópode que muda porque sobreviveu e
cresceu. Sem isso, o "darwinismo" poderia eternizar um sobrevivente que não era o mais apto.

## 1. O princípio
Aptidão = **funcionar e resolver o problema testado na realidade**, não ser teoricamente mais bonito.
Novas tecnologias, formas semânticas de código ou melhorias de apresentação PODEM aumentar a aptidão,
mas **o que funciona em teste real tem prevalência.** Logo: só muda quem já provou que sobrevive.

## 2. O Fitness Gate da Exúvia (mecanismo seguro — obrigatório)
Uma versão só pode mudar (exúvia) se passar por:
1. **Precondição de aptidão:** a versão atual está **funcional e testada** — suíte verde + testes reais
   passando + (no caso do protocolo) a **Ponte do Credenciamento funcionando**. Modelo não-provado não muda.
2. **Confronto incumbente × desafiante:** o modelo novo (proposto na muda) é confrontado contra o
   modelo atual (baseline provado) **nos mesmos testes reais**.
3. **Condição de vitória do desafiante:** entregar **mais com menos, melhor**, passando de forma exemplar
   nos testes, OU corrigir barreiras técnicas/restrições documentadas do modelo anterior — **medido**, não afirmado.
4. **Incumbente sobrevive por padrão:** se o desafiante não vence/iguala na realidade, a muda é **rejeitada**
   e o modelo atual permanece. (Isto é o que impede o darwinismo ingênuo de enshrinar o pior.)
5. **Reversibilidade (P6):** se, após a muda, o modelo novo decepcionar no uso real, rollback para o
   incumbente (que está congelado e intacto na exúvia anterior).

Resumo: **a seleção é DIRIGIDA por teste real**, não por inércia, acaso ou preferência estética.

## 3. Darwinismo em três níveis (com o mesmo fio de segurança)
**Nível 1 — Software/estrutura (a exúvia):** só os módulos/códigos/exemplos mais aptos (provados)
carregam para a versão nova; o menos apto fica no exoesqueleto anterior ou desce ao glacier. Gated pelo
Fitness Gate (§2).

**Nível 2 — Evolução das IAs (trilha de aprendizagem / "dream"):** uma lição só é promovida a regra/ADR
se **provar** que previne um erro real (não basta ser plausível). A consolidação offline propõe; o teste
real e o humano ratificam. Retenção/forgetting (30 dias) poda o que não se mostrou útil. Precedente:
auto-melhoria recursiva + AlphaEvolve (código que evolui sob avaliação objetiva).

**Nível 3 — Seleção inter-agentes (cláusula 9 evoluída):** qual IA para qual tarefa passa a ser decidido
por **desempenho MEDIDO ao longo de ciclos** (ex.: quem gerou menos tropeços de guard, melhores auditorias),
registrado no ledger/trilha. Padrão técnico: champion/challenger + multi-armed bandit (explorar×explorar)
sobre métricas reais. As mudanças de roteamento são **propostas auditadas e ratificadas**, nunca
auto-aplicadas. Conecta ao AdaptOrch (orquestração task-adaptive na convergência de performance dos LLMs).

**Fio de segurança comum aos três:** aptidão = provada na realidade; nada promove/muda/re-roteia sem
evidência do disco; o incumbente segura até o desafiante provar superioridade; tudo reversível e auditável.

## 4. Reconciliação do roadmap (decorre do §2)
O Fitness Gate corrige a ordem que tínhamos:
- **DESENHAR** a exúvia agora (sabendo que virá) — OK, é o que estamos fazendo.
- **A 1ª exúvia REAL só acontece sobre um baseline PROVADO** — ou seja, depois que o protocolo estiver
  **funcional e validado pela Ponte do Credenciamento**. Hoje estamos em elaboração; o protocolo ainda
  não "terminou de ser escrito e funcional".
- Portanto, o trabalho atual (fechar doutrina, dissolver dívida, estabilizar) **NÃO é uma exúvia** — é
  levar o protocolo até "funcional". A "1ª Exúvia MVP" do roadmap antigo vira: **dry-run do mecanismo**
  (validar a máquina da muda sem mudar o protocolo real), e o **molt real fica para depois da prova**.
- Ordem corrigida: **estabilizar → provar via Credenciamento → 1ª exúvia real** (na forma provada).
  Isso inverte a posição "exúvia antes do Credenciamento" do RADAR §7. Mesmo padrão vale para o
  Credenciamento: a exúvia da versão final V acontece com tudo de V funcionando.

## 5. Ponto de discussão para você
Confirmar a inversão: **a Ponte do Credenciamento (prova de funcionamento) vem ANTES da 1ª exúvia real**;
e a dissolução de B1/B2/B3 acontece dentro dessa 1ª exúvia provada (não antes, via cirurgia). Se você
concordar, eu ajusto o plano rápido (M-marcos) para refletir essa ordem.
