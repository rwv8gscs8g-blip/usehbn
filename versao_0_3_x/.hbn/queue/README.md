---
titulo: Queue do arquiteto — backlog como estado em arquivo (ADR-013 Decisão 1)
status: congelado
temperatura: glacier
data: 2026-06-10
autoria: claude-fable-5 (corrente C4)
origem: decomposição do PROMPT_ARQUITETO_USEHBN_AUTONOMO.md v1.6 §4 (trilhas A–G; F1–F3 recorrentes ficaram na cadência, não na fila)
---

# .hbn/queue/ — a fila do arquiteto

1 item = 1 arquivo `NNN-<slug>.json`. O prompt do arquiteto não carrega mais
backlog: o ciclo lê a fila, pega o menor `NNN` elegível (status `pending`,
sem `bloqueado_por` aberto, sem `bloqueio_externo` ativo) e segue o rito da
classe (`A` lote/rampa, `B` hearback individual — ADR-013).

Campos: `queue_id`, `tema`, `origem`, `projeto_alvo`, `classe` (A|B),
`status` (pending|in_progress|done|dropped), `bloqueado_por` (ids),
`bloqueio_externo` (texto), `nota`.

Mudança de estado de item = edição do JSON no commit do ciclo (classe A,
mecânica). Item novo: próximo NNN livre = `ls | sort | tail -1`. Itens 014 e
015 já nasceram `done` — entregues pela corrente C3 (sync schemas/guards),
pendentes do hearback do lote.
