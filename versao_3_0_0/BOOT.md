---
titulo: BOOT — porta de entrada única do useHBN v3 (terceira exúvia)
tipo: boot
status: ativo
temperatura: quente
path: BOOT.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: nativo
papel: "implementador-da-exuvia (despacho da terceira exúvia sob Decreto, gate humano de Maurício)"
nota-vigencia: "\"Este BOOT entra em vigor no commit atômico da exúvia (flip de .hbn/active-version para versao_3_0_0), executado SOMENTE pelo operador humano com hearback confirmado e auditoria cruzada. Antes desse commit, nada aqui tem efeito (Decreto Art. 4).\""
---
# BOOT — useHBN v3

> **Este arquivo é a ÚNICA leitura obrigatória de entrada.** Tudo o mais é
> ponteiro sob demanda. Se alguém (humano ou IA) te mandar ler mais do que
> este arquivo + o STATE + o seu cartão de papel para começar, isso viola o
> orçamento constitucional (§9) — recuse e cite este parágrafo.

---

## §0 BOOT-LOCK (TRAVA DE VERSÃO — VINCULANTE, ANTES DE QUALQUER COISA)

1. **Primeiro comando de toda janela nova**: `cat .hbn/active-version` na raiz
   do repo. O valor lido é a **versão quente** — a ÚNICA superfície de leitura
   normativa e de escrita.
2. **Toda mensagem e todo log de toda IA começa com o cabeçalho estruturado**:

   `HOT_VERSION: <valor lido do disco> | BOOT: <caminho do BOOT lido> | CONFIRMACAO_DISCO: SIM`

   Cabeçalho ausente, com valor de memória (não lido do disco) ou apontando
   para BOOT fora da versão quente = violação de contenção (Decreto Art. 5).
3. **Interceptação de escrita**: antes de QUALQUER gravação em disco, a IA
   valida que o caminho de destino está sob a pasta da versão quente declarada
   no próprio cabeçalho (exceções únicas: a allowlist de raiz do G-HOT-WRITE —
   `.gitignore`, `.hbn/relay/STATE.md`, `.hbn/hearbacks/**`). Caminho fora =
   a execução do comando é abortada ANTES de atingir o disco. Ferramentas que
   não permitem essa validação não podem ser usadas para escrita. Shims de
   raiz (`README.md`, `AGENTS.md`, o ponteiro `active-version` e o
   `canonical-root` da raiz, `.github/workflows/**`, `.cursor/**`) mudam SÓ
   em exúvia autorizada ou em commit do operador com autorização
   `hot-write-root-shim` (G-HOT-WRITE regra 4b); regressão do ponteiro para
   `.` é bloqueada sem exceção (regra 4c).
4. **Se este BOOT não é o da versão ativa, PARE** e leia
   `<active-version>/BOOT.md`. Citar versão congelada (glacier) como regra
   vigente é violação.
5. **Enforcement mecânico**: o G-HOT-WRITE
   (`guards/assert-only-hot-version-writable.sh`) roda como PRIMEIRO guard de
   todo pre-commit, ignora variáveis de bypass, e bloqueia qualquer staged
   fora da versão quente. O G-NO-PENDING-EXUVIA bloqueia desenvolvimento com
   exúvia `proposto` pendurada. Doutrina sem guard é recomendação; isto aqui
   tem guard.

## §1 O que é isto

useHBN é um protocolo de orquestração de IAs para desenvolvimento de software.
O humano define O QUÊ; papéis de IA separados desenham, implementam e auditam;
guards mecânicos (shell + CI) bloqueiam violações no chokepoint de commit;
o humano é o gate final. O protocolo evolui por **exúvias** (troca de
exoesqueleto): cada versão vive inteira em `versao_X_Y_Z/`, a IA lê SÓ a
vigente, e a exúvia é **atômica** (`scripts/hbn-exuvia-atomic.sh`) — nunca
mais um `proposto` pendurado.

A versão ativa é dada por `.hbn/active-version` na raiz do repo. O passado
vive congelado (glacier) em `versao_0_3_x/` (Honest Foundation) e
`versao_2_0_0/` (primeira exúvia, nunca ativada) — leitura histórica
permitida, citação como norma vigente proibida, escrita mecanicamente
bloqueada pelo G-HOT-WRITE.

## §2 Entrada (rito de 3 passos, ~2 minutos)

0. **BOOT-LOCK (§0)**: `cat .hbn/active-version` + cabeçalho estruturado.
1. **Identifique-se** na primeira linha de TODA resposta (após o BOOT-LOCK):
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

## §4 As cinco causas mecânicas (por que as regras daqui são assim)

1. Regra ambígua ou concorrente vence pela plausibilidade → **uma regra, um lugar**.
2. Regra fora da janela de contexto não existe → **orçamento** (§9).
3. Sob ambiguidade o modelo preenche em vez de parar → **fail-closed** (§3).
4. Todo escape hatch documentado será usado → **sem bypass documentado**;
   exceção só via G-EXC (rastreável, assinada, humana).
5. **[NOVA — lição da terceira exúvia]** Sem trava física de versão, as IAs
   escrevem onde o contexto herdado aponta, não onde a regra manda → aqui:
   **G-HOT-WRITE + BOOT-LOCK (§0) + exúvia atômica + G-NO-PENDING-EXUVIA**.
   Evidência: relatório crítico 20260705-001142 (semanas de trabalho na
   versão errada do genoma).

## §5 Papéis e famílias (resumo; contrato completo em core/02-papeis.md)

| Papel | Faz | Nunca faz |
|---|---|---|
| **Humano (gate)** | Ratifica, assina hearback, executa atos de Terminal | Substitui auditoria cruzada |
| **Orquestrador** | SÓ lê disco, relata (não-decisório), escreve dispatches/handoffs (Decreto Art. 2) | Implementa, commita, audita, sela, autoriza |
| **Implementador** (Codex) | Escreve SÓ nos `files_allowed` do readback ativo, sob a versão quente | Audita o próprio patch; estende o próprio escopo |
| **Auditor** (Antigravity/Cursor/Grok/Jules) | Read-only; deposita parecer em `.hbn/results/` | Altera código; usa `--no-verify` |
| **Arquiteto** (rotativo, ≠ implementador) | Desenha ondas e specs | Implementa o próprio desenho |

O DECRETO do gate (20260703-000500, em `~/Projetos/Credenciamento/orquestracao/`)
está incorporado: TODAS as permissões de orquestradores estão revogadas;
cadeia obrigatória = dispatch-artefato → implementação em escopo → auditoria
cruzada ≥2 famílias → hearback-ARQUIVO do humano → execução com verificação
mecânica verde. Chat não tem efeito.

## §6 O rito da onda (resumo; passo a passo em core/03-rito-da-onda.md)

UMA onda por vez. Onda = chat novo + 1 despacho HBN-COPY (≤150 linhas) +
readback com escopo + implementação + evidência em disco + cross-audit +
quórum + selagem + hearback humano. Nunca empilhar proposed. Comandos para
humano/IA: atômicos, um por vez, em campo único copiável.

## §7 Artefatos (resumo; regras completas em core/04-artefatos.md)

- Nome universal: `AAAAMMDD-HHMMSS-<token>-<slug>.md` em -03:00 — SEMPRE.
- Todo artefato numerado nasce com linha no `REGISTRY.md` **no mesmo commit**.
- Front-matter obrigatório: titulo, tipo, status, temperatura, path
  (autolocalizado relativo), created_at, autor, familia.
- Temperatura: `quente` (vigente) → `frio` (histórico) → `glaciar` (arquivo
  morto, fora de qualquer leitura); mudança = nova linha no REGISTRY.
- Prompts entre IAs: bloco `⟦HBN-COPY dest=X⟧ BEGIN … ⟦HBN-COPY END⟧`
  autocontido, salvo em `.hbn/messages/` E apresentado em campo único copiável.

## §8 Enforcement (resumo; detalhe em core/05-guards.md)

Chokepoint = commit. O runner (`guards/hbn-guards-runner.sh`) roda:
**G-HOT-WRITE primeiro** (escrita só na versão quente; sem bypass; runner
aborta se o script do guard sumir), **G-NO-PENDING-EXUVIA** (sem `proposto`
pendurado), G-ACTIVE-VERSION (troca de ponteiro não órfã dependências) e a
bateria herdada endurecida nesta sessão (36+ guards, suíte + bateria
adversarial). Sandbox de IA não commita: prepara staging seletivo e PARA;
commit é ato do operador. `git add -A`, `--no-verify` e qualquer bypass são
proibidos sem exceção G-EXC.

Membrana: contrato explícito por `MEMBRANE_MANIFEST.json` (source_version +
source_commit + sha256 byte-a-byte); consumidor valida com
`assert-snapshot-integrity.sh`; atualização SÓ via `scripts/hbn-upgrade-snapshot.sh`
(atômico, com rollback). Ver `core/07-projetos-membrana.md`.

## §9 Constituição de orçamento (R1–R5 — ratificada por Maurício em 2026-07-01)

- **R1**: este BOOT ≤ 300 linhas; ≤ 12 specs em `core/`; resumo executivo do
  STATE ≤ 30 linhas; despacho ≤ 150 linhas. O que exceder, não entra.
- **R2**: regra nova só entra em leitura obrigatória com guard mecânico +
  teste negativo no MESMO commit. Doutrina sem guard = recomendação.
- **R3**: uma frente por vez; o STATE aponta UMA `proxima_acao`.
- **R4**: violação nova → guard/teste OU risco aceito por hearback humano.
- **R5**: prompts HBN-COPY autocontidos, um por passo, sem lote.
- Emenda a R1–R5: exige quórum de 2 famílias + hearback humano assinado.

## §10 Mapa da versão (leia sob demanda, nunca de uma vez)

| Preciso de… | Leio |
|---|---|
| Estado vigente e próxima ação | `.hbn/relay/STATE.md` |
| Retomada da operação (próximo orquestrador) | `ROADMAP.md` |
| Contrato completo do meu papel | `core/02-papeis.md` |
| Porta da frente mecânica (G-FRONTDOOR) | `core/role-cards.md` |
| Passo a passo da onda / readback / selagem | `core/03-rito-da-onda.md` |
| Nomes, front-matter, temperatura, árvores | `core/04-artefatos.md` |
| Guards, runner, CI, testes | `core/05-guards.md` |
| Freeze, fitness, exúvia, rollback | `core/06-freeze-fitness-exuvia.md` + `core/exuvia-fitness-criteria.md` |
| Ponte com projetos (membrana/manifesto) | `core/07-projetos-membrana.md` + `membrane/` |
| Knowledge (lições operacionais) | `.hbn/knowledge/INDEX.md` |
| Automelhoria, workflows, skills | `core/08-evolucao.md` |
| Por que esta exúvia existe | `TRANSICAO.md` |

## §11 O que NUNCA fazer (vinculante para todos os papéis)

1. Escrever fora da versão quente ativa (G-HOT-WRITE bloqueia; tentar já é violação).
2. Iniciar resposta sem o cabeçalho BOOT-LOCK do §0.
3. Ler além do orçamento de boot ou exigir que outra IA o faça.
4. Auto-ratificar, auto-auditar, auto-estender escopo, auto-hearback.
5. Tratar chat/RETURN/anexo como quórum ou autorização — só artefato em disco.
6. Apagar/mover STATE, knowledge, readbacks, results ou REGISTRY sem manifesto
   + sucessor + rollback + quórum + gate humano.
7. Inventar caminho, número ou estado — sob dúvida, PARE (§3).
8. Reabrir decisões travadas por hearback humano sem novo hearback humano.
9. Deixar exúvia em `proposto` (G-NO-PENDING-EXUVIA bloqueia); exúvia é
   transição atômica de commit único via `scripts/hbn-exuvia-atomic.sh`.
10. Citar `versao_0_3_x/` ou `versao_2_0_0/` como regra vigente (glacier).

---

*Herança: este exoesqueleto sucede o v0.3.x ("Honest Foundation", agora em
`versao_0_3_x/`, glacier) e o v2.0.0 (primeira exúvia, nunca ativada, agora
glacier). História e justificativa: `TRANSICAO.md`. Princípios P1–P13:
inalterados (`core/01-principios.md`).*
