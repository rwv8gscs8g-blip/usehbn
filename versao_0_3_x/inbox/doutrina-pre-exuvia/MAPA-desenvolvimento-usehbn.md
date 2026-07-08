# Mapa de desenvolvimento — useHBN / hbn-exuvia

Documento-mestre: estado, princípios travados, roadmap e índice. Serve também de WARM BOOT para um
orquestrador novo (ler este mapa + `.hbn/relay/STATE.md` + os docs do índice). Atualizado 2026-06-14.

## 1. Estado atual
- Repo `usehbn`, HEAD `4db6928`, versão **0.3.0**. Em ELABORAÇÃO (ainda não "funcional/provado").
- Doutrina do orquestrador 0.2.0 ADOTADA e cross-auditada (Gemini/Codex). Hearback formal adiado (B2).
- Plano hbn-exuvia v2 escrito e cross-auditado APROVADO (0/0/0). **Porém superado** pelo modelo novo
  decidido pelo humano (versão = pasta com o sistema inteiro) — o plano precisa ser reescrito a esse modelo.
- Dívida B1/B2/B3 deferida (será dissolvida DENTRO da 1ª exúvia real, não antes).

## 2. Princípios TRAVADOS (decisões do gate humano, 2026-06-14)
1. **Exúvia = pasta da versão contém o SISTEMA INTEIRO.** `usehbn/versao_X_Y_Z/` tem tudo (todos os
   módulos). Estrutura livre por versão (5 → 30 → 3 módulos). A IA lê SÓ a versão vigente (ou a anterior
   se chamada). Pasta pequena, lapidada → carregável em memória; validações sempre no disco.
2. **Continuidade sem reescrever links:** o exoesqueleto abandonado mantém history; UM documento de
   transição ("de-onde-para-onde") mapeia o que mudou. A 1ª muda é um BOOTSTRAP especial.
3. **Fitness Gate (mecanismo seguro):** só muda quem está FUNCIONAL + TESTADO (suíte + testes reais +
   Ponte do Credenciamento). Confronto incumbente×desafiante nos mesmos testes; desafiante só vence se
   entregar mais com menos/melhor/corrigir barreiras — medido. Incumbente sobrevive por padrão; rollback (P6).
4. **Darwinismo em 3 níveis:** software (a exúvia), evolução das IAs (lições só promovidas se provarem
   que previnem erro), seleção inter-agentes (qual IA por tarefa por desempenho MEDIDO; champion/challenger
   + bandit; sempre proposta auditada). Fio comum: aptidão = provada na realidade.
5. **Roadmap invertido:** estabilizar → PROVAR via Credenciamento → 1ª exúvia real. (A exúvia vem DEPOIS
   da prova, não antes.) Mesmo padrão para o Credenciamento.
6. **Nome `hbn-exuvia`**; terminologia **exoesqueleto** (nunca "casca").
7. **Topologia:** Opus orquestra · Codex implementa · Gemini+Grok+Jules auditam · humano no gate.
   Família = `fornecedor` (anti-F-01: implementador ≠ fornecedor do orquestrador; auditores ≠ fornecedor do implementador).
8. **MODO EDUCACIONAL** 5 níveis (básico/entusiasta/intermediário-default/avançado/expert); núcleo factual nunca ocultado.

## 3. Roadmap (marcos corrigidos — refinado pelo gate humano 2026-06-14)
**Ordem travada:** estabilizar o usehbn → Ponte do Credenciamento provada em teste → 1ª exúvia DO PRÓPRIO
PROTOCOLO → revalidar contra o Credenciamento + correções no mundo real → (só então) exúvia DO PROJETO
CREDENCIAMENTO. A exúvia do Credenciamento é o **ÚLTIMO marco**, gated pela prova do próprio protocolo:
o Credenciamento só muda depois que o usehbn funcionou, fez a ponte, se exuviou e revalidou.

- **Concluído:** ondas 0006–0011 (enforcement, regularização, doutrina 0.2.0, planos exúvia 0010/0011);
  cross-audit de IMPLEMENTAÇÃO da exúvia (Codex+Gemini+Grok) consolidado (result `…044555…`).
- **AGORA — M-A: scaffold INATIVO do mecanismo.** Despacho ao Codex desenhado (message `…181924…`):
  ponteiro `.hbn/active-version` + hooks-shim fail-closed + guards version-aware (`get_canonical_root`) +
  6 achados (G-STRAY version-aware, token×STATE, hooks órfãos, conflito de merge no ponteiro, bloat→`git mv`,
  sincronizar o STATE). Sem `git mv`, sem corte; ativação VEDADA até o Fitness Gate. Cross-audit Gemini+Grok
  antes de qualquer ativação.
- **M-B — PROVAR via Ponte do Credenciamento.** Integração usehbn × projeto Credenciamento + testes reais;
  verificar que funciona, validar nos testes. É a precondição de aptidão de qualquer muda (Fitness Gate).
- **M-C — 1ª EXÚVIA REAL DO PROTOCOLO** sobre o baseline provado: nasce `versao_1_0_0/` lapidada; dissolve
  B1/B2/B3; exoesqueleto anterior congelado (`git mv` → `versao_0_3_x/`) + doc de transição; confronto
  incumbente×desafiante.
- **M-C′ — Revalidar contra o Credenciamento + correções no mundo real.** Confirmar que o protocolo, já
  exuviado, segue funcionando bem com o Credenciamento; aplicar as correções do usehbn medidas no uso real.
- **M-D — Publicar no GitHub** a forma provada/lapidada (chave SSH, branch protection, push origin/main);
  Jules entra no dogfooding a partir daqui.
- **M-E — Dogfooding contínuo no Credenciamento;** depois Dream MVP + ACI; depois Automação Fases 1–4.
- **M-F — EXÚVIA DO PROJETO CREDENCIAMENTO (último marco).** Só depois de o protocolo estar funcionando e
  provado por testes (M-B…M-E). Mesmo Fitness Gate aplicado ao Credenciamento.

## 4. Auditorias abertas / pendências humanas
- **Auditoria:** cross-audit de implementação da exúvia (4 IAs) — brief pronto (índice §5).
- **Humano:** rodar as 4 auditorias; gerar chave SSH (`.hbn/operators/`); branch protection no GitHub;
  decidir push de `origin/main`.

## 5. Índice de documentos (todos em `~/Projetos/`)
CANÔNICOS (vigentes):
- `MAPA-desenvolvimento-usehbn.md` — este mapa (warm boot).
- `MODELO-exuvia-versao-contem-sistema-inteiro.md` — a forma decidida.
- `MECANISMO-aptidao-darwinismo-exuvia.md` — Fitness Gate + darwinismo 3 níveis.
- `ANALISE-exuvia-renovacao-estrutural.md` — análise + precedente Docusaurus.
- `CROSS-AUDIT-formas-de-implementar-exuvia-estrutural.md` — brief de auditoria (4 IAs).
- `RADAR-0001-consolidacao-fronteira-orquestracao.md` — fronteira (Omnigent/A2A/LangGraph/sleep).
- `VISAO-hbn-governanca-automatizada-sobre-substratos.md` — visão de automação (Fases 0–4).
- `usehbn-painel-protecao.html` — painel do operador (a versionar como artefato).
SUPERADOS (não usar): `...M2-execucao-corte-exuvia...` (modelo antigo), alvo modular do plano v2.

## 6. Como retomar (warm boot do orquestrador novo)
Ler: este mapa → `.hbn/relay/STATE.md` (no repo) → os 3 docs canônicos (modelo, mecanismo, análise) →
o brief de auditoria. Começar toda resposta com `PAPEL · BASTÃO · CONTEXTO · MODO EDUCACIONAL`. Não
implementar/commitar (orquestrador desenha e despacha). Próxima ação: M-A — Codex implementa o scaffold
INATIVO do mecanismo (despacho `…181924…`); depois cross-audit Gemini+Grok antes de qualquer ativação.
