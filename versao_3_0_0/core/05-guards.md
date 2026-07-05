---
titulo: "05 — Guards e enforcement: runner, tiers, CI, testes"
status: ativo
temperatura: quente
path: versao_3_0_0/core/05-guards.md
created_at: "2026-07-01T19:40:00-03:00"
autor: fable-5
familia: Anthropic
---

# 05 — Guards e enforcement

## Decisão de migração (importante para auditores)

Os guards do v0.3.x foram **vendorizados SEM alteração de lógica** para
`versao_2_0_0/guards/` (shell selado por quórum não se reescreve em
intervenção unilateral). O runner roda o conjunto completo herdado (30 ativos
+ 3 condicionais), com resolução de raiz version-aware já preparada pela onda
M-A (`guards/lib/common.sh::get_canonical_root()` lê `.hbn/active-version`).
Suíte (`guards/tests/run-guard-tests.sh`) e bateria adversarial
(`guards/tests/adversarial-battery.sh`) acompanham, também sem alteração.

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
G-PTR (ponteiro existe) · G-ARVORE-LABEL · G-KNOWLEDGE-INDEX · G-COPY
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
