# Análise profunda — Exúvia como renovação ESTRUTURAL (não preservação com retoque)

Disparada por correção do gate humano (2026-06-14): a estrutura MUDA na muda. 20 pastas podem virar 5,
renumeradas e simplificadas; docs renascem com nova data + proveniência; a IA nova lê SÓ a pasta da
versão vigente, não arqueologia de tags. Documento de discussão; precede a implementação.

## 0. Onde eu errei (honesto)
Meu plano v2 tratou a muda como "preservar + reorganizar um pouco" (tag git + módulos). Isso
subaproveita a Exúvia. O valor real: a muda é a **única janela para refazer a forma** — simplificar,
renumerar, reescrever — acompanhando o aumento de entendimento e de capacidade de processamento.

## 1. Precedente de fronteira (valida sua visão)
- **Docusaurus** versiona snapshotando a árvore INTEIRA em `versioned_docs/version-X/`, com `versions.json`;
  o trabalho ativo fica em `docs/`. É exatamente "tudo da versão numa pasta numerada navegável".
- **Monorepo/Git**: muitas tags degradam o repo (lentidão até em `git status`); pastas-snapshot +
  arquivo de índice de versões são preferíveis. Confirma "não dezenas de milhares de tags".
Conclusão: o modelo de **snapshot por pasta numerada + índice de versões + ativo restruturável** é
padrão estabelecido. Adotá-lo é fagocitose de um padrão maduro.

## 2. Os problemas a resolver (com alternativas)

### P-A. Versão ativa auto-contida (a IA nova lê só ela)
A IA nova deve ler SÓ a estrutura da versão vigente — self-contained.
- Alt 1 (recomendada): ativo na **raiz** (como `docs/` do Docusaurus); a read-list aponta só para a
  forma vigente; exúvias ficam fora da read-list (consulta sob demanda). Hooks/paths estáveis.
- Alt 2: ativo dentro de `protocol-1.0.0/`. Mais literal ao "pasta numerada", porém move TODOS os
  paths de guards/hooks a cada muda (churn + risco). Docusaurus deliberadamente NÃO faz isso.

### P-B. Mudança de estrutura SEM vácuo de enforcement
Se a estrutura muda (pastas renomeadas/reduzidas), os guards/hooks precisam ser **reescritos para a
nova forma no MESMO corte**, atomically, suíte verde antes de aceitar. (É o "guards na virada",
agora maior.) Sem isso, há janela sem enforcement — inaceitável (P10).

### P-C. Docs renascidos com nova data + proveniência
Carry-forward = cópia com **nova data de nascimento** (nascimento na versão nova) + campo
`origem: protocol-0.3.x/<path>@<data-antiga>`. O original permanece congelado na exúvia. Assim
renova-se sem quebrar o trilho (P1 nada se perde + rastreabilidade).

### P-D. O documento "de onde → para onde" (a manchete da muda)
Um doc único mapeia estrutura antiga → nova: o que mergeou, sumiu, renomeou, renumerou e por quê,
com a data da exúvia. É a ponte legível + o diff humano da muda. Substitui "ler tags": a IA que
quiser linhagem lê este doc, não o histórico git.

### P-E. Onde vivem as versões congeladas (anti-bloat)
- Agora (MVP, sem publicar): in-repo em `exuvias/protocol-0.3.x/` (cópia completa navegável) + um
  `EXUVIAS.md/json` índice. Duplica conteúdo, mas é navegável e simples.
- Quando publicar no GitHub: cada exúvia pode virar **fork/repo arquival separado** (seu instinto
  anterior) — o repo ativo fica enxuto; a exúvia vira referência imutável.
- Glacier: após N exúvias, a mais antiga desce ao arquivo frio profundo.

### P-F. A "constituição" reescrita com a data da exúvia
Os princípios (P1–P13 — a parte dura) **persistem**, mas o DOCUMENTO é reescrito/reorganizado na
forma nova, datado da exúvia, no local mais consultável da versão ativa. A redação anterior fica
congelada na exúvia. O conteúdo dos princípios não muda; a forma de apresentá-los, sim.

### P-G. Reversibilidade da muda inteira (P6)
Como a estrutura toda muda, o rollback é "voltar à âncora pré-muda". A exúvia (cópia completa) + o
commit-âncora garantem retorno. Testar o rollback antes de aceitar.

## 3. Modelo proposto (síntese — "Docusaurus para protocolo")
```
usehbn/                         ← raiz; hooks .git estáveis
  (forma ATIVA, restruturada e renumerada a cada muda — a IA nova lê SÓ isto)
  governanca/  orquestracao/  radar/  fagocitose/  hbn-exuvia/  runtime/ ...
  EXUVIAS.md                    ← índice de versões (tipo versions.json)
  exuvias/
    protocol-0.3.x/             ← cópia COMPLETA e navegável da forma antiga (congelada)
      DE-ONDE-PARA-ONDE.md      ← mapa estrutura antiga→nova + data da exúvia
      ...(estrutura inteira 0.3.x)...
```
- Ativo na raiz = hooks/paths estáveis; estrutura interna livre para simplificar a cada muda.
- Exúvia = pasta numerada navegável + entrada no índice; vira fork separado quando publicar.
- IA nova lê só a forma ativa; exúvia é consulta sob demanda (nunca read-list quente).
- Carry-forward com nova data + proveniência; constituição reescrita datada; "de-onde-para-onde" é a ponte.

## 4. Perguntas em aberto para o cross-audit decidir
1. Ativo na raiz (Alt 1) vs dentro de `protocol-1.0.0/` (Alt 2) — trade-off churn/paths vs literalidade.
2. Exúvia in-repo agora vs já mirar fork separado (depende de quando publicar no GitHub).
3. Como reescrever guards/hooks atomically sem vácuo — sequência segura de commits.
4. Formato do índice de versões e do "de-onde-para-onde" (schema mínimo).
5. Como o glacier entra (após quantas exúvias; o que desce).
6. Regra de proveniência dos docs renascidos (campo padrão; o guard que a fiscaliza, se houver).

## 5. Recomendação
Adotar o **modelo da seção 3** (Docusaurus-para-protocolo) como base, decidir as 6 questões via
cross-audit (Codex + Gemini + 3ª IA), e SÓ DEPOIS reescrever o plano da muda (substituindo o alvo
modular do plano v2) e executar. Não executar nada antes de fechar a forma com auditoria.
