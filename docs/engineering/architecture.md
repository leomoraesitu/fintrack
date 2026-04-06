# Arquitetura

## Objetivo

Definir a arquitetura planejada do FinTrack para guiar a implementacao do MVP com foco em separacao de responsabilidades, evolucao incremental e manutencao simples.

## Principios

- a interface nao deve concentrar regra de negocio
- a camada de estado nao deve acessar dados diretamente sem mediacao adequada
- entidades de dominio nao devem depender de detalhes de framework
- detalhes de persistencia devem ficar encapsulados na camada de dados
- a arquitetura deve ser suficiente para o escopo atual, sem camadas artificiais

## Camadas previstas

### Presentation

Responsavel por telas, widgets, navegacao, BLoCs, Cubits e estados visiveis para o usuario.

Responsabilidades:

- renderizar interface
- despachar eventos de interacao
- reagir a estados e falhas
- coordenar fluxo de navegacao

### Domain

Responsavel por regras de negocio, entidades, contratos de repositorio e casos de uso.

Responsabilidades:

- representar o dominio financeiro
- declarar interfaces para acesso a dados
- isolar regras de negocio do framework e da persistencia

### Data

Responsavel por modelos, fontes de dados e implementacoes de repositorio.

Responsabilidades:

- ler e escrever dados locais
- converter modelos de armazenamento para entidades de dominio
- encapsular detalhes do mecanismo de persistencia

## Fluxo de dependencia

A direcao da dependencia deve seguir esta ordem:

Presentation -> Domain -> Data

Regras:

- Presentation conhece Domain
- Data conhece Domain para implementar contratos
- Domain nao conhece Presentation nem Data
- uma feature nao deve importar implementacao interna de outra feature

## Estrategia por feature

Cada feature principal deve conter suas subpastas de apresentacao, dominio e dados quando houver complexidade suficiente.

Exemplos previstos:

- auth
- dashboard
- transactions
- categories

## Estrategia de composicao

- componentes reutilizaveis e tokens ficam fora das features especificas
- regras compartilhadas de dominio devem ficar em local claro e previsivel
- estados simples e locais podem usar Cubit
- fluxos com multiplos eventos, validacoes e efeitos assincronos devem usar Bloc

## Tratamento de falhas

Falhas previsiveis devem ser parte do fluxo de estado.

Exemplos:

- erro ao salvar transacao
- erro ao carregar lista
- dados vazios sem erro
- validacao de formulario invalida

## Evolucao esperada

A arquitetura deve nascer simples e ganhar detalhes conforme o MVP avanca. O objetivo nao e implementar complexidade antes da necessidade, e sim deixar pontos claros de extensao para persistencia, filtros, dashboard e autenticacao.