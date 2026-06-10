# Re-auditoria cruzada — Corrente E 50% — Codex (OpenAI)

✅ HBN ACTIVE · ⚪ HBN AUDIT-ONLY

Auditor: Codex (OpenAI), chat limpo, familia diferente do implementador. Parecer independente: nao li o parecer do outro auditor; li apenas o parecer Codex anterior solicitado (`0021`).

## Pre-flight

1) `pwd`: `/Users/macbookpro/Projetos/usehbn` ;
2) `git status --short`: limpo ;
3) `git log --oneline -1`: `1a3a2c4 checkpoint(protocol): corrente E 50% (anti-teatro ADR-020 + 3 guards endurecidos + testes negativos + F-04 excecao fable-opus) — status: proposed, nao adotado` ;
4) `NNNN`: usei `0025`, preservando `0023/0024` como reservados conforme instrucao humana.

## Execucao Em /tmp

Clone descartavel: `/tmp/usehbn-codex-e-audit.UBTTk0/repo`.

Suite: `bash guards/tests/run-guard-tests.sh` retornou exit `0`, com `15 passaram, 0 falharam`.

Bypasses manuais reexecutados em `/tmp`:

1) G-FAM fable-5 x opus-4-8 com `hearback_ref` inexistente: BLOQUEOU, exit `1` ;
2) G-FAM fable-5 x opus-4-8 com hearback `0002` pendente: BLOQUEOU, exit `1` ;
3) G-FAM fable-5 x opus-4-8 com hearback temporario `confirmed` e excecao exata: PASSOU, exit `0` ;
4) G-REG substring `ADR-01` contra `ADR-011-exemplo`: BLOQUEOU, exit `1` ;
5) G-REG `core/*.md` novo sem REGISTRY: BLOQUEOU, exit `1` ;
6) G-REG `.hbn/models/*.json` novo sem REGISTRY: BLOQUEOU, exit `1` ;
7) G-REG `.github/workflows/*` novo sem REGISTRY: BLOQUEOU, exit `1` ;
8) G-REG orfao em `docs/prompts/`: BLOQUEOU, exit `1` ;
9) G-FRZ `obrigatorio=na` com hearback `confirmed`: PASSOU, exit `0` ;
10) G-FRZ `obrigatorio=na` sem hearback: BLOQUEOU, exit `1` ;
11) G-FRZ `obrigatorio=na` com hearback pendente: BLOQUEOU, exit `1`.

## Veredito Por Escopo

1) Os 3 bugs foram corrigidos: APROVAR. G-FAM dereferencia `hearback_ref` e exige `status=confirmed` (`guards/assert-role-family.sh:57-73`), exige excecao estruturada (`guards/assert-role-family.sh:75-86`) e bloqueia mesma familia sem cobertura (`guards/assert-role-family.sh:111-116`). G-REG usa coluna exata no REGISTRY (`guards/assert-registry-line.sh:84-90`), cobre `core/*.md`, `.hbn/models/*.json`, `.github/workflows/*` (`guards/assert-registry-line.sh:72-75`) e bloqueia orfaos em `docs/prompts/` (`guards/assert-registry-line.sh:113-117`). G-FRZ exige hearback verificavel para `obrigatorio=na` (`guards/freeze-gate.sh:57-69`, `guards/freeze-gate.sh:76-88`).

2) Suite negativa: REAL, com lacuna. O helper `check` afirma bloqueio por `rc != 0` (`guards/tests/run-guard-tests.sh:23-32`), e os negativos exercitam G-FAM (`guards/tests/run-guard-tests.sh:42-47`), G-FRZ (`guards/tests/run-guard-tests.sh:55-59`) e G-REG (`guards/tests/run-guard-tests.sh:87-103`). Nao encontrei teste que sempre passa. Lacuna: G-REG nao tem negativos para `.hbn/models/*.json` nem `.github/workflows/*`.

3) ADR-020: SOLIDO para esta remediacao proposed. Ele define Truth Barrier para guards (`methodology/adr/ADR-020-anti-validacao-de-teatro.md:36-50`), regra de teste negativo antes de runner (`methodology/adr/ADR-020-anti-validacao-de-teatro.md:52-61`) e aplicacao aos tres bugs (`methodology/adr/ADR-020-anti-validacao-de-teatro.md:63-73`). Os novos guards seguem fora do runner (`guards/hbn-guards-runner.sh:22-28`).

4) F-04: CORRIGIDO no campo mecanico. `opus-4-8` saiu de `atribuicao.auditores`, que agora lista `codex` e `gemini-3-5` (`.hbn/relay/STATE.md:28-33`). Opus fica em prosa como validador fixo ate decisao (`.hbn/relay/STATE.md:8-16`). O hearback 0002 declara a excecao fable-opus (`.hbn/hearbacks/0002-excecao-fable-opus.json:8-14`), mas esta `pendente`, nao `confirmed` (`.hbn/hearbacks/0002-excecao-fable-opus.json:5-7`).

5) Novo teatro/regressao/inconsistencia: SEM BLOQUEADOR. Ha 1 FORTE de cobertura de suite e 1 MARGINAL de redacao da spec. Nao encontrei regressao funcional nos tres guards.

## Findings

### BLOQUEADOR

Nenhum.

### FORTE

**E-RE-01 — Suite G-REG nao fixa dois subcasos prometidos pela remediacao.** A remediacao inclui `.hbn/models/*.json` e `.github/workflows/*` em `guards/assert-registry-line.sh:72-75`, mas a suite negativa cobre substring, `core/*.md` e `docs/prompts/` em `guards/tests/run-guard-tests.sh:87-103`. Impacto: regressao futura nesses dois ramos poderia manter a suite verde. Recomendacao: adicionar negativos explicitos antes de ativar G-REG no runner.

### MARGINAL

**E-RE-02 — Freeze spec preserva frase ambigua sobre `obrigatorio=na`.** `core/freeze-gate-spec.md:28` diz que criterio obrigatorio precisa `status: ok`, enquanto `core/freeze-gate-spec.md:30-31` permite `na` com hearback. ADR-020 fixa a interpretacao operacional (`methodology/adr/ADR-020-anti-validacao-de-teatro.md:71-73`) e o guard implementa (`guards/freeze-gate.sh:76-88`). Recomendacao: ajustar a linha 28 para explicitar a excecao.

## Recomendacao Por Hearback

1) ADR-020: aprovar como contrato anti-teatro proposed; mecanizar enforcement de runner em onda futura se o humano quiser ;
2) G-FAM: aceitar; nao recolocar opus em `atribuicao.auditores` ate `0002` virar `confirmed` ;
3) G-REG: aceitar a correcao funcional, mas completar negativos de modelos/workflows antes de ativar no runner ;
4) G-FRZ: aceitar; alinhar texto do freeze spec para remover ambiguidade ;
5) F-04: manter estado atual ate hearback humano.

## Checklist Anti-Vies B1-B6

1) B1: li a read-list diretamente e nao li o parecer do outro auditor ;
2) B2: reexecutei suite e bypasses em `/tmp`; descartei uma primeira rodada manual por erro no harness e considerei a segunda corrigida ;
3) B3: procurei falso verde, falso negativo, falso positivo e drift codigo x spec x ADR ;
4) B4: nao converti lacunas de cobertura em bloqueador porque os bypasses manuais bloquearam ;
5) B5: nao recomendo bastao para Codex; a decisao permanece humana ;
6) B6: nao implementei guard, nao ativei runner e nao movi/editei canonico fora destes dois resultados.

## VETO_ADOCAO

NAO.

## Resumo Para Humano

1) Remediacao dos 3 bugs e real: bypasses historicos bloquearam em `/tmp` ;
2) Suite negativa e real, nao teatro de segundo nivel nos casos existentes ;
3) Forte: faltam negativos G-REG para `.hbn/models/*.json` e `.github/workflows/*` ;
4) Marginal: freeze spec ainda tem frase ambigua ;
5) F-04 foi corrigido: opus saiu de `auditores`; 0002 continua pendente ;
6) Nada foi ativado no runner ;
7) VETO_ADOCAO: NAO, com ajuste antes de ativar G-REG no runner.
