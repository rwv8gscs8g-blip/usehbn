---
titulo: 06 - MD-H — Resolução da divergência de versão (package_version vs protocol_version)
diataxis: how-to
hbn-track: safe_track
hbn-status: active
audiencia: ambos
versao-protocolo: useHBN pre-v1
data: 2026-05-10
autor: Claude Opus 4.7 (chat arquiteto-mestre useHBN) — MD-H do plano de consolidação cross-IA
escopo: pré-requisito para re-depositar ADR-004 (SemVer)
relacionado:
  - 05_CONSOLIDACAO_CROSS_IA_ADRS_2026_05_10.md §B.4
  - .hbn/results/0003-cross-ia-codex-ADR-004.json
  - methodology/adr/ADR-004-semver-protocolo.md
status: congelado
temperatura: glacier
---

# 06. MD-H — Resolução da divergência de versão

> Este é um documento de **decisão arquitetural + plano de patch**. O
> patch em código (Python + setup.cfg + pyproject.toml) deve ser
> aplicado por Codex CLI (cirurgião) em sessão dedicada, não pelo Opus
> arquiteto. Este doc especifica exatamente o que mudar.

## A. O problema (achado cross-IA Codex)

Há **três superfícies de versão em conflito** no repo:

| Superfície | Valor atual | Arquivo:linha |
|---|---|---|
| `PROTOCOL_VERSION` | `"0.3.0"` | `src/usehbn/__init__.py:11` |
| `__version__` (package) | `"0.2.0"` | `src/usehbn/__init__.py:29` |
| `version` (setuptools metadata) | `0.2.0` | `setup.cfg:3` |
| `pyproject.toml` campo `version` | ausente (só build-system) | `pyproject.toml` |

E **um bug de roteamento**: `src/usehbn/cli.py:1079-1084` publica o campo
`protocol_version` nos records usando `__version__` (que é `0.2.0`),
enquanto `src/usehbn/protocol/result.py:91` e `readback.py:83` gravam
`protocol_version` usando `PROTOCOL_VERSION` (que é `0.3.0`).

**Consequência operacional:** uma app consumidora que chama `hbn version`
recebe `0.2.0`; um record ERP gravado declara `protocol_version: 0.3.0`.
Incoerência observável.

## B. A decisão

Adotar **duas constantes distintas com semânticas separadas**:

| Constante | Significado | Onde vive | Bump quando |
|---|---|---|---|
| `PACKAGE_VERSION` (`__version__`) | versão do pacote Python/CLI publicado no PyPI | `src/usehbn/__init__.py`, `setup.cfg`, `pyproject.toml` (fonte única → as outras derivam) | release de pacote (qualquer mudança de código que vá pro PyPI) |
| `PROTOCOL_VERSION` | versão do **protocolo** (schemas, princípios, contratos doutrinários) | `src/usehbn/__init__.py` | conforme ADR-004 §1 (MAJOR = mudança em P1-P13; MINOR = novo sinal/schema/partição; PATCH = redação) |

Os dois **podem divergir legitimamente** — é esperado. Ex.: `PACKAGE_VERSION
0.3.1` com `PROTOCOL_VERSION 0.3.0` (fix de bug no CLI sem mudança no
protocolo). O que NÃO pode é o CLI publicar a constante errada.

### B.1 Alinhamento de valores agora

- `PACKAGE_VERSION` = `"0.3.0"` (sobe de 0.2.0 → 0.3.0 — alinha com a
  Onda 6 "Vitrine + Release v0.3.0" do plano v0.3.0; o bump já estava
  planejado lá).
- `PROTOCOL_VERSION` = `"0.3.0"` (mantém).
- Após esta correção, ambos estão em `0.3.0` — mas isso é coincidência
  do momento, não acoplamento permanente.

### B.2 Fonte única de `PACKAGE_VERSION`

Decisão: `pyproject.toml` passa a ser a fonte única (`[project] version`),
com `setup.cfg` e `__init__.py:__version__` derivando dela. Alternativa
mais simples se isso for trabalhoso: manter `__init__.py:__version__`
como fonte e `setup.cfg`/`pyproject.toml` referenciarem. **Codex decide
o mecanismo** (setuptools dynamic version, ou hardcode sincronizado com
teste que valida igualdade). O importante é: **um lugar de verdade**.

## C. Plano de patch (para Codex CLI executar)

### C.1 Arquivos a tocar

| Arquivo | Mudança |
|---|---|
| `src/usehbn/__init__.py` | renomear ou aliasing: manter `__version__` mas adicionar `PACKAGE_VERSION = __version__` para clareza semântica; bumpar `__version__` de `0.2.0` → `0.3.0`; manter `PROTOCOL_VERSION = "0.3.0"`; exportar ambos em `__all__` |
| `setup.cfg` | `version = 0.3.0` (ou `attr: usehbn.__version__` se setuptools dynamic) |
| `pyproject.toml` | adicionar `[project]` com `name`, `version = "0.3.0"` (ou `dynamic = ["version"]`), `license`, `requires-python` — consolidar metadata que hoje está em `setup.cfg` |
| `src/usehbn/cli.py:1079-1084` | **bug fix**: `hbn version` (e qualquer record-writing path no cli) deve publicar `protocol_version` usando `PROTOCOL_VERSION`, NÃO `__version__`. Adicionalmente, `hbn version` deve imprimir **ambos** na saída: `usehbn package X.Y.Z (protocol A.B.C)` |
| `tests/test_*.py` | teste novo `test_version_constants_documented`: assert `PACKAGE_VERSION` e `PROTOCOL_VERSION` ambos existem e são strings SemVer; teste `test_cli_version_publishes_protocol_version_not_package`: assert que records gravados via cli usam `PROTOCOL_VERSION` |

### C.2 Migração de records legados

Records gravados antes desta correção podem ter `protocol_version: "0.2.0"`
(o valor errado do bug). Decisão: **não migrar retroativamente**. Records
históricos permanecem como estão (P7 — preservar identidade do que foi
gravado). A correção afeta apenas records novos. Quando `protocol_version`
virar `required` (v1.0.0, decisão Q4), um loader tolerante aceita ausência
ou valores antigos.

## D. Após este MD: re-depositar ADR-004

Uma vez aplicado o patch (por Codex) e os testes verdes:

1. Reescrever `methodology/adr/ADR-004-semver-protocolo.md` §1 absorvendo a
   distinção `PACKAGE_VERSION` vs `PROTOCOL_VERSION`.
2. Adicionar §nova: "Bug histórico de roteamento de versão — resolvido em
   MD-H 2026-05-10".
3. Status do ADR-004: `NÃO_RATIFICAR_AGORA` → re-deposit como `PROPOSED v2`.
4. Cross-IA leve (1 IA confirma que a divergência sumiu) → Hearback → `ACCEPTED`.

## E. Rollback

`git revert` do commit do patch restaura o estado divergente (que era o
estado anterior). Como o estado anterior tinha o bug, "rollback" aqui é
voltar ao bug — só fazer se a correção introduzir regressão pior. Os
testes novos (C.1) protegem contra isso.

## F. Versão

- v1.0 — 2026-05-10 — Opus 4.7 chat arquiteto-mestre — MD-H. Decisão: separar `PACKAGE_VERSION` de `PROTOCOL_VERSION`; plano de patch para Codex; ambos alinhados em `0.3.0` agora mas independentes daqui pra frente.
