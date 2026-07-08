---
titulo: "Despacho — W-COPY: guard G-COPY (bloco copiável determinístico)"
tipo: despacho
status: congelado
temperatura: glacier
path: .hbn/messages/20260618-214500-opus-4-8-despacho-g-copy.md
readback_alvo: 0064-w-copy-g-copy
created_at: "2026-06-18T21:45:00-03:00"
autoria: "claude-opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
---

# HBN PEER REVIEW — Despacho W-COPY / G-COPY

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-18T21:45:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-18T21:45:00-03:00 readback_ativo=.hbn/readbacks/0064-w-copy-g-copy.json; main intocada 4db6928.
PRÓXIMA AÇÃO: Cross-audit G-COPY por >=2 familias != OpenAI e hearback humano antes da selagem; nao iniciar W-ORQ-4 nem W-FREEZE.
SITUACAO: G-COPY entregue como PROPOSED_UNTIL_CROSS_AUDIT; aguarda auditoria cruzada e hearback antes de selagem.
BASTAO: claude-opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)

Nenhuma decisao informal adicional; este despacho ja traz o bloco copiavel
deterministico que o proprio G-COPY passa a exigir de despachos/prompts novos.

⟦HBN-COPY dest=codex⟧ BEGIN
PARA: codex (implementador · OpenAI). SOB: bastão token_fp 34a7f2f9. ORQUESTRADOR: claude-opus-4-8 · Anthropic (§2.9a OK). TRACK: safe_track.
READBACK A CRIAR: .hbn/readbacks/0064-w-copy-g-copy.json (0064 = próximo monotônico após 0063).
ATO: implementação (NÃO é ato de autoridade) — regenere a atestação same-fp normalmente (4a); pare no handoff para cross-audit ≠-OpenAI.

## Intenção
Criar o guard G-COPY que torna o "bloco copiável" um contrato MECÂNICO no artefato depositado, para que a automação extraia o payload do ARQUIVO (fonte de verdade) e não dependa da disciplina do orquestrador no chat.

## Comportamento exigido (você escreve o bash — §2.10)
Novo guard guards/assert-copy-block.sh (G-COPY), padrão C3 (diff staged local; HBN_DIFF_BASE...HEAD em CI), escopo = arquivos ADICIONADOS (diff-filter=A) em .hbn/messages/ e docs/prompts/ cujo front-matter tenha tipo ∈ {despacho, prompt}:
1. O corpo deve conter EXATAMENTE UM bloco delimitado por linha de abertura `⟦HBN-COPY dest=<apelido>⟧ BEGIN` e linha de fecho `⟦HBN-COPY END⟧`, cada uma sozinha na linha.
2. <apelido> de dest ∈ apelidos de guards/data/auditor-families.txt ∪ {codex, human}. dest fora disso ⇒ BLOQUEIA.
3. Payload (linhas entre BEGIN e END) não-vazio. Zero blocos, >1 bloco, BEGIN sem END, END antes de BEGIN, ou dest malformado ⇒ BLOQUEIA (fail-closed).
4. Validar o BLOB STAGED (git show :path; HEAD:path em CI), nunca a working tree (E-FECH-01).
5. Garantir que o token `⟦HBN-COPY …⟧` NÃO colide com o gatilho literal do G-PTR (são tokens distintos; confirme com teste que G-PTR não dispara nas linhas-sentinela).
6. Artefatos JÁ tracked (legado, ex. o despacho de selagem 0063) NÃO são reavaliados — só os adicionados a partir de agora. Não retrofitar.

## Ativação
Adicionar G-COPY ao guards/hbn-guards-runner.sh nesta entrega, porém o selo de vigência fica PROPOSED_UNTIL_CROSS_AUDIT: exige suíte verde + cross-audit ≥2 famílias ≠-OpenAI + hearback humano antes da selagem (readback ≥0065).

## files_allowed (stage explícito)
- guards/assert-copy-block.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260618-214500-opus-4-8-despacho-g-copy.md
- .hbn/readbacks/0064-w-copy-g-copy.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/**, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/** (não tocar o mapa).

## tests_required (após hearback)
- run-guard-tests.sh: caso BOM (artefato com 1 bloco bem-formado passa) + caso-ruins (0 blocos, 2 blocos, BEGIN sem END, dest inválido, payload vazio) BLOQUEADOS.
- adversarial-battery.sh: entradas B55+ para as burlas acima.
- runner verde; git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## trailers (contíguos)
HBN-Readback: 0064
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
PARAR no handoff para cross-audit ≠-OpenAI; NÃO selar G-COPY nesta entrega; NÃO iniciar W-ORQ-4/W-FREEZE.
⟦HBN-COPY END⟧
