# Escopo do MVP

## Objetivo

Definir o recorte minimo do FinTrack que entrega valor de produto, viabiliza demonstracao em portfolio e sustenta uma base tecnica evolutiva.

## Escopo incluido

### Funcionalidades principais

- autenticacao mock para entrada no app
- dashboard com saldo, total de receitas e total de despesas do periodo
- CRUD de transacoes
- categorias padrao para classificacao de lancamentos
- filtros por tipo, categoria e periodo
- persistencia local

## Status atual do escopo

### Ja implementado ate o fim da Sprint 2

- autenticacao mock para entrada no app
- shell principal com navegacao entre dashboard e transacoes
- dashboard com saldo, total de receitas e total de despesas
- secao de transacoes recentes com CTA para abrir a listagem completa
- CRUD de transacoes em memoria
- categorias padrao para classificacao de lancamentos
- cobertura de testes para fluxos principais, categorias e dashboard

### Ainda pendente dentro do MVP

- filtros por tipo, categoria e periodo
- persistencia local entre sessoes
- refinamentos de estados vazios, loading e tratamento de falhas em pontos restantes do app
- consolidacao final da cobertura de testes para os incrementos restantes

### Escopo tecnico

- arquitetura por camadas com separacao entre apresentacao, dominio e dados
- gerenciamento de estado com BLoC e Cubit conforme a complexidade do fluxo
- navegacao principal preparada para crescer sem acoplamento excessivo
- cobertura de testes sobre regras e fluxos criticos
- documentacao de arquitetura, backlog e decisoes tecnicas

## Requisitos funcionais

- o usuario pode entrar no app por um fluxo mock
- o usuario pode criar, editar e excluir transacoes
- o usuario pode classificar transacoes como receita ou despesa
- o usuario pode visualizar o saldo consolidado e o resumo mensal
- o usuario pode filtrar transacoes por periodo, tipo e categoria
- o app persiste os dados localmente entre sessoes

Observacao:
os quatro primeiros requisitos ja estao implementados no estado atual do projeto. Os requisitos de filtros e persistencia local permanecem como proximos passos do MVP.

## Requisitos nao funcionais

- codigo legivel e modular
- responsabilidade de negocio fora da UI
- camadas desacopladas por contratos bem definidos
- tratamento de estados de loading, sucesso, vazio e erro quando fizer sentido
- testes automatizados para comportamentos relevantes
- evolucao incremental com backlog priorizado

## Fora do escopo do MVP

- backend real
- sincronizacao em nuvem
- multiusuario
- cadastro completo de usuario
- graficos avancados
- exportacao de dados
- notificacoes push
- internacionalizacao

## Dependencias de decisao

O MVP depende das seguintes definicoes antes de implementacoes mais amplas:

- escolha do mecanismo de persistencia local
- convencao de tratamento de falhas e estados para os fluxos restantes
