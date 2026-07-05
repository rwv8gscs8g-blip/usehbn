---
titulo: 07 - MD-I — Especificação do snapshot tooling (fetch, verify, manifest determinístico)
diataxis: how-to
hbn-track: safe_track
hbn-status: active
audiencia: ambos
versao-protocolo: useHBN pre-v1
data: 2026-05-10
autor: Claude Opus 4.7 (chat arquiteto-mestre useHBN) — MD-I do plano de consolidação cross-IA
escopo: pré-requisito para re-depositar ADR-008 (migração snapshot Credenciamento)
relacionado:
  - 05_CONSOLIDACAO_CROSS_IA_ADRS_2026_05_10.md §B.8
  - .hbn/results/0009-cross-ia-codex-ADR-008.json
  - methodology/adr/ADR-008-migracao-snapshot-credenciamento.md
status: congelado
temperatura: glacier
---

# 07. MD-I — Especificação do snapshot tooling

> Documento de **especificação**. A implementação dos scripts e da
> extensão do `hbn doctor` deve ser feita por Codex CLI em sessão
> dedicada (pós-v204 final do Credenciamento, junto com ADR-008).

## A. O problema (achado cross-IA Codex)

ADR-008 (migração `Credenciamento/usehbn/` → `.usehbn-snapshot/`)
depende de 3 pilares técnicos que não existem hoje:

1. `bin/usehbn-fetch.sh` — popula o snapshot. **Não existe** (`bin/` inexistente).
2. `bin/usehbn-verify.sh` — valida o checksum. **Não existe**.
3. `hbn doctor` verificando snapshot/mirror drift. **Não existe** (`cli.py:1096-1199` não tem checks de snapshot).

Além disso, o checksum proposto ("sha256 da pasta") **não é determinístico** —
sem definição de ordenação, normalização de path, line endings,
permissões, ou se o próprio `PROTOCOL_SHA256.txt` entra no hash.

## B. Especificação do `PROTOCOL_MANIFEST.json` (determinístico)

Em vez de "sha256 da pasta", usar um **manifest determinístico por
arquivo**, e o checksum final = sha256 do manifest serializado
canonicamente.

### B.1 Estrutura do manifest

```json
{
  "schema_version": "1.0",
  "protocol_version": "1.0.0",
  "generated_at": "2026-05-NNTHH:MM:SSZ",
  "generated_by": "bin/usehbn-fetch.sh v1.0",
  "source_repo": "https://github.com/<org>/usehbn",
  "source_tag": "v1.0.0",
  "files": [
    {
      "path": "methodology/PRINCIPIOS-CONSTITUCIONAIS.md",
      "size": 12345,
      "sha256": "<hex>"
    },
    {
      "path": "modules/PROTOCOL-CONTRACT.md",
      "size": 6789,
      "sha256": "<hex>"
    }
  ]
}
```

### B.2 Regras de determinismo

1. **`path`**: relativo à raiz do snapshot, separador POSIX (`/`),
   NFC-normalized, sem `./` prefixo. Ascii puro preferido (ADR-009 §7).
2. **`files`**: ordenado lexicograficamente por `path` (UTF-8 byte order).
3. **`size`**: bytes do arquivo como gravado (após normalização de line
   ending — ver 4).
4. **Line endings**: todos os arquivos `.md`, `.json`, `.txt` no snapshot
   são normalizados para LF (`\n`) antes do hash. Arquivos binários (se
   houver) não são normalizados.
5. **`sha256` por arquivo**: hex lowercase do conteúdo do arquivo (após
   normalização de line ending para arquivos de texto).
6. **`generated_at`**: NÃO entra no cálculo do checksum final (é metadado
   informativo). O checksum final é sobre o subconjunto `{schema_version,
   protocol_version, source_repo, source_tag, files}` serializado como
   JSON canônico (chaves ordenadas, sem espaço extra, UTF-8).
7. **`PROTOCOL_SHA256.txt`**: contém apenas o hex do checksum final.
   **NÃO entra** no manifest nem no cálculo (é o output, não input).

### B.3 Arquivos do snapshot

```
.usehbn-snapshot/
├── VERSION                      # ex.: "1.0.0" — versão consumida
├── PROTOCOL_MANIFEST.json       # manifest determinístico
├── PROTOCOL_SHA256.txt          # hex do checksum final (sha256 do manifest canônico)
├── methodology/...              # cópia read-only
├── modules/...                  # cópia read-only
└── README.md                    # "diretório gerado — não editar manualmente"
```

O que vai pro snapshot: `methodology/` + `modules/` do repo canônico
(NÃO `auditoria/`, NÃO `src/`, NÃO `tests/`, NÃO `.hbn/` — o snapshot é
o **protocolo normativo + arquitetura**, não a implementação nem o
histórico).

## C. `bin/usehbn-fetch.sh` — especificação funcional

```
USO: bin/usehbn-fetch.sh <versão> [--target <path-da-app>] [--source <repo-url-ou-path>]

COMPORTAMENTO:
1. Resolve a tag/versão no repo canônico (--source; default = ~/Projetos/usehbn/).
2. Verifica que a tag existe e é estável (não pre-release).
3. Copia methodology/ + modules/ para <target>/.usehbn-snapshot/ (limpa o dir antes).
4. Normaliza line endings (LF) em .md/.json/.txt.
5. Gera PROTOCOL_MANIFEST.json (regras §B.2).
6. Calcula o checksum final e grava PROTOCOL_SHA256.txt.
7. Grava VERSION com a versão.
8. Grava README.md padrão ("gerado — não editar").
9. Imprime resumo: versão, n arquivos, checksum.
10. NÃO commita — operador revisa e commita.

FALHAS:
- Tag inexistente → exit 1, mensagem clara.
- Tag pre-release → exit 1, "use versão estável".
- <target> não é repo git → warning (mas prossegue — snapshot pode existir fora de git).
```

## D. `bin/usehbn-verify.sh` — especificação funcional

```
USO: bin/usehbn-verify.sh [--target <path-da-app>]

COMPORTAMENTO:
1. Lê <target>/.usehbn-snapshot/VERSION.
2. Lê <target>/.usehbn-snapshot/PROTOCOL_MANIFEST.json.
3. Recalcula o checksum a partir do manifest canônico (regras §B.2).
4. Compara com <target>/.usehbn-snapshot/PROTOCOL_SHA256.txt.
5. Para cada arquivo no manifest: verifica que existe no disco e que size+sha256 batem.
6. Se tudo OK → exit 0, "snapshot íntegro: versão X, N arquivos".
7. Se divergente → exit 2, lista os arquivos com mismatch, emite sinal 🪞 HBN MIRROR DRIFT (registra em .hbn/meta/signals-log.jsonl se existir).
```

## E. Extensão do `hbn doctor`

Adicionar a `src/usehbn/cli.py` (função `run_doctor`, hoje `~1096-1199`)
novos checks **quando `.usehbn-snapshot/` existir no target**:

| Check | O que verifica | Severidade |
|---|---|---|
| `snapshot_version` | `.usehbn-snapshot/VERSION` existe e é SemVer válido | warning se ausente |
| `snapshot_checksum` | recalcula checksum do manifest e compara com `PROTOCOL_SHA256.txt` | **fail** se divergente (emite 🪞 HBN MIRROR DRIFT) |
| `snapshot_files_integrity` | cada arquivo do manifest existe e size+sha256 batem | **fail** se algum diverge |
| `snapshot_not_edited` | (heurística) arquivos do snapshot não foram modificados após `generated_at` (mtime check, advisory) | warning |
| `license_consistency` (de MD-G/ADR-005) | não há mistura AGPL+Apache no repo | **fail** se mistura (este check vale para o repo do useHBN, não só apps) |

Quando `.usehbn-snapshot/` **não** existir no target, todos os checks de
snapshot são pulados silenciosamente (apps que não consomem o protocolo
via snapshot não veem ruído).

## F. `VERSION` raiz no useHBN

O repo canônico `~/Projetos/usehbn/` precisa de um `VERSION` na raiz
(hoje não existe — achado cross-IA Codex). Conteúdo: o `PROTOCOL_VERSION`
atual (ex.: `1.0.0` quando chegar lá; `0.3.0` agora). `bin/usehbn-fetch.sh`
lê esse `VERSION` para popular o snapshot. **Nota:** `VERSION` raiz é o
`PROTOCOL_VERSION`, não o `PACKAGE_VERSION` (ver MD-H §B) — o snapshot
é sobre o protocolo, não sobre o pacote Python.

## G. Após este MD: re-depositar ADR-008

Quando os scripts + extensão do doctor existirem (implementação Codex,
pós-v204 final):

1. Reescrever `methodology/adr/ADR-008-migracao-snapshot-credenciamento.md`
   §3 absorvendo o manifest determinístico (§B) e referenciando este MD-I.
2. Status: `NÃO_RATIFICAR_AGORA` → re-deposit `PROPOSED v2`.
3. Cross-IA (Codex confirma os 3 pilares existem; Antigravity confirma
   conceito intacto) → Hearback → `ACCEPTED`.
4. Execução da migração (substituição de `Credenciamento/usehbn/` por
   README depreciado + snapshot) só após `ACCEPTED` + MD-K (matriz
   origem→destino) concluído.

## H. Rollback

Scripts e extensão do doctor são aditivos — `git revert` do commit os
remove sem afetar nada existente. O snapshot, se já populado numa app,
permanece (é só arquivos read-only); a app continua funcionando sem o
tooling de verify (perde a validação automática até o tooling voltar).

## I. Versão

- v1.0 — 2026-05-10 — Opus 4.7 chat arquiteto-mestre — MD-I. Especificação completa: manifest determinístico (`PROTOCOL_MANIFEST.json` com regras de normalização), `bin/usehbn-fetch.sh`, `bin/usehbn-verify.sh`, 5 checks novos no `hbn doctor`, `VERSION` raiz no useHBN. Implementação fica para Codex pós-v204 final.
