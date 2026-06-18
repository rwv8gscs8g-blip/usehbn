# 03 — Qualidade da Descrição e Documentação do Software useHBN

**NÃO-NORMATIVO (fronteira) — insumo de pré-transição**

- **Autor:** technical writer read-only (avaliação automatizada sob Truth Barrier)
- **Data:** 2026-06-17
- **Escopo:** README, AGENTS, documentação do CLI, docstrings de `src/usehbn/**`, e existência de um glossário canônico.

**Resumo (3 linhas):** O README e o AGENTS.md são fortes em honestidade de maturidade e identidade, mas o pacote sofre de três lacunas estruturais — (1) nenhum glossário canônico para os termos internos (exúvia, árvores, fronteira, livro-razão, readback/hearback, guard, fagocitose), espalhados por specs e brainstorm; (2) ponteiros do AGENTS.md apontam para partições que não existem no disco (`modules/`, `radar/`); (3) nenhum diagrama de fluxo no README/how-it-works e uma cópia SUPERSEDED da Maturity Matrix ainda viva em `docs/`. Nenhum desses bloqueia o freeze, mas três correções leves elevam muito a autossuficiência para um clone novo.

> Truth Barrier: todo achado abaixo cita arquivo:linha OU comando+saída. Não confio em relatos; tudo conferido no disco em 2026-06-17.

---

## A) Diagnóstico do README e do AGENTS.md

### A.1 README.md (`README.md`, 567 linhas) — o que está bom

- **Identidade e propósito claros logo no topo:** `README.md:1-7` (título, subtítulo "open protocol for safe…", versão, licença) e seções "Why HBN exists" (`:30`), "What HBN Is" (`:76`), "What Problem HBN Solves" (`:96`) e principalmente **"What HBN Is Not"** (`:107-118`) — esta lista negativa é exemplar para barrar expectativas infladas.
- **Honestidade de maturidade exemplar:** a tabela "Maturidade por Componente" (`README.md:42-70`) classifica cada componente em Implementado/Parcial/Scaffold/Stub/Visão, e aponta a fonte canônica `methodology/MATURITY-MATRIX.md` (`:40`). As seções "What Works Today" (`:514`) e "What Does Not Work Yet" (`:544`) reforçam isso. Para uma IA nova, isto é ouro.
- **Quickstart e instalação concretos:** `README.md:9-17` (60s), "Installation" (`:151-195`) com `./get-hbn`, dev install, fallback de PATH. Bom.
- **Superfície CLI listada:** "CLI Surface" (`README.md:369-388`) e "Example Usage" com readback/result reais (`:390-422`).

### A.2 README.md — o que confunde ou falta

1. **Não há diagrama do fluxo.** O "Protocol Flow" é só uma lista numerada de 9 passos (`README.md:334-348`); `docs/how-it-works.md:8-14` repete em prosa. Comando+saída: `grep -rl "mermaid\|graph TD\|flowchart" README.md docs/how-it-works.md docs/ARCHITECTURE.md` → **nenhum match**. Um recém-chegado (humano ou IA) não tem visão de como Activation → Intent → Truth Barrier → Guardian → Track → Readback → Hearback → Execution → ERP se encadeiam, nem onde os gates `safe_track`/`fast_track` decidem (`:348`).
2. **Termos internos usados sem definição.** O README usa "exúvia"/"muda" zero vezes, mas usa "Phagocytosis" (`:259-261`), "Truth Barrier" (`:47`), "Guardian", "readback/hearback" (`:50-51`), "baton/relay" (`:53-54`) e "ERP" (`:52`) assumindo conhecimento prévio. ERP só é expandido em `:498` ("Execution Result Protocol") — tarde. Não há glossário (ver seção C).
3. **Mistura PT/EN sem critério visível.** O corpo é majoritariamente inglês, mas blocos inteiros viram português (tabela de maturidade `:38-70`, Universal Translator `:253-257`, Phagocytosis `:259-261`). Para uma IA isso é tolerável; para um humano clonando, é ruído. Não é bloqueador, mas merece nota.
4. **README muito longo (567 linhas) sem índice (TOC).** Não há sumário navegável no topo; um leitor precisa rolar. P2.
5. **Ponteiro de validação no topo pode quebrar.** `README.md:19-28` aponta para `docs/HUMAN-VALIDATION-v0.3.0.md` (existe) e `auditoria/post-implementation/v0.3.0-validation-log-template.md` — não verifiquei a existência deste último; recomenda-se um link-check (ver D, P1).

### A.3 AGENTS.md (`AGENTS.md`, 160 linhas) — o que está bom

- **É de fato uma porta de entrada para IAs:** declara identidade (`:10-17`), tipologia ADR-002 (`:19-28`), os 13 princípios constitucionais com referência canônica (`:29-52`), os 16 sinais HBN com emojis (`:74-96`) e delega a contratos granulares em `agents/` (`:107-119`). É o documento mais "AI-first" do repo.
- **Coerência com `core/role-cards.md`:** os papéis Orquestrador/Implementador/Auditor do cartão (`core/role-cards.md:16-32`) batem com a doutrina do AGENTS (não-tocar-main, escopo, trailers). Coerente.
- **Coerência com o cartão de entrada:** `.hbn/messages/20260616-220000-opus-4-8-cartao-entrada-universal-ia.md:37-57` define a read-list mínima e as leis invioláveis; AGENTS.md as ecoa. Coerente em espírito.

### A.4 AGENTS.md — o que confunde (ACHADOS DUROS)

1. **Ponteiros para partições inexistentes.** AGENTS.md descreve a topologia canônica em `:61-72` citando `modules/` (`:64`, "normative protocol specification") e `radar/` (`:67`, "technology phagocytosis tracking"). Comando+saída:
   - `ls modules/` → `No such file or directory`
   - `ls radar` → `No such file or directory`
   Ou seja, **2 das partições anunciadas como canônicas não existem no disco.** Uma IA nova que tentar ler `modules/` (a "spec normativa") falha. Isto contradiz a própria tabela de tipologia (`AGENTS.md:26` aponta `modules/` como a Protocol Specification). **P0 de honestidade documental.**
2. **Sobre o aviso "cuidado com AGENTS.md:17":** a linha 17 é o ponteiro `**Maturity reference:** methodology/MATURITY-MATRIX.md … single source of truth`. O alvo **existe** (`methodology/MATURITY-MATRIX.md`, 12.835 bytes). PORÉM há uma **cópia duplicada e marcada como SUPERSEDED** em `docs/MATURITY-MATRIX.md` (comando+saída: `head -3 docs/MATURITY-MATRIX.md` → `"Status: SUPERSEDED desde 2026-05-10 …"`; `diff -q docs/MATURITY-MATRIX.md methodology/MATURITY-MATRIX.md` → "differ"). README `:40` aponta corretamente para `methodology/`, mas a existência viva do arquivo `docs/` é uma armadilha: uma IA que faça `find . -name MATURITY-MATRIX.md` acha duas e pode ler a errada. **O ponteiro de AGENTS.md:17 está correto; o risco é a fonte duplicada não-canônica em `docs/`.** P1.
3. **Referência de adapter desatualizada.** AGENTS.md:59 cita os 7 runtimes em `src/usehbn/runtime.py` — o arquivo existe (confirmado). OK. Mas AGENTS.md:26 cita "spec normativa em `modules/`" que não existe (ver item 1).
4. **`agents/` referenciado existe?** AGENTS.md:111-115 lista `agents/agents.md`, `agents/claude.md`, etc. Não verifiquei cada um individualmente neste passo; recomenda-se link-check (D).

---

## B) Lacunas de documentação do CLI e do código

### B.1 CLI — subcomandos vs. documentação

Não consegui rodar `--help` por falha de import esperada; li os help-strings em `src/usehbn/cli.py`. Comando+saída: `grep -nE "add_parser\(" src/usehbn/cli.py` → **18 chamadas `add_parser`** correspondendo a:

| Subcomando | help-string (cli.py) | Documentado no README? |
|---|---|---|
| `run` | `:136` | sim (`README.md:269-273, 384`) |
| `translate` | `:142` | sim (`:235-239, 373`) |
| `connector inspect` | `:173` | sim (`:223-227`) |
| `connector ensure` | `:198` | sim (`:229-233`) |
| `init` | `:242` | sim (`:199-209, 374`) |
| `version` | `:263` | sim (`:172, 372`) |
| `inspect` | `:274` | sim (`:263-267, 375`) |
| `doctor` | `:290` | sim (`:217-221, 376`) |
| `quickstart` | `:306` | sim (`:211-215, 377`) |
| `install` | `:328` | sim (`:275-289, 378`) |
| `attention` | `:355` | sim (`:352-362, 382`) |
| `notify` | `:381` | sim (`:354, 383`) |
| `readback` | `:408` | sim (`:385, 400-411`) |
| `hearback` | `:472` | sim (`:308-312, 386`) |
| `result` | `:499` | sim (`:387, 413-422`) |
| `refresh` | `:551` | sim (`:290-294, 379`) |
| `relay status` | `:567/573` | sim (`:296-300, 380`) |
| `handoff` | `:589` | sim (`:302-306, 381`) |
| `autoevolve` | `:617` | parcial (ver abaixo) |

**Veredito:** a cobertura README↔CLI é alta (17-18 subcomandos todos citados). **Lacunas concretas:**

1. **`autoevolve` é honesto mas subdocumentado.** O help-string é honesto: `"Inspect the autoevolve audit scaffold; no autonomous evolution in v0.3.0."` (`cli.py:619`), e o comentário `cli.py:615-616` confirma que ele é despachado por parser próprio (`usehbn.autoevolve.cli`). MAS o README só o menciona na seção negativa (`:557`) — **não há um único exemplo de uso de `hbn autoevolve status/audit/approve/rollback`** apesar de a Maturity Matrix (`README.md:63`) afirmar que esses 4 verbos existem. Há `docs/HUMAN-INTERFACE-AUTOEVOLVE.md` (existe), mas não é linkado do bloco de uso. **P1.**
2. **O texto declara honestamente o que é scaffold?** Sim, em vários pontos: a própria descrição do parser raiz é `"Run the HBN protocol scaffold…"` (`cli.py:131`), a Maturity Matrix marca Autoevolve/Universal Translator/Connectors-verify/Bridge como Scaffold/Stub/Visão (`README.md:56,60,63,66,69`), e "What Does Not Work Yet" (`:544-557`) é explícito. **Honestidade de scaffold: aprovada.**
3. **Falta um `--help` funcional / um doc espelho do help.** Como `python3 -m usehbn --help` pode falhar por import, não há saída de ajuda confiável para quem clona. Recomenda-se um `docs/CLI-REFERENCE.md` gerado a partir dos help-strings, ou corrigir o import (ver D).

### B.2 Código `src/usehbn/**` — cobertura de docstrings

Comando+saída — heurística de docstring de módulo sobre os 34 arquivos `.py` (exceto `__init__`/`__pycache__`): **0 módulos sem docstring de topo.** A cobertura de docstring **de módulo é 100%** (loop em bash que imprimiria `NO-DOCSTRING:` não emitiu nenhuma linha).

Densidade de funções por arquivo (`grep -cE '^\s*def '`): `cli.py` 56 defs, `state/store.py` e `connectors/storage.py` 14 cada, `runtime.py` 9, `execution/engine.py` 7. Amostragem de qualidade:

- **Boa:** funções utilitárias têm docstrings descritivas, ex. `cli.py:1385` (`_find_latest_pending_readback`), `cli.py:1587-1592` (`_find_pending_readbacks`, explica R1/legado), `cli.py:1527,1553,1575` (comentários "Onda 3" explicando invariantes de relay).
- **Lacuna:** muitas funções `run_*` públicas do CLI (ex. `run_init` `cli.py:1012`, `run_doctor` `:1112`, `run_handoff` `:1618`) **não têm docstring** — operam por nome autoexplicativo, mas uma IA nova lendo o módulo não tem contrato de retorno documentado. Não é grave (o JSON de saída é autodescritivo via chave `project`), mas é P2.
- **Termo sem definição no código:** "ERP" aparece como `create_result_record`/`erp_record` (`cli.py:1486,1503`) sem expansão local; "track" (`safe_track`/`fast_track`) é usado em `TRACK_CHOICES` (`cli.py:422`) sem doc inline do critério de classificação. Ponteiro para glossário resolveria.

### B.3 Coerência de ponteiros no `docs/how-it-works.md`

`docs/how-it-works.md:17-23` aponta para `src/usehbn/trigger.py`, `protocol/intent.py`, `truth_barrier.py`, `guardian.py`, `consent.py`. Comando+saída: todos os 5 caminhos **existem** (loop `for p in …; do [ -f "$p" ]`). **Ponteiros do how-it-works estão corretos** — contraste positivo com AGENTS.md.

---

## C) Proposta de um GLOSSÁRIO canônico único

### C.1 O problema (evidência)

Os termos centrais **não têm lar canônico único**. Comando+saída (`grep -rl <termo> core/ docs/ schemas/ methodology/`):

- **"exúvia"/"exuvia":** definido informalmente só em `core/hbn-exuvia-scaffold.md:10-13` ("scaffold inativo da máquina de muda") e `core/exuvia-fitness-criteria.md`; conceito também em `docs/brainstorm/exuvia-evolucao-conceitual.md` (zona não-canônica).
- **"livro-razão":** aparece em `core/orchestrator-profile-spec.md` e em `docs/brainstorm/**` — sem definição central.
- **"Truth Barrier":** usado em `core/exuvia-fitness-criteria.md`, `core/state-report-spec.md`, `core/freeze-gate-spec.md`, `README.md:47`, `docs/TRUTH-BARRIER.md` (este último é o doc dedicado, mas não é um glossário).
- **"hearback":** em `core/dual-run-spec.md`, `core/pointer-spec.md` — definição operacional dispersa.
- **"fronteira"/"árvores":** **só** em `docs/brainstorm/**` (zona livre, não-canônica). Para uma IA nova, esses dois termos são essencialmente indefinidos no corpo canônico.
- **"fagocitose/phagocytosis":** doutrina em `docs/PHAGOCYTOSIS.md` e resumo em `README.md:259-261`. É o termo mais bem documentado.

Há `core/semantic-layer.md` e `core/protocol.md`, mas ambos definem só os *anchors* semânticos (`usehbn`, `use hbn`, domínios) e os objetivos do protocolo — **não são glossário de termos internos.**

### C.2 Proposta

Criar **um único arquivo canônico**: **`docs/GLOSSARY.md`** (espelhado/linkado de README "What HBN Is", de AGENTS.md no topo, e de `core/protocol.md`). Estrutura sugerida — uma linha por termo, com: termo · definição de 1-2 frases · estado de maturidade (apontando a Maturity Matrix) · ponteiro para o spec canônico.

Termos mínimos a cobrir (todos com evidência de uso disperso acima):

1. **Activation / Trigger** — `usehbn`/`use hbn` (`core/semantic-layer.md`).
2. **Intent (estruturação)** — objetivo, constraints, riscos, validation_requirements (`src/usehbn/protocol/intent.py`).
3. **Truth Barrier** — regra de citar arquivo:linha; advisory hoje (`docs/TRUTH-BARRIER.md`, `README.md:47`).
4. **Guardian / guard** — agregador de warnings + gates que falham fechado (`docs/GUARDIAN.md`).
5. **Track (`safe_track`/`fast_track`)** — classificação que decide se exige readback+hearback (`README.md:348`, `cli.py:422`).
6. **Readback** — registro do entendimento/plano antes de executar (`core/readback-spec.md`).
7. **Hearback** — confirmação humana que destrava o ERP (`core/dual-run-spec.md`).
8. **ERP (Execution Result Protocol)** — registro do resultado (`README.md:498`, `src/usehbn/protocol/result.py`).
9. **Relay / Baton (bastão)** — coordenação inter-IA e posse do turno (`core/relay-spec.md`).
10. **Handoff** — transferência validada do bastão (`cli.py:1618`).
11. **Fronteira** — zona não-normativa (ex.: `docs/brainstorm/**`) — **definir explicitamente**, hoje só implícito.
12. **Livro-razão** — registro append-only de decisões (`core/orchestrator-profile-spec.md`).
13. **Exúvia / muda** — corte/scaffold descartável do protocolo sob Fitness Gate (`core/hbn-exuvia-scaffold.md`, `core/exuvia-fitness-criteria.md`).
14. **Árvores** — (definir; hoje só em brainstorm) modelo registry-centric mencionado no cartão de entrada e em `docs/brainstorm/PROPOSTA-arvores-agora.md`.
15. **Fagocitose / Phagocytosis** — doutrina routed→studied→digested→mastered→contributed (`docs/PHAGOCYTOSIS.md`).
16. **Freeze / Freeze Gate** — congelamento de superfície pública (`core/freeze-gate-spec.md`).

### C.3 Onde deve viver

- **Lar canônico:** `docs/GLOSSARY.md` (Diataxis-friendly, já que `docs/INTEGRATION-DIATAXIS.md` é integração categoria A — `README.md:472`).
- **Ponteiros obrigatórios:** README (logo após "What HBN Is", `:76`), AGENTS.md (novo item na "Project identity", junto de `:17`), e `core/protocol.md` (rodapé "Definições").
- **Para IAs (LLM):** dado que `README.md:473` declara `llms.txt` como integração adotada mas `ls llms.txt docs/llms.txt` → **não existe** (comando+saída), o glossário deveria ser referenciado a partir de um futuro `llms.txt`. Ver D.

---

## D) Lista priorizada de melhorias (P0 / P1 / P2)

Distinção pedida: **leve = entra antes do freeze** (correção pontual, baixo risco, melhora autossuficiência); **exúvia = descartável / pós-corte** (não pertence ao genoma congelado e pode ser cortado na muda).

### P0 — corrigir antes do freeze (honestidade documental; barato)

1. **Reconciliar AGENTS.md com o disco.** `modules/` e `radar/` não existem (comando+saída em A.4.1). Ou criar stubs mínimos dessas partições, ou editar `AGENTS.md:26,64,67` para marcar "(planejado — não materializado em v0.3.0)". Sem isso, a "spec normativa" prometida é um ponteiro morto para qualquer clone. **Leve.**
2. **Resolver a Maturity Matrix duplicada.** `docs/MATURITY-MATRIX.md` está SUPERSEDED mas vivo (comando+saída em A.4.2). Deixar só um stub-redirect de 2 linhas apontando para `methodology/MATURITY-MATRIX.md`, evitando que uma IA leia a versão errada. **Leve.**

### P1 — fortemente recomendado antes do freeze (autossuficiência)

3. **Criar `docs/GLOSSARY.md`** (seção C). Sem ele, "fronteira", "árvores", "livro-razão" e "exúvia" só existem em `docs/brainstorm/**` (zona livre) — invisíveis para o genoma canônico. **Leve.** Maior ganho de autossuficiência por linha escrita.
4. **Adicionar um diagrama de fluxo** (Mermaid ou ASCII) ao README "Protocol Flow" (`:334`) e/ou `docs/how-it-works.md`, cobrindo os 9 passos e os gates `safe_track`/`fast_track`. Hoje há zero diagramas (comando+saída em A.2.1). **Leve.**
5. **Link-check de todos os ponteiros do README e AGENTS.** Verificar `auditoria/post-implementation/v0.3.0-validation-log-template.md` (`README.md:28`), os 5 arquivos `agents/*.md` (`AGENTS.md:111-115`) e os ~25 docs linkados no README. Um script `scripts/check-links.sh` read-only resolveria. **Leve.**
6. **Documentar `hbn autoevolve` com exemplos honestos.** Linkar `docs/HUMAN-INTERFACE-AUTOEVOLVE.md` do bloco de uso e mostrar `hbn autoevolve status/audit` com o disclaimer de scaffold (`cli.py:619`). **Leve.**
7. **Gerar `docs/CLI-REFERENCE.md`** (espelho dos help-strings) OU corrigir o import que quebra `python3 -m usehbn --help`. Um clone novo precisa de um `--help` confiável. **Leve a médio.**

### P2 — desejável; pode entrar depois ou ser tratado como exúvia

8. **TOC navegável no README** (567 linhas, sem sumário). **Leve.**
9. **Docstrings nas funções públicas `run_*` do CLI** (contrato de retorno). Útil para IAs lendo o código; baixo risco. **Leve.**
10. **Política de idioma PT/EN no README** (decidir e aplicar; hoje é misto, A.2.3). **Leve.**
11. **Criar `llms.txt`** (mapa curado para LLMs), já que é integração declarada (`README.md:473`) mas inexistente. Apontar para README, AGENTS, GLOSSARY, Maturity Matrix. **Leve.**

### Exúvia (descartável — NÃO pertence ao genoma congelado)

- Os ~9 arquivos `PROMPT_*_FABLE5.md`, `20260610-*.md` e `AUDITORIA_SUPERPOWERS.md` na **raiz** do repo (ver `ls` da raiz) são insumos operacionais de onda, não documentação de produto. São **exúvia documental**: devem sair da raiz (para `auditoria/` ou serem cortados na muda) para não poluir a primeira impressão de um clone. **Cortar na exúvia, não antes do freeze.**
- Todo o conteúdo de `docs/brainstorm/**` (inclusive este relatório) é **fronteira/não-normativo** e não deve ser promovido ao genoma sem aprovação humana — exatamente como o cartão de entrada exige (`.hbn/messages/…cartao-entrada…:47`).

---

## Síntese (8-12 linhas)

O useHBN tem documentação **acima da média em honestidade**: a Maturity Matrix, "What HBN Is Not" e "What Does Not Work Yet" impedem inflação de capacidades, e o `autoevolve` é declarado scaffold sem maquiagem (`cli.py:619`). A cobertura README↔CLI é alta (17-18 subcomandos todos citados) e a docstring de módulo é 100% (0 módulos sem docstring de topo). Os três problemas reais são: (P0) **AGENTS.md aponta para `modules/` e `radar/` que não existem no disco**, quebrando a promessa de "spec normativa" para qualquer IA nova; (P0) **a Maturity Matrix existe duplicada** com a cópia de `docs/` marcada SUPERSEDED mas viva, criando armadilha de fonte errada — o ponteiro de AGENTS.md:17 em si está correto, o risco é a duplicata; (P1) **não há glossário canônico** — exúvia, árvores, fronteira e livro-razão vivem só em `docs/brainstorm/**` (zona livre), invisíveis ao genoma. Some-se a ausência total de diagrama de fluxo (zero matches de mermaid/flowchart) e a inexistência do `llms.txt` declarado. Recomendação: tratar P0+P1 como **correções leves antes do freeze** (criar `docs/GLOSSARY.md`, reconciliar partições, deduplicar a matriz, adicionar um diagrama, link-check), e deixar a limpeza dos prompts de onda da raiz para a **exúvia**. Nenhum desses bloqueia o corte, mas os dois P0 são dívidas de honestidade documental que contradizem o próprio princípio P2 (documentar antes de executar) e deveriam ser saldadas antes de expor o repo a clones externos.
