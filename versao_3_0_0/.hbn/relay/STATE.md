---
titulo: "STATE — useHBN v3.0.0 (SELADA; Onda 0 — verdade pós-release + jaula)"
tipo: estado
status: ativo
temperatura: quente
path: .hbn/relay/STATE.md
created_at: "2026-07-10T04:05:14-03:00"
autor: claude-opus-4-8
familia: Anthropic
natureza: nativo
state_version: 1
projeto: usehbn (canônico)
protocolo: "useHBN v3.0.0 — terceira exúvia SELADA (3df71e8; tag v3.0.0; contida em main@fcd149d, árvore idêntica)"
onda_atual: "ONDA 0 (verdade pós-release): reconciliar o livro-razão quente com a selagem — STATE/ROADMAP/readbacks/read-list coerentes com 3df71e8; internalização das provas externas; triagem da working tree suja. Preparada por claude-opus-4-8 (orquestrador contido, Decreto Art. 2), staging seletivo, SEM commit."
transicao: "nenhuma (versão selada; sem exúvia pendente — G-NO-PENDING-EXUVIA verde)"
hearback_ref: .hbn/readbacks/0003-proveniencia-livro-razao.json
readback_ativo: ".hbn/readbacks/0003-proveniencia-livro-razao.json"
handoff_mais_recente: ".hbn/messages/20260706-001951-codex-handoff-onda-0003.md"
bastao_token_sha256:
proprietario_bastao: nenhum
papel_bastao: nenhum
modo_educacional: "intermediário"
papeis:
  orquestrador: "claude-opus-4-8 (Anthropic) — relator não-decisório sob Decreto; prepara este rito e o dispatch da jaula; não commita, não sela, não autoriza"
  implementador_jaula: "codex (OpenAI) — implementará a spec da jaula (.hbn/messages/20260710-022436-fable5-spec-jaula-definitiva-orquestrador.md) sob readback próprio, escopo fechado"
  auditores_validadores: "≥2 famílias != OpenAI e != implementador (Antigravity/Google + Grok/xAI + Jules/Google) por onda"
  gate_humano: "Maurício — confirma readbacks/hearbacks e executa o commit único de rito; nenhuma IA commita"
proxima_acao: "Operador humano executa o commit unico de rito da Onda 0 (runner verde), reconciliando o ledger com a selagem 3df71e8/v3.0.0; depois o Codex constroi a jaula antes da Onda 1 (corte e exuvia v4 seguem NO-GO)."
roadmap_ativo: "ROADMAP.md"
proximo_ponto:
  passo: "Hearback do gate e commit unico de rito da Onda 0 pelo operador"
  ato: hearback
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/readbacks/0003-proveniencia-livro-razao.json
  status: pendente
sinais_abertos:
  - "🟢 v3.0.0 SELADA — 3df71e8 (tag v3.0.0) contido em main@fcd149d com árvore idêntica (git diff --exit-code 3df71e8 fcd149d = vazio). Quórum 0001/0002/0003 resolvido: re-ratificações 20260707-171004 (xAI) e 20260707-171621 (Google) com APROVA_0001: SIM; 0002 e 0003 com ≥2 famílias != OpenAI APROVA SIM (REGISTRY.md)."
  - "🟡 ONDA 0 EM PREPARO — este STATE, ROADMAP, os 3 readbacks (campos required do schema) e o read-list (rehash) reconciliam a verdade pós-release. Entram no commit único de rito do operador; nada commitado pela IA."
  - "🟡 JAULA ESPECIFICADA, NÃO CONSTRUÍDA — contenção do orquestrador REPROVA contra adversário com escrita local (parecer Cobalto Q4). Pré-requisito da Onda 1 e de qualquer exúvia v4 com runtime. Dispatch ao Codex emitido nesta janela."
  - "🔴 NO-GO ao corte de leitura e à exúvia v4.0.0 AGORA — só após Ondas 0-1 + jaula construída (síntese §5; relatório de resolução §8). Decisão fundamentada, não omissão."
  - "🟡 CI (3ª barreira) — 3 defeitos de camada corrigidos nesta sessão (ci-entry.sh + lib/common.sh, endurecimento, sem enfraquecer guard); o defeito (d) de semântica de diff-range é mudança de TCB → onda sob rito (Onda 1), não fix unilateral."
  - "🟡 DEPENDÊNCIA EXTERNA REBAIXADA — provas/Decreto de ~/Projetos/Credenciamento internalizados em .hbn/knowledge/0035 (resumo normativo + sha256); refs de TRANSICAO/BOOT rebaixadas a histórico/consulta."
ultima_atualizacao: "2026-07-10T04:05:14-03:00"
atualizado_por: claude-opus-4-8
atribuicao:
  chapeu_atual: nenhum
  implementador: fable-5
  auditores:
    - antigravity
    - grok
---

# STATE — useHBN v3.0.0 (SELADA · Onda 0)

## Resumo executivo

1. **A terceira exúvia está SELADA** em `3df71e8` (tag `v3.0.0`), contida em
   `main@fcd149d` com árvore idêntica (`git diff --exit-code 3df71e8 fcd149d`
   vazio, exit 0). O quórum 0001/0002/0003 está resolvido (REGISTRY.md).
2. Esta **Onda 0** reconcilia o livro-razão quente com a selagem: este STATE,
   o `ROADMAP.md`, os 3 readbacks (campos `required` do schema) e o
   `read-list-canonica.txt` (rehash real) deixam de narrar o estado
   pré-selagem. Provas externas internalizadas em `.hbn/knowledge/0035`.
3. **Próxima ação única**: o operador humano (Maurício) executa UM commit de
   rito com runner verde, incorporando a Onda 0 + a esteira legítima da
   sessão (pareceres pré-corte relocados, síntese, relatório de resolução,
   spec da jaula, handoffs, fixes de CI). Nenhuma IA commita.
4. **Depois do commit**: o Codex constrói a JAULA (spec pronta) antes de
   qualquer reintrodução de escrita/runtime. Corte de leitura e exúvia v4 são
   **NO-GO agora** — só após Ondas 0-1 + jaula (síntese §5).

## Ponteiros

- Readback confirmado mais recente: `.hbn/readbacks/0003-proveniencia-livro-razao.json`
- Handoff da retomada: `.hbn/messages/20260710-024629-fable5-handoff-orquestrador-onda0-jaula.md`
- Síntese + cut-list definitiva: `.hbn/results/20260710-022436-fable5-sintese-adversarial-pre-corte-cutlist-definitiva.md`
- Relatório de resolução (ondas 0-8): `.hbn/messages/20260710-022436-fable5-relatorio-resolucao-integral-pre-corte.md`
- Spec da jaula (para o Codex): `.hbn/messages/20260710-022436-fable5-spec-jaula-definitiva-orquestrador.md`
- Provas externas internalizadas: `.hbn/knowledge/0035-decreto-e-provas-externas-internalizadas.md`
- Roadmap de retomada: `ROADMAP.md`
