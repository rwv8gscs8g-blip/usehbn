---
titulo: Handoff — onda 0008 (tempo 1): proposta de doutrina do orquestrador escrita; aguarda cross-audit
tipo: handoff
status: congelado
temperatura: glacier
id-global: 20260613-212913-fable-5-handoff-onda-0008-doutrina
path: .hbn/messages/20260613-212913-fable-5-handoff-onda-0008-doutrina.md
data: 2026-06-13
autoria: claude-fable-5 (implementador da onda 0008 — chapéu implementador, NÃO orquestrador; desenho é do orquestrador Opus 4.8)
hearback-status: aguardando humano
relacionado: [.hbn/readbacks/0008-doutrina-orquestrador.json, .hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md, .hbn/relay/STATE.md, REGISTRY.md]
---

# Onda 0008 — proposta de doutrina do orquestrador (tempo 1)

Mudança de doutrina aprovada pelo gate humano em 2026-06-13. Esta onda
ESCREVE uma **proposta** (artefato de design) com quatro ajustes ao §2 de
`core/orchestrator-profile-spec.md` e **não edita a spec** — a emenda real é
o tempo 3, depois do cross-audit. Adotar a própria proposta sem auditoria
externa violaria a cláusula 2 do papel (auditoria cruzada, nunca
auto-auditoria).

Os quatro ajustes descritos na proposta:

- **cl.7 — camada de abstração para o humano**: o orquestrador traduz toda
  mecânica em prosa; entrega operacional vem SEMPRE com a tradução do que faz
  e por quê. Desce o P13 (ADR-009) ao comportamento.
- **cl.8 — modo educativo / construção de competência, com três níveis**
  (Básico, Intermediário=DEFAULT no reboot, Avançado) + regras de modo
  (abertura declara estado-do-disco/modo/comando; reboot → intermediário;
  troca por comando; campo MODO no cabeçalho).
- **cl.9 — roteamento de modelo** (a IA certa para a tarefa, base ADR-015)
  com invariantes anti-F-01/ADR-018 e casamento complexidade↔modelo.
- **refino da cl.4**: minimalismo de PASSOS, não de ENTENDIMENTO.

## Separação desenho ≠ implementação (anti-F-01)

O DESENHISTA é o orquestrador (Opus 4.8): `agent_id` do readback =
`claude-opus-4-8-orquestrador-0008`, distinto DE FATO do `STATE.implementador`
(`claude-fable-5`). Família do implementador (Fable) ≠ família do orquestrador
mantém a separação honesta (ADR-018) — não um rótulo para driblar o G-EXC, que
nem dispara aqui porque `agent_id` ≠ `implementador`.

## O que NÃO foi tocado

`core/orchestrator-profile-spec.md` (emenda = tempo 3), guards/, src/, VBA,
examples, inbox, site, local-ai. O 🔴 F-01 + `PROPOSED_UNTIL_CROSS_AUDIT`
seguem no STATE (fora do escopo). Os 2 handoffs históricos untracked
(`…122102`, `…112502`) NÃO entram — a cerimônia usa paths explícitos.

## Verificação local (sandbox, informativa)

`bash guards/tests/run-guard-tests.sh` → suíte verde (número do Terminal só
entra com a saída colada por Maurício). O commit é ato do operador no
Terminal canônico (o sandbox nega `unlink` no mount do `.git` e deixaria lock
preso) — segue a cerimônia para colar.

```
RELATO DE ESTADO — fable-5 · implementador · 2026-06-13T21:29:13-03:00
STATE: ultima_atualizacao=2026-06-13T21:29:13-03:00 · bastão → Maurício (gate) · token FP 34a7f2f9 ativo
SINAIS: 🔴 F-01 mantida PROPOSED_UNTIL_CROSS_AUDIT; 🟢 onda 0006 ADOTADA (main 75d2e9d); 🟢 G-TOK FP 34a7f2f9; demais inalterados
FEITO: tempo 1 da onda 0008 — readback 0008 + proposta de doutrina + 3 linhas REGISTRY + este handoff + STATE; escrito no sandbox, NÃO commitado
PENDENTE: Maurício roda a cerimônia de Terminal (git reset → git add -f por path → 1 commit com trailers HBN-Readback: 0008 e HBN-Token-FP: 34a7f2f9)
PRÓXIMA AÇÃO: cross-audit Codex+Gemini da proposta de doutrina do orquestrador
PARA O HUMANO: colar a cerimônia no Terminal canônico (~/Projetos/usehbn); espera-se git status limpo dos itens do escopo + suíte verde
```
