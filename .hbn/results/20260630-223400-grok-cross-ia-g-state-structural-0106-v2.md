---
tipo: audit-result
autor: grok
familia: xAI
path: .hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md
id-global: 20260630-223400-grok-cross-ia-g-state-structural-0106-v2
arvore: fronteira
created_at: "2026-06-30T22:34:00-03:00"
---
SOU: grok · familia xAI · papel auditor

# Auditoria G-STATE-STRUCTURAL 0106 v2

## Veredito
VEREDITO_G_STATE_STRUCTURAL: APROVA

## Evidencias
Comandos executados (um por vez):

COMANDO 1:
git rev-parse HEAD
saida: f8dbe09086d06f5dc42527241c33e37174a65427
(HEAD exatamente o esperado)

COMANDO 2:
git status --short
saida (resumo relevante para o patch):
 M .hbn/knowledge/INDEX.md
 M REGISTRY.md
 M guards/hbn-guards-runner.sh
 M guards/tests/adversarial-battery.sh
 M guards/tests/run-guard-tests.sh
?? guards/assert-state-structural.sh
(guard novo presente em disco; runner modificado para inclui-lo; REGISTRY modificado)

COMANDO 3:
bash guards/tests/run-guard-tests.sh
saida (secao G-STATE):
== assert-state-structural (G-STATE-STRUCTURAL) ==
  ✓ structural: neutral change to STATE passes (esperado: pass)
  ✓ structural: structural change to STATE with quorum passes (esperado: pass)
  ✓ structural: structural change to STATE without readback -> BLOCK (esperado: block)
  ✓ structural: structural change to STATE with insufficient quorum (same family) -> BLOCK (esperado: block)
saida final: exit code 0 (suite verde)

COMANDO 4:
bash guards/tests/adversarial-battery.sh
saida (B91/B92 + final):
B91 repoint de STATE sem readback staged             | G-STATE  | BLOQUEADA ✓
B92 repoint de STATE com insufficient-quorum         | G-STATE  | BLOQUEADA ✓
...
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
exit code 0

Arquivos lidos (antes de concluir, conforme instrucoes):
- AGENTS.md
- core/role-cards.md
- .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
- .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md
- .hbn/knowledge/0030-chat-novo-prompts-sequenciais.md
- .hbn/knowledge/0031-campo-unico-colavel-e-comandos-atomicos.md
- .hbn/proposals/20260630-201952-codex-orquestrador-provisorio-saneamento-exuvia.md
- guards/assert-state-structural.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh (secoes G-STATE)
- guards/tests/adversarial-battery.sh (B91-B92)
- guards/data/auditor-families.txt
- REGISTRY.md (linha do guard)
- .hbn/relay/STATE.md (estado atual, sem alteracao estrutural neste auditoria)

Guard em si (evidencia chave):
```sh
# em guards/assert-state-structural.sh
STATE_TOUCHED ...
if structural change in STRUCTURAL_KEYS (proxima_acao, proximo_ponto, onda_atual, readback_ativo, bastao_*, proprietario_*, papel_*):
  exige readback no diff
  exige >=2 familias_with_sim ( != "OpenAI" e != impl_family ) com APROVA_NNNN: SIM nos results matching suffix do readback
  results lidos de git ls-files / ls-tree (staged/HEAD), nao working tree
  parse SOU + frontmatter + map de familias
```

Testes no run-guard-tests.sh (linhas ~3103-3298):
- fixtures neutral/good/sem-readback/insufficient-quorum
- good usa 2 familias distintas (grok xAI + antigravity Google) + readback codex + APROVA
- insufficient usa 2 da mesma familia Google

B91/B92 no adversarial-battery.sh (linhas ~1644-1699):
- B91: repoint sem readback staged -> BLOCK
- B92: repoint com insufficient (1 parecer ou same family) -> BLOCK

Runner registra (guards/hbn-guards-runner.sh:108):
"assert-state-structural.sh" na lista GUARDS, apos next-checkpoint.

Preflight: todos itens PASS (repo ok, HEAD ok, guard presente, registrado no runner, testes presentes, B91/B92 presentes).

## Achados
BLOQUEADOR: nenhum (o patch fecha exatamente a classe 0103-0105)
FORTE:
- G-STATE-STRUCTURAL exige quorum de auditoria cruzada (2+ familias != impl/OpenAI) + readback presente no diff, para mudanca em STRUCTURAL_KEYS do STATE.
- Le apenas blobs staged/HEAD (nao working tree), consistente com outros guards (G-PTR etc.).
- Testes unitarios no run-guard + B91/B92 na bateria adversarial reproduzem e bloqueiam o cenario de readback "entregue" sozinho ou quorum falso.
MARGINAL:
- Delecao de STATE.md nao explicitamente coberta (guard foca AM no diff; delecao pode precisar de guard futuro G-ORQ-NO-DELETE conforme proposta).
- Freshness temporal de pareceres nao validada aqui (depende de outros mecanismos + gate humano).
- Gate humano continua obrigatorio apos quorum (conforme knowledge 0029, role-cards, proposal).

## Respostas obrigatorias
1. Bloqueia repoint estrutural de STATE com readback entregue e sem quorum? SIM. (sem readback -> BLOCK; readback + <2 familias validas -> BLOCK; somente >=2 + readback -> pass. Evidenciado em fixtures good vs sem-readback/insufficient e B91/B92.)
2. Bloqueia quorum falso por dois pareceres da mesma familia? SIM. (caso insufficient-quorum com antigravity+gemini ambos Google -> BLOCK; tambem coberto em G-QUORUM tests no suite.)
3. Ignora resultado nao registrado/staged e SOU/familia inconsistentes? SIM. (list_results usa git ls-files/ls-tree; parse valida autor/familia contra mapa + SOU fallback; so conta APROVA SIM de familias coerentes; resultados devem estar no contexto do diff.)
4. B91/B92 reproduzem a falha real 0103-0105? SIM. (B91 = repoint sem readback; B92 = repoint com quorum insuficiente/same-family; ambos explicitamente BLOCK na bateria adversarial com exit 0 da suite.)
5. O patch e pequeno e isolavel para selagem propria? SIM. (adicao de ~400 linhas no guard + integracao no runner + 4 checks no run-guard + 2 casos na bateria; sem tocar main, sem alterar STATE, sem escopo amplo; registrado no REGISTRY.)
6. Quais limites devem ficar registrados para ondas seguintes, especialmente delecao de STATE, freshness de parecer e gate humano?
  - Delecao de STATE: o guard atual detecta mudanca (AM), mas delecao pura pode requerer tratamento explicito ou G-ORQ-NO-DELETE (ver proposal H2 item 3).
  - Freshness de parecer: nenhum TTL/check de data aqui; selagem posterior deve combinar com G-QUORUM + gate humano + hearback.
  - Gate humano: continua mandatorio (knowledge 0029, lei submissao pelo exemplo; role-cards; proposal explicita "humano gate" para STATE estrutural).
  - Outros: patch assume readback status="entregue" no json mas valida via quorum de results; nao substitui G-DIVERSITY/G-QUORUM para selagem geral; CI usa HBN_DIFF_BASE para validar HEAD:path.

APROVA_0106: SIM
