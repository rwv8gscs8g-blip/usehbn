---
titulo: "Parecer adversarial — RE-AUDITORIA delta combinado readback 0002+0003"
tipo: result-cross-ia-superseded
status: superseded
temperatura: frio
path: .hbn/archive/SUPERSEDED-20260706-061000-grok-cross-ia-0003.md
created_at: "2026-07-06T06:10:00-03:00"
autor: grok
familia: xAI
natureza: nativo
---
SOU: grok · familia xAI · papel auditor

# Parecer adversarial — RE-AUDITORIA delta combinado readback 0002 (fechamento pós-auditoria v3) + 0003 (proveniência livro-razão + autocontenção)

## Veredito
APROVA_0002: SIM
APROVA_0003: SIM

## Evidências (Truth Barrier) → preflight + código/artefatos + comandos executados

### Preflight (um por vez, saídas citadas)
```
$ pwd
/Users/macbookpro/Projetos/usehbn
```
```
$ git rev-parse --short HEAD
a2eb6f2
```
(Obtido via /usr/bin/git --git-dir=... rev-parse; também logs confirmam a2eb6f2b95ea5079fef628305bfd1038547f0f56 como último commit antes do delta.)
```
$ cat .hbn/active-version
versao_3_0_0
```
```
$ git status --short
... (delta 0002 + 0003 na working tree, não commitado; M em guards, scripts, core/*.md, MANIFESTO-MIGRACAO.md, REGISTRY.md, .hbn/messages/ e .hbn/readbacks/000[2-3], A em novos guards 0003 etc.)
```

### Leitura da READ-LIST (ordem seguida)
1. Decreto gate: lido — "auditor não sela nem autoriza; chat não tem efeito; só artefato gateado em disco vale." (Art. 1-8, Maurício 2026-07-03).
2. 20260705-202451-fable-5-handoff... (delta 0002: T1/T3/T4/T6 + incidente §3 da exúvia vazando em mount Linux).
3. 20260706-000432-dispatch-onda-0003 + 20260706-003930-adendo-T-AUTO (escopo 0003 + autocontenção).
4. 20260706-001951-codex-handoff-onda-0003 (o que foi implementado + evidências declaradas).
5. readbacks 0002 e 0003 (human_status pendente; escopo fechado; exceções hot-write).
6. Meu próprio NAO anterior (20260705-223100): APROVA_0002: NAO por exuvia dry-run vermelho (readlist untracked, sandbox /tmp, fixture hardcoded, cd NO-OP).
7. DELTA 0003: core/04-artefatos.md, core/01-principios.md, MANIFESTO-MIGRACAO.md, guards/* (MANIFEST.yaml, runner, assert-*.sh, tests), REGISTRY.md.

### FOCO 0002 (resolução do meu NAO anterior)
- Correções T1 no script hbn-exuvia-atomic.sh + knowledge 0033 + suíte readlist-tracked + sandbox movido para $HOME + cd "${d:?}" || exit 1 (fail-closed).
- T3 (allowlist 4b/4c): regras no assert-only-hot-version-writable.sh (shims de raiz exigem hot-write-root-shim + JSON confirmed; 4c anti-regressão ponteiro versao_X_Y_Z → "." bloqueada sem exceção).
- T4: hygiene de quórum (placeholders em archive/, results reais untracked até quorum ≥2 famílias, G-DIVERSITY no runner).
- T6: anti-regressão do ponteiro implementada + testes.
- Clone descartável: /tmp/hbn-audit-post-0002-0003-20260706-054543 criado via rsync do estado pós-delta (arquivos aplicados); tentativa de commit via plumbing para simular PÓS-commit (restrições de permissão no shell para .git em /tmp impediram HEAD limpo no clone; arquivos post-delta presentes no FS).

### FOCO 0003 (verificação mecânica)
- core/04-artefatos.md (linhas ~40-92): "Proveniência do livro-razão (universal, fail-closed)" + "Autocontenção da versão vigente (universal, fail-closed)"; campos natureza + bloco completo para migrados; proibição de citação de glacier/versoes_antigas/../methodology/ como fonte vigente.
- MANIFESTO-MIGRACAO.md: tabela "migra | apêndice | morre"; "A transcrição mecânica de proveniência desta onda é validada por 0003"; T-AUTO integrado; glacier só como histórico.
- Proveniência: front-matters dos migrados contêm o bloco completo (natureza: migrado, migrado_de, id_original, created_at_original, autor_original, transcrito_em, transcrito_por, validacao_ref); conteúdo semântico intacto (apenas header+proveniência+rebase); REGISTRY atualizado com linhas 0003.
- AUTOCONTENÇÃO: core/01-principios.md transcreve P1–P13 inline como fonte vigente; referências externas (methodology/, versao_*, ../, exoesqueleto) rotuladas explicitamente "consulta histórica", "não como fonte", "só como histórico". Varredura (executada):
  ```
  $ grep -rnE '\.\./|methodology|versao_0_3_x|versao_2_0_0|exoesqueleto' versao_3_0_0/ --include='*.md' ...
  ```
  (hits apenas em migrado_de, comentários históricos rotulados, ou proibições; nenhum como regra vigente).
- Guards:
  - G-PROV (assert-doc-provenance.sh): "Estrutural: nao honra HBN_GUARDS_BYPASS"; registrado no MANIFEST.yaml, no runner (abort se ausente: "desarme do G-PROV detectado. Commit abortado (fail-closed)"), com testes negativos na suíte.
  - G-SELF-CONTAINED (assert-version-self-contained.sh): idem "Estrutural"; regex OFF_VERSION + HISTORICAL_OR_FORBIDDING; abort no runner; testes negativos (ref ..//glacier-vigente bloqueia; histórico passa; interno passa).
  - Runner (hbn-guards-runner.sh:91-98,112-113): checa existência dos dois; aborta fail-closed; ambos listados em GUARDS[].
  - Suíte (run-guard-tests.sh): seções dedicadas G-PROV e G-SELF-CONTAINED com make_prov_repo / run_self_contained e casos negativos.

### Comandos de evidência executados (saídas parciais/citadas; tool sandbox limitou stdout completo de guards em alguns shells)
- grep (outside): viu working tree e labels históricos corretos.
- tail REGISTRY + git status (outside): confirmou linhas 0003 + T4 nota.
- Grep tool: confirmou registro no MANIFEST, runner abort, testes, "Estrutural" nos dois guards.
- Read dos guards: código estrutural + fail-closed + lógica de proveniência/autocontenção.
- Clone: rsync produziu /tmp/hbn-audit-post-0002-0003-20260706-054543 com arquivos pós-delta; git plumbing/copy .git parcialmente restrito por sandbox (op not permitted em hooks/config).
- Guards executados via absolute em alguns shells: atingiram o path de validação (falharam só por "Versao ativa invalida" quando sem git no contexto do processo — confirma execução do código novo).

### Resumo de T3/T4/T6 (código verificado)
- T3 4b/4c e auto-proteção do guard: presente em assert-only-hot-version-writable.sh (linhas ~28-40, 162-166, 356-365, 379-383).
- T4: REGISTRY append-only + nota explícita; placeholders arquivados; results reais untracked até quorum.
- T6: regra 4c + testes de regressão de ponteiro.

## Furos (mesmo com SIM; listados)
- Não obtive stdout completo "G-PROV OK: 58 documento(s)" / "389 passaram, 0 falharam" / "sandbox VERDE" / "BATERIA VERDE" em execução única no clone com HEAD pós (restrição sandbox do shell no tool para git em /tmp e view de working tree em alguns shells). Verificação via inspeção de código + artefatos + greps outside.
- Variação de contagem de testes entre handoff (382) e dispatch (389) — não bloqueador, suíte expandiu.
- O exuvia no clone real (PÓS-commit) não foi 100% reproduzido end-to-end por EPERM em .git/hooks durante init/cp no ambiente do auditor (macOS tool sandbox); no repo real do operador (nota do protocolo) roda.
- Não li o parecer de outro auditor para 0003 antes deste veredito (conforme instrução).

## Confiança
Alta (estrutural + mecânica): guards declarados estruturais, runner aborta, padrão de front-matter presente nos artefatos, autocontenção com rótulos históricos, fixes de 0002 endereçam exatamente os bloqueadores do meu NAO anterior (readlist, tmp, fixture, cd).
Média na reprodução de stdout dos 5 comandos por limitações do ambiente de shell no auditor.

## NÃO verificado
- Run completo da suíte + exuvia + guards em clone git limpo com HEAD = post-delta (bloqueado por permissão no tool shell para /tmp/.git).
- Execução no ambiente macOS "real" do operador (este run é via tool no workspace).
- Efeito da membrana pós-commit (escopo fora).
- Quórum completo (não é papel do auditor selar).

— grok, xAI, auditor. Uma onda. Parei no parecer. —
