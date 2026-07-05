# 0002 — Onda do Bastao: Fundacao v0.3.0 (Honest Foundation)

**Bastao:** claude-opus-4.7 (architect)
**Estado:** ativo
**Criado:** 2026-04-29T05:30:00Z
**Atualizado:** 2026-04-29T05:30:00Z

## Contexto Recebido

- Diagnostico arquitetural consolidado e aprovado pelo humano (Luis Mauricio).
- Insumos: HBN-ARCHITECTURAL-REVIEW-2026-04.md, AUDITORIA_SUPERPOWERS.md, reports/HBN-ERP-HARDENING-AUDIT.md, reports/HBN-SUPERPROMPT-ARQUITETURAL.md, docs/CASE-STUDY-CREDENCIAMENTO.md, leitura direta do codigo.
- Respostas humanas as 20 perguntas obrigatorias incorporadas (ver bloco "Decisoes Humanas Vinculantes" abaixo).

## Objetivo desta Iteracao

Depositar a infraestrutura doutrinaria minima e suficiente para que o Codex execute as 8 ondas de v0.3.0 sem improviso, sem renomeacao silenciosa de termos canonicos, e sem expansao de superficie.

## O Que Foi Feito (architect, sem tocar em codigo)

- Atualizacao de `.hbn/relay/INDEX.md` (este arquivo passa a ser a iteracao ativa).
- Criacao de `agents/wave-protocol.md` (protocolo canonico de execucao em ondas; restricoes obrigatorias para qualquer IA executora).
- Criacao de `docs/MATURITY-MATRIX.md` (tabela viva por componente: Implementado/Parcial/Scaffold/Stub/Visao; regra de evolucao de estado).
- Criacao de `docs/PHAGOCYTOSIS.md` (doutrina de incorporacao progressiva de tecnologia: routed → studied → digested → mastered → contributed; conexao com Universal Translator e com Connector Lifecycle).
- Criacao de `docs/rfc/RFC-0001-enforce-mode.md` (RFC para modo `--enforce` opt-in de Guardian e Truth Barrier; semantica de bloqueio apos avisos fortissimos; configuracao via `.hbn/policy/enforcement.json`).
- Criacao de `docs/PUBLISHING-DECISION.md` (resposta Q13: TestPyPI primeiro com justificativa; plano de transicao para PyPI; ambos os nomes `hbn` e `usehbn` permanecem equivalentes em CLI por decisao humana).

## Decisoes Humanas Vinculantes (registro normativo)

| # | Pergunta | Decisao |
|---|----------|---------|
| 1 | `state/`/`logs/` no root sao legado a migrar? | Sim |
| 2 | Compatibilidade dual por 1 versao minor? | Sim |
| 3 | Adicionar `protocol_version` opcional em readback/result em v0.3.0? | Sim |
| 4 | Bump major (v1.0.0) quando virar required? | Sim |
| 5 | Guardian/Truth Barrier: abrir RFC para `--enforce` opt-in agora? | Sim — RFC-0001 aberto |
| 6 | Modo `--enforce` pode bloquear apos avisos fortissimos? | Sim |
| 7 | Citar Credenciamento publicamente? | Sim |
| 8 | Reproduzir metricas do case-study em release notes? | Sim, com fonte |
| 9 | Congelar superficie da CLI em v0.3.0? | Sim, evolucao posterior |
| 10 | Manter `usehbn` e `hbn` como nomes equivalentes? | Sim, sempre. `usehbn` e a forma semantica humana e tem prioridade sobre tecnologia |
| 11 | Termos doutrinarios | Mantidos. Revisao recorrente conforme evolucao dos LLMs |
| 12 | Universal Translator | **Mantido**. Nome preserva visao. Documentar honestamente que hoje e roteador e que evolui via Phagocytosis |
| 13 | TestPyPI vs PyPI | TestPyPI primeiro (resposta documentada em docs/PUBLISHING-DECISION.md) |
| 14 | Nome canonico do pacote | Ambos `hbn` e `usehbn` chamaveis sempre |
| 15 | Licenca AGPLv3 | Permanece. Contagia tudo. "Para a humanidade, pela humanidade" |
| 17 | Default `allow_remote_lookup = false` | Sim |
| 18 | Telemetria anonima vetada permanentemente? | Sim |
| 19 | Autoridade final | Luis Mauricio Junqueira Zanin (mantenedor unico). Aceita contribuicoes tecnicas |
| 20 | RFC process oficial | Apenas planejado em v0.3.0; entra em v0.4.0 |

## Lista Doutrinaria Imutavel (v0.3.0)

Estes termos NAO podem ser renomeados, traduzidos para outras palavras-chave, ou substituidos em codigo, schemas ou docs sem RFC + bump de major:

`Readback`, `Hearback`, `Guardian`, `Truth Barrier`, `ERP`, `Relay`, `Baton`, `Consent`, `Handoff`, `Track` (`fast_track`/`safe_track`), `Universal Translator`, `Phagocytosis`, `usehbn`, `hbn`, `use hbn`.

## Proximo Passo

1. **Hearback humano** sobre os 6 artefatos depositados nesta iteracao (validar conteudo).
2. Apos Hearback `confirmed`: passar bastao para `codex` com o superprompt da **Onda 1 (Honestidade Narrativa)**.
3. Codex executa Onda 1 → cria proprio Readback → recebe Hearback → grava ERP → devolve bastao para `humano`.
4. Humano decide quando devolver bastao para `claude` (auditoria) ou seguir direto para Onda 2.

## Pendencias

- Aguardando Hearback humano para liberar Onda 1.
- RFC-0001 (`--enforce`) aberto para janela de comentarios humanos antes de qualquer execucao.
- Decisao Q13 documentada mas precisa Hearback explicito.

## Riscos

- R1: Codex pode tentar refatorar codigo durante onda de documentacao. Mitigacao: lista de arquivos proibidos por onda + grep de termos doutrinarios.
- R2: Renomeacao silenciosa de "Universal Translator" no codigo. Mitigacao: termo na lista imutavel.
- R3: Inflacao narrativa acidental ao explicar Phagocytosis. Mitigacao: doutrina marca explicitamente o que existe vs. o que e visao.

## Decisoes Tomadas (architect)

- Universal Translator e Phagocytosis sao conceitos COMPLEMENTARES: o primeiro e a porta de entrada (roteamento honesto); o segundo e o caminho de incorporacao progressiva de conhecimento de tecnologia.
- Modo `--enforce` nao entra em v0.3.0. Apenas RFC-0001 e aberto.
- Compatibilidade `state/` legado fica em v0.3.0 e e removida em v0.4.0 (janela 1 versao minor).
- Doctor passa a reportar inventario de outbound em onda dedicada (Onda 8) — sem alterar comportamento de remote.py.
