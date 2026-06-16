# Princípios candidatos — fila para a evolução do protocolo

Princípios propostos pelo Maurício, **analisados aqui mas ainda NÃO normativos**.
Ficam nesta fila até serem submetidos formalmente a uma onda de evolução do
protocolo (readback + cross-audit + selagem), quando então podem virar emenda em
`core/` + ADR. Zona livre: nada aqui vincula até promovido.

---

## P-CAND-01 — A pergunta recorrente da via mais simples

**Enunciado (Maurício):** em toda auditoria cruzada, perguntar sempre: *"existe
alguma outra forma mais simples, eficaz, efetiva ou racional de resolver o mesmo
problema, mesmo que partisse de premissas diferentes ou que precisasse fazer mão
de outros recursos ou tecnologias?"* A pergunta olha não só o processo de
desenvolvimento atual, mas a **forma de evoluir** — inclusive trocando a
tecnologia.

**Análise — por que vale:**
- É a pressão seletiva contra a ossificação. Sem ela, o cross-audit valida se a casca está *bem-feita*, mas nunca se a casca é a *forma certa*. Casa exatamente com a exúvia: a muda só é evolução (e não mera renovação) se houver quem pergunte "a carapaça atual ainda é a melhor carapaça?".
- Ataca o anti-padrão que o Maurício nomeou: "não otimizar o que não deveria existir, nem conviver com código gigante que caberia em uma linha". A pergunta força o salto de premissa, não só o ajuste incremental.
- É forward-looking: admite que a melhor resposta possa exigir outra tecnologia/recurso — o oposto do lock-in.

**Análise — o risco (que o próprio Maurício apontou):**
- Não pode virar ruído. Numa correção trivial (acento, erro ortográfico, fix de uma linha), perguntar "há uma forma radicalmente diferente?" é poluição e desperdício. Mata a leveza que pretende defender.

**Proposta de operacionalização equilibrada (a refinar na promoção):**
- **Proporcionalidade por peso da mudança.** A pergunta é OBRIGATÓRIA acima de um limiar (novo mecanismo, novo guard, nova spec, mudança estrutural ou de premissa) e SUPRIMIDA abaixo dele (cosmético, typo, rename, ajuste de uma linha sem mudança de comportamento).
- **Truth Barrier também aqui.** Quando aplicada, a resposta é registrada mesmo que seja "nenhuma via mais simples encontrada" — prova de que a pergunta foi feita, não pulada.
- **Recorrência, não repetição.** Feita a cada onda de peso, não a cada commit. Acumula um histórico de "alternativas consideradas e por que a atual venceu" — memória de design, não burocracia.
- Candidato a virar: um eixo opcional-condicional no contrato de cross-audit (ex.: SEÇÃO "via alternativa" que só dispara acima do limiar).

---

## P-CAND-02 — Mudar o protocolo é limpar o código sem perder o que funciona

**Enunciado (Maurício):** "passar"/mudar o protocolo (a exúvia) é **limpar o
código garantindo que tudo o que funciona continuará funcionando**; conseguir
**fazer mais com menos e melhor**. Por isso as validações e testes têm de ser
**robustos, idempotentes e resolutivos**.

**Análise — por que vale:**
- Define o critério de sucesso da muda em uma frase: **menos código + zero regressão funcional + melhor**. Sem a cláusula "o que funciona continua funcionando", simplificar vira aposta; com ela, vira engenharia.
- Explica *por que* a bateria de testes precisa ser tão forte: ela é a **rede que permite cortar com coragem**. Quanto mais robusto o teste, mais agressiva pode ser a lapidação sem medo — a suíte é a licença para simplificar.
- Conecta direto aos critérios de exúvia já normativos: é C-NOREG (sem regressão) + C-TEST (prova dos dois lados) elevados a princípio-guia.

**Análise — as três qualidades dos testes (operacionalizando):**
- **Robustos:** cobrem o caso bom e o caso ruim, e resistem a entradas adversariais (a bateria B*). Falham fechado.
- **Idempotentes:** rodar N vezes dá o mesmo veredito; sem flakiness, sem estado residual (o gap dos scratch dirs é justamente uma quebra disso — efeito colateral entre execuções).
- **Resolutivos:** dão veredito claro (passa/bloqueia), não "talvez"; o sinal é acionável sem interpretação.

**Proposta de operacionalização (a refinar na promoção):**
- A **definição de pronto da muda** passa a exigir, lado a lado: (a) suíte completa verde (nada que funcionava quebrou) e (b) uma métrica de "mais com menos" (ex.: LOC/complexidade não-cresceu, idealmente caiu) com justificativa.
- Candidato a virar: cláusula no Fitness Gate (`core/hbn-exuvia-scaffold.md`) e/ou critério C-LEVE adicional em `core/exuvia-fitness-criteria.md`.
- A idempotência dos testes vira invariante verificável (rodar a suíte 2× e comparar veredito) — fecha o anti-padrão dos scratch residuais.

---

## P-CAND-03 — Lição aprendida só vale se grudar (porta da frente das lições)

**Enunciado (Maurício, 2026-06-16):** o que é aprendido precisa **ficar** como
lição aprendida e ser **seguido** — não basta existir num arquivo. É um ponto do
protocolo que existe mas falha e precisa melhorar.

**Evidência (Truth Barrier, dogfood do próprio defeito):**
- As lições já existem e estão `accepted`: `.hbn/knowledge/0001-comandos-atomicos-copiaveis.md` ("1 comando = 1 bloco, copiável, explicação fora do bloco") e `0002-entrega-operacional-minimalista.md` ("ao humano, entrega minimalista e acionável"). Mesmo assim foram **repetidamente violadas** pelo orquestrador (cards de arquivo em vez do bloco colável), e o Maurício teve de cobrar várias vezes.
- Causa-raiz no disco: `.hbn/knowledge/INDEX.md` está **estagnado** — lista só 3 entradas antigas e **não inclui 0001/0002/0003/0019/0022**. A porta de entrada da base de lições não aponta para as lições. Não há read-list de boot nem guard que force a consulta.
- Converge com a lição "porta da frente" do brainstorm (`exuvia-evolucao-conceitual.md`, entrada D): o protocolo não pode depender de a IA *querer* ler — precisa de entrada barata e obrigatória.

**Análise — por que vale:** uma lição que não é re-lida nem aplicada é lixo de
conhecimento — pior que ausência, porque dá falsa sensação de que o problema foi
resolvido. Num sistema que será automatizado, a lição tem de virar comportamento
default, não memória que cada sessão redescobre.

**Proposta de operacionalização (a refinar na promoção):**
- **INDEX vivo:** o INDEX da knowledge é regenerável/verificável; toda entrada nova aparece nele. Candidato a guard simples (G-KNOW-INDEX): falha se há `NNNN-*.md` ausente do INDEX.
- **Read-list de boot:** as knowledge `accepted` operacionais (0001/0002) entram na read-list mínima de QUALQUER IA ao assumir o bastão — junto de STATE + readback ativo + contrato do papel.
- **Auto-checagem no cross-audit/handoff:** um item objetivo "a entrega operacional honrou knowledge 0001/0002?" — torna a lição verificável, não opcional.
- **Carry-forward na exúvia:** knowledge `accepted` operacional sobrevive à muda como parte do genoma (mesma lógica do CRISPR proposta no brainstorm).

**Adoção imediata (sem esperar promoção):** o orquestrador passa a entregar todo
conteúdo operacional como bloco colável no chat, por padrão — dogfood de 0001/0002
a partir de agora.

---

## P-CAND-04 — Área temporária segura para IAs (design convergido no cross-audit S3.1)

**Origem:** lição knowledge 0023 + parecer de design de Gemini/Antigravity e Cursor
(`.hbn/results/20260616-121025-gemini-3-5-cross-ia-s3-1.md`,
`.hbn/results/20260616-124526-cursor-cross-ia-s3-1.md`). Ainda **não implementado** —
candidato a onda própria.

**Regra primária (consenso):** trabalho efêmero (fixtures, rascunhos) vai para o
tmp do **próprio ambiente da IA** (`$TMPDIR`/sandbox/sessão), **fora do repo**.
Para provar que um guard bloqueia, usar **`git add` + `git reset`** (stage e
desfaz), nunca arquivo solto.

**Se for inevitável no repo (consenso):** uma única pasta `/scratch/` na raiz,
com defesa em camadas (gitignore sozinho NÃO basta):
- `.gitignore` com âncora de raiz `/scratch/` + um `README` versionado explicando a regra (sem segredos/PII).
- **G-SCRATCH-LOCK** — bloqueia qualquer path staged sob `scratch/` (nunca entra na história/origin).
- **G-SCRATCH-SYMLINK** — bloqueia symlink em `scratch/` que resolva para fora dela (fecha vazamento por link).
- **G-SCRATCH-IGNORE** — se o `.gitignore` mudar, exige que a linha `/scratch/` siga presente no blob staged (impede remover a proteção sorrateiramente).
- Política de backup/sync **excluindo** `/scratch/`.

**Por que seguro:** como nada sob `scratch/` jamais é commitado nem sincronizado,
ela não vira superfície de exposição no repositório/origin; os três guards fecham
os vetores de vazamento (stage, symlink, remoção do ignore).

---

## Estado

**Aprovados pelo Maurício em 2026-06-16** para já serem **seguidos no dogfooding
antes da primeira exúvia** — mas a adoção ainda **precisa ser validada** (cross-audit
+ promoção formal). Ou seja: passam de "candidatos" a **adotados-em-teste**.

- Uso imediato (informal, sem virar guard): aplicar P-CAND-01 e P-CAND-02 como lente nas próximas ondas e cross-audits, registrando quando ajudaram — isto é o próprio dogfood que vai validá-los.
- Promoção formal: submeter a cross-audit e promover a `core/` + ADR em S3 ou onda própria de evolução do protocolo. P-CAND-01 vira eixo proporcional do contrato de cross-audit; P-CAND-02 vira critério/cláusula no Fitness Gate e/ou `core/exuvia-fitness-criteria.md`.
- Validação = evidência de dogfood: ao chegar a primeira exúvia, mostrar que (a) a pergunta da via mais simples foi feita nas ondas de peso sem virar ruído nas triviais, e (b) cada muda manteve a suíte verde e fez "mais com menos".
