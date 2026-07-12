---
titulo: "Handoff parcial 2 — jaula verde, pendente spawn e staging"
tipo: handoff
status: em_andamento
temperatura: quente
path: .hbn/messages/20260711-160117-codex-handoff-jaula.md
created_at: "2026-07-11T16:01:17-03:00"
autor: codex
familia: OpenAI
natureza: nativo
---
# Handoff parcial 2 — jaula do orquestrador

HOT_VERSION: versao_3_0_0 | BOOT: versao_3_0_0/BOOT.md | CONFIRMACAO_DISCO: SIM
PAPEL implementador · TOKEN codex · FAMÍLIA OpenAI · CONTEXTO 52% · "retomando do disco"

## Preflight e autorização

- `.hbn/active-version` → `versao_3_0_0`.
- `git rev-parse --short HEAD` → `51ce570`.
- Ambos os hearbacks 0004 passaram em `jq empty`.
- A ampliação do aditivo 1 foi registrada no readback 0004; somente
  `guards/generate-manifest.sh` foi acrescentado. `assert-manifest-current.sh`
  não precisou ser alterado.

## Implementado nesta retomada

- `guards/tests/assert-no-structural-bypass.sh`.
- `guards/tests/jaula-adversarial-battery.sh`, JT-01..JT-14 automatizados e
  JT-15 documentado como limite residual.
- `guards/generate-manifest.sh` agora emite `classe` para todo guard e falha
  se a classificação calculada não for `estrutural|documental`.
- `guards/lib/common.sh` mantém bypass estrutural sempre fechado, exige
  nota+hearback no MANIFEST classificado e conserva compatibilidade somente
  para consumidor legado sem MANIFEST próprio.
- Verificação canônica de atestação foi centralizada em `jaula-lib.sh` e usada
  por `spawn-orchestrator.sh`; JT-12 exercita a mesma função.
- `scripts/jaula/BASELINE.sha256` e `guards/hook-shims/HASHES.sha256` gerados.

## Evidências verdes

- `bash guards/tests/assert-no-structural-bypass.sh` → exit 0.
- `bash guards/tests/jaula-adversarial-battery.sh` →
  `BATERIA JT VERDE: JT-01..JT-14 bloqueados; JT-15 documentado.`
- `bash guards/assert-runtime-lock.sh` → exit 0, runtime preso à versão quente.
- `bash guards/tests/run-guard-tests.sh` →
  `resumo: 389 passaram, 0 falharam` e exit 0.
- `shasum -a 256 -c scripts/jaula/BASELINE.sha256` → todos `OK`.
- `shasum -a 256 -c guards/hook-shims/HASHES.sha256` → todos `OK`.
- `git diff --check -- <escopo da jaula>` → exit 0.
- `git diff --cached --name-only` → vazio: nada staged.

## Próxima ação exata em janela limpa

1. Revalidar BOOT/preflight e este handoff; não reler o despacho inteiro.
2. Executar `spawn-orchestrator.sh` em repositório descartável que contenha o
   patch commitado localmente, medir `<60s` e medir o handoff `<5%` de contexto.
3. Confirmar se `_lock.py` deve chamar `assert_runtime_locked()` no import;
   hoje o guard valida o módulo, mas a função não é executada automaticamente.
   Se corrigir, rehash de `usehbn/_lock.py` em `BASELINE.sha256` e repetir JT,
   runtime lock e 389/389.
4. Revisar `git diff` apenas dos paths autorizados e conferir que
   `guards/ci-entry.sh`, STATE, glacier e esteira R3 permanecem intocados.
5. Atualizar REGISTRY/knowledge somente se houver artefato numerado novo que
   realmente exija linha; nenhum foi criado nesta retomada além da atualização
   do readback 0004 já existente.
6. Com tudo verde, staging cirúrgico arquivo a arquivo, nunca `-A/-u/--all`,
   e PARAR. Entregar comando exato de commit com os três trailers do readback.

## Declaração

Confiança alta nas provas JT, anti-bypass, runtime lock, hashes e regressão
389/389. NÃO verificado: spawn completo pós-patch em menos de 60s, orçamento
de contexto do handoff automático, import automático do runtime lock,
auditoria cruzada, Shield server-side, branch protection/CODEOWNERS. Nenhum
arquivo foi staged; nenhum commit, tag ou push foi feito.

RELATO DE ESTADO — codex · implementador · 2026-07-11T16:01:17-03:00
STATE ultima_atualizacao=2026-07-10T04:05:14-03:00
PRÓXIMA AÇÃO: Operador humano executa o commit unico de rito da Onda 0 (runner verde), reconciliando o ledger com a selagem 3df71e8/v3.0.0; depois o Codex constroi a jaula antes da Onda 1 (corte e exuvia v4 seguem NO-GO).
