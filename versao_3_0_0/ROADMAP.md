---
titulo: ROADMAP v3.0.0 — roteiro de retomada da operação para o próximo orquestrador
tipo: spec
status: ativo
temperatura: quente
path: ROADMAP.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: nativo
alvo: "\"Claude Opus (próximo orquestrador), sob Decreto 20260703-000500 — perfil relator não-decisório; todo ato depende de dispatch-artefato + hearback humano\""
---
# ROADMAP v3.0.0 — retomada da operação

> Para o próximo orquestrador (Claude Opus): execute as fases NA ORDEM, uma
> por vez (R3 do BOOT §9). Cada fase fecha com evidência em disco + hearback
> do gate humano onde indicado. O Decreto está vigente: você RELATA e prepara
> dispatches; quem decide é o gate; quem implementa é o implementador
> designado; quem audita são ≥2 famílias independentes.

## Fase 1 — Ativação do v3.0.0

1. **Auditoria cruzada da terceira exúvia** por 2 famílias independentes
   (**Gemini** e **Grok**): read-only sobre a working tree preparada;
   pareceres em `.hbn/results/` com `APROVA_0001 SIM|NAO`. Foco: G-HOT-WRITE,
   G-NO-PENDING-EXUVIA, rito atômico, membrana, BOOT-LOCK, glacier íntegro.
2. **Hearback do gate humano**: Maurício confirma o readback
   `.hbn/readbacks/0001-terceira-exuvia-genese.json`
   (`human_status: confirmed`) — é essa confirmação que o G-HOT-WRITE exige
   para o commit de exúvia.
3. **Flip**: o operador humano executa UM commit atômico contendo todo o
   staging (glacier `versao_0_3_x/` + congelamento `versao_2_0_0/` + pasta
   `versao_3_0_0/` + `.hbn/active-version = versao_3_0_0` + raiz esvaziada).
   Trailers HBN no commit; runner verde; sem `--no-verify`.
4. Critérios de fitness: `core/exuvia-fitness-criteria.md`. Falhou → congela
   ou descarta a proposta (G-NO-PENDING-EXUVIA não deixa pendurar).

## Fase 2 — Propagação da membrana

1. Rodar no genoma: `bash versao_3_0_0/scripts/hbn-upgrade-snapshot.sh
   --target ~/Projetos/Credenciamento --dry-run` → conferir → `--install`
   (sem `--dry-run`). O script gera `MEMBRANE_MANIFEST.json`
   (source_version + source_commit + sha256 byte-a-byte), troca o snapshot
   atomicamente e instala `assert-snapshot-integrity.sh` no consumidor.
2. Commit no Credenciamento: ato do operador, sob o rito do projeto.
3. **Confirmar que todos os 36 guards canônicos** do runner estão
   classificados e ativos no perfil do consumidor — eliminar a omissão
   silenciosa (guard não classificado = erro, não skip). Evidência:
   saída do runner do consumidor listando cada guard com veredicto.

## Fase 3 — Ponte de retroalimentação e saneamento do legado

1. Criar o canal oficial de retroalimentação (3 níveis):
   - **L1** problema local → knowledge local do projeto;
   - **L2** melhoria de protocolo → sobe ao genoma via `inbox/`
     (o antigo `versao_0_3_x/inbox/` é histórico; criar `inbox/` dentro desta
     versão na primeira onda de desenvolvimento normal, com guard de triagem);
   - **L3** correção dupla → registrada nos dois lados, com referência
     cruzada.
2. Resolver os incidentes abertos da sessão anterior (`110632`, `110633` e
   irmãos, registrados em `~/Projetos/Credenciamento/.hbn/incidents/`):
   consolidar o fechamento via hearback do gate; cada incidente fecha com
   causa, correção e knowledge (ou risco aceito assinado).

## Fase 4 — Congelamento e homologação V206 (Credenciamento)

1. Validação tela a tela da engine do Codex no projeto Credenciamento.
2. Validação da importação de VBA.
3. Gerar o checklist final do Fitness Gate e congelar a versão de liberação
   `v206` (tag + freeze-gate verde + hearback).

## Fase 5 — Subida e atualização do GitHub

1. Commitar e fazer push dos DOIS repositórios (`usehbn` e
   `Credenciamento`) — ato do operador humano, com CI (hbn-shield) verde.
2. Conferir que o workflow de CI da raiz roteia para a versão ativa
   (`$(cat .hbn/active-version)/guards/ci-entry.sh`).

## Fase 6 — Integração do assistente Jules

1. Configurar a esteira de CI/GitHub Actions para incluir o **Jules** como
   agente validador automático do protocolo useHBN.
2. Focos: auto-cura (propor correções, nunca aplicar sem gate), conformidade
   de regras (rodar a suíte + bateria adversarial) e análise incremental de
   segurança por PR.
3. Jules entra no mapa de famílias (`guards/data/auditor-families.txt`) por
   commit governado, com perfil em `.hbn/models/jules.json`.

## Fase 7 — Ciclo de melhoria recorrente (Wednesday Refinement)

1. Instituir **quarta-feira** como o dia da bateria de auditoria de
   segurança: rodar a bateria adversarial completa, revisar exceções G-EXC
   vivas, refinar regras e limpar logs.
2. Todo ciclo semanal fecha com knowledge nova ou refinamento de guard —
   nunca só relatório.

## Fase 8 — Planejamento da versão V207 (exúvia do consumidor)

1. Roteirizar o refactoring do VBA do Credenciamento na versão `v207`.
2. Desenhar a **exúvia local do projeto**: trocar o esqueleto de código
   legado por arquitetura otimizada baseada nas lições acumuladas
   (mesmo padrão do genoma: versão nova ao lado, validação, flip atômico,
   glacier do legado).
3. Usar `scripts/hbn-exuvia-atomic.sh` como referência do rito; adaptar ao
   contexto do consumidor.

---

## Invariantes permanentes (valem em toda fase)

- UMA fase/onda por vez; o STATE aponta UMA `proxima_acao`.
- Nenhuma IA commita; nenhum bypass; exceção só via G-EXC com hearback.
- Escrita SÓ sob `versao_3_0_0/` (G-HOT-WRITE bloqueia o resto).
- Exúvia futura SÓ pelo rito atômico (`scripts/hbn-exuvia-atomic.sh`).
- Toda mensagem de IA abre com o cabeçalho BOOT-LOCK (`BOOT.md` §0).
