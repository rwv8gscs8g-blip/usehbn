# hbn-exuvia — requisitos consolidados para a v2 do plano (antes do corte)

Reúne tudo que a emenda do plano deve incorporar antes da onda de execução da muda.
Fontes: parecer Gemini onda 0010 (`.hbn/results/20260614-021641-...`) + decisões do gate humano 2026-06-14.

## A. Correções do parecer Gemini (3 FORTE + 1 MARGINAL)
- **F-01 (anti-GC):** na fase de CONGELAMENTO, gerar uma **tag git imutável** apontando para o commit da casca (ex.: `hbn-exuvia/protocol-0.3.x`), senão o `git gc --prune` apaga o commit órfão — violaria P1/P6. Passo obrigatório.
- **F-02 (sem symlink):** ao mover o livro-razão para o novo local, **atualizar `guards/assert-registry-line.sh` direto** para o novo caminho. NADA de symlink na raiz — `git show :REGISTRY.md` num symlink devolve o caminho, não o conteúdo, e o guard bloquearia todos os commits.
- **F-03 (preservar untracked):** o commit de congelamento deve fazer **`git add -f`** dos untracked a preservar (handoffs históricos + pareceres), não só citá-los no manifesto.
- **M-01 (sinal de dependência):** após a muda, publicar o sinal **`⛓️ HBN PROTOCOL DEP CHANGE`** para as apps consumidoras (protocol_version vira required).

## B. Adições humanas aprovadas pelo parecer
- **Painel** `.hbn/relay/PAINEL.md` como denominador comum no nível de ARQUIVO (estado de guards, exceções F-01, tokens), referenciado por toda IA do protocolo. (Não nas UIs de chat — não as controlamos.)
- **Trilha de aprendizagem:** toda IA grava o log frio do turno em `logs/<timestamp>-<agente>-log-janela.md`, indexado no painel — oculto-mas-acessível para quem aprende.

## C. Itens novos do gate humano (2026-06-14)
1. **Ponte de controle bidirecional:** o ÚLTIMO documento da exúvia de uma versão deve ser CITADO pelo PRIMEIRO documento da versão que nasce (além do manifesto nova→velha). Liga as duas pontas.
2. **Retenção do frio (estudo):** logs/trilha disponíveis por **30 dias (configurável)**; a limpeza acontece numa **passagem de manutenção** do protocolo (não na hora).
3. **Política configurável de loop do arquiteto autônomo:** a cada rodada, **apagar OU mandar ao glacier** conforme config do usuário; o material retido vira "**guia de raciocínio para estudo do comportamento das IAs**" — insumo das futuras **Memory/Dream**. (Conecta ADR-010 autoevolve e ADR-013 arquiteto autônomo.)
4. **Nome oficial: `hbn-exuvia`** — ordem adjetival do inglês ("a exúvia do hbn"). Documentar como ação no sistema (spec/ADR + REGISTRY).
5. **Inventário de módulos:** documentar os MÓDULOS do usehbn como **subpastas** (árvores de funcionalidade independentes: `hbn-exuvia`, orquestração, fagocitose, radar, etc.) — base para a reconstrução da árvore/estrutura/modelos de construção na forma 1.0.

## D. Dependência de sequência
A **pesquisa de fronteira** (consulta multi-IA: melhores alternativas de orquestração + modelos de automelhoria) deve **informar a reconstrução** da forma nova ANTES de cravar a estrutura 1.0. Ordem: pesquisa → emenda do plano (v2, com A+B+C) → cross-audit → ratificação → execução do corte.
