---
titulo: "Parecer Antigravity — auditoria cruzada da proposta de doutrina do orquestrador (Onda 0008)"
tipo: result
path: .hbn/results/20260613-221433-gemini-3-5-cross-ia-onda-0008-doutrina.md
id-global: 20260613-221433-gemini-3-5-cross-ia-onda-0008-doutrina
temperatura: glacier
auditor: gemini-3-5
alvo: "proposta da onda 0008 (commit 5a8c5fb, main)"
reviewed_at: "2026-06-13T22:14:33-03:00"
status: congelado
---

## Resumo Humano

1. A proposta de evolução da doutrina é aprovada com ressalva devido a uma contradição mecânica na cláusula 9.
2. Confirmado escopo de Doutrina-Sem-Enforcement (Tempo 1). Nenhuma spec ou guard foi alterado no commit `5a8c5fb`.
3. A camada de abstração (cl. 7) desce o princípio P13 ao comportamento e reforça a supervisão humana legítima.
4. O modo educativo (cl. 8) apoia a autonomia do gate humano ao instruir sua competência didaticamente.
5. Identificado achado Forte na cl. 9: fixar Codex simultaneamente na implementação e na auditoria viola o invariante anti-groupthink.
6. A contradição de auditoria do Codex deve ser mitigada no Tempo 3 parametrizando a exclusão da família do implementador.
7. O modo básico educativo apresenta risco marginal de opacidade por excesso de didatismo; a verdade mecânica deve prevalecer.
8. A ambiguidade sobre reboot vs leitura de estado persistido de modo de prosa deve ser refinada no tempo 3.

**VETO_ADOCAO:** NAO

---

## Verificação de Diretrizes e Coerência

### 1. Fidelidade e Coerência Teórica
As cláusulas propostas são teoricamente coerentes com os princípios da Constituição (ADR-009). 
- A **Cláusula 7** (Camada de Abstração) traduz de forma pragmática o **P13** (AI-Language-Abstraction), atribuindo ao orquestrador a responsabilidade de digerir a mecânica técnica de guards e códigos para apresentá-los em prosa limpa e acessível ao humano. Isso apoia diretamente o **P5** (Humano no controle), reduzindo a barreira de entrada da supervisão e prevenindo a validação de teatro.
- A **Cláusula 8** (Modo Educativo) e o refino da **Cláusula 4** resolvem de forma elegante a tensão entre o minimalismo técnico de passos operacionais (knowledge 0002) e o entendimento detalhado de conceitos de domínio exigido do operador humano.
- A **Cláusula 9** (Roteamento) formaliza as capacidades e papéis dos modelos com base nos perfis canônicos de capacidade parametrizados (ADR-015).

### 2. Escopo e Ausência de Enforcement Escondido
Confirmado que a mudança cumpre estritamente com o escopo de **Doutrina-Sem-Enforcement** do Tempo 1.
- A especificação `core/orchestrator-profile-spec.md` permaneceu intocada no commit.
- Nenhum script em `guards/` ou código de domínio em `src/` foi modificado.
- O diff de modificação em `REGISTRY.md` e `.hbn/relay/STATE.md` representa puramente o tracking administrativo da Onda 0008. Não há regras de guards em execução escondidas ou ativadas silenciosamente.

### 3. Solidez e Riscos de Implementação

#### R1. Invariante da Cláusula 9 vs Contradição de Roteamento Fixo
Os invariantes propostos reforçam muito o anti-groupthink (ADR-018) e a mitigação de auto-auditoria/exceção (anti-F-01 / G-EXC) ao barrar que a mesma família de pesos se auto-avalie.
Contudo, há uma contradição mecânica na proposta de roteamento:
- A Cláusula 9 define o roteamento fixo de implementação: `Código/Guards → Codex`.
- A mesma cláusula define o roteamento fixo de auditoria cruzada: `Cross-audit → Codex + Gemini`.
- E o invariante (b) decreta: `auditores ≠ família do implementador (ADR-018)`.
Se o Codex (família OpenAI) atua como implementador, ele não pode atuar como auditor cruzado de sua própria obra sem violar o invariante (b) e o ADR-018. 
**Mitigação recomendada para o Tempo 3:** Ajustar a redação para que o pool de auditores seja mutuamente exclusivo com a família do implementador ativo (por exemplo, se Codex implementa, a auditoria cruzada deve ser feita por Gemini + Opus/Fable).

#### R2. Didatismo Didático vs Risco de Opacidade Operacional
No "Modo Básico" de prosa educativa, a ocultação de jargões técnicos para facilitar o entendimento de iniciantes pode, marginalmente, mascarar detalhes estruturais de guards ou logs mecânicos importantes, transformando a simplificação didática em opacidade técnica.
**Mitigação recomendada para o Tempo 3:** Adicionar uma frase na cláusula 8 garantindo que o didatismo de prosa nunca deve substituir ou ocultar a precisão factual dos diagnósticos mecânicos e guards do repositório (Truth Barrier).

#### R3. Ambiguidade de Reboot vs Disco no Handoff do Modo
A cláusula 8 diz no item (a) que toda nova janela declara o modo ativo persistido no disco, mas no item (b) diz que o "reboot" sempre volta a intermediário. Se a troca de janela (handoff ordinário) inicializa uma nova sessão, isso redefine o modo para intermediário ou lê o modo persistido no disco?
**Mitigação recomendada para o Tempo 3:** Esclarecer que a troca ordinária de janela de chat lê o modo persistido em STATE.md (disco), enquanto o reset de ciclo completo (reboot forçado/de emergência) volta para o default intermediário.

---

## Achados de Auditoria

### F1. Contradição de Roteamento Codex em Implementação e Auditoria
- **Veredito:** FORTE
- **Severidade:** Média (Inconsistência lógica que inviabiliza execução mecânica estrita do anti-groupthink)
- **Evidência:** `.hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md#L86-L88` vs `#L94`.
- **Análise:** A especificação indica que o `Codex` deve implementar código de guards e também participar da auditoria cruzada (`Codex + Gemini`), o que viola a regra de separação de famílias de peso do ADR-018 se ambos os papéis forem exercidos na mesma onda.

### F2. Risco de Opacidade por Abstração no Modo Básico
- **Veredito:** MARGINAL
- **Severidade:** Baixa (Risco de atenuação de entendimento factual por didatismo)
- **Evidência:** `.hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md#L56-L58`.
- **Análise:** A omissão total de jargões técnicos e vocabulários HBN pode dificultar a identificação de violações reais de guards no gate humano se o didatismo forçar metáforas imprecisas sobre logs reais.

---

## Recomendações de Adoção (Hearback)

### Item 1. Homologar Proposta para Tempo 3 (Emenda da Spec)
- **Recomendação:** APROVAR com ressalva para emenda no Tempo 3.
- **Ação Humana:** Prosseguir com a incorporação do conteúdo à spec `core/orchestrator-profile-spec.md` sob a condição de ajustar as mitigações dos achados F1, F2 e o esclarecimento do fluxo de boot/reboot do modo educativo na redação final.

### Item 2. Correção de Roteamento de Auditoria Cruzada (F1)
- **Recomendação:** APROVAR.
- **Ação Humana:** Garantir que no Tempo 3, ao redigir a especificação final de roteamento de modelo, o texto estipule que a família do implementador deve ser dinamicamente removida do subconjunto de auditores daquela onda (evitando Codex auditando Codex).

### Item 3. Blindagem Factual contra Opacidade no Didatismo (F2)
- **Recomendação:** APROVAR.
- **Ação Humana:** Acrescentar na redação da emenda da cláusula 8 que a simplificação didática de linguagem não autoriza a omissão ou atenuação da verdade de estado informada por guards ou pelo disco (Truth Barrier).

### Item 4. Esclarecer Boot de Nova Janela vs Reboot
- **Recomendação:** APROVAR.
- **Ação Humana:** Esclarecer na especificação que warm boots ordinários de novas janelas respeitam a configuração de modo persistida no disco, enquanto reboots sistêmicos ou de ciclo forçam o retorno ao nível intermediário default.
