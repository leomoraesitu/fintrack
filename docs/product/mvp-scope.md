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
- definicao da estrutura inicial de pastas
- convencao de navegacao principal
- convencao de tratamento de falhas e estados
