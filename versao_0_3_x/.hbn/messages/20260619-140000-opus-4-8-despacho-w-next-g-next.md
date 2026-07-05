---
titulo: "Despacho — W-NEXT: guard G-NEXT (próximo ponto de conferência no disco)"
tipo: despacho
status: congelado
temperatura: glacier
path: .hbn/messages/20260619-140000-opus-4-8-despacho-w-next-g-next.md
readback_alvo: 0066-w-next-g-next
created_at: "2026-06-19T14:00:00-03:00"
autoria: "claude-opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - .hbn/relay/STATE.md
  - guards/hbn-guards-runner.sh
  - guards/assert-copy-block.sh
---

# HBN PEER REVIEW — Despacho W-NEXT / G-NEXT

## RELATO DE ESTADO — claude-opus-4-8 · orquestrador · 2026-06-19T14:00:00-03:00
SOU: claude-opus-4-8 · familia Anthropic · papel orquestrador.
STATE: ultima_atualizacao=2026-06-19T14:00:00-03:00 readback_ativo=.hbn/readbacks/0066-w-next-g-next.json; G-NEXT PROPOSTO; main intocada 4db6928; HEAD e614be2.
PRÓXIMA AÇÃO: Cross-audit do G-NEXT (readback 0066); aguardar >=2 familias != OpenAI + hearback humano antes de selar; nao iniciar W-ORQ-4/W-FREEZE.
SITUACAO: gate quer tornar o "próximo ponto de conferência" um fato de disco, guard-enforçado, com avanço por "pronto".
BASTAO: claude-opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- k-0031: cada disparo a uma IA é chat NOVO — instrução autossuficiente, idempotente, ato atômico num só shot.
- O guard garante o CAMPO no disco; quem lê e apresenta é o orquestrador/harness ("pronto" = avançar).

O payload abaixo (entre as sentinelas) é o que vai verbatim ao codex; tudo fora é moldura humana.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memória — tudo aqui é autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: e614be2 (chore: seal G-COPY). main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Você é o implementador (OpenAI). Orquestrador = claude-opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem git add . (stage explícito); honre TODOS os guards; se um guard bloquear, PARE e relate, nunca contorne; você escreve o bash (§2.10).
- IDEMPOTÊNCIA: se algo abaixo já existir no disco, confira e relate — NÃO duplique.

READBACK A CRIAR: .hbn/readbacks/0066-w-next-g-next.json (0066 = próximo monotônico após 0065).
ATO: implementação (NÃO é ato de autoridade) — regenere a atestação same-fp normalmente (4a); pare no handoff para cross-audit ≠-OpenAI. NÃO selar.

## Intenção
Criar o guard G-NEXT, que torna o "próximo ponto de conferência" um campo legível por máquina em .hbn/relay/STATE.md, para que o orquestrador (e a automação) leiam o próximo passo do DISCO, em ordem de decisão, sem depender de prosa de chat.

## Comportamento exigido (você escreve o bash — §2.10)
Novo guard guards/assert-next-checkpoint.sh (G-NEXT), padrão C3 (staged local :path; HEAD:path / range em CI), validando o BLOB STAGED, nunca a working tree (E-FECH-01). Escopo: TODO commit em que .hbn/relay/STATE.md seja adicionado/modificado (diff-filter=AM). Regra:
1. O front-matter YAML de STATE.md deve conter EXATAMENTE UM mapeamento top-level `proximo_ponto` com os campos:
   - passo: string não-vazia
   - ato: ∈ {implementacao, cross-audit, hearback, selagem, freeze, fim}
   - destino: ∈ (apelidos de guards/data/auditor-families.txt) ∪ {codex, human, nenhum}
   - gate: ∈ {nenhum, hearback_humano}
   - bloco_ref: caminho versionado que EXISTE no disco (git cat-file -e :bloco_ref localmente; HEAD:bloco_ref em CI) — OU a string "nenhum" quando ato ∈ {fim}
   - status: ∈ {pendente, em_curso, concluido}
2. Ausência do mapa, campo faltando, valor fora do enum, destino não-canônico, bloco_ref inexistente (quando ≠ "nenhum"), ou mapa duplicado ⇒ BLOQUEIA (fail-closed). Use python3 para o parse YAML (precedente assert-scope-lock).
3. NÃO reavaliar STATE de commits já existentes — só o STATE staged/no range deste commit (forward-only).

## Ativação
Adicionar G-NEXT ao guards/hbn-guards-runner.sh nesta entrega. Como o próprio commit 0066 modifica STATE.md, ele JÁ deve carregar um proximo_ponto válido (bootstrap): defina em STATE.md, no front-matter:
  proximo_ponto:
    passo: "cross-audit do G-NEXT (readback 0066)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260619-140000-opus-4-8-despacho-w-next-g-next.md
    status: pendente
Selo de vigência: PROPOSED_UNTIL_CROSS_AUDIT (suíte verde + cross-audit ≥2 famílias ≠-OpenAI + hearback antes de selar; readback ≥0067).

## files_allowed (stage explícito)
- guards/assert-next-checkpoint.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260619-140000-opus-4-8-despacho-w-next-g-next.md
- .hbn/readbacks/0066-w-next-g-next.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/**, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/** (não tocar o mapa).

## tests_required
- run-guard-tests.sh: caso BOM (STATE com proximo_ponto bem-formado passa) + casos-ruins (sem mapa; ato fora do enum; destino não-canônico; bloco_ref inexistente; mapa duplicado) BLOQUEADOS.
- adversarial-battery.sh: entradas B63+ para as burlas acima.
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## trailers (contíguos)
HBN-Readback: 0066
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit ÚNICO da entrega 0066 (prepare -> stage explícito -> COMMIT, num só shot). Após o commit, PARE no handoff para cross-audit ≠-OpenAI. NÃO selar G-NEXT. NÃO iniciar W-ORQ-4/W-FREEZE. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
