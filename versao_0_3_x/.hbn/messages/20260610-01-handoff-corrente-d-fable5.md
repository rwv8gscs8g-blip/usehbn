---
id: 20260610-01
tipo: handoff
projeto: usehbn (canônico)
de: claude-fable-5 (arquiteto, corrente D)
para: Maurício (gate humano) → próxima janela após hearback
data: 2026-06-10
temperatura: glacier
status: congelado
---

# Handoff — corrente D (ADR-011 enforcement + dual-run + freeze-gate + papéis)

## O que esta corrente depositou (TUDO `status: proposed`)

| Bloco | Artefatos (ids REGISTRY) |
|---|---|
| 0 | guards/assert-registry-line.sh (35); faxina DRY-RUN reports/20260610-36-proposal-faxina-prompts-raiz.md (36) |
| 1 | ADR-016 (37); core/dual-run-spec.md (38); schemas/dual-run-result.schema.json (39) |
| 2 | ADR-017 (40); core/freeze-gate-spec.md (41); schemas/freeze-checklist.schema.json (42); guards/freeze-gate.sh (43); inbox/credenciamento/20260610-44-freeze-gate-v206.md (44) |
| 3 | ADR-018 (45); core/roles-assignment-spec.md (46); guards/assert-role-family.sh (47); campo `atribuicao` em relay-spec + state.schema.json (nota 48) |

## Evidência de funcionamento (testado em repo descartável no sandbox)

- assert-registry-line: recusou órfão na raiz e ADR sem linha de REGISTRY;
  aceitou depósito correto (4/4).
- gate dual-run: PASSA com diff=0 e com diff justificado+hearback; FALHA com
  diff sem justificativa e com caso sem registro (4/4).
- freeze-gate: checklist espelhando a V206 hoje → "congelável: não" com 3
  faltas (tela-a-tela, PDFs rodízio, pareceres); checklist completo → "sim";
  BLOQUEADOR>0 → veto (3/3).
- assert-role-family: codex×(opus,gemini) passa; fable×opus sem hearback
  BLOQUEIA (groupthink); com hearback_ref passa (3/3).

## Invariantes respeitados

Nenhum guard novo foi adicionado ao runner (ativação = pós-hearback). Nenhum
arquivo movido (faxina é dry-run). Nenhuma edição em projeto (V206 via
inbox). CLI não integrado. Git do canônico intocado pelo sandbox (knowledge
0003). Firewall 0022 intacto.

## Hearbacks pendentes (decidir em lote)

H1 ativar assert-registry-line no runner; H2 executar a faxina (comando
pronto na proposal 36); H3 adotar ADR-016+spec+schema; H4 adotar ADR-017
+freeze-gate e encaminhar inbox 44 ao Credenciamento; H5 adotar ADR-018
+campo atribuicao (e decidir a rampa opcional→obrigatório); H6 ativar
assert-role-family como passo de handoff.

## Próxima ação

Maurício lê este handoff + .hbn/relay/STATE.md, decide H1–H6; quem retomar
depois lê o STATE primeiro (read-list do relay-spec).
