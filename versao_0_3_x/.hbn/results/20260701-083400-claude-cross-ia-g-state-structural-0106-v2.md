---
tipo: audit-result
autor: claude
familia: Anthropic
path: .hbn/results/20260701-083400-claude-cross-ia-g-state-structural-0106-v2.md
id-global: 20260701-083400-claude-cross-ia-g-state-structural-0106-v2
arvore: fronteira
created_at: "2026-07-01T08:34:00-03:00"
status: congelado
temperatura: glacier
---
SOU: claude · familia Anthropic · papel auditor

# Auditoria G-STATE-STRUCTURAL 0106 v2

## Veredito

VEREDITO_G_STATE_STRUCTURAL: APROVA

Auditoria independente, read-only sobre o codigo. Nenhuma escrita alem deste
parecer. Nao usei o parecer xAI (grok v2) como substituto: audite o patch em
disco primeiro; a comparacao vem ao final.

## Preflight fail-closed

Todos os itens passaram:

1. Repo acessivel: `/Users/macbookpro/Projetos/usehbn` — OK.
2. HEAD = `f8dbe09086d06f5dc42527241c33e37174a65427` — igual ao esperado. OK.
3. `guards/assert-state-structural.sh` presente (untracked `??` — patch em disco,
   nao commitado). OK.
4. Runner registra o guard: `guards/hbn-guards-runner.sh:108` lista
   `"assert-state-structural.sh"` no array `GUARDS`. OK.
5. Testes de G-STATE presentes em `run-guard-tests.sh` (secao
   `== assert-state-structural (G-STATE-STRUCTURAL) ==`, linhas 3103-3300, 4 casos).
   OK.
6. B91/B92 presentes em `adversarial-battery.sh:1644-1699`. OK.
7. Nenhum uso de chat/anexo como quorum: o guard so consulta blobs
   staged/HEAD via `git` (`git ls-files` / `git ls-tree -r HEAD`, blob `:path`),
   nunca a working tree nem texto de chat.
8. Este prompt chegou integro (bloco HBN-COPY completo, um comando por vez).
9. O patch auditado e G-STATE (guard + runner + testes), NAO 0109 G-ORQ-XAUDIT-GATE.

## Evidencias

### Comandos executados (um por vez, saidas relevantes)

COMANDO 1 — `git rev-parse HEAD`:
```
f8dbe09086d06f5dc42527241c33e37174a65427
```

COMANDO 2 — `git status --short` (recorte do patch sob auditoria):
```
 M guards/hbn-guards-runner.sh
 M guards/tests/adversarial-battery.sh
 M guards/tests/run-guard-tests.sh
?? guards/assert-state-structural.sh
```
STATE nao aparece no diff de trabalho — o patch nao faz repoint de STATE, so
introduz o mecanismo que o vigia. Isolavel.

COMANDO 3 — `bash guards/tests/run-guard-tests.sh`:
```
== assert-state-structural (G-STATE-STRUCTURAL) ==
  ✓ structural: neutral change to STATE passes (esperado: pass)
  ✓ structural: structural change to STATE with quorum passes (esperado: pass)
  ✓ structural: structural change to STATE without readback -> BLOCK (esperado: block)
  ✓ structural: structural change to STATE with insufficient quorum (same family) -> BLOCK (esperado: block)
...
== resumo: 268 passaram, 0 falharam ==
SUÍTE VERDE
```

COMANDO 4 — `bash guards/tests/adversarial-battery.sh`:
```
B91 repoint de STATE sem readback staged             | G-STATE  | BLOQUEADA ✓
B92 repoint de STATE com insufficient-quorum         | G-STATE  | BLOQUEADA ✓
BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
```

### Leitura do guard (`guards/assert-state-structural.sh`)

Fluxo verificado linha a linha:

- Escopo por diff: so opina se `.hbn/relay/STATE.md` for A/M no diff
  (`state_diff_files`, `--diff-filter=AM`, linhas 30-68). Se STATE nao muda,
  `guard_ok` e sai — nao ha falso positivo (confirmado pelo caso `neutral`).
- Le blobs por referencia staged (`:path`) local ou `HEAD:path` no CI
  (`blob_ref`/`old_ref`, 38-58). Nunca le working tree (comentario 9 e uso de
  `git cat-file`/`git show` confirmam).
- Chaves estruturais (226-234): `proxima_acao`, `proximo_ponto`, `onda_atual`,
  `readback_ativo`, `bastao_token_sha256`, `proprietario_bastao`, `papel_bastao`.
  Compara new vs old; se nenhuma muda, `sys.exit(0)`.
- Se mudou e nao ha readback ADICIONADO no diff (`.hbn/readbacks/NNNN-*.json`,
  93-98, 254-256) -> BLOCK.
- Para cada readback: extrai `NNNN`, resolve `implementador_id` -> familia pelo
  mapa (`auditor-families.txt`, 341-342), e conta pareceres em `.hbn/results/`
  cujo nome termina em `-NNNN.md` (344-348).
- Consistencia SOU/familia (363-378): usa `autor`/`familia` do frontmatter, com
  fallback para a linha `SOU: <apelido> · familia <F> · papel auditor`; se
  `alias_to_family[autor] != familia`, o parecer e DESCARTADO. Bloqueia parecer
  forjado com familia declarada divergente do apelido.
- Exige `APROVA_NNNN: SIM` no corpo (351, 380).
- Conta so familias `!= OpenAI` e `!= familia do implementador` (383); usa um
  `set` de familias (384), portanto dois pareceres da MESMA familia contam como 1.
- Exige `len(families_with_sim) >= 2` (386) senao BLOCK.

## Achados

### BLOQUEADOR
Nenhum.

### FORTE (registrar como limite de ondas seguintes; NAO bloqueiam este patch)
- **Delecao de STATE nao coberta.** `--diff-filter=AM` ignora `D`. Um `git rm`
  de `.hbn/relay/STATE.md` nao aciona o guard. Fora do escopo declarado do
  0106 (repoint estrutural), mas deve ser fechado por `G-ORQ-NO-DELETE`.
- **Freshness de parecer ausente.** O guard nao amarra a aprovacao ao conteudo
  atual do STATE (nem por hash, nem por janela temporal). Um `APROVA_NNNN: SIM`
  antigo, de iteracao anterior da mesma proposta, continua contando. Aceitavel
  para fechar 0103-0105, mas e superficie residual para uma onda futura de
  freshness/binding.
- **Gate humano nao e responsabilidade deste guard.** O repoint estrutural com
  quorum de IA passa sem confirmacao humana explicita neste guard. Por desenho o
  gate humano vive em G-NEXT / G-QUORUM-SELAGEM / hearback; correto nao duplicar
  aqui, mas deve permanecer registrado como dependencia da cadeia.

### MARGINAL
- **Readback precisa ser ADICIONADO no mesmo diff.** Um repoint que reuse um
  readback ja commitado (nao re-adicionado) e bloqueado. E fail-closed
  (conservador, correto), mas operadores precisam co-stapear o readback; vale
  documentar para evitar falso-bloqueio confuso.
- **Regex de aprovacao permissiva no corpo.** `APROVA_NNNN: SIM` casa em
  qualquer linha do corpo (case-insensitive). A consistencia autor/familia + o
  match por sufixo `-NNNN.md` limitam abuso, mas um parecer que cite o token como
  exemplo poderia falso-positivar. Baixo risco.
- **Higiene do disco.** Ha diretorios untracked `guards/tests/hbn-repro-*`
  pre-existentes (resquicio de execucoes de teste). Nao afetam a logica do
  G-STATE, mas convem limpar antes de selagem para nao poluir o range.

## Respostas obrigatorias

1. **Bloqueia repoint estrutural de STATE com readback entregue e sem quorum?**
   SIM. Mesmo com readback `status: entregue` (impl `codex`/OpenAI), o guard
   exige `>=2` familias distintas != OpenAI/implementador com `APROVA_NNNN: SIM`.
   O caso `good` so passa com grok(xAI)+antigravity(Google); `sem-readback` e B91
   bloqueiam.

2. **Bloqueia quorum falso por dois pareceres da mesma familia?**
   SIM. `families_with_sim` e um conjunto de FAMILIAS. O caso `insufficient-quorum`
   e B92 usam antigravity+gemini (ambos Google) -> tamanho 1 -> BLOCK. Verificado
   no codigo (linha 384) e nas duas baterias.

3. **Ignora resultado nao registrado/staged e SOU/familia inconsistentes?**
   SIM. Resultados sao enumerados do indice/HEAD (`git ls-files`/`ls-tree`) e
   lidos por blob staged; nada de chat/anexo/working tree. Pareceres com
   `alias_to_family[autor] != familia` sao descartados (368-378).

4. **B91/B92 reproduzem a falha real 0103-0105?**
   SIM. Fixtures usam `readback_id: 0103-onda-repoint-state-p2c`,
   `implementador_id: codex` (OpenAI), `status: entregue` — exatamente a classe
   descrita na proposta 20260630-201952 (§5 e H2/H3: "readback entregue nao pode
   alterar STATE estrutural sem quorum"). B91 = sem readback; B92 = quorum
   insuficiente por mesma familia.

5. **O patch e pequeno e isolavel para selagem propria?**
   SIM. Um guard novo (`assert-state-structural.sh`), uma linha no runner
   (`hbn-guards-runner.sh:108`) e casos de teste nas duas baterias. STATE nao e
   tocado; G-STR permanece fora do runner por desenho. Selavel isoladamente antes
   de 0109.

6. **Limites a registrar para ondas seguintes.**
   - Delecao de STATE (`--diff-filter=AM` nao cobre `D`) -> `G-ORQ-NO-DELETE`.
   - Freshness/binding do parecer ao conteudo de STATE (hash/janela temporal).
   - Gate humano explicito para repoint critico permanece na cadeia
     G-NEXT/G-QUORUM-SELAGEM/hearback, nao neste guard.
   - Reuso de readback ja commitado (co-staging obrigatorio) documentado.
   - `G-ORQ-XAUDIT-GATE` (0109) para prompts de auditoria com preflight e destino
     — proxima onda, fora deste escopo.

## Comparacao com o parecer independente xAI (grok v2)

Cheguei a APROVA de forma independente, sem usar o parecer
`.hbn/results/20260630-223400-grok-cross-ia-g-state-structural-0106-v2.md` como
substituto. Concordo com o SIM da xAI. Nao ha divergencia material de veredito.
O parecer grok v1 (`...-222400-...`) veio de prompt v1 superseded e nao foi usado
como evidencia de quorum, conforme instruido. Nota: este e um segundo parecer de
familia distinta (Anthropic) — mas o quorum formal de selagem e responsabilidade
de G-QUORUM no ato de commit, nao deste parecer.

## Conclusao

O patch G-STATE-STRUCTURAL fecha a lacuna 0103-0105: mudanca estrutural de
`.hbn/relay/STATE.md` deixa de ser autorizavel apenas por readback `entregue` e
passa a exigir quorum de auditoria cruzada (>=2 familias distintas !=
OpenAI/implementador) registrado em `.hbn/results/`. Testes e bateria adversarial
sustentam a afirmacao (268/268 verde; B91/B92 bloqueadas). Achados FORTE/MARGINAL
sao limites de ondas seguintes, nao defeitos desta selagem.

APROVA_0106: SIM
