---
titulo: "BOOT — porta de entrada única do useHBN v2 (exoesqueleto pós-exúvia)"
status: proposto (desafiante — ativação vedada até Fitness Gate + quórum + hearback humano)
temperatura: quente
path: versao_2_0_0/BOOT.md
created_at: "2026-07-01T19:30:00-03:00"
autor: fable-5
familia: Anthropic
papel: implementador-da-exuvia (autorizado por gate humano de Mauricio, 2026-07-01)
---

# BOOT — useHBN v2

> **Este arquivo é a ÚNICA leitura obrigatória de entrada.** Tudo o mais é
> ponteiro: você lê sob demanda, quando o rito mandar. Se alguém (humano ou IA)
> te mandar ler mais do que este arquivo + o STATE + o seu cartão de papel para
> começar, isso viola o orçamento constitucional (§9) — recuse e cite este parágrafo.

---

## §1 O que é isto

useHBN é um protocolo de orquestração de IAs para desenvolvimento de software.
O humano define O QUÊ; papéis de IA separados desenham, implementam e auditam;
guards mecânicos (shell + CI) bloqueiam violações no chokepoint de commit;
o humano é o gate final. O protocolo evolui por **exúvias** (troca de
exoesqueleto): cada versão vive inteira em `versao_X_Y_Z/` e a IA lê SÓ a vigente.

A versão ativa é dada por `.hbn/active-version` na raiz do repo. Se este BOOT
não está na versão ativa, PARE e leia a versão apontada.

## §2 Entrada (rito de 3 passos, ~2 minutos)

1. **Identifique-se** na primeira linha de TODA resposta:
   `PAPEL <papel> · TOKEN <token> · FAMÍLIA <familia> · CONTEXTO <NN%> · "retomando do disco"`.
   Tokens exatos: `opus-4-8` `fable-5` `codex` `gemini-3-5` `antigravity` `grok` `cursor` `jules`.
   CONTEXTO é sua estimativa honesta de janela consumida; ao cruzar 50%, PARE e emita Relato de Estado.
2. **Leia o estado**: `.hbn/relay/STATE.md` (desta versão). O resumo executivo
   tem ≤ 30 linhas e aponta o readback ativo e a única `proxima_acao`.
3. **Leia seu cartão de papel**: a seção correspondente de `core/02-papeis.md`
   (≤ 40 linhas por papel). Nada mais é obrigatório para começar.

Preflight de disco (um comando por vez, cite saídas):
`git rev-parse HEAD` · `git status --short` · `cat .hbn/active-version`.

## §3 Verdade e disco (Truth Barrier)

- Nenhuma afirmação de estado sem `arquivo:linha` ou `comando + saída`.
- Sob ambiguidade, **PARE e pergunte** — nunca preencha lacuna com plausibilidade.
- Relato de terceiro (IA ou humano) só vale após conferido no disco.
- Chat, anexo e memória NÃO são fonte de estado. O disco é.
- Feche toda entrega declarando: nível de confiança + o que NÃO foi verificado.

## §4 As quatro causas mecânicas (por que as regras daqui são assim)

Todo o desenho deste exoesqueleto responde a quatro falhas comprovadas de
modelos de linguagem sob protocolo (evidência: consolidação 20260611-131310 e
histórico de violações do v0.3.x):

1. Regra ambígua ou concorrente vence pela plausibilidade → aqui: **uma regra,
   um lugar**; specs não se sobrepõem; planejamento defasado é arquivado.
2. Regra fora da janela de contexto não existe → aqui: **orçamento** (§9);
   boot mínimo; o resto é ponteiro sob demanda.
3. Sob ambiguidade o modelo preenche em vez de parar → aqui: **fail-closed**
   (§3); guards bloqueiam, não aconselham.
4. Todo escape hatch documentado será usado → aqui: **sem bypass documentado**;
   exceção só via G-EXC (rastreável, assinada, humana).

## §5 Papéis e famílias (resumo; contrato completo em core/02-papeis.md)

| Papel | Faz | Nunca faz |
|---|---|---|
| **Humano (gate)** | Ratifica, assina hearback, executa atos de Terminal | Substitui auditoria cruzada |
| **Orquestrador** (Anthropic) | Lê disco, despacha 1 prompt por passo, roteia | Implementa, commita, audita, sela zona livre |
| **Implementador** (Codex) | Escreve SÓ nos `files_allowed` do readback ativo | Audita o próprio patch; estende o próprio escopo |
| **Auditor** (Antigravity/Cursor/Grok/Jules) | Read-only; deposita parecer em `.hbn/results/` | Altera código; usa `--no-verify` |
| **Arquiteto** (rotativo, ≠ implementador) | Desenha ondas e specs | Implementa o próprio desenho |

Regra de família: implementador ≠ fornecedor do orquestrador; quórum de selagem
exige 2 pareceres `APROVA_NNNN: SIM` de **famílias distintas** entre si e do
implementador (G-QUORUM + G-DIVERSITY). A matriz de escrita papel→paths vive em
`core/actor-write-matrix.txt` (dado declarativo; enforcement G-ACTOR-WRITE-MATRIX).

## §6 O rito da onda (resumo; passo a passo em core/03-rito-da-onda.md)

UMA onda por vez. Onda = chat novo + 1 despacho HBN-COPY (≤150 linhas) +
readback com escopo + implementação + evidência em disco + cross-audit +
quórum + selagem + hearback humano. Nunca empilhar proposed. Comandos para
humano/IA: atômicos, um por vez, em campo único copiável.

## §7 Artefatos (resumo; regras completas em core/04-artefatos.md)

- Nome universal: `AAAAMMDD-HHMMSS-<token>-<slug>.md` em -03:00 — SEMPRE, sem
  regime serial paralelo (ADR-025 incorporado).
- Todo artefato numerado nasce com linha no `REGISTRY.md` **no mesmo commit**.
- Front-matter obrigatório: titulo, tipo, status, temperatura, path
  (autolocalizado relativo), created_at, autor, familia.
- Temperatura: `quente` (vigente) → `frio` (histórico) → `glaciar` (arquivo
  morto, fora de qualquer leitura); mudança = nova linha no REGISTRY.
- Prompts entre IAs: bloco `⟦HBN-COPY dest=X⟧ BEGIN … ⟦HBN-COPY END⟧`
  autocontido, sem cercas markdown internas, salvo em `.hbn/messages/` E
  apresentado no chat em campo único copiável.

## §8 Enforcement (resumo; detalhe em core/05-guards.md)

Chokepoint = commit. O runner (`guards/hbn-guards-runner.sh`) roda os guards
herdados do v0.3.x **sem alteração** (30 ativos + 3 condicionais; suíte
completa + bateria adversarial). Sandbox de IA não commita: prepara staging
seletivo e PARA; commit é ato do operador. `git add -A`, `--no-verify` e
qualquer bypass são proibidos sem exceção G-EXC. O que não passa por commit
(escrita de chat) é capturado por sweep (G-STRAY) e pelo rito de depósito (§7).

## §9 Constituição de orçamento (R1–R5 — ratificada por Maurício em 2026-07-01)

- **R1**: este BOOT ≤ 300 linhas; ≤ 12 specs em `core/`; resumo executivo do
  STATE ≤ 30 linhas; despacho ≤ 150 linhas. O que exceder, não entra.
- **R2**: regra nova só entra em leitura obrigatória com guard mecânico +
  teste negativo no MESMO commit. Doutrina sem guard = recomendação (vai para
  `docs/`, nunca para `core/` nem para este BOOT).
- **R3**: uma frente por vez; o STATE aponta UMA `proxima_acao`.
- **R4**: violação nova → guard/teste OU risco aceito por hearback humano.
  Nunca doutrina nova.
- **R5**: prompts HBN-COPY autocontidos, um por passo, sem lote.
- Emenda a R1–R5: exige quórum de 2 famílias + hearback humano assinado.

## §10 Mapa da versão (leia sob demanda, nunca de uma vez)

| Preciso de… | Leio |
|---|---|
| Estado vigente e próxima ação | `.hbn/relay/STATE.md` |
| Contrato completo do meu papel | `core/02-papeis.md` |
| Porta da frente mecânica (contrato do G-FRONTDOOR) | `core/role-cards.md` |
| Passo a passo da onda / readback / selagem | `core/03-rito-da-onda.md` |
| Nomes, front-matter, temperatura, árvores | `core/04-artefatos.md` |
| Guards, runner, CI, testes | `core/05-guards.md` |
| Freeze, fitness, exúvia, rollback | `core/06-freeze-fitness-exuvia.md` + `core/exuvia-fitness-criteria.md` |
| Ponte com projetos (membrana/snapshot) | `core/07-projetos-membrana.md` |
| Knowledge (lições operacionais) | `.hbn/knowledge/INDEX.md` |
| Automelhoria, workflows dinâmicos, skills | `core/08-evolucao.md` |
| Por que este exoesqueleto existe | `TRANSICAO.md` |
| De onde veio cada coisa | `MANIFESTO-MIGRACAO.md` |
| Critérios para esta versão ser ativada | `FITNESS-CHECKLIST.md` |

## §11 O que NUNCA fazer (vinculante para todos os papéis)

1. Ler além do orçamento de boot ou exigir que outra IA o faça.
2. Escrever fora do seu slot (matriz de escrita) ou fora do escopo do readback.
3. Auto-ratificar, auto-auditar, auto-estender escopo, auto-hearback.
4. Tratar chat/RETURN/anexo como quórum — só parecer canônico em `.hbn/results/`.
5. Apagar/mover STATE, knowledge, readbacks, results ou REGISTRY sem manifesto
   + sucessor + rollback + quórum + gate humano.
6. Inventar caminho, número ou estado — sob dúvida, PARE (§3).
7. Reabrir decisões travadas por hearback humano sem novo hearback humano.
8. Ativar esta versão (`.hbn/active-version`) sem Fitness Gate completo.

---

*Herança: este exoesqueleto sucede o v0.3.x ("Honest Foundation"). A história
completa permanece no exoesqueleto antigo (raiz do repo) e no git. Detalhes e
justificativa do corte: `TRANSICAO.md`. Princípios constitucionais P1–P13:
inalterados (ponteiro em `core/01-principios.md`).*
