# ADR-001 - Adocao do BLoC

## Status

Aceito

## Contexto

O FinTrack foi concebido como projeto de portfolio em Flutter com foco em demonstrar estado, arquitetura, testes e evolucao incremental. O projeto precisa de uma abordagem previsivel para fluxos como autenticacao, listagem de transacoes, formulario e dashboard.

## Decisao

Adotar `Bloc` e `Cubit` como estrategia principal de gerenciamento de estado.

## Consequencias

### Positivas

- separacao mais clara entre interacao, transicao de estado e regra de negocio
- previsibilidade maior em fluxos relevantes
- melhor aderencia a testes de transicao e debug com `BlocObserver`
- alinhamento com o objetivo de portfolio definido para o projeto

### Custos

- mais estrutura inicial do que abordagens extremamente simples
- necessidade de disciplina para evitar BLoCs grandes demais

## Aplicacao pratica

- Cubit para estados simples e locais
- Bloc para fluxos com multiplos eventos, validacoes e efeitos assincronos
