# Proposta — HBN v0.4.0 "Self-Improving Foundation"

> Proposta de upgrade do protocolo do HBN. Documento PROPOSED — não promove
> nada por si só. Promoção depende da bateria de testes humanos da tarde de
> 2026-05-13 e do Hearback explícito do operador.

---

## 1) Contexto

A v0.3.0 ("Honest Foundation") tem hoje:

- 182 testes verdes (eram 114 no início da Quarta 2026-05-13);
- 16 microdeltas aplicados em 14 braços, todos com commit e teste;
- ADR-010 depositado em PROPOSED com a doutrina do ciclo Autoevolve;
- 1 novo signal canônico (`AUTOEVOLVE_TICK`), totalizando 17;
- Documento Feynman + página pública (vitrine) + interface humana.

A v0.4.0 capta esse salto formalmente.

## 2) O que muda no `PROTOCOL_VERSION`

```
PROTOCOL_VERSION: 0.3.0 → 0.4.0   (minor bump — additive, no breaking change)
PACKAGE_VERSION: 0.3.0 → 0.4.0    (acompanha; permanece sincronizado nesta release)
```

Justificativa do **minor** (não major): toda mudança deste ciclo é
**aditiva**. Nenhum campo de schema mudou de tipo, nenhum subcomando do CLI
sumiu, nenhum contrato existente quebrou. Consumidores `usehbn-snapshot`
verão signal `⛓️ HBN PROTOCOL DEP CHANGE` mas não precisam de migração.

## 3) Capacidades novas em v0.4.0 (resumo)

1) **Protocolo de ciclo de auto-evolução** — ADR-010 PROPOSED, com
   contrato `MicrodeltaTask v1.0.0` JSON-serializável;
2) **Registry canônico de signals** — `src/usehbn/signals.py`
   (16 user-facing + 1 operacional);
3) **Schema novo** — `autoevolve-cycle.schema.json` (Draft 2020-12);
4) **CLI novo** — `hbn autoevolve {status, audit, approve, rollback}`;
5) **Puros novos** (reusáveis em downstream): `compute_baton_staleness`,
   `summarize_registry`, `summarize_state_document`,
   `resolve_language_fallback`, `get_protocol_invariant`,
   `aggregate_audit`, `render_html_fragment`, `_classify_trigger_origin`;
6) **Auditoria pública** — `site/autoevolve.html` renderizando o JSONL real;
7) **Documento Feynman** — primeiro material humano-amigável que admite com
   clareza o que é "funcional testado" vs "promessa de futuro".

## 4) Maturity Matrix — deltas propostos para v0.4.0

| Componente | v0.3.0 | v0.4.0 proposto |
|---|---|---|
| Autoevolve (orquestrador local) | (não existia) | **Implementado** |
| Autoevolve (computação distribuída) | (não existia) | **Scaffold** (interfaces prontas, sem workers remotos) |
| Signals registry | embedded strings | **Implementado** (módulo dedicado) |
| Audit aggregator | (não existia) | **Implementado** |
| Bridge maturity disclaimer | implícito | **Implementado** (campo machine-readable) |
| Tests | 114 verdes | **182 verdes** (+68) |

Componentes **não tocados** continuam com a mesma classificação: Universal
Translator permanece **Scaffold**, Bridge generation permanece **Stub**,
Phagocytosis permanece **Visão**.

## 5) Pré-condições para promoção

Para promover de PROPOSED → ACCEPTED v0.4.0:

1. **Testes humanos da tarde** (após 12:00 BRT) confirmados via
   `docs/HUMAN-VALIDATION-v0.4.0.md` (a criar);
2. **Cross-IA** sobre ADR-010 — pelo menos Codex OU Antigravity em paralelo;
3. **Hearback** explícito do operador em formato de boletim consolidado;
4. **Build local** verde em Linux + macOS + Windows (smoke);
5. **CHANGELOG** atualizado com bloco v0.4.0 listando os 16 commits.

## 6) Pré-condições NÃO atendidas (ainda)

- `Credenciamento` permanece em freeze V204; nada do ciclo toca em
  Credenciamento (verificado por `files_allowed` dos microdeltas);
- TestPyPI/PyPI não foram tocados;
- Push para `origin/main` não foi feito;
- A AGENTS.md e outros docs operacionais não foram revistos para
  consistência com ADR-010 — fica para o ciclo de manhã da próxima Quarta.

## 7) Comandos de promoção (depois do Hearback)

```bash
# 1. atualizar versões
hbn version  # confirma 0.3.0 antes da edição
sed -i.bak 's/0\.3\.0/0.4.0/' src/usehbn/__init__.py setup.cfg

# 2. atualizar CHANGELOG.md
${EDITOR:-vim} CHANGELOG.md  # adicionar bloco [0.4.0] - 2026-05-13

# 3. atualizar MATURITY-MATRIX.md
${EDITOR:-vim} methodology/MATURITY-MATRIX.md

# 4. promover ADR-010
sed -i.bak 's/status: PROPOSED/status: ACCEPTED/' methodology/adr/ADR-010-autoevolve-cycle.md
# atualizar data-ratificacao e hearback-status

# 5. testar
pytest -q
hbn doctor

# 6. tag local (sem push)
git tag v0.4.0
```

## 8) Calendário sugerido

| Quando | O quê |
|---|---|
| 2026-05-13 manhã (concluído) | Ciclo Autoevolve 16 microdeltas |
| 2026-05-13 13:00–17:00 BRT | Bateria de testes humanos da tarde |
| 2026-05-13 17:00–18:00 BRT | Hearback bloco do operador |
| 2026-05-14 | Cross-IA ADR-010 (Codex / Antigravity) |
| 2026-05-15+ | Possível tag v0.4.0 + push após gates verdes |

## 9) Nota final

Esta proposta nasce de **evidência empírica** (16 commits verdes,
182 testes verdes, todos os 14 braços tocados). Ela é diferente das
propostas anteriores que descreviam intenção: aqui está descrito o
**que já foi feito**, formalizado em um upgrade. Se a tarde de testes
humanos confirmar que tudo continua coerente, a promoção é o passo
honesto seguinte. Se algo quebrar, a proposta volta como
**SUPERSEDED**.
