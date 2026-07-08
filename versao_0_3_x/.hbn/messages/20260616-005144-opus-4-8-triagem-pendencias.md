---
titulo: "Triagem de pendências em aberto — pós-S2 (2026-06-16)"
tipo: analise
status: congelado
temperatura: glacier
path: .hbn/messages/20260616-005144-opus-4-8-triagem-pendencias.md
id-global: 20260616-005144-opus-4-8-triagem-pendencias
autor: claude-opus-4-8 (orquestrador)
created_at: "2026-06-16T00:51:44-03:00"
---

RELATO DE ESTADO — opus-4-8 · documento · 2026-06-16T00:51:44-03:00
STATE: ultima_atualizacao=2026-06-16T01:24:52-03:00 (carimbo de deposito 0027)
PRÓXIMA AÇÃO: Abrir a faxina 0027 para tratar os untracked antigos, a triagem/criterios de exuvia e os marginais H/EXTRA documentados, sem alterar logica de guard nesta selagem.

# Triagem de pendências em aberto — pós-S2

Levantado do disco: `.hbn/relay/STATE.md` (sinais_abertos), readback 0025
(out_of_scope), handoff S2, `ROADMAP.md` e marcadores `PENDENTE/FUTURO` em
`core/**`. Cada item: classificação + ação recomendada. Nenhuma ação tomada —
isto é mapa para sua decisão.

## A. Corrigir / fechar no fluxo atual (curto prazo)

| # | Pendência | Onde | Ação recomendada |
|---|---|---|---|
| A1 | Cross-audit de S2 pendente | STATE sinal 🟡; handoff S2 | EM ANDAMENTO — despachos Gemini+Cursor prontos para colar. |
| A2 | Selagem de S2 | proxima_acao | Após 2× APROVA_S2: SIM, abrir micro-onda readback 0026. |
| A3 | Dois despachos do orquestrador untracked (abertura S2 + cross-audit S2) | worktree | Selar junto com 0026, em micro-onda própria. Não deixar acumular. |
| A4 | Marginal dos trailers não-contíguos | commits S2 | Decidir no cross-audit S2: exigir bloco contíguo (CI por range) OU won't-fix documentado. Hoje os guards passam por grep. |

## B. Gates humanos (só você resolve — IA não pode)

| # | Pendência | Onde | Ação recomendada |
|---|---|---|---|
| B1 | Branch protection no GitHub (hbn-shield obrigatório no push) | STATE 🟡; report F-10 | Configurar no GitHub. Enquanto aberto, o enforcement é só local. |
| B2 | G-HRB: chave SSH `.hbn/operators/<nome>.pub` | STATE 🟡; report G-HRB | Gerar/registrar a chave para ativar `ssh-keygen -Y verify`; sem ela, hearback assinado não enforça. |
| B3 | F-02: formato da linha `superseded_by` (0035 UTC×REGISTRY) | STATE 🟡 | Definir o formato; é decisão de convenção sua. |
| B4 | Hearback 0002 pendente | report (gates humanos) | Confirmar/registrar quando aplicável. |

## C. Frentes PROPOSED — decisão de sequência (antes/depois de S3-S5)

| # | Pendência | Onde | Ação recomendada |
|---|---|---|---|
| C1 | D-ORQ-WRITE (cl.10): cross-audit ≠ Anthropic/OpenAI; enforcement só em S4 | STATE 🟡; report; orchestrator-profile-spec:11 | Decidir se o cross-audit de família neutra entra antes de S3 ou fica para S4. G-ACTOR-WRITE-MATRIX segue reservado. |
| C2 | F-01 (desenhista=implementador=fable) PROPOSED_UNTIL_CROSS_AUDIT | STATE 🔴 | Ratificar via cross-audit ou deixar expirar; hoje é exceção ativa rastreável. |
| C3 | Perfis grok/cursor `proposed`; marginal `cursor.json` model_id vs runtime | STATE nota S0; report | Promover a `accepted` em onda futura após confronto model_id×runtime. |

## D. Reconciliação / higiene (não bloqueia, mas acumula)

| # | Pendência | Onde | Ação recomendada |
|---|---|---|---|
| D1 | Seis untracked antigos (2 handoffs fable5 + 4 results exúvia/onda-0011) | worktree | Reconciliação humana: selar em micro-onda dedicada OU descartar. Acumulam há dias no índice sujo. |
| D2 | Diretórios scratch de teste (`guards/tests/cr-*`, `adv-cr-*`) | worktree | As suítes os deixam e a sandbox impede `rm` (`.git` imutável). Adicionar ao `.gitignore` ou rotina de limpeza pós-suite. |

## E. Versões à frente (roadmap — já especificado como futuro)

| # | Pendência | Onde | Ação recomendada |
|---|---|---|---|
| E1 | S3-S5 da série de governança; conteúdo de S3 a definir | report (S2-S5) | Definir escopo de S3 após selar S2. D-ORQ-WRITE enforcement marcado para S4. |
| E2 | Ativação da exúvia bloqueada (Fitness Gate: baseline funcional + Ponte verde + confronto incumbente×desafiante) | STATE 🔴; core/hbn-exuvia-scaffold | M-C, depois do Fitness Gate. Não tocar agora. |
| E3 | Ponte vetada (0034 Codex + 0035 Antigravity = VETO_ADOCAO) | STATE 🔴 | Corrigir bloqueadores antes de descongelar a Ponte. Pré-requisito de E2. |
| E4 | Backlog: bump 0.3.1, inbox/credenciamento, versionamento de readbacks | STATE 🟡 | Ondas futuras. |
| E5 | Roadmap de PRODUTO (TestPyPI/PyPI, `hbn relay query`, `hbn inspect`, i18n) | ROADMAP.md | Trilha separada da governança; não confundir com a série S. |

## Leitura rápida (o que realmente trava o quê)

- Caminho crítico imediato: **A1 → A2** (cross-audit, depois selagem). Tudo o mais é paralelo ou futuro.
- Maior risco silencioso: **B1/B2** — sem branch protection (B1) e sem chave de hearback (B2), a governança é forte localmente mas não no `origin`. São só seus para resolver.
- Decisão estratégica de sequência: **C1 (D-ORQ-WRITE)** — define quanto de S3/S4 já mexe na escrita do orquestrador.
- Dívida de higiene acumulando: **D1/D2** — não urgente, mas cada onda deixa o worktree mais sujo.
