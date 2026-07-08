# SUPER-PROMPT — auditoria cross-IA do Batch 1 de Fronteira (useHBN)

> COMO USAR (humano): cole TODO o bloco abaixo (da linha `=== INÍCIO ===` até
> `=== FIM ===`) em cada IA externa — Gemini 3.5, Codex, Cursor, Grok, Antigravity.
> Cada IA se autoidentifica e escreve SOMENTE o parecer. Rode em janela/chat novo.

=== INÍCIO ===

Você é AUDITOR em janela limpa no protocolo useHBN (governança epistêmica para
engenharia assistida por IA; humano no centro; guards fail-closed; auditoria
cross-family; história sagrada). O repositório está em `~/Projetos/usehbn/`
(ou no caminho que o operador indicar).

## 0. Identifique-se (primeira linha da sua resposta, obrigatório)
Comece exatamente assim:
`SOU: <fornecedor> · <modelo> · apelido: <apelido-curto>`
Ex.: `SOU: Google · Gemini 3.5 · apelido: gemini-3-5`

## 1. Regras
- JANELA LIMPA: não confie em memória; reconstrua tudo LENDO o disco.
- TRUTH BARRIER: toda afirmação cita `arquivo:linha` ou `comando + saída`. Proibido
  "garantido/100%/totalmente seguro".
- ISOLAMENTO: NÃO modifique nenhum arquivo do repo. A única escrita permitida é o
  seu PARECER (ver §5). Não rode git add/commit. Não altere os deliverables.

## 2. Leia, nesta ordem
1. `docs/brainstorm/rodada-2026-06-16/INDEX.md`
2. `docs/brainstorm/rodada-2026-06-16/A1-front-door-verificavel.md`
3. `docs/brainstorm/rodada-2026-06-16/A2-arvores-portao-promocao.md`
4. `docs/brainstorm/rodada-2026-06-16/A3-compilador-md-enforcement.md`
5. `docs/brainstorm/rodada-2026-06-16/B1-code-review-cli-runtime.md`
6. `docs/brainstorm/rodada-2026-06-16/B2-honestidade-maturity-matrix.md`
7. `docs/brainstorm/PROPOSTA-arvores-agora.md`
8. `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` · `methodology/MATURITY-MATRIX.md` · `core/exuvia-fitness-criteria.md`

## 3. Parte A — auditoria adversarial (tente QUEBRAR cada deliverable, com evidência)
- A1 (front-door / G-FDACK): o "eco de leitura" prova leitura ou é teatro? Há burla
  por ack emprestado/copiado? O fail-closed cobre STATE/readback ausente?
- A2 (árvores / portão): o campo `arvore:` cria segunda fonte de verdade vs
  `temperatura:`/`hbn-track:`? O portão Fronteira→Intermediária→Estável tem burla?
  Etiquetar guards via REGISTRY (já que são bash sem YAML) é robusto?
- A3 (compilador `.md`→enforcement): o bloco `enforcement:` proposto vira segunda
  fonte de verdade se divergir da prosa? A "verificação fiel" é suficiente?
- B1 (code review): confirme ou conteste — `cli.py` `main()` retorna exit 0 mesmo em
  violação? Três diretórios de estado coexistem? A decomposição preserva o contrato?
- B2 (honestidade): confirme ou conteste — `autoevolve` é teatro (worker no-op; gate
  de orçamento sempre passa) e está fora da MATURITY-MATRIX? Faltam dívidas? Há
  afirmação no README/AGENTS que excede a matriz?
- TRANSVERSAL: algo viola P1–P13? Algo excede a MATURITY-MATRIX?

## 4. Parte B — sua visão própria (divergência é bem-vinda)
Traga o que a SUA família veria de diferente ou melhor: o gradiente de prova entre
árvores, o portão de promoção, o modelo compilador, e a PRIORIDADE de correções
antes do freeze da versão. O objetivo é diversidade, não concordar.

## 5. Veredito — escreva APENAS aqui
- SE você tem acesso de escrita ao disco do repo: deposite um arquivo em
  `.hbn/results/AAAAMMDD-HHMMSS-<seu-apelido>-cross-ia-batch1-fronteira.md`
  (carimbo real: `TZ=America/Sao_Paulo date '+%Y%m%d-%H%M%S'`).
- SE NÃO tem acesso ao disco: produza o bloco abaixo NA RESPOSTA, para o humano depositar.

Formato (template `core/cadence-d.md`):
```
1 Veredito (APROVAR / APROVAR com FORTES incorporados / BLOQUEAR + 1 frase)
2 BLOQUEADORES (descrição + evidência arquivo:linha + remediação)
3 FORTES
4 MARGINAIS
5 Convergências
6 Divergências
7 Riscos não cobertos
8 Próxima ação
```
Encerre com uma linha por deliverable:
`APROVA_A1: SIM/NÃO · Conf X/100` … até `APROVA_B2: …`, e
`APROVA_PF-ARVORES-AGORA: SIM/NÃO · Conf X/100`. Assine com seu apelido e date.

Não modifique os deliverables nem qualquer outro arquivo — só o seu parecer.

=== FIM ===
