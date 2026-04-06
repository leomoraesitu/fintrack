# Feature - Categorias e filtros

## Objetivo

Permitir ao usuario organizar e analisar melhor as transacoes por categoria, tipo e periodo.

## Fluxo principal

1. usuario cria ou edita uma transacao e escolhe uma categoria
2. usuario acessa a listagem e aplica filtros
3. sistema atualiza a lista conforme os criterios selecionados
4. usuario remove ou altera filtros conforme necessidade

## Criterios de aceite

- transacoes podem ser associadas a categorias padrao
- lista pode ser filtrada por tipo
- lista pode ser filtrada por categoria
- lista pode ser filtrada por periodo
- combinacoes simples de filtros devem funcionar de forma previsivel

## Regras de negocio

- categorias padrao devem estar disponiveis desde a criacao de transacoes
- filtros nao devem alterar os dados originais, apenas a visualizacao
- periodo invalido deve ser tratado antes da consulta final

## Dependencias tecnicas

- entidade de categoria ou representacao de categoria no dominio
- estrutura de filtro no dominio
- adaptacao da listagem e do repositorio
- estado dedicado para filtros, se a complexidade justificar
