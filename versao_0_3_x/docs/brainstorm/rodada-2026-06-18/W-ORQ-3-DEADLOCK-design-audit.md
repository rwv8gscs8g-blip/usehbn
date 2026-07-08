# W-ORQ-3 — Deadlock de selagem/freeze sob G-ORQ-REF: dossiê + brief de auditoria de design

NÃO-NORMATIVO (zona livre). Orquestrador (opus-4-8 · Anthropic), 2026-06-18. Branch
`proposta/reestruturacao-m-a-s0`; main intocada em `4db6928`; HEAD da onda `3da43c4`.
Insumo para auditoria de design cross-família (gemini/Google + grok/xAI + codex/OpenAI),
consolidação pelo orquestrador e despacho de implementação ao codex (W-ORQ-3b).

---

## 0. TL;DR

A entrega W-ORQ-3 (commit `3da43c4`, guard `guards/assert-orq-entrada-ref.sh` = **G-ORQ-REF**)
passa todos os testes que ela mesma definiu (208/208; adversarial B48–B51 bloqueadas) e foi
aprovada por dois cross-audits ≠-OpenAI (antigravity/Google + grok/xAI, ambos `APROVA_0061: SIM`).
**Mas** introduz um **deadlock** no primeiro ato de autoridade que a seguir — a própria selagem
da W-ORQ-3 (0062) e, depois, o W-FREEZE. Nenhum dos dois cross-audits testou esse caminho.

## 1. O deadlock, por arquivo:linha (Truth Barrier)

Dois invariantes mecânicos colidem num **ato de autoridade que edita o STATE**:

1. **Toda edição do STATE invalida a atestação de entrada** — `guards/assert-orq-entrada.sh:282`
   compara `manifest_sha256` da atestação com o manifesto recomputado da read-list canônica; o
   STATE é item da read-list, então qualquer mudança no blob do STATE muda o manifesto e **falha**
   a menos que a atestação seja **regenerada** no commit (lição operacional 4a). O runner roda esse
   guard em todo commit (`guards/hbn-guards-runner.sh`).
2. **Re-pin vedado em ato de autoridade** — `guards/assert-orq-entrada-ref.sh:248-251`: se um ato
   de autoridade (selagem detectada em `:126-142`, nome contém "selagem" `:138`; freeze `:163`;
   despacho `:156`) traz a atestação `.hbn/attestations/<fp>-orq-entrada.json` alterada no commit
   **local** (sem `HBN_DIFF_BASE`), **BLOQUEIA** ("Re-pin ... é vedado").

Consequência na selagem 0062 (que edita `onda_atual`, `proxima_acao`, `readback_ativo` no STATE):
- **regenerar** a atestação → bloqueada por `assert-orq-entrada-ref.sh:248`;
- **não regenerar** → bloqueada por `assert-orq-entrada.sh:282` (manifest drift).

Ambos os lados travam. O mesmo vale para o **W-FREEZE** (ato de autoridade `.hbn/freeze/*.json`).

### 1.1. Por que a saída "regenerar em commit anterior separado" não fecha trivialmente

A read-list canônica traz `readback_ativo` como item **DYNAMIC** (`core/read-list-canonica.txt`;
resolvido por `assert-orq-entrada.sh:99-114`). Logo a atestação pina o conteúdo do readback ativo.
Um commit prévio que regenerasse a atestação precisaria que o STATE já apontasse
`readback_ativo=.hbn/readbacks/0062-...` **e** que esse arquivo já existisse no índice — senão o
manifesto falha ("item da read-list ausente"). Isso embaralha a ordem natural (o readback de
selagem nasce no commit de selagem). Não há, hoje, procedimento de selagem demonstrado que passe
sob o G-ORQ-REF — e **não há teste** cobrindo "ato de autoridade + edição de STATE + regeneração".

## 2. Causa-raiz (hipótese do orquestrador)

`assert-orq-entrada-ref.sh:247-251` trata **qualquer** alteração do arquivo de atestação como
"re-pin". Não distingue:
- **re-pin verdadeiro** — mudança de `bastao_token_fp` / identidade do dono do bastão (sequestro de
  bastão); o que o gate deve mesmo barrar; vs.
- **regeneração de mesmo-fp** — desafio/manifesto recomputado porque o conteúdo da read-list (STATE)
  mudou, com `bastao_token_fp` inalterado; exigida pela 4a e inofensiva (a prova extrativa de
  `assert-orq-entrada.sh` impede regeneração fraudulenta — não há como forjar uma atestação válida
  sem ter lido os arquivos).

## 3. Candidatos de saída (para os auditores estressarem — não são decisão)

- **Exit A — re-pin escopado por fp (candidato líder do orquestrador).** G-ORQ-REF bloqueia
  alteração de atestação em ato de autoridade **só quando** o `bastao_token_fp` muda (ou surge
  atestação de fp diferente). Regeneração de mesmo-fp é permitida **desde que** a atestação
  regenerada ainda passe `assert-orq-entrada.sh` contra o novo STATE. Preserva a segurança
  (bloqueia hijack; a prova extrativa cobre a fraude) e desfaz o deadlock. Risco a auditar:
  como detectar mudança de fp de forma robusta (comparar fp do blob antigo `HEAD:` vs novo `:`),
  e garantir que não abre brecha para trocar identidade mantendo o mesmo fp.
- **Exit B — regeneração em commit próprio + ordenação.** Manter o bloqueio amplo e mandar
  regenerar antes, em commit não-autoridade. Precisa resolver o problema da ordem do
  `readback_ativo` DYNAMIC (§1.1). Risco: frágil, multi-commit, fácil de errar na operação.
- **Exit C — desacoplar a atestação dos campos voláteis do STATE.** A atestação pina só partes
  ESTÁVEIS do STATE (não `proxima_acao`/`readback_ativo`/`onda_atual`, que mudam toda onda), de
  modo que edições de rotina não a invalidem. Reduz a frequência de regeneração. Risco: muda a
  semântica da prova de entrada; precisa redefinir o que é "estável".
- **Exit D — combinação.** Ex.: A (fp-scoped) + um teste de selagem dogfood obrigatório no CI.

## 4. Pergunta de design aos auditores

Para cada família, com evidência por arquivo:linha e/ou comando+saída:
1. Confirmar ou refutar o deadlock descrito em §1 (reproduzir o raciocínio no disco).
2. Avaliar Exit A: é seguro permitir regeneração de mesmo-fp em ato de autoridade? Há vetor de
   burla que a prova extrativa NÃO cubra? Como detectar "mudança de fp" sem falso-negativo?
3. Propor o exit preferido (A/B/C/D ou outro) com o racional de segurança × operabilidade.
4. Especificar o(s) teste(s) que provam que uma **selagem real passa** sob o guard corrigido
   (hoje inexistente) — incluindo o caso DYNAMIC `readback_ativo` (§1.1).
5. Apontar qualquer impacto no W-FREEZE (que é o próximo ato de autoridade de verdade).

## 5. Meta-lição para os próximos orquestradores (candidata a knowledge 0026)

**O zelador confere o disco de forma independente — inclusive contra cross-audits que aprovaram.**
Aqui, dois cross-audits ≠-família (Google + xAI) aprovaram a W-ORQ-3 com pareceres minuciosos, mas
ambos só exercitaram os vetores que a própria entrega definiu (B48–B51) e o fail-closed. O deadlock
estava na **interação** entre o guard novo e um invariante pré-existente (4a + `assert-orq-entrada`)
no caminho que ainda não tinha teste — a selagem/freeze. Padrões que custaram este achado:

1. **Auditoria cruzada tende a verificar a superfície que o autor nomeou.** Os casos de teste de
   uma entrega definem o que os auditores conferem; a regressão mora no que ninguém nomeou. O
   orquestrador deve perguntar explicitamente "qual é o PRÓXIMO ato que este guard vai gatear, e
   alguém demonstrou que ele passa?".
2. **Todo guard novo de autoridade deve ser dogfoodado contra o próprio rito que o usa** (selagem,
   freeze) ANTES de selar — não só contra fixtures adversariais. "Passa os testes que definiu" não
   é "não regride o fluxo real".
3. **O orquestrador é o primeiro submetido às barreiras que mantém** (G-ORQ-ENTRADA). Quando uma
   barreira nova recai sobre o próprio ato de autoridade do orquestrador, ele é quem sente o
   deadlock primeiro — e tem o dever de PARAR e relatar, nunca contornar (knowledge 0024/0025: só
   gate enforçado vincula; instrução escrita não basta).
4. **Aprovação de cross-audit ≠ selagem segura.** A ratificação (≥2 famílias + gate humano) é
   necessária, não suficiente; o julgamento independente do zelador, citando arquivo:linha, é a
   última barreira antes do disco virar verdade.

(Promoção desta lição a `.hbn/knowledge/0026-*.md` segue o rito de curadoria com aprovação humana
por arquivo — knowledge 0024 — quando o gate decidir.)
