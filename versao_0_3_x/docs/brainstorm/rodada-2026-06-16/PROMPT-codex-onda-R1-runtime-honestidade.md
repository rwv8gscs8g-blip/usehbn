# Prompt único para o Codex — Onda R1: correção de runtime + honestidade

> COMO USAR (humano): este é o despacho da onda R1, validado por cross-audit
> (Cursor/Gemini-Antigravity/Codex em 2026-06-16). Cole no Codex implementador.
> O orquestrador preenche `readback_id` e `token_fp` reais e roda o rito formal
> (readback → gates intra-onda → suíte + bateria adversarial → cross-audit ≠-família
> → hearback do Maurício → selagem). NÃO é para promover Fronteira nem mudar a
> constituição — é correção de runtime do incumbente, pré-freeze e pré-Ponte.

=== INÍCIO ===

PAPEL: você é o implementador (Codex) da Onda R1 do useHBN. Janela limpa: leia o
disco. Truth Barrier: toda mudança citável por arquivo:linha + teste. Não confie em
memória. Repo: ~/Projetos/usehbn/.

OBJETIVO DA ONDA: tornar o runtime Python honesto e correto ANTES do freeze/Ponte —
sem mudar o contrato externo do CLI, sem tocar a constituição (P1–P13) e sem
promover nada de Fronteira. Base validada pela consolidação em
docs/brainstorm/rodada-2026-06-16/CONSOLIDACAO-batch1-cross-audit.md e nos pareceres
em .hbn/results/ (cursor-composer e gpt-5).

ESCOPO PERMITIDO (scope.files_allowed — o orquestrador confirma): src/usehbn/cli.py,
src/usehbn/utils/config.py, src/usehbn/runtime.py, src/usehbn/state/store.py,
src/usehbn/protocol/result.py, tests/ (novos golden tests), methodology/MATURITY-MATRIX.md,
AGENTS.md, README.md. PROIBIDO: core/, guards/, .hbn/ (salvo depósitos do rito),
schemas/, e qualquer arquivo de docs/brainstorm/.

LEIA ANTES: docs/brainstorm/rodada-2026-06-16/B1-code-review-cli-runtime.md,
B2-honestidade-maturity-matrix.md, C3-escopo-primeira-exuvia.md, e a CONSOLIDACAO.

PLANO DE AÇÃO (4 sub-fases, cada uma com commit local e gate auditável):

R1.1 — Golden tests primeiro (rede de segurança, antes de qualquer mudança).
  Crie tests que capturam a saída atual dos 17 subcomandos do CLI (run, translate,
  connector inspect/ensure, init, version, inspect, doctor, quickstart, install,
  attention, notify, readback, hearback, result, refresh, relay status, handoff,
  autoevolve). Objetivo: provar que R1.2–R1.4 não mudam o contrato externo.

R1.2 — Exit codes honestos.
  Hoje main() retorna 0 mesmo em erro/violação (cli.py:1772; ramos de erro em
  cli.py:1732, 1759; run_handoff cli.py:1607, 1613-1618). Introduza uma hierarquia
  de exceção (ex.: HbnProtocolViolation, HbnCliError) e reescreva main() para sair
  com código ≠0: 2 para erro de CLI/subcomando desconhecido, 3 para violação de
  protocolo (ex.: hearback não confirmado, result.py:54-56). Qualquer payload com
  chave "error" deve resultar em exit ≠0. Atualize os golden tests para asserir os
  novos códigos.

R1.3 — Unificar diretório de estado.
  Três convenções coexistem: .hbn/ (cli.py:752-753), .usehbn/ (utils/config.py:12),
  state/ (runtime.py:377-379), com remendo em cli.py:1564-1595. Consolide numa única
  base canônica (.hbn/ para governança + subdir de estado explícito), com migração
  tolerante (ler legado, escrever no canônico, dedup por traceability.execution_id) e
  caminho de leitura legado só-leitura. Remova a duplicação na origem, não no consumidor.

R1.4 — Honestidade (fechar teatro e alinhar docs).
  a) Rode a suíte (pytest) e REGISTRE a contagem real (a coleta indica ~181 funções
     test_, não 93 nem 114). Alinhe o número idêntico em AGENTS.md:57, README.md e
     methodology/MATURITY-MATRIX.md.
  b) Registre autoevolve na MATURITY-MATRIX: audit=Parcial, orchestrator/worker/queue/
     approval=Scaffold, cli=Parcial (evidência: worker.py:4-6 no-op; contract.py:49-50
     diff sempre 0; approval.py:27 gate sempre passa). Ajuste o texto do CLI/help para
     declarar que autoevolve NÃO faz evolução autônoma em v0.3.0.
  c) Corrija o ponteiro de fonte: AGENTS.md:17 deve apontar para
     methodology/MATURITY-MATRIX.md (não docs/MATURITY-MATRIX.md SUPERSEDED).
  d) Remova/defina o nível "L4" em README.md:559 (use os 5 estados oficiais da matriz).

GATES DA ONDA: suíte verde (com a contagem real); golden tests dos 17 subcomandos
verdes; bateria adversarial (guards/tests/adversarial-battery.sh) sem regressão; nenhum
guard alterado; main não tocada além do escopo. Saída de cada sub-fase auditável.

FORA DESTA ONDA (não implemente aqui; ficam para R2/R3 e decisão humana):
  - G-REG estender para diff-filter M + guard anti-mislabel de arvore: (Onda R2).
  - Etiquetagem arvore: registry-centric (Onda R2).
  - Trailer HBN-Spec-Source / G-PROV e G-FDACK com HBN-Token-FP (Onda R3).
  - Assinatura criptográfica (G-HRB, perfis de modelo) — exige Maurício gerar chaves.
  - Emenda P13, regra CRISPR, escopo da exúvia, esteiras/chapéu — via ADR/onda própria.

ENCERRAMENTO: produza o handoff com o placar de evidências (arquivo:linha + saída de
teste) e atualize o STATE no mesmo commit, conforme o rito. Cross-audit ≠-OpenAI
(Gemini + Cursor) antes da selagem; hearback do Maurício no gate.

=== FIM ===
