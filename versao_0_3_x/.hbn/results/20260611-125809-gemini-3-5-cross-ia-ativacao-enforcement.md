---
titulo: "Parecer Antigravity — cross-audit ex-post da onda ativação-enforcement (readback 0005)"
tipo: result
path: .hbn/results/20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement.md
id-global: 20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement
temperatura: glacier
auditor: antigravity-gemini
alvo: "commits 27775bd, ffd40c5, 65b4af0 + readback 0005"
reviewed_at: "2026-06-11T12:58:09-03:00"
status: congelado
---

## Resumo Humano

1. O hook `.git/hooks/pre-commit` chama o runner corretamente via caminho relativo dinâmico, sobrevivendo a renomeações.
2. A pré-condição do `STATE.md` (testes negativos dos 5 guards legados) foi paga com 12 checks adicionados na suíte.
3. Há pequenos gaps na cobertura de testes legados (ex.: falta testar `files_forbidden` em isolamento no `G-SCO`).
4. O guard `G-STRAY` possui limitações: falha em detectar `.hbn` órfãos em profundidade >4, e a exclusão da pasta `backups/` cria um bypass.
5. Foi identificada uma inconsistência grave no parecer anterior `0035.md` (UTC no arquivo vs -03:00 e ID diferente no `REGISTRY.md`).
6. O uso de `CI=true` localmente constitui um bypass que exige travas baseadas em TTY e variáveis específicas de provedores de CI.
7. A violação do processo de cross-audit pré-commit é grave, mas mitigável com este parecer ex-post e novas regras de autorização digital.
8. Os sinais e a nota descrita no `STATE.md` refletem fielmente o estado físico do repositório pós-onda.
9. A suíte de testes está 100% verde (79/79) e o sweep manual do `G-STRAY` executou com sucesso sem detectar órfãos.

**VETO_ADOÇÃO:** SIM (Veto provisório até a regularização do ID e relógio do parecer 0035 no REGISTRY/front-matter, e aprovação humana do readback 0005).

---

## Pontos de Auditoria

### P1 — Hook pre-commit e Bypasses
* **Veredito:** FORTE (Risco de bypass local)
* **Evidência:** [.git/hooks/pre-commit:3](file:///Users/macbookpro/Projetos/usehbn/.git/hooks/pre-commit#L3)
* **Análise:** O pre-commit chama o runner usando `exec bash "$(git rev-parse --show-toplevel)/guards/hbn-guards-runner.sh"`, o que é dinâmico e sobrevive a renomeações/movimentações do repositório. Contudo, há vetores de não-execução:
  1. Configuração `core.hooksPath` no Git, que desvia a pasta de hooks.
  2. Uso manual do parâmetro `--no-verify` (ou `-n`) pelo committer.
  3. Falta de permissões de execução no hook (embora atualmente esteja com `-rwx--x--x`).
* **Mitigação:** O protocolo deve:
  - Encomendar a execução obrigatória do runner `hbn-guards-runner.sh` na inicialização de qualquer sessão de IA (leitura cega ou sandbox start), validando o commit `HEAD` e staged contra os guards.
  - Executar a bateria de guards na esteira de CI (onde `--no-verify` local não tem efeito).

### P2 — Ativação e Testes Negativos Legados
* **Veredito:** MARGINAL (Gaps menores de cobertura)
* **Evidência:** [guards/tests/run-guard-tests.sh:685-755](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh#L685-L755)
* **Análise:** A pré-condição do STATE foi paga fisicamente no commit `ffd40c5` com a inserção da seção "guards legados" e 12 novos checks. Contudo:
  - O `G-SCO` não possui teste negativo isolado para `files_forbidden` (apenas testa `files_allowed` vazio e staged fora do permitido).
  - Edge cases como arquivo `canonical-root` corrompido ou inacessível não são testados.
  Os checks testam o comportamento de bloqueio básico corretamente, mas deixaram de fora cenários mais estritos.

### P3 — Qualidade dos Testes Legados (G-TMP e G-CR)
* **Veredito:** MARGINAL (Falta de cleanup automático global)
* **Evidência:** [guards/tests/run-guard-tests.sh:739](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh#L739) e [guards/tests/run-guard-tests.sh:747](file:///Users/macbookpro/Projetos/usehbn/guards/tests/run-guard-tests.sh#L747)
* **Análise:** 
  - O teste `G-TMP` força `/tmp` literal para testar o bloqueio de worktree. Como no macOS `/tmp` resolve para `/private/tmp`, o guard [forbid-tmp-worktree.sh:34](file:///Users/macbookpro/Projetos/usehbn/guards/forbid-tmp-worktree.sh#L34) cobre corretamente ambos os caminhos no padrão `case`.
  - O teste-bom do `G-CR` cria um repositório temporário aninhado em `guards/tests/`. Como o script executa `git init -q` dentro dele, o Git interrompe a busca de toplevel no diretório temporário, isolando-o do repo principal e evitando viés.
  - Contudo, a suíte carece de um bloco `trap` global para remover os diretórios de teste. Em caso de aborto ou falha no meio do script, os repositórios temporários permanecem fisicamente no workspace, poluindo-o com diretórios untracked que podem enganar varreduras futuras.

### P4 — G-STRAY (assert-no-stray-hbn.sh)
* **Veredito:** FORTE (Falsos negativos em estruturas profundas/exclusões)
* **Evidência:** [guards/assert-no-stray-hbn.sh:71](file:///Users/macbookpro/Projetos/usehbn/guards/assert-no-stray-hbn.sh#L71) e [guards/assert-no-stray-hbn.sh:74-76](file:///Users/macbookpro/Projetos/usehbn/guards/assert-no-stray-hbn.sh#L74-L76)
* **Análise:** 
  - **Worktrees e submódulos:** O guard usa `[[ ! -e "${parent}/.git" ]]`. Como em worktrees e submódulos o `.git` é um arquivo texto regular e não um diretório, o parâmetro `-e` retorna verdadeiro de qualquer forma, evitando falsos positivos corretamente.
  - **Profundidade:** O `find` usa `-maxdepth 4`. Um `.hbn` criado a 5 ou mais níveis de profundidade a partir do `SCAN_ROOT` não será detectado, gerando um falso negativo grave.
  - **Symlinks:** O `find` não segue links simbólicos. Se a árvore do repositório for linkada, o sweep não entrará nela.
  - **Poda de backups/:** Ignorar a pasta `backups/` permite que uma IA maliciosa ou errática crie um `.hbn` oculto sob esse nome, escapando do sweep.
  - **Fallback do SCAN_ROOT:** O `exit 0` com aviso em caso de `SCAN_ROOT` indeterminado permite bypass se o ambiente ocultar o diretório toplevel ou se o script rodar fora de um diretório Git válido.

### P5 — REGISTRY e Honestidade Temporal (Inconsistência 0035)
* **Veredito:** BLOQUEADOR (Inconsistência de ID e Relógio)
* **Evidência:** [REGISTRY.md:315](file:///Users/macbookpro/Projetos/usehbn/REGISTRY.md#L315) vs [.hbn/results/0035-cross-ia-antigravity-ponte.md:6-9](file:///Users/macbookpro/Projetos/usehbn/.hbn/results/0035-cross-ia-antigravity-ponte.md#L6-L9)
* **Análise:** 
  - As 10 novas linhas inseridas no `REGISTRY.md` estão coerentes entre ID e `created_at` (formato `HHMMSS` correto e offset `-03:00`).
  - No entanto, o parecer `0035` possui uma inconsistência crítica:
    - No arquivo [.hbn/results/0035-cross-ia-antigravity-ponte.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/results/0035-cross-ia-antigravity-ponte.md#L6-L9), o `id-global` é `20260611-025900-antigravity-parecer-ponte` com `reviewed_at` em UTC (`"2026-06-11T02:59:00Z"`).
    - No [REGISTRY.md:315](file:///Users/macbookpro/Projetos/usehbn/REGISTRY.md#L315), a linha correspondente registra o ID `20260610-235830-gemini-3-5-audit-ponte-md` com `created_at` `2026-06-10T23:58:30-03:00`.
    - Isso viola a regra de consistência de ID do adendo `ADR-011×ADR-024` e causa desalinhamento na base de dados de controle.
  - **Front-matter de terceiros:** A alteração nos arquivos `0034.md` e na proposta do Codex limitou-se estritamente à conformidade de auto-localização do `ADR-021` (consertando caminhos absolutos e adicionando metadados), sem alteração do conteúdo técnico.

### P6 — bypass do G-CR via CI=true
* **Veredito:** FORTE (Bypass fácil localmente)
* **Evidência:** [guards/assert-canonical-root.sh:20-23](file:///Users/macbookpro/Projetos/usehbn/guards/assert-canonical-root.sh#L20-L23)
* **Análise:** O bypass baseado em `CI=true` foi usado nos 3 commits do sandbox porque a máquina virtual/contêiner de cowork não compartilhava o path exato da máquina local do desenvolvedor (`/Users/macbookpro/Projetos/usehbn`). Embora justificado pelo ambiente, expõe um bypass trivial local: qualquer committer local pode rodar `CI=true git commit` e burlar a proteção do `G-CR`.
* **Remediação:** O guard deve recusar `CI=true` se detectar sessões interativas (ex.: `[[ -t 0 ]]`) ou exigir variáveis de ambiente específicas de provedores conhecidos (ex.: `GITHUB_ACTIONS`, `GITLAB_CI`).

### P7 — Desvio do Processo de Governança
* **Veredito:** BLOQUEADOR (Quebra do protocolo de segurança)
* **Evidência:** [.hbn/readbacks/0005-ativacao-enforcement.json:11-15](file:///Users/macbookpro/Projetos/usehbn/.hbn/readbacks/0005-ativacao-enforcement.json#L11-L15)
* **Análise:** O commit direto de mudanças sem aprovação e sem cross-audit prévio viola o núcleo de segurança HBN (firewall humano-gated). A justificativa de "ordem direta" do humano resolve operacionalmente a urgência do operador, mas quebra a cadeia de confiança se não puder ser atestada de forma criptográfica ou rastreável.
* **Remediação:** Para tornar a exceção não-repetível silenciosamente:
  1. O bloco `authorization` no readback deve incluir uma assinatura criptográfica do humano (chave GPG ou SSH).
  2. O commit deve conter obrigatoriamente um trailer `HBN-Authorization: <chave-de-autorizacao>`.
  3. O `STATE.md` deve abrir um sinal vermelho explícito de bypass temporário.
  4. Um guard específico deve cruzar a ausência de parecer de auditoria e bloquear commits normais se a chave de bypass não for válida.

### P8 — Fidelidade do STATE.md
* **Veredito:** OK
* **Evidência:** [.hbn/relay/STATE.md:14-25](file:///Users/macbookpro/Projetos/usehbn/.hbn/relay/STATE.md#L14-L25)
* **Análise:** Os sinais e a nota da onda descritos no arquivo coincidem precisamente com a realidade física: o hook está de fato instalado e operativo, os guards novos estão ativos no runner, a suíte de testes está expandida e os pareceres 0034/0035 estão registrados.

### P9 — Reprodutibilidade
* **Veredito:** OK
* **Evidência:** Execução de testes (`bash guards/tests/run-guard-tests.sh` -> 79/79 verdes) e sweep (`bash guards/assert-no-stray-hbn.sh --sweep` -> Limpo, zero órfãos).
* **Análise:** Os testes da suíte passaram integralmente (79 verizações) demonstrando que as regressões não causaram danos colaterais nos guards. O sweep funcionou localmente sem falsos positivos.

---

## Proposta de Linha do REGISTRY

Proposta de registro deste parecer para consolidação (a ser realizada pelo operador humano):

```markdown
| 20260611-125809-gemini-3-5-audit-ativacao-enforcement | .hbn/results/0037-cross-ia-antigravity-ativacao-enforcement.md | audit-result | frio | — | 2026-06-11T12:58:09-03:00 |
```
