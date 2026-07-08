# Consolidação — auditoria cross-family do Batch 1+2 (2026-06-16)

> Zona Fronteira / não-normativo. Consolidação feita pelo chat paralelo
> (analista-de-fronteira, Anthropic) a partir dos pareceres externos. Truth Barrier:
> achados novos verificados no disco nesta data.

## Pareceres recebidos (cobertura cross-family)

- **Cursor · Composer** (`cursor-composer`) — depositado em `.hbn/results/20260616-230608-cursor-composer-cross-ia-batch1-fronteira.md`.
- **Gemini via Antigravity** (`antigravity`, família Google) — BLOQUEAR, confiança 95–100.
- **Codex** (`gpt-5`, família OpenAI) — depositado em `.hbn/results/20260616-231038-gpt-5-cross-ia-batch1-fronteira.md`.
- **OBS honesta:** o texto colado como "Grok" era uma **cópia idêntica do parecer do Cursor** — não temos visão independente do Grok ainda. Cobertura real de famílias: Anthropic (autor) + OpenAI (Codex) + Google (Gemini/Antigravity) + Cursor. É cross-family suficiente.

## Matriz de vereditos

| Deliverable | Cursor | Antigravity/Gemini | Codex | Síntese |
|---|---|---|---|---|
| A1 front-door | SIM 72 | NÃO 95 | NÃO | Ideia boa; **não promover** até existir G-FDACK + acoplar `HBN-Token-FP` (ack emprestado é burla barata) |
| A2 árvores | SIM 78 | NÃO 95 | NÃO | Eixos ortogonais OK; **etiqueta sem guard é frágil** — precisa guard anti-mislabel + G-REG em `M` |
| A3 compilador | SIM 75 | NÃO 90 | SIM | Só **proveniência** (`HBN-Spec-Source`) agora; adiar bloco `enforcement:` até `G-PROV` |
| B1 code review | SIM 92 | NÃO 100 | SIM | **CONFIRMADO unânime** (factual, reproduzível) |
| B2 honestidade | SIM 90 | NÃO 100 | SIM | **CONFIRMADO unânime** (factual, reproduzível) |
| PF-ARVORES-AGORA | SIM 70 | NÃO 95 | NÃO | Etiquetar agora OK; guard anti-mislabel **obrigatório antes do Credenciamento** |

**Leitura crítica do "SIM × NÃO":** a pergunta de veredito foi ambígua. Cursor leu "aprovar como Fronteira" (SIM); Antigravity/Codex leram "aprovar promoção/freeze" (NÃO). Substantivamente **não há divergência**: o Antigravity, ao votar NÃO em B1/B2, **confirma cada fato** de B1/B2 com evidência. Logo:

> **Veredito consolidado:** a análise do Batch 1+2 é **confirmada como válida e valiosa** pelas três famílias. A **promoção normativa e o freeze ficam BLOQUEADOS** até a onda de correções runtime + os guards de etiqueta/ack. (Lição: padronizar a pergunta de veredito — "aprovar como Fronteira" ≠ "aprovar promoção/freeze".)

## Convergências (todos concordam)

- B1: `cli.py` `main()` retorna exit 0 mesmo em erro/violação (`src/usehbn/cli.py:1732,1759,1772`, `run_handoff` 1607/1613).
- B1: três diretórios de estado coexistem (`.hbn/` `cli.py:752`; `.usehbn/` `utils/config.py:12`; `state/` `runtime.py:377`).
- B2: `autoevolve` é teatro (`worker.py:4-6` no-op; `approval.py:27` sobre `contract.py:49-50` default 0) e ausente da matriz.
- Eixos `arvore:`/`temperatura:`/`hbn-track:` são ortogonais (não criam tabela paralela).
- **Registry-centric > partição física** de diretórios (unânime; partição física quebra git log/paths — Antigravity divergência crítica).
- Compilador: **proveniência antes de geração**; geração de guard a partir de prosa fica como pesquisa de Fronteira.

## Achados NOVOS dos auditores — verificados no disco hoje (fortalecem o pacote)

- **Contagem de testes real ≈ 181** (coleta de `def test_` únicos = 181). Tanto `AGENTS.md:57` (93/93) quanto a matriz/README (114) estão **defasados**. Dívida de honestidade maior que a relatada no B2.
- **G-REG ignora modificações.** `guards/assert-registry-line.sh:71,73` usa `--diff-filter=AR` → **edição (`M`) de front-matter não dispara o guard**. Como a promoção de árvore (mudar `arvore:`) é uma edição, ela passaria **silenciosa e sem linha no REGISTRY**. Bloqueador direto da proposta de árvores.
- **Autorização humana é forjável.** `guards/assert-dispatch-integrity.sh:201-202` só checa `human_authorization` não-vazio — **sem assinatura criptográfica**. Combinado ao G-HRB "PENDENTE DE CHAVE" (`STATE.md`), qualquer IA com escrita poderia forjar hearback humano, pareceres de cross-audit e perfis de modelo (`.hbn/models/*.json` em texto plano → burla do G-FAM). **É a lacuna de segurança mais profunda do conjunto.**
- Fraude de timestamp em acks (`created_at` não validado contra relógio/git).

## Sequência recomendada (convergente entre os auditores)

**Onda R1 — correção de runtime + honestidade (P0; ANTES do freeze e da Ponte):**
1. Exit codes: hierarquia `HbnProtocolViolation`; `main()` sai com código ≠0 em erro/violação (≠0 CLI = 2, violação = 3).
2. Unificar diretório de estado: `.hbn/` canônico + subdir de estado explícito; eliminar `.usehbn/` e `state/` legados; migrar leitores.
3. Golden tests dos 17 subcomandos ANTES de qualquer refatoração (rede de segurança).
4. Honestidade: registrar `autoevolve` na matriz (Scaffold/Stub) + neutralizar o teatro (texto do CLI explícito); **rodar pytest e alinhar a contagem real (~181) em AGENTS/README/matriz**; corrigir ponteiro SUPERSEDED (`AGENTS.md:17`) e "L4" (`README.md:559`).

**Onda R2 — árvores registry-centric + enforcement (a penúltima onda do orquestrador):**
5. Estender G-REG para disparar em `M` quando muda metadado de ciclo de vida (`arvore:`/`temperatura:`) e exigir linha no REGISTRY no mesmo commit.
6. Guard anti-mislabel para `arvore:` (etiqueta `estavel`/`intermediaria` exige registro de promoção; sem isso, bloqueia).
7. Spec do campo `arvore:` + etiquetagem **registry-centric, não diretórios físicos**.

**Onda R3 — proveniência + front-door (ondas próprias):**
8. C1: trailer `HBN-Spec-Source` obrigatório nos guards (hoje 10/26 citam o spec); adiar bloco `enforcement:` até `G-PROV`.
9. G-FDACK com acoplamento `HBN-Token-FP` (ack atado ao fingerprint do bastão — mata o ack emprestado).

**Gated por decisão humana (não é tarefa Codex agora):**
- **Assinatura criptográfica** (G-HRB + perfis de modelo): ativar `ssh-keygen -Y verify`/GPG. Exige Maurício gerar/registrar `.hbn/operators/<nome>.pub`. Lacuna de segurança mais profunda — recomendação prioritária pós-R1.
- **Governança** (emenda P13, regra CRISPR, escopo da exúvia, esteiras/chapéu): via ADR/onda própria (C1–C5 da rodada), separada do runtime.

## Sobre a 5ª IA (Jules)

Concordo com o plano: Jules precisa de acesso ao GitHub e o espelho está defasado. Melhor **primeiro atualizar tudo** (R1–R3 + publicação honesta), e **depois** acionar o Jules como **validação externa independente** sobre o código publicado — visão de fora, sem o contexto interno. Fica como marco pós-MVP, não agora.
