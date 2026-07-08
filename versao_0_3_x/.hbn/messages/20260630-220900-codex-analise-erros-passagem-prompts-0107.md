---
titulo: "Analise de erros na passagem de prompts — onda 0107"
tipo: state-report
status: congelado
temperatura: glacier
path: .hbn/messages/20260630-220900-codex-analise-erros-passagem-prompts-0107.md
created_at: "2026-06-30T22:09:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
relacionado:
  - .hbn/messages/20260630-213000-codex-plano-g-orq-xaudit-gate-0107.md
  - .hbn/messages/20260630-213100-codex-prompt-implementacao-g-orq-xaudit-gate-0107-antigravity.md
  - .hbn/messages/20260630-213200-codex-prompt-cross-audit-g-orq-xaudit-gate-0107-grok.md
  - .hbn/messages/20260630-213300-codex-prompt-cross-audit-g-orq-xaudit-gate-0107-claude.md
  - .hbn/results/20260630-213200-grok-cross-ia-g-orq-xaudit-gate-0107.md
  - .hbn/results/20260630-213300-claude-cross-ia-g-orq-xaudit-gate-0107.md
---

SOU: codex · familia OpenAI · papel orquestrador-provisorio

# Analise de erros na passagem de prompts — 0107

## Estado

0107 esta bloqueada. Nao houve implementacao de `G-ORQ-XAUDIT-GATE` em disco.
Os dois auditores fizeram o correto em chat novo: leram o disco, nao encontraram
o patch, e reprovaram.

## Evidencias lidas

- `guards/assert-orq-xaudit-gate.sh` nao existe (`test -f` retornou 1).
- `.hbn/messages/20260630-213100-antigravity-implementacao-g-orq-xaudit-gate-0107.md`
  nao existe (`test -f` retornou 1).
- Grok reprovou porque o guard, o readback e o handoff do implementador estao
  ausentes; `APROVA_0107: NAO`.
- Claude reprovou pelo mesmo motivo e apontou que o diff presente e de
  `G-STATE-STRUCTURAL`, nao de `G-ORQ-XAUDIT-GATE`; `APROVA_0107: NAO`.

## Erros do orquestrador provisório

1. Quebrei a sequencia da onda: entreguei prompts de auditoria junto com o
   prompt de implementacao. Como cada IA comeca em chat novo, os auditores nao
   sabiam que deveriam aguardar uma implementacao futura; auditaram o disco
   imediatamente.
2. Em uma unica resposta, dei tres blocos `HBN-COPY`. A W-LEX exige um passo por
   vez e um bloco por passo.
3. Os prompts de auditoria nao tinham precondicao fail-closed do tipo: "se
   `guards/assert-orq-xaudit-gate.sh` ou o handoff do implementador nao existir,
   pare e retorne BLOQUEADA, sem auditoria conclusiva de patch".
4. Os prompts de auditoria apontavam para um alvo pressuposto ("patch entregue
   por Antigravity") sem fornecer um artefato de entrega real: handoff do
   implementador, diff, arquivos tocados e saidas de teste.
5. Abri 0107 com a working tree ainda suja por outra onda (`G-STATE-STRUCTURAL`).
   Isso contaminou a leitura dos auditores e violou o proprio escopo proibido de
   0107, que listava `guards/assert-state-structural.sh` como proibido.
6. Eu reduzi/reescrevi os blocos no chat em vez de garantir que o conteudo
   colavel fosse exatamente o mesmo salvo no `.md`.
7. Falhei em tratar "chat novo, sem memoria" como contrato material: cada prompt
   precisa ser autocontido, declarar precondicoes, alvo verificavel, estado
   esperado do disco e condicao de parada.

## Regras corretivas

1. Nunca emitir prompt de auditoria antes de existir entrega de implementador em
   disco.
2. Em chat ao humano, entregar apenas o proximo bloco copiavel, nao a fila toda.
3. Todo prompt para IA externa comeca com "chat NOVO, sem memoria" e inclui
   preflight fail-closed.
4. Prompt de auditoria deve citar o handoff do implementador e o arquivo/guard
   que precisa existir; se nao existir, o auditor deve salvar parecer
   BLOQUEADO/NAO por alvo ausente, sem tratar isso como avaliacao do patch.
5. Nao abrir nova onda de guard enquanto a anterior esta suja, nao selada ou
   misturada no worktree.
6. O bloco colavel no chat deve ser verbatim do `.md`.

## Proximo passo recomendado

Nao seguir com 0107 agora. Primeiro decidir, com gate humano, se o patch
`G-STATE-STRUCTURAL` sera depositado/isolado/selado ou revertido da working
tree. Depois reemitir somente o prompt de implementacao de 0107, em chat novo,
com preflight de worktree limpa ou escopo explicitamente isolado.

Fim.
