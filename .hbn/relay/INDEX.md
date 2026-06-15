# HBN Relay — Índice Operacional

**Status:** superseded como fonte de estado  
**Fonte canônica:** `.hbn/relay/STATE.md`  
**Última reconciliação:** 2026-06-14T22:24:37-03:00  
**Reconciliação:** S0 — rollback, perfis e INDEX

Este arquivo é apenas um ponteiro de orientação. O estado operacional vigente
do protocolo fica em `.hbn/relay/STATE.md`, inclusive bastão, onda atual,
readback ativo, handoff recente e próxima ação.

## Snapshot reconciliado do STATE

| Campo | Valor |
|---|---|
| Projeto | usehbn (canônico) |
| Protocolo | HBN 0.3.0 (modelo versão=pasta; M-A scaffold inativo) |
| Onda atual | M-A — scaffold inativo da hbn-exuvia |
| Bastão | codex |
| Papel do bastão | implementador |
| Roadmap ativo | M-A scaffold inativo; M-B Ponte/prova; M-C 1ª exúvia do protocolo; revalidar Credenciamento; M-F exúvia do Credenciamento |

## Leitura Obrigatória Para Novas IAs

1. `.hbn/relay/STATE.md` — fonte canônica de estado.
2. Readback ativo indicado em `STATE.md`.
3. Handoff mais recente indicado em `STATE.md`.
4. `REGISTRY.md` — livro-razão de artefatos governados.

## Nota De Supersedência

O INDEX antigo apontava bastão `claude-opus-4.7`, data de abril de 2026 e
iteração ativa incompatíveis com o STATE real de junho de 2026. Esses dados não
devem ser usados para handoff; qualquer janela nova deve reconciliar pelo
`STATE.md`.
