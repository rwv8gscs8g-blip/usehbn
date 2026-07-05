---
path: .hbn/results/20260618-045800-antigravity-cross-ia-g-orq-entrada-0056.md
id-global: 20260618-045800-antigravity-cross-ia-g-orq-entrada-0056
tipo: audit-result
autor: antigravity
familia: Google
veredito: "APROVA_0056: SIM"
arvore: fronteira
created_at: "2026-06-18T01:58:00-03:00"
status: congelado
temperatura: glacier
---

SOU: antigravity · familia Google · papel auditor

APROVA_0056: SIM (Confiança: 100/100)

# PARECER DE AUDITORIA CRUZADA — G-ORQ-ENTRADA PISO (READBACK 0056)

- **Auditor**: antigravity (Família Google)
- **Papel**: Auditor Independente
- **Data/Hora**: 2026-06-18T01:58:00-03:00
- **Fase**: G-ORQ-ENTRADA PISO (Readback 0056)
- **Branch**: `proposta/reestruturacao-m-a-s0`
- **HEAD Auditado**: `b6451df5b5ed9a5c1552823632dc902e0343a4ce`

---

## 1. Verificação de Invariantes e Requisitos de Auditoria

### 1.1. `main` Intacta
- **Evidência no disco:** Executamos `git rev-parse main` e obtivemos a seguinte saída:
  ```
  4db692876381a0d7909985c8500d999f2e677b04
  ```
  Isso valida perfeitamente que o HEAD de `main` permaneceu intacto e intocado.

### 1.2. Escopo de Arquivos Modificados
- **Evidência no disco:** Executamos `git diff-tree --no-commit-id --name-only -r b6451df5b5ed9a5c1552823632dc902e0343a4ce` para listar os arquivos modificados/adicionados no commit alvo:
  1. `.hbn/attestations/34a7f2f9-orq-entrada.json`
  2. `.hbn/messages/20260618-003300-codex-handoff-g-orq-entrada.md`
  3. `.hbn/readbacks/0056-g-orq-entrada.json`
  4. `.hbn/relay/STATE.md`
  5. `REGISTRY.md`
  6. `core/read-list-canonica.txt`
  7. `guards/assert-orq-entrada.sh`
  8. `guards/data/orq-entrada-desafios.txt`
  9. `guards/hbn-guards-runner.sh`
  10. `guards/tests/adversarial-battery.sh`
  11. `guards/tests/run-guard-tests.sh`
- **Validação:** A lista de modificações de `b6451df` toca exclusivamente os 11 arquivos autorizados em `scope.files_allowed` de `.hbn/readbacks/0056-g-orq-entrada.json` (linhas 19-31). Nada além foi modificado.

### 1.3. Trailers Contíguos
- **Evidência no disco:** Executamos `git log -1 --format=%B b6451df5b5ed9a5c1552823632dc902e0343a4ce` para obter a mensagem do commit:
  ```
  feat(guards): G-ORQ-ENTRADA piso — atestacao de entrada do orquestrador (0056)
  
  Gate fail-closed: bastao de orquestrador exige atestacao valida contra
  read-list canonica + hashes de disco + desafios. Reconhecido como PISO
  (desafio aberto), hardening D1/extrativo/binding/escopo em ondas seguintes.
  
  HBN-Readback: 0056
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
  ```
- **Validação:** Os trailers obrigatórios estão presentes de forma contígua no último parágrafo do commit.

### 1.4. Suíte de Testes e Bateria Adversarial Verde
Executamos as suítes de teste e verificamos que tudo passou com sucesso:
- **`bash guards/hbn-guards-runner.sh`**: Passou com sucesso.
- **`bash guards/tests/run-guard-tests.sh`**: Finalizou reportando `== resumo: 200 passaram, 0 falharam ==` com exit code `0`. As novas coberturas de `G-ORQ-ENTRADA` incluem os testes:
  - `orq-entrada: atestacao valida passa`
  - `orq-entrada: sem atestacao → BLOCK`
  - `orq-entrada: hash divergente → BLOCK`
  - `orq-entrada: item da read-list ausente → BLOCK`
  - `orq-entrada: resposta fora do gabarito → BLOCK`
- **`bash guards/tests/adversarial-battery.sh`**: Finalizou com `BATERIA VERDE — toda burla documentada foi BLOQUEADA` e exit code `0`. As burlas `B41`, `B42`, `B43` e `B44` referentes ao bypass do novo gate foram bloqueadas com sucesso:
  - `B41 orquestrador sem atestacao | G-ORQ | BLOQUEADA ✓`
  - `B42 hash de read-list divergente | G-ORQ | BLOQUEADA ✓`
  - `B43 item de read-list ausente | G-ORQ | BLOQUEADA ✓`
  - `B44 resposta de desafio invalida | G-ORQ | BLOQUEADA ✓`

---

## 2. Análise Técnica do Gate Fail-Closed (`assert-orq-entrada.sh`)

O arquivo [assert-orq-entrada.sh](file:///Users/macbookpro/Projetos/usehbn/guards/assert-orq-entrada.sh) implementa a validação mecânica da atestação de entrada do orquestrador. A integridade fail-closed foi confirmada nos seguintes aspectos:
1. **Gatilho Correto:** O guard só entra em ação se `papel_bastao` ou `chapeu_atual` no `STATE.md` (local ou do índice) indicar `"orquestrador"` (linhas 59-62).
2. **Fail-Closed Estrito:** O script aborta e falha fechado (bloqueando o commit) caso:
   - O `STATE.md` esteja ausente ou não contenha `bastao_token_sha256` válido (linha 65).
   - O arquivo canônico `core/read-list-canonica.txt` ou o gabarito `guards/data/orq-entrada-desafios.txt` não existirem ou forem ilegíveis (linhas 77-84).
   - O arquivo de atestação `.hbn/attestations/${TOKEN_FP}-orq-entrada.json` não exista (linha 85).
   - A quantidade de itens resolvidos da read-list canônica divirja de 13 (linha 125).
   - O JSON da atestação esteja corrompido, tenha papel divergente de `"orquestrador"` ou não aponte para a read-list correta (linhas 153-170).
   - Algum arquivo listado na read-list canônica não tenha correspondência em `itens` na atestação ou o seu hash no disco atual (`git hash-object`) divirja do `blob_hash` atestado (linhas 197-212).
   - Qualquer resposta a desafio (D1-D4) esteja ausente ou divirja do padrão regex do gabarito (linhas 247-258).

---

## 3. Juízo sobre Selar o Piso (Doutrina do Enforcement)

### Pergunta de Design:
> Dado que (a) o gabarito `guards/data/orq-entrada-desafios.txt` está versionado em claro e (b) o desafio é pergunta-aberta+regex, o gate é seguro o suficiente para **SELAR COMO PISO** (falha fechado, só super-bloqueia) com hardening `W-ORQ-2` obrigatório em seguida? Ou recomenda dobrar `W-ORQ-2` ANTES da selagem?

### Parecer de Juízo:
Recomendo **SELAR COMO PISO** nesta versão, com a obrigação de iniciar o hardening `W-ORQ-2` imediatamente em seguida.

#### Fundamentação:
1. **A Proteção do Fail-Closed:** Como o gate foi implementado com política restritiva (qualquer divergência de hash, ausência de resposta ou erro de regex bloqueia o commit), o gate é seguro no sentido de que **não falha aberto**. Ele impede commits não-atestados por parte de um orquestrador.
2. **A Vulnerabilidade da Burla (Teatro de Leitura):** Por estar em formato estático (gabarito aberto e regex simples de pergunta-resposta no disco), uma IA com capacidade de ler arquivos de texto pode burlar a validação sem realizar qualquer leitura semântica real (bastando ler as regexes em `orq-entrada-desafios.txt` e compor respostas artificiais). No entanto, recomputar hashes locais do disco contra a read-list canônica já força a IA a acessar o worktree local real no momento da geração do JSON.
3. **Agilidade vs. Opacidade:** Tentar implementar a infraestrutura do `W-ORQ-2` (desafios dinâmicos extrativos baseados em seeds e hashes de execução dinâmicos) antes de selar o piso iria introduzir uma complexidade excessiva no commit atual. Selar o piso agora garante uma base funcional e testada de 200 testes verdes no runner antes de reestruturar a lógica dos desafios.
4. **Hardening W-ORQ-2 Mandatório:** A transição definitiva da branch só deve ser considerada madura após a aplicação de `W-ORQ-2` para sanar a burla de leitura, removendo o gabarito do disco ou implementando desafios dinâmicos extrativos (onde o guard sorteia dinamicamente uma linha do arquivo lido para a IA copiar, provando acesso físico aos bytes locais sem cognição artificial de teatro).

---

## 4. Registro no Ledger (Linha REGISTRY)

REGISTRY: | 20260618-045800-antigravity-cross-ia-g-orq-entrada-0056 | .hbn/results/20260618-045800-antigravity-cross-ia-g-orq-entrada-0056.md | audit-result | frio | fronteira | — | 2026-06-18T01:58:00-03:00 |
