---
titulo: "08 — Evolução e automelhoria: knowledge, workflows dinâmicos, loops, skills"
status: congelado
temperatura: glacier
path: versao_2_0_0/core/08-evolucao.md
created_at: "2026-07-01T19:46:00-03:00"
autor: fable-5
familia: Anthropic
---

# 08 — Evolução e automelhoria

## Knowledge (lições operacionais)

Lição de execução vira entrada numerada em `.hbn/knowledge/` (herdadas as
0001–0032 do v0.3.x, vigentes). Uma lição por evento, com INDEX consistente
(G-KNOWLEDGE-INDEX). Knowledge é **recomendação forte**, não doutrina: se uma
lição precisa ser vinculante, vira guard + teste (R2) — nunca leitura
obrigatória nova.

## Workflows dinâmicos e loops (automelhoria com orçamento)

O processo de automelhoria opera em loops fechados e curtos:

1. **Loop de onda** (horas): despacho → implementação → auditoria → selagem.
2. **Loop de lição** (por evento): violação/surpresa → knowledge OU guard+teste
   OU risco aceito (R4). Nunca doutrina.
3. **Loop de muda** (meses): pressão acumulada (dívida C-DEBT, boot crescendo,
   guards conflitantes) → nova exúvia pelo ciclo do `06`.

Regra anti-espiral: melhoria de processo NUNCA adiciona leitura obrigatória
(orçamento R1 é teto duro). Se uma melhoria "precisa" de mais boot, ela está
errada — redesenhe até caber.

## Skills (capacidades empacotadas)

Procedimento repetitivo (ex.: cerimônia de commit, geração de despacho,
checklist de auditoria) vira skill versionada em `docs/skills/` — texto
autocontido ≤ 100 linhas que uma IA carrega SÓ quando executa aquele
procedimento. Skills são zona `docs/` (não-normativa); a norma continua sendo
o guard que valida o resultado.

## Métricas de saúde (medidas por onda, registradas no STATE)

- linhas de leitura obrigatória de entrada (teto: BOOT+STATE+cartão ≤ 500);
- proporção artefatos de governança / artefatos de produto (alerta > 1:1);
- violações pegas por guard vs. por humano (meta: 100% guard);
- ondas até selagem (meta: 1 despacho, 2 pareceres, 1 hearback).
Três medições consecutivas fora da meta = sinal de muda (loop 3).
