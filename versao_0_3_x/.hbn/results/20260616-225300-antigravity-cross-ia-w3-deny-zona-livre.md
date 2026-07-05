---
titulo: "Parecer ADR-020/022 — Cross-IA do W3 (Deny-by-default da zona livre)"
tipo: audit-result
status: congelado
temperatura: glacier
path: .hbn/results/20260616-225300-antigravity-cross-ia-w3-deny-zona-livre.md
id-global: 20260616-225300-antigravity-cross-ia-w3-deny-zona-livre
autoria: antigravity
familia: Google
created_at: "2026-06-16T22:53:00-03:00"
---

PAPEL auditor · TOKEN antigravity · FAMÍLIA Google · CONTEXTO {100%} · "auditando do disco"

# Parecer de Auditoria Cruzada do W3 — Deny-by-default da Zona Livre (ADR-022)

## Identidade
- **AUDITOR**: antigravity
- **FAMÍLIA**: Google
- **ESTADO**: "auditando do disco"
- **CONFIRMAÇÃO**: Confirmo que pertenço à família Google (Antigravity/Gemini) e realizei a auditoria de forma independente sobre o workspace `/Users/macbookpro/Projetos/usehbn`.

---

## Veredito Geral
**APROVA_W3**: SIM
**FUROS ENCONTRADOS**: Nenhum furo de bypass de segurança ou regressão funcional foi encontrado na implementação do guard ou nas suítes de teste.
**ACHADO ADICIONAL (Sem Severidade de Bloqueio)**:
- **Divergência de Template/Explicit Path**: No readback ativo `.hbn/readbacks/0036-deny-zona-livre.json` (linha 28), o path listado em `files_allowed` é literal `".hbn/messages/20260616-HHMMSS-codex-handoff-w3-deny-zona-livre.md"`. No entanto, o arquivo criado foi `.hbn/messages/20260616-213600-codex-handoff-w3-deny-zona-livre.md`. Este commit passou com sucesso no guard G-SCO porque a regra B17 (auto-allow de meta-paths para coordenadores) foi aplicada, validando o padrão do arquivo como auto-permitido em `.hbn/messages/` (`assert-scope-lock.sh:248`). O arquivo passaria independentemente da explicit-list, mas destaca uma pequena incongruência entre a autorização estática e a criação real.

---

## Sumário da Auditoria

### 1. Separação + Trailers
- **Comando de validação de commits**: `git log 50263e1..55291e1 --oneline`
  - `55291e1 w3: atualiza state e handoff`
  - `c4fd64b w3: cobre deny-zona-livre e burla B33`
  - `ba40c30 w3: guard G-ZONA-LIVRE (bloqueante)`
  - `c683b0b w3: abre readback 0036`
- **Verificação de trailers**: Todos os 4 commits possuem trailers contíguos no último parágrafo (`git show -s <commit>`):
  - `HBN-Readback: 0036`
  - `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)`
  - `HBN-Token-FP: 34a7f2f9`
- **Separação**: O implementador (`codex`) operou estritamente dentro da branch `proposta/reestruturacao-m-a-s0` e no escopo de arquivos permitidos. Não houve commit espúrio nem toque na branch `main`.

### 2. Readback 0036 e Invariantes
- **Arquivo de Escopo**: `.hbn/readbacks/0036-deny-zona-livre.json` está completo e estruturado de acordo com o esquema.
- **Autorização Humana**: Devidamente justificada com `human_status` e `hearback_status` confirmados.
- **Arquivos Tocados**: Todos os arquivos modificados constam adequadamente do `scope.files_allowed` do readback ou qualificam-se no auto-allow de meta-paths coordenados.

### 3. Suítes de Testes (Anti-Teatro e Baterias)
- **run-guard-tests**: Execução de `bash guards/tests/run-guard-tests.sh` passou com status de **SUÍTE VERDE (178/178 checks)**.
- **adversarial-battery**: Execução de `bash guards/tests/adversarial-battery.sh` passou com status de **BATERIA VERDE (34/34 burlas bloqueadas)**, bloqueando a nova burla B33 (staged de brainstorm sem curadoria).
- **Enforcement**: O novo guard `assert-zona-livre.sh` foi integrado com sucesso à lista de guards executados pelo runner em `guards/hbn-guards-runner.sh` na linha 58.

### 4. Análise Estrita do Guard `assert-zona-livre.sh`
- **Leitura do Disco vs Memória (Truth Barrier)**: O script resolve os caminhos do STATE e do Readback usando `git show :<path>` (localmente) ou `HEAD:<path>` (em CI), evitando skews com a working tree descompromissada (`assert-zona-livre.sh:56-99`).
- **Prevenção de Path Traversal**: A verificação de segurança no campo `readback_ativo` do STATE bloqueia ativamente caracteres inseguros, como `..`, `*//*`, slashes adicionais, e whitespaces (`assert-zona-livre.sh:79-83`).
- **Fail-Closed**: Em caso de STATE ou readback ausente/ilegível ou erro na leitura do JSON, o guard falha fechado retornando código `1`.
- **Parsing JSON Segura**: Utiliza `python3` com um script embutido resiliente para decodificar e conferir a presença e integridade das chaves `zona_livre_curada` e `zona_livre_nota`.

### 5. Coerência Documental
- O `guards/README.md` (linhas 58-67) foi enriquecido com a documentação da regra de "Zona livre curada", explicando o comportamento do `G-ZONA-LIVRE`.
- O `REGISTRY.md` (linhas 856-869) foi atualizado registrando adequadamente todos os artefatos de W3 com as suas metadados e data-horas corretas.

---

## Evidência Mecânica (Truth Barrier)

### 1. Histórico de Commits e Diffs
```bash
$ git log 50263e1..55291e1 --oneline
55291e1 w3: atualiza state e handoff
c4fd64b w3: cobre deny-zona-livre e burla B33
ba40c30 w3: guard G-ZONA-LIVRE (bloqueante)
c683b0b w3: abre readback 0036
```

### 2. Validação Contígua de Trailers (Exemplo de C1)
```bash
$ git show -s c683b0b
commit c683b0b2580a89fc2434d40dd5f351bd19198320
Author: claude-fable-5 (Cowork) <mauriciozanin@gmail.com>
Date:   Tue Jun 16 20:09:05 2026 -0300

    w3: abre readback 0036
    
    HBN-Readback: 0036
    HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
    HBN-Token-FP: 34a7f2f9
```

### 3. Execução das Baterias de Teste
```bash
$ bash guards/tests/run-guard-tests.sh
== assert-zona-livre (G-ZONA-LIVRE) ==
  ✓ zona: brainstorm com curadoria no readback passa (esperado: pass)
  ✓ zona: brainstorm sem marcador no readback → BLOCK (esperado: block)
  ✓ zona: readback ativo ilegivel → BLOCK (esperado: block)
...
== resumo: 178 passaram, 0 falharam ==
SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
```

```bash
$ bash guards/tests/adversarial-battery.sh
B33 docs/brainstorm sem curadoria                    | G-ZONA   | BLOQUEADA ✓

BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

---

## Truth Barrier e Limitações
- **Nível de Confiança**: 100/100.
- **Limitações**: A execução de CI remoto não foi testada de forma física direta, mas o comportamento em CI foi simulado por `HBN_DIFF_BASE` e validado nos testes unitários e adversariais.
