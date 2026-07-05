# HBN Wave Protocol — Diretrizes Canonicas para Execucao em Ondas

> Este e o contrato que TODA IA executora deve respeitar ao executar uma
> "onda" de mudanca no HBN. Vale para Codex, Claude, Cursor, qualquer outra
> IA, ou para o proprio humano operando como agente.

## Definicao de "onda"

Uma **onda** e uma unidade pequena, reversivel e auditavel de mudanca
no HBN, com:

- escopo declarado por arquivos permitidos e proibidos;
- objetivo unico;
- testes obrigatorios;
- Readback antes de qualquer alteracao;
- Hearback humano antes de cada onda;
- ERP no final;
- rollback documentado.

Uma onda nao e um "PR generico". E uma transacao protocolada.

## Gates obrigatorios em qualquer onda

Estes gates aplicam a TODAS as ondas, nao apenas as de v0.3.0:

| # | Gate | Quando | Quem aprova | Forma |
|---|------|--------|-------------|-------|
| G1 | Antes de qualquer alteracao | Inicio da onda | Humano | Hearback explicito apos leitura do plano |
| G2 | Antes de mudar estado em `.hbn/` ou `state/` | Onda toca persistencia | Humano | Plano de migracao + plano de rollback |
| G3 | Antes de mudar `schemas/*.json` | Onda toca schema | Humano | RFC + impacto retroativo |
| G4 | Antes de qualquer enforcement de Guardian/Truth Barrier | Onda implementa `--enforce` | Humano + revisor externo | RFC `accepted` + teste adversarial |
| G5 | Antes de mexer com Credenciamento | Onda toca docs/cases ou referencia tecnica | Humano + autores externos | Autorizacao escrita |
| G6 | Antes de release publica (TestPyPI/PyPI) | Onda 5 e similares | Humano | Smoke test 3 OS + CHANGELOG fechado |
| G7 | Antes de alterar termos doutrinarios | Onda toca lista doutrinaria | Humano + autoria do protocolo | RFC + bump major |
| G8 | Antes de adicionar dependencia externa | Onda muda `pyproject.toml`/`setup.cfg` | Humano | Justificativa + analise de licenca |

Pulei algum gate = onda invalida. Roll back imediato.

## Lista doutrinaria imutavel (v0.3.0)

Termos abaixo NAO podem ser renomeados, traduzidos para outras palavras-
chave, ou substituidos em codigo, schemas ou docs sem RFC formal e bump de
major:

```
Readback
Hearback
Guardian
Truth Barrier
ERP
Relay
Baton
Consent
Handoff
Track (fast_track | safe_track)
Universal Translator
Phagocytosis
usehbn
hbn
use hbn
```

Os nomes `usehbn` e `hbn` sao **igualmente canonicos** (resposta Q14 do
diagnostico). Nenhum dos dois pode ser depreciado em v0.3.0.

`Universal Translator` e mantido por decisao humana (Q12). A doutrina honesta
sobre o que ele faz hoje vs. o que sera no futuro vive em
`docs/PHAGOCYTOSIS.md`.

## Fluxo obrigatorio de qualquer onda

```
1. Ler input
2. Criar Readback inicial em .hbn/relay/
3. PARAR e aguardar Hearback humano
4. Apos Hearback confirmed, executar passos
5. Rodar testes (pytest -q antes e depois)
6. Verificar diff contra arquivos proibidos
7. Verificar grep contra renomeacao de termos doutrinarios
8. Gravar ERP via hbn result
9. Atualizar .hbn/relay/INDEX.md
10. Devolver bastao
```

Nenhum desses passos e opcional.

### 1. Ler input

A IA executora le, na ordem:

- `.hbn/relay/INDEX.md` (estado atual do relay).
- A iteracao ativa em `.hbn/relay/000N-*.md`.
- Os arquivos da `Lista de Leitura Obrigatoria` da onda.

Sem ler todos, a onda nao comeca.

### 2. Criar Readback inicial

Em `.hbn/relay/000N-onda-<nome>.md`, conforme template existente em
`.hbn/relay/INDEX.md`. Campos minimos:

- Bastao (quem esta executando)
- Estado: ativo
- Contexto Recebido
- O Que Sera Feito (diff planejado por arquivo)
- O Que NAO Sera Feito (lista de arquivos proibidos)
- Riscos (minimo 3)
- Proximo Passo apos onda
- created_at em UTC ISO 8601 com sufixo Z

### 3. Parar e aguardar Hearback

A IA executora PARA aqui. Nao prossegue sem Hearback humano explicito.
Hearback pode ser:

- Atualizacao de `hearback_status` em registro `.hbn/readbacks/`.
- Mensagem humana confirmando explicitamente o plano da onda.

### 4. Executar passos

Apos Hearback, executar mudancas em ordem:

- Cada arquivo modificado deve estar declarado em "O Que Sera Feito".
- Nenhum arquivo proibido pode ser tocado.
- Nenhum termo doutrinario pode ser renomeado.

### 5. Rodar testes

Antes da primeira mudanca:
```
pytest -q
```
Apos a ultima mudanca:
```
pytest -q
```

Resultado obrigatorio: zero regressao.

### 6. Verificar diff

```
git diff --stat
```

E confirmar que nenhum arquivo da lista proibida foi tocado. Se foi:

- desfazer essa parte do diff;
- registrar a violacao no Readback;
- pedir Hearback humano sobre como prosseguir.

### 7. Verificar termos doutrinarios

```
grep -RIn "hearback\|readback\|guardian\|truth barrier\|relay\|baton\|consent\|handoff\|universal translator\|phagocytosis\|usehbn\|hbn" src/ docs/ schemas/ core/ agents/
```

Resultado obrigatorio: nenhum desses termos foi renomeado em arquivos
modificados pela onda.

### 8. Gravar ERP

```bash
hbn result <execution_id> \
  --agent-id <agente> \
  --action "<onda> - <resumo>" \
  --outcome <executed|executed_with_risk|failed> \
  --human-status not_reviewed \
  --readback-id readback-<execution_id> \
  --evidence "audit:<arquivo-de-auditoria>" \
  --evidence "diff:<commit-hash-ou-branch>"
```

ERP sem `readback-id` em onda safe_track e violacao de protocolo.

### 9. Atualizar `.hbn/relay/INDEX.md`

Atualizar `Bastao atual` e `Ultima atualizacao` se houver handoff. Se nao
houver, manter e adicionar entrada de progresso na iteracao ativa.

### 10. Devolver bastao

Devolver o bastao para `humano` por default. O humano decide:

- aceitar o resultado e seguir para proxima onda;
- pedir auditoria do `claude` antes de seguir;
- reverter a onda;
- pausar.

## Lista de "NAO faca" universal

Independente da onda, a IA executora NAO pode:

- Refatorar fora do escopo declarado.
- Renomear funcoes, classes, subcomandos publicos da CLI.
- Renomear termos doutrinarios.
- Adicionar dependencia externa sem G8.
- Alterar `src/usehbn/execution/engine.py` em v0.3.0 (congelado).
- Alterar `schemas/` sem G3.
- Tocar em `docs/CASE-STUDY-CREDENCIAMENTO.md` sem G5.
- Apagar conteudo em `reports/`.
- Inventar metricas em README ou release notes (toda afirmacao numerica
  exige fonte).
- Pular Readback/Hearback.
- Fazer `git push` direto. Branch + revisao humana sao obrigatorios.
- Ativar enforcement, telemetria, ou comportamento outbound novo sem RFC.

## Como Codex deve operar especificamente

Codex e o executor primario das ondas v0.3.0. Codex deve:

- Tratar este documento como restricao operacional, nao como guideline
  flexivel.
- Se em qualquer momento o prompt da onda contradiz este documento, pausar
  e pedir Hearback humano.
- Se em qualquer momento ha tentacao de refatorar codigo "para
  consistencia", pausar e pedir Hearback humano.
- Se em qualquer momento um termo doutrinario parece "incorreto" ou
  "datado", pausar e pedir Hearback humano. **Nunca renomear unilateralmente.**

Em outras palavras: Codex e cirurgiao, nao arquiteto.

## Como Claude deve operar especificamente

Claude (este papel: arquiteto principal) deve:

- Pegar o bastao apenas para depositar artefatos doutrinarios estruturais
  (markdown).
- Nao executar ondas de codigo. Codigo e Codex.
- Quando o humano pedir auditoria, examinar diffs, executar `pytest -q` mental
  e verificar conformidade com este wave-protocol.
- Em caso de violacao detectada na auditoria, propor reversao em vez de
  correcao no lugar.

## Auditoria de aderencia

Apos cada onda, antes de avancar para a proxima, o humano pode invocar
auditoria:

> "Claude, auditar onda <nome> contra wave-protocol.md."

A auditoria retorna:

- Conformidade: pass | warn | fail.
- Lista de artefatos violados.
- Recomendacao: aceitar | revisar | reverter.

Sem auditoria, a proxima onda comeca apenas se o humano aceita o risco
explicitamente.
