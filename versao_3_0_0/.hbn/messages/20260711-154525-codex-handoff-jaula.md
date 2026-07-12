---
titulo: "Handoff parcial — implementação da jaula do orquestrador"
tipo: handoff
status: em_andamento
temperatura: quente
path: .hbn/messages/20260711-154525-codex-handoff-jaula.md
created_at: "2026-07-11T15:45:25-03:00"
autor: codex
familia: OpenAI
natureza: nativo
---
# Handoff parcial — jaula do orquestrador

HOT_VERSION: versao_3_0_0 | BOOT: versao_3_0_0/BOOT.md | CONFIRMACAO_DISCO: SIM
PAPEL implementador · TOKEN codex · FAMÍLIA OpenAI · CONTEXTO 50% · "retomando do disco"

## Estado verificável

- Baseline confirmada: `git rev-parse --short HEAD` → `51ce570`.
- Hearback conferido e JSON válido:
  `cat versao_3_0_0/.hbn/hearbacks/0004-jaula-orquestrador-hearback.json`
  e `jq empty ...` → exit 0.
- Implementação iniciada somente após esse hearback.
- Escritas mantidas sob `files_allowed`; um `usehbn/__init__.py` criado por
  engano foi removido imediatamente e não está presente.

## Implementado nesta janela

- `scripts/jaula/`: biblioteca canônica, `jaula-sh`, geração de handoff
  atestado, promoção de ledger, spawn em worktree read-only e watchdog.
- `guards/hooks/pre-write-gate.sh`: canonicalização + matriz de ator + ledger.
- `guards/hooks/pre-push`: chama runtime lock, anti-bypass e bateria JT.
- `.claude/settings.json`: PreToolUse de Write/Edit/Bash no gate único.
- `guards/assert-runtime-lock.sh` e `usehbn/_lock.py`.
- `guards/lib/common.sh`: bypass estrutural sempre recusado; bypass documental
  exige nota staged e hearback humano confirmado/assinado.
- `guards/MANIFEST.yaml`: campo `classe` adicionado aos registros existentes e
  registro inicial do runtime lock.

## Evidência executada

`bash -n scripts/jaula/*.sh scripts/jaula/jaula-sh` → exit 0.

`git diff --check -- scripts/jaula` → exit 0.

`bash -n guards/lib/common.sh guards/hooks/pre-write-gate.sh
guards/hooks/pre-push guards/assert-runtime-lock.sh` → exit 0.

## Próxima ação exata

1. Implementar `guards/tests/assert-no-structural-bypass.sh`.
2. Implementar `guards/tests/jaula-adversarial-battery.sh` com JT-01..JT-14 e
   JT-15 documentado.
3. Corrigir detalhes revelados pela bateria; gerar `scripts/jaula/BASELINE.sha256`
   e `guards/hook-shims/HASHES.sha256`.
4. Atualizar readback/REGISTRY/knowledge somente se exigido por artefato
   numerado; executar JT e suíte preexistente.
5. Se tudo verde, staging cirúrgico arquivo a arquivo e parar.

## Bloqueio de escopo já identificado

O requisito §4(c).1 manda `MANIFEST.yaml` ganhar `classe` e o gerador validar
completude. Porém `guards/generate-manifest.sh` e
`guards/assert-manifest-current.sh` não constam de `files_allowed`. O gerador
atual não emite `classe`; portanto `assert-manifest-current.sh` necessariamente
verá drift quando o MANIFEST classificado for staged. Não houve ampliação
unilateral. É necessário novo hearback/readback autorizando ao menos
`guards/generate-manifest.sh` (e, se a validação não couber só nele, o guard
correspondente), ou decisão expressa alterando o critério.

## Declaração

Confiança: média na implementação parcial e alta no diagnóstico do conflito de
escopo. NÃO verificado: JT-01..JT-14, suíte 389/389, spawn completo pós-commit,
hash baselines, staging, auditoria cruzada, Shield server-side, branch
protection/CODEOWNERS. Nenhum arquivo foi staged; nenhum commit, tag ou push foi
feito.

RELATO DE ESTADO — codex · implementador · 2026-07-11T15:45:25-03:00
STATE ultima_atualizacao=2026-07-10T04:05:14-03:00
PRÓXIMA AÇÃO: Operador humano executa o commit unico de rito da Onda 0 (runner verde), reconciliando o ledger com a selagem 3df71e8/v3.0.0; depois o Codex constroi a jaula antes da Onda 1 (corte e exuvia v4 seguem NO-GO).
