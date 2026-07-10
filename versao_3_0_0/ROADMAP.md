---
titulo: ROADMAP v3.0.0 — retomada pós-selagem (Ondas 0-8 até o corte de leitura)
tipo: spec
status: ativo
temperatura: quente
path: ROADMAP.md
created_at: "2026-07-10T04:05:14-03:00"
autor: claude-opus-4-8
familia: Anthropic
natureza: nativo
alvo: "\"Próximo orquestrador (contido, Decreto 20260703-000500) — relator não-decisório; todo ato depende de dispatch-artefato + auditoria cruzada ≥2 famílias + hearback humano. Quem implementa é o implementador designado; quem sela/commita é o gate.\""
---
# ROADMAP v3.0.0 — retomada pós-selagem

> **Estado real (disco):** a terceira exúvia está **SELADA** em `3df71e8`
> (tag `v3.0.0`), contida em `main@fcd149d` com árvore idêntica
> (`git diff --exit-code 3df71e8 fcd149d` = vazio). A Fase 1 (ativação +
> selagem) do roadmap anterior está **CONCLUÍDA**. Este roadmap substitui o
> plano de ativação pelo roteiro de **fechamento do release** em ondas
> (síntese 20260710-022436 + relatório de resolução integral), até o corte de
> leitura (glacier → só v3), que é **NO-GO agora**.

## Verdade de contagem (anti-overclaim)

- Guards: **47 scripts** `guards/*.sh`; **44 entradas** no `guards/MANIFEST.yaml`;
  união dos modos do runner (pre-commit/CI/commit-msg) = **40 gates**; 4 fora do
  runner (`assert-manifest-current`, `assert-profile-authorized`,
  `assert-start-cast`, `freeze-gate`). A frase antiga "36 guards" está
  **aposentada** (era do plano de propagação da membrana).
- Suíte: `guards/tests/run-guard-tests.sh` = **389 checks** (resumo verde
  quando executada de dentro da versão). Bateria adversarial:
  `guards/tests/adversarial-battery.sh`.
- Integridade da exúvia: **PARCIAL** — íntegra como muda de governança (Git
  atômico, tag, glacier preservado, guards preservados); **não** integral como
  versão de produto (runtime, CLI, site, examples, testes, packaging ficaram no
  glacier). Fonte: síntese §3.

## Onda 0 — Verdade pós-release (EM RITO nesta janela)

Reconciliar o livro-razão quente com a selagem. Itens: STATE reescrito para
selado; 3 readbacks completados aos campos `required` do schema (3/3 OK);
`read-list-canonica.txt` rehashada (PENDENTE_REHASH eliminado); provas/Decreto
externos internalizados em `.hbn/knowledge/0035`; refs de TRANSICAO/BOOT
rebaixadas a histórico; triagem da working tree suja; commit único de rito pelo
operador. **Gate:** checkout coerente, ledger sem narrativa pré-selagem,
runner verde. Corte de leitura e exúvia v4 permanecem NO-GO.

## Onda 1 — Fechar contenção ANTES de reintroduzir escrita (pré-requisito da jaula)

CI (3ª barreira): os 3 fixes de camada (roteamento, onboarding de shims em
checkout virgem, cwd-bug do `guard_hook_path`) já aplicados nesta sessão
(`guards/ci-entry.sh`, `guards/lib/common.sh` — endurecimento, sem enfraquecer
guard). O defeito (d) — falsos positivos de semântica de diff-range — é
**mudança de TCB**: onda sob rito com auditoria cruzada, nunca fix unilateral.
Endurecimentos: TCB verificável por baseline imutável; chave do operador ativa
(hearback assinado); G-ACTOR-WRITE-MATRIX fail-closed; eliminar bypass genérico
(33 guards) para guard estrutural; BOOT-LOCK universal (shell/Codex/Jules).
**Gate:** orquestrador adversarial não altera código/TCB/readback sem chave
humana — bloqueado local e no CI.

## Onda 2 — Contratos e CLI read-only (cut-list itens 1, 5, 7, 9)

Package skeleton (`pyproject.toml` moderno único, fonte única de versão), CLI
mínima read-only (`version`, `inspect`, `doctor`), reconciliar
`readback.schema.json` com os 3 artefatos + validar todos os schemas com engine
Draft 2020-12, build wheel/sdist + smoke de instalação, remover promessas
quentes de comandos inexistentes. **Gate:** instalação limpa em venv
descartável; CLI não escreve fora de tmpdir; pytest verde dentro da versão.

## Onda 3 — Runtime mutante fail-closed (itens 2-6, 25) — SÓ APÓS a jaula construída

Runtime/protocol/execution/state/trigger/translation rebaseados para
BOOT/STATE/membrana v3, sob G-RUNTIME-LOCK (item (e) da spec da jaula): toda
mutação resolve canonical-root/active-version, exige readback + hearback
assinado + actor-matrix + files_allowed. Vetos herdados do glacier não
renascem (auto-hearback, confirmação textual, prefix collision, path escape,
escrita em glacier). **Gate:** o runtime não cria autoridade; só consome
autoridade humana verificável e deixa evidência em disco.

## Onda 4 — Packaging, examples, docs, comunidade (itens 8, 15, 19-23, 26)

`get-hbn` v3 (ou substituto honesto), examples executáveis, matriz de
maturidade anti-overclaim, CHANGELOG com lacunas explícitas,
GOVERNANCE/CONTRIBUTING/CODE_OF_CONDUCT/SECURITY/SUPPORT/MAINTAINERS reescritos,
ledger de ADRs (16 IDs citados hoje sem alvo). **Gate:** checkout limpo → build
→ install → version/doctor/inspect → exemplos → testes → links, reproduzível.

## Onda 5 — Membrana transacional e consumidor

Unificar/deprecar `install-snapshot`/`hbn-upgrade-snapshot`; implementar o
`--install` prometido; snapshot+guard extraídos do MESMO commit; rollback
integral; ensaio em consumidor descartável antes do Credenciamento. **Gate:**
`MEMBRANE_MANIFEST.json` no consumidor pinado ao commit, rollback provado.

## Onda 6 — Site e exposição pública honesta (itens 16-18)

Site v3 reescrito (nunca republicar v0.3 como v3), workflow Pages na raiz
roteado pela versão ativa, CNAME/DNS conferidos pelo gate. Só anuncia o que as
Ondas 4-5 provaram. **Gate:** deploy reproduzível; claims rastreáveis a testes.

## Onda 7 — Itens B (connectors, bridge, adapters, skill, docs técnicos)

Após contrato do núcleo estável. Autoevolve executor v0 permanece C
(aposentado): autoaprovação e unlock local nunca renascem.

## Onda 8 — Corte do fio

Manifesto de corte com os 44 itens (decisão A/B/C, origem, hash, sucessor,
teste); A concluídos, B agendados com dono, C aposentados conscientemente; só
então instruir IAs a ler exclusivamente a versão quente. **Gate final:** uma IA
nova instala, opera, audita e entende o estado público lendo só a v3, sem abrir
glacier ou `~/Projetos/Credenciamento`.

---

## Frente paralela do gate (GitHub / server-side) — não bloqueia as ondas locais

Branch protection em `main` (required check **hbn-shield**, include
administrators, sem force-push/delete), CODEOWNERS do TCB, pauta de PRs de
validação do Jules. Detalhe operacional no dispatch de instruções GitHub desta
janela e no §7 do relatório de resolução.

## Invariantes permanentes (valem em toda onda)

- UMA onda por vez; o STATE aponta UMA `proxima_acao` (R3).
- Nenhuma IA commita/sela/tagueia; nenhum bypass; exceção só via G-EXC com
  hearback humano.
- Escrita SÓ sob `versao_3_0_0/` (G-HOT-WRITE bloqueia o resto).
- Corte de leitura e exúvia v4 são NO-GO até Ondas 0-1 + jaula construída.
- Exúvia futura SÓ pelo rito atômico (`scripts/hbn-exuvia-atomic.sh`), com
  dry-run verde na máquina do operador e commit do operador.
- Toda mensagem de IA abre com o cabeçalho BOOT-LOCK (`BOOT.md` §0).
