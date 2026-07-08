---
path: inbox/credenciamento/20260703-0188-codex-proposta-perfil-consumidor-v2-contencao.md
titulo: "Proposta Credenciamento - perfil consumidor v2 com contencao de orquestracao"
diataxis: proposal
status: congelado
temperatura: glacier
created_at: 2026-07-03T01:55:00-03:00
origem_repo: /Users/macbookpro/Projetos/Credenciamento
origem_readback: .hbn/readbacks/0188-rb-instalacao-contencao.json
hearback_ref: .hbn/hearbacks/0188-hb-decisao-catalogo-contencao.json
autor: codex
---

# Proposta de perfil consumidor v2 para Credenciamento

## Problema

O perfil atual do Credenciamento exclui 13 guards de orquestracao apesar de
eles existirem no snapshot. A exclusao nao tem decisao humana verificavel no
periodo auditado. Pelo decreto do gate, exclusao de guard e decisao exclusiva
do humano e precisa de hearback-artefato.

## Proposta

O perfil v2 deve incluir a superficie de orquestracao por padrao. Uma exclusao
so e valida quando trouxer estes campos:

- `guard`: nome do guard excluido.
- `motivo`: justificativa operacional objetiva.
- `autorizado_por_humano`: nome do gate humano.
- `hearback_ref`: arquivo em `.hbn/hearbacks/*.json` com `status: confirmed`.
- `validade`: onda, data ou condicao de expiracao.

Um guard novo `assert-profile-authorized` deve bloquear qualquer perfil que
declare exclusao sem `autorizado_por_humano` e `hearback_ref` verificavel.

## Perfil alvo

```yaml
surface: core methodology schemas guards orchestration
guards_projeto:
  - assert-canonical-root
  - forbid-tmp-worktree
  - forbid-env-files
  - forbid-legacy-paths
  - assert-scratch-lock
  - assert-scratch-symlink
  - assert-scratch-ignore
  - assert-zona-livre
  - assert-scope-lock
  - assert-hearback-integrity
  - assert-no-stray-hbn
  - assert-self-path
  - assert-trailers-contiguous
  - assert-report-fresh
  - assert-readlist-rite
  - assert-knowledge-index
guards_orquestracao:
  - assert-orq-entrada
  - assert-orq-entrada-ref
  - validate-dispatch
  - assert-dispatch-integrity
  - assert-registry-line
  - assert-pointer-honest
  - assert-arvore-label
  - assert-auditor-id
  - assert-audit-diversity
  - assert-quorum-selagem
  - assert-parallel-id
  - freeze-gate
  - assert-baton-token
guards_excluidos: []
exclusoes_autorizadas: []
```

## Compatibilidade

Enquanto o perfil v2 nao for adotado pelo genoma, o Credenciamento executa a
contencao local por runner endurecido na Onda 0188. Essa ponte e deliberada:
snapshot permanece read-only, e a melhoria do protocolo entra por inbox.
