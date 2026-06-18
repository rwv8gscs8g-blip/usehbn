# 04 — Prontidão do repositório para uma transição segura via GitHub

**NÃO-NORMATIVO (fronteira) — insumo de pré-transição**

- **Autor:** auditor read-only (engenheiro de release/segurança), sessão Cowork
- **Data:** 2026-06-17
- **Contato:** mauriciozanin@gmail.com

**Resumo (3 linhas).** O repositório já tem boa parte da casca de transição GitHub pronta — Apache 2.0, DCO documental, CI HBN Shield com guards+pytest, badge `213/213` *honesto* (confere com `pytest --collect-only`), `.gitignore` cobrindo segredos/`.venv`/state efêmero, e zero segredo/PII literal versionado. Os buracos são de *governança e portabilidade*: falta CODEOWNERS, templates de PR/issue, check DCO em CI (admitidamente fase 2), Dependabot, e documentação da branch protection (passkey/biometria/ruleset) — que hoje **não existe em nenhum `.md`**. O risco de quebra num clone novo é concreto e localizado: `.hbn/canonical-root` carrega o caminho absoluto `/Users/macbookpro/Projetos/usehbn`, que trava os commits locais de qualquer outra máquina/usuário (CI está imune por design).

> Truth Barrier respeitado: toda afirmação abaixo traz `arquivo:linha` ou `comando + saída`. Relatório autossuficiente; nada foi commitado; nenhum arquivo rastreado foi tocado; este é o único arquivo novo.

---

## 0. Método e baseline

```
$ git ls-files | wc -l
609

$ git branch --show-current
proposta/reestruturacao-m-a-s0          # NÃO está em main — auditoria segura

$ git remote -v
origin  https://github.com/rwv8gscs8g-blip/usehbn.git (fetch)
origin  https://github.com/rwv8gscs8g-blip/usehbn.git (push)
```

Observação de contexto: a "transição GitHub" **já está parcialmente em curso** — existe `origin` apontando para `github.com/rwv8gscs8g-blip/usehbn`, e o README usa exatamente essa URL no quickstart (`README.md:13`). Logo, o que se avalia aqui é a *prontidão da casca para um clone novo nascer seguro*, não um greenfield.

Distribuição do versionado (top): `.hbn/` 272, `guards/` 53, `docs/` 47, `src/` 43, `methodology/` 32, `tests/` 31. O peso em `.hbn/` (evidência de governança/cross-IA) é deliberado — ver §3 e §6.

---

## 1. O que está versionado, `.gitignore` e risco de segredo/PII

### 1.1 `.gitignore` — cobertura (bom)
`.gitignore` (raiz) cobre os eixos certos:
- caches/build: `.pytest_cache/`, `__pycache__/`, `*.egg-info/`, `dist/`, `build/`, `htmlcov/`, `.coverage`
- ambiente de máquina: **`.venv/`** e `.usehbn/` (confirmado: `git ls-files | grep -c '^\.venv/'` → `0`, NÃO rastreado)
- state efêmero do runtime: `.hbn/manifest.json`, `.hbn/state.json`, `.hbn/readbacks/`, `.hbn/results/*`, `logs/*.json`, `state/*.json`, `tmp/`, `temp/`, `*.log`
- scratch de guards: `guards/tests/cr-*`, `guards/tests/adv-cr*`, `guards/tests/tmp-pass.*`, `guards/tests/wt-main.*`
- per-developer: `.claude/settings.local.json`
- lixo macOS/Office: `.DS_Store`, `~$*`, `/scratch/` (com `!/scratch/README.md`)

Detalhe sofisticado e correto: `.hbn/results/*` é ignorado, **mas** há *allowlists* explícitas para preservar evidência permanente de auditoria — `!.hbn/results/*-cross-ia-*` e o padrão carimbo `!.hbn/results/[0-9]{8}-[0-9]{6}-*` (ADR-025). Ou seja: ERPs efêmeros saem, evidência cross-IA fica. `state/` e `logs/` mantêm `.gitkeep` versionado e o resto ignorado — estrutura preservada, conteúdo volátil fora. **Avaliação: ótimo.**

### 1.2 Segredo / PII versionado (sem achado material)
```
$ git ls-files | grep -iE "env|secret|key|token|cred|\.pem|password"
docs/CASE-STUDY-CREDENCIAMENTO.md
guards/assert-baton-token.sh
guards/forbid-env-files.sh
inbox/credenciamento/20260610-01-0017-parametrica.md
inbox/credenciamento/20260610-44-freeze-gate-v206.md
inbox/credenciamento/20260610-56-complemento-seguranca-pii.md
inbox/govflow/20260610-58-credenciais-orfas-descomissionamento.md
methodology/adr/ADR-008-migracao-snapshot-credenciamento-v2.md
methodology/adr/ADR-008-migracao-snapshot-credenciamento.md
```
Inspeção dos suspeitos diretos por padrões de segredo literal (`password|secret=|token=|api_key|BEGIN ... PRIVATE KEY|aws_|sk-…`):
- `guards/forbid-env-files.sh` — é o **guard que recusa** `.env`/`*.pem`/`*.p12`/chaves (cabeçalho L1-9); zero segredo.
- `guards/assert-baton-token.sh` — fala *sobre* token de posse do bastão; por construção o segredo vive só em `.git/hbn-baton-token` (fora do versionamento) e o STATE versiona apenas o **sha256/fingerprint** (L31-44). Zero segredo literal.
- `inbox/.../complemento-seguranca-pii.md` — documento *sobre* PII, sem PII.

**Conclusão: nenhum segredo nem PII literal versionado.** Os matches são guards e documentos que *tratam de* segurança/credenciamento. PII residual a vigiar (severidade baixa, decisão do dono): o nome completo do autor "Luis Mauricio Junqueira Zanin" e o e-mail/identidade do gate humano aparecem em metadados (`setup.cfg:author`, README, trailers `HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)`) — isso é *autoria pública intencional*, não vazamento.

---

## 2. `.github/` — CI, templates, CODEOWNERS

```
$ git ls-files | grep '^\.github/'
.github/workflows/hbn-shield.yml
.github/workflows/pages.yml
```

### 2.1 O que existe (bom)
**`.github/workflows/hbn-shield.yml`** — o "portão verde". `permissions: contents: read` (mínimo correto). Dois jobs:
- `guards` — `bash guards/hbn-guards-runner.sh` com `fetch-depth: 0` e `HBN_DIFF_BASE` derivado de `pull_request.base.sha || github.event.before`.
- `tests` — `setup-python@v5` (3.12), `pip install -e . || true`, `python -m pytest tests -q`.
- Dispara em `push:[main]`, `pull_request`, `workflow_dispatch`.

**`.github/workflows/pages.yml`** — deploy de `site/` para GitHub Pages, permissões certas (`pages: write`, `id-token: write`), concurrency com cancel-in-progress.

### 2.2 O que falta (lacunas de governança)
| Item | Estado | Severidade |
|---|---|---|
| `CODEOWNERS` | **ausente** (`git ls-files \| grep -i codeowners` → vazio) | **Alta** — sem ele, branch protection "require review from code owners" não tem âncora |
| `PULL_REQUEST_TEMPLATE.md` | **ausente** | Média — PR sem checklist de readback/DCO/guards |
| `ISSUE_TEMPLATE/` | **ausente** | Baixa |
| `dependabot.yml` | **ausente** | Média — sem alerta de CVE em deps |
| `DCO check` em CI | **ausente** e **declarado fase 2** (`CONTRIBUTING.md:81-82`: *"DCO enforcement in CI … is **phase 2** and will be activated in a future release. For now, the requirement is documental."*) | Média — coerência ok, mas é um gate prometido e não entregue |
| `hbn-shield` status | `status: proposed (C3 2026-06-10, aguardando hearback)` (cabeçalho do yml) | Informativo — o gate ainda não foi ratificado por hearback |
| `pip install -e . \|\| true` | tolera falha de install silenciosamente | Média — se o pacote quebrar o install, os testes podem rodar contra um ambiente parcial e ainda assim "passar" o passo de install |

---

## 3. Metadados do projeto (coerência)

| Metadado | Fonte | Valor |
|---|---|---|
| LICENSE | `LICENSE:1` | Apache License 2.0 |
| Nome/versão | `setup.cfg:metadata` | `usehbn`, `version = 0.3.0`, `license = Apache-2.0` |
| `__version__` | `src/usehbn/__init__.py:8` | `0.3.0`; `PROTOCOL_VERSION = "0.3.0"` (`:10`) — alinhados |
| Entry points | `setup.cfg` | `hbn` e `usehbn` → `usehbn.cli:main` |
| DCO | `CONTRIBUTING.md:62-82` | exigido documentalmente (`git commit -s`), enforcement em CI = fase 2 |
| ADR de licença | `methodology/adr/ADR-005-licenciamento-apache-cla.md` | migração AGPLv3 → Apache 2.0 (2026-05-10) |

### 3.1 Badge `213/213` — **HONESTO** (correção de uma suspeita)
README declara em dois lugares: `README.md:5` ("Tests: 213/213") e o badge `Tests-213/213` (`README.md:7`). Uma contagem ingênua de `def test_` dá **195**, o que sugeriria badge inflado — mas é artefato de parametrização:
```
$ python3 -m pytest tests --collect-only -q | tail -1
213 tests collected in 0.09s
```
A diferença (195 funções → 213 casos) vem de `tests/test_cli_golden_contract.py` (único arquivo com `parametrize`). **O badge confere com a suíte real.** Severidade: nenhuma — registra-se aqui apenas para encerrar a dúvida com prova.

Ressalva de *drift*, não de fraude: o histórico mostra a contagem sendo ressincronizada manualmente (`git log`: `selagem-r1: sincroniza contagem de testes 211->212`, `r1-fix2: sincroniza contagem de testes com a suite real`). O número 213 no README é um literal de manutenção manual — recomenda-se torná-lo derivado (badge dinâmico em CI) para não voltar a divergir. **Severidade: Baixa.**

### 3.2 Coerência Apache 2.0 + DCO
Coerente: Apache 2.0 (`LICENSE`, `setup.cfg`) + DCO via `Signed-off-by` (`CONTRIBUTING.md`) é exatamente o modelo CNCF/Linux. O único furo é que o repo **ainda não assina seus próprios commits com `Signed-off-by`** — os trailers atuais são `HBN-Readback` / `HBN-Human-Authorization` / `HBN-Token-FP` (ver §4), **sem** `Signed-off-by`. Se o DCO virar gate em CI (fase 2), todo o histórico recente reprova. **Severidade: Média** — decidir antes do freeze se DCO se aplica retroativamente ou só going-forward.

---

## 4. Higiene de histórico / tags

```
$ git tag -l
evidencia/orquestrador-bug-2026-06-14
evidencia/reestruturacao-m-a-s0-tree-equivalent
$ git tag -l | wc -l
2
```
- **Existem** tags `evidencia/*` (2). **NÃO existe** tag de versão estável** (`v0.3.0` não está tagueada) — lacuna para release reproduzível. **Severidade: Média.**
- Trailers seguem padrão HBN consistente (`git log -5 --format=%B`):
  ```
  HBN-Readback: 0041
  HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
  HBN-Token-FP: 34a7f2f9
  ```
  Padrão coeso e governado — porém **não inclui `Signed-off-by`** (ver §3.2). Os assuntos seguem prefixo de onda (`r1-fix2:`, `selagem-r1:`, `r1:`), legível.

---

## 5. Branch protection (passkey/biometria/ruleset)

```
$ grep -rn "branch protection|ruleset|passkey|biometr" \
    README.md CONTRIBUTING.md SECURITY.md CHANGELOG.md \
    methodology/adr/ADR-005-...md docs/LICENSING.md
(sem saída)
```
**Achado: NÃO há documentação no repositório de que a `main` exija passkey/biometria nem de qualquer *ruleset* de branch protection.** O grep amplo `--include=*.md` por esses termos retorna apenas ocorrências de "branch protection" em contextos não-relacionados (CHANGELOG genérico, ADRs de licença) e nada sobre passkey/biometria/ruleset. A política de proteção da main — se existe no GitHub — vive **só no servidor**, invisível ao clone. Para uma transição "casca nova nasce segura", isso precisa ser *documentado como código/doc* (um `docs/BRANCH-PROTECTION.md` ou seção em SECURITY.md descrevendo o ruleset esperado: required checks = `HBN Shield`, required reviewers = CODEOWNERS, signed commits, etc.). **Severidade: Alta** — é o coração da "transição segura" e hoje é tácito.

Nota: o SECURITY.md existente (`SECURITY.md:1-24`) é honesto mas mínimo — declara "early protocol scaffold", "no cryptographic guarantees", reporte privado via SUPPORT.md. Não cobre o modelo de proteção de branch/release.

---

## 6. O que vaza ou quebra num clone limpo

### 6.1 QUEBRA (alta) — `.hbn/canonical-root` com caminho absoluto de máquina
```
$ cat .hbn/canonical-root
/Users/macbookpro/Projetos/usehbn
```
Esse arquivo é **versionado** e consumido pelo guard `assert-canonical-root.sh` (runner em `guards/hbn-guards-runner.sh:50`). Análise da lógica (`guards/assert-canonical-root.sh:38-98`):
- Em **CI real** (`GITHUB_ACTIONS=true` **E** `HBN_DIFF_BASE` não-vazio) o guard **pula** (L38-41) — então **a CI do GitHub NÃO quebra**.
- Em **commit local**, o guard exige que `git rev-parse --show-toplevel` ∈ `{canonical-root}` ∪ `.hbn/alt-roots` (L73-98), senão **`guard_fail` + exit 1** (L98: *"git toplevel (…) ≠ raiz canônica … e não consta em .hbn/alt-roots"*).

Consequência: **qualquer outro humano que clone o repo num caminho diferente de `/Users/macbookpro/Projetos/usehbn` não consegue commitar localmente** — o pre-commit barra tudo. O `.hbn/alt-roots` mitiga só o sandbox Cowork (`cat .hbn/alt-roots` → `/sessions/*/mnt/Projetos/usehbn`), não um clone arbitrário. Isso é *by design* para um repo single-operator, mas é uma **barreira dura à transição multi-colaborador**. **Severidade: Alta** para abrir contribuição; **Baixa** se o modelo permanecer single-operator.
Mitigação possível: tornar a raiz canônica derivável (ex.: marcador relativo + permitir registro de raiz por hearback) ou documentar explicitamente o passo "edite `.hbn/canonical-root` no seu primeiro commit" como parte do onboarding.

### 6.2 QUEBRA (média) — `marker_path` absoluto em connector
```
.hbn/connectors/registry.json:9:
  "marker_path": "/Users/macbookpro/Projetos/usehbn/.hbn/connectors/hbn.connector.runtime.copilot.json"
```
Ponteiro absoluto versionado de uma máquina específica; num clone novo aponta para um caminho inexistente. **Severidade: Média** (depende de quão crítico é o consumo desse marker pelo runtime de connectors).

### 6.3 VAZAMENTO COSMÉTICO (baixa) — caminhos `/Users/macbookpro/` em docs `.hbn/*.md`
`git grep -n "/Users/"` em arquivos rastreados retorna **dezenas** de ocorrências, **todas** em `.hbn/proposals/*`, `.hbn/messages/*` e `.hbn/knowledge/0001-comandos-atomicos-copiaveis.md:23` (`cd /Users/macbookpro/Projetos/usehbn`) — são *links `file://` e comandos copiáveis* de orquestração histórica. Exemplos: `.hbn/proposals/20260610-221540-codex-ponte-002-008.md` (~15 linhas com paths absolutos), `.hbn/messages/...despacho...md`. Não há **nenhum** caminho absoluto em `src/`, `tests/`, `core/` ou nos `guards/*.sh` executáveis (esses usam `SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"` — portável). **Severidade: Baixa** — não quebra nada, mas expõe a topologia de diretórios do autor e polui evidência. O próprio repo já reconhece o problema (`.hbn/proposals/0042-…md:129` discute o *"Local Path Mismatch"* de links `file://`).

### 6.4 NÃO vaza — `.venv` específico de máquina
`.venv/` existe no disco (apareceu no grep bruto) mas **não é rastreado** (`git ls-files | grep -c '^\.venv/'` → `0`, coberto por `.gitignore`). Todos os matches `/Users/`·`/home/` em `.py` vinham de dentro de `.venv/lib/...` (pip/setuptools/pytest), **fora do versionamento**. Clone limpo não traz nada disso. **OK.**

---

## A) Checklist de prontidão GitHub

### JÁ está bom
- [x] LICENSE Apache 2.0 coerente (`LICENSE`, `setup.cfg`, README badge) — **OK**
- [x] `.gitignore` cobre segredos, `.venv`, scratch, `.hbn/` state efêmero, com allowlist cirúrgica de evidência (ADR-025) — **OK**
- [x] Zero segredo/PII literal versionado (§1.2) — **OK**
- [x] Guard `forbid-env-files.sh` ativo recusando `.env`/`.pem`/`.p12`/chaves — **OK**
- [x] CI HBN Shield com guards + pytest, `permissions: contents: read` — **OK**
- [x] Badge `213/213` confere com `pytest --collect-only` (§3.1) — **OK**
- [x] DCO documentado (`CONTRIBUTING.md`) — **OK** (documental)
- [x] SECURITY.md + SUPPORT.md existem e são honestos — **OK**
- [x] `__version__`/`PROTOCOL_VERSION` alinhados em 0.3.0 — **OK**
- [x] Auditoria rodando fora da main (branch `proposta/…`) — **OK**

### FALTA (com severidade)
- [ ] **CODEOWNERS** — ausente — **Alta**
- [ ] **Doc de branch protection / ruleset / passkey** (§5) — ausente — **Alta**
- [ ] **`.hbn/canonical-root` portável** para clone multi-máquina (§6.1) — **Alta** (se abrir contribuição)
- [ ] **DCO check em CI** (prometido fase 2, `CONTRIBUTING.md:81`) + decisão sobre `Signed-off-by` retroativo (§3.2) — **Média**
- [ ] **Tag de versão estável `v0.3.0`** (só há tags `evidencia/*`) (§4) — **Média**
- [ ] **`marker_path` absoluto** em `.hbn/connectors/registry.json:9` (§6.2) — **Média**
- [ ] **dependabot.yml** — **Média**
- [ ] **PULL_REQUEST_TEMPLATE** com checklist (readback/DCO/guards verdes) — **Média**
- [ ] **Badge de testes dinâmico** (hoje literal manual, sujeito a drift) (§3.1) — **Baixa**
- [ ] Limpeza/normalização dos paths `/Users/macbookpro/` em `.hbn/*.md` (§6.3) — **Baixa**
- [ ] **ISSUE_TEMPLATE/** — **Baixa**
- [ ] Ratificar o status `proposed` do `hbn-shield.yml` (cabeçalho do yml) — **Baixa**

---

## B) CI mínima recomendada para a transição segura

Manter o `hbn-shield.yml` e adicionar/endurecer (jobs concretos):

1. **`guards`** (já existe) — `bash guards/hbn-guards-runner.sh` com `HBN_DIFF_BASE`. Manter como *required check* na branch protection.
2. **`tests`** (já existe) — endurecer: trocar `pip install -e . || true` por `pip install -e .` **sem** `|| true`, para que falha de empacotamento seja vermelha; matriz `python-version: [3.9, 3.12]` (o `setup.cfg` promete `>=3.9`, mas a CI só testa 3.12 — gap de cobertura do contrato).
3. **`dco-check`** (novo) — action que valida `Signed-off-by` em todos os commits do PR (cumpre a promessa de `CONTRIBUTING.md:81`). Decidir escopo retroativo vs going-forward antes de ligar.
4. **`adversarial`** (novo) — `bash guards/tests/adversarial-battery.sh` + `bash guards/tests/run-guard-tests.sh` (a suíte adversarial de bypass dos guards, ~89/… casos; existe no repo mas **não** está no Shield). Sem ela, a CI valida os guards mas não que os guards *resistem a burla*.
5. **`secret-scan`** (novo, defesa em profundidade) — gitleaks/trufflehog no diff do PR, complementando o `forbid-env-files.sh` (que só pega nomes de arquivo, não conteúdo).
6. **`lint/format`** (opcional) — ruff/shellcheck nos `guards/*.sh`.

Branch protection (a documentar e aplicar no servidor): required checks = `guards` + `tests` + `adversarial` (+ `dco-check` quando ligado); require review de CODEOWNERS; require signed commits; linear history; sem force-push em `main`.

---

## C) Riscos de vazamento/quebra num clone novo + mitigação

| # | Risco | Evidência | Sev. | Mitigação |
|---|---|---|---|---|
| C1 | Clone em outro caminho **não commita** (guard canonical-root) | `.hbn/canonical-root` = `/Users/macbookpro/…`; `assert-canonical-root.sh:98` | Alta | Tornar raiz derivável OU passo de onboarding "edite canonical-root no 1º commit" OU registrar alt-root por hearback |
| C2 | `marker_path` absoluto quebra connector | `.hbn/connectors/registry.json:9` | Média | Caminho relativo ao repo root |
| C3 | Paths `/Users/macbookpro/` expostos em ~dezenas de `.hbn/*.md` | `git grep -n /Users/` (só `.hbn/proposals,messages,knowledge`) | Baixa | Normalizar para relativo/genérico; nenhum executável afetado |
| C4 | Identidade/PII do autor e do gate humano em metadados | `setup.cfg:author`, trailers `HBN-Human-Authorization` | Baixa | Intencional (autoria pública); confirmar com o dono |
| C5 | Badge `213` literal pode divergir da suíte | `README.md:5,7` vs histórico de "sincroniza contagem" | Baixa | Badge dinâmico em CI |
| — | `.venv`/segredos | NÃO rastreados (`git ls-files` limpo) | — | nada a fazer (já coberto) |

**Não há vazamento de segredo material num clone novo.** Os riscos são de portabilidade (C1-C3) e de higiene/PII intencional (C4-C5).

---

## D) Sequência de melhorias antes do freeze/transição

**Leve (não-exúvia — cabe antes do freeze, baixo risco, alto retorno):**
1. Criar `CODEOWNERS` (Alta) e `docs/BRANCH-PROTECTION.md` documentando o ruleset esperado da `main` incl. passkey/biometria (Alta).
2. Taguear `v0.3.0` (Média) para release reproduzível.
3. Corrigir `marker_path` relativo (Média) e endurecer `pip install -e .` sem `|| true` + matriz 3.9/3.12 no Shield (Média).
4. Adicionar `dependabot.yml` e `PULL_REQUEST_TEMPLATE.md` (Média).
5. Ratificar via hearback o status `proposed` do `hbn-shield.yml` (Baixa).
6. Badge de testes dinâmico (Baixa).

**Exúvia (muda de casca — exige decisão de dono + readback/hearback, toca governança e história):**
7. **Portabilidade da raiz canônica** (`.hbn/canonical-root`): decidir entre permanecer single-operator (documentar o limite) ou abrir multi-colaborador (redesenhar o guard para raiz derivável). É a decisão estrutural que destrava a transição GitHub real.
8. **DCO em CI + `Signed-off-by`**: cumprir a fase 2 prometida e decidir retroatividade — afeta validade de todo o histórico recente.
9. Acrescentar `adversarial` + `secret-scan` ao Shield e elevá-los a required checks da branch protection.
10. Normalizar/expurgar paths absolutos em `.hbn/*.md` (limpeza de evidência histórica — sensível porque mexe em audit-permanent).

Ordem sugerida: 1→2→3→4 (leve, semana do freeze) ; depois 7→8→9 (exúvia, com cerimônia) ; 5,6,10 oportunísticos.

---

## Resumo executivo (8-12 linhas)

1. O repo **NÃO está em main** (branch `proposta/reestruturacao-m-a-s0`); auditoria 100% read-only; um único arquivo novo criado (este). Nada commitado.
2. `git ls-files` = 609; `.gitignore` é exemplar — cobre `.venv`, segredos, scratch e state efêmero do `.hbn/`, com allowlist cirúrgica para preservar evidência cross-IA (ADR-025).
3. **Zero segredo/PII literal versionado**: os matches de "secret/key/token" são guards e docs *sobre* segurança; o token do bastão vive fora do git (só sha256/fingerprint versionado).
4. CI existe: `hbn-shield.yml` (guards + pytest, permissões mínimas) e `pages.yml`. Status do Shield ainda `proposed`, aguardando hearback.
5. **Badge `213/213` é HONESTO** — confere com `pytest --collect-only` (213); a contagem ingênua de 195 `def test_` é só parametrização. Desfaz a suspeita de inflação.
6. Apache 2.0 + DCO coerentes; mas **DCO em CI é fase 2 (não entregue)** e os commits **não usam `Signed-off-by`** (usam trailers HBN próprios) — decisão pendente de retroatividade.
7. **Faltam: CODEOWNERS, templates de PR/issue, dependabot, tag `v0.3.0`, e — crítico — documentação da branch protection/ruleset/passkey (grep retorna vazio).**
8. **Maior risco de quebra num clone novo:** `.hbn/canonical-root` hardcoda `/Users/macbookpro/Projetos/usehbn`; o guard `assert-canonical-root` **barra commits locais de qualquer outra máquina** (CI imune por design). `alt-roots` só cobre o sandbox Cowork.
9. Risco secundário: `marker_path` absoluto em `connectors/registry.json` e paths `/Users/macbookpro/` cosméticos em ~dezenas de `.hbn/*.md` (nenhum executável afetado; `.venv` não rastreado).
10. Caminho recomendado: **leve** (CODEOWNERS, doc de branch protection, tag v0.3.0, dependabot, PR template, endurecer install/matriz) antes do freeze; **exúvia** (portabilidade da raiz canônica, DCO+signoff, adversarial+secret-scan na CI) com cerimônia de dono.
