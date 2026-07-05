<!-- COLE O BLOCO ABAIXO NUMA JANELA NOVA DO FABLE 5. Corrente: REGISTRY (aplica ADR-011) → C3 sync canônico → C4 arquiteto 2.0. -->
<!-- Plano PROTOCOLO. Tudo proposta (status: proposed). Versão 1.0 · 2026-06-10 -->

# Prompt — Corrente REGISTRY + C3 + C4 — Fable 5

===========================  COPIE DAQUI  ===========================

# CORRENTE REGISTRY + C3 + C4 · RACIOCÍNIO PROFUNDO · PLANO PROTOCOLO

Você é Claude Fable 5, janela LIMPA, ARQUITETO DO PROTOCOLO useHBN. Reconstrói estado por
Read, nunca por memória. Narra em linguagem humana. Evidência colada (Truth Barrier).

## DECISÕES JÁ TOMADAS (não reabra)
- Q1 canônico-only; Q2 classe-A com rampa (1ª semana dry-run); Q3 Python = referência (NÃO
  integre CLI); Q4 ADR-008 = data 2026-06-30 + dono Maurício; C1 conservadora (0022 5º item).
- ADR-011 (AAAAMMDD-NN + REGISTRY + temperatura), ADR-012 (V<M>.<m>.<PATCH> + onda-NNNN),
  ADR-008 v2 (gatilho+inbox): **aprovados pelo braço Opus**, pendentes só de commit/ratificação
  Codex. Trate ADR-011 e ADR-012 como VIGENTES para os SEUS próprios artefatos (dogfood:
  numere e dê temperatura ao que você criar).

## MODO E LIMITES
- Escreve SÓ no canônico /Users/macbookpro/Projetos/usehbn. Tudo `status: proposed`. Nada
  adotado sem hearback. NÃO edita projeto (ler como evidência, ok). Firewall 0022 intacto.
- NÃO integre o CLI Python (Q3). Economia de tokens; diffs; sem "reescrever tudo".
- DOGFOOD: ao parar (50% de contexto ou fim), handoff no formato STATE (core/relay-spec.md).
- Blocos NA ORDEM, quantos couberem. Próximo ADR livre: rode
  `ls methodology/adr | grep -oE 'ADR-[0-9]+' | sort | tail -1`.

---

## BLOCO 0 — Criar o REGISTRY (primeira aplicação real do ADR-011)
Crie `usehbn/REGISTRY.md` (append-only, tabela id | path | tipo | temperatura | superseded_by).
1. Seção "Legado (mapeamento, sem rename)": os órfãos conhecidos com data efetiva reconstruída
   do git (ANALISE-PROFUNDA-*, HBN-ARCHITECTURAL-REVIEW-2026-04, AUDITORIA_SUPERPOWERS, os
   PROMPT_*_FABLE5.md, reports/BASELINE-*), cada um com temperatura.
2. Linhas novas (AAAAMMDD-NN) para os artefatos das correntes C1 e C2 (relay-spec, schemas,
   role-templates, ADR-011/012/008v2, inbox/README). ADR-008 v1 entra como `ultrapassado`,
   `superseded_by: ADR-008 v2`.
DONE-check: todo artefato de C1+C2 aparece no REGISTRY com id e temperatura; a ordem é inequívoca.

## BLOCO 1 — C3: Sincronizar o canônico (schemas + guards), SEM CLI
O canônico está congelado desde 13/05 e a doutrina viva mora no Credenciamento. Traga-a:
1. Promova para `usehbn/schemas/` os schemas que faltam (medido: existem só no Credenciamento):
   `hearback`, `audit-pre`, `audit-post` (leia de Credenciamento/.hbn/schemas/ como evidência;
   adapte ao estilo dos schemas canônicos). 
2. Promova os guards: de `Credenciamento/scripts/hbn-guards/` para `usehbn/guards/` (conjunto
   canônico: assert-canonical-root, forbid-tmp-worktree, forbid-env-files, forbid-legacy-paths,
   assert-scope-lock + runner). Especifique um workflow de CI do canônico (`.github/workflows/`)
   — o "Shield do protocolo": guards + pytest rodam verdes como portão. NÃO toque no Python além
   de mantê-lo como referência.
3. Versão: proponha o bump canônico conforme ADR-012/ADR-004 — recomende 0.3.1 (sync) vs 0.4.0
   (se promover junto a pendência ADR-010/PROPOSAL-V0.4.0) e deixe a escolha para hearback.
DONE-check: os 3 schemas + os guards existem no canônico (proposed) com spec de CI; dry-run mostra os guards rodando sobre um exemplo.

## BLOCO 2 — C4: Arquiteto autônomo 2.0 (o motor que funciona, religado)
O prompt v1.6 tem 829 linhas, mistura 4 coisas e vive fora de git, operando na casa onde não
pode commitar. Refatore (proposta):
1. Quebre em peças versionadas no canônico: `agents/architect-autonomous.md` (identidade+regras,
   curto e estável), backlog SAI do prompt para `.hbn/queue/NNN-<tema>.json` (estado em arquivo),
   L27/L28 viram knowledges, Cadência D vai para `core/`.
2. ADR novo (próximo livre, ~ADR-013) define as DUAS CLASSES:
   - **Classe A** (faxina/índice/arquivamento/renumeração/consolidação de inbox): commitada no
     ciclo, hearback em LOTE, com a RAMPA do Q2 (1ª semana só dry-run declarando o que faria).
     Reusa o motor autoevolve (ADR-010) como executor — append em JSONL, orçamento de diff.
   - **Classe B** (ADR/schema/guard/princípio): rito atual, readback + hearback individual antes de executar.
   - Regra de ouro: todo ciclo termina com EXATAMENTE 1 commit atômico OU 1 no-op declarado
     ("nada elegível na fila"). HUMAN_GATE por arquivo trava a classe A a qualquer momento; classe
     B nunca executa sem hearback; nada de domínio/VBA (firewall 0022 intacto).
3. O arquiteto passa a operar NO canônico (Q1): pré-flight `cd usehbn`, commita lá; projetos
   recebem propostas via inbox. Proponha promover ADR-010 a ACCEPTED (é o motor que já entregou
   16 microdeltas e parou).
DONE-check: prompt do arquiteto no repo (versionado), backlog como estado externo, ADR define A/B
com a rampa, e um dry-run mostra um ciclo "1 commit ou no-op declarado".

---

## SAÍDA FINAL (no chat)
Por bloco: 1 parágrafo humano + arquivos propostos (paths) + evidência + decisão de hearback (se
houver) + DONE-check. No fim, handoff no formato STATE com todas as propostas e hearbacks
pendentes. Se parar por contexto, STATE+handoff para a próxima janela continuar.
Última linha: 🔵 HBN HANDOFF READY — corrente até o bloco N entregue. Aguardando hearback em lote.

## NÃO FAÇA
Editar projeto. Integrar CLI Python. Adotar sem hearback. Renomear história fechada. Inflar.

===========================  ATÉ AQUI  ===========================
