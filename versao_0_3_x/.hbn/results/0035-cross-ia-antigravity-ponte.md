---
titulo: "Parecer Antigravity — auditoria cruzada da PONTE CONSOLIDADA usehbn ⇄ Credenciamento"
tipo: result
status: congelado
temperatura: glacier
id-global: 20260611-025900-antigravity-parecer-ponte
path: .hbn/results/0035-cross-ia-antigravity-ponte.md
autoria: antigravity-gemini (Google — auditor cruzado de 2ª família, chat limpo, sem bastão)
reviewed_at: "2026-06-11T02:59:00Z"
relacionado: [usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md]
---

# Parecer Antigravity — Auditoria Cruzada da Ponte Consolidada

**Auditor:** Antigravity (Gemini 3.5 / Google)  
**Session Role:** cross-ia-audit-ponte  
**Reviewed at:** 2026-06-11T02:59:00Z  

## Veredito
**VETO_ADOÇÃO:** SIM (Veto provisório até correção dos bloqueadores e graves apontados).

---

## Resumo para Humano
A proposta de ponte consolidada foi auditada sob independência estrita. Embora a topologia macro e os deltas estejam corretos, foram identificadas 3 falhas de projeto críticas: (1) O guard de integridade do snapshot tenta ler a biblioteca de verificação em caminho absoluto local (`~/Projetos/usehbn/`), quebrando a esteira de CI em ambientes isolados; (2) O texto do split do firewall 0022 não está explícito no plano consolidado, gerando risco de deriva semântica na aplicação; (3) O passo R8 do runbook falha no pre-commit local ao tentar comitar o README do tombstone e a trava de forbidden-paths na mesma etapa. Recomenda-se a divisão do commit R8, a especificação dos textos de firewall (anexados aqui) e a vendorização da verificação.

---

## Escrutínio Mínimo dos 6 Pontos do §11

### 1. §0 achado 1 — Diferenças no PRINCIPIOS
*Veredito:* **OK**  
*Evidência:* `Credenciamento/usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md` vs `usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md`  
*Análise:* O diff integral comprova que a cópia sob `Credenciamento` está de fato no estado pré-MD-F/MD-J. Ela carece da declaração de licença atualizada (exibe AGPLv3 em vez de Apache 2.0/CLA), não possui a nota sobre a não-invalidação do runtime Python pela introdução do Rust (P12) e carece da nota de isonomia P1-P13. Trata-se de histórico defasado e a adjudicação "canônico vence sem resgate" é 100% correta.

### 2. §1-D1 — Split do 0022 e semântica
*Veredito:* **FORTE (Deficiência de Especificação)**  
*Evidência:* `usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L182`  
*Análise:* O plano de split do firewall 0022 é filosoficamente correto (morando no canônico sob `methodology/` e sendo distribuído via snapshot). No entanto, o texto final adaptado não foi rascunhado no plano. Como a regra trata de segurança contra processos descontrolados de IAs, qualquer reescrita ad-hoc pelo executor humano na etapa R3 corre o risco de introduzir deriva semântica. Para sanar este gap, o texto exato do split foi desenhado e anexado a este parecer (ver Anexo A).

### 3. §3.1/3.2 — Determinismo dos Manifests
*Veredito:* **OK**  
*Evidência:* `usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L238-L265`  
*Análise:* A serialização do JSON com chaves ordenadas (`sort_keys=True`) e sem espaçamento (`separators=(',', ':')`) garante determinismo de bit. A ordenação por bytes UTF-8 no Python é robusta. O arquivo binário `.docx` tem seu hash sha256 e tamanho gravados de forma binária limpa (`open(p, 'rb')`), blindando-o contra quebras de line-ending e preservando o determinismo.

### 4. §3.3 — Guard de Snapshot e Rename/Delete
*Veredito:* **BLOQUEADOR (Quebra de CI)**  
*Evidência:* `usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L342`  
*Análise:* A lógica do pre-commit em extrair blobs staged do index usando `--diff-filter=ACMRD` funciona corretamente e cobre rename/delete. Contudo, a linha `if ! bash ~/Projetos/usehbn/bin/usehbn-verify.sh --target "$TMP"; then` assume que a máquina executora possui o repositório usehbn clonado exatamente na home do usuário. Isso é falso para servidores de CI (ex: GitHub Actions), onde o script de validação de PRs do repositório `Credenciamento` quebrará com erros de "arquivo não encontrado", inviabilizando a esteira de build do produto. É imperativo vendorizar a biblioteca.

### 5. §5.2 — Globs no forbidden-paths e tombstone
*Veredito:* **FORTE (Quebra do runbook)**  
*Evidência:* `usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L559-L563`  
*Análise:* O glob `usehbn/*` bloqueia a escrita/adição de qualquer arquivo abaixo do tombstone. No passo R8, o runbook tenta excluir a pasta legada, criar o `README.md` tombstone e atualizar o `.hbn/forbidden-paths.txt` na mesma etapa de git add/commit. O guard local `forbid-legacy-paths.sh` lerá o arquivo alterado e abortará o commit porque o README.md tombstone adicionado colidirá com a trava `usehbn/*` que está sendo staged no mesmo commit.

### 6. §7-T3 — Teste Cognitivo
*Veredito:* **OK**  
*Evidência:* `usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L487-L488`  
*Análise:* O teste cognitivo T3 com gabarito rígido de 3 perguntas é o critério de aceitação definitivo para garantir a sanidade conceitual de IAs futuras, mitigando validações de teatro observadas em ciclos anteriores.

---

## Tabela de Escopo (§0-§10)

| Seção | Veredito | Gravidade | Análise / Evidência |
|---|---|---|---|
| §0 Diff | OK | - | Números do diff 5-estados reproduzidos de forma independente e validados: 0 IGUAL, 1 DIVERGE, 106 SÓ-CÓPIA, 3 FORA-DA-MATRIZ, 30 SÓ-CANÔNICO. |
| §1 Propriedade | FORTE | Grave | O split do 0022 foi planejado sem especificar o texto genérico final, criando risco de deriva de segurança (F-02). |
| §2 Completude | MARGINAL | Nota | A nota de 107 arquivos em §2 apresenta redundância matemática devido a dupla contagem dos 3 lixos (já excluídos de SÓ-CÓPIA) (F-04). |
| §3 Scripts MD-I | BLOQUEADOR | Crítico | Guard absoluto `~/Projetos/usehbn/bin/usehbn-verify.sh` quebra o CI da aplicação consumidora em ambientes de integração (F-01). |
| §4 Snapshot | OK | - | Contornos e exclusão correta de radar/, auditoria/ e subpastas operacionais. |
| §5 Tombstone | OK | - | Correção da read-list em AGENTS.md e tombstone README previstos corretamente. |
| §6 Router | OK | - | Router no topo de AGENTS.md e forbidden-paths criam barreiras cognitivas e mecânicas robustas. |
| §7 Validação | OK | - | Suite T1-T4 bem desenhada. |
| §8 Gatilho | OK | - | Dono (Maurício) e gatilho temporal (30/06/2026) evitam decisões perenes órfãs. |
| §9 Runbook | FORTE | Grave | O passo R8 causa colisão no pre-commit por comitar o README do tombstone e as regras de bloqueio na mesma etapa (F-03). |
| §10 State | OK | - | Transição de bastão e atribuição cross-família do STATE.md estão corretas. |

---

## Findings por Severidade

### [BLOQUEADOR] F-01: Quebra de CI no guard de snapshot
* **Arquivo:** [20260610-233218-fable5-ponte-consolidada.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L342)  
* **Evidência:** `if ! bash ~/Projetos/usehbn/bin/usehbn-verify.sh --target "$TMP"; then`  
* **Descrição:** O guard `assert-snapshot-integrity.sh` chama o script de verificação canônico usando o path absoluto da home de desenvolvimento (`~/Projetos/usehbn`). Em ambientes de Integração Contínua (CI), onde a aplicação consumidora é testada de forma isolada, este caminho não existirá, fazendo a validação quebrar incondicionalmente e travando o pipeline.  
* **Recomendação:** Vendorizar a lógica de verificação copiando o script verify canônico para dentro do repositório `Credenciamento` (ex: `scripts/lib/usehbn-verify-lib.sh`) e invocá-lo localmente na checagem.

### [FORTE] F-02: Risco de Deriva Semântica no Split do Firewall (0022)
* **Arquivo:** [20260610-233218-fable5-ponte-consolidada.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L182)  
* **Evidência:** `corpo = 0022 atual §"A regra"+§"Por quê"+§"Consequências práticas" genéricas`  
* **Descrição:** A divisão da regra de firewall (0022) entre genérica (usehbn) e local (VBA/Credenciamento) não foi textualmente explicitada. Por se tratar de uma diretiva de segurança crítica que restringe a escrita autônoma por IAs, deixar a redação para a fase de aplicação (R3) pode introduzir distorções.  
* **Recomendação:** Adotar verbatim a minuta de split fornecida no Anexo A deste documento.

### [FORTE] F-03: Bloqueio do commit R8 pelo pre-commit local
* **Arquivo:** [20260610-233218-fable5-ponte-consolidada.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L559-L563)  
* **Evidência:** `git rm -r usehbn/ && mkdir usehbn ... git add -A && git commit -m ...`  
* **Descrição:** No passo R8, ao comitar a nova regra do forbidden-paths (`usehbn/*`) junto com o novo `usehbn/README.md` tombstone, o pre-commit `forbid-legacy-paths.sh` interceptará a alteração e abortará o commit por detectar que o README.md tombstone está sob o glob de bloqueio.  
* **Recomendação:** Dividir o passo R8 em duas subetapas de commit: (1) `R8.a`: remover a pasta usehbn/ e criar o README.md tombstone, realizando o commit; (2) `R8.b`: adicionar as travas `usehbn/*` e `usehbn/**` ao `.hbn/forbidden-paths.txt` e realizar o commit. Como o README já estará commitado no passo anterior, ele não estará na lista `STAGED` (ACMR) e o commit passará sem violar o guard.

### [MARGINAL] F-04: Inconsistência Matemática no Total de Arquivos
* **Arquivo:** [20260610-233218-fable5-ponte-consolidada.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L186-L188)  
* **Evidência:** `Total que ENTRA no canônico: 107 arquivos (106 SÓ-CÓPIA − 3 lixo...`  
* **Descrição:** A conta matemática descrita em §2 subtrai 3 lixos dos 106 SÓ-CÓPIA. Contudo, os 106 arquivos de SÓ-CÓPIA já excluíam os lixos (que constavam em FORA-DA-MATRIZ no diff mecânico). A matemática exata de arquivos copiados da origem é 101. Com a criação de 1 arquivo novo e 1 template, o total real de arquivos novos inseridos no repositório canônico é 103. Os comandos de R2 do runbook estão operacionais e corretos.  
* **Recomendação:** Corrigir a nota conceitual do plano para 103 arquivos finais.

### [MARGINAL] F-05: Falta de tratamento de erro amigável em caso de manifest ausente
* **Arquivo:** [20260610-233218-fable5-ponte-consolidada.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L282)  
* **Evidência:** `m = json.load(open(os.path.join(snap, 'PROTOCOL_MANIFEST.json')))`  
* **Descrição:** Se o manifesto do protocolo for deletado do snapshot por acidente, o script `usehbn-verify.sh` gerará um crash python por FileNotFoundError puro em vez de emitir aviso limpo de erro.  
* **Recomendação:** Adicionar verificação prévia de existência de `PROTOCOL_MANIFEST.json` com mensagem de erro limpa e retorno exit code 2.

### [MARGINAL] F-06: Brecha de deleção total do snapshot
* **Arquivo:** [20260610-233218-fable5-ponte-consolidada.md](file:///Users/macbookpro/Projetos/usehbn/.hbn/proposals/20260610-233218-fable5-ponte-consolidada.md#L339)  
* **Evidência:** `if [ ! -d "$TMP/$PREFIX" ]; then exit 0; fi`  
* **Descrição:** Se um commit remover por completo a pasta `.usehbn-snapshot/` do índice, o guard `assert-snapshot-integrity.sh` passará com sucesso sem reportar erro, pois a pasta temporária não conterá o prefixo.  
* **Recomendação:** Apenas registrar este comportamento como uma limitação de segurança assumível, mitigada por validações de tempo de execução da aplicação.

---

## Checklist Anti-Viés

* **B1. Li os artefatos eu mesmo, sem confiar no resumo do handoff/STATE?**  
  *Resposta:* Sim. Li integralmente o `STATE.md`, o plano consolidado de ponte, as ADRs (002, 003, 008-v2, 006, 011, 024) e os scripts propostos.
* **B2. Verifiquei de forma independente as alegações de teste do implementador?**  
  *Resposta:* Sim. Rerodei o diff de 5 estados em Python de forma independente e validei as contagens de arquivos linha a linha, batendo exatamente com a distribuição física.
* **B3. Procurei ativamente razões para REPROVAR antes de aprovar?**  
  *Resposta:* Sim. Identifiquei 1 ponto bloqueador de CI em ambientes isolados, 1 quebra do próprio runbook pelo pre-commit e 1 gap de documentação de segurança.
* **B4. Se encontrei zero contradição com o implementador, re-examinei por suspeita de leniência?**  
  *Resposta:* Não se aplica (foram identificadas contradições e falhas graves).
* **B5. Alguma das minhas recomendações preserva a minha relevância como ferramenta? Qual?**  
  *Resposta:* Nenhuma. Todas as correções focam na estabilidade do CI e na independência operacional das ferramentas locais do repositório consumidor.
* **B6. Confirmo que auditar não me dá o bastão: não propus assumir a próxima ação.**  
  *Resposta:* Confirmado. A próxima ação continua sob governança humana (Maurício) para hearback e correções do autor.

---

## Recomendação por Hearback

* **H1 (Maurício):** Assinar e confirmar a aplicação do **VETO provisório** à proposta consolidada `20260610-233218-fable5-ponte-consolidada.md` até que os ajustes de F-01, F-02 e F-03 sejam incorporados pelo autor (Anthropic).
* **H2 (Remediação F-01):** Modificar o guard `assert-snapshot-integrity.sh` para apontar e utilizar um verify local (vendorizado) dentro de `Credenciamento/scripts/lib/` em vez de depender de paths da home de desenvolvimento.
* **H3 (Remediação F-02):** Validar os textos divididos do 0022 propostos no Anexo A deste parecer.
* **H4 (Remediação F-03):** Ajustar o runbook R8 para que a alteração seja feita em dois commits sucessivos (README primeiro, trava de forbidden-paths depois), evitando travamentos de pre-commit.
* **H5 (Revisão da Matemática):** Corrigir a estimativa de novos arquivos de 107 para 103 em §2.

---

## Anexo A: Minuta de Split do Firewall (0022)

### 1. Novo arquivo canônico: `usehbn/methodology/FIREWALL-ORQUESTRACAO.md`

```markdown
---
titulo: Firewall — orquestração automática/workflows só em fast_track; escrita safe_track é humana
hbn-track: fast_track
hbn-status: active
audiencia: ambos
versao-sistema: useHBN-v0.3.0
data: 2026-06-11
---

# Firewall — workflows só `fast_track`; escrita `safe_track` é humana

> **Esta é a fonte canônica única da regra.**
> Origem: `Credenciamento/.hbn/knowledge/0022-firewall-workflow-fast-track.md`

## A regra

Orquestração automática — Dynamic Workflows, scheduled tasks, fan-out de
subagentes, qualquer run que prossiga sem hearback humano a cada passo — é
permitida no HBN **somente** para trabalho de **leitura, análise, auditoria e
diagnóstico** (`fast_track`, doc-only).

A **escrita `safe_track`** — qualquer código de domínio e aplicação de estado no
projeto — permanece:

1. **Humano-aplicada**: O operador humano é o único ponto de execução de escrita no ambiente de produção. Nenhum run autônomo aplica nada na aplicação viva.
2. **Hearback-gated**: readback com `human_status: confirmed` antes de qualquer escrita, uma onda por vez.
3. **Fora de qualquer run autônomo**: nem como "passo final" de um workflow, nem via bypass, nem por exceção de conveniência.

## Por quê

O domínio de produção (código e arquivos de dados vivos) torna a escrita errada catastrófica e de detecção tardia. O gate humano é a razão de existir do protocolo; a autonomia de workflows não pode erodi-lo.

## Consequências práticas

- Scheduled task do arquiteto: permitida — produz readback e para; nunca executa sem hearback.
- Workflow que proponha "aplicar o delta automaticamente" ou commitar código de domínio: violação — responder com ❌ HBN SECURITY BLOCKED SUGGESTION e parar.
- Violação observada por qualquer IA deve ser registrada em `.hbn/protocol-evolutions/` ou logs de incidente do protocolo.
```

### 2. Novo arquivo de binding local: `Credenciamento/.hbn/knowledge/0022-firewall-workflow-fast-track.md`

```markdown
---
titulo: Firewall — orquestração automática/workflows só em fast_track; escrita safe_track é humano-aplicada (binding local)
data: 2026-06-05
autoria: claude-opus (modo arquiteto, onda 0115/G1); decisão de Mauricio no hearback 0145
aplica-a: toda IA, todo run autônomo, todo workflow/organização automática operando em qualquer projeto sob o protocolo HBN
revisar-em: 2026-12-05
---

# Firewall — workflows só `fast_track`; escrita `safe_track` é humana (Credenciamento)

> **Fonte canônica genérica:** `.usehbn-snapshot/methodology/FIREWALL-ORQUESTRACAO.md`.
> Este arquivo contém a especificação e consequências locais para o projeto Credenciamento.

## A regra local

A regra genérica descrita na fonte canônica é integralmente aplicável ao Credenciamento. No contexto local:
- **safe_track**: refere-se a alterações em `src/vba/`, `local-ai/vba_import/` e na planilha `PlanilhaCredenciamento-*.xlsm`.
- **Humano-aplicada**: Mauricio é o executor físico (rodar Importador V3, compilar, testar via macros).

## Consequências locais

- Piloto G2/EW-3 (auditoria cruzada via workflow Claude-only): permitido — é leitura/auditoria, doc-only.
- Scheduled task do arquiteto: permitida.
- Qualquer escrita autônoma no workbook ou commits em `src/vba/` por workflows sem o gate humano é uma violação de segurança.
```
