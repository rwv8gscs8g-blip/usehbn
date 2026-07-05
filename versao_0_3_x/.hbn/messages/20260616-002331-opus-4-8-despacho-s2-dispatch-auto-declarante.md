---
titulo: "Despacho de abertura — S2 (despacho auto-declarante)"
tipo: despacho
status: congelado
temperatura: glacier
path: .hbn/messages/20260616-002331-opus-4-8-despacho-s2-dispatch-auto-declarante.md
id-global: 20260616-002331-opus-4-8-despacho-s2-dispatch-auto-declarante
autor: claude-opus-4-8 (orquestrador/arquiteto)
implementador_designado: codex
auditores_designados: [gemini-3-5, cursor]
created_at: "2026-06-16T00:23:31-03:00"
---

RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-16T00:23:31-03:00
STATE: ultima_atualizacao=2026-06-16T00:43:42-03:00 · bastão → claude-opus-4-8 · contexto S2 implementada
SINAIS: despacho de abertura S2; cross-audit ainda seria etapa posterior no STATE vigente
FEITO: depositar instrucoes de S2 para implementador codex
PENDENTE: cross-audit Gemini+Cursor e selagem propria se aprovado
PONTEIROS: .hbn/readbacks/0025-s2-dispatch-auto-declarante.json; .hbn/relay/STATE.md
PRÓXIMA AÇÃO: Submeter S2 (dispatch auto-declarante) ao cross-audit Gemini+Cursor antes de qualquer selagem.
PARA O HUMANO: main intocada; despacho historico selado sem alterar logica de guard

## Decisões informais (cápsula)

Nenhuma alem das decisoes humanas explicitadas no proprio despacho.

# Despacho S2 — despacho auto-declarante

Artefato do orquestrador, depositado **untracked**. Selagem em micro-onda
própria após cross-audit. Este arquivo NÃO está no escopo de escrita de S2.

## Contexto verificado no disco (2026-06-16)

- Branch `proposta/reestruturacao-m-a-s0`, HEAD `5d7c72f`, 47 commits sobre `main` (`4db6928`). `main` intocada.
- Tags-âncora: `evidencia/orquestrador-bug-2026-06-14` → `3b03a32` (tree `61fa290`); `evidencia/reestruturacao-m-a-s0-tree-equivalent` → `5a0587d` (tree `61fa290`).
- Suítes: run-guard-tests **145/145**; adversarial **B1–B19 bloqueadas**; `hbn-guards-runner` **rc=0**.
- readback ativo: `0024-selagem-b19-cross-audit`. Classe symlink/meta-path FECHADA (B17+B18+B19).
- G-TOK FP ativo: `34a7f2f9`.

## Decisões humanas que travaram o desenho (Maurício, 2026-06-16)

1. Despacho = **arquivo próprio rastreado** em `.hbn/dispatch/NNNN-*.md`.
2. Guards **bloqueantes já nesta onda** (rc≠0), como B17/B18/B19.
3. **Abrir S2 agora** (D-ORQ-WRITE fica para enforcement em S4; F-01 segue PROPOSED_UNTIL_CROSS_AUDIT sem bloquear).

## Desenho de S2 (resumo do mecanismo)

O despacho passa a ser um artefato versionado **auto-declarante**: declara qual
`readback_id` serve, qual `token_fp` o autoriza e qual `human_authorization` o
legitima. Dois guards novos fecham a malha:

- **validate-dispatch (G-DSP-FMT)** — valida a forma: front-matter projetado
  sobre `schemas/dispatch.schema.json` (campos obrigatórios, tipos, arrays de
  escopo não-vazios), `token_fp` no formato de 8 hex e **ausência de linhas
  iniciadas por '#'** no corpo colável (invariante zsh-safe assada no guard).
  Falha fechado se o schema sumir ou um campo for inválido.
- **assert-dispatch-integrity (G-DSP-INT)** — valida a coerência: o
  `readback_id` declarado existe e é o readback ativo do STATE; o `token_fp`
  declarado é igual ao prefixo de 8 de `bastao_token_sha256` no STATE;
  `human_authorization` não-vazio. Bloqueia se o despacho declarar readback que
  não é o ativo ou token_fp divergente do STATE.

Dogfood: o próprio despacho que abre S2 vira o **primeiro** artefato
`.hbn/dispatch/0025-*.md` validado pelos guards recém-criados (commit C5, depois
que os guards existem e ficam verdes).

---

INÍCIO DO BLOCO COLÁVEL (copie tudo entre as linhas de '=' para o Codex; sem linhas iniciadas por '#', zsh-safe)

================================================================================

PARA: codex (implementador)
DE: claude-opus-4-8 (orquestrador/arquiteto)
PAPEL DESTA ONDA: implementador. Auditores cruzados (família distinta): gemini-3-5 + cursor.
READBACK ATIVO APÓS C1: 0025-s2-dispatch-auto-declarante
ONDA: S2 — despacho auto-declarante (dispatch schema + validate-dispatch + assert-dispatch-integrity)

SEÇÃO 0 — INVARIANTES (lei desta onda)
- NÃO tocar main; NÃO fazer merge; NÃO usar --no-verify.
- NÃO habilitar D-ORQ-WRITE operacional nem G-ACTOR-WRITE-MATRIX (fica para S4).
- NÃO usar "git add ."; adicionar somente os paths exatos listados em ESCOPO.
- NÃO tocar nos seis untracked antigos: handoffs fable5 (20260612, 20260613) e results exúvia/onda-0011 (4 arquivos 20260614).
- Antes de CADA commit: bash guards/hbn-guards-runner.sh VERDE com o índice exato do commit.
- Enforcement BLOQUEANTE já nesta onda (rc≠0). Sem rampa.
- Trailers obrigatórios em TODO commit (exatamente estes três):
  HBN-Readback: 0025
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
- Cerimônia zsh-safe: paths explícitos; nada de globs perigosos; despacho sem linhas iniciadas por '#'.

SEÇÃO 1 — ESCOPO (files_allowed; qualquer outro path = fora de escopo)
- .hbn/readbacks/0025-s2-dispatch-auto-declarante.json
- schemas/dispatch.schema.json
- core/dispatch-spec.md
- guards/validate-dispatch.sh
- guards/assert-dispatch-integrity.sh
- guards/hbn-guards-runner.sh
- guards/README.md
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/dispatch/0025-s2-dispatch-auto-declarante.md
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/messages/20260616-HHMMSS-codex-handoff-s2.md

SEÇÃO 2 — FORA DE ESCOPO (files_forbidden)
- main; src/**; site/**; examples/**; inbox/**; .hbn/models/**; .hbn/hearbacks/**
- os seis untracked antigos (handoffs fable5 + results exúvia/onda-0011)
- habilitar escrita operacional do orquestrador (D-ORQ-WRITE) ou ratificar F-01
- iniciar S3 antes do cross-audit de S2

SEÇÃO 3 — PLANO DE AÇÃO (commits SEPARADOS; readback, depois impl, depois testes, depois STATE+handoff)
C1: criar .hbn/readbacks/0025-s2-dispatch-auto-declarante.json (conteúdo verbatim na SEÇÃO 6) e registrar a linha de nascimento no REGISTRY.md. Commit: "onda-s2: abre readback 0025".
C2: criar schemas/dispatch.schema.json (JSON Schema 2020-12) e core/dispatch-spec.md (spec normativa do artefato de despacho: campos, semântica auto-declarante, invariante zsh-safe). Commit: "onda-s2: schema e spec do despacho auto-declarante".
C3: criar guards/validate-dispatch.sh (G-DSP-FMT) e guards/assert-dispatch-integrity.sh (G-DSP-INT); inseri-los no array GUARDS de guards/hbn-guards-runner.sh logo APÓS "assert-scope-lock.sh"; documentar G-DSP-FMT e G-DSP-INT em guards/README.md. Comportamento detalhado na SEÇÃO 4. Commit: "onda-s2: guards validate-dispatch e assert-dispatch-integrity (bloqueantes)".
C4: acrescentar casos em guards/tests/run-guard-tests.sh (positivos: despacho bem-formado e coerente passa; negativos: campo obrigatório ausente, '#' no corpo colável, token_fp mal-formado, readback inexistente, token_fp ≠ STATE) e em guards/tests/adversarial-battery.sh as burlas B20, B21, B22 (SEÇÃO 5). Suíte deve fechar VERDE. Commit: "onda-s2: cobre despacho auto-declarante (B20-B22)".
C5: depositar .hbn/dispatch/0025-s2-dispatch-auto-declarante.md — o primeiro despacho auto-declarante real, dogfood; precisa passar validate-dispatch + assert-dispatch-integrity com o índice do commit. Commit: "onda-s2: deposita primeiro despacho auto-declarante (dogfood)".
C6: atualizar .hbn/relay/STATE.md (onda_atual, proxima_acao, sinais, readback_ativo segue 0025 até a selagem; nota S2), criar handoff fresco .hbn/messages/20260616-HHMMSS-codex-handoff-s2.md e registrar linhas finais no REGISTRY.md. Commit: "onda-s2: atualiza state e handoff".
Depois de C6: bastão volta ao orquestrador; cross-audit Gemini+Cursor (família ≠ implementador) antes de qualquer selagem. Selagem é micro-onda própria (readback 0026), não entra aqui.

SEÇÃO 4 — CONTRATO DOS GUARDS
validate-dispatch.sh (G-DSP-FMT): para cada entrada staged sob .hbn/dispatch/** com modo git 100644 e extensão .md: validar que o front-matter YAML projeta sobre schemas/dispatch.schema.json com os campos obrigatórios (dispatch_id, readback_id, token_fp, human_authorization, scope.files_allowed[], scope.files_forbidden[], action_plan[]); token_fp casa /^[0-9a-f]{8}$/; e o corpo colável NÃO contém nenhuma linha iniciada por '#'. Falha fechado se o schema estiver ausente, ilegível, ou qualquer campo inválido. Mensagem clara por violação.
assert-dispatch-integrity.sh (G-DSP-INT): para cada despacho staged sob .hbn/dispatch/**: o readback_id declarado deve existir como arquivo .hbn/readbacks/<readback_id>.json E ser o readback ativo declarado no STATE (readback_ativo); o token_fp declarado deve ser igual ao prefixo de 8 hex de bastao_token_sha256 no STATE; human_authorization não-vazio. Bloqueia se o despacho declarar readback que não é o ativo, token_fp divergente do STATE, ou autorização ausente. Reusar lib/common.sh; mesmo estilo fail-closed dos demais asserts.

SEÇÃO 5 — BURLAS ADVERSARIAIS A ADICIONAR
B20 despacho com token_fp != prefixo do STATE  | G-DSP-INT | deve BLOQUEAR
B21 despacho declarando readback inexistente/não-ativo | G-DSP-INT | deve BLOQUEAR
B22 despacho com linha iniciada por '#' no corpo colável (quebra zsh) ou campo obrigatório ausente | G-DSP-FMT | deve BLOQUEAR

SEÇÃO 6 — CONTEÚDO VERBATIM DO READBACK 0025 (criar em C1)
{
  "readback_id": "0025-s2-dispatch-auto-declarante",
  "execution_id": "s2-dispatch-auto-declarante-2026-06-16",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "in_progress",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0025-s2-dispatch-auto-declarante.json",
  "understanding": "Implementar S2: formalizar o despacho como artefato versionado auto-declarante em .hbn/dispatch/NNNN-*.md, validado por schemas/dispatch.schema.json. Criar dois guards bloqueantes: validate-dispatch (G-DSP-FMT, forma + invariante zsh-safe sem linhas '#' no corpo colavel) e assert-dispatch-integrity (G-DSP-INT, coerencia readback_id+token_fp+human_authorization com o readback ativo e o STATE). Dogfood: o despacho 0025 vira o primeiro artefato validado. Enforcement bloqueante ja nesta onda.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Mauricio autorizou em 2026-06-16: abrir S2 agora; despacho como arquivo proprio rastreado em .hbn/dispatch/; guards bloqueantes ja na onda (sem rampa).",
    "created_at": "2026-06-16T00:23:31-03:00",
    "note": "Autorizacao humana para safe_track de implementacao S2. Nao autoriza tocar main, merge, --no-verify, git add ., habilitar D-ORQ-WRITE operacional, ratificar F-01 ou tocar nos seis untracked antigos."
  },
  "scope": {
    "files_allowed": [
      ".hbn/readbacks/0025-s2-dispatch-auto-declarante.json",
      "schemas/dispatch.schema.json",
      "core/dispatch-spec.md",
      "guards/validate-dispatch.sh",
      "guards/assert-dispatch-integrity.sh",
      "guards/hbn-guards-runner.sh",
      "guards/README.md",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/dispatch/0025-s2-dispatch-auto-declarante.md",
      ".hbn/relay/STATE.md",
      "REGISTRY.md"
    ],
    "files_forbidden": [
      "main",
      "src/**",
      "site/**",
      "examples/**",
      "inbox/**",
      ".hbn/models/**",
      ".hbn/hearbacks/**",
      ".hbn/messages/20260612-122102-fable5-handoff-orquestracao-pos-onda-0006.md",
      ".hbn/messages/20260613-112502-fable5-handoff-orquestracao-pos-adocao-onda-0006.md",
      ".hbn/results/20260614-032800-gemini-3-5-cross-ia-onda-0011-plano-v2.md",
      ".hbn/results/20260614-043647-antigravity-cross-ia-exuvia-impl.md",
      ".hbn/results/20260614-043826-codex-cross-ia-exuvia-impl.md",
      ".hbn/results/20260614-044555-opus-4-8-consolidacao-cross-audit-exuvia-impl.md"
    ]
  },
  "action_plan": [
    "C1: abrir readback 0025 e registrar nascimento no REGISTRY.",
    "C2: criar schemas/dispatch.schema.json e core/dispatch-spec.md.",
    "C3: criar guards validate-dispatch.sh e assert-dispatch-integrity.sh, inserir no runner apos assert-scope-lock e documentar em guards/README.md.",
    "C4: cobrir positivos/negativos em run-guard-tests e burlas B20-B22 em adversarial-battery; suite verde.",
    "C5: depositar .hbn/dispatch/0025-*.md como primeiro despacho auto-declarante (dogfood), verde nos guards.",
    "C6: atualizar STATE, criar handoff fresco e registrar linhas finais no REGISTRY."
  ],
  "invariants_to_preserve": [
    "Nao tocar main, nao fazer merge e nao usar --no-verify.",
    "Nao habilitar D-ORQ-WRITE operacional nem G-ACTOR-WRITE-MATRIX.",
    "Nao usar git add .; adicionar somente paths exatos.",
    "Nao tocar nos seis untracked antigos.",
    "Antes de cada commit: bash guards/hbn-guards-runner.sh verde com o indice do commit.",
    "Enforcement bloqueante ja nesta onda (rc != 0).",
    "Trailers obrigatorios: HBN-Readback: 0025, HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin), HBN-Token-FP: 34a7f2f9."
  ],
  "out_of_scope": [
    "Habilitar escrita operacional do orquestrador (D-ORQ-WRITE).",
    "Ratificar F-01.",
    "Iniciar S3 antes do cross-audit de S2.",
    "Tocar nos seis untracked antigos."
  ],
  "read_evidence": [
    "schemas/handoff.schema.json (modelo de schema analogo)",
    "guards/assert-scope-lock.sh (estilo fail-closed e leitura de indice/HEAD)",
    "guards/hbn-guards-runner.sh:50-63 (array GUARDS, ponto de insercao apos assert-scope-lock.sh)",
    ".hbn/relay/STATE.md (bastao_token_sha256 e readback_ativo)"
  ],
  "mechanical_evidence": [
    "pwd -> /Users/macbookpro/Projetos/usehbn",
    "git rev-parse HEAD -> 5d7c72f1930f4ce36a7a65963f207e430648be5e",
    "git rev-parse main -> 4db692876381a0d7909985c8500d999f2e677b04",
    "run-guard-tests -> 145/145; adversarial -> B1-B19 bloqueadas; runner rc=0"
  ],
  "created_at": "2026-06-16T00:23:31-03:00",
  "protocol_version": "0.3.0"
}

SEÇÃO 7 — DEFINIÇÃO DE PRONTO (antes de devolver o bastão)
- run-guard-tests VERDE com os novos casos; adversarial-battery bloqueia B1–B22.
- hbn-guards-runner rc=0 com o índice de cada commit.
- .hbn/dispatch/0025-*.md passa validate-dispatch + assert-dispatch-integrity (dogfood).
- Seis commits separados, cada um com os três trailers; nenhum "git add .".
- main intocada; nenhum arquivo fora do ESCOPO; seis untracked antigos não tocados.
- Handoff fresco + STATE coerente; bastão devolvido ao orquestrador para cross-audit.

================================================================================

FIM DO BLOCO COLÁVEL
