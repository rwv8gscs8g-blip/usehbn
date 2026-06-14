---
titulo: Handoff — onda 0009: emenda da doutrina do orquestrador aplicada na spec
tipo: handoff
status: proposed
temperatura: quente
id-global: 20260613-225152-codex-handoff-onda-0009-emenda-doutrina
path: .hbn/messages/20260613-225152-codex-handoff-onda-0009-emenda-doutrina.md
data: 2026-06-13
autoria: codex (implementador da onda 0009; desenho/readback do orquestrador claude-opus-4-8)
hearback-status: formal adiado para fase-2 (B2 G-REG x G-HRB)
relacionado: [core/orchestrator-profile-spec.md, .hbn/readbacks/0009-emenda-doutrina-orquestrador.json, .hbn/results/20260613-221518-codex-cross-ia-onda-0008-doutrina.md, .hbn/results/20260613-221433-gemini-3-5-cross-ia-onda-0008-doutrina.md, .hbn/relay/STATE.md, REGISTRY.md]
---

# Onda 0009 — emenda da doutrina do orquestrador

Esta onda aplica o tempo 3 da mudança de doutrina do orquestrador. A spec
`core/orchestrator-profile-spec.md` foi emendada para 0.2.0, incorporando as
cláusulas 7/8/9, o refino da cláusula 4, a recalibração de 5 níveis do `MODO
EDUCACIONAL` e a nota de enforcement que mantém esse campo fora do G-RLT nesta
adoção.

## Truth Barrier

- A spec original ainda tinha 6 cláusulas no contrato antes da emenda
  (`core/orchestrator-profile-spec.md:28-47`) e agora registra versão 0.2.0,
  data 2026-06-13 e revisar-em 2026-09-13
  (`core/orchestrator-profile-spec.md:8-13`).
- A proposta da onda 0008 pedia cl.7, cl.8, cl.9 e refino da cl.4
  (`.hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md:35-103`).
- O parecer Codex vetou só a adoção literal da cl.9 por ambiguidade de
  "família" e exigiu `fornecedor(implementador) ≠ fornecedor(orquestrador)`
  ou redação equivalente (`.hbn/results/20260613-221518-codex-cross-ia-onda-0008-doutrina.md:57-89`).
- O parecer Codex também pediu manter `MODO` fora do G-RLT e impedir que modo
  avançado reduza justificativa (`.hbn/results/20260613-221518-codex-cross-ia-onda-0008-doutrina.md:93-109`).
- O parecer Gemini pediu exclusão dinâmica do fornecedor do implementador nos
  auditores, blindagem Truth Barrier contra opacidade e distinção warm
  boot/reboot (`.hbn/results/20260613-221433-gemini-3-5-cross-ia-onda-0008-doutrina.md:43-58`).
- ADR-018 define família como `fornecedor` do perfil
  (`methodology/adr/ADR-018-papeis-chapeus-anti-groupthink.md:46-55`); a
  roles-spec trata implementador↔arquiteto de mesmo fornecedor como AVISO
  (`core/roles-assignment-spec.md:46-52`).
- Perfis vivos confirmam fornecedores: Codex=OpenAI
  (`.hbn/models/codex.json:3-9`), Gemini=Google
  (`.hbn/models/gemini-3-5.json:3-9`), Opus/Fable=Anthropic
  (`.hbn/models/opus-4-8.json:3-9`,
  `.hbn/models/fable-5.json:3-9`).

## Aplicado

- `core/orchestrator-profile-spec.md`:
  - metadados 0.2.0, data/revisar-em 2026-06-13/2026-09-13;
  - cláusula 4 refinada: comando único + expectativa + fallback com tradução
    em prosa do que o comando faz e por quê;
  - cláusula 7: orquestrador como camada de abstração humana e painel de
    proteção como denominador comum;
  - cláusula 8: `MODO EDUCACIONAL` em básico, entusiasta, intermediário
    (DEFAULT), avançado e expert; núcleo obrigatório de verdade mecânica;
    warm boot lê STATE, reboot volta a intermediário;
  - cláusula 9: família = fornecedor; separação implementador↔orquestrador
    elevada a doutrina; auditores excluem dinamicamente o fornecedor do
    implementador; roteamento é referência, não fixação;
  - §5 preserva doutrina-sem-enforcement e explicita que `MODO EDUCACIONAL`
    segue fora do G-RLT nesta adoção.
- `REGISTRY.md` registra a spec emendada, os dois pareceres frios da onda 0008,
  o readback 0009, este handoff e a atualização do STATE.
- `.hbn/relay/STATE.md` passa a apontar para onda 0009, próximo passo Gemini,
  `MODO EDUCACIONAL: intermediário`, readback/handoff novos e atribuição
  implementador=codex, auditores=[gemini-3-5].

## Hearback formal adiado

Não foi criado hearback numerado nesta onda. O deadlock B2 (`G-REG x G-HRB`)
ainda não foi resolvido; a adoção desta emenda fica apoiada na cerimônia
humano-aplicada e na auditoria Gemini. O hearback ADR-023 formal entra na
fase-2, junto com B1/B2/B3 e sinais/painel.

## O que NÃO foi tocado

Nada em `guards/`, `src/`, VBA, `examples/`, `inbox/` ou domínio. O sinal 🔴
F-01 segue `PROPOSED` e fora do escopo. Os dois handoffs históricos não entram
na cerimônia; o commit deve usar paths explícitos.

## Decisões informais (cápsula)

Nenhuma decisão informal nova além do escopo humano-aplicado da onda 0009. A
regra operacional desta onda é: aplicar a emenda, não criar hearback formal,
manter F-01 e entregar cerimônia para o operador.

```
RELATO DE ESTADO — codex · implementador · 2026-06-13T22:51:52-03:00
STATE: ultima_atualizacao=2026-06-13T22:51:52-03:00 · bastão → Maurício (gate) · token FP 34a7f2f9 ativo · MODO EDUCACIONAL intermediário
SINAIS: 🔴 F-01 mantida PROPOSED; hearback ADR-023 formal adiado p/ fase-2 por B2 G-REG×G-HRB; G-TOK FP 34a7f2f9 inalterado
FEITO: spec 0.2.0 emendada; readback 0009, handoff, STATE e REGISTRY escritos; pareceres 0008 registrados; sandbox NÃO commitou
PENDENTE: suíte local e re-simulação dos guards; depois operador roda cerimônia zsh-safe com paths explícitos
PRÓXIMA AÇÃO: auditoria da emenda por Gemini; depois hearback (formal adiado p/ fase-2 por B2 G-REG×G-HRB) e fase-2 (B1/B2/B3 + sinais/painel)
PARA O HUMANO: aplicar a cerimônia no Terminal canônico; esperado: suíte verde e commit com trailers HBN-Readback: 0009 e HBN-Token-FP: 34a7f2f9
```
