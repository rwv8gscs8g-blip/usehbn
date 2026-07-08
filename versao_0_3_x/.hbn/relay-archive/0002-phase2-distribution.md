# 0002 — Phase 2 Distribution

**Bastao:** codex
**Estado:** resolvido
**Criado:** 2026-03-30T03:28:00Z
**Atualizado:** 2026-03-30T03:37:00Z

## Contexto Recebido

Fase 1 concluida com runtime local e readback semantico. O objetivo aprovado foi fechar a camada seguinte: bootstrap local, estrategia de distribuicao, adapters para runtimes, `hbn inspect`, empacotamento e revisao documental de release.

## O Que Foi Feito

- criado `src/usehbn/runtime.py` com inspecao e instalacao de adapters
- adicionados `hbn inspect` e `hbn install --runtime ...`
- introduzido `pyproject.toml` para build moderno
- criado `get-hbn` como bootstrap local previsivel
- documentados publishing e runtime adapters
- revisado README para refletir a release atual
- validado bootstrap, inspect, install e alias legado

## O Que Foi Alterado

- `src/usehbn/runtime.py`
- `src/usehbn/cli.py`
- `pyproject.toml`
- `get-hbn`
- `README.md`
- `CHANGELOG.md`
- `ROADMAP.md`
- `core/command-spec.md`
- `docs/PUBLISHING.md`
- `docs/RUNTIME-ADAPTERS.md`
- `tests/test_distribution_phase2.py`

## Próximo Passo

Validar nome de distribuicao publica e decidir se a publicacao externa continua com `usehbn` ou migra para outro nome de pacote.

## Pendências

- publicacao em indice publico ainda nao foi executada
- adapters ainda sao artefatos de arquivo, nao integracoes nativas

## Riscos

- nome `hbn` pode nao estar livre como pacote
- expectativas de plugin nativo podem exceder o que os adapters realmente fazem hoje

## Decisões Tomadas

- bootstrap local deve funcionar offline e sem depender de registry
- `usehbn` segue como nome de distribuicao atual
- `hbn` segue como CLI primario
- publicacao publica depende de validacao de nome e checklist final
