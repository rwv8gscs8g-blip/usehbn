---
id-global: 20260610-51
titulo: Prompt-pack — auditoria cruzada da evolução C1→D (Codex + Antigravity/Gemini 3.5)
tipo: prompt
status: congelado
temperatura: glacier
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente D — PREPARADOR do pedido, NÃO auditor)
tier: T1 (doc; nenhuma adoção, nenhum move, nenhum guard ativado)
motivo-da-nao-autoauditoria: "ADR-018 (anti-groupthink) + Cadência D: o implementador da corrente D (fable-5, Anthropic) não audita o próprio trabalho; auditores de FAMÍLIAS DIFERENTES (OpenAI, Google)"
relacionado: [handoff 20260610-49, STATE 20260610-50, ADR-016, ADR-017, ADR-018, proposal 20260610-36, nota 20260610-34]
saidas-esperadas:
  - ".hbn/results/0021-cross-ia-codex-corrente-d.json"
  - ".hbn/results/0022-cross-ia-antigravity-corrente-d.md"
nota-numeracao: "ids 51–57 estavam reservados pela proposal 36 (faxina); este depósito e o handoff 52 consomem 51–52 — a faxina renumera na execução, conforme previsto na própria proposal 36."
---

# Prompt-pack — auditoria cruzada da corrente D (C1→D)

Dois prompts de CHAT LIMPO, um por auditor. Maurício cola cada um no
respectivo ambiente. Cada auditor produz UM arquivo em `.hbn/results/`
(convenção cross-ia existente, próximo NNNN livre: 0021/0022) e NADA mais.
Nenhum dos dois implementa, adota, move ou ativa coisa alguma — auditoria é
fast_track de leitura; a decisão é do hearback de Maurício (H1–H6 + veredito
destes pareceres).

---

## PROMPT 1 — AUDITOR 1: Codex (OpenAI)

```text
Você é o CODEX (OpenAI), em CHAT LIMPO, vestindo o chapéu de AUDITOR CRUZADO
do protocolo useHBN. Você é de família DIFERENTE do implementador auditado
(Claude Fable 5, Anthropic) — é exatamente por isso que você foi escolhido
(ADR-018, invariante anti-groupthink). Você NÃO herda o bastão: audita e
entrega o parecer; a próxima ação continua sendo o hearback humano.

RAIZ CANÔNICA: /Users/macbookpro/Projetos/usehbn
Tudo é relativo a essa raiz. Se ela não existir ou não for um repo git, PARE
e reporte — não procure outra pasta.

PRÉ-FLIGHT (obrigatório, antes de qualquer leitura):
1. pwd  → confirme que está em /Users/macbookpro/Projetos/usehbn
2. GIT_OPTIONAL_LOCKS=0 git status --short
   Esperado: a corrente D está UNTRACKED/MODIFIED e NÃO commitada
   (M REGISTRY.md, M core/relay-spec.md, M schemas/state.schema.json,
   ?? guards/assert-registry-line.sh, ?? guards/assert-role-family.sh,
   ?? guards/freeze-gate.sh, ?? core/dual-run-spec.md, ?? core/freeze-gate-spec.md,
   ?? core/roles-assignment-spec.md, ?? methodology/adr/ADR-016..018,
   ?? schemas/dual-run-result.schema.json, ?? schemas/freeze-checklist.schema.json,
   ?? reports/20260610-36-*, ?? inbox/credenciamento/20260610-44-*,
   ?? .hbn/relay/STATE.md, ?? .hbn/messages/). Divergência pequena = registre
   como observação e siga; raiz/repo errados = PARE.

READ-LIST EXATA (leia TUDO, nesta ordem; não confie em resumo de ninguém):
 1. REGISTRY.md — inteiro; foco nas linhas 20260610-35..50, na "Nota corrente D"
    e na nota 20260610-34 (bump adiado).
 2. .hbn/relay/STATE.md
 3. .hbn/messages/20260610-01-handoff-corrente-d-fable5.md
 4. methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md
 5. methodology/adr/ADR-012-naming-versoes-ondas.md
 6. methodology/adr/ADR-013-arquiteto-autonomo-classes-a-b.md
 7. methodology/adr/ADR-014-cerimonia-proporcional-tiers.md
 8. methodology/adr/ADR-015-perfis-de-modelo.md
 9. methodology/adr/ADR-016-dual-run-caracterizacao.md      ← objeto
10. methodology/adr/ADR-017-freeze-gate-executavel.md        ← objeto
11. methodology/adr/ADR-018-papeis-chapeus-anti-groupthink.md ← objeto
12. core/relay-spec.md (v2 — Bastão 2.0; inclui campo `atribuicao` proposed)
13. core/cadence-d.md (severidades, papéis P1/P2/P4, §12)
14. core/dual-run-spec.md                                    ← objeto
15. core/freeze-gate-spec.md                                 ← objeto
16. core/roles-assignment-spec.md                            ← objeto
17. guards/assert-registry-line.sh                           ← objeto
18. guards/assert-role-family.sh                             ← objeto
19. guards/freeze-gate.sh                                    ← objeto
20. guards/assert-scope-lock.sh (precedente C3, para comparar padrão)
21. guards/hbn-guards-runner.sh + guards/lib/common.sh (confirme que NENHUM
    guard novo está no runner — invariante declarado no handoff)
22. schemas/state.schema.json (propriedade `atribuicao`)     ← objeto
23. schemas/dual-run-result.schema.json                      ← objeto
24. schemas/freeze-checklist.schema.json                     ← objeto
25. reports/20260610-36-proposal-faxina-prompts-raiz.md (faxina DRY-RUN)
26. reports/20260610-15-proposal-bump-versao-canonico.md (bump 0.3.1 adiado)
27. inbox/credenciamento/20260610-44-freeze-gate-v206.md
28. .hbn/models/codex.json, fable-5.json, gemini-3-5.json, opus-4-8.json
    (insumo dos guards de família)
29. 20260610-51-prompt-pack-auditoria-cruzada-corrente-d.md (seu mandato)

ESCOPO DA AUDITORIA — responda os 6 pontos, cada um com veredito + evidência:
(1) COERÊNCIA E COMPLETUDE da evolução C1→D: os blocos 0–4 formam um todo
    consistente? Há contradição entre ADRs, specs, schemas e guards? Falta
    peça que o conjunto promete?
(2) LÓGICA DO BASTÃO E DO STATE: a retomada ficou barata, clara e sem perda?
    Leia o STATE como se você fosse a janela que retoma: ele diz a VERDADE
    sobre o repo (confronte cada campo com a realidade observável)? A
    read-list canônica do relay-spec é suficiente e mínima?
(3) ONDE ESCREVE / NUMERAÇÃO AAAAMMDD-NN / TEMPERATURA / REGISTRY: a tabela
    tipo→pasta→numeração→temperatura é aplicada consistentemente nos
    depósitos 35..52? Existe ÓRFÃO novo (artefato sem linha no REGISTRY, ou
    linha sem artefato)? A reserva/renumeração de ids 51–57 da faxina é coerente?
(4) OS GUARDS FAZEM O QUE PROMETEM? Leia o código de assert-registry-line,
    assert-role-family, freeze-gate (e compare com assert-scope-lock como
    precedente). Procure: falso negativo (caso que deveria bloquear e passa),
    falso positivo, injeção via nome de arquivo, parsing frágil do REGISTRY/
    JSON, divergência código×spec×ADR. Você PODE executá-los para verificar —
    mas SOMENTE contra cópia descartável em /tmp, NUNCA mutando o repo canônico.
(5) AS RECOMENDAÇÕES E ADR-016/017/018 SÃO ADEQUADOS? Avalie cada decisão e
    as consequências declaradas. Há BLOQUEADOR ou FORTE contra adoção (H3/H4/H5)?
    A exceção fable×opus registrada no ADR-018 Decisão 3 está bem cercada?
(6) FAXINA DRY-RUN E BUMP ADIADO: foram decisões corretas? O dry-run da
    proposal 36 está completo e seguro para execução (mover, nunca deletar)?
    Adiar o bump 0.3.1 (nota 20260610-34) cria risco de divergência de versão?

SEVERIDADES (cadência D): BLOQUEADOR (impede adoção; veto), FORTE (corrigir
antes ou na adoção), MARGINAL (registrar; não impede). Todo finding cita
artefato + linha/trecho como evidência — afirmação sem evidência não conta.

CHECKLIST ANTI-VIÉS DE BASTÃO (responda explicitamente no parecer):
B1. Li os artefatos eu mesmo, sem confiar no resumo do handoff/STATE?
B2. Verifiquei de forma independente as alegações de teste do implementador
    (handoff §Evidência: 4/4, 4/4, 3/3, 3/3) por leitura do código e/ou
    execução em cópia /tmp?
B3. Procurei ativamente razões para REPROVAR antes de aprovar?
B4. Se encontrei ZERO contradição com o implementador, re-examinei por
    suspeita de leniência?
B5. Alguma das minhas recomendações preserva a MINHA relevância como
    ferramenta (viés observado em 2026-05-27)? Qual?
B6. Confirmo que auditar não me dá o bastão: não propus assumir a próxima ação.

PROIBIDO: implementar, adotar, ativar guard no runner, mover/renomear/deletar
qualquer arquivo, editar STATE/REGISTRY/qualquer artefato do canônico,
commitar, escrever fora do arquivo de saída. ÚNICO write permitido:

SAÍDA: .hbn/results/0021-cross-ia-codex-corrente-d.json
(se 0021 já existir, use o próximo NNNN livre e diga qual usou)
Formato JSON, espelhando a convenção dos resultados 0001–0010:
{
  "schema_version": "1.0",
  "auditor": "codex-cli",
  "session_role": "cross-ia-audit-corrente-d",
  "reviewed_at": "<ISO8601>",
  "preflight": { "pwd_ok": true, "git_status_divergencias": [] },
  "escopo": {
    "1_coerencia_completude":   { "veredito": "...", "comentario": "..." },
    "2_bastao_state":           { "veredito": "...", "comentario": "..." },
    "3_numeracao_registry":     { "veredito": "...", "comentario": "..." },
    "4_guards":                 { "veredito": "...", "comentario": "..." },
    "5_adrs_016_017_018":       { "veredito": "...", "comentario": "..." },
    "6_faxina_e_bump":          { "veredito": "...", "comentario": "..." }
  },
  "findings": [ { "id": "F-01", "severidade": "BLOQUEADOR|FORTE|MARGINAL",
                  "artefato": "<path>", "evidencia": "<linha/trecho>",
                  "descricao": "...", "recomendacao": "..." } ],
  "checklist_anti_vies": { "B1": "...", "B2": "...", "B3": "...",
                           "B4": "...", "B5": "...", "B6": "..." },
  "recomendacao_por_hearback": { "H1": "...", "H2": "...", "H3": "...",
                                 "H4": "...", "H5": "...", "H6": "..." },
  "veto_adocao": "sim|nao",
  "resumo_para_humano": "<=10 linhas"
}
Ao terminar: imprima no chat o caminho do arquivo gravado + veto_adocao +
contagem de findings por severidade. Nada além disso.
```

---

## PROMPT 2 — AUDITOR 2: Antigravity / Gemini 3.5 (Google)

```text
Você é o ANTIGRAVITY rodando GEMINI 3.5 (Google), em CHAT LIMPO, vestindo o
chapéu de AUDITOR CRUZADO do protocolo useHBN. Você é de família DIFERENTE
do implementador auditado (Claude Fable 5, Anthropic) e do outro auditor
(Codex, OpenAI) — três famílias, zero groupthink (ADR-018). Você NÃO herda o
bastão: audita, entrega o parecer, e a próxima ação continua sendo o
hearback humano. Seu parecer é INDEPENDENTE: não leia o parecer do Codex
(.hbn/results/0021-*), mesmo que já exista.

RAIZ CANÔNICA: /Users/macbookpro/Projetos/usehbn
Tudo é relativo a essa raiz. Se ela não existir ou não for um repo git, PARE
e reporte — não procure outra pasta.

PRÉ-FLIGHT (obrigatório, antes de qualquer leitura):
1. pwd  → confirme /Users/macbookpro/Projetos/usehbn
2. GIT_OPTIONAL_LOCKS=0 git status --short
   Esperado: corrente D untracked/modified, NÃO commitada (M REGISTRY.md,
   M core/relay-spec.md, M schemas/state.schema.json, ?? guards/*, ?? core/*-spec
   novos, ?? methodology/adr/ADR-016..018, ?? schemas novos, ?? reports/20260610-36,
   ?? inbox/credenciamento/20260610-44, ?? .hbn/relay/STATE.md, ?? .hbn/messages/).
   Divergência pequena = observação; raiz/repo errados = PARE.

READ-LIST EXATA (leia TUDO; não confie em resumo de ninguém):
 1. REGISTRY.md — inteiro; foco em 20260610-35..50, "Nota corrente D" e nota 20260610-34
 2. .hbn/relay/STATE.md
 3. .hbn/messages/20260610-01-handoff-corrente-d-fable5.md
 4. methodology/adr/ADR-011-enderecamento-numeracao-temperatura.md
 5. methodology/adr/ADR-012-naming-versoes-ondas.md
 6. methodology/adr/ADR-013-arquiteto-autonomo-classes-a-b.md
 7. methodology/adr/ADR-014-cerimonia-proporcional-tiers.md
 8. methodology/adr/ADR-015-perfis-de-modelo.md
 9. methodology/adr/ADR-016-dual-run-caracterizacao.md       ← objeto
10. methodology/adr/ADR-017-freeze-gate-executavel.md         ← objeto
11. methodology/adr/ADR-018-papeis-chapeus-anti-groupthink.md  ← objeto
12. core/relay-spec.md (v2; campo `atribuicao` proposed)
13. core/cadence-d.md
14. core/dual-run-spec.md                                     ← objeto
15. core/freeze-gate-spec.md                                  ← objeto
16. core/roles-assignment-spec.md                             ← objeto
17. guards/assert-registry-line.sh                            ← objeto
18. guards/assert-role-family.sh                              ← objeto
19. guards/freeze-gate.sh                                     ← objeto
20. guards/assert-scope-lock.sh (precedente C3)
21. guards/hbn-guards-runner.sh + guards/lib/common.sh (confirme: nenhum
    guard novo ativado no runner)
22. schemas/state.schema.json (propriedade `atribuicao`)      ← objeto
23. schemas/dual-run-result.schema.json                       ← objeto
24. schemas/freeze-checklist.schema.json                      ← objeto
25. reports/20260610-36-proposal-faxina-prompts-raiz.md (faxina DRY-RUN)
26. reports/20260610-15-proposal-bump-versao-canonico.md (bump 0.3.1 adiado)
27. inbox/credenciamento/20260610-44-freeze-gate-v206.md
28. .hbn/models/codex.json, fable-5.json, gemini-3-5.json, opus-4-8.json
29. 20260610-51-prompt-pack-auditoria-cruzada-corrente-d.md (seu mandato)

ESCOPO DA AUDITORIA — 6 pontos, cada um com veredito + evidência:
(1) COERÊNCIA E COMPLETUDE da evolução C1→D (blocos 0–4): conjunto
    consistente? contradições entre ADR×spec×schema×guard? peça faltando?
(2) LÓGICA DO BASTÃO E DO STATE: simule ser a janela que retoma — a retomada
    é barata, clara e sem perda? O STATE diz a VERDADE (confronte cada campo
    com o repo)? A read-list canônica do relay-spec é suficiente e mínima?
    Aqui interessa especialmente sua leitura conceitual: o modelo STATE×LOG
    e o dogfood do canônico se sustentam filosoficamente e na prática?
(3) ONDE ESCREVE / NUMERAÇÃO AAAAMMDD-NN / TEMPERATURA / REGISTRY: aplicação
    consistente da tabela do ADR-011 nos depósitos 35..52? Há órfão (artefato
    sem linha, linha sem artefato)? Reserva/renumeração 51–57 da faxina coerente?
(4) OS GUARDS (registry-line, role-family, freeze-gate, scope-lock) FAZEM O
    QUE PROMETEM? Procure falso negativo, falso positivo, parsing frágil,
    divergência código×spec×ADR. Pode executar SOMENTE em cópia descartável
    em /tmp; NUNCA mutar o repo canônico.
(5) RECOMENDAÇÕES E ADR-016/017/018 SÃO ADEQUADOS? Inclua tensões
    filosóficas, riscos antropológico-culturais e comparação com precedentes
    externos (characterization testing/Feathers; release gates; revisão por
    pares independente) — seu diferencial nos pareceres 0011–0020. Há
    BLOQUEADOR/FORTE contra adoção? A exceção fable×opus (ADR-018 Decisão 3)
    está bem cercada?
(6) FAXINA DRY-RUN E BUMP ADIADO foram decisões corretas? Riscos residuais?

SEVERIDADES: BLOQUEADOR (veto) / FORTE / MARGINAL. Todo finding cita
artefato + linha/trecho — afirmação sem evidência não conta.

CHECKLIST ANTI-VIÉS DE BASTÃO (responda explicitamente):
B1. Li os artefatos eu mesmo, sem confiar no resumo do handoff/STATE?
B2. Verifiquei de forma independente as alegações de teste do implementador
    (handoff §Evidência: 4/4, 4/4, 3/3, 3/3)?
B3. Procurei ativamente razões para REPROVAR antes de aprovar?
B4. Zero contradições com o implementador → re-examinei por leniência?
B5. Alguma recomendação minha preserva a MINHA relevância como ferramenta
    (viés observado em 2026-05-27)? Qual?
B6. Auditar não me dá o bastão: não propus assumir a próxima ação.

PROIBIDO: implementar, adotar, ativar guard, mover/renomear/deletar, editar
qualquer artefato do canônico, commitar, ler o parecer do outro auditor,
escrever fora do arquivo de saída. ÚNICO write permitido:

SAÍDA: .hbn/results/0022-cross-ia-antigravity-corrente-d.md
(se 0022 já existir, use o próximo NNNN livre e diga qual usou)
Formato markdown, espelhando a convenção dos pareceres 0011–0020:
# Parecer Antigravity — auditoria cruzada corrente D (C1→D)
**Auditor:** antigravity (Gemini 3.5) · **Session role:** cross-ia-audit-corrente-d
**Reviewed at:** <data>
## Pré-flight  (pwd + divergências de git status)
## Veredito por escopo  (tabela: item 1–6 | veredito | evidência-chave)
## Findings  (F-NN | severidade | artefato | evidência | recomendação)
## Tensões filosóficas e risco antropológico/cultural
## Comparação com precedentes externos
## Checklist anti-viés (B1–B6)
## Recomendação por hearback (H1–H6)
## VETO_ADOÇÃO: sim|não
## Recomendação para humano (<=10 linhas)
Ao terminar: imprima no chat o caminho do arquivo gravado + VETO_ADOÇÃO +
contagem de findings por severidade. Nada além disso.
```
