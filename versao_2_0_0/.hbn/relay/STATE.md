---
state_version: 2
projeto: usehbn (canônico)
protocolo: "HBN 2.0.0-desafiante (exoesqueleto pós-exúvia; INATIVO até Fitness Gate)"
onda_atual: "BOOTSTRAP — versão construída em 2026-07-01 por fable-5 (implementador da exúvia, gate humano de Maurício). Aguarda cross-audit de 4 famílias + consolidação arquiteto + Fitness Gate."
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: codex
papel_bastao: "orquestrador-provisorio (vigente no incumbente; handoff a orquestrador Anthropic previsto na ativação desta versão)"
modo_educacional: "intermediário"
papeis:
  arquiteto: "consolidação pós-auditoria (chat Fable-arquiteto) — desenho desta versão: fable-5 sob gate humano"
  implementador: "codex (após ativação); fable-5 (apenas neste bootstrap)"
  auditores_validadores: "codex + antigravity/gemini-3-5 + grok + cursor — cross-audit do bootstrap pendente"
  gate_humano: "Maurício — autorizou o corte crítico e a intervenção fable-5 em 2026-07-01"
proxima_acao: 'CROSS-AUDIT do bootstrap por 4 famílias (codex/OpenAI, antigravity/Google, grok/xAI, cursor) com pareceres em .hbn/results/ do INCUMBENTE; depois consolidação pelo chat Fable-arquiteto; depois Fitness Gate (FITNESS-CHECKLIST.md); ativação SOMENTE com hearback humano + flip de .hbn/active-version.'
roadmap_ativo: "FITNESS-CHECKLIST.md"
proximo_ponto:
  passo: 'Cross-audit do bootstrap versao_2_0_0 por 4 familias com veredito APROVA_EXUVIA_V2 em pareceres canonicos no incumbente'
  ato: implementacao
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/messages/20260701-193000-fable-5-bootstrap-exuvia-versao-2-0-0.md
  status: pendente
sinais_abertos:
  - "🟡 CROSS-AUDIT PENDENTE — 4 pareceres (codex, antigravity, grok, cursor) sobre este bootstrap; prompts no adendo 20260701 em ~/Projetos; vereditos APROVA_EXUVIA_V2: SIM|NAO depositados no .hbn/results/ do incumbente (esta versão está inativa e não recebe artefatos de terceiros até ativação)."
  - "🟡 FITNESS GATE PENDENTE — ver FITNESS-CHECKLIST.md; inclui C-DOG (freeze V206 do Credenciamento) como prova real; ativação vedada antes."
  - "🟡 ONDAS NATAS DO DESAFIANTE (ordem fixa, pós-ativação): 1) G-ACTOR-WRITE-MATRIX; 2) G-ORQ-NO-DELETE; 3) rehash read-list-canonica; 4) tiers do runner (15 no pre-commit, tudo no CI). Ver core/05-guards.md."
  - "🟡 RECONCILIAR NO INCUMBENTE — árvore suja classes A–E (manifesto de faxina) segue no plano do documento-mestre fable-5; a exúvia NÃO substitui a faxina."
  - "🟢 HERDADO SEM ALTERAÇÃO — guards (30+3), suíte, bateria adversarial, schemas, knowledge 0001–0032, fitness-criteria, freeze-gate-spec, dual-run-spec, rollback script (ver MANIFESTO-MIGRACAO.md)."
---

# STATE — useHBN v2 (desafiante)

## Resumo executivo (≤ 30 linhas)

1. Esta pasta é o exoesqueleto candidato da 1ª exúvia do useHBN, construído em
   2026-07-01 por fable-5 como implementador único, sob autorização explícita
   do gate humano ("corte crítico por incapacidade operacional das IAs de ler
   o contexto"), com auditoria cruzada de 4 famílias como contrapeso ao
   desenho+implementação concentrados (anti-F-01 compensado por quórum ampliado).
2. Leitura de entrada: `BOOT.md` (≈150 linhas) + este resumo + cartão de papel.
   Custo alvo de boot: < 500 linhas (incumbente: ~2.500).
3. Normativa: 8 specs consolidadas em `core/` + 3 contratos verbatim
   (fitness-criteria, freeze-gate, dual-run) + matriz de escrita declarativa.
4. Enforcement: guards herdados SEM alteração de lógica (decisão registrada em
   `core/05-guards.md`); version-aware via `.hbn/active-version` (scaffold M-A).
5. Esta versão está INATIVA (`.hbn/active-version` da raiz permanece `.`).
   Flip só após: quórum 4 famílias → consolidação arquiteto → Fitness Gate
   (8 critérios, incluindo V206 real) → hearback humano assinado.
6. Rollback: o incumbente permanece íntegro na raiz; desfazer = remover esta
   pasta (nenhum arquivo fora dela foi tocado pelo bootstrap).
7. Próxima ação única: ver `proxima_acao` acima.
