# HBN Phagocytosis — Doutrina de Incorporacao Progressiva de Tecnologia

> Como o HBN absorve uma tecnologia ao longo do tempo, sob controle humano,
> sem prometer dominio antes dele existir.

## Por que esta doutrina existe

O HBN tem uma visao publica forte: tornar-se uma "chave inglesa
multiversatil" capaz de operar com qualquer tecnologia (legada ou moderna)
sem regressao e com risco controlado. Essa visao e ambiciosa o bastante para
gerar promessa em excesso. Para evitar isso, HBN define um caminho de
incorporacao explicito, em estagios, com artefatos verificaveis em cada
estagio.

A metafora **fagocitose** (do grego *phagein*, comer; *kytos*, celula) descreve
o mecanismo biologico em que uma celula engloba uma particula ou organismo
externo, o digere internamente e incorpora o conteudo util para sua propria
funcao. HBN adota esse vocabulario porque captura tres ideias-chave:

1. A incorporacao e progressiva — nao instantanea.
2. O conteudo e digerido — nao apenas acoplado.
3. O resultado e que a celula passa a operar com aquele conhecimento como se
   fosse seu — sem deixar de ser ela mesma.

## Tres regras invariantes

A fagocitose de qualquer tecnologia no HBN obedece a tres regras nao-
negociaveis:

1. **Honestidade de estagio.** O HBN nunca afirma estagio mais avancado do que
   o codigo e a documentacao verificavel sustentam. O estado de fagocitose de
   cada tecnologia e visivel em `docs/MATURITY-MATRIX.md` e em
   `.hbn/knowledge/by-tech/<tecnologia>.md`.
2. **Controle humano em cada transicao.** Avancar de um estagio para o
   proximo e ato registrado: PR + Hearback humano. Nao ha promocao silenciosa.
3. **Reversibilidade.** Em qualquer estagio, e possivel desfazer a integracao
   removendo os artefatos correspondentes daquela tecnologia, sem afetar o
   nucleo do HBN nem outras tecnologias.

## Os cinco estagios da fagocitose

```
routed → studied → digested → mastered → contributed
```

### Estagio 1 — Routed (roteado)

**Definicao.** O HBN reconhece a tecnologia como alvo possivel atraves do
Universal Translator: detecta a tecnologia (ex.: presenca de `package.json`,
`pom.xml`, `.cbl`, `.bas`, `.swift`, etc.) e direciona a execucao para o
runtime adapter ou connector apropriado, sem nenhum conhecimento profundo
sobre como aquela tecnologia se comporta.

**Artefatos minimos.**
- Entrada em `src/usehbn/connectors/catalog.py` com `connector_id`,
  `target_technology_id` e `delivery_languages`.
- Entrada em `src/usehbn/connectors/profiles.py` para deteccao da tecnologia.
- Linha na tabela `docs/MATURITY-MATRIX.md` marcando o estado.

**O que NAO existe ainda.** Conhecimento sobre erros frequentes, padroes
seguros, gotchas, formatos preferidos para entregar codigo.

**Estado equivalente.** `Scaffold` (em `MATURITY-MATRIX`).

### Estagio 2 — Studied (estudado)

**Definicao.** Existem documentos canonicos sobre a tecnologia em
`.hbn/knowledge/by-tech/<tecnologia>.md` e `docs/<TECNOLOGIA>.md` cobrindo:

- O que a tecnologia e e onde se aplica (neutralidade descritiva).
- Erros frequentes e gotchas conhecidos da comunidade.
- Padroes seguros para gerar codigo nessa tecnologia.
- Formato preferido para entregar bridges (delivery language, coupling mode).
- Tipos de tarefa onde HBN agrega valor versus onde nao agrega.

**Artefatos minimos.**
- `.hbn/knowledge/by-tech/<tecnologia>.md`.
- `docs/<TECNOLOGIA>.md` (documentacao publica neutra).
- Referencias externas verificaveis (links de docs oficiais ou padroes).

**O que NAO existe ainda.** Geracao executavel; verificacao automatizada.

**Estado equivalente.** `Scaffold` (com base de conhecimento associada).

### Estagio 3 — Digested (digerido)

**Definicao.** Os erros frequentes e padroes da tecnologia foram codificados
como regras consultaveis pelo HBN durante a execucao. O Truth Barrier e o
Guardian podem citar regras especificas daquela tecnologia. O Readback exige
invariantes da tecnologia explicitamente.

**Artefatos minimos.**
- `src/usehbn/connectors/<tecnologia>/rules.py` com regras testaveis.
- Testes em `tests/connectors/test_<tecnologia>_rules.py`.
- Lista de regras citaveis em `docs/<TECNOLOGIA>.md`.
- Conexao com Truth Barrier/Guardian: cada regra retorna warning identificavel.

**O que NAO existe ainda.** Bridge executavel; geracao automatica de codigo
da tecnologia.

**Estado equivalente.** `Parcial` (com regras testadas).

### Estagio 4 — Mastered (dominado)

**Definicao.** O HBN gera bridges executaveis na tecnologia: codigo, modulos,
configuracoes, testes minimos. A geracao passa por verificacao automatica
(parse/compile do output). O Connector Lifecycle pode atingir
`verified` e `active` para essa tecnologia.

**Artefatos minimos.**
- `BridgeContributor` (interface canonica, definida em onda futura) para a
  tecnologia.
- Geracao testada produzindo arquivos sintaticamente validos.
- Verify automatico: parse/compile passa.
- Documentacao mostrando exemplo end-to-end.

**O que NAO existe ainda.** Comunidade externa contribuindo extensoes
independentes.

**Estado equivalente.** `Implementado` (para aquela tecnologia).

### Estagio 5 — Contributed (contribuido)

**Definicao.** A tecnologia tem extensao independente do core: pacote
separado (ex.: `usehbn-bridge-vba`), mantenedor especialista, comunidade
ativa, releases proprias. O core do HBN apenas conhece a interface. A
tecnologia "anda sozinha" sob a doutrina HBN.

**Artefatos minimos.**
- Pacote externo publicado.
- Mantenedor declarado.
- Politica de versao independente, mas compativel com `protocol_version` do HBN.

**Estado equivalente.** `Implementado` + `Externalizado`.

## Mapa estagio x maturidade

| Estagio | MATURITY-MATRIX | Universal Translator faz hoje |
|---|---|---|
| **Routed** | Scaffold | Detecta + roteia |
| **Studied** | Scaffold + knowledge | Detecta + roteia + cita docs |
| **Digested** | Parcial | Detecta + roteia + valida regras |
| **Mastered** | Implementado | Detecta + roteia + valida + gera + verifica |
| **Contributed** | Implementado externalizado | Idem, via pacote externo |

## Interacao com termos doutrinarios existentes

A fagocitose nao substitui nenhum conceito doutrinario. Ela compoe com eles:

- **Readback.** Em estagios `Digested` e adiante, o readback inclui
  invariantes especificas da tecnologia (ex.: "Excel/VBA: nenhum modulo
  protegido sera importado").
- **Truth Barrier.** Cada regra digerida emite warning citavel em texto
  natural ("VBA: macros sem assinatura nao devem ser instaladas
  silenciosamente").
- **Guardian.** Em `mastered`, Guardian pode bloquear (sob `--enforce`)
  outputs que violem regras canonizadas.
- **ERP.** O `evidence` de cada execucao em uma tecnologia digerida deve citar
  qual regra foi seguida ou violada.
- **Universal Translator.** E a porta de entrada para todos os estagios. Em
  `Routed`, e roteador puro. Em `Mastered`, e gerador verificavel. Em
  `Contributed`, e dispatcher para pacotes externos.

## Relacao com EVOLUTION-POLICY

`docs/EVOLUTION-POLICY.md` ja define tres categorias de absorcao de protocolos
externos:

- **A** — Adopted as integration (manter externo, documentar composicao).
- **B** — Absorbed as protocol concept (concept entra no core).
- **C** — Rejected with rationale.

Phagocytosis e a especializacao da Categoria B aplicada a **tecnologias**
(linguagens, runtimes, plataformas), nao a **protocolos** (Diataxis, llms.txt,
AGENTS.md, Glasswing). Os dois caminhos coexistem.

| Tipo de absorcao | Documento | Categoria EVOLUTION-POLICY |
|---|---|---|
| Protocolo externo | `docs/INTEGRATION-<NOME>.md` | A ou B |
| Tecnologia / linguagem | `docs/<TECNOLOGIA>.md` + `.hbn/knowledge/by-tech/<tecnologia>.md` | B (via Phagocytosis) |
| Standard rejeitado | `docs/REJECTED-<NOME>.md` | C |

## Como abrir uma fagocitose

1. Crie issue `[phago] propose <tecnologia> <estagio-alvo>`.
2. Liste os artefatos do estagio que sera atingido (consultar tabela acima).
3. Espere triagem do mantenedor.
4. Aprovado: abra PR seguindo `agents/wave-protocol.md`.
5. Cada PR atinge UM estagio. Saltar estagios nao e permitido.
6. PR cita evidencia, atualiza `docs/MATURITY-MATRIX.md` e adiciona o registro
   em `.hbn/knowledge/by-tech/<tecnologia>.md`.

## Limites duros (nao-negociaveis)

A doutrina de Phagocytosis NAO permite:

- Avancar estagios sem PR e sem Hearback humano.
- Afirmar capacidade que pertenca a estagio mais avancado do que o atual.
- Acoplar HBN a um vendor unico para uma tecnologia.
- Substituir Readback por inferencia automatica baseada em "conhecimento
  digerido".
- Telemetria sobre uso da tecnologia para "aprendizado automatico".

Se uma proposta exige qualquer um dos itens acima, ela nao e Phagocytosis: e
escopo fora do HBN.

## Onde Phagocytosis vive

| Aspecto | Local |
|---|---|
| Doutrina | Este arquivo (`docs/PHAGOCYTOSIS.md`) |
| Conhecimento por tecnologia | `.hbn/knowledge/by-tech/<tecnologia>.md` |
| Documentacao publica por tecnologia | `docs/<TECNOLOGIA>.md` |
| Detecao | `src/usehbn/connectors/profiles.py` |
| Roteamento | `src/usehbn/translation/universal.py` + `src/usehbn/connectors/resolver.py` |
| Regras digeridas | `src/usehbn/connectors/<tecnologia>/rules.py` (apos `Digested`) |
| Geracao | `src/usehbn/bridge/<tecnologia>.py` ou pacote externo (apos `Mastered`) |
| Estado canonico | `docs/MATURITY-MATRIX.md` |

## Mensagem para contribuidores

Se voce e especialista em uma tecnologia (VBA, COBOL, Pascal, Lua, Swift, C,
C++, C#, Java, Python, ou qualquer outra), o caminho aqui e claro:

1. Comece pelo estagio `Studied` para a sua tecnologia. Documente o que voce
   sabe que da errado nela.
2. Avance para `Digested` codificando as regras como testes.
3. Mestrar (`Mastered`) e contribuir (`Contributed`) sao consequencias
   naturais quando ha base solida nos primeiros estagios.

HBN nao quer dominar todas as tecnologias sozinho. HBN quer ser o protocolo
que torna seguro outras pessoas dominarem suas tecnologias com IA, sem
regressao e sob controle humano.
