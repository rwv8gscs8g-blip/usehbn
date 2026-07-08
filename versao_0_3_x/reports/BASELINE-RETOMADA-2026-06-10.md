---
titulo: Baseline do custo de retomada — onda 0177 (Credenciamento)
diataxis: reference
status: congelado
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, ciclo C1 Bastão 2.0)
evidencia: medição `wc -c` sobre /Users/macbookpro/Projetos/Credenciamento em 2026-06-10
temperatura: glacier
---

# Baseline — quanto custa retomar a onda 0177 hoje

Medição real (bytes via `wc -c`) do que o sucessor (Opus) é mandado ler para
retomar a onda 0177, seguindo o caminho oficial: handoff item 10 → AGENTS.md
"Antes de tocar qualquer coisa" (16 itens) → relay INDEX.

## Camada A — trilha do handoff 0177

| Item | KB |
|---|---|
| `.hbn/messages/20260610-0110-handoff-fim-sessao-codex-bastao-codex-para-opus.md` | 5,8 |
| `.hbn/readbacks/0177-rb-onda-38-2-44-handoff-opus-pendencias-v206-v207.json` | 6,2 |
| `.hbn/hearbacks/0177-rb-...-confirmed.json` | 0,4 |
| **Subtotal A (3 arquivos)** | **12,4** |

## Camada B — leituras obrigatórias do handoff (item 10, textuais)

| Item | KB |
|---|---|
| `AGENTS.md` | 14,4 |
| `.hbn/relay/INDEX.md` (2.162 linhas) | **173,9** |
| `.hbn/knowledge/0014-protocolo-fim-de-sessao.md` | 4,6 |
| `.hbn/knowledge/0019-cadencia-d-estendida-passagem-bastao.md` | 3,8 |
| `.hbn/knowledge/0022-firewall-workflow-fast-track.md` | 3,1 |
| `.hbn/results/0176-exec-...json` | 10,5 |
| `.hbn/results/0177-exec-...json` | 4,8 |
| `.hbn/messages/20260610-0110-prompts-auditoria-cruzada-v206-v207.md` | 7,4 |
| `.hbn/protocol-evolutions/20260610-usehbn-passagem-bastao-...md` | 3,1 |
| **Subtotal B (9 arquivos)** | **225,6** |

(PDFs 039–048 são binários de evidência visual; fora da conta textual.)

## Camada C — read-list de 16 itens do AGENTS.md (o que B item 1 manda ler)

| Item | KB |
|---|---|
| knowledge 0001 + 0002 + 0003 + 0010 + 0011 + 0012 + 0013 + 0021 (8 arquivos) | 36,2 |
| `auditoria/00_status/105_AUDITORIA_HANDOFF_V206_V207_...md` | 20,8 |
| `scripts/hbn-guards/README.md` + `.hbn/schemas/README.md` | 8,8 |
| release V205 + regras V205 + jornada V205 + evidências INDEX (4 arquivos) | 15,8 |
| `usehbn/docs/PHAGOCYTOSIS-VBA-PATTERNS.md` | **71,4** |
| **Subtotal C (16 arquivos)** | **155,0** |

## Total

| Cenário | Arquivos | KB |
|---|---|---|
| Mínimo praticado (A + B, ignorando a cascata do AGENTS.md) | 12 | **238,0** |
| Caminho oficial completo (A + B + C) | 28 | **393,0** |

## Diagnóstico (2 linhas)

O vilão isolado é `.hbn/relay/INDEX.md`: 174 KB porque ESTADO (5 campos
vigentes no front-matter) e LOG (177 ondas de histórico) vivem no mesmo
arquivo append-only. Segundo vilão: read-list de 16 itens onde só ~4 mudam
entre ondas. Meta do C1: retomada com ≤5 arquivos / ≤40 KB.
