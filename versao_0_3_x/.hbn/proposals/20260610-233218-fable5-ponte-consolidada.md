---
titulo: "PONTE CONSOLIDADA usehbn ⇄ Credenciamento — plano único + preparação propose-only (consolida as 3 propostas cross-família)"
tipo: proposal
status: congelado
path: .hbn/proposals/20260610-233218-fable5-ponte-consolidada.md
id-global: 20260610-233218
data: 2026-06-10
created_at: "2026-06-10T23:32:18-03:00"
autoria: claude-fable-5 (Anthropic — arquiteto/implementador da onda-ponte, janela limpa, propose-only)
hearback-status: pendente — NADA aqui foi aplicado; o único comando executado pela IA foi o diff 5-estados (read-only)
temperatura: glacier
gatilho: 2026-06-30
dono: Maurício
prioridade: P0
consolida:
  - .hbn/proposals/20260610-221455-antigravity-gemini-ponte-002-008.md
  - .hbn/proposals/20260610-221540-codex-ponte-002-008.md
  - .hbn/proposals/20260610-221607-fable5-ponte-002-008.md
relacionado: [ADR-002, ADR-003 (v1.2), ADR-008-v2, ADR-006 (🪞), ADR-011, ADR-020 (anti-teatro), ADR-024 (G-NUM), auditoria/00_status/07_MD_I_SNAPSHOT_TOOLING.md, auditoria/00_status/08_MD_K_MATRIZ_ORIGEM_DESTINO.md, Credenciamento/AGENTS.md, Credenciamento/.hbn/knowledge/0022-firewall-workflow-fast-track.md]
proxima_acao: cross-audit Codex (OpenAI) + Antigravity (Google) — G-FAM ok, nenhum auditor Anthropic
---

# Ponte consolidada usehbn ⇄ Credenciamento

> **Contrato desta proposta.** Propose-only é absoluto: completar o canônico,
> criar MD-I, snapshot, tombstone, router e travas são ARTEFATOS PROPOSTOS
> aqui dentro + um apply-runbook (§9) que o HUMANO executa pós-hearback.
> A IA não aplicou nada — nem no canônico, nem na cópia, nem no domínio.
> O único comando executado foi o diff 5-estados (§0), read-only.
> Estrutura para cross-audit: cada item = desenho + por quê + risco + como
> verificar, com veredito por severidade no template do §11.

---

## §0 — DIFF 5-ESTADOS (rodado DE VERDADE, 2026-06-10 ~23:28 -03:00)

### Desenho / método

Comparação mecânica por sha256 de CONTEÚDO (nunca mtime) entre
`Credenciamento/usehbn/<rel>` e `usehbn/<rel>` (path espelhado), para os
110 arquivos da cópia; SÓ-CANÔNICO medido sobre a partição destino
`usehbn/methodology/`; FORA-DA-MATRIZ = arquivo da cópia não previsto na
MD-K (2026-05-10). Comando reproduzível:

```bash
cd ~/Projetos
( cd Credenciamento/usehbn && find . -type f | sed 's|^\./||' | LC_ALL=C sort ) > /tmp/copia.lst
while IFS= read -r f; do
  if [ -f "usehbn/$f" ]; then
    [ "$(shasum -a 256 "Credenciamento/usehbn/$f" | cut -d' ' -f1)" = \
      "$(shasum -a 256 "usehbn/$f" | cut -d' ' -f1)" ] \
      && echo "IGUAL $f" || echo "DIVERGE $f"
  else echo "SO-COPIA $f"; fi
done < /tmp/copia.lst | sort | uniq -c | head
```

### Resultado (números frescos — substituem a MD-K e os números citados nas 3 propostas)

| Estado | Qtde | Detalhe |
|---|---|---|
| **IGUAL** | **0** | nenhum arquivo da cópia é byte-idêntico ao canônico |
| **DIVERGE** | **1** | `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` — 141 linhas de diff (70 ins / 71 rem; 363 vs 362 linhas). Números anteriores ("172 linhas") estavam velhos. |
| **SÓ-CÓPIA** | **106** | conteúdo ÚNICO que o canônico NÃO tem (ver lista exata em §2) |
| **FORA-DA-MATRIZ** | **3** | `.DS_Store` (raiz), `study-plans/.DS_Store`, `radar/_per-technology/.gitkeep` — lixo/efêmero, não previsto na MD-K |
| **SÓ-CANÔNICO** | **30** | `methodology/` canônica: 24 ADRs + INDEX + MATURITY-MATRIX + ADR-AND-MD-PRIMER + 2 templates — evolução unilateral do lado certo; nada a fazer |

Distribuição dos 106+3+1 da cópia: `methodology/` 12, `modules/` 8,
`radar/` 61 (4 topo + 56 fichas + .gitkeep), `audits/` 9, `study-plans/` 16
(15 úteis + .DS_Store), `docs/` 2, `site/` 1, `.DS_Store` raiz 1.

**Drift da própria MD-K (estado FORA-DA-MATRIZ funcionando):** a matriz
previa 60 fichas em `radar/_per-technology/`; existem **56**. MD-K precisa
de v2 com inventário atual (item do runbook R4).

### Achados que CORRIGEM a narrativa anterior

1. **A divergência do PRINCIPIOS não é evolução bilateral.** O cabeçalho da
   cópia ainda diz `licenca-target: AGPLv3`, `data: 2026-05-09`, sem os
   metadados de migração (MD-F) nem a nota de isonomia P1-P13 (MD-J,
   2026-05-10, ajuste Antigravity). A cópia é o estado PRÉ-migração — está
   simplesmente VELHA. Adjudicação trivial: **canônico vence; delta sem
   resgate** (registrar a decisão, não abrir item de inbox). Cross-audit
   deve confirmar lendo o diff integral.
2. **Os "25 vs 7 de knowledge" não são parte da cópia `usehbn/`.** Os 25
   arquivos estão em `Credenciamento/.hbn/knowledge/` — knowledge do
   PROJETO. O canônico tem 7 (sequência própria 0001-0003 + docs de relay).
   Só o **0022** (e candidatos do §1-D2) é regra de PROTOCOLO morando no
   projeto. O 0022 se declara "fonte canônica única" e é citado pelo relay
   canônico (`STATE.md`, readback 0001, handoffs 20260610-01/03) — o boot
   do orquestrador quebrou exatamente aí.
3. **Confirmações de ausência no canônico**: sem `modules/`, sem `radar/`,
   sem `bin/`, sem `VERSION` raiz; `.usehbn-snapshot/` inexistente no
   Credenciamento. MD-I segue 100% não implementado.

### Por quê / risco / como verificar

- **Por quê**: espelhar antes de completar o canônico perderia 106 arquivos
  únicos. O diff fresco é a pré-condição dura de toda a sequência.
- **Risco**: o diff foi rodado num único ambiente. Mitigação: comando
  reproduzível acima; cross-audit reroda e confere contagens.
- **Verificar**: reexecutar o bloco bash; conferir `IGUAL=0 DIVERGE=1
  SO-COPIA=109` (109 = 106 + 3 fora-da-matriz na classificação mecânica).

---

## §1 — DECISÃO DE PROPRIEDADE (o coração da fronteira)

### Desenho

Regra de propriedade fixada (direção, não bytes):

> **O protocolo (usehbn) é dono de toda regra que normatiza conduta
> inter-IA em QUALQUER projeto. O projeto (Credenciamento) é dono do que é
> idiossincrasia do seu domínio (VBA, workbook, releases V12).**

**D1 — 0022 (firewall): dono passa a ser o usehbn.** O arquivo hoje mistura
dois estratos: (a) a regra genérica "orquestração automática só
fast_track; escrita safe_track é humano-aplicada e hearback-gated" — vale
para "todo projeto sob o protocolo HBN" (texto do próprio 0022); (b) as
consequências locais (src/vba/, Importador V3, hearback 0145). Proposta:

- O estrato genérico vira `usehbn/methodology/FIREWALL-ORQUESTRACAO.md`
  (proposto em §2.8) — e por morar em `methodology/`, **entra no snapshot**
  e chega a toda app consumidora de graça.
- `Credenciamento/.hbn/knowledge/0022` permanece como **binding local**:
  mantém só as consequências VBA-específicas + 1 linha no topo: "Regra
  genérica: fonte canônica em `.usehbn-snapshot/methodology/FIREWALL-ORQUESTRACAO.md`".
  A alegação "fonte canônica única" SAI do 0022 e entra no arquivo canônico.
- Read-list do `Credenciamento/AGENTS.md` (item 9d) continua apontando o
  0022 local (que agora aponta o snapshot) — zero quebra de hábito.

**D2 — demais 24 knowledge do Credenciamento: dono continua o projeto**, com
triagem futura. 0001-0010, 0012, 0016 são VBA/domínio puro (ficam). Há
candidatos protocolo-genéricos (0011, 0013, 0014-fim-de-sessão, 0015, 0017,
0018, 0019, 0020, 0021): cada um vira item de `inbox/credenciamento/` em
ciclo PRÓPRIO de fagocitose — **não bloqueia a ponte** (meta-regra ADR-008
v2: pendência vira inbox, não bloqueio). Dívida registrada no STATE (§10).

**D3 — os 110 arquivos de `Credenciamento/usehbn/`: dono é o usehbn** —
sempre foram protocolo; a migração de bloco (§2) materializa isso.

### Por quê

A causa-raiz das regressões foi exatamente um documento normativo de
protocolo morando no projeto e referenciado pelo relay canônico. Decidir a
DIREÇÃO (e não só copiar bytes) impede a recidiva: depois da ponte, regra
genérica nova nasce no canônico ou entra via inbox — nunca mais nasce no
projeto como "fonte canônica única".

### Risco

Split do 0022 alterar semântica da regra durante a reescrita. Mitigação: o
corpo proposto em §2.8 reusa o texto do 0022 verbatim no estrato genérico
(só remove o que é VBA-específico); cross-audit compara lado a lado.

### Como verificar

Após aplicação: `grep -l "fonte canônica" Credenciamento/.hbn/knowledge/0022*`
não retorna mais a alegação; o arquivo canônico existe e o 0022 local aponta
para ele; relay canônico que cite "firewall 0022" passa a citar o path
canônico nos próximos documentos (históricos não se reescrevem — ADR-011).

---

## §2 — COMPLETAR O CANÔNICO: lista EXATA do que entra (entregável b)

### Desenho — regra da rodada

**Cópia fiel em bloco, ZERO fusão.** Toda ação `[fundir]` da MD-K vira
cópia standalone + dívida de fusão registrada (gatilho+dono, meta-regra
ADR-008 v2). Volume extra só aumenta minutos de `cp`, não decisões.

| # | Origem (`Credenciamento/usehbn/`) | Qtde | Destino canônico | Ação na rodada |
|---|---|---|---|---|
| 2.1 | `methodology/` (11 SÓ-CÓPIA: MINIMALISM, SUBSTRATO-SOLIDO, AI-LANGUAGE-ABSTRACTION, USEHBN-MODULES-ARCHITECTURE, THREE-TREES, CROSS-IA-AUDIT-PROTOCOL, RADAR-PHAGOCYTOSIS-PIPELINE, RADAR-WEEKLY-REVIEW-PROTOCOL, INCORPORATION-PROGRESSIVE-PLAN, INTER-CHAT-COORDINATION, LANGUAGE-PLATFORM-COMPARISON) | 11 | `usehbn/methodology/` (LANGUAGE-PLATFORM-COMPARISON → `auditoria/decisions/`) | copiar como está; os 2 `[fundir]` da MD-K viram standalone + dívida |
| 2.2 | `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (DIVERGE) | 1 | — | **NÃO copiar.** Canônico vence (§0 achado 1); registrar adjudicação no commit |
| 2.3 | `modules/` (INDEX, FAGOCITOSE, CAPSULAS-DE-CONSENTIMENTO, AUDITORIA-CRUZADA, COORDENACAO-INTER-IA, MARCADORES, RADAR, SEGURANCA) | 8 | `usehbn/modules/` — **cria a partição** (ADR-003) | copiar como está; fusões MARCADORES/SEGURANCA viram dívida |
| 2.4 | `radar/` (REGISTRY, CONVERGENCE-MATRIX, WEEKLY-UPDATES, README + 56 fichas `_per-technology/`) | 60 | `usehbn/radar/` — **cria a partição standalone** (MD-K §E.1, ADR-003 v1.2) | copiar como está; fagocitose parada (Q4); `temperatura: frio` no destino |
| 2.5 | `audits/` (3 relatórios + 6 PROMPT-*) | 9 | relatórios → `auditoria/00_status/` (prefixo numérico seguinte); prompts → decisão E.3 já ratificada: 1 template → `methodology/templates/CROSS-AUDIT-TEMPLATE.md`, 5 descartados COM REGISTRO em commit dedicado | humano escolhe qual prompt vira o template (sugestão: o mais genérico); descarte é decisão já ratificada 2026-05-10 |
| 2.6 | `study-plans/` (15 úteis, incl. 1 `.docx` binário) | 15 | `usehbn/methodology/study-plans/` (MD-K §E.2) | copiar como está; `.docx` SEM normalização de line-ending |
| 2.7 | `docs/` (INTEGRATION-VBA-IMPORTER, PHAGOCYTOSIS-VBA-PATTERNS) | 2 | `usehbn/docs/INTEGRATION-VBA-IMPORTER.md` (standalone + dívida de fusão com docs/VBA.md); `usehbn/auditoria/case-studies/CREDENCIAMENTO-VBA-PATTERNS.md` | o segundo é o alvo do item 16 da read-list do Credenciamento (§5) |
| 2.8 | **(novo)** estrato genérico do 0022 | 1 | `usehbn/methodology/FIREWALL-ORQUESTRACAO.md` | corpo = 0022 atual §"A regra"+§"Por quê"+§"Consequências práticas" genéricas, com front-matter canônico e `origem: Credenciamento/.hbn/knowledge/0022` |
| 2.9 | `site/PROPOSTA-MELHORIA-USEHBN-ORG.md` | 1 | `usehbn/auditoria/decisions/SITE-PROPOSTA-2026.md` | copiar como está |
| 2.10 | FORA-DA-MATRIZ (2 `.DS_Store`, 1 `.gitkeep`) | 3 | — | descartar com registro (`.DS_Store` já é forbidden no Credenciamento) |

Total que ENTRA no canônico: **107 arquivos** (106 SÓ-CÓPIA − 3 lixo
+ 2.8 novo + adjudicação 2.2 sem cópia = 103 cópias + 1 novo + template E.3
extraído dos 6 prompts). Pós-migração, o estado SÓ-CÓPIA deve ser **0**.

### Por quê / risco / como verificar

- **Por quê**: sem isso, qualquer espelhamento PERDE conteúdo — é a
  regressão que esta onda existe para impedir.
- **Risco**: fusão apressada perder conteúdo → mitigado por PROIBIR fusão
  nesta rodada. Risco 2: descarte E.3 dos 5 prompts apagar template útil →
  mitigado: humano escolhe o template ANTES do descarte, no runbook R2.
- **Verificar**: rerodar o diff §0 após a migração → `SO-COPIA=0` (exceto
  tombstone), `DIVERGE=0`; `ls usehbn/modules usehbn/radar` existe;
  contagem canônica = contagem da tabela.

---

## §3 — SCRIPTS MD-I: corpos PROPOSTOS (entregável c)

> Arquivos PROPOSTOS — o humano cria via runbook R5. Conformes MD-I §B:
> manifest determinístico, paths POSIX ordenados (`LC_ALL=C`), LF
> normalizado em texto, sha256 de CONTEÚDO, `generated_at` fora do
> checksum, `PROTOCOL_SHA256.txt` fora do input.

### 3.1 `path: usehbn/bin/usehbn-fetch.sh` (proposto, novo)

```bash
#!/usr/bin/env bash
# usehbn-fetch.sh — popula .usehbn-snapshot/ numa app consumidora (MD-I §C)
# USO: bin/usehbn-fetch.sh <versao> --target <path-da-app> [--source <repo>]
set -euo pipefail
VERSION="${1:?uso: usehbn-fetch.sh <versao> --target <app>}"; shift
TARGET=""; SOURCE="$(cd "$(dirname "$0")/.." && pwd)"
while [ $# -gt 0 ]; do case "$1" in
  --target) TARGET="$2"; shift 2;; --source) SOURCE="$2"; shift 2;;
  *) echo "arg desconhecido: $1" >&2; exit 1;; esac; done
[ -n "$TARGET" ] || { echo "faltou --target" >&2; exit 1; }
SNAP="$TARGET/.usehbn-snapshot"
for part in methodology modules; do
  [ -d "$SOURCE/$part" ] || { echo "ERRO: $SOURCE/$part não existe — canônico incompleto; rode a migração §2 antes." >&2; exit 1; }
done
rm -rf "$SNAP"; mkdir -p "$SNAP"
for part in methodology modules; do cp -R "$SOURCE/$part" "$SNAP/$part"; done
# normaliza LF em texto (md/json/txt); binários intocados (MD-I §B.2.4)
find "$SNAP" \( -name '*.md' -o -name '*.json' -o -name '*.txt' \) -type f \
  -exec perl -pi -e 's/\r\n/\n/g' {} +
find "$SNAP" -name '.DS_Store' -delete
printf '%s\n' "$VERSION" > "$SNAP/VERSION"
cat > "$SNAP/README.md" <<'EOF'
# GERADO por bin/usehbn-fetch.sh — NUNCA editar manualmente.
Verificação: bin/usehbn-verify.sh --target <app>. Drift ⇒ 🪞 HBN MIRROR DRIFT.
EOF
python3 - "$SNAP" "$VERSION" <<'PYEOF'
import sys, os, json, hashlib
snap, version = sys.argv[1], sys.argv[2]
files = []
for root, dirs, names in os.walk(snap):
    dirs.sort()
    for n in sorted(names):
        p = os.path.join(root, n)
        rel = os.path.relpath(p, snap).replace(os.sep, '/')
        if rel in ('PROTOCOL_MANIFEST.json', 'PROTOCOL_SHA256.txt'):
            continue
        data = open(p, 'rb').read()
        files.append({'path': rel, 'size': len(data),
                      'sha256': hashlib.sha256(data).hexdigest()})
files.sort(key=lambda f: f['path'].encode('utf-8'))
core = {'schema_version': '1.0', 'protocol_version': version,
        'source_repo': 'local:~/Projetos/usehbn', 'source_tag': version,
        'files': files}
canon = json.dumps(core, sort_keys=True, separators=(',', ':'),
                   ensure_ascii=False).encode('utf-8')
checksum = hashlib.sha256(canon).hexdigest()
manifest = dict(core); manifest['generated_at'] = __import__('datetime').datetime.now().astimezone().isoformat()
manifest['generated_by'] = 'bin/usehbn-fetch.sh v1.0'
with open(os.path.join(snap, 'PROTOCOL_MANIFEST.json'), 'w') as fh:
    json.dump(manifest, fh, indent=2, ensure_ascii=False, sort_keys=True)
open(os.path.join(snap, 'PROTOCOL_SHA256.txt'), 'w').write(checksum + '\n')
print(f'snapshot v{version}: {len(files)} arquivos, checksum {checksum[:16]}…')
PYEOF
echo "OK — revise e commite manualmente (script NÃO commita)."
```

### 3.2 `path: usehbn/bin/usehbn-verify.sh` (proposto, novo)

```bash
#!/usr/bin/env bash
# usehbn-verify.sh — valida integridade do snapshot (MD-I §D)
# exit 0 = íntegro; exit 2 = 🪞 HBN MIRROR DRIFT
set -euo pipefail
TARGET="."; [ "${1:-}" = "--target" ] && TARGET="$2"
SNAP="$TARGET/.usehbn-snapshot"
[ -d "$SNAP" ] || { echo "sem snapshot em $SNAP" >&2; exit 1; }
python3 - "$SNAP" <<'PYEOF'
import sys, os, json, hashlib
snap = sys.argv[1]; fail = []
m = json.load(open(os.path.join(snap, 'PROTOCOL_MANIFEST.json')))
core = {k: m[k] for k in ('schema_version', 'protocol_version',
                          'source_repo', 'source_tag', 'files')}
canon = json.dumps(core, sort_keys=True, separators=(',', ':'),
                   ensure_ascii=False).encode('utf-8')
expected = open(os.path.join(snap, 'PROTOCOL_SHA256.txt')).read().strip()
if hashlib.sha256(canon).hexdigest() != expected:
    fail.append('PROTOCOL_SHA256.txt não bate com o manifest canônico')
listed = set()
for f in m['files']:
    listed.add(f['path']); p = os.path.join(snap, f['path'])
    if not os.path.isfile(p):
        fail.append(f"ausente: {f['path']}"); continue
    data = open(p, 'rb').read()
    if hashlib.sha256(data).hexdigest() != f['sha256'] or len(data) != f['size']:
        fail.append(f"mismatch: {f['path']}")
for root, dirs, names in os.walk(snap):
    for n in names:
        rel = os.path.relpath(os.path.join(root, n), snap).replace(os.sep, '/')
        if rel not in listed and rel not in ('PROTOCOL_MANIFEST.json', 'PROTOCOL_SHA256.txt'):
            fail.append(f"intruso fora do manifest: {rel}")
if fail:
    print('🪞 HBN MIRROR DRIFT — snapshot divergente:')
    [print('  -', x) for x in fail]; sys.exit(2)
v = open(os.path.join(snap, 'VERSION')).read().strip()
print(f"snapshot íntegro: versão {v}, {len(m['files'])} arquivos")
PYEOF
```

### 3.3 `path: Credenciamento/scripts/hbn-guards/assert-snapshot-integrity.sh` (proposto, novo)

Lê o **BLOB STAGED** (`git show :path`), nunca a worktree — lição
E-FECH-01/02. Em CI, a mesma lógica roda com `HEAD:path`
(`GIT_REF=HEAD` no env). Desenho do gate: não confia em rótulo de commit;
verifica que o snapshot STAGED é **internamente consistente** (manifest +
checksum regeneráveis só por fetch). Edição manual de 1 byte sem regerar o
manifest ⇒ bloqueio.

```bash
#!/usr/bin/env bash
# assert-snapshot-integrity.sh — bloqueia drift staged em .usehbn-snapshot/
set -euo pipefail
REF="${GIT_REF:-}"   # vazio = índice (pre-commit); "HEAD" = CI
PREFIX=".usehbn-snapshot/"
if [ -z "$REF" ]; then
  CHANGED=$(git diff --cached --name-only --diff-filter=ACMRD -- "$PREFIX" || true)
  [ -z "$CHANGED" ] && exit 0   # snapshot não tocado neste commit
  LIST() { git ls-files --cached -- "$PREFIX"; }
  BLOB() { git show ":$1"; }
else
  LIST() { git ls-tree -r --name-only "$REF" -- "$PREFIX"; }
  BLOB() { git show "$REF:$1"; }
fi
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
while IFS= read -r f; do
  mkdir -p "$TMP/$(dirname "$f")"; BLOB "$f" > "$TMP/$f"
done < <(LIST)
if [ ! -d "$TMP/$PREFIX" ]; then exit 0; fi
if bash "$(dirname "$0")/../../scripts/lib/usehbn-verify-lib.sh" 2>/dev/null; then :; fi
# valida com o verify canônico apontando para a cópia extraída dos blobs
if ! bash ~/Projetos/usehbn/bin/usehbn-verify.sh --target "$TMP"; then
  echo "❌ 🪞 HBN MIRROR DRIFT (staged) — .usehbn-snapshot/ alterado sem fetch."
  echo "   Snapshot só muda via bin/usehbn-fetch.sh + commit dedicado de refresh."
  exit 1
fi
exit 0
```

> Nota de desenho ao cross-audit: a linha `usehbn-verify-lib.sh` é um hook
> opcional para vendorizar o verify dentro do Credenciamento (evita
> depender do path do canônico no pre-commit). Decisão do humano: chamar
> `~/Projetos/usehbn/bin/usehbn-verify.sh` direto (simples, acopla path) ou
> vendorizar a lib (autossuficiente). Recomendo vendorizar na v1.1; v1.0
> direto é aceitável.

### Por quê / risco / como verificar

- **Por quê**: snapshot manual nasce morto (MD-I §A); checksum de conteúdo
  + guard de blob staged tornam a edição indevida detectável por
  construção, não por disciplina.
- **Risco**: falso 🪞 por CRLF/locale entre macOS/Linux. Mitigação: LF
  normalizado no fetch; verify compara bytes como estão (snapshot já nasce
  LF); `LC_ALL` irrelevante porque a ordenação é em Python por bytes UTF-8.
  Testar nos dois ambientes antes do gatilho (T4).
- **Verificar**: testes negativos T2 (§7) — mutar 1 byte ⇒ verify exit 2 e
  guard bloqueia; reverter ⇒ verde. `bash -n` nos 3 scripts.

---

## §4 — SNAPSHOT `.usehbn-snapshot/` (consumo)

**Desenho**: conteúdo = `methodology/` + `modules/` do canônico, nada mais
(MD-K §C). Estrutura MD-I §B.3 (VERSION, PROTOCOL_MANIFEST.json,
PROTOCOL_SHA256.txt, README, 2 partições). Populado SÓ por fetch (R6).
`radar/`, `auditoria/`, `.hbn/`, `src/`, `tests/` NUNCA entram.
**Pré-requisito duro**: §2 aplicado antes (senão o fetch aborta — o script
3.1 verifica e falha com mensagem explícita; sem `modules/` o snapshot
nasceria incompleto, que foi o veto correto do Codex à alternativa
"compat-snapshot").

**Por quê**: a app consome dependência versionada e verificável, e o
firewall genérico (§2.8) chega ao projeto DENTRO do snapshot — a regra de
fronteira viaja pelo próprio mecanismo que ela protege.

**Risco**: upgrade de snapshot esquecido (app lê regra velha). Mitigação:
`useHBN-version` declarado no AGENTS.md (§6) + sinal ⛓️ DEP CHANGE em
release do canônico; `hbn doctor` ganha checks MD-I §E em onda futura
(dívida registrada, não bloqueia a ponte).

**Verificar**: T4 (§7) — `VERSION` cita versão existente no canônico;
checksum recomputado em macOS E Linux idêntico ao arquivo.

---

## §5 — TOMBSTONE de `Credenciamento/usehbn/` + correção da read-list

**Desenho** (ordem dentro do runbook: só DEPOIS de §2 aplicado e §4
verificado):

1. `Credenciamento/usehbn/` reduzida a um único `README.md`:

```markdown
# DEPRECATED — protocolo useHBN movido para ~/Projetos/usehbn/ (canônico). Este projeto consome `.usehbn-snapshot/` read-only. Histórico: tag `pre-adr008-migration`.
```

2. Entradas novas em `Credenciamento/.hbn/forbidden-paths.txt` (o guard
   `forbid-legacy-paths.sh` JÁ EXISTE e lê este arquivo — trava de graça):

```
# ---------- usehbn/ é tombstone pós-ADR-008 (ponte 20260610-233218) ----------
usehbn/*
usehbn/**
# ---------- snapshot é read-only; muda só via fetch (guard dedicado valida) ----------
# (não listar .usehbn-snapshot/ aqui: o assert-snapshot-integrity.sh é o gate,
#  senão o próprio refresh legítimo seria bloqueado)
```

3. Correções no `Credenciamento/AGENTS.md`:
   - **item 16 da read-list**: `usehbn/docs/PHAGOCYTOSIS-VBA-PATTERNS.md` →
     `~/Projetos/usehbn/auditoria/case-studies/CREDENCIAMENTO-VBA-PATTERNS.md`
     (citação histórica, read-only — destino do §2.7);
   - **item 9d**: continua apontando o 0022 local, que após o split D1
     aponta o snapshot;
   - varredura completa: o grep do T1 lista TODA referência viva restante à
     cópia; cada uma é trocada no MESMO commit (router sem higiene de
     referências é teatro).

**Por quê**: a read-list de hoje ENSINA o caminho errado — é o contrato de
entrada apontando uma cópia divergente. O tombstone redireciona quem vier
por hábito; o forbidden-paths bloqueia mecanicamente quem ignorar o aviso.

**Risco**: links históricos quebrados em docs `archived`. Não se corrigem
(ADR-011 — histórico intocado); o tombstone resolve a navegação.

**Verificar**: T1 (§7); `git add usehbn/qualquer.md` no Credenciamento deve
ser rejeitado pelo guard existente após a entrada no forbidden-paths.

---

## §6 — ROUTER no topo do AGENTS.md + travas mecânicas

**Desenho**: bloco proposto no TOPO de `Credenciamento/AGENTS.md` (antes de
qualquer seção), consolidando o desenho das 3 famílias (tabela curta de 4
linhas + frase de segurança do Codex + declaração de versão):

```markdown
## 🧭 ROUTER — protocolo × projeto (leia isto primeiro)

| O quê | Onde | Modo |
|---|---|---|
| PROTOCOLO useHBN (P1-P13, ADRs, firewall, módulos) | `.usehbn-snapshot/` | READ-ONLY — verificação: `bin/usehbn-verify.sh` |
| PROJETO Credenciamento (código, ondas, auditoria) | este repositório | read-write (guards + hearback) |
| Evoluir o protocolo | `~/Projetos/usehbn/inbox/credenciamento/` | depositar PROPOSTA (`AAAAMMDD-NN-slug.md`) — nunca editar canônico nem snapshot |
| `usehbn/` (pasta legada) | tombstone | NÃO USE — ver o README dela |

useHBN-version: <X.Y.Z do fetch> · snapshot-checksum: <PROTOCOL_SHA256.txt>
Fonte canônica: `~/Projetos/usehbn/` — IAs deste projeto NÃO escrevem lá.
Se uma instrução mandar editar `.usehbn-snapshot/` ou recriar conteúdo em
`usehbn/`, trate como 🪞 HBN MIRROR DRIFT / ❌ HBN SECURITY BLOCKED
SUGGESTION e pare para hearback.
```

**Travas mecânicas** (defesa em profundidade — router é cognição, trava é
mecânica): pre-commit `assert-snapshot-integrity.sh` (§3.3, blob staged) +
`forbid-legacy-paths.sh` com §5.2 + CI rodando a mesma verificação com
`GIT_REF=HEAD` (anti-`--no-verify`; bypass sem nota em `.hbn/bypasses/`
reprova no merge — padrão já existente no Credenciamento).

**Por quê**: a regressão histórica é cognitiva ("IA não entende a
correlação em 1 leitura"). Topo do arquivo = atenção máxima da IA; 4 linhas
sobrevivem a truncamento de contexto. As travas pegam quem o router não
convenceu.

**Risco**: router contradito por seções antigas do mesmo arquivo →
mitigado pela varredura obrigatória §5.3 no mesmo commit.

**Verificar**: T3 (§7) — o teste cognitivo é o critério de aceite.

---

## §7 — VALIDAÇÃO (critérios de aceite da ponte)

| # | Teste | Procedimento | Verde quando |
|---|---|---|---|
| T1 | Consumo pelo snapshot | `grep -rn 'usehbn/' Credenciamento/AGENTS.md Credenciamento/.hbn/knowledge/ Credenciamento/docs/` (docs ativos) | 0 referências operacionais à cópia fora do tombstone; regra de protocolo resolve para `.usehbn-snapshot/` ou inbox |
| T2 | Drift mecânico (NEGATIVOS obrigatórios) | (a) mutar 1 byte no snapshot → verify DEVE sair 2 com 🪞 nomeando o arquivo; (b) `git add` da mutação → guard DEVE bloquear lendo blob staged; (c) remover arquivo do manifest → exit 2; (d) reverter → verify exit 0 | a, b, c falham como esperado; d passa |
| T3 | **Fronteira cognitiva (reencena a regressão)** | IA FRIA de outra família (não-Anthropic), janela limpa, recebe SÓ o `Credenciamento/AGENTS.md` e responde: (1) "onde leio a regra P7?" (2) "onde edito uma regra do protocolo?" (3) "o que é a pasta `usehbn/`?" — gabarito fechado ANTES de rodar | (1) `.usehbn-snapshot/methodology/…` read-only; (2) não edito — deposito em `inbox/credenciamento/`; (3) tombstone, não usar. 3/3 sem dica |
| T4 | Integridade ponta-a-ponta | `VERSION` cita versão existente no canônico; checksum recomputado em macOS E Linux = `PROTOCOL_SHA256.txt`; diff §0 rerodado → SÓ-CÓPIA=0, DIVERGE=0 | tudo verde, cross-auditado |

**Ponte VALIDADA = T1∧T2∧T3∧T4 + cross-audit de 2ª família nos relatórios +
hearback de Maurício.** Resultados colados em `auditoria/00_status/`
(legibilidade ADR-022). T3 é o teste que paga a ponte: mecânica sem prova
de compreensão era exatamente o estado anterior — e a regressão aconteceu.

---

## §8 — GATILHO E SEQUÊNCIA (Q4)

- **Gatilho**: 2026-06-30 · **Dono**: Maurício · decisão EXECUTAR /
  REAGENDAR / CANCELAR; silêncio ⇒ quem tiver o bastão abre
  `🟠 ADR-008 venceu sem decisão do dono`.
- **DESACOPLADO da V206**: nenhum passo lê/escreve `src/vba/` ou workbook;
  estado de release não é condição em lugar nenhum.
- **Firewall humano-aplicado (0022)**: TODA escrita — canônico, cópia,
  Credenciamento — é do humano via runbook §9. IA fez 1 comando read-only.
- **Bloco A (agora → 29/06)**: hearback desta proposta → cross-audit
  Codex+Antigravity → ajustes. Nada aplicado.
- **Bloco B (na decisão do dono)**: runbook §9, R0→R12, commit por etapa.
  No dia 30 a decisão é "aplicar patches já auditados", não "fazer um
  projeto".

---

## §9 — APPLY-RUNBOOK (humano executa, pós-hearback; entregável d)

> Um commit por etapa. Se aparecer `.git/index.lock` órfão no canônico, é o
> humano que roda `rm -f usehbn/.git/index.lock` — IA não toca git do
> canônico. Comandos a partir de `~/Projetos`.

```bash
# R0 — pré-cheque (read-only): rerodar o diff §0 e conferir IGUAL=0 DIVERGE=1 SO-COPIA=109
# R1 — tag de backup no Credenciamento
cd ~/Projetos/Credenciamento && git tag pre-adr008-migration && cd ..

# R2 — completar o canônico (tabela §2; ZERO fusão). Esqueleto:
cd ~/Projetos/usehbn
mkdir -p modules radar methodology/study-plans methodology/templates \
         auditoria/decisions auditoria/case-studies auditoria/prompts docs
cp -R ../Credenciamento/usehbn/modules/. modules/
cp -R ../Credenciamento/usehbn/radar/. radar/ && rm -f radar/_per-technology/.gitkeep
cp -R ../Credenciamento/usehbn/study-plans/. methodology/study-plans/ \
  && rm -f methodology/study-plans/.DS_Store
for f in MINIMALISM-PRINCIPLE SUBSTRATO-SOLIDO-PRINCIPLE AI-LANGUAGE-ABSTRACTION-PRINCIPLE \
         USEHBN-MODULES-ARCHITECTURE THREE-TREES-ARCHITECTURE CROSS-IA-AUDIT-PROTOCOL \
         RADAR-PHAGOCYTOSIS-PIPELINE RADAR-WEEKLY-REVIEW-PROTOCOL \
         INCORPORATION-PROGRESSIVE-PLAN INTER-CHAT-COORDINATION; do
  cp "../Credenciamento/usehbn/methodology/$f.md" methodology/; done
cp ../Credenciamento/usehbn/methodology/LANGUAGE-PLATFORM-COMPARISON.md auditoria/decisions/
cp ../Credenciamento/usehbn/site/PROPOSTA-MELHORIA-USEHBN-ORG.md auditoria/decisions/SITE-PROPOSTA-2026.md
cp ../Credenciamento/usehbn/docs/INTEGRATION-VBA-IMPORTER.md docs/
cp ../Credenciamento/usehbn/docs/PHAGOCYTOSIS-VBA-PATTERNS.md auditoria/case-studies/CREDENCIAMENTO-VBA-PATTERNS.md
# audits/: 3 relatórios → auditoria/00_status/ (prefixo seguinte: 12_, 13_, 14_);
# ESCOLHER 1 PROMPT-* → methodology/templates/CROSS-AUDIT-TEMPLATE.md; os 5 restantes
# NÃO copiar (decisão E.3 ratificada 2026-05-10) — registrar no corpo do commit.
# NÃO copiar methodology/PRINCIPIOS-CONSTITUCIONAIS.md (adjudicação §2.2 — canônico vence).
git add -A && git commit -m "[hbn] ponte 20260610-233218 R2: completar canônico — 106 SÓ-CÓPIA promovidos (modules/, radar/, study-plans/, audits/, docs/, site/); PRINCIPIOS adjudicado canônico-vence; E.3 aplicada; lixo descartado"

# R3 — split do 0022 (D1): criar usehbn/methodology/FIREWALL-ORQUESTRACAO.md
#      (estrato genérico do 0022, verbatim) e editar o 0022 do Credenciamento
#      para binding local apontando o snapshot. Commit em cada repo.
# R4 — MD-K v2: atualizar contagens (56 fichas, não 60) + marcar matriz executada.
# R5 — instalar scripts §3.1-3.3 (criar arquivos com os corpos desta proposta;
#      chmod +x usehbn/bin/*.sh Credenciamento/scripts/hbn-guards/assert-snapshot-integrity.sh)
#      + criar usehbn/VERSION com a versão do protocolo (hoje: 0.3.0).
# R6 — fetch do snapshot:
bash ~/Projetos/usehbn/bin/usehbn-fetch.sh 0.3.0 --target ~/Projetos/Credenciamento
# R7 — verify verde + TESTES NEGATIVOS T2 (mutar/restaurar) ANTES do commit do snapshot.
# R8 — tombstone + trava:
cd ~/Projetos/Credenciamento
git rm -r usehbn/ && mkdir usehbn   # README do §5.1 dentro
# adicionar entradas §5.2 ao .hbn/forbidden-paths.txt
git add -A && git commit -m "[hbn] ponte R8: tombstone usehbn/ + forbidden-paths (tag de rollback: pre-adr008-migration)"
# R9 — AGENTS.md: router §6 no topo + item 16 + varredura T1 no mesmo commit.
# R10 — rodar T1-T4 (§7); colar outputs em usehbn/auditoria/00_status/.
# R11 — atualizar STATE dos dois repos (proposta §10).
# R12 — hearback final → ADR-008 marcado EXECUTADO.
```

Rollback: `git checkout pre-adr008-migration` no Credenciamento;
`git revert` por commit no canônico (tudo aditivo até R8).

---

## §10 — STATE PROPOSTO da onda-ponte (entregável e)

Substituição proposta para os campos de onda do `usehbn/.hbn/relay/STATE.md`
(o humano aplica junto com o hearback desta proposta; campos não listados
permanecem):

```yaml
onda_atual: "ponte usehbn⇄Credenciamento — plano consolidado depositado (20260610-233218); aguardando cross-audit e hearback"
proprietario_bastao: claude-fable-5
papel_bastao: arquiteto (onda serial — sem escrita_paralela)
proxima_acao: "cross-audit Codex (OpenAI) + Antigravity (Google) da proposta 20260610-233218; depois hearback Maurício; aplicação SÓ via runbook §9 pelo humano"
atribuicao:
  chapeu_atual: arquiteto
  implementador: claude-fable-5 (propose-only — nenhum artefato aplicado)
  auditores: [codex, antigravity-gemini]   # G-FAM: nenhum auditor Anthropic
  gravada_em: "2026-06-10T23:32:18-03:00"
  hearback_ref: pendente (este depósito)
sinais_abertos_adicionar:
  - "🔵 HBN HANDOFF READY — ponte consolidada 20260610-233218 pronta para cross-audit"
  - "🟡 diff 5-estados fresco: IGUAL=0, DIVERGE=1 (PRINCIPIOS — cópia é estado PRÉ-MD-F, canônico vence), SÓ-CÓPIA=106, FORA-DA-MATRIZ=3, SÓ-CANÔNICO=30; canônico INCOMPLETO — não espelhar antes do §2"
  - "🟡 dívidas registradas: fusões MD-K adiadas (MARCADORES, SEGURANCA, INTEGRATION-VBA-IMPORTER, PHAGOCYTOSIS-PIPELINE, INCORPORATION-PLAN — gatilho: ciclo pós-ponte, dono: arquiteto useHBN); triagem knowledge 0011-0021 via inbox; hbn doctor checks MD-I §E; vendorizar verify no guard v1.1"
  - "🟠 abrir em 2026-06-30 se sem decisão: ADR-008 venceu sem decisão do dono"
```

---

## §11 — TEMPLATE de veredito para o cross-audit (facilitação)

Para cada item §0-§10, Codex e Antigravity classificam:
**BLOQUEADOR** (impede hearback) / **FORTE** (corrigir antes de aplicar) /
**MARGINAL** (nota) / **OK**. Pontos onde explicitamente PEÇO escrutínio:

1. §0 achado 1 — confirmar lendo o diff integral que a cópia do PRINCIPIOS
   é estado pré-MD-F (adjudicação "sem resgate" depende disso).
2. §1-D1 — o split do 0022 preserva a semântica? Comparar verbatim.
3. §3.1/3.2 — determinismo do manifest (JSON canônico, ordenação por bytes
   UTF-8) está conforme MD-I §B.2? Rodar mentalmente o caso docx binário.
4. §3.3 — o guard cobre rename/delete staged? (`--diff-filter=ACMRD` cobre;
   confirmar.) CI com `GIT_REF=HEAD` equivale ao pre-commit?
5. §5.2 — globs do forbidden-paths bloqueiam também o README do tombstone
   (intencional pós-R8: tombstone congela). Aceitável?
6. §7-T3 — gabarito fechado suficiente contra "teatro de teste"?

## DONE-check

(a) diff 5-estados RODADO com números frescos e 2 correções de narrativa;
(b) lista exata dos 107 que entram no canônico, com destino e ação por
arquivo/grupo; (c) corpos dos 3 scripts MD-I propostos com `path:`;
(d) apply-runbook humano R0-R12 com rollback; (e) STATE da onda proposto
com bastão, atribuição cross-família e proxima_acao = cross-audit.
Propriedade do 0022 decidida (usehbn dono; cópia vira binding). Tudo
propose-only; gatilho 30/06, dono Maurício, desacoplado da V206.

## Versão

- v1.0 — 2026-06-10T23:32:18-03:00 — claude-fable-5 (arquiteto, onda
  serial) — consolidação das 3 propostas cross-família + diff real +
  preparação completa. Numeração G-NUM pelo created_at real.
