CROSS-AUDIT DE IMPLEMENTAÇÃO — modelo "versão = pasta com o sistema inteiro" (decidido)
Cole em CADA IA independente: Codex, Gemini, Grok e Jules (Jules lê o repositório e produz parecer).
Auditoria de DESENHO/SEGURANÇA da implementação. A FORMA já foi decidida pelo gate humano — NÃO re-litigar a forma; auditar como executá-la com segurança.

IMPORTANTE — incluir no escopo da auditoria o FITNESS GATE (mecanismo de aptidão): a 1ª exúvia real só
ocorre sobre baseline FUNCIONAL e PROVADO (suíte + testes reais + Ponte do Credenciamento), com confronto
incumbente×desafiante; o que estamos pedindo agora é auditar o DESENHO + um DRY-RUN do mecanismo, não a
execução do corte real. Ver `/Users/macbookpro/Projetos/MECANISMO-aptidao-darwinismo-exuvia.md`.

## A forma decidida (não auditar SE, auditar COMO)
Cada versão é UMA pasta que contém o sistema inteiro: `usehbn/versao_1_0_0/` tem tudo (módulos, guards,
ledger, estado, constituição). Na muda nasce `versao_2_0_0/` etc. A IA lê só a pasta vigente; o
exoesqueleto anterior fica congelado (history intacto) com UM documento de transição. Glacier recebe as
mais antigas. Hooks no nível do repo apontam para o runner da versão vigente. Detalhes:
`/Users/macbookpro/Projetos/MODELO-exuvia-versao-contem-sistema-inteiro.md`.

## Leia
- O modelo acima + `.hbn/proposals/20260614-030748-codex-exuvia-plano-v2.md` (plano a revisar)
- `methodology/PRINCIPIOS-CONSTITUCIONAIS.md` (P1, P6, P10); `guards/`; `.git/hooks/`; `guards/lib/common.sh` (como os guards resolvem caminho hoje)

## Responda (foco em segurança da execução; cite arquivo:linha)
1. **Bootstrap da 1ª muda**: sequência segura de commits para mover a forma atual da raiz → `versao_0_3_x/` (congelar) e nascer `versao_1_0_0/`, SEM janela sem enforcement (P10) e SEM perder history (P1). Quais commits, em que ordem, com quais checkpoints?
2. **Hooks + caminho-raiz**: como os hooks (`.git/hooks/`) e o `assert-canonical-root`/`common.sh` passam a resolver a raiz como a pasta da versão vigente, de forma que repontar para `versao_2_0_0/` na próxima muda seja trivial e à prova de erro?
3. **Guards relativos à versão**: os guards hoje assumem caminhos relativos à raiz do repo. O que precisa mudar para operarem relativos à pasta da versão sem falso-positivo/bypass?
4. **Reversibilidade (P6)**: rollback de uma muda que troca a pasta inteira — como garantir retorno limpo (âncora pré-muda + exoesqueleto congelado)?
5. **Glacier + leitura**: como a IA garante que lê só a versão vigente (read-list auto-contida) e como o glacier remove versões antigas sem quebrar o documento de transição.
6. **Riscos não previstos**: o que pode dar errado nesse modelo que o documento não cobriu? (ex.: tamanho do repo, duplicação, hooks órfãos, colisão de token entre versões.)

## Saída
Recomendação por item + sequência de commits proposta para o bootstrap; top 3 riscos; honestidade fonte vs especulação.
Pode gravar em `.hbn/results/<AAAAMMDD-HHMMSS>-<seu-token>-cross-ia-exuvia-impl.md` (com `path:`) OU colar no chat. NÃO commitar além do parecer.
