---
titulo: State-report spec — Relato de Estado fixo (≤10 linhas) antes de todo bastão
diataxis: reference
status: accepted
temperatura: quente
id-global: 20260610-202750-fable-5-spec-state-report
path: core/state-report-spec.md
versao: 0.1.1   # FIX cross-audit 0030 F-02 (heading exato) + 0031 F-03 (parser do chapéu por campo)
data: 2026-06-10
autoria: claude-fable-5 (consolidação ADR-024)
hearback-status: confirmed
relacionado: [ADR-024 (Decisões 4 e 6), ADR-022, core/relay-spec.md (guard-state-fresh — o G-RLT o estende), core/pointer-spec.md, knowledge 0002]
---

# State-report spec

## §1 Forma fixa (≤10 linhas, ADR-022)

Impresso no chat E refletido no handoff antes de TODO bastão, qualquer
chapéu:

```
RELATO DE ESTADO — <apelido> · <chapeu_atual> · <created_at ISO8601>
STATE: ultima_atualizacao=<valor EXATO do arquivo> · bastão → <próximo dono> · contexto ~<n>% do threshold
SINAIS: <abertos novos/fechados nesta sessão; demais permanecem no STATE>
FEITO: <1 linha — entregável com status proposed/adotado>
PENDENTE: <1 linha — o que NÃO foi feito e onde está declarado>
PONTEIROS: <1+ linhas no formato da pointer-spec>
PRÓXIMA AÇÃO: <atômica; STRING IDÊNTICA ao proxima_acao do STATE>
PARA O HUMANO: <comando único + expectativa + fallback (knowledge 0002)>
```

## §2 Regras anti-teatro

1. Cada linha deriva de LER o STATE pós-atualização do disco — não da
   memória da sessão. A linha STATE cita o `ultima_atualizacao` EXATO:
   valor que só existe no arquivo novo; divergência denuncia relato de
   memória (ADR-020).
2. `PRÓXIMA AÇÃO` é igualdade EXATA de string com `STATE.proxima_acao` —
   não paráfrase.
3. `PONTEIROS` seguem a pointer-spec (gerados do disco).
4. Quando o chapéu é `conversacional-orquestrador`, o handoff
   correspondente contém a seção `## Decisões informais (cápsula)`
   (ADR-024 Decisão 6) — ainda que vazia com "nenhuma".

## §3 Relação com o guard-state-fresh

O `guard-state-fresh` (relay-spec) garante o STATE coerente com o handoff;
o G-RLT garante o RELATO coerente com o STATE. Juntos fecham o triângulo
chat × handoff × STATE.

## §4 Guard G-RLT (`assert-report-fresh`) — spec, FORA do runner

Gatilho: commit que toca handoff em `.hbn/messages/` (staged; HEAD em CI).

1. BLOQUEADOR: handoff sem bloco `RELATO DE ESTADO`.
2. BLOQUEADOR: `PRÓXIMA AÇÃO` do relato ≠ `proxima_acao` do STATE staged
   (`git show :.hbn/relay/STATE.md` — lição staged-skew).
3. BLOQUEADOR: `ultima_atualizacao` citado no relato ≠ o do STATE staged.
4. BLOQUEADOR: chapéu orquestrador sem o heading EXATO
   `^## Decisões informais \(cápsula\)$` no handoff — substring solta
   `(cápsula)` em qualquer linha NÃO satisfaz (cross-audit 0030 F-02).
   Header do relato fora da forma fixa §1 (chapéu não extraível por
   campo `·`) também BLOQUEIA (cross-audit 0031 F-03).
5. AVISO: bloco com >10 linhas (inflação de relato).

Casos de teste (estilo `guards/tests/run-guard-tests.sh`, repo git
descartável):

```
check "rlt: relato íntegro, proxima_acao idêntica, cápsula presente"   pass
check "rlt: handoff sem bloco RELATO DE ESTADO"                        block
check "rlt: proxima_acao parafraseada (≠ string do STATE)"             block
check "rlt: ultima_atualizacao de memória (≠ STATE staged)"            block
check "rlt: orquestrador sem seção cápsula"                            block
check "rlt: '(cápsula)' fora do heading exato (teatro)"                block  # 0030 F-02
check "rlt: STATE bom só na working tree; staged velho (skew)"         block
check "rlt: relato de 12 linhas"                                       pass-com-aviso
```
