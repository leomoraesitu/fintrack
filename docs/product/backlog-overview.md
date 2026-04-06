# Visao geral do backlog

## Objetivo

Registrar a estrutura do backlog do produto em alto nivel, preservando o detalhamento operacional no board do Trello.

## Fonte operacional

O detalhamento do board, com convencoes de cards, story points, labels e Definition of Done operacional, esta em [docs/trello/trello-implementation.md](../trello/trello-implementation.md).

## Macroetapas do backlog

### Sprint 0 - Fundacao

- substituir o app demo por uma shell inicial do FinTrack
- definir estrutura de pastas e tema base
- preparar navegacao inicial e smoke tests
- iniciar padroes de organizacao do projeto

### Sprint 1 - Fluxo principal

- implementar autenticacao mock
- preparar shell principal com navegacao
- modelar entidade de transacao
- criar primeira listagem e formulario inicial

### Sprint 2 - Proposta de valor do produto

- concluir CRUD de transacoes
- incluir categorias
- construir dashboard com resumo financeiro
- conectar os fluxos principais do usuario

### Sprint 3 - Robustez e fechamento do MVP

- adicionar filtros e ordenacao basica
- fortalecer tratamento de erros, loading e estados vazios
- ampliar testes automatizados
- consolidar documentacao tecnica e de apresentacao

## Regras de priorizacao

- priorizar o menor incremento que gere aprendizado ou valor perceptivel
- evitar iniciar refinamentos visuais antes do fluxo principal estar demonstravel
- quebrar tarefas maiores que 5 story points em cards menores
- manter a entrega orientada a fluxo do usuario, nao a listas de tecnologia

## Definition of Ready

Um item esta pronto para entrar em execucao quando:

- possui objetivo claro
- possui criterios de aceite definidos
- nao depende de uma decisao tecnica em aberto
- esta pequeno o suficiente para ser concluido sem reparticao durante a execucao

## Definition of Done

Um item esta concluido quando:

- atende aos criterios de aceite
- nao quebra o fluxo existente
- inclui teste ou validacao adequada ao contexto
- respeita a arquitetura e os padroes definidos no projeto
- tem documentacao atualizada quando necessario
