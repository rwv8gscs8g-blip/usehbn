# Insumo de Fronteira para o Orquestrador de Desenvolvimento — Batch 1 (2026-06-16)

> COMO USAR (humano): cole este bloco no chat do orquestrador de desenvolvimento
> (o Opus que segura o bastão). É insumo NÃO-NORMATIVO da esteira de Fronteira —
> não é ordem; é pacote maturado para o orquestrador avaliar e encadear no fluxo
> formal, com o seu gate.

=== INÍCIO ===

PAPEL DESTE INSUMO: vem da esteira de Planejamento/Análise de Fronteira (chat
paralelo, chapéu provisório `analista-de-fronteira`, família Anthropic — portanto
NÃO conta como cross-audit; precisa de auditoria ≠-Anthropic). Nada aqui foi
commitado nem tocou `core/`, `.hbn/`, `guards/`, `src/`. Tudo vive em
`docs/brainstorm/rodada-2026-06-16/` (zona Fronteira, não-normativo).

ALINHAMENTO COM A SUA LINHA: você está fechando a versão (selagem W3 → árvores
registry-centric → freeze + tag v1-estável → Ponte do Credenciamento → V206). Este
pacote alimenta exatamente essa linha — em especial a onda "árvores registry-centric".

DELIVERABLES (ler em `docs/brainstorm/rodada-2026-06-16/`): A1 (front-door), A2
(árvores/portão), A3 (compilador), B1 (code review), B2 (honestidade) + INDEX.md.
Auditoria cross-IA externa disponível em `SUPERPROMPT-cross-ia-batch1.md`.

ACHADOS COM AÇÃO RÁPIDA SUGERIDA ANTES DO FREEZE (cada um a confirmar por você + cross-audit ≠-família):
1. [B1] `cli.py` `main()` retorna exit 0 mesmo em violação de protocolo
   (`src/usehbn/cli.py:1695,1772`; ex.: hearback não confirmado `result.py:56`).
   Contradição funcional para um sistema cujo fim é barrar avanço inseguro. Correção
   pequena, alto valor antes de congelar.
2. [B1] Três convenções de diretório de estado coexistem (`.hbn/`, `.usehbn/`,
   `state/`); o próprio código remenda em `cli.py:1564-1572`. Unificar antes do freeze.
3. [B2] `autoevolve` é teatro confirmado (worker no-op `worker.py:1-6`; gate de
   orçamento sempre passa `contract.py:49-50` + `approval.py:27`) e NÃO está na
   MATURITY-MATRIX. Classificar honestamente (Scaffold) ou quarentenar antes do MVP público.
4. [B2] Divergências documentais: `AGENTS.md:57` diz 93/93 vs 114/114 da matriz;
   `AGENTS.md:17` aponta para `docs/MATURITY-MATRIX.md` que está SUPERSEDED.

APOIO À ONDA "ÁRVORES REGISTRY-CENTRIC" (que você já planejou):
- [A2] guards são bash sem front-matter → a etiqueta de árvore vai no REGISTRY/comentário
  canônico, não em YAML. A2 traz o spec do portão de promoção e a reconciliação de
  `arvore:`×`temperatura:`×`hbn-track:` como eixos ortogonais (prova × tempo × processo).
- [A1] o front-door já existe pela metade (`core/role-cards.md` + `assert-frontdoor.sh`);
  falta o ECO de leitura — proposto guard G-FDACK. Candidato a onda própria; resolve o
  "fio da meada".
- [A3] o compilador já tem embrião (`dispatch-spec.md`→`dispatch.schema.json`→G-DSP);
  trailer de proveniência (`HBN-Spec-Source`) é ganho barato; geração real fica como pesquisa.

PEDIDO AO ORQUESTRADOR: 1) avalie o pacote; 2) rode as auditorias adversariais
≠-família que julgar necessárias (super-prompt pronto); 3) decida o que entra no
fechamento da versão e em que ondas — sugestão: itens 1–4 como correções rápidas
antes do freeze; árvores registry-centric (A2) e G-FDACK (A1) como ondas próprias;
compilador (A3) como pesquisa de Fronteira. O gate humano (Maurício) aprova cada selagem.

=== FIM ===
