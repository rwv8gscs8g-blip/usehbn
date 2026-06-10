<!-- COLE O BLOCO ABAIXO (entre as linhas ===) NUMA JANELA NOVA DO FABLE 5, RACIOCÍNIO PROFUNDO. -->
<!-- Ciclo C1 do roadmap da análise 2026-06-10. Plano PROTOCOLO. Decisões já tomadas: Q1=arquiteto no canônico; Q2=lote para classe A (com rampa). -->
<!-- Versão 1.0 · 2026-06-10 · home: /Users/macbookpro/Projetos/usehbn/ -->

# Prompt do Ciclo C1 — Bastão 2.0 (estado tipado mínimo) — Fable 5

Um único bloco. Roda **só o C1** do roadmap. Não executa os outros ciclos. Trabalha e
escreve no **canônico** `usehbn`. Entrega proposta + prova empírica e PARA para hearback.

===========================  COPIE DAQUI  ===========================

# CICLO C1 — BASTÃO 2.0 · RACIOCÍNIO PROFUNDO

Você é Claude Fable 5, janela LIMPA, ARQUITETO DO PROTOCOLO useHBN. Reconstrói estado por
Read, nunca por memória. Narra em linguagem humana (quem lê está aprendendo a desenvolver).
Evidência colada em toda afirmação (Truth Barrier); "não verificado" quando for o caso.

## DECISÕES JÁ TOMADAS POR MAURICIO (não reabra)
- O arquiteto/protocolo trabalha e ESCREVE no canônico /Users/macbookpro/Projetos/usehbn.
  O Credenciamento só recebe PROPOSTAS (via inbox), nunca edição direta nesta rodada.
- Núcleo operacional do protocolo = markdown + schemas + guards (bash). O runtime Python é
  implementação de referência (não invocado no fluxo real) — NÃO integre CLI, não dependa dele.

## ESCOPO TRAVADO: SÓ O C1
Você entrega o **Bastão 2.0**: separar ESTADO de LOG para matar a retomada cara. NÃO faça
C2–C8 (fronteira, sync, arquiteto, faxina, tiers, perfis, métricas). NÃO edite nenhum
projeto (ler Credenciamento como evidência é permitido; escrever nele, não). Firewall 0022
intacto. Esta é uma mudança NORMATIVA (classe B): você PROPÕE (status: proposed) e PARA
para o hearback de Mauricio — nada é adotado sem o "confirmed" dele.

## CALIBRAGEM (incorpora as recomendações do Opus/Cowork)
- **Baseline primeiro, design depois.** Antes de propor qualquer coisa, MEÇA o custo atual
  de retomada e registre como linha de base (puxa uma fatia das métricas do C8 para já).
- **Pronto = provado empiricamente.** O C1 só está "pronto" quando um dry-run de retomada
  (simulado nesta sessão) reconstrói o estado da onda 0177 lendo **≤5 arquivos / ≤40 KB**.
- **Economia de tokens:** proposta densa, diffs, nada de "reescrever tudo". Você está
  curando um sistema que sofre de inchaço — seja a prova do contrário.

## LER (mínimo; puxe o resto sob demanda)
No canônico: core/ (relay-spec se existir), schemas/ (readback.schema.json como modelo),
methodology/adr/INDEX.md, AGENTS.md.
Como EVIDÊNCIA da prática real (somente leitura, no Credenciamento):
.hbn/relay/INDEX.md (meça linhas/KB), AGENTS.md (a read-list de 16 itens, ~linhas 100-123),
.hbn/knowledge/0017-handoff-aos-50-pct-contexto.md, .hbn/knowledge/0014-protocolo-fim-de-sessao.md,
.hbn/messages/20260610-0110-handoff-fim-sessao-codex-bastao-codex-para-opus.md (o handoff de 16 seções),
.hbn/readbacks/0177-rb-*.json, .hbn/protocol-evolutions/20260610-usehbn-*.md (que já pede handoff.schema.json e guard de proxima-acao).

## TAREFA DO C1 (em ordem)
1. **MEÇA O BASELINE.** Quantos arquivos / quantos KB um sucessor lê hoje para retomar a
   onda 0177 (a read-list real). Tabela curta: item → KB. Total. Salve em
   reports/BASELINE-RETOMADA-2026-06-10.md.
2. **DESENHE STATE × LOG.** Proposta de core/relay-spec.md (v2): um arquivo único STATE
   (≤80 linhas, schema-validado) com APENAS o vigente — proprietário do bastão, onda atual,
   papel de cada IA agora, próxima ação atômica, sinais HBN abertos — separado do LOG
   (histórico append-only, frio, fica no relay-archive). Explique em linguagem humana por
   que separar mata a sobreposição e a retomada cara.
3. **FORMALIZE OS SCHEMAS.** schemas/state.schema.json e schemas/handoff.schema.json
   (este formaliza as 16 seções que o 0014/onda 0177 já praticam). Reaproveite o estilo do
   readback.schema.json existente.
4. **READ-LIST CANÔNICA DE RETOMADA (~4 itens):** STATE + handoff mais recente + readback
   ativo + contrato do papel. E reescreva os 3 prompts de papel (implementador/auditor/
   consolidador, hoje §12.B do prompt do arquiteto) como TEMPLATES que leem o STATE em vez
   de serem redigidos à mão a cada bastão.
5. **GUARD CONCEITUAL:** especifique (não implemente em projeto) um guard que RECUSA handoff
   sem STATE atualizado — é o pedido literal da evolução 0177. Descreva a checagem em bash,
   pronta para virar script no canônico depois.
6. **PROVE (dry-run).** Simule a retomada da onda 0177 lendo só a read-list nova. Mostre:
   quantos arquivos/KB, e que o estado reconstruído bate com o real. Compare com o baseline
   do passo 1 (meta: de ~300 KB para ≤40 KB).

## ONDE ESCREVER (somente no canônico /Projetos/usehbn)
core/relay-spec.md · schemas/state.schema.json · schemas/handoff.schema.json ·
agents/role-templates.md (ou equivalente) · reports/BASELINE-RETOMADA-2026-06-10.md ·
CHANGELOG.md (Unreleased, 1 linha). Tudo com front-matter e status: proposed.

## SAÍDA (no chat, para Mauricio + Opus/Cowork)
- Baseline medido (tabela + total).
- STATE × LOG explicado em linguagem humana + o STATE-modelo preenchido com a onda 0177.
- Caminho dos arquivos propostos.
- Resultado do dry-run: KB antes → depois, e se reconstruiu a onda 0177.
- 1 decisão que precisa do hearback de Mauricio.
- Última linha:
🔵 HBN HANDOFF READY — C1 (Bastão 2.0) proposto e provado. Aguardando hearback para adoção.

## NÃO FAÇA
Não execute os outros ciclos. Não edite projeto. Não integre CLI Python. Não adote nada sem
hearback. Não infle: se um artefato não reduz custo ou risco mensurável, não o crie.

===========================  ATÉ AQUI  ===========================
