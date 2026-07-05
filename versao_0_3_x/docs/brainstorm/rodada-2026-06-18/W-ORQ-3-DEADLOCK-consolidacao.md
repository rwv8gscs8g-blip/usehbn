# W-ORQ-3 deadlock — consolidação cross-família + decisão de design

NÃO-NORMATIVO (zona livre). Orquestrador (opus-4-8 · Anthropic), 2026-06-18. Consolida três
pareceres de design (≠-família) sobre como sair do deadlock de selagem/freeze do G-ORQ-REF.
Base: `W-ORQ-3-DEADLOCK-design-audit.md`. Insumo para o despacho de implementação W-ORQ-3b (codex).

Pareceres consolidados (lidos do disco):
- `.hbn/results/20260618-134230-antigravity-design-w-orq-3-deadlock.md` (Google)
- `.hbn/results/20260618-134500-grok-xai-design-auditor-design-w-orq-3-deadlock.md` (xAI)
- `.hbn/results/20260618-134234-codex-design-w-orq-3-deadlock.md` (OpenAI · viabilidade)

---

## 1. Convergência (3/3)

1. **Deadlock confirmado e reproduzido no disco.** antigravity montou repo temporário e exibiu os
   dois bloqueios; grok e codex rastrearam por arquivo:linha (`assert-orq-entrada.sh:282` ×
   `assert-orq-entrada-ref.sh:248-251`; runner roda os dois). Não há selagem que passe hoje.
2. **Exit A/D é o caminho.** Permitir regeneração de atestação de **mesmo-fp** num ato de
   autoridade. Exit B (multi-commit) rejeitado (frágil; ordenação circular do `readback_ativo`
   DYNAMIC). Exit C (desacoplar campos voláteis) rejeitado como principal (muda a semântica da
   prova de entrada; revisão maior do contrato).
3. **A exceção exige regeneração REAL, não "qualquer byte de mesmo-fp".** `manifest_sha256` novo
   deve diferir do antigo **e** a nova atestação deve passar `assert-orq-entrada.sh`. Caso
   contrário, o B51 regride (edição decorativa passaria). [ponto mais afiado do codex]
4. **Simetria local/CI obrigatória.** Local: `:path` vs `HEAD:path`. CI: `commit^:path` vs
   `commit:path` para cada commit em `HBN_DIFF_BASE..HEAD`. Mesma semântica nos dois modos —
   senão passa no pre-commit e falha no push.
5. **Dogfood obrigatório de selagem real (hoje inexistente).** É a raiz do problema: os 208 testes
   + B48-B51 + os dois cross-audits de 0061 só exercitaram a superfície que a entrega nomeou.
6. **W-FREEZE tem o mesmo deadlock, pior** (`assert-orq-entrada-ref.sh:163-165`). A correção e o
   dogfood devem cobrir o freeze.

## 2. Divergência — o vetor de identidade (e minha arbitragem)

- **antigravity (Google):** "Exit A é perfeitamente seguro; nenhum vetor não coberto." Algoritmo de
  detecção de fp: comparar `BASE_FP` (STATE do HEAD/base) vs `STAGED_FP`.
- **grok (xAI):** achou furo — `assert-orq-entrada.sh:274` só checa `bastao_token_fp == token_fp`;
  **não** cruza `proprietario_bastao`/`identidade` da atestação contra o STATE. Logo, sob Exit A
  só-fp, é possível **soft-hijack**: regenerar uma atestação válida de mesmo-fp declarando outro
  dono. Recomenda bindar identidade + comparar o `bastao_token_sha256` completo (8 hex = 32 bits,
  colisão possível).
- **codex (OpenAI):** concorda com o mecanismo da ameaça, mas **discorda do remédio**: campos
  `identidade`/`proprietario_bastao` **não devem virar fonte de autoridade** — "a autoridade
  mecânica é o token do STATE + prova extrativa". Âncora anti-hijack = comparar o
  `bastao_token_sha256` **completo** (velho vs novo); se mudou, é troca de bastão mesmo com prefixo
  igual. Três sinais de fp independentes (nome do arquivo, fp do JSON antigo, fp do JSON novo)
  todos == fp esperado.

**Arbitragem do orquestrador (eixo de autoridade × eixo de proveniência):**

1. **Autoridade — codex tem razão.** A autoridade mecânica é a posse do token (full
   `bastao_token_sha256`, enforçado por `assert-baton-token.sh`) + a prova extrativa. A âncora
   anti-hijack PRIMÁRIA é a **comparação do SHA completo** do STATE (antigo vs novo) no ato de
   autoridade: qualquer mudança ⇒ re-pin ⇒ BLOQUEIA. Isso já pega a colisão de prefixo que o grok
   teme, sem elevar rótulo a autoridade.
2. **Proveniência — grok tem razão.** Um rótulo (`proprietario_bastao`/`identidade`) que deriva em
   silêncio faz o livro-razão mentir (Truth Barrier). Entra como **checagem de consistência**, NÃO
   como fonte de autoridade: em ato de autoridade, exigir que `proprietario_bastao`/`identidade` da
   atestação regenerada sejam **idênticos** aos do HEAD (ou do STATE) — se divergirem, BLOQUEIA.
   Defesa-em-profundidade barata; honra o caveat do codex (rótulo não autoriza, só não pode mentir).
3. **antigravity subestimou o vetor** ("perfeitamente seguro") — a checagem independente é o que o
   apanhou. Reforça a meta-lição 0026 (zelador confere o disco mesmo contra cross-audits aprovados).

## 3. Design escolhido — "Exit A'" (síntese, para o W-ORQ-3b)

Em `assert-orq-entrada-ref.sh`, substituir o bloqueio amplo (`:247-251` + alça CI `:253-264`) por
uma triagem de diff que, num ato de autoridade, **permite** alterar SOMENTE a atestação esperada
`.hbn/attestations/${token_fp}-orq-entrada.json` se TODAS as condições valerem (senão BLOQUEIA):

1. `orq_entrada_ref` do ato == `.hbn/attestations/${token_fp}-orq-entrada.json`, com `token_fp`
   derivado do `bastao_token_sha256` do STATE **novo (staged)**.
2. Nenhuma OUTRA atestação `.hbn/attestations/<fp>-orq-entrada.json` adicionada/removida/renomeada/
   modificada no mesmo ato.
3. Regeneração real de mesmo-fp: fp do nome == fp do JSON antigo (`HEAD:`/`commit^:`) == fp do JSON
   novo (`:`/`commit:`) == fp esperado; **`bastao_token_sha256` completo do STATE NÃO mudou** no
   ato; `manifest_sha256` novo ≠ antigo; e a nova atestação **passa `assert-orq-entrada.sh`**.
4. **Consistência de proveniência (não-autoritativa):** `proprietario_bastao` e `identidade` da
   atestação nova == os do HEAD; divergência ⇒ BLOQUEIA.
5. Qualquer ambiguidade (blob ausente, JSON ilegível, campo não-string, rename/delete/add, múltiplas
   atestações) ⇒ BLOQUEIA (fail-closed).
6. Triagem ANTES de chamar `assert-orq-entrada.sh` — não basta remover `:247-251`; G-ORQ-REF decide
   "é regeneração permitida do mesmo bastão?", G-ORQ-ENTRADA decide "a prova extrativa é válida?".

Opcional defendido por grok/codex (decidir no W-ORQ-3b ou em onda própria): cruzar
`proprietario_bastao`/`identidade` da atestação ↔ STATE também dentro do `assert-orq-entrada.sh`
(fecha o gap de binding na origem, além do gate). Recomendo incluir já, como item aditivo separado,
porque é a raiz que o grok apontou.

## 4. Matriz de testes obrigatória (dogfood) — antes de qualquer selagem 0062

Positivo (run-guard-tests, staged-first, reusando `make_orq_entrada_repo`/`write_valid_orq_attestation`):
- **P1** selagem real: edita STATE (`readback_ativo`→0062, `proxima_acao`), cria readback 0062
  `authority_act=selagem`+`orq_entrada_ref` esperado, regenera atestação mesmo-fp → `assert-orq-entrada.sh`
  PASS **e** `assert-orq-entrada-ref.sh` PASS. Prova o caminho DYNAMIC `readback_ativo`.

Negativos de controle:
- **N1** mesma selagem sem regenerar atestação → `assert-orq-entrada.sh` BLOCK.
- **N2** atestação alterada só com campo decorativo, `manifest_sha256` igual → BLOCK (preserva B51).
- **N3** atestação esperada com `bastao_token_fp` (JSON) trocado → BLOCK.
- **N4** atestação extra `.hbn/attestations/deadbeef-orq-entrada.json` staged junto → BLOCK.
- **N5** `bastao_token_sha256` completo do STATE trocado no ato, mesmo mantendo 8 chars → BLOCK.
- **N6** `proprietario_bastao`/`identidade` da atestação divergente do HEAD em ato de autoridade → BLOCK.

Bateria adversarial: manter B48-B50; **redefinir B51** para "auto-repin sem regeneração real OU de
fp diferente" (não "qualquer byte same-fp"); somar B52-B54 (fp trocado; full-SHA trocado c/ prefixo
igual; atestação extra). CI/HEAD: um caso com `HBN_DIFF_BASE` provando a selagem same-fp PASS e a
variante de fp trocado BLOCK.

Dogfood final: a **selagem 0062 real** deve ser produzida SOB o guard corrigido (sem bypass) e o
runner + suíte + bateria devem ficar verdes. Incluir um freeze simulado passando.

## 5. Próximos passos

1. Despacho W-ORQ-3b → codex implementa (aditivo, fail-closed, simétrico local/CI) + a matriz §4.
2. Cross-audit ≠-OpenAI da correção (grok/xAI + antigravity/Google) — desta vez exigindo
   explicitamente a verificação do dogfood de selagem real.
3. Hearback humano → selagem 0062 (que agora dogfooda o próprio G-ORQ-REF corrigido).
4. Só então retomar a sequência: W-ORQ-4 → despromoção-P6 → W-FREEZE.
