---
titulo: "Handoff da selagem da faxina 0027"
tipo: handoff
status: congelado
temperatura: glacier
path: .hbn/messages/20260616-032113-codex-handoff-selagem-faxina.md
id-global: 20260616-032113-codex-handoff-selagem-faxina
autor: codex
readback: .hbn/readbacks/0028-selagem-faxina-lixo-zero.json
created_at: "2026-06-16T03:21:13-03:00"
---

RELATO DE ESTADO — codex · implementador · 2026-06-16T03:21:13-03:00
STATE: ultima_atualizacao=2026-06-16T03:21:13-03:00
PRÓXIMA AÇÃO: Definir S3: hardening prosa-trailer do G-EXC e evolução do protocolo.

# Handoff da selagem da faxina 0027

## Feito

- C1 abriu `.hbn/readbacks/0028-selagem-faxina-lixo-zero.json` e registrou nascimento no REGISTRY.
- C2 depositou os dois pareceres cross-audit da faxina 0027; o parecer Cursor foi normalizado para ter front matter parseavel e manter `APROVA_0027: SIM` como primeira linha do corpo.
- C3 selou os tres despachos do orquestrador permitidos no readback e adicionou metadados de deposito exigidos pelos guards.
- C4 versionou `docs/brainstorm/exuvia-evolucao-conceitual.md` e `docs/brainstorm/principios-candidatos.md` como zona-livre nao-normativa.
- C5 aplicou os fixes lixo-zero: `.gitignore` cobre `guards/tests/adv-cr*` e o doc-fonte dos criterios agora aponta `superseded_by: core/exuvia-fitness-criteria.md`.
- C6 atualizou o STATE, registrou as dividas rastreadas e criou este handoff dentro do escopo da onda.

## Evidencia mecanica

- `bash guards/hbn-guards-runner.sh` passou antes de cada commit C1-C6.
- `git check-ignore -v guards/tests/adv-cr.zzz guards/tests/adv-cr-x.zzz` confirmou que os dois formatos sao ignorados por `guards/tests/adv-cr*`.
- `main` permaneceu em `4db692876381a0d7909985c8500d999f2e677b04`.

## Dividas rastreadas

- G-EXC prosa-trailer: `%B` inteiro ainda aceita linhas do corpo iniciadas por `HBN-...:`; destino S3/hardening para restringir ao ultimo paragrafo de trailers.
- Convencao operacional: handoff de cada onda deve estar no `files_allowed` do readback antes da execucao.
