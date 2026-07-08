---
path: .hbn/results/20260618-023926-antigravity-cross-ia-g-orq-entrada-0058.md
id-global: 20260618-023926-antigravity-cross-ia-g-orq-entrada-0058
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0058: SIM"
arvore: fronteira
created_at: "2026-06-18T02:39:26-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

APROVA_0058: SIM

# PARECER DE AUDITORIA CRUZADA — W-ORQ-2 / G-ORQ-ENTRADA v2 (READBACK 0058)

- **Auditor**: antigravity (Família Google)
- **Papel**: Auditor Independente
- **Data/Hora**: 2026-06-18T02:39:26-03:00
- **Fase**: W-ORQ-2 / G-ORQ-ENTRADA v2 (Readback 0058)
- **Branch**: `proposta/reestruturacao-m-a-s0`
- **HEAD Auditado**: `c667bce991dcac075eb4ae36210bb360c6fedd3a`

---

## 1. Verificação de Invariantes e Requisitos de Auditoria

### 1.1. `main` Intacta
- **Evidência no disco:** Executamos `git rev-parse main` e obtivemos a seguinte saída:
  ```
  4db692876381a0d7909985c8500d999f2e677b04
  ```
  Isso valida perfeitamente que o HEAD de `main` permaneceu intacto e intocado. (Confirmado em [git status](file:///Users/macbookpro/Projetos/usehbn) / [git rev-parse main](file:///Users/macbookpro/Projetos/usehbn)).

### 1.2. Escopo de Arquivos Modificados
- **Evidência no disco:** Executamos `git show --stat c667bce` para listar os arquivos modificados/adicionados no commit alvo:
  1. `.hbn/attestations/34a7f2f9-orq-entrada.json`
  2. `.hbn/messages/20260618-015800-codex-handoff-w-orq-2.md`
  3. `.hbn/readbacks/0058-w-orq-2.json`
  4. `.hbn/relay/STATE.md`
  5. `REGISTRY.md`
  6. `guards/assert-orq-entrada.sh`
  7. `guards/data/orq-entrada-desafios.txt` (removed)
  8. `guards/tests/adversarial-battery.sh`
  9. `guards/tests/run-guard-tests.sh`
- **Validação:** A lista de modificações de `c667bce` toca exclusivamente os 9 caminhos autorizados em `scope.files_allowed` de `.hbn/readbacks/0058-w-orq-2.json` (linhas 19-29). Nada além foi modificado.

### 1.3. Trailers Contíguos
- **Evidência no disco:** Executamos `git log -1 --format=%B c667bce` para obter a mensagem do commit:
  ```
  W-ORQ-2 harden orq entrada
  
  Substitui desafio aberto por prova extrativa v2 e remove o gabarito fisico.
  
  HBN-Readback: 0058
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
  ```
- **Validação:** Os trailers obrigatórios estão presentes de forma contígua no último parágrafo do commit.

### 1.4. Gabarito Físico Eliminado
- **Evidência no disco:** Executamos `ls -la guards/data/` e confirmamos que `guards/data/orq-entrada-desafios.txt` foi excluído física e logicamente do índice e da árvore de trabalho. O guard não depende nem falha pela ausência do gabarito antigo (as rotinas antigas de regexes `D1-D4` foram removidas do script principal).

### 1.5. Suíte de Testes e Bateria Adversarial Verde
Executamos as suítes de teste e verificamos que tudo passou com sucesso na branch sob auditoria:
- **`bash guards/tests/run-guard-tests.sh`**: Finalizou reportando `== resumo: 202 passaram, 0 falharam ==` com exit code `0`. As novas coberturas de `G-ORQ-ENTRADA` incluem os 7 testes:
  - `orq-entrada: atestacao v2 valida sem gabarito.txt passa`
  - `orq-entrada: sem atestacao → BLOCK`
  - `orq-entrada: linha extrativa errada → BLOCK`
  - `orq-entrada: line_sha256 errado → BLOCK`
  - `orq-entrada: seed de manifest velho → BLOCK`
  - `orq-entrada: field ausente → BLOCK`
  - `orq-entrada: arquivo da read-list mudado → BLOCK`
- **`bash guards/tests/adversarial-battery.sh`**: Finalizou com `BATERIA VERDE — toda burla documentada foi BLOQUEADA` e exit code `0`. Os novos testes adversariais `B41-B47` que cobrem o hardening `W-ORQ-2` foram totalmente bloqueados:
  - `B41 orquestrador sem atestacao | G-ORQ | BLOQUEADA ✓`
  - `B42 arquivo da read-list alterado | G-ORQ | BLOQUEADA ✓`
  - `B43 line_sha256 errado | G-ORQ | BLOQUEADA ✓`
  - `B44 field_response ausente | G-ORQ | BLOQUEADA ✓`
  - `B45 linha extrativa forjada | G-ORQ | BLOQUEADA ✓`
  - `B46 reuso seed de manifest antigo | G-ORQ | BLOQUEADA ✓`
  - `B47 tentativa sem ler linhas | G-ORQ | BLOQUEADA ✓`

---

## 2. Análise Técnica do Desafio Extrativo (`assert-orq-entrada.sh`)

O arquivo [assert-orq-entrada.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-orq-entrada.sh) implementa a validação da prova extrativa v2. Os principais componentes de segurança atestados são:

1. **Recomputabilidade e Coerência da Semente (Seed):**
   A semente dinâmica da prova é calculada como:
   `seed_sha256 = sha256("orq-entrada.v2\n" + readback_execution_id + "\n" + token_fp + "\n" + manifest_sha256)`
   (Implementado em [assert-orq-entrada.sh:291](file:///Users/macbookpro/Projetos/usehbn/guards/assert-orq-entrada.sh#L291)).
   Como o `manifest_sha256` cobre deterministicamente a lista ordenada de hashes dos 13 arquivos listados no `core/read-list-canonica.txt`, qualquer variação de conteúdo/versão nos arquivos de spec, relay ou knowledge altera a semente, mudando as linhas sorteadas.

2. **Cálculo de Linhas Extrativas (Indexação Dinâmica):**
   Para cada um dos 3 arquivos chaves (`STATE.md`, readback ativo e `core/orchestrator-profile-spec.md`), a linha a extrair é calculada deterministicamente via:
   `challenge_hash = sha256(seed_sha256 + "\n" + path + "\n" + blob_oid)`
   `idx = int(challenge_hash[:8], 16) % record["nonempty_lines"]`
   (Implementado em [assert-orq-entrada.sh:337-339](file:///Users/macbookpro/Projetos/usehbn/guards/assert-orq-entrada.sh#L337-L339)).
   O uso de `blob_oid` (do staged ou HEAD) liga a validação diretamente ao índice Git, impedindo que o orquestrador forneça respostas com base em versões diferentes das efetivamente enviadas para o commit.

3. **Verificação de Respostas da Prova:**
   O guard valida individualmente se `line_no`, `line_text` e `line_sha256` fornecidos pelo orquestrador casam perfeitamente com a linha calculada do arquivo real (linhas 341-346). Mudar qualquer caractere, linha ou SHA-256 resulta em bloqueio instantâneo do commit (fail-closed).

---

## 3. Juízo: Frestas Antigas e Teatro de Leitura do Piso

### Pergunta de Design:
> O gate v2 fecha o "teatro de leitura" do PISO? Resta fresta?

### Parecer de Juízo:
O gate v2 **fecha completamente** o "teatro de leitura" do PISO. 

#### Fundamentação:
- **Fechamento do Teatro:** Anteriormente (v1), o desafio baseava-se em respostas pré-definidas ou padrões regex fáceis de simular sem ler os arquivos (uma IA poderia apenas responder às strings estáticas contidas no gabarito). Sob o novo esquema v2, como a semente depende do estado inteiro da read-list (incluindo o readback atual e o handoff que mudam a cada rodada), a IA é forçada a ler de fato os bytes exatos dos arquivos staged no momento da atestação. Não há como simular a atestação sem possuir acesso real ao worktree e ao índice Git.
- **Resta Fresta?** Não há frestas mecânicas residuais conhecidas na lógica de validação atual. O guard opera hermeticamente em cima dos OIDs do índice staged (`git show :path`), prevenindo qualquer tipo de bypass de skew com a working tree. A contagem estrita de 13 arquivos e o check explícito de 3 respostas dinâmicas mais 2 campos no STATE garantem a coerência contextual do orquestrador.

---

## 4. Registro no Ledger (Linha REGISTRY)

REGISTRY: | 20260618-023926-antigravity-cross-ia-g-orq-entrada-0058 | .hbn/results/20260618-023926-antigravity-cross-ia-g-orq-entrada-0058.md | audit-result | frio | fronteira | — | 2026-06-18T02:39:26-03:00 |
