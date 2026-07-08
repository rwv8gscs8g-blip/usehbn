---
titulo: Distribution Model
tipo: knowledge
status: accepted
temperatura: quente
path: .hbn/knowledge/distribution-model.md
created_at: "2026-07-05T02:30:00-03:00"
autor: fable-5
familia: Anthropic
natureza: migrado
migrado_de: v0.3.x
id_original: .hbn/knowledge/distribution-model.md
created_at_original: "2026-07-05T02:30:00-03:00"
autor_original: fable-5
transcrito_em: "2026-07-05T02:30:00-03:00"
transcrito_por: fable-5
validacao_ref: 0003-proveniencia-livro-razao
---
# Distribution Model

Decisoes atuais da fase 2:

- `get-hbn` e um bootstrap local do checkout, nao um instalador remoto
- `hbn inspect` serve como leitura rapida de estado local, packaging e adapters
- `hbn install --runtime ...` gera artefatos de filesystem por runtime
- `pyproject.toml` prepara o empacotamento, mas a publicacao publica continua dependente da validacao do nome do pacote

Racional:

- evitar promessas irreais de distribuicao global antes da validacao publica
- manter bootstrap offline e previsivel
- separar adaptadores de runtime da logica central do protocolo
