---
titulo: "STATE — useHBN v3.0.0 (onda 0003, proveniência + autocontenção)"
tipo: estado
status: ativo
temperatura: quente
path: .hbn/relay/STATE.md
created_at: "2026-07-06T00:19:51-03:00"
autor: codex
familia: OpenAI
natureza: nativo
state_version: 1
projeto: usehbn (canônico)
protocolo: "useHBN v3.0.0 — terceira exúvia ATIVADA (commit a2eb6f2) + onda 0003 em working tree"
onda_atual: "ONDA 0003 (codex/OpenAI): padrão universal de proveniência do livro-razão, MANIFESTO-MIGRACAO, transcrição de documentos migrados, T-AUTO/autocontenção, G-PROV e G-SELF-CONTAINED estruturais. Readback 0003 pendente; nada commitado."
transicao: "proveniencia-livro-razao + hot-write-guard-change + hot-write-root-shim"
hearback_ref: .hbn/readbacks/0002-fechamento-pos-auditoria-v3.json
readback_ativo: ".hbn/readbacks/0003-proveniencia-livro-razao.json"
handoff_mais_recente: ".hbn/messages/20260706-001951-codex-handoff-onda-0003.md"
bastao_token_sha256:
proprietario_bastao: nenhum
papel_bastao: nenhum
modo_educacional: "intermediário"
papeis:
  orquestrador_seguinte: "claude-opus-4-8 (Anthropic) — orquestrador contido após commit/handoff, sem poder de selagem"
  implementador: "codex (OpenAI) — readback 0003, escopo fechado"
  auditores_validadores: "re-auditoria do delta combinado 0002+0003 por Grok/xAI + Antigravity/Google, famílias != OpenAI"
  gate_humano: "Maurício — confirma readbacks/hearbacks e executa commit; nenhuma IA commita"
proxima_acao: "Re-auditoria do delta combinado 0002+0003 por Grok e Antigravity; depois hearback humano dos readbacks 0002 e 0003; só então commit do operador com runner verde."
roadmap_ativo: "ROADMAP.md"
proximo_ponto:
  passo: "Re-auditoria 0003 + hearback humano dos readbacks 0002/0003"
  ato: hearback
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/readbacks/0003-proveniencia-livro-razao.json
  status: pendente
sinais_abertos:
  - "🔴 EXCEÇÃO F-01 (auto-direção): implementador == autor do readback ativo 0003 (codex). PROPOSED_UNTIL_CROSS_AUDIT — adoção exige 2 pareceres de famílias != OpenAI + hearback humano; re-auditado por grok/xAI e antigravity/Google."
  - "🔴 READBACK 0003 PENDENTE — safe_track; gate Maurício precisa confirmar antes de commit."
  - "🔴 READBACK 0002 PENDENTE — delta anterior continua na working tree e deve ser re-auditado junto."
  - "🔴 QUÓRUM 0001 SEM CONSENSO — grok 174859 (APROVA_0001: NAO) × antigravity 183900 (APROVA_0001: SIM); v3 não está selada."
  - "🟡 G-PROV NOVO — estrutural, sem bypass; exige re-auditoria por famílias != OpenAI."
  - "🟡 G-SELF-CONTAINED NOVO — estrutural, sem bypass; rejeita fonte vigente externa em documento governado."
  - "🟡 MEMBRANA — snapshot padrão agora inclui MANIFESTO-MIGRACAO.md e guards/ para propagar G-PROV + G-SELF-CONTAINED."
ultima_atualizacao: "2026-07-06T00:19:51-03:00"
atualizado_por: codex
atribuicao:
  chapeu_atual: implementador
  implementador: codex
  auditores:
    - grok
    - antigravity
---

# STATE — useHBN v3.0.0 (onda 0003)

## Resumo executivo

1. A terceira exúvia está ativa em `a2eb6f2`, mas ainda não está selada:
   auditoria 0001 ficou sem consenso.
2. A working tree contém o delta 0002 não commitado e a onda 0003 construída
   por cima dele.
3. Esta onda 0003 adiciona o padrão universal de proveniência do livro-razão,
   transcreve documentos migrados, cria `MANIFESTO-MIGRACAO.md`, incorpora
   T-AUTO/autocontenção e ativa os guards estruturais
   `assert-doc-provenance.sh` e `assert-version-self-contained.sh` no runner.
4. Próxima ação única: re-auditar o delta combinado 0002+0003 por famílias
   distintas de OpenAI, colher hearback humano dos readbacks 0002/0003 e só
   então o operador executa commit com runner verde.

## Ponteiros

- Readback ativo da onda: `.hbn/readbacks/0003-proveniencia-livro-razao.json`
- Handoff da onda: `.hbn/messages/20260706-001951-codex-handoff-onda-0003.md`
- Regra canônica estendida: `core/04-artefatos.md`
- Manifesto de migração: `MANIFESTO-MIGRACAO.md`
- Guards novos: `guards/assert-doc-provenance.sh` e
  `guards/assert-version-self-contained.sh`
