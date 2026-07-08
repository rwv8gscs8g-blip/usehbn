---
titulo: 01 - Prompt-Retomada Codex V204 — rollback MICRO49 → MICRO48
diataxis: how-to
hbn-track: safe_track
hbn-status: active
audiencia: codex (consumir) + operador (mediar)
versao-protocolo: useHBN pre-v1
data: 2026-05-09
autor: Claude Opus 4.7 (Cowork) — chat arquiteto-mestre useHBN
relacionado:
  - Credenciamento doc 68 (pausa MICRO49)
  - parecer Codex RCA MICRO49 (entregue 2026-05-09 via operador)
  - useHBN bootstrap 00_BOOTSTRAP_PROTOCOLO_2026_05_09.md (MD-D)
status: congelado
temperatura: glacier
---

# 01. Prompt-Retomada Codex — rollback MICRO49 → MICRO48

> Este e o entregavel do MD-D do plano §5 do bootstrap. Operador copia
> o bloco entre `===` para a sessao Codex CLI que esta com bastao F1
> (Credenciamento V12.0.0204). Bloco e self-contained — Codex nao
> precisa ler este preambulo.

## Contexto deste documento (apenas para operador)

Em 2026-05-09, Codex CLI (sessao RCA) entregou parecer:

- **Causa provavel** (texto Codex): "nao ha evidencia forte de defeito
  textual remanescente no MICRO49-fix2; o pacote atual parece reduzido
  a comentario em `Svc_Rodizio` + bump de `App_Release`. Mas ha um
  bloqueio objetivo: `App_Release.bas` diverge entre `src/vba` e
  `local-ai/vba_import`, e `glasswing-checks.sh G7` falha. Isso invalida
  o pacote como base de novo import."
- **Evidencias principais** (texto Codex): Svc_Rodizio.bas/
  Teste_V2_Engine.bas/Teste_V2_Roteiros.bas com hash igual fonte↔espelho;
  App_Release.bas com divergencia no carimbo + linha final extra no
  espelho; CRLF preservado nos 8 arquivos; sem controle invisivel;
  `Attribute VB_Name` apenas no topo dos 4 modulos; `SelecionarEmpresaComEfeitos`,
  `SMK_008` e `TV2_DtUltimaIndicacaoCred` nao existem mais em `src/vba`
  nem no pacote importavel — so em docs/readbacks/manifests historicos.
- **Decisivo**: apos recovery, `?GetBuildImportado` retornou
  `f7aa84f+ONDA24.MD24.3-avaliacao-dual-counter`. Smoke/Sexteto
  posteriores validam MICRO48, NAO MICRO49.

**Decisao recomendada Codex**: rollback formal para MICRO48 + deferir
MD-24.4. Nao MICRO49-fix3 — fix2 ja virou quase documental, mas passou
por crash/build stale e deixou G7 violado. Ganho de MD-24.4 nao
justifica carregar esse risco para MICRO50/RC.

**Ratificacao Opus chat-novo**: concordo. P10 (Seguranca + nao-regressao
> velocidade) e P6 (Toda evolucao deve ser reversivel) sustentam a
escolha. ADRs em flight (002 tipologia, 003 topologia, 004 SemVer, 008
migracao) sao citados pelo prompt abaixo no campo "integracoes
sistemicas".

## Bloco copiavel para sessao Codex CLI

```text
=================== INICIO PROMPT-RETOMADA-CODEX-V204 ===================

Codex CLI — pausa operacional MICRO49 concluida com parecer RCA aceito.
Voce pode retomar a esteira V12.0.0204 do Credenciamento em
/Users/macbookpro/Projetos/Credenciamento.

Primeira linha obrigatoria:
✅ HBN ACTIVE — Codex CLI, Frente 1 Credenciamento, 2026-05-09 (V204 /
Onda 24 retomada — rollback MICRO49 → MICRO48 ratificado).

## Decisao operacional ratificada (operador + Opus arquiteto useHBN)

Seu parecer foi aceito integralmente:

1. ROLLBACK FORMAL para MICRO48 / MD-24.3 (build
   `f7aa84f+ONDA24.MD24.3-avaliacao-dual-counter`).
2. MD-24.4 (selecionar com efeitos) FICA DEFERIDO. Nao reabra MICRO49-fix3
   — fix2 ja virou quase documental mas carrega o crash do compile +
   G7 violado. O ganho de MD-24.4 nao justifica esse risco para MICRO50
   nem para o RC futuro.
3. Esteira segue para MICRO50 a partir de MICRO48 como base limpa.

## Por que Opus arquiteto useHBN ratifica

Pelos principios constitucionais do useHBN
(`Credenciamento/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md`):

- P10 (Seguranca + nao-regressao > velocidade): G7 violado bloqueia
  fechamento de onda; rollback restitui gate verde.
- P6 (Toda evolucao deve ser reversivel): rollback e o caminho explicito
  e exercitado de reverter MICRO49.
- P3 (Testar antes de refatorar): MICRO48 tem Smoke 33/0/4 + Sexteto
  VR_20260509_173629 verde como baseline; rollback restaura essa base.

## O que voce precisa fazer agora

### Etapa 1 — Readback de rollback (PARAR antes de Etapa 2)

Crie em
`.hbn/relay/0010-onda24-rollback-micro49-para-micro48.md`
um Readback HBN com:

- Objetivo: rollback formal do pacote MICRO49 (fix1 + fix2) para o
  estado MICRO48 / MD-24.3.
- Build alvo: `f7aa84f+ONDA24.MD24.3-avaliacao-dual-counter`.
- Diff planejado:
  - `src/vba/Svc_Rodizio.bas`: reverter qualquer comentario/linha
    introduzida pelo MICRO49 ou fix1/fix2.
  - `src/vba/App_Release.bas`: alinhar carimbo + linhas finais ao
    estado MICRO48 em ambos os lados (src/vba e local-ai/vba_import).
  - `src/vba/Teste_V2_Engine.bas` / `Teste_V2_Roteiros.bas`: reverter
    se houverem alteracoes pertinentes ao MICRO49.
  - `local-ai/vba_import/<modulos>`: alinhar a `src/vba/<modulos>` para
    fechar G7 (espelho 12/12).
- Asserts pos-rollback:
  - `glasswing-checks.sh G7` retorna OK.
  - `?GetBuildImportado` no VBE retorna `f7aa84f+ONDA24.MD24.3-...`.
  - `TV2_RunSmoke False` retorna `OK=33 | FALHA=0 | MANUAL=4`.
  - Sexteto Minimo passa (sintaxe canonica de VR_20260509_173629).
- Riscos R1 (esquecer arquivo divergente nao mapeado): mitigacao -
  rodar `git diff f7aa84f -- src/vba/ local-ai/vba_import/` antes de
  declarar rollback completo.
- Rollback do rollback: caminho de retomada para MICRO49-fix3 caso o
  operador mude de ideia (NAO planejado agora, apenas registrado).
- PROXIMO PASSO: PARAR e aguardar Hearback humano.

### Etapa 2 — Apos Hearback humano explicito

a. Restaurar pacote/repo para o build
   `f7aa84f+ONDA24.MD24.3-avaliacao-dual-counter`.
b. Manifesto de rollback registra em
   `.hbn/results/0055-exec-onda24-md24-rollback-micro48.json`:
   - schema_version: "1.0"
   - executed_at: timestamp BRT
   - delta: lista exata de arquivos revertidos com hashes antes/depois
   - asserts: G7 OK, GetBuildImportado, Smoke 33/0/4, Sexteto verde
   - decisao_arquiteto_useHBN: ratifica via prompt 01 do Opus chat-novo
3. Rodar `local-ai/scripts/glasswing-checks.sh --strict` antes de
   entregar; bloquear se G7 falhar.

### Etapa 3 — Gate operador

Operador (Mauricio) executa, na ordem:

1. Importar pacote rollback no Excel.
2. Compilar limpo (VBE > Depurar > Compilar VBAProject) — DEVE FECHAR
   sem crash (criterio inverso ao incidente MICRO49).
3. `?GetBuildImportado` retorna `f7aa84f+ONDA24.MD24.3-...`.
4. `TV2_RunSmoke False` retorna 33/0/4.
5. Sexteto verde (sintaxe `VR_*`).

Se algum passo falhar, voltar para Etapa 1 (revisar Readback).

## Integracoes sistemicas com o protocolo useHBN (informativo — sem acao)

Em paralelo, em `~/Projetos/usehbn/`, foram producidos os esqueletos de
9 ADRs (`auditoria/00_status/00_BOOTSTRAP_PROTOCOLO_2026_05_09.md`).
Nenhum ADR esta merged ainda; todos aguardam cross-IA + Hearback.
Quando essas decisoes ratificarem, voce recebera um segundo
prompt-retomada citando os ADR-IDs aplicaveis (provavelmente
ADR-002 tipologia, ADR-003 topologia, ADR-004 SemVer, ADR-008 migracao
do `Credenciamento/usehbn/`).

Por enquanto, sua acao ESTA limitada a:

- Rollback MICRO49 → MICRO48 conforme Etapas 1-3.
- NAO tocar `Credenciamento/usehbn/` (legado em migracao apos v204
  final — ADR-008 cuidara).
- NAO tocar `Credenciamento/.hbn/knowledge/` (congelado ate v204 final).
- Operacao normal em `src/vba/`, `local-ai/vba_import/`,
  `.hbn/relay/INDEX.md` e `.hbn/results/`.

## Estado do bastao

Voce continua com bastao F1 (Credenciamento V204). Opus chat-novo
continua com bastao F2 (protocolo useHBN) em `~/Projetos/usehbn/`.
As duas pistas sao paralelas e auditaveis. Operador media com copy-paste.

## Marcadores HBN obrigatorios

Comeco da resposta:
✅ HBN ACTIVE — Codex CLI retomando esteira V12.0.0204 com rollback
MICRO49 → MICRO48 ratificado.

Fim da resposta:
🔵 HBN HANDOFF READY — Readback de rollback entregue; aguardando
Hearback humano para Etapa 2.

==================== FIM PROMPT-RETOMADA-CODEX-V204 ====================
```

## Notas operacionais para o operador

1) Antes de colar o bloco acima na sessao Codex, confirme que e a mesma
   sessao que produziu o RCA (manter contexto) ou inicie nova sessao
   citando o doc 68 + este parecer Codex no contexto inicial.

2) Apos a Etapa 3 (gate operador) passar, nada impede MICRO50 partindo
   de MICRO48. A Onda 24 do Credenciamento prossegue normalmente, sem
   MD-24.4.

3) Se Codex propor patch alternativo (ex.: MICRO49-fix3 minimal), volte
   a este prompt e ao parecer dele. Nossa decisao e rollback formal —
   nao re-litigar.

4) Sinal `🟠 HBN BILLING WINDOW DRIFT` so aplica se o ciclo de
   faturamento Anthropic mudar. Rollback consome tokens normais.

## Versao deste documento

- v1.0 — 2026-05-09 — Opus 4.7 chat-novo entrega prompt-retomada apos
  receber RCA Codex via operador. Sem mudanca de protocolo; apenas
  ratifica rollback e mantem ADRs em flight em paralelo.
