# AGENTS.md — BOOT-LOCK (raiz mínima, useHBN pós-terceira-exúvia)

> Esta raiz está **vazia por desenho**. Todo o protocolo vivo mora na pasta
> da versão quente ativa. Este arquivo é um shim de roteamento — ele não
> contém regra além da trava de entrada abaixo.

## TRAVA DE BOOT (vinculante para toda IA, antes de qualquer ação)

1. **Primeiro comando da janela**: `cat .hbn/active-version` (na raiz deste
   repositório). O valor lido do disco é a **versão quente**.
2. **Leia então `<versão-quente>/BOOT.md`** — e só ele — para entrar.
3. **Toda mensagem e todo log seus começam com o cabeçalho estruturado**:

   `HOT_VERSION: <valor lido do disco> | BOOT: <caminho_do_boot_lido> | CONFIRMACAO_DISCO: SIM`

   Sem esse cabeçalho (ou com valor de memória, não lido do disco), você
   está em violação de contenção — pare.
4. **Escrita**: só sob a pasta da versão quente. Qualquer gravação fora dela
   é interceptada ANTES do disco (hook `.cursor/hooks/hbn-boot-lock.sh`) e
   bloqueada no commit (guard G-HOT-WRITE, primeiro do pre-commit, sem
   bypass). Allowlist mínima de raiz (idêntica nas 3 camadas — este arquivo,
   o hook e o guard): `.gitignore`, `.hbn/relay/STATE.md`,
   `.hbn/hearbacks/**`. Os **shims de raiz** (`README.md`, `AGENTS.md`,
   `.hbn/active-version`, `.hbn/canonical-root`, `.github/workflows/**`,
   `.cursor/**`) são IMUTÁVEIS em dev normal: mudam só em exúvia autorizada
   ou em commit do operador com autorização `hot-write-root-shim` (STATE +
   readback/hearback confirmado cobrindo o path exato — G-HOT-WRITE regra 4b).
5. **Versões congeladas** (`versao_0_3_x/`, `versao_2_0_0/` e futuras
   glaciers): leitura histórica permitida; citá-las como regra vigente ou
   escrever nelas é violação.

## Nada além disto vive na raiz

| Item | Papel |
|---|---|
| `.hbn/active-version` | Ponteiro da versão quente (fonte única de verdade) |
| `<versão-quente>/` | TODO o protocolo vigente (BOOT, core, guards, scripts) |
| `versao_*/` congeladas | História imutável (glacier) |
| `.git/hooks/{pre-commit,commit-msg}` | Shims que executam o runner da versão quente |
| `.github/workflows/` | CI que roteia para a versão quente |
| `.cursor/hooks/` | BOOT-LOCK client-side (interceptação de escrita) |
| `.claude/settings.local.json` | Config local do Claude Code (por desenvolvedor; untracked e ignorada em `.gitignore`; concede leitura e NEGA escrita no consumidor Credenciamento) |

Se algo além disso aparecer na raiz, é lixo ou violação — reporte.
