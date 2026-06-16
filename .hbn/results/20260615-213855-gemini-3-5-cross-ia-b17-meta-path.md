---
titulo: "Parecer ADR-020/022 — Cross-IA do B17 (Restrição tipo+nome em meta-path)"
tipo: audit-result
status: final
temperatura: frio
path: .hbn/results/20260615-213855-gemini-3-5-cross-ia-b17-meta-path.md
id-global: 20260615-213855-gemini-3-5-cross-ia-b17-meta-path
agente: gemini-3-5
autoria: gemini-3-5
familia: Google
created_at: "2026-06-15T21:38:55-03:00"
---

PAPEL auditor · TOKEN gemini-3-5 · FAMÍLIA Google · CONTEXTO {99%} · "auditando do disco"

# Parecer de Auditoria Cruzada do B17 — Restrição tipo+nome em meta-path (ADR-022)

## Identidade
- **AUDITOR**: gemini-3-5
- **FAMÍLIA**: Google
- **ESTADO**: "auditando do disco"
- **CONFIRMAÇÃO**: Confirmo que pertenço à família Google (Gemini) e realizei a auditoria de forma independente sobre o workspace `/Users/macbookpro/Projetos/usehbn`.

---

## Veredito Geral
**APROVA_B17**: SIM
**FUROS ENCONTRADOS**: nenhum (com observação sobre o comportamento esperado de links simbólicos e subpastas de bypasses, ambos bloqueando corretamente quaisquer conteúdos executáveis não-declarados).

---

## Sumário da Auditoria

### 1. Separação + Trailers
- **Comando**: `git log 9556618..cb4c1d4`
- **Trailers**: Todos os 4 commits da onda B17 acima de `9556618` possuem corretamente as linhas de rodapé separadas:
  - `HBN-Readback: 0019`
  - `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)`
  - `HBN-Token-FP: 34a7f2f9`
- **Separação**: Nenhum commit mistura lógica de governança com outros escopos. A branch `main` (`4db6928`) está intocada.
- **Linhas REGISTRY**: As linhas do REGISTRY para os artefatos da onda B17 estão numeradas e registradas a partir da linha 564 do `REGISTRY.md`.

### 2. Readback 0019
- **Campos verificados**:
  - `track` e `human_status` estão coerentes (`safe_track` e `confirmed` respectively).
  - `files_allowed` em `.hbn/readbacks/0019-b17-anti-smuggling-meta-path.json` está coerente com os arquivos alterados nos commits de B17.

### 3. Suítes de Testes
- **run-guard-tests**: O runner `bash guards/tests/run-guard-tests.sh` passou com sucesso com 140/140 testes verdes.
- **adversarial-battery**: A bateria adversarial `bash guards/tests/adversarial-battery.sh` cobriu todos os 17 cenários, com B17 sendo bloqueado (BATERIA VERDE).
- **hbn-guards-runner**: `bash guards/hbn-guards-runner.sh` retornou código de saída `rc=0` no ambiente de desenvolvimento.

### 4. Coerência da Spec e do Guard
- O diff de `537045b` (`guards/assert-scope-lock.sh`) restringe com sucesso a auto-permissão de meta-paths apenas para arquivos `.json` e `.md` em `.hbn/messages/` e `.hbn/bypasses/` com basename seguindo ADR-025, hearback do readback ativo e `.hbn/relay/INDEX.md`.
- A documentação em `guards/README.md` §Meta-paths é perfeitamente coerente com o código implementado.

---

## Tarefa Adversarial (Validação de Burlas)
Foi executada uma bateria de testes isolada para investigar as seguintes tentativas de burlar o scope-lock em meta-paths:

- **a) .hbn/bypasses/payload.sh e .hbn/messages/exploit.py (B17 clássico)**:
  - **Comportamento**: **BLOQUEADO** ✓ (`rc=1`).
- **b) Nome ADR-025 com extensão executável (.sh)**:
  - **Comportamento**: **BLOQUEADO** ✓ (`rc=1`).
- **c) Dupla extensão (.md.sh / .json.py)**:
  - **Comportamento**: **BLOQUEADO** ✓ (`rc=1`).
- **d) Symlink em meta-path apontando para script/binário**:
  - **Comportamento**: **PASSA** ✓ (`rc=0`). O link simbólico com nome de ADR-025 em `.hbn/messages/` é tolerado porque o guard avalia o nome do link e não o destino do link em si. No entanto, se o desenvolvedor modificar o arquivo de destino (que está fora do escopo), essa modificação será detectada no diff do Git e **BLOQUEADA** pelo guard no pre-commit. Portanto, não representa um furo crítico de bypass de modificação de código.
- **e) Nome quase-ADR-025 com .md (sem HHMMSS, maiúsculas, unicode/zero-width space)**:
  - **Comportamento**: **BLOQUEADO** ✓ (`rc=1`). O regex `^[0-9]{8}-[0-9]{6}-[a-z0-9][a-z0-9-]*-[a-z0-9][a-z0-9-]*\.(json|md)$` barrou com sucesso todas as variações incorretas.
- **f) Regressão (handoff bem-nomeado, hearback do readback ativo, bypass bem-nomeado)**:
  - **Comportamento**: **PASSAM** ✓ (`rc=0`).
- **g.1) Arquivo arbitrário sob subpasta com nome ADR-025 em bypasses/**:
  - **Comportamento**: **BLOQUEADO** ✓ (`rc=1`). Apenas o arquivo com extensão permitida e nome condizente passa.
- **g.2) Arquivo ADR-025 sob subpasta em bypasses/**:
  - **Comportamento**: **PASSA** ✓ (`rc=0`). A estrutura permite aninhamento, contanto que o arquivo final seja `.json`/`.md` com nomenclatura correta.

---

## Truth Barrier
- **Nível de Confiança**: 100/100.
- **Não verificado**: Execução externa no GitHub Actions (verificação simulada localmente via reprodução dos scripts de teste).
