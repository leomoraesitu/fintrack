# Visao geral do backlog

## Objetivo

Registrar a estrutura do backlog do produto em alto nivel, preservando o detalhamento operacional no board do Trello.

## Fonte operacional

O detalhamento do board, com convencoes de cards, story points, labels e Definition of Done operacional, esta em [docs/trello/trello-implementation.md](../trello/trello-implementation.md).

## Status atual do backlog

- Sprint 0 concluída com shell inicial, tema base, navegação principal e smoke tests
- Sprint 1 concluída com autenticação mock e fluxo principal de CRUD de transações
- Sprint 2 concluída com categorias padrão, dashboard com resumo financeiro, transações recentes e cobertura de testes ampliada
- Sprint 3 concluída com fundação técnica, arquitetura em camadas, primeiros testes e documentação inicial
- Sprint 4 concluída com cadastro/edição/exclusão de transações, integração dos agregados financeiros ao dashboard, refino de navegação, expansão de testes, handoff visual consolidado e estrutura multiplataforma validada
- Sprint 5 (em andamento): integração do backend Firebase, migração de autenticação e dados, sincronização multi-dispositivo, ajustes de segurança e documentação

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

Status: concluida


### Sprint 3 - Robustez e fechamento do MVP
- adicionar filtros e ordenação básica
- fortalecer tratamento de erros, loading e estados vazios
- ampliar testes automatizados
- consolidar documentação técnica e de apresentação

Status: concluída

### Sprint 4 - Evolução e consolidação do MVP
- implementar cadastro, edição e exclusão de transações com categorias padrão
- integrar agregados financeiros (saldo, receitas, despesas) ao dashboard
- refinar fluxo de navegação e estados de interface
- expandir cobertura de testes para novos fluxos
- consolidar handoff visual e atualizar documentação de design
- padronizar código, revisão contínua e refatoração incremental
- validar estrutura multiplataforma (Android, iOS, Web, Windows, Linux, macOS)

Status: concluída

### Sprint 5 - Integração do Backend e Sincronização
- integrar backend Firebase ao app (autenticação real, Firestore)
- migrar autenticação e CRUD de transações para o backend
- implementar sincronização multi-dispositivo
- migrar dados locais para o backend
- revisar e aplicar regras de segurança do Firestore
- atualizar documentação técnica e de setup
- validar fluxos de login, cadastro, edição, exclusão e leitura com backend
- corrigir bugs e inconsistências encontradas durante testes
- preparar release público com APK e documentação

Status: em andamento

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
