# Rodada de lapidação de Fronteira — 2026-06-16

> **Zona Fronteira / não-normativo / fora do scope-lock.** Orquestrada pelo chat
> paralelo (Claude Opus 4.8, Anthropic) no chapéu provisório `analista/orquestrador-de-fronteira`.
> Objetivo: usar a janela de créditos (~16h) para lapidar a fundo os temas pendentes
> e entregar pacotes "prontos" ao orquestrador de desenvolvimento — **sempre** sob
> validação humana + auditoria adversarial cross-family antes de qualquer produção.

## Regras de isolamento (invioláveis para todo subagente)

1. Cada subagente escreve **um único** arquivo nesta pasta.
2. Pode LER todo o repo; **não escreve** em `core/`, `guards/`, `.hbn/`, `src/`,
   `schemas/`, `REGISTRY.md` nem `STATE`.
3. Não roda `git add/commit`, não roda guards, não altera a linha de desenvolvimento.
4. Tudo é `arvore: fronteira`, não-normativo, pendente de validação + cross-audit.
5. Truth Barrier: toda afirmação cita arquivo:linha.

## Batch 1 (subagentes Opus — disparado 2026-06-16)

| id | tema | arquivo | status | achado-chave |
|---|---|---|---|---|
| A1 | Front-door / start-rite verificável (resolve o "fio da meada") | A1-front-door-verificavel.md | ✅ concluído | O front-door já existe pela metade (`core/role-cards.md` + `assert-frontdoor.sh`); falta o ECO de leitura — proposto guard G-FDACK |
| A2 | Árvores: portão de promoção + reconciliação de campos | A2-arvores-portao-promocao.md | ✅ concluído | `arvore:`×`temperatura:`×`hbn-track:` são eixos ORTOGONAIS (prova×tempo×processo); guards são bash sem YAML → etiqueta vai no REGISTRY/comentário |
| A3 | Modelo compilador (`.md`→enforcement) — prova de conceito | A3-compilador-md-enforcement.md | ✅ concluído | O embrião do compilador já existe: `dispatch-spec.md`→`dispatch.schema.json`→`G-DSP`; só 9 de ~22 guards citam o spec de origem |
| B1 | Code review do runtime Python + alocação por árvore | B1-code-review-cli-runtime.md | ✅ concluído | `main()` sempre retorna 0 (exit-code-zero mesmo em violação) e 3 convenções de diretório de estado coexistem — bugs pré-exúvia |
| B2 | Auditoria de honestidade vs MATURITY-MATRIX | B2-honestidade-maturity-matrix.md | ✅ concluído | `autoevolve` é teatro (worker no-op; gate de orçamento sempre passa) e não está na matriz; testes 93/93 vs 114/114 divergentes |

## Batch 2 (subagentes Opus — concluído 2026-06-16)

| id | tema | arquivo | status | achado-chave |
|---|---|---|---|---|
| C1 | Emenda P13 (intenção × sintaxe) + questão P14 | C1-emenda-p13-intencao.md | ✅ | Manter UM P13 reformulado (não criar P14); 2 incidências reais; rito ADR-009 (cross-IA ≠-Anthropic) |
| C2 | Memória imunológica (regra CRISPR) | C2-memoria-imunologica-crispr.md | ✅ | Invariante em exuvia-fitness-criteria; distingue casca→glacier (ok) vs imunidade→genoma novo (obrigatório); guard `assert-immune-carryforward` |
| C3 | Escopo modesto da 1ª exúvia (bootstrap) | C3-escopo-primeira-exuvia.md | ✅ | Carrega só núcleo de governança; correções pré-exúvia (exit-code, diretório de estado) são pré-condição dura; checklist FG+8 critérios+bootstrap |
| C4 | GitHub/README honesto para o MVP | C4-github-readme-honesto.md | ✅ | 5 estados→verbos permitidos; 4 correções (autoevolve na matriz, 93/93→114/114, banner superseded, "L4") |
| C5 | Duas esteiras + chapéu `analista-de-fronteira` | C5-esteiras-e-chapeu.md | ✅ | Perfil proposto NÃO valida no schema atual (enum de papéis fechado) → instalar exige editar schema (T2); S1 impede auto-instalação |

## Documentos para disparo (prontos)

- `SUPERPROMPT-cross-ia-batch1.md` — bloco único para colar em Gemini 3.5 / Codex /
  Cursor / Grok / Antigravity; cada IA se autoidentifica e deposita só o parecer.
- `PROMPT-orquestrador-batch1.md` — insumo para o orquestrador de desenvolvimento
  avaliar e encadear no fluxo formal (correções rápidas pré-freeze + ondas próprias).
- `../PROMPTS-PF-ARVORES-AGORA-DRAFT.md` — prompts específicos da proposta de árvores.

## Resultado da auditoria cross-family (2026-06-16)

Pareceres de Cursor, Gemini/Antigravity e Codex recebidos. Consolidação em
`CONSOLIDACAO-batch1-cross-audit.md`. **Veredito:** análise confirmada como válida;
promoção normativa e freeze BLOQUEADOS até a onda de correções runtime + guards de
etiqueta/ack. B1 e B2 confirmados por unanimidade. Achados novos verificados no disco:
contagem real de testes ≈181 (docs defasados em 93 e 114); G-REG ignora `M`
(`assert-registry-line.sh:71,73`); `human_authorization` sem assinatura
(`assert-dispatch-integrity.sh:201-202`) → forjável.

Despacho de implementação pronto: `PROMPT-codex-onda-R1-runtime-honestidade.md`
(onda R1, validada, pré-freeze/pré-Ponte). R2/R3 e assinatura criptográfica sequenciados.

## Consolidação

O orquestrador-de-fronteira reúne os deliverables + os pareceres externos numa matriz
convergência × divergência por tema, e entrega ao orquestrador de desenvolvimento o
pacote pronto-para-despacho. Nada aqui vira regra sem o fluxo formal do protocolo.
