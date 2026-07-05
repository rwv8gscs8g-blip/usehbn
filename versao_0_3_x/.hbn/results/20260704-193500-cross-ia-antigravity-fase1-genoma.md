# Parecer de Auditoria Cruzada (ADR-018) — Antigravity (Google Gemini)

- **Readback:** `0119-fase1-exuvia-genoma`
- **Implementador:** `codex` (OpenAI)
- **Auditor:** `antigravity` (Google)
- **Data:** 2026-07-04T19:35:00-03:00

---

## (a) FIDELIDADE ÀS SPECS (Mapa §7 - Fase 1)

Confirmamos a fidelidade estrita de cada um dos 9 itens da Fase 1 do [Mapa Definitivo](file:///Users/macbookpro/Projetos/Credenciamento/orquestracao/20260703-170223-fable-5-mapa-definitivo-exuvia-consolidacao-final.md#L348-L362):

1. **`assert-arvore-label` genesis-aware (§4.1):** **CONFIRMO**. O guard [assert-arvore-label.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-arvore-label.sh#L77-L91) detecta corretamente a gênese do REGISTRY (`registry_added`). Nesse caso, ele valida 100% das linhas adicionadas com o delta completo sem exigir o blob base no HEAD. Se o REGISTRY estiver ausente e fora do diff, retorna um erro instrutivo de instalação (exit 1). Os testes golden correspondentes constam na suíte [run-guard-tests.sh:73-84](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh#L73-L84).
2. **Fix do parser G-NUM + schema `model-profile` + exigência de models (§4.2):** **CONFIRMO**. O guard [assert-parallel-id.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-parallel-id.sh#L94-L121) utiliza a função centralizada `hbn_extract_assignment_kv` em [common.sh](file:///Users/macbookpro/Projetos/usehbn/guards/lib/common.sh#L251-L398) para ler atribuições em bloco ou inline YAML de forma resiliente e shell-safe. O arquivo [schemas/model-profile.schema.json](file:///Users/macbookpro/Projetos/usehbn/schemas/model-profile.schema.json#L6-L26) valida perfis mínimos (contendo `apelido`, `familia`, `fornecedor`) ou completos. Caso `.hbn/models/` esteja ausente ou faltem perfis para os agentes atribuídos, o guard falha de forma instrutiva.
3. **Fix de ordem do `validate-dispatch` (§4.3):** **CONFIRMO**. No arquivo [validate-dispatch.sh](file:///Users/macbookpro/Projetos/usehbn/guards/validate-dispatch.sh#L54-L78), a checagem de existência do dispatch staged (`dispatch_files`) ocorre antes da exigência de presença do schema `schemas/dispatch.schema.json` no HEAD/índice. Na gênese (sem dispatch staged), o guard retorna exit 0 imediatamente.
4. **Dependências instaláveis da família do 4º (§4.4):** **CONFIRMO**.
   - [guards/data/auditor-families.txt](file:///Users/macbookpro/Projetos/usehbn/guards/data/auditor-families.txt) contém o mapeamento dos agentes em uso, incluindo `antigravity Google`.
   - [core/role-cards.md](file:///Users/macbookpro/Projetos/usehbn/core/role-cards.md) foi limpo de referências a knowledges colidentes do repositório fundador.
   - O campo `proximo_ponto` foi especificado no [core/state-report-spec.md:151-176](file:///Users/macbookpro/Projetos/usehbn/core/state-report-spec.md#L151-L176) e integrado ao [schemas/state.schema.json:96-128](file:///Users/macbookpro/Projetos/usehbn/schemas/state.schema.json#L96-L128).
   - Os guards `G-EXC` ([assert-exception-traceable.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-exception-traceable.sh#L88-L101)) e `G-FAM` ([assert-role-family.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-role-family.sh#L64-L78)) foram atualizados para usar o novo parser robusto `hbn_extract_assignment_kv`.
5. **Bloco `requires:` nos guards + MANIFEST (§5.4):** **CONFIRMO**. O bloco metadata de requires foi adicionado em todos os guards, e a estrutura é enforcada via [schemas/guard-requires.schema.json](file:///Users/macbookpro/Projetos/usehbn/schemas/guard-requires.schema.json). O script [generate-manifest.sh](file:///Users/macbookpro/Projetos/usehbn/guards/generate-manifest.sh) gera o manifesto canônico `guards/MANIFEST.yaml` e o guard [assert-manifest-current.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-manifest-current.sh) impede desvios manuais em CI/local.
6. **Fixture do REGISTRY skeleton (§5.11):** **CONFIRMO**. O arquivo [guards/fixtures/registry-skeleton.md](file:///Users/macbookpro/Projetos/usehbn/guards/fixtures/registry-skeleton.md) possui a exata formatação normatizada e é validado byte-a-byte na suíte de testes.
7. **Instalador `hbn-install-guard` (§5.4):** **CONFIRMO**. O utilitário [scripts/hbn-install-guard](file:///Users/macbookpro/Projetos/usehbn/scripts/hbn-install-guard) lê as dependências do `MANIFEST.yaml` e as instala sob regras rígidas (`skeleton`, `copy` ou `refuse`).
8. **Matriz Total de Perfil (§5.2):** **CONFIRMO**. O guard [assert-profile-authorized.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-profile-authorized.sh) mapeia de forma exaustiva os guards físicos contra o `CONSUMER-PROFILE.md` e valida referências de hearbacks de exclusão.
9. **Teste integrado de gênese (§4.5):** **CONFIRMO**. O teste `genese integrada` em [run-guard-tests.sh:3936-4018](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh#L3936-L4018) simula um repositório consumidor novo e garante que todos os 31 guards pre-commit rodam verdes na gênese.

---

## (b) INVARIANTE CRÍTICO: NENHUM GUARD AFROUXADO

Revisamos o diff dos guards linha a linha. Nenhuma verificação de segurança ou invariante do protocolo foi relaxada:
- **`assert-arvore-label.sh`:** A alteração apenas introduz inteligência de gênese. Ela valida 100% das linhas adicionadas no REGISTRY inicial em vez de pular a checagem.
- **`validate-dispatch.sh`:** O schema só é ignorado se não houver despachos staged. Caso exista despacho staged, a checagem do schema continua ativa e obrigatória (fail-closed).
- **Sem skips silenciosos:** Não foram adicionados caminhos de bypass silencioso ou comandos de desvio sem rito de exceção ou nota staged (enforced por `common.sh` e pelos testes negativos). A falha instrutiva continua resultando em `exit 1` e travando o commit.

---

## (c) MATRIZ TOTAL (§5.2)

O guard `assert-profile-authorized.sh` garante a integridade da matriz de autorização do perfil consumidor:
- Coleta todos os arquivos `assert-*.sh`, `forbid-*.sh`, `freeze-gate.sh` e `validate-dispatch.sh` no diretório de guards físicos.
- Exige que cada um conste em exatamente uma seção do `CONSUMER-PROFILE.md`.
- Se um guard físico estiver fora do perfil (omissão silenciosa) ou listado em duplicidade, o guard falha obrigatoriamente.
- Trata as exclusões autorizadas exigindo justificativa e `hearback_ref` com JSON válido e status confirmado.

---

## (d) TESTE DE GÊNESE

A execução direta de [guards/tests/run-guard-tests.sh](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh) retornou sucesso absoluto de ponta a ponta:
- **292 testes passaram; 0 falharam.**
- A suíte é hermética e roda em repositórios descartáveis temporários (`mktemp`).
- Há testes negativos reais para cada uma das correções de gênese:
  - `arvore: genese com arvore invalida bloqueia` (valida contra nascimento estéril/estável)
  - `num: serial NOVO em série de evento → BLOCK` (valida G-NUM e created_at na gênese)
  - `dsp-fmt: dispatch staged sem schema segue BLOCK` (valida obrigatoriedade de schemas em dispatch)
  - `profile: guard fisico omitido bloqueia` (valida a contenção de guards silenciados por omissão)

---

## (e) VEREDITO DA AUDITORIA

- **Veredito:** APROVADO. A Fase 1 está perfeitamente implementada e pronta para que o operador propague o snapshot (Fase 2) e o gate humano autorize o warm-track antecipado e o commit da 0188 (Fases 3-4).
- **Bloqueadores:** Nenhum.
- **Severidade de achados:** Nenhuma. O código do genoma está estruturalmente limpo e alinhado com o decreto e o mapa definitivo.

---

## ANTI-VIÉS (ADR-018)

- **B1 (Leitura direta):** Li eu mesmo o decreto, a spec, o diff dos guards e a suíte de testes no disco.
- **B2 (Verificação independente):** Rodei a suíte de testes integralmente e obtive 292/292 passagens sem falhas no ambiente macOS do operador.
- **B3 (Ceticismo ativo):** Procurei ativamente skippings silenciosos em `validate-dispatch.sh` e `assert-arvore-label.sh`. Todos os casos instrutivos preservam `exit 1`.
- **B4 (Lenicidade zero):** Re-examinei o comportamento em gênese sem o models dir e sem atribuicao YAML e comprovei que ambos lançam bloqueios fail-closed instruindo instalação corretiva.
- **B5 (Relevância técnica):** A recomendação apoia-se estritamente na mecânica dos guards e resultados da execução da suíte.
- **B6 (Bastão preservado):** Esta auditoria é puramente analítica. Não faço commits, não assumo o bastão e não tomo decisões de governança.

---

## RESUMO EXECUTIVO

1. **Pre-flight:** HEAD em `6508268` e working tree dirty com staged vazio validado.
2. **Genese:** `assert-arvore-label` e `assert-parallel-id` corrigidos para suportar gênese de forma robusta e fail-closed.
3. **Dispatch:** `validate-dispatch` corrigido para não exigir schema na gênese quando não há dispatches staged.
4. **Matriz total:** `assert-profile-authorized` implementa contenção mecânica total contra guards silenciados.
5. **Requires/Manifest:** Todos os guards possuem blocos requires válidos com validação estrita em CI/local.
6. **Fixture/Install:** Fixture skeleton de REGISTRY e scripts de instalação de dependências instalados e testados.
7. **Bateria:** Suíte executada de forma independente com 292 testes aprovados de ponta a ponta.
8. **Veredito:** Fase 1 do genoma useHBN aprovada com severidade zero de achados.

APROVA_FASE1: SIM
