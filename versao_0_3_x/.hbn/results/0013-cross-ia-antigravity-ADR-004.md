# Parecer Antigravity — ADR-004 SemVer do protocolo + sinalização

**Auditor:** antigravity (Gemini 3.1)
**Session role:** cross-ia-review-usehbn
**Reviewed at:** 2026-05-09

## Veredito conceitual

`APROVADO_SEM_RESSALVA`

## Coerência com P1-P13

| Princípio | Apoiado | Em tensão | Comentário |
|---|---|---|---|
| P6 (Reversibilidade) | sim | não | Versionamento é pré-requisito para rollback previsível. |
| P10 (Segurança > velocidade) | sim | não | Sinais `⛓️` forçam atenção humana a mudanças de base. |

## Comparação com precedentes externos

**Rust Edition System:** SemVer puro não captura bem "mudança de filosofia". O Rust usa "Edições" (2018, 2021) para quebras conceituais. No entanto, o mapeamento do ADR (Mudança de P1-P13 = MAJOR) traduz bem a quebra de contrato semântico para os moldes do SemVer clássico.

## Tensões filosóficas detectadas

Versionar "princípios" é epistemologicamente complexo. Princípios não quebram APIs com `SyntaxError`, eles quebram a "confiança" ou a "direção". O ADR trata ambos (schema JSON e dogmas doutrinários) sob a mesma métrica de versão, o que é pragmático, mas unifica coisas de naturezas distintas.

## Risco antropológico/cultural

A banalização do "MAJOR". Se a equipe alterar a redação de um princípio menor e isso gerar um MAJOR, os consumidores (apps) vão se dessensibilizar ao sinal `⛓️ HBN PROTOCOL DEP CHANGE` (fadiga de alarme).

## Recomendação para humano

`RATIFICAR`

## Comentário livre

Mecanismo excelente. A regra de ouro será o rigor na avaliação do que é "mudança de redação que altera semântica" (MAJOR) vs "clarificação" (MINOR). Recomendo extrema parcimônia em bumpar MAJORs puramente filosóficos após a v1.0.0. A validação técnica dos schemas SemVer defiro ao Codex CLI.

> **Nota da consolidação cross-IA:** Antigravity APROVOU sem ressalva técnica, mas Codex REPROVOU este ADR por divergência objetiva entre `PROTOCOL_VERSION = 0.3.0` (em `__init__.py:11`), `__version__ = 0.2.0` (em `__init__.py:29`), e `setup.cfg:3 version = 0.2.0`, com `cli.py:1079` publicando o valor errado. Esta divergência cruzada **prevalece**: ADR-004 vai para NÃO_RATIFICAR_AGORA até resolução técnica. Ver `0003-cross-ia-codex-ADR-004.json` e `auditoria/00_status/05_CONSOLIDACAO_CROSS_IA_ADRS_2026_05_10.md`.
