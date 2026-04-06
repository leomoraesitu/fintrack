# Implementacao do Board Trello

Este documento transforma o plano de reorganizacao do board do FinTrack em um lote inicial de execucao.

Objetivo: sair do board hibrido atual e passar para um fluxo unico, com cards pequenos e executaveis para o MVP.

## Estrutura final recomendada

Listas do board:

1. Backlog
2. Pronto para puxar
3. Em andamento
4. Revisao/Testes
5. Concluido

Regra principal: um card representa um unico status por vez. Sprint deixa de ser lista e passa a ser metadado do card.

## Convencoes do board

Labels recomendadas:

- Sprint 0
- Sprint 1
- Sprint 2
- Sprint 3
- area:foundation
- area:auth
- area:navigation
- area:transactions
- type:feature
- type:tech
- type:test

Campos minimos por card:

- Objetivo em uma frase
- Criterios de aceite
- Checklist tecnico
- Dependencias, quando houver

## Convencao de Story Points

Escala sugerida para este board:

- 1 SP: ajuste muito pequeno, decisao simples ou refinamento rapido
- 2 SP: implementacao pequena com baixo risco
- 3 SP: implementacao media, com mais de uma etapa ou validacao relevante
- 5 SP: implementacao mais densa, com UI, estado e regras juntas

Convencao para o titulo do card:

- usar o prefixo `Card [SP:X]: Titulo do card`

Exemplos:

- `Card [SP:1]: Definir estrategia de sessao mock`
- `Card [SP:3]: Implementar shell principal com navegacao inferior`

Regra pratica de estimativa:

- estimar complexidade relativa, nao duracao em horas
- considerar implementacao, validacao e risco tecnico basico
- se um card passar de 5 SP, quebrar em cards menores

## Regras de passagem entre listas

Backlog:
- Card ainda macro, nao refinado, ou aguardando prioridade.

Pronto para puxar:
- Objetivo claro.
- Sem dependencia critica aberta.
- Criterios de aceite definidos.

Em andamento:
- Responsavel definido.
- Card pequeno o bastante para ser concluido sem precisar ser repartido no meio da execucao.

Revisao/Testes:
- Implementacao concluida.
- Testes locais executados quando aplicavel.
- Sem mudancas pendentes no mesmo card.

Concluido:
- Atende a Definition of Done.
- Fluxo validado manualmente ou por teste, conforme o tipo do card.

## Definition of Done operacional

Use o card ja existente de Definition of Done como referencia e alinhe com esta versao operacional minima:

- Codigo compila e roda.
- Funcionalidade atende aos criterios de aceite do card.
- Nao quebra o fluxo existente.
- Teste criado ou atualizado quando fizer sentido.
- Nomeacao e estrutura coerentes com o restante do projeto.

## Observacoes sobre o estado atual do repositorio

O repositorio ainda esta no scaffold inicial do Flutter:

- existe apenas [lib/main.dart](/c:/Users/leomo/OneDrive/Documentos/DEV/PORTFOLIO/fintrack/lib/main.dart)
- o teste atual e o padrao de contador em [test/widget_test.dart](/c:/Users/leomo/OneDrive/Documentos/DEV/PORTFOLIO/fintrack/test/widget_test.dart)
- a stack no momento e a base descrita em [pubspec.yaml](/c:/Users/leomo/OneDrive/Documentos/DEV/PORTFOLIO/fintrack/pubspec.yaml)
- o produto e o roadmap inicial estao descritos em [README.md](/c:/Users/leomo/OneDrive/Documentos/DEV/PORTFOLIO/fintrack/README.md)

Isso significa que os primeiros cards precisam atacar fundacao, substituicao do app de exemplo e estrutura minima do dominio.

## Lote inicial para criar no Trello

Os cards abaixo substituem a execucao direta dos epicos 1 a 4.

### Epic 1: Fundacao do projeto

Card [SP:2]: Substituir app demo por shell inicial do FinTrack
- Labels: Sprint 0, area:foundation, type:feature
- Objetivo: remover a experiencia padrao do contador e iniciar o app com identidade basica do FinTrack.
- Criterios de aceite:
- MaterialApp exibe nome e tema do FinTrack.
- Tela inicial nao referencia mais o contador do template.
- App abre em uma home placeholder valida.
- Checklist tecnico:
- ajustar [lib/main.dart](/c:/Users/leomo/OneDrive/Documentos/DEV/PORTFOLIO/fintrack/lib/main.dart)
- remover textos e widgets do exemplo padrao
- criar placeholders minimos para a tela inicial

Card [SP:2]: Definir estrutura inicial de pastas do app
- Labels: Sprint 0, area:foundation, type:tech
- Objetivo: criar uma base de organizacao simples para crescimento do projeto.
- Criterios de aceite:
- Estrutura de pastas criada em lib para app, features, shared e domain, ou equivalente enxuto.
- Nomenclatura consistente e sem camadas artificiais.
- Checklist tecnico:
- criar estrutura inicial em lib
- mover widgets e arquivos para os lugares corretos
- manter o app compilando apos a reorganizacao

Card [SP:2]: Criar tema base e tokens visuais iniciais
- Labels: Sprint 0, area:foundation, type:feature
- Objetivo: padronizar cores, tipografia e espacamentos iniciais.
- Criterios de aceite:
- Tema centralizado em arquivo proprio.
- App usa o tema centralizado em vez de valores espalhados.
- Checklist tecnico:
- extrair ThemeData
- definir esquema de cores inicial
- aplicar no MaterialApp

Card [SP:1]: Trocar teste padrao por smoke test do FinTrack
- Labels: Sprint 0, area:foundation, type:test
- Objetivo: remover o teste do contador e validar o novo bootstrap do app.
- Criterios de aceite:
- teste nao depende de contador nem icone de soma
- teste valida que o app sobe com a identidade inicial esperada
- Checklist tecnico:
- atualizar [test/widget_test.dart](/c:/Users/leomo/OneDrive/Documentos/DEV/PORTFOLIO/fintrack/test/widget_test.dart)
- executar flutter test

### Epic 2: Autenticacao mock

Card [SP:1]: Definir estrategia de sessao mock
- Labels: Sprint 1, area:auth, type:tech
- Objetivo: decidir o menor fluxo de autenticacao para o MVP sem backend real.
- Criterios de aceite:
- fluxo documentado de forma simples: entrar, permanecer logado em memoria e sair
- regras de navegacao apos login definidas
- Checklist tecnico:
- descrever estados da sessao
- decidir se havera usuario fake fixo ou formulario simples

Card [SP:3]: Criar tela de login mock
- Labels: Sprint 1, area:auth, type:feature
- Objetivo: permitir entrada no app por uma tela inicial simples.
- Criterios de aceite:
- tela possui campos ou acao minima para entrar
- interface informa claramente que se trata de fluxo mock
- Checklist tecnico:
- criar tela de login
- adicionar validacoes minimas de UX
- conectar navegacao para a shell principal

Card [SP:2]: Implementar estado local de autenticacao
- Labels: Sprint 1, area:auth, type:feature
- Objetivo: controlar sessao mock dentro do app.
- Criterios de aceite:
- app distingue usuario autenticado de nao autenticado
- logout retorna para a tela de login
- Checklist tecnico:
- criar controlador simples de sessao
- expor estado para a arvore de widgets

Card [SP:2]: Cobrir fluxo basico de login/logout
- Labels: Sprint 1, area:auth, type:test
- Objetivo: proteger o fluxo principal com teste de widget.
- Criterios de aceite:
- teste valida entrada no app
- teste valida retorno para login ao sair
- Checklist tecnico:
- criar teste do fluxo mock
- manter testes existentes verdes

### Epic 3: Shell e navegacao principal

Card [SP:1]: Definir tabs e arquitetura de navegacao do MVP
- Labels: Sprint 1, area:navigation, type:tech
- Objetivo: fechar a navegacao minima antes de criar telas definitivas.
- Criterios de aceite:
- tabs ou destinos principais definidos
- navegacao escolhida cabe no escopo atual do app
- Checklist tecnico:
- decidir rotas principais
- decidir se navegacao sera por bottom navigation

Card [SP:3]: Implementar shell principal com navegacao inferior
- Labels: Sprint 1, area:navigation, type:feature
- Objetivo: criar o contorno principal da experiencia apos login.
- Criterios de aceite:
- shell possui areas principais do MVP
- troca de abas funciona sem quebrar estado basico
- Checklist tecnico:
- criar widget shell
- adicionar destinos placeholder para transacoes e dashboard

Card [SP:2]: Criar placeholders de telas principais
- Labels: Sprint 1, area:navigation, type:feature
- Objetivo: deixar navegacao pronta para receber features reais.
- Criterios de aceite:
- existe ao menos uma tela de lista de transacoes e uma tela de dashboard placeholder
- titulos e hierarquia visual estao coerentes
- Checklist tecnico:
- criar telas placeholder
- ligar as telas ao shell

### Epic 4: CRUD de transacoes

Card [SP:2]: Modelar entidade Transaction
- Labels: Sprint 1, area:transactions, type:tech
- Objetivo: definir a estrutura minima do dominio financeiro.
- Criterios de aceite:
- entidade contempla tipo, valor, data, descricao e categoria inicial ou placeholder
- nomeacao coerente com o dominio do app
- Checklist tecnico:
- criar modelo de dominio
- decidir representacao de receita e despesa

Card [SP:3]: Implementar repositorio em memoria para transacoes
- Labels: Sprint 1, area:transactions, type:feature
- Objetivo: viabilizar CRUD antes da persistencia local.
- Criterios de aceite:
- adicionar, listar, editar e remover funcionam em memoria
- camada pode ser substituida depois por persistencia local
- Checklist tecnico:
- criar interface simples para fonte de dados
- criar implementacao em memoria

Card [SP:3]: Criar tela de listagem de transacoes vazia e populada
- Labels: Sprint 1, area:transactions, type:feature
- Objetivo: mostrar o estado inicial da feature e a lista de itens quando houver dados.
- Criterios de aceite:
- tela exibe estado vazio amigavel sem transacoes
- tela lista transacoes quando houver dados
- Checklist tecnico:
- criar widget de lista
- criar empty state

Card [SP:5]: Criar formulario de nova transacao
- Labels: Sprint 1, area:transactions, type:feature
- Objetivo: permitir cadastro de receita e despesa.
- Criterios de aceite:
- usuario consegue informar tipo, valor, descricao e data
- validacoes impedem salvar dados invalidos
- Checklist tecnico:
- criar formulario
- validar campos obrigatorios
- integrar com repositorio em memoria

Card [SP:3]: Implementar edicao e exclusao de transacao
- Labels: Sprint 1, area:transactions, type:feature
- Objetivo: completar o CRUD do MVP.
- Criterios de aceite:
- usuario consegue editar item existente
- usuario consegue remover item com confirmacao simples
- Checklist tecnico:
- adicionar acao de editar
- adicionar acao de excluir
- refletir mudancas na listagem

Card [SP:3]: Cobrir CRUD basico com testes
- Labels: Sprint 1, area:transactions, type:test
- Objetivo: proteger o fluxo central do produto.
- Criterios de aceite:
- teste cobre cadastro
- teste cobre edicao ou exclusao
- Checklist tecnico:
- adicionar testes de widget ou unidade
- validar estados vazio e populado

## Ordem recomendada de execucao

1. Substituir app demo por shell inicial do FinTrack
2. Definir estrutura inicial de pastas do app
3. Criar tema base e tokens visuais iniciais
4. Trocar teste padrao por smoke test do FinTrack
5. Definir estrategia de sessao mock
6. Criar tela de login mock
7. Implementar estado local de autenticacao
8. Definir tabs e arquitetura de navegacao do MVP
9. Implementar shell principal com navegacao inferior
10. Criar placeholders de telas principais
11. Modelar entidade Transaction
12. Implementar repositorio em memoria para transacoes
13. Criar tela de listagem de transacoes vazia e populada
14. Criar formulario de nova transacao
15. Implementar edicao e exclusao de transacao
16. Cobrir fluxos principais com testes

## Proximo lote sugerido

Depois deste lote, o proximo passo natural e quebrar os epicos 5 a 7:

- categorias
- dashboard
- filtros e ordenacao

Esses tres epicos ja passam a depender da modelagem e do CRUD de transacoes definidos aqui.