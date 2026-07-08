---
titulo: Parecer adversarial — AUDITORIA delta combinado ondas 0002 + 0003 (proveniência e autocontenção)
tipo: result-cross-ia-superseded
status: superseded
temperatura: frio
path: .hbn/archive/SUPERSEDED-20260706-055401-antigravity-cross-ia-0003.md
created_at: "2026-07-06T06:54:01-03:00"
autor: antigravity
familia: Google
natureza: nativo
---
SOU: antigravity · familia Google · papel auditor

# Parecer adversarial — AUDITORIA delta combinado ondas 0002 + 0003

## Veredito

APROVA_0002: SIM
APROVA_0003: SIM

---

## Evidências

Todos os testes de verificação e baterias mecânicas foram executados e obtiveram sucesso absoluto:

1. **Guards de Proveniência (`G-PROV`) e Autocontenção (`G-SELF-CONTAINED`)**:
   - `bash versao_3_0_0/guards/assert-doc-provenance.sh` executado com sucesso:
     ```text
     G-PROV OK: 58 documento(s) governado(s) com proveniencia valida.
     [hbn-guards/assert-doc-provenance] ✓ Proveniencia canonica validada.
     ```
   - `bash versao_3_0_0/guards/assert-version-self-contained.sh` executado com sucesso:
     ```text
     G-SELF-CONTAINED OK: 58 documento(s) governado(s) sem dependencia vigente externa.
     [hbn-guards/assert-version-self-contained] ✓ Autocontencao documental validada.
     ```

2. **Suíte de Testes dos Guards**:
   - `bash versao_3_0_0/guards/tests/run-guard-tests.sh` executado com sucesso, retornando resultado determinístico verde:
     ```text
     == resumo: 389 passaram, 0 falharam ==
     SUÍTE VERDE — todos os casos-ruins BLOQUEADOS, todos os casos-bons passam.
     ```

3. **Bateria Adversarial**:
   - `bash versao_3_0_0/guards/tests/adversarial-battery.sh` executado com sucesso contra 94 tentativas de evasão e bypasses:
     ```text
     BATERIA VERDE — toda burla documentada foi BLOQUEADA pelo guard correspondente.
     ```

4. **Rito de Exúvia Atômica (`scripts/hbn-exuvia-atomic.sh`)**:
   - O rito de exúvia pós-commit foi simulado e reproduzido em clone descartável fora de áreas montadas (`/Users/macbookpro/.gemini/antigravity-ide/scratch/verify_clone`), gerando o seguinte log verde:
     ```text
     [hbn-exuvia-atomic] repo=/Users/macbookpro/.gemini/antigravity-ide/scratch/verify_clone HEAD=64a2a27 ativa=versao_3_0_0 nova=versao_4_0_0 modo=--dry-run
     [hbn-exuvia-atomic] sandbox: /Users/macbookpro/.gemini/antigravity-ide/scratch/hbn-exuvia-versao_4_0_0.NF7D9O
     [hbn-exuvia-atomic/sandbox] rodando suite de testes da nova versao...
     [hbn-exuvia-atomic/sandbox] validando guards estruturais da transicao (hot-write / pending / active-integrity)...
     [hbn-exuvia-atomic/sandbox] G-HOT-WRITE bloqueou a transicao sem hearback (comportamento fail-closed correto).
     [hbn-exuvia-atomic] sandbox VERDE.
     [hbn-exuvia-atomic] DRY-RUN concluido: nada escrito no repo real. Rode com --prepare para preparar a transicao.
     ```

5. **Verificações Mecânicas de Integridade (Focos 0002/0003)**:
   - **T3 (allowlist 4b/4c) e T6**: Alinhamento estrito nas quatro camadas documentadas no G-HOT-WRITE. O bloqueio contra regressões de ponteiro para `.` (causa C2/L3) está ativo no guard e validado por testes negativos.
   - **T4 (Higiene de Quórum)**: Placeholders antigos arquivados corretamente. Resultados de auditoria cruzada sem consenso (0001) mantidos em results como untracked para evitar bloqueio por G-DIVERSITY.
   - **Proveniência e Transcrição**: Varredura manual e automação mecânica confirmam que todos os 58 documentos governados estão em paridade estrita com o manifesto de migração e com os campos de proveniência de livro-razão no front-matter YAML (ou cabeçalho comentado em arquivos `.txt`).
   - **Autocontenção**: `core/01-principios.md` possui a transcrição literal dos princípios constitutifs P1-P13. Nenhuma referência externa a glacier ou ao exoesqueleto opera como fonte vigente nas especificações da `versao_3_0_0/`.

---

## Furos

1. **Dependência de Cadeia Estática de Execução no macOS**:
   - Vários guards executam `python3` como processador para validação JSON e parsing de front-matter. Embora tolerado no macOS do operador, em ambientes altamente restritos (como contêineres mínimos de produção/CI) a ausência do interpretador causaria falha precoce ("python3 ausente"), impedindo commits.
2. **Obfuscabilidade no G-SELF-CONTAINED**:
   - A validação de autocontenção utiliza expressões regulares estáticas para pesquisar por caminhos relativos de escape (`../`) e nomes de pastas passadas. Embora robusto para documentações textuais Markdown e JSON puros, arquivos de script poderiam mascarar referências externas por meio de manipulações dinâmicas de string (ex: `'..' + '/'`), contornando a validação de texto puro se inseridos como specs.
3. **Ausência de Assinatura Criptográfica Padrão no JSON de Confirmação**:
   - O mecanismo `transition_authorized` em `assert-only-hot-version-writable.sh` verifica a existência da propriedade `human_status: confirmed` nos readbacks/hearbacks sem exigir assinatura digital atômica da chave do gate Maurício diretamente na validação em nível de script. O runner delega a garantia de autenticidade ao commit do operador e à pureza criptográfica de repositórios remotos.

---

## Confiança

**Nível de Confiança: Alto**
O delta combinado 0002 + 0003 resolve de forma robusta a segurança das transições de exúvia e formaliza um livro-razão auto-contido e auditável. As correções efetuadas para a suíte de testes em sandbox em modo dry-run impedem falhas procedimentais sem relaxar as travas mecânicas de integridade.

---

## NÃO verificado

1. Execução direta das suítes de teste nativamente em sistema operacional Linux, tendo em vista que a bateria foi rodada em ambiente macOS host.
2. Aplicação de transição de snapshot real via membrana no repositório consumidor de Credenciamento com o parâmetro `--install`, visto que este ato é de atribuição estrita do operador humano após a gravação desta auditoria.
