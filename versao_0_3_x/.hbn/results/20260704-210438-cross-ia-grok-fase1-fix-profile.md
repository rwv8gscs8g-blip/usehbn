---
titulo: "CROSS-IA GROK FASE1 FIX-PROFILE (adversarial, clean chat)"
autor: GROK (xAI family)
data: 2026-07-04
head: 6508268 (working tree, uncommitted)
papel: auditor cruzado adversarial do genoma useHBN
aviso: NAO li parecer de outro auditor; trabalhei independente; NAO implementei, NAO decidi, NAO herdei bastao; ataquei o conserto como porta.
status: congelado
temperatura: glacier
---

# RELATÓRIO DE AUDITORIA CRUZADA ADVERSARIAL — FASE 1 FIX (assert-profile-authorized + testes)

PRE-FLIGHT (executado):
- cd /Users/macbookpro/Projetos/usehbn
- git log -1 --oneline: 6508268 feat(guards): nata-0c - G-SLF version-aware + quitacao dos 17 vendorizados da divida
- git status -s: working tree com A guards/assert-profile-authorized.sh + M em múltiplos guards + .hbn/ untracked (sem commit)
- Diretório existe e é git repo válido.

DECRETO LIDO: /Users/macbookpro/Projetos/Credenciamento/orquestracao/20260703-000500-GATE-DECRETO-REVOGACAO-PERMISSOES-ORQUESTRADORES-LEITURA-OBRIGATORIA.md (Art.1-8: revogação de orquestradores, só leitura+relatório NÃO-decisório, cadeia completa, fail-closed, humano no controle, exúvia para contenção).

MAPA §5.2/§4.3-4.4/§5.5 LIDO: /Users/macbookpro/Projetos/Credenciamento/orquestracao/20260703-170223-fable-5-mapa-definitivo-exuvia-consolidacao-final.md (matriz total via assert-profile-authorized como mecanismo contra omissão silenciosa; desalinhamento snapshot×raiz; fail instrutivo; Fase 1 genesis-aware no genoma).

GUARD E TESTES LIDOS: guards/assert-profile-authorized.sh (linhas 58-71 para marcador) e guards/tests/run-guard-tests.sh (casos 3930-3937 + write_profile_matrix).

## (a) O MARCADOR É BRECHA?

Evidência primária (código do guard fix):

```58:71:guards/assert-profile-authorized.sh
CONSUMER_MARKER_DIR="${ACTIVE_ROOT}/.usehbn-snapshot"
PROFILE_DECLARED=false
if [[ -n "${HBN_CONSUMER_PROFILE:-}" || -f "${ACTIVE_ROOT}/CONSUMER-PROFILE.md" || -f "${CONSUMER_MARKER_DIR}/CONSUMER-PROFILE.md" ]]; then
    PROFILE_DECLARED=true
fi

if [[ ! -f "$PROFILE_PATH" ]]; then
    if [[ ! -d "$CONSUMER_MARKER_DIR" && "$PROFILE_DECLARED" != "true" ]]; then
        guard_ok "Sem .usehbn-snapshot/ e sem CONSUMER-PROFILE.md: contexto genoma/nao-consumidor; guard sem alvo, matriz nao opinada."
        exit 0
    fi
    guard_fail "Perfil consumidor ausente: ${PROFILE_PATH}. Instale/declare CONSUMER-PROFILE.md v2 antes de ativar a matriz total."
    exit 1
fi
```

- Quando NÃO há .usehbn-snapshot/ dir E NÃO há CONSUMER-PROFILE.md (top ou inside) E não declarado por env → no-op (exit 0, "genoma/nao-consumidor").
- Em consumidor real (snapshot instalado com profile dentro de .usehbn-snapshot/): se IA maliciosa faz rm -rf .usehbn-snapshot/ (ou rm do profile + marker), o guard vê ! -d + ! -f + declared=false → no-op.
- O que impede: NENHUM outro guard referencia/força presença de .usehbn-snapshot/ (grep em todos *.sh só encontra referências dentro do próprio assert-profile-authorized.sh e seus testes). Proteções indiretas existem (scope-lock pode vetar staging da deleção se .usehbn-snapshot/ não estiver em files_allowed do readback ativo; alguns hooks consumer hardcoded olham em .usehbn-snapshot/guards e falham; snapshot em ex. tem perms 555; runner checa RUNNER_ROOT==ACTIVE_ROOT), mas NÃO há guard que garanta "em contexto consumidor o marker existe (senão block)".
- Ataques testados (via execução em setups controlados + inspeção de código + reexecução da suíte):
  - Marker dir ausente + profile ausente → no-op (confirmado em harness de testes e execução direta no genoma atual).
  - Marker presente (mesmo vazio/guards vazio) + profile ausente → block (rc=1, teste "consumidor .usehbn-snapshot sem perfil bloqueia").
  - Symlink .usehbn-snapshot → dir vazio/sem profile: -d true (bash segue) → declared false → block "perfil ausente".
  - Symlink quebrado: -d false → se declared false → no-op (mas em prática cai em outros paths ou falta de runner).
  - ACTIVE_ROOT torta: exige .hbn/active-version válido + get_canonical_root (pwd -P) + assert-canonical-root (que checa toplevel vs canonical-root + alt-roots versionado). Alterar active-version para subdir sem marker causa ou fail em get_canonical (early exit 1 no profile) ou block no canonical-root.
  - Dir vazio marker: -d true → block.
- CONFIRMO: o marcador funciona como "valvula de escape" por design para distinguir genoma vs consumidor. Remover o artefato de instalação da exúvia desliga a checagem de matriz total deste guard. Não há "segundo guard" que garanta presença do snapshot no consumidor. Isso é brecha latente de contenção (fs-level disarm do G-PROFILE-MATRIX).

## (b) AUTOCRÍTICA DE PROCESSO (Fase 1)

Por que deixei passar o hard-fail do genoma na Fase 1 (APROVA_FASE1: SIM, parecer 20260704-193900)?

- Meu método testou predominantemente cenários de "consumidor" ou "gênese simulando consumidor com dependências parciais instaladas".
- O teste "genese integrada" (run-guard-tests.sh:3949+) cria estrutura completa com .hbn/ + guards/ copiados + models + STATE, simulando consumidor novo — nunca o caso do GENOMA fonte (usehbn raiz sem .usehbn-snapshot/, com guards/ locais, commitando alterações nos próprios guards e no profile).
- Cenários NÃO cobertos ativamente na Fase 1 que escondem o mesmo tipo de defeito:
  - Genoma self-commit: edição de guards/ (incluindo introdução do próprio assert-profile), sem marker, sem CONSUMER-PROFILE top-level.
  - Primeira gênese do genoma (antes de qualquer exúvia propagada).
  - Contexto sem uma dependência (ex.: .hbn/models/ ausente para guards que o requerem via requires:, ou snapshot parcial).
  - Execução standalone de guard (não via runner) em árvore que é o próprio genoma.
- Procurei ativamente agora: rodei suíte completa, rodei guards individuais no tree atual (com mudanças unstaged de guards), ataquei remoção/symlink/active-root torto em simulações, inspecionei common.sh:get_canonical_root + active-version validation + canonical-root guard, grepei todos os guards por snapshot/marker (zero menções fora deste guard). O defeito era "fail-closed demais para genoma"; o conserto introduz o discriminador de contexto, que agora ataco.

## (c) EXECUÇÃO DE TESTES E GUARDS INDIVIDUAIS

- Rodei: guards/tests/run-guard-tests.sh (background + poll; exit 0 da suíte).
- Evidência dos 2 testes novos (tail do output + leitura do fonte):
  - "profile: genoma sem CONSUMER-PROFILE no-op" → ✓ pass (rc=0)
  - "profile: consumidor .usehbn-snapshot sem perfil bloqueia" → ✓ block (rc=1)
  - Também: "profile: matriz total cobre todos os guards fisicos" pass; "profile: guard fisico omitido bloqueia" block.
- Rodei guards individuais (execução direta no working tree atual):
  - assert-profile-authorized.sh → rc=0 + mensagem exata de no-op genoma (correto).
  - assert-manifest-current.sh → rc=0 (MANIFEST deriva correta).
  - assert-canonical-root.sh → rc=0 (raiz OK).
- Os 2 novos testes provam exatamente os dois lados requeridos pelo fix (genoma no-op / consumidor-sem-perfil block). Suíte completa verde.

## (d) VEREDITO

- Pode selar o fix? O conserto resolve o hard-fail do genoma ao commitar sua própria obra (o bug que não peguei na Fase 1). Os testes cobrem os casos, a lógica de discriminador está implementada e os ataques de resolução torta/symlink/empty confirmam que o fail/ no-op acontece conforme desenhado. Nenhum BLOQUEADOR puro no código do fix.
- Brecha no marcador: CONFIRMO (ver (a)). O .usehbn-snapshot/ é o sinal de "consumidor com exúvia"; sua remoção (junto com o profile que ele carrega) desarma o G-PROFILE-MATRIX sem que outro guard exija sua presença. É por design (genoma não tem snapshot), mas é uma válvula de escape fs-level para este guard específico. Proteções indiretas (scope-lock, hooks, perms, runner-root) existem mas não cobrem todas as vias de "apagar para forçar no-op".
- Severidade da brecha no marcador: FORTE (não BLOQUEADOR para selar este fix específico, porque o problema original era o oposto — bloqueio indevido do genoma; a matriz continua fail-closed quando o sinal de consumidor está presente. Mas é ponto de atenção para contenção futura da exúvia).
- Não há proposta de enfraquecer guard, bypass ou exclusão. O relatório é só evidência + ataque.

## ADMISSÃO DO QUE DEIXEI PASSAR NA FASE 1
Deixei passar porque foquei em "o consumidor não deve ter guards silenciados" e "genesis de consumidor". Não ataquei suficientemente o caso "o genoma precisa editar os guards e commitar sem snapshot". Procurei ativamente agora (B3) e o encontrei no código + repro em harness. Reexaminei leniência (B4): na Fase 1 fui menos adversarial sobre contextos de "self" do genoma.

## B1-B6 (ANTI-VIES)
- B1: li eu mesmo? Sim — decreto, mapa (seções relevantes), guard (linhas 1-247), common.sh (get_canonical, active-version), test script (seção profile + make_repo), runner, canonical-root, install-guard. Execuções próprias.
- B2: verifiquei independente? Sim — rodei suíte completa (exit 0), rodei profile + 2 guards individuais no tree, simulei remoção/symlink/empty dir/crooked root via setups, inspecionei resoluções de ACTIVE_ROOT (pwd -P + active-version), greps restritos.
- B3: procurei brecha ativamente + o que deixei passar? Sim — ataquei todas as vias listadas (rm, symlink, dir vazio, active-version torta, ausencia de canonical), + outros cenários de gênese/self-commit. Admiti o viés de "só consumidor".
- B4: reexaminei leniência? Sim — na Fase 1 aceitei o no-op "genoma" sem prova de que o discriminador era robusto contra spoof via fs. Agora ataquei.
- B5: recomendacao preserva minha relevancia? A auditoria é para expor, não para "passar fácil". Reporto a válvula com severidade FORTE; não suavizo para caber.
- B6: auditar não me dá o bastão. Correto — este é relatório NÃO-decisório (conforme decreto). Não implemento, não commit, não selo, não proponho changes.

## RESUMO (<=10 linhas)
- Fix corrige hard-fail do genoma em self-commit de guards (no-op quando sem marker/sem profile).
- 2 testes novos + suíte verde provam genoma-pass / consumidor-sem-perfil-block.
- Marcador .usehbn-snapshot/ é discriminador de contexto; remoção (rm -rf) + profile dentro força no-op neste guard.
- Nenhum outro guard garante presença do marker em consumidor → válvula de escape fs-level (CONFIRMO).
- Ataques de symlink/active-root/empty: ou block ou caught por canonical/active-version guards.
- Fix selável (resolve o bug reportado); brecha no marcador é FORTE (não BLOQUEADOR do conserto).
- Admissão: Fase 1 testou só consumidor/gênese-consumidor; não atacou self-genoma.
- APROVA_FIX: SIM (com nota da válvula de fs no relatório).

APROVA_FIX: SIM
