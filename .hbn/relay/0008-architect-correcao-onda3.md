# Iteracao 0008 — Architect Deposit: Correcao Pre-Bastao da Nova Onda 3

**Tipo:** Architect Deposit (correcao de plano antes de bastao para Codex)
**Bastao atual:** claude-opus-4.7 (architect)
**Bastao desde:** 2026-04-29T08:07:00Z
**Origem:** humano autorizou seguir com Nova Onda 3 (mensagem 2026-04-29)

## Contexto

Apos confirmacao de Hearback final da Nova Onda 2 (commit `4a09523`,
worktree limpo, INDEX.md zerado), a proxima onda canonica e a
**Nova Onda 3 — Relay Invariants em Runtime**. Aplicando a licao
aprendida do ciclo anterior (architect deve auditar codigo antes de
planejar), eu (claude-opus-4.7, architect) inspecionei o codigo de
relay/baton em `src/usehbn/cli.py`, `src/usehbn/protocol/readback.py`
e `tests/test_relay.py` antes de bastonar Codex.

A inspecao detectou duas divergencias entre o plano original
(`docs/WAVE-PLAN-V0.3.0.md`, secao "Onda 3 (NOVA)") e o codigo real.
Sem correcao, Codex pararia corretamente no Passo 1 do superprompt
ao tentar abrir `src/usehbn/relay/*.py`.

## Achados

### Achado 1 — Localizacao do codigo de relay

- Plano lista `src/usehbn/relay/*.py` como **arquivo permitido**.
- Esse modulo NAO existe.
- Toda a logica vive em `src/usehbn/cli.py`:
  - `_load_relay_state` (linha 1486)
  - `_save_relay_state` (linha 1508)
  - `_find_pending_readbacks` (linha 1526)
  - `run_relay_status` (linha 1515)
  - `run_handoff` (linha 1538)
- Extracao para um modulo dedicado faz parte do refator do "god-object"
  CLI marcado em `MATURITY-MATRIX.md`, e e trabalho de **v0.4.0**
  (Onda 7 hipotetica). Em **v0.3.0** o objetivo e honestidade
  comportamental do Relay, nao reorganizacao estrutural.

### Achado 2 — Invariante "handoff bloqueia readback pendente" mais quebrada do que descrito

- Plano original menciona apenas: "handoff deve falhar se existir
  Readback pending sem Hearback".
- Codigo atual de `_find_pending_readbacks` (`cli.py:1526`):
  ```python
  hbn_dir = _hbn_dir(target)
  readbacks_dir = hbn_dir / "readbacks"
  ```
  Le APENAS `.hbn/readbacks/`.
- Codigo atual de `create_readback_record` (`protocol/readback.py:24`):
  ```python
  def _readbacks_dir(storage_dir: Optional[Path] = None) -> Path:
      readbacks_dir = default_state_dir(storage_dir) / READBACKS_DIRNAME
  ```
  Escreve em `default_state_dir(storage_dir) / "readbacks"`. O default
  e `.usehbn/readbacks/`.
- Consequencia em uso real: `run_handoff` **nunca** vai detectar
  readback pendente criado pelo fluxo padrao do CLI HBN. A invariante
  central do protocolo (Readback pendente bloqueia bastao) e ficcao
  no caminho feliz.
- Evidencia adicional: o teste de integracao
  `test_two_agent_handoff_cycle` (`tests/test_relay.py:341-425`)
  precisa copiar manualmente o readback de `.usehbn/readbacks/` para
  `.hbn/readbacks/` (linhas 374-379) para que o handoff falhe. O
  comentario do proprio teste explicita o sintoma: "handoff checks
  `.hbn/readbacks/`, not `.usehbn/readbacks/`".

### Achado 3 — Invariantes (b) e (c) confirmadas como ausentes

- `audit_trail`, `baton_staleness_seconds`, `baton_stale`: nenhum
  destes existe em `src/usehbn/`. Confirmado via `grep`.
- `_save_relay_state` apenas escreve novo estado; nao preserva
  historico alem do `last_handoff` singular.

## Decisoes do architect

1. **Manter Onda 3 com escopo cirurgico em `cli.py`.**
   Nao criar `src/usehbn/relay/`. Refator e v0.4.0.
2. **Promover o achado 2 (path mismatch) ao topo da Onda 3.** E o
   bug invisivel mais grave do componente Relay e ja existia antes
   das outras invariantes. Resolve-lo primeiro torna (b) e (c)
   significativas.
3. **Manter (b) audit_trail (last 10) e (c) baton staleness check
   (default off, advisory).** Sem enforcement nesta onda, alinhado a
   doutrina "honest foundation".
4. **Atualizar `test_two_agent_handoff_cycle`** para nao depender mais
   do hack de copia manual entre dirs. Comportamento esperado: teste
   continua passando, agora sem o copy.
5. **Sem nova superficie publica.** Subcomandos `relay status` e
   `handoff` mantem contrato; campos novos no JSON sao apenas adicoes.

## Plano executavel da Nova Onda 3 (versao corrigida)

Disponivel em `docs/WAVE-PLAN-V0.3.0.md`, secao "Onda 3 (NOVA) — Relay
Invariants em Runtime", revisao 2026-04-29 (segunda correcao).

Resumo:

| Item | Detalhe |
|------|---------|
| Arquivos permitidos | `src/usehbn/cli.py` (apenas 5 funcoes); `tests/test_relay.py` |
| Arquivos proibidos | Schemas; `engine/`; `protocol/`; novos modulos; novos subcomandos CLI |
| Tests obrigatorios | 7 testes (3 sobre path-fix; 2 sobre audit_trail; 2 sobre staleness) |
| Gates | G1 (Hearback escopo), G2 (pre-deposit grep check), G4 (CLI publica intacta), G5 (doutrina) |
| Riscos R1-R4 | Documentados; R3 cobre alteracao do teste integrado |

## Superprompt para Codex (Nova Onda 3)

```
Voce e Codex, atuando como cirurgiao em Onda 3 do plano canonico
docs/WAVE-PLAN-V0.3.0.md (revisao 2026-04-29 segunda correcao).

LEITURA OBRIGATORIA antes de qualquer alteracao:
1. agents/wave-protocol.md (contrato).
2. docs/MATURITY-MATRIX.md (estado canonico).
3. docs/WAVE-PLAN-V0.3.0.md secao "Onda 3 (NOVA)" + secao "Revisao
   2026-04-29 (segunda correcao)".
4. .hbn/relay/0008-architect-correcao-onda3.md (este deposit, com
   achados completos).
5. tests/test_relay.py linhas 341-425 (entender por que existe o hack
   de copia entre `.usehbn/readbacks/` e `.hbn/readbacks/`).

PASSO 1 — Pre-deposit check (gate G2):
- Execute `grep -nE "audit_trail|baton_staleness_seconds|baton_stale" \
  src/usehbn/cli.py` e confirme zero matches.
- Execute `grep -n "default_state_dir" src/usehbn/protocol/readback.py`
  para confirmar onde readbacks sao escritos.
- Se algum dos achados deste deposit nao se sustentar no codigo atual,
  PARE e peca Hearback humano.

PASSO 2 — Criar Readback inicial em .hbn/relay/0009-onda-3-relay-invariants.md
com:
  - readback_id correspondente.
  - track: safe_track.
  - understanding: 1 paragrafo explicando que esta onda corrige path
    mismatch de readbacks + adiciona audit_trail + adiciona staleness
    advisory, todos em src/usehbn/cli.py.
  - invariants_preserved: ["doutrina HBN", "CLI publica", "schemas",
    "engine.py", "protocol/", "default_state_dir"].
  - action_plan: 7 passos correspondendo aos 7 testes do plano.
  - residual_risks: R1-R4 do plano.
  - hearback_status: pending.
PARE aqui. Aguarde Hearback humano explicito antes do Passo 3.

PASSO 3 — Implementacao em src/usehbn/cli.py (apenas as 5 funcoes
listadas em "Arquivos permitidos"; NAO tocar nada fora):

A. _find_pending_readbacks(target):
   - Ler de AMBOS os dirs:
     - `.hbn/readbacks/` (path atual).
     - `default_state_dir(target) / "readbacks"` (importar de
       src/usehbn/state/store.py — verificar nome real).
   - Dedup por execution_id; quando duplicado, preferir entrada
     com hearback_status == "pending".
   - Retornar lista ordenada estavel.

B. _save_relay_state(target, state):
   - Antes de escrever, garantir state["audit_trail"] como lista.
   - Quando handoff: append {from, to, at, summary} e cap em 10
     entradas (slice [-10:]).
   - Compatibilidade backward: se state recebido nao tem
     audit_trail, criar lista vazia e popular.

C. _load_relay_state(target):
   - Tolerar audit_trail ausente (default = []).
   - Levantar ValueError apenas se audit_trail existir mas tipo
     for invalido.

D. run_handoff(args):
   - Apos validar pending readbacks (Achado 2 ja resolvido em A),
     adicionar entrada ao audit_trail antes de _save_relay_state.

E. run_relay_status(args):
   - Se state contem chave baton_staleness_seconds (int > 0):
     calcular delta = now - baton_since.
     adicionar campo top-level "baton_stale": delta > staleness.
   - Se chave nao existe ou eh None: NAO adicionar campo
     "baton_stale" no retorno.

PASSO 4 — Tests em tests/test_relay.py (adicionar 6 novos; ajustar
test_two_agent_handoff_cycle):
  - test_handoff_blocks_on_pending_usehbn_readback
  - test_find_pending_readbacks_dedups_when_present_in_both_dirs
  - test_handoff_audit_trail_preserves_last_ten
  - test_handoff_audit_trail_backward_compatible
  - test_relay_status_baton_stale_flag_when_configured
  - test_relay_status_no_baton_stale_field_by_default
  - Ajustar test_two_agent_handoff_cycle para REMOVER as linhas
    374-379 (copia manual de .usehbn -> .hbn) e validar que o
    handoff_fail_args agora bloqueia diretamente (sem copy).
    Comentar a remocao.

PASSO 5 — Verificacoes:
- pytest -q deve passar (esperado: 96+ tests verdes; 90 atuais + 6
  novos).
- git diff --stat: apenas 2 arquivos alvo (cli.py + test_relay.py)
  + 2 arquivos de relay (.hbn/relay/0009*.md + INDEX.md).
- grep doutrinario: nenhum termo imutavel renomeado.

PASSO 6 — Gravar ERP:
hbn result exec-<onda3-id> --agent-id codex \\
  --action "Onda 3: relay invariants — path-fix, audit_trail, staleness advisory" \\
  --outcome executed --human-status not_reviewed \\
  --readback-id readback-exec-<onda3-id> \\
  --evidence "deposit:.hbn/relay/0008-architect-correcao-onda3.md" \\
  --evidence "plan:docs/WAVE-PLAN-V0.3.0.md"

PASSO 7 — Atualizar .hbn/relay/INDEX.md:
- Iteracao 0009 marcada como "resolvido-aguardando-hearback-final".
- Bastao volta para humano.
- Readback 0009 permanece em .hbn/relay/ ate Hearback final.

PASSO 8 — Reportar resultado ao humano. Aguardar Hearback final
antes de qualquer arquivamento ou commit.

PROIBICOES (rejeitar imediatamente):
- Criar src/usehbn/relay/ ou outros novos modulos.
- Tocar src/usehbn/protocol/, src/usehbn/engine/, schemas/.
- Adicionar novos subcomandos CLI.
- Renomear funcoes ou parametros existentes.
- Mover codigo de relay para fora de cli.py.
- Renomear ou traduzir termos doutrinarios.
- Escrever em PyPI, push remoto ou commit final sem Hearback.

EM CASO DE DUVIDA: PARE e peca Hearback. Codex e cirurgiao, nao
arquiteto.
```

## Validacao humana necessaria (gates)

| Gate | Decisao | Estado |
|------|---------|--------|
| G1 — escopo correcao da Onda 3 | aprovar plano corrigido | aguardando |
| G2 — autorizacao para Codex iniciar pre-deposit check | bastao para codex | aguardando |
| Cancelamento alternativo | rejeitar correcao e definir caminho diferente | aguardando |

## Frase canonica do humano para o Codex (apos Hearback)

> "Codex, executar Nova Onda 3 conforme `.hbn/relay/0008-architect-correcao-onda3.md`
> e `docs/WAVE-PLAN-V0.3.0.md` secao 'Onda 3 (NOVA) — Relay Invariants em Runtime'.
> Crie Readback 0009. Pare apos Passo 2 e aguarde Hearback antes de implementar."

## Frase canonica do humano para o architect (auditoria pos-execucao)

> "Claude, auditar Nova Onda 3 contra `agents/wave-protocol.md`,
> `docs/WAVE-PLAN-V0.3.0.md` e `.hbn/relay/0008-architect-correcao-onda3.md`."

## Hearback necessario

Aguardo Hearback humano explicito sobre:

1. Aprovacao do escopo corrigido da Onda 3 (achados 1, 2 e 3 acima).
2. Autorizacao para passar bastao a Codex com o superprompt acima.
3. Confirmacao de que `usehbn` e `hbn` continuam canonicos (decisao Q14)
   — sem mudanca nesta onda.

Sem Hearback, bastao permanece com architect.
