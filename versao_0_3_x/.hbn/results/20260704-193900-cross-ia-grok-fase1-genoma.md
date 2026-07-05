---
titulo: "Cross-Audit Fase 1 Exúvia Genoma — GROK (xAI family, independente, chat limpo)"
autor: "GROK (família xAI) — auditor cruzado"
data: 2026-07-04
head: "6508268 (pre-flight confirmado)"
spec_referenciada: "20260703-170223-fable-5-mapa-definitivo-exuvia-consolidacao-final.md (Fase 1)"
decreto: "20260703-000500-GATE-DECRETO-REVOGACAO-PERMISSOES-ORQUESTRADORES-LEITURA-OBRIGATORIA.md"
nao_leu: "nenhum outro cross-ia result ou parecer antes deste"
status: congelado
temperatura: glacier
---

# AUDITORIA CRUZADA FASE 1 — INSTALADOR "religar=instalar" e PONTO DE CAPTURA (mandato do mapa §7)

Trabalho INDEPENDENTE. Não herdei bastão. Não li parecer de outro auditor. Não implementei, não editei, não commitei, não rodei hooks. Foco: atacar o instalador e o ponto de captura.

PRE-FLIGHT: cd /Users/macbookpro/Projetos/usehbn; git log -1 --oneline = 6508268; git status -s = dirty (M + ??), staged vazio. OK.

## (a) INSTALADOR: hbn-install-guard

- Faz SOMENTE skeleton / copy / refuse (scripts/hbn-install-guard:138-163).
- Determinístico: mesmo input → mesmos bytes para registry (cp exato da fixture); para models deriva de STATE + families map de forma reprodutível (linhas 119-133).
- Modo refuse: emite instrução e sai 1, NADA instala (155-158: "REFUSE: $path requer acao humana/consumidor; nada foi instalado automaticamente").
- Não pode ser induzido a conteúdo semântico: skeleton_registry = copy da fixture (65-67); skeleton_models = JSON mínimo 3 campos {"apelido","familia","fornecedor"} só de parse de STATE (129-132); desconhecido ou sem source → refuse (150-153).
- Caminho de "materializar estrutura tratada como já resolvida/autoridade"? Não encontrado. O skeleton REGISTRY é template (header + seção Legado vazia); linhas de autoridade de gênese são append pelo implementador e validadas por assert-registry-line + genesis-aware em arvore-label. Models placeholders são validados por conteúdo no G-NUM (perfil deve declarar apelido+fornecedor/familia; vazio falha — ver diff assert-parallel-id). Instalador não anexa linhas, não declara autoridade, não bypassa outros guards.
- CONFIRMO (com ressalva de que é o ponto de captura por design — foi auditado adversariamente conforme mandato grok no mapa).

Evidência:
- scripts/hbn-install-guard:20-24 (doc "nunca inventa"), 53-63 (copy), 65-68 (registry), 112-134 (models), 155-158 (refuse), 166-170 (path mode), 247-250 (driver MANIFEST).
- guards/assert-arvore-label.sh:88-90 (mensagem instrutiva aponta instalador).
- Testes: guards/tests/run-guard-tests.sh:3902-3909 (byte cmp + refuse block + models criados).

## (b) FIXTURE byte-a-byte

- guards/fixtures/registry-skeleton.md é exato: 10 linhas, termina com \n, sem trailing spaces, sem conteúdo semântico (só header 7-col + "## Legado (mapeamento, sem rename)").
- Golden test: sha256 exato "8a40bf06701b5d5ce0f45e0456b8b18d7008fdfd74e6421d7f0b4fdca538ede9" (guards/tests/run-guard-tests.sh:951-952); cmp -s após install (3903-3904).
- 1 byte de diferença → falha no teste (cmp e sha).
- CONFIRMO.

Evidência:
- guards/fixtures/registry-skeleton.md:1-10.
- run-guard-tests.sh:951-952 (sha), 3903-3904 (cmp), 968 (cp no harness de gênese).
- spec §5.11:305-321 (exigência byte-a-byte + golden).

## (c) MANIFEST

- generate-manifest.sh: determinístico (guards ordenados, 143; parse estrito de sentinelas exatas, 27-33; emissão canônica).
- assert-manifest-current.sh: gera, cmp -s contra blob, divergência → guard_fail + instrução para regenerar (52-62).
- Guard ativo sem requires parseável → FALHA: extract_block exige exatamente 1 BEGIN + 1 END (31-32); parse exige "requires:" (47-48). Confirmado por simulação em /tmp (sem editar repo): bloco ausente → falha esperada.
- CONFIRMO.

Evidência:
- guards/generate-manifest.sh:13-15 (sentinelas), 27-33 (extract), 46-134 (parse rigoroso, install enum, source exigido para skeleton/copy), 143 (sorted).
- guards/assert-manifest-current.sh:6-16 (seu próprio requires), 52-62 (cmp + fail).
- schemas/guard-requires.schema.json:5-110 (strict, enum, conditionals).
- MANIFEST.yaml atual bate com generate (verificado em shell).
- Teste: run-guard-tests.sh: "manifest: gerado bate com blocos requires (pass)" + "drift manual bloqueia (block)".

## (d) ONDE A CORREÇÃO PODE VIRAR PORTA — procura ativa + testes

- Rodei: guards/tests/run-guard-tests.sh → 292 passaram, 0 falharam (inclui suíte "fase 1 exuvia: manifest/install/profile/genese" + genese integrada 31 guards verdes + install tests + manifest drift).
- Diffs de gênese (git diff HEAD -- guards/assert-arvore-label.sh, validate-dispatch.sh, assert-parallel-id.sh): 
  - arvore-label: modo gênese (added REGISTRY → valida 100% linhas, previous vazio); ausência não-gênese → falha instrutiva apontando instalador. Nenhuma cobertura perdida.
  - parallel-id (G-NUM): parser robusto YAML aninhado (falha instrutiva se ruim); models agora validados (apelido + fornecedor/familia; vazio falha); antes aceitava dir vazio ou json vazio. Endurecimento.
  - validate-dispatch: early-exit ANTES do schema check (só exige quando há dispatch). Fail-closed mantido para o caso que importa.
- Bypass: continua exigindo env + nota .hbn/bypasses/ no MESMO diff (common.sh:215-238, F-10 hardening pré-existente, não afrouxado).
- Nenhuma "instrução" virando skip; nenhum novo default permissivo; nenhum || true que silencia violação em guards de produção (só em cleanup de testes).
- Nenhuma correção virou porta. Instalador atacado diretamente (codex readback + spec chamam "ponto de captura" para grok) — sem brecha de smuggling de autoridade ou conteúdo semântico.
- CONFIRMO: bateria verde, zero afrouxamento disfarçado.

Evidência:
- run-guard-tests.sh (output completo): "== resumo: 292 passaram, 0 falharam ==" "SUÍTE VERDE".
- git diff guards/ (40 arquivos, +973/-69; adições são requires + hardening + parser + genesis logic).
- common.sh:215-238 (bypass ignora sem nota).
- spec §4.1-4.5, §5.4, §5.11, §7 Fase 1.

## (e) VEREDITO

O gate pode selar a Fase 1? **SIM**.

BLOQUEADOR? **NENHUM**.

Severidade: **MARGINAL** (o instalador é ponto de captura por design e foi atacado; cobertura e determinismo confirmados; recomenda-se apenas que Fase 3 documente o fluxo exato de "install → stage linhas genesis → commit" com hearback, mas nada bloqueia o selamento da onda do genoma).

Nenhum guard foi afrouxado. Todos os 4+ bloqueadores de gênese endereçados no genoma. Fixture, manifest, requires, instalador cumprem a spec linha a linha. Testes independentes verdes. Cadeia de artefatos preservada.

## B1-B6 (anti-bias auto-auditoria)

B1: Li eu mesmo? SIM — decreto (linhas 1-51), mapa §3.2/4/5.2/5.4/5.11/7 (linhas 132-155,185-230,238-240,246-271,305-321,348-361), readback 0119-fase1-exuvia-genoma.json (1-98), erp codex 20260704-161118 (1-54), código fonte completo dos 5 artefatos + blocos requires + diffs + common.sh + testes.

B2: Verifiquei independente (rodei testes)? SIM — pre-flight, git status/log, sha fixture, generate cmp IDENTICAL, simulação de parse sem bloco, run-guard-tests.sh completo (292/0, via shell background + await), instalação via harness nos testes (byte cmp + refuse + models), diffs manuais dos 3 guards de gênese.

B3: Procurei razões p/ REPROVAR? SIM — foquei no instalador como superfície de ataque (religar=instalar, materializar authority, semantic content, overwrite de skeleton, bypass via skeleton models, genesis sem linhas). Revisei todos os paths de skeleton_models, copy sem source, refuse, registry_added. Nenhum encontrado. Examinei se genesis mode enfraquece (não: 100% cobertura + fail instrutivo).

B4: Zero contradição → reexaminei leniência? SIM — re-li o installer 2x, common bypass, diffs linha a linha, testes de recusa. Conclusão manteve-se: sem brecha. Se houvesse 1 byte drift ou skip silencioso, teria reprovado.

B5: Recomendação preserva minha relevância? A recomendação é técnica e restrita (APROVA com MARGINAL por ser o ponto de captura). Não infla, não enfraquece guarda. Auditoria cruzada de família diferente cumpre ADR-018.

B6: Auditar não me dá o bastão. SIM — este output é só relatório NÃO-DECISÓRIO. Selagem exige hearback humano + cadeia completa (decreto Art. 3). Não herdei, não executo, não autorizo commit.

## RESUMO (≤10 linhas)

- Pre-flight OK (6508268, dirty, staged vazio).
- Instalador: só skeleton/copy/refuse; determinístico; refuse instrutivo; zero conteúdo semântico inventado; não materializa autoridade (CONFIRMO).
- Fixture: byte-exato, sha golden, 1 byte falha (CONFIRMO).
- Manifest: generate det., assert recusa drift, guard sem requires → FALHA parse (CONFIRMO).
- Rodei testes: 292/0 verde; bateria fase1 + genese integrada OK. Diffs genesis = endurecimento (parser, validação models, ordem schema).
- Zero afrouxamento disfarçado, skip novo ou default de brecha.
- Veredito: sem bloqueador. Gate PODE selar Fase 1. Severidade MARGINAL.
- APROVA_FASE1: SIM

APROVA_FASE1: SIM
