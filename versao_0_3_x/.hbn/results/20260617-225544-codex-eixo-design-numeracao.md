SOU: OpenAI · GPT-5 Codex · apelido: codex-eixo · papel auditor

# Parecer de design: numeração federada useHBN

## Leitura de disco

Li no disco:

- `docs/brainstorm/rodada-2026-06-17/NUMERACAO-design-brief-e-validacao.md`
- `docs/brainstorm/rodada-2026-06-17/NUMERACAO-analise-fronteira-opus.md`

O brief pede um esquema global, aberto, federado, sem autoridade central, legível, parseável, agnóstico, sequencial, estável através de exúvias e simples. A arte prévia aponta a convergência industrial para "namespace federado + esquema local legível". A análise de fronteira do Opus acrescenta o ponto mais importante: identidade do adotante, sequência local e verificação de integridade são eixos diferentes.

## Recomendação

Recomendo o candidato **E, B-mínimo**, com um ajuste de redação normativa: o identificador primário deve identificar a **coordenada lógica** do evento/passagem no protocolo; a prova de bytes deve ser um **pin opcional** por `git sha + path`.

Forma mínima:

```text
cNN.wMM-slug
```

Forma completa cross-system:

```text
<namespace>:gN.cNN.wMM-slug
```

Forma pinada para integridade:

```text
<namespace>@<git-sha>:<path-or-local-id>
```

Exemplos exatos:

```text
c02.w03-auth-screen
github.com/usehbn/credenciamento:g1.c02.w03-auth-screen
github.com/usehbn/credenciamento@0123456789abcdef0123456789abcdef01234567:g1.c02.w03-auth-screen
github.com/usehbn/credenciamento@0123456789abcdef0123456789abcdef01234567:.hbn/results/20260617-225544-codex-eixo-design-numeracao.md
```

Eu não recomendo C como formato padrão. C resolve um problema real, mas embute verificação em todo ID. Isso torna o identificador mais pesado, menos escaneável e mais frágil a mudanças legítimas de metadados. O ganho de C deve existir como modo pinado obrigatório apenas quando o artefato é usado como evidência externa, importação federada ou referência normativa sensível.

## Avaliação de A/B/C/D/E

**A. `g1.c01.w03-slug`**  
Bom núcleo local. É legível, sequencial e simples dentro de um sistema. Falha como protocolo federado porque dois adotantes independentes podem produzir o mesmo `g1.c01.w03-slug`. Eu não descartaria A; eu o trataria como o miolo local de E.

**B. `<ns>:g1.c01.w03-slug`**  
É a direção correta. O namespace resolve a colisão entre adotantes, e a regra "implícito dentro do repo, explícito ao cruzar fronteira" reduz fricção. A fraqueza de B, se mal escrita, é parecer que o namespace deve aparecer em todo lugar. Para P11, ele deve ser declarado uma vez no manifesto do adotante e omitido nos IDs locais.

**C. B + ULID/hash anexo**  
Seguro, mas pesado como padrão. O hash em todo ID garante que uma string copiada carrega também uma prova de conteúdo, o que é útil em ambientes hostis, espelhos, arquivos offline ou quando há risco de namespace takeover. Porém duplica uma capacidade que o git já fornece, encurta pouco a investigação humana, e mistura identidade lógica com integridade de bytes. Se uma correção editorial legítima muda o hash, C força a troca do ID ou cria uma distinção que o humano não queria fazer.

**D. Só ULID/hash**  
Serve para storage e prova, não para governança humana. Perde sequência legível e não mostra progressão de ciclos/ondas. Como identificador primário, vai contra requisitos centrais do brief.

**E. B-mínimo**  
Melhor equilíbrio. Mantém o núcleo legível de A, adiciona namespace de B apenas quando necessário, e usa SHA do git como verificação separada. O risco de E é disciplinar: se a cultura não souber quando pin deve ser obrigatório, referências importantes podem circular sem prova de bytes. Esse risco é menor que obrigar C em tudo, desde que a regra de pin seja explícita.

## Respostas às 6 perguntas

### 1. Esquema mais adequado e simples

Eu escolheria **E (B-mínimo)**.

O requisito que A não satisfaz é colisão entre adotantes. B resolve isso com namespace, mas pode ficar verboso. C aumenta segurança, mas cobra complexidade em todos os usos. D é simples para máquina e ruim para humanos.

E preserva as propriedades úteis:

- local: `c02.w03-auth-screen`
- cross-system: `github.com/usehbn/credenciamento:g1.c02.w03-auth-screen`
- pin de integridade: `github.com/usehbn/credenciamento@0123456789abcdef0123456789abcdef01234567:g1.c02.w03-auth-screen`

Minha ressalva: E só funciona bem se o protocolo disser claramente que o ID lógico não prova bytes. Quando a pergunta for "qual é exatamente o artefato?", a referência deve ser `namespace@sha:path`.

### 2. Namespace e colisão sem autoridade central

O namespace padrão deve ser a **URL canônica do repositório sem esquema**, por exemplo:

```text
github.com/usehbn/credenciamento
gitlab.com/org/projeto
codeberg.org/user/repo
```

Reverse-DNS também deve ser aceito para quem possui domínio:

```text
br.gov.exemplo.sistema
com.empresa.produto
```

Eu não usaria handle livre como namespace primário. Handles colidem entre plataformas, podem ser reaproveitados e não carregam uma cadeia de delegação clara. Também não usaria hash como namespace humano primário, porque resolve colisão ao custo de opacidade.

A estratégia de colisão sem autoridade central do useHBN é pegar carona numa autoridade externa já distribuída: DNS ou host git. Isso não é ausência total de autoridade no mundo; é ausência de um **registro central do useHBN**. Essa distinção importa. Domínios expiram, repositórios mudam de dono, hosts somem. Para reduzir esse risco, o manifesto do adotante deve registrar:

```text
namespace: github.com/usehbn/credenciamento
namespace_since: 2026-06-17
namespace_evidence: <commit/tag inicial que declarou o namespace>
```

Esse manifesto não precisa criar registro central; só torna auditável quando aquele sistema começou a usar aquele nome.

### 3. Genoma/exúvia

`gN` deve ser local ao namespace. O `g2` de `github.com/a/sistema` não tem relação com o `g2` de `github.com/b/sistema`.

Regra proposta:

- `g1` é implícito dentro do repo enquanto não houver exúvia.
- Após a primeira exúvia, referências cross-exúvia e cross-system devem explicitar `gN`.
- Exúvia incrementa genoma: `g1` -> `g2` -> `g3`.
- Genomas antigos ficam read-only; não se reescrevem IDs legados.
- Cada genoma novo declara predecessor e documento de transição.

Exemplo:

```text
c02.w03-auth-screen                         # local, genoma atual implícito
g1.c02.w03-auth-screen                      # local, explícito por ser legado/cross-exúvia
github.com/usehbn/credenciamento:g2.c01.w01-exuvia-start
```

Para rastreabilidade, o importante não é colocar mais dados no ID; é manter um arquivo de transição parseável que diga: este `g2` deriva de `g1`, nesta data, por estes commits, com estas regras de congelamento. O ID só precisa carregar a coordenada.

### 4. Artefatos federados

Eu separaria dois tipos de referência:

**Referência lógica**, quando se fala de uma onda, decisão, readback ou knowledge como item do protocolo:

```text
github.com/usehbn/credenciamento:g1.c02.w03-auth-screen
github.com/usehbn/commons:g1.k0007-p11-minimo
```

**Referência de evidência**, quando se precisa dos bytes exatos de um parecer, arquivo ou registro:

```text
github.com/usehbn/credenciamento@0123456789abcdef0123456789abcdef01234567:.hbn/results/20260617-225544-codex-eixo-design-numeracao.md
```

Isso evita inventar uma árvore global para knowledge compartilhado. Um commons federado é apenas outro namespace, por exemplo `github.com/usehbn/commons`. Se outro sistema importar esse knowledge, ele referencia o namespace de origem ou registra um mirror pinado por SHA.

Para pareceres e readbacks, eu não forçaria um ID universal no nome do arquivo além do padrão local já usado. O front matter ou cabeçalho pode carregar `id`, `kind`, `agent`, `namespace` e `genome`; o endereço verificável continua sendo `namespace@sha:path`.

### 5. Migração do REGISTRY antigo `00NN`

O risco é administrável se a coexistência for explícita:

- `00NN` fica read-only.
- O parser novo aceita `00NN` apenas em modo legado.
- IDs antigos não são renumerados.
- Novos itens nascem no esquema novo.
- Referências novas a itens antigos usam `legacy:00NN` ou caminho pinado, não uma tradução fingida.

Exemplo aceitável:

```text
legacy:0049
github.com/usehbn/usehbn@0123456789abcdef0123456789abcdef01234567:.hbn/results/0049-algum-registro.md
```

O atrito real é operacional: ferramentas e humanos conviverão por algum tempo com dois formatos. Isso é menos custoso que migrar histórico e quebrar confiança no livro-razão. A recomendação é documentar que `00NN` é uma camada arqueológica, não o futuro.

### 6. Leveza P11 e subconjunto mínimo

O subconjunto que deve servir 90% dos adotantes:

```text
namespace: github.com/<owner>/<repo>   # declarado uma vez
id local: cNN.wMM-slug                 # usado no dia a dia
genoma: g1 implícito                   # até a primeira exúvia
pin: <namespace>@<sha>:<path>          # só quando precisar provar bytes
```

Maquinaria que eu removeria do caminho feliz:

- ULID/hash obrigatório em todo ID.
- Namespace repetido em cada arquivo interno.
- Domínio próprio obrigatório.
- Registro central de namespaces.
- `gN` obrigatório antes de existir exúvia.
- Taxonomia global rígida para todo tipo de artefato.
- Um parser que tente inferir significado sem manifesto local.

O mínimo normativo deveria caber em poucas regras:

1. Todo sistema declara um namespace canônico.
2. Todo passo novo usa `cNN.wMM-slug`.
3. Toda exúvia incrementa `gN` e congela o genoma anterior.
4. Toda referência cross-system usa `<namespace>:<id>`.
5. Toda referência probatória usa `<namespace>@<sha>:<path>`.

## Ataque direto ao candidato E

E perde uma garantia que C entrega: em C, qualquer ID completo carregado para fora do repo já pode ser validado contra conteúdo, sem depender de o emissor lembrar de adicionar um pin. Isso é forte para auditoria adversarial e para pacotes copiados fora de contexto.

Também há um risco de drift: se `github.com/usehbn/credenciamento:g1.c02.w03-auth-screen` aponta para uma entidade lógica, diferentes clones ou tempos podem resolver para bytes diferentes se não houver disciplina de congelamento. C evita essa ambiguidade por construção.

Mesmo assim, eu não escolheria C como padrão porque essa garantia é necessária em menos casos que a identidade lógica. Em governança via git, o SHA já é o mecanismo canônico de conteúdo. Embutir hash no ID primário transforma cada referência humana numa referência probatória, e isso tende a gerar:

- IDs longos demais para leitura e conversa.
- Fragilidade em pequenas correções de texto/metadado.
- Dúvida sobre qual hash usar quando o artefato é composto por vários arquivos.
- Custo futuro se o algoritmo de hash mudar.
- Duplicação entre "id do protocolo" e "endereço do git".

Minha proposta é tornar o pin obrigatório por situação, não por forma universal:

- obrigatório para importação federada normativa;
- obrigatório para parecer usado como evidência;
- obrigatório para mirror/arquivo offline;
- opcional para navegação local, brainstorming e rascunhos.

Assim E não nega a verificação; ele a desloca para o lugar em que ela é semanticamente correta.

## Parecer final

Adotaria **E (B-mínimo)** como base da exúvia:

```text
local:        c02.w03-auth-screen
cross:        github.com/usehbn/credenciamento:g1.c02.w03-auth-screen
evidência:    github.com/usehbn/credenciamento@0123456789abcdef0123456789abcdef01234567:.hbn/results/20260617-225544-codex-eixo-design-numeracao.md
```

O desenho é simples porque não tenta fazer um único ID carregar tudo. Namespace responde "de quem é"; sequência responde "onde está no fio"; genoma responde "em qual muda"; SHA/path responde "quais bytes". Essa separação parece a menor superfície que ainda atende ao brief sem criar um registro central ou um identificador opaco como linguagem principal.
