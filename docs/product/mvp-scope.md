# Escopo do MVP

## Objetivo

Definir o recorte minimo do FinTrack que entrega valor de produto, viabiliza demonstracao em portfolio e sustenta uma base tecnica evolutiva.

## Escopo incluido

### Funcionalidades principais

- autenticacao real por e-mail/senha e modo demo para entrada rapida no app
- dashboard com saldo, total de receitas e total de despesas do periodo
- CRUD de transacoes
- categorias padrao para classificacao de lancamentos
- filtros por tipo, categoria e periodo
- persistencia local no modo demo e persistencia remota para contas autenticadas

## Status atual do escopo

### Ja implementado no estado atual

- autenticacao real por e-mail/senha e modo demo para entrada rapida no app
- shell principal com navegacao entre dashboard e transacoes
- dashboard com saldo, total de receitas e total de despesas
- secao de transacoes recentes com CTA para abrir a listagem completa
- CRUD de transacoes com persistencia local no modo demo e Firestore em contas autenticadas
- categorias padrao para classificacao de lancamentos
- filtros por tipo, categoria e periodo
- deteccao basica de conflito remoto por `updatedAt`, com recarga da versao atual e orientacao de fechamento quando a transacao nao existe mais no backend
- cobertura de testes para fluxos principais, categorias, dashboard, autenticacao, repositório remoto e regras Firestore

### Ainda pendente dentro do MVP

- sincronizacao multi-dispositivo avancada com conciliacao entre versoes
- refinamentos de estados vazios, loading e tratamento de falhas em pontos restantes do app
- consolidacao final da cobertura de testes para os incrementos restantes

### Escopo tecnico

- arquitetura por camadas com separacao entre apresentacao, dominio e dados
- gerenciamento de estado com BLoC e Cubit conforme a complexidade do fluxo
- navegacao principal preparada para crescer sem acoplamento excessivo
- cobertura de testes sobre regras e fluxos criticos
- documentacao de arquitetura, backlog e decisoes tecnicas

## Requisitos funcionais

- o usuario pode entrar no app por conta real ou modo demo
- o usuario pode criar, editar e excluir transacoes
- o usuario pode classificar transacoes como receita ou despesa
- o usuario pode visualizar o saldo consolidado e o resumo mensal
- o usuario pode filtrar transacoes por periodo, tipo e categoria
- o app persiste dados localmente no modo demo e remotamente quando ha conta autenticada

Observacao:
todos os requisitos acima ja estao implementados no estado atual do projeto. O que permanece pendente no MVP e a evolucao da sincronizacao e da experiencia de falha para cenarios mais avancados.

## Requisitos nao funcionais

- codigo legivel e modular
- responsabilidade de negocio fora da UI
- camadas desacopladas por contratos bem definidos
- tratamento de estados de loading, sucesso, vazio e erro quando fizer sentido
- testes automatizados para comportamentos relevantes
- evolucao incremental com backlog priorizado

## Fora do escopo do MVP

- conciliacao avancada de conflitos multi-dispositivo
- cadastro completo de usuario
- graficos avancados
- exportacao de dados
- notificacoes push
- internacionalizacao

## Dependencias de decisao

O MVP depende das seguintes definicoes antes de implementacoes mais amplas:

- estrategia de conciliacao entre versoes local e remota
- convencao de tratamento de falhas e estados para os fluxos restantes
