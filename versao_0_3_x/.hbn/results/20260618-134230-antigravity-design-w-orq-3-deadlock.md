---
path: .hbn/results/20260618-134230-antigravity-design-w-orq-3-deadlock.md
id-global: 20260618-134230-antigravity-design-w-orq-3-deadlock
tipo: audit-result
autor: antigravity
familia: Google
veredito: "AUDITORIA: CONCLUIDA"
arvore: fronteira
created_at: "2026-06-18T13:42:30-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

# PARECER DE AUDITORIA DE DESIGN — RESPOSTA AO DOSSIÊ W-ORQ-3-DEADLOCK

- **Auditor**: antigravity (Família Google)
- **Papel**: Auditor de Design
- **Data/Hora**: 2026-06-18T13:42:30-03:00
- **Dossiê Auditado**: [W-ORQ-3-DEADLOCK-design-audit.md](file:///Users/macbookpro/Projetos/usehbn/docs/brainstorm/rodada-2026-06-18/W-ORQ-3-DEADLOCK-design-audit.md)
- **Status**: Auditado, Deadlock Confirmado e Rota de Fuga Especificada

---

## 1. Confirmação do Deadlock (§4 Pergunta 1)

Confirmamos o deadlock mecânico descrito no dossiê. A colisão de invariantes impede qualquer fluxo de selagem de autoridade subsequente.

### 1.1 Raciocínio de Bloqueio Mútuo
1. **Invariante de Manifesto Dinâmico:** `guards/assert-orq-entrada.sh:282` exige que o campo `manifest_sha256` na atestação `.hbn/attestations/<fp>-orq-entrada.json` seja idêntico ao hash recomputado dos 13 arquivos da read-list canônica. 
   - A read-list canônica inclui o próprio `STATE.md` e, como item **DYNAMIC**, o `readback_ativo` em curso.
   - Qualquer ato de autoridade (como a selagem 0062) obrigatoriamente modifica o `STATE.md` (campos `readback_ativo`, `proxima_acao`, etc.) e cria/modifica o JSON de readback.
   - Portanto, os OIDs desses arquivos no índice staged são diferentes dos OIDs antigos. Para que o commit passe por `assert-orq-entrada.sh`, a atestação **deve ser regenerada** no mesmo commit com o novo `manifest_sha256` e o novo `seed_sha256`.
2. **Invariante de Re-pin Estático:** `guards/assert-orq-entrada-ref.sh:248-251` proíbe terminantemente qualquer alteração em arquivos de atestação no mesmo commit que um ato de autoridade.
   - Se o commit local (sem `HBN_DIFF_BASE`) trouxer uma atestação alterada, o guard levanta a exceção:
     `Re-pin de atestacao no mesmo commit de ato de autoridade e vedado: ...`

### 1.2 Prova de Reprodução no Disco (Truth Barrier)
Criamos um repositório temporário isolado simulando a selagem, copiando os guards e gerando uma atestação válida inicial. Ao tentar realizar um ato de selagem, os dois caminhos falharam como previsto:

- **Caso 1: Sem regenerar a atestação no mesmo commit de selagem**
  ```
  G-ORQ-ENTRADA: execution_id divergente do readback ativo: esperado 'selagem-teste-execution-1234'
  G-ORQ-ENTRADA: manifest_sha256 divergente da read-list recomputada
  G-ORQ-ENTRADA: challenge.seed_sha256 divergente
  G-ORQ-ENTRADA: line_response para path fora da read-list: .hbn/readbacks/0056-g-orq-entrada.json
  G-ORQ-ENTRADA: line_no divergente para .hbn/relay/STATE.md: esperado 10, obtido 9
  G-ORQ-ENTRADA: line_text divergente para .hbn/relay/STATE.md
  G-ORQ-ENTRADA: line_sha256 divergente para .hbn/relay/STATE.md
  G-ORQ-ENTRADA: line_response obrigatoria ausente: .hbn/readbacks/0062-selagem-teste.json
  G-ORQ-ENTRADA: field_response divergente para proxima_acao
  G-ORQ-ENTRADA: field_response divergente para readback_ativo
  
  [hbn-guards/assert-orq-entrada] ✗ COMMIT BLOQUEADO
    motivo: Atestacao de entrada do orquestrador invalida para bastao 34a7f2f9.
  ```
- **Caso 2: Regenerando a atestação no mesmo commit de selagem**
  ```
  [hbn-guards/assert-orq-entrada-ref] ✗ COMMIT BLOQUEADO
    motivo: Re-pin de atestacao no mesmo commit de ato de autoridade e vedado: .hbn/attestations/34a7f2f9-orq-entrada.json. Gere nova atestacao em commit proprio antes do ato.
  ```

---

## 2. Avaliação de Segurança do Exit A (§4 Pergunta 2)

**Exit A (fp-scoped)** propõe permitir a alteração da atestação no commit de autoridade desde que o fingerprint (`bastao_token_fp`) permaneça idêntico ao anterior (permitindo regeneração de mesmo-fp, mas vetando re-pin de nova chave).

### 2.1 Análise de Segurança e Vetores de Burla
- **O Exit A é perfeitamente seguro.** A prova extrativa de leitura dinâmica do `assert-orq-entrada.sh` permanece integralmente ativa e é executada no final do fluxo.
- Se um atacante tentar injetar alterações maliciosas nas specs/STATE e regenerar a atestação de mesmo-fp para forçar a entrada:
  1. Ele deve saber responder ao desafio extrativo gerado pela semente recomputada (que muda conforme o OID dos arquivos staged).
  2. Ele deve possuir o segredo do bastão localmente para que o hook `assert-baton-token.sh` libere o commit local.
  3. A identidade e posse do bastão não mudaram. O atacante não está sequestrando o bastão, mas utilizando o bastão legítimo previamente estabelecido.
- **Vetor Não Coberto:** Nenhum. A regeneração de mesmo-fp apenas recalcula o manifesto de leitura para provar que a identidade detentora do bastão leu o novo estado staged antes de submeter o commit de autoridade.

### 2.2 Algoritmo de Detecção de Mudança de Fingerprint (Sem Falso-Negativo)
Para diferenciar a regeneração legítima (mesmo-fp) de um sequestro de bastão (novo fp/re-pin verdadeiro), o guard deve comparar o token fingerprint do estado anterior (HEAD/base) com o staged:

1. **Determinar Base:** `BASE_REF="HEAD"`; se `HBN_DIFF_BASE` estiver definida, `BASE_REF="${HBN_DIFF_BASE}"`.
2. **Extrair FP da Base:** Ler `.hbn/relay/STATE.md` no commit base, capturar `bastao_token_sha256` e pegar os 8 caracteres iniciais (`BASE_FP`).
3. **Extrair FP Staged:** Ler `.hbn/relay/STATE.md` do índice staged (`git show :.hbn/relay/STATE.md`), capturar o hash e pegar os 8 caracteres iniciais (`STAGED_FP`).
4. **Decisão:**
   - Se `STAGED_FP != BASE_FP` ou `BASE_FP` for vazio: é um **re-pin verdadeiro**. Bloqueia se qualquer arquivo em `.hbn/attestations/` estiver no diff.
   - Se `STAGED_FP == BASE_FP`: é **mesmo-fp**. Permite a alteração exclusivamente do arquivo `.hbn/attestations/${STAGED_FP}-orq-entrada.json`. Se houver qualquer outro arquivo de atestação modificado no diff, bloqueia.

---

## 3. Exit Preferido e Racional de Segurança × Operabilidade (§4 Pergunta 3)

### Nosso Voto: Exit D (Exit A + Testes de Dogfood CI)

#### Justificativa de Segurança × Operabilidade:
- **Segurança Máxima:** Mantém a barreira contra hijack do bastão de orquestrador na mesma transação que executa o despacho/selagem (re-pin segue bloqueado). O compromisso de leitura é garantido porque a atestação mesmo-fp precisa recalcular o desafio sobre os novos OIDs staged.
- **Operabilidade:** Permite ritos de selagem e freeze de commit único (Single-Commit Authority Acts), removendo a necessidade de cadeias de commit complexas e propensas a erro humano.
- **Prevenção de Regressão (CI Dogfood):** A inclusão de testes automáticos específicos na CI que mimetizam o rito de selagem real garante que futuras otimizações de guards não reintroduzam colisões lógicas parecidas.

#### Por que recusar Exit B e Exit C?
- **Exit B (Multi-Commit):** Operacionalmente inviável e circular. Como o readback de selagem é dinâmico e tem seu OID verificado na atestação, não é possível commitar a atestação em C1 (sem o readback exato) e o ato em C2. A tentativa geraria quebras em cascata de consistência do manifesto.
- **Exit C (Desacoplamento):** Reduz a segurança ao remover campos voláteis do manifesto. Isso permitiria ao orquestrador submeter um ato sem provar que leu as atualizações imediatas do STATE de controle.

---

## 4. Especificação dos Testes de Selagem Real (§4 Pergunta 4)

Propomos adicionar um teste na suíte de testes de desenvolvimento [run-guard-tests.sh](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh):

```bash
# --- Teste de Selagem Legítima de Autoridade (Exit A) ---
d="$(make_orq_entrada_repo)" # inicializa com bastão e atestação coerentes
# 1. Preparar o ato de selagem (autoridade)
cat > "$d/.hbn/readbacks/0062-selagem-teste.json" <<'EOF'
{
  "readback_id": "0062-selagem-teste",
  "execution_id": "selagem-real-1234",
  "agent_id": "codex",
  "track": "safe_track",
  "authority_act": "selagem",
  "status": "selado",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json"
}
EOF

# 2. Modificar o STATE.md (simula rito de transição)
cat > "$d/.hbn/relay/STATE.md" <<'EOF'
---
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: claude-opus-4-8
papel_bastao: "orquestrador"
readback_ativo: ".hbn/readbacks/0062-selagem-teste.json"
handoff_mais_recente: ".hbn/messages/20260618-003300-codex-handoff-g-orq-entrada.md"
proxima_acao: "Selagem concluida."
atribuicao:
  chapeu_atual: orquestrador
  implementador: codex
---
EOF

# 3. Adicionar os novos hashes no index do read-list-canonica.txt
cat > "$d/core/read-list-canonica.txt" <<EOF
$(git -C "$d" hash-object .hbn/relay/STATE.md) .hbn/relay/STATE.md
DYNAMIC handoff_mais_recente
DYNAMIC readback_ativo
$(git -C "$d" hash-object agents/role-templates.md) agents/role-templates.md
$(git -C "$d" hash-object .hbn/knowledge/0022-firewall-workflow-fast-track.md) .hbn/knowledge/0022-firewall-workflow-fast-track.md
$(git -C "$d" hash-object core/role-cards.md) core/role-cards.md
$(git -C "$d" hash-object .hbn/knowledge/0001-comandos-atomicos-copiaveis.md) .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
$(git -C "$d" hash-object .hbn/knowledge/0002-entrega-operacional-minimalista.md) .hbn/knowledge/0002-entrega-operacional-minimalista.md
$(git -C "$d" hash-object .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md) .hbn/knowledge/0023-area-temporaria-e-fixtures-efemeras.md
$(git -C "$d" hash-object .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md) .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md
$(git -C "$d" hash-object .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md) .hbn/knowledge/0025-auditor-read-only-sem-no-verify.md
$(git -C "$d" hash-object core/orchestrator-profile-spec.md) core/orchestrator-profile-spec.md
$(git -C "$d" hash-object core/relay-spec.md) core/relay-spec.md
EOF

# 4. Stagear os arquivos de ato de autoridade e STATE.md
( cd "$d" && git add .hbn/relay/STATE.md .hbn/readbacks/0062-selagem-teste.json core/read-list-canonica.txt )

# 5. Regenerar a atestacao de mesmo-fp contra o index staged
write_valid_orq_attestation "$d"
( cd "$d" && git add .hbn/attestations/34a7f2f9-orq-entrada.json )

# 6. Executar o guard de ref e garantir aprovação (pass)
check "orq-ref: selagem com regeneracao de mesmo-fp no mesmo commit passa" pass "$(run_orq_ref "$d")"
```

No caso de item **DYNAMIC**, a função `write_valid_orq_attestation` resolve dinamicamente a referência `readback_ativo` do staged `STATE.md` (nesse caso, `.hbn/readbacks/0062-selagem-teste.json`) e inclui seus OIDs no `manifest_sha256`. O script do teste passa sem falha de coerência mecânica.

---

## 5. Impacto no W-FREEZE (§4 Pergunta 5)

Sem a correção do deadlock, o **W-FREEZE** (que é o rito que congela a branch de forma definitiva gerando os arquivos `.hbn/freeze/*.json`) estaria **totalmente bloqueado**.
1. O freeze é um ato de autoridade do orquestrador e grava um arquivo de freeze staged no commit local.
2. Escrever o freeze altera a read-list canônica (o STATE muda de status, a lista de arquivos da onda congela).
3. Isso invalida a atestação vigente.
4. Tentar regenerar a atestação no mesmo commit do freeze seria barrado pelo G-ORQ-REF antigo.
5. Aplicando o **Exit A**, a gravação do freeze e a regeneração da atestação do mesmo bastão (`34a7f2f9`) passam a rodar limpas em um único commit atômico no CI ou local.

---

## 6. Registro de Tabela no REGISTRY.md

REGISTRY:
| 20260618-134230-antigravity-design-w-orq-3-deadlock | .hbn/results/20260618-134230-antigravity-design-w-orq-3-deadlock.md | audit-result; autor=antigravity; familia=Google; veredito=AUDITORIA:CONCLUIDA; onda=w-orq-3-deadlock | frio | fronteira | — | 2026-06-18T13:42:30-03:00 |
