# HBN — Decisao de Publicacao v0.3.0

> Resposta canonica a pergunta 13 do diagnostico arquitetural 2026-04.
> Decisao tomada pelo mantenedor (Luis Mauricio Junqueira Zanin) e ancorada
> em iteracao 0002 do relay.

## A pergunta

> "Proximo release sera TestPyPI somente, ou ja PyPI estavel?"

## TL;DR

**Decisao para v0.3.0:** TestPyPI primeiro. PyPI estavel apenas apos smoke
test em 3 OSes e Hearback humano explicito.

**Justificativa:** TestPyPI permite validar metadata, instalacao em venv
limpa, comportamento de entry points (`hbn` e `usehbn`), e
detecao do nome do pacote sem reservar nome em PyPI estavel
prematuramente.

## TestPyPI vs PyPI direto — comparacao tecnica

| Aspecto | TestPyPI | PyPI direto |
|---|---|---|
| **URL de instalacao** | `pip install --index-url https://test.pypi.org/simple/ usehbn` | `pip install usehbn` |
| **Reserva de nome** | Independente do PyPI estavel | Reserva o nome canonico |
| **Visibilidade publica** | Baixa (audiencia precisa saber URL) | Alta (qualquer usuario encontra) |
| **Risco de instalacao acidental** | Baixo (nao aparece em `pip install` default) | Alto |
| **Yank/remocao** | Mais permissivo | Restrito (versao continua resolvavel) |
| **Confiabilidade** | Indice de testes; nao garante uptime | Producao |
| **Custo de erro** | Quase zero | Permanente (versao yanked continua resolvavel) |
| **Sandbox para metadata** | Sim | Nao |

## Impactos especificos para o HBN

### Para o mantenedor

- **TestPyPI primeiro** evita reservar o nome `usehbn` em PyPI estavel antes
  de validar que o pacote instala corretamente em macOS, Linux e Windows.
- Se metadata estiver errada (classifiers, description, dependencias), corrigir
  em TestPyPI e republicar e barato.
- Permite testar o cenario de upgrade (`pip install --upgrade`) com versoes
  sucessivas (0.3.0a1, 0.3.0a2, 0.3.0).

### Para usuarios atuais

- Nada muda em v0.3.0. `get-hbn` continua sendo o caminho oficial.
- Beta-testers que quiserem instalar via pip rodam:
  ```bash
  pip install --index-url https://test.pypi.org/simple/ \
              --extra-index-url https://pypi.org/simple/ \
              usehbn
  ```

### Para CI/CD futuro

- Workflow de release fica mais robusto: dois jobs separados (TestPyPI auto,
  PyPI manual com aprovacao humana).

## Politica de nome de pacote

Decisao humana vinculante (resposta Q14): **`hbn` e `usehbn` sao chamaveis
sempre, de forma igual**. `usehbn` e a forma semantica humana e tem
prioridade.

Implementacao concreta proposta:

| Aspecto | Valor |
|---|---|
| **Nome de distribuicao no PyPI** | `usehbn` (forma semantica humana, prioritaria) |
| **Entry points (CLI)** | `hbn` E `usehbn`, ambos funcionais |
| **`__version__`** | Em `src/usehbn/__init__.py`, atualizado para `0.3.0` na onda de release |
| **Trigger semantico** | `usehbn`, `use hbn`, `usehbn.com`, `usehbn.org` (mantidos) |

Em v0.3.0, NAO se reserva `hbn` no PyPI. A reserva fica para uma onda futura
quando o nome estiver garantido como livre.

## Plano de transicao TestPyPI → PyPI

| Etapa | Pre-requisito | Ato |
|---|---|---|
| 1 | RFC-0001 nao precisa estar `accepted` | Construir sdist + wheel local |
| 2 | Smoke test em macOS | Validar `pip install` em venv limpa; `hbn version` retorna `0.3.0` |
| 3 | Smoke test em Linux | Idem |
| 4 | Smoke test em Windows | Idem |
| 5 | Hearback humano confirmando metadata | Publicar em TestPyPI como `0.3.0a1` |
| 6 | Beta-test interno por 7 dias | Bug-fix se necessario; subir patches `0.3.0a2`, `0.3.0a3` etc |
| 7 | Hearback humano explicito | Publicar `0.3.0` em TestPyPI |
| 8 | Janela de observacao 14 dias | Coletar feedback |
| 9 | Hearback humano explicito | Publicar `0.3.0` em PyPI estavel |

Em qualquer etapa, falha de smoke test bloqueia o avanco. Sem Hearback
humano explicito, nenhum publish em PyPI estavel acontece.

## Gates Hearback necessarios

| Gate | Quando | Aprovador |
|---|---|---|
| **G6.1** | Antes de publicar `0.3.0a1` em TestPyPI | Humano |
| **G6.2** | Antes de publicar `0.3.0` em TestPyPI | Humano |
| **G6.3** | Antes de publicar `0.3.0` em PyPI estavel | Humano |

Cada gate exige Readback + Hearback `confirmed`. ERP correspondente
gravado.

## Decisao final

> v0.3.0 sera publicada em TestPyPI primeiro, sob nome de distribuicao
> `usehbn`, com entry points `hbn` e `usehbn` ambos funcionais. PyPI estavel
> e Onda separada, posterior, sob aprovacao humana explicita.

Esta decisao esta vinculada a iteracao 0002 do relay e e referenciada como
parte da Onda 5 do plano v0.3.0.
