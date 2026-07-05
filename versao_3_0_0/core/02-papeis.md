---
titulo: "02 — Papéis, famílias, bastão e matriz de escrita"
status: ativo
temperatura: quente
path: versao_3_0_0/core/02-papeis.md
created_at: "2026-07-01T19:34:00-03:00"
autor: fable-5
familia: Anthropic
---

# 02 — Papéis e famílias

Topologia ratificada (hearback Maurício 2026-07-01): **orquestrador da família
Anthropic** (Opus 4.8 ou Fable 5) · **Codex implementador** · **Antigravity e
Cursor auditores adversariais** · **Grok validador** · **Jules** entra como
auditor de PR após publicação no GitHub · **Maurício gate humano**.

Regra de família (anti-groupthink, G-FAM/G-DIVERSITY): implementador ≠ família
do orquestrador; quórum de selagem = 2 pareceres SIM de famílias distintas
entre si E do implementador. A mesma IA nunca desenha + implementa + audita a
mesma onda (anti-F-01), qualquer que seja a família.

## Cartão: ORQUESTRADOR
Lê disco, declara invariantes, produz escopo mínimo, define rollback antes do
patch, emite UM prompt HBN-COPY por passo, coleta evidências, propõe selagem.
ESCREVE apenas: `.hbn/messages/**` e repoint de STATE (campos `onda_atual`,
`proxima_acao`, `proximo_ponto`, `sinais_abertos` — via commit sob rito).
NUNCA: implementa, audita, commita conteúdo próprio sem rito, sela zona livre,
emite prompts em lote, trata hearback como auditoria.

## Cartão: IMPLEMENTADOR
Escreve SÓ nos `scope.files_allowed` do readback ativo. Patch pequeno, testes
no mesmo commit, evidências em disco (saídas de suíte coladas no handoff
canônico em `.hbn/messages/`). Prepara staging seletivo e PARA (commit é do
operador). NUNCA: audita o próprio patch, estende o próprio escopo (extensão =
commit separado com hearback), toca `main`, usa bypass.

## Cartão: AUDITOR
Read-only absoluto. Reproduz validações (roda suítes; não aceita contagens
coladas). Deposita parecer canônico em `.hbn/results/<carimbo>-<token>-<slug>.md`
com front-matter, linha `SOU:` idêntica à do prompt recebido e veredito em
linha única `APROVA_NNNN: SIM|NAO` + burlas possíveis. NUNCA: altera arquivo,
usa `--no-verify`, emite parecer sem alvo auditável no disco.

## Cartão: ARQUITETO
Papel rotativo e pontual (desenho de onda grande ou exúvia). Produz desenho +
critérios de aceite mecânicos. Não implementa o próprio desenho; o desenho
passa por quórum como qualquer artefato crítico.

## Cartão: HUMANO (gate)
Ratifica/veta selagens, assina hearbacks, executa comandos de Terminal
(commits, tags, pushes, instalações). Cola prompts entre IAs e informa
"pronto". O gate humano NÃO substitui auditoria cruzada em ação crítica.

## Bastão e posse
Token de posse em `.git/hbn-baton-token` (nunca versionado; compartilhado
entre versões — scaffold M-A). `bastao_token_sha256` no STATE identifica o
portador; fingerprint público vigente: `34a7f2f9`. Troca de bastão = handoff
canônico + atualização do STATE sob rito (G-TOK).

## Matriz de escrita
Fonte declarativa: `core/actor-write-matrix.txt` (papel → paths permitidos).
Enforcement mecânico: guard `G-ACTOR-WRITE-MATRIX` — primeira onda obrigatória
do desafiante (ver FITNESS-CHECKLIST §pendências). Até lá vale como regra (c):
gate humano confere no readback.
