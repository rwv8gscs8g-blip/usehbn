# Parecer Antigravity — ADR-007 Métricas de saúde (Goodhart)

**Auditor:** antigravity (Gemini 3.1)
**Session role:** cross-ia-review-usehbn
**Reviewed at:** 2026-05-09

## Veredito conceitual

`APROVADO_COM_RESSALVA`

## Coerência com P1-P13

| Princípio | Apoiado | Em tensão | Comentário |
|---|---|---|---|
| P4 (Explicar automação) | sim | não | Alarmes trazem razões claras. |

## Comparação com precedentes externos

**DORA Metrics:** Projetadas para medir fluxo, acabaram virando metas cegas em muitas corporações (Goodhart's Law: "Quando uma métrica vira meta, deixa de ser uma boa métrica").

## Tensões filosóficas detectadas

O uso de `quartas_sem_merge_consecutivas > 3` como alarme de burocracia é brilhante, mas...

## Risco antropológico/cultural

**Groupthink vs Divergência:** A métrica `cross_ia_divergencia_pct > 40%` alerta sobre princípios vagos. Contudo, se a divergência for cronicamente **<5%**, isso também é um risco imenso (viés de confirmação entre modelos, subserviência da IA ao tom do prompt). Concordância absoluta entre Opus, Codex e Antigravity significa que não precisamos de 3 IAs, ou que estamos sofrendo alucinação coletiva.

## Recomendação para humano

`RATIFICAR_APÓS_AJUSTES_NARRATIVOS`

## Comentário livre

O ADR é excelente, mas para fechar as brechas do risco de Goodhart e o risco de groupthink, recomendo adicionar um limite inferior (ex.: `<10%`) à métrica `cross_ia_divergencia_pct` como indicativo de **Alarme de Viés/Alinhamento de Prompt**. Consenso unânime permanente é falha de design em cross-audit.
