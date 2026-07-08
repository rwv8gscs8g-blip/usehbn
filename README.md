# useHBN

Protocolo de orquestração de IAs para desenvolvimento de software, com
enforcement mecânico (guards de shell no chokepoint de commit + CI) e
evolução por **exúvias** — cada versão do protocolo vive inteira em uma
pasta `versao_X_Y_Z/`, e a troca de versão é uma transição atômica.

## Onde está o protocolo

A raiz deste repositório é **vazia por desenho**. A versão vigente é
apontada por um único arquivo:

```bash
cat .hbn/active-version
# -> versao_3_0_0
```

Todo o protocolo vivo (porta de entrada, especificações, guards, scripts,
estado) mora em **[`versao_3_0_0/`](versao_3_0_0/)**. Comece por
[`versao_3_0_0/BOOT.md`](versao_3_0_0/BOOT.md) — é a única leitura
obrigatória de entrada (IAs: observem o BOOT-LOCK do §0 e o `AGENTS.md`
da raiz).

## História (glacier — leitura permitida, citação como norma proibida)

| Pasta | O que é |
|---|---|
| `versao_0_3_x/` | Exoesqueleto v0.3.x ("Honest Foundation") — congelado |
| `versao_2_0_0/` | Primeira exúvia (nunca ativada) — congelada |
| `versao_3_0_0/` | **Versão quente ativa** (terceira exúvia) |

Por que a terceira exúvia existe: [`versao_3_0_0/TRANSICAO.md`](versao_3_0_0/TRANSICAO.md).
Roteiro de retomada da operação: [`versao_3_0_0/ROADMAP.md`](versao_3_0_0/ROADMAP.md).

## Enforcement

Os hooks de Git desta raiz (`.git/hooks/pre-commit` e `.git/hooks/commit-msg`)
são shims mínimos: leem `.hbn/active-version` e executam o runner da versão
quente (`$(cat .hbn/active-version)/guards/hbn-guards-runner.sh`). O primeiro
guard do pre-commit é o **G-HOT-WRITE**: escrita só na versão quente, sem
variável de bypass, fail-closed.

## Licença

Ver [`versao_3_0_0/LICENSE`](versao_3_0_0/LICENSE).
