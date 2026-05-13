# Autoevolve — interface humana

> Como um humano lê, aprova, ou reverte o que o ciclo Autoevolve fez na Quarta
> de Sanitização. Conversa curta, clara e à prova de pressa.

---

## 1) O que aconteceu hoje

Para qualquer ciclo:

```bash
hbn autoevolve status --cycle 2026-05-13
```

Saída em três linhas e uma tabela compacta:

```
cycle: 2026-05-13  entries: 16
arm           slug                             status    tests
--------------------------------------------------------------
autoevolve    bootstrap                        ok        ✓
site          feynman-doc                      ok        ✓
protocol-core protocol-invariant               ok        ✓
runtime       baton-staleness-pure             ok        ✓
...
```

Para obter o mesmo dado em JSON, agregue com `--json`:

```bash
hbn autoevolve status --cycle 2026-05-13 --json | jq .
```

## 2) Relatório agregado (markdown ou HTML)

Para colocar no site, na vitrine pública, ou compartilhar em uma issue:

```bash
# Markdown (cabeçalho + contagens + tabela)
hbn autoevolve audit --cycle 2026-05-13 --output reports/AUTOEVOLVE-2026-05-13.md

# Fragmento HTML pronto para colar em site/autoevolve.html
hbn autoevolve audit --cycle 2026-05-13 --html --output site/fragment.html
```

Ambos derivam do mesmo `.hbn/autoevolve/cycle-2026-05-13.jsonl`. **Não edite
o JSONL** — ele é append-only e auditável.

## 3) Como reverter UM microdelta

Cada microdelta é um commit isolado. Para desfazer:

```bash
hbn autoevolve rollback --commit <hash>
# imprime o git revert correspondente; cole no terminal.
```

Depois rode `pytest -q` para confirmar que a suite continua verde sem aquele
microdelta. Se ficar vermelha, era dependência — `git revert -m 1 <hash>` ou
investigar antes de continuar.

## 4) Como bloquear ciclos automáticos (gate humano)

Antes de qualquer Quarta em que você queira revisão linha-a-linha:

```bash
hbn autoevolve approve --lock
# cria .hbn/autoevolve/HUMAN_GATE — microdeltas auto ficam bloqueados.

hbn autoevolve approve            # consulta estado atual
hbn autoevolve approve --unlock   # libera novamente
```

Durante o gate, todo microdelta que chegar ao orquestrador será **gravado
como `skipped`** no audit JSONL, com nota `gate denied`. Nada some — a fila
fica preservada para você decidir manualmente o que vai e o que não vai.

## 5) Os sinais HBN que você verá no audit

Cada linha do `.jsonl` carrega um array `signals`. A composição canônica é:

| Signal | Significado |
|---|---|
| `INTENT_DECLARED` | A intenção do microdelta foi enunciada |
| `READBACK_OK` | A descrição da mudança foi confirmada |
| `EXECUTION_START` | O patch começou a ser aplicado |
| `EXECUTION_END` | O patch terminou de ser aplicado |
| `AUDIT_SEALED` | A linha foi gravada e selada no JSONL |
| `AUTOEVOLVE_TICK` | 17º signal — operacional, marca o ciclo |

Se algum desses sinais faltar em uma linha, é bandeira vermelha. O schema
`schemas/autoevolve-cycle.schema.json` valida `signals: minItems 1`, mas a
auditoria humana espera os seis.

## 6) Onde está o que

| Arquivo | O que tem dentro |
|---|---|
| `.hbn/autoevolve/cycle-2026-05-13.jsonl` | A trilha bruta, append-only |
| `methodology/adr/ADR-010-autoevolve-cycle.md` | A doutrina do ciclo (PROPOSED) |
| `docs/feynman/USEHBN-EXPLICADO.md` (+ `.docx`) | Explicação de tudo, estilo Feynman |
| `docs/PROPOSAL-V0.4.0.md` | Proposta de upgrade pós-ciclo |
| `site/autoevolve.html` | Vitrine pública do ciclo |
| `reports/AUTOEVOLVE-2026-05-13.md` | Relatório markdown deste ciclo |

## 7) Princípio orientador

O ciclo Autoevolve **não substitui** a Quarta de Sanitização. Ele é o
**veículo operacional** dela: entrega objetiva, padronizada, verificável,
dentro da janela de tokens IA. A Quarta continua sendo o ritual humano que
ratifica (HEARBACK) a entrega antes de qualquer promoção PROPOSED → ACCEPTED.

Se o ciclo gerar 16 microdeltas verdes e o humano não tiver lido nenhum, a
janela não pode promover ADR-010 a ACCEPTED nem bumpar PROTOCOL_VERSION. Isso
é por design.
