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

## Estado

**Aprovados pelo Maurício em 2026-06-16** para já serem **seguidos no dogfooding
antes da primeira exúvia** — mas a adoção ainda **precisa ser validada** (cross-audit
+ promoção formal). Ou seja: passam de "candidatos" a **adotados-em-teste**.

- Uso imediato (informal, sem virar guard): aplicar P-CAND-01 e P-CAND-02 como lente nas próximas ondas e cross-audits, registrando quando ajudaram — isto é o próprio dogfood que vai validá-los.
- Promoção formal: submeter a cross-audit e promover a `core/` + ADR em S3 ou onda própria de evolução do protocolo. P-CAND-01 vira eixo proporcional do contrato de cross-audit; P-CAND-02 vira critério/cláusula no Fitness Gate e/ou `core/exuvia-fitness-criteria.md`.
- Validação = evidência de dogfood: ao chegar a primeira exúvia, mostrar que (a) a pergunta da via mais simples foi feita nas ondas de peso sem virar ruído nas triviais, e (b) cada muda manteve a suíte verde e fez "mais com menos".
