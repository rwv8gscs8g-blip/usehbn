# Modelo canônico da Exúvia — a versão é uma pasta que contém o sistema inteiro

Decisão do gate humano (2026-06-14). Este é o modelo definitivo; supersede o alvo modular do plano v2.
Documentar é obrigatório: define como o protocolo evolui, lê e se conserva.

## 1. A forma
O **exoesqueleto** É a pasta da versão. Ela contém o **sistema inteiro e seu funcionamento completo**
daquela versão — todos os módulos (bastão/orquestração, fagocitose, radar, governança, guards, runtime,
livro-razão, estado, constituição). Tudo o que ocorre na versão fica na versão e evolui na versão.

```
Projeto/usehbn/
  versao_0_3_x/      ← exoesqueleto anterior (congelado, history intacto)
  versao_1_0_0/      ← versão vigente: o SISTEMA INTEIRO desta versão
  EXUVIAS.md         ← índice de versões + ponteiros
  (.git/, hooks no nível do repo — ver §5)
```
Na próxima muda nasce `versao_2_0_0/` com tudo; depois `versao_3_0_0/`; etc. Cada versão pode ter um
número diferente de módulos (5 → 30 → 3): **a estrutura muda livremente a cada muda.**

## 2. Leitura otimizada (a IA lê só a versão vigente)
A IA nova lê **apenas** `versao_X_Y_Z/` vigente — auto-contida. Só lê uma pasta anterior se for
explicitamente chamada para isso (consulta ao passado). Não há arqueologia de tags nem leitura de
dezenas de versões. Resultado: pasta pequena → **carregável inteira no contexto/memória**, leitura
rápida, barreira de entrada mínima. As **validações continuam sendo feitas a partir do disco** (guards),
unindo velocidade de decisão e segurança de persistência.

## 3. Darwinismo (o motor da lapidação)
Cada exúvia consolida **só as lições mais aptas e testadas**: os exemplos, códigos e subsistemas que
melhor resolvem os problemas sobrevivem para a versão nova; o menos apto é deixado no exoesqueleto
anterior (ou vai ao glacier). Repetido em **ciclos de autoaperfeiçoamento**, isso vira o modelo de
ponderação do que é importante — a IA aprende o que vale carregar. A consulta ao passado, quando
necessária, explica **por que** cada decisão foi tomada. Glacier recebe a maior parte das versões
antigas, mantendo a versão viva enxuta e lapidada.

## 4. Continuidade sem reescrever links (a ponte da muda)
Os documentos do exoesqueleto abandonado **mantêm seu histórico — não se reescrevem os links internos**.
A muda gera **um único documento de transição** (o documento da exúvia / "de-onde-para-onde"): ele, e
só ele, registra que "a pasta/conteúdo que estava em X agora está em `versao_X/...`" (e o que mais for
necessário). Isso preserva auditabilidade (P1) sem o custo de reescrever tudo.

## 5. Mecânica (para a implementação não se perder)
- **Hooks no nível do repo** (`usehbn/.git/hooks/`) são shims finos que apontam para o runner da
  **versão vigente** (`versao_1_0_0/guards/...`). Na muda, repontam para a nova versão. Mudança pequena e contida.
- **Guards operam relativos à pasta da versão**: a `versao_X_Y_Z/` é a "raiz canônica" daquela versão
  (o `assert-canonical-root` passa a reconhecer a pasta da versão vigente).
- **Bastão/token** vive em `.git/` (nível do repo, compartilhado entre versões) — não duplica por versão.
- **Glacier**: versões antigas além de N descem ao arquivo frio (fora do repo ativo, ou em
  `glacier/`/fork separado quando publicar no GitHub).

## 6. A 1ª exúvia é um BOOTSTRAP especial
Hoje o sistema está na raiz (forma 0.3.x), ainda não sob pasta de versão. A 1ª muda:
1. congela a forma atual como `versao_0_3_x/` (history intacto, + o documento de transição);
2. nasce `versao_1_0_0/` com o carry-forward lapidado (a estrutura simplificada, renumerada);
3. reaponta os hooks para `versao_1_0_0/`; cria o `EXUVIAS.md`.
Isso "dá problema" só na primeira (porque hoje tudo está na raiz). A partir dela, **a lógica de pastas
de versão já nasce pronta** para as próximas mudas serem limpas e mecânicas.

## 7. Por que isto importa (resumo)
Velocidade (pasta pequena, carregável) + segurança (validação no disco) + evolução livre (estrutura
muda a cada versão) + auditabilidade (exoesqueletos congelados + 1 doc de transição) + lapidação
darwiniana (só o mais apto sobrevive) — sem que a IA precise carregar a história inteira para operar.
A parte dura que persiste por todas as exúvias: os princípios P1–P13 e os invariantes (isolamento,
cross-family, gate humano, auditabilidade, reversibilidade).
