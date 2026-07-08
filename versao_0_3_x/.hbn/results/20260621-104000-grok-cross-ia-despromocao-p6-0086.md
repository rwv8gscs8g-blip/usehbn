---
path: .hbn/results/20260621-104000-grok-cross-ia-despromocao-p6-0086.md
id-global: 20260621-104000-grok-cross-ia-despromocao-p6-0086
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0086: SIM"
arvore: fronteira
created_at: "2026-06-21T10:40:00-03:00"
status: congelado
temperatura: glacier
---

SOU: grok · familia xAI · papel auditor

VERIFICACOES OBRIGATORIAS (comando+saida + arquivo:linha):

1. git rev-parse main (INTocada):
$ cd /Users/macbookpro/Projetos/usehbn && git rev-parse main
4db692876381a0d7909985c8500d999f2e677b04
Branch atual: proposta/reestruturacao-m-a-s0
HEAD do branch: 4cd6bf8 guards: gate arvore despromocao
(confirmado via git rev-parse --abbrev-ref HEAD e git log -1)
main permanece exatamente no hash especificado; nenhuma alteracao em main.

2. guards/assert-arvore-label.sh (linhas chave da logica estendida):
```104:111:guards/assert-arvore-label.sh
arvore_rank() {
    case "$1" in
        fronteira) echo 0 ;;
        intermediaria) echo 1 ;;
        estavel) echo 2 ;;
        *) return 1 ;;
    esac
}
```
Ordem canonica: fronteira(0) < intermediaria(1) < estavel(2) — conforme exigido.

```113:129:guards/assert-arvore-label.sh
previous_arvore_for_path() {
    local wanted_path="$1" prior="" base_line cols base_path base_arvore
    while IFS= read -r base_line; do
        [[ -z "$base_line" ]] && continue
        cols="$(registry_col_count "$base_line")"
        if [[ "$cols" -lt 7 ]]; then
            continue
        fi
        base_path="$(registry_col "$base_line" 2)"
        [[ "$base_path" == "$wanted_path" ]] || continue
        base_arvore="$(registry_col "$base_line" 5)"
        if valid_arvore "$base_arvore"; then
            prior="$base_arvore"
        fi
    done < <(git show "$(base_blob_ref "$REGISTRY_REPO_PATH")")
    printf '%s\n' "$prior"
}
```
Lookup da arvore anterior: le do blob BASE (HEAD: ou HBN_DIFF_BASE:), ignora linhas com <7 colunas (legadas 5/6-col ignoradas como historico), ultima ocorrencia do path vence.

```172:182:guards/assert-arvore-label.sh
    arvore_anterior="$(previous_arvore_for_path "$path_col")"
    if [[ -n "$arvore_anterior" ]]; then
        rank_novo="$(arvore_rank "$arvore")"
        rank_anterior="$(arvore_rank "$arvore_anterior")"
        if [[ "$rank_novo" -lt "$rank_anterior" ]]; then
            if [[ "$tipo" != "arvore-despromocao" ]] || ! readback_ref_exists "$line"; then
                guard_fail "despromocao de '${path_col}' de ${arvore_anterior} para ${arvore} sem evento tipo=arvore-despromocao + readback"
                FAIL=1
            fi
            continue
        fi
    fi
```
Exigencia para despromocao (A_nova < A_anterior): tipo=arvore-despromocao + readback versionado existente no blob. Senao: fail + continue (nao cai na checagem de promocao).

```167:170:guards/assert-arvore-label.sh
    if [[ "$arvore" == "estavel" && "$temperatura" != "quente" ]]; then
        guard_fail "Linha nova do ${REGISTRY} viola invariante estavel=>quente: '${path_col}' tem temperatura='${temperatura}'."
        FAIL=1
    fi
```
Invariante estavel=>quente preservada.

```185:195:guards/assert-arvore-label.sh
    if [[ "$arvore" == "intermediaria" || "$arvore" == "estavel" ]]; then
        if [[ "$tipo" != "arvore-promocao" ]]; then
            guard_fail "Linha nova do ${REGISTRY} rotula '${path_col}' como '${arvore}' sem evento tipo=arvore-promocao. Artefato nasce fronteira; intermediaria/estavel so por promocao append-only."
            FAIL=1
            continue
        fi
        if ! readback_ref_exists "$line"; then
            guard_fail "Evento arvore-promocao para '${path_col}' sem referencia a readback versionado em .hbn/readbacks/NNNN-*.json."
            FAIL=1
        fi
    fi
```
Logica de PROMOCAO (e nascer fronteira) totalmente preservada — nenhuma regressao introduzida pela extensao de despromocao.

3. ATAQUE em fixture descartavel (temp git repo, sem tocar repo real/versionado):
Comandos executados (resumido; fixture em /var/folders/.../tmp... ):
- seed repo + linha previa estavel (ou intermediaria)
- append linha de rebaixamento
- invocar bash guards/assert-arvore-label.sh ; capturar rc (1=bloqueia)

Saida real:
OK: BLOCK estavel->fronteira sem evento (rc=1)
OK: BLOCK inter->fronteira sem evento (rc=1)
OK: BLOCK despromocao sem readback (rc=1)
OK: PASS despromocao COM tipo+readback (rc=0)
OK: PASS nascer fronteira (sem anterior) (rc=0)
OK: PASS promocao com tipo+readback (rc=0)

Exemplo de bloqueio capturado:
[hbn-guards/assert-arvore-label] ✗ COMMIT BLOQUEADO
  motivo: despromocao de 'docs/x.md' de estavel para fronteira sem evento tipo=arvore-despromocao + readback

Todos os 3 casos de bloqueio exigidos e 3 de passagem passaram conforme especificado. Nenhuma regressao em promocao.

4. Execucao dos runners (saida citada):
$ bash guards/hbn-guards-runner.sh
...
[hbn-guards] Todos os guards passaram.
(observacao: sinal de EXCECAO F-01 rastreavel para 0086 PROPOSED_UNTIL_CROSS_AUDIT — esperado e correto)

$ bash guards/tests/run-guard-tests.sh
...
== resumo: 262 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
(Inclui os +5 checks novos de Despromocao-P6 em G-ARVORE-LABEL: 2 pass + 3 block)

$ bash guards/tests/adversarial-battery.sh
...
B88 despromocao estavel->fronteira sem evento        | G-ARVORE | BLOQUEADA ✓
B89 despromocao intermediaria->fronteira sem evento  | G-ARVORE | BLOQUEADA ✓
B90 despromocao sem readback versionado              | G-ARVORE | BLOQUEADA ✓
...
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
(B88+ atingido; bateria completa sem FALHAS)

5. Readback 0086 (.hbn/readbacks/0086-despromocao-p6.json):
```7:8:.hbn/readbacks/0086-despromocao-p6.json
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
```
```20:32:.hbn/readbacks/0086-despromocao-p6.json
  "scope": {
    "files_allowed": [
      "guards/assert-arvore-label.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/messages/20260621-100000-opus-4-8-despacho-despromocao-p6.md",
      ".hbn/readbacks/0086-despromocao-p6.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main", "core/**", "methodology/**", "schemas/**", "src/**", "docs/brainstorm/**", ".hbn/freeze/**", "guards/data/**", "guards/hbn-guards-runner.sh"]
  },
```
Status/activation: implemented_pending_cross_audit + PROPOSED_UNTIL_CROSS_AUDIT — escopo respeitado.
files_forbidden incluem exatamente: guards/data/** , guards/hbn-guards-runner.sh , core/read-list-canonica (via contexto), orchestrator-profile-spec.
Commit 4cd6bf8 tocou SOMENTE arquivos permitidos:
$ git show 4cd6bf8 --name-only
.hbn/attestations/34a7f2f9-orq-entrada.json
.hbn/messages/20260621-100000-opus-4-8-despacho-despromocao-p6.md
.hbn/readbacks/0086-despromocao-p6.json
.hbn/relay/STATE.md
REGISTRY.md
guards/assert-arvore-label.sh
guards/tests/adversarial-battery.sh
guards/tests/run-guard-tests.sh
(read-list, guards/data, orchestrator-profile-spec, runner: NAO tocados — conforme proibido.)

6. Caca a burlas / regressao / falso-verde:
- Testes de fixture descartavel + bateria adversarial (B88-B90) cobrem explicitamente: rebaixamento sem evento, desprom sem readback.
- Nenhuma passagem de demote sem tipo+readback.
- Nenhuma regressao: promocao com arvore-promocao+readback continua bloqueando quando ausente e passando quando presente (testes + fixture manual).
- Linhas legadas (<7 col): sao ignoradas pelo guard (continue antes de extrair arvore); nao permitem rebaixamento efetivo de arvore (ausencia de coluna 5 impede atualizacao do label "anterior"). Nao constitui bypass para a semantica de arvore 7-col.
- Multiplas linhas mesmo path no commit: cada linha added e checada vs base anterior independentemente; linha ruim (sem evento) falha individualmente.
- Normalizacao de colunas: trim em registry_col; contagem NF-2 consistente com formato real de 7 dados (8 pipes) — validado em execucao.
- Nao encontrado falso-verde, bypass por env, por diff skew ou outro. Nenhuma alteracao no runner ou dados de guard que pudesse enfraquecer.
- Veredito: sem achados de regressao ou burla. APROVA.

O guard selado foi estendido corretamente, com simetria despromocao, preservacao de promocao e invariantes, testes suficientes e sem contorno detectado.

APROVA_0086: SIM
