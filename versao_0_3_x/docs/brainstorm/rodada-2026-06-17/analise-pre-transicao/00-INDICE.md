# Dossiê de Pré-Transição — useHBN (rodada 2026-06-17)

NÃO-NORMATIVO (fronteira / zona livre). Índice legível por humanos e IAs.
Produzido pela Esteira de Pré-Transição (ver `06-`). Tudo aqui é INSUMO de decisão —
não-vinculante até curadoria humana. Truth Barrier: cada relatório cita arquivo:linha.

---

## Como navegar (comece aqui)

| # | Arquivo | O que responde |
|---|---|---|
| 00 | `00-INDICE.md` (este) | mapa do dossiê + atalhos para princípios e limpeza |
| — | `../SINTESE-PROFUNDA-pre-freeze.md` | **leitura mestra**: validação da metodologia, mapa runtime+guards, design R2, prontidão de freeze, sequência até a tag |
| 01 | `01-estrutura-pastas-e-documentacao.md` | árvore de pastas alvo, nada solto na raiz, padronização |
| 02 | `02-mapa-migracao-genoma-autocontido.md` | o que migra/melhora/aposenta; genoma auto-contido; ponteiros quebráveis |
| 03 | `03-qualidade-documentacao-software.md` | README/AGENTS/CLI/glossário; o que confunde uma IA nova |
| 04 | `04-prontidao-github-transicao.md` | o que um clone novo vê; CI; segredos; branch protection |
| 05 | `05-protocolos-de-teste-e-novos-testes.md` | estratégia de teste (3 camadas); fixtures irreais; novos testes |
| 06 | `06-esteira-pre-transicao-proposta.md` | a proposta de tornar esta esteira um passo de protocolo |

## Cobertura de temas a-g (R-PT5)

| Tema minimo | Cobertura auditavel |
|---|---|
| a) auditoria profunda | `../SINTESE-PROFUNDA-pre-freeze.md` |
| b) estrutura de pastas | `01-estrutura-pastas-e-documentacao.md` |
| c) mapa migracao | `02-mapa-migracao-genoma-autocontido.md` |
| d) qualidade doc | `03-qualidade-documentacao-software.md` |
| e) padronizacao geral | `01-estrutura-pastas-e-documentacao.md` (secao de padronizacao/raiz) |
| f) prontidao github | `04-prontidao-github-transicao.md` |
| g) protocolos de teste | `05-protocolos-de-teste-e-novos-testes.md` |

`06-esteira-pre-transicao-proposta.md` e meta/proposta da esteira; nao conta
como tema minimo a-g.

## Atalhos para os PRINCÍPIOS da plataforma (acesso fácil)

- **Constituição (P1–P13):** `methodology/PRINCIPIOS-CONSTITUCIONAIS.md`
- **Matriz de maturidade (fonte única):** `methodology/MATURITY-MATRIX.md`
  (atenção: existe uma cópia SUPERSEDED em `docs/MATURITY-MATRIX.md` — a dedup é um P0).
- **Critérios de exúvia (8 pontos) + Fitness Gate:** `core/exuvia-fitness-criteria.md`
- **Scaffold da exúvia (genoma, versões):** `core/hbn-exuvia-scaffold.md`
- **Cartões de papel (implementador/auditor/orquestrador):** `core/role-cards.md`
- **Cartão de entrada universal:** `.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md`
- **Lições acumuladas:** `.hbn/knowledge/INDEX.md` (0001–0025)
- **Livro-razão (todas as ações):** `REGISTRY.md`

## Proposta de LIMPEZA para a exúvia (acesso fácil)

- **Plano de pastas + "nada solto na raiz":** `01-estrutura-pastas-e-documentacao.md` (seção D)
- **Mapa de migração (antigos ficam para auditoria; novos nascem limpos):** `02-mapa-migracao-genoma-autocontido.md` (tabela A + regra de auditoria D)
- **Faxina de prompts da raiz já desenhada e nunca executada:** `reports/20260610-36-proposal-faxina-prompts-raiz.md` (a exúvia fecha)

## Achados P0 convergentes (de vários relatórios)

1. **AGENTS.md desonesto/quebrado** — aponta para `modules/` e `radar/` que NÃO existem e
   declara `core/` como "legado/superseded" sendo que `core/` é a casa das specs vivas.
   Contradiz P2. Correção mais barata e prioritária. (01, 02, 03)
2. **Maturity Matrix duplicada** — `docs/MATURITY-MATRIX.md` SUPERSEDED mas viva; deduplicar. (01, 03)
3. **Sem glossário canônico** — exúvia/árvores/fronteira/livro-razão sem definição no corpo
   canônico (só em zona livre). Criar `docs/GLOSSARY.md`. (03)
4. **G-LEG desarmado** — `guards/forbid-legacy-paths.sh` existe mas `.hbn/forbidden-paths.txt`
   não; precisa ser populado no corte da exúvia. (02)
5. **Paths absolutos** — `core/pointer-spec.md:36`, `.hbn/canonical-root`, `connectors/registry.json:9`
   prendem o repo a uma máquina; bloqueiam clone novo. (02, 04)
6. **Atomicidade de escrita** — `logger.py:20-22` e `store.py:151-157` fazem write direto;
   crash corrompe estado. Teste + tmp+os.replace. (05)
7. **Bateria adversarial é CRISPR** — cresceu para B1–B33 no disco mas o doc conceitual diz
   B1–B22; sincronizar e transferir integralmente na exúvia. (02)

## Estado do trabalho em curso (para qualquer IA que entrar)

- R1, R1-fix, R1-fix-2: ENTREGUES. R1+R1-fix: SELADOS. R1-fix-2: aguardando cross-audit
  ≠-OpenAI + hearback + selagem. Suíte 213/213; adversarial B1–B33 verde; `main` em `4db6928`.
- Próximo: cross-audit/selagem R1-fix-2 → R2 (árvores registry-centric) → R3 (hardening) →
  W-FREEZE. Detalhe em `../SINTESE-PROFUNDA-pre-freeze.md` (seção 7).
