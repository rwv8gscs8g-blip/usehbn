---
titulo: "Handoff — entrada da próxima janela (backup seguro feito; próximo = commit da membrana no Credenciamento)"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260629-220000-opus-4-8-handoff-orquestrador-pre-commit-membrana.md
created_at: "2026-06-29T22:00:00-03:00"
autoria: "opus-4-8 (orquestrador cessante · Anthropic) — bastao token_fp 34a7f2f9"
para: "proximo Claude Opus orquestrador (Anthropic), em CHAT NOVO"
relacionado:
  - .hbn/relay/STATE.md
  - .hbn/messages/20260628-040000-opus-4-8-handoff-orquestrador-validacao-final.md
  - .hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md
  - docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md
  - .hbn/knowledge/0001-comandos-atomicos-copiaveis.md
  - .hbn/knowledge/0029-lei-submissao-pelo-exemplo.md
---
# HANDOFF — VOCÊ É O NOVO ORQUESTRADOR. LEIA INTEIRO E CUMPRA ANTES DE AGIR.

## 0. MANDATO — VOCÊ É O GUARDIÃO DAS REGRAS. NÃO IMPROVISE.
Você é o **responsável e guardião das regras**. Sua primeira obrigação é **LER as
regras e os conteúdos do disco e SEGUI-LOS** — não de memória, não por suposição.
**É proibido improvisar, inventar procedimento, "agilizar" ou fugir de qualquer
regra/convenção.** Essas convenções existem para **impedir que IAs atuem de forma
descontrolada**; quebrá-las derrota o propósito do sistema. Em dúvida entre
cumprir a regra e ser rápido: **cumpra a regra.** Se um guard ou regra bloquear:
**PARE e relate** — o motivo se lê DO DISCO, nunca do chat. Você não apenas
obedece: **faz com que as regras sejam cumpridas.**

REGRA DE ENTREGA: **todo texto e todo comando vão NO CHAT, completos**, para o
humano copiar um a um. Salvar só em arquivo NÃO cumpre a regra (erro pago nesta
transição).

## 1. QUEM VOCÊ É
Claude Opus orquestrador (Anthropic), bastão token_fp **34a7f2f9**. ZELADOR
ENFORÇADO (W-LEX, k-0029): submetido às barreiras primeiro, mantenedor depois.
Autoridade vem de OBEDECER ao rito e DECLARAR o que leu e fará — nunca de
contornar.

## 2. O QUE VOCÊ PRECISA LER PRIMEIRO (obrigatório, com arquivo:linha)
Antes de QUALQUER ação, releia e confirme no disco:
- `core/read-list-canonica.txt` (os 13 itens do bastão) e CADA item dela.
- `.hbn/relay/STATE.md` (proximo_ponto, readback_ativo, sinais_abertos).
- `.hbn/knowledge/0029-lei-submissao-pelo-exemplo.md` (W-LEX) e
  `.hbn/knowledge/0001-comandos-atomicos-copiaveis.md`.
- `.hbn/proposals/20260626-120000-opus-4-8-ponte-v2-consolidada.md` (desenho da ponte).
- `docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md` (5 passos).
- Os guards que o passo atual toca (ver §6), inteiros, todas as variações.

## 3. REGRA ZERO (declare a cada iteração, no chat, verificável)
1. **LI as regras** — liste o que releu nesta iteração, com `arquivo:linha` de ao
   menos um ponto que governa a ação atual.
2. **CONHEÇO o plano** — `proximo_ponto` do STATE + onde encaixa no ROADMAP.
3. **VOU executar EXATAMENTE o proximo_ponto** — sem passo paralelo, sem selagem
   combinada que o disco não declare (W-LEX cláusula 1, k-0029:17).

## 4. REGRA DE OPERAÇÃO — TUDO NO CHAT, JANELA NOVA, AUTOSSUFICIENTE
- **Todo texto e todo comando vão NO CHAT, completos** (o app não é IDE).
- **Cada comando é executado em JANELA NOVA, sem memória.** Cada entrega
  **começa pelo `cd` no repo** (bloco próprio), é **idempotente** e não depende de
  staging/estado de janela anterior.
- **1 comando = 1 bloco; explicação FORA do bloco; PROIBIDO comentário inline** (k-0001).
- main NUNCA é tocada (`4db6928`). Orquestrador DESENHA; codex/humano IMPLEMENTA.

## 5. ESTADO DE DISCO (confirme você mesmo — Truth Barrier)
### usehbn (`~/Projetos/usehbn`, branch `proposta/reestruturacao-m-a-s0`)
- HEAD = **886b3a1** (baseline; onda 0103 cosmética DESCARTADA e árvore normalizada).
  main = **4db6928 INTOCADA**. tag **v1-estavel** → `a67e8049` (tag anotada `783053a2`).
  readback_ativo = **0102**.
- **BACKUP FEITO no GitHub:** branch de trabalho (886b3a1) e tag `v1-estavel`
  pushadas nesta janela. A `main` REMOTA está em `18d5434` (atrás, é ancestral) e é
  **protegida (require PR/biometria) — NÃO dê push direto**; reconciliar é passo
  governado próprio.
- 78 untracked = zona-livre intencional (não rastrear sem onda de curadoria).

### Credenciamento (`~/Projetos/Credenciamento`, branch `codex/v12-0-0206-planejamento`)
- HEAD = **d299335**, **em sincronia com o GitHub** (push feito nesta janela). A onda
  de projeto 0178 (prestação de contas) foi commitada+pushada (guards do projeto ✓).
- Sobra não-commitado: `.claude/` (gitignored — NÃO versionar) e a **MEMBRANA**
  (`.usehbn-snapshot/`, `scripts/hbn-snapshot/`, `.hbn/active-version`) — próximo passo.
- Antes de commitar, remova lock se houver:
  `rm -f /Users/macbookpro/Projetos/Credenciamento/.git/index.lock`

## 6. O QUE VOCÊ PRECISA FAZER — COMMIT DA MEMBRANA (já pesquisado nesta janela)
A membrana já está instalada e verificada no Credenciamento (integrity ✓ 137;
`protocol_sha256 8796b672819c0dd0df6fc9c7b0c24288b987ad0e9adfa3b3fd115dd12b5cb7f1`;
tag `v1-estavel`) e está UNTRACKED. O passo é só **registrar (commitar)**, escopado,
na branch atual. É **ADITIVO — não toca código de domínio.**

Caminhos (git add EXPLÍCITO — nunca `git add .`): `.usehbn-snapshot/`,
`scripts/hbn-snapshot/assert-snapshot-integrity.sh`, `.hbn/active-version`.

Rito do projeto (LIDO INTEIRO nesta janela — não monte às cegas):
- `.git/hooks/pre-commit` → FASE 1 roda `scripts/hbn-guards/hbn-guards-runner.sh`
  (`assert-canonical-root`, `forbid-tmp-worktree`, `forbid-env-files`,
  `forbid-legacy-paths`, `assert-scope-lock`); FASE 2 (VBA G7/G8) só se tocar VBA — não é o caso.
- `assert-scope-lock` usa o **readback ativo = maior número em `.hbn/readbacks/`**
  (hoje **0178**, `fast_track` → PULA). Se for `safe_track`, exige
  `human_status=confirmed` e que TODO arquivo staged case com `scope.files_allowed`
  (`files_forbidden` tem prioridade).
- `assert-snapshot-integrity.sh` (modo normal) **FALHA se `.usehbn-snapshot/` estiver
  staged** → **rode a verificação ANTES do `git add`**. Ainda NÃO está no hook do
  projeto (isso é P2-C); o commit inicial não é bloqueado por ele.
- `.hbn/forbidden-paths.txt`: confirmado que nenhum caminho da membrana casa proibição.

DECISÃO PENDENTE COM MAURICIO (gate dele) — recoloque no chat:
- **(Recomendado) Readback de projeto 0179 governado** (`safe_track`,
  `human_status: confirmed`), `files_allowed` = só a membrana + o próprio readback →
  scope-lock ENFORÇA. Espelhe o schema de `.hbn/readbacks/0174-*.json`.
- **(Mínimo) Sem readback** — confia no 0178 `fast_track`; proteção só do `git add` explícito.

Sequência do bloco (autossuficiente, janela nova, k-0001):
1. `cd /Users/macbookpro/Projetos/Credenciamento`
2. `rm -f .../.git/index.lock` (se houver)
3. `bash scripts/hbn-snapshot/assert-snapshot-integrity.sh` → esperar `✓ … 137` (ANTES de stage)
4. (se rito governado) criar `.hbn/readbacks/0179-…json` (heredoc, schema espelhado)
5. `git add` EXPLÍCITO dos 3 caminhos (+ readback, se houver)
6. conferir staged (só membrana + readback; nada de domínio)
7. `git commit -m "chore(hbn): instala membrana usehbn@v1-estavel (.usehbn-snapshot 137) — P2-B parte 2"`
8. `git push origin codex/v12-0-0206-planejamento`
9. confirmar do remoto; depois ATUALIZAR o STATE do PROTOCOLO (onda própria no usehbn:
   registra membrana commitada; repoint `proxima_acao` → P2-C). Ato de autoridade no
   usehbn carrega `orq_entrada_ref` e regenera atestação same-fp (`/tmp/gen_orq.py` é
   volátil — considere versionar o gerador).

## 7. PARA ONDE VAMOS DEPOIS (ROADMAP passo 2 e além)
- **P2-C:** runner project-mode no Credenciamento + subset bloqueante (shims chamando
  `.usehbn-snapshot/guards/` após `assert-snapshot-integrity`) + pré-higiene do INDEX
  da knowledge (proposta v2 §5/§2).
- **P2-D:** router OBRIGATÓRIO no topo do `AGENTS.md` do Credenciamento; tombstone do
  espelho antigo `usehbn/`; untangle; limpeza de refs (humano-gated); selagem do passo 2.
- **Passo 3:** exúvia do protocolo. **Passo 4:** validar+congelar V206. **Passo 5:** v207.

## 8. LIÇÕES DESTA JANELA (não repita)
- Onda 0103 (cosmética, off-roadmap) descartada; usehbn normalizado ao baseline.
- Backup seguro no GitHub já feito nos dois repos — NÃO refaça pushes.
- Tudo no chat; toda entrega começa pelo `cd`; janela nova; autossuficiente.
- Respeite os 50% de contexto: ao se aproximar, pare e passe o bastão.

## 9. GATES SÃO DO HUMANO
Mauricio opera os GATES (hearback, posse do bastão, freeze, push). Você desenha e
declara; o codex/humano implementa; o humano aprova. Tudo verificável no disco.
— FIM DO HANDOFF —
