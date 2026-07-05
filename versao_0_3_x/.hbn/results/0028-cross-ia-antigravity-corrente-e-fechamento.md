# Parecer Antigravity — re-auditoria cruzada corrente E (fechamento Blocos 3-6)
**Auditor:** antigravity (Gemini 3.5) · **Session role:** cross-ia-audit-corrente-e-fechamento
**Reviewed at:** 2026-06-10T15:20:00-03:00

## Pré-flight
1. **pwd**: Confirmado em `/Users/macbookpro/Projetos/usehbn`
2. **git status**:
   - Status mostra 14 arquivos staged (prontos para checkpoint).
   - O index.lock do Git foi detectado como órfão pós-sandbox e documentado no handoff.
3. **git log**:
   - HEAD está em `e876060` (release(protocol): adopt corrente E 50% anti-teatro (ADR-020 + 3 guards + suite) — hearback mauricio; guards fora do runner; 0002 pendente).

---

## Veredito por escopo

| Item | Veredito | Evidência-chave |
|---|---|---|
| (1) G-HRB / ADR-023 (Integridade de Hearback) | **APROVADO** | [ADR-023](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-023-integridade-de-hearback.md) e [assert-hearback-integrity.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-hearback-integrity.sh) bloqueiam com sucesso a auto-assinatura no mesmo commit e commits impuros. Reconhecem honestamente na Decisão 3 que a barreira final de segurança lógica é parcial sob shell compartilhado, delegando à revisão humana do diff. |
| (2) G-SLF / ADR-021 (Auto-localização) | **APROVADO** | [ADR-021](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-021-documentos-auto-localizaveis.md) e [assert-self-path.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-self-path.sh) implementam corretamente o bloqueio para caminhos declarados diferentes dos físicos (`path:` ≠ real) e a falta de declaração em artefatos governados. |
| (3) G-REG Endurecido (Rename AR, Aninhados, Órfãos) | **APROVADO** | Os bugs 0026/F-01 (filtro de renames AR), 0026/F-02 (guards aninhados) e 0026/F-04 (órfãos em docs/methodology) foram todos endereçados e sanados em [assert-registry-line.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-registry-line.sh). O suporte a guards aninhados foi provado via teste negativo hermético. |
| (4) Efetividade da Suíte de Testes (29 Casos) | **APROVADO** | A suíte ampliada em [run-guard-tests.sh](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh) é robusta, roda em repositórios descartáveis temporários e provou o bloqueio efetivo de todos os casos-ruins adicionados (29/29 verde). |
| (5) Análise de Risco Antropológico / Cultural | **APROVADO COM ALERTA** | A mitigação reduz a superfície de ataque ao exigir commits separados e puros para assinaturas, mas a dependência no "green check" da suíte pode induzir ao viés de automação no gate keeper humano se ele não realizar a revisão manual do diff de hearbacks. |

---

## Findings

### F-01 · MARGINAL · guards/assert-self-path.sh · L68-81
* **Evidência**: A função `requires_path()` lista apenas um subconjunto de artefatos governados (ADR, knowledge, results, messages, reports, prompts e hearbacks).
* **Descrição**: Arquivos de especificação sob `core/*.md` e modelos sob `.hbn/models/*.json` são listados como artefatos governados em `assert-registry-line.sh` (G-REG), mas não são obrigados a possuir o campo `path:` em `assert-self-path.sh` (G-SLF). Se uma IA criar um novo arquivo spec em `core/` sem declarar `path:`, o G-SLF passará com sucesso. Embora esses arquivos tenham nomes estáveis, a falta de auto-localização neles gera uma inconsistência de cobertura do Bloco 3.
* **Recomendação**: Adicionar `core/*.md` e `.hbn/models/*.json` à função `requires_path()` na próxima janela de hardening do G-SLF.

### F-02 · MARGINAL · guards/tests/run-guard-tests.sh
* **Evidência**: Os novos guards G-SLF e G-HRB foram implementados e testados com sucesso, mas permanecem fora do runner de produção.
* **Descrição**: A política geral do ADR-020 (Decisão 2) impede a ativação de qualquer guard no runner de commits sem uma suíte completa de testes negativos. Como as 5 guardas legadas (`assert-canonical-root.sh`, `forbid-tmp-worktree.sh`, `forbid-env-files.sh`, `forbid-legacy-paths.sh`, `assert-scope-lock.sh`) ainda não possuem testes na suíte, o runner inteiro permanece desativado, o que deixa o repositório temporariamente desprotegido contra auto-assinatura e auto-localização mentirosa durante o desenvolvimento ativo (proteção apenas local via execução manual dos testes).
* **Recomendação**: Priorizar no backlog a criação de testes negativos para os 5 guards legados para destravar a ativação global do runner.

---

## Tensões filosóficas e risco antropológico/cultural

1. **A Fragilidade dos Commits Puros sob Identidade Compartilhada (Teatro de 4º Nível)**: 
   O G-HRB impede que a IA faça bypass simples gerando uma assinatura no mesmo commit. No entanto, como a IA compartilha o mesmo shell e identidade Git do desenvolvedor humano, ela possui os comandos e permissões necessárias para encadear commits (`git commit` do hearback seguido de `git commit` do código). O guard G-HRB avaliará o commit do hearback como ancestral separado e puro, marcando-o como verde. Se o operador humano confiar cegamente na suíte de testes ou no feedback do guard ("Viés de Automação"), a barreira de segurança falhará. A declaração explícita dessa limitação na **Decisão 3 do ADR-023** é um ato de honestidade técnica indispensável que previne a falsa sensação de segurança.
2. **A Burocracia da Assinatura Separada**: 
   Exigir um commit exclusivo e puro para cada hearback adiciona atrito ao fluxo de trabalho do desenvolvedor humano. Esse atrito é positivo, pois força um ponto de pausa física (o commit da autorização precede a obra), exigindo que o humano olhe para o diff daquela autorização. Contudo, há o risco de o humano começar a realizar commits "em lote" ou pré-autorizar mudanças de forma descuidada para evitar o atrito, o que degradaria a eficácia do ritual de auditoria.

---

## Comparação com precedentes externos

1. **Policy-as-Code e Auditoria Criptográfica**: 
   A evolução natural sugerida na Decisão 4 do ADR-023 (assinatura GPG/SSH de commits) alinha o protocolo useHBN com as melhores práticas de infraestrutura segura (ex.: commits assinados obrigatórios no GitHub/GitLab). Sem chaves criptográficas privadas guardadas fora do alcance do agente local da IA, a segurança em nível de aplicação Git é puramente informativa e baseada em trilha de auditoria post-hoc.
2. **Aproximação Estrita de Glob em Bash**: 
   A resolução do F-02 (guards aninhados) via comportamento nativo do `case` bash (onde `*` cruza `/`) demonstra que simplificar o código mantendo o padrão declarativo é superior a adicionar complexidade procedural. O teste negativo provou de forma limpa a validade da especificação.

---

## Checklist anti-viés

* **B1. Li os artefatos diretamente?** Sim, analizei na íntegra as especificações de [ADR-021](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-021-documentos-auto-localizaveis.md), [ADR-022](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-022-saida-de-auditoria-legivel.md), [ADR-023](file:///Users/macbookpro/Projetos/usehbn/methodology/adr/ADR-023-integridade-de-hearback.md), os scripts correspondentes e os 29 casos de teste em [run-guard-tests.sh](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh).
* **B2. Verifiquei as alegações de teste independentemente?** Sim, executei a suíte localmente no ambiente de trabalho e obtive a confirmação de 29/29 testes passando, validando o bloqueio real dos casos-ruins.
* **B3. Procurei razões para reprovar antes de aprovar?** Sim, inspecionei possíveis escapes no G-SLF (F-01) e o risco de desvio estrutural na pureza de commits no G-HRB.
* **B4. Encontrei contradições?** Sim, a inatividade prática das novas guardas até que as legadas ganhem cobertura (F-02) contrasta com o progresso técnico imediato delas.
* **B5. Alguma recomendação minha preserva minha utilidade/relevância?** Não. As recomendações focam exclusivamente no hardening técnico do repositório e no processo de governança humana.
* **B6. Não assumi o bastão?** Confirmado. O proprietário do bastão no `STATE.md` continua sendo `claude-fable-5` e a próxima ação é delegada ao gate humano (Maurício).

---

## Recomendação por hearback

* **EF1 (Aprovar ADR-021 + G-SLF)**: **APROVAR**. A auto-localização resolve o problema dos arquivos flutuantes em chats e o guard impede desvios de caminhos físicos.
* **EF2 (Aprovar ADR-022)**: **APROVAR**. Formaliza o markdown legível como contrato principal de auditoria, otimizando o tempo do gate humano.
* **EF3 (Aprovar ADR-023 + G-HRB)**: **APROVAR**. A integridade de hearback mitiga efetivamente o "Teatro de 3º Nível" ao forçar commits puros e separados. O aviso explícito sobre autoria é a abordagem técnica correta para o cenário de identidade única atual.
* **EF4 (Aprovar Marginais e Ajustes)**: **APROVAR**. Os bugs marginais levantados nas re-auditorias 0025 e 0026 foram todos sanados no diff atual e o drift de índices foi resolvido.

---

## VETO_ADOÇÃO: não

---

## Recomendação para humano (<=10 linhas)

O fechamento da Corrente E (Blocos 3-6) foi executado com rigor e honestidade técnica. Os novos guards G-SLF e G-HRB funcionam como especificado e a suíte com 29 testes negativos prova a eficácia mecânica contra a forja simples de hearbacks e caminhos falsos. O ADR-023 assume corretamente os limites lógicos do shell compartilhado, devolvendo ao seu olhar cético no diff de `.hbn/hearbacks/` a responsabilidade final pela validação. Recomenda-se aprovar o lote e adotar o checkpoint. Para a próxima janela, priorize a cobertura de testes negativos dos 5 guards legados para ativar globalmente o runner no pré-commit.
