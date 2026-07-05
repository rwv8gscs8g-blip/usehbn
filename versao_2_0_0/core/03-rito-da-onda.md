---
titulo: "03 — Rito da onda: despacho, readback, evidência, quórum, selagem, hearback"
status: congelado
temperatura: glacier
path: versao_2_0_0/core/03-rito-da-onda.md
created_at: "2026-07-01T19:36:00-03:00"
autor: fable-5
familia: Anthropic
---

# 03 — Rito da onda

Consolida: relay-spec, readback-spec, dispatch-spec, cadence-d, start-rite,
state-report-spec, relay-return-spec e a doutrina de saneamento do v0.3.x.

## A onda (12 passos — invariável)

1. Orquestrador lê disco (BOOT §2) e declara invariantes aplicáveis.
2. Produz escopo mínimo + rollback ANTES do patch (tag `hbn-rollback/…`).
3. Cria/aponta **readback** com o próximo número livre em `.hbn/readbacks/`.
4. Emite **UM** prompt HBN-COPY de implementação (≤150 linhas), salvo em
   `.hbn/messages/` E colado no chat em campo único. Nada em lote.
5. Implementador executa dentro do `files_allowed`; testes no mesmo commit;
   handoff canônico com saídas reais de comando.
6. Humano informa "pronto"; orquestrador CONFERE no disco (nunca aceita relato).
7. Orquestrador emite UM prompt de auditoria para família independente —
   somente APÓS existir alvo auditável no disco.
8. Auditor deposita parecer canônico; repete-se para a 2ª família.
9. Quórum: 2× `APROVA_NNNN: SIM`, famílias distintas entre si e do
   implementador (G-QUORUM + G-DIVERSITY).
10. Orquestrador propõe selagem; humano assina hearback.
11. Operador executa a cerimônia de commit (abaixo); guards decidem.
12. STATE repontado (`proxima_acao` única); RETURN.json efêmero se pedido.

## Readback (contrato de escopo)

JSON em `.hbn/readbacks/NNNN-<slug>.json` com, no mínimo: `scope.files_allowed`,
`understanding`, `read_evidence` (arquivo:linha), `human_status`
(`pending|confirmed`), `created_at`. Escopo é PREMISSA: alterar `files_allowed`
no mesmo commit do artefato que ele autoriza é violação (anti-auto-emenda,
G-SCOPE). Extensão de escopo = commit separado com bloco `scope_extension`
contendo `human`, `evidence`, `created_at` e `allowed_delta` cobrindo o delta
(campos exigidos por `guards/assert-scope-lock.sh`).

## Hearback (ato humano)

Só o humano escreve `human_status: confirmed`. IA que o preencha comete
violação classe F-01. Com chave em `.hbn/operators/<nome>.pub`, o hearback é
assinado (`ssh-keygen -Y sign`) e o G-HRB o verifica.

## Cerimônia de commit (zsh-safe, sempre igual)

Linhas próprias, sem comentário inline, sem `git add .`:
`cd <raiz do repo>` → `rm -f .git/index.lock` → `git add <paths explícitos>` →
`git commit -s -m "<mensagem honesta>" -m "HBN-Readback: NNNN" -m "HBN-Token-FP: 34a7f2f9"`.
Mensagem descreve o que o commit REALMENTE faz. Sandbox de IA prepara e PARA;
quem executa é o operador.

**Janela nova é a premissa** (consolida knowledge 0001 + 0030 para o
terminal): todo bloco colável entregue ao operador é AUTOSSUFICIENTE quanto a
diretório e a estado — inicia com `cd <raiz> && ` na MESMA linha (ou usa
`git -C <raiz> …`). Bloco que depende do `cd` de um bloco anterior, ou de
qualquer estado de janela anterior, é violação do rito de entrega.

## Relato de Estado (a 50% de contexto ou ao encerrar)

Cabeçalho de identificação + HEAD + o que foi feito/conferido (arquivo:linha) +
pendências + próxima ação única + nível de confiança. Handoff entre janelas é
SEMPRE por disco (`.hbn/messages/`), nunca por colagem de memória.

## Relato de Leitura (I-10 — prova de entrada; consolida state-report-spec §5)

Handoff de entrada de janela (`tipo: entrada` no front-matter) exige o heading
EXATO `## RELATO DE LEITURA` com ≥ 1 item da read-list citado como
`arquivo:linha` — a citação é a prova de leitura do disco (Truth Barrier).
Sem ela o commit do handoff é bloqueado. Enforcement herdado sem alteração:
`guards/assert-report-fresh.sh` (regra 6, onda 0006 I-10).

## Proporcionalidade (anti-burocracia)

Tier BAIXO (ajuste visual, typo, doc não-normativo): 1 auditor, sem quórum
duplo, hearback simples. Tier ALTO (guards, core, STATE, REGISTRY, membrana,
freeze, exúvia): rito completo de 12 passos. Na dúvida, tier alto. O tier é
declarado no despacho e conferível no readback.
