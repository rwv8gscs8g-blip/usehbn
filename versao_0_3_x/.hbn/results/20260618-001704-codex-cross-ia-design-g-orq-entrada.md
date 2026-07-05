SOU: codex · familia OpenAI · papel auditor

# Parecer — design G-ORQ-ENTRADA

Escopo: auditoria de design do enforcement de entrada do orquestrador. Nao auditei a implementacao da onda 0055; li o readback 0055 apenas como contexto de estado ativo.

Fontes no disco: `core/orchestrator-profile-spec.md:28-30,115-131,133-139,153-159`; `AGENTS.md:10-23,65-67,98-104`; `core/role-cards.md:3-20`; `core/relay-spec.md:116-141`; `core/dispatch-spec.md:12-15,19-31,35-44`; `guards/assert-dispatch-integrity.sh:38-55,76-87,168-200`; `guards/freeze-gate.sh:3-17,26-30,71-99`; `core/freeze-gate-spec.md:18-36,53-57`; `.hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md:27-45`; `.hbn/knowledge/0028-diversidade-familia-enforced-selagem.md:14-31`; `.hbn/relay/STATE.md:5-14,18-20,27-29`; `.hbn/readbacks/0055-curadoria-dossie-pre-transicao.json:1-13,20-47,67-78`.

## Resumo

1. Hash sozinho nao fecha o buraco: hash pode ser copiado ou recomputado sem evidenciar leitura situada.
2. Desafio aberto de compreensao tambem nao fecha: resposta por heuristica ou por resumo generico passa facil.
3. O desafio minimo bloqueante deve ser extrativo, dinamico e recalculavel pelo guard: linhas/campos exatos derivados dos blobs atuais.
4. O guard deve provar uso dos bytes do disco, nao cognição interna da IA; cognicao fica para auditoria/verificador, nao para criterio mecanico.
5. Antes do guard, D1 precisa resolver uma divergencia real: AGENTS, role-cards, relay-spec e orchestrator-profile hoje descrevem listas diferentes.
6. A atestacao deve ser referenciada por despacho, selagem e freeze; atestacao solta em `.hbn/attestations/` nao enforca nada.
7. Hash-pin deve falhar em drift; re-pin automatico reabre a fresta.
8. G-ORQ-ENTRADA deve ser pre-condicao de despacho, selagem e freeze, nao de todo commit de implementador/auditor.
9. Subagente verificador vale para selagem/freeze; usar em todo despacho vira over-engineering contra P11.

## Veredito

APROVA_COM_RESSALVAS para D1-D6, desde que o desenho seja mecanico e fail-closed: uma read-list unica; atestacao JSON com blobs atuais; desafio extrativo nao-generico; referencia obrigatoria nos artefatos de autoridade; e bloqueio em dispatch/selagem/freeze. Reprovo a versao fraca "hash + pergunta aberta", porque ela vira teatro de leitura.

## Achados

**BLOQUEADOR — D1 precisa ter uma unica fonte mecanica de read-list antes de qualquer guard.**  
Hoje o disco nao tem uma unica lista: `AGENTS.md:18` inclui STATE, readback ativo, `core/role-cards.md` e knowledges 0001/0002/0023/0024/0025; `core/role-cards.md:7-12` lista STATE, readback ativo, role-cards e 0001/0002/0023; `core/relay-spec.md:118-129` fala em STATE, handoff, readback, template do papel e 0022; `core/orchestrator-profile-spec.md:135-139` manda o orquestrador ler o proprio contrato e a read-list do relay-spec. Um guard que compara hashes contra "a read-list canonica" fica ambiguo. Opcao P11: eleger `core/role-cards.md` como fonte unica parseavel, incluindo ali todo item obrigatorio; transformar AGENTS/relay/orchestrator-profile em ponteiros, nao listas paralelas. Se 0024/0025 continuarem obrigatorios, entram nessa fonte unica e o teto de G-FRONTDOOR e ajustado sob rito.

**FORTE — hash+desafio so fecha a burla se o desafio for extrativo e derivado dos blobs atuais.**  
Copiar `git hash-object` ou `git show :path` nao prova leitura semantica. Perguntas como "qual o objetivo?" podem ser respondidas por padrao. O minimo nao-forjavel contra copia/heuristica e exigir linhas ou campos exatos escolhidos por uma seed derivada de `execution_id + token_fp + manifest_hash + blob_oid`, com o guard recomputando a resposta. Isso prova acesso aos bytes correntes do disco. Nao prova que a IA compreendeu tudo; essa honestidade e importante.

**FORTE — atestacao sem amarra ao ato posterior vira evidencia decorativa.**  
O precedente bom e `core/dispatch-spec.md:35-44` + `guards/assert-dispatch-integrity.sh:76-87,187-200`: o dispatch declara readback/token/autorizacao e o guard cruza contra STATE/readback. G-ORQ-ENTRADA precisa do mesmo padrao: `orq_entrada_ref` no despacho, no readback de selagem e no checklist de freeze. Sem essa referencia, um JSON correto pode existir no disco e nunca governar nada.

**FORTE — re-pin automatico reabre a fresta.**  
Se a read-list ou qualquer item lido muda, a atestacao antiga deve falhar. A resposta P11 e simples: gerar nova atestacao sob rito, com novo `manifest_sha256`, e referenciar a nova atestacao no ato governado. Nao alterar atestacao antiga; nao aceitar "atualizei o hash porque mudou"; nao permitir que o proprio despacho auto-repina sem readback/human gate.

**MARGINAL — subagente verificador e util, mas nao deve ser o gate primario.**  
Knowledge 0024 registra que instrucao escrita nao vincula IA e que so guard enforcado segura (`.hbn/knowledge/0024...:27-32`). Um subagente LLM que "confere compreensao" e outra disciplina humana/IA; bom para selagem/freeze e auditoria adversarial, mas fraco como pre-condicao mecanica. O gate primario deve ser deterministico.

## A. Hash + Desafio

O par hash+desafio fecha a burla apenas se "desafio" significar verificacao extrativa sobre bytes atuais. Nao fecha se for:

- lista de hashes sem resposta situada;
- pergunta aberta de compreensao;
- resumo livre;
- checklist autodeclarado "li X".

Desafio minimo nao-forjavel por heuristica:

1. O guard constroi a read-list efetiva a partir da fonte unica D1 e resolve ponteiros dinamicos: STATE atual, readback ativo e spec do papel.
2. Para cada path, calcula `blob_oid`, `sha256`, `bytes` e linhas nao vazias a partir do blob do indice local (`:path`) ou `HEAD:path` em CI.
3. Calcula `manifest_sha256 = sha256(canonical_json([{path, blob_oid, sha256, bytes, lines}], ordem_exata))`.
4. Calcula `seed_sha256 = sha256("orq-entrada.v1\n" + execution_id + "\n" + token_fp + "\n" + manifest_sha256)`.
5. Para pelo menos 3 itens obrigatorios, incluindo STATE, readback ativo e spec do orquestrador, escolhe uma linha nao vazia: `idx = uint32(sha256(seed_sha256 + "\n" + path + "\n" + blob_oid)[0:8]) % nonempty_line_count`.
6. A resposta deve trazer `line_no`, `line_text` exato e `line_sha256`. Para STATE/readback, deve trazer tambem campos parseados exatos: `readback_ativo`, `proxima_acao`, `implementador_id`, `files_forbidden[0..2]` quando existirem.
7. O guard recomputa tudo. Divergiu, falta arquivo, mudou blob, seed velha ou campo ausente: bloqueia.

Isto nao impede uma IA de usar um script para extrair as linhas. Esse e o ponto aceitavel: ela precisou acessar os bytes atuais do disco. O que nao pode passar e hash copiado, resposta decorada ou inferencia generica.

## Forma Exata Do Artefato

Arquivo: `.hbn/attestations/<execution_id>-orq-entrada.json`

```json
{
  "schema_version": "orq-entrada.v1",
  "attestation_id": "<execution_id>-orq-entrada",
  "execution_id": "<execution_id-do-ato-governado>",
  "agent_id": "<apelido-do-orquestrador>",
  "familia": "<familia-canonica>",
  "role": "orquestrador",
  "created_at": "<ISO8601-com-offset>",
  "state": {
    "path": ".hbn/relay/STATE.md",
    "readback_ativo": "<path-do-readback-ativo>",
    "bastao_token_fp": "<8-hex>",
    "chapeu_atual": "orquestrador"
  },
  "readlist_source": {
    "path": "core/role-cards.md",
    "blob_oid": "<git-blob-oid>",
    "rule": "PARTE_A_PLUS_SPEC_COMPLETA_DO_PAPEL"
  },
  "readlist": [
    {
      "path": ".hbn/relay/STATE.md",
      "blob_oid": "<git-blob-oid>",
      "sha256": "sha256:<64hex>",
      "bytes": 0,
      "nonempty_lines": 0
    }
  ],
  "manifest_sha256": "sha256:<64hex>",
  "challenge": {
    "algorithm": "orq-entrada.v1/extractive-lines",
    "seed_sha256": "sha256:<64hex>",
    "line_responses": [
      {
        "path": "<path>",
        "line_no": 1,
        "line_text": "<texto-exato-da-linha>",
        "line_sha256": "sha256:<64hex>",
        "nearest_heading": "<heading-anterior-ou-vazio>"
      }
    ],
    "field_responses": [
      {
        "path": ".hbn/relay/STATE.md",
        "field": "readback_ativo",
        "value": "<path-do-readback-ativo>"
      }
    ]
  },
  "binding": {
    "gated_act": "<dispatch|selagem|freeze>",
    "referenced_by": [
      "<path-do-artefato-que-declara-orq_entrada_ref>"
    ]
  }
}
```

Campos com placeholder sao obrigatorios. `bytes` e `nonempty_lines` sao numeros reais. A lista `readlist` deve conter todos os itens resolvidos, nao apenas STATE.

## ESBOCO assert-orq-entrada.sh

**Nome:** `guards/assert-orq-entrada.sh`

**Objetivo:** G-ORQ-ENTRADA valida que ato de autoridade do orquestrador referencia uma atestacao de entrada vigente, com blobs de leitura atuais e desafio extrativo correto.

**Gatilho local/CI:**

- modo runner local: usa o indice staged (`git diff --cached`, blobs `:path`);
- modo CI/range: se `HBN_DIFF_BASE` estiver setado, usa `HEAD` e diff `${HBN_DIFF_BASE}...HEAD`, como `assert-auditor-id.sh:76-91` e `assert-audit-diversity.sh:84-100`;
- dispara quando o diff adiciona/modifica:
  - `.hbn/dispatch/*.md`;
  - `.hbn/freeze/*.json`;
  - `.hbn/readbacks/*.json` cujo `readback_id` ou `execution_id` contenha `selagem`;
  - ou qualquer artefato governado que declare `orq_entrada_ref`.

**Contrato de entrada:**

- sem argumentos no runner;
- opcional direto: `bash guards/assert-orq-entrada.sh --require <artefato-governado>`;
- variavel suportada: `HBN_DIFF_BASE=<sha-base>` para range CI;
- depende de `python3` para JSON/front-matter, mesmo precedente de `assert-dispatch-integrity.sh:108-174` e `freeze-gate.sh:35-99`.

**O que compara:**

1. Cada artefato gatilho deve declarar `orq_entrada_ref: .hbn/attestations/<execution_id>-orq-entrada.json` em JSON/front matter.
2. A atestacao deve existir no indice/HEAD, modo git `100644`, e ter `schema_version="orq-entrada.v1"`, `role="orquestrador"` e `execution_id` igual ao ato governado.
3. `state.readback_ativo` deve bater com `.hbn/relay/STATE.md`; `bastao_token_fp` deve bater com os 8 primeiros hex de `bastao_token_sha256`; `chapeu_atual` deve ser `orquestrador` quando presente em `STATE.atribuicao`.
4. A read-list resolvida a partir da fonte unica D1 deve ser identica a `readlist[].path`, em ordem. Extra ou falta bloqueia.
5. Para cada item, `blob_oid`, `sha256`, `bytes` e `nonempty_lines` devem bater com o blob atual do indice/HEAD.
6. `manifest_sha256` e `challenge.seed_sha256` devem recomputar exatamente.
7. Cada `line_response` deve bater com a linha selecionada pelo algoritmo; cada `field_response` deve bater com parse do STATE/readback.
8. O artefato governado deve estar listado em `binding.referenced_by` e o `binding.gated_act` deve casar com o tipo do artefato.

**Onde falha fechado:**

- nao ha fonte unica de read-list ou ela e ambigua;
- STATE ausente/ilegivel;
- readback ativo ausente/ilegivel;
- `python3` ausente;
- `orq_entrada_ref` ausente em ato governado;
- atestacao ausente, nao-JSON, nao-100644, duplicada ou fora de `.hbn/attestations/`;
- attestation stale: qualquer blob mudou;
- resposta de desafio faltante, duplicada ou divergente;
- `execution_id`, token, readback ou papel divergem;
- em modo `--require`, nenhum ato governado encontrado.

**Saida e exit codes:**

- `0`: nenhum ato gatilho no diff, ou todos os atos gatilho tem G-ORQ-ENTRADA valido.
- `1`: bloqueio de politica/verificacao; mensagem via `guard_fail`, no estilo "G-ORQ-ENTRADA: <motivo>".
- `2`: uso invalido em modo direto ou dependencia de tooling indisponivel quando nao ha como produzir diagnostico seguro.

**Posicao no runner:**

P11: inserir apos `assert-dispatch-integrity.sh` no `GUARDS` do runner. O guard deve validar a propria fonte de read-list, sem exigir reordenar G-FRONTDOOR agora. Em onda futura, mover `assert-frontdoor.sh` antes de dispatch seria limpo, mas nao e pre-condicao.

## C. Hash-pin E Arquivos Que Mudam

Opcao P11: pin no artefato de atestacao e referencia no ato governado, nao pin global espalhado em todo readback.

- O readback/dispatch/freeze deve carregar apenas `orq_entrada_ref` e, se quiser redundancia barata, `orq_entrada_manifest_sha256`.
- A atestacao carrega os hashes dos blobs lidos.
- O guard compara contra o blob atual no momento do ato.
- Se qualquer arquivo da read-list mudou, a atestacao antiga e invalida.
- Re-pin = nova atestacao, novo `manifest_sha256`, nova referencia no ato governado, sob readback/human gate. Nunca editar a atestacao antiga.
- Para onda que altera a propria D1/read-list, usar dogfood com blobs staged no mesmo commit: o guard le `:path`, como os guards existentes fazem, e a atestacao precisa refletir a nova fonte staged.

Isso evita duas frestas: hash velho aceito depois de mudanca e "auto-refresh" de hash feito pelo proprio orquestrador sem rito.

## D. Freeze-gate E G-DIVERSITY

G-ORQ-ENTRADA deve ser pre-condicao dos atos em que o orquestrador transforma leitura em autoridade:

- **Despacho:** obrigatorio para criar/modificar `.hbn/dispatch/*.md`. Sem dispatch como artefato, nao ha onde o guard morder; portanto D3 e pre-requisito real.
- **Selagem:** obrigatorio no readback/handoff/STATE de selagem antes de contar pareceres como fechamento. G-DIVERSITY continua verificando quorum de familias (`.hbn/knowledge/0028...:18-31`); G-ORQ-ENTRADA verifica que o orquestrador que decidiu selar entrou pelo disco.
- **Freeze:** obrigatorio antes de `freeze-gate.sh` retornar "congelavel: sim". Pode ser criterio obrigatorio no checklist e/ou chamada direta dentro do freeze-gate antes da avaliacao dos criterios. Como `core/freeze-gate-spec.md:18-36` define freeze por exit code, falta de atestacao deve tornar o freeze nao congelavel.

Nao deve ser pre-condicao de:

- commit normal do implementador dentro de `files_allowed`;
- deposito de parecer por auditor em `.hbn/results/`;
- toda resposta de chat do orquestrador.

Essa fronteira preserva P11: protege atos de autoridade sem transformar cada interacao em cerimonia.

## E. Meta-padrao 0024

Depois de G-ORQ-ENTRADA, a proxima superficie sem governo sera o proprio metadado que configura o gate:

- `orq_entrada_ref` omitido ou apontando para atestacao de outro ato;
- read-list fonte D1 editada para remover itens incomodos;
- atestacao criada no mesmo commit que muda a read-list sem rito;
- desafio alterado para perguntas triviais;
- freeze checklist marcando `orq_entrada_ok` sem dereferenciar JSON.

Vale endurecer agora so o minimo:

1. fonte unica D1 guardada por G-FRONTDOOR/G-ORQ;
2. atestacao referenciada pelo ato;
3. desafio extrativo deterministico;
4. fail-closed em dispatch/selagem/freeze.

Nao vale, por enquanto, criar assinatura criptografica nova, verificador LLM obrigatorio em todo despacho, ou hash em todo ID. Isso repete o alerta de P11 ja aplicado em discussoes de numeracao/hash: o git e os guards ja dao integridade de bytes; a lacuna aqui e binding e desafio situado, nao mais opacidade.

## Decisao Recomendada

Implementar G-ORQ-ENTRADA como uma evolucao estreita:

1. corrigir D1 para uma unica read-list parseavel;
2. criar `.hbn/attestations/<execution_id>-orq-entrada.json`;
3. exigir `orq_entrada_ref` em dispatch/selagem/freeze;
4. implementar `assert-orq-entrada.sh` fail-closed;
5. adicionar testes negativos: sem atestacao, hash copiado/stale, desafio generico, resposta de linha errada, read-list com item faltante, re-pin automatico, selagem/freeze sem ref.

Isso fecha a fresta que produziu atestado falso/parcial sem fingir que um guard consegue provar estado mental da IA.
