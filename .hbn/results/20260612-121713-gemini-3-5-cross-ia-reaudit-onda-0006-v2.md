---
titulo: "Parecer Antigravity — re-auditoria ex-post da onda 0006 v2"
tipo: result
path: .hbn/results/20260612-121713-gemini-3-5-cross-ia-reaudit-onda-0006-v2.md
id-global: 20260612-121713-gemini-3-5-cross-ia-reaudit-onda-0006-v2
temperatura: frio
auditor: antigravity-gemini
alvo: "branch proposta/onda-0006-v2 (13 commits)"
reviewed_at: "2026-06-12T12:17:13-03:00"
---

## Resumo Humano

1. A re-auditoria da branch `proposta/onda-0006-v2` atesta a remediação de todos os bloqueadores da v1.
2. A incompatibilidade de Bash 3.2 no G-TOK foi sanada com conversão segura via `tr` (suíte 123/123 verde).
3. O deadlock e perda de autoria no runbook foram corrigidos com o comando `commit -C` e cerimônia final.
4. O replay do G-TOK foi mitigado ao mover o segredo para arquivo local e usar apenas fingerprint público.
5. O script do Glacier foi corrigido para usar o agente `mauricio`, que possui perfil registrado no commit.
6. Os pareceres 0036/0037 foram alinhados fisicamente e no `id-global` interno.
7. A bateria adversarial roda sem crash e todas as 14 burlas estão bloqueadas de forma legítima.

**VETO_CHERRY_PICKS:** NÃO

---

## Verificação de Achados e Bloqueadores

### R1. Bash 3.2 no G-TOK
- **Veredito:** SANADO
- **Severidade:** Nula
- **Análise:** A sintaxe de expansão `${EXPECTED,,}` incompatível com o Bash 3.2 do macOS foi substituída pela função helper `lc()` que faz `tr '[:upper:]' '[:lower:]'`. A execução do comando `bash guards/tests/run-guard-tests.sh | tail -2` concluiu com sucesso reportando `== resumo: 123 passaram, 0 falharam ==` e `SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.`, sem quebras ou substituições ruins.

### R2. Deadlock do runbook
- **Veredito:** SANADO
- **Severidade:** Nula
- **Análise:** O runbook da tabela de aprovação v2 (`20260612-120145-fable5-tabela-aprovacao-onda-0006-v2.md`) reordenou o rito: o token entra no `STATE.md` com campo vazio (rampa inativa) no commit final `I-09` e os 12 picks anteriores rodam sem exigir o token. A cerimônia de geração física de `.git/hbn-baton-token` local e a gravação do sha256 no STATE ocorrem apenas como passo final após todos os picks, eliminando a dependência circular.

### R3. Autoria preservada
- **Veredito:** SANADO
- **Severidade:** Nula
- **Análise:** O comando de pick sugerido no runbook foi alterado de `git commit --no-edit` para `git commit -C <sha>`. Esse comando instrui o git a reaproveitar o autor e a mensagem com os trailers originais de `claude-fable-5` enquanto executa e valida o commit sob os hooks `pre-commit` e `commit-msg` locais.

### R4. Replay do G-TOK
- **Veredito:** MITIGADO / LIMITAÇÃO DECLARADA
- **Severidade:** Baixa (Limitação de design documentada)
- **Análise:** O segredo do token (16 bytes gerados de forma randômica) vive exclusivamente no arquivo local `.git/hbn-baton-token` (não versionado) com proteção restritiva de leitura (`umask 077`), e o histórico de commits armazena apenas o `HBN-Token-FP: <8 hex>` (fingerprint público). O replay do segredo a partir do log público é impossível localmente. A limitação em CI remoto (que valida apenas consistência de fingerprint, permitindo replay via push com hook local bypassado) foi explicitamente documentada no §6 da state-report-spec como parte do design simplificado do G-TOK.

### R5. glacier-move.sh
- **Veredito:** SANADO
- **Severidade:** Nula
- **Análise:** O script corrigido (`20260611-162338-fable5-script-glacier-move.sh`) agora usa `AGENTE="mauricio"` (operador humano legítimo) para a geração dos IDs de movimentação (`YYYYMMDD-HHMMSS-mauricio-<slug>`) e cria o respectivo perfil de modelo `.hbn/models/mauricio.json` em staging na primeira leva. Isso faz com que o guard `G-NUM` valide a entrada com sucesso.

### R6. Mismatch id-global × nome dos pareceres
- **Veredito:** SANADO
- **Severidade:** Nula
- **Análise:** No commit `I-04` amendado na v2 (`c900406`), o campo interno `id-global` dos pareceres `20260611-110642-codex-cross-ia-ativacao-enforcement.md` e `20260611-125809-gemini-3-5-cross-ia-ativacao-enforcement.md` foi modificado para utilizar o slug `cross-ia-ativacao-enforcement` em vez de `audit-ativacao-enforcement`, igualando-se exatamente aos nomes físicos e linhas do `REGISTRY.md`.

### R7. Bateria adversarial
- **Veredito:** PASSANDO
- **Severidade:** Nula
- **Análise:** O comando `bash guards/tests/adversarial-battery.sh | tail -2` executou com sucesso retornando `BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.`. O teste adversarial `B14` foi retrabalhado para testar a tentativa de posse com arquivo local de token incorreto sob fingerprint público válido (replay), sendo devidamente bloqueado pelo G-TOK sem mascaramento por crash de sintaxe.

---

## REGISTRY

```markdown
| 20260612-121713-gemini-3-5-cross-ia-reaudit-onda-0006-v2 | .hbn/results/20260612-121713-gemini-3-5-cross-ia-reaudit-onda-0006-v2.md | result | frio | — | 2026-06-12T12:17:13-03:00 |
```
