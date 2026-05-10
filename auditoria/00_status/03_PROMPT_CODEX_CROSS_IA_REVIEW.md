---
titulo: 03 - Prompt Cross-IA Review — Codex CLI (perspectiva operacional/cirúrgica)
diataxis: how-to
hbn-track: safe_track
hbn-status: active
audiencia: codex CLI (consumir) + operador (mediar)
versao-protocolo: useHBN pre-v1
data: 2026-05-09
autor: Claude Opus 4.7 (chat arquiteto-mestre useHBN)
relacionado:
  - 9 ADRs em methodology/adr/ (PROPOSED desde 2026-05-09)
  - methodology/PRINCIPIOS-CONSTITUCIONAIS.md (P1-P13 canônicos)
  - 04_PROMPT_ANTIGRAVITY_CROSS_IA_REVIEW.md (par complementar)
escopo: cross-IA review obrigatório por ADRs estruturais (P10)
---

# 03. Prompt Cross-IA Review — Codex CLI

> Este é o prompt para a **sessão Codex CLI no terminal** dedicada a
> cross-IA review dos 9 ADRs. NÃO é a sessão Codex que está fazendo
> rollback MICRO49 no Credenciamento (essa mantém bastão F1).
> Esta é uma sessão NOVA com bastão de cross-IA review do useHBN
> (sem absorver F1 nem F2 — apenas auditor cruzado).

## Por que Codex para esta auditoria

Codex CLI tem capacidades cirúrgicas que pesam mais nos ADRs com
contrato técnico:

- **Validação contra código real**: pode grep/find no `src/usehbn/`,
  `schemas/`, `core/`, `agents/`.
- **Detecção de conflitos contrato↔implementação**: ex.: ADR-004 declara
  `useHBN-version: ^X.Y.Z` em AGENTS.md — Codex valida que `pyproject.toml`,
  `__init__.py:__version__`, e `protocol_version` em schemas batem.
- **Análise de runtime adapters**: ADR-006 introduz 5 sinais novos —
  Codex valida onde cada um se conecta em `runtime.py:_adapter_body` +
  `agents/wave-protocol.md`.
- **Estimativa de blast radius operacional**: linhas afetadas por ADR,
  testes que precisam mudar, CLI surface impactada.

Esta perspectiva complementa Antigravity (que faz análise conceitual/
estratégica em paralelo).

## Bloco copiável para sessão Codex CLI

```text
=================== INICIO PROMPT CROSS-IA CODEX (USEHBN) ===================

Voce e Codex CLI assumindo papel de AUDITOR CROSS-IA do protocolo
useHBN em /Users/macbookpro/Projetos/usehbn/. Esta sessao e DIFERENTE
da sessao Codex que esta fazendo rollback MICRO49 no Credenciamento;
nao toque /Users/macbookpro/Projetos/Credenciamento/ exceto leitura.

Primeira linha obrigatoria:
✅ HBN ACTIVE — Codex CLI auditor cross-IA do useHBN, 2026-05-09 —
review dos 9 ADRs depositados em methodology/adr/.

## Identidade e papel

- Voce NAO escreve ADRs novos. NAO modifica codigo de producao. NAO
  modifica os ADRs existentes.
- Voce produz UM PARECER POR ADR em modo cirurgico: factibilidade
  tecnica, conflitos com codigo existente, gaps de implementacao,
  riscos nao declarados, blast radius estimado.
- Voce e PAR de cross-IA com Antigravity (que faz a vertente conceitual
  em paralelo, em sessao separada). Sua perspectiva complementa, nao
  duplica.

## Leitura obrigatoria antes de qualquer parecer (NESTA ORDEM)

Em /Users/macbookpro/Projetos/usehbn/:

1. auditoria/00_status/00_BOOTSTRAP_PROTOCOLO_2026_05_09.md
2. auditoria/00_status/02_ADDENDUM_BOOTSTRAP_2026_05_09.md
3. methodology/PRINCIPIOS-CONSTITUCIONAIS.md (fonte canonica P1-P13)
4. methodology/adr/INDEX.md
5. methodology/adr/ADR-001 ate ADR-009 (todos os 9 .md)
6. README.md, CHANGELOG.md, ROADMAP.md
7. core/ (5 specs)
8. agents/ (5 contratos de IA)
9. schemas/ (7 schemas JSON)
10. src/usehbn/ (estrutura — pelo menos cli.py, runtime.py, protocol/, state/)
11. .hbn/relay/INDEX.md

Em /Users/macbookpro/Projetos/Credenciamento/ (read-only — `cat`/`grep`/`ls`):

12. auditoria/00_status/66_HANDOFF_OPUS_PARA_CHAT_USEHBN_2026_05_09.md
13. usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md (origem)

## Tarefa: 9 pareceres cirurgicos

Para cada ADR (na ordem 002 → 003 → 004 → 009 → 001 → 005 → 006 → 007 →
008), produza um parecer em
.hbn/results/00NN-cross-ia-codex-ADR-MMM.json (NN = numero sequencial
disponivel; MMM = numero do ADR).

Schema do parecer:

{
  "schema_version": "1.0",
  "adr_id": "ADR-002",
  "auditor": "codex-cli",
  "session_role": "cross-ia-review-usehbn",
  "reviewed_at": "2026-05-XXTHH:MM:SSZ",
  "veredito_tecnico": "APROVADO_SEM_RESSALVA | APROVADO_COM_RESSALVA | REPROVADO",
  "ressalvas_bloqueantes": [
    {
      "tema": "<resumo>",
      "evidencia": "<arquivo:linha ou ausencia explicita>",
      "remediacao_proposta": "<o que precisa mudar no ADR ou em arquivo de codigo antes de ACCEPTED>"
    }
  ],
  "ressalvas_nao_bloqueantes": [
    "<lista de itens P2/P3 — melhorias, nao impedem ratificacao>"
  ],
  "factibilidade_tecnica": {
    "implementavel_em_v0_3_0": true | false,
    "dependencias_externas_necessarias": ["<libs novas, scripts novos, etc>"],
    "blast_radius_estimado": {
      "arquivos_afetados": <int>,
      "testes_a_atualizar": <int>,
      "cli_surface_impactada": true | false
    }
  },
  "conflitos_com_codigo_existente": [
    {
      "arquivo": "<caminho>:<linha>",
      "natureza": "<contrato divergente | termo doutrinario divergente | schema divergente>",
      "severidade": "P0 | P1 | P2"
    }
  ],
  "riscos_nao_declarados_no_adr": [
    {
      "descricao": "<>",
      "evidencia": "<>"
    }
  ],
  "alinhamento_com_p1_p13": {
    "principios_apoiados": ["P2", "P5", "P6", "..."],
    "principios_em_tensao": ["<P_n se houver tensao>"],
    "comentario": "<curto>"
  },
  "recomendacao_para_humano": "RATIFICAR | RATIFICAR_APOS_RESSALVAS | NAO_RATIFICAR_AGORA",
  "comentario_livre": "<ate 200 palavras>"
}

## Pontos onde sua perspectiva agrega mais (priorize esses ADRs)

- **ADR-002** (Tipologia): valide contrato AGENTS.md `useHBN-version`
  contra schemas existentes e runtime adapters. AGENTS.md raiz
  inexistente hoje — qual o impacto operacional?
- **ADR-003** (Topologia): valide se mover `core/` → `modules/`
  quebra imports em src/usehbn/ ou em runtime adapters. Liste arquivos
  que referenciam `core/`.
- **ADR-004** (SemVer): valide compatibilidade entre `protocol_version`
  no schema (Onda 2 ja entregue), `__version__` em src/usehbn/__init__.py,
  e `pyproject.toml`. Verifique se bump MAJOR para v1.0.0 (que torna
  protocol_version required) tem caminho de migracao seguro.
- **ADR-006** (Sinais multi-repo): valide pontos de injecao em
  src/usehbn/runtime.py:_adapter_body, agents/wave-protocol.md e
  core/protocol.md. Onde cada um dos 5 sinais novos seria emitido?
- **ADR-008** (Migracao snapshot): valide a especificacao de
  bin/usehbn-fetch.sh e bin/usehbn-verify.sh. Esquema de checksum
  (PROTOCOL_SHA256.txt) — basta sha256 da concatenacao? Existe ja
  algum precedente em `hbn doctor`?

ADRs onde Antigravity tem mais a dizer (revise mas seja mais breve):
ADR-001 (Quarta — ritual), ADR-005 (licenciamento — estrategia),
ADR-007 (metricas — Goodhart), ADR-009 (constituicao — filosofia).

## Restricoes

- NAO modifique nenhum arquivo em methodology/, docs/, core/, agents/,
  schemas/, src/, ou .hbn/relay/. Apenas leitura. Escrita SOMENTE em
  .hbn/results/00NN-cross-ia-codex-ADR-MMM.json.
- NAO escreva codigo de producao. Se identificar bug em codigo
  existente, anote no comentario_livre do parecer relevante; nao corrija.
- NAO toque /Users/macbookpro/Projetos/Credenciamento/. Apenas leitura
  de arquivos historicos para contexto.
- Glasswing G6 estrito: nada de codigo de producao na resposta do chat
  — tudo em arquivos no repo via tools normais.
- Truth Barrier estrito: claims absolutos ("100%", "totalmente seguro",
  "zero risco") proibidos.
- Convencao numerada com ponto-e-virgula no chat: 1) ... ; 2) ... ; em
  vez de Q1/Q2/Q3.
- Cada turno comeca com sinal HBN (✅ / 🟡 / ❌ / 🔵).

## Sequencia esperada

1. Leitura completa dos 13 itens da §"Leitura obrigatoria" (1-2h).
2. Pareceres 1 a 9 (em ordem 002 → 003 → 004 → 009 → 001 → 005 → 006 →
   007 → 008). Cada parecer e um JSON em .hbn/results/.
3. Apos os 9 pareceres, escreva sintese curta em
   .hbn/results/00NN-cross-ia-codex-SINTESE.json com:
   - top 3 ADRs com maior risco operacional
   - top 3 ADRs com mais ressalvas bloqueantes
   - lista cumulativa de conflitos codigo-existente x ADR
   - recomendacao final consolidada (RATIFICAR / RATIFICAR_APOS_RESSALVAS /
     NAO_RATIFICAR_AGORA) por ADR.
4. Sinalize 🔵 HBN HANDOFF READY no chat e pare. Operador encaminha
   pareceres ao Opus chat-arquiteto que consolida com pareceres do
   Antigravity (par complementar).

## Como NAO duplicar Antigravity

Antigravity vai focar em: coerencia narrativa entre os 13 principios
e os 9 ADRs, comparacao com protocolos universais (MCP/LSP/OTel),
sinal cultural da licenca, analise antropologica do ritual da Quarta,
risco de Goodhart nas metricas. NAO faca isso. Se um ADR e mais
"conceitual que operacional" (001, 005, 007, 009), seja breve no
parecer e cite "deferido a Antigravity" para os pontos conceituais.

## Marcadores HBN obrigatorios

Inicio: ✅ HBN ACTIVE — Codex CLI auditor cross-IA do useHBN.
Fim: 🔵 HBN HANDOFF READY — 9 pareceres + sintese gravados em
.hbn/results/; aguardando consolidacao com pareceres Antigravity.

==================== FIM PROMPT CROSS-IA CODEX (USEHBN) ====================
```

## Notas operacionais para o operador

1. Abrir Codex CLI em terminal NOVO. CWD = `~/Projetos/usehbn/`.
2. Confirmar que esta sessão NÃO é a mesma do rollback MICRO49.
3. Colar o bloco acima.
4. Estimativa de duração: 2-4h (leitura + 9 pareceres).
5. Quando 🔵 HBN HANDOFF READY aparecer, recolher os JSONs em
   `.hbn/results/` e encaminhar via copy-paste ou referência ao Opus
   chat-arquiteto.

## Versão

- v1.0 — 2026-05-09 — Opus 4.7 chat-arquiteto — depósito inicial.
