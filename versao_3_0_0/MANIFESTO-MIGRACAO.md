---
titulo: "MANIFESTO-MIGRACAO — livro de migração e transcrição da terceira exúvia"
tipo: manifesto
status: ativo
temperatura: quente
path: MANIFESTO-MIGRACAO.md
created_at: "2026-07-06T00:19:51-03:00"
autor: codex
familia: OpenAI
natureza: nativo
validacao_ref: 0003-proveniencia-livro-razao
---

# MANIFESTO-MIGRACAO

Este é o livro da migração da `versao_3_0_0`. A regra vigente desta exúvia
vive nos documentos desta pasta; `versao_0_3_x/` e `versao_2_0_0/` são história
congelada, citáveis como prova de origem, nunca como regra vigente.

Vocabulário:

- `migra`: entra como regra/artefato vigente desta exúvia e carrega proveniência.
- `apêndice`: entra como suporte técnico ou fixture, mas não é documento
  normativo; exceção explícita do G-PROV.
- `morre`: não entra como regra vigente; permanece apenas em glacier/git.

## Decisão de transcrição

Campos ratificados para documentos migrados:

`natureza`, `migrado_de`, `id_original`, `created_at_original`,
`autor_original`, `transcrito_em`, `transcrito_por`, `validacao_ref`.

Para documentos migrados na gênese da v3, `created_at = transcrito_em =
2026-07-05T02:30:00-03:00`, o carimbo do nascimento desta exúvia no REGISTRY.
A transcrição mecânica de proveniência desta onda é validada por
`0003-proveniencia-livro-razao`.

Adendo T-AUTO da mesma onda: conteúdo normativo usado pela versão vigente deve
viver dentro da própria versão. `core/01-principios.md` transcreve P1–P13 para
eliminar a dependência vigente do índice constitucional pré-exúvia; referências
ao exoesqueleto/glacier permanecem apenas como histórico, consulta ou
proveniência.

## Elementos Que Migram

| elemento | classe | decisão | origem | validação |
|---|---|---|---|---|
| `core/01-principios.md` | spec | migra | `versao_2_0_0` | 0003 |
| `core/02-papeis.md` | spec | migra | `versao_2_0_0` | 0003 |
| `core/03-rito-da-onda.md` | spec | migra | `versao_2_0_0` | 0003 |
| `core/04-artefatos.md` | spec | migra | `versao_2_0_0` | 0003 |
| `core/05-guards.md` | spec | migra | `versao_2_0_0` | 0003 |
| `core/06-freeze-fitness-exuvia.md` | spec | migra | `versao_2_0_0` | 0003 |
| `core/07-projetos-membrana.md` | spec | migra | `versao_2_0_0` | 0003 |
| `core/08-evolucao.md` | spec | migra | `versao_2_0_0` | 0003 |
| `core/role-cards.md` | spec | migra | `versao_2_0_0` | 0003 |
| `core/dual-run-spec.md` | spec | migra | `v0.3.x`, id `20260610-38` | 0003 |
| `core/freeze-gate-spec.md` | spec | migra | `v0.3.x`, id `20260610-41` | 0003 |
| `core/exuvia-fitness-criteria.md` | spec | migra | `v0.3.x`, id `20260616-011004-codex-exuvia-fitness-criteria` | 0003 |
| `core/read-list-canonica.txt` | spec txt | migra | `versao_2_0_0` | 0003 |
| `core/actor-write-matrix.txt` | spec txt | migra | `versao_2_0_0` | 0003 |
| `guards/README.md` | dado normativo | migra | `v0.3.x` | 0003 |
| `.hbn/knowledge/0001..0032-*.md` | knowledge | migra | `v0.3.x` | 0003 |
| `.hbn/knowledge/INDEX.md` | knowledge-index | migra | `v0.3.x` | 0003 |
| `.hbn/knowledge/distribution-model.md` | knowledge | migra | `v0.3.x` | 0003 |
| `.hbn/knowledge/relay-protocol.md` | knowledge | migra | `v0.3.x` | 0003 |
| `.hbn/knowledge/runtime-command-model.md` | knowledge | migra | `v0.3.x` | 0003 |
| `.hbn/operators/README.md` | dado | migra | `v0.3.x` | 0003 |

## Elementos Nativos Da v3

| elemento | classe | decisão | origem | validação |
|---|---|---|---|---|
| `BOOT.md` | boot | migra como nativo | gênese v3 | 0001 + 0003 |
| `REGISTRY.md` | registry | migra como nativo | gênese v3 | 0001 + 0003 |
| `ROADMAP.md` | spec | migra como nativo | gênese v3 | 0001 + 0003 |
| `TRANSICAO.md` | spec | migra como nativo | gênese v3 | 0001 + 0003 |
| `.hbn/readbacks/0001-terceira-exuvia-genese.json` | readback | migra como nativo | gênese v3 | 0001 + 0003 |
| `.hbn/readbacks/0002-fechamento-pos-auditoria-v3.json` | readback | migra como nativo | onda 0002 | 0002 + 0003 |
| `.hbn/readbacks/0003-proveniencia-livro-razao.json` | readback | migra como nativo | onda 0003 | 0003 |
| `.hbn/messages/*.md` | despacho/handoff | migra como nativo | ondas 0002/0003 | readback correspondente |
| `.hbn/results/*-cross-ia-0001.md` | result-cross-ia | migra como nativo | auditoria 0001 | 0001 + 0003 |
| `.hbn/results/*-cross-ia-0002.md` | result-cross-ia | migra como nativo | auditoria 0002 | 0002 + 0003 |
| `.hbn/archive/PLACEHOLDER-*.md` | result-placeholder | migra como nativo frio | onda 0002 | 0002 + 0003 |
| `.hbn/knowledge/0033-*.md` | knowledge | migra como nativo | onda 0002 | 0002 + 0003 |
| `.hbn/knowledge/0034-*.md` | knowledge proposto | migra como nativo | onda 0002 | 0002 + 0003 |
| `guards/assert-doc-provenance.sh` | guard | migra como nativo | onda 0003 | 0003 |
| `guards/assert-version-self-contained.sh` | guard | migra como nativo | adendo T-AUTO 0003 | 0003 |

## Apêndices Técnicos

Estes arquivos são governados pelo REGISTRY, mas não são documentos de regra
com front-matter. O G-PROV os trata por exceção explícita e comentada.

| elemento | decisão | motivo |
|---|---|---|
| `schemas/*.schema.json` | apêndice | JSON Schema com semântica própria; adicionar metadados quebraria validação ou `additionalProperties`. |
| `guards/tests/fixtures/**/*.json` | apêndice | fixtures negativos/positivos precisam permanecer no formato testado. |
| `guards/fixtures/*.md` | apêndice | esqueletos/fixtures copiados byte-a-byte por instaladores e testes. |
| `.hbn/models/*.json` | apêndice | perfis são validados por `schemas/model-profile.schema.json`; metadados exigem onda própria de schema. |
| `membrane/MEMBRANE_MANIFEST.template.json` | apêndice | template de manifesto gerado por script; estrutura consumida por snapshot. |
| `guards/MANIFEST.yaml` | apêndice | manifesto técnico gerado de blocos `HBN-REQUIRES`. |
| `.hbn/stray-allowlist` | apêndice | lista de padrões para guard; formato linha-a-linha. |
| `LICENSE` | apêndice | licença legal; não recebe front-matter. |

## Elementos Que Morrem Como Regra Vigente

| elemento | decisão | destino |
|---|---|---|
| regra citada apenas por `versao_0_3_x/` | morre como vigente | consulta histórica no glacier/git |
| regra citada apenas por `versao_2_0_0/` | morre como vigente | consulta histórica no glacier/git |
| path raiz pré-exúvia (`methodology/**`, `agents/**`, `core/relay-spec.md`) | morre como vigente | referência rebaseada para `core/**`/knowledge desta versão quando virar regra |
| placeholders em `.hbn/results/` | morre como parecer | preservados frios em `.hbn/archive/PLACEHOLDER-*` |

## Pendências Declaradas

- `.hbn/models/*.json` deve ganhar vocabulário de proveniência apenas junto de
  uma revisão de `schemas/model-profile.schema.json`.
- `schemas/*.schema.json` pode receber envelope de metadados somente em onda que
  preserve compatibilidade com os consumidores de JSON Schema.
- `core/read-list-canonica.txt` mantém `PENDENTE_REHASH`; esta onda só registra
  proveniência e não recalcula hashes.
