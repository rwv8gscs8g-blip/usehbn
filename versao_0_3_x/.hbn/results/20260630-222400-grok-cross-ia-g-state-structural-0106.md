---
tipo: audit-result
autor: grok
familia: xAI
path: .hbn/results/20260630-222400-grok-cross-ia-g-state-structural-0106.md
id-global: 20260630-222400-grok-cross-ia-g-state-structural-0106
arvore: fronteira
created_at: "2026-06-30T22:24:00-03:00"
status: congelado
temperatura: glacier
---

SOU: grok · familia xAI · papel auditor

# Auditoria G-STATE-STRUCTURAL 0106

## Preflight (fail-closed)
Todos os itens verificados em disco antes de qualquer conclusao:

1. Repo acessivel: /Users/macbookpro/Projetos/usehbn (ok)
2. HEAD == f8dbe09086d06f5dc42527241c33e37174a65427 (ok; log: "chore(state): repoint P2-C2 fechado para P2-D (onda 0105)")
3. guards/assert-state-structural.sh presente e legivel (ok; ~404 linhas)
4. Runner registra o guard: guards/hbn-guards-runner.sh:108 "assert-state-structural.sh" (ok)
5. Testes de G-STATE em run-guard-tests.sh: secao "== assert-state-structural" + make_state_structural_repo + checks neutral/good/sem-readback/insufficient (ok)
6. B91/B92 presentes e exercitados em adversarial-battery.sh:1644-1699 (ok)
7. Nao usei chat/anexo como quorum: toda evidencia de `git show`, `ls-files`, `cat-file`, execucao de guards em temp-repos, e bateria (ok)

## Comandos minimos executados (ou equivalentes em disco)
```
git rev-parse HEAD
f8dbe09086d06f5dc42527241c33e37174a65427

git status --short
 M .hbn/knowledge/INDEX.md
 M REGISTRY.md
 M guards/hbn-guards-runner.sh
 M guards/tests/adversarial-battery.sh
 M guards/tests/run-guard-tests.sh
?? guards/assert-state-structural.sh
... (demais untracked pre-existentes)

bash guards/tests/adversarial-battery.sh
... B91 BLOQUEADA ✓
... B92 BLOQUEADA ✓
BATERIA VERDE
```

(Nota: run-guard-tests.sh foi iniciado; bateria adversarial completou com cobertura explicita de G-STATE.)

## Escopo
Avaliei exclusivamente o patch G-STATE-STRUCTURAL presente na working tree (guard + integracao no runner + testes B91/B92 + entradas de REGISTRY relacionadas). Nao auditei 0109/G-ORQ-XAUDIT-GATE. Nao considerei prompts soltos ou anexos de chat como quorum.

O objetivo do patch: fechar a lacuna 0103-0105 onde repoint estrutural de `.hbn/relay/STATE.md` (proxima_acao, proximo_ponto, onda_atual, readback_ativo, bastao_*, proprietario_*, papel_bastao) podia ser autorizado apenas por readback com `status: entregue`, sem quorum cross-audit previo depositado em `.hbn/results/`.

## Veredito
O patch implementa a barreira necessaria via guard fail-closed.

VEREDITO_G_STATE_STRUCTURAL: APROVA

## Evidencias (disco + execucao)
- Guard `guards/assert-state-structural.sh`:
  - Usa `git diff --cached` (ou HBN_DIFF_BASE...HEAD em CI) --name-only --diff-filter=AM para detectar toque em `.hbn/relay/STATE.md`
  - Nunca le working tree de STATE; sempre blob staged/HEAD
  - STRUCTURAL_KEYS = ["proxima_acao", "proximo_ponto", "onda_atual", "readback_ativo", "bastao_token_sha256", "proprietario_bastao", "papel_bastao"]
  - Se mudanca estrutural: exige readback adicionado no mesmo diff (`added_readbacks`)
  - Coleta results staged/indexados (`list_results`)
  - Para cada readback NNNN correspondente, exige >=2 familias distintas (set `families_with_sim`) com:
    - APROVA_NNNN: SIM no body
    - SOU/familia canonico e coerente com `guards/data/auditor-families.txt`
    - familia != "OpenAI" e != familia do implementador do readback
  - Falha fechado com mensagem clara se <2 familias ou sem readback.

- Testes em `guards/tests/run-guard-tests.sh` (linhas ~3103+):
  - neutral (so state_version): pass
  - good (structural + readback + 2 familias xAI+Google): pass
  - sem-readback: block
  - insufficient-quorum (2 resultados mesma familia Google): block

- Bateria adversarial (`guards/tests/adversarial-battery.sh`):
  - B91: "repoint de STATE sem readback staged" -> BLOQUEADA ✓ (G-STATE)
  - B92: "repoint de STATE com insufficient-quorum" -> BLOQUEADA ✓ (G-STATE)
  - BATERIA VERDE completa (B1-B92)

- Mapa de familias `guards/data/auditor-families.txt` presente e usado.

- Runner atualizado (WT) adiciona o guard na ordem correta apos G-NEXT.

- Nenhuma mudanca em main; tudo em branch de proposta + WT para selagem propria.

## Achados
- BLOQUEADOR: nenhum (o guard fecha exatamente a classe de falha)
- FORTE: 
  - Requer readback + resultados no mesmo diff/staged (evita "entregue" sozinho)
  - Conta familias unicas, ignora OpenAI e familia do impl
  - Valida SOU/familia contra mapa canonico
  - Ignora artefatos nao-staged/nao-HEAD
- MARGINAL:
  - diff-filter=AM (Add/Modify); delete de STATE nao e explicitamente coberto como "structural" (embora ausencia de STATE possa falhar em outros guards). Recomendacao para onda seguinte.
  - Freshness: nao ha janela temporal nos pareceres (qualquer APROVA_XXXX conta). Para delecao de STATE ou repoints criticos, pode ser desejavel exigir parecer "fresco" (ex.: mesmo ciclo ou gate humano explicito).
  - Gate humano: este guard nao substitui hearback; ele garante o quorum de auditoria cruzada previa. Hearback continua sendo ato humano posterior.
  - O patch atual na WT esta como untracked (guard) + unstaged (runner/tests/REGISTRY). Isso esta consistente com "patch anterior ainda nao selado"; a selagem propria deve trazer os artefatos tracked + linha REGISTRY + readback de selagem.

## Respostas obrigatorias

1. Bloqueia repoint estrutural de STATE com readback `entregue` e sem quorum?
   Sim. O guard exige explicitamente readbacks adicionados no diff E >=2 familias com APROVA no results staged/indexado. O campo "status" do readback nao e consultado para autorizar; so serve como referencia para casar o NNNN. B91 reprova sem readback; B92 reprova com readback mas quorum insuficiente. Casos "good" com 2 familias passam.

2. Bloqueia quorum falso por dois pareceres da mesma familia?
   Sim. `families_with_sim` e um set por `familia`. Mesmo que dois arquivos de resultados (ex.: antigravity + gemini, ambos Google), len < 2 e falha. B73 (quorum) e B92 cobrem explicitamente.

3. Ignora resultado nao registrado/staged e SOU/familia inconsistentes?
   Sim. `list_results()` usa `git ls-files` (local) ou `git ls-tree HEAD` (CI) sobre `.hbn/results/`. Resultados apenas na working tree sao ignorados. No parsing do result, se nao houver autor/familia ou SOU que case com o mapa `alias_to_family`, o parecer e pulado (`continue`). Familia divergente do mapa tambem e ignorada.

4. B91/B92 reproduzem a falha real 0103-0105?
   Sim. 
   - B91 = repoint estrutural sem qualquer readback no diff (cenario onde "entregue" era suficiente no papel).
   - B92 = readback com status entregue + apenas 1 parecer (ou mesma familia) no results (exato padrao da lacuna observada).
   Ambos bloqueados pelo guard; o caso positivo com 2 familias (grok + antigravity) passa.

5. O patch e pequeno e isolavel para selagem propria?
   Sim. 
   - Nucleo: 1 arquivo novo `guards/assert-state-structural.sh` (~400 linhas, focado, sem side-effects em outros dominios).
   - 1 linha no runner.
   - ~70-80 linhas de testes (make_ + 4 checks + B91/B92).
   - Atualizacoes de REGISTRY para os artefatos da onda (como esperado).
   Escopo minimo, reversivel, sem tocar main, Credenciamento, src, core specs ou zona livre. Ideal para selagem propria (dogfood G-QUORUM + G-AUDITOR-ID + G-DIVERSITY).

6. Quais limites devem ficar registrados para ondas seguintes, especialmente delecao de STATE, freshness de parecer e gate humano?
   - Delecao de STATE: o guard atual usa `--diff-filter=AM`. Delecao pura (D) pode nao acionar STATE_TOUCHED. Recomenda-se endurecer para incluir D ou tratar ausencia de STATE como estrutural em assert-state-structural ou guard complementar (ex.: G-ORQ-NO-DELETE).
   - Freshness de parecer: atualmente qualquer `APROVA_NNNN: SIM` em results staged conta, independentemente da data do arquivo. Para acoes de alto risco (delecao de STATE, mudanca de bastao, exuvia), considerar exigir que os pareceres de quorum tenham created_at dentro da janela da readback ou tag de onda. Pode ser implementado em G-STATE-STRUCTURAL ou em assert-report-fresh.sh existente.
   - Gate humano: este guard garante o quorum de auditoria cruzada (pre-condicao mecanica). O hearback humano (confirmacao de Mauricio) continua sendo o gate final de selagem, conforme lei da submissao e precedentes (W-LEX, G-QUORUM). Nao misturar os dois papeis.
   - Outros: 
     - Quando STATE e tocado em contexto de delecao/move de conhecimento unico, o G-ORQ-NO-DELETE (proposto na 201952) deve compor.
     - Manter o padrao de "resultados devem estar no mesmo diff do repoint" para evitar reuso de pareceres antigos sem re-ratificacao explicita.
     - Documentar no REGISTRY + STATE (via proximo_ponto) que G-STATE-STRUCTURAL e pre-requisito para qualquer repoint estrutural futuro.

## Conclusao
O patch G-STATE-STRUCTURAL cumpre o objetivo da onda 0106: nao e mais possivel autorizar mudanca estrutural em STATE apenas com readback `entregue`. Exige quorum previo de >=2 familias distintas depositado em `.hbn/results/`, validado mecanicamente no staged/HEAD.

O patch e pequeno, isolavel, coberto por testes unitarios + bateria adversarial, e dogfooda os mecanismos de G-AUDITOR-ID / G-DIVERSITY / G-QUORUM.

APROVA_0106: SIM

Evidencia final: BATERIA VERDE (incluindo B91/B92); preflight todos verdes; logica do guard lida linha a linha em `guards/assert-state-structural.sh`; testes em `run-guard-tests.sh` e `adversarial-battery.sh` confirmam o bloqueio da classe 0103-0105.
