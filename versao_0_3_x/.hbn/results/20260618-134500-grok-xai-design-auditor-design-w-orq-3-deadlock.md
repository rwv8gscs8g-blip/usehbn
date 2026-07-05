---
path: .hbn/results/20260618-134500-grok-xai-design-auditor-design-w-orq-3-deadlock.md
id-global: 20260618-134500-grok-xai-design-auditor-design-w-orq-3-deadlock
tipo: design-audit
autor: grok-xai-design-auditor
familia: xAI
veredito: "ANALISE DE DESIGN — deadlock confirmado; Exit A' recomendado com escopo de fp+token+identidade + dogfood selagem"
arvore: fronteira
created_at: "2026-06-18T13:45:00-03:00"
status: congelado
temperatura: glacier
---

SOU: grok-xai-design-auditor · familia xAI · papel auditor

# AUDITORIA DE DESIGN — W-ORQ-3 DEADLOCK (G-ORQ-REF + orq-entrada) · xAI

**≠-OpenAI · Truth Barrier: tudo lido do disco (git show, cat, execucao de guards, python de manifest, read de canonica/STATE/guards).**  
Nao usei memorias previas; re-li os 4 arquivos mandatorios + .hbn/relay/STATE.md + .hbn/attestations/34a7f2f9-orq-entrada.json + guards/lib + resultados de cross 0061 + canonica + REGISTRY.

Foco exigido: (a) reproduzir deadlock §1 + impasse ordenacao readback_ativo DYNAMIC §1.1; (b) estressar Exit A por burlas (troca identidade mantendo fp? regen sem reler?); (c) propor exit mais seguro e operavel.

---

## Resumo executivo (para orquestrador e zelador)

Deadlock **confirmado mecanicamente** no disco.

- Edicao de STATE (obrigatória em selagem/freeze) invalida a atestacao corrente via `manifest_sha256` (porque STATE esta na read-list canonica).
- Regenerar a atestacao no mesmo commit de ato de autoridade e **bloqueado** por G-ORQ-REF independentemente de fp.
- Nao ha selagem demonstrada que passe sob G-ORQ-REF (nem no suite 208, nem nos B48-B51, nem nos dois cross-audits 0061).
- O impasse de DYNAMIC readback_ativo torna "regen em commit previo" nao-trivial (order-of-creation).

Exit A (re-pin escopado por fp) resolve o deadlock mas **introduz vetor de soft-hijack** de identidade (proprietario_bastao/identidade) mantendo fp. A prova extrativa **impede** forjar sem reler, mas nao impede declarar dono diferente com mesmo fp.

**Recomendacao:** Exit A' (escopo por fp + full bastao_token_sha256 + campos de identidade) + adicao de match de identidade no assert-orq-entrada + **dogfood obrigatorio de selagem real** no runner/tests. Combinar com desacoplamento parcial de campos volateis (Exit C leve).

---

## 1. Confirmar ou refutar o deadlock descrito em §1 (reproduzir no disco)

**CONFIRMADO.**

Evidencia direta do disco:

```10:12:usehbn/core/read-list-canonica.txt
3018a075aed76767241e3eb9d95496543c7b3f05 .hbn/relay/STATE.md
DYNAMIC handoff_mais_recente
DYNAMIC readback_ativo
```

```99:114:usehbn/guards/assert-orq-entrada.sh
    if [[ "$line" =~ ^DYNAMIC[[:space:]]+([A-Za-z0-9_]+)$ ]]; then
        ...
        readback_ativo) resolved="$READBACK_PATH" ;;
```

```152:152:usehbn/.hbn/relay/STATE.md
readback_ativo: ".hbn/readbacks/0061-w-orq-3.json"
```

Quando selagem executa:
- Atualiza STATE → `readback_ativo`, `proxima_acao`, `onda_atual` (e possivelmente handoff).
- STATE é item da read-list → qualquer alteracao de conteudo muda `manifest_sha256` recomputado em `assert-orq-entrada.sh:240`.
- Validacao falha:

```282:283:usehbn/guards/assert-orq-entrada.sh
if data.get("manifest_sha256") != manifest_sha256:
    fail("manifest_sha256 divergente da read-list recomputada")
```

Para "passar" a atestacao referenciada, e preciso **alterar** `.hbn/attestations/34a7f2f9-orq-entrada.json` (novo manifest, novo seed, novas line_responses extraidas do novo readback_ativo etc).

Porem:

```247:251:usehbn/guards/assert-orq-entrada-ref.sh
changed_attestation=...
if [[ -n "$changed_attestation" && -z "${HBN_DIFF_BASE:-}" ]]; then
    guard_fail "Re-pin de atestacao no mesmo commit de ato de autoridade e vedado: ... Gere nova atestacao em commit proprio antes do ato."
```

Selagem e detectada como authority:

```168:178:usehbn/guards/assert-orq-entrada-ref.sh
if re.match(r"^\.hbn/readbacks/.*\.json$", path):
    ...
    if isinstance(data, dict) and is_authority_readback(path, data):
        ...
```

E `is_authority_readback` aceita "selagem" no path ou `authority_act`/`status selado`.

Resultado: dois bloqueios mutuamente exclusivos. Deadlock.

### 1.1 Impasse de ordenacao do readback_ativo DYNAMIC

```40:46:usehbn/docs/brainstorm/rodada-2026-06-18/W-ORQ-3-DEADLOCK-design-audit.md
A read-list canonica traz `readback_ativo` como item **DYNAMIC** ... Um commit previo que regenerasse a atestacao precisaria que o STATE ja apontasse `readback_ativo=.hbn/readbacks/0062-...` **e** que esse arquivo ja existisse no indice — senão o manifesto falha ("item da read-list ausente"). Isso embaralha a ordem natural (o readback de selagem nasce no commit de selagem).
```

Reproduzido na canonica + logica de resolucao DYNAMIC + na atestacao atual que referencia o readback 0061 como execution source.

Nenhum dos cross-audits de 0061 testou este caminho (ver §5 abaixo).

---

## 2. Avaliar Exit A: seguro permitir regeneracao de mesmo-fp em ato de autoridade?

**Parcialmente seguro, com furos de implementacao que precisam de correcao.**

### O que a prova extrativa cobre bem (regenerar sem reler?)

Cobre 100%. 

- `manifest_sha256` e `seed_sha256` dependem do conteudo atual de todos os 13 itens (incluindo o novo readback DYNAMIC).
- `line_responses` sao escolhidas por `idx = int(challenge_hash[:8],16) % nonempty_lines` e devem bater `line_text` + `line_sha256` exatos.
- Tentar "copiar e ajustar so o manifest" falha nas line_responses (ver B43/B45 na bateria).

Evidencia de execucao previa (adversarial) + codigo:

```337:346:usehbn/guards/assert-orq-entrada.sh
challenge_hash = ...
idx = int(...) % ...
line_no, line_text = ...
if item.get("line_text") != line_text:
    fail(...)
```

Logo, "regenerar sem reler" e bloqueado pela propria validacao da atestacao (que e reusada no final do ref).

### Vetor de burla que a prova extrativa NAO cobre: trocar identidade mantendo mesmo fp

Sim, existe.

- fp = `bastao_token_sha256[:8]`
- assert-orq-entrada **so** checa `bastao_token_fp == token_fp` (do STATE). Nao cruza `proprietario_bastao` nem `identidade` do attest contra STATE.
- Qualquer um que consiga ler os blobs (qualquer committer com acesso ao indice) consegue produzir uma atestacao **valida** para o fp corrente, com qualquer string nos campos de identidade.
- Em um commit de selagem (authority), se Exit A permitir alteracao da atestacao "porque fp igual", o atacante pode:
  1. mudar `proprietario_bastao` / `bastao_token_sha256` (se colidir prefixo) ou manter token mas mudar dono nos dois lugares (STATE + attest)
  2. regen attest (extractive passa)
  3. G-ORQ-REF com Exit A "so fp" aceita (mesmo fp)
  4. orq_entrada_ref continua apontando o fp "velho"

Resultado: soft hijack de bastao sem mudar o fp do arquivo de atestacao.

Evidencia de que hoje nao ha checagem:

```274:275:usehbn/guards/assert-orq-entrada.sh
if data.get("bastao_token_fp") != token_fp:
    fail(...)
# (sem checks para proprietario_bastao ou identidade)
```

No STATE atual e na atestacao atual os campos existem mas nao sao comparados cruzadamente.

### Como detectar "mudanca de fp" sem falso-negativo?

Melhor que so olhar filename:

- Derivar fp do `bastao_token_sha256` do STATE (HEAD vs novo) — se divergiu, e re-pin/hijack.
- Checar o campo `bastao_token_fp` dentro do blob HEAD:attest vs novo attest.
- Adicionalmente: se o full `bastao_token_sha256` do STATE mudou (mesmo prefixo coincidindo), tratar como change.
- 8 hex = 32 bits: colisao e possivel (embora raro); por isso ancorar na comparacao do full token_sha + identidade declarada.

---

## 3. Propor o exit preferido (A/B/C/D ou outro) com racional de seguranca × operabilidade

**Recomendado: Exit A' (A escopado + protecoes de identidade) + dogfood obrigatorio + leve C.**

### Racional

- **A puro** (so fp) resolve deadlock mas abre o vetor de identidade acima.
- **B** (regen previo + ordenacao) e fragil operacionalmente: exige multi-commit, ordem exata do DYNAMIC readback_ativo, e ainda precisa de dogfood para nao errar na selagem real. Facil de quebrar em pressa.
- **C** (desacoplar volateis do STATE) reduz a frequencia de regen (atestacao nao pinaria mais `readback_ativo`/`proxima_acao`/`onda_atual` todos os atos), mas muda a semantica da "prova de entrada" — a atestacao deixa de atestar o estado completo da onda. Pode ser feito de forma parcial (manter os 3 campos obrigatorios de field_responses so para execucao, mas nao no manifest?).
- **D** (combinacao) e o caminho natural.

**Exit A' (proposto):**

No `assert-orq-entrada-ref.sh`, substituir o bloco amplo de changed_attestation por:

- Calcular `old_fp` a partir de `HEAD:.hbn/relay/STATE.md` (ou HEAD:attest se mais seguro) e `new_fp` do STATE staged.
- Se `new_fp != old_fp` ou `new_bastao_token_sha256 != old_bastao_token_sha256` → bloquear re-pin (hijack).
- Se fp/token iguais, permitir alteracao da atestacao **somente se** o novo attest passar `assert-orq-entrada.sh` (prova extrativa).
- Adicional: comparar `proprietario_bastao` e `identidade` do novo attest com o HEAD:attest (ou com STATE); se divergirem em ato de autoridade, bloquear (ou exigir justificativa + trailer humano extra).

No `assert-orq-entrada.sh` (v2 ou v3): adicionar checagens:

```python
if data.get("proprietario_bastao") != state_value(..., "proprietario_bastao"):
    fail("proprietario_bastao do attest diverge do STATE")
# idem para identidade
```

Isto fecha o soft-hijack sem impedir regen legit de conteudo.

**Operabilidade:** 
- Selagem/freeze continuam em 1 commit (como sempre foram).
- O orquestrador so precisa rodar a mesma rotina de "atualizar atestacao" que ja usa hoje (apenas agora o guard permite quando fp/token/owner inalterados).
- CI com HBN_DIFF_BASE continua a checar historico de commits.

**Seguranca:** hijack de bastao (fp ou dono) ainda exige commit separado (ou pelo menos nao misturado com ato de autoridade), e a prova extrativa continua obrigando leitura real.

**Bônus:** promover knowledge 0026 ja mencionada no doc original.

---

## 4. Especificar o(s) teste(s) que provam que uma selagem real passa sob o guard corrigido

Hoje inexistente — essa e a raiz do problema (dois cross + suite so exercitaram os B48-B51 nomeados pela entrega).

Testes obrigatorios a adicionar (antes de qualquer selagem 0062):

1. **run-guard-tests.sh** — caso positivo novo:
   - setup temp repo com bastao orq, readback 0061 + attest valido
   - simular selagem: editar STATE (readback_ativo, proxima, onda), criar readback 0062 com authority_act=selagem + orq_entrada_ref correto, **regenerar attest contra novo manifest** (mesmo fp)
   - stage tudo + rodar `assert-orq-entrada-ref.sh` → deve sair 0 (AUTH >0, orq_entrada_ref ok, attest valida)
   - nome do caso: "selagem real (mesmo bastao/fp) + regen de atestacao = PASS"

2. **adversarial-battery.sh** — 3 casos novos B52-B54:
   - B52: selagem + alteracao de bastao_token_sha256 (fp muda) + regen attest → BLOQUEADA (re-pin hijack)
   - B53: selagem + alteracao apenas de `proprietario_bastao`/`identidade` (fp mantido) + regen → BLOQUEADA (A')
   - B54: selagem legit (somente DYNAMICs + novo readback) + regen mesmo-fp → PASS (o caso positivo de 1 acima, em modo adversarial)

3. **Dogfood real no CI/local**:
   - Depois da correcao, o proprio orquestrador deve produzir a selagem 0062 **usando o guard corrigido** (sem bypass) e o runner deve ficar verde.
   - Adicionar no readback de selagem 0062 nota explicita: "dogfood G-ORQ-REF em selagem real com DYNAMIC readback_ativo".
   - Exigir que o resultado da selagem (readback 0062 + STATE + attest atualizado + handoff) passe `bash guards/hbn-guards-runner.sh` + suite + bateria.

4. Cobertura de W-FREEZE (ver §5).

Sem esses testes, a regressao volta na proxima autoridade.

---

## 5. Apontar qualquer impacto no W-FREEZE

**Mesmo deadlock, pior.**

- W-FREEZE e explicitamente authority act:
  ```163:165:usehbn/guards/assert-orq-entrada-ref.sh
  if re.match(r"^\.hbn/freeze/.*\.json$", path):
      authority_paths.append(path)
      authority_targets.append(path)
  ```

- Freeze tipicamente edita STATE (freeze state, proxima_acao, possivelmente readback_ativo final, onda).
- Portanto: mesmo colisao "edicao STATE → manifest drift" vs "nao pode regen attest no commit de autoridade".
- Freeze e o "proximo ato de autoridade de verdade" apos a selagem 0062 (ver STATE e doc §1).
- Qualquer solucao que nao cubra freeze deixara o W-FREEZE travado.

Recomendacao: os testes de dogfood acima devem incluir um freeze simulado (ou o freeze real apos 0062) passando sob o guard corrigido.

---

## Meta-achados (alinhados com §5 do doc)

- Dois cross-audits (antigravity 100 + grok 92 em 0061) + suite 208 + B48-B51 **nao bastaram**. Nenhum deles perguntou "qual o proximo ato de autoridade que este guard vai gatear de verdade, e alguem ja demonstrou que passa?".
- A lição 0026 (promover?) esta correta: auditoria de superficie nomeada pelo autor e insuficiente; o zelador (e o orquestrador) deve insistir em dogfood do rito real (selagem/freeze).
- A prova extrativa e forte contra forja sem leitura; o ponto fraco atual e a ausencia de binding de identidade + escopo amplo demais do re-pin gate.

---

## Veredito final

Deadlock real, reprodutivel, com causa-raiz clara em `read-list-canonica.txt:10` (DYNAMIC) + `assert-orq-entrada.sh:282` + `assert-orq-entrada-ref.sh:248`.

Exit A' + checagens de identidade + dogfood selagem/freeze e o caminho mais seguro e operavel.

Nao selar W-ORQ-3 / 0062 enquanto o guard nao for corrigido e o caminho de selagem demonstrado verde no disco.

---

**APROVA_0061_REVISADO_POR_DESIGN:** NAO (bloqueado pelo deadlock ate fix + dogfood).  
Recomendacao ao orquestrador: implementar A' , adicionar os 4 testes, re-auditar cross, so entao selar.

(Arquivo depositado com front-matter path real e SOU no topo conforme instrucao.)
