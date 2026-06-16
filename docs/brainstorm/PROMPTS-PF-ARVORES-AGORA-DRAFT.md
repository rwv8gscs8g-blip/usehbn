# Prompts intermediários — PF-ARVORES-AGORA (DRAFT)

> **DRAFT — não disparar antes da validação humana.** Seguem a lógica do protocolo:
> janela limpa (chat novo, leitura do disco), Truth Barrier (citar arquivo:linha),
> cross-family (família ≠ Anthropic = autor da proposta), template de auditoria da
> `core/cadence-d.md`, veredito `APROVA_PF-ARVORES-AGORA: SIM/NÃO` + `Confiança: X/100`.
> Autor: chat paralelo (Claude Opus 4.8, Anthropic), 2026-06-16.

## Bloco de contexto (cabeçalho comum a TODOS os prompts)

```
Você é auditor/proponente em janela limpa no protocolo useHBN. Não confie em
memória de chat: reconstrua tudo lendo o disco. Truth Barrier: toda afirmação
cita arquivo:linha ou comando+saída — nada de "confie em mim". Não comite nada.

Leia, nesta ordem:
1. docs/brainstorm/PROPOSTA-arvores-agora.md  (a proposta a avaliar)
2. docs/brainstorm/exuvia-evolucao-conceitual.md  (seções H, I, K, L, O, P — contexto)
3. docs/brainstorm/EXPLICACAO-PUBLICA-usehbn-DRAFT.md  (visão geral honesta)
4. methodology/PRINCIPIOS-CONSTITUCIONAIS.md  (P1–P13)
5. methodology/MATURITY-MATRIX.md  (estados; nenhuma afirmação pode excedê-la)
6. core/exuvia-fitness-criteria.md  (os 8 critérios) e docs/PHAGOCYTOSIS.md (5 estágios)

Tema (id de trabalho): PF-ARVORES-AGORA — implementar/etiquetar as três árvores
(Fronteira / Intermediária / Estável) AGORA, com o campo `arvore:` no front-matter,
deixando a partição física de diretórios para a 1ª exúvia.
```

## Prompt tipo 1 — Auditoria adversarial (por instância ≠-família)

```
Sua tarefa: TENTAR QUEBRAR a proposta PF-ARVORES-AGORA. Não valide; ataque.
Vetores obrigatórios a testar (com evidência de disco):

a) Segunda fonte de verdade — o campo `arvore:` colide ou duplica `temperatura:`
   e `hbn-track:`? Há risco de divergência entre eles? (roles-spec §3 proíbe
   tabela paralela.)
b) Classificação prematura — etiquetar agora + particionar na exúvia abre brecha
   para rotular como Intermediária algo não provado? O portão (fagocitose + 8
   critérios + Fitness Gate) fecha isso?
c) Burla do portão Fronteira→Intermediária — existe caminho para um artefato
   subir de árvore sem cross-audit ≠-família ou sem o Fitness Gate?
d) Modelo compilador (`.md`→enforcement) — viola algum P1–P13? Cria promessa
   acima do que a MATURITY-MATRIX sustenta?
e) Invariante "regra estável governa o sistema/Credenciamento" — é suficiente e
   fail-closed, ou há cenário em que regra de Fronteira vaza para produção?

Saída no template da core/cadence-d.md:
1 Veredito (APROVAR / APROVAR com FORTES incorporados / BLOQUEAR + 1 frase)
2 BLOQUEADORES (descrição + evidência arquivo:linha + remediação)
3 FORTES
4 MARGINAIS
5 Convergências
6 Divergências
7 Riscos não cobertos
8 Próxima ação
Encerre com: APROVA_PF-ARVORES-AGORA: SIM/NÃO  ·  Confiança: X/100
```

## Prompt tipo 2 — Abertura de proposta (divergência de fronteira)

```
Sua tarefa: contribuir a SUA visão própria, mesmo que divergente da proposta —
o objetivo é diversidade de cepas (evitar convergência Anthropic-cêntrica).

Responda:
1. Como a sua família desenharia o gradiente de prova entre árvores
   (Fronteira → Intermediária → Estável)? O que mudaria?
2. Como deveria ser o portão de promoção entre árvores? Reusar fagocitose + 8
   critérios é o melhor, ou há mecanismo superior?
3. Como o modelo compilador (`.md` = fonte; código = saída impressa) deveria
   funcionar na prática para "imprimir" enforcement em linguagens diferentes
   (incluindo legadas)?
4. Ganhos ou riscos que a proposta atual NÃO cobre.

Saída: lista objetiva de divergências e propostas, cada uma com justificativa e,
quando possível, evidência arquivo:linha.
```

## Especialização por família (o que pedir de melhor a cada uma)

- **Gemini 3.5** — foco em constituição/estrutura e enforcement em runtime (regras
  parseáveis; relação `arvore:` × P1–P13).
- **Codex** — foco em implementação + interop A2A (como o compilador "imprime" em
  múltiplas linguagens; mecânica do `arvore:` nos guards).
- **Cursor** (modo auto) — foco em verificação mecânica no disco (vetores finos,
  como fez no 0029: substring, ponteiro morto, isolamento de escopo).
- **Grok** — foco em fronteira/mercado (paradigmas novos; Omnigent; precedentes de
  árvores Estável/Testing/Unstable em distros e como aplicá-los).
- **Antigravity** (opcional, se incluído) — foco em isolamento de escopo e área
  temporária/fail-closed (como no parecer 0029).

## Consolidação (feita pelo analista-de-fronteira, este chat)

Reunir os pareceres (tipo 1) + as visões (tipo 2) numa **matriz
convergência × divergência**, classificar BLOQUEADORES/FORTES, e entregar ao
orquestrador um pacote pronto-para-despacho — só então o tema entra na esteira de
produção.
