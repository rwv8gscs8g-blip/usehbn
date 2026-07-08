# RFC-0001 — Modo `--enforce` para Guardian e Truth Barrier

**Status:** open for human comment
**Autor:** Claude Opus 4.7 (architect, sob bastao em itercao 0002)
**Aprovacao final:** Luis Mauricio Junqueira Zanin
**Data de abertura:** 2026-04-29
**Janela de comentarios:** minimo 14 dias antes de qualquer execucao
**Versao alvo:** v0.4.0 (NAO entra em v0.3.0)

---

## 1. Sumario

Hoje, Guardian (`src/usehbn/protocol/guardian.py`) e Truth Barrier
(`src/usehbn/protocol/truth_barrier.py`) emitem warnings que sao registrados
mas nao bloqueiam o pipeline em `src/usehbn/execution/engine.py`. Em
`tests/`, os testes confirmam o comportamento atual: warnings agregados, sem
gate.

Esta RFC propoe **abrir um modo `--enforce` opt-in** para que esses dois
componentes possam, em ambientes onde o humano deseja, **bloquear o pipeline
apos avisos fortissimos**. O default permanece advisory.

A decisao humana vinculante (resposta a pergunta 5 e 6 do diagnostico):

> "Modo `--enforce` opt-in: pode bloquear apos emissao de avisos fortissimos."

## 2. Motivacao

Truth Barrier e Guardian sao componentes doutrinarios fortes. Sem qualquer
forma de enforcement, a promessa publica do HBN ("ferramenta para reduzir
risco em engenharia assistida por IA") tem limite estreito: o agente pode
ignorar warnings.

Ao mesmo tempo, transformar advisory em bloqueio universal e perigoso:

- Quebra compatibilidade silenciosa.
- Pode parar pipelines em uso real por causa de regex frageis.
- Move o HBN para "ferramenta autoritaria" antes de o codigo merecer.

A solucao e introduzir enforcement como capacidade explicita, opt-in,
configuravel, e com base em avisos fortissimos antes do bloqueio.

## 3. Princippios desta RFC

1. **Advisory continua sendo o default.** Nada muda para usuarios atuais
   sem opt-in explicito.
2. **Enforcement e opt-in declarado.** Ativacao explicita via flag CLI ou
   arquivo de politica.
3. **Bloqueio so apos avisos fortissimos.** O modo nao bloqueia
   silenciosamente: emite mensagem clara, especifica, citavel, antes de parar.
4. **Reversibilidade.** O modo pode ser desligado sem deixar estado
   imigratorio em `.hbn/`.
5. **Humano pode sempre forcar passagem.** Mesmo com `--enforce`, o humano
   pode liberar a execucao com Hearback explicito (`--override`).

## 4. Semantica proposta

### 4.1 Niveis de severidade

Warnings emitidos por Guardian e Truth Barrier passam a carregar campo
`severity`:

- `info` — observacional, nunca bloqueia.
- `warning` — atencao requerida, bloqueia em modo `enforce-strict`.
- `critical` — bloqueia em qualquer modo `enforce-*`.

Hoje, a estrutura ja existe (`severity: "warning"` em ambos modulos). A
mudanca e adicionar `critical` para casos especificos (a ser definido por
estagio em `docs/PHAGOCYTOSIS.md` para tecnologias digeridas).

### 4.2 Modos disponiveis

| Modo | Comportamento |
|---|---|
| `advisory` (default) | Warnings emitidos. Pipeline prossegue normalmente. Comportamento atual. |
| `enforce-soft` | Warnings emitidos. Apenas `critical` bloqueia. Apos critical, exibe mensagem fortissima e exit code != 0, a menos que Hearback `--override` seja apresentado. |
| `enforce-strict` | Warnings emitidos. Tanto `warning` quanto `critical` bloqueiam apos mensagem fortissima. Override por Hearback explicito permitido. |

Default para todos os usuarios atuais: `advisory`. Migracao para qualquer
outro modo e ato registrado.

### 4.3 Ativacao

Tres caminhos de ativacao, em ordem de precedencia:

1. **CLI flag** (sessao unica): `hbn run --enforce-mode enforce-soft "..."`.
2. **Arquivo de politica do projeto:** `.hbn/policy/enforcement.json`:
   ```json
   {
     "mode": "enforce-soft",
     "scope": "project",
     "set_at": "2026-04-29T05:30:00Z",
     "set_by": "humano:luis-mauricio",
     "approved_via": "readback-exec-NNNN"
   }
   ```
3. **Variavel de ambiente** (CI/CD): `HBN_ENFORCE_MODE=enforce-strict`.

A precedencia e: CLI flag > env var > arquivo de politica > default
`advisory`.

### 4.4 Mensagem de bloqueio

Antes de qualquer bloqueio, o engine emite a "mensagem fortissima":

```
❌ HBN SECURITY BLOCKED SUGGESTION

Severity: critical
Origem: <Guardian|Truth Barrier>
Codigo do warning: <code>
Evidencia: <evidence>

Para sua seguranca e conformidade, a acao da IA foi bloqueada
provisoriamente pelo Human Brain Net ao aplicar pensamento humano associado
ao contexto.

O ciclo nao deve prosseguir sem passar por analise humana.

Para liberar manualmente, gere um Readback explicito com `understanding`
contendo justificativa, e execute novamente com `--override <readback_id>`.

Digite A para retirar o aviso sonoro ou digite B para apenas piscar a tela.
```

### 4.5 Override humano

Apos bloqueio, o humano pode:

1. Criar Readback com `understanding` justificando a passagem.
2. Confirmar Hearback.
3. Re-executar com `--override <readback_id>`.

O ERP da execucao subsequente registra:

```json
{
  "hbn_outcome": "executed_with_risk",
  "human_decision": {
    "status": "conditional",
    "review_notes": "<justificativa do override>"
  },
  "override_basis": {
    "readback_id": "readback-exec-NNNN",
    "blocked_warnings": [{"code": "...", "severity": "critical"}]
  }
}
```

### 4.6 Configuracao de politica via `hbn policy`

Subcomando novo proposto (entra em onda v0.4.0):

```
hbn policy enforcement set --mode enforce-soft --readback <id>
hbn policy enforcement get
hbn policy enforcement clear
```

Toda mudanca de politica exige `--readback <id>` valido com `hearback_status`
= `confirmed`. Nao ha mudanca de politica de enforcement sem Hearback.

## 5. O que esta RFC NAO propoe

- NAO propoe ativar enforcement por default em qualquer release.
- NAO propoe bloquear silenciosamente (sem mensagem fortissima).
- NAO propoe desabilitar advisory mode.
- NAO propoe tornar warnings detectaveis por LLM externo (zero acoplamento
  remoto).
- NAO propoe enforcement de Consent (escopo separado, RFC futura).
- NAO propoe afetar Readback ou ERP (esses ja sao gates implementados).

## 6. Impacto em compatibilidade

| Cenario | Comportamento atual | Comportamento apos RFC |
|---|---|---|
| Usuario nao toca em config | Warnings advisory | Warnings advisory (idem) |
| Usuario quer enforcement | Nao disponivel | Opt-in via flag/env/policy |
| Schemas | Sem mudanca | Sem mudanca em v0.4 (warnings ja tem `severity`) |
| Testes existentes | Verdes | Continuam verdes (default advisory) |

Conclusao: zero quebra de compatibilidade no opt-in.

## 7. Caminho de execucao proposto

Esta RFC NAO autoriza implementacao em v0.3.0. Em v0.3.0 entra apenas o
documento. A implementacao real fica em v0.4.0 e exige:

1. **Onda v0.4-A:** introduzir parametro `enforce_mode` em `engine.execute_request`,
   defaulting para `advisory`. Nada bloqueia ainda. Apenas o parametro existe.
2. **Onda v0.4-B:** introduzir `severity = "critical"` para warnings
   especificos, com base em regras de tecnologias `Digested`
   (ver `docs/PHAGOCYTOSIS.md`).
3. **Onda v0.4-C:** introduzir bloqueio em `engine.execute_request` quando
   `enforce_mode != "advisory"` e existe warning na severidade alvo. Saida
   nao-zero do CLI. Mensagem fortissima.
4. **Onda v0.4-D:** introduzir `--override <readback_id>` no CLI e ERP.
5. **Onda v0.4-E:** introduzir `hbn policy enforcement` subcomando.

Cada onda exige Readback + Hearback humano antes da proxima.

## 8. Riscos

- **R1:** Codex tentar implementar antes de v0.4. Mitigacao: este RFC fica
  marcado `status: open for human comment` e `versao alvo: v0.4.0`. Ondas
  v0.3.0 nao mencionam enforcement.
- **R2:** Severidade `critical` se aplicar a warnings que sao falso-positivo
  por causa do regex. Mitigacao: severidade `critical` so aplica a regras
  oriundas de tecnologias em estagio `Digested` da Phagocytosis (regras
  testadas).
- **R3:** Override virar burocracia teatral. Mitigacao: `--override` exige
  Readback com `understanding` minLength alta e `human_decision.status =
  conditional` no ERP.

## 9. Como contribuir

Comentarios humanos sobre esta RFC: abrir issue
`[rfc-0001] comentario sobre enforce-mode`. Apos minimo 14 dias de janela e
aprovacao do mantenedor, status muda para `accepted` e a primeira onda
(v0.4-A) torna-se elegivel.

## 10. Decisao

Aguardando Hearback humano para confirmar:

- O modelo de modos (`advisory`, `enforce-soft`, `enforce-strict`).
- A semantica de override por Readback.
- O caminho de execucao em 5 ondas em v0.4.0.

Sem Hearback, esta RFC permanece em `open for human comment`.
