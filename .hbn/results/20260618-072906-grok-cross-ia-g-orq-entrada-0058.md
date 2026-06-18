---
path: .hbn/results/20260618-072906-grok-cross-ia-g-orq-entrada-0058.md
id-global: 20260618-072906-grok-cross-ia-g-orq-entrada-0058
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0058: SIM"
arvore: fronteira
created_at: "2026-06-18T07:29:06-03:00"
---

SOU: grok · familia xAI · papel auditor

# CROSS-AUDIT useHBN — G-ORQ-ENTRADA v2 (W-ORQ-2 / readback 0058) · APROVA_0058 — RE-ROTEIO

**PARA:** grok (xAI) — auditor independente ≠ implementador (OpenAI). 2a familia ≠-OpenAI (antigravity/Google ja deu SIM 100).  
**MOTIVO:** o parecer anterior do grok para 0058 nao chegou ao disco (.hbn/results vazio). Re-emitir.  
**ALVO:** gate v2 entregue no commit c667bce991dcac075eb4ae36210bb360c6fedd3a, intacto no HEAD atual (97db6f9) da branch proposta/reestruturacao-m-a-s0.  
**REGRA:** Truth Barrier — arquivo:linha OU comando+saida no DISCO. READ-ONLY: sem stage/commit/main/--no-verify.

---

APROVA_0058: SIM (confiança 92/100)

APROVA_0058: SIM

---

## 1. Verificações (Truth Barrier no disco)

### 1. main == 4db692876381a0d7909985c8500d999f2e677b04
- Comando: `cd usehbn && git rev-parse main`
- Saida no disco:
  ```
  4db692876381a0d7909985c8500d999f2e677b04
  ```
- Contido em: `git branch -a --contains 4db692876381a0d7909985c8500d999f2e677b04` → main + proposta/reestruturacao-m-a-s0
- **OK.**

### 2. Escopo de c667bce = 9 paths do files_allowed do readback 0058
- `git show --stat c667bce991dcac075eb4ae36210bb360c6fedd3a`
- 9 files changed:
  1. .hbn/attestations/34a7f2f9-orq-entrada.json
  2. .hbn/messages/20260618-015800-codex-handoff-w-orq-2.md
  3. .hbn/readbacks/0058-w-orq-2.json
  4. .hbn/relay/STATE.md
  5. REGISTRY.md
  6. guards/assert-orq-entrada.sh
  7. guards/data/orq-entrada-desafios.txt (git rm)
  8. guards/tests/adversarial-battery.sh
  9. guards/tests/run-guard-tests.sh
- Comparado com `.hbn/readbacks/0058-w-orq-2.json:19-29` (files_allowed) — match exato, incluindo o rm do gabarito.
- HEAD atual 97db6f9 preserva o gate (diff c667bce..97db6f9 só atualiza atestacao posterior, guard idêntico: 398 linhas).
- **OK.**

### 3. Trailers contíguos
- `git log -1 --format=%B c667bce991dcac075eb4ae36210bb360c6fedd3a`
- Corpo final:
  ```
  W-ORQ-2 harden orq entrada

  Substitui desafio aberto por prova extrativa v2 e remove o gabarito fisico.

  HBN-Readback: 0058
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
  ```
- Contíguos no último parágrafo. **OK.**

### 4. Gabarito físico ELIMINADO
- `ls guards/data/orq-entrada-desafios.txt 2>&1` → "No such file or directory"
- `grep -n "orq-entrada-desafios" guards/assert-orq-entrada.sh` → zero matches.
- Guard v2 não referencia, não falha por ausência. **OK.**

### 5. Desafio EXTRATIVO recomputável
- Formula no disco (assert-orq-entrada.sh:291):
  ```
  seed_sha256 = sha256_text(f"orq-entrada.v2\n{readback_execution_id}\n{token_fp}\n{manifest_sha256}")
  ```
- Verificado para atestacao do commit c667bce:
  - execution_id: w-orq-2-2026-06-18
  - manifest_sha256 (entregue): 69be9960...
  - seed recomputado == seed declarado no json da atestacao. **MATCH.**
- Selecao de linha:
  ```
  challenge_hash = sha256_text(f"{seed_sha256}\n{path}\n{record['blob_oid']}")
  idx = int(challenge_hash[:8], 16) % record["nonempty_lines"]
  ```
- Depois: line_no/line_text/line_sha256 devem bater exatamente (linhas 341-346).
- Campos obrigatorios: STATE (readback_ativo + proxima_acao), readback_ativo, core/orchestrator-profile-spec.md.
- Mudar qualquer um (seed, manifest, blob, linha, sha) → BLOCK pelos testes.
- **OK. Mecanismo deterministico e sensivel a mudanca.**

### 6. Reprodução de testes
- `bash guards/tests/run-guard-tests.sh` → `== resumo: 202 passaram, 0 falharam ==` (exit 0). Inclui 7 casos G-ORQ-ENTRADA v2 (sem gabarito, linha errada, sha errado, seed velho, field ausente, read-list mudado, ausencia atest).
- `bash guards/tests/adversarial-battery.sh` → `BATERIA VERDE`
  - B45 linha extrativa forjada | G-ORQ | BLOQUEADA ✓
  - B46 reuso seed de manifest antigo | G-ORQ | BLOQUEADA ✓
  - B47 tentativa sem ler linhas | G-ORQ | BLOQUEADA ✓
- Evidencia no terminal output + saida no disco. **OK.**

### 7. JUIZO: o v2 fecha o "teatro de leitura" do PISO? Resta fresta?
**Parecer:** SIM, o v2 **fecha o teatro de leitura do PISO**.

- Antes (v1 + gabarito fisico): respostas estaticas/regex D1-D4 podiam ser "teatradas" sem ler o canon (gabarito permitia lookup ou memorizacao estatica).
- Agora: prova extrativa sobre manifest dos 13 itens da read-list canonica + seed = f(execution_id, fp, manifest) + 3 linhas sorteadas dinamicamente dos blobs reais (staged/HEAD) + 2 fields do STATE.
- Guard recomputa tudo do indice git (`git show :path` ou HEAD:). Qualquer diferenca de conteudo ou versao muda o sorteio e falha o match.
- Bateria adversarial especifica para forja/reuso/sem-leitura bloqueada.
- Nenhuma dependencia de arquivo removido (gabarito).

**Resta fresta?** Fresta minima/negligenciavel para o escopo deste gate:
- Atestacao e conteudo dos read-list items devem estar presentes no indice no momento do gate (dogfood no proprio commit). Isso e intencional e fail-closed.
- O bastao muda de readback → nova atestacao v2 e necessaria (ja observado em atualizacoes posteriores 0059).
- Integracao com G-EXC/G-TRAILERS/G-DIVERSITY/G-AUDITOR-ID ja cobre o envelope de governanca.
- Sem fresta mecânica no "teatro de leitura" que o W-ORQ-2 se propoe a fechar.

Confianca alta porque: 1) verificacao literal de codigo+testes+commits no disco; 2) reproducao dos comandos; 3) antigravity/Google ja aprovou 100/100 no mesmo alvo; 4) gate intacto no HEAD da branch.

---

## Entrega REGISTRY 7-col (arvore=fronteira)

REGISTRY: | 20260618-072906-grok-cross-ia-g-orq-entrada-0058 | .hbn/results/20260618-072906-grok-cross-ia-g-orq-entrada-0058.md | audit-result | frio | fronteira | — | 2026-06-18T07:29:06-03:00 |

---

**Evidencias mecanicas (arquivo:linha ou cmd+saida):**
- git rev-parse main
- git show --stat c667bce...
- git log -1 --format=%B c667bce
- ls guards/data/orq-entrada-desafios.txt
- grep no guard
- python recompute seed match
- bash .../run-guard-tests.sh (202/0)
- bash .../adversarial-battery.sh (B45-B47 BLOQUEADAS)
- git diff c667bce..97db6f9 -- guards/assert-orq-entrada.sh (identical)

**APROVA_0058: SIM**

Fim do parecer cross-audit grok/xAI para 0058 (re-roteio).