---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (modelo versão=pasta; M-A scaffold inativo; B18 ratificado e selado; B19a pendente)"
onda_atual: "B18 ratificado e selado; próxima onda: B19 (generalizar bloqueio symlink p/ todo path governado); hardlink=non-issue; depois S2"
bastao_token_sha256: 34a7f2f9882b7f4a8a5d54bfa40b957ae4369d8d3c4ba8bdbe52543b0d616daf
proprietario_bastao: codex
papel_bastao: "implementador"
modo_educacional: "intermediário"
papeis:
  arquiteto: "claude-opus-4-8 — orquestrador/desenho do mecanismo M-A; distinto do implementador codex"
  auditores_validadores: "gemini-3-5 + cursor — cross-audit S1 concluiu APROVA_S1: SIM; cross-audit B17 concluiu APROVA_B17: SIM; cross-audit B18 concluiu APROVA_B18: SIM"
  gate_humano: "Maurício — aprovou a reestruturação em 2026-06-15, autorizou a selagem S1, decidiu tratar B17 antes do S2, autorizou B18 e ratificou a selagem B18 com B19a como próxima onda"
proxima_acao: "B18 ratificado e selado; próxima onda: B19 (generalizar bloqueio symlink p/ todo path governado); hardlink=non-issue; depois S2"
sinais_abertos:
  - "🟡 B19a PRÓXIMA ONDA — generalizar bloqueio de symlink para todo path governado; hoje is_governed_hbn_symlink restringe a checagem a .hbn/* em guards/assert-scope-lock.sh:256, achado real/estreito no parecer Gemini .hbn/results/20260615-223941-gemini-3-5-cross-ia-b18-symlink.md; hardlink = non-issue (git 100644)."
  - "🟢 B18 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B18: SIM; symlink staged sob .hbn/** segue bloqueado por modo git 120000 antes da dispensa de meta-path; run-guard-tests 141/141 e adversarial-battery B1-B18 verdes."
  - "🟢 B17 RATIFICADO E SELADO — cross-audit Gemini+Cursor registrou APROVA_B17: SIM; meta-paths em guards/assert-scope-lock.sh auto-permitem somente .json/.md com basename ADR-025, hearback do readback ativo ou nome-endereco conhecido."
  - "🟢 S1 RATIFICADO E SELADO — assert-scope-lock endurecido contra auto-emenda de files_allowed; cross-audit Gemini+Cursor registrou APROVA_S1: SIM."
  - "🟢 REESTRUTURAÇÃO M-A+S0 SELADA — linha limpa proposta/reestruturacao-m-a-s0 @ 5a0587d; tree 61fa290e ancorada por tag."
  - "🟢 CROSS-AUDIT SIM — Cursor e Gemini 3.5 registraram APROVA_REESTRUTURACAO: SIM para o Modelo B."
  - "🔴 EXCEÇÃO F-01 ATIVA — desenhista=implementador=claude-fable-5 por ordem direta de Maurício; PROPOSED_UNTIL_CROSS_AUDIT."
  - "🔴 PONTE VETADA — 0034 Codex e 0035 Antigravity retornaram VETO_ADOCAO: SIM; corrigir bloqueadores antes de descongelar."
  - "🔴 ATIVAÇÃO DA EXÚVIA BLOQUEADA — Fitness Gate pendente: baseline funcional + Ponte verde + confronto incumbente×desafiante."
  - "🟡 D-ORQ-WRITE NÃO HABILITADA — doutrina no replay; escrita do orquestrador e G-ACTOR-WRITE-MATRIX seguem para rito futuro."
  - "🟡 G-HRB assinatura PENDENTE DE CHAVE — Maurício gera/registra .hbn/operators/<nome>.pub para ativar ssh-keygen -Y verify."
  - "🟡 F-02 (0035 UTC×REGISTRY) NÃO corrigido — formato da linha superseded_by segue decisão humana."
  - "🟡 branch protection no GitHub (hbn-shield obrigatório no push) = ação humana pendente."
  - "🟡 backlog preservado — bump 0.3.1, hearback 0002, inbox/credenciamento e versionamento de readbacks ficam para ondas futuras."
readback_ativo: ".hbn/readbacks/0022-selagem-b18-cross-audit.json"
handoff_mais_recente: ".hbn/messages/20260615-230143-codex-handoff-selagem-b18.md"
ancora_rollback: "evidencia/reestruturacao-m-a-s0-tree-equivalent -> 5a0587d (tree 61fa290e; rollback da selagem ao replay limpo)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "B18 ratificado e selado; próxima onda: B19 (generalizar bloqueio symlink p/ todo path governado); hardlink=non-issue; depois S2."
ultima_atualizacao: "2026-06-15T23:01:43-03:00"
atualizado_por: codex-implementador-selagem-b18
atribuicao:
  chapeu_atual: implementador
  implementador: codex
  auditores: [gemini-3-5, cursor]
  gravada_em: "2026-06-15T21:53:12-03:00"
  hearback_ref: null
---

Nota M-A: esta onda construiu a máquina da muda sem disparar a muda. O
ponteiro ativo permanece em `.`; hooks e guards falham fechado quando o
ponteiro está ausente, conflitado ou aponta para versão inexistente. A tag
`hbn-exuvia/protocol-0.3.x` e qualquer `git mv` ficam para M-C, depois do
Fitness Gate. O script de rollback foi testado apenas em dry-run.

Nota S0: esta onda corrigiu somente itens aditivos/corretivos pós-M-A. O bug D3
do rollback foi corrigido com teste de `--apply`; perfis `grok` e `cursor`
foram adicionados como `proposed`; o INDEX foi marcado como superseded pelo
STATE; e as fixtures untracked indicadas foram removidas. Nenhuma lógica de
guard foi alterada.

Nota depósito S0: Gemini (Google) aprovou S0 com confiança 100/100; Cursor
aprovou S0 com duas marginais não-bloqueadoras; opus-4-8 consolidou como OK,
ratificável e sem bloqueador. O marginal `cursor.json` model_id vs runtime fica
rastreado para a promoção futura do perfil a `accepted`.

Nota D-ORQ-WRITE: a cláusula 10 de `core/orchestrator-profile-spec.md` está na
linha limpa ratificada pela reestruturação M-A+S0, mas esta selagem não habilita
escrita operacional do orquestrador. O guard G-ACTOR-WRITE-MATRIX fica reservado
para rito futuro.

Nota reestruturação M-A+S0: o Modelo B foi ratificado por Maurício em
2026-06-15 após cross-audit Cursor+Gemini com `APROVA_REESTRUTURACAO: SIM`.
A linha limpa é `proposta/reestruturacao-m-a-s0` no tip `5a0587d`; a prova
mecânica fica congelada pela tag `evidencia/reestruturacao-m-a-s0-tree-equivalent`
com tree `61fa290e83b075983b9c6961a06c6e229cad1fd4`. Esta selagem adiciona
governança nova por cima do replay e não habilita escrita operacional do
orquestrador.

Nota selagem S1: Gemini (`.hbn/results/20260615-112714-gemini-3-5-cross-ia-s1-scope-lock.md`)
e Cursor (`.hbn/results/20260615-113115-cursor-cross-ia-s1-scope-lock.md`)
registraram `APROVA_S1: SIM`. B16 (auto-emenda de `scope.files_allowed` + uso
no mesmo commit) permanece bloqueado pela bateria S1. B17, a brecha
preexistente de meta-paths sempre permitidos em `guards/assert-scope-lock.sh:207-214`,
foi tratado e selado em 2026-06-15; B18 segue como proxima onda antes do S2.

Nota B17: a brecha preexistente de smuggling por meta-path foi implementada em
2026-06-15 com recorte tipo+nome. `guards/assert-scope-lock.sh` agora aceita
automaticamente apenas `.json`/`.md` de evento ADR-025 em `.hbn/messages/` e
`.hbn/bypasses/`, hearback `NNNN-*.{json,md}` do readback ativo e
`.hbn/relay/INDEX.md`; scripts, binarios e nomes arbitrarios nesses caminhos
precisam estar em `scope.files_allowed`. `run-guard-tests` passou com 140/140 e
`adversarial-battery` bloqueou B1-B17; cross-audit independente aprovado em
2026-06-15.

Nota selagem B17: Gemini
(`.hbn/results/20260615-213855-gemini-3-5-cross-ia-b17-meta-path.md`) e Cursor
(`.hbn/results/20260615-213850-cursor-cross-ia-b17-meta-path.md`) registraram
`APROVA_B17: SIM`. Cursor documentou B18: symlink com basename ADR-025 em
`.hbn/messages/20260615-120000-codex-handoff-x.md` apontando para
`../../src/payload.sh` passa porque `is_meta_auto_allowed` valida somente o
path string (`guards/assert-scope-lock.sh:236-249`). Decisão humana:
B18 e a próxima onda antes do S2.

Nota B18: implementado em 2026-06-15. `guards/assert-scope-lock.sh` agora
recusa qualquer entrada staged sob `.hbn/**` com modo git `120000`, antes de
avaliar `scope.files_allowed` ou meta-path ADR-025. A mensagem de bloqueio e
`symlink não permitido em path de coordenação governado: <path>`. Arquivos
regulares de handoff `.md`, hearback `NNNN-*.json` e nota de bypass `.md`
continuam passando. Cross-audit independente aprovado na selagem B18.

Nota selagem B18: Gemini
(`.hbn/results/20260615-223941-gemini-3-5-cross-ia-b18-symlink.md`) e Cursor
(`.hbn/results/20260615-224921-cursor-cross-ia-b18-symlink.md`) registraram
`APROVA_B18: SIM`. B19a fica aberto porque `is_governed_hbn_symlink` limita a
checagem a `.hbn/*` em `guards/assert-scope-lock.sh:256`; a próxima onda deve
generalizar o bloqueio de symlink para todo path governado. hardlink =
non-issue (git 100644): o Git grava hardlink como arquivo regular, sem
semantica de link no objeto versionado.
