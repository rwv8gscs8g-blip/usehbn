# Parecer Antigravity — ADR-005 Licenciamento Apache 2.0 + CLA

**Auditor:** antigravity (Gemini 3.1)
**Session role:** cross-ia-review-usehbn
**Reviewed at:** 2026-05-09

## Veredito conceitual

`APROVADO_SEM_RESSALVA`

## Coerência com P1-P13

| Princípio | Apoiado | Em tensão | Comentário |
|---|---|---|---|
| P9 (Pragmatismo) | sim | não | Escolha técnica focada em adoção ampla. |
| P2 (Documentar) | sim | não | O processo de transição está claro. |

## Comparação com precedentes externos

**MongoDB (AGPL -> SSPL) vs Kubernetes / Diataxis (Apache 2.0):** Tecnologias de "encanamento" (como TCP/IP, Diataxis, Kubernetes) exigem licenças permissivas para atingir a onipresença. A AGPLv3 é uma licença de ativismo ou de proteção de modelo de negócios (SaaS). O useHBN é um protocolo conceitual, e a Apache 2.0 é o padrão de facto para esse estrato.

## Tensões filosóficas detectadas

O nome "useHBN" carrega o espírito "Humano no Controle". A AGPLv3 protegia essa transparência pela força jurídica. Migrar para Apache 2.0 permite que corporações embarquem o HBN silenciosamente em esteiras opacas. É uma troca filosófica: abandona-se o poder coercitivo da licença pela onipresença do padrão.

## Risco antropológico/cultural

Adoção do **DCO** (Developer Certificate of Origin) em vez de um ICLA pesado é o *sweet spot* perfeito. Um ICLA de 3 páginas (estilo Apache Software Foundation) mataria as contribuições pequenas. O DCO protege legalmente, é trivial (`git commit -s`), e comunica "somos profissionais, mas sem burocracia".

## Recomendação para humano

`RATIFICAR`

## Comentário livre

Decisão madura e inescapável se a ambição do projeto for ser consumido por *tools* e LLMs de terceiros. A AGPLv3 geraria medo em diretores técnicos (FUD). A Apache 2.0 abre as portas corporativas. O risco de ser consumido sem reciprocidade é mitigado pela governança forte e pela cadência agressiva de evolução.
