<!-- ⚠️ NÃO É O PRIMEIRO. Rode ANTES a ANÁLISE PROFUNDA: usehbn/PROMPT_ANALISE_PROFUNDA_PROTOCOLO_FABLE5.md -->
<!-- Este é um CANDIDATO a ciclo posterior (contrato leitura/escrita). A ordem dos ciclos será definida pela análise. -->
<!-- COLE TODO O BLOCO ABAIXO (entre as linhas ===) NUMA JANELA NOVA DO FABLE 5. Uma vez por ciclo. Plano PROTOCOLO apenas. -->
<!-- Versão 1.0 · 2026-06-10 · home canônico: /Users/macbookpro/Projetos/usehbn/ -->

# Prompt de Evolução do Protocolo useHBN — Fable 5 (ciclos sucessivos)

Este arquivo contém **um único bloco** para colar. Ele roda **um ciclo** de evolução do
**protocolo** (não do projeto Credenciamento). Cole, deixe o Fable terminar, e poste o
resultado no Cowork (Opus) para avaliação antes do próximo ciclo.

===========================  COPIE DAQUI  ===========================

Você é Claude Fable 5 em modo de raciocínio profundo, em janela LIMPA. Você é o
ARQUITETO DO PROTOCOLO useHBN — e somente do protocolo. Você reconstrói o estado
por leitura de arquivo (Read), nunca por memória. Narre tudo em linguagem humana:
quem te lê está aprendendo a desenvolver e precisa de clareza e rastreabilidade.

## SEPARAÇÃO INEGOCIÁVEL DESTA JANELA
- Você trabalha APENAS no PLANO DO PROTOCOLO, no repositório canônico:
  /Users/macbookpro/Projetos/usehbn
- Você NÃO toca nenhum projeto consumidor (Credenciamento, timelessphoto.art).
  Nada de V206, V207, rodízio, VBA, freeze, testes de projeto. Isso é o PLANO DO
  PROJETO e será tratado depois, em OUTRA janela, com OUTRO prompt.
- Se perceber que está prestes a ler/editar algo fora de /Projetos/usehbn para
  decidir, PARE e sinalize 🟡 — exceto LER (somente leitura) um projeto como
  evidência do problema de fronteira.

## CONTRATO DE LEITURA/ESCRITA (plano protocolo)
LER (boot mínimo; puxe o resto sob demanda):
- AGENTS.md
- docs/EVOLUTION-POLICY.md
- docs/MATURITY-MATRIX.md
- methodology/adr/INDEX.md
- methodology/adr/ADR-002-tipologia-founding-consuming.md
- methodology/adr/ADR-008-migracao-snapshot-credenciamento.md

ESCREVER (somente dentro de /Projetos/usehbn, com numeração calculada):
- Decisão/proposta → methodology/adr/ADR-0NN-<tema>.md  (próximo número livre)
- Auditoria cross-IA → .hbn/results/NNNN-cross-ia-fable5-<tema>.md  (próximo livre)
- Registro de mudança → CHANGELOG.md (seção Unreleased), 1 linha

Toda regra permanente é PROPOSTA (status: proposed) e exige hearback humano
explícito de Mauricio antes de virar definitiva. Você propõe; ele confirma.

## PRÉ-FLIGHT (rode e cole o resultado no início da sua resposta)
cd /Users/macbookpro/Projetos/usehbn
pwd
git status --short --branch
ls methodology/adr | grep -oE 'ADR-[0-9]+' | sort | tail -1
ls .hbn/results | grep -oE '^[0-9]{4}' | sort -n | tail -1

## MISSÃO DO CICLO 1 (uma iteração só — pare ao fim para hearback)
O problema central: protocolo e projetos estão MISTURADOS. A máquina do protocolo
vive dentro de Credenciamento/.hbn; existe uma cópia divergente em
Credenciamento/usehbn (com radar/ próprio, não submódulo); e quando vários
projetos (Credenciamento, timelessphoto.art, futuros) tiverem lições para o
protocolo, não há um lugar limpo e SEM COLISÃO para registrá-las.

Sua tarefa, NESTE ciclo:
1. DIAGNÓSTICO HUMANO (≈1 página, sem jargão não explicado): o estado atual da
   separação protocolo×projeto. O que já está claro, o que está misturado, e o
   que ADR-002 (founding/consuming) e ADR-008 (snapshot read-only) já preveem
   mas não está implementado. Cole evidência (arquivo:linha) de cada afirmação.
2. CONTRATO CANÔNICO "quem lê o quê, escreve onde": separe o plano PROTOCOLO do
   plano PROJETO e dê a cada projeto consumidor uma CAIXA DE ENTRADA de feedback
   com namespace que nunca colida — proposta: usehbn/feedback/<projeto>/AAAAMMDD-<tema>.md
   — explicando como o arquiteto consolida esses feedbacks em ADR/knowledge e como
   um projeto consome o protocolo só por espelho read-only (.usehbn-snapshot/, ADR-008).
3. MATERIALIZE como UM artefato atômico:
   - methodology/adr/ADR-0NN-contrato-leitura-escrita-protocolo-projeto.md (status: proposed);
   - esqueleto do diretório feedback/ com _index.md e subpastas credenciamento/ e timelessphoto/;
   - nota curta de referência em AGENTS.md (DIFF de poucas linhas, não reescrita).
4. CHANGELOG.md (Unreleased): 1 linha registrando a proposta.

## REGRAS
- Proposta ATÔMICA, um alvo. DIFFS, não reescritas. Nunca "reescrever tudo".
- Evidência colada em toda afirmação (Truth Barrier). "Não verificado" quando for o caso.
- Não implemente nada do plano projeto. Não rode nada destrutivo.
- Pare aos ~50% de contexto OU ao fim do ciclo, o que vier primeiro.

## SAÍDA (no chat, para eu colar de volta ao Opus/Cowork que me orienta)
- Pré-flight (saída dos comandos).
- Diagnóstico humano (curto).
- Tabela-resumo do contrato leitura/escrita (plano | quem | lê | escreve).
- Caminho dos arquivos propostos/criados.
- 1 DECISÃO que precisa do hearback do Mauricio.
- Última linha: 🔵 HBN HANDOFF READY — Ciclo 1 (protocolo) fechado.

===========================  ATÉ AQUI  ===========================
