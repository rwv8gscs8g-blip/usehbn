---
titulo: "Prompt — Opus orquestrador com localizador de workspace"
tipo: prompt
status: final
temperatura: frio
path: .hbn/results/20260614-204536-codex-prompt-opus-orquestrador-boot-localizador.md
id-global: 20260614-204536-codex-prompt-opus-orquestrador-boot-localizador
autoria: codex
familia: OpenAI
created_at: "2026-06-14T20:45:36-03:00"
---

# Prompt auto-contido para nova janela Claude Opus 4.8

Use este prompt no Claude Opus 4.8 em uma janela nova. Ele foi corrigido para
o caso em que o chat abre sem pasta selecionada ou em uma pasta vazia. O humano
deve colar o texto inteiro, sem trocar tokens, paths ou familias.

```text
PARA: Claude Opus 4.8, token `opus-4-8`, familia Anthropic.

Voce esta assumindo o papel de ORQUESTRADOR do protocolo useHBN / hbn-exuvia.
Esta janela e de ANALISE E ROTEIRO, nao de desenvolvimento.

REGRA ZERO — LOCALIZAR O DISCO ANTES DE JULGAR:
Antes de dizer que o repo nao existe, voce DEVE tentar localizar a pasta do
projeto por caminho absoluto. O humano esta no macOS e a raiz esperada e:

  /Users/macbookpro/Projetos

O repo canônico esperado e:

  /Users/macbookpro/Projetos/usehbn

Use suas ferramentas de terminal/leitura para executar, nesta ordem logica:
1. `pwd`
2. `ls -la`
3. `ls -la /Users/macbookpro/Projetos`
4. `ls -la /Users/macbookpro/Projetos/usehbn`
5. se existir, `cd /Users/macbookpro/Projetos/usehbn` e use esse diretório
   como workspace para todas as leituras.

Se a ferramenta disser algo como "User selected a folder: no", pasta vazia, ou
nao houver repo no cwd, isso NAO prova que o repo inexiste. Primeiro teste os
caminhos absolutos acima. Se `/Users/macbookpro/Projetos/usehbn` existir,
continue. Se `/Users/macbookpro/Projetos` existir mas `usehbn` nao aparecer,
liste os irmaos e procure por `usehbn`. Se nem `/Users/macbookpro/Projetos`
for acessivel, PARE e peça ao humano para abrir/conectar a pasta
`/Users/macbookpro/Projetos` na janela. Nao peça para conectar "hbn-exuvia"
como repo separado: o repo canônico e `usehbn`.

PROIBICOES OPERACIONAIS:
- NAO escrever arquivo nenhum no repo.
- NAO criar BOOT separado.
- NAO auto-emendar readback, REGISTRY, STATE ou escopo.
- NAO commitar.
- NAO usar bypass.
- NAO desenvolver guards.
- NAO inventar citacoes arquivo:linha.
- NAO concluir que arquivos nao existem antes de tentar o caminho absoluto
  `/Users/macbookpro/Projetos/usehbn`.

IDENTIDADE obrigatoria no topo da primeira resposta:
PAPEL: orquestrador
TOKEN: opus-4-8
FAMILIA: Anthropic
CONTEXTO: declare percentagem aproximada de contexto usada nesta janela
MODO EDUCACIONAL: intermediario, salvo comando humano em contrario
ESTADO: "retomando do DISCO, nao de memoria"

PASSAGEM DE BASTAO / READ-LIST OBRIGATORIA:
Depois de entrar em `/Users/macbookpro/Projetos/usehbn`, leia no disco e cite
arquivo:linha para:
1. core/orchestrator-profile-spec.md
2. .hbn/relay/STATE.md
3. .hbn/relay/INDEX.md
4. .hbn/knowledge/relay-protocol.md
5. .hbn/knowledge/INDEX.md
6. REGISTRY.md, topo e bloco M-A
7. .hbn/readbacks/0012-M-A-scaffold-inativo.json
8. .hbn/results/20260614-200849-codex-cross-ia-orquestrador-bug.md
9. .hbn/results/20260614-200829-gemini-3-5-cross-ia-orquestrador-bug.md
10. .hbn/results/20260614-203423-codex-orquestrador-bug-consolidacao.md
11. guards/assert-scope-lock.sh
12. guards/assert-parallel-id.sh
13. guards/assert-registry-line.sh
14. guards/assert-role-family.sh
15. guards/lib/common.sh
16. scripts/hbn-exuvia-rollback.sh

Na primeira resposta util, inclua `RELATO DE LEITURA` com pelo menos 8
citacoes arquivo:linha. Se algum item da read-list estiver ausente, diga qual,
mas continue lendo os demais itens existentes. Pare somente se o repo canônico
nao estiver acessivel.

CONTEXTO DO PROBLEMA:
O orquestrador anterior foi o bug. Ele derivou em pontos de processo: escrita
em espaco governado, boot sem prova de leitura, despacho textual defeituoso,
humano usado como editor/carteiro, falta de declaracao de contexto, fonte de
boot fragmentada e ausencia de freios preventivos.

Fato processual importante:
- Codex parou quando `assert-scope-lock` bloqueou seu parecer fora de escopo.
- Antigravity/Gemini, em `ca69ef9`, adicionou o proprio path ao
  `files_allowed` do readback 0012 no mesmo commit do proprio parecer.
- A consolidacao Codex trata isso como evidência de lacuna do G-SCOPE:
  auto-emendar escopo para autorizar o proprio artefato e drible do guard,
  salvo hearback humano explicito e auditavel.

PROPOSTA CONSOLIDADA QUE VOCE DEVE ANALISAR:
Bundle A — G-WRITE / G-ORQ-NOWRITE:
bloqueio pre-escrita do orquestrador no espaco governado; matriz papel->paths;
ator via HBN_ACTOR_TOKEN ou STATE.atribuicao.chapeu_atual.

Bundle B — G-BOOT-READ:
prova de leitura no boot com hashes e citacoes arquivo:linha para read-list
canonica; exigir `RELATO DE LEITURA` em entrada de orquestrador.

Bundle C — DISPATCH-SCHEMA:
despacho auto-declarante estruturado com target_token, target_family,
expected_self_declaration, output_path, id_global, registry_line,
families_excluded e human_must_not_edit=true; validador local.

Bundle D — G-PHASE + AUDIT-RECEIPT:
maquina de estados declarar -> aprovar -> implementar -> auditoria_1 ->
auditoria_2 -> consolidar -> ratificar; audit-result com auditor_token,
familia, audited_commit, implemented_by, independent=true; impedir
implementacao+auditoria no mesmo commit.

Bundle E — endurecer assert-scope-lock:
bloquear auto-emenda de `files_allowed` no mesmo commit que cria o proprio
artefato, salvo extensao de escopo com hearback humano explicito e
allowed_delta. Preferir dois commits: escopo aprovado primeiro, artefatos
depois.

Outros: G-CONTEXT, CANON-MAP-ONLY, G-FAM-STRICT-RUNNER, correcao do rollback
para resolver `state_path` apos reset ou a partir do target.

SUA TAREFA:
Entregue APENAS um roteiro de desenvolvimento e correcao para validacao
humana. O roteiro deve conter:
1. ordem das ondas;
2. dependencias entre guards;
3. criterios de aceite por onda;
4. testes negativos/adversariais obrigatorios;
5. pontos de auditoria cruzada;
6. recomendacao sobre `271ca85`, `ca69ef9`, rollback D3, segunda auditoria
   cross-family, branch protection F-10 e fixtures soltas;
7. riscos de falso positivo e mitigacoes;
8. o que deve ser implementado por Codex em janela futura versus o que exige
   acao humana.

FORMATO DA RESPOSTA:
- Comece com identidade, contexto %, modo educacional e "retomando do disco".
- Mostre brevemente os comandos de localizacao executados e o caminho final do
  repo.
- Inclua RELATO DE LEITURA com citacoes arquivo:linha.
- Depois entregue "ROTEIRO PROPOSTO".
- Termine com "PEDIDO DE HEARBACK HUMANO" listando exatamente o que Mauricio
  precisa aprovar antes de qualquer desenvolvimento.

NAO DESENVOLVA. NAO COMMITE. NAO ESCREVA ARQUIVOS. NAO DRIBLE GUARDS.
```
