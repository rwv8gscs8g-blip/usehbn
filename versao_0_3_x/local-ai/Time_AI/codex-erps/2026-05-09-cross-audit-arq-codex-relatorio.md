# Cross-Audit Arquitetural Codex — 2026-05-09

Marker atual: 🔍 HBN CROSS-AUDIT IN PROGRESS

Marker proposto pós-aprovação: 🤝 HBN CROSS-AUDIT APPROVED

## 1. Sumário executivo

Recomendação técnica: **mono-repo canônico com opção híbrida de espelhos/release repos**. O repositório `usehbn` deve concentrar protocolo, módulos, documentação canônica, crates Rust e POCs Python. Poly-repos devem existir só quando um módulo tiver ciclo de release, mantenedores, versão e comunidade realmente independentes. O argumento do operador se sustenta para contexto de IA e revisão por path; não se sustenta como “permissão por pasta” forte, porque GitHub CODEOWNERS exige review por path mas não concede ACL nativa de escrita por subpasta.

Tipologia recomendada: **Credenciamento é caso fundador + aplicação consumidora**, não módulo formal. Ele gerou evidência e hoje abriga fonte canônica por contingência histórica. A fonte canônica do protocolo deve migrar para `usehbn`; Credenciamento deve manter código, auditorias do sistema e links/snapshots.

Simplificação documental: usar **Diataxis + ADR**. `modules/*.md` vira referência normativa curta por módulo. `methodology/*.md` fica para princípios e explicações transversais. `auditoria/00_status/` vira tracking histórico particionado por frente. Documentos V1 não devem ser apagados: devem ser marcados `superseded` ou `deprecated` com link para a fonte atual.

## 2. Q1 — Mono-repo vs poly-repo

### Recomendação

Adotar **mono-repo canônico híbrido**:

- `usehbn/` como repositório público canônico.
- `usehbn/modules/<modulo>/` para specs e POCs de módulos.
- `usehbn/crates/<crate>/` para crates Rust do substrato.
- `usehbn/packages/<package>/` ou `usehbn/modules/<modulo>/poc/` para POCs Python.
- `usehbn/docs/adr/` para decisões arquiteturais.
- Repos separados só como espelhos/release repos quando houver maturidade real.

Esta decisão alinha melhor com:

- Cargo workspace para múltiplos crates Rust.
- CI por path.
- CODEOWNERS por path.
- Busca local e contexto de IA.
- Migração simples do skeleton `usehbn-phago`.

### Alternativa 1 — Poly-repo puro

Modelo: `usehbn`, `usehbn-phago`, `usehbn-capsules`, `usehbn-otel-rust`, `usehbn-coord`.

Vantagens:

- Permissão forte por repo.
- Release independente por módulo.
- Menor risco de acoplamento acidental entre módulos.

Custos:

- Mais overhead de CI, issues, releases e versionamento.
- IAs precisam múltiplos checkouts.
- Dependências locais viram path-deps ou packages publicados.
- Docs canônicos tendem a divergir.
- Submodules pioram ergonomia: Git registra gitlinks fixos e exige `--recurse-submodules` para clone, grep, pull e CI coerentes.

Veredito: cedo demais para o useHBN. Útil depois, se um módulo crescer como projeto independente.

### Alternativa 2 — Mono-repo puro

Modelo: tudo dentro de `usehbn`, sem repos separados.

Vantagens:

- Melhor contexto para IAs.
- Uma fonte de verdade.
- Cargo workspace direto.
- GitHub Actions por path.
- CODEOWNERS por path.
- Menos sincronização manual.

Custos:

- Permissão por pasta não é ACL forte.
- Risco de “mono-pile” se `modules/`, `methodology/`, `audits/` e `case-studies/` não forem separados.
- Releases independentes exigem disciplina de tags e changelogs por módulo.

Veredito: tecnicamente melhor como fonte canônica inicial.

### Alternativa 3 — Híbrido recomendado

Modelo: mono-repo canônico + espelhos/release repos quando necessário.

Vantagens:

- Preserva contexto e fonte única.
- Permite separar módulos maduros no futuro.
- Não bloqueia release independente.
- Mantém reversibilidade.

Custos:

- Precisa regra explícita: “repo canônico vs espelho”.
- Precisa evitar que espelhos voltem a virar fonte de verdade.

Veredito: melhor encaixe para 2026-05-09.

### Tooling

Rust:

- Cargo workspace é o encaixe natural. A documentação oficial define workspace como coleção de pacotes geridos juntos, com `Cargo.lock` e `target` compartilhados.
- Layout sugerido:

```text
Cargo.toml
crates/
  usehbn-core/
  usehbn-markers/
  usehbn-capsules/
  usehbn-phago/
```

Python:

- Usar `pyproject.toml` PEP 621 por POC/pacote.
- Como `uv` está arquivado por decisão P11/P12, não reabrir uv para implementação agora.
- Tecnicamente, `uv workspace` é adequado para monorepos Python, mas seria mudança de decisão.
- Curto prazo: `python -m venv .venv`, `pip install -e modules/<modulo>/poc` quando necessário.

Pre-commit:

- Um root `.pre-commit-config.yaml`.
- Hooks por `files`.
- Exemplo conceitual:

```yaml
files: ^modules/consent-capsules/poc/
```

CODEOWNERS:

- Útil para review automático por path.
- Não é permissão de escrita por pasta.
- GitHub exige que owners tenham write access no repo.
- Combinar com branch protection ou rulesets.

CI:

- Usar `paths`/`paths-ignore` em GitHub Actions.
- Melhor ainda: job agregador que sempre roda e decide jobs específicos via paths-filter.
- Cuidado: checks skipped por path filter podem ficar `Pending` se marcados como required.

Submodules/subtree:

- Submodule é ruim como divisão artificial de código coevolutivo.
- Subtree é aceitável para incorporar `usehbn-phago` no mono-repo preservando histórico.
- Se histórico não importa: copiar diretórios é mais barato e claro.

### Padrões open-source comparáveis

- **Cargo workspaces**: padrão oficial Rust para múltiplos pacotes geridos juntos.
- **Bevy**: engine Rust modular em mono-repo; módulos/crates coevoluem.
- **Tokio**: ecossistema Rust com crates separados e crates coevolutivos; bom alerta para separar só quando ciclo de release justificar.
- **Apache Airflow 3.2.0**: repo grande Python com core, Task SDK e providers; distribuição pode ser modular sem exigir repo separado para cada unidade.
- **Babel 7.28.5**: monorepo declarado com muitos pacotes npm.

## 3. Q2 — Tipologia módulo × aplicação

### Recomendação

Adotar tipologia:

- **Protocolo**: specs, princípios, marcadores, formatos, gates.
- **Implementação de referência**: crates/CLI/libs que implementam partes do protocolo.
- **Módulo do protocolo**: capacidade genérica e reutilizável do useHBN.
- **Aplicação consumidora**: software real que usa o protocolo.
- **Caso fundador**: aplicação ou contexto histórico onde o protocolo emergiu.

Credenciamento V12.0.0203 deve ser classificado como:

```text
caso fundador + aplicação consumidora
```

Não deve ser módulo.

### Hipótese A — Credenciamento é aplicação

Encaixe técnico bom após migração.

Prós:

- Separa código VBA de protocolo.
- Permite `usehbn` como fonte canônica.
- Evita que regras específicas de Credenciamento contaminem specs gerais.

Contras:

- Apaga parte da origem histórica se for dito apenas “aplicação”.
- Não explica por que `Credenciamento/usehbn/` contém hoje source-of-truth.

Veredito: correta operacionalmente, incompleta historicamente.

### Hipótese B — Credenciamento é módulo

Encaixe técnico ruim.

Problema central: módulo do useHBN deve ser capacidade genérica. Credenciamento é um sistema de domínio específico em VBA.

Se Credenciamento virar módulo, o protocolo mistura:

- domínio municipal brasileiro;
- importação VBA;
- regras M11/G7/G8;
- documentação do protocolo;
- aplicação de produção.

Isso degrada a fronteira entre protocolo e consumidor.

Veredito: rejeitar.

### Hipótese C — Credenciamento é caso fundador

Melhor encaixe técnico.

Explica simultaneamente:

- por que Credenciamento contém hoje docs canônicos;
- por que suas lições informam Segurança, Fagocitose e Marcadores;
- por que o código VBA não é parte do protocolo;
- por que deve haver migração para `usehbn`.

Tratamento recomendado:

```text
usehbn/
  case-studies/
    credenciamento.md
```

Ou:

```text
usehbn/docs/case-studies/credenciamento.md
```

Este documento deve apontar para:

- evidências no repo Credenciamento;
- lições L1-L18;
- M11;
- Glasswing G1-G8;
- markers usados em produção.

### Precedentes

HTTP:

- RFC 9110 define semântica, papeis e extensões.
- nginx/curl implementam ou usam HTTP.
- Wikipedia consome HTTP.
- Nenhuma aplicação vira “módulo do HTTP”.

LSP:

- LSP 3.17 define protocolo cliente-servidor.
- rust-analyzer é language server.
- VS Code é host/client.
- Um projeto Rust analisado por rust-analyzer não vira parte do protocolo.

MCP:

- MCP separa specification, SDKs, development tools e reference servers.
- Host, client e server são papeis formais.
- Um MCP server específico não redefine o protocolo.

## 4. Q3 — Simplificação documental

### Padrão recomendado

Usar três camadas:

1. **Reference normativa**
   - `modules/*.md`
   - schemas
   - markers
   - comandos

2. **Explanation / arquitetura**
   - `methodology/*.md`
   - princípios
   - modelo das 3 árvores
   - arquitetura multi-braço

3. **Decision / histórico**
   - `docs/adr/*.md`
   - `auditoria/status/<frente>/`
   - documentos superseded/deprecated

Diataxis resolve a mistura atual: reference não deve carregar narrativa de processo; explanation não deve virar segunda spec; auditoria não deve ser fonte canônica.

### Ações concretas

| Path | Ação | Justificativa |
|---|---|---|
| `usehbn/methodology/PRINCIPIOS-CONSTITUCIONAIS.md` | manter | Fonte canônica dos 13 princípios. |
| `usehbn/methodology/THREE-TREES-ARCHITECTURE.md` | manter | Arquitetura transversal; ajustar para “por módulo”. |
| `usehbn/methodology/USEHBN-MODULES-ARCHITECTURE.md` | renomear/atualizar | Corrigir poly-repo se mono-repo for confirmado; registrar ADR. |
| `usehbn/methodology/MINIMALISM-PRINCIPLE.md` | manter | P11. |
| `usehbn/methodology/SUBSTRATO-SOLIDO-PRINCIPLE.md` | manter | P12. |
| `usehbn/methodology/AI-LANGUAGE-ABSTRACTION-PRINCIPLE.md` | manter | P13. |
| `usehbn/methodology/LANGUAGE-PLATFORM-COMPARISON.md` | arquivar | Rust já decidido; manter como histórico. |
| `usehbn/methodology/RADAR-PHAGOCYTOSIS-PIPELINE.md` | fundir | Conteúdo pertence a `modules/RADAR.md` + `modules/FAGOCITOSE.md`. |
| `usehbn/methodology/INCORPORATION-PROGRESSIVE-PLAN.md` | fundir | Fases F0-F5 pertencem ao módulo Fagocitose. |
| `usehbn/methodology/INTER-CHAT-COORDINATION.md` | fundir | Fonte única deve ser `modules/COORDENACAO-INTER-IA.md`. |
| `usehbn/methodology/CROSS-IA-AUDIT-PROTOCOL.md` | fundir | Fonte única deve ser `modules/AUDITORIA-CRUZADA.md`. |
| `usehbn/methodology/RADAR-WEEKLY-REVIEW-PROTOCOL.md` | fundir | Subcomponente do Radar. |
| `usehbn/modules/INDEX.md` | manter | Índice canônico dos módulos. |
| `usehbn/modules/RADAR.md` | manter | Spec curta do módulo Radar. |
| `usehbn/modules/FAGOCITOSE.md` | manter | Spec curta do módulo Fagocitose. |
| `usehbn/modules/CAPSULAS-DE-CONSENTIMENTO.md` | manter | Spec curta do módulo Cápsulas. |
| `usehbn/modules/COORDENACAO-INTER-IA.md` | manter | Spec curta do módulo Coordenação. |
| `usehbn/modules/SEGURANCA.md` | manter | Spec curta do módulo Segurança. |
| `usehbn/modules/MARCADORES.md` | manter | Spec curta do módulo Marcadores. |
| `usehbn/modules/AUDITORIA-CRUZADA.md` | manter | Spec curta do módulo Auditoria Cruzada. |
| `auditoria/00_status/38_USEHBN_TESE_FAGOCITOSE_INTEGRADA.md` | deprecar formalmente | V1 histórica; superseded por V2 multi-braço. |
| `auditoria/00_status/41_DECISOES_5_TECNOLOGIAS_EM_CURSO.md` | manter histórico | Fonte de decisões de 2026-05-06; não virar spec. |
| `auditoria/00_status/42_ROADMAP_CONSENT_CAPSULES_RUST.md` | manter roadmap | Roadmap operacional; depois converter partes estáveis em spec/ADR. |
| `auditoria/00_status/43_PLANO_DOCUMENTACAO_V2_USEHBN.md` | manter até execução | Plano de migração, não spec final. |
| `auditoria/00_status/44_CORRECAO_USEHBN_E_CONSOLIDACAO.md` | fundir nas fontes | Correção deve entrar em docs canônicos; arquivo fica histórico. |
| `auditoria/00_status/45_TRANSCRICAO_SESSAO_2026-05-06.md` | manter histórico | Evidência, não spec. |
| `auditoria/00_status/46_PROMPT_UNIFICADO_CODEX.md` | manter histórico | Prompt operacional; não spec. |
| `HBN-ARCHITECTURAL-REVIEW-2026-04.md` | arquivar | Pré multi-braço; histórico. |
| `ROADMAP.md` | atualizar | Provavelmente obsoleto parcial pós multi-braço. |
| `GOVERNANCE.md` | manter | Documento open-source operacional. |
| `MAINTAINERS.md` | manter | Complementar com CODEOWNERS. |
| `CONTRIBUTING.md` | manter/atualizar | Deve apontar para layout novo. |
| `SECURITY.md` | manter/atualizar | Linkar módulo Segurança, sem duplicar spec. |
| `CODE_OF_CONDUCT.md` | manter | Documento público operacional. |
| `SUPPORT.md` | manter | Documento público operacional. |
| `CHANGELOG.md` | manter | Histórico de release. |

### Conflito de numeração 43/44/45

Não renumerar arquivos existentes. Renumeração destrói referência histórica e quebra links.

Solução técnica:

```text
auditoria/
  status/
    F1-credenciamento/
      2026-05-03-43-handoff-test-first.md
    F2-usehbn/
      2026-05-06-43-plano-documentacao-v2-usehbn.md
```

Ou, se mover arquivos for sensível:

```text
43_F1_HANDOFF_...
43_F2_PLANO_...
```

Melhor padrão para frente:

- ADRs: `docs/adr/usehbn/ADR-0001-mono-repo-canonico.md`
- Status operacional: `auditoria/status/<frente>/YYYY-MM-DD-<slug>.md`
- Índice histórico: mapa de arquivos antigos conflitantes.

### Tratamento da tese 38

Recomendação: **deprecar formalmente e preservar histórico**.

Não reescrever. Não apagar. Adicionar status:

```yaml
status: superseded
superseded-by: <doc V2 multi-braco>
```

Este padrão segue a lógica de W3C: specs superseded/obsolete continuam disponíveis, mas não são recomendadas para nova implementação.

## 5. Roadmap técnico de migração se mono-repo for confirmado

### Semana 1 — Decisão e ADR

- Criar `docs/adr/ADR-0001-mono-repo-canonico-usehbn.md`.
- Registrar que `usehbn` é fonte canônica.
- Definir `usehbn-phago` como skeleton transitório/superseded ou espelho.
- Definir regra: Credenciamento é caso fundador + aplicação consumidora.

### Semana 2 — Layout alvo

Criar estrutura alvo no `usehbn`:

```text
methodology/
modules/
radar/
audits/
case-studies/
docs/adr/
crates/
packages/
local-ai/Time_AI/
```

Adicionar `.github/CODEOWNERS` planejado.

### Semana 3 — Migração documental

- Copiar `Credenciamento/usehbn/methodology`.
- Copiar `Credenciamento/usehbn/modules`.
- Copiar `Credenciamento/usehbn/radar`.
- Copiar `Credenciamento/usehbn/audits`.
- Criar `case-studies/credenciamento.md`.
- Manter hashes de origem.

### Semana 4 — Consolidação de duplicados

- Fundir pares duplicados.
- Marcar documentos superseded.
- Atualizar índices.
- Não apagar históricos.

### Semana 5 — Skeleton técnico

- Incorporar `usehbn-phago/modules/*` como base ou descartar se redundante.
- Criar `Cargo.toml` workspace virtual se já houver crate Rust.
- Criar templates Python POC por módulo, sem uv.
- Definir padrão de README por módulo.

### Semana 6 — CI e ownership

- Adicionar CODEOWNERS.
- Adicionar CI por paths.
- Adicionar checks agregadores.
- Adicionar pre-commit por path.

### Semana 7 — Credenciamento como consumidor

- Substituir docs canônicos dentro de Credenciamento por links/snapshots.
- Manter evidências operacionais e auditorias de Credenciamento.
- Garantir que M11 continua intocada: `src/vba/` é fonte, `local-ai/vba_import/` é espelho.

### Semana 8 — Fechamento

- ERP de migração.
- Auditoria cruzada Opus/Codex/Antigravity.
- Decisão de Maurício sobre arquivar, manter ou transformar `usehbn-phago` em espelho.

## 6. Riscos técnicos não listados em outros lugares

- **Falso senso de permissão por pasta**: CODEOWNERS não bloqueia escrita; só exige revisão se branch protection/rulesets estiverem corretos.
- **CI filtrado mal desenhado**: required checks podem ficar pending quando workflows são skipped.
- **Mistura de docs e specs**: se `auditoria/00_status` continuar sendo fonte de decisão viva, a duplicação volta.
- **Rust workspace cedo demais**: criar crates antes de haver API mínima pode cristalizar fronteiras erradas.
- **Python sem isolamento por POC**: POCs Python em mono-repo podem vazar dependências; usar venvs e requirements/pyproject por POC.
- **Submodules como solução de contexto**: submodules reduzem contexto por padrão; exigem flags e disciplina.
- **Caso fundador virando autoridade normativa**: Credenciamento deve informar o protocolo, não governá-lo.
- **Nome `usehbn-phago`**: após Esteira 5, o repo contém múltiplos módulos; o nome é semanticamente errado se mantido como repo de todos os módulos.

## Referências consultadas

- Cargo workspaces: https://doc.rust-lang.org/cargo/reference/workspaces.html
- GitHub CODEOWNERS: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners
- GitHub Actions path filters: https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow
- PEP 621: https://peps.python.org/pep-0621/
- uv workspaces: https://docs.astral.sh/uv/concepts/projects/workspaces/
- Git submodules: https://git-scm.com/docs/gitsubmodules.html
- HTTP Semantics RFC 9110: https://www.ietf.org/rfc/rfc9110.html
- LSP: https://microsoft.github.io/language-server-protocol/
- MCP architecture: https://modelcontextprotocol.io/specification/2025-11-25/architecture
- Diataxis: https://diataxis.fr/
- W3C superseded/obsolete/rescinded specs: https://www.w3.org/guide/process/obsolete-rescinded-supserseded.html
- Babel: https://github.com/babel/babel
- Bevy: https://github.com/bevyengine/bevy
- Apache Airflow: https://github.com/apache/airflow
