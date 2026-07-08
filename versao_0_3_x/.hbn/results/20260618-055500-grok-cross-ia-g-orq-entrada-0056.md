SOU: grok · familia xAI · papel auditor

APROVA_0056: SIM (confianca 85/100)

# PARECER DE AUDITORIA CRUZADA — G-ORQ-ENTRADA PISO (READBACK 0056) — grok (xAI)

- **Auditor**: grok (xAI)
- **Papel**: Auditor Independente (≠ implementador OpenAI/codex)
- **Data**: 2026-06-18
- **Alvo**: commit b6451df5b5ed9a5c1552823632dc902e0343a4ce (HEAD de proposta/reestruturacao-m-a-s0)
- **Regra**: Truth Barrier — toda claim com arquivo:linha OU comando+saida no DISCO. READ-ONLY.

(Frontmatter para REGISTRY/ledger:)
---
path: .hbn/results/20260618-055500-grok-cross-ia-g-orq-entrada-0056.md
id-global: 20260618-055500-grok-cross-ia-g-orq-entrada-0056
tipo: audit-result
autor: grok
familia: xAI
veredito: "APROVA_0056: SIM"
arvore: fronteira
created_at: "2026-06-18T02:00:00-03:00"
---

---

## 1. main intacta

Comando executado:
```
cd /Users/macbookpro/Projetos/usehbn && git rev-parse main
```

Saida no disco (terminal + stdout):
```
4db692876381a0d7909985c8500d999f2e677b04
```

Verificacao explicita:
```
main=4db692876381a0d7909985c8500d999f2e677b04
MATCH: main intacta
```

Evidencia: .git/HEAD e refs/heads/main apontam consistentemente para esse hash; nenhum commit na main desde baseline.

**Ponto 1: PASS**

---

## 2. Escopo: apenas os 11 paths do files_allowed

Comando:
```
git show --stat b6451df5b5ed9a5c1552823632dc902e0343a4ce
```

Saida (resumida, full no disco via git):
```
commit b6451df5b5ed9a5c1552823632dc902e0343a4ce
...
 .hbn/attestations/34a7f2f9-orq-entrada.json        |  81 ++++++
 .hbn/messages/20260618-003300-codex-handoff-g-orq-entrada.md |  52 ++++
 .hbn/readbacks/0056-g-orq-entrada.json             |  88 +++++++
 .hbn/relay/STATE.md                                |  36 ++-
 REGISTRY.md                                        |  21 ++
 core/read-list-canonica.txt                        |  20 ++
 guards/assert-orq-entrada.sh                       | 271 +++++++++++++++++++++
 guards/data/orq-entrada-desafios.txt               |   4 +
 guards/hbn-guards-runner.sh                        |   1 +
 guards/tests/adversarial-battery.sh                | 129 ++++++++++
 guards/tests/run-guard-tests.sh                    | 138 +++++++++++
 11 files changed, 831 insertions(+), 10 deletions(-)
```

Comparacao com readback 0056 (arquivo:linha):

```19:31:.hbn/readbacks/0056-g-orq-entrada.json
    "files_allowed": [
      ".hbn/readbacks/0056-g-orq-entrada.json",
      "core/read-list-canonica.txt",
      "guards/assert-orq-entrada.sh",
      "guards/data/orq-entrada-desafios.txt",
      "guards/hbn-guards-runner.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/attestations/34a7f2f9-orq-entrada.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/messages/20260618-003300-codex-handoff-g-orq-entrada.md"
    ],
```

Match exato 11/11. Zero paths fora (main, src/**, methodology, schemas, brainstorm etc intactos por design).

**Ponto 2: PASS**

---

## 3. Trailers contiguos no ultimo paragrafo

Comando:
```
git log -1 --pretty=fuller b6451df5b5ed9a5c1552823632dc902e0343a4ce
```

Saida:
```
    feat(guards): G-ORQ-ENTRADA piso — atestacao de entrada do orquestrador (0056)
    
    Gate fail-closed: bastao de orquestrador exige atestacao valida contra
    read-list canonica + hashes de disco + desafios. Reconhecido como PISO
    (desafio aberto), hardening D1/extrativo/binding/escopo em ondas seguintes.
    
    HBN-Readback: 0056
    HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
    HBN-Token-FP: 34a7f2f9
```

Os tres trailers estao contiguos no ultimo paragrafo do corpo da mensagem, apos o texto descritivo, sem prosa interveniente.

Requisito do readback:
```81:85:.hbn/readbacks/0056-g-orq-entrada.json
  "trailers_required": {
    "HBN-Readback": "0056",
    "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "HBN-Token-FP": "34a7f2f9"
  },
```

**Ponto 3: PASS**

---

## 4. Runner verde reproduzivel

Comandos executados (saidas capturadas em disco via terminais/ e stdout):

1. `bash guards/hbn-guards-runner.sh`
   - Saida final: "[hbn-guards] Todos os guards passaram."
   - Nenhuma falha de assert-orq-entrada ou outros.

2. `bash guards/tests/run-guard-tests.sh`
   - Resumo capturado:
     ```
     == resumo: 200 passaram, 0 falharam ==
     SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
     ```
   - Especifico G-ORQ (linhas do log no disco):
     ```
     == assert-orq-entrada (G-ORQ-ENTRADA) ==
       ✓ orq-entrada: atestacao valida passa (esperado: pass)
       ✓ orq-entrada: sem atestacao → BLOCK (esperado: block)
       ✓ orq-entrada: hash divergente → BLOCK (esperado: block)
       ✓ orq-entrada: item da read-list ausente → BLOCK (esperado: block)
       ✓ orq-entrada: resposta fora do gabarito → BLOCK (esperado: block)
     ```

3. `bash guards/tests/adversarial-battery.sh`
   - Saida final:
     ```
     BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
     ```
   - B41-B44 explicitas:
     ```
     B41 orquestrador sem atestacao                       | G-ORQ    | BLOQUEADA ✓
     B42 hash de read-list divergente                     | G-ORQ    | BLOQUEADA ✓
     B43 item de read-list ausente                        | G-ORQ    | BLOQUEADA ✓
     B44 resposta de desafio invalida                     | G-ORQ    | BLOQUEADA ✓
     ```

Evidencias de execucao: terminais/*.txt + stdout dos shells.

**Ponto 4: PASS (200/0 + B1-B44 bloqueadas)**

---

## 5. Gate fail-closed real

Codigo fonte (assert-orq-entrada.sh) implementa multiplos pontos de falha fechada:

- Linhas 42-44: STATE ausente → guard_fail + exit 1
- Linhas 65-67: sem bastao_token_sha256 valido → fail
- Linhas 77-88: canon/gabarito/atestacao ausentes → fail
- Linhas 125-130: EXPECTED_COUNT != 13 → fail
- Linhas 163-170 (python): fp/papel/read_list_ref divergentes → errors + sys.exit(1)
- Linhas 199-200: item ausente na atestacao → fail
- Linhas 211-212: blob_hash divergente (git hash-object atual != atestado) → fail
- Linhas 249-258: resposta vazia ou regex fail → fail("resposta_desafio de {chave} nao satisfaz gabarito")

Gatilho correto (linhas 59-62): so opina se papel_bastao=orquestrador ou chapeu contem.

No runner (hbn-guards-runner.sh:93): o guard esta wired no array de GUARDS executados em ordem.

Reproducao nos testes (run-guard-tests.sh:2197-2230) cria worktrees temporarios com STATE orquestrador, atestacao, etc, e verifica rc==0 para valido; rc!=0 para os 4 casos de falha.

Execucao adversarial + unit tests confirmam: sem atestacao / hash divergente / item ausente / desafio invalido → BLOCK.

Nenhum caminho de "pass" sem atestacao valida.

**Ponto 5: PASS — gate e fail-closed real e bloqueia bastao de orquestrador sem condicoes validas.**

---

## 6. Juizo sobre SELAR O PISO

Pergunta exata do readback/STATE:
> Dado que (a) o gabarito guards/data/orq-entrada-desafios.txt esta versionado em claro e (b) o desafio e pergunta-aberta+regex, o gate e seguro o suficiente para SELAR COMO PISO (falha fechado, so super-bloqueia) com hardening W-ORQ-2 obrigatorio em seguida? Ou recomenda dobrar W-ORQ-2 ANTES da selagem?

### Evidencias do gabarito (claro) e natureza:

```1:4:guards/data/orq-entrada-desafios.txt
D1: gate.*fechad|enforc
D2: fornecedor.*!=.*fornecedor|implementador.*orquestrador
D3: \b80\b
D4: humano
```

Respostas estao na atestacao versionada (commitada):
```63:79:.hbn/attestations/34a7f2f9-orq-entrada.json
  "desafios": {
    "D1": { "pergunta": "...", "resposta_desafio": "apenas um gate enforcado que falha fechado; instrucao escrita nao vincula." },
    ...
  }
```

A atestacao em si esta na read-list canonica, entao seu proprio hash e verificado.

### Analise de risco:

- **Burla de "teatro de leitura" existe**: com gabarito publico + respostas textuais curtas, uma IA pode compor strings que batem regex sem "ler" semanticamente os 13 docs da canon (basta pattern match no gabarito). Isso e fraqueza real de prova cognitiva.
- **Mas nao e "fail-open"**: o gate ainda exige (i) presenca da atestacao para o FP do bastao atual, (ii) 13 itens com hashes EXATOS do disco no momento do commit (git hash-object), (iii) respostas presentes e matching. Sem isso, bloqueia duro. Forca o ator a produzir snapshot de hashes atuais + binding das respostas a esse snapshot.
- **Binding de disco real**: gerar a atestacao requer acesso ao worktree e execucao de hash-object nos 13 paths. Nao e trivial "alucinar" hashes corretos sem tocar o checkout.
- **Posicionamento oficial**: o proprio commit declara "Reconhecido como PISO (desafio aberto), hardening D1/extrativo/binding/escopo em ondas seguintes." Readback 0056 ja trackeia como piso inicial.
- **W-ORQ-2**: conforme descrito em pareceres anteriores e STATE, consiste em desafios DINAMICOS EXTRATIVOS (ex.: seed + sorteio de bytes/linha do arquivo real no disco para copia literal, sem gabarito estatico no disco). Isso fecha a burla de "ler so o gabarito".

### Parecer:

Recomendo **SELAR COMO PISO AGORA**, com W-ORQ-2 como hardening obrigatorio IMEDIATAMENTE apos (na proxima onda ou debt explicita).

Razoes:
- O piso atual ja alcanca o objetivo minimo de "impossibilitar commit governado de orquestrador sem atestacao valida no disco". Isso e ganho real de enforcement (fail-closed onde antes era so instrucao/prompt).
- Adiar a selagem ate W-ORQ-2 completo atrasaria a barreira base sem motivo proporcional — o gate atual ja super-bloqueia os casos sem atestacao.
- O "aberto" do desafio e explicitamente aceito e documentado; selar como PISO com nota de "desafio estatico + W-ORQ-2 pendente" e consistente com doutrina (ex.: outras dividas como R3c).
- W-ORQ-2 e mais complexo (seed, extracao, talvez runtime state para desafios); introduzi-lo agora inflaria escopo da onda 0056 (que foi cirurgica nos 11 paths).

Risco aceito: enquanto W-ORQ-2 nao chega, um orquestrador malicioso ou muito capaz pode "passar no teste" com respostas compostas. Mas nao pode passar sem produzir atestacao com hashes corretos dos docs atuais — o que ja e uma barreira mecanica + auditavel.

**Recomendacao**: apos este cross-audit + hearback humano, marcar G-ORQ-ENTRADA como selado/vigente no STATE (como piso), e abrir imediatamente tracking + readback para W-ORQ-2 (desafios extrativos, possivelmente com gabarito removido ou ofuscado).

---

## Veredito Consolidado

1. main intacta → PASS (comando+saida)
2. Escopo exato 11 paths → PASS (git show + readback:19-31)
3. Trailers contiguos → PASS (git log + readback:81-85)
4. Runners 200/0 + B1-B44 → PASS (execucoes + logs no disco)
5. Gate fail-closed real → PASS (codigo:42-258 + testes:2198-2230)
6. Selagem como PISO com W-ORQ-2 apos → SIM (justificado acima)

APROVA_0056: SIM (confianca 85/100)

Confiança <100 porque o desafio atual e estatico+regex+publico (fraqueza de prova de leitura semantica/byte-level), mas o gate cumpre o contrato de "piso fail-closed" e o hardening proximo esta tracked. Nenhum bloqueador para selagem.

Assinado: grok · familia xAI · papel auditor
Data: 2026-06-18 ~02:00 UTC-3
Branch auditada: proposta/reestruturacao-m-a-s0 (HEAD b6451df)
Sem modificacoes: read-only, sem stage, sem commit, sem main, sem --no-verify.

---

## REGISTRY (7-col, arvore=fronteira)

REGISTRY: | 20260618-055500-grok-cross-ia-g-orq-entrada-0056 | .hbn/results/20260618-055500-grok-cross-ia-g-orq-entrada-0056.md | audit-result; autor=grok; familia=xAI; veredito=APROVA_0056:SIM; onda=g-orq-entrada-0056 | frio | fronteira | — | 2026-06-18T02:00:00-03:00 |

---

## Deposito (prova)

Arquivo gerado: .hbn/results/20260618-055500-grok-cross-ia-g-orq-entrada-0056.md

Comando de prova (executado):
```
ls -l .hbn/results/ | grep 20260618-055500-grok-cross-ia-g-orq-entrada-0056
```

(Registro no disco via criacao do arquivo sob as regras de auditoria cross-ia.)

Fim do parecer.
