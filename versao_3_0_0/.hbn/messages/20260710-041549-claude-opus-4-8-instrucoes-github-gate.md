---
titulo: "Instruções GitHub ao gate — branch protection, CODEOWNERS do TCB, pauta do Jules (texto; nenhuma ação remota)"
tipo: handoff
status: ativo
temperatura: quente
path: .hbn/messages/20260710-041549-claude-opus-4-8-instrucoes-github-gate.md
created_at: "2026-07-10T04:15:49-03:00"
autor: claude-opus-4-8
familia: Anthropic
natureza: nativo
destinatario: gate humano (Maurício)
insumos:
  - .hbn/messages/20260710-022436-fable5-relatorio-resolucao-integral-pre-corte.md
  - .hbn/messages/20260710-022436-fable5-spec-jaula-definitiva-orquestrador.md
---
HOT_VERSION: versao_3_0_0 | BOOT: versao_3_0_0/BOOT.md | CONFIRMACAO_DISCO: SIM

PAPEL orquestrador · TOKEN opus-4-8 · FAMÍLIA Anthropic · CONTEXTO ~46% · "retomando do disco"

SOU: claude-opus-4-8 · família Anthropic · papel orquestrador (contido). Este
artefato é **só texto** — nenhuma ação remota foi executada por mim (não tenho e
não uso credencial de repositório). São passos para o GATE executar no GitHub.

RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-07-10T04:15:49-03:00
STATE ultima_atualizacao=2026-07-10T04:05:14-03:00
PRÓXIMA AÇÃO: Operador humano executa o commit unico de rito da Onda 0 (runner verde), reconciliando o ledger com a selagem 3df71e8/v3.0.0; depois o Codex constroi a jaula antes da Onda 1 (corte e exuvia v4 seguem NO-GO).

## Decisões informais (cápsula)
nenhuma

# Instruções GitHub ao gate (server-side) — §7 do relatório de resolução + spec (b)

Estado remoto (do relatório): `origin = https://github.com/rwv8gscs8g-blip/usehbn.git`;
`main@fcd149d` (árvore idêntica a `3df71e8`, tag `v3.0.0`).

## 0. Pré-condição — sem isto, o Shield fica vermelho

1. Executar o **commit único de rito da Onda 0** (comando entregue no RETURN do
   orquestrador) e `git push` — inclui os 3 fixes de CI desta sessão
   (`guards/ci-entry.sh`, `guards/lib/common.sh`). Antes disso, qualquer PR
   nasce bloqueado porque o check `hbn-shield` ainda falharia.
2. Conferir localmente antes do push: `bash versao_3_0_0/guards/hbn-guards-runner.sh`
   verde e `bash versao_3_0_0/guards/tests/run-guard-tests.sh` = 389 verde.

## 1. Branch protection em `main` (Settings → Branches → Add rule)

- Branch name pattern: `main`.
- ☑ Require a pull request before merging (≥1 approval).
- ☑ Require status checks to pass before merging → **required check: `hbn-shield`**
  (o job do workflow `.github/workflows/hbn-shield.yml`).
- ☑ Require branches to be up to date before merging.
- ☑ Do not allow bypassing the above settings → **Include administrators**.
- ☐ Allow force pushes: **desmarcado** (proibir). ☐ Allow deletions: **desmarcado**.
- Efeito (spec (b)/(a)): `--no-verify` local, apagar `.git/hooks` ou reescrever
  hook local ficam **irrelevantes para o canônico** — o check roda no runner do
  GitHub, fora do alcance do orquestrador.

## 2. CODEOWNERS do TCB (arquivo `.github/CODEOWNERS`, revisão humana obrigatória)

Cobrir o Trusted Computing Base para exigir review do gate em qualquer mudança:

```
# TCB — mudança exige revisão do gate humano
/versao_*/guards/**        @Mauricio
/versao_*/scripts/**       @Mauricio
/.github/**                @Mauricio
/.cursor/**                @Mauricio
/.hbn/active-version       @Mauricio
```

(Substituir `@Mauricio` pelo handle GitHub real do gate. O arquivo CODEOWNERS
entra por onda de implementador sob rito — não pelo orquestrador — mas o
conteúdo acima é a especificação.)

## 3. Defeito (d) — semântica de diff-range (issue rastreada, não fix agora)

Abrir issue: "G-HOT auto-proteção + G-KNOW-INDEX disparam falsos positivos em
ranges que contêm a selagem 3df71e8 ou em range degenerado (base==HEAD)".
É **mudança de TCB** → onda sob rito (Onda 1), com matriz de casos testada
(push main, PR, workflow_dispatch, range com selagem, range vazio). Até lá:
**PRs do Jules devem ter base em `main` e ranges que não contenham a selagem**
(na prática, PRs novos a partir de `fcd149d` passam).

## 4. Pauta inicial de PRs do Jules (VALIDAÇÃO, não construção)

O Jules entra como auditor automático (família Google; perfil em
`.hbn/models/jules.json`; entra no `guards/data/auditor-families.txt` por commit
governado). Foco: propor, nunca aplicar sem gate. Pauta:

1. Reproduzir a suíte (`run-guard-tests.sh`) e a bateria adversarial no CI pelo
   mesmo entrypoint do GitHub (`guards/ci-entry.sh`).
2. Validar os 3 readbacks × `schemas/readback.schema.json` (após a Onda 0) com
   engine Draft 2020-12 real.
3. Verificar links/refs mortos (cut-list item 42: MINIMALISM/SUBSTRATO/
   AI-LANGUAGE/USEHBN-MODULES/THREE-TREES/radar; ADRs citados sem alvo).
4. Lint dos guards (`shellcheck guards/*.sh`).

## Limite honesto

Estes passos dependem de você (dono do repo). O orquestrador não executa e não
prepara execução remota (Decreto Art. 1). Registre no ledger, ao concluir, um
screenshot/nota do branch protection ativo (spec (b)) para trilha de auditoria.
