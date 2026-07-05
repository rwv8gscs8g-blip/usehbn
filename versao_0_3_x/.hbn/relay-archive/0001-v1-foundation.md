# 0001 — Fundação v1.0

**Bastao:** codex
**Estado:** resolvido
**Criado:** 2026-03-30T03:19:00Z
**Atualizado:** 2026-03-30T03:20:00Z

## Contexto Recebido

Repositório HBN com runtime local funcional, 21 testes passando, ERP e semantic readback já existentes, mas sem conteúdo semântico no readback, sem `hbn` como entry point principal, sem `hbn init`, sem `hbn version`, sem `.hbn/` no próprio repositório e com documentação e relatórios ainda desalinhados.

## O Que Foi Feito

- adicionado `hbn` como entry point primário sem remover `usehbn`
- implementado `hbn init`, `hbn run` e `hbn version`
- ampliado o readback para registrar entendimento, invariantes, plano de ação, escopo excluído e riscos residuais
- reorganizados relatórios históricos em `reports/`
- inicializado o próprio repositório com `.hbn/`
- atualizados README, command spec, roadmap e regras do Codex

## O Que Foi Alterado

- runtime CLI em `src/usehbn/cli.py`
- schema e lógica de readback
- entry points em `setup.cfg`
- documentação principal e especificações em `README.md`, `core/`, `agents/`
- estrutura operacional `.hbn/`

## Próximo Passo

Iteracao concluida. A proxima acao depende de um novo objetivo aprovado para o repositorio.

## Pendências

- `hbn inspect` ainda não existe
- adaptadores para Claude Code, Codex skills e outros runtimes ainda não existem
- `get-hbn` permanece fora de escopo nesta iteracao

## Riscos

- o nome de distribuição futuro pode exigir ajuste entre pacote `usehbn` e CLI `hbn`
- a camada `.hbn/` ainda é local e manual; integração nativa com outras IAs não existe

## Decisões Tomadas

- `hbn` é o comando operacional primário
- `usehbn` continua como alias de compatibilidade
- `safe_track` exige readback semanticamente preenchido e hearback confirmado
- `.hbn/relay/` e `.hbn/knowledge/` são a base de continuidade entre IAs
