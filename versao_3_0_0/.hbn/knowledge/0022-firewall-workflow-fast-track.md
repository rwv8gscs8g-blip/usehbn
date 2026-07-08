---
titulo: Firewall de escrita — workflows só fast_track; escrita de domínio é safe_track humano-aplicada
tipo: knowledge
status: accepted
temperatura: quente
path: .hbn/knowledge/0022-firewall-workflow-fast-track.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: v0.3.x
id_original: 20260611-155221-fable5-knowledge-0022-firewall
created_at_original: "2026-06-11T15:52:21-03:00"
autor_original: "claude-fable-5 (implementador onda 0006, item I-01)"
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
id-global: 20260611-155221-fable5-knowledge-0022-firewall
autoria: "claude-fable-5 (implementador onda 0006, item I-01)"
autorizada-por: "\"Maurício, chat de orquestração 2026-06-11 — referência quebrada da mesma classe do F-08, achada no censo de read-list da onda 0006; criação autorizada em resposta ao alerta do implementador\""
fonte: "transcrito para esta exúvia a partir das decisões de firewall de workflow; regra vigente neste arquivo e em core/02-papeis.md"
---
# Firewall 0022 — o único invariante sempre-quente

Antes da transcrição, esta regra era citada por templates/relay sem alvo
estável nesta exúvia (mesma classe do F-08/0019). Este arquivo materializa a
regra no livro-razão vigente; em divergência, vale este arquivo e a matriz de
papéis em `core/02-papeis.md`.

## A regra

1. **Workflows de produto são SÓ fast_track de leitura/diagnóstico.**
   Nenhuma IA altera workflow de produção por conta própria.
2. **Escrita de DOMÍNIO é safe_track HUMANO-APLICADA, sem exceção**:
   VBA, Excel/planilhas de produto, `src/` de produto, workflows de
   produto, `examples/`, `inbox/` de consolidação — a IA PROPÕE (diff,
   patch, arquivo em pasta de proposta); quem aplica é o humano.
3. O firewall vale em TODA onda, mesmo com readback `safe_track`
   confirmado para outros paths — o scope do readback não o revoga;
   `files_forbidden` o reforça mecanicamente (G-SCO).
4. Critério de sempre-quente: é crítico de segurança/negócio E
   não-coberto-por-guard-executável na parte "escrita fora de repo/commit" —
   por isso mora na read-list canônica de TODOS os papéis.

## O que o guard cobre e o que fica com você

`assert-scope-lock.sh` (G-SCO) bloqueia no commit o que entra em
`files_forbidden` do readback ativo. O que NÃO passa por commit (escrita
solta, app externo) é coberto por G-STRAY (sweep) e pela disciplina desta
página: na dúvida, é domínio → PROPONHA, não aplique.
