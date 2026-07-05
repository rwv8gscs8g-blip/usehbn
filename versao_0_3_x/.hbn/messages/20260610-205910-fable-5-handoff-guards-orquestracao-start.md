---
titulo: Handoff — metade 2 da orquestração-start: 4 guards implementados e provados por teste negativo
tipo: handoff
status: congelado
temperatura: glacier
id-global: 20260610-205910-fable-5-handoff-guards-orquestracao-start
path: .hbn/messages/20260610-205910-fable-5-handoff-guards-orquestracao-start.md
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, janela limpa — metade 2 do ADR-024)
hearback-status: aguardando humano
relacionado: [methodology/adr/ADR-024-orquestracao-start.md, core/start-rite-spec.md, core/pointer-spec.md, core/state-report-spec.md, guards/tests/run-guard-tests.sh]
---

# Metade 2 da orquestração-start — G-STR, G-NUM, G-PTR, G-RLT

Os 4 guards especificados na metade 1 (ADR-024, commitada em e47bd81) agora
existem como `.sh` em `guards/`, cada um conforme sua spec, cada um lendo o
BLOB STAGED (`git show :path` local; `HEAD:path` em CI — lição E-FECH-01/02)
onde há staged a ler, e cada um nascendo com teste negativo verde na suíte
(ADR-020). G-STR é a exceção documentada: recebe a atribuição por argumento
porque o insumo é o JSON impresso pelo rito ANTES de existir como blob
(forma fixada na start-rite-spec §4; mesmo padrão do G-FAM, a quem delega).
NENHUM guard entrou no runner; D2 e D6 seguem doutrina-sem-enforcement
(backlog declarado no ADR-024) — nenhum guard foi criado para eles. Nada foi
commitado: o trabalho está STAGED para o gate humano.

## Entregue

⟦HBN⟧ guards/assert-start-cast.sh · sinal: 🔵 HBN HANDOFF READY · ação: auditar contra start-rite-spec §4 (delegação G-FAM + orquestrador apto + escrita_paralela ⊆ elenco)
⟦HBN⟧ guards/assert-parallel-id.sh · sinal: 🔵 HBN HANDOFF READY · ação: auditar contra start-rite-spec §5 e validar as 2 interpretações registradas no header
⟦HBN⟧ guards/assert-pointer-honest.sh · sinal: 🔵 HBN HANDOFF READY · ação: auditar contra pointer-spec §3 (escopo: .hbn/messages/ e docs/prompts/)
⟦HBN⟧ guards/assert-report-fresh.sh · sinal: 🔵 HBN HANDOFF READY · ação: auditar contra state-report-spec §4 (fecha o triângulo com o guard-state-fresh)
⟦HBN⟧ guards/tests/run-guard-tests.sh · sinal: 🟢 · ação: rodar no Terminal e conferir 59/59 (33 legados + 26 novos)

Fixtures novas: `guards/tests/fixtures/models/gamma-1.json` e
`guards/tests/fixtures/atribuicoes/{good-cast-serial,bad-orq-sem-aptidao,bad-paralelo-forasteiro}.json`
(sintéticas, padrão ADR-020). REGISTRY: 5 linhas novas no bloco de 6 colunas,
todas com `created_at` cujo HHMMSS deriva do mesmo carimbo do id (Decisão 5.4).

## Testes negativos (a prova de que cada guard BLOQUEIA o caso ruim)

- G-STR: groupthink sem hearback → BLOCK ✓ · orquestrador sem papel apto → BLOCK ✓ · escrita_paralela com forasteiro → BLOCK ✓
- G-NUM: AAAAMMDD-NN em ciclo paralelo (colisão 0001×0001) → BLOCK ✓ · agente fora de escrita_paralela → BLOCK ✓ · linha REGISTRY sem created_at → BLOCK ✓ · created_at ≠ HHMMSS do id → BLOCK ✓ · skew staged×worktree → BLOCK ✓
- G-PTR: path inexistente no staged → BLOCK ✓ · path ≠ front-matter do destino → BLOCK ✓ · linha sem ação: → BLOCK ✓ · destino só na working tree (skew) → BLOCK ✓
- G-RLT: handoff sem relato → BLOCK ✓ · proxima_acao parafraseada → BLOCK ✓ · ultima_atualizacao de memória → BLOCK ✓ · orquestrador sem cápsula → BLOCK ✓ · STATE staged velho (skew) → BLOCK ✓
- Compatibilidade (risco R5 do ADR-024): linha de 6 colunas com created_at continua passando no grep do G-REG ✓

Suíte completa: **59 passaram, 0 falharam** (repos descartáveis em /tmp via
mktemp; verde em sandbox = informativo; conclusivo no Terminal — knowledge 0021).

## Dogfood (os 4 guards contra o próprio diff staged desta onda)

Resultado registrado abaixo do relato; o comando para reproduzir no Terminal:
`for g in start-cast parallel-id pointer-honest report-fresh; do bash guards/assert-$g.sh; done`
(G-STR dispensa diff: `bash guards/assert-start-cast.sh <atribuicao.json>` — o
dogfood usou a fixture `good-cast-serial.json`.)

## Interpretações registradas para o cross-audit (Codex + Antigravity)

1. G-NUM, "pasta de série não-local": proxy adotado = `.hbn/proposals/`,
   `.hbn/messages/`, `.hbn/results/`, `reports/`, `docs/prompts/` (o diff não
   tem autor; a pasta é o proxy de escrita paralela). Séries locais estáveis
   (ADR-NNN, knowledge NNNN, core/*.md) isentas da regra 1, por ADR-024 D5.2.
2. G-NUM, `escrita_paralela`: lida do STATE STAGED, só forma inline `[a, b]`
   (a forma da start-rite-spec §3); ausente/vazia ⇒ ciclo serial.
3. G-PTR, escopo: só `.hbn/messages/` e `docs/prompts/` — specs/ADRs carregam
   exemplos de ponteiro em code fence que não são ponteiros reais.
4. G-RLT, chapéu: extraído do header do próprio relato (entre os dois
   primeiros `·`); contém "orquestrador" ⇒ cápsula obrigatória.

```
RELATO DE ESTADO — claude-fable-5 · arquiteto-implementador · 2026-06-10T20:59:10-03:00
STATE: ultima_atualizacao=2026-06-10T20:59:10-03:00 · bastão → Maurício (gate) · contexto ~50% do threshold
SINAIS: 🟢 DOGFOOD metade 2 (4/4 + suíte 59/59); 🟣 atualizado; 🔵 HANDOFF READY; demais inalterados no STATE
FEITO: 4 guards do ADR-024 implementados em guards/ + 26 casos na suíte — proposed, FORA do runner, staged, não commitado
PENDENTE: gate humano (commit) → cross-audit Codex/Antigravity → hearback; ativação segue presa aos testes dos 5 legados; D2/D6 backlog
PONTEIROS: ⟦HBN⟧ guards/tests/run-guard-tests.sh · sinal: 🟢 · ação: rodar no Terminal (espera-se 59/59)
PONTEIROS: ⟦HBN⟧ methodology/adr/ADR-024-orquestracao-start.md · sinal: 🟣 · ação: conferir o mapa de enforcement contra o diff
PRÓXIMA AÇÃO: Maurício: rodar bash guards/tests/run-guard-tests.sh no Terminal, revisar o diff staged da metade 2 e commitar se aprovado; depois cross-audit Codex + Antigravity dos 4 guards (ADR-018)
PARA O HUMANO: git diff --cached --stat && bash guards/tests/run-guard-tests.sh — espera-se 59/59 verde; se vermelho, NÃO commitar e devolver o bastão com a saída colada
```

## Decisões informais (cápsula)

Nenhuma instrução informal nova do humano nesta sessão (janela limpa). Duas
decisões de implementação minha, registradas para o orquestrador: (a) o bloco
`atribuicao` do STATE foi mantido intacto da onda de consolidação (toque
mínimo — quem reatribui é o rito start, não este handoff); (b) os ids dos 4
guards usam o carimbo real de criação dos arquivos (20:53:10–20:53:40), não
um carimbo único da onda.
