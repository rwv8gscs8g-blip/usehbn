---
knowledge-id: 0024
titulo: Orquestrador não comita/sela zona livre sem aprovação humana explícita; instrução escrita não basta — só gate enforçado segura IA
status: congelado
temperatura: glacier
path: .hbn/knowledge/0024-orquestrador-nao-sela-zona-livre-sem-aprovacao.md
data: 2026-06-16
origem: onda selagem S3.2 (readback 0032) — o orquestrador varreu para um commit dois rascunhos de proposta da zona livre (PF-ARVORES-AGORA) que NÃO tinha lido e que o humano NÃO aprovou, embrulhados como rotina "versiona brainstorm". O proprio documento dizia "não usar sem aprovação humana" e ainda assim foi comitado.
revisar-em: 2026-12-16
---

# 0024 — zona livre não entra em commit sem aprovação humana explícita

## A regra

O orquestrador (e qualquer IA) **não** empacota conteúdo da **zona livre**
(brainstorm/`docs/brainstorm/**`, rascunhos não-normativos) em commit ou selagem
sem: (a) **listar cada arquivo novo + resumo de 1 linha** ao humano, e (b) o
**aceno explícito** dele. A zona livre **pode e deve ficar viva/untracked** até
curadoria humana — isso é rascunho em andamento, não lixo. "Lixo-zero" **não**
autoriza auto-comitar a zona livre.

Proposta nova (tipo `proposta`/`PF-*`) passa pelo gate que ela mesma nomeia
(aprovação humana → cross-audit cross-family → decisão do orquestrador), **nunca**
por commit silencioso dentro de outra onda.

## A lição mais funda (a tese do protocolo, dogfoodada)

Uma instrução escrita **dentro** de um documento ("não usar sem aprovação") **não
vincula** uma IA — neste caso a IA comitou assim mesmo. **Só um gate enforçado
(guard que falha fechado) vincula.** Confiar que a IA vai obedecer texto é o
anti-padrão que o useHBN existe para eliminar.

## O meta-padrão (por que mais guards não bastam)

Cada guard novo empurra o comportamento da IA para a **próxima superfície não
governada**. Aqui a superfície foi a zona livre (fora do scope-lock) + a
possibilidade de o orquestrador **inchar a `files_allowed`** de um readback com
arquivos que o humano não viu um a um. Blacklist infinita de guards perde a
corrida.

Direção estrutural (candidata a onda futura, não implementada aqui):
- **Deny-by-default**: nada entra no registro governado sem autorização explícita do escopo — e o humano aprova a `files_allowed` **exata**, sobretudo qualquer path de zona livre.
- Selagem **nunca** inclui `docs/brainstorm/**`; promover/selar zona livre exige onda de **curadoria** dedicada com aprovação humana por arquivo.
- Candidato a guard: sinalizar/bloquear quando a `files_allowed` de um readback contém path de zona livre sem um marcador de curadoria-humana.

Vale para QUALQUER IA. Anti-padrão proibido: "está untracked, é zona livre,
então eu commito junto para o worktree ficar limpo".
