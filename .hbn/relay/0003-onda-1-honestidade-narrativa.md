# 0003 — Onda 1: Honestidade Narrativa
**Bastão:** codex
**Estado:** ativo
**Criado:** 2026-04-29T06:36:41Z

## Contexto Recebido
Bastão recebido de claude-opus-4.7 após iteração 0002. Onda 1 aprovada por Hearback humano em `.hbn/relay/INDEX.md`, que registra: "Hearback | confirmado para iteracao 0002 (architect deposit) e Onda 1". Objetivo: alinhar README, ARCHITECTURE, UNIVERSAL-TRANSLATOR, CONNECTORS e RUNTIME-ADAPTERS à MATURITY-MATRIX.md sem tocar em código.

Leitura obrigatória realizada, com os seguintes trechos normativos usados como base:

- `agents/wave-protocol.md`: "Pulei algum gate = onda invalida. Roll back imediato." e "A IA executora PARA aqui. Nao prossegue sem Hearback humano explicito."
- `docs/MATURITY-MATRIX.md`: "Documento normativo: o README e os docs publicos NAO podem afirmar nada que contradiga esta tabela."
- `docs/PHAGOCYTOSIS.md`: "Em `Routed`, e roteador puro." e "Afirmar capacidade que pertenca a estagio mais avancado do que o atual" e limite duro.
- `docs/PUBLISHING-DECISION.md`: "TestPyPI primeiro. PyPI estavel apenas apos smoke test em 3 OSes e Hearback humano explicito." e "`hbn` e `usehbn` sao chamaveis sempre, de forma igual."
- `docs/rfc/RFC-0001-enforce-mode.md`: "Esta RFC NAO autoriza implementacao em v0.3.0."
- `.hbn/relay/INDEX.md`: "codex deve: ... Criar `.hbn/relay/0003-onda-1-honestidade-narrativa.md` (Readback inicial). PARAR."
- `.hbn/relay-archive/20260429T0530-0002-onda-bastao-claude-v0.3.0-foundation.md`: "Universal Translator e Phagocytosis sao conceitos COMPLEMENTARES."
- `README.md`: "This repository is not a hosted orchestration platform."
- `docs/ARCHITECTURE.md`: "minimal implementation scaffold for the protocol, not a full execution engine."
- `docs/UNIVERSAL-TRANSLATOR.md`: "This is not the final translator."
- `docs/CONNECTORS.md`: "Connectors are **not** silent downloaders. They are governed bridges."
- `docs/RUNTIME-ADAPTERS.md`: "They do not create native integration by themselves."
- `src/usehbn/__init__.py`: versão real lida como `__version__ = "0.2.0"`.
- `src/usehbn/execution/engine.py`: `_validation_summary` agrega `warnings` e retorna `"warn" if warnings else "clear"`, sem bloqueio de Guardian ou Truth Barrier.

Observação operacional: o arquivo 0002 indicado no superprompt não existe em `.hbn/relay/` com esse nome ativo. O `INDEX.md` aponta a iteração concluída em `.hbn/relay-archive/20260429T0530-0002-onda-bastao-claude-v0.3.0-foundation.md`, que foi lida como fonte equivalente da iteração 0002.

## O Que Será Feito
Após Hearback humano explícito sobre este Readback, o diff planejado é:

- `README.md`
  - Inserir seção "Maturidade por Componente" próxima ao topo, com link para `docs/MATURITY-MATRIX.md` e resumo fiel dos estados Implementado, Parcial, Scaffold, Stub e Visão.
  - Ajustar "What Works Today" e "What Does Not Work Yet" para não prometer capacidades além da matriz.
  - Adicionar "Universal Translator (estado atual)" descrevendo o estado Routed como roteador honesto, sem tradução semântica.
  - Adicionar "Phagocytosis: como o HBN aprende novas tecnologias" com link para `docs/PHAGOCYTOSIS.md`.
  - Acrescentar nota em "Public Domains" preservando `usehbn` e `hbn` como nomes igualmente canônicos e citando `docs/PUBLISHING-DECISION.md`.

- `docs/ARCHITECTURE.md`
  - Mover/reformular "Current Non-Goals" para depois de "Components".
  - Citar `docs/MATURITY-MATRIX.md` como fonte de estado por componente.
  - Adicionar "Truth Barrier e Guardian: estado atual e direção", deixando claro que hoje são advisory e que enforcement depende de `docs/rfc/RFC-0001-enforce-mode.md` para v0.4.0.
  - Manter os 5 layers existentes sem renomear.

- `docs/UNIVERSAL-TRANSLATOR.md`
  - Reescrever o primeiro parágrafo para afirmar que, em v0.3.0, o Universal Translator é Environment Router + Connector Resolver.
  - Declarar explicitamente que não realiza tradução semântica entre línguas humanas ou tecnologias.
  - Adicionar seção "Estágios de Phagocytosis aplicados ao Translator" com o caminho Routed -> Studied -> Digested -> Mastered -> Contributed.
  - Não alterar nomes de funções, classes ou código.

- `docs/CONNECTORS.md`
  - Adicionar nota inicial informando que Connectors em v0.3.0 operam em estágio Routed.
  - Explicar que lifecycle states formais começam a ser registrados na Onda 4 sem enforcement.
  - Marcar "Approval Rules" com aviso de que enforcement real depende de RFC-0001 e fica em v0.4+.

- `docs/RUNTIME-ADAPTERS.md`
  - Adicionar parágrafo inicial dizendo que adapters são arquivos de instrução em filesystem, não plugins nativos.
  - Declarar que a execução real depende de cada runtime ler e respeitar essas instruções.
  - Citar estado atual como Implementado conforme `docs/MATURITY-MATRIX.md`.

- `CHANGELOG.md`
  - Adicionar somente a entrada `## [Unreleased] — Onda 1: Honestidade Narrativa`, com os três bullets de mudança exigidos no superprompt.

## O Que NÃO Será Feito
- Não alterar nenhum arquivo em `src/`, `schemas/`, `core/`, `tests/`, `.github/`, `reports/`, `pyproject.toml`, `setup.cfg`, `get-hbn`, `.hbn/state/`, `.hbn/connectors/`, `.hbn/readbacks/`, `.hbn/results/` ou `docs/CASE-STUDY-CREDENCIAMENTO.md`.
- Não renomear termos doutrinários: Readback, Hearback, Guardian, Truth Barrier, ERP, Relay, Baton, Consent, Handoff, Track (fast_track/safe_track), Universal Translator, Phagocytosis, usehbn, hbn, use hbn.
- Não renomear funções, classes, subcomandos públicos ou arquivos fora do escopo.
- Não adicionar, remover ou alterar dependências.
- Não criar arquivos fora do Readback obrigatório e dos arquivos alvo permitidos pelo superprompt.
- Não implementar RFC-0001, enforcement, lifecycle FSM, verify automático, publicação TestPyPI/PyPI, código de bridge executável ou mudanças de runtime.
- Não fazer commit, push ou abrir PR.

## Riscos
- Risco 1: inflar a narrativa do Universal Translator além do estado Scaffold/Routed. Mitigação: usar `docs/MATURITY-MATRIX.md` e `docs/PHAGOCYTOSIS.md` como fontes normativas e escrever em linguagem condicional para estados Scaffold, Stub e Visão.
- Risco 2: tocar acidentalmente em arquivos proibidos porque o worktree já contém mudanças pré-existentes em áreas fora da onda. Mitigação: limitar edições aos arquivos alvo, verificar `git diff --stat` e parar se aparecer alteração nova fora do escopo da onda.
- Risco 3: introduzir sinônimos ou traduções que enfraqueçam termos doutrinários. Mitigação: preservar grafia exata dos termos imutáveis e rodar o grep obrigatório sobre o diff.
- Risco 4: confundir documentação de RFC aberta com autorização de implementação. Mitigação: citar RFC-0001 apenas como direção v0.4.0 e manter a onda como documentação somente.

## Próximo Passo após onda
Aguardar Hearback humano sobre este Readback. Após Hearback explícito, executar apenas os passos documentais autorizados, rodar verificações, gravar ERP, atualizar relay e devolver bastão ao humano.
