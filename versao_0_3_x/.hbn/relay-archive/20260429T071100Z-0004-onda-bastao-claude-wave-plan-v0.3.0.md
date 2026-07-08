# 0004 — Onda do Bastao: Plano de Ondas v0.3.0 (architect deposit)

**Bastao:** claude-opus-4.7 (architect)
**Estado:** ativo
**Criado:** 2026-04-29T07:00:00Z
**Atualizado:** 2026-04-29T07:00:00Z

## Contexto Recebido

- Onda 1 concluida e arquivada (`20260429T065632Z-0003-onda-1-honestidade-narrativa.md`).
- Commit local `43c4c5d` aplicado, worktree limpo, sem push.
- Hearback humano recebido em mensagem de 2026-04-29: autoriza continuacao
  das proximas ondas e define Vitrine + GitHub push como Onda final do
  ciclo v0.3.0.
- Bastao retomado pelo claude para depositar plano canonico do ciclo
  completo, conforme `agents/wave-protocol.md` secao "Como Claude deve
  operar especificamente".

## Objetivo desta Iteracao

Depositar `docs/WAVE-PLAN-V0.3.0.md` como artefato doutrinario canonico
do ciclo v0.3.0, contendo as 9 ondas (Onda 1 ja concluida + 8 restantes).
Ao mesmo tempo, formalizar o superprompt da Onda 2 para que o Codex
possa executa-la apos Hearback humano explicito.

## O Que Foi Feito (architect, sem tocar em codigo)

- Atualizacao deste `.hbn/relay/INDEX.md` (em arquivo separado).
- Criacao de `docs/WAVE-PLAN-V0.3.0.md` (plano canonico de 9 ondas com
  escopo, arquivos permitidos, arquivos proibidos, testes, gates,
  riscos, rollback, e superprompts resumidos).
- Inclusao explicita da Onda 9 (Vitrine + Release) como onda final do
  ciclo, conforme decisao humana de 2026-04-29 ("ao final do ciclo
  atualizar o github" + "melhorar a interface").

## Lista de Arquivos Tocados

- `docs/WAVE-PLAN-V0.3.0.md` (novo).
- `.hbn/relay/0004-onda-bastao-claude-wave-plan-v0.3.0.md` (este arquivo).
- `.hbn/relay/INDEX.md` (em alteracao paralela).

Nenhum arquivo em `src/`, `schemas/`, `core/`, `tests/`, `pyproject.toml`,
`get-hbn`, `.github/`, `reports/`, `docs/CASE-STUDY-CREDENCIAMENTO.md` foi
tocado. Esta iteracao e exclusivamente deposito doutrinario.

## Decisoes Tomadas (architect)

- **Ordem das ondas**: priorizar integridade de dados (Ondas 2-4) antes
  de capacidade nova (Ondas 5-7), depois higiene/migration (Onda 8),
  depois vitrine (Onda 9).
- **Onda 2 = ERP Hardening Batch 1 (P0)**: defeito de sobrescrita
  silenciosa de `execution_id` e o risco mais alto auditado em
  `reports/HBN-ERP-HARDENING-AUDIT.md`. Deve ser fechado primeiro.
- **Schema changes nas Ondas 4 e 5**: G3 obrigatorio, mas correcoes ja
  auditadas em `reports/HBN-ERP-HARDENING-AUDIT.md` reduzem necessidade
  de RFC formal. Decisao do humano em Hearback.
- **Onda 9 release path**: TestPyPI primeiro (decisao Q13). PyPI estavel
  fica para v0.3.1 apos validacao humana. GitHub push so apos G6 + G1
  duplos.
- **Cleanups da auditoria pos-Onda 1** (CHANGELOG dual-header + README
  Current Status) absorvidos na Onda 8 ao inves de criar Onda 1.5.
- **`engine.py` permanece congelado em todo v0.3.0** (decisao do
  wave-protocol.md). Hardening de protocolo acontece em camadas
  adjacentes (`result.py`, `consent.py`, `cli.py`, `state/store.py`,
  `validators.py`).

## Riscos e Mitigacoes (deste deposito)

- **R1**: humano pode discordar da ordem proposta. **Mitigacao**: este
  documento e proposta; Hearback pode reordenar antes de qualquer Codex
  executar.
- **R2**: humano pode preferir release antes de hardening (ex.: liberar
  v0.3.0 ja com Onda 1 + vitrine, deixar hardening para v0.3.1).
  **Mitigacao**: documentar essa alternativa aqui mesmo. **Risco**:
  release com defeito P0 conhecido (sobrescrita silenciosa). **Recomendacao
  do architect**: NAO recomendado; melhor fechar P0 antes de qualquer
  release publica.
- **R3**: Onda 9 pode escapar do escopo "vitrine" para virar reescrita
  ampla do site. **Mitigacao**: superprompt da Onda 9 deve listar
  literalmente os arquivos permitidos e proibir CSS framework novo,
  build tooling novo, ou JS framework novo. Site continua HTML+CSS
  estatico GitHub Pages.

## Proximo Passo

1. **Hearback humano** sobre este deposito doutrinario, especialmente
   sobre:
   - aprovacao da ordem das 9 ondas;
   - aprovacao do escopo da Onda 2 (ERP Hardening Batch 1);
   - confirmacao de que a Onda 9 (vitrine + release) e a onda final do
     ciclo.
2. Apos Hearback explicito sobre **Onda 2 especificamente**, passar
   bastao para `codex` com instrucao de criar Readback inicial em
   `.hbn/relay/0005-onda-2-erp-hardening-batch-1.md` e PARAR.
3. Apos Codex finalizar Onda 2, humano pode invocar:
   `"Claude, auditar Onda 2 contra docs/WAVE-PLAN-V0.3.0.md e agents/wave-protocol.md."`

## Pendencias

- Aguardando Hearback humano para liberar Onda 2.
- RFC-0001 (`--enforce`) permanece aberto, sem janela definida em v0.3.0.
- Decisao Q13 (TestPyPI primeiro) precisa Hearback explicito antes de
  Onda 9.
- Auditoria pos-Onda 1 deixou 2 observacoes menores (CHANGELOG dual-header
  + README Current Status); ambas absorvidas na Onda 8.
