---
titulo: "Cross-audit Codex — onda 0008: doutrina do orquestrador"
tipo: audit-result
status: congelado
path: .hbn/results/20260613-221518-codex-cross-ia-onda-0008-doutrina.md
id-global: 20260613-221518-codex-cross-ia-onda-0008-doutrina
temperatura: glacier
auditor: codex
familia: OpenAI
implementador-auditado: fable-5
commit_alvo: 5a8c5fb55123d93878fa0890d47ede0c960e096d
alvo: .hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md
created_at: "2026-06-13T22:15:18-03:00"
---

# Parecer Codex — onda 0008 doutrina do orquestrador

## Veredito

**VETO_ADOCAO: SIM para adoção literal da cláusula 9 como está redigida.**

Contagem: **0 BLOQUEADOR; 1 FORTE; 2 MARGINAL**.

O veto é estreito: não veta a direção da doutrina, nem as cláusulas 7/8, nem o
refino da cláusula 4. Veta copiar a cláusula 9 para a spec sem reparar a
ambiguidade de "família".

## Resumo

1. Li o alvo no commit `5a8c5fb` e o contrato atual do orquestrador no disco.
2. Cláusula 7 desce P13 para comportamento e corrige a tensão com minimalismo.
3. Cláusula 8 preserva P5: a IA instrui julgamento humano, não substitui.
4. Refino da cláusula 4 é coerente: minimalismo de passos, não de entendimento.
5. Escopo tempo 1 está limpo: a spec e os guards não foram tocados.
6. Não encontrei enforcement escondido; `MODO` é explicitamente futuro.
7. O risco central está na cláusula 9: "família" está sobrecarregado.
8. ADR-018 e os perfis definem família por `fornecedor`, não por linha de modelo.
9. Fable e Opus são ambos `Anthropic`; tratá-los como famílias distintas enfraquece o anti-groupthink.
10. Corrigida essa redação, a proposta fica adotável como doutrina.

## Truth Barrier

- Commit auditado: `git rev-parse HEAD` retornou `5a8c5fb55123d93878fa0890d47ede0c960e096d`.
- Arquivos alterados pelo commit: `.hbn/messages/20260613-212913-fable-5-handoff-onda-0008-doutrina.md`, `.hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md`, `.hbn/readbacks/0008-doutrina-orquestrador.json`, `.hbn/relay/STATE.md`, `REGISTRY.md`.
- A spec atual tem 6 cláusulas em `core/orchestrator-profile-spec.md:27-45`; enforcement do contrato é declarado doutrina-sem-enforcement em `core/orchestrator-profile-spec.md:67-73`.
- ADR-024 D2 define o perfil do orquestrador como contrato curto e sem enforcement mecânico em `methodology/adr/ADR-024-orquestracao-start.md:97-110`; o mapa repete D2 como backlog sem guard em `methodology/adr/ADR-024-orquestracao-start.md:181`.
- P5 e P13 aparecem na lista constitucional em `methodology/adr/ADR-009-constituicao-p1-p13.md:71-83`; a fonte canônica detalha P5 em `methodology/PRINCIPIOS-CONSTITUCIONAIS.md:130-147` e P13 em `methodology/PRINCIPIOS-CONSTITUCIONAIS.md:293-305`.
- ADR-018 define família como `fornecedor` do perfil em `methodology/adr/ADR-018-papeis-chapeus-anti-groupthink.md:46-55`; a roles spec aplica isso como `fornecedor(auditor) == fornecedor(implementador)` em `core/roles-assignment-spec.md:42-55`.
- Perfis vivos: `fable-5` tem `fornecedor: Anthropic` em `.hbn/models/fable-5.json:5`; `opus-4-8` também tem `fornecedor: Anthropic` em `.hbn/models/opus-4-8.json:5`; `codex` é OpenAI em `.hbn/models/codex.json:5`; `gemini-3-5` é Google em `.hbn/models/gemini-3-5.json:5`.

## BLOQUEADOR

Nenhum.

## FORTE

### F-01 — Cláusula 9 sobrecarrega "família" e pode contradizer ADR-018

A direção da cláusula 9 é boa: roteamento por aptidão, complexidade e separação
de vieses reforça ADR-015 e ADR-018. O problema é a redação do invariante.

A proposta declara "família Fable" no front-matter e diz que o invariante é
"implementador ≠ família do orquestrador" em
`.hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md:7`
e `.hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md:90-97`.
O handoff repete que "Família do implementador (Fable) ≠ família do
orquestrador" em
`.hbn/messages/20260613-212913-fable-5-handoff-onda-0008-doutrina.md:36-42`.

Isso conflita com a fonte operacional vigente: ADR-018 define família como
`fornecedor` do perfil, e os perfis mostram `fable-5` e `opus-4-8` no mesmo
fornecedor Anthropic. Se a adoção permitir chamar "Fable" e "Opus" de famílias
distintas, a nova doutrina enfraquece o anti-groupthink exatamente onde pretendia
reforçá-lo.

Correção exigida para o tempo 3:

1. Se a intenção é uma regra forte de família, escrever explicitamente
   `fornecedor(implementador) ≠ fornecedor(orquestrador)` e apontar para os
   perfis ADR-015, com exceção só por hearback.
2. Se a intenção é apenas anti-F-01 estrito, trocar "família" por
   `agente/perfil`: `agente_do_implementador ≠ agente_do_orquestrador`.
3. Se a intenção é elevar de AVISO para doutrina a separação entre
   implementador e orquestrador/arquiteto de mesmo fornecedor, dizer que isto é
   novo comportamento doutrinário e não o invariante atual do G-FAM; hoje a roles
   spec trata "implementador e arquiteto da mesma família" como AVISO, não
   bloqueio, em `core/roles-assignment-spec.md:51-52`.

Sem essa correção, eu veto a adoção literal da cláusula 9.

## MARGINAL

### M-01 — `MODO` deve continuar explicitamente fora do G-RLT nesta adoção

A proposta é honesta ao dizer que o campo `MODO` "pode virar face checável do
G-RLT numa onda futura" e que não nasce guard novo aqui
`.hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md:105-110`.
No tempo 3, convém preservar essa frase na spec ou em nota de adoção para evitar
que operadores tratem ausência de `MODO` como falha mecânica antes de haver
guard/spec de enforcement.

### M-02 — Modo avançado deve reduzir glosa, não reduzir justificativa

A cláusula 8 já diz que toda decisão explica trade-off e deixa o humano decidir
`.hbn/proposals/20260613-212813-fable-5-orquestrador-doutrina-abstracao-educativa-roteamento.md:48-76`.
Ainda assim, o modo "Avançado" fala em "andaime mínimo". Para evitar a brecha de
minimalismo virar opacidade, o tempo 3 deveria deixar explícito que modo avançado
nunca suprime o núcleo obrigatório: o que aconteceu, por quê, trade-off e próxima
decisão. Isso só encurta glosas e conceitos básicos.

## Respostas Diretas

1. **Fidelidade/coerência:** cláusulas 7, 8 e refino 4 são coerentes com o §2
   atual e com P5/P13. Cláusula 9 é coerente na direção, mas não na redação de
   "família"; precisa alinhar com `fornecedor` dos perfis ADR-015/ADR-018.
2. **Escopo:** confirmado como doutrina-sem-enforcement. O commit não altera
   `core/orchestrator-profile-spec.md`, `guards/**`, `src/**`, domínio ou runner;
   só proposta/readback/handoff/STATE/REGISTRY. Não vi mudança escondida de
   comportamento de guard.
3. **Solidez/risco:** os invariantes reforçam anti-groupthink e anti-F-01 se
   "família" significar `fornecedor`. Se "família" significar linhagem Fable vs
   Opus dentro de Anthropic, enfraquecem ADR-018. O modo educativo não abre
   brecha relevante porque cl.7 e cl.8 preservam entendimento, trade-off e
   decisão humana; a ressalva é só tornar isso explícito no modo avançado.

## Recomendação por Hearback

1. Aprovar cláusula 7, cláusula 8 e refino da cláusula 4.
2. Aprovar a cláusula 9 somente após correção textual de "família" no tempo 3.
3. Manter esta onda como tempo 1 sem enforcement; qualquer `MODO` checável por
   G-RLT deve ser proposta futura separada.

VETO_ADOCAO: SIM
