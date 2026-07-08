---
path: .hbn/results/20260618-134234-codex-design-w-orq-3-deadlock.md
SOU: codex · familia OpenAI · papel implementador
status: congelado
temperatura: glacier
---

# Parecer de design — W-ORQ-3 deadlock

Escopo: input de viabilidade como implementador, sem implementar. Li do disco: `docs/brainstorm/rodada-2026-06-18/W-ORQ-3-DEADLOCK-design-audit.md`, `guards/assert-orq-entrada-ref.sh`, `guards/assert-orq-entrada.sh`, `guards/tests/run-guard-tests.sh` e `guards/tests/adversarial-battery.sh`.

## 1. Confirmo o deadlock

Confirmo.

O lado "nao regenerar" cai em `assert-orq-entrada.sh`: localmente ele le `git show :path`; em CI le `HEAD:path` quando `HBN_DIFF_BASE` existe (`guards/assert-orq-entrada.sh:35-41`). Ele resolve `DYNAMIC handoff_mais_recente` e `DYNAMIC readback_ativo` a partir do STATE (`:99-114`), exige 13 itens resolvidos (`:137-143`), calcula o manifesto dos blobs atuais (`:212-240`) e bloqueia se `manifest_sha256` da atestacao divergir (`:280-283`). Como selagem/freeze que mexe em STATE muda ao menos `readback_ativo`/`proxima_acao` e normalmente o proprio readback ativo, a atestacao antiga fica invalida.

O lado "regenerar" cai em `assert-orq-entrada-ref.sh`: ele detecta ato de autoridade por despacho (`:156-160`), freeze (`:163-165`) e readback de selagem/status vigente (`:126-142`, `:168-178`). Depois, em modo local, qualquer `.hbn/attestations/<fp>-orq-entrada.json` alterada junto de ato de autoridade bloqueia (`:247-251`). Em CI, a regra por commit tambem bloqueia qualquer commit que misture ato de autoridade e atestacao (`:253-264`).

O runner chama os dois guards na mesma execucao, com `assert-orq-entrada.sh` antes de `assert-orq-entrada-ref.sh` (`guards/hbn-guards-runner.sh:83-96`). Portanto:

- sem atestacao regenerada, `assert-orq-entrada.sh` bloqueia por manifesto/`execution_id`/campo dinamico desatualizado;
- com atestacao regenerada, `assert-orq-entrada-ref.sh` bloqueia por "re-pin" amplo.

Os testes atuais nao exercitam esse caminho. O bloco G-ORQ-REF cobre despacho valido, ref omitida, dangling, fp trocado, auto-repin amplo e entrega nao-autoridade (`guards/tests/run-guard-tests.sh:2348-2426`), mas nao uma selagem real que altera STATE e regenera a atestacao. A bateria B48-B51 replica a mesma superficie adversarial (`guards/tests/adversarial-battery.sh:958-1028`).

## 2. Exit preferido

Eu escolheria Exit D como entrega: semantica do Exit A, mais teste dogfood obrigatorio de selagem. Se a pergunta for apenas sobre a mudanca de regra, a parte implementavel e o Exit A.

Nao escolheria B como solucao principal: o proprio desenho atual resolve `readback_ativo` como DYNAMIC, entao um commit previo de atestacao precisa antever o readback que a selagem ainda vai criar. Isso e fragil e facil de operar errado. Nao escolheria C agora: desacoplar campos volateis do STATE muda a semantica do G-ORQ-ENTRADA e e uma revisao maior do contrato de prova.

Regra recomendada, fail-closed:

1. Ato de autoridade continua obrigado a declarar `orq_entrada_ref` igual ao ref esperado pelo `bastao_token_sha256` do STATE atual.
2. Em ato de autoridade, permitir somente modificacao da atestacao esperada `.hbn/attestations/${token_fp}-orq-entrada.json`.
3. Bloquear qualquer atestacao de outro fp adicionada, removida, renomeada ou modificada no mesmo ato.
4. Para a atestacao esperada, permitir alteracao apenas se for regeneracao real de mesmo fp: fp do nome, fp JSON antigo e fp JSON novo devem bater com o fp esperado; o `bastao_token_sha256` completo do STATE nao pode trocar no ato; `manifest_sha256` novo deve diferir do antigo; e a nova atestacao deve passar `assert-orq-entrada.sh`.
5. Se qualquer blob antigo/novo estiver ausente, JSON ilegivel, campo ausente ou ambiguidade de rename/delete/add, bloquear.

Como detectar mudanca de fp de forma robusta:

- Local: comparar explicitamente `HEAD:<repo_path>` contra `:<repo_path>`. O antigo vem do HEAD; o novo vem do indice staged. Nao usar working tree.
- CI: para cada commit em `HBN_DIFF_BASE..HEAD`, comparar `${commit}^:<repo_path>` contra `${commit}:<repo_path>`; nao comparar `HEAD:` contra `HEAD:` e nao depender do indice.
- Extrair tres sinais independentes: fp do nome do arquivo, `bastao_token_fp` do JSON antigo e `bastao_token_fp` do JSON novo. Todos devem ser iguais ao fp esperado derivado do STATE novo.
- Comparar tambem o `bastao_token_sha256` completo do STATE antigo vs novo quando STATE foi alterado no ato. Se o SHA completo mudou, e troca de bastao, mesmo que os 8 primeiros caracteres coincidam.
- Tratar `git cat-file -e` falhando, JSON invalido, campo nao-string, multiplas atestacoes alteradas ou path nao esperado como bloqueio.

Isso preserva a barreira: G-ORQ-REF decide se a alteracao da atestacao e uma regeneracao permitida de mesmo bastao; G-ORQ-ENTRADA continua decidindo se a prova extrativa e valida contra os blobs atuais.

## 3. Testes novos que provam selagem real

Eu adicionaria testes em `guards/tests/run-guard-tests.sh`, reutilizando `make_orq_entrada_repo` e `write_valid_orq_attestation`, com todos os arquivos staged antes de chamar o helper, porque ele le `git rev-parse :path`.

Teste positivo principal:

- `orq-ref: selagem real com STATE/readback_ativo DYNAMIC e atestacao mesmo-fp passa`.
- Fluxo: partir de `make_orq_ref_base`; criar `.hbn/readbacks/0062-selagem-w-orq-3.json` com `readback_id`, `execution_id` novo, `authority_act: "selagem"`, `status: "selado"` e `orq_entrada_ref` esperado; atualizar `.hbn/relay/STATE.md` para `readback_ativo` apontar para esse novo readback e mudar `proxima_acao`; `git add` do STATE e readback; chamar `write_valid_orq_attestation`; `git add` da atestacao; esperar `assert-orq-entrada.sh` PASS e `assert-orq-entrada-ref.sh` PASS.
- Esse teste prova o ponto critico: o `DYNAMIC readback_ativo` resolve para o readback novo, o `execution_id` novo entra na seed, e a atestacao regenerada e aceita no mesmo ato por ser mesmo fp.

Negativos de controle:

- Mesma selagem, sem regenerar atestacao: `assert-orq-entrada.sh` deve BLOCK.
- Mesma selagem, atestacao alterada apenas com campo decorativo e `manifest_sha256` igual ao antigo: deve BLOCK. Isso preserva o espirito do B51 atual.
- Mesma selagem, atestacao esperada com `bastao_token_fp` JSON trocado: deve BLOCK.
- Mesma selagem, atestacao extra `.hbn/attestations/deadbeef-orq-entrada.json` staged junto: deve BLOCK.
- Mesma selagem, `bastao_token_sha256` completo do STATE trocado no ato, mesmo mantendo prefixo de 8 chars: deve BLOCK.

Teste CI/head:

- Criar base, commitar uma selagem com STATE + readback novo + atestacao mesmo-fp regenerada, e rodar `HBN_DIFF_BASE=$base bash guards/assert-orq-entrada-ref.sh`: deve PASS.
- Fazer variante em commit com ato de autoridade + fp trocado/atestacao extra: deve BLOCK.

Na bateria adversarial, manter B48-B50 e ajustar/renomear B51 para a ameaca real sob a nova regra:

- B48 `orq_entrada_ref` omitido continua BLOCK.
- B49 ref dangling/atestacao ausente continua BLOCK.
- B50 ref com fp trocado continua BLOCK.
- B51 deve continuar BLOCK para "auto-repin sem regeneracao real" ou "auto-repin de fp diferente", nao para qualquer byte diferente de mesmo-fp. Se a implementacao simplesmente permitir toda alteracao same-fp, o B51 atual vira regressao.

## 4. Riscos de regressao

Risco principal nos B48-B51: afrouxar demais o bloqueio amplo. B48-B50 nao dependem da regra de auto-repin e devem permanecer iguais. B51 depende da definicao: hoje ele bloqueia uma nota extra em atestacao (`guards/tests/run-guard-tests.sh:2414-2425`; `guards/tests/adversarial-battery.sh:1017-1028`). Se Exit A for implementado como "qualquer alteracao same-fp passa", B51 fica vermelho e abre mudanca decorativa sem necessidade. Para evitar isso, a excecao deve exigir regeneracao real: `manifest_sha256` novo diferente e atestacao nova validada contra os blobs atuais.

Risco no reuso de `assert-orq-entrada.sh`: ele ja e o validador correto da prova nova, mas nao distingue "regeneracao necessaria" de "metadata edit". Por isso G-ORQ-REF precisa fazer a triagem de diff antes de chamar `assert-orq-entrada.sh`; nao basta remover o bloqueio das linhas `247-251`.

Risco local vs CI: se a logica for corrigida so no ramo local (`HEAD:` vs `:`) e a alca de CI (`HBN_DIFF_BASE..HEAD`) continuar bloqueando amplo, a selagem passa no pre-commit e falha no push/CI. A solucao precisa ter a mesma semantica nos dois modos, usando parent-vs-commit em CI.

Risco com DYNAMIC: `write_valid_orq_attestation` e o guard leem blobs staged. Se o teste chamar o helper antes de `git add` do STATE/readback novo, ele gera prova para o estado velho e cria falso negativo confuso. O teste positivo precisa staged-first para provar `readback_ativo` dinamico de verdade.

Risco de path/versionamento: toda comparacao deve operar em version path para politica e repo path para `git show`/`cat-file`, usando os helpers existentes (`guard_version_repo_path`, `guard_active_version_prefix`). Hardcode de path sem prefixo pode quebrar repo com `versao_*`.

Risco de token collision/identidade: fp de 8 chars e identificador curto. A regra deve comparar tambem o SHA completo do STATE entre antigo e novo para impedir troca de bastao no ato. Campos como `identidade` e `proprietario_bastao` da atestacao nao devem virar fonte de autoridade; a autoridade mecanica e o token do STATE + prova extrativa validada.

Veredito: implementavel de forma aditiva e fail-closed com Exit D/A. O patch deve ser pequeno no G-ORQ-REF, mas so e seguro se vier acompanhado do teste positivo de selagem real e dos negativos acima.
