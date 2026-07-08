---
titulo: "Exúvia atômica: o sandbox nasce do HEAD — citação untracked-only é bomba silenciosa"
tipo: knowledge
status: accepted
temperatura: quente
path: .hbn/knowledge/0033-exuvia-sandbox-exige-head-completo.md
created_at: "2026-07-05T20:24:51-03:00"
autor: fable-5
familia: Anthropic
natureza: nativo
---
# Exúvia sandbox exige HEAD completo

## A falha (bloqueador T1, readback 0002; parecer grok 20260705-174859 furo 1)

`hbn-exuvia-atomic.sh --dry-run --new versao_4_0_0` abortava com
`SUITE-VERMELHA`. Causa mecânica, reproduzida em sandbox idêntico ao do rito:

1. O rito clona o repo (`git clone` = **só estado commitado**), copia a versão
   quente para a nova pasta, flipa o ponteiro e roda a suíte de dentro do clone.
2. O check `readlist: alvos version-aware sem referência quebrada` exige que
   todo path citado nos alvos vivos (BOOT.md, core/*) exista no disco.
3. `.hbn/messages/` era citada no BOOT/core mas existia **apenas untracked**
   na working tree (o HEAD `a2eb6f2` não tinha nenhum arquivo dentro dela).
4. No repo real a suíte passa (a pasta está no disco); no clone da exúvia a
   pasta **não existe** → suíte vermelha, e o log ia para `/dev/null`
   (falha muda).

## As três correções mecânicas (mesmo commit)

1. **Presença no HEAD**: `.hbn/messages/` passa a ter conteúdo tracked (o
   handoff canônico da onda — a série de evento não aceita `.gitkeep`, G-NUM;
   o canal de hearback não aceita mistura, G-HRB): diretório governado
   citado nunca mais fica vazio no HEAD.
2. **Classe de erro ruidosa no chokepoint**: seção `readlist-tracked` na suíte
   — toda citação dos alvos vivos deve resolver via `git ls-files`
   (índice/HEAD), não só no disco. Untracked-only reprova JÁ no repo real,
   antes de qualquer exúvia (teste negativo incluso).
3. **Fim da falha muda**: `hbn-exuvia-atomic.sh` agora preserva o log da suíte
   do sandbox e imprime os checks reprovados no stderr do rito.

## Causas irmãs fechadas na mesma onda

- Sandbox do rito vivia em `${TMPDIR:-/tmp}` e o G-CR bloqueia worktree em
  `*/tmp/*` → sandbox movido para `$HOME` (portável macOS/Linux).
- Fixture `make_integrated_genesis_repo` com caminho HARDCODED do operador:
  fora do Mac o `mktemp` falha e `cd ""` (NO-OP do bash) fazia a fixture
  executar NO REPO ENVOLVENTE (`echo . > .hbn/active-version` + `git add -A`
  — incidente real de 2026-07-05). Correção: caminho portátil + `cd "${d:?}"
  || exit 1` (fail-closed).

## Regras reutilizáveis

1. Todo validador que roda dentro de clone/sandbox deve ter um espelho no
   repo real que valide contra o conjunto TRACKED. "Passa no meu disco" não
   é prova: o disco tem coisas que o clone não terá.
2. Fixture NUNCA assume que `mktemp`/`cd` deu certo: `cd ""` é no-op — todo
   `cd` de fixture é `cd "${d:?}" || exit 1`.
3. Caminho absoluto de UM operador dentro de teste é bomba de portabilidade
   e de contenção ao mesmo tempo.
