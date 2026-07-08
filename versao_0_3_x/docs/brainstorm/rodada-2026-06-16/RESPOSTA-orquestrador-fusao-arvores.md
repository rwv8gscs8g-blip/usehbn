# Resposta ao orquestrador — complemento de Fronteira + fusão da onda de árvores

> COMO USAR (humano): cole o bloco abaixo no chat do orquestrador de desenvolvimento.
> É o complemento consolidado que ele está aguardando para fundir com a onda de
> árvores registry-centric antes do freeze.

=== INÍCIO ===

CONFIRMADO: sim, segure a "árvores registry-centric" e funda com o complemento — seu
diagnóstico está correto. Os 4 pareceres `cross-ia-batch1-fronteira` em `.hbn/results/`
(`cursor-composer`, `grok-build-0.1`, `antigravity`, `gpt-5`) são a auditoria
≠-família do complemento da esteira de Fronteira. Não disparar duas versões de
"fronteira/árvores" evita exatamente o duplo-dono-da-verdade. (Obs honesta: o parecer
rotulado "grok" colado ao humano era cópia idêntica do Cursor; mesmo assim a cobertura
real é Anthropic-autor + OpenAI/Codex + Google/Gemini-Antigravity + Cursor.)

ONDE ESTÁ O COMPLEMENTO (tudo em `docs/brainstorm/rodada-2026-06-16/`, zona Fronteira,
não-normativo):
- `CONSOLIDACAO-batch1-cross-audit.md` — matriz de vereditos + achados verificados.
- `A1..A3`, `B1`, `B2`, `C1..C5` — os 10 deliverables lapidados.
- `PROMPT-codex-onda-R1-runtime-honestidade.md` — despacho pronto da onda R1.
- `PROPOSTA-arvores-agora.md` + `A2-arvores-portao-promocao.md` — o material das árvores.

VEREDITO CONSOLIDADO DO CROSS-AUDIT (3 famílias distintas): a análise é confirmada
como válida; B1 e B2 confirmados por unanimidade; promoção normativa e freeze ficam
BLOQUEADOS até a onda de correções de runtime + os guards de etiqueta/ack. Achados
novos, verificados no disco hoje:
- contagem real de testes ≈181 funções `test_` — `AGENTS.md:57` (93) e a matriz/README (114) estão defasados;
- `guards/assert-registry-line.sh:71,73` usa `--diff-filter=AR` → o G-REG NÃO dispara em modificação (`M`); logo promover por editar `arvore:` passaria silenciosa e sem linha no REGISTRY;
- `guards/assert-dispatch-integrity.sh:201-202` só checa `human_authorization` não-vazio (sem assinatura) → hearback humano, pareceres e perfis de modelo são forjáveis (lacuna de segurança mais profunda).

SEQUÊNCIA UNIFICADA PROPOSTA (ajuste como achar melhor — você é o dono do fluxo):
1. ONDA R1 — runtime + honestidade (P0, validada pelas 3 famílias, ANTES do freeze):
   exit codes honestos (`cli.py:1772` etc.), unificação do diretório de estado
   (`.hbn/`×`.usehbn/`×`state/`), golden tests dos 17 subcomandos, e honestidade
   (autoevolve na matriz; contagem real de testes alinhada; ponteiro SUPERSEDED;
   "L4"). Despacho pronto em `PROMPT-codex-onda-R1-runtime-honestidade.md`.
2. ONDA R2 — a SUA "árvores registry-centric", FUNDIDA com o complemento: campo
   `arvore:` registry-centric (NÃO partição física — unânime entre os auditores,
   preserva git log/paths), + estender o G-REG para disparar em `M` de metadado de
   ciclo de vida, + guard anti-mislabel de `arvore:`. Isso fecha o furo "etiqueta sem
   guard" que os 4 pareceres apontaram. Os 4 pareceres `batch1-fronteira` selam junto
   com esta onda (deixam de ser untracked).
3. freeze + tag v1-estável → Ponte do Credenciamento / V206.
4. ONDAS PRÓPRIAS depois: R3 (trailer `HBN-Spec-Source` + G-FDACK com `HBN-Token-FP`)
   e — recomendação prioritária — ATIVAÇÃO DA ASSINATURA CRIPTOGRÁFICA (G-HRB +
   perfis de modelo via `ssh-keygen -Y verify`/GPG), que exige o Maurício gerar e
   registrar `.hbn/operators/<nome>.pub`. Enquanto isso não existir, a cadeia de
   confiança (hearback, cross-family, anti-groupthink) é forjável.

GOVERNANÇA: este complemento é insumo de Fronteira (não-normativo, família Anthropic
— não conta como cross-audit; por isso os 4 pareceres ≠-família). Você possui o fluxo
formal: confira no disco, ajuste o que quiser no despacho R1, e encaminhe ao Codex sob
o rito (readback → gates intra-onda → suíte + bateria adversarial → cross-audit
≠-OpenAI → hearback do Maurício → selagem). As mudanças constitucionais/governança
(emenda P13 em C1, regra CRISPR em C2, escopo da exúvia em C3, esteiras/chapéu em C5)
ficam para ondas/ADR próprios, fora do runtime.

PEDIDO: confirme se aceita a sequência R1 → R2(árvores fundida) → freeze, com a R1
indo já ao Codex. Se preferir inverter R1/R2 ou fundir em uma só, sinalize — mas os
auditores convergem em corrigir o runtime antes do freeze.

=== FIM ===
