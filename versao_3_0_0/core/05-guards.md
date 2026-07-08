---
titulo: "05 — Guards e enforcement: runner, tiers, CI, testes"
tipo: spec
status: ativo
temperatura: quente
path: core/05-guards.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: versao_2_0_0
id_original: core/05-guards.md
created_at_original: "2026-07-01T19:40:00-03:00"
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
---
# 05 — Guards e enforcement

## Decisão de migração (importante para auditores)

A lógica de guards herdada foi transcrita para `guards/` desta versão sem
reescrita unilateral de shell selado por quórum. O runner roda o conjunto
completo vigente desta exúvia, com resolução de raiz version-aware já preparada
pela onda M-A (`guards/lib/common.sh::get_canonical_root()` lê
`.hbn/active-version`). Suíte (`guards/tests/run-guard-tests.sh`) e bateria
adversarial (`guards/tests/adversarial-battery.sh`) acompanham.

## Chokepoints

1. **pre-commit / commit-msg** (hook-shims em `guards/hook-shims/`, instalados
   pelo operador): delegam ao runner da versão ativa; fail-closed se ponteiro
   inválido, pasta ausente ou shim sem marcador.
2. **CI (`hbn-shield`)**: `bash guards/ci-entry.sh` roda runner + suíte +
   bateria com igualdade exata (G-CI-BATTERY). Obrigatório no push após
   publicação (branch protection).
3. **Sweep**: `assert-no-stray-hbn.sh --sweep` captura escrita fora de rito
   (o que chat produz sem commit).

## Mapa rápido dos guards (nome → o que bloqueia)

Identidade/posse: G-TOK (bastão) · G-FAM (família/papel) · G-AUDITOR-ID ·
G-EXC (exceção sem 4 sinais) · G-TRAILERS.
Escrita/escopo: G-CAN (raiz) · G-SCOPE (files_allowed + anti-auto-emenda) ·
G-STR/scratch-* (órfãos e área temporária) · G-ZONA-LIVRE.
Artefatos: G-REG (linha de nascimento) · G-NUM (nome/carimbo) · G-SLF (path) ·
G-PTR (ponteiro existe) · G-PROV (proveniência de documento) ·
G-SELF-CONTAINED (sem fonte vigente externa) · G-ARVORE-LABEL ·
G-KNOWLEDGE-INDEX · G-COPY
(HBN-COPY autocontido).
Estado/rito: G-STATE (STATE estrutural sem quórum) · G-NEXT (proximo_ponto
único) · G-RLT (relato de estado) · G-READLIST-RITE · G-ORQ-ENTRADA(-REF) ·
G-DISPATCH · G-FRONTDOOR · G-REPORT-FRESH · G-START-CAST.
Selagem: G-QUORUM (2 pareceres SIM) · G-DIVERSITY (famílias distintas) ·
G-HRB (hearback humano íntegro/assinado).
CI: G-CI-BATTERY.

## Tiers de execução (meta da onda 2 do desafiante)

Objetivo R1: pre-commit local rápido com os ~15 guards de chokepoint
(identidade, escrita, artefatos, selagem) e o conjunto completo no CI.
Implementação: onda própria (Codex), com testes, SEM deletar guard nenhum —
tier é configuração do runner, não remoção. Até lá, runner completo em ambos.

## Guards novos obrigatórios do desafiante (backlog nato, ordem fixa)

1. **G-ACTOR-WRITE-MATRIX** — enforcement de `core/actor-write-matrix.txt`.
2. **G-ORQ-NO-DELETE** — delete/move de STATE/knowledge/readbacks/results/
   REGISTRY exige manifesto + sucessor + rollback + quórum + gate.
3. Recalcular hashes de `core/read-list-canonica.txt` para os paths desta
   versão (G-READLIST-RITE volta a morder).
Regra R2: cada um nasce com teste negativo no mesmo commit.
