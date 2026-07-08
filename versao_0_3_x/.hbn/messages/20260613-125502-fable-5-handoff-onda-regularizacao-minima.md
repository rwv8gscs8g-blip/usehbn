---
titulo: Handoff — onda 0007 regularização mínima (Path A): pareceres + readback + STATE regularizados
tipo: handoff
status: congelado
temperatura: glacier
id-global: 20260613-125502-fable-5-handoff-onda-regularizacao-minima
path: .hbn/messages/20260613-125502-fable-5-handoff-onda-regularizacao-minima.md
data: 2026-06-13
autoria: claude-fable-5 (implementador da onda 0007 — chapéu implementador, NÃO orquestrador)
hearback-status: aguardando humano
relacionado: [.hbn/readbacks/0007-onda-regularizacao-minima.json, .hbn/relay/STATE.md, REGISTRY.md]
---

# Onda 0007 — regularização mínima pós-adoção da onda 0006 (Path A)

A onda 0006 está ADOTADA na main `75d2e9d`. Esta onda faz o registro mínimo
que ficou pendente, sem redesenhar enforcement e sem destravar os 3 deadlocks
conhecidos (Path A, decisão do gate humano):

- **6 pareceres** de cross-audit/re-auditoria da onda 0006 (untracked em
  `.hbn/results/`) entram no repo, cada um com sua linha no REGISTRY.
- **readback 0007** declara o escopo fechado da onda (agent_id = orquestrador,
  ≠ `STATE.implementador`, logo o G-EXC nem dispara) com linha no REGISTRY.
- **handoff** (este arquivo) + **STATE** corrigido no MESMO commit (par G-RLT).

## Por que os deadlocks NÃO são tocados (fase-2 planejada)

- **B1 (G-RLT):** os 2 handoffs históricos (`…122102`, `…112502`) NÃO são
  commitados — um quebraria a regra do bloco RELATO, o outro tem PRÓXIMA AÇÃO
  de outra onda. Ficam untracked até a fase-2 (handoff arquival).
- **B2 (G-REG × G-HRB):** nenhum hearback numerado é criado — `is_numbered_artifact`
  exigiria linha REGISTRY no mesmo commit, e o G-HRB exige commit de hearback
  PURO. Conciliação fica para a fase-2.
- **B3 (G-EXC):** a F-01 NÃO é baixada — mantidos 🔴 + `PROPOSED_UNTIL_CROSS_AUDIT`
  no STATE, com nota de gate-satisfeito. Baixa formal → ADOTADA-NÃO-PRECEDENTE
  + hearback ADR-023 fica para a fase-2.

## Desvio declarado do despacho (Truth Barrier)

O despacho dizia que `.hbn/messages/` não precisa de linha REGISTRY. **O guard
ativo contradiz:** `assert-registry-line.sh:91` casa o path do handoff no padrão
`messages-case` (numbered), e `:106` reforça pelo carimbo — toda a história de
handoffs no REGISTRY confirma a convenção. Por isso a linha do handoff FOI
adicionada (REGISTRY está no escopo; não é toque em guard/domínio). Consequência:
**1 commit único** em vez de 2 — ver justificativa na cerimônia.

## Verificação local (sandbox, informativa)

`bash guards/tests/run-guard-tests.sh` → **125 passaram, 0 falharam**. O commit
é ato do operador no Terminal canônico (o sandbox nega `unlink` no mount do
`.git` e deixaria lock preso) — segue a cerimônia para colar.

```
RELATO DE ESTADO — claude-fable-5 · implementador · 2026-06-13T12:55:02-03:00
STATE: ultima_atualizacao=2026-06-13T12:55:02-03:00 · bastão → Maurício (gate) · token FP 34a7f2f9 ativo
SINAIS: 🟢 onda 0006 ADOTADA (main 75d2e9d); 🟢 G-TOK ATIVO FP 34a7f2f9; 🔴 F-01 mantida PROPOSED_UNTIL_CROSS_AUDIT (baixa formal na fase-2); demais inalterados
FEITO: regularização mínima (Path A) — readback 0007 + 6 pareceres + 8 linhas REGISTRY + este handoff + STATE corrigido; escrito no sandbox, NÃO commitado
PENDENTE: Maurício roda a cerimônia de Terminal (git add por path + commit com trailer HBN-Token-FP: 34a7f2f9); orquestrador confere no disco
PRÓXIMA AÇÃO: planejar fase-2 da regularização (B1 G-RLT handoff arquival; B2 G-REG×G-HRB hearback numerado; B3 baixa da F-01 → ADOTADA-NÃO-PRECEDENTE)
PARA O HUMANO: colar a cerimônia no Terminal canônico (~/Projetos/usehbn); espera-se git status limpo dos itens do escopo + suíte 125/125 verde
```
