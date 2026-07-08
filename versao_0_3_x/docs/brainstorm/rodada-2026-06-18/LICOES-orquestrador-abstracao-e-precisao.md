# Lições do orquestrador — camada de abstração e precisão de instrução

NÃO-NORMATIVO (zona livre). Orquestrador (opus-4-8 · Anthropic), 2026-06-18. Candidatas a knowledge
(0027, 0028). Registradas a pedido do gate humano (Maurício) após erros reais cometidos por ESTE
orquestrador na sessão W-ORQ-3/3b. Promoção a `.hbn/knowledge/` segue curadoria com aprovação por
arquivo (knowledge 0024).

---

## Lição A (candidata k-0027) — a IA é a camada de abstração; o humano é GATE, não mecânico

### A regra (já escrita, aqui dogfoodada por violação)

`core/orchestrator-profile-spec.md §2.7`: "o orquestrador é a interface entre o humano e a
maquinaria (guards, git, artefatos, outras IAs). Traduz toda mecânica em prosa humana ... sem
exigir que o humano leia código ou saída de guard crua." `AGENTS.md`: "Orquestrador deposita
artefatos untracked". Cartão de papel: o humano está no **gate** (P5).

**Divisão correta de trabalho:**
- **Humano = só atos de GATE/AUTORIDADE que apenas ele pode fazer:** hearback/autorização,
  posse do bastão (assinatura), proteção biométrica da main, rodar `freeze-gate.sh`, gerar a
  chave de operador. E operar como **conduto** para outras IAs CLI (rodar grok/antigravity/codex)
  enquanto não há fio direto IA↔IA (Jules, Fase C).
- **Camada IA = toda a mecânica:** o orquestrador DESENHA e deposita artefatos untracked; o
  **codex (implementador) EXECUTA** edições de arquivo, git, normalização de front-matter,
  descarte de edição perdida, remoção de `index.lock`, etc. — sob micro-despacho, com guards.

### A violação (o que ESTE orquestrador fez de errado)

Diante de fricções mecânicas (edição perdida no readback 0061; `index.lock` preso; typo de
front-matter no parecer do grok), o orquestrador **mandou o humano executar comandos de terminal
e editar YAML à mão** (`git restore`, `git checkout`, `rm .git/index.lock`, "troque a linha
`path:`"). Isso **inverte** a §2.7: faz do humano o mecânico, sendo que ele não tem interface de
edição aqui e a IA existe justamente para ser a abstração.

### Causa-raiz honesta

O ambiente do orquestrador (sandbox) **não commita nem faz unlink** de forma confiável no mount
do repo. Em vez de rotear a correção mecânica para o **codex** (que opera no disco real e já
commita), o orquestrador pegou o atalho de "peça ao humano". Atalho proibido pela doutrina.

### A regra operacional (o conserto)

Toda operação mecânica de repo (editar/normalizar arquivo, git janitorial, lock, fix de
front-matter) → **micro-despacho ao codex**, nunca comando/edição ao humano. O humano recebe
**prosa + decisões de gate**. Exceção: os atos conclusivos que SÓ o humano pode (bastão,
biometria, `freeze-gate.sh`, chave de operador) — esses sim vão a ele, atômicos (knowledge 0001).

## Lição B (candidata k-0028) — instrução imprecisa do orquestrador vira defeito a jusante

O orquestrador é amplificador: cada ambiguidade na instrução se materializa como erro no
artefato de outra IA. Dois casos reais nesta sessão:

1. **"PARE antes de qualquer ERP/implementação"** no despacho W-ORQ-3b foi mais estrito que o
   fluxo real (entregar → cross-audit → selar) e fez o codex rebaixar um readback já entregue,
   criando estado incoerente.
2. **"front-matter (path: real — G-SLF)"** no prompt de cross-audit foi copiado **ao pé da letra**
   pelo grok, que gravou `path: real — G-SLF` em vez do caminho real — defeito que o G-SLF
   bloquearia na selagem. Re-rodar com o MESMO prompt reproduziu o bug (não é falha do grok).

**Regra:** instruções a outras IAs usam exemplos concretos e literais ("`path:` deve ser o
caminho real deste arquivo, ex.: `.hbn/results/<ts>-<apelido>-...md`"), nunca abreviações que o
modelo possa copiar como valor. O orquestrador relê o próprio despacho perguntando "que parte
disto uma IA copiaria literalmente por engano?".

## Meta

Ambas as lições reforçam o que `core/orchestrator-profile-spec.md §1` já diz (o papel é stateless;
o disco é o ativo) e a meta-lição 0026 (o zelador confere o disco). Acrescentam: o zelador também
**confere a si mesmo** — quando o atalho aparece (passar mecânica ao humano, abreviar instrução),
é sinal de deriva, possivelmente de fadiga de janela (§2.6).
