---
state_version: 1
projeto: usehbn (canônico)
protocolo: "useHBN v3.0.0 — terceira exúvia (G-HOT-WRITE + exúvia atômica + membrana com contrato explícito + BOOT-LOCK)"
onda_atual: "GÊNESE v3.0.0 — terceira exúvia preparada por fable-5 sob despacho do antigravity (Decreto 20260703-000500). Working tree completa; commit pendente do operador humano."
transicao: hot-write-exuvia
hearback_ref: .hbn/readbacks/0001-terceira-exuvia-genese.json
readback_ativo: ".hbn/readbacks/0001-terceira-exuvia-genese.json"
handoff_mais_recente: nenhum
bastao_token_sha256:
proprietario_bastao: nenhum
papel_bastao: nenhum
modo_educacional: "intermediário"
papeis:
  arquiteto: "pendente — designado pelo próximo orquestrador (Claude Opus) na fase de ativação (ROADMAP.md §1)"
  implementador_da_exuvia: "fable-5 (Anthropic) — gênese v3.0.0, sem bastão herdado"
  auditores_validadores: "pendente — auditoria cruzada da terceira exúvia por 2 famílias independentes (Gemini e Grok) antes do flip"
  gate_humano: "Maurício — único autorizado a confirmar o readback 0001 e executar o commit atômico da exúvia"
proxima_acao: 'ATIVAÇÃO DA TERCEIRA EXÚVIA (ROADMAP.md §1): (1) auditoria cruzada por Gemini e Grok com APROVA em .hbn/results/; (2) Maurício confirma o readback 0001 (human_status: confirmed); (3) UM commit atômico com todo o staging (glacier + v3 + flip do ponteiro). Nada além disso até o flip.'
roadmap_ativo: "ROADMAP.md"
proximo_ponto:
  passo: 'Ativação do v3.0.0 — auditoria cruzada (Gemini + Grok) + confirmação humana do readback 0001 + commit atômico único da exúvia'
  ato: hearback
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/readbacks/0001-terceira-exuvia-genese.json
  status: pendente
sinais_abertos:
  - "🔴 EXCEÇÃO F-01 EM CURSO (PROPOSED_UNTIL_CROSS_AUDIT) — implementador da exúvia (fable-5) é o mesmo agente do readback 0001: gênese sem bastão herdado, autorizada pelo super-prompt do antigravity sob Decreto 20260703-000500. Adoção exige 2 pareceres APROVA_0001: SIM de famílias ≠ Anthropic/OpenAI em .hbn/results/ + confirmação humana do readback (human_status: confirmed) antes do commit atômico."
  - "🟡 EXÚVIA EM PREPARAÇÃO — versao_3_0_0 completa na working tree (Cold Core consolidado de versao_2_0_0 + guards estruturais da raiz); versao_0_3_x e versao_2_0_0 congeladas (glacier); raiz esvaziada com shims mínimos. NADA COMMITADO."
  - "🟡 AUDITORIA PENDENTE — 2 famílias independentes (Gemini, Grok) devem depositar APROVA em .hbn/results/ antes do gate humano (ROADMAP §1)."
  - "🟡 INCIDENTES ABERTOS — 110632/110633 + irmãos da sessão anterior ficam para o saneamento do legado (ROADMAP §3); nada foi apagado."
ultima_atualizacao: "2026-07-05T02:30:00-03:00"
atualizado_por: fable-5
atribuicao:
  chapeu_atual: implementador-da-exuvia
  implementador: fable-5
  auditores:
    - gemini-3-5
    - grok
---

# STATE — useHBN v3.0.0 (gênese da terceira exúvia)

## Resumo executivo (≤ 30 linhas)

1. **O que é este estado**: gênese da `versao_3_0_0`, preparada por fable-5
   em uma única passada limpa no disco, sob o super-prompt do antigravity
   aprovado pelo gate (Decreto 20260703-000500 vigente).
2. **Por quê**: o relatório crítico 20260705-001142 (Claude Opus) provou que
   a `versao_2_0_0` nunca foi ativada e que semanas de trabalho correram na
   versão errada (raiz). Pareceres antigravity (20260705-002500) e grok
   (20260705-014500) confirmaram e endureceram o desenho.
3. **O que mudou**: G-HOT-WRITE (escrita só na versão quente, sem bypass),
   G-NO-PENDING-EXUVIA (nunca mais um `proposto` pendurado), exúvia atômica
   (`scripts/hbn-exuvia-atomic.sh`), membrana com contrato explícito
   (`membrane/` + `scripts/hbn-upgrade-snapshot.sh`) e BOOT-LOCK (BOOT.md §0).
4. **Readback ativo**: `.hbn/readbacks/0001-terceira-exuvia-genese.json`
   (human_status: pendente — o gate confirma para autorizar o flip).
5. **Próxima ação (ÚNICA)**: ver `proxima_acao` acima. Depois do flip, o
   próximo orquestrador (Claude Opus) segue `ROADMAP.md` passo a passo.

## Ponteiros

- Roteiro de retomada: `ROADMAP.md`
- Justificativa da exúvia: `TRANSICAO.md`
- Porta de entrada: `BOOT.md` (com BOOT-LOCK §0)
- Livro-razão: `REGISTRY.md`
