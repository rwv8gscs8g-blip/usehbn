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
