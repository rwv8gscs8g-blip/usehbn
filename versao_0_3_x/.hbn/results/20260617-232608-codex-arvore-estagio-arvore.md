SOU: OpenAI · GPT-5 Codex · apelido: codex-arvore · papel auditor

# Parecer de design: evolução de estágio de árvore

## Leitura de disco

Li como barreira de verdade:

- `docs/brainstorm/rodada-2026-06-17/NUMERACAO-decisao-consolidada.md`
- `core/arvores-spec.md`
- `guards/assert-arvore-label.sh`

Também consultei, para responder a P6/exúvia sem inferir no vazio:

- `REGISTRY.md`
- `core/exuvia-fitness-criteria.md`
- `core/hbn-exuvia-scaffold.md`
- `docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/02-mapa-migracao-genoma-autocontido.md`

## Veredito curto

O estágio de árvore deve continuar fora do id. A fonte de verdade deve continuar sendo o REGISTRY append-only. Porém, para consulta barata do estágio corrente, recomendo um resolver determinístico ou índice materializado gerado a partir do REGISTRY. Esse índice pode expor o estágio vigente, mas não pode ser fonte normativa independente.

## 1. Eventos append-only bastam, ou precisa estágio corrente resolvível?

Minha resposta: **bastam como prova**, mas **não bastam como ergonomia** se cada consumidor precisar reinterpretar o livro inteiro manualmente. O id não deve expor estágio; o manifesto também não deve virar fonte paralela. O que deve existir é:

1. REGISTRY como fonte normativa.
2. Regra determinística de resolução: estágio corrente = último evento válido de árvore para o artefato.
3. Índice/ponteiro derivado opcional, regenerável, para leitura barata.

Evidência:

- A consolidação já identifica estágio como estado mutável e id como identidade imutável; incluir estágio no id quebraria referências em promoção (`docs/brainstorm/rodada-2026-06-17/NUMERACAO-decisao-consolidada.md:77-82`).
- A mesma seção diz que a evolução deve ser mecanismo separado do id, por evento `arvore-promocao` no REGISTRY, com readback e onda (`docs/brainstorm/rodada-2026-06-17/NUMERACAO-decisao-consolidada.md:83-95`).
- A spec normativa diz que o REGISTRY é a fonte única da árvore e define a coluna `arvore` going-forward (`core/arvores-spec.md:29-37`).
- A spec também proíbe `arvore:` em front-matter e evita parser YAML/runtime para isso (`core/arvores-spec.md:39-40`).
- Promoção é append-only no REGISTRY; a linha original nunca é editada (`core/arvores-spec.md:42-49`).
- O guard bloqueia `intermediaria|estavel` sem `tipo=arvore-promocao` e readback rastreável (`guards/assert-arvore-label.sh:130-139`).

Logo: **não colocar estágio no id nem no manifesto autoritativo**. Se o usuário ou ferramenta precisa responder "qual é o estágio atual?", isso deve vir de `hbn arvore resolve <artefato>` ou de `.hbn/index/arvores-current.*` gerado e validável contra o REGISTRY. Se o índice divergir do REGISTRY, o REGISTRY vence.

## 2. Reconstrução barata e não-ambígua da trajetória, inclusive despromoções

O desenho atual reconstrói promoções, mas ainda não especifica despromoção/reversão com a mesma clareza. A trajetória barata precisa de uma regra de replay:

1. Chave do artefato: preferir id estável do artefato quando o esquema `cNN.wMM-slug` nascer; enquanto isso, usar `artefato (path)` como chave.
2. Ordenação: ordem física das linhas append-only do REGISTRY; `created_at` é evidência humana, não desempate normativo.
3. Nascimento: primeira linha do artefato define estágio inicial. Para linhas novas, o default honesto é `fronteira`.
4. Transição: cada linha `tipo=arvore-promocao` ou `tipo=arvore-despromocao` para a mesma chave adiciona um passo; a coluna `arvore` é o estágio alvo.
5. Prova: cada transição cita readback versionado, onda e autorização humana; promoção a `intermediaria|estavel` exige cross-audit.

Evidência:

- O próprio REGISTRY é livro-razão append-only; a ordem das linhas diz o que veio antes (`REGISTRY.md:13-19`).
- O bloco R2 introduz sete colunas going-forward, incluindo `arvore` e `created_at` (`REGISTRY.md:1059-1066`).
- A spec declara `fronteira` como default honesto para artefato novo (`core/arvores-spec.md:22-23`).
- A spec exige que promoção referencie readback e seja rastreável por onda (`core/arvores-spec.md:48-49`).
- A promoção para `intermediaria|estavel` exige aprovação humana e cross-audit de família diferente (`core/arvores-spec.md:61-62`).
- O guard só verifica promoção hoje; ele não define `arvore-despromocao` nem `arvore-reversao` (`guards/assert-arvore-label.sh:130-139`).

Lacuna real: despromoção não está normatizada. Eu adicionaria o menor complemento:

```text
tipo=arvore-despromocao
arvore=<estagio_alvo>
evidencia/readback=.hbn/readbacks/NNNN-*.json
de=<estagio_anterior_derivado_ou_declarado>
motivo=<regressao|superseded|exuvia|reversao>
reverte_evento=<id-evento-opcional>
```

Isso pode caber como metadado estruturado no campo `tipo` ou em uma futura coluna `evidencia`, mas o ponto normativo mínimo é: **despromover também é append-only; nunca se apaga nem edita a promoção anterior**. Reversão P6 é só uma transição nova que cita o evento revertido. A história fica:

```text
nascimento: fronteira
arvore-promocao: intermediaria
arvore-promocao: estavel
arvore-despromocao: intermediaria
arvore-promocao: estavel
```

O estágio corrente é o último alvo válido. A trajetória completa é o replay inteiro.

## 3. Exúvia g1 -> g2: re-provar ou herdar estágio?

Minha recomendação: **não herdar estágio automaticamente**. Ao atravessar exúvia, o estágio precisa ser revalidado pelo Fitness Gate ou por evento explícito de revalidação que cite a evidência antiga e prove que ela ainda vale no novo genoma. Isso é herança com evidência, não herança cega.

Evidência:

- O Fitness Gate decide se a versão inteira muda; os oito critérios decidem, mecanismo a mecanismo, o que entra na carapaça nova (`core/exuvia-fitness-criteria.md:70-73`).
- A sobrevivência ao molt exige C-TEST a C-TRACE = SIM e dívida registrada; caso contrário, o mecanismo é refatorado, não-ratificado ou bloqueado até rastrear/auditar (`core/exuvia-fitness-criteria.md:88-96`).
- A ativação real da exúvia continua bloqueada por Fitness Gate no scaffold (`core/hbn-exuvia-scaffold.md:12-14`).
- O mapa de migração define genoma auto-contido: a versão nova deve operar sem ler a pasta antiga em runtime (`docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/02-mapa-migracao-genoma-autocontido.md:15-20`).
- O teste de auto-contenção exige referências relativas, ausência de dependência runtime fora da versão, guards verdes e bateria adversarial transferida (`docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/02-mapa-migracao-genoma-autocontido.md:220-238`).
- A bateria adversarial deve transferir integralmente; esquecer memória imunológica é regressão (`docs/brainstorm/rodada-2026-06-17/analise-pre-transicao/02-mapa-migracao-genoma-autocontido.md:280-286`).

Risco de herança automática: estágio velho vira maquiagem. Um artefato `estavel` em g1 pode depender de path, guard, schema ou topologia que mudou em g2. Se ele entra como `estavel` sem replay de prova, o rótulo deixa de medir prova acumulada real.

Risco de re-prova integral: custo e lentidão. Pode criar burocracia em artefatos que só foram movidos sem mudança semântica. O meio-termo correto é re-prova proporcional:

- se bytes/contrato/dependências mudaram: rodar o gate completo;
- se o artefato foi carregado quase igual: permitir `arvore-revalidacao` append-only que cite a promoção g1, o readback de exúvia e checks g2;
- CRISPR/bateria adversarial migra obrigatoriamente, mas rótulos de maturidade não migram por osmose.

## 4. Over-engineering e subconjunto mínimo

Um dev autônomo razoável recusaria:

- estágio no id;
- front-matter `arvore:` como fonte paralela;
- manifesto autoritativo de estágio corrente;
- renome físico de arquivos por estágio;
- serviço central ou banco de grafo para maturidade;
- índice corrente que não seja regenerável do REGISTRY;
- cross-audit pesado para toda despromoção simples de segurança.

Subconjunto mínimo que eu selaria:

1. REGISTRY continua fonte única (`core/arvores-spec.md:29-37`).
2. Nascimento novo = `fronteira`, salvo evento formal de promoção (`core/arvores-spec.md:22-23`, `guards/assert-arvore-label.sh:130-132`).
3. Promoção = `tipo=arvore-promocao`, append-only, com readback versionado, onda, aprovação humana e cross-audit quando sobe para `intermediaria|estavel` (`core/arvores-spec.md:44-49`, `core/arvores-spec.md:61-63`).
4. Despromoção = novo `tipo=arvore-despromocao`, append-only, com readback/motivo; não exige o mesmo rito pesado da promoção porque reduz claim, mas deve ser rastreável.
5. Resolver corrente = último evento válido por artefato; índice corrente é cache derivado.
6. Exúvia = revalidação explícita por Fitness Gate ou `arvore-revalidacao` com evidência g2; nada de herança silenciosa (`core/exuvia-fitness-criteria.md:88-96`).

Esse é o menor desenho que preserva P6: dá para promover, despromover, reverter por evento novo e reconstruir tudo sem quebrar referências nem inflar maturidade.
