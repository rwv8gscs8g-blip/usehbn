---
titulo: "Declaração de leitura das regras — orquestrador provisório"
tipo: state-report
status: congelado
temperatura: glacier
path: .hbn/messages/20260630-211500-codex-declaracao-leitura-regras-orquestrador.md
created_at: "2026-06-30T21:15:00-03:00"
autor: codex
familia: OpenAI
papel: orquestrador-provisorio
---

SOU: codex · familia OpenAI · papel orquestrador-provisorio

# Declaração de leitura das regras

Estado: BLOQUEADO. Nenhum novo despacho, implementação, auditoria ou selagem deve
prosseguir até novo comando humano.

Declaro que li em disco a read-list de entrada e os complementos diretamente
aplicáveis ao comportamento do orquestrador nesta janela:

- `.hbn/relay/STATE.md`
- `.hbn/readbacks/0105-onda-repoint-state-p2c2-fechado.json`
- `core/role-cards.md`
- `agents/codex.md`
- `agents/wave-protocol.md`
- `agents/role-templates.md`
- `.hbn/knowledge/0001-comandos-atomicos-copiaveis.md`
- `.hbn/knowledge/0002-entrega-operacional-minimalista.md`
- `.hbn/knowledge/0022-firewall-workflow-fast-track.md`
- `.hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md`
- `.hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md`
- `.hbn/knowledge/0025-auditor-read-only-sem-no-verify.md`
- `.hbn/knowledge/0029-lei-submissao-pelo-exemplo.md`
- `core/orchestrator-profile-spec.md`
- `core/relay-spec.md`
- `core/read-list-canonica.txt`
- `.hbn/messages/20260626-220000-opus-4-8-handoff-orquestrador-pos-p2b-install.md`
- `.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md`
- `guards/assert-copy-block.sh`
- `methodology/adr/ADR-022-saida-de-auditoria-legivel.md`
- `REGISTRY.md`
- `guards/assert-auditor-id.sh`
- `guards/assert-registry-line.sh`
- `guards/assert-quorum-selagem.sh`

Regras extraídas:

1. O orquestrador é zelador pelo exemplo: obedece as barreiras antes de
   mantê-las.
2. A única ação legal por turno é executar exatamente o `proximo_ponto` do
   STATE.
3. Um passo por vez; um bloco HBN-COPY por passo.
4. Todo despacho/prompt precisa estar inteiro no chat, copiável, e também salvo
   em `.md` quando virar artefato de orquestração.
5. Auditor deposita parecer em `.hbn/results/AAAAMMDD-HHMMSS-<apelido>-cross-ia-<onda>.md`.
6. Resultado de auditoria precisa de `.md` legível, `SOU`, frontmatter
   canônico, veredito `APROVA_NNNN: SIM|NAO`, evidências e linha no `REGISTRY`
   quando for formalmente versionado.
7. Auto-certificação é nula: ratificação exige pelo menos duas famílias válidas
   distintas do implementador e gate humano.
8. Human gate não substitui auditoria cruzada em ação crítica.
9. Guard que bloqueia implica parar e relatar; não contornar.
10. Nenhum conhecimento único deve ser apagado, movido ou despromovido sem
    manifesto, sucessor, rollback, auditoria cruzada e gate humano.

Correção de comportamento adotada:

- Próximos prompts/despachos serão entregues como bloco integral copiável no
  chat e salvos em `.md`.
- Nenhum parecer colado apenas no chat/anexo será contado como quorum formal até
  existir como artefato canônico em `.hbn/results/` com identidade e registro.
- Nenhuma selagem será proposta por mim sem evidência em disco, quorum formal e
  decisão humana explícita.

Fim da declaração. Próxima ação depende de novo comando humano.
