---
path: .hbn/results/20260621-121000-grok-cross-ia-fix-freeze-meta-deref-0088.md
id-global: 20260621-121000-grok-cross-ia-fix-freeze-meta-deref-0088
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0088: SIM"
arvore: fronteira
created_at: "2026-06-21T12:10:00-03:00"
---

SOU: grok · familia xAI · papel auditor

### Verificações Obrigatórias (com comando + saída e arquivo:linha)

#### 1. main intocada
Comando executado:
```
cd /Users/macbookpro/Projetos/usehbn && git rev-parse main
```
Saída:
```
4db692876381a0d7909985c8500d999f2e677b04
```
Confirmado: main permanece exatamente 4db692876381a0d7909985c8500d999f2e677b04 (INTOCADA). Branch atual: proposta/reestruturacao-m-a-s0 no commit 6ff4531.

#### 2. Lógica de guards/freeze-gate.sh (RESOLVIDA = (a)+(b); PROPOSED próprio não conta; meta-deref-atestacao preservado)
Arquivo lido: guards/freeze-gate.sh

- Lógica (a) seals_proposal (readback vigente):
```72:76:guards/freeze-gate.sh
resolved_by_seal = {
    str(data.get("seals_proposal"))
    for _, data in readbacks
    if data.get("status") == "vigente" and data.get("seals_proposal") is not None
}
```

- Lógica (b) STATE (protocolo + sinais_abertos) + skip de PROPOSED:
```99:113:guards/freeze-gate.sh
def resolved_by_state(nnnn):
    nnnn_re = re.compile(rf"(?<!\d){re.escape(nnnn)}(?!\d)")
    for fragment in state_fragments:
        lowered = fragment.casefold()
        if "proposed_until_cross_audit" in lowered:
            continue
        if not nnnn_re.search(fragment):
            continue
        if (
            "selado e vigente" in lowered
            or "selada e vigente" in lowered
            or "superad" in lowered
        ):
            return True
    return False
```

- Aplicação do skip + continue (própria linha 🔴 PROPOSED não resolve a si mesma):
```128:129:guards/freeze-gate.sh
        if nnnn in resolved_by_seal or resolved_by_state(nnnn):
            continue
```

- meta-deref-atestacao e demais critérios PRESERVADOS (chamada ao assert-orq-entrada intacta, seguida da validação de checklist):
```155:164:guards/freeze-gate.sh
set +e
ORQ_ENTRADA_OUTPUT="$(cd "$REPO_ROOT" && bash "${SCRIPT_DIR}/assert-orq-entrada.sh" 2>&1)"
RC_ORQ_ENTRADA=$?
set -e
if [[ $RC_ORQ_ENTRADA -ne 0 ]]; then
    printf '%s\n' "$ORQ_ENTRADA_OUTPUT"
    echo "congelável: não — meta-deref-atestacao: atestação de entrada do orquestrador não dereferencia limpo"
    guard_fail "Gate de freeze: NÃO congelável (meta-deref-atestacao; guards/assert-orq-entrada.sh rc=${RC_ORQ_ENTRADA})."
    exit $RC_ORQ_ENTRADA
fi
```
O restante do script (validação de bloqueadores, critérios ok/na com hearback verificável, Truth Barrier) permanece inalterado.

Spec atualizada em core/freeze-gate-spec.md §2 item 6 descreve exatamente a semântica (a)+(b).

#### 3. SANITY no repo real
Checklist mínimo válido construído em /tmp/min-freeze-checklist.json (com bloqueadores_abertos=0, 1 critério não-obrigatório "ok" com evidencia).

Comando:
```
bash guards/freeze-gate.sh /tmp/min-freeze-checklist.json
```
Saída:
```
congelável: não — meta-deref-propostas: proposta(s) pendente(s) sem cross-audit/hearback
  ✗ .hbn/readbacks/0088-fix-freeze-meta-deref.json (readback_id='0088-fix-freeze-meta-deref', activation_status='PROPOSED_UNTIL_CROSS_AUDIT', status='implemented_pending_cross_audit')

[hbn-guards/freeze-gate] ✗ COMMIT BLOQUEADO
  motivo: Gate de freeze: NÃO congelável (meta-deref-propostas).
```
Resultado: SOMENTE 0088 aparece como pendente (correto). Nenhuma das 13 antigas (0064,0066,0067,0070,0072,0074,0076,0078,0080,0081,0082,0083,0086) foi listada.

#### 4. Fixtures descartáveis (lógica de RESOLVIDA)
Simulação python da lógica de resolução (mesmo algoritmo do script) sobre o disco atual:

```
=== Fixture tests (simulated on current repo state) ===
(i) 0070 (PROPOSED) + seals_proposal in vigente 0071: RESOLVED (no veto)
(ii) 0080 (PROPOSED) + SUPERAD in STATE: RESOLVED (no veto)
(ii) 0081 (PROPOSED) + SUPERAD in STATE: RESOLVED (no veto)
(iii) 0088 (PROPOSED) sem nada: VETA (pendente)
(i/ii) 0064 (PROPOSED) selado via state/protocolo: RESOLVED
(iii) ficticio 9999 sem nada: VETA (pendente)

All three cases behave as expected (i/ii no-veto, iii veto).
```

- (i) PROPOSED + seals_proposal vigente => NÃO veta
- (ii) PROPOSED + STATE 'selado e vigente' / 'SUPERAD' => NÃO veta
- (iii) PROPOSED sem marcadores => VETA

#### 5. Guards e baterias
Comando:
```
bash guards/hbn-guards-runner.sh
```
Saída final:
```
[hbn-guards] Todos os guards passaram.
```

Comando:
```
bash guards/tests/run-guard-tests.sh
```
Saída (resumo):
```
== resumo: 264 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

Comando:
```
bash guards/tests/adversarial-battery.sh
```
Saída final:
```
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```
(Inclui B81: "freeze com readback PROPOSED pendente | G-FRZ | BLOQUEADA ✓")

#### 6. Readback 0088 e escopo
Arquivo: .hbn/readbacks/0088-fix-freeze-meta-deref.json
```7:8:.hbn/readbacks/0088-fix-freeze-meta-deref.json
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
```
```2:2:.hbn/readbacks/0088-fix-freeze-meta-deref.json
  "readback_id": "0088-fix-freeze-meta-deref",
```
Status e activation corretos; escopo respeitado (stop para cross-audit, NAO selar).

Arquivos tocados no commit 6ff4531 (git show --stat):
```
 .hbn/attestations/34a7f2f9-orq-entrada.json
 .hbn/messages/20260621-113000-opus-4-8-despacho-fix-freeze-meta-deref.md
 .hbn/readbacks/0088-fix-freeze-meta-deref.json
 .hbn/relay/STATE.md
 REGISTRY.md
 core/freeze-gate-spec.md
 guards/freeze-gate.sh
 guards/tests/run-guard-tests.sh
```
Nenhum dos proibidos foi tocado:
- core/read-list-canonica.txt
- core/orchestrator-profile-spec.md
- guards/data/**
- guards/hbn-guards-runner.sh
Confirmado por git show e diff --name-only.

#### 7. Busca de burla / regressão
- Caça a colisão de NNNN: resolved_by_seal = ['0070','0072','0074','0076','0078','0082','0083','0086']
- Pendentes não-resolvidos (apenas): [('0088', '.hbn/readbacks/0088-fix-freeze-meta-deref.json')]
- Nenhuma proposta genuinamente pendente é ignorada (NNNN de uma não resolve outra por substring, graças a (?<!\d) e (?! \d) + skip proposed).
- meta-deref-atestacao: `bash guards/assert-orq-entrada.sh` → "✓ Atestacao de entrada v2 valida para bastao de orquestrador 34a7f2f9. RC=0" (sem regressão).

Nenhuma burla encontrada. Lógica fail-closed preservada (erros de leitura de STATE/readbacks vetam).

APROVA_0088: SIM
