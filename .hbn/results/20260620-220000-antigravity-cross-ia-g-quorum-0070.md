---
path: .hbn/results/20260620-220000-antigravity-cross-ia-g-quorum-0070.md
id-global: 20260620-220000-antigravity-cross-ia-g-quorum-0070
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0070: SIM"
arvore: fronteira
created_at: "2026-06-20T22:00:00-03:00"
---

SOU: antigravity · familia Google · papel auditor

### Verificações Realizadas

1. **Integridade da Branch main**:
   - Comando executado: `git rev-parse main`
   - Saída obtida: `4db692876381a0d7909985c8500d999f2e677b04` (INTOCADA).

2. **Análise de `guards/assert-quorum-selagem.sh`**:
   - **Gatilho**: O guard monitora adições de readbacks vigentes na função `added_readbacks` (linhas 32-38), que filtra por `diff-filter=A` e arquivos no diretório `.hbn/readbacks/`. No bloco Python, ele verifica se o status é `"vigente"` (linhas 198-200).
   - **Exigência de seals_proposal**: Validada no bloco Python (linhas 202-205), assegurando que `seals_proposal` seja uma string correspondente a exatamente 4 dígitos (`^[0-9]{4}$`).
   - **Coleta de pareceres**: Realizada na função `list_results` (linhas 51-60), listando todos os arquivos `.md` na pasta `.hbn/results/` contidos no índice/HEAD, e filtrando-os na lógica Python pelo sufixo `-{proposal}.md` (linhas 227-236).
   - **Família no mapa**: O mapa canônico de famílias é definido pelo path `guards/data/auditor-families.txt` (linha 25), lido por `parse_map` (linha 211) e validado contra cada autor/família dos pareceres (linhas 259-268). A família "OpenAI" é explicitamente desconsiderada para fins de quórum de aprovação (linhas 271-272).
   - **Contagem de famílias distintas / Bloqueio se < 2**: Lógica validada em Python (linhas 274-280), onde se exige `len(families_with_sim) >= 2`.
   - **Fail-closed**: Em caso de falha do script Python (saída != 0), o runner aciona a falha (linhas 282-285) e propaga o erro pelo shell (linhas 296-298) interrompendo a transição.

3. **Validação no Runner (`guards/hbn-guards-runner.sh`)**:
   - Comando executado: `grep -n assert-quorum-selagem guards/hbn-guards-runner.sh`
   - Saída obtida: `102:    "assert-quorum-selagem.sh"` (está ativo no runner).

4. **Execução do Runner**:
   - Comando executado: `bash guards/hbn-guards-runner.sh`
   - Saída obtida: `[hbn-guards] Todos os guards passaram.`

5. **Execução dos Testes Rápidos**:
   - Comando executado: `bash guards/tests/run-guard-tests.sh`
   - Saída obtida: `BATERIA VERDE: 39 test(s) passed, 0 failed.` (com todos os 9 sub-casos de teste para quorum passando com sucesso).

6. **Execução da Bateria Adversarial**:
   - Comando executado: `bash guards/tests/adversarial-battery.sh`
   - Saída obtida: `BATERIA VERDE: 78 caso(s) executado(s), 0 falha(s).`
   - Casos confirmados (B71 a B78):
     - `B71`: quorum-selagem: readback vigente com seals_proposal e quorum >=2 != OpenAI... OK (passou)
     - `B72`: quorum-selagem: readback vigente sem seals_proposal... OK (bloqueado)
     - `B73`: quorum-selagem: readback vigente com apenas 1 parecer != OpenAI... OK (bloqueado)
     - `B74`: quorum-selagem: readback vigente com pareceres da mesma família... OK (bloqueado)
     - `B75`: quorum-selagem: readback vigente com parecer OpenAI não contando para o quorum... OK (bloqueado)
     - `B76`: quorum-selagem: readback vigente com parecer sem APROVA_NNNN: SIM... OK (bloqueado)
     - `B77`: quorum-selagem: readback vigente apontando para si mesma como seals_proposal... OK (bloqueado)
     - `B78`: quorum-selagem: readback vigente com mapa de famílias corrompido ou ausente... OK (bloqueado)

7. **Validação do Readback `0070-w-quorum-g-quorum.json`**:
   - `status`: `"implemented_pending_cross_audit"` (linha 7)
   - `activation_status`: `"PROPOSED_UNTIL_CROSS_AUDIT"` (linha 8)
   - `track`: `"safe_track"` (linha 6)
   - Escopo `files_allowed` respeitado: Todos os arquivos alterados no commit `18d46e5` estão listados no escopo (linhas 21-31).
   - O diretório `guards/data/**` não foi modificado.

8. **Investigação de Burlas**:
   - Nenhuma burla ou bypass identificada. A validação é rigorosamente forward-only e fail-closed, sem riscos de reavaliação de selagens passadas ou drifts indesejados.

APROVA_0070: SIM
